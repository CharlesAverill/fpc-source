{
    $Id$
    Copyright (c) 1993-98 by Florian Klaempfl

    Generate i386 assembler for in add node

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
unit cg386add;
interface

{$define usecreateset}

    uses
      tree;

    procedure secondadd(var p : ptree);

implementation

    uses
      globtype,systems,
      cobjects,verbose,globals,
      symconst,symtable,aasm,types,
      hcodegen,temp_gen,pass_2,
      cpubase,cpuasm,
      cgai386,tgeni386;

{*****************************************************************************
                                Helpers
*****************************************************************************}

    procedure locflags2reg(var l:tlocation;opsize:topsize);
      var
        hregister : tregister;
      begin
        if (l.loc=LOC_FLAGS) then
         begin
           case opsize of
            S_L : hregister:=getregister32;
            S_W : hregister:=reg32toreg16(getregister32);
            S_B : hregister:=reg32toreg8(getregister32);
           end;
           emit_flag2reg(l.resflags,hregister);
           l.loc:=LOC_REGISTER;
           l.register:=hregister;
         end;
      end;

    function getresflags(p : ptree;unsigned : boolean) : tresflags;

      begin
         if not(unsigned) then
           begin
              if p^.swaped then
                case p^.treetype of
                   equaln : getresflags:=F_E;
                   unequaln : getresflags:=F_NE;
                   ltn : getresflags:=F_G;
                   lten : getresflags:=F_GE;
                   gtn : getresflags:=F_L;
                   gten : getresflags:=F_LE;
                end
              else
                case p^.treetype of
                   equaln : getresflags:=F_E;
                   unequaln : getresflags:=F_NE;
                   ltn : getresflags:=F_L;
                   lten : getresflags:=F_LE;
                   gtn : getresflags:=F_G;
                   gten : getresflags:=F_GE;
                end;
           end
         else
           begin
              if p^.swaped then
                case p^.treetype of
                   equaln : getresflags:=F_E;
                   unequaln : getresflags:=F_NE;
                   ltn : getresflags:=F_A;
                   lten : getresflags:=F_AE;
                   gtn : getresflags:=F_B;
                   gten : getresflags:=F_BE;
                end
              else
                case p^.treetype of
                   equaln : getresflags:=F_E;
                   unequaln : getresflags:=F_NE;
                   ltn : getresflags:=F_B;
                   lten : getresflags:=F_BE;
                   gtn : getresflags:=F_A;
                   gten : getresflags:=F_AE;
                end;
           end;
      end;


    procedure SetResultLocation(cmpop,unsigned:boolean;var p :ptree);

      begin
         { remove temporary location if not a set or string }
         { that's a bad hack (FK) who did this ?            }
         if (p^.left^.resulttype^.deftype<>stringdef) and
            ((p^.left^.resulttype^.deftype<>setdef) or (psetdef(p^.left^.resulttype)^.settype=smallset)) and
            (p^.left^.location.loc in [LOC_MEM,LOC_REFERENCE]) then
           ungetiftemp(p^.left^.location.reference);
         if (p^.right^.resulttype^.deftype<>stringdef) and
            ((p^.right^.resulttype^.deftype<>setdef) or (psetdef(p^.right^.resulttype)^.settype=smallset)) and
            (p^.right^.location.loc in [LOC_MEM,LOC_REFERENCE]) then
           ungetiftemp(p^.right^.location.reference);
         { in case of comparison operation the put result in the flags }
         if cmpop then
           begin
              clear_location(p^.location);
              p^.location.loc:=LOC_FLAGS;
              p^.location.resflags:=getresflags(p,unsigned);
           end;
      end;


{*****************************************************************************
                                Addstring
*****************************************************************************}

    procedure addstring(var p : ptree);
      var
        pushedregs : tpushed;
        href       : treference;
        pushed,
        cmpop      : boolean;
      begin
        { string operations are not commutative }
        if p^.swaped then
          swaptree(p);
        case pstringdef(p^.left^.resulttype)^.string_typ of
           st_ansistring:
             begin
                case p^.treetype of
                   addn:
                     begin
                        cmpop:=false;
                        secondpass(p^.left);
                        { to avoid problem with maybe_push and restore }
                        set_location(p^.location,p^.left^.location);
                        pushed:=maybe_push(p^.right^.registers32,p,false);
                        secondpass(p^.right);
                        if pushed then restore(p,false);
                        { get the temp location, must be done before regs are
                          released/pushed because after the release the regs are
                          still used for the push (PFV) }
                        clear_location(p^.location);
                        p^.location.loc:=LOC_MEM;
                        if gettempansistringreference(p^.location.reference) then
                          decrstringref(cansistringdef,p^.location.reference);
                        { release used registers }
                        del_location(p^.right^.location);
                        del_location(p^.left^.location);
                        { push the still used registers }
                        pushusedregisters(pushedregs,$ff);
                        { push data }
                        emitpushreferenceaddr(p^.location.reference);
                        emit_push_loc(p^.right^.location);
                        emit_push_loc(p^.left^.location);
                        emitcall('FPC_ANSISTR_CONCAT');
                        popusedregisters(pushedregs);
                        maybe_loadesi;
                        ungetiftempansi(p^.left^.location.reference);
                        ungetiftempansi(p^.right^.location.reference);
                     end;
                   ltn,lten,gtn,gten,
                   equaln,unequaln:
                     begin
                        cmpop:=true;
                        secondpass(p^.left);
                        pushed:=maybe_push(p^.right^.registers32,p,false);
                        secondpass(p^.right);
                        if pushed then restore(p,false);
                        { release used registers }
                        del_location(p^.right^.location);
                        del_location(p^.left^.location);
                        { push the still used registers }
                        pushusedregisters(pushedregs,$ff);
                        { push data }
                        case p^.right^.location.loc of
                          LOC_REFERENCE,LOC_MEM:
                            emit_push_mem(p^.right^.location.reference);
                          LOC_REGISTER,LOC_CREGISTER:
                            emit_reg(A_PUSH,S_L,p^.right^.location.register);
                        end;
                        case p^.left^.location.loc of
                          LOC_REFERENCE,LOC_MEM:
                            emit_push_mem(p^.left^.location.reference);
                          LOC_REGISTER,LOC_CREGISTER:
                            emit_reg(A_PUSH,S_L,p^.left^.location.register);
                        end;
                        emitcall('FPC_ANSISTR_COMPARE');
                        emit_reg_reg(A_OR,S_L,R_EAX,R_EAX);
                        popusedregisters(pushedregs);
                        maybe_loadesi;
                        ungetiftempansi(p^.left^.location.reference);
                        ungetiftempansi(p^.right^.location.reference);
                     end;
                end;
               { the result of ansicompare is signed }
               SetResultLocation(cmpop,false,p);
             end;
           st_shortstring:
             begin
                case p^.treetype of
                   addn:
                     begin
                        cmpop:=false;
                        secondpass(p^.left);
                        { if str_concat is set in expr
                          s:=s+ ... no need to create a temp string (PM) }

                        if (p^.left^.treetype<>addn) and not (p^.use_strconcat) then
                          begin

                             { can only reference be }
                             { string in register would be funny    }
                             { therefore produce a temporary string }

                             { release the registers }
                             del_reference(p^.left^.location.reference);
                             gettempofsizereference(256,href);
                             copyshortstring(href,p^.left^.location.reference,255,false);
                             ungetiftemp(p^.left^.location.reference);

                             { does not hurt: }
                             clear_location(p^.left^.location);
                             p^.left^.location.loc:=LOC_MEM;
                             p^.left^.location.reference:=href;
                          end;

                        secondpass(p^.right);

                        { on the right we do not need the register anymore too }
{$IfNDef regallocfix}
                        del_reference(p^.right^.location.reference);
                        pushusedregisters(pushedregs,$ff);
{$Else regallocfix}
                        pushusedregisters(pushedregs,$ff
                          xor ($80 shr byte(p^.right^.location.reference.base))
                          xor ($80 shr byte(p^.right^.location.reference.index)));
{$EndIf regallocfix}
                        emitpushreferenceaddr(p^.left^.location.reference);
                        emitpushreferenceaddr(p^.right^.location.reference);
{$IfDef regallocfix}
                        del_reference(p^.right^.location.reference);
{$EndIf regallocfix}
                        emitcall('FPC_SHORTSTR_CONCAT');
                        maybe_loadesi;
                        popusedregisters(pushedregs);

                        set_location(p^.location,p^.left^.location);
                        ungetiftemp(p^.right^.location.reference);
                     end;
                   ltn,lten,gtn,gten,
                   equaln,unequaln :
                     begin
                        cmpop:=true;
                        { generate better code for s='' and s<>'' }
                        if (p^.treetype in [equaln,unequaln]) and
                           (((p^.left^.treetype=stringconstn) and (str_length(p^.left)=0)) or
                            ((p^.right^.treetype=stringconstn) and (str_length(p^.right)=0))) then
                          begin
                             secondpass(p^.left);
                             { are too few registers free? }
                             pushed:=maybe_push(p^.right^.registers32,p,false);
                             secondpass(p^.right);
                             if pushed then restore(p,false);
                             { only one node can be stringconstn }
                             { else pass 1 would have evaluted   }
                             { this node                         }
                             if p^.left^.treetype=stringconstn then
                               emit_const_ref(
                                 A_CMP,S_B,0,newreference(p^.right^.location.reference))
                             else
                               emit_const_ref(
                                 A_CMP,S_B,0,newreference(p^.left^.location.reference));
                             del_reference(p^.right^.location.reference);
                             del_reference(p^.left^.location.reference);
                          end
                        else
                          begin
                             pushusedregisters(pushedregs,$ff);
                             secondpass(p^.left);
                             emitpushreferenceaddr(p^.left^.location.reference);
                             del_reference(p^.left^.location.reference);
                             secondpass(p^.right);
                             emitpushreferenceaddr(p^.right^.location.reference);
                             del_reference(p^.right^.location.reference);
                             emitcall('FPC_SHORTSTR_COMPARE');
                             maybe_loadesi;
                             popusedregisters(pushedregs);
                          end;
                        ungetiftemp(p^.left^.location.reference);
                        ungetiftemp(p^.right^.location.reference);
                     end;
                   else CGMessage(type_e_mismatch);
                end;
               SetResultLocation(cmpop,true,p);
             end;
          end;
      end;


{*****************************************************************************
                                Addset
*****************************************************************************}

    procedure addset(var p : ptree);
      var
        createset,
        cmpop,
        pushed : boolean;
        href   : treference;
        pushedregs : tpushed;
      begin
        cmpop:=false;

        { not commutative }
        if p^.swaped then
         swaptree(p);

        { optimize first loading of a set }
{$ifdef usecreateset}
        if (p^.right^.treetype=setelementn) and
           not(assigned(p^.right^.right)) and
           is_emptyset(p^.left) then
         createset:=true
        else
{$endif}
         begin
           createset:=false;
           secondpass(p^.left);
         end;

        { are too few registers free? }
        pushed:=maybe_push(p^.right^.registers32,p,false);
        secondpass(p^.right);
        if codegenerror then
          exit;
        if pushed then
          restore(p,false);

        set_location(p^.location,p^.left^.location);

        { handle operations }

{$IfDef regallocfix}
        pushusedregisters(pushedregs,$ff
          xor ($80 shr byte(p^.left^.location.reference.base))
          xor ($80 shr byte(p^.left^.location.reference.index))
          xor ($80 shr byte(p^.right^.location.reference.base))
          xor ($80 shr byte(p^.right^.location.reference.index)));
{$EndIf regallocfix}
        case p^.treetype of
          equaln,
        unequaln
{$IfNDef NoSetInclusion}
        ,lten, gten
{$EndIf NoSetInclusion}
                  : begin
                     cmpop:=true;
                     del_location(p^.left^.location);
                     del_location(p^.right^.location);
                     pushusedregisters(pushedregs,$ff);
{$IfNDef NoSetInclusion}
                     If (p^.treetype in [equaln, unequaln, lten]) Then
                       Begin
{$EndIf NoSetInclusion}
                         emitpushreferenceaddr(p^.right^.location.reference);
                         emitpushreferenceaddr(p^.left^.location.reference);
{$IfNDef NoSetInclusion}
                       End
                     Else  {gten = lten, if the arguments are reversed}
                       Begin
                         emitpushreferenceaddr(p^.left^.location.reference);
                         emitpushreferenceaddr(p^.right^.location.reference);
                       End;
                     Case p^.treetype of
                       equaln, unequaln:
{$EndIf NoSetInclusion}
                         emitcall('FPC_SET_COMP_SETS');
{$IfNDef NoSetInclusion}
                       lten, gten:
                         Begin
                           emitcall('FPC_SET_CONTAINS_SETS');
                           { we need a jne afterwards, not a jnbe/jnae }
                           p^.treetype := equaln;
                        End;
                     End;
{$EndIf NoSetInclusion}
                     maybe_loadesi;
                     popusedregisters(pushedregs);
                     ungetiftemp(p^.left^.location.reference);
                     ungetiftemp(p^.right^.location.reference);
                   end;
            addn : begin
                   { add can be an other SET or Range or Element ! }
{$IfNDef regallocfix}
                     del_location(p^.left^.location);
                     del_location(p^.right^.location);
                     pushusedregisters(pushedregs,$ff);
{$EndIf regallocfix}
                     href.symbol:=nil;
                     gettempofsizereference(32,href);
                     if createset then
                      begin
{$IfDef regallocfix}
                        del_location(p^.left^.location);
                        del_location(p^.right^.location);
{$EndIf regallocfix}
                        pushsetelement(p^.right^.left);
                        emitpushreferenceaddr(href);
                        emitcall('FPC_SET_CREATE_ELEMENT');
                      end
                     else
                      begin
                      { add a range or a single element? }
                        if p^.right^.treetype=setelementn then
                         begin
{$IfNDef regallocfix}
                           concatcopy(p^.left^.location.reference,href,32,false,false);
{$Else regallocfix}
                           concatcopy(p^.left^.location.reference,href,32,true,false);
{$EndIf regallocfix}
                           if assigned(p^.right^.right) then
                            begin
                              pushsetelement(p^.right^.right);
                              pushsetelement(p^.right^.left);
                              emitpushreferenceaddr(href);
                              emitcall('FPC_SET_SET_RANGE');
                            end
                           else
                            begin
                              pushsetelement(p^.right^.left);
                              emitpushreferenceaddr(href);
                              emitcall('FPC_SET_SET_BYTE');
                            end;
                         end
                        else
                         begin
                         { must be an other set }
                           emitpushreferenceaddr(href);
                           emitpushreferenceaddr(p^.right^.location.reference);
{$IfDef regallocfix}
                           del_location(p^.right^.location);
{$EndIf regallocfix}
                           emitpushreferenceaddr(p^.left^.location.reference);
{$IfDef regallocfix}
                           del_location(p^.left^.location);
{$EndIf regallocfix}
                           emitcall('FPC_SET_ADD_SETS');
                         end;
                      end;
                     maybe_loadesi;
                     popusedregisters(pushedregs);
                     ungetiftemp(p^.left^.location.reference);
                     ungetiftemp(p^.right^.location.reference);
                     p^.location.loc:=LOC_MEM;
                     p^.location.reference:=href;
                   end;
            subn,
         symdifn,
            muln : begin
{$IfNDef regallocfix}
                     del_location(p^.left^.location);
                     del_location(p^.right^.location);
                     pushusedregisters(pushedregs,$ff);
{$EndIf regallocfix}
                     href.symbol:=nil;
                     gettempofsizereference(32,href);
                     emitpushreferenceaddr(href);
                     emitpushreferenceaddr(p^.right^.location.reference);
{$IfDef regallocfix}
                     del_location(p^.right^.location);
{$EndIf regallocfix}
                     emitpushreferenceaddr(p^.left^.location.reference);
{$IfDef regallocfix}
                     del_location(p^.left^.location);
{$EndIf regallocfix}
                     case p^.treetype of
                      subn : emitcall('FPC_SET_SUB_SETS');
                   symdifn : emitcall('FPC_SET_SYMDIF_SETS');
                      muln : emitcall('FPC_SET_MUL_SETS');
                     end;
                     maybe_loadesi;
                     popusedregisters(pushedregs);
                     ungetiftemp(p^.left^.location.reference);
                     ungetiftemp(p^.right^.location.reference);
                     p^.location.loc:=LOC_MEM;
                     p^.location.reference:=href;
                   end;
        else
          CGMessage(type_e_mismatch);
        end;
        SetResultLocation(cmpop,true,p);
      end;


{*****************************************************************************
                                SecondAdd
*****************************************************************************}

    procedure secondadd(var p : ptree);
    { is also being used for xor, and "mul", "sub, or and comparative }
    { operators                                                }

      label do_normal;

      var
         hregister,hregister2 : tregister;
         noswap,popeax,popedx,
         pushed,mboverflow,cmpop : boolean;
         op,op2 : tasmop;
         flags : tresflags;
         otl,ofl,hl : pasmlabel;
         power : longint;
         opsize : topsize;
         hl4: pasmlabel;
         hr : preference;

         { true, if unsigned types are compared }
         unsigned : boolean;
         { true, if a small set is handled with the longint code }
         is_set : boolean;
         { is_in_dest if the result is put directly into }
         { the resulting refernce or varregister }
         is_in_dest : boolean;
         { true, if for sets subtractions the extra not should generated }
         extra_not : boolean;

{$ifdef SUPPORT_MMX}
         mmxbase : tmmxtype;
{$endif SUPPORT_MMX}
         pushedreg : tpushed;
         hloc : tlocation;

      procedure firstjmp64bitcmp;

        var
           oldtreetype : ttreetyp;

        begin
           { the jump the sequence is a little bit hairy }
           case p^.treetype of
              ltn,gtn:
                begin
                   emitjmp(flag_2_cond[getresflags(p,unsigned)],truelabel);
                   { cheat a little bit for the negative test }
                   p^.swaped:=not(p^.swaped);
                   emitjmp(flag_2_cond[getresflags(p,unsigned)],falselabel);
                   p^.swaped:=not(p^.swaped);
                end;
              lten,gten:
                begin
                   oldtreetype:=p^.treetype;
                   if p^.treetype=lten then
                     p^.treetype:=ltn
                   else
                     p^.treetype:=gtn;
                   emitjmp(flag_2_cond[getresflags(p,unsigned)],truelabel);
                   { cheat for the negative test }
                   if p^.treetype=ltn then
                     p^.treetype:=gtn
                   else
                     p^.treetype:=ltn;
                   emitjmp(flag_2_cond[getresflags(p,unsigned)],falselabel);
                   p^.treetype:=oldtreetype;
                end;
              equaln:
                emitjmp(C_NE,falselabel);
              unequaln:
                emitjmp(C_NE,truelabel);
           end;
        end;

      procedure secondjmp64bitcmp;

        begin
           { the jump the sequence is a little bit hairy }
           case p^.treetype of
              ltn,gtn,lten,gten:
                begin
                   { the comparisaion of the low dword have to be }
                   {  always unsigned!                            }
                   emitjmp(flag_2_cond[getresflags(p,true)],truelabel);
                   emitjmp(C_None,falselabel);
                end;
              equaln:
                begin
                   emitjmp(C_NE,falselabel);
                   emitjmp(C_None,truelabel);
                end;
              unequaln:
                begin
                   emitjmp(C_NE,truelabel);
                   emitjmp(C_None,falselabel);
                end;
           end;
        end;

      begin
      { to make it more readable, string and set (not smallset!) have their
        own procedures }
         case p^.left^.resulttype^.deftype of
         stringdef : begin
                       addstring(p);
                       exit;
                     end;
            setdef : begin
                     { normalsets are handled separate }
                       if not(psetdef(p^.left^.resulttype)^.settype=smallset) then
                        begin
                          addset(p);
                          exit;
                        end;
                     end;
         end;

         { defaults }
         unsigned:=false;
         is_in_dest:=false;
         extra_not:=false;
         noswap:=false;
         opsize:=S_L;

         { are we a (small)set, must be set here because the side can be
           swapped ! (PFV) }
         is_set:=(p^.left^.resulttype^.deftype=setdef);

         { calculate the operator which is more difficult }
         firstcomplex(p);

         { handling boolean expressions extra: }
         if is_boolean(p^.left^.resulttype) and
            is_boolean(p^.right^.resulttype) then
           begin
             if (porddef(p^.left^.resulttype)^.typ=bool8bit) or
                (porddef(p^.right^.resulttype)^.typ=bool8bit) then
               opsize:=S_B
             else
               if (porddef(p^.left^.resulttype)^.typ=bool16bit) or
                  (porddef(p^.right^.resulttype)^.typ=bool16bit) then
                 opsize:=S_W
             else
               opsize:=S_L;
             case p^.treetype of
              andn,
               orn : begin
                       clear_location(p^.location);
                       p^.location.loc:=LOC_JUMP;
                       cmpop:=false;
                       case p^.treetype of
                        andn : begin
                                  otl:=truelabel;
                                  getlabel(truelabel);
                                  secondpass(p^.left);
                                  maketojumpbool(p^.left);
                                  emitlab(truelabel);
                                  truelabel:=otl;
                               end;
                        orn : begin
                                 ofl:=falselabel;
                                 getlabel(falselabel);
                                 secondpass(p^.left);
                                 maketojumpbool(p^.left);
                                 emitlab(falselabel);
                                 falselabel:=ofl;
                              end;
                       else
                         CGMessage(type_e_mismatch);
                       end;
                       secondpass(p^.right);
                       maketojumpbool(p^.right);
                     end;
          unequaln,
       equaln,xorn : begin
                       if p^.left^.treetype=ordconstn then
                        swaptree(p);
                       if p^.left^.location.loc=LOC_JUMP then
                         begin
                            otl:=truelabel;
                            getlabel(truelabel);
                            ofl:=falselabel;
                            getlabel(falselabel);
                         end;

                       secondpass(p^.left);
                       { if in flags then copy first to register, because the
                         flags can be destroyed }
                       case p^.left^.location.loc of
                          LOC_FLAGS:
                            locflags2reg(p^.left^.location,opsize);
                          LOC_JUMP:
                            begin
                               case opsize of
                                  S_L : hregister:=getregister32;
                                  S_W : hregister:=reg32toreg16(getregister32);
                                  S_B : hregister:=reg32toreg8(getregister32);
                               end;
                               p^.left^.location.loc:=LOC_REGISTER;
                               p^.left^.location.register:=hregister;
                               emitlab(truelabel);
                               truelabel:=otl;
                               emit_const_reg(A_MOV,opsize,1,hregister);
                               getlabel(hl);
                               emitjmp(C_None,hl);
                               emitlab(falselabel);
                               falselabel:=ofl;
                               emit_reg_reg(A_XOR,S_L,makereg32(hregister),
                                 makereg32(hregister));
                               emitlab(hl);
                            end;
                       end;
                       set_location(p^.location,p^.left^.location);
                       pushed:=maybe_push(p^.right^.registers32,p,false);
                       if p^.right^.location.loc=LOC_JUMP then
                         begin
                            otl:=truelabel;
                            getlabel(truelabel);
                            ofl:=falselabel;
                            getlabel(falselabel);
                         end;
                       secondpass(p^.right);
                       if pushed then restore(p,false);
                       case p^.right^.location.loc of
                          LOC_FLAGS:
                            locflags2reg(p^.right^.location,opsize);
                          LOC_JUMP:
                            begin
                               case opsize of
                                  S_L : hregister:=getregister32;
                                  S_W : hregister:=reg32toreg16(getregister32);
                                  S_B : hregister:=reg32toreg8(getregister32);
                               end;
                               p^.right^.location.loc:=LOC_REGISTER;
                               p^.right^.location.register:=hregister;
                               emitlab(truelabel);
                               truelabel:=otl;
                               emit_const_reg(A_MOV,opsize,1,hregister);
                               getlabel(hl);
                               emitjmp(C_None,hl);
                               emitlab(falselabel);
                               falselabel:=ofl;
                               emit_reg_reg(A_XOR,S_L,makereg32(hregister),
                                 makereg32(hregister));
                               emitlab(hl);
                            end;
                       end;
                       goto do_normal;
                    end
             else
               CGMessage(type_e_mismatch);
             end
           end
         else
           begin
              { in case of constant put it to the left }
              if (p^.left^.treetype=ordconstn) then
               swaptree(p);
              secondpass(p^.left);
              { this will be complicated as
               a lot of code below assumes that
               p^.location and p^.left^.location are the same }

{$ifdef test_dest_loc}
              if dest_loc_known and (dest_loc_tree=p) and
                 ((dest_loc.loc=LOC_REGISTER) or (dest_loc.loc=LOC_CREGISTER)) then
                begin
                   set_location(p^.location,dest_loc);
                   in_dest_loc:=true;
                   is_in_dest:=true;
                end
              else
{$endif test_dest_loc}
                set_location(p^.location,p^.left^.location);

              { are too few registers free? }
              pushed:=maybe_push(p^.right^.registers32,p,is_64bitint(p^.left^.resulttype));
              secondpass(p^.right);
              if pushed then
                restore(p,is_64bitint(p^.left^.resulttype));

              if (p^.left^.resulttype^.deftype=pointerdef) or

                 (p^.right^.resulttype^.deftype=pointerdef) or

                 ((p^.right^.resulttype^.deftype=objectdef) and
                  pobjectdef(p^.right^.resulttype)^.is_class and
                 (p^.left^.resulttype^.deftype=objectdef) and
                  pobjectdef(p^.left^.resulttype)^.is_class
                 ) or

                 (p^.left^.resulttype^.deftype=classrefdef) or

                 (p^.left^.resulttype^.deftype=procvardef) or

                 ((p^.left^.resulttype^.deftype=enumdef) and
                  (p^.left^.resulttype^.size=4)) or

                 ((p^.left^.resulttype^.deftype=orddef) and
                 (porddef(p^.left^.resulttype)^.typ=s32bit)) or
                 ((p^.right^.resulttype^.deftype=orddef) and
                 (porddef(p^.right^.resulttype)^.typ=s32bit)) or

                ((p^.left^.resulttype^.deftype=orddef) and
                 (porddef(p^.left^.resulttype)^.typ=u32bit)) or
                 ((p^.right^.resulttype^.deftype=orddef) and
                 (porddef(p^.right^.resulttype)^.typ=u32bit)) or

                { as well as small sets }
                 is_set then
                begin
          do_normal:
                   mboverflow:=false;
                   cmpop:=false;
                   if (p^.left^.resulttype^.deftype=pointerdef) or
                      (p^.right^.resulttype^.deftype=pointerdef) or
                      ((p^.left^.resulttype^.deftype=orddef) and
                       (porddef(p^.left^.resulttype)^.typ=u32bit)) or
                      ((p^.right^.resulttype^.deftype=orddef) and
                       (porddef(p^.right^.resulttype)^.typ=u32bit)) then
                     unsigned:=true;
                   case p^.treetype of
                      addn : begin
                               if is_set then
                                begin
                                { adding elements is not commutative }
                                  if p^.swaped and (p^.left^.treetype=setelementn) then
                                   swaptree(p);
                                { are we adding set elements ? }
                                  if p^.right^.treetype=setelementn then
                                   begin
                                   { no range support for smallsets! }
                                     if assigned(p^.right^.right) then
                                      internalerror(43244);
                                   { bts requires both elements to be registers }
                                     if p^.left^.location.loc in [LOC_MEM,LOC_REFERENCE] then
                                      begin
                                        ungetiftemp(p^.left^.location.reference);
                                        del_location(p^.left^.location);
{!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!}
                                        hregister:=getregister32;
                                        emit_ref_reg(A_MOV,opsize,
                                          newreference(p^.left^.location.reference),hregister);
                                        clear_location(p^.left^.location);
                                        p^.left^.location.loc:=LOC_REGISTER;
                                        p^.left^.location.register:=hregister;
                                        set_location(p^.location,p^.left^.location);
                                      end;
                                     if p^.right^.location.loc in [LOC_MEM,LOC_REFERENCE] then
                                      begin
                                        ungetiftemp(p^.right^.location.reference);
                                        del_location(p^.right^.location);
                                        hregister:=getregister32;
                                        emit_ref_reg(A_MOV,opsize,
                                          newreference(p^.right^.location.reference),hregister);
                                        clear_location(p^.right^.location);
                                        p^.right^.location.loc:=LOC_REGISTER;
                                        p^.right^.location.register:=hregister;
                                      end;
                                     op:=A_BTS;
                                     noswap:=true;
                                   end
                                  else
                                   op:=A_OR;
                                  mboverflow:=false;
                                  unsigned:=false;
                                end
                               else
                                begin
                                  op:=A_ADD;
                                  mboverflow:=true;
                                end;
                             end;
                   symdifn : begin
                               { the symetric diff is only for sets }
                               if is_set then
                                begin
                                  op:=A_XOR;
                                  mboverflow:=false;
                                  unsigned:=false;
                                end
                               else
                                CGMessage(type_e_mismatch);
                             end;
                      muln : begin
                               if is_set then
                                begin
                                  op:=A_AND;
                                  mboverflow:=false;
                                  unsigned:=false;
                                end
                               else
                                begin
                                  if unsigned then
                                   op:=A_MUL
                                  else
                                   op:=A_IMUL;
                                  mboverflow:=true;
                                end;
                             end;
                      subn : begin
                               if is_set then
                                begin
                                  op:=A_AND;
                                  mboverflow:=false;
                                  unsigned:=false;
{$IfNDef NoSetConstNot}
                                  If (p^.right^.treetype = setconstn) then
                                    p^.right^.location.reference.offset := not(p^.right^.location.reference.offset)
                                  Else
{$EndIf NoNosetConstNot}
                                    extra_not:=true;
                                end
                               else
                                begin
                                  op:=A_SUB;
                                  mboverflow:=true;
                                end;
                             end;
                  ltn,lten,
                  gtn,gten,
           equaln,unequaln : begin
{$IfNDef NoSetInclusion}
                               If is_set Then
                                 Case p^.treetype of
                                   lten,gten:
                                     Begin
                                      If p^.treetype = lten then
                                        swaptree(p);
                                      if p^.left^.location.loc in [LOC_MEM,LOC_REFERENCE] then
                                        begin
                                         ungetiftemp(p^.left^.location.reference);
                                         del_reference(p^.left^.location.reference);
                                         hregister:=getregister32;
                                         emit_ref_reg(A_MOV,opsize,
                                           newreference(p^.left^.location.reference),hregister);
                                         clear_location(p^.left^.location);
                                         p^.left^.location.loc:=LOC_REGISTER;
                                         p^.left^.location.register:=hregister;
                                         set_location(p^.location,p^.left^.location);
                                       end
                                      else
                                       if p^.left^.location.loc = LOC_CREGISTER Then
                                        {save the register var in a temp register, because
                                          its value is going to be modified}
                                          begin
                                            hregister := getregister32;
                                            emit_reg_reg(A_MOV,opsize,
                                              p^.left^.location.register,hregister);
                                             clear_location(p^.left^.location);
                                             p^.left^.location.loc:=LOC_REGISTER;
                                             p^.left^.location.register:=hregister;
                                             set_location(p^.location,p^.left^.location);
                                           end;
                                     {here, p^.left^.location should be LOC_REGISTER}
                                      If p^.right^.location.loc in [LOC_MEM,LOC_REFERENCE] Then
                                         emit_ref_reg(A_AND,opsize,
                                           newreference(p^.right^.location.reference),p^.left^.location.register)
                                      Else
                                        emit_reg_reg(A_AND,opsize,
                                          p^.right^.location.register,p^.left^.location.register);
                {warning: ugly hack ahead: we need a "jne" after the cmp, so
                 change the treetype from lten/gten to equaln}
                                      p^.treetype := equaln
                                     End;
                           {no < or > support for sets}
                                   ltn,gtn: CGMessage(type_e_mismatch);
                                 End;
{$EndIf NoSetInclusion}
                               op:=A_CMP;
                               cmpop:=true;
                             end;
                      xorn : op:=A_XOR;
                       orn : op:=A_OR;
                      andn : op:=A_AND;
                   else
                     CGMessage(type_e_mismatch);
                   end;

                   { filter MUL, which requires special handling }
                   if op=A_MUL then
                     begin
                       popeax:=false;
                       popedx:=false;
                       { here you need to free the symbol first }
                       clear_location(p^.location);
                       release_loc(p^.right^.location);
                       release_loc(p^.left^.location);
                       p^.location.register:=getregister32;
                       p^.location.loc:=LOC_REGISTER;
{$IfNDef NoShlMul}
                       if p^.right^.treetype=ordconstn then
                        swaptree(p);
                       If (p^.left^.treetype = ordconstn) and
                          ispowerof2(p^.left^.value, power) and
                          not(cs_check_overflow in aktlocalswitches) then
                         Begin
                           emitloadord2reg(p^.right^.location,u32bitdef,p^.location.register,true);
                           emit_const_reg(A_SHL,S_L,power,p^.location.register)
                         End
                       Else
                        Begin
{$EndIf NoShlMul}
                         if not(R_EAX in unused) and (p^.location.register<>R_EAX) then
                          begin
                           emit_reg(A_PUSH,S_L,R_EAX);
                           popeax:=true;
                          end;
                         if not(R_EDX in unused) and (p^.location.register<>R_EDX)  then
                          begin
                           emit_reg(A_PUSH,S_L,R_EDX);
                           popedx:=true;
                          end;
                         { p^.left^.location can be R_EAX !!! }
                         emitloadord2reg(p^.left^.location,u32bitdef,R_EDI,true);
                         emitloadord2reg(p^.right^.location,u32bitdef,R_EAX,true);
                         emit_reg(A_MUL,S_L,R_EDI);
                         emit_reg_reg(A_MOV,S_L,R_EAX,p^.location.register);
                         if popedx then
                          emit_reg(A_POP,S_L,R_EDX);
                         if popeax then
                          emit_reg(A_POP,S_L,R_EAX);
{$IfNDef NoShlMul}
                        End;
{$endif NoShlMul}
                       SetResultLocation(false,true,p);
                       exit;
                     end;

                   { Convert flags to register first }
                   if (p^.left^.location.loc=LOC_FLAGS) then
                    locflags2reg(p^.left^.location,opsize);
                   if (p^.right^.location.loc=LOC_FLAGS) then
                    locflags2reg(p^.right^.location,opsize);

                   { left and right no register?  }
                   { then one must be demanded    }
                   if (p^.left^.location.loc<>LOC_REGISTER) and
                      (p^.right^.location.loc<>LOC_REGISTER) then
                     begin
                        { register variable ? }
                        if (p^.left^.location.loc=LOC_CREGISTER) then
                          begin
                             { it is OK if this is the destination }
                             if is_in_dest then
                               begin
                                  hregister:=p^.location.register;
                                  emit_reg_reg(A_MOV,opsize,p^.left^.location.register,
                                    hregister);
                               end
                             else
                             if cmpop then
                               begin
                                  { do not disturb the register }
                                  hregister:=p^.location.register;
                               end
                             else
                               begin
                                  case opsize of
                                     S_L : hregister:=getregister32;
                                     S_B : hregister:=reg32toreg8(getregister32);
                                  end;
                                  emit_reg_reg(A_MOV,opsize,p^.left^.location.register,
                                    hregister);
                               end
                          end
                        else
                          begin
                             ungetiftemp(p^.left^.location.reference);
                             del_reference(p^.left^.location.reference);
                             if is_in_dest then
                               begin
                                  hregister:=p^.location.register;
                                  emit_ref_reg(A_MOV,opsize,
                                    newreference(p^.left^.location.reference),hregister);
                               end
                             else
                               begin
                                  { first give free, then demand new register }
                                  case opsize of
                                     S_L : hregister:=getregister32;
                                     S_W : hregister:=reg32toreg16(getregister32);
                                     S_B : hregister:=reg32toreg8(getregister32);
                                  end;
                                  emit_ref_reg(A_MOV,opsize,
                                    newreference(p^.left^.location.reference),hregister);
                               end;
                          end;
                        clear_location(p^.location);
                        p^.location.loc:=LOC_REGISTER;
                        p^.location.register:=hregister;
                     end
                   else
                     { if on the right the register then swap }
                     if not(noswap) and (p^.right^.location.loc=LOC_REGISTER) then
                       begin
                          swap_location(p^.location,p^.right^.location);

                          { newly swapped also set swapped flag }
                          p^.swaped:=not(p^.swaped);
                       end;
                   { at this point, p^.location.loc should be LOC_REGISTER }
                   { and p^.location.register should be a valid register   }
                   { containing the left result                     }

                    if p^.right^.location.loc<>LOC_REGISTER then
                     begin
                        if (p^.treetype=subn) and p^.swaped then
                          begin
                             if p^.right^.location.loc=LOC_CREGISTER then
                               begin
                                  if extra_not then
                                    emit_reg(A_NOT,opsize,p^.location.register);

                                  emit_reg_reg(A_MOV,opsize,p^.right^.location.register,R_EDI);
                                  emit_reg_reg(op,opsize,p^.location.register,R_EDI);
                                  emit_reg_reg(A_MOV,opsize,R_EDI,p^.location.register);
                               end
                             else
                               begin
                                  if extra_not then
                                    emit_reg(A_NOT,opsize,p^.location.register);

                                  emit_ref_reg(A_MOV,opsize,
                                    newreference(p^.right^.location.reference),R_EDI);
                                  emit_reg_reg(op,opsize,p^.location.register,R_EDI);
                                  emit_reg_reg(A_MOV,opsize,R_EDI,p^.location.register);
                                  ungetiftemp(p^.right^.location.reference);
                                  del_reference(p^.right^.location.reference);
                               end;
                          end
                        else
                          begin
                             if (p^.right^.treetype=ordconstn) and
                                (op=A_CMP) and
                                (p^.right^.value=0) then
                               begin
                                  emit_reg_reg(A_TEST,opsize,p^.location.register,
                                    p^.location.register);
                               end
                             else if (p^.right^.treetype=ordconstn) and
                                (op=A_ADD) and
                                (p^.right^.value=1) and
                                not(cs_check_overflow in aktlocalswitches) then
                               begin
                                  emit_reg(A_INC,opsize,
                                    p^.location.register);
                               end
                             else if (p^.right^.treetype=ordconstn) and
                                (op=A_SUB) and
                                (p^.right^.value=1) and
                                not(cs_check_overflow in aktlocalswitches) then
                               begin
                                  emit_reg(A_DEC,opsize,
                                    p^.location.register);
                               end
                             else if (p^.right^.treetype=ordconstn) and
                                (op=A_IMUL) and
                                (ispowerof2(p^.right^.value,power)) and
                                not(cs_check_overflow in aktlocalswitches) then
                               begin
                                  emit_const_reg(A_SHL,opsize,power,
                                    p^.location.register);
                               end
                             else
                               begin
                                  if (p^.right^.location.loc=LOC_CREGISTER) then
                                    begin
                                       if extra_not then
                                         begin
                                            emit_reg_reg(A_MOV,S_L,p^.right^.location.register,R_EDI);
                                            emit_reg(A_NOT,S_L,R_EDI);
                                            emit_reg_reg(A_AND,S_L,R_EDI,
                                              p^.location.register);
                                         end
                                       else
                                         begin
                                            emit_reg_reg(op,opsize,p^.right^.location.register,
                                              p^.location.register);
                                         end;
                                    end
                                  else
                                    begin
                                       if extra_not then
                                         begin
                                            emit_ref_reg(A_MOV,S_L,newreference(
                                              p^.right^.location.reference),R_EDI);
                                            emit_reg(A_NOT,S_L,R_EDI);
                                            emit_reg_reg(A_AND,S_L,R_EDI,
                                              p^.location.register);
                                         end
                                       else
                                         begin
                                            emit_ref_reg(op,opsize,newreference(
                                              p^.right^.location.reference),p^.location.register);
                                         end;
                                       ungetiftemp(p^.right^.location.reference);
                                       del_reference(p^.right^.location.reference);
                                    end;
                               end;
                          end;
                     end
                   else
                     begin
                        { when swapped another result register }
                        if (p^.treetype=subn) and p^.swaped then
                          begin
                             if extra_not then
                               emit_reg(A_NOT,S_L,p^.location.register);

                             emit_reg_reg(op,opsize,
                               p^.location.register,p^.right^.location.register);
                               swap_location(p^.location,p^.right^.location);
                               { newly swapped also set swapped flag }
                               { just to maintain ordering         }
                               p^.swaped:=not(p^.swaped);
                          end
                        else
                          begin
                             if extra_not then
                               emit_reg(A_NOT,S_L,p^.right^.location.register);
                             emit_reg_reg(op,opsize,
                               p^.right^.location.register,
                               p^.location.register);
                          end;
                        case opsize of
                           S_L : ungetregister32(p^.right^.location.register);
                           S_B : ungetregister32(reg8toreg32(p^.right^.location.register));
                        end;
                     end;

                   if cmpop then
                     case opsize of
                        S_L : ungetregister32(p^.location.register);
                        S_B : ungetregister32(reg8toreg32(p^.location.register));
                     end;

                   { only in case of overflow operations }
                   { produce overflow code }
                   { we must put it here directly, because sign of operation }
                   { is in unsigned VAR!!                                   }
                   if mboverflow then
                    begin
                      if cs_check_overflow in aktlocalswitches  then
                       begin
                         getlabel(hl4);
                         if unsigned then
                          emitjmp(C_NB,hl4)
                         else
                          emitjmp(C_NO,hl4);
                         emitcall('FPC_OVERFLOW');
                         emitlab(hl4);
                       end;
                    end;
                end
              else

              { Char type }
                if ((p^.left^.resulttype^.deftype=orddef) and
                    (porddef(p^.left^.resulttype)^.typ=uchar)) or
              { enumeration type 16 bit }
                   ((p^.left^.resulttype^.deftype=enumdef) and
                    (p^.left^.resulttype^.size=1)) then
                 begin
                   case p^.treetype of
                      ltn,lten,gtn,gten,
                      equaln,unequaln :
                                cmpop:=true;
                      else CGMessage(type_e_mismatch);
                   end;
                   unsigned:=true;
                   { left and right no register? }
                   { the one must be demanded    }
                   if (p^.location.loc<>LOC_REGISTER) and
                     (p^.right^.location.loc<>LOC_REGISTER) then
                     begin
                        if p^.location.loc=LOC_CREGISTER then
                          begin
                             if cmpop then
                               { do not disturb register }
                               hregister:=p^.location.register
                             else
                               begin
                                  hregister:=reg32toreg8(getregister32);
                                  emit_reg_reg(A_MOV,S_B,p^.location.register,
                                    hregister);
                               end;
                          end
                        else
                          begin
                             del_reference(p^.location.reference);

                             { first give free then demand new register }
                             hregister:=reg32toreg8(getregister32);
                             emit_ref_reg(A_MOV,S_B,newreference(p^.location.reference),
                               hregister);
                          end;
                        clear_location(p^.location);
                        p^.location.loc:=LOC_REGISTER;
                        p^.location.register:=hregister;
                     end;

                   { now p always a register }

                   if (p^.right^.location.loc=LOC_REGISTER) and
                      (p^.location.loc<>LOC_REGISTER) then
                     begin
                       swap_location(p^.location,p^.right^.location);
                       { newly swapped also set swapped flag }
                       p^.swaped:=not(p^.swaped);
                     end;

                   if p^.right^.location.loc<>LOC_REGISTER then
                     begin
                        if p^.right^.location.loc=LOC_CREGISTER then
                          begin
                             emit_reg_reg(A_CMP,S_B,
                                p^.right^.location.register,p^.location.register);
                          end
                        else
                          begin
                             emit_ref_reg(A_CMP,S_B,newreference(
                                p^.right^.location.reference),p^.location.register);
                             del_reference(p^.right^.location.reference);
                          end;
                     end
                   else
                     begin
                        emit_reg_reg(A_CMP,S_B,p^.right^.location.register,
                          p^.location.register);
                        ungetregister32(reg8toreg32(p^.right^.location.register));
                     end;
                   ungetregister32(reg8toreg32(p^.location.register));
                end
              else
              { 16 bit enumeration type }
                if ((p^.left^.resulttype^.deftype=enumdef) and
                    (p^.left^.resulttype^.size=2)) then
                 begin
                   case p^.treetype of
                      ltn,lten,gtn,gten,
                      equaln,unequaln :
                                cmpop:=true;
                      else CGMessage(type_e_mismatch);
                   end;
                   unsigned:=true;
                   { left and right no register? }
                   { the one must be demanded    }
                   if (p^.location.loc<>LOC_REGISTER) and
                     (p^.right^.location.loc<>LOC_REGISTER) then
                     begin
                        if p^.location.loc=LOC_CREGISTER then
                          begin
                             if cmpop then
                               { do not disturb register }
                               hregister:=p^.location.register
                             else
                               begin
                                  hregister:=reg32toreg16(getregister32);
                                  emit_reg_reg(A_MOV,S_W,p^.location.register,
                                    hregister);
                               end;
                          end
                        else
                          begin
                             del_reference(p^.location.reference);

                             { first give free then demand new register }
                             hregister:=reg32toreg16(getregister32);
                             emit_ref_reg(A_MOV,S_W,newreference(p^.location.reference),
                               hregister);
                          end;
                        clear_location(p^.location);
                        p^.location.loc:=LOC_REGISTER;
                        p^.location.register:=hregister;
                     end;

                   { now p always a register }

                   if (p^.right^.location.loc=LOC_REGISTER) and
                      (p^.location.loc<>LOC_REGISTER) then
                     begin
                       swap_location(p^.location,p^.right^.location);
                       { newly swapped also set swapped flag }
                       p^.swaped:=not(p^.swaped);
                     end;

                   if p^.right^.location.loc<>LOC_REGISTER then
                     begin
                        if p^.right^.location.loc=LOC_CREGISTER then
                          begin
                             emit_reg_reg(A_CMP,S_W,
                                p^.right^.location.register,p^.location.register);
                          end
                        else
                          begin
                             emit_ref_reg(A_CMP,S_W,newreference(
                                p^.right^.location.reference),p^.location.register);
                             del_reference(p^.right^.location.reference);
                          end;
                     end
                   else
                     begin
                        emit_reg_reg(A_CMP,S_W,p^.right^.location.register,
                          p^.location.register);
                        ungetregister32(reg16toreg32(p^.right^.location.register));
                     end;
                   ungetregister32(reg16toreg32(p^.location.register));
                end
              else
              { 64 bit types }
              if is_64bitint(p^.left^.resulttype) then
                begin
                   mboverflow:=false;
                   cmpop:=false;
                   unsigned:=((p^.left^.resulttype^.deftype=orddef) and
                       (porddef(p^.left^.resulttype)^.typ=u64bit)) or
                      ((p^.right^.resulttype^.deftype=orddef) and
                       (porddef(p^.right^.resulttype)^.typ=u64bit));
                   case p^.treetype of
                      addn : begin
                                begin
                                  op:=A_ADD;
                                  op2:=A_ADC;
                                  mboverflow:=true;
                                end;
                             end;
                      subn : begin
                                op:=A_SUB;
                                op2:=A_SBB;
                                mboverflow:=true;
                             end;
                      ltn,lten,
                      gtn,gten,
                      equaln,unequaln:
                             begin
                               op:=A_CMP;
                               op2:=A_CMP;
                               cmpop:=true;
                             end;

                      xorn:
                        begin
                           op:=A_XOR;
                           op2:=A_XOR;
                        end;

                      orn:
                        begin
                           op:=A_OR;
                           op2:=A_OR;
                        end;

                      andn:
                        begin
                           op:=A_AND;
                           op2:=A_AND;
                        end;
                      muln:
                        ;
                   else
                     CGMessage(type_e_mismatch);
                   end;

                   if p^.treetype=muln then
                     begin
                        { save p^.lcoation, because we change it now }
                        set_location(hloc,p^.location);
                        release_qword_loc(p^.location);
                        release_qword_loc(p^.right^.location);
                        p^.location.registerlow:=getexplicitregister32(R_EAX);
                        p^.location.registerhigh:=getexplicitregister32(R_EDX);
                        pushusedregisters(pushedreg,$ff
                          and not($80 shr byte(p^.location.registerlow))
                          and not($80 shr byte(p^.location.registerhigh)));
                        if cs_check_overflow in aktlocalswitches then
                          push_int(1)
                        else
                          push_int(0);
                        { the left operand is in hloc, because the
                          location of left is p^.location but p^.location
                          is already destroyed
                        }
                        emit_pushq_loc(hloc);
                        clear_location(hloc);
                        emit_pushq_loc(p^.right^.location);
                        if porddef(p^.resulttype)^.typ=u64bit then
                          emitcall('FPC_MUL_QWORD')
                        else
                          emitcall('FPC_MUL_INT64');
                        emit_reg_reg(A_MOV,S_L,R_EAX,p^.location.registerlow);
                        emit_reg_reg(A_MOV,S_L,R_EDX,p^.location.registerhigh);
                        popusedregisters(pushedreg);
                        p^.location.loc:=LOC_REGISTER;
                     end
                   else
                     begin
                        { left and right no register?  }
                        { then one must be demanded    }
                        if (p^.left^.location.loc<>LOC_REGISTER) and
                           (p^.right^.location.loc<>LOC_REGISTER) then
                          begin
                             { register variable ? }
                             if (p^.left^.location.loc=LOC_CREGISTER) then
                               begin
                                  { it is OK if this is the destination }
                                  if is_in_dest then
                                    begin
                                       hregister:=p^.location.registerlow;
                                       hregister2:=p^.location.registerhigh;
                                       emit_reg_reg(A_MOV,S_L,p^.left^.location.registerlow,
                                         hregister);
                                       emit_reg_reg(A_MOV,S_L,p^.left^.location.registerlow,
                                         hregister2);
                                    end
                                  else
                                  if cmpop then
                                    begin
                                       { do not disturb the register }
                                       hregister:=p^.location.registerlow;
                                       hregister2:=p^.location.registerhigh;
                                    end
                                  else
                                    begin
                                       hregister:=getregister32;
                                       hregister2:=getregister32;
                                       emit_reg_reg(A_MOV,S_L,p^.left^.location.registerlow,
                                         hregister);
                                       emit_reg_reg(A_MOV,S_L,p^.left^.location.registerhigh,
                                         hregister2);
                                    end
                               end
                             else
                               begin
                                  ungetiftemp(p^.left^.location.reference);
                                  del_reference(p^.left^.location.reference);
                                  if is_in_dest then
                                    begin
                                       hregister:=p^.location.registerlow;
                                       hregister2:=p^.location.registerhigh;
                                       emit_ref_reg(A_MOV,S_L,
                                         newreference(p^.left^.location.reference),hregister);
                                       hr:=newreference(p^.left^.location.reference);
                                       inc(hr^.offset,4);
                                       emit_ref_reg(A_MOV,S_L,
                                         hr,hregister2);
                                    end
                                  else
                                    begin
                                       hregister:=getregister32;
                                       hregister2:=getregister32;
                                       emit_ref_reg(A_MOV,S_L,
                                         newreference(p^.left^.location.reference),hregister);
                                       hr:=newreference(p^.left^.location.reference);
                                       inc(hr^.offset,4);
                                       emit_ref_reg(A_MOV,S_L,
                                         hr,hregister2);
                                    end;
                               end;
                             clear_location(p^.location);
                             p^.location.loc:=LOC_REGISTER;
                             p^.location.registerlow:=hregister;
                             p^.location.registerhigh:=hregister2;
                          end
                        else
                          { if on the right the register then swap }
                          if not(noswap) and (p^.right^.location.loc=LOC_REGISTER) then
                            begin
                               swap_location(p^.location,p^.right^.location);

                               { newly swapped also set swapped flag }
                               p^.swaped:=not(p^.swaped);
                            end;
                        { at this point, p^.location.loc should be LOC_REGISTER }
                        { and p^.location.register should be a valid register   }
                        { containing the left result                        }

                        if p^.right^.location.loc<>LOC_REGISTER then
                          begin
                             if (p^.treetype=subn) and p^.swaped then
                               begin
                                  if p^.right^.location.loc=LOC_CREGISTER then
                                    begin
                                       emit_reg_reg(A_MOV,opsize,p^.right^.location.register,R_EDI);
                                       emit_reg_reg(op,opsize,p^.location.register,R_EDI);
                                       emit_reg_reg(A_MOV,opsize,R_EDI,p^.location.register);
                                       emit_reg_reg(A_MOV,opsize,p^.right^.location.registerhigh,R_EDI);
                                       { the carry flag is still ok }
                                       emit_reg_reg(op2,opsize,p^.location.registerhigh,R_EDI);
                                       emit_reg_reg(A_MOV,opsize,R_EDI,p^.location.registerhigh);
                                    end
                                  else
                                    begin
                                       emit_ref_reg(A_MOV,opsize,
                                         newreference(p^.right^.location.reference),R_EDI);
                                       emit_reg_reg(op,opsize,p^.location.registerlow,R_EDI);
                                       emit_reg_reg(A_MOV,opsize,R_EDI,p^.location.registerlow);
                                       hr:=newreference(p^.right^.location.reference);
                                       inc(hr^.offset,4);
                                       emit_ref_reg(A_MOV,opsize,
                                         hr,R_EDI);
                                       { here the carry flag is still preserved }
                                       emit_reg_reg(op2,opsize,p^.location.registerhigh,R_EDI);
                                       emit_reg_reg(A_MOV,opsize,R_EDI,
                                         p^.location.registerhigh);
                                       ungetiftemp(p^.right^.location.reference);
                                       del_reference(p^.right^.location.reference);
                                    end;
                               end
                             else if cmpop then
                               begin
                                  if (p^.right^.location.loc=LOC_CREGISTER) then
                                    begin
                                       emit_reg_reg(A_CMP,S_L,p^.right^.location.registerhigh,
                                          p^.location.registerhigh);
                                       firstjmp64bitcmp;
                                       emit_reg_reg(A_CMP,S_L,p^.right^.location.registerlow,
                                          p^.location.registerlow);
                                       secondjmp64bitcmp;
                                    end
                                  else
                                    begin
                                       hr:=newreference(p^.right^.location.reference);
                                       inc(hr^.offset,4);

                                       emit_ref_reg(A_CMP,S_L,
                                         hr,p^.location.registerhigh);
                                       firstjmp64bitcmp;

                                       emit_ref_reg(A_CMP,S_L,newreference(
                                         p^.right^.location.reference),p^.location.registerlow);
                                       secondjmp64bitcmp;

                                       emitjmp(C_None,falselabel);

                                       ungetiftemp(p^.right^.location.reference);
                                       del_reference(p^.right^.location.reference);
                                    end;
                               end
                             else
                               begin
                                  {
                                  if (p^.right^.treetype=ordconstn) and
                                     (op=A_CMP) and
                                     (p^.right^.value=0) then
                                    begin
                                       emit_reg_reg(A_TEST,opsize,p^.location.register,
                                         p^.location.register);
                                    end
                                  else if (p^.right^.treetype=ordconstn) and
                                     (op=A_IMUL) and
                                     (ispowerof2(p^.right^.value,power)) then
                                    begin
                                       emit_const_reg(A_SHL,opsize,power,
                                         p^.location.register);
                                    end
                                  else
                                  }
                                    begin
                                       if (p^.right^.location.loc=LOC_CREGISTER) then
                                         begin
                                            emit_reg_reg(op,S_L,p^.right^.location.registerlow,
                                               p^.location.registerlow);
                                            emit_reg_reg(op2,S_L,p^.right^.location.registerhigh,
                                               p^.location.registerhigh);
                                         end
                                       else
                                         begin
                                            emit_ref_reg(op,S_L,newreference(
                                              p^.right^.location.reference),p^.location.registerlow);
                                            hr:=newreference(p^.right^.location.reference);
                                            inc(hr^.offset,4);
                                            emit_ref_reg(op2,S_L,
                                              hr,p^.location.registerhigh);
                                            ungetiftemp(p^.right^.location.reference);
                                            del_reference(p^.right^.location.reference);
                                         end;
                                    end;
                               end;
                          end
                        else
                          begin
                             { when swapped another result register }
                             if (p^.treetype=subn) and p^.swaped then
                               begin
                                 emit_reg_reg(op,S_L,
                                    p^.location.registerlow,
                                    p^.right^.location.registerlow);
                                 emit_reg_reg(op2,S_L,
                                    p^.location.registerhigh,
                                    p^.right^.location.registerhigh);
                                  swap_location(p^.location,p^.right^.location);
                                  { newly swapped also set swapped flag }
                                  { just to maintain ordering           }
                                  p^.swaped:=not(p^.swaped);
                               end
                             else if cmpop then
                               begin
                                  emit_reg_reg(A_CMP,S_L,
                                    p^.right^.location.registerhigh,
                                    p^.location.registerhigh);
                                  firstjmp64bitcmp;
                                  emit_reg_reg(A_CMP,S_L,
                                    p^.right^.location.registerlow,
                                    p^.location.registerlow);
                                  secondjmp64bitcmp;
                               end
                             else
                               begin
                                  emit_reg_reg(op,S_L,
                                    p^.right^.location.registerlow,
                                    p^.location.registerlow);
                                  emit_reg_reg(op2,S_L,
                                    p^.right^.location.registerhigh,
                                    p^.location.registerhigh);
                               end;
                             ungetregister32(p^.right^.location.registerlow);
                             ungetregister32(p^.right^.location.registerhigh);
                          end;

                        if cmpop then
                          begin
                             ungetregister32(p^.location.registerlow);
                             ungetregister32(p^.location.registerhigh);
                          end;

                        { only in case of overflow operations }
                        { produce overflow code }
                        { we must put it here directly, because sign of operation }
                        { is in unsigned VAR!!                              }
                        if mboverflow then
                         begin
                           if cs_check_overflow in aktlocalswitches  then
                            begin
                              getlabel(hl4);
                              if unsigned then
                               emitjmp(C_NB,hl4)
                              else
                               emitjmp(C_NO,hl4);
                              emitcall('FPC_OVERFLOW');
                              emitlab(hl4);
                            end;
                         end;
                        { we have LOC_JUMP as result }
                        if cmpop then
                          begin
                             clear_location(p^.location);
                             p^.location.loc:=LOC_JUMP;
                             cmpop:=false;
                          end;
                     end;
                end
              else
              { Floating point }
               if (p^.left^.resulttype^.deftype=floatdef) and
                  (pfloatdef(p^.left^.resulttype)^.typ<>f32bit) then
                 begin
                    { real constants to the left }
                    if p^.left^.treetype=realconstn then
                      swaptree(p);
                    cmpop:=false;
                    case p^.treetype of
                       addn : op:=A_FADDP;
                       muln : op:=A_FMULP;
                       subn : op:=A_FSUBP;
                       slashn : op:=A_FDIVP;
                       ltn,lten,gtn,gten,
                       equaln,unequaln : begin
                                            op:=A_FCOMPP;
                                            cmpop:=true;
                                         end;
                       else CGMessage(type_e_mismatch);
                    end;

                    if (p^.right^.location.loc<>LOC_FPU) then
                      begin
                         if p^.right^.location.loc=LOC_CFPUREGISTER then
                           begin
                              emit_reg( A_FLD,S_NO,
                                correct_fpuregister(p^.right^.location.register,fpuvaroffset));
                              inc(fpuvaroffset);
                            end
                         else
                           floatload(pfloatdef(p^.right^.resulttype)^.typ,p^.right^.location.reference);
                         if (p^.left^.location.loc<>LOC_FPU) then
                           begin
                              if p^.left^.location.loc=LOC_CFPUREGISTER then
                                begin
                                   emit_reg( A_FLD,S_NO,
                                     correct_fpuregister(p^.left^.location.register,fpuvaroffset));
                                   inc(fpuvaroffset);
                                end
                              else
                                floatload(pfloatdef(p^.left^.resulttype)^.typ,p^.left^.location.reference)
                           end
                         { left was on the stack => swap }
                         else
                           p^.swaped:=not(p^.swaped);

                         { releases the right reference }
                         del_reference(p^.right^.location.reference);
                      end
                    { the nominator in st0 }
                    else if (p^.left^.location.loc<>LOC_FPU) then
                      begin
                         if p^.left^.location.loc=LOC_CFPUREGISTER then
                           begin
                              emit_reg( A_FLD,S_NO,
                                correct_fpuregister(p^.left^.location.register,fpuvaroffset));
                              inc(fpuvaroffset);
                           end
                         else
                           floatload(pfloatdef(p^.left^.resulttype)^.typ,p^.left^.location.reference)
                      end
                    { fpu operands are always in the wrong order on the stack }
                    else
                      p^.swaped:=not(p^.swaped);

                    { releases the left reference }
                    if (p^.left^.location.loc in [LOC_MEM,LOC_REFERENCE]) then
                      del_reference(p^.left^.location.reference);

                    { if we swaped the tree nodes, then use the reverse operator }
                    if p^.swaped then
                      begin
                         if (p^.treetype=slashn) then
                           op:=A_FDIVRP
                         else if (p^.treetype=subn) then
                           op:=A_FSUBRP;
                      end;
                    { to avoid the pentium bug
                    if (op=FDIVP) and (opt_processors=pentium) then
                      emitcall('EMUL_FDIVP')
                    else
                    }
                    { the Intel assemblers want operands }
                    if op<>A_FCOMPP then
                      begin
                         emit_reg_reg(op,S_NO,R_ST,R_ST1);
                         dec(fpuvaroffset);
                      end
                    else
                      begin
                         emit_none(op,S_NO);
                         dec(fpuvaroffset,2);
                      end;

                    { on comparison load flags }
                    if cmpop then
                     begin
                       if not(R_EAX in unused) then
                         emit_reg_reg(A_MOV,S_L,R_EAX,R_EDI);
                       emit_reg(A_FNSTSW,S_NO,R_AX);
                       emit_none(A_SAHF,S_NO);
                       if not(R_EAX in unused) then
                         emit_reg_reg(A_MOV,S_L,R_EDI,R_EAX);
                       if p^.swaped then
                        begin
                          case p^.treetype of
                              equaln : flags:=F_E;
                            unequaln : flags:=F_NE;
                                 ltn : flags:=F_A;
                                lten : flags:=F_AE;
                                 gtn : flags:=F_B;
                                gten : flags:=F_BE;
                          end;
                        end
                       else
                        begin
                          case p^.treetype of
                              equaln : flags:=F_E;
                            unequaln : flags:=F_NE;
                                 ltn : flags:=F_B;
                                lten : flags:=F_BE;
                                 gtn : flags:=F_A;
                                gten : flags:=F_AE;
                          end;
                        end;
                       clear_location(p^.location);
                       p^.location.loc:=LOC_FLAGS;
                       p^.location.resflags:=flags;
                       cmpop:=false;
                     end
                    else
                     begin
                        clear_location(p^.location);
                        p^.location.loc:=LOC_FPU;
                     end;
                 end
{$ifdef SUPPORT_MMX}
               else

               { MMX Arrays }
                if is_mmx_able_array(p^.left^.resulttype) then
                 begin
                   cmpop:=false;
                   mmxbase:=mmx_type(p^.left^.resulttype);
                   case p^.treetype of
                      addn : begin
                                if (cs_mmx_saturation in aktlocalswitches) then
                                  begin
                                     case mmxbase of
                                        mmxs8bit:
                                          op:=A_PADDSB;
                                        mmxu8bit:
                                          op:=A_PADDUSB;
                                        mmxs16bit,mmxfixed16:
                                          op:=A_PADDSB;
                                        mmxu16bit:
                                          op:=A_PADDUSW;
                                     end;
                                  end
                                else
                                  begin
                                     case mmxbase of
                                        mmxs8bit,mmxu8bit:
                                          op:=A_PADDB;
                                        mmxs16bit,mmxu16bit,mmxfixed16:
                                          op:=A_PADDW;
                                        mmxs32bit,mmxu32bit:
                                          op:=A_PADDD;
                                     end;
                                  end;
                             end;
                      muln : begin
                                case mmxbase of
                                   mmxs16bit,mmxu16bit:
                                     op:=A_PMULLW;
                                   mmxfixed16:
                                     op:=A_PMULHW;
                                end;
                             end;
                      subn : begin
                                if (cs_mmx_saturation in aktlocalswitches) then
                                  begin
                                     case mmxbase of
                                        mmxs8bit:
                                          op:=A_PSUBSB;
                                        mmxu8bit:
                                          op:=A_PSUBUSB;
                                        mmxs16bit,mmxfixed16:
                                          op:=A_PSUBSB;
                                        mmxu16bit:
                                          op:=A_PSUBUSW;
                                     end;
                                  end
                                else
                                  begin
                                     case mmxbase of
                                        mmxs8bit,mmxu8bit:
                                          op:=A_PSUBB;
                                        mmxs16bit,mmxu16bit,mmxfixed16:
                                          op:=A_PSUBW;
                                        mmxs32bit,mmxu32bit:
                                          op:=A_PSUBD;
                                     end;
                                  end;
                             end;
                      {
                      ltn,lten,gtn,gten,
                      equaln,unequaln :
                             begin
                                op:=A_CMP;
                                cmpop:=true;
                             end;
                      }
                      xorn:
                        op:=A_PXOR;
                      orn:
                        op:=A_POR;
                      andn:
                        op:=A_PAND;
                      else CGMessage(type_e_mismatch);
                   end;
                   { left and right no register?  }
                   { then one must be demanded    }
                   if (p^.left^.location.loc<>LOC_MMXREGISTER) and
                     (p^.right^.location.loc<>LOC_MMXREGISTER) then
                     begin
                        { register variable ? }
                        if (p^.left^.location.loc=LOC_CMMXREGISTER) then
                          begin
                             { it is OK if this is the destination }
                             if is_in_dest then
                               begin
                                  hregister:=p^.location.register;
                                  emit_reg_reg(A_MOVQ,S_NO,p^.left^.location.register,
                                    hregister);
                               end
                             else
                               begin
                                  hregister:=getregistermmx;
                                  emit_reg_reg(A_MOVQ,S_NO,p^.left^.location.register,
                                    hregister);
                               end
                          end
                        else
                          begin
                             del_reference(p^.left^.location.reference);

                             if is_in_dest then
                               begin
                                  hregister:=p^.location.register;
                                  emit_ref_reg(A_MOVQ,S_NO,
                                    newreference(p^.left^.location.reference),hregister);
                               end
                             else
                               begin
                                  hregister:=getregistermmx;
                                  emit_ref_reg(A_MOVQ,S_NO,
                                    newreference(p^.left^.location.reference),hregister);
                               end;
                          end;
                        clear_location(p^.location);
                        p^.location.loc:=LOC_MMXREGISTER;
                        p^.location.register:=hregister;
                     end
                   else
                     { if on the right the register then swap }
                     if (p^.right^.location.loc=LOC_MMXREGISTER) then
                       begin
                          swap_location(p^.location,p^.right^.location);
                          { newly swapped also set swapped flag }
                          p^.swaped:=not(p^.swaped);
                       end;
                   { at this point, p^.location.loc should be LOC_MMXREGISTER }
                   { and p^.location.register should be a valid register      }
                   { containing the left result                        }
                   if p^.right^.location.loc<>LOC_MMXREGISTER then
                     begin
                        if (p^.treetype=subn) and p^.swaped then
                          begin
                             if p^.right^.location.loc=LOC_CMMXREGISTER then
                               begin
                                  emit_reg_reg(A_MOVQ,S_NO,p^.right^.location.register,R_MM7);
                                  emit_reg_reg(op,S_NO,p^.location.register,R_EDI);
                                  emit_reg_reg(A_MOVQ,S_NO,R_MM7,p^.location.register);
                               end
                             else
                               begin
                                  emit_ref_reg(A_MOVQ,S_NO,
                                    newreference(p^.right^.location.reference),R_MM7);
                                  emit_reg_reg(op,S_NO,p^.location.register,
                                    R_MM7);
                                  emit_reg_reg(A_MOVQ,S_NO,
                                    R_MM7,p^.location.register);
                                  del_reference(p^.right^.location.reference);
                               end;
                          end
                        else
                          begin
                             if (p^.right^.location.loc=LOC_CREGISTER) then
                               begin
                                  emit_reg_reg(op,S_NO,p^.right^.location.register,
                                    p^.location.register);
                               end
                             else
                               begin
                                  emit_ref_reg(op,S_NO,newreference(
                                    p^.right^.location.reference),p^.location.register);
                                  del_reference(p^.right^.location.reference);
                               end;
                          end;
                     end
                   else
                     begin
                        { when swapped another result register }
                        if (p^.treetype=subn) and p^.swaped then
                          begin
                             emit_reg_reg(op,S_NO,
                               p^.location.register,p^.right^.location.register);
                             swap_location(p^.location,p^.right^.location);
                             { newly swapped also set swapped flag }
                             { just to maintain ordering         }
                             p^.swaped:=not(p^.swaped);
                          end
                        else
                          begin
                             emit_reg_reg(op,S_NO,
                               p^.right^.location.register,
                               p^.location.register);
                          end;
                        ungetregistermmx(p^.right^.location.register);
                     end;
                end
{$endif SUPPORT_MMX}
              else CGMessage(type_e_mismatch);
           end;
       SetResultLocation(cmpop,unsigned,p);
    end;


end.
{
  $Log$
  Revision 1.75  1999-08-23 10:35:13  jonas
    * fixed <= and >= for sets

  Revision 1.74  1999/08/19 13:08:43  pierre
   * emit_??? used

  Revision 1.73  1999/08/07 11:29:26  peter
    * better fix for muln register allocation

  Revision 1.72  1999/08/04 13:45:17  florian
    + floating point register variables !!
    * pairegalloc is now generated for register variables

  Revision 1.71  1999/08/04 00:22:40  florian
    * renamed i386asm and i386base to cpuasm and cpubase

  Revision 1.70  1999/08/03 22:02:31  peter
    * moved bitmask constants to sets
    * some other type/const renamings

  Revision 1.69  1999/07/05 20:13:06  peter
    * removed temp defines

  Revision 1.68  1999/07/02 12:18:46  jonas
    * released setconstnot (changed to $ifndef nosetconstnot)
    * released shlmul (changed to $ifndef no shlmul)

  Revision 1.67  1999/06/14 17:47:45  peter
    * merged

  Revision 1.66.2.1  1999/06/14 17:24:40  peter
    * fixed saving of registers with decr_ansistr

  Revision 1.66  1999/06/09 23:22:37  peter
    + del_location

  Revision 1.65  1999/06/09 23:00:11  peter
    * small ansistring fixes
    * val_ansistr_sint destsize changed to longint
    * don't write low/hi ascii with -al

  Revision 1.64  1999/06/02 10:11:39  florian
    * make cycle fixed i.e. compilation with 0.99.10
    * some fixes for qword
    * start of register calling conventions

  Revision 1.63  1999/05/31 20:35:45  peter
    * ansistring fixes, decr_ansistr called after all temp ansi reuses

  Revision 1.62  1999/05/27 19:44:04  peter
    * removed oldasm
    * plabel -> pasmlabel
    * -a switches to source writing automaticly
    * assembler readers OOPed
    * asmsymbol automaticly external
    * jumptables and other label fixes for asm readers

  Revision 1.61  1999/05/25 20:36:11  florian
    * some bugs in the qword code generation fixed

  Revision 1.60  1999/05/23 19:55:10  florian
    * qword/int64 multiplication fixed
    + qword/int64 subtraction

  Revision 1.59  1999/05/19 10:31:53  florian
    * two bugs reported by Romio (bugs 13) are fixed:
        - empty array constructors are now handled correctly (e.g. for sysutils.format)
        - comparsion of ansistrings was sometimes coded wrong

  Revision 1.58  1999/05/18 21:58:22  florian
    * fixed some bugs related to temp. ansistrings and functions results
      which return records/objects/arrays which need init/final.

  Revision 1.57  1999/05/18 14:15:18  peter
    * containsself fixes
    * checktypes()

  Revision 1.56  1999/05/17 21:56:58  florian
    * new temporary ansistring handling

  Revision 1.55  1999/05/10 14:37:49  pierre
   problem with EAX being overwritten before used in A_MULL code fixed

  Revision 1.54  1999/05/09 17:58:42  jonas
    + change "MUL <power of 2>, reg" to SHL (-d ShlMul)
    * do the NOT of a constant set when it's substracted internally
      (-dsetconstnot)

  Revision 1.53  1999/05/01 13:24:01  peter
    * merged nasm compiler
    * old asm moved to oldasm/

  Revision 1.52  1999/04/19 09:39:01  pierre
   * fixes for tempansi

  Revision 1.51  1999/04/16 20:44:34  florian
    * the boolean operators =;<>;xor with LOC_JUMP and LOC_FLAGS
      operands fixed, small things for new ansistring management

  Revision 1.50  1999/04/16 13:42:35  jonas
    * more regalloc fixes (still not complete)

  Revision 1.49  1999/04/16 11:44:24  peter
    * better support for flags result

  Revision 1.48  1999/04/14 09:14:45  peter
    * first things to store the symbol/def number in the ppu

  Revision 1.47  1999/04/12 19:09:08  florian
  * comparsions for small enumerations type are now generated
    correct

  Revision 1.46  1999/03/02 18:21:36  peter
    + flags support for add and case

  Revision 1.45  1999/02/25 21:02:20  peter
    * ag386bin updates
    + coff writer

  Revision 1.44  1999/02/22 02:15:02  peter
    * updates for ag386bin

  Revision 1.43  1999/02/16 00:46:30  peter
    * fixed bug 206

  Revision 1.42  1999/02/12 10:43:56  florian
    * internal error 10 with ansistrings fixed

  Revision 1.41  1999/01/20 19:23:10  jonas
    * fixed set1 <= set2 for small sets

  Revision 1.40  1999/01/20 17:39:22  jonas
    + fixed bug0163 (set1 <= set2 support)

  Revision 1.39  1999/01/19 10:18:58  florian
    * bug with mul. of dwords fixed, reported by Alexander Stohr
    * some changes to compile with TP
    + small enhancements for the new code generator

  Revision 1.38  1999/01/05 17:03:36  jonas
    * don't output inc/dec if cs_check_overflow is on, because inc/dec don't change
      the carry flag

  Revision 1.37  1998/12/22 13:10:56  florian
    * memory leaks for ansistring type casts fixed

  Revision 1.36  1998/12/19 00:23:40  florian
    * ansistring memory leaks fixed

  Revision 1.35  1998/12/11 23:36:06  florian
    + again more stuff for int64/qword:
         - comparision operators
         - code generation for: str, read(ln), write(ln)

  Revision 1.34  1998/12/11 00:02:46  peter
    + globtype,tokens,version unit splitted from globals

  Revision 1.33  1998/12/10 11:16:00  florian
    + some basic operations with qwords and int64 added: +, xor, and, or;
      the register allocation works fine

  Revision 1.32  1998/12/10 09:47:13  florian
    + basic operations with int64/qord (compiler with -dint64)
    + rtti of enumerations extended: names are now written

  Revision 1.31  1998/11/30 09:42:59  pierre
    * some range check bugs fixed (still not working !)
    + added DLL writing support for win32 (also accepts variables)
    + TempAnsi for code that could be used for Temporary ansi strings
      handling

  Revision 1.30  1998/11/24 12:52:40  peter
    * sets are not written twice anymore
    * optimize for emptyset+single element which uses a new routine from
      set.inc FPC_SET_CREATE_ELEMENT

  Revision 1.29  1998/11/18 15:44:05  peter
    * VALUEPARA for tp7 compatible value parameters

  Revision 1.28  1998/11/18 09:18:01  pierre
    + automatic loading of profile unit with -pg option
      in go32v2 mode (also defines FPC_PROFILE)
    * some memory leaks removed
    * unreleased temp problem with sets solved

  Revision 1.27  1998/11/17 00:36:38  peter
    * more ansistring fixes

  Revision 1.26  1998/11/16 16:17:16  peter
    * fixed ansistring temp which forgot a reset

  Revision 1.25  1998/11/16 15:35:35  peter
    * rename laod/copystring -> load/copyshortstring
    * fixed int-bool cnv bug
    + char-ansistring conversion

  Revision 1.24  1998/11/07 12:49:30  peter
    * fixed ansicompare which returns signed

  Revision 1.23  1998/10/29 15:42:43  florian
    + partial disposing of temp. ansistrings

  Revision 1.22  1998/10/28 18:26:12  pierre
   * removed some erros after other errors (introduced by useexcept)
   * stabs works again correctly (for how long !)

  Revision 1.21  1998/10/25 23:32:48  peter
    * fixed unsigned mul

  Revision 1.20  1998/10/21 08:39:56  florian
    + ansistring operator +
    + $h and string[n] for n>255 added
    * small problem with TP fixed

  Revision 1.19  1998/10/20 15:09:21  florian
    + binary operators for ansi strings

  Revision 1.18  1998/10/20 08:06:38  pierre
    * several memory corruptions due to double freemem solved
      => never use p^.loc.location:=p^.left^.loc.location;
    + finally I added now by default
      that ra386dir translates global and unit symbols
    + added a first field in tsymtable and
      a nextsym field in tsym
      (this allows to obtain ordered type info for
      records and objects in gdb !)

  Revision 1.17  1998/10/09 11:47:45  pierre
    * still more memory leaks fixes !!

  Revision 1.16  1998/10/09 08:56:21  pierre
    * several memory leaks fixed

  Revision 1.15  1998/10/08 17:17:10  pierre
    * current_module old scanner tagged as invalid if unit is recompiled
    + added ppheap for better info on tracegetmem of heaptrc
      (adds line column and file index)
    * several memory leaks removed ith help of heaptrc !!

  Revision 1.14  1998/09/28 16:57:13  pierre
    * changed all length(p^.value_str^) into str_length(p)
      to get it work with and without ansistrings
    * changed sourcefiles field of tmodule to a pointer

  Revision 1.13  1998/09/17 09:42:09  peter
    + pass_2 for cg386
    * Message() -> CGMessage() for pass_1/pass_2

  Revision 1.12  1998/09/14 10:43:44  peter
    * all internal RTL functions start with FPC_

  Revision 1.11  1998/09/07 18:45:52  peter
    * update smartlinking, uses getdatalabel
    * renamed ptree.value vars to value_str,value_real,value_set

  Revision 1.10  1998/09/04 10:05:04  florian
    * ugly fix for STRCAT, nevertheless it needs more fixing !!!!!!!
      we need an new version of STRCAT which takes a length parameter

  Revision 1.9  1998/09/04 08:41:36  peter
    * updated some error CGMessages

  Revision 1.8  1998/08/28 10:54:18  peter
    * fixed smallset generation from elements, it has never worked before!

  Revision 1.7  1998/08/19 14:56:59  peter
    * forgot to removed some unused code in addset for set<>set

  Revision 1.6  1998/08/18 09:24:35  pierre
    * small warning position bug fixed
    * support_mmx switches splitting was missing
    * rhide error and warning output corrected

  Revision 1.5  1998/08/14 18:18:37  peter
    + dynamic set contruction
    * smallsets are now working (always longint size)

  Revision 1.4  1998/08/10 14:49:42  peter
    + localswitches, moduleswitches, globalswitches splitting

  Revision 1.3  1998/06/25 08:48:04  florian
    * first version of rtti support

  Revision 1.2  1998/06/08 13:13:28  pierre
    + temporary variables now in temp_gen.pas unit
      because it is processor independent
    * mppc68k.bat modified to undefine i386 and support_mmx
      (which are defaults for i386)

  Revision 1.1  1998/06/05 17:44:10  peter
    * splitted cgi386

}
