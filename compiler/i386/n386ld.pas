{
    $Id$
    Copyright (c) 1998-2000 by Florian Klaempfl

    Generate i386 assembler for load/assignment nodes

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
unit n386ld;

{$i defines.inc}

interface

    uses
      node,nld;

    type
       ti386loadnode = class(tloadnode)
          procedure pass_2;override;
       end;

       ti386assignmentnode = class(tassignmentnode)
          procedure pass_2;override;
       end;

       ti386funcretnode = class(tfuncretnode)
          procedure pass_2;override;
       end;

       ti386arrayconstructornode = class(tarrayconstructornode)
          procedure pass_2;override;
       end;

implementation

    uses
      systems,
      verbose,globals,
      symconst,symtype,symdef,symsym,symtable,aasm,types,
      cgbase,temp_gen,pass_2,
      nmem,ncon,ncnv,
      cpubase,cpuasm,
      cga,tgcpu,n386cnv,n386util,regvars;

{*****************************************************************************
                             SecondLoad
*****************************************************************************}

    procedure ti386loadnode.pass_2;
      var
         hregister : tregister;
         symtabletype : tsymtabletype;
         i : longint;
         hp : preference;
         s : tasmsymbol;
         popeax : boolean;
         //pushed : tpushed;
         //hr : treference;

      begin
         simple_loadn:=true;
         reset_reference(location.reference);
         case symtableentry.typ of
              { this is only for toasm and toaddr }
              absolutesym :
                 begin
                    location.reference.symbol:=nil;
                    if (tabsolutesym(symtableentry).abstyp=toaddr) then
                     begin
                       if tabsolutesym(symtableentry).absseg then
                        location.reference.segment:=R_FS;
                       location.reference.offset:=tabsolutesym(symtableentry).address;
                     end
                    else
                     location.reference.symbol:=newasmsymbol(symtableentry.mangledname);
                 end;
              constsym:
                begin
                   if tconstsym(symtableentry).consttyp=constresourcestring then
                     begin
                        location.loc:=LOC_MEM;
                        location.reference.symbol:=newasmsymbol(tconstsym(symtableentry).owner.name^+'_RESOURCESTRINGLIST');
                        location.reference.offset:=tconstsym(symtableentry).resstrindex*16+8;
                     end
                   else
                     internalerror(22798);
                end;
              varsym :
                 begin
                    hregister:=R_NO;
                    { C variable }
                    if (vo_is_C_var in tvarsym(symtableentry).varoptions) then
                      begin
                         location.reference.symbol:=newasmsymbol(symtableentry.mangledname);
                      end
                    { DLL variable }
                    else if (vo_is_dll_var in tvarsym(symtableentry).varoptions) then
                      begin
                         hregister:=getregister32;
                         location.reference.symbol:=newasmsymbol(symtableentry.mangledname);
                         emit_ref_reg(A_MOV,S_L,newreference(location.reference),hregister);
                         location.reference.symbol:=nil;
                         location.reference.base:=hregister;
                      end
                    { external variable }
                    else if (vo_is_external in tvarsym(symtableentry).varoptions) then
                      begin
                         location.reference.symbol:=newasmsymbol(symtableentry.mangledname);
                      end
                    { thread variable }
                    else if (vo_is_thread_var in tvarsym(symtableentry).varoptions) then
                      begin
                         popeax:=not(R_EAX in unused);
                         if popeax then
                           emit_reg(A_PUSH,S_L,R_EAX);
                         location.reference.symbol:=newasmsymbol(symtableentry.mangledname);
                         emit_ref(A_PUSH,S_L,newreference(location.reference));
                         { the called procedure isn't allowed to change }
                         { any register except EAX                    }
                         emitcall('FPC_RELOCATE_THREADVAR');

                         reset_reference(location.reference);
                         location.reference.base:=getregister32;
                         emit_reg_reg(A_MOV,S_L,R_EAX,location.reference.base);
                         if popeax then
                           emit_reg(A_POP,S_L,R_EAX);

                      end
                    { normal variable }
                    else
                      begin
                         symtabletype:=symtable.symtabletype;
                         { in case it is a register variable: }
                         if tvarsym(symtableentry).reg<>R_NO then
                           begin
                              if tvarsym(symtableentry).reg in [R_ST0..R_ST7] then
                                begin
                                   location.loc:=LOC_CFPUREGISTER;
                                   location.register:=tvarsym(symtableentry).reg;
                                end
                              else
                                if not(makereg32(tvarsym(symtableentry).reg) in [R_EAX..R_EBX]) or
                                   regvar_loaded[tvarsym(symtableentry).reg] then
                                begin
                                   location.loc:=LOC_CREGISTER;
                                   location.register:=tvarsym(symtableentry).reg;
                                   unused:=unused-[tvarsym(symtableentry).reg];
                                end
                              else
                                begin
                                  load_regvar(exprasmlist,tvarsym(symtableentry));
                                  location.loc:=LOC_CREGISTER;
                                  location.register:=tvarsym(symtableentry).reg;
                                  unused:=unused-[tvarsym(symtableentry).reg];
                                end
                           end
                         else
                           begin
                              { first handle local and temporary variables }
                              if (symtabletype in [parasymtable,inlinelocalsymtable,
                                                   inlineparasymtable,localsymtable]) then
                                begin
                                   location.reference.base:=procinfo^.framepointer;
                                   if (symtabletype in [inlinelocalsymtable,
                                                        localsymtable]) then
                                     location.reference.offset:=
                                       tvarsym(symtableentry).address-symtable.address_fixup
                                   else
                                     location.reference.offset:=
                                       tvarsym(symtableentry).address+symtable.address_fixup;

                                   if (symtabletype in [localsymtable,inlinelocalsymtable]) then
                                     begin
                                        if use_esp_stackframe then
                                          dec(location.reference.offset,
                                            tvarsym(symtableentry).getvaluesize)
                                        else
                                          location.reference.offset:=-location.reference.offset;
                                     end;
                                   if (lexlevel>(symtable.symtablelevel)) then
                                     begin
                                        hregister:=getregister32;

                                        { make a reference }
                                        hp:=new_reference(procinfo^.framepointer,
                                          procinfo^.framepointer_offset);

                                        emit_ref_reg(A_MOV,S_L,hp,hregister);

                                        simple_loadn:=false;
                                        i:=lexlevel-1;
                                        while i>(symtable.symtablelevel) do
                                          begin
                                             { make a reference }
                                             hp:=new_reference(hregister,8);
                                             emit_ref_reg(A_MOV,S_L,hp,hregister);
                                             dec(i);
                                          end;
                                        location.reference.base:=hregister;
                                     end;
                                end
                              else
                                case symtabletype of
                                   globalsymtable,
                                   staticsymtable :
                                     begin
                                       location.reference.symbol:=newasmsymbol(symtableentry.mangledname);
                                     end;
                                   stt_exceptsymtable:
                                     begin
                                        location.reference.base:=procinfo^.framepointer;
                                        location.reference.offset:=tvarsym(symtableentry).address;
                                     end;
                                   objectsymtable:
                                     begin
                                        getexplicitregister32(R_ESI);
                                        if (sp_static in tvarsym(symtableentry).symoptions) then
                                          begin
                                             location.reference.symbol:=newasmsymbol(symtableentry.mangledname);
                                          end
                                        else
                                          begin
                                             location.reference.base:=R_ESI;
                                             location.reference.offset:=tvarsym(symtableentry).address;
                                          end;
                                     end;
                                   withsymtable:
                                     begin
                                        { make a reference }
                                        { symtable datasize field
                                          contains the offset of the temp
                                          stored }
{                                       hp:=new_reference(procinfo^.framepointer,
                                          symtable.datasize);

                                        emit_ref_reg(A_MOV,S_L,hp,hregister);}

                                        if nf_islocal in tnode(twithsymtable(symtable).withnode).flags then
                                         begin
                                           location.reference:=twithnode(twithsymtable(symtable).withnode).withreference^;
                                         end
                                        else
                                         begin
                                           hregister:=getregister32;
                                           location.reference.base:=hregister;
                                           emit_ref_reg(A_MOV,S_L,
                                             newreference(twithnode(twithsymtable(symtable).withnode).withreference^),
                                             hregister);
                                         end;
                                        inc(location.reference.offset,tvarsym(symtableentry).address);
                                     end;
                                end;
                           end;
                         { in case call by reference, then calculate. Open array
                           is always an reference! }
                         if (tvarsym(symtableentry).varspez in [vs_var,vs_out]) or
                            is_open_array(tvarsym(symtableentry).vartype.def) or
                            is_array_of_const(tvarsym(symtableentry).vartype.def) or
                            ((tvarsym(symtableentry).varspez=vs_const) and
                             push_addr_param(tvarsym(symtableentry).vartype.def)) then
                           begin
                              simple_loadn:=false;
                              if hregister=R_NO then
                                hregister:=getregister32;
                              if location.loc=LOC_CREGISTER then
                                begin
                                   emit_reg_reg(A_MOV,S_L,
                                     location.register,hregister);
                                   location.loc:=LOC_REFERENCE;
                                end
                              else
                                begin
                                   emit_ref_reg(A_MOV,S_L,
                                     newreference(location.reference),
                                     hregister);
                                end;
                              reset_reference(location.reference);
                              location.reference.base:=hregister;
                          end;
                      end;
                 end;
              procsym:
                 begin
                    if assigned(left) then
                      begin
                         location.loc:=LOC_MEM;
                         gettempofsizereference(8,location.reference);
                         if left.nodetype=typen then
                          begin
                            if left.resulttype.def.deftype<>objectdef then
                             internalerror(200103261);
                            getexplicitregister32(R_EDI);
                            hregister:=R_EDI;
                            new(hp);
                            emit_sym_ofs_reg(A_MOV,S_L,
                              newasmsymbol(tobjectdef(left.resulttype.def).vmt_mangledname),0,R_EDI);
                          end
                         else
                          begin
                            secondpass(left);

                            { load class instance address }
                            case left.location.loc of

                               LOC_CREGISTER,
                               LOC_REGISTER:
                                 begin
                                    hregister:=left.location.register;
                                    ungetregister32(left.location.register);
                                    if is_object(left.resulttype.def) then
                                      CGMessage(cg_e_illegal_expression);
                                 end;

                               LOC_MEM,
                               LOC_REFERENCE:
                                 begin
                                    getexplicitregister32(R_EDI);
                                    hregister:=R_EDI;
                                    if is_class_or_interface(left.resulttype.def) then
                                      emit_ref_reg(A_MOV,S_L,
                                        newreference(left.location.reference),R_EDI)
                                    else
                                      emit_ref_reg(A_LEA,S_L,
                                        newreference(left.location.reference),R_EDI);
                                    del_reference(left.location.reference);
                                    ungetiftemp(left.location.reference);
                                 end;
                               else internalerror(26019);
                            end;
                          end;

                         { store the class instance address }
                         new(hp);
                         hp^:=location.reference;
                         inc(hp^.offset,4);
                         emit_reg_ref(A_MOV,S_L,
                           hregister,hp);

                         { virtual method ? }
                         if (po_virtualmethod in tprocsym(symtableentry).definition.procoptions) then
                           begin
                              new(hp);
                              reset_reference(hp^);
                              hp^.base:=hregister;
                              { load vmt pointer }
                              emit_ref_reg(A_MOV,S_L,
                                hp,R_EDI);
{$IfDef regallocfix}
                              del_reference(hp^);
{$EndIf regallocfix}
                              { load method address }
                              new(hp);
                              reset_reference(hp^);
                              hp^.base:=R_EDI;
                              hp^.offset:=tprocsym(symtableentry).definition._class.vmtmethodoffset(
                                tprocsym(symtableentry).definition.extnumber);
                              emit_ref_reg(A_MOV,S_L,
                                hp,R_EDI);
                              { ... and store it }
                              emit_reg_ref(A_MOV,S_L,
                                R_EDI,newreference(location.reference));
                              ungetregister32(R_EDI);
                           end
                         else
                           begin
                              ungetregister32(R_EDI);
                              s:=newasmsymbol(tprocsym(symtableentry).definition.mangledname);
                              emit_sym_ofs_ref(A_MOV,S_L,s,0,
                                newreference(location.reference));
                           end;
                      end
                    else
                      begin
                         {!!!!! Be aware, work on virtual methods too }
                         location.reference.symbol:=newasmsymbol(tprocsym(symtableentry).definition.mangledname);
                      end;
                 end;
              typedconstsym :
                 begin
                    location.reference.symbol:=newasmsymbol(symtableentry.mangledname);
                 end;
              else internalerror(4);
         end;
      end;


{*****************************************************************************
                             SecondAssignment
*****************************************************************************}

    procedure ti386assignmentnode.pass_2;
      var
         opsize : topsize;
         otlabel,hlabel,oflabel : tasmlabel;
         fputyp : tfloattype;
         loc : tloc;
         r : preference;
         ai : taicpu;
         op : tasmop;
         pushed : boolean;
         regspushed : tpushed;
         regs_to_push: byte;
         ungettemp : boolean;

      begin
         otlabel:=truelabel;
         oflabel:=falselabel;
         getlabel(truelabel);
         getlabel(falselabel);
         { calculate left sides }
         { don't do it yet if it's a crgister (JM) }
         if not(nf_concat_string in flags) then
           secondpass(left);

         if codegenerror then
           exit;

         if not(left.location.loc in [LOC_REFERENCE,LOC_CFPUREGISTER,
           LOC_CREGISTER,LOC_CMMXREGISTER]) then
           begin
              CGMessage(cg_e_illegal_expression);
              exit;
           end;


         loc:=left.location.loc;
         { lets try to optimize this (PM)            }
         { define a dest_loc that is the location      }
         { and a ptree to verify that it is the right }
         { place to insert it                    }
{$ifdef test_dest_loc}
         if (aktexprlevel<4) then
           begin
              dest_loc_known:=true;
              dest_loc:=left.location;
              dest_loc_tree:=right;
           end;
{$endif test_dest_loc}

         { left can't be never a 64 bit LOC_REGISTER, so the 3. arg }
         { can be false                                             }
         pushed:=maybe_push(right.registers32,left,false);
         secondpass(right);

         { restoring here is nonsense for LOC_JMP !! }
         { This generated code that was after a jmp and before any
           label => unreachable !!
           Could this be tested somehow ?? PM }
         if pushed and (right.location.loc <>LOC_JUMP) then
           restore(left,false);

         if codegenerror then
           exit;

{$ifdef test_dest_loc}
         dest_loc_known:=false;
         if in_dest_loc then
           begin
              truelabel:=otlabel;
              falselabel:=oflabel;
              in_dest_loc:=false;
              exit;
           end;
{$endif test_dest_loc}
         if left.resulttype.def.deftype=stringdef then
           begin
              if is_ansistring(left.resulttype.def) or
                is_widestring(left.resulttype.def) then
                begin
                  { before pushing any parameter, we have to save all used      }
                  { registers, but before that we have to release the       }
                  { registers of that node to save uneccessary pushed       }
                  { so be careful, if you think you can optimize that code (FK) }

                  { nevertheless, this has to be changed, because otherwise the }
                  { register is released before it's contents are pushed ->     }
                  { problems with the optimizer (JM)                            }
                  del_reference(left.location.reference);
                  ungettemp:=false;
                  { Find out which registers have to be pushed (JM) }
                  regs_to_push := $ff;
                  remove_non_regvars_from_loc(right.location,regs_to_push);
                  { And push them (JM) }
                  pushusedregisters(regspushed,regs_to_push);
                  case right.location.loc of
                     LOC_REGISTER,LOC_CREGISTER:
                       begin
                          exprasmList.concat(Taicpu.Op_reg(A_PUSH,S_L,right.location.register));
                          ungetregister32(right.location.register);
                       end;
                     LOC_REFERENCE,LOC_MEM:
                       begin
                          { First release the registers because emit_push_mem may  }
                          { load the reference in edi before pushing and then the  }
                          { dealloc is too late (and optimizations are missed (JM) }
                          del_reference(right.location.reference);
                          { This one doesn't need extra registers (JM) }
                          emit_push_mem(right.location.reference);
                          ungettemp:=true;
                       end;
                  end;
                  emitpushreferenceaddr(left.location.reference);
                  del_reference(left.location.reference);
                  saveregvars($ff);
                  if is_ansistring(left.resulttype.def) then
                    emitcall('FPC_ANSISTR_ASSIGN')
                  else
                    emitcall('FPC_WIDESTR_ASSIGN');
                  maybe_loadself;
                  popusedregisters(regspushed);
                  if ungettemp then
                    ungetiftemp(right.location.reference);
                end
              else
              if is_shortstring(left.resulttype.def) and
                not (nf_concat_string in flags) then
                begin
                  if is_ansistring(right.resulttype.def) then
                    begin
                      if (right.nodetype=stringconstn) and
                         (tstringconstnode(right).len=0) then
                        begin
                          emit_const_ref(A_MOV,S_B,
                            0,newreference(left.location.reference));
                          del_reference(left.location.reference);
                        end
                      else
                        loadansi2short(right,left);
                    end
                  else
                    begin
                       { we do not need destination anymore }
                       del_reference(left.location.reference);
                       {del_reference(right.location.reference);
                        done in loadshortstring }
                       loadshortstring(right,left);
                       ungetiftemp(right.location.reference);
                    end;
                end
              else if is_longstring(left.resulttype.def) then
                begin
                   internalerror(200105261);
                end
              else
                begin
                  { its the only thing we have to do }
                  del_reference(right.location.reference);
                end
           end
        else if is_interfacecom(left.resulttype.def) then
          begin
             loadinterfacecom(self);
          end
        else case right.location.loc of
            LOC_REFERENCE,
            LOC_MEM : begin
                         { extra handling for ordinal constants }
                         if (right.nodetype in [ordconstn,pointerconstn,niln]) or
                            (loc=LOC_CREGISTER) then
                           begin
                              case left.resulttype.def.size of
                                 1 : opsize:=S_B;
                                 2 : opsize:=S_W;
                                 4 : opsize:=S_L;
                                 { S_L is correct, the copy is done }
                                 { with two moves                   }
                                 8 : opsize:=S_L;
                              end;
                              if loc=LOC_CREGISTER then
                                begin
                                  emit_ref_reg(A_MOV,opsize,
                                    newreference(right.location.reference),
                                    left.location.register);
                                  if left.resulttype.def.size=8 then
                                    begin
                                       r:=newreference(right.location.reference);
                                       inc(r^.offset,4);
                                       emit_ref_reg(A_MOV,opsize,r,
                                         left.location.registerhigh);
                                    end;
{$IfDef regallocfix}
                                  del_reference(right.location.reference);
{$EndIf regallocfix}
                                end
                              else
                                begin
                                  if left.resulttype.def.size=8 then
                                    begin
                                       emit_const_ref(A_MOV,opsize,
                                         longint(lo(tordconstnode(right).value)),
                                         newreference(left.location.reference));
                                       r:=newreference(left.location.reference);
                                       inc(r^.offset,4);
                                       emit_const_ref(A_MOV,opsize,
                                         longint(hi(tordconstnode(right).value)),r);
                                    end
                                  else
                                    begin
                                       emit_const_ref(A_MOV,opsize,
                                         right.location.reference.offset,
                                         newreference(left.location.reference));
                                    end;
{$IfDef regallocfix}
                                  del_reference(left.location.reference);
{$EndIf regallocfix}
                                {emit_const_loc(A_MOV,opsize,
                                    right.location.reference.offset,
                                    left.location);}
                                end;

                           end
                         else if loc=LOC_CFPUREGISTER then
                           begin
                              floatloadops(tfloatdef(right.resulttype.def).typ,op,opsize);
                              emit_ref(op,opsize,
                                newreference(right.location.reference));
                              emit_reg(A_FSTP,S_NO,
                                correct_fpuregister(left.location.register,fpuvaroffset+1));
                           end
                         else
                           begin
                              if (right.resulttype.def.needs_inittable) then
                                begin
                                   { this would be a problem }
                                   if not(left.resulttype.def.needs_inittable) then
                                     internalerror(3457);

                                   { increment source reference counter }
                                   new(r);
                                   reset_reference(r^);
                                   r^.symbol:=tstoreddef(right.resulttype.def).get_rtti_label(initrtti);
                                   emitpushreferenceaddr(r^);

                                   emitpushreferenceaddr(right.location.reference);
                                   emitcall('FPC_ADDREF');
                                   { decrement destination reference counter }
                                   new(r);
                                   reset_reference(r^);
                                   r^.symbol:=tstoreddef(left.resulttype.def).get_rtti_label(initrtti);
                                   emitpushreferenceaddr(r^);
                                   emitpushreferenceaddr(left.location.reference);
                                   emitcall('FPC_DECREF');
                                end;

{$ifdef regallocfix}
                              concatcopy(right.location.reference,
                                left.location.reference,left.resulttype.def.size,true,false);
                              ungetiftemp(right.location.reference);
{$Else regallocfix}
                              concatcopy(right.location.reference,
                                left.location.reference,left.resulttype.def.size,false,false);
                              ungetiftemp(right.location.reference);
{$endif regallocfix}
                           end;
                      end;
{$ifdef SUPPORT_MMX}
            LOC_CMMXREGISTER,
            LOC_MMXREGISTER:
              begin
                 if loc=LOC_CMMXREGISTER then
                   emit_reg_reg(A_MOVQ,S_NO,
                   right.location.register,left.location.register)
                 else
                   emit_reg_ref(A_MOVQ,S_NO,
                     right.location.register,newreference(left.location.reference));
              end;
{$endif SUPPORT_MMX}
            LOC_REGISTER,
            LOC_CREGISTER : begin
                              case right.resulttype.def.size of
                                 1 : opsize:=S_B;
                                 2 : opsize:=S_W;
                                 4 : opsize:=S_L;
                                 8 : opsize:=S_L;
                              end;
                              { simplified with op_reg_loc       }
                              if loc=LOC_CREGISTER then
                                begin
                                  emit_reg_reg(A_MOV,opsize,
                                    right.location.register,
                                    left.location.register);
                                 ungetregister(right.location.register);
                                end
                              else
                                Begin
                                  emit_reg_ref(A_MOV,opsize,
                                    right.location.register,
                                    newreference(left.location.reference));
                                  ungetregister(right.location.register);
{$IfDef regallocfix}
                                  del_reference(left.location.reference);
{$EndIf regallocfix}
                                end;
                              if is_64bitint(right.resulttype.def) then
                                begin
                                   { simplified with op_reg_loc  }
                                   if loc=LOC_CREGISTER then
                                     emit_reg_reg(A_MOV,opsize,
                                       right.location.registerhigh,
                                       left.location.registerhigh)
                                   else
                                     begin
                                        r:=newreference(left.location.reference);
                                        inc(r^.offset,4);
                                        emit_reg_ref(A_MOV,opsize,
                                          right.location.registerhigh,r);
                                     end;
                                end;
                              {emit_reg_loc(A_MOV,opsize,
                                  right.location.register,
                                  left.location);      }

                           end;
            LOC_FPU : begin
                              if (left.resulttype.def.deftype=floatdef) then
                               fputyp:=tfloatdef(left.resulttype.def).typ
                              else
                               if (right.resulttype.def.deftype=floatdef) then
                                fputyp:=tfloatdef(right.resulttype.def).typ
                              else
                               if (right.nodetype=typeconvn) and
                                  (ttypeconvnode(right).left.resulttype.def.deftype=floatdef) then
                                fputyp:=tfloatdef(ttypeconvnode(right).left.resulttype.def).typ
                              else
                                fputyp:=s32real;
                              case loc of
                                 LOC_CFPUREGISTER:
                                   begin
                                      emit_reg(A_FSTP,S_NO,
                                        correct_fpuregister(left.location.register,fpuvaroffset));
                                      dec(fpuvaroffset);
                                   end;
                                 LOC_REFERENCE:
                                   floatstore(fputyp,left.location.reference);
                                 else
                                   internalerror(48991);
                              end;
                           end;
            LOC_CFPUREGISTER: begin
                              if (left.resulttype.def.deftype=floatdef) then
                               fputyp:=tfloatdef(left.resulttype.def).typ
                              else
                               if (right.resulttype.def.deftype=floatdef) then
                                fputyp:=tfloatdef(right.resulttype.def).typ
                              else
                               if (right.nodetype=typeconvn) and
                                  (ttypeconvnode(right).left.resulttype.def.deftype=floatdef) then
                                fputyp:=tfloatdef(ttypeconvnode(right).left.resulttype.def).typ
                              else
                                fputyp:=s32real;
                              emit_reg(A_FLD,S_NO,
                                correct_fpuregister(right.location.register,fpuvaroffset));
                              inc(fpuvaroffset);
                              case loc of
                                 LOC_CFPUREGISTER:
                                   begin
                                      emit_reg(A_FSTP,S_NO,
                                        correct_fpuregister(right.location.register,fpuvaroffset));
                                      dec(fpuvaroffset);
                                   end;
                                 LOC_REFERENCE:
                                   floatstore(fputyp,left.location.reference);
                                 else
                                   internalerror(48992);
                              end;
                           end;
            LOC_JUMP     : begin
                              opsize:=def_opsize(left.resulttype.def);
                              getlabel(hlabel);
                              emitlab(truelabel);
                              if pushed then
                                restore(left,false);
                              if loc=LOC_CREGISTER then
                                emit_const_reg(A_MOV,opsize,
                                  1,left.location.register)
                              else
                                emit_const_ref(A_MOV,opsize,
                                  1,newreference(left.location.reference));
                              emitjmp(C_None,hlabel);
                              emitlab(falselabel);
                              if pushed then
                                restore(left,false);
                              if loc=LOC_CREGISTER then
                                emit_reg_reg(A_XOR,opsize,
                                  left.location.register,
                                  left.location.register)
                              else
                                begin
                                  emit_const_ref(A_MOV,opsize,
                                    0,newreference(left.location.reference));
{$IfDef regallocfix}
                                  del_reference(left.location.reference);
{$EndIf regallocfix}
                                 end;
                              emitlab(hlabel);
                           end;
            LOC_FLAGS    : begin
                              if loc=LOC_CREGISTER then
                                emit_flag2reg(right.location.resflags,left.location.register)
                              else
                                begin
                                  ai:=Taicpu.Op_ref(A_Setcc,S_B,newreference(left.location.reference));
                                  ai.SetCondition(flag_2_cond[right.location.resflags]);
                                  exprasmList.concat(ai);
                                end;
{$IfDef regallocfix}
                              del_reference(left.location.reference);
{$EndIf regallocfix}
                           end;
         end;
         truelabel:=otlabel;
         falselabel:=oflabel;
      end;


{*****************************************************************************
                             SecondFuncRet
*****************************************************************************}

    procedure ti386funcretnode.pass_2;
      var
         hr : tregister;
         hp : preference;
         pp : pprocinfo;
         hr_valid : boolean;
         i : integer;
      begin
         reset_reference(location.reference);
         hr_valid:=false;
         if (not inlining_procedure) and
            (lexlevel<>funcretsym.owner.symtablelevel) then
           begin
              hr:=getregister32;
              hr_valid:=true;
              hp:=new_reference(procinfo^.framepointer,procinfo^.framepointer_offset);
              emit_ref_reg(A_MOV,S_L,hp,hr);

              { walk up the stack frame }
              pp:=procinfo^.parent;
              i:=lexlevel-1;
              while i>funcretsym.owner.symtablelevel do
               begin
                 hp:=new_reference(hr,pp^.framepointer_offset);
                 emit_ref_reg(A_MOV,S_L,hp,hr);
                 pp:=pp^.parent;
                 dec(i);
               end;
              location.reference.base:=hr;
              location.reference.offset:=pp^.return_offset;
           end
         else
           begin
             location.reference.base:=procinfo^.framepointer;
             location.reference.offset:=procinfo^.return_offset;
           end;
         if ret_in_param(resulttype.def) then
           begin
              if not hr_valid then
                hr:=getregister32;
              emit_ref_reg(A_MOV,S_L,newreference(location.reference),hr);
              location.reference.base:=hr;
              location.reference.offset:=0;
           end;
      end;


{*****************************************************************************
                           SecondArrayConstruct
*****************************************************************************}

      const
        vtInteger    = 0;
        vtBoolean    = 1;
        vtChar       = 2;
        vtExtended   = 3;
        vtString     = 4;
        vtPointer    = 5;
        vtPChar      = 6;
        vtObject     = 7;
        vtClass      = 8;
        vtWideChar   = 9;
        vtPWideChar  = 10;
        vtAnsiString = 11;
        vtCurrency   = 12;
        vtVariant    = 13;
        vtInterface  = 14;
        vtWideString = 15;
        vtInt64      = 16;
        vtQWord      = 17;

    procedure ti386arrayconstructornode.pass_2;
      var
        hp    : tarrayconstructornode;
        href  : treference;
        lt    : tdef;
        vaddr : boolean;
        vtype : longint;
        freetemp,
        dovariant : boolean;
        elesize : longint;
      begin
        dovariant:=(nf_forcevaria in flags) or tarraydef(resulttype.def).isvariant;
        if dovariant then
         elesize:=8
        else
         elesize:=tarraydef(resulttype.def).elesize;
        if not(nf_cargs in flags) then
         begin
           reset_reference(location.reference);
           { Allocate always a temp, also if no elements are required, to
             be sure that location is valid (PFV) }
            if tarraydef(resulttype.def).highrange=-1 then
              gettempofsizereference(elesize,location.reference)
            else
              gettempofsizereference((tarraydef(resulttype.def).highrange+1)*elesize,location.reference);
           href:=location.reference;
         end;
        hp:=self;
        while assigned(hp) do
         begin
           if assigned(hp.left) then
            begin
              freetemp:=true;
              secondpass(hp.left);
              if codegenerror then
               exit;
              if dovariant then
               begin
                 { find the correct vtype value }
                 vtype:=$ff;
                 vaddr:=false;
                 lt:=hp.left.resulttype.def;
                 case lt.deftype of
                   enumdef,
                   orddef :
                     begin
                       if is_64bitint(lt) then
                         begin
                            case torddef(lt).typ of
                               s64bit:
                                 vtype:=vtInt64;
                               u64bit:
                                 vtype:=vtQWord;
                            end;
                            freetemp:=false;
                            vaddr:=true;
                         end
                       else if (lt.deftype=enumdef) or
                         is_integer(lt) then
                         vtype:=vtInteger
                       else
                         if is_boolean(lt) then
                           vtype:=vtBoolean
                         else
                           if (lt.deftype=orddef) and (torddef(lt).typ=uchar) then
                             vtype:=vtChar;
                     end;
                   floatdef :
                     begin
                       vtype:=vtExtended;
                       vaddr:=true;
                       freetemp:=false;
                     end;
                   procvardef,
                   pointerdef :
                     begin
                       if is_pchar(lt) then
                         vtype:=vtPChar
                       else
                         vtype:=vtPointer;
                     end;
                   classrefdef :
                     vtype:=vtClass;
                   objectdef :
                     begin
                       vtype:=vtObject;
                     end;
                   stringdef :
                     begin
                       if is_shortstring(lt) then
                        begin
                          vtype:=vtString;
                          vaddr:=true;
                          freetemp:=false;
                        end
                       else
                        if is_ansistring(lt) then
                         begin
                           vtype:=vtAnsiString;
                           freetemp:=false;
                         end;
                     end;
                 end;
                 if vtype=$ff then
                   internalerror(14357);
                 { write C style pushes or an pascal array }
                 if nf_cargs in flags then
                  begin
                    if vaddr then
                     begin
                       emit_to_mem(hp.left.location,hp.left.resulttype.def);
                       emit_push_lea_loc(hp.left.location,freetemp);
                       del_reference(hp.left.location.reference);
                     end
                    else
                     emit_push_loc(hp.left.location);
                    inc(pushedparasize,4);
                  end
                 else
                  begin
                    { write changing field update href to the next element }
                    inc(href.offset,4);
                    if vaddr then
                     begin
                       emit_to_mem(hp.left.location,hp.left.resulttype.def);
                       emit_lea_loc_ref(hp.left.location,href,freetemp);
                     end
                    else
                     begin
                       emit_mov_loc_ref(hp.left.location,href,S_L,freetemp);
                     end;
                    { update href to the vtype field and write it }
                    dec(href.offset,4);
                    emit_const_ref(A_MOV,S_L,vtype,newreference(href));
                    { goto next array element }
                    inc(href.offset,8);
                  end;
               end
              else
              { normal array constructor of the same type }
               begin
                 case elesize of
                   1 :
                     emit_mov_loc_ref(hp.left.location,href,S_B,freetemp);
                   2 :
                     emit_mov_loc_ref(hp.left.location,href,S_W,freetemp);
                   4 :
                     emit_mov_loc_ref(hp.left.location,href,S_L,freetemp);
                   8 :
                     begin
                       if hp.left.location.loc in [LOC_REGISTER,LOC_CREGISTER] then
                        begin
                          emit_reg_ref(A_MOV,S_L,hp.left.location.registerlow,newreference(href));
                          { update href to the high bytes and write it }
                          inc(href.offset,4);
                          emit_reg_ref(A_MOV,S_L,hp.left.location.registerhigh,newreference(href));
                          dec(href.offset,4)
                        end
                       else
                        concatcopy(hp.left.location.reference,href,elesize,freetemp,false);
                     end;
                   else
                     begin
                       { concatcopy only supports reference }
                       if not(hp.left.location.loc in [LOC_MEM,LOC_REFERENCE]) then
                        internalerror(200108012);
                       concatcopy(hp.left.location.reference,href,elesize,freetemp,false);
                     end;
                 end;
                 inc(href.offset,elesize);
               end;
            end;
           { load next entry }
           hp:=tarrayconstructornode(hp.right);
         end;
      end;

begin
   cloadnode:=ti386loadnode;
   cassignmentnode:=ti386assignmentnode;
   cfuncretnode:=ti386funcretnode;
   carrayconstructornode:=ti386arrayconstructornode;
end.
{
  $Log$
  Revision 1.21  2001-08-30 20:13:57  peter
    * rtti/init table updates
    * rttisym for reusable global rtti/init info
    * support published for interfaces

  Revision 1.20  2001/08/30 11:57:20  michael
  + Patch for wrong paramsize

  Revision 1.19  2001/08/26 13:36:59  florian
    * some cg reorganisation
    * some PPC updates

  Revision 1.18  2001/08/06 21:40:50  peter
    * funcret moved from tprocinfo to tprocdef

  Revision 1.17  2001/08/05 13:19:51  peter
    * partly fix for proc of obj=nil

  Revision 1.15  2001/07/28 15:13:17  peter
    * fixed opsize for assignment with LOC_JUMP

  Revision 1.14  2001/05/27 14:30:56  florian
    + some widestring stuff added

  Revision 1.13  2001/04/13 01:22:19  peter
    * symtable change to classes
    * range check generation and errors fixed, make cycle DEBUG=1 works
    * memory leaks fixed

  Revision 1.12  2001/04/02 21:20:37  peter
    * resulttype rewrite

  Revision 1.11  2000/12/25 00:07:33  peter
    + new tlinkedlist class (merge of old tstringqueue,tcontainer and
      tlinkedlist objects)

  Revision 1.10  2000/12/05 11:44:33  jonas
    + new integer regvar handling, should be much more efficient

  Revision 1.9  2000/11/29 00:30:48  florian
    * unused units removed from uses clause
    * some changes for widestrings

  Revision 1.8  2000/11/13 14:44:36  jonas
    * fixes so no more range errors with improved range checking code

  Revision 1.7  2000/11/12 23:24:15  florian
    * interfaces are basically running

  Revision 1.6  2000/11/11 22:59:20  florian
    * fixed resourcestrings, made a stupid mistake yesterday

  Revision 1.5  2000/11/09 18:52:06  florian
    * resourcestrings doesn't need the helper anymore they
      access the table now direct

  Revision 1.4  2000/11/06 23:15:02  peter
    * added copyvaluepara call again

  Revision 1.3  2000/11/04 14:25:23  florian
    + merged Attila's changes for interfaces, not tested yet

  Revision 1.2  2000/10/31 22:02:56  peter
    * symtable splitted, no real code changes

  Revision 1.1  2000/10/15 09:33:31  peter
    * moved n386*.pas to i386/ cpu_target dir

  Revision 1.1  2000/10/14 10:14:49  peter
    * moehrendorf oct 2000 rewrite

}
