{
    $Id$
    Copyright (c) 1998-2000 by Florian Klaempfl

    Generate i386 assembler for in set/case nodes

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

 ****************************************************************************
}
unit n386set;

{$i defines.inc}

interface

    uses
       node,nset;

    type
       ti386setelementnode = class(tsetelementnode)
          procedure pass_2;override;
       end;

       ti386innode = class(tinnode)
          procedure pass_2;override;
       end;
       ti386casenode = class(tcasenode)
          procedure pass_2;override;
       end;

implementation

    uses
      globtype,systems,cpuinfo,
      verbose,globals,
      symconst,symdef,aasm,types,
      cginfo,cgbase,pass_2,
      ncon,
      cpubase,
      cga,tgobj,n386util,regvars,rgobj;

     const
       bytes2Sxx:array[1..8] of Topsize=(S_B,S_W,S_NO,S_L,S_NO,S_NO,S_NO,S_Q);

{*****************************************************************************
                          TI386SETELEMENTNODE
*****************************************************************************}

    procedure ti386setelementnode.pass_2;
       var
         pushed: boolean;
       begin
       { load first value in 32bit register }
         secondpass(left);
         if left.location.loc in [LOC_REGISTER,LOC_CREGISTER] then
           emit_to_reg32(left.location.register);

       { also a second value ? }
         if assigned(right) then
           begin
             pushed:=maybe_push(right.registers32,left,false);
             secondpass(right);
             if codegenerror then
               exit;
             if pushed then
               restore(left,false);
             if right.location.loc in [LOC_REGISTER,LOC_CREGISTER] then
              emit_to_reg32(right.location.register);
           end;

         { we doesn't modify the left side, we check only the type }
         location_copy(location,left.location);
       end;


{*****************************************************************************
                              TI386INNODE
*****************************************************************************}

    procedure ti386innode.pass_2;
       type
         Tsetpart=record
           range : boolean;      {Part is a range.}
           start,stop : byte;    {Start/stop when range; Stop=element when an element.}
         end;
       var
         genjumps,
         use_small,
         pushed,
         ranges     : boolean;
         hr,hr2,
         pleftreg   : tregister;
         href       : treference;
         opsize     : topsize;
         setparts   : array[1..8] of Tsetpart;
         i,numparts : byte;
         adjustment : longint;
         {href,href2 : Treference;}
         l,l2       : tasmlabel;
{$ifdef CORRECT_SET_IN_FPC}
         AM         : tasmop;
{$endif CORRECT_SET_IN_FPC}

         function analizeset(Aset:pconstset;is_small:boolean):boolean;
           type
             byteset=set of byte;
           var
             compares,maxcompares:word;
             i:byte;
           begin
             analizeset:=false;
             ranges:=false;
             numparts:=0;
             compares:=0;
             { Lots of comparisions take a lot of time, so do not allow
               too much comparisions. 8 comparisions are, however, still
               smalller than emitting the set }
             if cs_littlesize in aktglobalswitches then
              maxcompares:=8
             else
              maxcompares:=5;
             { when smallset is possible allow only 3 compares the smallset
               code is for littlesize also smaller when more compares are used }
             if is_small then
              maxcompares:=3;
             for i:=0 to 255 do
              if i in byteset(Aset^) then
               begin
                 if (numparts=0) or (i<>setparts[numparts].stop+1) then
                  begin
                  {Set element is a separate element.}
                    inc(compares);
                    if compares>maxcompares then
                         exit;
                    inc(numparts);
                    setparts[numparts].range:=false;
                    setparts[numparts].stop:=i;
                  end
                 else
                  {Set element is part of a range.}
                  if not setparts[numparts].range then
                   begin
                     {Transform an element into a range.}
                     setparts[numparts].range:=true;
                     setparts[numparts].start:=setparts[numparts].stop;
                     setparts[numparts].stop:=i;
                     ranges := true;
                     { there's only one compare per range anymore. Only a }
                     { sub is added, but that's much faster than a        }
                     { cmp/jcc combo so neglect its effect                }
{                     inc(compares);
                     if compares>maxcompares then
                      exit; }
                   end
                  else
                   begin
                    {Extend a range.}
                    setparts[numparts].stop:=i;
                   end;
              end;
             analizeset:=true;
           end;

       begin
         { We check first if we can generate jumps, this can be done
           because the resulttype.def is already set in firstpass }

         { check if we can use smallset operation using btl which is limited
           to 32 bits, the left side may also not contain higher values !! }
         use_small:=(tsetdef(right.resulttype.def).settype=smallset) and
                    ((left.resulttype.def.deftype=orddef) and (torddef(left.resulttype.def).high<=32) or
                     (left.resulttype.def.deftype=enumdef) and (tenumdef(left.resulttype.def).max<=32));

         { Can we generate jumps? Possible for all types of sets }
         genjumps:=(right.nodetype=setconstn) and
                   analizeset(tsetconstnode(right).value_set,use_small);
         { calculate both operators }
         { the complex one first }
         firstcomplex(self);
         secondpass(left);
         { Only process the right if we are not generating jumps }
         if not genjumps then
          begin
            pushed:=maybe_push(right.registers32,left,false);
            secondpass(right);
            if pushed then
             restore(left,false);
          end;
         if codegenerror then
          exit;

         { ofcourse not commutative }
         if nf_swaped in flags then
          swapleftright;

         if genjumps then
          begin
            { It gives us advantage to check for the set elements
              separately instead of using the SET_IN_BYTE procedure.
              To do: Build in support for LOC_JUMP }

            opsize := def_opsize(left.resulttype.def);
            { If register is used, use only lower 8 bits }
            if left.location.loc in [LOC_REGISTER,LOC_CREGISTER] then
             begin
               pleftreg:=left.location.register;
               { for ranges we always need a 32bit register, because then we }
               { use the register as base in a reference (JM)                }
               if ranges then
                 begin
                   pleftreg := makereg32(pleftreg);
                   if opsize <> S_L then
                     emit_const_reg(A_AND,S_L,255,pleftreg);
                   opsize := S_L;
                 end
               else
                 { otherwise simply use the lower 8 bits (no "and" }
                 { necessary this way) (JM)                        }
                 begin
                   pleftreg := makereg8(pleftreg);
                   opsize := S_B;
                 end;
             end
            else
             begin
               { load the value in a register }
               pleftreg := rg.getexplicitregisterint(exprasmlist,R_EDI);
               opsize := S_L;
               emit_ref_reg(A_MOVZX,S_BL,left.location.reference,pleftreg);
             end;

            { Get a label to jump to the end }
            location_reset(location,LOC_FLAGS,OS_NO);

            { It's better to use the zero flag when there are
              no ranges }
            if ranges then
              location.resflags:=F_C
            else
              location.resflags:=F_E;

            getlabel(l);

            { how much have we already substracted from the x in the }
            { "x in [y..z]" expression                               }
            adjustment := 0;

            for i:=1 to numparts do
             if setparts[i].range then
              { use fact that a <= x <= b <=> cardinal(x-a) <= cardinal(b-a) }
              begin
                { is the range different from all legal values? }
                if (setparts[i].stop-setparts[i].start <> 255) then
                  begin
                    { yes, is the lower bound <> 0? }
                    if (setparts[i].start <> 0) then
                      { we're going to substract from the left register,   }
                      { so in case of a LOC_CREGISTER first move the value }
                      { to edi (not done before because now we can do the  }
                      { move and substract in one instruction with LEA)    }
                      if (pleftreg <> R_EDI) and
                         (left.location.loc = LOC_CREGISTER) then
                        begin
                          rg.ungetregister(exprasmlist,pleftreg);
                          rg.getexplicitregisterint(exprasmlist,R_EDI);
                          reference_reset_base(href,pleftreg,-setparts[i].start);
                          emit_ref_reg(A_LEA,S_L,href,R_EDI);
                          { only now change pleftreg since previous value is }
                          { still used in previous instruction               }
                          pleftreg := R_EDI;
                          opsize := S_L;
                        end
                      else
                        begin
                          { otherwise, the value is already in a register   }
                          { that can be modified                            }
                          if setparts[i].start-adjustment <> 1 then
                            emit_const_reg(A_SUB,opsize,
                              setparts[i].start-adjustment,pleftreg)
                          else emit_reg(A_DEC,opsize,pleftreg);
                        end;
                    { new total value substracted from x:           }
                    { adjustment + (setparts[i].start - adjustment) }
                    adjustment := setparts[i].start;

                    { check if result < b-a+1 (not "result <= b-a", since }
                    { we need a carry in case the element is in the range }
                    { (this will never overflow since we check at the     }
                    { beginning whether stop-start <> 255)                }
                    emit_const_reg(A_CMP,opsize,
                      setparts[i].stop-setparts[i].start+1,pleftreg);
                    { use C_C instead of C_B: the meaning is the same, but }
                    { then the optimizer can easier trace the jump to its  }
                    { final destination since the resultflag of this node  }
                    { is set to the carryflag                              }
                    emitjmp(C_C,l);
                  end
                else
                  { if setparts[i].start = 0 and setparts[i].stop = 255,  }
                  { it's always true since "in" is only allowed for bytes }
                  begin
                    emit_none(A_STC,S_NO);
                    emitjmp(C_NONE,l);
                  end;
              end
             else
              begin
                { Emit code to check if left is an element }
                emit_const_reg(A_CMP,opsize,setparts[i].stop-adjustment,
                  pleftreg);
                { Result should be in carry flag when ranges are used }
                if ranges then
                 emit_none(A_STC,S_NO);
                { If found, jump to end }
                emitjmp(C_E,l);
              end;
             if ranges and
                { if the last one was a range, the carry flag is already }
                { set appropriately                                      }
                not(setparts[numparts].range) then
              emit_none(A_CLC,S_NO);
             { To compensate for not doing a second pass }
             right.location.reference.symbol:=nil;
             { Now place the end label }
             emitlab(l);
             case left.location.loc of
               LOC_REGISTER,
               LOC_CREGISTER :
                 rg.ungetregister(exprasmlist,pleftreg);
               else
                 begin
                   reference_release(exprasmlist,left.location.reference);
                   rg.ungetregister(exprasmlist,R_EDI);
                 end;
             end;
          end
         else
          begin
            location_reset(location,LOC_FLAGS,OS_NO);

            { We will now generated code to check the set itself, no jmps,
              handle smallsets separate, because it allows faster checks }
            if use_small then
             begin
               if left.nodetype=ordconstn then
                begin
                  location.resflags:=F_NE;
                  case right.location.loc of
                    LOC_REGISTER,
                    LOC_CREGISTER:
                      begin
                         emit_const_reg(A_TEST,S_L,
                           1 shl (tordconstnode(left).value and 31),right.location.register);
                      end;
                    LOC_REFERENCE,
                    LOC_CREFERENCE :
                      begin
                        emit_const_ref(A_TEST,S_L,1 shl (tordconstnode(left).value and 31),
                           right.location.reference);
                      end;
                    else
                      internalerror(200203312);
                  end;
                  location_release(exprasmlist,right.location);
                end
               else
                begin
                  case left.location.loc of
                     LOC_REGISTER,
                     LOC_CREGISTER:
                       begin
                          hr:=left.location.register;
                          emit_to_reg32(hr);
                       end;
                  else
                    begin
                      { the set element isn't never samller than a byte  }
                      { and because it's a small set we need only 5 bits }
                      { but 8 bits are easier to load               }
                      rg.getexplicitregisterint(exprasmlist,R_EDI);
                      emit_ref_reg(A_MOVZX,S_BL,left.location.reference,R_EDI);
                      hr:=R_EDI;
                      location_release(exprasmlist,left.location);
                    end;
                  end;

                  case right.location.loc of
                 LOC_REGISTER,
                LOC_CREGISTER :
                          begin
                            emit_reg_reg(A_BT,S_L,hr,
                              right.location.register);
                            rg.ungetregisterint(exprasmlist,right.location.register);
                          end;
                   LOC_CONSTANT :
                       begin
                       { We have to load the value into a register because
                         btl does not accept values only refs or regs (PFV) }
                         hr2:=rg.getregisterint(exprasmlist);
                         emit_const_reg(A_MOV,S_L,
                           right.location.value,hr2);
                         emit_reg_reg(A_BT,S_L,hr,hr2);
                         rg.ungetregisterint(exprasmlist,hr2);
                       end;
                   LOC_CREFERENCE,
                   LOC_REFERENCE :
                       begin
                         location_release(exprasmlist,right.location);
                         emit_reg_ref(A_BT,S_L,hr,right.location.reference);
                       end;
                     else
                       internalerror(2002032210);
                  end;
                  { simply to indicate EDI is deallocated here too (JM) }
                  rg.ungetregisterint(exprasmlist,hr);
                  location.loc:=LOC_FLAGS;
                  location.resflags:=F_C;
                end;
             end
            else
             begin
               if right.location.loc=LOC_CONSTANT then
                begin
                  location.resflags:=F_C;
                  getlabel(l);
                  getlabel(l2);

                  { Is this treated in firstpass ?? }
                  if left.nodetype=ordconstn then
                    begin
                      hr:=rg.getregisterint(exprasmlist);
                      left.location.loc:=LOC_REGISTER;
                      left.location.register:=hr;
                      emit_const_reg(A_MOV,S_L,
                            tordconstnode(left).value,hr);
                    end;
                  case left.location.loc of
                     LOC_REGISTER,
                     LOC_CREGISTER:
                       begin
                          hr:=left.location.register;
                          emit_to_reg32(hr);
                          emit_const_reg(A_CMP,S_L,31,hr);
                          emitjmp(C_NA,l);
                        { reset carry flag }
                          emit_none(A_CLC,S_NO);
                          emitjmp(C_NONE,l2);
                          emitlab(l);
                        { We have to load the value into a register because
                          btl does not accept values only refs or regs (PFV) }
                          hr2:=rg.getregisterint(exprasmlist);
                          emit_const_reg(A_MOV,S_L,right.location.value,hr2);
                          emit_reg_reg(A_BT,S_L,hr,hr2);
                          rg.ungetregisterint(exprasmlist,hr2);
                       end;
                  else
                    begin
{$ifdef CORRECT_SET_IN_FPC}
                          if m_tp in aktmodeswitches then
                            begin
                              {***WARNING only correct if
                                reference is 32 bits (PM) *****}
                               emit_const_ref(A_CMP,S_L,31,reference_copy(left.location.reference));
                            end
                          else
{$endif CORRECT_SET_IN_FPC}
                            begin
                               emit_const_ref(A_CMP,S_B,31,left.location.reference);
                            end;
                       emitjmp(C_NA,l);
                     { reset carry flag }
                       emit_none(A_CLC,S_NO);
                       emitjmp(C_NONE,l2);
                       emitlab(l);
                       location_release(exprasmlist,left.location);
                       hr:=rg.getregisterint(exprasmlist);
                       emit_ref_reg(A_MOV,S_L,left.location.reference,hr);
                     { We have to load the value into a register because
                       btl does not accept values only refs or regs (PFV) }
                       hr2:=rg.getregisterint(exprasmlist);
                       emit_const_reg(A_MOV,S_L,
                         right.location.value,hr2);
                       emit_reg_reg(A_BT,S_L,hr,hr2);
                       rg.ungetregisterint(exprasmlist,hr2);
                    end;
                  end;
                  emitlab(l2);
                end { of right.location.loc=LOC_CONSTANT }
               { do search in a normal set which could have >32 elementsm
                 but also used if the left side contains higher values > 32 }
               else if left.nodetype=ordconstn then
                begin
                  location.resflags:=F_NE;
                  inc(right.location.reference.offset,tordconstnode(left).value shr 3);
                  emit_const_ref(A_TEST,S_B,1 shl (tordconstnode(left).value and 7),right.location.reference);
                  location_release(exprasmlist,right.location);
                end
               else
                begin
                  if not(left.location.loc in [LOC_REGISTER,LOC_CREGISTER]) then
                    begin
                      pleftreg := rg.getexplicitregisterint(exprasmlist,R_EDI);
                      opsize := def2def_opsize(left.resulttype.def,u32bittype.def);
                      if opsize = S_L then
                        emit_ref_reg(A_MOV,opsize,left.location.reference,pleftreg)
                      else
                        emit_ref_reg(A_MOVZX,opsize,left.location.reference,pleftreg);
                      location_freetemp(exprasmlist,left.location);
                      location_release(exprasmlist,left.location);
                    end
                  else
                    begin
                      pleftreg := left.location.register;
                      opsize := def2def_opsize(left.resulttype.def,u32bittype.def);
                      if opsize <> S_L then
                         { this will change left, even if it's a LOC_CREGISTER, but }
                         { that doesn't matter: if left is an 8 bit def, then the   }
                         { upper 24 bits are undefined, so we can zero them without }
                         { any problem (JM)                                         }
                         emit_to_reg32(pleftreg)
                    end;
                  emit_reg_ref(A_BT,S_L,pleftreg,right.location.reference);
                  rg.ungetregister(exprasmlist,pleftreg);
                  location_release(exprasmlist,right.location);
                  { tg.ungetiftemp(exprasmlist,right.location.reference) happens below }
                  location.resflags:=F_C;
                end;
             end;
          end;
          location_freetemp(exprasmlist,right.location);
       end;


{*****************************************************************************
                            TI386CASENODE
*****************************************************************************}

    procedure ti386casenode.pass_2;
      var
         with_sign : boolean;
         opsize : topsize;
         jmp_gt,jmp_le,jmp_lee : tasmcond;
         hp : tnode;
         { register with case expression }
         hregister,hregister2 : tregister;
         endlabel,elselabel : tasmlabel;

         { true, if we can omit the range check of the jump table }
         jumptable_no_range : boolean;
         { where to put the jump table }
         jumpsegment : TAAsmoutput;
         min_label : TConstExprInt;

      procedure gentreejmp(p : pcaserecord);

        var
           lesslabel,greaterlabel : tasmlabel;

       begin
         emitlab(p^._at);
         { calculate labels for left and right }
         if (p^.less=nil) then
           lesslabel:=elselabel
         else
           lesslabel:=p^.less^._at;
         if (p^.greater=nil) then
           greaterlabel:=elselabel
         else
           greaterlabel:=p^.greater^._at;
           { calculate labels for left and right }
         { no range label: }
         if p^._low=p^._high then
           begin
              emit_const_reg(A_CMP,opsize,p^._low,hregister);
              if greaterlabel=lesslabel then
                emitjmp(C_NE,lesslabel)
              else
                begin
                   emitjmp(jmp_le,lesslabel);
                   emitjmp(jmp_gt,greaterlabel);
                end;
              emitjmp(C_None,p^.statement);
           end
         else
           begin
              emit_const_reg(A_CMP,opsize,p^._low,hregister);
              emitjmp(jmp_le,lesslabel);
              emit_const_reg(A_CMP,opsize,p^._high,hregister);
              emitjmp(jmp_gt,greaterlabel);
              emitjmp(C_None,p^.statement);
           end;
          if assigned(p^.less) then
           gentreejmp(p^.less);
          if assigned(p^.greater) then
           gentreejmp(p^.greater);
      end;

      procedure genlinearcmplist(hp : pcaserecord);

        var
           first : boolean;
           last : TConstExprInt;

        procedure genitem(t : pcaserecord);

          var
             l1 : tasmlabel;

          begin
             if assigned(t^.less) then
               genitem(t^.less);
             if t^._low=t^._high then
               begin
                  if opsize=S_Q then
                    begin
                       getlabel(l1);
                       emit_const_reg(A_CMP,S_L,longint(hi(int64(t^._low))),hregister2);
                       emitjmp(C_NZ,l1);
                       emit_const_reg(A_CMP,S_L,longint(lo(int64(t^._low))),hregister);
                       emitjmp(C_Z,t^.statement);
                       emitlab(l1);
                    end
                  else
                    begin
                       emit_const_reg(A_CMP,opsize,longint(t^._low),hregister);
                       emitjmp(C_Z,t^.statement);
                       last:=t^._low;
                    end;
               end
             else
               begin
                  { if there is no unused label between the last and the }
                  { present label then the lower limit can be checked    }
                  { immediately. else check the range in between:        }
                  if first or (t^._low-last>1) then
                    begin
                       if opsize=S_Q then
                         begin
                            getlabel(l1);
                            emit_const_reg(A_CMP,S_L,longint(hi(int64(t^._low))),hregister2);
                            emitjmp(jmp_le,elselabel);
                            emitjmp(jmp_gt,l1);
                            emit_const_reg(A_CMP,S_L,longint(lo(int64(t^._low))),hregister);
                            { the comparisation of the low dword must be always unsigned! }
                            emitjmp(C_B,elselabel);
                            emitlab(l1);
                         end
                       else
                         begin
                            emit_const_reg(A_CMP,opsize,longint(t^._low),hregister);
                            emitjmp(jmp_le,elselabel);
                         end;
                    end;

                  if opsize=S_Q then
                    begin
                       getlabel(l1);
                       emit_const_reg(A_CMP,S_L,longint(hi(int64(t^._high))),hregister2);
                       emitjmp(jmp_le,t^.statement);
                       emitjmp(jmp_gt,l1);
                       emit_const_reg(A_CMP,S_L,longint(lo(int64(t^._high))),hregister);
                       { the comparisation of the low dword must be always unsigned! }
                       emitjmp(C_BE,t^.statement);
                       emitlab(l1);
                    end
                  else
                    begin
                       emit_const_reg(A_CMP,opsize,longint(t^._high),hregister);
                       emitjmp(jmp_lee,t^.statement);
                    end;

                  last:=t^._high;
               end;
             first:=false;
             if assigned(t^.greater) then
               genitem(t^.greater);
          end;

        begin
           last:=0;
           first:=true;
           genitem(hp);
           emitjmp(C_None,elselabel);
        end;

      procedure genlinearlist(hp : pcaserecord);

        var
           first : boolean;
           last : TConstExprInt;
           {helplabel : longint;}

        procedure genitem(t : pcaserecord);

            procedure gensub(value:longint);
            begin
              if value=1 then
                emit_reg(A_DEC,opsize,hregister)
              else
                emit_const_reg(A_SUB,opsize,value,hregister);
            end;

          begin
             if assigned(t^.less) then
               genitem(t^.less);
             { need we to test the first value }
             if first and (t^._low>get_min_value(left.resulttype.def)) then
               begin
                  emit_const_reg(A_CMP,opsize,longint(t^._low),hregister);
                  emitjmp(jmp_le,elselabel);
               end;
             if t^._low=t^._high then
               begin
                  if t^._low-last=0 then
                    emit_reg_reg(A_OR,opsize,hregister,hregister)
                  else
                    gensub(longint(t^._low-last));
                  last:=t^._low;
                  emitjmp(C_Z,t^.statement);
               end
             else
               begin
                  { it begins with the smallest label, if the value }
                  { is even smaller then jump immediately to the    }
                  { ELSE-label                                }
                  if first then
                    begin
                       { have we to ajust the first value ? }
                       if (t^._low>get_min_value(left.resulttype.def)) then
                         gensub(t^._low);
                    end
                  else
                    begin
                      { if there is no unused label between the last and the }
                      { present label then the lower limit can be checked    }
                      { immediately. else check the range in between:       }

                      { note: you can't use gensub() here because dec doesn't }
                      { change the carry flag (needed for jmp_lxx) (JM)       }
                      emit_const_reg(A_SUB,opsize,longint(t^._low-last),hregister);
                      emitjmp(jmp_le,elselabel);
                    end;
                  emit_const_reg(A_SUB,opsize,longint(t^._high-t^._low),hregister);
                  emitjmp(jmp_lee,t^.statement);
                  last:=t^._high;
               end;
             first:=false;
             if assigned(t^.greater) then
               genitem(t^.greater);
          end;

        begin
           { do we need to generate cmps? }
           if (with_sign and (min_label<0)) then
             genlinearcmplist(hp)
           else
             begin
                last:=0;
                first:=true;
                genitem(hp);
                emitjmp(C_None,elselabel);
             end;
        end;

      procedure genjumptable(hp : pcaserecord;min_,max_ : longint);

        var
           table : tasmlabel;
           last : TConstExprInt;
           href : treference;

        procedure genitem(t : pcaserecord);

          var
             i : longint;

          begin
             if assigned(t^.less) then
               genitem(t^.less);
             { fill possible hole }
             for i:=last+1 to t^._low-1 do
               jumpSegment.concat(Tai_const_symbol.Create(elselabel));
             for i:=t^._low to t^._high do
               jumpSegment.concat(Tai_const_symbol.Create(t^.statement));
              last:=t^._high;
             if assigned(t^.greater) then
               genitem(t^.greater);
            end;

          begin
           if not(jumptable_no_range) then
             begin
                emit_const_reg(A_CMP,opsize,longint(min_),hregister);
                { case expr less than min_ => goto elselabel }
                emitjmp(jmp_le,elselabel);
                emit_const_reg(A_CMP,opsize,longint(max_),hregister);
                emitjmp(jmp_gt,elselabel);
             end;
           getlabel(table);
           { extend with sign }
           if opsize=S_W then
             begin
                if with_sign then
                  emit_reg_reg(A_MOVSX,S_WL,hregister,
                    reg16toreg32(hregister))
                else
                  emit_reg_reg(A_MOVZX,S_WL,hregister,
                    reg16toreg32(hregister));
                hregister:=reg16toreg32(hregister);
             end
           else if opsize=S_B then
             begin
                if with_sign then
                  emit_reg_reg(A_MOVSX,S_BL,hregister,
                    reg8toreg32(hregister))
                else
                  emit_reg_reg(A_MOVZX,S_BL,hregister,
                    reg8toreg32(hregister));
                hregister:=reg8toreg32(hregister);
             end;
           reference_reset_symbol(href,table,0);
           href.offset:=(-longint(min_))*4;
           href.index:=hregister;
           href.scalefactor:=4;
           emit_ref(A_JMP,S_NO,href);
           { !!!!! generate tables
             if not(cs_littlesize in aktlocalswitches) then
             jumpSegment.concat(Taicpu.Op_const(A_ALIGN,S_NO,4));
           }
           jumpSegment.concat(Tai_label.Create(table));
             last:=min_;
           genitem(hp);
             { !!!!!!!
           if not(cs_littlesize in aktlocalswitches) then
             emit_const(A_ALIGN,S_NO,4);
           }
        end;

      var
         lv,hv,
         max_label: tconstexprint;
         labels : longint;
         max_linear_list : longint;
         otl, ofl: tasmlabel;
{$ifdef Delphi}
         dist : cardinal;
{$else Delphi}
         dist : dword;
{$endif Delphi}
         href : treference;

      begin
         getlabel(endlabel);
         getlabel(elselabel);
         if (cs_create_smart in aktmoduleswitches) then
           jumpsegment:=procinfo^.aktlocaldata
         else
           jumpsegment:=datasegment;
         with_sign:=is_signed(left.resulttype.def);
         if with_sign then
           begin
              jmp_gt:=C_G;
              jmp_le:=C_L;
              jmp_lee:=C_LE;
           end
         else
            begin
              jmp_gt:=C_A;
              jmp_le:=C_B;
              jmp_lee:=C_BE;
           end;
         rg.cleartempgen;
         { save current truelabel and falselabel (they are restored in }
         { locjump2reg) (JM)                                           }
         if left.location.loc=LOC_JUMP then
           begin
            otl:=truelabel;
            getlabel(truelabel);
            ofl:=falselabel;
            getlabel(falselabel);
           end;
         secondpass(left);
         { determines the size of the operand }
         opsize:=bytes2Sxx[left.resulttype.def.size];
         { copy the case expression to a register }
         case left.location.loc of
            LOC_REGISTER:
              begin
                 if opsize=S_Q then
                   begin
                      hregister:=left.location.registerlow;
                      hregister2:=left.location.registerhigh;
                   end
                 else
                   hregister:=left.location.register;
              end;
            LOC_FLAGS :
              begin
                locflags2reg(left.location,opsize);
                hregister := left.location.register;
              end;
            LOC_JUMP:
              begin
                locjump2reg(left.location,opsize,otl,ofl);
                hregister := left.location.register;
              end;
            LOC_CREGISTER:
              begin
                 hregister:=rg.getregisterint(exprasmlist);
                 case opsize of
                    S_B:
                      hregister:=reg32toreg8(hregister);
                    S_W:
                      hregister:=reg32toreg16(hregister);
                    S_Q:
                      hregister2:=R_EDI;
                 end;
                 if opsize=S_Q then
                   begin
                      emit_reg_reg(A_MOV,S_L,left.location.registerlow,hregister);
                      href:=left.location.reference;
                      inc(href.offset,4);
                      emit_reg_reg(A_MOV,S_L,left.location.registerhigh,hregister2);
                   end
                 else
                   emit_reg_reg(A_MOV,opsize,
                     left.location.register,hregister);
              end;
            LOC_CREFERENCE,LOC_REFERENCE:
              begin
                 location_release(exprasmlist,left.location);
                 hregister:=rg.getregisterint(exprasmlist);
                 case opsize of
                    S_B:
                      hregister:=reg32toreg8(hregister);
                    S_W:
                      hregister:=reg32toreg16(hregister);
                    S_Q:
                      hregister2:=R_EDI;
                 end;
                 if opsize=S_Q then
                   begin
                      emit_ref_reg(A_MOV,S_L,left.location.reference,hregister);
                      href:=left.location.reference;
                      inc(href.offset,4);
                      emit_ref_reg(A_MOV,S_L,href,hregister2);
                   end
                 else
                   emit_ref_reg(A_MOV,opsize,left.location.reference,hregister);
              end;
            else internalerror(2002);
         end;
         { we need the min_label always to choose between }
         { cmps and subs/decs                             }
         min_label:=case_get_min(nodes);

         load_all_regvars(exprasmlist);
         { now generate the jumps }
         if opsize=S_Q then
           genlinearcmplist(nodes)
         else
           begin
              if cs_optimize in aktglobalswitches then
                begin
                   { procedures are empirically passed on }
                   { consumption can also be calculated   }
                   { but does it pay on the different     }
                   { processors?                       }
                   { moreover can the size only be appro- }
                   { ximated as it is not known if rel8,  }
                   { rel16 or rel32 jumps are used   }
                   max_label:=case_get_max(nodes);
                   labels:=case_count_labels(nodes);
                   { can we omit the range check of the jump table ? }
                   getrange(left.resulttype.def,lv,hv);
                   jumptable_no_range:=(lv=min_label) and (hv=max_label);
                   { hack a little bit, because the range can be greater }
                   { than the positive range of a longint            }

                   if (min_label<0) and (max_label>0) then
                     begin
{$ifdef Delphi}
                        if min_label=longint($80000000) then
                          dist:=Cardinal(max_label)+Cardinal($80000000)
                        else
                          dist:=Cardinal(max_label)+Cardinal(-min_label)
{$else Delphi}
                        if min_label=$80000000 then
                          dist:=dword(max_label)+dword($80000000)
                        else
                          dist:=dword(max_label)+dword(-min_label)
{$endif Delphi}
                     end
                   else
                     dist:=max_label-min_label;

                   { optimize for size ? }
                   if cs_littlesize in aktglobalswitches  then
                     begin
                        if (labels<=2) or
                           ((max_label-min_label)<0) or
                           ((max_label-min_label)>3*labels) then
                       { a linear list is always smaller than a jump tree }
                          genlinearlist(nodes)
                        else
                       { if the labels less or more a continuum then }
                          genjumptable(nodes,min_label,max_label);
                     end
                   else
                     begin
                        if jumptable_no_range then
                          max_linear_list:=4
                        else
                          max_linear_list:=2;
                        { a jump table crashes the pipeline! }
                        if aktoptprocessor=Class386 then
                          inc(max_linear_list,3);
                            if aktoptprocessor=ClassP5 then
                          inc(max_linear_list,6);
                        if aktoptprocessor>=ClassP6 then
                          inc(max_linear_list,9);

                        if (labels<=max_linear_list) then
                          genlinearlist(nodes)
                        else
                          begin
                             if (dist>4*cardinal(labels)) then
                               begin
                                  if labels>16 then
                                    gentreejmp(nodes)
                                  else
                                    genlinearlist(nodes);
                               end
                             else
                               genjumptable(nodes,min_label,max_label);
                          end;
                     end;
                end
              else
                { it's always not bad }
                genlinearlist(nodes);
           end;

         rg.ungetregister(exprasmlist,hregister);

         { now generate the instructions }
         hp:=right;
         while assigned(hp) do
           begin
              rg.cleartempgen;
              secondpass(tbinarynode(hp).right);
              { don't come back to case line }
              aktfilepos:=exprasmList.getlasttaifilepos^;
              load_all_regvars(exprasmlist);
              emitjmp(C_None,endlabel);
              hp:=tbinarynode(hp).left;
           end;
         emitlab(elselabel);
         { ...and the else block }
         if assigned(elseblock) then
           begin
              rg.cleartempgen;
              secondpass(elseblock);
              load_all_regvars(exprasmlist);
           end;
         emitlab(endlabel);
      end;


begin
   csetelementnode:=ti386setelementnode;
   cinnode:=ti386innode;
   ccasenode:=ti386casenode;
end.
{
  $Log$
  Revision 1.21  2002-04-02 17:11:36  peter
    * tlocation,treference update
    * LOC_CONSTANT added for better constant handling
    * secondadd splitted in multiple routines
    * location_force_reg added for loading a location to a register
      of a specified size
    * secondassignment parses now first the right and then the left node
      (this is compatible with Kylix). This saves a lot of push/pop especially
      with string operations
    * adapted some routines to use the new cg methods

  Revision 1.20  2002/03/31 20:26:39  jonas
    + a_loadfpu_* and a_loadmm_* methods in tcg
    * register allocation is now handled by a class and is mostly processor
      independent (+rgobj.pas and i386/rgcpu.pas)
    * temp allocation is now handled by a class (+tgobj.pas, -i386\tgcpu.pas)
    * some small improvements and fixes to the optimizer
    * some register allocation fixes
    * some fpuvaroffset fixes in the unary minus node
    * push/popusedregisters is now called rg.save/restoreusedregisters and
      (for i386) uses temps instead of push/pop's when using -Op3 (that code is
      also better optimizable)
    * fixed and optimized register saving/restoring for new/dispose nodes
    * LOC_FPU locations now also require their "register" field to be set to
      R_ST, not R_ST0 (the latter is used for LOC_CFPUREGISTER locations only)
    - list field removed of the tnode class because it's not used currently
      and can cause hard-to-find bugs

  Revision 1.19  2001/12/31 09:53:15  jonas
    * changed remaining "getregister32" calls to "getregisterint"

  Revision 1.18  2001/12/03 21:48:43  peter
    * freemem change to value parameter
    * torddef low/high range changed to int64

  Revision 1.17  2001/09/04 11:38:55  jonas
    + searchsystype() and searchsystype() functions in symtable
    * changed ninl and nadd to use these functions
    * i386 set comparison functions now return their results in al instead
      of in the flags so that they can be sued as compilerprocs
    - removed all processor specific code from n386add.pas that has to do
      with set handling, it's now all done in nadd.pas
    * fixed fpc_set_contains_sets in genset.inc
    * fpc_set_in_byte is now coded inline in n386set.pas and doesn't use a
      helper anymore
    * some small fixes in compproc.inc/set.inc regarding the declaration of
      internal helper types (fpc_small_set and fpc_normal_set)

  Revision 1.16  2001/08/26 13:37:00  florian
    * some cg reorganisation
    * some PPC updates

  Revision 1.15  2001/05/06 17:12:14  jonas
    * fixed an IE10 and another bug with [var1..var2] construct

  Revision 1.14  2001/04/13 01:22:19  peter
    * symtable change to classes
    * range check generation and errors fixed, make cycle DEBUG=1 works
    * memory leaks fixed

  Revision 1.13  2001/04/06 14:09:34  jonas
    * fixed bug in ti386innode.pass_2 code and made it simpler/faster

  Revision 1.12  2001/04/02 21:20:38  peter
    * resulttype rewrite

  Revision 1.11  2001/02/11 12:14:56  jonas
    * simplified and optimized code generated for in-statements

  Revision 1.10  2000/12/25 00:07:33  peter
    + new tlinkedlist class (merge of old tstringqueue,tcontainer and
      tlinkedlist objects)

  Revision 1.9  2000/12/18 17:45:32  jonas
    * int64 case fixes
    * explicit longint type casts for constants used in assembler code
      generation s,ice they can be cardinals too (or even int64's in case of
      range check errors)

  Revision 1.8  2000/12/16 15:58:18  jonas
    * removed warnings about possible range check errors

  Revision 1.7  2000/12/05 11:44:34  jonas
    + new integer regvar handling, should be much more efficient

  Revision 1.6  2000/11/29 00:30:49  florian
    * unused units removed from uses clause
    * some changes for widestrings

  Revision 1.5  2000/11/17 14:09:00  jonas
    * fixed webbug 1222 ("merged")

  Revision 1.4  2000/11/13 14:44:36  jonas
    * fixes so no more range errors with improved range checking code

  Revision 1.3  2000/10/31 22:02:57  peter
    * symtable splitted, no real code changes

  Revision 1.2  2000/10/26 15:53:27  jonas
    * fixed web bug1192 (changed an ungetregister32 to ungetregister)
      ("merged" from fixes)

  Revision 1.1  2000/10/15 09:33:32  peter
    * moved n386*.pas to i386/ cpu_target dir

  Revision 1.4  2000/10/14 10:14:49  peter
    * moehrendorf oct 2000 rewrite

  Revision 1.3  2000/09/30 16:08:45  peter
    * more cg11 updates

  Revision 1.2  2000/09/24 20:17:44  florian
    * more conversion work done

  Revision 1.1  2000/09/24 19:38:39  florian
    * initial implementation

}
