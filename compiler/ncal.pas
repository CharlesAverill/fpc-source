{
    $Id$
    Copyright (c) 1998-2000 by Florian Klaempfl

    This file implements the node for sub procedure calling


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
unit ncal;

{$i defines.inc}

interface

    uses
       node,
       symbase,symsym,symdef,symtable;

    type
       tcallnode = class(tbinarynode)
          { the symbol containing the definition of the procedure }
          { to call                                               }
          symtableprocentry : tprocsym;
          { the symtable containing symtableprocentry }
          symtableproc   : tsymtable;
          { the definition of the procedure to call }
          procdefinition : tabstractprocdef;
          methodpointer  : tnode;
          { only the processor specific nodes need to override this }
          { constructor                                             }
          constructor create(l:tnode; v : tprocsym;st : tsymtable; mp : tnode);virtual;
{$ifdef hascompilerproc}
          constructor createintern(const name: string; params: tnode);
{$endif hascompilerproc}
          destructor destroy;override;
          function  getcopy : tnode;override;
          procedure insertintolist(l : tnodelist);override;
          function  pass_1 : tnode;override;
          function  det_resulttype:tnode;override;
          function  docompare(p: tnode): boolean; override;
          procedure set_procvar(procvar:tnode);
       end;

       tcallparaflags = (
          { flags used by tcallparanode }
          cpf_exact_match_found,
          cpf_convlevel1found,
          cpf_convlevel2found,
          cpf_is_colon_para
       );

       tcallparanode = class(tbinarynode)
          callparaflags : set of tcallparaflags;
          hightree : tnode;
          { only the processor specific nodes need to override this }
          { constructor                                             }
          constructor create(expr,next : tnode);virtual;
          destructor destroy;override;
          function getcopy : tnode;override;
          procedure insertintolist(l : tnodelist);override;
          procedure gen_high_tree(openstring:boolean);
          procedure get_paratype;
          procedure insert_typeconv(defcoll : tparaitem;do_count : boolean);
          procedure det_registers;
          procedure firstcallparan(defcoll : tparaitem;do_count : boolean);
          procedure secondcallparan(defcoll : tparaitem;
                   push_from_left_to_right,inlined,is_cdecl : boolean;
                   para_alignment,para_offset : longint);virtual;abstract;
          function docompare(p: tnode): boolean; override;
       end;

       tprocinlinenode = class(tnode)
          inlinetree : tnode;
          inlineprocsym : tprocsym;
          retoffset,para_offset,para_size : longint;
          constructor create(callp,code : tnode);virtual;
          destructor destroy;override;
          function getcopy : tnode;override;
          procedure insertintolist(l : tnodelist);override;
          function pass_1 : tnode;override;
          function docompare(p: tnode): boolean; override;
       end;

    function reverseparameters(p: tcallparanode): tcallparanode;


    var
       ccallnode : class of tcallnode;
       ccallparanode : class of tcallparanode;
       cprocinlinenode : class of tprocinlinenode;

implementation

    uses
      cutils,globtype,systems,
      verbose,globals,
      symconst,symtype,types,
      htypechk,pass_1,cpubase,
      ncnv,nld,ninl,nadd,ncon,
      tgcpu,cgbase
      ;


{****************************************************************************
                             HELPERS
 ****************************************************************************}

    function reverseparameters(p: tcallparanode): tcallparanode;
      var
        hp1, hp2: tcallparanode;
      begin
        hp1:=nil;
        while assigned(p) do
          begin
             { pull out }
             hp2:=p;
             p:=tcallparanode(p.right);
             { pull in }
             hp2.right:=hp1;
             hp1:=hp2;
          end;
        reverseparameters:=hp1;
      end;



{****************************************************************************
                             TCALLPARANODE
 ****************************************************************************}

    constructor tcallparanode.create(expr,next : tnode);

      begin
         inherited create(callparan,expr,next);
         hightree:=nil;
         if assigned(expr) then
          expr.set_file_line(self);
         callparaflags:=[];
      end;

    destructor tcallparanode.destroy;

      begin
         hightree.free;
         inherited destroy;
      end;

    function tcallparanode.getcopy : tnode;

      var
         n : tcallparanode;

      begin
         n:=tcallparanode(inherited getcopy);
         n.callparaflags:=callparaflags;
         if assigned(hightree) then
           n.hightree:=hightree.getcopy
         else
           n.hightree:=nil;
         result:=n;
      end;

    procedure tcallparanode.insertintolist(l : tnodelist);

      begin
      end;


    procedure tcallparanode.get_paratype;
      var
        old_get_para_resulttype : boolean;
        old_array_constructor : boolean;
      begin
         inc(parsing_para_level);
         if assigned(right) then
          tcallparanode(right).get_paratype;
         old_array_constructor:=allow_array_constructor;
         old_get_para_resulttype:=get_para_resulttype;
         get_para_resulttype:=true;
         allow_array_constructor:=true;
         resulttypepass(left);
         get_para_resulttype:=old_get_para_resulttype;
         allow_array_constructor:=old_array_constructor;
         if codegenerror then
          resulttype:=generrortype
         else
          resulttype:=left.resulttype;
         dec(parsing_para_level);
      end;


    procedure tcallparanode.insert_typeconv(defcoll : tparaitem;do_count : boolean);
      var
        oldtype     : ttype;
{$ifdef extdebug}
        store_count_ref : boolean;
{$endif def extdebug}
      begin
         inc(parsing_para_level);

         if not assigned(defcoll) then
           internalerror(200104261);

{$ifdef extdebug}
         if do_count then
           begin
             store_count_ref:=count_ref;
             count_ref:=true;
           end;
{$endif def extdebug}
         if assigned(right) then
           begin
             { if we are a para that belongs to varargs then keep
               the current defcoll }
             if (nf_varargs_para in flags) then
              tcallparanode(right).insert_typeconv(defcoll,do_count)
             else
              tcallparanode(right).insert_typeconv(tparaitem(defcoll.next),do_count);
           end;

         { Be sure to have the resulttype }
         if not assigned(left.resulttype.def) then
           resulttypepass(left);

         { Handle varargs directly, no typeconvs or typechecking needed }
         if (nf_varargs_para in flags) then
          begin
            { convert pascal to C types }
            case left.resulttype.def.deftype of
              stringdef :
                inserttypeconv(left,charpointertype);
              floatdef :
                inserttypeconv(left,s64floattype);
            end;
            set_varstate(left,true);
            resulttype:=left.resulttype;
            dec(parsing_para_level);
            exit;
          end;

         { Do we need arrayconstructor -> set conversion, then insert
           it here before the arrayconstructor node breaks the tree
           with its conversions of enum->ord }
         if (left.nodetype=arrayconstructorn) and
            (defcoll.paratype.def.deftype=setdef) then
           inserttypeconv(left,defcoll.paratype);

         { set some settings needed for arrayconstructor }
         if is_array_constructor(left.resulttype.def) then
          begin
            if is_array_of_const(defcoll.paratype.def) then
             begin
               if assigned(aktcallprocsym) and
                  (([pocall_cppdecl,pocall_cdecl]*aktcallprocsym.definition.proccalloptions)<>[]) and
                  (po_external in aktcallprocsym.definition.procoptions) then
                 include(left.flags,nf_cargs);
               { force variant array }
               include(left.flags,nf_forcevaria);
             end
            else
             begin
               include(left.flags,nf_novariaallowed);
               { now that the resultting type is know we can insert the required
                 typeconvs for the array constructor }
               tarrayconstructornode(left).force_type(tarraydef(defcoll.paratype.def).elementtype);
             end;
          end;

         { check if local proc/func is assigned to procvar }
         if left.resulttype.def.deftype=procvardef then
           test_local_to_procvar(tprocvardef(left.resulttype.def),defcoll.paratype.def);

         { generate the high() value tree }
         if not(assigned(aktcallprocsym) and
                (([pocall_cppdecl,pocall_cdecl]*aktcallprocsym.definition.proccalloptions)<>[]) and
                (po_external in aktcallprocsym.definition.procoptions)) and
            push_high_param(defcoll.paratype.def) then
           gen_high_tree(is_open_string(defcoll.paratype.def));

         { test conversions }
         if not(is_shortstring(left.resulttype.def) and
                is_shortstring(defcoll.paratype.def)) and
                (defcoll.paratype.def.deftype<>formaldef) then
           begin
              if (defcoll.paratyp in [vs_var,vs_out]) and
              { allows conversion from word to integer and
                byte to shortint, but only for TP7 compatibility }
                (not(
                   (m_tp7 in aktmodeswitches) and
                   (left.resulttype.def.deftype=orddef) and
                   (defcoll.paratype.def.deftype=orddef) and
                   (left.resulttype.def.size=defcoll.paratype.def.size)
                    ) and
              { an implicit pointer conversion is allowed }
                not(
                   (left.resulttype.def.deftype=pointerdef) and
                   (defcoll.paratype.def.deftype=pointerdef)
                    ) and
              { child classes can be also passed }
                not(
                   (left.resulttype.def.deftype=objectdef) and
                   (defcoll.paratype.def.deftype=objectdef) and
                   tobjectdef(left.resulttype.def).is_related(tobjectdef(defcoll.paratype.def))
                   ) and
              { passing a single element to a openarray of the same type }
                not(
                   (is_open_array(defcoll.paratype.def) and
                   is_equal(tarraydef(defcoll.paratype.def).elementtype.def,left.resulttype.def))
                   ) and
              { an implicit file conversion is also allowed }
              { from a typed file to an untyped one           }
                not(
                   (left.resulttype.def.deftype=filedef) and
                   (defcoll.paratype.def.deftype=filedef) and
                   (tfiledef(defcoll.paratype.def).filetyp = ft_untyped) and
                   (tfiledef(left.resulttype.def).filetyp = ft_typed)
                    ) and
                not(is_equal(left.resulttype.def,defcoll.paratype.def))) then
                  begin
                     CGMessagePos2(left.fileinfo,parser_e_call_by_ref_without_typeconv,
                       left.resulttype.def.typename,defcoll.paratype.def.typename);
                  end;
              { Process open parameters }
              if push_high_param(defcoll.paratype.def) then
               begin
                 { insert type conv but hold the ranges of the array }
                 oldtype:=left.resulttype;
                 inserttypeconv(left,defcoll.paratype);
                 left.resulttype:=oldtype;
               end
              else
               begin
                 inserttypeconv(left,defcoll.paratype);
               end;
              if codegenerror then
                begin
                   dec(parsing_para_level);
                   exit;
                end;
           end;

         { check var strings }
         if (cs_strict_var_strings in aktlocalswitches) and
            is_shortstring(left.resulttype.def) and
            is_shortstring(defcoll.paratype.def) and
            (defcoll.paratyp in [vs_out,vs_var]) and
            not(is_open_string(defcoll.paratype.def)) and
            not(is_equal(left.resulttype.def,defcoll.paratype.def)) then
            begin
               aktfilepos:=left.fileinfo;
               CGMessage(type_e_strict_var_string_violation);
            end;

         { Handle formal parameters separate }
         if (defcoll.paratype.def.deftype=formaldef) then
           begin
             case defcoll.paratyp of
               vs_var,
               vs_out :
                 begin
                   if not valid_for_formal_var(left) then
                    CGMessagePos(left.fileinfo,parser_e_illegal_parameter_list);
                 end;
               vs_const :
                 begin
                   if not valid_for_formal_const(left) then
                    CGMessagePos(left.fileinfo,parser_e_illegal_parameter_list);
                 end;
             end;
           end
         else
           begin
             { check if the argument is allowed }
             if (defcoll.paratyp in [vs_out,vs_var]) then
               valid_for_var(left);
           end;

         if defcoll.paratyp in [vs_var,vs_const] then
           begin
              { Causes problems with const ansistrings if also }
              { done for vs_const (JM)                         }
              if defcoll.paratyp = vs_var then
                set_unique(left);
              make_not_regable(left);
           end;

         { ansistrings out paramaters doesn't need to be  }
         { unique, they are finalized                     }
         if defcoll.paratyp=vs_out then
           make_not_regable(left);

         if do_count then
          begin
            { not completly proper, but avoids some warnings }
            if (defcoll.paratyp in [vs_var,vs_out]) then
             set_funcret_is_valid(left);
            set_varstate(left,not(defcoll.paratyp in [vs_var,vs_out]));
          end;
         { must only be done after typeconv PM }
         resulttype:=defcoll.paratype;
         dec(parsing_para_level);
{$ifdef extdebug}
         if do_count then
           count_ref:=store_count_ref;
{$endif def extdebug}
      end;


    procedure tcallparanode.det_registers;
      var
        old_get_para_resulttype : boolean;
        old_array_constructor : boolean;
      begin
         if assigned(right) then
           begin
              tcallparanode(right).det_registers;

              registers32:=right.registers32;
              registersfpu:=right.registersfpu;
{$ifdef SUPPORT_MMX}
              registersmmx:=right.registersmmx;
{$endif}
           end;

         old_array_constructor:=allow_array_constructor;
         old_get_para_resulttype:=get_para_resulttype;
         get_para_resulttype:=true;
         allow_array_constructor:=true;
         firstpass(left);
         get_para_resulttype:=old_get_para_resulttype;
         allow_array_constructor:=old_array_constructor;

         if left.registers32>registers32 then
           registers32:=left.registers32;
         if left.registersfpu>registersfpu then
           registersfpu:=left.registersfpu;
{$ifdef SUPPORT_MMX}
         if left.registersmmx>registersmmx then
           registersmmx:=left.registersmmx;
{$endif SUPPORT_MMX}
      end;


    procedure tcallparanode.firstcallparan(defcoll : tparaitem;do_count : boolean);
      begin
        if not assigned(left.resulttype.def) then
         begin
           get_paratype;
           if assigned(defcoll) then
            insert_typeconv(defcoll,do_count);
         end;
        det_registers;
      end;


    procedure tcallparanode.gen_high_tree(openstring:boolean);
      var
        len : longint;
        st  : tsymtable;
        loadconst : boolean;
        srsym : tsym;
      begin
        if assigned(hightree) then
          exit;
        len:=-1;
        loadconst:=true;
        case left.resulttype.def.deftype of
          arraydef :
            begin
              if is_open_array(left.resulttype.def) or
                 is_array_of_const(left.resulttype.def) then
               begin
                 st:=tloadnode(left).symtable;
                 srsym:=searchsymonlyin(st,'high'+tvarsym(tloadnode(left).symtableentry).name);
                 hightree:=cloadnode.create(tvarsym(srsym),st);
                 loadconst:=false;
               end
              else
                begin
                  { this is an empty constructor }
                  len:=tarraydef(left.resulttype.def).highrange-
                       tarraydef(left.resulttype.def).lowrange;
                end;
            end;
          stringdef :
            begin
              if openstring then
               begin
                 if is_open_string(left.resulttype.def) then
                  begin
                    st:=tloadnode(left).symtable;
                    srsym:=searchsymonlyin(st,'high'+tvarsym(tloadnode(left).symtableentry).name);
                    hightree:=cloadnode.create(tvarsym(srsym),st);
                    loadconst:=false;
                  end
                 else
                  len:=tstringdef(left.resulttype.def).len;
               end
              else
             { passing a string to an array of char }
               begin
                 if (left.nodetype=stringconstn) then
                   begin
                     len:=str_length(left);
                     if len>0 then
                      dec(len);
                   end
                 else
                   begin
                     hightree:=caddnode.create(subn,geninlinenode(in_length_x,false,left.getcopy),
                                               cordconstnode.create(1,s32bittype));
                     firstpass(hightree);
                     hightree:=ctypeconvnode.create(hightree,s32bittype);
                     loadconst:=false;
                   end;
               end;
           end;
        else
          len:=0;
        end;
        if loadconst then
          hightree:=cordconstnode.create(len,s32bittype);
        firstpass(hightree);
      end;


    function tcallparanode.docompare(p: tnode): boolean;
      begin
        docompare :=
          inherited docompare(p) and
          (callparaflags = tcallparanode(p).callparaflags) and
          hightree.isequal(tcallparanode(p).hightree);
      end;

{****************************************************************************
                                 TCALLNODE
 ****************************************************************************}

    constructor tcallnode.create(l:tnode;v : tprocsym;st : tsymtable; mp : tnode);

      begin
         inherited create(calln,l,nil);
         symtableprocentry:=v;
         symtableproc:=st;
         include(flags,nf_return_value_used);
         methodpointer:=mp;
         procdefinition:=nil;
      end;

{$ifdef hascompilerproc}
     constructor tcallnode.createintern(const name: string; params: tnode);
       var
         srsym: tsym;
         symowner: tsymtable;
       begin
         if not (cs_compilesystem in aktmoduleswitches) then
           begin
             srsym := searchsymonlyin(systemunit,name);
             symowner := systemunit;
           end
         else
           begin
             searchsym(name,srsym,symowner);
             if not assigned(srsym) then
               searchsym(upper(name),srsym,symowner);
           end;
         if not assigned(srsym) or
            (srsym.typ <> procsym) then
           internalerror(200107271);
         self.create(params,tprocsym(srsym),symowner,nil);
       end;
{$endif hascompilerproc}

    destructor tcallnode.destroy;
      begin
         methodpointer.free;
         inherited destroy;
      end;


    procedure tcallnode.set_procvar(procvar:tnode);
      begin
        right:=procvar;
      end;


    function tcallnode.getcopy : tnode;
      var
        n : tcallnode;
      begin
        n:=tcallnode(inherited getcopy);
        n.symtableprocentry:=symtableprocentry;
        n.symtableproc:=symtableproc;
        n.procdefinition:=procdefinition;
        if assigned(methodpointer) then
         n.methodpointer:=methodpointer.getcopy
        else
         n.methodpointer:=nil;
        result:=n;
      end;

    procedure tcallnode.insertintolist(l : tnodelist);

      begin
      end;


    function tcallnode.det_resulttype:tnode;
      type
         pprocdefcoll = ^tprocdefcoll;
         tprocdefcoll = record
            data      : tprocdef;
            nextpara  : tparaitem;
            firstpara : tparaitem;
            next      : pprocdefcoll;
         end;
      var
         hp,procs,hp2 : pprocdefcoll;
         pd : tprocdef;
         oldcallprocsym : tprocsym;
         def_from,def_to,conv_to : tdef;
         hpt : tnode;
         pt : tcallparanode;
         exactmatch : boolean;
         paralength,lastpara : longint;
         lastparatype : tdef;
         pdc : tparaitem;
{$ifdef TEST_PROCSYMS}
         nextprocsym : tprocsym;
         symt : tsymtable;
{$endif TEST_PROCSYMS}
         { only Dummy }
         hcvt : tconverttype;
      label
        errorexit;

      { check if the resulttype.def from tree p is equal with def, needed
        for stringconstn and formaldef }
      function is_equal(p:tcallparanode;def:tdef) : boolean;

        begin
           { safety check }
           if not (assigned(def) or assigned(p.resulttype.def)) then
            begin
              is_equal:=false;
              exit;
            end;
           { all types can be passed to a formaldef }
           is_equal:=(def.deftype=formaldef) or
             (types.is_equal(p.resulttype.def,def))
           { integer constants are compatible with all integer parameters if
             the specified value matches the range }
             or
             (
              (tbinarynode(p).left.nodetype=ordconstn) and
              is_integer(p.resulttype.def) and
              is_integer(def) and
              (tordconstnode(p.left).value>=torddef(def).low) and
              (tordconstnode(p.left).value<=torddef(def).high)
             )
           { to support ansi/long/wide strings in a proper way }
           { string and string[10] are assumed as equal }
           { when searching the correct overloaded procedure   }
             or
             (
              (def.deftype=stringdef) and (p.resulttype.def.deftype=stringdef) and
              (tstringdef(def).string_typ=tstringdef(p.resulttype.def).string_typ)
             )
             or
             (
              (p.left.nodetype=stringconstn) and
              (is_ansistring(p.resulttype.def) and is_pchar(def))
             )
             or
             (
              (p.left.nodetype=ordconstn) and
              (is_char(p.resulttype.def) and (is_shortstring(def) or is_ansistring(def)))
             )
           { set can also be a not yet converted array constructor }
             or
             (
              (def.deftype=setdef) and (p.resulttype.def.deftype=arraydef) and
              (tarraydef(p.resulttype.def).IsConstructor) and not(tarraydef(p.resulttype.def).IsVariant)
             )
           { in tp7 mode proc -> procvar is allowed }
             or
             (
              (m_tp_procvar in aktmodeswitches) and
              (def.deftype=procvardef) and (p.left.nodetype=calln) and
              (proc_to_procvar_equal(tprocdef(tcallnode(p.left).procdefinition),tprocvardef(def)))
             )
             ;
        end;

      function is_in_limit(def_from,def_to : tdef) : boolean;

        begin
           is_in_limit:=(def_from.deftype = orddef) and
                        (def_to.deftype = orddef) and
                        (torddef(def_from).low>torddef(def_to).low) and
                        (torddef(def_from).high<torddef(def_to).high);
        end;

      var
        i : longint;
        is_const : boolean;
        bestord  : torddef;
      begin
         result:=nil;

         procs:=nil;

         oldcallprocsym:=aktcallprocsym;
         aktcallprocsym:=nil;

         { determine length of parameter list }
         pt:=tcallparanode(left);
         paralength:=0;
         while assigned(pt) do
          begin
            inc(paralength);
            pt:=tcallparanode(pt.right);
          end;

         { determine the type of the parameters }
         if assigned(left) then
          begin
            tcallparanode(left).get_paratype;
            if codegenerror then
             goto errorexit;
          end;

         { procedure variable ? }
         if assigned(right) then
           begin
              set_varstate(right,true);
              resulttypepass(right);
              if codegenerror then
               exit;

              procdefinition:=tabstractprocdef(right.resulttype.def);

              { check the amount of parameters }
              pdc:=tparaitem(procdefinition.Para.first);
              pt:=tcallparanode(left);
              lastpara:=paralength;
              while assigned(pdc) and assigned(pt) do
                begin
                  { only goto next para if we're out of the varargs }
                  if not(po_varargs in procdefinition.procoptions) or
                     (lastpara<=procdefinition.maxparacount) then
                    pdc:=tparaitem(pdc.next);
                  pt:=tcallparanode(pt.right);
                  dec(lastpara);
                end;
              if assigned(pt) or assigned(pdc) then
                begin
                   if assigned(pt) then
                     aktfilepos:=pt.fileinfo;
                   CGMessage(parser_e_wrong_parameter_size);
                end;
           end
         else
         { not a procedure variable }
           begin
              aktcallprocsym:=tprocsym(symtableprocentry);
              { do we know the procedure to call ? }
              if not(assigned(procdefinition)) then
                begin
{$ifdef TEST_PROCSYMS}
                 if (unit_specific) or
                    assigned(methodpointer) then
                   nextprocsym:=nil
                 else while not assigned(procs) do
                  begin
                     symt:=symtableproc;
                     srsym:=nil;
                     while assigned(symt^.next) and not assigned(srsym) do
                       begin
                          symt:=symt^.next;
                          srsym:=searchsymonlyin(symt,actprocsym.name);
                          if assigned(srsym) then
                            if srsym.typ<>procsym then
                              begin
                                 { reject all that is not a procedure }
                                 srsym:=nil;
                                 { don't search elsewhere }
                                 while assigned(symt^.next) do
                                   symt:=symt^.next;
                              end;
                       end;
                     nextprocsym:=srsym;
                  end;
{$endif TEST_PROCSYMS}
                   { link all procedures which have the same # of parameters }
                   pd:=aktcallprocsym.definition;
                   while assigned(pd) do
                     begin
                        { only when the # of parameter are supported by the
                          procedure }
                        if (paralength>=pd.minparacount) and
                           ((po_varargs in pd.procoptions) or { varargs }
                            (paralength<=pd.maxparacount)) then
                          begin
                             new(hp);
                             hp^.data:=pd;
                             hp^.next:=procs;
                             hp^.firstpara:=tparaitem(pd.Para.first);
                             if not(po_varargs in pd.procoptions) then
                              begin
                                { if not all parameters are given, then skip the
                                  default parameters }
                                for i:=1 to pd.maxparacount-paralength do
                                 hp^.firstpara:=tparaitem(hp^.firstPara.next);
                              end;
                             hp^.nextpara:=hp^.firstpara;
                             procs:=hp;
                          end;
                        pd:=pd.nextoverloaded;
                     end;

                   { no procedures found? then there is something wrong
                     with the parameter size }
                   if not assigned(procs) then
                    begin
                      { in tp mode we can try to convert to procvar if
                        there are no parameters specified }
                      if not(assigned(left)) and
                         (m_tp_procvar in aktmodeswitches) then
                        begin
                          hpt:=cloadnode.create(tprocsym(symtableprocentry),symtableproc);
                          if (symtableprocentry.owner.symtabletype=objectsymtable) and
                             assigned(methodpointer) then
                            tloadnode(hpt).set_mp(methodpointer.getcopy);
                          resulttypepass(hpt);
                          right:=hpt;
                        end
                      else
                        begin
                          if assigned(left) then
                           aktfilepos:=left.fileinfo;
                          CGMessage(parser_e_wrong_parameter_size);
                          aktcallprocsym.write_parameter_lists(nil);
                        end;
                      goto errorexit;
                    end;

                { now we can compare parameter after parameter }
                   pt:=tcallparanode(left);
                   { we start with the last parameter }
                   lastpara:=paralength+1;
                   lastparatype:=nil;
                   while assigned(pt) do
                     begin
                        dec(lastpara);
                        { walk all procedures and determine how this parameter matches and set:
                           1. pt.exact_match_found if one parameter has an exact match
                           2. exactmatch if an equal or exact match is found

                           3. Para.argconvtyp to exact,equal or convertable
                                (when convertable then also convertlevel is set)
                           4. pt.convlevel1found if there is a convertlevel=1
                           5. pt.convlevel2found if there is a convertlevel=2
                        }
                        exactmatch:=false;
                        hp:=procs;
                        while assigned(hp) do
                          begin
                             { varargs are always equal, but not exact }
                             if (po_varargs in hp^.data.procoptions) and
                                (lastpara>hp^.data.minparacount) then
                              begin
                                hp^.nextPara.argconvtyp:=act_equal;
                                exactmatch:=true;
                              end
                             else
                              begin
                                if is_equal(pt,hp^.nextPara.paratype.def) then
                                 begin
                                   if hp^.nextPara.paratype.def=pt.resulttype.def then
                                    begin
                                       include(pt.callparaflags,cpf_exact_match_found);
                                       hp^.nextPara.argconvtyp:=act_exact;
                                    end
                                   else
                                    hp^.nextPara.argconvtyp:=act_equal;
                                   exactmatch:=true;
                                 end
                                else
                                 begin
                                   hp^.nextPara.argconvtyp:=act_convertable;
                                   hp^.nextPara.convertlevel:=isconvertable(pt.resulttype.def,hp^.nextPara.paratype.def,
                                       hcvt,pt.left.nodetype,false);
                                   case hp^.nextPara.convertlevel of
                                    1 : include(pt.callparaflags,cpf_convlevel1found);
                                    2 : include(pt.callparaflags,cpf_convlevel2found);
                                   end;
                                 end;
                              end;

                             hp:=hp^.next;
                          end;

                        { If there was an exactmatch then delete all convertables }
                        if exactmatch then
                          begin
                            hp:=procs;
                            procs:=nil;
                            while assigned(hp) do
                              begin
                                 hp2:=hp^.next;
                                 { keep if not convertable }
                                 if (hp^.nextPara.argconvtyp<>act_convertable) then
                                  begin
                                    hp^.next:=procs;
                                    procs:=hp;
                                  end
                                 else
                                  dispose(hp);
                                 hp:=hp2;
                              end;
                          end
                        else
                        { No exact match was found, remove all procedures that are
                          not convertable (convertlevel=0) }
                          begin
                            hp:=procs;
                            procs:=nil;
                            while assigned(hp) do
                              begin
                                 hp2:=hp^.next;
                                 { keep if not convertable }
                                 if (hp^.nextPara.convertlevel<>0) then
                                  begin
                                    hp^.next:=procs;
                                    procs:=hp;
                                  end
                                 else
                                  begin
                                    { save the type for nice error message }
                                    lastparatype:=hp^.nextPara.paratype.def;
                                    dispose(hp);
                                  end;
                                 hp:=hp2;
                              end;
                          end;
                        { update nextpara for all procedures }
                        hp:=procs;
                        while assigned(hp) do
                          begin
                            { only goto next para if we're out of the varargs }
                            if not(po_varargs in hp^.data.procoptions) or
                               (lastpara<=hp^.data.maxparacount) then
                              hp^.nextpara:=tparaitem(hp^.nextPara.next);
                            hp:=hp^.next;
                          end;
                        { load next parameter or quit loop if no procs left }
                        if assigned(procs) then
                          pt:=tcallparanode(pt.right)
                        else
                          break;
                     end;

                 { All parameters are checked, check if there are any
                   procedures left }
                   if not assigned(procs) then
                    begin
                      { there is an error, must be wrong type, because
                        wrong size is already checked (PFV) }
                      if (not assigned(lastparatype)) or
                         (not assigned(pt)) or
                         (not assigned(pt.resulttype.def)) then
                        internalerror(39393)
                      else
                        begin
                          aktfilepos:=pt.fileinfo;
                          CGMessage3(type_e_wrong_parameter_type,tostr(lastpara),
                            pt.resulttype.def.typename,lastparatype.typename);
                        end;
                      aktcallprocsym.write_parameter_lists(nil);
                      goto errorexit;
                    end;

                   { if there are several choices left then for orddef }
                   { if a type is totally included in the other        }
                   { we don't fear an overflow ,                       }
                   { so we can do as if it is an exact match           }
                   { this will convert integer to longint              }
                   { rather than to words                              }
                   { conversion of byte to integer or longint          }
                   { would still not be solved                         }
                   if assigned(procs) and assigned(procs^.next) then
                     begin
                        hp:=procs;
                        while assigned(hp) do
                          begin
                            hp^.nextpara:=hp^.firstpara;
                            hp:=hp^.next;
                          end;
                        pt:=tcallparanode(left);
                        while assigned(pt) do
                          begin
                             { matches a parameter of one procedure exact ? }
                             exactmatch:=false;
                             def_from:=pt.resulttype.def;
                             hp:=procs;
                             while assigned(hp) do
                               begin
                                  if not is_equal(pt,hp^.nextPara.paratype.def) then
                                    begin
                                       def_to:=hp^.nextPara.paratype.def;
                                       if ((def_from.deftype=orddef) and (def_to.deftype=orddef)) and
                                         (is_in_limit(def_from,def_to) or
                                         ((hp^.nextPara.paratyp in [vs_var,vs_out]) and
                                         (def_from.size=def_to.size))) then
                                         begin
                                            exactmatch:=true;
                                            conv_to:=def_to;
                                         end;
                                    end;
                                  hp:=hp^.next;
                               end;

                             { .... if yes, del all the other procedures }
                             if exactmatch then
                               begin
                                  { the first .... }
                                  while (assigned(procs)) and not(is_in_limit(def_from,procs^.nextPara.paratype.def)) do
                                    begin
                                       hp:=procs^.next;
                                       dispose(procs);
                                       procs:=hp;
                                    end;
                                  { and the others }
                                  hp:=procs;
                                  while (assigned(hp)) and assigned(hp^.next) do
                                    begin
                                       if not(is_in_limit(def_from,hp^.next^.nextPara.paratype.def)) then
                                         begin
                                            hp2:=hp^.next^.next;
                                            dispose(hp^.next);
                                            hp^.next:=hp2;
                                         end
                                       else
                                         begin
                                           def_to:=hp^.next^.nextPara.paratype.def;
                                           if (conv_to.size>def_to.size) or
                                              ((torddef(conv_to).low<torddef(def_to).low) and
                                              (torddef(conv_to).high>torddef(def_to).high)) then
                                             begin
                                                hp2:=procs;
                                                procs:=hp;
                                                conv_to:=def_to;
                                                dispose(hp2);
                                             end
                                           else
                                             hp:=hp^.next;
                                         end;
                                    end;
                               end;
                             { update nextpara for all procedures }
                             hp:=procs;
                             while assigned(hp) do
                               begin
                                  hp^.nextpara:=tparaitem(hp^.nextPara.next);
                                  hp:=hp^.next;
                               end;
                             pt:=tcallparanode(pt.right);
                          end;
                     end;

                   { let's try to eliminate equal if there is an exact match
                     is there }
                   if assigned(procs) and assigned(procs^.next) then
                     begin
                        { reset nextpara for all procs left }
                        hp:=procs;
                        while assigned(hp) do
                         begin
                           hp^.nextpara:=hp^.firstpara;
                           hp:=hp^.next;
                         end;

                        pt:=tcallparanode(left);
                        while assigned(pt) do
                          begin
                             if cpf_exact_match_found in pt.callparaflags then
                               begin
                                 hp:=procs;
                                 procs:=nil;
                                 while assigned(hp) do
                                   begin
                                      hp2:=hp^.next;
                                      { keep the exact matches, dispose the others }
                                      if (hp^.nextPara.argconvtyp=act_exact) then
                                       begin
                                         hp^.next:=procs;
                                         procs:=hp;
                                       end
                                      else
                                       dispose(hp);
                                      hp:=hp2;
                                   end;
                               end;
                             { update nextpara for all procedures }
                             hp:=procs;
                             while assigned(hp) do
                               begin
                                  hp^.nextpara:=tparaitem(hp^.nextPara.next);
                                  hp:=hp^.next;
                               end;
                             pt:=tcallparanode(pt.right);
                          end;
                     end;

                   { Check if there are integer constant to integer
                     parameters then choose the best matching integer
                     parameter and remove the others, this is Delphi
                     compatible. 1 = byte, 256 = word, etc. }
                   if assigned(procs) and assigned(procs^.next) then
                     begin
                        { reset nextpara for all procs left }
                        hp:=procs;
                        while assigned(hp) do
                         begin
                           hp^.nextpara:=hp^.firstpara;
                           hp:=hp^.next;
                         end;

                        pt:=tcallparanode(left);
                        while assigned(pt) do
                          begin
                            bestord:=nil;
                            if (pt.left.nodetype=ordconstn) and
                               is_integer(pt.resulttype.def) then
                             begin
                               hp:=procs;
                               while assigned(hp) do
                                begin
                                  def_to:=hp^.nextPara.paratype.def;
                                  { to be sure, it couldn't be something else,
                                    also the defs here are all in the range
                                    so now find the closest range }
                                  if not is_integer(def_to) then
                                   internalerror(43297815);
                                  if (not assigned(bestord)) or
                                     ((torddef(def_to).low>bestord.low) or
                                      (torddef(def_to).high<bestord.high)) then
                                   bestord:=torddef(def_to);
                                  hp:=hp^.next;
                                end;
                             end;
                            { if a bestmatch is found then remove the other
                              procs which don't match the bestord }
                            if assigned(bestord) then
                             begin
                               hp:=procs;
                               procs:=nil;
                               while assigned(hp) do
                                begin
                                  hp2:=hp^.next;
                                  { keep matching bestord, dispose the others }
                                  if (torddef(hp^.nextPara.paratype.def)=bestord) then
                                   begin
                                     hp^.next:=procs;
                                     procs:=hp;
                                   end
                                  else
                                   dispose(hp);
                                  hp:=hp2;
                                end;
                             end;

                            { update nextpara for all procedures }
                            hp:=procs;
                            while assigned(hp) do
                             begin
                               hp^.nextpara:=tparaitem(hp^.nextPara.next);
                               hp:=hp^.next;
                             end;
                            pt:=tcallparanode(pt.right);
                          end;
                     end;

                   { Check if there are convertlevel 1 and 2 differences
                     left for the parameters, then discard all convertlevel
                     2 procedures. The value of convlevelXfound can still
                     be used, because all convertables are still here or
                     not }
                   if assigned(procs) and assigned(procs^.next) then
                     begin
                        { reset nextpara for all procs left }
                        hp:=procs;
                        while assigned(hp) do
                         begin
                           hp^.nextpara:=hp^.firstpara;
                           hp:=hp^.next;
                         end;

                        pt:=tcallparanode(left);
                        while assigned(pt) do
                          begin
                             if (cpf_convlevel1found in pt.callparaflags) and
                               (cpf_convlevel2found in pt.callparaflags) then
                               begin
                                 hp:=procs;
                                 procs:=nil;
                                 while assigned(hp) do
                                   begin
                                      hp2:=hp^.next;
                                      { keep all not act_convertable and all convertlevels=1 }
                                      if (hp^.nextPara.argconvtyp<>act_convertable) or
                                         (hp^.nextPara.convertlevel=1) then
                                       begin
                                         hp^.next:=procs;
                                         procs:=hp;
                                       end
                                      else
                                       dispose(hp);
                                      hp:=hp2;
                                   end;
                               end;
                             { update nextpara for all procedures }
                             hp:=procs;
                             while assigned(hp) do
                               begin
                                  hp^.nextpara:=tparaitem(hp^.nextPara.next);
                                  hp:=hp^.next;
                               end;
                             pt:=tcallparanode(pt.right);
                          end;
                     end;

                   if not(assigned(procs)) or assigned(procs^.next) then
                     begin
                        CGMessage(cg_e_cant_choose_overload_function);
                        aktcallprocsym.write_parameter_lists(nil);
                        goto errorexit;
                     end;
{$ifdef TEST_PROCSYMS}
                   if (procs=nil) and assigned(nextprocsym) then
                     begin
                        symtableprocentry:=nextprocsym;
                        symtableproc:=symt;
                     end;
                 end ; { of while assigned(symtableprocentry) do }
{$endif TEST_PROCSYMS}
                   if make_ref then
                     begin
                        procs^.data.lastref:=tref.create(procs^.data.lastref,@fileinfo);
                        inc(procs^.data.refcount);
                        if procs^.data.defref=nil then
                          procs^.data.defref:=procs^.data.lastref;
                     end;

                   procdefinition:=procs^.data;
                   { big error for with statements
                   symtableproc:=procdefinition.owner;
                   but neede for overloaded operators !! }
                   if symtableproc=nil then
                     symtableproc:=procdefinition.owner;

{$ifdef CHAINPROCSYMS}
                   { object with method read;
                     call to read(x) will be a usual procedure call }
                   if assigned(methodpointer) and
                     (procdefinition._class=nil) then
                     begin
                        { not ok for extended }
                        case methodpointer^.nodetype of
                           typen,hnewn : fatalerror(no_para_match);
                        end;
                        methodpointer.free;
                        methodpointer:=nil;
                     end;
{$endif CHAINPROCSYMS}
               end; { end of procedure to call determination }


              { add needed default parameters }
              if assigned(procs) and
                 (paralength<procdefinition.maxparacount) then
               begin
                 { add default parameters, just read back the skipped
                   paras starting from firstPara.previous, when not available
                   (all parameters are default) then start with the last
                   parameter and read backward (PFV) }
                 if not assigned(procs^.firstpara) then
                  pdc:=tparaitem(procs^.data.Para.last)
                 else
                  pdc:=tparaitem(procs^.firstPara.previous);
                 while assigned(pdc) do
                  begin
                    if not assigned(pdc.defaultvalue) then
                     internalerror(751349858);
                    left:=ccallparanode.create(genconstsymtree(tconstsym(pdc.defaultvalue)),left);
                    pdc:=tparaitem(pdc.previous);
                  end;
               end;
           end;

          { handle predefined procedures }
          is_const:=(pocall_internconst in procdefinition.proccalloptions) and
                    ((block_type in [bt_const,bt_type]) or
                     (assigned(left) and (tcallparanode(left).left.nodetype in [realconstn,ordconstn])));
          if (pocall_internproc in procdefinition.proccalloptions) or is_const then
           begin
             if assigned(left) then
              begin
                { ptr and settextbuf needs two args }
                if assigned(tcallparanode(left).right) then
                 begin
                   hpt:=geninlinenode(tprocdef(procdefinition).extnumber,is_const,left);
                   left:=nil;
                 end
                else
                 begin
                   hpt:=geninlinenode(tprocdef(procdefinition).extnumber,is_const,tcallparanode(left).left);
                   tcallparanode(left).left:=nil;
                 end;
              end
             else
              hpt:=geninlinenode(tprocdef(procdefinition).extnumber,is_const,nil);
             resulttypepass(hpt);
             result:=hpt;
             goto errorexit;
           end;

         { Calling a message method directly ? }
         if assigned(procdefinition) and
            (po_containsself in procdefinition.procoptions) then
           message(cg_e_cannot_call_message_direct);

         { ensure that the result type is set }
         resulttype:=procdefinition.rettype;

         { get a register for the return value }
         if (not is_void(resulttype.def)) then
          begin
            if ret_in_acc(resulttype.def) then
             begin
               { wide- and ansistrings are returned in EAX    }
               { but they are imm. moved to a memory location }
               if is_widestring(resulttype.def) or
                  is_ansistring(resulttype.def) then
                 begin
                   { we use ansistrings so no fast exit here }
                   procinfo^.no_fast_exit:=true;
                 end;
             end;
          end;

         { constructors return their current class type, not the type where the
           constructor is declared, this can be different because of inheritance }
         if (procdefinition.proctypeoption=potype_constructor) then
           begin
             if assigned(methodpointer) and
                assigned(methodpointer.resulttype.def) and
                (methodpointer.resulttype.def.deftype=classrefdef) then
               resulttype:=tclassrefdef(methodpointer.resulttype.def).pointertype;
           end;

         { flag all callparanodes that belong to the varargs }
         if (po_varargs in procdefinition.procoptions) then
          begin
            pt:=tcallparanode(left);
            i:=paralength;
            while (i>procdefinition.maxparacount) do
             begin
               include(tcallparanode(pt).flags,nf_varargs_para);
               pt:=tcallparanode(pt.right);
               dec(i);
             end;
          end;

         { insert type conversions }
         if assigned(left) then
          tcallparanode(left).insert_typeconv(tparaitem(procdefinition.Para.first),true);

      errorexit:
         { Reset some settings back }
         if assigned(procs) then
           dispose(procs);
         aktcallprocsym:=oldcallprocsym;
      end;


    function tcallnode.pass_1 : tnode;
      var
         inlinecode : tnode;
         inlined : boolean;
{$ifdef m68k}
         regi : tregister;
{$endif}
         method_must_be_valid : boolean;
      label
        errorexit;
      begin
         result:=nil;
         inlined:=false;

         { work trough all parameters to get the register requirements }
         if assigned(left) then
           tcallparanode(left).det_registers;

         if assigned(procdefinition) and
            (pocall_inline in procdefinition.proccalloptions) then
           begin
              inlinecode:=right;
              if assigned(inlinecode) then
                begin
                   inlined:=true;
                   exclude(procdefinition.proccalloptions,pocall_inline);
                end;
              right:=nil;
           end;

         { procedure variable ? }
         if assigned(right) then
           begin
              firstpass(right);

              { procedure does a call }
              if not (block_type in [bt_const,bt_type]) then
                procinfo^.flags:=procinfo^.flags or pi_do_call;
{$ifndef newcg}
              { calc the correct value for the register }
{$ifdef i386}
              incrementregisterpushed($ff);
{$else}
              incrementregisterpushed(ALL_REGISTERS);
{$endif}
{$endif newcg}
           end
         else
         { not a procedure variable }
           begin
              location.loc:=LOC_MEM;

              { calc the correture value for the register }
              { handle predefined procedures }
              if (pocall_inline in procdefinition.proccalloptions) then
                begin
                   if assigned(methodpointer) then
                     CGMessage(cg_e_unable_inline_object_methods);
                   if assigned(right) and (right.nodetype<>procinlinen) then
                     CGMessage(cg_e_unable_inline_procvar);
                   { nodetype:=procinlinen; }
                   if not assigned(right) then
                     begin
                        if assigned(tprocdef(procdefinition).code) then
                          inlinecode:=cprocinlinenode.create(self,tnode(tprocdef(procdefinition).code))
                        else
                          CGMessage(cg_e_no_code_for_inline_stored);
                        if assigned(inlinecode) then
                          begin
                             { consider it has not inlined if called
                               again inside the args }
                             exclude(procdefinition.proccalloptions,pocall_inline);
                             firstpass(inlinecode);
                             inlined:=true;
                          end;
                     end;
                end
              else
                begin
                  if not (block_type in [bt_const,bt_type]) then
                    procinfo^.flags:=procinfo^.flags or pi_do_call;
                end;

{$ifndef newcg}
{$ifndef POWERPC}
             { for the PowerPC standard calling conventions this information isn't necassary (FK) }
             incrementregisterpushed(tprocdef(procdefinition).usedregisters);
{$endif POWERPC}
{$endif newcg}
           end;

         { get a register for the return value }
         if (not is_void(resulttype.def)) then
           begin
              if (procdefinition.proctypeoption=potype_constructor) then
                begin
                   { extra handling of classes }
                   { methodpointer should be assigned! }
                   if assigned(methodpointer) and
                      assigned(methodpointer.resulttype.def) and
                      (methodpointer.resulttype.def.deftype=classrefdef) then
                     begin
                        location.loc:=LOC_REGISTER;
                        registers32:=1;
                     end
                  { a object constructor returns the result with the flags }
                   else
                     location.loc:=LOC_FLAGS;
                end
              else
                begin
{$ifdef SUPPORT_MMX}
                   if (cs_mmx in aktlocalswitches) and
                     is_mmx_able_array(resulttype.def) then
                     begin
                        location.loc:=LOC_MMXREGISTER;
                        registersmmx:=1;
                     end
                   else
{$endif SUPPORT_MMX}
                   if ret_in_acc(resulttype.def) then
                     begin
                        location.loc:=LOC_REGISTER;
                        if is_64bitint(resulttype.def) then
                          registers32:=2
                        else
                          registers32:=1;

                        { wide- and ansistrings are returned in EAX    }
                        { but they are imm. moved to a memory location }
                        if is_widestring(resulttype.def) or
                           is_ansistring(resulttype.def) then
                          begin
                             location.loc:=LOC_MEM;
                             registers32:=1;
                          end;
                     end
                   else if (resulttype.def.deftype=floatdef) then
                     begin
                       location.loc:=LOC_FPU;
{$ifdef m68k}
                       if (cs_fp_emulation in aktmoduleswitches) or
                          (tfloatdef(resulttype.def).typ=s32real) then
                         registers32:=1
                       else
                         registersfpu:=1;
{$else not m68k}
                        registersfpu:=1;
{$endif not m68k}
                     end
                   else
                     location.loc:=LOC_MEM;
                end;
           end;
         { a fpu can be used in any procedure !! }
         registersfpu:=procdefinition.fpu_used;
         { if this is a call to a method calc the registers }
         if (methodpointer<>nil) then
           begin
              case methodpointer.nodetype of
                { but only, if this is not a supporting node }
                typen: ;
                { we need one register for new return value PM }
                hnewn : if registers32=0 then
                          registers32:=1;
                else
                  begin
                     if (procdefinition.proctypeoption in [potype_constructor,potype_destructor]) and
                        assigned(symtableproc) and (symtableproc.symtabletype=withsymtable) and
                        not twithsymtable(symtableproc).direct_with then
                       begin
                          CGmessage(cg_e_cannot_call_cons_dest_inside_with);
                       end; { Is accepted by Delphi !! }
                     { this is not a good reason to accept it in FPC if we produce
                       wrong code for it !!! (PM) }

                     { R.Assign is not a constructor !!! }
                     { but for R^.Assign, R must be valid !! }
                     if (procdefinition.proctypeoption=potype_constructor) or
                        ((methodpointer.nodetype=loadn) and
                        (not(oo_has_virtual in tobjectdef(methodpointer.resulttype.def).objectoptions))) then
                       method_must_be_valid:=false
                     else
                       method_must_be_valid:=true;
                     firstpass(methodpointer);
                     set_varstate(methodpointer,method_must_be_valid);
                     { The object is already used ven if it is called once }
                     if (methodpointer.nodetype=loadn) and
                        (tloadnode(methodpointer).symtableentry.typ=varsym) then
                       tvarsym(tloadnode(methodpointer).symtableentry).varstate:=vs_used;

                     registersfpu:=max(methodpointer.registersfpu,registersfpu);
                     registers32:=max(methodpointer.registers32,registers32);
{$ifdef SUPPORT_MMX}
                     registersmmx:=max(methodpointer.registersmmx,registersmmx);
{$endif SUPPORT_MMX}
                  end;
              end;
           end;

         if inlined then
           right:=inlinecode;
         { determine the registers of the procedure variable }
         { is this OK for inlined procs also ?? (PM)     }
         if assigned(right) then
           begin
              registersfpu:=max(right.registersfpu,registersfpu);
              registers32:=max(right.registers32,registers32);
{$ifdef SUPPORT_MMX}
              registersmmx:=max(right.registersmmx,registersmmx);
{$endif SUPPORT_MMX}
           end;
         { determine the registers of the procedure }
         if assigned(left) then
           begin
              registersfpu:=max(left.registersfpu,registersfpu);
              registers32:=max(left.registers32,registers32);
{$ifdef SUPPORT_MMX}
              registersmmx:=max(left.registersmmx,registersmmx);
{$endif SUPPORT_MMX}
           end;
      errorexit:
         if inlined then
           include(procdefinition.proccalloptions,pocall_inline);
      end;


    function tcallnode.docompare(p: tnode): boolean;
      begin
        docompare :=
          inherited docompare(p) and
          (symtableprocentry = tcallnode(p).symtableprocentry) and
          (symtableproc = tcallnode(p).symtableproc) and
          (procdefinition = tcallnode(p).procdefinition) and
          (methodpointer = tcallnode(p).methodpointer);
      end;

{****************************************************************************
                            TPROCINLINENODE
 ****************************************************************************}

    constructor tprocinlinenode.create(callp,code : tnode);

      begin
         inherited create(procinlinen);
         inlineprocsym:=tcallnode(callp).symtableprocentry;
         retoffset:=-target_info.size_of_pointer; { less dangerous as zero (PM) }
         para_offset:=0;
         para_size:=inlineprocsym.definition.para_size(target_info.alignment.paraalign);
         if ret_in_param(inlineprocsym.definition.rettype.def) then
           inc(para_size,target_info.size_of_pointer);
         { copy args }
         if assigned(code) then
           inlinetree:=code.getcopy
         else inlinetree := nil;
         registers32:=code.registers32;
         registersfpu:=code.registersfpu;
{$ifdef SUPPORT_MMX}
         registersmmx:=code.registersmmx;
{$endif SUPPORT_MMX}
         resulttype:=inlineprocsym.definition.rettype;
      end;

    destructor tprocinlinenode.destroy;
      begin
        if assigned(inlinetree) then
          inlinetree.free;
        inherited destroy;
      end;

    function tprocinlinenode.getcopy : tnode;

      var
         n : tprocinlinenode;

      begin
         n:=tprocinlinenode(inherited getcopy);
         if assigned(inlinetree) then
           n.inlinetree:=inlinetree.getcopy
         else
           n.inlinetree:=nil;
         n.inlineprocsym:=inlineprocsym;
         n.retoffset:=retoffset;
         n.para_offset:=para_offset;
         n.para_size:=para_size;
         getcopy:=n;
      end;

    procedure tprocinlinenode.insertintolist(l : tnodelist);

      begin
      end;

    function tprocinlinenode.pass_1 : tnode;
      begin
        result:=nil;
        { left contains the code in tree form }
        { but it has already been firstpassed }
        { so firstpass(left); does not seem required }
        { might be required later if we change the arg handling !! }
      end;

    function tprocinlinenode.docompare(p: tnode): boolean;
      begin
        docompare :=
          inherited docompare(p) and
          inlinetree.isequal(tprocinlinenode(p).inlinetree) and
          (inlineprocsym = tprocinlinenode(p).inlineprocsym);
      end;

begin
   ccallnode:=tcallnode;
   ccallparanode:=tcallparanode;
   cprocinlinenode:=tprocinlinenode;
end.
{
  $Log$
  Revision 1.45  2001-08-26 13:36:39  florian
    * some cg reorganisation
    * some PPC updates

  Revision 1.44  2001/08/24 13:47:27  jonas
    * moved "reverseparameters" from ninl.pas to ncal.pas
    + support for non-persistent temps in ttempcreatenode.create, for use
      with typeconversion nodes

  Revision 1.43  2001/08/23 14:28:35  jonas
    + tempcreate/ref/delete nodes (allows the use of temps in the
      resulttype and first pass)
    * made handling of read(ln)/write(ln) processor independent
    * moved processor independent handling for str and reset/rewrite-typed
      from firstpass to resulttype pass
    * changed names of helpers in text.inc to be generic for use as
      compilerprocs + added "iocheck" directive for most of them
    * reading of ordinals is done by procedures instead of functions
      because otherwise FPC_IOCHECK overwrote the result before it could
      be stored elsewhere (range checking still works)
    * compilerprocs can now be used in the system unit before they are
      implemented
    * added note to errore.msg that booleans can't be read using read/readln

  Revision 1.42  2001/08/19 21:11:20  florian
    * some bugs fix:
      - overload; with external procedures fixed
      - better selection of routine to do an overloaded
        type case
      - ... some more

  Revision 1.41  2001/08/13 12:41:56  jonas
    * made code for str(x,y) completely processor independent

  Revision 1.40  2001/08/06 21:40:46  peter
    * funcret moved from tprocinfo to tprocdef

  Revision 1.39  2001/08/01 15:07:29  jonas
    + "compilerproc" directive support, which turns both the public and mangled
      name to lowercase(declaration_name). This prevents a normal user from
      accessing the routine, but they can still be easily looked up within
      the compiler. This is used for helper procedures and should facilitate
      the writing of more processor independent code in the code generator
      itself (mostly written by Peter)
    + new "createintern" constructor for tcal nodes to create a call to
      helper exported using the "compilerproc" directive
    + support for high(dynamic_array) using the the above new things
    + definition of 'HASCOMPILERPROC' symbol (to be able to check in the
      compiler and rtl whether the "compilerproc" directive is supported)

  Revision 1.38  2001/07/30 20:52:25  peter
    * fixed array constructor passing with type conversions

  Revision 1.37  2001/07/09 21:15:40  peter
    * Length made internal
    * Add array support for Length

  Revision 1.36  2001/07/01 20:16:15  peter
    * alignmentinfo record added
    * -Oa argument supports more alignment settings that can be specified
      per type: PROC,LOOP,VARMIN,VARMAX,CONSTMIN,CONSTMAX,RECORDMIN
      RECORDMAX,LOCALMIN,LOCALMAX. It is possible to set the mimimum
      required alignment and the maximum usefull alignment. The final
      alignment will be choosen per variable size dependent on these
      settings

  Revision 1.35  2001/06/04 18:08:19  peter
    * procvar support for varargs

  Revision 1.34  2001/06/04 11:48:02  peter
    * better const to var checking

  Revision 1.33  2001/05/20 12:09:31  peter
    * fixed exit with ansistring return from function call, no_fast_exit
      should be set in det_resulttype instead of pass_1

  Revision 1.32  2001/04/26 21:55:05  peter
    * defcoll must be assigned in insert_typeconv

  Revision 1.31  2001/04/21 12:03:11  peter
    * m68k updates merged from fixes branch

  Revision 1.30  2001/04/18 22:01:54  peter
    * registration of targets and assemblers

  Revision 1.29  2001/04/13 23:52:29  peter
    * don't allow passing signed-unsigned ords to var parameter, this
      forbids smallint-word, shortint-byte, longint-cardinal mixtures.
      It's still allowed in tp7 -So mode.

  Revision 1.28  2001/04/13 22:22:59  peter
    * call set_varstate for procvar calls

  Revision 1.27  2001/04/13 01:22:08  peter
    * symtable change to classes
    * range check generation and errors fixed, make cycle DEBUG=1 works
    * memory leaks fixed

  Revision 1.26  2001/04/04 22:42:39  peter
    * move constant folding into det_resulttype

  Revision 1.25  2001/04/02 21:20:30  peter
    * resulttype rewrite

  Revision 1.24  2001/03/12 12:47:46  michael
  + Patches from peter

  Revision 1.23  2001/02/26 19:44:52  peter
    * merged generic m68k updates from fixes branch

  Revision 1.22  2001/01/08 21:46:46  peter
    * don't push high value for open array with cdecl;external;

  Revision 1.21  2000/12/31 11:14:10  jonas
    + implemented/fixed docompare() mathods for all nodes (not tested)
    + nopt.pas, nadd.pas, i386/n386opt.pas: optimized nodes for adding strings
      and constant strings/chars together
    * n386add.pas: don't copy temp strings (of size 256) to another temp string
      when adding

  Revision 1.20  2000/12/25 00:07:26  peter
    + new tlinkedlist class (merge of old tstringqueue,tcontainer and
      tlinkedlist objects)

  Revision 1.19  2000/12/17 14:35:12  peter
    * fixed crash with procvar load in tp mode

  Revision 1.18  2000/11/29 00:30:32  florian
    * unused units removed from uses clause
    * some changes for widestrings

  Revision 1.17  2000/11/22 15:12:06  jonas
    * fixed inline-related problems (partially "merges")

  Revision 1.16  2000/11/11 16:14:52  peter
    * fixed crash with settextbuf,ptr

  Revision 1.15  2000/11/06 21:36:25  peter
    * fixed var parameter varstate bug

  Revision 1.14  2000/11/04 14:25:20  florian
    + merged Attila's changes for interfaces, not tested yet

  Revision 1.13  2000/10/31 22:02:47  peter
    * symtable splitted, no real code changes

  Revision 1.12  2000/10/21 18:16:11  florian
    * a lot of changes:
       - basic dyn. array support
       - basic C++ support
       - some work for interfaces done
       ....

  Revision 1.11  2000/10/21 14:35:27  peter
    * readd to many remove p. for tcallnode.is_equal()

  Revision 1.10  2000/10/14 21:52:55  peter
    * fixed memory leaks

  Revision 1.9  2000/10/14 10:14:50  peter
    * moehrendorf oct 2000 rewrite

  Revision 1.8  2000/10/01 19:48:24  peter
    * lot of compile updates for cg11

  Revision 1.7  2000/09/28 19:49:52  florian
  *** empty log message ***

  Revision 1.6  2000/09/27 18:14:31  florian
    * fixed a lot of syntax errors in the n*.pas stuff

  Revision 1.5  2000/09/24 21:15:34  florian
    * some errors fix to get more stuff compilable

  Revision 1.4  2000/09/24 20:17:44  florian
    * more conversion work done

  Revision 1.3  2000/09/24 15:06:19  peter
    * use defines.inc

  Revision 1.2  2000/09/20 21:52:38  florian
    * removed a lot of errors

  Revision 1.1  2000/09/20 20:52:16  florian
    * initial revision

}
