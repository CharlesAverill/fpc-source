{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    Does object types for Free Pascal

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
unit pdecobj;

{$i fpcdefs.inc}

interface

    uses
      globtype,symtype,symdef;

    { parses a object declaration }
    function object_dec(const n : stringid;fd : tobjectdef) : tdef;

implementation

    uses
      cutils,cclasses,
      globals,verbose,systems,tokens,
      symconst,symbase,symsym,symtable,defutil,defcmp,
      node,nld,nmem,ncon,ncnv,ncal,pass_1,
      scanner,
      pbase,pexpr,pdecsub,pdecvar,ptype
{$ifdef delphi}
      ,dmisc
      ,sysutils
{$endif}
      ;

    const
      { Please leave this here, this module should NOT use
        these variables.
        Declaring it as string here results in an error when compiling (PFV) }
      current_procinfo = 'error';


    function object_dec(const n : stringid;fd : tobjectdef) : tdef;
    { this function parses an object or class declaration }
      var
         there_is_a_destructor : boolean;
         classtype : tobjectdeftype;
         childof : tobjectdef;
         aktclass : tobjectdef;

      function constructor_head:tprocdef;
        var
          pd : tprocdef;
        begin
           consume(_CONSTRUCTOR);
           { must be at same level as in implementation }
           parse_proc_head(aktclass,potype_constructor,pd);
           if not assigned(pd) then
             begin
               consume(_SEMICOLON);
               exit;
             end;
           if (cs_constructor_name in aktglobalswitches) and
              (pd.procsym.name<>'INIT') then
             Message(parser_e_constructorname_must_be_init);
           consume(_SEMICOLON);
           include(aktclass.objectoptions,oo_has_constructor);
           { Set return type, class constructors return the
             created instance, object constructors return boolean }
           if is_class(pd._class) then
            pd.rettype.setdef(pd._class)
           else
            pd.rettype:=booltype;
           constructor_head:=pd;
        end;


      procedure property_dec;
        var
          p : tpropertysym;
        begin
           { check for a class }
           if not((is_class_or_interface(aktclass)) or
              ((m_delphi in aktmodeswitches) and (is_object(aktclass)))) then
             Message(parser_e_syntax_error);
           consume(_PROPERTY);
           p:=read_property_dec(aktclass);
           consume(_SEMICOLON);
           if try_to_consume(_DEFAULT) then
             begin
               include(p.propoptions,ppo_defaultproperty);
               if not(ppo_hasparameters in p.propoptions) then
                 message(parser_e_property_need_paras);
               consume(_SEMICOLON);
             end;
        end;


      function destructor_head:tprocdef;
        var
          pd : tprocdef;
        begin
           consume(_DESTRUCTOR);
           parse_proc_head(aktclass,potype_destructor,pd);
           if not assigned(pd) then
             begin
               consume(_SEMICOLON);
               exit;
             end;
           if (cs_constructor_name in aktglobalswitches) and
              (pd.procsym.name<>'DONE') then
             Message(parser_e_destructorname_must_be_done);
           if not(pd.maxparacount=0) and
              (m_fpc in aktmodeswitches) then
             Message(parser_e_no_paras_for_destructor);
           consume(_SEMICOLON);
           include(aktclass.objectoptions,oo_has_destructor);
           { no return value }
           pd.rettype:=voidtype;
           destructor_head:=pd;
        end;

      var
         hs      : string;
         pcrd       : tclassrefdef;
         tt     : ttype;
         old_object_option : tsymoptions;
         oldparse_only : boolean;
         storetypecanbeforward : boolean;

      procedure setclassattributes;

        begin
           { publishable }
           if classtype in [odt_interfacecom,odt_class] then
             begin
                aktclass.objecttype:=classtype;
                if (cs_generate_rtti in aktlocalswitches) or
                    (assigned(aktclass.childof) and
                     (oo_can_have_published in aktclass.childof.objectoptions)) then
                  begin
                     include(aktclass.objectoptions,oo_can_have_published);
                     { in "publishable" classes the default access type is published }
                     current_object_option:=[sp_published];
                  end;
             end;
        end;

     procedure setclassparent;

        begin
           if assigned(fd) then
             aktclass:=fd
           else
             aktclass:=tobjectdef.create(classtype,n,nil);
           { is the current class tobject?   }
           { so you could define your own tobject }
           if (cs_compilesystem in aktmoduleswitches) and (classtype=odt_class) and (upper(n)='TOBJECT') then
             class_tobject:=aktclass
           else if (cs_compilesystem in aktmoduleswitches) and (classtype=odt_interfacecom) and (upper(n)='IUNKNOWN') then
             interface_iunknown:=aktclass
           else
             begin
                case classtype of
                  odt_class:
                    childof:=class_tobject;
                  odt_interfacecom:
                    childof:=interface_iunknown;
                end;
                if (oo_is_forward in childof.objectoptions) then
                  Message1(parser_e_forward_declaration_must_be_resolved,childof.objrealname^);
                aktclass.set_parent(childof);
             end;
         end;

      procedure setinterfacemethodoptions;

        var
          i: longint;
          defs: TIndexArray;
          pd: tprocdef;
        begin
          include(aktclass.objectoptions,oo_has_virtual);
          defs:=aktclass.symtable.defindex;
          for i:=1 to defs.count do
            begin
              pd:=tprocdef(defs.search(i));
              if pd.deftype=procdef then
                begin
                  pd.extnumber:=aktclass.lastvtableindex;
                  inc(aktclass.lastvtableindex);
                  include(pd.procoptions,po_virtualmethod);
                  pd.forwarddef:=false;
                end;
            end;
        end;

      function readobjecttype : boolean;

        begin
           readobjecttype:=true;
           { distinguish classes and objects }
           case token of
              _OBJECT:
                begin
                   classtype:=odt_object;
                   consume(_OBJECT)
                end;
              _CPPCLASS:
                begin
                   classtype:=odt_cppclass;
                   consume(_CPPCLASS);
                end;
              _INTERFACE:
                begin
                   { need extra check here since interface is a keyword
                     in all pascal modes }
                   if not(m_class in aktmodeswitches) then
                     Message(parser_f_need_objfpc_or_delphi_mode);
                   if aktinterfacetype=it_interfacecom then
                     classtype:=odt_interfacecom
                   else {it_interfacecorba}
                     classtype:=odt_interfacecorba;
                   consume(_INTERFACE);
                   { forward declaration }
                   if not(assigned(fd)) and (token=_SEMICOLON) then
                     begin
                       { also anonym objects aren't allow (o : object a : longint; end;) }
                       if n='' then
                         Message(parser_f_no_anonym_objects);
                       aktclass:=tobjectdef.create(classtype,n,nil);
                       if (cs_compilesystem in aktmoduleswitches) and
                          (classtype=odt_interfacecom) and (upper(n)='IUNKNOWN') then
                         interface_iunknown:=aktclass;
                       include(aktclass.objectoptions,oo_is_forward);
                       object_dec:=aktclass;
                       typecanbeforward:=storetypecanbeforward;
                       readobjecttype:=false;
                       exit;
                     end;
                end;
              _CLASS:
                begin
                   classtype:=odt_class;
                   consume(_CLASS);
                   if not(assigned(fd)) and
                      (token=_OF) and
                      { Delphi only allows class of in type blocks.
                        Note that when parsing the type of a variable declaration
                        the blocktype is bt_type so the check for typecanbeforward
                        is also necessary (PFV) }
                      (((block_type=bt_type) and typecanbeforward) or
                       not(m_delphi in aktmodeswitches)) then
                     begin
                        { a hack, but it's easy to handle }
                        { class reference type }
                        consume(_OF);
                        single_type(tt,hs,typecanbeforward);

                        { accept hp1, if is a forward def or a class }
                        if (tt.def.deftype=forwarddef) or
                           is_class(tt.def) then
                          begin
                             pcrd:=tclassrefdef.create(tt);
                             object_dec:=pcrd;
                          end
                        else
                          begin
                             object_dec:=generrortype.def;
                             Message1(type_e_class_type_expected,generrortype.def.typename);
                          end;
                        typecanbeforward:=storetypecanbeforward;
                        readobjecttype:=false;
                        exit;
                     end
                   { forward class }
                   else if not(assigned(fd)) and (token=_SEMICOLON) then
                     begin
                        { also anonym objects aren't allow (o : object a : longint; end;) }
                        if n='' then
                          Message(parser_f_no_anonym_objects);
                        aktclass:=tobjectdef.create(odt_class,n,nil);
                        if (cs_compilesystem in aktmoduleswitches) and (upper(n)='TOBJECT') then
                          class_tobject:=aktclass;
                        aktclass.objecttype:=odt_class;
                        include(aktclass.objectoptions,oo_is_forward);
                        { all classes must have a vmt !!  at offset zero }
                        if not(oo_has_vmt in aktclass.objectoptions) then
                          aktclass.insertvmt;

                        object_dec:=aktclass;
                        typecanbeforward:=storetypecanbeforward;
                        readobjecttype:=false;
                        exit;
                     end;
                end;
              else
                begin
                   classtype:=odt_class; { this is error but try to recover }
                   consume(_OBJECT);
                end;
           end;
        end;

      procedure handleimplementedinterface(implintf : tobjectdef);

        begin
            if not is_interface(implintf) then
              begin
                 Message1(type_e_interface_type_expected,implintf.typename);
                 exit;
              end;
            if aktclass.implementedinterfaces.searchintf(implintf)<>-1 then
              Message1(sym_e_duplicate_id,implintf.name)
            else
              begin
                 { allocate and prepare the GUID only if the class
                   implements some interfaces.
                 }
                 if aktclass.implementedinterfaces.count = 0 then
                   aktclass.prepareguid;
                 aktclass.implementedinterfaces.addintf(implintf);
              end;
        end;

      procedure readimplementedinterfaces;
        var
          tt      : ttype;
        begin
          while try_to_consume(_COMMA) do
            begin
               id_type(tt,pattern,false);
               if (tt.def.deftype<>objectdef) then
                 begin
                    Message1(type_e_interface_type_expected,tt.def.typename);
                    continue;
                 end;
               handleimplementedinterface(tobjectdef(tt.def));
            end;
        end;

      procedure readinterfaceiid;
        var
          p : tnode;
          valid : boolean;
        begin
          p:=comp_expr(true);
          if p.nodetype=stringconstn then
            begin
              stringdispose(aktclass.iidstr);
              aktclass.iidstr:=stringdup(strpas(tstringconstnode(p).value_str)); { or upper? }
              p.free;
              valid:=string2guid(aktclass.iidstr^,aktclass.iidguid^);
              if (classtype=odt_interfacecom) and not assigned(aktclass.iidguid) and not valid then
                Message(parser_e_improper_guid_syntax);
            end
          else
            begin
              p.free;
              Message(parser_e_illegal_expression);
            end;
        end;


      procedure readparentclasses;
        var
           hp : tobjectdef;
        begin
           hp:=nil;
           { reads the parent class }
           if try_to_consume(_LKLAMMER) then
             begin
                id_type(tt,pattern,false);
                childof:=tobjectdef(tt.def);
                if (not assigned(childof)) or
                   (childof.deftype<>objectdef) then
                 begin
                   if assigned(childof) then
                     Message1(type_e_class_type_expected,childof.typename);
                   childof:=nil;
                   aktclass:=tobjectdef.create(classtype,n,nil);
                 end
                else
                 begin
                   { a mix of class, interfaces, objects and cppclasses
                     isn't allowed }
                   case classtype of
                      odt_class:
                        if not(is_class(childof)) then
                          begin
                             if is_interface(childof) then
                               begin
                                  { we insert the interface after the child
                                    is set, see below
                                  }
                                  hp:=childof;
                                  childof:=class_tobject;
                               end
                             else
                               Message(parser_e_mix_of_classes_and_objects);
                          end;
                      odt_interfacecorba,
                      odt_interfacecom:
                        if not(is_interface(childof)) then
                          Message(parser_e_mix_of_classes_and_objects);
                      odt_cppclass:
                        if not(is_cppclass(childof)) then
                          Message(parser_e_mix_of_classes_and_objects);
                      odt_object:
                        if not(is_object(childof)) then
                          Message(parser_e_mix_of_classes_and_objects);
                   end;
                   { the forward of the child must be resolved to get
                     correct field addresses }
                   if assigned(fd) then
                    begin
                      if (oo_is_forward in childof.objectoptions) then
                       Message1(parser_e_forward_declaration_must_be_resolved,childof.objrealname^);
                      aktclass:=fd;
                      { we must inherit several options !!
                        this was missing !!
                        all is now done in set_parent
                        including symtable datasize setting PM }
                      fd.set_parent(childof);
                    end
                   else
                    aktclass:=tobjectdef.create(classtype,n,childof);
                   if aktclass.objecttype=odt_class then
                     begin
                        if assigned(hp) then
                          handleimplementedinterface(hp);
                        readimplementedinterfaces;
                     end;
                 end;
                consume(_RKLAMMER);
             end
           { if no parent class, then a class get tobject as parent }
           else if classtype in [odt_class,odt_interfacecom] then
             setclassparent
           else
             aktclass:=tobjectdef.create(classtype,n,nil);
           { read GUID }
             if (classtype in [odt_interfacecom,odt_interfacecorba]) and
                try_to_consume(_LECKKLAMMER) then
               begin
                 readinterfaceiid;
                 consume(_RECKKLAMMER);
               end;
        end;

        procedure chkcpp(pd:tprocdef);
        begin
           if is_cppclass(pd._class) then
            begin
              pd.proccalloption:=pocall_cppdecl;
              pd.setmangledname(target_info.Cprefix+pd.cplusplusmangledname);
            end;
        end;

      var
        pd : tprocdef;
      begin
         old_object_option:=current_object_option;

         { forward is resolved }
         if assigned(fd) then
           exclude(fd.objectoptions,oo_is_forward);

         { objects and class types can't be declared local }
         if not(symtablestack.symtabletype in [globalsymtable,staticsymtable]) then
           Message(parser_e_no_local_objects);

         storetypecanbeforward:=typecanbeforward;
         { for tp7 don't allow forward types }
         if (m_tp7 in aktmodeswitches) then
           typecanbeforward:=false;

         if not(readobjecttype) then
           exit;

         { also anonym objects aren't allow (o : object a : longint; end;) }
         if n='' then
           Message(parser_f_no_anonym_objects);

         { read list of parent classes }
         readparentclasses;

         { default access is public }
         there_is_a_destructor:=false;
         current_object_option:=[sp_public];

         { set class flags and inherits published }
         setclassattributes;

         aktobjectdef:=aktclass;
         aktclass.symtable.next:=symtablestack;
         symtablestack:=aktclass.symtable;
         testcurobject:=1;
         curobjectname:=Upper(n);

         { short class declaration ? }
         if (classtype<>odt_class) or (token<>_SEMICOLON) then
          begin
          { Parse componenten }
            repeat
              case token of
                _ID :
                  begin
                    case idtoken of
                      _PRIVATE :
                        begin
                          if is_interface(aktclass) then
                             Message(parser_e_no_access_specifier_in_interfaces);
                           consume(_PRIVATE);
                           current_object_option:=[sp_private];
                           include(aktclass.objectoptions,oo_has_private);
                         end;
                       _PROTECTED :
                         begin
                           if is_interface(aktclass) then
                             Message(parser_e_no_access_specifier_in_interfaces);
                           consume(_PROTECTED);
                           current_object_option:=[sp_protected];
                           include(aktclass.objectoptions,oo_has_protected);
                         end;
                       _PUBLIC :
                         begin
                           if is_interface(aktclass) then
                             Message(parser_e_no_access_specifier_in_interfaces);
                           consume(_PUBLIC);
                           current_object_option:=[sp_public];
                         end;
                       _PUBLISHED :
                         begin
                           { we've to check for a pushlished section in non-  }
                           { publishable classes later, if a real declaration }
                           { this is the way, delphi does it                  }
                           if is_interface(aktclass) then
                             Message(parser_e_no_access_specifier_in_interfaces);
                           consume(_PUBLISHED);
                           current_object_option:=[sp_published];
                         end;
                       else
                         begin
                           if is_interface(aktclass) then
                             Message(parser_e_no_vars_in_interfaces);

                           if (sp_published in current_object_option) and
                             not(oo_can_have_published in aktclass.objectoptions) then
                             Message(parser_e_cant_have_published);

                           read_var_decs(false,true,false);
                         end;
                    end;
                  end;
                _PROPERTY :
                  begin
                    property_dec;
                  end;
                _PROCEDURE,
                _FUNCTION,
                _CLASS :
                  begin
                    if (sp_published in current_object_option) and
                       not(oo_can_have_published in aktclass.objectoptions) then
                      Message(parser_e_cant_have_published);

                    oldparse_only:=parse_only;
                    parse_only:=true;
                    pd:=parse_proc_dec(aktclass);

                    { this is for error recovery as well as forward }
                    { interface mappings, i.e. mapping to a method  }
                    { which isn't declared yet                      }
                    if assigned(pd) then
                     begin
                       parse_object_proc_directives(pd);
                       handle_calling_convention(pd);
                       calc_parast(pd);

                       { add definition to procsym }
                       proc_add_definition(pd);

                       { add procdef options to objectdef options }
                       if (po_msgint in pd.procoptions) then
                        include(aktclass.objectoptions,oo_has_msgint);
                       if (po_msgstr in pd.procoptions) then
                         include(aktclass.objectoptions,oo_has_msgstr);
                       if (po_virtualmethod in pd.procoptions) then
                         include(aktclass.objectoptions,oo_has_virtual);

                       chkcpp(pd);
                     end;

                    parse_only:=oldparse_only;
                  end;
                _CONSTRUCTOR :
                  begin
                    if (sp_published in current_object_option) and
                      not(oo_can_have_published in aktclass.objectoptions) then
                      Message(parser_e_cant_have_published);

                    if not(sp_public in current_object_option) then
                      Message(parser_w_constructor_should_be_public);

                    if is_interface(aktclass) then
                      Message(parser_e_no_con_des_in_interfaces);

                    oldparse_only:=parse_only;
                    parse_only:=true;
                    pd:=constructor_head;
                    parse_object_proc_directives(pd);
                    handle_calling_convention(pd);
                    calc_parast(pd);

                    { add definition to procsym }
                    proc_add_definition(pd);

                    { add procdef options to objectdef options }
                    if (po_virtualmethod in pd.procoptions) then
                      include(aktclass.objectoptions,oo_has_virtual);
                    chkcpp(pd);
                    parse_only:=oldparse_only;
                  end;
                _DESTRUCTOR :
                  begin
                    if (sp_published in current_object_option) and
                      not(oo_can_have_published in aktclass.objectoptions) then
                      Message(parser_e_cant_have_published);

                    if there_is_a_destructor then
                      Message(parser_n_only_one_destructor);

                    if is_interface(aktclass) then
                      Message(parser_e_no_con_des_in_interfaces);

                    if not(sp_public in current_object_option) then
                      Message(parser_w_destructor_should_be_public);

                    there_is_a_destructor:=true;
                    oldparse_only:=parse_only;
                    parse_only:=true;
                    pd:=destructor_head;
                    parse_object_proc_directives(pd);
                    handle_calling_convention(pd);
                    calc_parast(pd);

                    { add definition to procsym }
                    proc_add_definition(pd);

                    { add procdef options to objectdef options }
                    if (po_virtualmethod in pd.procoptions) then
                      include(aktclass.objectoptions,oo_has_virtual);

                    chkcpp(pd);

                    parse_only:=oldparse_only;
                  end;
                _END :
                  begin
                    consume(_END);
                    break;
                  end;
                else
                  consume(_ID); { Give a ident expected message, like tp7 }
              end;
            until false;
          end;

         { generate vmt space if needed }
         if not(oo_has_vmt in aktclass.objectoptions) and
            (([oo_has_virtual,oo_has_constructor,oo_has_destructor]*aktclass.objectoptions<>[]) or
             (classtype in [odt_class])
            ) then
           aktclass.insertvmt;

         if is_interface(aktclass) then
           setinterfacemethodoptions;

         { reset }
         testcurobject:=0;
         curobjectname:='';
         typecanbeforward:=storetypecanbeforward;
         { restore old state }
         symtablestack:=symtablestack.next;
         aktobjectdef:=nil;
         current_object_option:=old_object_option;

         object_dec:=aktclass;
      end;

end.
{
  $Log$
  Revision 1.77  2004-06-16 20:07:09  florian
    * dwarf branch merged

  Revision 1.76.2.1  2004/04/28 19:55:52  peter
    * new warning for ordinal-pointer when size is different
    * fixed some cg_e_ messages to the correct section type_e_ or parser_e_

  Revision 1.76  2004/02/26 16:13:25  peter
    * fix crash when method is not declared in object declaration
    * fix parsing of mapped interface functions

  Revision 1.75  2003/12/10 16:37:01  peter
    * global property support for fpc modes

  Revision 1.74  2003/12/04 23:27:49  peter
    * missing handle_calling_convention()

  Revision 1.73  2003/11/10 18:06:25  florian
    + published single properties can have a default value now

  Revision 1.72  2003/10/30 16:23:13  peter
    * don't search for overloads in parents for constructors

  Revision 1.71  2003/10/22 15:22:33  peter
    * fixed unitsym-globalsymtable relation so the uses of a unit
      is counted correctly

  Revision 1.70  2003/10/21 18:16:13  peter
    * IncompatibleTypes() added that will include unit names when
      the typenames are the same

  Revision 1.69  2003/10/07 16:06:30  peter
    * tsymlist.def renamed to tsymlist.procdef
    * tsymlist.procdef is now only used to store the procdef

  Revision 1.68  2003/10/02 21:15:12  peter
    * support nil as default value
    * when no default property is allowed don't check default value

  Revision 1.67  2003/06/13 21:19:30  peter
    * current_procdef removed, use current_procinfo.procdef instead

  Revision 1.66  2003/05/23 14:27:35  peter
    * remove some unit dependencies
    * current_procinfo changes to store more info

  Revision 1.65  2003/05/09 17:47:02  peter
    * self moved to hidden parameter
    * removed hdisposen,hnewn,selfn

  Revision 1.64  2003/05/05 14:53:16  peter
    * vs_hidden replaced by is_hidden boolean

  Revision 1.63  2003/04/27 11:21:33  peter
    * aktprocdef renamed to current_procinfo.procdef
    * procinfo renamed to current_procinfo
    * procinfo will now be stored in current_module so it can be
      cleaned up properly
    * gen_main_procsym changed to create_main_proc and release_main_proc
      to also generate a tprocinfo structure
    * fixed unit implicit initfinal

  Revision 1.62  2003/04/27 07:29:50  peter
    * current_procinfo.procdef cleanup, current_procdef is now always nil when parsing
      a new procdef declaration
    * aktprocsym removed
    * lexlevel removed, use symtable.symtablelevel instead
    * implicit init/final code uses the normal genentry/genexit
    * funcret state checking updated for new funcret handling

  Revision 1.61  2003/04/26 00:32:37  peter
    * start search for overriden properties in the parent class

  Revision 1.60  2003/04/25 20:59:33  peter
    * removed funcretn,funcretsym, function result is now in varsym
      and aliases for result and function name are added using absolutesym
    * vs_hidden parameter for funcret passed in parameter
    * vs_hidden fixes
    * writenode changed to printnode and released from extdebug
    * -vp option added to generate a tree.log with the nodetree
    * nicer printnode for statements, callnode

  Revision 1.59  2003/04/10 17:57:52  peter
    * vs_hidden released

  Revision 1.58  2003/01/09 21:52:37  peter
    * merged some verbosity options.
    * V_LineInfo is a verbosity flag to include line info

  Revision 1.57  2002/11/25 17:43:21  peter
    * splitted defbase in defutil,symutil,defcmp
    * merged isconvertable and is_equal into compare_defs(_ext)
    * made operator search faster by walking the list only once

  Revision 1.56  2002/11/17 16:31:56  carl
    * memory optimization (3-4%) : cleanup of tai fields,
       cleanup of tdef and tsym fields.
    * make it work for m68k

  Revision 1.55  2002/10/05 12:43:25  carl
    * fixes for Delphi 6 compilation
     (warning : Some features do not work under Delphi)

  Revision 1.54  2002/10/02 18:20:20  peter
    * don't allow interface without m_class mode

  Revision 1.53  2002/09/27 21:13:28  carl
    * low-highval always checked if limit ober 2GB is reached (to avoid overflow)

  Revision 1.52  2002/09/16 14:11:13  peter
    * add argument to equal_paras() to support default values or not

  Revision 1.51  2002/09/09 17:34:15  peter
    * tdicationary.replace added to replace and item in a dictionary. This
      is only allowed for the same name
    * varsyms are inserted in symtable before the types are parsed. This
      fixes the long standing "var longint : longint" bug
    - consume_idlist and idstringlist removed. The loops are inserted
      at the callers place and uses the symtable for duplicate id checking

  Revision 1.50  2002/09/03 16:26:26  daniel
    * Make Tprocdef.defs protected

  Revision 1.49  2002/08/17 09:23:38  florian
    * first part of procinfo rewrite

  Revision 1.48  2002/08/09 07:33:02  florian
    * a couple of interface related fixes

  Revision 1.47  2002/07/20 11:57:55  florian
    * types.pas renamed to defbase.pas because D6 contains a types
      unit so this would conflicts if D6 programms are compiled
    + Willamette/SSE2 instructions to assembler added

  Revision 1.46  2002/07/01 16:23:53  peter
    * cg64 patch
    * basics for currency
    * asnode updates for class and interface (not finished)

  Revision 1.45  2002/05/18 13:34:12  peter
    * readded missing revisions

  Revision 1.44  2002/05/16 19:46:42  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.42  2002/05/12 16:53:08  peter
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

  Revision 1.41  2002/04/21 19:02:04  peter
    * removed newn and disposen nodes, the code is now directly
      inlined from pexpr
    * -an option that will write the secondpass nodes to the .s file, this
      requires EXTDEBUG define to actually write the info
    * fixed various internal errors and crashes due recent code changes

  Revision 1.40  2002/04/19 15:46:02  peter
    * mangledname rewrite, tprocdef.mangledname is now created dynamicly
      in most cases and not written to the ppu
    * add mangeledname_prefix() routine to generate the prefix of
      manglednames depending on the current procedure, object and module
    * removed static procprefix since the mangledname is now build only
      on demand from tprocdef.mangledname

  Revision 1.39  2002/04/04 19:06:00  peter
    * removed unused units
    * use tlocation.size in cg.a_*loc*() routines

  Revision 1.38  2002/01/25 17:38:19  peter
    * fixed default value for properties with index values

  Revision 1.37  2002/01/24 18:25:48  peter
   * implicit result variable generation for assembler routines
   * removed m_tp modeswitch, use m_tp7 or not(m_fpc) instead

  Revision 1.36  2002/01/06 12:08:15  peter
    * removed uauto from orddef, use new range_to_basetype generating
      the correct ordinal type for a range

}
