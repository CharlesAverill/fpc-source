{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    This file implements the node for sub procedure calling.

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

{$i fpcdefs.inc}

interface

    uses
       cutils,cclasses,
       globtype,cpuinfo,
       node,nbas,
       {$ifdef state_tracking}
       nstate,
       {$endif state_tracking}
       symbase,symtype,symppu,symsym,symdef,symtable;

    type
       pcandidate = ^tcandidate;
       tcandidate = record
          next        : pcandidate;
          data        : tprocdef;
          wrongpara,
          firstpara   : tparaitem;
          exact_count,
          equal_count,
          cl1_count,
          cl2_count,
          cl3_count,
          coper_count : integer; { should be signed }
          ordinal_distance : bestreal;
          invalid     : boolean;
          wrongparanr : byte;
       end;

       tcallnode = class(tbinarynode)
       private
          paravisible  : boolean;
          function  candidates_find:pcandidate;
          procedure candidates_free(procs:pcandidate);
          procedure candidates_list(procs:pcandidate;all:boolean);
          procedure candidates_get_information(procs:pcandidate);
          function  candidates_choose_best(procs:pcandidate;var bestpd:tprocdef):integer;
          procedure candidates_find_wrong_para(procs:pcandidate);
{$ifdef EXTDEBUG}
          procedure candidates_dump_info(lvl:longint;procs:pcandidate);
{$endif EXTDEBUG}
          function  gen_self_tree_methodpointer:tnode;
          function  gen_self_tree:tnode;
          function  gen_vmt_tree:tnode;
          procedure bind_paraitem;

          { function return node, this is used to pass the data for a
            ret_in_param return value }
          _funcretnode    : tnode;
          procedure setfuncretnode(const returnnode: tnode);
          procedure convert_carg_array_of_const;
          procedure order_parameters;
       public
          { the symbol containing the definition of the procedure }
          { to call                                               }
          symtableprocentry : tprocsym;
          symtableprocentryderef : tderef;
          { symtable where the entry was found, needed for with support }
          symtableproc   : tsymtable;
          { the definition of the procedure to call }
          procdefinition : tabstractprocdef;
          procdefinitionderef : tderef;
          { tree that contains the pointer to the object for this method }
          methodpointer  : tnode;
          { number of parameters passed from the source, this does not include the hidden parameters }
          paralength   : smallint;
          { inline function body }
          inlinecode : tnode;
          { varargs tparaitems }
          varargsparas : tlinkedlist;
          { node that specifies where the result should be put for calls }
          { that return their result in a parameter                      }
          property funcretnode: tnode read _funcretnode write setfuncretnode;


          { separately specified resulttype for some compilerprocs (e.g. }
          { you can't have a function with an "array of char" resulttype }
          { the RTL) (JM)                                                }
          restype: ttype;
          restypeset: boolean;

          { only the processor specific nodes need to override this }
          { constructor                                             }
          constructor create(l:tnode; v : tprocsym;st : tsymtable; mp : tnode);virtual;
          constructor create_def(l:tnode;def:tprocdef;mp:tnode);virtual;
          constructor create_procvar(l,r:tnode);
          constructor createintern(const name: string; params: tnode);
          constructor createinternres(const name: string; params: tnode; const res: ttype);
          constructor createinternreturn(const name: string; params: tnode; returnnode : tnode);
          destructor destroy;override;
          constructor ppuload(t:tnodetype;ppufile:tcompilerppufile);override;
          procedure ppuwrite(ppufile:tcompilerppufile);override;
          procedure buildderefimpl;override;
          procedure derefimpl;override;
          function  getcopy : tnode;override;
          { Goes through all symbols in a class and subclasses and calls
            verify abstract for each .
          }
          procedure verifyabstractcalls;
          { called for each definition in a class and verifies if a method
            is abstract or not, if it is abstract, give out a warning
          }
          procedure verifyabstract(p : tnamedindexitem;arg:pointer);
          procedure insertintolist(l : tnodelist);override;
          function  pass_1 : tnode;override;
          function  det_resulttype:tnode;override;
       {$ifdef state_tracking}
          function track_state_pass(exec_known:boolean):boolean;override;
       {$endif state_tracking}
          function  docompare(p: tnode): boolean; override;
          procedure printnodedata(var t:text);override;
          function  para_count:longint;
       private
          AbstractMethodsList : TStringList;
       end;
       tcallnodeclass = class of tcallnode;

       tcallparaflags = (
          { flags used by tcallparanode }
          cpf_is_colon_para
       );

       tcallparanode = class(tbinarynode)
       public
          callparaflags : set of tcallparaflags;
          paraitem : tparaitem;
          used_by_callnode : boolean;
          { only the processor specific nodes need to override this }
          { constructor                                             }
          constructor create(expr,next : tnode);virtual;
          destructor destroy;override;
          constructor ppuload(t:tnodetype;ppufile:tcompilerppufile);override;
          procedure ppuwrite(ppufile:tcompilerppufile);override;
          function getcopy : tnode;override;
          procedure insertintolist(l : tnodelist);override;
          procedure get_paratype;
          procedure insert_typeconv(do_count : boolean);
          procedure det_registers;
          procedure firstcallparan;
          procedure secondcallparan;virtual;abstract;
          function docompare(p: tnode): boolean; override;
          procedure printnodetree(var t:text);override;
       end;
       tcallparanodeclass = class of tcallparanode;

    function reverseparameters(p: tcallparanode): tcallparanode;


    var
      ccallnode : tcallnodeclass;
      ccallparanode : tcallparanodeclass;

      { Current callnode, this is needed for having a link
       between the callparanodes and the callnode they belong to }
      aktcallnode : tcallnode;


implementation

    uses
      systems,
      verbose,globals,
      symconst,paramgr,defutil,defcmp,
      htypechk,pass_1,
      ncnv,nld,ninl,nadd,ncon,nmem,
      procinfo,
      cgbase
      ;

type
     tobjectinfoitem = class(tlinkedlistitem)
       objinfo : tobjectdef;
       constructor create(def : tobjectdef);
     end;


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


    function gen_high_tree(p:tnode;openstring:boolean):tnode;
      var
        temp: tnode;
        len : integer;
        loadconst : boolean;
        hightree : tnode;
      begin
        len:=-1;
        loadconst:=true;
        hightree:=nil;
        case p.resulttype.def.deftype of
          arraydef :
            begin
              { handle via a normal inline in_high_x node }
              loadconst := false;
              hightree := geninlinenode(in_high_x,false,p.getcopy);
              { only substract low(array) if it's <> 0 }
              temp := geninlinenode(in_low_x,false,p.getcopy);
              resulttypepass(temp);
              if (temp.nodetype <> ordconstn) or
                 (tordconstnode(temp).value <> 0) then
                hightree := caddnode.create(subn,hightree,temp)
              else
                temp.free;
            end;
          stringdef :
            begin
              if openstring then
               begin
                 { handle via a normal inline in_high_x node }
                 loadconst := false;
                 hightree := geninlinenode(in_high_x,false,p.getcopy);
               end
              else
               begin
                 { passing a string to an array of char }
                 if (p.nodetype=stringconstn) then
                   begin
                     len:=str_length(p);
                     if len>0 then
                      dec(len);
                   end
                 else
                   begin
                     hightree:=caddnode.create(subn,geninlinenode(in_length_x,false,p.getcopy),
                                               cordconstnode.create(1,s32bittype,false));
                     loadconst:=false;
                   end;
               end;
           end;
        else
          len:=0;
        end;
        if loadconst then
          hightree:=cordconstnode.create(len,s32bittype,true)
        else
          begin
            if not assigned(hightree) then
              internalerror(200304071);
            { Need to use explicit, because it can also be a enum }
            hightree:=ctypeconvnode.create_explicit(hightree,s32bittype);
          end;
        result:=hightree;
      end;


      function is_better_candidate(currpd,bestpd:pcandidate):integer;
        var
          res : integer;
        begin
          {
            Return values:
              > 0 when currpd is better than bestpd
              < 0 when bestpd is better than currpd
              = 0 when both are equal

            To choose the best candidate we use the following order:
            - Incompatible flag
            - (Smaller) Number of convert operator parameters.
            - (Smaller) Number of convertlevel 2 parameters.
            - (Smaller) Number of convertlevel 1 parameters.
            - (Bigger) Number of exact parameters.
            - (Smaller) Number of equal parameters.
            - (Smaller) Total of ordinal distance. For example, the distance of a word
              to a byte is 65535-255=65280.
          }
          if bestpd^.invalid then
           begin
             if currpd^.invalid then
              res:=0
             else
              res:=1;
           end
          else
           if currpd^.invalid then
            res:=-1
          else
           begin
             { less operator parameters? }
             res:=(bestpd^.coper_count-currpd^.coper_count);
             if (res=0) then
              begin
                { less cl3 parameters? }
                res:=(bestpd^.cl3_count-currpd^.cl3_count);
                if (res=0) then
                 begin
                   { less cl2 parameters? }
                   res:=(bestpd^.cl2_count-currpd^.cl2_count);
                   if (res=0) then
                    begin
                      { less cl1 parameters? }
                      res:=(bestpd^.cl1_count-currpd^.cl1_count);
                      if (res=0) then
                       begin
                         { more exact parameters? }
                         res:=(currpd^.exact_count-bestpd^.exact_count);
                         if (res=0) then
                          begin
                            { less equal parameters? }
                            res:=(bestpd^.equal_count-currpd^.equal_count);
                            if (res=0) then
                             begin
                               { smaller ordinal distance? }
                               if (currpd^.ordinal_distance<bestpd^.ordinal_distance) then
                                res:=1
                               else
                                if (currpd^.ordinal_distance>bestpd^.ordinal_distance) then
                                 res:=-1
                               else
                                res:=0;
                             end;
                          end;
                       end;
                    end;
                 end;
              end;
           end;
          is_better_candidate:=res;
        end;


    procedure var_para_allowed(var eq:tequaltype;def_from,def_to:Tdef);
      begin
        { Note: eq must be already valid, it will only be updated! }
        case def_to.deftype of
          formaldef :
            begin
              { all types can be passed to a formaldef }
              eq:=te_equal;
            end;
          orddef :
            begin
              { allows conversion from word to integer and
                byte to shortint, but only for TP7 compatibility }
              if (m_tp7 in aktmodeswitches) and
                 (def_from.deftype=orddef) and
                 (def_from.size=def_to.size) then
                eq:=te_convert_l1;
            end;
          arraydef :
            begin
              if is_open_array(def_to) and
                 is_dynamic_array(def_from) and
                equal_defs(tarraydef(def_from).elementtype.def,tarraydef(def_to).elementtype.def) then
                eq:=te_convert_l2;
            end;
          pointerdef :
            begin
              { an implicit pointer conversion is allowed }
              if (def_from.deftype=pointerdef) then
                eq:=te_convert_l1;
            end;
          stringdef :
            begin
              { all shortstrings are allowed, size is not important }
              if is_shortstring(def_from) and
                 is_shortstring(def_to) then
                eq:=te_equal;
            end;
          objectdef :
            begin
              { child objects can be also passed }
              { in non-delphi mode, otherwise    }
              { they must match exactly, except  }
              { if they are objects              }
              if (def_from.deftype=objectdef) and
                 (
                  not(m_delphi in aktmodeswitches) or
                  (
                   (tobjectdef(def_from).objecttype=odt_object) and
                   (tobjectdef(def_to).objecttype=odt_object)
                  )
                 ) and
                 (tobjectdef(def_from).is_related(tobjectdef(def_to))) then
                eq:=te_convert_l1;
            end;
          filedef :
            begin
              { an implicit file conversion is also allowed }
              { from a typed file to an untyped one           }
              if (def_from.deftype=filedef) and
                 (tfiledef(def_from).filetyp = ft_typed) and
                 (tfiledef(def_to).filetyp = ft_untyped) then
                eq:=te_convert_l1;
            end;
        end;
      end;


    procedure para_allowed(var eq:tequaltype;p:tcallparanode;def_to:tdef);
      begin
        { Note: eq must be already valid, it will only be updated! }
        case def_to.deftype of
          formaldef :
            begin
              { all types can be passed to a formaldef }
              eq:=te_equal;
            end;
          stringdef :
            begin
              { to support ansi/long/wide strings in a proper way }
              { string and string[10] are assumed as equal }
              { when searching the correct overloaded procedure   }
              if (p.resulttype.def.deftype=stringdef) and
                 (tstringdef(def_to).string_typ=tstringdef(p.resulttype.def).string_typ) then
                eq:=te_equal
              else
              { Passing a constant char to ansistring or shortstring or
                a widechar to widestring then handle it as equal. }
               if (p.left.nodetype=ordconstn) and
                  (
                   is_char(p.resulttype.def) and
                   (is_shortstring(def_to) or is_ansistring(def_to))
                  ) or
                  (
                   is_widechar(p.resulttype.def) and
                   is_widestring(def_to)
                  ) then
                eq:=te_equal
            end;
          setdef :
            begin
              { set can also be a not yet converted array constructor }
              if (p.resulttype.def.deftype=arraydef) and
                 (tarraydef(p.resulttype.def).IsConstructor) and
                 not(tarraydef(p.resulttype.def).IsVariant) then
                eq:=te_equal;
            end;
          procvardef :
            begin
              { in tp7 mode proc -> procvar is allowed }
              if (m_tp_procvar in aktmodeswitches) and
                 (p.left.nodetype=calln) and
                 (proc_to_procvar_equal(tprocdef(tcallnode(p.left).procdefinition),tprocvardef(def_to),true)>=te_equal) then
               eq:=te_equal;
            end;
        end;
      end;


{****************************************************************************
                              TOBJECTINFOITEM
 ****************************************************************************}

    constructor tobjectinfoitem.create(def : tobjectdef);
      begin
        inherited create;
        objinfo := def;
      end;


{****************************************************************************
                             TCALLPARANODE
 ****************************************************************************}

    constructor tcallparanode.create(expr,next : tnode);

      begin
         inherited create(callparan,expr,next);
         if not assigned(expr) then
           internalerror(200305091);
         expr.set_file_line(self);
         callparaflags:=[];
      end;

    destructor tcallparanode.destroy;

      begin
         { When the node is used by callnode then
           we don't destroy left, the callnode takes care of it }
         if used_by_callnode then
          left:=nil;
         inherited destroy;
      end;


    constructor tcallparanode.ppuload(t:tnodetype;ppufile:tcompilerppufile);
      begin
        inherited ppuload(t,ppufile);
        ppufile.getsmallset(callparaflags);
      end;


    procedure tcallparanode.ppuwrite(ppufile:tcompilerppufile);
      begin
        inherited ppuwrite(ppufile);
        ppufile.putsmallset(callparaflags);
      end;


    function tcallparanode.getcopy : tnode;

      var
         n : tcallparanode;

      begin
         n:=tcallparanode(inherited getcopy);
         n.callparaflags:=callparaflags;
         n.paraitem:=paraitem;
         result:=n;
      end;

    procedure tcallparanode.insertintolist(l : tnodelist);

      begin
      end;


    procedure tcallparanode.get_paratype;
      var
        old_array_constructor : boolean;
      begin
         inc(parsing_para_level);
         if assigned(right) then
          tcallparanode(right).get_paratype;
         old_array_constructor:=allow_array_constructor;
         allow_array_constructor:=true;
         resulttypepass(left);
         allow_array_constructor:=old_array_constructor;
         if codegenerror then
          resulttype:=generrortype
         else
          resulttype:=left.resulttype;
         dec(parsing_para_level);
      end;


    procedure tcallparanode.insert_typeconv(do_count : boolean);
      var
        oldtype     : ttype;
{$ifdef extdebug}
        store_count_ref : boolean;
{$endif def extdebug}
      begin
         inc(parsing_para_level);

{$ifdef extdebug}
         if do_count then
           begin
             store_count_ref:=count_ref;
             count_ref:=true;
           end;
{$endif def extdebug}
         { Be sure to have the resulttype }
         if not assigned(left.resulttype.def) then
           resulttypepass(left);

         if (left.nodetype<>nothingn) then
           begin
             { Handle varargs and hidden paras directly, no typeconvs or }
             { typechecking needed                                       }
             if (nf_varargs_para in flags) then
               begin
                 { convert pascal to C types }
                 case left.resulttype.def.deftype of
                   stringdef :
                     inserttypeconv(left,charpointertype);
                   floatdef :
                     inserttypeconv(left,s64floattype);
                 end;
                 set_varstate(left,vs_used,true);
                 resulttype:=left.resulttype;
               end
             else
              if (paraitem.is_hidden) then
               begin
                 set_varstate(left,vs_used,true);
                 resulttype:=left.resulttype;
               end
             else
               begin

                 { Do we need arrayconstructor -> set conversion, then insert
                   it here before the arrayconstructor node breaks the tree
                   with its conversions of enum->ord }
                 if (left.nodetype=arrayconstructorn) and
                    (paraitem.paratype.def.deftype=setdef) then
                   inserttypeconv(left,paraitem.paratype);

                 { set some settings needed for arrayconstructor }
                 if is_array_constructor(left.resulttype.def) then
                  begin
                    if is_array_of_const(paraitem.paratype.def) then
                     begin
                       { force variant array }
                       include(left.flags,nf_forcevaria);
                     end
                    else
                     begin
                       include(left.flags,nf_novariaallowed);
                       { now that the resultting type is know we can insert the required
                         typeconvs for the array constructor }
                       tarrayconstructornode(left).force_type(tarraydef(paraitem.paratype.def).elementtype);
                     end;
                  end;

                 { check if local proc/func is assigned to procvar }
                 if left.resulttype.def.deftype=procvardef then
                   test_local_to_procvar(tprocvardef(left.resulttype.def),paraitem.paratype.def);

                 { test conversions }
                 if not(is_shortstring(left.resulttype.def) and
                        is_shortstring(paraitem.paratype.def)) and
                    (paraitem.paratype.def.deftype<>formaldef) then
                   begin
                      { Process open parameters }
                      if paramanager.push_high_param(paraitem.paratyp,paraitem.paratype.def,aktcallnode.procdefinition.proccalloption) then
                       begin
                         { insert type conv but hold the ranges of the array }
                         oldtype:=left.resulttype;
                         inserttypeconv(left,paraitem.paratype);
                         left.resulttype:=oldtype;
                       end
                      else
                       begin
                         { for ordinals, floats and enums, verify if we might cause
                           some range-check errors. }
                         if (paraitem.paratype.def.deftype in [enumdef,orddef,floatdef]) and
                            (left.resulttype.def.deftype in [enumdef,orddef,floatdef]) and
                            (left.nodetype in [vecn,loadn,calln]) then
                           begin
                              if (left.resulttype.def.size>paraitem.paratype.def.size) then
                                begin
                                  if (cs_check_range in aktlocalswitches) then
                                     Message(type_w_smaller_possible_range_check)
                                  else
                                     Message(type_h_smaller_possible_range_check);
                                end;
                           end;
                         inserttypeconv(left,paraitem.paratype);
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
                    is_shortstring(paraitem.paratype.def) and
                    (paraitem.paratyp in [vs_out,vs_var]) and
                    not(is_open_string(paraitem.paratype.def)) and
                    not(equal_defs(left.resulttype.def,paraitem.paratype.def)) then
                   begin
                     aktfilepos:=left.fileinfo;
                     CGMessage(type_e_strict_var_string_violation);
                   end;

                 { Handle formal parameters separate }
                 if (paraitem.paratype.def.deftype=formaldef) then
                   begin
                     { load procvar if a procedure is passed }
                     if (m_tp_procvar in aktmodeswitches) and
                        (left.nodetype=calln) and
                        (is_void(left.resulttype.def)) then
                       load_procvar_from_calln(left);

                     case paraitem.paratyp of
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
                     if (paraitem.paratyp in [vs_out,vs_var]) then
                       valid_for_var(left);
                   end;

                 if paraitem.paratyp in [vs_var,vs_const] then
                   begin
                      { Causes problems with const ansistrings if also }
                      { done for vs_const (JM)                         }
                      if paraitem.paratyp = vs_var then
                        set_unique(left);
                      make_not_regable(left);
                   end;

                 { ansistrings out paramaters doesn't need to be  }
                 { unique, they are finalized                     }
                 if paraitem.paratyp=vs_out then
                   make_not_regable(left);

                 if do_count then
                  begin
                    if paraitem.paratyp in [vs_var,vs_out] then
                      set_varstate(left,vs_used,false)
                    else
                      set_varstate(left,vs_used,true);
                  end;
                 { must only be done after typeconv PM }
                 resulttype:=paraitem.paratype;
               end;
            end;

         { process next node }
         if assigned(right) then
           tcallparanode(right).insert_typeconv(do_count);

         dec(parsing_para_level);
{$ifdef extdebug}
         if do_count then
           count_ref:=store_count_ref;
{$endif def extdebug}
      end;


    procedure tcallparanode.det_registers;
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

         firstpass(left);

         if left.registers32>registers32 then
           registers32:=left.registers32;
         if left.registersfpu>registersfpu then
           registersfpu:=left.registersfpu;
{$ifdef SUPPORT_MMX}
         if left.registersmmx>registersmmx then
           registersmmx:=left.registersmmx;
{$endif SUPPORT_MMX}
      end;


    procedure tcallparanode.firstcallparan;
      begin
        if not assigned(left.resulttype.def) then
          get_paratype;
        det_registers;
      end;


    function tcallparanode.docompare(p: tnode): boolean;
      begin
        docompare :=
          inherited docompare(p) and
          (callparaflags = tcallparanode(p).callparaflags)
          ;
      end;


    procedure tcallparanode.printnodetree(var t:text);
      begin
        printnodelist(t);
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
         restypeset:=false;
         _funcretnode:=nil;
         inlinecode:=nil;
         paralength:=-1;
         varargsparas:=nil;
      end;


    constructor tcallnode.create_def(l:tnode;def:tprocdef;mp:tnode);
      begin
         inherited create(calln,l,nil);
         symtableprocentry:=nil;
         symtableproc:=nil;
         include(flags,nf_return_value_used);
         methodpointer:=mp;
         procdefinition:=def;
         restypeset:=false;
         _funcretnode:=nil;
         inlinecode:=nil;
         paralength:=-1;
         varargsparas:=nil;
      end;


    constructor tcallnode.create_procvar(l,r:tnode);
      begin
         inherited create(calln,l,r);
         symtableprocentry:=nil;
         symtableproc:=nil;
         include(flags,nf_return_value_used);
         methodpointer:=nil;
         procdefinition:=nil;
         restypeset:=false;
         _funcretnode:=nil;
         inlinecode:=nil;
         paralength:=-1;
         varargsparas:=nil;
      end;


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
           begin
{$ifdef EXTDEBUG}
             Comment(V_Error,'unknown compilerproc '+name);
{$endif EXTDEBUG}
             internalerror(200107271);
           end;
         self.create(params,tprocsym(srsym),symowner,nil);
       end;


    constructor tcallnode.createinternres(const name: string; params: tnode; const res: ttype);
      begin
        self.createintern(name,params);
        restype := res;
        restypeset := true;
        { both the normal and specified resulttype either have to be returned via a }
        { parameter or not, but no mixing (JM)                                      }
        if paramanager.ret_in_param(restype.def,pocall_compilerproc) xor
           paramanager.ret_in_param(symtableprocentry.first_procdef.rettype.def,symtableprocentry.first_procdef.proccalloption) then
          internalerror(200108291);
      end;


    constructor tcallnode.createinternreturn(const name: string; params: tnode; returnnode : tnode);
      begin
        self.createintern(name,params);
        _funcretnode:=returnnode;
        if not paramanager.ret_in_param(symtableprocentry.first_procdef.rettype.def,symtableprocentry.first_procdef.proccalloption) then
          internalerror(200204247);
      end;


    procedure tcallnode.setfuncretnode(const returnnode: tnode);
      var
        para: tcallparanode;
      begin
        if assigned(_funcretnode) then
          _funcretnode.free;
        _funcretnode := returnnode;
        { if the resulttype pass hasn't occurred yet, that one will do }
        { everything                                                   }
        if assigned(resulttype.def) then
          begin
            { these are returned as values, but we can optimize their loading }
            { as well                                                         }
            if is_ansistring(resulttype.def) or
               is_widestring(resulttype.def) then
              exit;
            para := tcallparanode(left);
            while assigned(para) do
              begin
                if para.paraitem.is_hidden and
                   (vo_is_funcret in tvarsym(para.paraitem.parasym).varoptions) then
                 begin
                   para.left.free;
                   para.left := _funcretnode.getcopy;
                   exit;
                 end;
                 para := tcallparanode(para.right);
              end;
            { no hidden resultpara found, error! }
            internalerror(200306087);
          end;
      end;


    destructor tcallnode.destroy;
      begin
         methodpointer.free;
         _funcretnode.free;
         inlinecode.free;
         if assigned(varargsparas) then
           varargsparas.free;
         inherited destroy;
      end;


    constructor tcallnode.ppuload(t:tnodetype;ppufile:tcompilerppufile);
      begin
        inherited ppuload(t,ppufile);
        ppufile.getderef(symtableprocentryderef);
{$ifdef fpc}
{$warning FIXME: No withsymtable support}
{$endif}
        symtableproc:=nil;
        ppufile.getderef(procdefinitionderef);
        restypeset:=boolean(ppufile.getbyte);
        methodpointer:=ppuloadnode(ppufile);
        _funcretnode:=ppuloadnode(ppufile);
        inlinecode:=ppuloadnode(ppufile);
      end;


    procedure tcallnode.ppuwrite(ppufile:tcompilerppufile);
      begin
        inherited ppuwrite(ppufile);
        ppufile.putderef(symtableprocentryderef);
        ppufile.putderef(procdefinitionderef);
        ppufile.putbyte(byte(restypeset));
        ppuwritenode(ppufile,methodpointer);
        ppuwritenode(ppufile,_funcretnode);
        ppuwritenode(ppufile,inlinecode);
      end;


    procedure tcallnode.buildderefimpl;
      begin
        inherited buildderefimpl;
        symtableprocentryderef.build(symtableprocentry);
        procdefinitionderef.build(procdefinition);
        if assigned(methodpointer) then
          methodpointer.buildderefimpl;
        if assigned(_funcretnode) then
          _funcretnode.buildderefimpl;
        if assigned(inlinecode) then
          inlinecode.buildderefimpl;
      end;


    procedure tcallnode.derefimpl;
      var
        pt : tcallparanode;
        currpara : tparaitem;
      begin
        inherited derefimpl;
        symtableprocentry:=tprocsym(symtableprocentryderef.resolve);
        symtableproc:=symtableprocentry.owner;
        procdefinition:=tprocdef(procdefinitionderef.resolve);
        if assigned(methodpointer) then
          methodpointer.derefimpl;
        if assigned(_funcretnode) then
          _funcretnode.derefimpl;
        if assigned(inlinecode) then
          inlinecode.derefimpl;
        { Connect paraitems }
        pt:=tcallparanode(left);
        while assigned(pt) and
              (nf_varargs_para in pt.flags) do
          pt:=tcallparanode(pt.right);
        currpara:=tparaitem(procdefinition.Para.last);
        while assigned(currpara) do
          begin
            if not assigned(pt) then
              internalerror(200311077);
            pt.paraitem:=currpara;
            pt:=tcallparanode(pt.right);
            currpara:=tparaitem(currpara.previous);
          end;
        if assigned(currpara) or assigned(pt) then
          internalerror(200311078);
      end;


    function tcallnode.getcopy : tnode;
      var
        n : tcallnode;
        hp : tparaitem;
      begin
        n:=tcallnode(inherited getcopy);
        n.symtableprocentry:=symtableprocentry;
        n.symtableproc:=symtableproc;
        n.procdefinition:=procdefinition;
        n.restype := restype;
        n.restypeset := restypeset;
        if assigned(methodpointer) then
         n.methodpointer:=methodpointer.getcopy
        else
         n.methodpointer:=nil;
        if assigned(_funcretnode) then
         n._funcretnode:=_funcretnode.getcopy
        else
         n._funcretnode:=nil;
        if assigned(inlinecode) then
         n.inlinecode:=inlinecode.getcopy
        else
         n.inlinecode:=nil;
        if assigned(varargsparas) then
         begin
           n.varargsparas:=tlinkedlist.create;
           hp:=tparaitem(varargsparas.first);
           while assigned(hp) do
            begin
              n.varargsparas.concat(hp.getcopy);
              hp:=tparaitem(hp.next);
            end;
         end
        else
         n.varargsparas:=nil;
        result:=n;
      end;


    procedure tcallnode.insertintolist(l : tnodelist);

      begin
      end;


    procedure tcallnode.convert_carg_array_of_const;
      var
        hp : tarrayconstructornode;
        oldleft : tcallparanode;
      begin
        oldleft:=tcallparanode(left);
        if oldleft.left.nodetype<>arrayconstructorn then
          begin
            CGMessage1(type_e_wrong_type_in_array_constructor,oldleft.left.resulttype.def.typename);
            exit;
          end;
        { Get arrayconstructor node and insert typeconvs }
        hp:=tarrayconstructornode(oldleft.left);
        hp.insert_typeconvs;
        { Add c args parameters }
        { It could be an empty set }
        if assigned(hp) and
           assigned(hp.left) then
          begin
            while assigned(hp) do
              begin
                left:=ccallparanode.create(hp.left,left);
                { set callparanode resulttype and flags }
                left.resulttype:=hp.left.resulttype;
                include(left.flags,nf_varargs_para);
                hp.left:=nil;
                hp:=tarrayconstructornode(hp.right);
              end;
          end;
        { Remove value of old array of const parameter, but keep it
          in the list because it is required for bind_paraitem.
          Generate a nothign to keep callparanoed.left valid }
        oldleft.left.free;
        oldleft.left:=cnothingnode.create;
      end;


    procedure tcallnode.verifyabstract(p : tnamedindexitem;arg:pointer);

      var
         hp : tprocdef;
          j: integer;
      begin
         if (tsym(p).typ=procsym) then
           begin
              for j:=1 to tprocsym(p).procdef_count do
               begin
                  { index starts at 1 }
                  hp:=tprocsym(p).procdef[j];
                  { If this is an abstract method insert into the list }
                  if (po_abstractmethod in hp.procoptions) then
                     AbstractMethodsList.Insert(hp.procsym.name)
                  else
                    { If this symbol is already in the list, and it is
                      an overriding method or dynamic, then remove it from the list
                    }
                    begin
                       { symbol was found }
                       if AbstractMethodsList.Find(hp.procsym.name) <> nil then
                         begin
                            if po_overridingmethod in hp.procoptions then
                              AbstractMethodsList.Remove(hp.procsym.name);
                         end;

                  end;
               end;
           end;
      end;


    procedure tcallnode.verifyabstractcalls;
      var
        objectdf : tobjectdef;
        parents : tlinkedlist;
        objectinfo : tobjectinfoitem;
        stritem : tstringlistitem;
      begin
        objectdf := nil;
        { verify if trying to create an instance of a class which contains
          non-implemented abstract methods }

        { first verify this class type, no class than exit  }
        { also, this checking can only be done if the constructor is directly
          called, indirect constructor calls cannot be checked.
        }
        if assigned(methodpointer) then
          begin
            if (methodpointer.resulttype.def.deftype = objectdef) then
              objectdf:=tobjectdef(methodpointer.resulttype.def)
            else
              if (methodpointer.resulttype.def.deftype = classrefdef) and
                 (tclassrefdef(methodpointer.resulttype.def).pointertype.def.deftype = objectdef) and
                 (methodpointer.nodetype in [typen,loadvmtaddrn]) then
                objectdf:=tobjectdef(tclassrefdef(methodpointer.resulttype.def).pointertype.def);
          end;
        if not assigned(objectdf) then
          exit;

        parents := tlinkedlist.create;
        AbstractMethodsList := tstringlist.create;

        { insert all parents in this class : the first item in the
          list will be the base parent of the class .
        }
        while assigned(objectdf) do
          begin
            objectinfo:=tobjectinfoitem.create(objectdf);
            parents.insert(objectinfo);
            objectdf := objectdf.childof;
        end;
        { now all parents are in the correct order
          insert all abstract methods in the list, and remove
          those which are overriden by parent classes.
        }
        objectinfo:=tobjectinfoitem(parents.first);
        while assigned(objectinfo) do
          begin
             objectdf := objectinfo.objinfo;
             if assigned(objectdf.symtable) then
               objectdf.symtable.foreach({$ifdef FPCPROCVAR}@{$endif}verifyabstract,nil);
             objectinfo:=tobjectinfoitem(objectinfo.next);
          end;
        if assigned(parents) then
          parents.free;
        { Finally give out a warning for each abstract method still in the list }
        stritem := tstringlistitem(AbstractMethodsList.first);
        if assigned(stritem) then
          Message1(type_w_instance_with_abstract,objectdf.objname^);
        while assigned(stritem) do
         begin
           if assigned(stritem.fpstr) then
             Message1(sym_h_param_list,stritem.str);
           stritem := tstringlistitem(stritem.next);
         end;
        if assigned(AbstractMethodsList) then
          AbstractMethodsList.Free;
      end;


    function Tcallnode.candidates_find:pcandidate;

      var
        j          : integer;
        pd         : tprocdef;
        procs,hp   : pcandidate;
        found,
        has_overload_directive : boolean;
        topclassh  : tobjectdef;
        srsymtable : tsymtable;
        srprocsym  : tprocsym;

        procedure proc_add(pd:tprocdef);
        var
          i : integer;
        begin
          { generate new candidate entry }
          new(hp);
          fillchar(hp^,sizeof(tcandidate),0);
          hp^.data:=pd;
          hp^.next:=procs;
          procs:=hp;
          { Find last parameter, skip all default parameters
            that are not passed. Ignore this skipping for varargs }
          hp^.firstpara:=tparaitem(pd.Para.last);
          if not(po_varargs in pd.procoptions) then
           begin
             for i:=1 to pd.maxparacount-paralength do
              hp^.firstpara:=tparaitem(hp^.firstPara.previous);
           end;
        end;

      begin
        procs:=nil;

        { when the definition has overload directive set, we search for
          overloaded definitions in the class, this only needs to be done once
          for class entries as the tree keeps always the same }
        if (not symtableprocentry.overloadchecked) and
           (symtableprocentry.owner.symtabletype=objectsymtable) and
           (po_overload in symtableprocentry.first_procdef.procoptions) then
         search_class_overloads(symtableprocentry);

         { when the class passed is defined in this unit we
           need to use the scope of that class. This is a trick
           that can be used to access protected members in other
           units. At least kylix supports it this way (PFV) }
         if assigned(symtableproc) and
            (symtableproc.symtabletype=objectsymtable) and
            (symtableproc.defowner.owner.symtabletype in [globalsymtable,staticsymtable]) and
            (symtableproc.defowner.owner.unitid=0) then
           topclassh:=tobjectdef(symtableproc.defowner)
         else
           begin
             if assigned(current_procinfo) then
               topclassh:=current_procinfo.procdef._class
             else
               topclassh:=nil;
           end;

        { link all procedures which have the same # of parameters }
        paravisible:=false;
        for j:=1 to symtableprocentry.procdef_count do
          begin
            pd:=symtableprocentry.procdef[j];
            { Is the procdef visible? This needs to be checked on
              procdef level since a symbol can contain both private and
              public declarations. But the check should not be done
              when the callnode is generated by a property }
            if (nf_isproperty in flags) or
               (pd.owner.symtabletype<>objectsymtable) or
               pd.is_visible_for_object(topclassh) then
             begin
               { we have at least one procedure that is visible }
               paravisible:=true;
               { only when the # of parameter are supported by the
                 procedure }
               if (paralength>=pd.minparacount) and
                  ((po_varargs in pd.procoptions) or { varargs }
                   (paralength<=pd.maxparacount)) then
                 proc_add(pd);
             end;
          end;

        { remember if the procedure is declared with the overload directive,
          it's information is still needed also after all procs are removed }
        has_overload_directive:=(po_overload in symtableprocentry.first_procdef.procoptions);

        { when the definition has overload directive set, we search for
          overloaded definitions in the symtablestack. The found
          entries are only added to the procs list and not the procsym, because
          the list can change in every situation }
        if has_overload_directive and
           (symtableprocentry.owner.symtabletype<>objectsymtable) then
          begin
            srsymtable:=symtableprocentry.owner.next;
            while assigned(srsymtable) do
             begin
               if srsymtable.symtabletype in [localsymtable,staticsymtable,globalsymtable] then
                begin
                  srprocsym:=tprocsym(srsymtable.speedsearch(symtableprocentry.name,symtableprocentry.speedvalue));
                  { process only visible procsyms }
                  if assigned(srprocsym) and
                     (srprocsym.typ=procsym) and
                     srprocsym.is_visible_for_object(topclassh) then
                   begin
                     { if this procedure doesn't have overload we can stop
                       searching }
                     if not(po_overload in srprocsym.first_procdef.procoptions) then
                      break;
                     { process all overloaded definitions }
                     for j:=1 to srprocsym.procdef_count do
                      begin
                        pd:=srprocsym.procdef[j];
                        { only when the # of parameter are supported by the
                          procedure }
                        if (paralength>=pd.minparacount) and
                           ((po_varargs in pd.procoptions) or { varargs }
                           (paralength<=pd.maxparacount)) then
                         begin
                           found:=false;
                           hp:=procs;
                           while assigned(hp) do
                            begin
                              { Only compare visible parameters for the user }
                              if compare_paras(hp^.data.para,pd.para,cp_value_equal_const,[cpo_ignorehidden])>=te_equal then
                               begin
                                 found:=true;
                                 break;
                               end;
                              hp:=hp^.next;
                            end;
                           if not found then
                             proc_add(pd);
                         end;
                      end;
                   end;
                end;
               srsymtable:=srsymtable.next;
             end;
          end;
        candidates_find:=procs;
      end;


    procedure tcallnode.candidates_free(procs:pcandidate);
      var
        hpnext,
        hp : pcandidate;
      begin
        hp:=procs;
        while assigned(hp) do
         begin
           hpnext:=hp^.next;
           dispose(hp);
           hp:=hpnext;
         end;
      end;


    procedure tcallnode.candidates_list(procs:pcandidate;all:boolean);
      var
        hp : pcandidate;
      begin
        hp:=procs;
        while assigned(hp) do
         begin
           if all or
              (not hp^.invalid) then
             MessagePos1(hp^.data.fileinfo,sym_h_param_list,hp^.data.fullprocname(false));
           hp:=hp^.next;
         end;
      end;


{$ifdef EXTDEBUG}
    procedure Tcallnode.candidates_dump_info(lvl:longint;procs:pcandidate);

        function ParaTreeStr(p:tcallparanode):string;
        begin
          result:='';
          while assigned(p) do
           begin
             if result<>'' then
              result:=result+',';
             result:=result+p.resulttype.def.typename;
             p:=tcallparanode(p.right);
           end;
        end;

      var
        hp : pcandidate;
        currpara : tparaitem;
      begin
        if not CheckVerbosity(lvl) then
         exit;
        Comment(lvl+V_LineInfo,'Overloaded callnode: '+symtableprocentry.name+'('+ParaTreeStr(tcallparanode(left))+')');
        hp:=procs;
        while assigned(hp) do
         begin
           Comment(lvl,'  '+hp^.data.fullprocname(false));
           if (hp^.invalid) then
            Comment(lvl,'   invalid')
           else
            begin
              Comment(lvl,'   ex: '+tostr(hp^.exact_count)+
                          ' eq: '+tostr(hp^.equal_count)+
                          ' l1: '+tostr(hp^.cl1_count)+
                          ' l2: '+tostr(hp^.cl2_count)+
                          ' l3: '+tostr(hp^.cl3_count)+
                          ' oper: '+tostr(hp^.coper_count)+
                          ' ord: '+realtostr(hp^.exact_count));
              { Print parameters in left-right order }
              currpara:=hp^.firstpara;
              if assigned(currpara) then
               begin
                 while assigned(currpara.next) do
                  currpara:=tparaitem(currpara.next);
               end;
              while assigned(currpara) do
               begin
                 if (not currpara.is_hidden) then
                   Comment(lvl,'    - '+currpara.paratype.def.typename+' : '+EqualTypeName[currpara.eqval]);
                 currpara:=tparaitem(currpara.previous);
               end;
            end;
           hp:=hp^.next;
         end;
      end;
{$endif EXTDEBUG}


    procedure Tcallnode.candidates_get_information(procs:pcandidate);
      var
        hp       : pcandidate;
        currpara : tparaitem;
        currparanr : byte;
        def_from,
        def_to   : tdef;
        pt       : tcallparanode;
        eq       : tequaltype;
        convtype : tconverttype;
        pdoper   : tprocdef;
      begin
        { process all procs }
        hp:=procs;
        while assigned(hp) do
         begin
           { We compare parameters in reverse order (right to left),
             the firstpara is already pointing to the last parameter
             were we need to start comparing }
           currparanr:=paralength;
           currpara:=hp^.firstpara;
           while assigned(currpara) and (currpara.is_hidden) do
             currpara:=tparaitem(currpara.previous);
           pt:=tcallparanode(left);
           while assigned(pt) and assigned(currpara) do
            begin
              { retrieve current parameter definitions to compares }
              eq:=te_incompatible;
              def_from:=pt.resulttype.def;
              def_to:=currpara.paratype.def;
              if not(assigned(def_from)) then
               internalerror(200212091);
              if not(
                     assigned(def_to) or
                     ((po_varargs in hp^.data.procoptions) and
                      (currparanr>hp^.data.minparacount))
                    ) then
               internalerror(200212092);

              { varargs are always equal, but not exact }
              if (po_varargs in hp^.data.procoptions) and
                 (currparanr>hp^.data.minparacount) then
               begin
                 inc(hp^.equal_count);
                 eq:=te_equal;
               end
              else
              { same definition -> exact }
               if (def_from=def_to) then
                begin
                  inc(hp^.exact_count);
                  eq:=te_exact;
                end
              else
              { for value and const parameters check if a integer is constant or
                included in other integer -> equal and calc ordinal_distance }
               if not(currpara.paratyp in [vs_var,vs_out]) and
                  is_integer(def_from) and
                  is_integer(def_to) and
                  is_in_limit(def_from,def_to) then
                 begin
                   inc(hp^.equal_count);
                   eq:=te_equal;
                   hp^.ordinal_distance:=hp^.ordinal_distance+
                     abs(bestreal(torddef(def_from).low)-bestreal(torddef(def_to).low));
                   hp^.ordinal_distance:=hp^.ordinal_distance+
                     abs(bestreal(torddef(def_to).high)-bestreal(torddef(def_from).high));
                   { Give wrong sign a small penalty, this is need to get a diffrence
                     from word->[longword,longint] }
                   if is_signed(def_from)<>is_signed(def_to) then
                     hp^.ordinal_distance:=hp^.ordinal_distance+1.0;
                 end
              else
              { generic type comparision }
               begin
                 eq:=compare_defs_ext(def_from,def_to,pt.left.nodetype,
                                      false,true,convtype,pdoper);

                 { when the types are not equal we need to check
                   some special case for parameter passing }
                 if (eq<te_equal) then
                  begin
                    if currpara.paratyp in [vs_var,vs_out] then
                      begin
                        { para requires an equal type so the previous found
                          match was not good enough, reset to incompatible }
                        eq:=te_incompatible;
                        { var_para_allowed will return te_equal and te_convert_l1 to
                          make a difference for best matching }
                        var_para_allowed(eq,pt.resulttype.def,currpara.paratype.def)
                      end
                    else
                      para_allowed(eq,pt,def_to);
                  end;

                 case eq of
                   te_exact :
                     internalerror(200212071); { already checked }
                   te_equal :
                     inc(hp^.equal_count);
                   te_convert_l1 :
                     inc(hp^.cl1_count);
                   te_convert_l2 :
                     inc(hp^.cl2_count);
                   te_convert_l3 :
                     inc(hp^.cl3_count);
                   te_convert_operator :
                     inc(hp^.coper_count);
                   te_incompatible :
                     hp^.invalid:=true;
                   else
                     internalerror(200212072);
                 end;
               end;

              { stop checking when an incompatible parameter is found }
              if hp^.invalid then
               begin
                 { store the current parameter info for
                   a nice error message when no procedure is found }
                 hp^.wrongpara:=currpara;
                 hp^.wrongparanr:=currparanr;
                 break;
               end;

{$ifdef EXTDEBUG}
              { store equal in node tree for dump }
              currpara.eqval:=eq;
{$endif EXTDEBUG}

              { next parameter in the call tree }
              pt:=tcallparanode(pt.right);

              { next parameter for definition, only goto next para
                if we're out of the varargs }
              if not(po_varargs in hp^.data.procoptions) or
                 (currparanr<=hp^.data.maxparacount) then
               begin
                 { Ignore vs_hidden parameters }
                 repeat
                   currpara:=tparaitem(currpara.previous);
                 until (not assigned(currpara)) or (not currpara.is_hidden);
               end;
              dec(currparanr);
            end;
           if not(hp^.invalid) and
              (assigned(pt) or assigned(currpara) or (currparanr<>0)) then
             internalerror(200212141);
           { next candidate }
           hp:=hp^.next;
         end;
      end;


    function Tcallnode.candidates_choose_best(procs:pcandidate;var bestpd:tprocdef):integer;
      var
        besthpstart,
        hp       : pcandidate;
        cntpd,
        res      : integer;
      begin
        {
          Returns the number of candidates left and the
          first candidate is returned in pdbest
        }
        { Setup the first procdef as best, only count it as a result
          when it is valid }
        bestpd:=procs^.data;
        if procs^.invalid then
         cntpd:=0
        else
         cntpd:=1;
        if assigned(procs^.next) then
         begin
           besthpstart:=procs;
           hp:=procs^.next;
           while assigned(hp) do
            begin
              res:=is_better_candidate(hp,besthpstart);
              if (res>0) then
               begin
                 { hp is better, flag all procs to be incompatible }
                 while (besthpstart<>hp) do
                  begin
                    besthpstart^.invalid:=true;
                    besthpstart:=besthpstart^.next;
                  end;
                 { besthpstart is already set to hp }
                 bestpd:=besthpstart^.data;
                 cntpd:=1;
               end
              else
               if (res<0) then
                begin
                  { besthpstart is better, flag current hp to be incompatible }
                  hp^.invalid:=true;
                end
              else
               begin
                 { res=0, both are valid }
                 if not hp^.invalid then
                   inc(cntpd);
               end;
              hp:=hp^.next;
            end;
         end;

        candidates_choose_best:=cntpd;
      end;


    procedure tcallnode.candidates_find_wrong_para(procs:pcandidate);
      var
        currparanr : smallint;
        hp : pcandidate;
        pt : tcallparanode;
      begin
        { Only process the first overloaded procdef }
        hp:=procs;
        { Find callparanode corresponding to the argument }
        pt:=tcallparanode(left);
        currparanr:=paralength;
        while assigned(pt) and
              (currparanr>hp^.wrongparanr) do
         begin
           pt:=tcallparanode(pt.right);
           dec(currparanr);
         end;
        if (currparanr<>hp^.wrongparanr) or
           not assigned(pt) then
          internalerror(200212094);
        { Show error message, when it was a var or out parameter
          guess that it is a missing typeconv }
        if hp^.wrongpara.paratyp in [vs_var,vs_out] then
          CGMessagePos2(left.fileinfo,parser_e_call_by_ref_without_typeconv,
            pt.resulttype.def.typename,hp^.wrongpara.paratype.def.typename)
        else
          CGMessagePos3(pt.fileinfo,type_e_wrong_parameter_type,
            tostr(hp^.wrongparanr),pt.resulttype.def.typename,hp^.wrongpara.paratype.def.typename);
      end;


    function tcallnode.gen_self_tree_methodpointer:tnode;
      var
        hsym : tvarsym;
      begin
        { find self field in methodpointer record }
        hsym:=tvarsym(trecorddef(methodpointertype.def).symtable.search('self'));
        if not assigned(hsym) then
          internalerror(200305251);
        { Load tmehodpointer(right).self }
        result:=csubscriptnode.create(
                     hsym,
                     ctypeconvnode.create_explicit(right.getcopy,methodpointertype));
      end;


    function tcallnode.gen_self_tree:tnode;
      var
        selftree : tnode;
      begin
        selftree:=nil;

        { inherited }
        if (nf_inherited in flags) then
          selftree:=load_self_node
        else
          { constructors }
          if (procdefinition.proctypeoption=potype_constructor) then
            begin
              { push 0 as self when allocation is needed }
              if (methodpointer.resulttype.def.deftype=classrefdef) or
                 (nf_new_call in flags) then
                selftree:=cpointerconstnode.create(0,voidpointertype)
              else
                begin
                  if methodpointer.nodetype=typen then
                    selftree:=load_self_node
                  else
                    selftree:=methodpointer.getcopy;
                end;
            end
        else
          { Calling a static/class method }
          if (po_classmethod in procdefinition.procoptions) or
             (po_staticmethod in procdefinition.procoptions) then
            begin
              if (procdefinition.deftype<>procdef) then
                internalerror(200305062);
              if (oo_has_vmt in tprocdef(procdefinition)._class.objectoptions) then
                begin
                  { we only need the vmt, loading self is not required and there is no
                    need to check for typen, because that will always get the
                    loadvmtaddrnode added }
                  selftree:=methodpointer.getcopy;
                  if methodpointer.resulttype.def.deftype<>classrefdef then
                    selftree:=cloadvmtaddrnode.create(selftree);
                end
              else
                selftree:=cpointerconstnode.create(0,voidpointertype);
            end
        else
          begin
            if methodpointer.nodetype=typen then
              selftree:=load_self_node
            else
              selftree:=methodpointer.getcopy;
          end;
        result:=selftree;
      end;


    function tcallnode.gen_vmt_tree:tnode;
      var
        vmttree : tnode;
      begin
        vmttree:=nil;
        if not(procdefinition.proctypeoption in [potype_constructor,potype_destructor]) then
          internalerror(200305051);

        { inherited call, no create/destroy }
        if (nf_inherited in flags) then
          vmttree:=cpointerconstnode.create(0,voidpointertype)
        else
          { do not create/destroy when called from member function
            without specifying self explicit }
          if (nf_member_call in flags) then
            begin
              if (methodpointer.resulttype.def.deftype=classrefdef) and
                (procdefinition.proctypeoption=potype_constructor) then
                vmttree:=methodpointer.getcopy
              else
                vmttree:=cpointerconstnode.create(0,voidpointertype);
            end
        else
          { constructor with extended syntax called from new }
          if (nf_new_call in flags) then
            vmttree:=cloadvmtaddrnode.create(ctypenode.create(methodpointer.resulttype))
        else
          { destructor with extended syntax called from dispose }
          if (nf_dispose_call in flags) then
            vmttree:=cloadvmtaddrnode.create(methodpointer.getcopy)
        else
         if (methodpointer.resulttype.def.deftype=classrefdef) then
          begin
            { constructor call via classreference => allocate memory }
            if (procdefinition.proctypeoption=potype_constructor) and
               is_class(tclassrefdef(methodpointer.resulttype.def).pointertype.def) then
              begin
                vmttree:=methodpointer.getcopy;
                { Only a typenode can be passed when it is called with <class of xx>.create }
                if vmttree.nodetype=typen then
                  vmttree:=cloadvmtaddrnode.create(vmttree);
              end
            else
              vmttree:=cpointerconstnode.create(0,voidpointertype);
          end
        else
        { class }
         if is_class(methodpointer.resulttype.def) then
          begin
            { destructor: release instance, flag(vmt)=1
              constructor: direct call, do nothing, leave vmt=0 }
            if (procdefinition.proctypeoption=potype_destructor) then
             vmttree:=cpointerconstnode.create(1,voidpointertype)
            else
             vmttree:=cpointerconstnode.create(0,voidpointertype);
          end
        else
        { object }
         begin
           { destructor: direct call, no dispose, vmt=0
             constructor: initialize object, load vmt }
           if (procdefinition.proctypeoption=potype_constructor) then
             { old styled inherited call? }
             if (methodpointer.nodetype=typen) then
               vmttree:=cpointerconstnode.create(0,voidpointertype)
             else
               vmttree:=cloadvmtaddrnode.create(ctypenode.create(methodpointer.resulttype))
           else
             vmttree:=cpointerconstnode.create(0,voidpointertype);
         end;
        result:=vmttree;
      end;


    procedure tcallnode.bind_paraitem;
      var
        i        : integer;
        pt       : tcallparanode;
        oldppt   : ^tcallparanode;
        varargspara,
        currpara : tparaitem;
        used_by_callnode : boolean;
        hiddentree : tnode;
        newstatement : tstatementnode;
        temp         : ttempcreatenode;
      begin
        pt:=tcallparanode(left);
        oldppt:=@left;

        { flag all callparanodes that belong to the varargs }
        i:=paralength;
        while (i>procdefinition.maxparacount) do
          begin
            include(pt.flags,nf_varargs_para);
            oldppt:=@pt.right;
            pt:=tcallparanode(pt.right);
            dec(i);
          end;

        { skip varargs that are inserted by array of const }
        while assigned(pt) and
              (nf_varargs_para in pt.flags) do
          pt:=tcallparanode(pt.right);

        { process normal parameters and insert hidden parameters }
        currpara:=tparaitem(procdefinition.Para.last);
        while assigned(currpara) do
         begin
           if currpara.is_hidden then
            begin
              { generate hidden tree }
              used_by_callnode:=false;
              hiddentree:=nil;
              if (vo_is_funcret in tvarsym(currpara.parasym).varoptions) then
               begin
                 { Generate funcretnode if not specified }
                 if assigned(funcretnode) then
                  begin
                    hiddentree:=funcretnode.getcopy;
                  end
                 else
                  begin
                    hiddentree:=internalstatements(newstatement);
                    { need to use resulttype instead of procdefinition.rettype,
                      because they can be different }
                    temp:=ctempcreatenode.create(resulttype,resulttype.def.size,tt_persistent);
                    addstatement(newstatement,temp);
                    addstatement(newstatement,ctempdeletenode.create_normal_temp(temp));
                    addstatement(newstatement,ctemprefnode.create(temp));
                  end;
               end
              else
               if vo_is_high_value in tvarsym(currpara.parasym).varoptions then
                begin
                  if not assigned(pt) then
                    internalerror(200304082);
                  { we need the information of the next parameter }
                  hiddentree:=gen_high_tree(pt.left,is_open_string(tparaitem(currpara.previous).paratype.def));
                end
              else
               if vo_is_self in tvarsym(currpara.parasym).varoptions then
                 begin
                   if assigned(right) then
                     hiddentree:=gen_self_tree_methodpointer
                   else
                     hiddentree:=gen_self_tree;
                 end
              else
               if vo_is_vmt in tvarsym(currpara.parasym).varoptions then
                 begin
                   hiddentree:=gen_vmt_tree;
                 end
              else
               if vo_is_parentfp in tvarsym(currpara.parasym).varoptions then
                 begin
                   if not(assigned(procdefinition.owner.defowner)) then
                     internalerror(200309287);
                   hiddentree:=cloadparentfpnode.create(tprocdef(procdefinition.owner.defowner));
                 end;
              { add the hidden parameter }
              if not assigned(hiddentree) then
                internalerror(200304073);
              { Already insert para and let the previous node point to
                this new node }
              pt:=ccallparanode.create(hiddentree,oldppt^);
              pt.used_by_callnode:=used_by_callnode;
              oldppt^:=pt;
            end;
           if not assigned(pt) then
             internalerror(200310052);
           pt.paraitem:=currpara;
           oldppt:=@pt.right;
           pt:=tcallparanode(pt.right);
           currpara:=tparaitem(currpara.previous)
         end;

        { Create paraitems for varargs }
        pt:=tcallparanode(left);
        while assigned(pt) do
          begin
            if nf_varargs_para in pt.flags then
              begin
                if not assigned(varargsparas) then
                  varargsparas:=tlinkedlist.create;
                varargspara:=tparaitem.create;
                varargspara.paratyp:=vs_value;
                varargspara.paratype:=pt.resulttype;
                { varargspara is left-right, use insert
                  instead of concat }
                varargsparas.insert(varargspara);
                pt.paraitem:=varargspara;
              end;
            pt:=tcallparanode(pt.right);
          end;
      end;


    function tcallnode.det_resulttype:tnode;
      var
        procs : pcandidate;
        oldcallnode : tcallnode;
        hpt : tnode;
        pt : tcallparanode;
        lastpara : longint;
        currpara : tparaitem;
        cand_cnt : integer;
        i : longint;
        method_must_be_valid,
        is_const : boolean;
      label
        errorexit;
      begin
         result:=nil;
         procs:=nil;

         oldcallnode:=aktcallnode;
         aktcallnode:=nil;

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
              set_varstate(right,vs_used,true);
              resulttypepass(right);
              if codegenerror then
               exit;

              procdefinition:=tabstractprocdef(right.resulttype.def);

              { Compare parameters from right to left }
              currpara:=tparaitem(procdefinition.Para.last);
              while assigned(currpara) and (currpara.is_hidden) do
                currpara:=tparaitem(currpara.previous);
              pt:=tcallparanode(left);
              lastpara:=paralength;
              while assigned(currpara) and assigned(pt) do
                begin
                  { only goto next para if we're out of the varargs }
                  if not(po_varargs in procdefinition.procoptions) or
                     (lastpara<=procdefinition.maxparacount) then
                   begin
                     repeat
                       currpara:=tparaitem(currpara.previous);
                     until (not assigned(currpara)) or (not currpara.is_hidden);
                   end;
                  pt:=tcallparanode(pt.right);
                  dec(lastpara);
                end;
              if assigned(pt) or
                 (assigned(currpara) and
                  not assigned(currpara.defaultvalue)) then
                begin
                   if assigned(pt) then
                     aktfilepos:=pt.fileinfo;
                   CGMessage(parser_e_wrong_parameter_size);
                   goto errorexit;
                end;
           end
         else
         { not a procedure variable }
           begin
              { do we know the procedure to call ? }
              if not(assigned(procdefinition)) then
                begin
                   procs:=candidates_find;

                   { no procedures found? then there is something wrong
                     with the parameter size or the procedures are
                     not accessible }
                   if not assigned(procs) then
                    begin
                      { when it's an auto inherited call and there
                        is no procedure found, but the procedures
                        were defined with overload directive and at
                        least two procedures are defined then we ignore
                        this inherited by inserting a nothingn. Only
                        do this ugly hack in Delphi mode as it looks more
                        like a bug. It's also not documented }
                      if (m_delphi in aktmodeswitches) and
                         (nf_anon_inherited in flags) and
                         (symtableprocentry.owner.symtabletype=objectsymtable) and
                         (po_overload in symtableprocentry.first_procdef.procoptions) and
                         (symtableprocentry.procdef_count>=2) then
                        result:=cnothingnode.create
                      else
                        begin
                          { in tp mode we can try to convert to procvar if
                            there are no parameters specified. Only try it
                            when there is only one proc definition, else the
                            loadnode will give a strange error }
                          if not(assigned(left)) and
                             not(nf_inherited in flags) and
                             (m_tp_procvar in aktmodeswitches) and
                             (symtableprocentry.procdef_count=1) then
                            begin
                              hpt:=cloadnode.create(tprocsym(symtableprocentry),symtableproc);
                              if assigned(methodpointer) then
                                tloadnode(hpt).set_mp(methodpointer.getcopy);
                              resulttypepass(hpt);
                              result:=hpt;
                            end
                          else
                            begin
                              if assigned(left) then
                               aktfilepos:=left.fileinfo;
                              if paravisible then
                                begin
                                  CGMessage(parser_e_wrong_parameter_size);
                                  symtableprocentry.write_parameter_lists(nil);
                                end
                              else
                                CGMessage(parser_e_cant_access_private_member);
                            end;
                        end;
                      goto errorexit;
                    end;

                   { Retrieve information about the candidates }
                   candidates_get_information(procs);
{$ifdef EXTDEBUG}
                   { Display info when multiple candidates are found }
                   if assigned(procs^.next) then
                     candidates_dump_info(V_Debug,procs);
{$endif EXTDEBUG}

                   { Choose the best candidate and count the number of
                     candidates left }
                   cand_cnt:=candidates_choose_best(procs,tprocdef(procdefinition));

                   { All parameters are checked, check if there are any
                     procedures left }
                   if cand_cnt>0 then
                    begin
                      { Multiple candidates left? }
                      if cand_cnt>1 then
                       begin
                         CGMessage(cg_e_cant_choose_overload_function);
{$ifdef EXTDEBUG}
                         candidates_dump_info(V_Hint,procs);
{$else}
                         candidates_list(procs,false);
{$endif EXTDEBUG}
                         { we'll just use the first candidate to make the
                           call }
                       end;

                      { assign procdefinition }
                      if symtableproc=nil then
                        symtableproc:=procdefinition.owner;

                      { update browser information }
                      if make_ref then
                        begin
                           tprocdef(procdefinition).lastref:=tref.create(tprocdef(procdefinition).lastref,@fileinfo);
                           inc(tprocdef(procdefinition).refcount);
                           if tprocdef(procdefinition).defref=nil then
                             tprocdef(procdefinition).defref:=tprocdef(procdefinition).lastref;
                        end;
                    end
                   else
                    begin
                      { No candidates left, this must be a type error,
                        because wrong size is already checked. procdefinition
                        is filled with the first (random) definition that is
                        found. We use this definition to display a nice error
                        message that the wrong type is passed }
                      candidates_find_wrong_para(procs);
                      candidates_list(procs,true);
{$ifdef EXTDEBUG}
                      candidates_dump_info(V_Hint,procs);
{$endif EXTDEBUG}

                      { We can not proceed, release all procs and exit }
                      candidates_free(procs);
                      goto errorexit;
                    end;

                   candidates_free(procs);
               end; { end of procedure to call determination }
           end;

          { add needed default parameters }
          if assigned(procdefinition) and
             (paralength<procdefinition.maxparacount) then
           begin
             currpara:=tparaitem(procdefinition.Para.first);
             i:=0;
             while (i<paralength) do
              begin
                if not assigned(currpara) then
                  internalerror(200306181);
                if not currpara.is_hidden then
                  inc(i);
                currpara:=tparaitem(currpara.next);
              end;
             while assigned(currpara) and
                   currpara.is_hidden do
               currpara:=tparaitem(currpara.next);
             while assigned(currpara) do
              begin
                if not assigned(currpara.defaultvalue) then
                 internalerror(200212142);
                left:=ccallparanode.create(genconstsymtree(tconstsym(currpara.defaultvalue)),left);
                currpara:=tparaitem(currpara.next);
              end;
           end;

          { handle predefined procedures }
          is_const:=(po_internconst in procdefinition.procoptions) and
                    ((block_type in [bt_const,bt_type]) or
                     (assigned(left) and (tcallparanode(left).left.nodetype in [realconstn,ordconstn])));
          if (procdefinition.proccalloption=pocall_internproc) or is_const then
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
             result:=hpt;
             goto errorexit;
           end;

         { ensure that the result type is set }
         if not restypeset then
          begin
            { constructors return their current class type, not the type where the
              constructor is declared, this can be different because of inheritance }
            if (procdefinition.proctypeoption=potype_constructor) and
               assigned(methodpointer) and
               assigned(methodpointer.resulttype.def) and
               (methodpointer.resulttype.def.deftype=classrefdef) then
              resulttype:=tclassrefdef(methodpointer.resulttype.def).pointertype
            else
              resulttype:=procdefinition.rettype;
           end
         else
           resulttype:=restype;

         if resulttype.def.needs_inittable then
           include(current_procinfo.flags,pi_needs_implicit_finally);

         if assigned(methodpointer) then
          begin
            resulttypepass(methodpointer);

            { direct call to inherited abstract method, then we
              can already give a error in the compiler instead
              of a runtime error }
            if (nf_inherited in flags) and
               (po_abstractmethod in procdefinition.procoptions) then
              CGMessage(cg_e_cant_call_abstract_method);

            { if an inherited con- or destructor should be  }
            { called in a con- or destructor then a warning }
            { will be made                                  }
            { con- and destructors need a pointer to the vmt }
            if (nf_inherited in flags) and
               (procdefinition.proctypeoption in [potype_constructor,potype_destructor]) and
               is_object(methodpointer.resulttype.def) and
               not(current_procinfo.procdef.proctypeoption in [potype_constructor,potype_destructor]) then
             CGMessage(cg_w_member_cd_call_from_method);

            if methodpointer.nodetype<>typen then
             begin
               hpt:=methodpointer;
               while assigned(hpt) and (hpt.nodetype in [subscriptn,vecn]) do
                hpt:=tunarynode(hpt).left;

               if (procdefinition.proctypeoption=potype_constructor) and
                  assigned(symtableproc) and
                  (symtableproc.symtabletype=withsymtable) and
                  (tnode(twithsymtable(symtableproc).withrefnode).nodetype=temprefn) then
                 CGmessage(cg_e_cannot_call_cons_dest_inside_with);

               { R.Init then R will be initialized by the constructor,
                 Also allow it for simple loads }
               if (procdefinition.proctypeoption=potype_constructor) or
                  ((hpt.nodetype=loadn) and
                   (
                    (methodpointer.resulttype.def.deftype=classrefdef) or
                    (
                     (methodpointer.resulttype.def.deftype=objectdef) and
                     not(oo_has_virtual in tobjectdef(methodpointer.resulttype.def).objectoptions)
                    )
                   )
                  ) then
                 method_must_be_valid:=false
               else
                 method_must_be_valid:=true;
               set_varstate(methodpointer,vs_used,method_must_be_valid);

               { The object is already used if it is called once }
               if (hpt.nodetype=loadn) and
                  (tloadnode(hpt).symtableentry.typ=varsym) then
                 tvarsym(tloadnode(hpt).symtableentry).varstate:=vs_used;
             end;

            { if we are calling the constructor check for abstract
              methods. Ignore inherited and member calls, because the
              class is then already created }
            if (procdefinition.proctypeoption=potype_constructor) and
               not(nf_inherited in flags) and
               not(nf_member_call in flags) then
              verifyabstractcalls;
          end
         else
          begin
            { When this is method the methodpointer must be available }
            if (right=nil) and
               (procdefinition.owner.symtabletype=objectsymtable) then
              internalerror(200305061);
          end;

         { Change loading of array of const to varargs }
         if assigned(left) and
            is_array_of_const(tparaitem(procdefinition.para.last).paratype.def) and
            (procdefinition.proccalloption in [pocall_cppdecl,pocall_cdecl]) then
           convert_carg_array_of_const;

         { bind paraitems to the callparanodes and insert hidden parameters }
         aktcallnode:=self;
         bind_paraitem;

         { methodpointer is only needed for virtual calls, and
           it should then be loaded with the VMT }
         if (po_virtualmethod in procdefinition.procoptions) and
            not(assigned(methodpointer) and
                (methodpointer.nodetype=typen)) then
          begin
            if not assigned(methodpointer) then
              internalerror(200305063);
            if (methodpointer.resulttype.def.deftype<>classrefdef) then
              begin
                methodpointer:=cloadvmtaddrnode.create(methodpointer);
                resulttypepass(methodpointer);
              end;
          end
         else
          begin
            { not needed anymore }
            methodpointer.free;
            methodpointer:=nil;
          end;

         { insert type conversions for parameters }
         if assigned(left) then
           tcallparanode(left).insert_typeconv(true);

      errorexit:
         aktcallnode:=oldcallnode;
      end;


    procedure tcallnode.order_parameters;
      var
        hp,hpcurr,hpnext,hpfirst,hpprev : tcallparanode;
        currloc : tcgloc;
      begin
        hpfirst:=nil;
        hpcurr:=tcallparanode(left);
        while assigned(hpcurr) do
          begin
            { pull out }
            hpnext:=tcallparanode(hpcurr.right);
            { pull in at the correct place.
              Used order:
                1. LOC_REFERENCE with smallest offset (x86 only)
                2. LOC_REFERENCE with most registers
                3. LOC_REGISTER with most registers }
            currloc:=hpcurr.paraitem.paraloc[callerside].loc;
            hpprev:=nil;
            hp:=hpfirst;
            while assigned(hp) do
              begin
                case currloc of
                  LOC_REFERENCE :
                    begin
                      case hp.paraitem.paraloc[callerside].loc of
                        LOC_REFERENCE :
                          begin
                            { Offset is calculated like:
                               sub esp,12
                               mov [esp+8],para3
                               mov [esp+4],para2
                               mov [esp],para1
                               call function
                              That means the for pushes the para with the
                              highest offset (see para3) needs to be pushed first
                            }
                            if (hpcurr.registers32>hp.registers32)
{$ifdef x86}
                               or (hpcurr.paraitem.paraloc[callerside].reference.offset>hp.paraitem.paraloc[callerside].reference.offset)
{$endif x86}
                               then
                              break;
                          end;
                        LOC_REGISTER,
                        LOC_FPUREGISTER :
                          break;
                      end;
                    end;
                  LOC_FPUREGISTER,
                  LOC_REGISTER :
                    begin
                      if (hp.paraitem.paraloc[callerside].loc=currloc) and
                         (hpcurr.registers32>hp.registers32) then
                        break;
                    end;
                end;
                hpprev:=hp;
                hp:=tcallparanode(hp.right);
              end;
            hpcurr.right:=hp;
            if assigned(hpprev) then
              hpprev.right:=hpcurr
            else
              hpfirst:=hpcurr;
            { next }
            hpcurr:=hpnext;
          end;
        left:=hpfirst;
      end;


    function tcallnode.pass_1 : tnode;
{$ifdef m68k}
      var
         regi : tregister;
{$endif}
      label
        errorexit;
      begin
         result:=nil;

         { calculate the parameter info for the procdef }
         if not procdefinition.has_paraloc_info then
           begin
             paramanager.create_paraloc_info(procdefinition,callerside);
             procdefinition.has_paraloc_info:=true;
           end;

         { calculate the parameter info for varargs }
         if assigned(varargsparas) then
           paramanager.create_varargs_paraloc_info(procdefinition,varargsparas);

         { work trough all parameters to get the register requirements }
         if assigned(left) then
           tcallparanode(left).det_registers;

         { order parameters }
         order_parameters;

         { function result node }
         if assigned(_funcretnode) then
           firstpass(_funcretnode);

         { procedure variable ? }
         if assigned(right) then
           begin
              firstpass(right);

              { procedure does a call }
              if not (block_type in [bt_const,bt_type]) then
                include(current_procinfo.flags,pi_do_call);
           end
         else
         { not a procedure variable }
           begin
              { calc the correture value for the register }
              { handle predefined procedures }
              if (procdefinition.proccalloption=pocall_inline) then
                begin
                   if assigned(methodpointer) then
                     CGMessage(cg_e_unable_inline_object_methods);
                   if assigned(right) then
                     CGMessage(cg_e_unable_inline_procvar);
                   if not assigned(inlinecode) then
                     begin
                       if assigned(tprocdef(procdefinition).code) then
                         inlinecode:=tprocdef(procdefinition).code.getcopy
                       else
                         CGMessage(cg_e_no_code_for_inline_stored);
                       if assigned(inlinecode) then
                         begin
                           { consider it has not inlined if called
                             again inside the args }
                           procdefinition.proccalloption:=pocall_default;
                           firstpass(inlinecode);
                         end;
                     end;
                end
              else
                begin
                  if not (block_type in [bt_const,bt_type]) then
                    include(current_procinfo.flags,pi_do_call);
                end;

           end;

         { get a register for the return value }
         if (not is_void(resulttype.def)) then
           begin
              if paramanager.ret_in_param(resulttype.def,procdefinition.proccalloption) then
               begin
                 expectloc:=LOC_REFERENCE;
               end
             else
             { for win32 records returned in EDX:EAX, we
               move them to memory after ... }
             if (resulttype.def.deftype=recorddef) then
              begin
                expectloc:=LOC_CREFERENCE;
              end
             else
             { ansi/widestrings must be registered, so we can dispose them }
              if is_ansistring(resulttype.def) or
                 is_widestring(resulttype.def) then
               begin
                 expectloc:=LOC_CREFERENCE;
                 registers32:=1;
               end
             else
             { we have only to handle the result if it is used }
              if (nf_return_value_used in flags) then
               begin
                 case resulttype.def.deftype of
                   enumdef,
                   orddef :
                     begin
                       if (procdefinition.proctypeoption=potype_constructor) then
                        begin
                          expectloc:=LOC_REGISTER;
                          registers32:=1;
                        end
                       else
                        begin
                          expectloc:=LOC_REGISTER;
                          if is_64bit(resulttype.def) then
                            registers32:=2
                          else
                            registers32:=1;
                        end;
                     end;
                   floatdef :
                     begin
                       expectloc:=LOC_FPUREGISTER;
{$ifdef cpufpemu}
                       if (cs_fp_emulation in aktmoduleswitches) then
                         registers32:=1
                       else
{$endif cpufpemu}
{$ifdef m68k}
                        if (tfloatdef(resulttype.def).typ=s32real) then
                         registers32:=1
                       else
{$endif m68k}
                         registersfpu:=1;
                     end;
                   else
                     begin
                       expectloc:=LOC_REGISTER;
                       registers32:=1;
                     end;
                 end;
               end
             else
               expectloc:=LOC_VOID;
           end
         else
           expectloc:=LOC_VOID;

{$ifdef m68k}
         { we need one more address register for virtual calls on m68k }
         if (po_virtualmethod in procdefinition.procoptions) then
           inc(registers32);
{$endif m68k}
         { a fpu can be used in any procedure !! }
{$ifdef i386}
         registersfpu:=procdefinition.fpu_used;
{$endif i386}
         { if this is a call to a method calc the registers }
         if (methodpointer<>nil) then
           begin
              if methodpointer.nodetype<>typen then
               begin
                 firstpass(methodpointer);
                 registersfpu:=max(methodpointer.registersfpu,registersfpu);
                 registers32:=max(methodpointer.registers32,registers32);
{$ifdef SUPPORT_MMX }
                 registersmmx:=max(methodpointer.registersmmx,registersmmx);
{$endif SUPPORT_MMX}
               end;
           end;

         { determine the registers of the procedure variable }
         { is this OK for inlined procs also ?? (PM)     }
         if assigned(inlinecode) then
           begin
              registersfpu:=max(inlinecode.registersfpu,registersfpu);
              registers32:=max(inlinecode.registers32,registers32);
{$ifdef SUPPORT_MMX}
              registersmmx:=max(inlinecode.registersmmx,registersmmx);
{$endif SUPPORT_MMX}
           end;
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
         if assigned(inlinecode) then
           procdefinition.proccalloption:=pocall_inline;
      end;

{$ifdef state_tracking}
    function Tcallnode.track_state_pass(exec_known:boolean):boolean;

    var hp:Tcallparanode;
        value:Tnode;

    begin
        track_state_pass:=false;
        hp:=Tcallparanode(left);
        while assigned(hp) do
            begin
                if left.track_state_pass(exec_known) then
                    begin
                        left.resulttype.def:=nil;
                        do_resulttypepass(left);
                    end;
                value:=aktstate.find_fact(hp.left);
                if value<>nil then
                    begin
                        track_state_pass:=true;
                        hp.left.destroy;
                        hp.left:=value.getcopy;
                        do_resulttypepass(hp.left);
                    end;
                hp:=Tcallparanode(hp.right);
            end;
    end;
{$endif}


    function tcallnode.para_count:longint;
      var
        ppn : tcallparanode;
      begin
        result:=0;
        ppn:=tcallparanode(left);
        while assigned(ppn) do
          begin
            if not(assigned(ppn.paraitem) and
                   ppn.paraitem.is_hidden) then
              inc(result);
            ppn:=tcallparanode(ppn.right);
          end;
      end;


    function tcallnode.docompare(p: tnode): boolean;
      begin
        docompare :=
          inherited docompare(p) and
          (symtableprocentry = tcallnode(p).symtableprocentry) and
          (procdefinition = tcallnode(p).procdefinition) and
          (methodpointer.isequal(tcallnode(p).methodpointer)) and
          ((restypeset and tcallnode(p).restypeset and
            (equal_defs(restype.def,tcallnode(p).restype.def))) or
           (not restypeset and not tcallnode(p).restypeset));
      end;


    procedure tcallnode.printnodedata(var t:text);
      begin
        if assigned(procdefinition) and
           (procdefinition.deftype=procdef) then
          writeln(t,printnodeindention,'proc = ',tprocdef(procdefinition).fullprocname(true))
        else
          begin
            if assigned(symtableprocentry) then
              writeln(t,printnodeindention,'proc = ',symtableprocentry.name)
            else
              writeln(t,printnodeindention,'proc = <nil>');
          end;
        printnode(t,methodpointer);
        printnode(t,right);
        printnode(t,left);
      end;


begin
   ccallnode:=tcallnode;
   ccallparanode:=tcallparanode;
end.
{
  $Log$
  Revision 1.211  2003-12-08 16:34:23  peter
    * varargspara is left-right, so adding paraitems needs insert
      instead of concat

  Revision 1.210  2003/12/01 18:44:15  peter
    * fixed some crashes
    * fixed varargs and register calling probs

  Revision 1.209  2003/11/28 17:24:22  peter
    * reversed offset calculation for caller side so it works
      correctly for interfaces

  Revision 1.208  2003/11/23 17:05:15  peter
    * register calling is left-right
    * parameter ordering
    * left-right calling inserts result parameter last

  Revision 1.207  2003/11/10 22:02:52  peter
    * cross unit inlining fixed

  Revision 1.206  2003/11/10 19:09:29  peter
    * procvar default value support

  Revision 1.205  2003/11/06 15:54:32  peter
    * fixed calling classmethod for other object from classmethod

  Revision 1.204  2003/11/01 16:17:48  peter
    * use explicit typecast when generating the high value

  Revision 1.203  2003/10/31 15:52:58  peter
    * support creating classes using <class of tobject>.create

  Revision 1.202  2003/10/30 16:23:13  peter
    * don't search for overloads in parents for constructors

  Revision 1.201  2003/10/29 22:01:20  florian
    * fixed passing of dyn. arrays to open array parameters

  Revision 1.200  2003/10/23 14:44:07  peter
    * splitted buildderef and buildderefimpl to fix interface crc
      calculation

  Revision 1.199  2003/10/22 20:40:00  peter
    * write derefdata in a separate ppu entry

  Revision 1.198  2003/10/21 18:17:02  peter
    * only search for overloaded constructors in classes

  Revision 1.197  2003/10/21 15:14:55  peter
    * also search in parents for overloads when calling a constructor

  Revision 1.196  2003/10/13 14:05:12  peter
    * removed is_visible_for_proc
    * search also for class overloads when finding interface
      implementations

  Revision 1.195  2003/10/09 21:31:37  daniel
    * Register allocator splitted, ans abstract now

  Revision 1.194  2003/10/09 15:00:13  florian
    * fixed constructor call in class methods

  Revision 1.193  2003/10/08 19:19:45  peter
    * set_varstate cleanup

  Revision 1.192  2003/10/07 21:14:32  peter
    * compare_paras() has a parameter to ignore hidden parameters
    * cross unit overload searching ignores hidden parameters when
      comparing parameter lists. Now function(string):string is
      not overriden with procedure(string) which has the same visible
      parameter list

  Revision 1.191  2003/10/05 21:21:52  peter
    * c style array of const generates callparanodes
    * varargs paraloc fixes

  Revision 1.190  2003/10/05 12:54:17  peter
    * don't check for abstract methods when the constructor is called
      by inherited
    * fix private member error instead of wrong number of parameters

  Revision 1.189  2003/10/04 19:00:52  florian
    * fixed TP 6.0 styled inherited call; fixes IDE with 1.1

  Revision 1.188  2003/10/03 22:00:33  peter
    * parameter alignment fixes

  Revision 1.187  2003/10/03 14:44:38  peter
    * fix IE when callnode was firstpassed twice

  Revision 1.186  2003/10/02 21:13:46  peter
    * protected visibility fixes

  Revision 1.185  2003/10/01 20:34:48  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.184  2003/09/28 21:44:55  peter
    * fix check that filedef needs var para

  Revision 1.183  2003/09/28 17:55:03  peter
    * parent framepointer changed to hidden parameter
    * tloadparentfpnode added

  Revision 1.182  2003/09/25 21:28:00  peter
    * parameter fixes

  Revision 1.181  2003/09/23 17:56:05  peter
    * locals and paras are allocated in the code generation
    * tvarsym.localloc contains the location of para/local when
      generating code for the current procedure

  Revision 1.180  2003/09/16 16:17:01  peter
    * varspez in calls to push_addr_param

  Revision 1.179  2003/09/07 22:09:35  peter
    * preparations for different default calling conventions
    * various RA fixes

  Revision 1.178  2003/09/06 22:27:08  florian
    * fixed web bug 2669
    * cosmetic fix in printnode
    * tobjectdef.gettypename implemented

  Revision 1.177  2003/09/03 15:55:00  peter
    * NEWRA branch merged

  Revision 1.176.2.3  2003/08/31 21:07:44  daniel
    * callparatemp ripped

  Revision 1.176.2.2  2003/08/27 20:23:55  peter
    * remove old ra code

  Revision 1.176.2.1  2003/08/27 19:55:54  peter
    * first tregister patch

  Revision 1.176  2003/08/23 18:42:57  peter
    * only check for size matches when parameter is enum,ord,float

  Revision 1.175  2003/08/10 17:25:23  peter
    * fixed some reported bugs

  Revision 1.174  2003/07/25 09:54:57  jonas
    * fixed bogus abstract method warnings

  Revision 1.173  2003/06/25 18:31:23  peter
    * sym,def resolving partly rewritten to support also parent objects
      not directly available through the uses clause

  Revision 1.172  2003/06/17 16:34:44  jonas
    * lots of newra fixes (need getfuncretparaloc implementation for i386)!
    * renamed all_intregisters to volatile_intregisters and made it
      processor dependent

  Revision 1.171  2003/06/15 16:47:33  jonas
    * fixed revious commit

  Revision 1.170  2003/06/15 15:10:57  jonas
    * callparatemp fix: if a threadvar is a parameter, that paramter also
      does a call

  Revision 1.169  2003/06/13 21:19:30  peter
    * current_procdef removed, use current_procinfo.procdef instead

  Revision 1.168  2003/06/08 20:01:53  jonas
    * optimized assignments with on the right side a function that returns
      an ansi- or widestring

  Revision 1.167  2003/06/08 18:27:15  jonas
    + ability to change the location of a ttempref node with changelocation()
      method. Useful to use instead of copying the contents from one temp to
      another
    + some shortstring optimizations in tassignmentnode that avoid some
      copying (required some shortstring optimizations to be moved from
      resulttype to firstpass, because they work on callnodes and string
      addnodes are only changed to callnodes in the firstpass)
    * allow setting/changing the funcretnode of callnodes after the
      resulttypepass has been done, funcretnode is now a property
    (all of the above should have a quite big effect on callparatemp)

  Revision 1.166  2003/06/08 11:42:33  peter
    * creating class with abstract call checking fixed
    * there will be only one warning for each class, the methods
      are listed as hint

  Revision 1.165  2003/06/07 20:26:32  peter
    * re-resolving added instead of reloading from ppu
    * tderef object added to store deref info for resolving

  Revision 1.164  2003/06/03 21:05:48  peter
    * fix check for procedure without parameters
    * calling constructor as member will not allocate memory

  Revision 1.163  2003/06/03 13:01:59  daniel
    * Register allocator finished

  Revision 1.162  2003/05/26 21:17:17  peter
    * procinlinenode removed
    * aktexit2label removed, fast exit removed
    + tcallnode.inlined_pass_2 added

  Revision 1.161  2003/05/25 11:34:17  peter
    * methodpointer self pushing fixed

  Revision 1.160  2003/05/25 08:59:16  peter
    * inline fixes

  Revision 1.159  2003/05/24 17:16:37  jonas
    * added missing firstpass for callparatemp code

  Revision 1.158  2003/05/23 14:27:35  peter
    * remove some unit dependencies
    * current_procinfo changes to store more info

  Revision 1.157  2003/05/17 14:05:58  jonas
    * fixed callparatemp for ansi/widestring and interfacecoms

  Revision 1.156  2003/05/17 13:30:08  jonas
    * changed tt_persistant to tt_persistent :)
    * tempcreatenode now doesn't accept a boolean anymore for persistent
      temps, but a ttemptype, so you can also create ansistring temps etc

  Revision 1.155  2003/05/16 14:33:31  peter
    * regvar fixes

  Revision 1.154  2003/05/14 19:35:50  jonas
    * fixed callparatemp so it works with vs_var, vs_out and formal const
      parameters

  Revision 1.153  2003/05/13 20:53:41  peter
    * constructors return in register

  Revision 1.152  2003/05/13 15:18:49  peter
    * fixed various crashes

  Revision 1.151  2003/05/11 21:37:03  peter
    * moved implicit exception frame from ncgutil to psub
    * constructor/destructor helpers moved from cobj/ncgutil to psub

  Revision 1.150  2003/05/11 14:45:12  peter
    * tloadnode does not support objectsymtable,withsymtable anymore
    * withnode cleanup
    * direct with rewritten to use temprefnode

  Revision 1.149  2003/05/09 17:47:02  peter
    * self moved to hidden parameter
    * removed hdisposen,hnewn,selfn

  Revision 1.148  2003/05/05 14:53:16  peter
    * vs_hidden replaced by is_hidden boolean

  Revision 1.147  2003/04/27 11:21:33  peter
    * aktprocdef renamed to current_procinfo.procdef
    * procinfo renamed to current_procinfo
    * procinfo will now be stored in current_module so it can be
      cleaned up properly
    * gen_main_procsym changed to create_main_proc and release_main_proc
      to also generate a tprocinfo structure
    * fixed unit implicit initfinal

  Revision 1.146  2003/04/27 09:08:44  jonas
    * do callparatemp stuff only after the parameters have been firstpassed,
      because some nodes are turned into calls during the firstpass

  Revision 1.145  2003/04/27 07:29:50  peter
    * current_procinfo.procdef cleanup, current_procdef is now always nil when parsing
      a new procdef declaration
    * aktprocsym removed
    * lexlevel removed, use symtable.symtablelevel instead
    * implicit init/final code uses the normal genentry/genexit
    * funcret state checking updated for new funcret handling

  Revision 1.144  2003/04/25 20:59:33  peter
    * removed funcretn,funcretsym, function result is now in varsym
      and aliases for result and function name are added using absolutesym
    * vs_hidden parameter for funcret passed in parameter
    * vs_hidden fixes
    * writenode changed to printnode and released from extdebug
    * -vp option added to generate a tree.log with the nodetree
    * nicer printnode for statements, callnode

  Revision 1.143  2002/04/25 20:15:39  florian
    * block nodes within expressions shouldn't release the used registers,
      fixed using a flag till the new rg is ready

  Revision 1.142  2003/04/23 20:16:04  peter
    + added currency support based on int64
    + is_64bit for use in cg units instead of is_64bitint
    * removed cgmessage from n386add, replace with internalerrors

  Revision 1.141  2003/04/23 13:21:06  peter
    * fix warning for calling constructor inside constructor

  Revision 1.140  2003/04/23 12:35:34  florian
    * fixed several issues with powerpc
    + applied a patch from Jonas for nested function calls (PowerPC only)
    * ...

  Revision 1.139  2003/04/22 23:50:22  peter
    * firstpass uses expectloc
    * checks if there are differences between the expectloc and
      location.loc from secondpass in EXTDEBUG

  Revision 1.138  2003/04/22 09:53:33  peter
    * fix insert_typeconv to handle new varargs which don't have a
      paraitem set

  Revision 1.137  2003/04/11 16:02:05  peter
    * don't firstpass typen

  Revision 1.136  2003/04/11 15:51:04  peter
    * support subscript,vec for setting methodpointer varstate

  Revision 1.135  2003/04/10 17:57:52  peter
    * vs_hidden released

  Revision 1.134  2003/04/07 11:58:22  jonas
    * more vs_invisible fixes

  Revision 1.133  2003/04/07 10:40:21  jonas
    * fixed VS_HIDDEN for high parameter so it works again

  Revision 1.132  2003/04/04 15:38:56  peter
    * moved generic code from n386cal to ncgcal, i386 now also
      uses the generic ncgcal

  Revision 1.131  2003/03/17 18:54:23  peter
    * fix missing self setting for method to procvar conversion in
      tp_procvar mode

  Revision 1.130  2003/03/17 16:54:41  peter
    * support DefaultHandler and anonymous inheritance fixed
      for message methods

  Revision 1.129  2003/03/17 15:54:22  peter
    * store symoptions also for procdef
    * check symoptions (private,public) when calculating possible
      overload candidates

  Revision 1.128  2003/02/19 22:00:14  daniel
    * Code generator converted to new register notation
    - Horribily outdated todo.txt removed

  Revision 1.127  2003/01/16 22:13:52  peter
    * convert_l3 convertlevel added. This level is used for conversions
      where information can be lost like converting widestring->ansistring
      or dword->byte

  Revision 1.126  2003/01/15 01:44:32  peter
    * merged methodpointer fixes from 1.0.x

  Revision 1.125  2003/01/12 17:52:07  peter
    * only check for auto inherited in objectsymtable

  Revision 1.124  2003/01/09 21:45:46  peter
    * extended information about overloaded candidates when compiled
      with EXTDEBUG

  Revision 1.123  2002/12/26 18:24:33  jonas
  * fixed check for whether or not a high parameter was already generated
  * no type checking/conversions for invisible parameters

  Revision 1.122  2002/12/15 22:50:00  florian
    + some stuff for the new hidden parameter handling added

  Revision 1.121  2002/12/15 21:34:15  peter
    * give sign difference between ordinals a small penalty. This is
      needed to get word->[longword|longint] working

  Revision 1.120  2002/12/15 21:30:12  florian
    * tcallnode.paraitem introduced, all references to defcoll removed

  Revision 1.119  2002/12/15 20:59:58  peter
    * fix crash with default parameters

  Revision 1.118  2002/12/15 11:26:02  peter
    * ignore vs_hidden parameters when choosing overloaded proc

  Revision 1.117  2002/12/11 22:42:28  peter
    * tcallnode.det_resulttype rewrite, merged code from nice_ncal and
      the old code. The new code collects the information about possible
      candidates only once resultting in much less calls to type compare
      routines

  Revision 1.116  2002/12/07 14:27:07  carl
    * 3% memory optimization
    * changed some types
    + added type checking with different size for call node and for
       parameters

  Revision 1.115  2002/12/06 17:51:10  peter
    * merged cdecl and array fixes

  Revision 1.114  2002/12/06 16:56:58  peter
    * only compile cs_fp_emulation support when cpufpuemu is defined
    * define cpufpuemu for m68k only

  Revision 1.113  2002/11/27 20:04:38  peter
    * cdecl array of const fixes

  Revision 1.112  2002/11/27 15:33:46  peter
    * the never ending story of tp procvar hacks

  Revision 1.111  2002/11/27 02:31:17  peter
    * fixed inlinetree parsing in det_resulttype

  Revision 1.110  2002/11/25 18:43:32  carl
   - removed the invalid if <> checking (Delphi is strange on this)
   + implemented abstract warning on instance creation of class with
      abstract methods.
   * some error message cleanups

  Revision 1.109  2002/11/25 17:43:17  peter
    * splitted defbase in defutil,symutil,defcmp
    * merged isconvertable and is_equal into compare_defs(_ext)
    * made operator search faster by walking the list only once

  Revision 1.108  2002/11/18 17:31:54  peter
    * pass proccalloption to ret_in_xxx and push_xxx functions

  Revision 1.107  2002/11/15 01:58:50  peter
    * merged changes from 1.0.7 up to 04-11
      - -V option for generating bug report tracing
      - more tracing for option parsing
      - errors for cdecl and high()
      - win32 import stabs
      - win32 records<=8 are returned in eax:edx (turned off by default)
      - heaptrc update
      - more info for temp management in .s file with EXTDEBUG

  Revision 1.106  2002/10/14 18:20:30  carl
    * var parameter checking for classes and interfaces in Delphi mode

  Revision 1.105  2002/10/06 21:02:17  peter
    * fixed limit checking for qword

  Revision 1.104  2002/10/05 15:15:45  peter
    * Write unknwon compiler proc using Comment and only in Extdebug

  Revision 1.103  2002/10/05 12:43:25  carl
    * fixes for Delphi 6 compilation
     (warning : Some features do not work under Delphi)

  Revision 1.102  2002/10/05 00:48:57  peter
    * support inherited; support for overload as it is handled by
      delphi. This is only for delphi mode as it is working is
      undocumented and hard to predict what is done

  Revision 1.101  2002/09/16 14:11:12  peter
    * add argument to equal_paras() to support default values or not

  Revision 1.100  2002/09/15 17:49:59  peter
    * don't have strict var parameter checking for procedures in the
      system unit

  Revision 1.99  2002/09/09 19:30:34  peter
    * don't allow convertable parameters for var and out parameters in
      delphi and tp mode

  Revision 1.98  2002/09/07 15:25:02  peter
    * old logs removed and tabs fixed

  Revision 1.97  2002/09/07 12:16:05  carl
    * second part bug report 1996 fix, testrange in cordconstnode
      only called if option is set (also make parsing a tiny faster)

  Revision 1.96  2002/09/05 14:53:41  peter
    * fixed old callnode.det_resulttype code
    * old ncal code is default again

  Revision 1.95  2002/09/03 21:32:49  daniel
    * Small bugfix for procdef selection

  Revision 1.94  2002/09/03 19:27:22  daniel
    * Activated new ncal code

  Revision 1.93  2002/09/03 16:26:26  daniel
    * Make Tprocdef.defs protected

  Revision 1.92  2002/09/01 13:28:37  daniel
   - write_access fields removed in favor of a flag

  Revision 1.91  2002/09/01 12:14:15  peter
    * remove debug line
    * containself methods can be called directly

  Revision 1.90  2002/09/01 08:01:16  daniel
   * Removed sets from Tcallnode.det_resulttype
   + Added read/write notifications of variables. These will be usefull
     for providing information for several optimizations. For example
     the value of the loop variable of a for loop does matter is the
     variable is read after the for loop, but if it's no longer used
     or written, it doesn't matter and this can be used to optimize
     the loop code generation.

  Revision 1.89  2002/08/23 16:13:16  peter
    * also firstpass funcretrefnode if available. This was breaking the
      asnode compilerproc code

  Revision 1.88  2002/08/20 10:31:26  daniel
   * Tcallnode.det_resulttype rewritten

  Revision 1.87  2002/08/19 19:36:42  peter
    * More fixes for cross unit inlining, all tnodes are now implemented
    * Moved pocall_internconst to po_internconst because it is not a
      calling type at all and it conflicted when inlining of these small
      functions was requested

  Revision 1.86  2002/08/17 22:09:44  florian
    * result type handling in tcgcal.pass_2 overhauled
    * better tnode.dowrite
    * some ppc stuff fixed

  Revision 1.85  2002/08/17 09:23:34  florian
    * first part of current_procinfo rewrite

  Revision 1.84  2002/08/16 14:24:57  carl
    * issameref() to test if two references are the same (then emit no opcodes)
    + ret_in_reg to replace ret_in_acc
      (fix some register allocation bugs at the same time)
    + save_std_register now has an extra parameter which is the
      usedinproc registers

  Revision 1.83  2002/07/20 11:57:53  florian
    * types.pas renamed to defbase.pas because D6 contains a types
      unit so this would conflicts if D6 programms are compiled
    + Willamette/SSE2 instructions to assembler added

  Revision 1.82  2002/07/19 11:41:35  daniel
  * State tracker work
  * The whilen and repeatn are now completely unified into whilerepeatn. This
    allows the state tracker to change while nodes automatically into
    repeat nodes.
  * Resulttypepass improvements to the notn. 'not not a' is optimized away and
    'not(a>b)' is optimized into 'a<=b'.
  * Resulttypepass improvements to the whilerepeatn. 'while not a' is optimized
    by removing the notn and later switchting the true and falselabels. The
    same is done with 'repeat until not a'.

  Revision 1.81  2002/07/15 18:03:14  florian
    * readded removed changes

  Revision 1.79  2002/07/11 14:41:27  florian
    * start of the new generic parameter handling

  Revision 1.80  2002/07/14 18:00:43  daniel
  + Added the beginning of a state tracker. This will track the values of
    variables through procedures and optimize things away.

  Revision 1.78  2002/07/04 20:43:00  florian
    * first x86-64 patches

}
