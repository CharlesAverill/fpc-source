{
    $Id$
    Copyright (c) 2000-2002 by Florian Klaempfl

    Type checking and register allocation for memory related nodes

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
unit nmem;

{$i fpcdefs.inc}

interface

    uses
       node,
       symdef,symsym,symtable,symtype,
       cpubase;

    type
       tloadvmtaddrnode = class(tunarynode)
          constructor create(l : tnode);virtual;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
       end;
       tloadvmtaddrnodeclass = class of tloadvmtaddrnode;

       tloadparentfpnode = class(tunarynode)
          parentpd : tprocdef;
          parentpdderef : tderef;
          constructor create(pd:tprocdef);virtual;
          constructor ppuload(t:tnodetype;ppufile:tcompilerppufile);override;
          procedure ppuwrite(ppufile:tcompilerppufile);override;
          procedure buildderefimpl;override;
          procedure derefimpl;override;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
          function getcopy : tnode;override;
       end;
       tloadparentfpnodeclass = class of tloadparentfpnode;

       taddrnode = class(tunarynode)
          getprocvardef : tprocvardef;
          getprocvardefderef : tderef;
          constructor create(l : tnode);virtual;
          constructor ppuload(t:tnodetype;ppufile:tcompilerppufile);override;
          procedure ppuwrite(ppufile:tcompilerppufile);override;
          procedure mark_write;override;
          procedure buildderefimpl;override;
          procedure derefimpl;override;
          function getcopy : tnode;override;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
       end;
       taddrnodeclass = class of taddrnode;

       tderefnode = class(tunarynode)
          constructor create(l : tnode);virtual;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
          procedure mark_write;override;
       end;
       tderefnodeclass = class of tderefnode;

       tsubscriptnode = class(tunarynode)
          vs : tvarsym;
          vsderef : tderef;
          constructor create(varsym : tsym;l : tnode);virtual;
          constructor ppuload(t:tnodetype;ppufile:tcompilerppufile);override;
          procedure ppuwrite(ppufile:tcompilerppufile);override;
          procedure buildderefimpl;override;
          procedure derefimpl;override;
          function getcopy : tnode;override;
          function pass_1 : tnode;override;
          function docompare(p: tnode): boolean; override;
          function det_resulttype:tnode;override;
          procedure mark_write;override;
       end;
       tsubscriptnodeclass = class of tsubscriptnode;

       tvecnode = class(tbinarynode)
          constructor create(l,r : tnode);virtual;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
          procedure mark_write;override;
       end;
       tvecnodeclass = class of tvecnode;

       twithnode = class(tunarynode)
          withsymtable  : twithsymtable;
          tablecount    : longint;
          withrefnode   : tnode;
          constructor create(l:tnode;symtable:twithsymtable;count:longint;r:tnode);
          destructor destroy;override;
          constructor ppuload(t:tnodetype;ppufile:tcompilerppufile);override;
          procedure ppuwrite(ppufile:tcompilerppufile);override;
          function getcopy : tnode;override;
          function pass_1 : tnode;override;
          function docompare(p: tnode): boolean; override;
          function det_resulttype:tnode;override;
       end;
       twithnodeclass = class of twithnode;

    var
       cloadvmtaddrnode : tloadvmtaddrnodeclass;
       cloadparentfpnode : tloadparentfpnodeclass;
       caddrnode : taddrnodeclass;
       cderefnode : tderefnodeclass;
       csubscriptnode : tsubscriptnodeclass;
       cvecnode : tvecnodeclass;
       cwithnode : twithnodeclass;

implementation

    uses
      globtype,systems,
      cutils,verbose,globals,
      symconst,symbase,defutil,defcmp,
      nbas,nutils,
      htypechk,pass_1,ncal,nld,ncon,ncnv,cgbase,procinfo
      ;

{*****************************************************************************
                            TLOADVMTADDRNODE
*****************************************************************************}

    constructor tloadvmtaddrnode.create(l : tnode);
      begin
         inherited create(loadvmtaddrn,l);
      end;


    function tloadvmtaddrnode.det_resulttype:tnode;
      begin
        result:=nil;
        resulttypepass(left);
        if codegenerror then
         exit;

        case left.resulttype.def.deftype of
          classrefdef :
            resulttype:=left.resulttype;
          objectdef :
            resulttype.setdef(tclassrefdef.create(left.resulttype));
          else
            Message(parser_e_pointer_to_class_expected);
        end;
      end;


    function tloadvmtaddrnode.pass_1 : tnode;
      begin
         result:=nil;
         expectloc:=LOC_REGISTER;
         if left.nodetype<>typen then
           begin
             firstpass(left);
             registersint:=left.registersint;
           end;
         if registersint<1 then
           registersint:=1;
      end;


{*****************************************************************************
                        TLOADPARENTFPNODE
*****************************************************************************}

    constructor tloadparentfpnode.create(pd:tprocdef);
      begin
        inherited create(loadparentfpn,nil);
        if not assigned(pd) then
          internalerror(200309288);
        if (pd.parast.symtablelevel>current_procinfo.procdef.parast.symtablelevel) then
          internalerror(200309284);
        parentpd:=pd;
      end;


    constructor tloadparentfpnode.ppuload(t:tnodetype;ppufile:tcompilerppufile);
      begin
        inherited ppuload(t,ppufile);
        ppufile.getderef(parentpdderef);
      end;


    procedure tloadparentfpnode.ppuwrite(ppufile:tcompilerppufile);
      begin
        inherited ppuwrite(ppufile);
        ppufile.putderef(parentpdderef);
      end;


    procedure tloadparentfpnode.buildderefimpl;
      begin
        inherited buildderefimpl;
        parentpdderef.build(parentpd);
      end;


    procedure tloadparentfpnode.derefimpl;
      begin
        inherited derefimpl;
        parentpd:=tprocdef(parentpdderef.resolve);
      end;


    function tloadparentfpnode.getcopy : tnode;
      var
         p : tloadparentfpnode;
      begin
         p:=tloadparentfpnode(inherited getcopy);
         p.parentpd:=parentpd;
         getcopy:=p;
      end;


    function tloadparentfpnode.det_resulttype:tnode;
      begin
        result:=nil;
        resulttype:=voidpointertype;
      end;


    function tloadparentfpnode.pass_1 : tnode;
      begin
        result:=nil;
        expectloc:=LOC_REGISTER;
        registersint:=1;
      end;


{*****************************************************************************
                             TADDRNODE
*****************************************************************************}

    constructor taddrnode.create(l : tnode);

      begin
         inherited create(addrn,l);
         getprocvardef:=nil;
      end;


    constructor taddrnode.ppuload(t:tnodetype;ppufile:tcompilerppufile);
      begin
        inherited ppuload(t,ppufile);
        ppufile.getderef(getprocvardefderef);
      end;


    procedure taddrnode.ppuwrite(ppufile:tcompilerppufile);
      begin
        inherited ppuwrite(ppufile);
        ppufile.putderef(getprocvardefderef);
      end;

    procedure Taddrnode.mark_write;

    begin
      {@procvar:=nil is legal in Delphi mode.}
      left.mark_write;
    end;

    procedure taddrnode.buildderefimpl;
      begin
        inherited buildderefimpl;
        getprocvardefderef.build(getprocvardef);
      end;


    procedure taddrnode.derefimpl;
      begin
        inherited derefimpl;
        getprocvardef:=tprocvardef(getprocvardefderef.resolve);
      end;


    function taddrnode.getcopy : tnode;

      var
         p : taddrnode;

      begin
         p:=taddrnode(inherited getcopy);
         p.getprocvardef:=getprocvardef;
         getcopy:=p;
      end;


    function taddrnode.det_resulttype:tnode;
      var
         hp  : tnode;
         hp2 : TParaItem;
         hp3 : tabstractprocdef;
      begin
        result:=nil;
        resulttypepass(left);
        if codegenerror then
         exit;

        { don't allow constants }
        if is_constnode(left) then
         begin
           aktfilepos:=left.fileinfo;
           CGMessage(type_e_no_addr_of_constant);
           exit;
         end;

        { tp @procvar support (type of @procvar is a void pointer)
          Note: we need to leave the addrn in the tree,
          else we can't see the difference between @procvar and procvar.
          we set the procvarload flag so a secondpass does nothing for
          this node (PFV) }
        if (m_tp_procvar in aktmodeswitches) then
         begin
           case left.nodetype of
             calln :
               begin
                 { a load of a procvar can't have parameters }
                 if assigned(tcallnode(left).left) then
                   CGMessage(cg_e_illegal_expression);
                 { is it a procvar? }
                 hp:=tcallnode(left).right;
                 if assigned(hp) then
                   begin
                     { remove calln node }
                     tcallnode(left).right:=nil;
                     left.free;
                     left:=hp;
                     include(flags,nf_procvarload);
                   end;
               end;
             loadn,
             subscriptn,
             typeconvn,
             vecn,
             derefn :
               begin
                 if left.resulttype.def.deftype=procvardef then
                   include(flags,nf_procvarload);
               end;
           end;
           if nf_procvarload in flags then
            begin
              resulttype:=voidpointertype;
              exit;
            end;
         end;

        { proc 2 procvar ? }
        if left.nodetype=calln then
         { if it were a valid construct, the addr node would already have }
         { been removed in the parser. This happens for (in FPC mode)     }
         { procvar1 := @procvar2(parameters);                             }
         CGMessage(cg_e_illegal_expression)
        else
         if (left.nodetype=loadn) and (tloadnode(left).symtableentry.typ=procsym) then
          begin
            { the address is already available when loading a procedure of object }
            if assigned(tloadnode(left).left) then
             include(flags,nf_procvarload);

            { result is a procedure variable }
            { No, to be TP compatible, you must return a voidpointer to
              the procedure that is stored in the procvar.}
            if not(m_tp_procvar in aktmodeswitches) then
              begin
                 if assigned(getprocvardef) and
                    (tprocsym(tloadnode(left).symtableentry).procdef_count>1) then
                  begin
                    hp3:=tprocsym(tloadnode(left).symtableentry).search_procdef_byprocvardef(getprocvardef);
                    if not assigned(hp3)  then
                     begin
                       IncompatibleTypes(tprocsym(tloadnode(left).symtableentry).first_procdef,getprocvardef);
                       exit;
                     end;
                  end
                 else
                  hp3:=tabstractprocdef(tprocsym(tloadnode(left).symtableentry).first_procdef);


                 { create procvardef }
                 resulttype.setdef(tprocvardef.create(hp3.parast.symtablelevel));
                 tprocvardef(resulttype.def).proctypeoption:=hp3.proctypeoption;
                 tprocvardef(resulttype.def).proccalloption:=hp3.proccalloption;
                 tprocvardef(resulttype.def).procoptions:=hp3.procoptions;
                 tprocvardef(resulttype.def).rettype:=hp3.rettype;

                 { method ? then set the methodpointer flag }
                 if (hp3.owner.symtabletype=objectsymtable) then
                   include(tprocvardef(resulttype.def).procoptions,po_methodpointer);

                 { only need the address of the method? this is needed
                   for @tobject.create }
                 if not assigned(tloadnode(left).left) then
                   include(tprocvardef(resulttype.def).procoptions,po_addressonly);

                 { Add parameters in left to right order }
                 hp2:=TParaItem(hp3.Para.first);
                 while assigned(hp2) do
                   begin
                      tprocvardef(resulttype.def).concatpara(nil,hp2.paratype,hp2.parasym,
                          hp2.defaultvalue,hp2.is_hidden);
                      hp2:=TParaItem(hp2.next);
                   end;
              end
            else
              resulttype:=voidpointertype;
          end
        else
          begin
            { what are we getting the address from an absolute sym? }
            hp:=left;
            while assigned(hp) and (hp.nodetype in [vecn,derefn,subscriptn]) do
             hp:=tunarynode(hp).left;
{$ifdef i386}
            if assigned(hp) and
               (hp.nodetype=loadn) and
               ((tloadnode(hp).symtableentry.typ=absolutesym) and
                tabsolutesym(tloadnode(hp).symtableentry).absseg) then
             begin
               if not(nf_typedaddr in flags) then
                 resulttype:=voidfarpointertype
               else
                 resulttype.setdef(tpointerdef.createfar(left.resulttype));
             end
            else
{$endif i386}
             begin
               if not(nf_typedaddr in flags) then
                 resulttype:=voidpointertype
               else
                 resulttype.setdef(tpointerdef.create(left.resulttype));
             end;
          end;

         { this is like the function addr }
         inc(parsing_para_level);
         set_varstate(left,vs_used,false);
         dec(parsing_para_level);

      end;


    function taddrnode.pass_1 : tnode;
      begin
         result:=nil;
         firstpass(left);
         if codegenerror then
          exit;

         make_not_regable(left);
         if nf_procvarload in flags then
          begin
            registersint:=left.registersint;
            registersfpu:=left.registersfpu;
{$ifdef SUPPORT_MMX}
            registersmmx:=left.registersmmx;
{$endif SUPPORT_MMX}
            if registersint<1 then
             registersint:=1;
            expectloc:=left.expectloc;
            exit;
          end;

         { we should allow loc_mem for @string }
         if not(left.expectloc in [LOC_CREFERENCE,LOC_REFERENCE]) then
           begin
             aktfilepos:=left.fileinfo;
             CGMessage(cg_e_illegal_expression);
           end;

         registersint:=left.registersint;
         registersfpu:=left.registersfpu;
{$ifdef SUPPORT_MMX}
         registersmmx:=left.registersmmx;
{$endif SUPPORT_MMX}
         if registersint<1 then
           registersint:=1;
         { is this right for object of methods ?? }
         expectloc:=LOC_REGISTER;
      end;


{*****************************************************************************
                             TDEREFNODE
*****************************************************************************}

    constructor tderefnode.create(l : tnode);

      begin
         inherited create(derefn,l);

      end;

    function tderefnode.det_resulttype:tnode;
      begin
         result:=nil;
         resulttypepass(left);
         set_varstate(left,vs_used,true);
         if codegenerror then
          exit;

         { tp procvar support }
         maybe_call_procvar(left,true);

         if left.resulttype.def.deftype=pointerdef then
          resulttype:=tpointerdef(left.resulttype.def).pointertype
         else
          CGMessage(cg_e_invalid_qualifier);
      end;

    procedure Tderefnode.mark_write;

    begin
      include(flags,nf_write);
    end;

    function tderefnode.pass_1 : tnode;
      begin
         result:=nil;
         firstpass(left);
         if codegenerror then
          exit;

         registersint:=max(left.registersint,1);
         registersfpu:=left.registersfpu;
{$ifdef SUPPORT_MMX}
         registersmmx:=left.registersmmx;
{$endif SUPPORT_MMX}

         expectloc:=LOC_REFERENCE;
      end;


{*****************************************************************************
                            TSUBSCRIPTNODE
*****************************************************************************}

    constructor tsubscriptnode.create(varsym : tsym;l : tnode);

      begin
         inherited create(subscriptn,l);
         { vs should be changed to tsym! }
         vs:=tvarsym(varsym);
      end;

    constructor tsubscriptnode.ppuload(t:tnodetype;ppufile:tcompilerppufile);
      begin
        inherited ppuload(t,ppufile);
        ppufile.getderef(vsderef);
      end;


    procedure tsubscriptnode.ppuwrite(ppufile:tcompilerppufile);
      begin
        inherited ppuwrite(ppufile);
        ppufile.putderef(vsderef);
      end;


    procedure tsubscriptnode.buildderefimpl;
      begin
        inherited buildderefimpl;
        vsderef.build(vs);
      end;


    procedure tsubscriptnode.derefimpl;
      begin
        inherited derefimpl;
        vs:=tvarsym(vsderef.resolve);
      end;


    function tsubscriptnode.getcopy : tnode;

      var
         p : tsubscriptnode;

      begin
         p:=tsubscriptnode(inherited getcopy);
         p.vs:=vs;
         getcopy:=p;
      end;


    function tsubscriptnode.det_resulttype:tnode;
      begin
        result:=nil;
        resulttypepass(left);
        { tp procvar support }
        maybe_call_procvar(left,true);
        resulttype:=vs.vartype;
      end;

    procedure Tsubscriptnode.mark_write;

    begin
      include(flags,nf_write);
    end;

    function tsubscriptnode.pass_1 : tnode;
      begin
         result:=nil;
         firstpass(left);
         if codegenerror then
          exit;

         registersint:=left.registersint;
         registersfpu:=left.registersfpu;
{$ifdef SUPPORT_MMX}
         registersmmx:=left.registersmmx;
{$endif SUPPORT_MMX}
         { classes must be dereferenced implicit }
         if is_class_or_interface(left.resulttype.def) then
           begin
              if registersint=0 then
                registersint:=1;
              expectloc:=LOC_REFERENCE;
           end
         else
           begin
              if (left.expectloc<>LOC_CREFERENCE) and
                 (left.expectloc<>LOC_REFERENCE) then
                CGMessage(cg_e_illegal_expression);
              expectloc:=left.expectloc;
           end;
      end;

    function tsubscriptnode.docompare(p: tnode): boolean;
      begin
        docompare :=
          inherited docompare(p) and
          (vs = tsubscriptnode(p).vs);
      end;


{*****************************************************************************
                               TVECNODE
*****************************************************************************}

    constructor tvecnode.create(l,r : tnode);

      begin
         inherited create(vecn,l,r);
      end;


    function tvecnode.det_resulttype:tnode;
      var
         htype : ttype;
         valid : boolean;
      begin
         result:=nil;
         resulttypepass(left);
         resulttypepass(right);
         { In p[1] p is always valid, it is not possible to
           declared a shortstring or normal array that has
           undefined number of elements. Dynamic array and
           ansi/widestring needs to be valid }
         valid:=is_dynamic_array(left.resulttype.def) or
                is_ansistring(left.resulttype.def) or
                is_widestring(left.resulttype.def);
         set_varstate(left,vs_used,valid);
         set_varstate(right,vs_used,true);
         if codegenerror then
          exit;

         { maybe type conversion for the index value, but
           do not convert enums,booleans,char }
         if (right.resulttype.def.deftype<>enumdef) and
            not(is_char(right.resulttype.def)) and
            not(is_boolean(right.resulttype.def)) then
           begin
             inserttypeconv(right,s32inttype);
           end;

         case left.resulttype.def.deftype of
           arraydef :
             begin
               { check type of the index value }
               if (compare_defs(right.resulttype.def,tarraydef(left.resulttype.def).rangetype.def,right.nodetype)=te_incompatible) then
                 IncompatibleTypes(right.resulttype.def,tarraydef(left.resulttype.def).rangetype.def);
               resulttype:=tarraydef(left.resulttype.def).elementtype;
             end;
           pointerdef :
             begin
               { are we accessing a pointer[], then convert the pointer to
                 an array first, in FPC this is allowed for all pointers in
                 delphi/tp7 it's only allowed for pchars }
               if (m_fpc in aktmodeswitches) or
                  is_pchar(left.resulttype.def) or
                  is_pwidechar(left.resulttype.def) then
                begin
                  { convert pointer to array }
                  htype.setdef(tarraydef.create_from_pointer(tpointerdef(left.resulttype.def).pointertype));
                  inserttypeconv(left,htype);

                  resulttype:=tarraydef(htype.def).elementtype;
                end
               else
                CGMessage(type_e_array_required);
             end;
           stringdef :
             begin
                { indexed access to 0 element is only allowed for shortstrings }
                if (right.nodetype=ordconstn) and
                   (tordconstnode(right).value=0) and
                   not(is_shortstring(left.resulttype.def)) then
                  CGMessage(cg_e_can_access_element_zero);
                case tstringdef(left.resulttype.def).string_typ of
                   st_widestring :
                     resulttype:=cwidechartype;
                   st_ansistring :
                     resulttype:=cchartype;
                   st_longstring :
                     resulttype:=cchartype;
                   st_shortstring :
                     resulttype:=cchartype;
                end;
             end
           else
             CGMessage(type_e_array_required);
        end;
      end;

    procedure Tvecnode.mark_write;

    begin
      include(flags,nf_write);
    end;

    function tvecnode.pass_1 : tnode;
{$ifdef consteval}
      var
         tcsym : ttypedconstsym;
{$endif}
      begin
         result:=nil;
         firstpass(left);
         firstpass(right);
         if codegenerror then
           exit;

         if (nf_callunique in flags) and
            (is_ansistring(left.resulttype.def) or
             is_widestring(left.resulttype.def)) then
           begin
             left := ctypeconvnode.create_explicit(ccallnode.createintern('fpc_'+tstringdef(left.resulttype.def).stringtypname+'_unique',
               ccallparanode.create(
                 ctypeconvnode.create_explicit(left,voidpointertype),nil)),
               left.resulttype);
             firstpass(left);
             { double resulttype passes somwhere else may cause this to be }
             { reset though :/                                             }
             exclude(flags,nf_callunique);
           end;

         { the register calculation is easy if a const index is used }
         if right.nodetype=ordconstn then
           begin
{$ifdef consteval}
              { constant evaluation }
              if (left.nodetype=loadn) and
                 (left.symtableentry.typ=typedconstsym) then
               begin
                 tcsym:=ttypedconstsym(left.symtableentry);
                 if tcsym.defintion^.typ=stringdef then
                  begin

                  end;
               end;
{$endif}
              registersint:=left.registersint;

              { for ansi/wide strings, we need at least one register }
              if is_ansistring(left.resulttype.def) or
                is_widestring(left.resulttype.def) or
              { ... as well as for dynamic arrays }
                is_dynamic_array(left.resulttype.def) then
                registersint:=max(registersint,1);
           end
         else
           begin
              { this rules are suboptimal, but they should give }
              { good results                                }
              registersint:=max(left.registersint,right.registersint);

              { for ansi/wide strings, we need at least one register }
              if is_ansistring(left.resulttype.def) or
                is_widestring(left.resulttype.def) or
              { ... as well as for dynamic arrays }
                is_dynamic_array(left.resulttype.def) then
                registersint:=max(registersint,1);

              { need we an extra register when doing the restore ? }
              if (left.registersint<=right.registersint) and
              { only if the node needs less than 3 registers }
              { two for the right node and one for the       }
              { left address                             }
                (registersint<3) then
                inc(registersint);

              { need we an extra register for the index ? }
              if (right.expectloc<>LOC_REGISTER)
              { only if the right node doesn't need a register }
                and (right.registersint<1) then
                inc(registersint);

              { not correct, but what works better ?
              if left.registersint>0 then
                registersint:=max(registersint,2)
              else
                 min. one register
                registersint:=max(registersint,1);
              }
           end;
         registersfpu:=max(left.registersfpu,right.registersfpu);
{$ifdef SUPPORT_MMX}
         registersmmx:=max(left.registersmmx,right.registersmmx);
{$endif SUPPORT_MMX}
         if left.expectloc=LOC_CREFERENCE then
           expectloc:=LOC_CREFERENCE
         else
           expectloc:=LOC_REFERENCE;
      end;


{*****************************************************************************
                               TWITHNODE
*****************************************************************************}

    constructor twithnode.create(l:tnode;symtable:twithsymtable;count:longint;r:tnode);
      begin
         inherited create(withn,l);
         withrefnode:=r;
         withsymtable:=symtable;
         tablecount:=count;
         set_file_line(l);
      end;


    destructor twithnode.destroy;
      var
        hsymt,
        symt : tsymtable;
        i    : longint;
      begin
        symt:=withsymtable;
        for i:=1 to tablecount do
         begin
           if assigned(symt) then
            begin
              hsymt:=symt.next;
              symt.free;
              symt:=hsymt;
            end;
         end;
        inherited destroy;
      end;


    constructor twithnode.ppuload(t:tnodetype;ppufile:tcompilerppufile);
      begin
        inherited ppuload(t,ppufile);
        internalerror(200208192);
      end;


    procedure twithnode.ppuwrite(ppufile:tcompilerppufile);
      begin
        inherited ppuwrite(ppufile);
        internalerror(200208193);
      end;


    function twithnode.getcopy : tnode;

      var
         p : twithnode;

      begin
         p:=twithnode(inherited getcopy);
         p.withsymtable:=withsymtable;
         p.tablecount:=tablecount;
         if assigned(p.withrefnode) then
           p.withrefnode:=withrefnode.getcopy
         else
           p.withrefnode:=nil;
         result:=p;
      end;


    function twithnode.det_resulttype:tnode;
      begin
        result:=nil;
        resulttype:=voidtype;

        resulttypepass(withrefnode);
        //unset_varstate(withrefnode);
        set_varstate(withrefnode,vs_used,true);
        if codegenerror then
         exit;

        if (withrefnode.nodetype=vecn) and
           (nf_memseg in withrefnode.flags) then
          CGMessage(parser_e_no_with_for_variable_in_other_segments);

        if assigned(left) then
          resulttypepass(left);
      end;


    function twithnode.pass_1 : tnode;
      begin
        result:=nil;
        expectloc:=LOC_VOID;

        if assigned(left) then
         begin
           firstpass(left);
           registersint:=left.registersint;
           registersfpu:=left.registersfpu;
{$ifdef SUPPORT_MMX}
           registersmmx:=left.registersmmx;
{$endif SUPPORT_MMX}
         end;
        if assigned(withrefnode) then
          begin
            firstpass(withrefnode);
            if withrefnode.registersint > registersint then
              registersint:=withrefnode.registersint;
            if withrefnode.registersfpu > registersfpu then
              registersint:=withrefnode.registersfpu;
{$ifdef SUPPORT_MMX}
            if withrefnode.registersmmx > registersmmx then
              registersmmx:=withrefnode.registersmmx;
{$endif SUPPORT_MMX}
          end;
      end;


    function twithnode.docompare(p: tnode): boolean;
      begin
        docompare :=
          inherited docompare(p) and
          (withsymtable = twithnode(p).withsymtable) and
          (tablecount = twithnode(p).tablecount) and
          (withrefnode.isequal(twithnode(p).withrefnode));
      end;

begin
  cloadvmtaddrnode := tloadvmtaddrnode;
  caddrnode := taddrnode;
  cderefnode := tderefnode;
  csubscriptnode := tsubscriptnode;
  cvecnode := tvecnode;
  cwithnode := twithnode;
end.
{
  $Log$
  Revision 1.81  2004-03-18 16:19:03  peter
    * fixed operator overload allowing for pointer-string
    * replaced some type_e_mismatch with more informational messages

  Revision 1.80  2004/02/20 21:55:59  peter
    * procvar cleanup

  Revision 1.79  2004/02/03 22:32:54  peter
    * renamed xNNbittype to xNNinttype
    * renamed registers32 to registersint
    * replace some s32bit,u32bit with torddef([su]inttype).def.typ

  Revision 1.78  2004/01/31 17:45:17  peter
    * Change several $ifdef i386 to x86
    * Change several OS_32 to OS_INT/OS_ADDR

  Revision 1.77  2004/01/26 16:12:28  daniel
    * reginfo now also only allocated during register allocation
    * third round of gdb cleanups: kick out most of concatstabto

  Revision 1.76  2003/12/12 15:42:53  peter
    * don't give warnings for shortstring vecnodes

  Revision 1.75  2003/12/08 22:35:06  peter
    * don't check varstate for left of vecnode for normal arrays

  Revision 1.74  2003/12/01 18:44:15  peter
    * fixed some crashes
    * fixed varargs and register calling probs

  Revision 1.73  2003/11/29 14:33:13  peter
    * typed address only used for @ and addr() that are parsed

  Revision 1.72  2003/11/10 22:02:52  peter
    * cross unit inlining fixed

  Revision 1.71  2003/11/05 14:18:03  marco
   * fix from Peter arraysize warning (nav Newsgroup msg)

  Revision 1.70  2003/10/31 18:44:18  peter
    * don't search for compatible procvars when the proc is not
      overloaded

  Revision 1.69  2003/10/31 15:52:58  peter
    * support creating classes using <class of tobject>.create

  Revision 1.68  2003/10/23 14:44:07  peter
    * splitted buildderef and buildderefimpl to fix interface crc
      calculation

  Revision 1.67  2003/10/22 20:40:00  peter
    * write derefdata in a separate ppu entry

  Revision 1.66  2003/10/21 18:16:13  peter
    * IncompatibleTypes() added that will include unit names when
      the typenames are the same

  Revision 1.65  2003/10/08 19:19:45  peter
    * set_varstate cleanup

  Revision 1.64  2003/10/01 20:34:49  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.63  2003/09/28 17:55:04  peter
    * parent framepointer changed to hidden parameter
    * tloadparentfpnode added

  Revision 1.62  2003/09/06 22:27:08  florian
    * fixed web bug 2669
    * cosmetic fix in printnode
    * tobjectdef.gettypename implemented

  Revision 1.61  2003/09/03 11:18:37  florian
    * fixed arm concatcopy
    + arm support in the common compiler sources added
    * moved some generic cg code around
    + tfputype added
    * ...

  Revision 1.60  2003/08/10 17:25:23  peter
    * fixed some reported bugs

  Revision 1.59  2003/06/17 19:24:08  jonas
    * fixed conversion of fpc_*str_unique to compilerproc

  Revision 1.58  2003/06/17 16:34:44  jonas
    * lots of newra fixes (need getfuncretparaloc implementation for i386)!
    * renamed all_intregisters to volatile_intregisters and made it
      processor dependent

  Revision 1.57  2003/06/07 20:26:32  peter
    * re-resolving added instead of reloading from ppu
    * tderef object added to store deref info for resolving

  Revision 1.56  2003/06/07 18:57:04  jonas
    + added freeintparaloc
    * ppc get/freeintparaloc now check whether the parameter regs are
      properly allocated/deallocated (and get an extra list para)
    * ppc a_call_* now internalerrors if pi_do_call is not yet set
    * fixed lot of missing pi_do_call's

  Revision 1.55  2003/05/24 17:15:24  jonas
    * added missing firstpass for withrefnode

  Revision 1.54  2003/05/11 14:45:12  peter
    * tloadnode does not support objectsymtable,withsymtable anymore
    * withnode cleanup
    * direct with rewritten to use temprefnode

  Revision 1.53  2003/05/09 17:47:02  peter
    * self moved to hidden parameter
    * removed hdisposen,hnewn,selfn

  Revision 1.52  2003/05/05 14:53:16  peter
    * vs_hidden replaced by is_hidden boolean

  Revision 1.51  2003/04/27 11:21:33  peter
    * aktprocdef renamed to current_procdef
    * procinfo renamed to current_procinfo
    * procinfo will now be stored in current_module so it can be
      cleaned up properly
    * gen_main_procsym changed to create_main_proc and release_main_proc
      to also generate a tprocinfo structure
    * fixed unit implicit initfinal

  Revision 1.50  2003/04/27 07:29:50  peter
    * current_procdef cleanup, current_procdef is now always nil when parsing
      a new procdef declaration
    * aktprocsym removed
    * lexlevel removed, use symtable.symtablelevel instead
    * implicit init/final code uses the normal genentry/genexit
    * funcret state checking updated for new funcret handling

  Revision 1.49  2003/04/23 10:10:54  peter
    * procvar is not compared in addrn

  Revision 1.48  2003/04/22 23:50:23  peter
    * firstpass uses expectloc
    * checks if there are differences between the expectloc and
      location.loc from secondpass in EXTDEBUG

  Revision 1.47  2003/04/10 17:57:52  peter
    * vs_hidden released

  Revision 1.46  2003/01/30 21:46:57  peter
    * self fixes for static methods (merged)

  Revision 1.45  2003/01/09 21:52:37  peter
    * merged some verbosity options.
    * V_LineInfo is a verbosity flag to include line info

  Revision 1.44  2003/01/06 21:16:52  peter
    * po_addressonly added to retrieve the address of a methodpointer
      only, this is used for @tclass.method which has no self pointer

  Revision 1.43  2003/01/04 15:54:03  daniel
    * Fixed mark_write for @ operator
      (can happen when compiling @procvar:=nil (Delphi mode construction))

  Revision 1.42  2003/01/03 12:15:56  daniel
    * Removed ifdefs around notifications
      ifdefs around for loop optimizations remain

  Revision 1.41  2002/11/25 17:43:20  peter
    * splitted defbase in defutil,symutil,defcmp
    * merged isconvertable and is_equal into compare_defs(_ext)
    * made operator search faster by walking the list only once

  Revision 1.40  2002/09/27 21:13:28  carl
    * low-highval always checked if limit ober 2GB is reached (to avoid overflow)

  Revision 1.39  2002/09/01 18:44:17  peter
    * cleanup of tvecnode.det_resulttype
    * move 0 element of string access check to resulttype

  Revision 1.38  2002/09/01 13:28:38  daniel
   - write_access fields removed in favor of a flag

  Revision 1.37  2002/09/01 08:01:16  daniel
   * Removed sets from Tcallnode.det_resulttype
   + Added read/write notifications of variables. These will be usefull
     for providing information for several optimizations. For example
     the value of the loop variable of a for loop does matter is the
     variable is read after the for loop, but if it's no longer used
     or written, it doesn't matter and this can be used to optimize
     the loop code generation.

  Revision 1.36  2002/08/19 19:36:43  peter
    * More fixes for cross unit inlining, all tnodes are now implemented
    * Moved pocall_internconst to po_internconst because it is not a
      calling type at all and it conflicted when inlining of these small
      functions was requested

  Revision 1.35  2002/07/23 09:51:23  daniel
  * Tried to make Tprocsym.defs protected. I didn't succeed but the cleanups
    are worth comitting.

  Revision 1.34  2002/07/20 11:57:54  florian
    * types.pas renamed to defbase.pas because D6 contains a types
      unit so this would conflicts if D6 programms are compiled
    + Willamette/SSE2 instructions to assembler added

  Revision 1.33  2002/05/18 13:34:10  peter
    * readded missing revisions

  Revision 1.32  2002/05/16 19:46:39  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.30  2002/05/12 16:53:07  peter
    * moved entry and exitcode to ncgutil and cgobj
    * foreach gets extra argument for passing local data to the
      iterator function
    * -CR checks also class typecasts at runtime by changing them
      into as
    * fixed compiler to cycle with the -CR option
    * fixed stabs with elf writer, finally the global variables can
      be watched
    * removed a lot of routines from cga unit and replaced them by
      calls to cgobj
    * u32bit-s32bit updates for and,or,xor nodes. When one element is
      u32bit then the other is typecasted also to u32bit without giving
      a rangecheck warning/error.
    * fixed pascal calling method with reversing also the high tree in
      the parast, detected by tcalcst3 test

  Revision 1.29  2002/04/21 19:02:04  peter
    * removed newn and disposen nodes, the code is now directly
      inlined from pexpr
    * -an option that will write the secondpass nodes to the .s file, this
      requires EXTDEBUG define to actually write the info
    * fixed various internal errors and crashes due recent code changes

  Revision 1.28  2002/04/20 21:32:23  carl
  + generic FPC_CHECKPOINTER
  + first parameter offset in stack now portable
  * rename some constants
  + move some cpu stuff to other units
  - remove unused constents
  * fix stacksize for some targets
  * fix generic size problems which depend now on EXTEND_SIZE constant

  Revision 1.27  2002/04/02 17:11:29  peter
    * tlocation,treference update
    * LOC_CONSTANT added for better constant handling
    * secondadd splitted in multiple routines
    * location_force_reg added for loading a location to a register
      of a specified size
    * secondassignment parses now first the right and then the left node
      (this is compatible with Kylix). This saves a lot of push/pop especially
      with string operations
    * adapted some routines to use the new cg methods

  Revision 1.26  2002/04/01 20:57:13  jonas
    * fixed web bug 1907
    * fixed some other procvar related bugs (all related to accepting procvar
        constructs with either too many or too little parameters)
    (both merged, includes second typo fix of pexpr.pas)

}
