{
    $Id$
    Copyright (c) 1998-2000 by Florian Klaempfl

    Generate assembler for memory related nodes which are
    the same for all (most?) processors

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
unit ncgmem;

{$i defines.inc}

interface

    uses
      node,nmem;

    type
       tcgloadvmtnode = class(tloadvmtnode)
          procedure pass_2;override;
       end;

       tcghnewnode = class(thnewnode)
          procedure pass_2;override;
       end;

       tcghdisposenode = class(thdisposenode)
          procedure pass_2;override;
       end;

       tcgaddrnode = class(taddrnode)
          procedure pass_2;override;
       end;

       tcgdoubleaddrnode = class(tdoubleaddrnode)
          procedure pass_2;override;
       end;

       tcgderefnode = class(tderefnode)
          procedure pass_2;override;
       end;

       tcgsubscriptnode = class(tsubscriptnode)
          procedure pass_2;override;
       end;

       tcgselfnode = class(tselfnode)
          procedure pass_2;override;
       end;

       tcgwithnode = class(twithnode)
          procedure pass_2;override;
       end;

implementation

    uses
{$ifdef delphi}
      sysutils,
{$else}
      strings,
{$endif}
{$ifdef GDB}
      gdb,
{$endif GDB}
      globtype,systems,
      cutils,verbose,globals,
      symconst,symbase,symdef,symsym,aasm,
      cgbase,temp_gen,pass_2,
      nld,ncon,nadd,
      cpubase,cgobj,cgcpu,
      cga,tgcpu;

{*****************************************************************************
                            TCGLOADNODE
*****************************************************************************}

    procedure tcgloadvmtnode.pass_2;

      begin
         location.register:=getregister32;
         cg.a_load_sym_ofs_reg(exprasmlist,
           newasmsymbol(tobjectdef(tclassrefdef(resulttype.def).pointertype.def).vmt_mangledname),
           0,location.register);
      end;


{*****************************************************************************
                            TCGHNEWNODE
*****************************************************************************}

    procedure tcghnewnode.pass_2;
      begin
      end;


{*****************************************************************************
                         TCGHDISPOSENODE
*****************************************************************************}

    procedure tcghdisposenode.pass_2;
      begin
         secondpass(left);
         if codegenerror then
           exit;
        { is this already set somewhere else? It wasn't present in the }
        { original i386 code either (JM)                               }
        { location.loc := LOC_REFERENCE;                               }
         reset_reference(location.reference);
         case left.location.loc of
            LOC_REGISTER:
              begin
                if not isaddressregister(left.location.register) then
                  begin
                    ungetregister(left.location.register);
                    location.reference.index := getaddressregister;
                    cg.a_load_reg_reg(exprasmlist,OS_ADDR,left.location.register,
                      location.reference.index);
                  end
                else
                  location.reference.index := left.location.register;
              end;
            LOC_CREGISTER,LOC_MEM,LOC_REFERENCE:
              begin
                 del_location(left.location);
                 location.reference.index:=getaddressregister;
                 cg.a_load_loc_reg(exprasmlist,OS_ADDR,left.location,
                   location.reference.index);
              end;
         end;
      end;


{*****************************************************************************
                             TCGADDRNODE
*****************************************************************************}

    procedure tcgaddrnode.pass_2;
      begin
         secondpass(left);

         { when loading procvar we do nothing with this node, so load the
           location of left }
         if nf_procvarload in flags then
          begin
            set_location(location,left.location);
            exit;
          end;

         location.loc:=LOC_REGISTER;
         del_reference(left.location.reference);
         location.register:=getaddressregister;
         {@ on a procvar means returning an address to the procedure that
           is stored in it.}
         { yes but left.symtableentry can be nil
           for example on self !! }
         { symtableentry can be also invalid, if left is no tree node }
         if (m_tp_procvar in aktmodeswitches) and
            (left.nodetype=loadn) and
            assigned(tloadnode(left).symtableentry) and
            (tloadnode(left).symtableentry.typ=varsym) and
            (tvarsym(tloadnode(left).symtableentry).vartype.def.deftype=procvardef) then
           cg.a_load_ref_reg(exprasmlist,OS_ADDR,left.location.reference,
             location.register)
         else
           cg.a_loadaddress_ref_reg(exprasmlist,left.location.reference,
             location.register);
      end;


{*****************************************************************************
                         TCGDOUBLEADDRNODE
*****************************************************************************}

    procedure tcgdoubleaddrnode.pass_2;
      begin
         secondpass(left);
         location.loc:=LOC_REGISTER;
         del_reference(left.location.reference);
         location.register:=getaddressregister;
         cg.a_loadaddress_ref_reg(exprasmlist,left.location.reference,
           location.register);
      end;


{*****************************************************************************
                           TCGDEREFNODE
*****************************************************************************}

    procedure tcgderefnode.pass_2;

      begin
         secondpass(left);
         reset_reference(location.reference);
         case left.location.loc of
            LOC_REGISTER:
              begin
                if not isaddressregister(left.location.register) then
                  begin
                    ungetregister(left.location.register);
                    location.reference.base := getaddressregister;
                    cg.a_load_reg_reg(exprasmlist,OS_ADDR,left.location.register,
                      location.reference.base);
                  end
                else
                  location.reference.base := left.location.register;
              end;
            LOC_CREGISTER,LOC_MEM,LOC_REFERENCE:
              begin
                 del_location(left.location);
                 location.reference.base:=getaddressregister;
                 cg.a_load_loc_reg(exprasmlist,OS_ADDR,left.location,
                   location.reference.base);
              end;
         end;
         { still needs generic checkpointer() support! }
      end;


{*****************************************************************************
                          TCGSUBSCRIPTNODE
*****************************************************************************}

    procedure tcgsubscriptnode.pass_2;

      begin
         secondpass(left);
         if codegenerror then
           exit;
         { classes and interfaces must be dereferenced implicit }
         if is_class_or_interface(left.resulttype.def) then
           begin
             reset_reference(location.reference);
             case left.location.loc of
                LOC_REGISTER:
                  begin
                    if not isaddressregister(left.location.register) then
                      begin
                        ungetregister(left.location.register);
                        location.reference.base := getaddressregister;
                        cg.a_load_reg_reg(exprasmlist,OS_ADDR,
                          left.location.register,location.reference.base);
                      end
                    else
                      location.reference.base := left.location.register;
                  end;
                LOC_CREGISTER,LOC_MEM,LOC_REFERENCE:
                  begin
                     del_location(left.location);
                     location.reference.base:=getaddressregister;
                     cg.a_load_loc_reg(exprasmlist,OS_ADDR,left.location,
                       location.reference.base);
                  end;
             end;
           end
         else if is_interfacecom(left.resulttype.def) then
           begin
              gettempintfcomreference(location.reference);
              cg.a_load_loc_ref(exprasmlist,OS_ADDR,left.location,
                location.reference);
           end
         else
           set_location(location,left.location);

        { is this already set somewhere else? It wasn't present in the }
        { original i386 code either (JM)                               }
        { location.loc := LOC_REFERENCE;                               }
         inc(location.reference.offset,vs.address);
      end;

{*****************************************************************************
                            TCGSELFNODE
*****************************************************************************}

    procedure tcgselfnode.pass_2;
      begin
         reset_reference(location.reference);
         getexplicitregister32(SELF_POINTER);
         if (resulttype.def.deftype=classrefdef) or
           is_class(resulttype.def) then
          begin
            location.loc := LOC_CREGISTER;
            location.register:=SELF_POINTER;
          end
         else
           begin
             location.loc := LOC_REFERENCE;
             location.reference.base:=SELF_POINTER;
           end;
      end;


{*****************************************************************************
                            TCGWITHNODE
*****************************************************************************}

    procedure tcgwithnode.pass_2;
      var
        tmpreg: tregister;
        usetemp,with_expr_in_temp : boolean;
{$ifdef GDB}
        withstartlabel,withendlabel : tasmlabel;
        pp : pchar;
        mangled_length  : longint;

      const
        withlevel : longint = 0;
{$endif GDB}
      begin
         if assigned(left) then
            begin
               secondpass(left);
{$ifdef i386}
               if left.location.reference.segment<>R_NO then
                 message(parser_e_no_with_for_variable_in_other_segments);
{$endif i386}

               new(withreference);

               usetemp:=false;
               if (left.nodetype=loadn) and
                  (tloadnode(left).symtable=aktprocsym.definition.localst) then
                 begin
                    { for locals use the local storage }
                    withreference^:=left.location.reference;
                    include(flags,nf_islocal);
                 end
               else
                { call can have happend with a property }
                begin
                  tmpreg := cg.get_scratch_reg(exprasmlist);
                  usetemp:=true;
                  if is_class_or_interface(left.resulttype.def) then
                    cg.a_load_loc_reg(exprasmlist,OS_ADDR,left.location,tmpreg)
                  else
                    cg.a_loadaddress_ref_reg(exprasmlist,
                      left.location.reference,tmpreg);
                end;

               del_location(left.location);

               { if the with expression is stored in a temp    }
               { area we must make it persistent and shouldn't }
               { release it (FK)                               }
               if (left.location.loc in [LOC_MEM,LOC_REFERENCE]) and
                 istemp(left.location.reference) then
                 begin
                    normaltemptopersistant(left.location.reference.offset);
                    with_expr_in_temp:=true;
                 end
               else
                 with_expr_in_temp:=false;

               { if usetemp is set the value must be in tmpreg }
               if usetemp then
                begin
                  gettempofsizereference(target_info.size_of_pointer,
                    withreference^);
                  normaltemptopersistant(withreference^.offset);
                  { move to temp reference }
                  cg.a_load_reg_ref(exprasmlist,OS_ADDR,tmpreg,withreference^);
                  cg.free_scratch_reg(exprasmlist,tmpreg);
{$ifdef GDB}
                  if (cs_debuginfo in aktmoduleswitches) then
                    begin
                      inc(withlevel);
                      getaddrlabel(withstartlabel);
                      getaddrlabel(withendlabel);
                      emitlab(withstartlabel);
                      withdebugList.concat(Tai_stabs.Create(strpnew(
                         '"with'+tostr(withlevel)+':'+tostr(symtablestack.getnewtypecount)+
                         '=*'+tstoreddef(left.resulttype.def).numberstring+'",'+
                         tostr(N_LSYM)+',0,0,'+tostr(withreference^.offset))));
                      mangled_length:=length(aktprocsym.definition.mangledname);
                      getmem(pp,mangled_length+50);
                      strpcopy(pp,'192,0,0,'+withstartlabel.name);
                      if (target_info.use_function_relative_addresses) then
                        begin
                          strpcopy(strend(pp),'-');
                          strpcopy(strend(pp),aktprocsym.definition.mangledname);
                        end;
                      withdebugList.concat(Tai_stabn.Create(strnew(pp)));
                    end;
{$endif GDB}
                end;

               { right can be optimize out !!! }
               if assigned(right) then
                 secondpass(right);

               if usetemp then
                 begin
                   ungetpersistanttemp(withreference^.offset);
{$ifdef GDB}
                   if (cs_debuginfo in aktmoduleswitches) then
                     begin
                       emitlab(withendlabel);
                       strpcopy(pp,'224,0,0,'+withendlabel.name);
                      if (target_info.use_function_relative_addresses) then
                        begin
                          strpcopy(strend(pp),'-');
                          strpcopy(strend(pp),aktprocsym.definition.mangledname);
                        end;
                       withdebugList.concat(Tai_stabn.Create(strnew(pp)));
                       freemem(pp,mangled_length+50);
                       dec(withlevel);
                     end;
{$endif GDB}
                 end;

               if with_expr_in_temp then
                 ungetpersistanttemp(left.location.reference.offset);

               dispose(withreference);
               withreference:=nil;
            end;
       end;

begin
   cloadvmtnode:=tcgloadvmtnode;
   chnewnode:=tcghnewnode;
   chdisposenode:=tcghdisposenode;
   caddrnode:=tcgaddrnode;
   cdoubleaddrnode:=tcgdoubleaddrnode;
   cderefnode:=tcgderefnode;
   csubscriptnode:=tcgsubscriptnode;
   cselfnode:=tcgselfnode;
   cwithnode:=tcgwithnode;
end.
{
  $Log$
  Revision 1.1  2001-09-30 16:17:17  jonas
    * made most constant and mem handling processor independent


}
