{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    Parses variable declarations. Used for var statement and record
    definitions

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
unit pdecvar;

{$i fpcdefs.inc}

interface

    procedure read_var_decs(is_record,is_object,is_threadvar:boolean);


implementation

    uses
       { common }
       cutils,
       { global }
       globtype,globals,tokens,verbose,
       systems,
       { symtable }
       symconst,symbase,symtype,symdef,symsym,symtable,defbase,fmodule,
       { pass 1 }
       node,
       nmat,nadd,ncal,nset,ncnv,ninl,ncon,nld,nflw,
       { parser }
       scanner,
       pbase,pexpr,ptype,ptconst,pdecsub,
       { link }
       import;

    const
       variantrecordlevel : longint = 0;

    procedure read_var_decs(is_record,is_object,is_threadvar:boolean);
    { reads the filed of a record into a        }
    { symtablestack, if record=false        }
    { variants are forbidden, so this procedure }
    { can be used to read object fields  }
    { if absolute is true, ABSOLUTE and file    }
    { types are allowed                  }
    { => the procedure is also used to read     }
    { a sequence of variable declaration        }

      procedure insert_syms(st : tsymtable;sc : tidstringlist;tt : ttype;is_threadvar : boolean);
      { inserts the symbols of sc in st with def as definition or sym as ttypesym, sc is disposed }
        var
           s : string;
           filepos : tfileposinfo;
           ss : tvarsym;
        begin
           filepos:=akttokenpos;
           while not sc.empty do
             begin
                s:=sc.get(akttokenpos);
                ss:=tvarsym.Create(s,tt);
                if is_threadvar then
                  include(ss.varoptions,vo_is_thread_var);
                st.insert(ss);
                { static data fields are inserted in the globalsymtable }
                if (st.symtabletype=objectsymtable) and
                   (sp_static in current_object_option) then
                  begin
                     s:='$'+lower(st.name^)+'_'+upper(s);
                     st.defowner.owner.insert(tvarsym.create(s,tt));
                  end;
             end;
{$ifdef fixLeaksOnError}
             if strContStack.pop <> sc then
               writeln('problem with strContStack in pdecl (2)');
{$endif fixLeaksOnError}
           sc.free;
           akttokenpos:=filepos;
        end;

      var
         sc : tidstringList;
         s : stringid;
         old_block_type : tblock_type;
         declarepos,storetokenpos : tfileposinfo;
         oldsymtablestack : tsymtable;
         symdone : boolean;
         { to handle absolute }
         abssym : tabsolutesym;
         { c var }
         newtype : ttypesym;
         is_dll,
         is_gpc_name,is_cdecl,
         extern_aktvarsym,export_aktvarsym : boolean;
         old_current_object_option : tsymoptions;
         dll_name,
         C_name : string;
         tt,casetype : ttype;
         { Delphi initialized vars }
         tconstsym : ttypedconstsym;
         { maxsize contains the max. size of a variant }
         { startvarrec contains the start of the variant part of a record }
         usedalign,
         maxsize,minalignment,maxalignment,startvarrecalign,startvarrecsize : longint;
         pt : tnode;
         srsym : tsym;
         srsymtable : tsymtable;
         unionsymtable : tsymtable;
         offset : longint;
         uniondef : trecorddef;
         unionsym : tvarsym;
         uniontype : ttype;
         dummysymoptions : tsymoptions;
      begin
         old_current_object_option:=current_object_option;
         { all variables are public if not in a object declaration }
         if not is_object then
          current_object_option:=[sp_public];
         old_block_type:=block_type;
         block_type:=bt_type;
         is_gpc_name:=false;
         { Force an expected ID error message }
         if not (token in [_ID,_CASE,_END]) then
          consume(_ID);
         { read vars }
         while (token=_ID) and
               not(is_object and (idtoken in [_PUBLIC,_PRIVATE,_PUBLISHED,_PROTECTED])) do
           begin
             C_name:=orgpattern;
             sc:=consume_idlist;
{$ifdef fixLeaksOnError}
             strContStack.push(sc);
{$endif fixLeaksOnError}
             consume(_COLON);
             if (m_gpc in aktmodeswitches) and
                not(is_record or is_object or is_threadvar) and
                (token=_ID) and (orgpattern='__asmname__') then
               begin
                 consume(_ID);
                 C_name:=get_stringconst;
                 Is_gpc_name:=true;
               end;
             { this is needed for Delphi mode at least
               but should be OK for all modes !! (PM) }
             ignore_equal:=true;
             if is_record then
              begin
                { for records, don't search the recordsymtable for
                  the symbols of the types }
                oldsymtablestack:=symtablestack;
                symtablestack:=symtablestack.next;
                read_type(tt,'');
                symtablestack:=oldsymtablestack;
              end
             else
              read_type(tt,'');
             { types that use init/final are not allowed in variant parts, but
               classes are allowed }
             if (variantrecordlevel>0) and
                (tt.def.needs_inittable and not is_class(tt.def)) then
               Message(parser_e_cant_use_inittable_here);
             ignore_equal:=false;
             symdone:=false;
             if is_gpc_name then
               begin
                  storetokenpos:=akttokenpos;
                  s:=sc.get(akttokenpos);
                  if not sc.empty then
                   Message(parser_e_absolute_only_one_var);
{$ifdef fixLeaksOnError}
                   if strContStack.pop <> sc then
                     writeln('problem with strContStack in pdecl (3)');
{$endif fixLeaksOnError}
                  sc.free;
                  aktvarsym:=tvarsym.create_C(s,target_info.Cprefix+C_name,tt);
                  include(aktvarsym.varoptions,vo_is_external);
                  symtablestack.insert(aktvarsym);
                  akttokenpos:=storetokenpos;
                  symdone:=true;
               end;
             { check for absolute }
             if not symdone and
                (idtoken=_ABSOLUTE) and not(is_record or is_object or is_threadvar) then
              begin
                consume(_ABSOLUTE);
                { only allowed for one var }
                s:=sc.get(declarepos);
                if not sc.empty then
                 Message(parser_e_absolute_only_one_var);
{$ifdef fixLeaksOnError}
                 if strContStack.pop <> sc then
                   writeln('problem with strContStack in pdecl (4)');
{$endif fixLeaksOnError}
                sc.free;
                { parse the rest }
                pt:=expr;
                if (pt.nodetype=stringconstn) or (is_constcharnode(pt)) then
                 begin
                   storetokenpos:=akttokenpos;
                   akttokenpos:=declarepos;
                   abssym:=tabsolutesym.create(s,tt);
                   if pt.nodetype=stringconstn then
                     s:=strpas(tstringconstnode(pt).value_str)
                   else
                     s:=chr(tordconstnode(pt).value);
                   consume(token);
                   abssym.abstyp:=toasm;
                   abssym.asmname:=stringdup(s);
                   symtablestack.insert(abssym);
                   akttokenpos:=storetokenpos;
                   symdone:=true;
                 end;
                if not symdone then
                 begin
                   { variable }
                   if (pt.nodetype=loadn) then
                    begin
                      { we should check the result type of srsym }
                      if not (tloadnode(pt).symtableentry.typ in [varsym,typedconstsym,funcretsym]) then
                        Message(parser_e_absolute_only_to_var_or_const);
                      storetokenpos:=akttokenpos;
                      akttokenpos:=declarepos;
                      abssym:=tabsolutesym.create(s,tt);
                      abssym.abstyp:=tovar;
                      abssym.ref:=tstoredsym(tloadnode(pt).symtableentry);
                      symtablestack.insert(abssym);
                      akttokenpos:=storetokenpos;
                      symdone:=true;
                    end
                   { funcret }
                   else if (pt.nodetype=funcretn) then
                    begin
                      storetokenpos:=akttokenpos;
                      akttokenpos:=declarepos;
                      abssym:=tabsolutesym.create(s,tt);
                      abssym.abstyp:=tovar;
                      abssym.ref:=tstoredsym(tfuncretnode(pt).funcretsym);
                      symtablestack.insert(abssym);
                      akttokenpos:=storetokenpos;
                      symdone:=true;
                    end;
                   { address }
                   if (not symdone) then
                    begin
                      if is_constintnode(pt) and
                         ((target_info.system=system_i386_go32v2) or
                          (m_objfpc in aktmodeswitches) or
                          (m_delphi in aktmodeswitches)) then
                       begin
                         storetokenpos:=akttokenpos;
                         akttokenpos:=declarepos;
                         abssym:=tabsolutesym.create(s,tt);
                         abssym.abstyp:=toaddr;
                         abssym.absseg:=false;
                         abssym.address:=tordconstnode(pt).value;
                         if (token=_COLON) and
                            (target_info.system=system_i386_go32v2) then
                          begin
                            consume(token);
                            pt.free;
                            pt:=expr;
                            if is_constintnode(pt) then
                              begin
                                abssym.address:=abssym.address shl 4+tordconstnode(pt).value;
                                abssym.absseg:=true;
                              end
                            else
                               Message(parser_e_absolute_only_to_var_or_const);
                          end;
                         symtablestack.insert(abssym);
                         akttokenpos:=storetokenpos;
                         symdone := true;
                       end
                      else
                       Message(parser_e_absolute_only_to_var_or_const);
                    end
                 end
                else
                  Message(parser_e_absolute_only_to_var_or_const);
                if not symdone then
                  begin
                    tt := generrortype;
                    symtablestack.insert(tvarsym.create(s,tt));
                    symdone:=true;
                  end;
                pt.free;
              end;
             { Handling of Delphi typed const = initialized vars ! }
             { When should this be rejected ?
               - in parasymtable
               - in record or object
               - ... (PM) }
             if (token=_EQUAL) and
                not(m_tp7 in aktmodeswitches) and
                not(symtablestack.symtabletype in [parasymtable]) and
                not is_record and
                not is_object then
               begin
                  storetokenpos:=akttokenpos;
                  s:=sc.get(akttokenpos);
                  if not sc.empty then
                    Message(parser_e_initialized_only_one_var);
                  tconstsym:=ttypedconstsym.createtype(s,tt,true);
                  symtablestack.insert(tconstsym);
                  akttokenpos:=storetokenpos;
                  consume(_EQUAL);
                  readtypedconst(tt,tconstsym,true);
                  symdone:=true;
               end;
             { hint directive }
             {$warning hintdirective not stored in syms}
             dummysymoptions:=[];
             try_consume_hintdirective(dummysymoptions);
             { for a record there doesn't need to be a ; before the END or ) }
             if not((is_record or is_object) and (token in [_END,_RKLAMMER])) then
               consume(_SEMICOLON);
             { procvar handling }
             if (tt.def.deftype=procvardef) and (tt.def.typesym=nil) then
               begin
                  newtype:=ttypesym.create('unnamed',tt);
                  parse_var_proc_directives(tsym(newtype));
                  newtype.restype.def:=nil;
                  tt.def.typesym:=nil;
                  newtype.free;
               end;
             { Check for variable directives }
             if not symdone and (token=_ID) then
              begin
                { Check for C Variable declarations }
                if (m_cvar_support in aktmodeswitches) and
                   not(is_record or is_object or is_threadvar) and
                   (idtoken in [_EXPORT,_EXTERNAL,_PUBLIC,_CVAR]) then
                 begin
                   { only allowed for one var }
                   s:=sc.get(declarepos);
                   if not sc.empty then
                    Message(parser_e_absolute_only_one_var);
{$ifdef fixLeaksOnError}
                   if strContStack.pop <> sc then
                     writeln('problem with strContStack in pdecl (5)');
{$endif fixLeaksOnError}
                   sc.free;
                   { defaults }
                   is_dll:=false;
                   is_cdecl:=false;
                   extern_aktvarsym:=false;
                   export_aktvarsym:=false;
                   { cdecl }
                   if idtoken=_CVAR then
                    begin
                      consume(_CVAR);
                      consume(_SEMICOLON);
                      is_cdecl:=true;
                      C_name:=target_info.Cprefix+C_name;
                    end;
                   { external }
                   if idtoken=_EXTERNAL then
                    begin
                      consume(_EXTERNAL);
                      extern_aktvarsym:=true;
                    end;
                   { export }
                   if idtoken in [_EXPORT,_PUBLIC] then
                    begin
                      consume(_ID);
                      if extern_aktvarsym or
                         (symtablestack.symtabletype in [parasymtable,localsymtable]) then
                       Message(parser_e_not_external_and_export)
                      else
                       export_aktvarsym:=true;
                    end;
                   { external and export need a name after when no cdecl is used }
                   if not is_cdecl then
                    begin
                      { dll name ? }
                      if (extern_aktvarsym) and (idtoken<>_NAME) then
                       begin
                         is_dll:=true;
                         dll_name:=get_stringconst;
                       end;
                      consume(_NAME);
                      C_name:=get_stringconst;
                    end;
                   { consume the ; when export or external is used }
                   if extern_aktvarsym or export_aktvarsym then
                    consume(_SEMICOLON);
                   { insert in the symtable }
                   storetokenpos:=akttokenpos;
                   akttokenpos:=declarepos;
                   if is_dll then
                    aktvarsym:=tvarsym.create_dll(s,tt)
                   else
                    aktvarsym:=tvarsym.create_C(s,C_name,tt);
                   { set some vars options }
                   if export_aktvarsym then
                    begin
                      inc(aktvarsym.refs);
                      include(aktvarsym.varoptions,vo_is_exported);
                    end;
                   if extern_aktvarsym then
                    include(aktvarsym.varoptions,vo_is_external);
                   { insert in the stack/datasegment }
                   symtablestack.insert(aktvarsym);
                   akttokenpos:=storetokenpos;
                   { now we can insert it in the import lib if its a dll, or
                     add it to the externals }
                   if extern_aktvarsym then
                    begin
                      if is_dll then
                       begin
                         if not(current_module.uses_imports) then
                          begin
                            current_module.uses_imports:=true;
                            importlib.preparelib(current_module.modulename^);
                          end;
                         importlib.importvariable(aktvarsym.mangledname,dll_name,C_name)
                       end
                      else
                       if target_info.DllScanSupported then
                        current_module.Externals.insert(tExternalsItem.create(aktvarsym.mangledname));
                    end;
                   symdone:=true;
                 end
                else
                 if (is_object) and (cs_static_keyword in aktmoduleswitches) and (idtoken=_STATIC) then
                  begin
                    include(current_object_option,sp_static);
                    insert_syms(symtablestack,sc,tt,false);
                    exclude(current_object_option,sp_static);
                    consume(_STATIC);
                    consume(_SEMICOLON);
                    symdone:=true;
                  end;
              end;
             { insert it in the symtable, if not done yet }
             if not symdone then
               begin
                  { save object option, because we can turn of the sp_published }
                  if (sp_published in current_object_option) and
                    not(is_class(tt.def)) then
                   begin
                     Message(parser_e_cant_publish_that);
                     exclude(current_object_option,sp_published);
                   end
                  else
                   if (sp_published in current_object_option) and
                      not(oo_can_have_published in tobjectdef(tt.def).objectoptions) then
                    begin
                      Message(parser_e_only_publishable_classes_can__be_published);
                      exclude(current_object_option,sp_published);
                    end;
                  insert_syms(symtablestack,sc,tt,is_threadvar);
                  current_object_option:=old_current_object_option;
               end;
           end;
         { Check for Case }
         if is_record and (token=_CASE) then
           begin
              maxsize:=0;
              maxalignment:=0;
              consume(_CASE);
              s:=pattern;
              searchsym(s,srsym,srsymtable);
              { may be only a type: }
              if assigned(srsym) and (srsym.typ in [typesym,unitsym]) then
               begin
                 { for records, don't search the recordsymtable for
                   the symbols of the types }
                 oldsymtablestack:=symtablestack;
                 symtablestack:=symtablestack.next;
                 read_type(casetype,'');
                 symtablestack:=oldsymtablestack;
               end
              else
                begin
                  consume(_ID);
                  consume(_COLON);
                  { for records, don't search the recordsymtable for
                    the symbols of the types }
                  oldsymtablestack:=symtablestack;
                  symtablestack:=symtablestack.next;
                  read_type(casetype,'');
                  symtablestack:=oldsymtablestack;
                  symtablestack.insert(tvarsym.create(s,casetype));
                end;
              if not(is_ordinal(casetype.def)) or is_64bitint(casetype.def)  then
               Message(type_e_ordinal_expr_expected);
              consume(_OF);
              UnionSymtable:=trecordsymtable.create;
              Unionsymtable.next:=symtablestack;
              registerdef:=false;
              UnionDef:=trecorddef.create(unionsymtable);
              registerdef:=true;
              symtablestack:=UnionSymtable;
              startvarrecsize:=symtablestack.datasize;
              startvarrecalign:=symtablestack.dataalignment;
              repeat
                repeat
                  pt:=comp_expr(true);
                  if not(pt.nodetype=ordconstn) then
                    Message(cg_e_illegal_expression);
                  pt.free;
                  if token=_COMMA then
                   consume(_COMMA)
                  else
                   break;
                until false;
                consume(_COLON);
                { read the vars }
                consume(_LKLAMMER);
                inc(variantrecordlevel);
                if token<>_RKLAMMER then
                  read_var_decs(true,false,false);
                dec(variantrecordlevel);
                consume(_RKLAMMER);
                { calculates maximal variant size }
                maxsize:=max(maxsize,symtablestack.datasize);
                maxalignment:=max(maxalignment,symtablestack.dataalignment);
                { the items of the next variant are overlayed }
                symtablestack.datasize:=startvarrecsize;
                symtablestack.dataalignment:=startvarrecalign;
                if (token<>_END) and (token<>_RKLAMMER) then
                  consume(_SEMICOLON)
                else
                  break;
              until (token=_END) or (token=_RKLAMMER);
              { at last set the record size to that of the biggest variant }
              symtablestack.datasize:=maxsize;
              symtablestack.dataalignment:=maxalignment;
              uniontype.def:=uniondef;
              uniontype.sym:=nil;
              UnionSym:=tvarsym.create('case',uniontype);
              symtablestack:=symtablestack.next;
              { we do NOT call symtablestack.insert
               on purpose PM }
              if aktalignment.recordalignmax=-1 then
               begin
{$ifdef i386}
                 if maxalignment>2 then
                  minalignment:=4
                 else if maxalignment>1 then
                  minalignment:=2
                 else
                  minalignment:=1;
{$else}
{$ifdef m68k}
                 minalignment:=2;
{$endif}
                 minalignment:=1;
{$endif}
               end
              else
               minalignment:=maxalignment;
              usedalign:=used_align(maxalignment,minalignment,maxalignment);
              offset:=align(symtablestack.datasize,usedalign);
              symtablestack.datasize:=offset+unionsymtable.datasize;
              if maxalignment>symtablestack.dataalignment then
                symtablestack.dataalignment:=maxalignment;
              trecordsymtable(Unionsymtable).Insert_in(symtablestack,offset);
              Unionsym.owner:=nil;
              unionsym.free;
              uniondef.free;
           end;
         block_type:=old_block_type;
         current_object_option:=old_current_object_option;
      end;

end.
{
  $Log$
  Revision 1.29  2002-07-26 21:15:40  florian
    * rewrote the system handling

  Revision 1.28  2002/07/20 11:57:55  florian
    * types.pas renamed to defbase.pas because D6 contains a types
      unit so this would conflicts if D6 programms are compiled
    + Willamette/SSE2 instructions to assembler added

  Revision 1.27  2002/06/10 13:41:26  jonas
    * fixed bug 1985

  Revision 1.26  2002/05/18 13:34:12  peter
    * readded missing revisions

  Revision 1.25  2002/05/16 19:46:43  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.23  2002/04/21 18:57:24  peter
    * fixed memleaks when file can't be opened

}
