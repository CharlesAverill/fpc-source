{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    Does parsing types for Free Pascal

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
unit ptype;

{$i fpcdefs.inc}

interface

    uses
       globtype,symtype;

    const
       { forward types should only be possible inside a TYPE statement }
       typecanbeforward : boolean = false;

    var
       { hack, which allows to use the current parsed }
       { object type as function argument type  }
       testcurobject : byte;
       curobjectname : stringid;

    { reads a string, file type or a type id and returns a name and }
    { tdef }
    procedure single_type(var tt:ttype;var s : string;isforwarddef:boolean);

    procedure read_type(var tt:ttype;const name : stringid;parseprocvardir:boolean);

    { reads a type definition }
    { to a appropriating tdef, s gets the name of   }
    { the type to allow name mangling          }
    procedure id_type(var tt : ttype;var s : string;isforwarddef:boolean);


implementation

    uses
       { common }
       cutils,
       { global }
       globals,tokens,verbose,
       systems,
       { target }
       paramgr,
       { symtable }
       symconst,symbase,symdef,symsym,symtable,
       defutil,defcmp,
       { pass 1 }
       node,
       nmat,nadd,ncal,nset,ncnv,ninl,ncon,nld,nflw,
       { parser }
       scanner,
       pbase,pexpr,pdecsub,pdecvar,pdecobj;


    procedure id_type(var tt : ttype;var s : string;isforwarddef:boolean);
    { reads a type definition }
    { to a appropriating tdef, s gets the name of   }
    { the type to allow name mangling          }
      var
        is_unit_specific : boolean;
        pos : tfileposinfo;
        srsym : tsym;
        srsymtable : tsymtable;
        sorg : stringid;
      begin
         s:=pattern;
         sorg:=orgpattern;
         pos:=akttokenpos;
         { classes can be used also in classes }
         if (curobjectname=pattern) and is_class_or_interface(aktobjectdef) then
           begin
              tt.setdef(aktobjectdef);
              consume(_ID);
              exit;
           end;
         { objects can be parameters }
         if (testcurobject=2) and (curobjectname=pattern) then
           begin
              tt.setdef(aktobjectdef);
              consume(_ID);
              exit;
           end;
         { try to load the symbol to see if it's a unitsym. Use the
           special searchsym_type that ignores records,objects and
           parameters }
         is_unit_specific:=false;
         searchsym_type(s,srsym,srsymtable);
         consume(_ID);
         if assigned(srsym) and
            (srsym.typ=unitsym) then
           begin
              is_unit_specific:=true;
              consume(_POINT);
              if srsym.owner.unitid=0 then
               begin
                 srsym:=searchsymonlyin(tunitsym(srsym).unitsymtable,pattern);
                 pos:=akttokenpos;
                 s:=pattern;
               end
              else
               srsym:=nil;
              consume(_ID);
           end;
         { Types are first defined with an error def before assigning
           the real type so check if it's an errordef. if so then
           give an error. Only check for typesyms in the current symbol
           table as forwarddef are not resolved directly }
         if assigned(srsym) and
            (srsym.typ=typesym) and
            (srsym.owner=symtablestack) and
            (ttypesym(srsym).restype.def.deftype=errordef) then
          begin
            Message1(type_e_type_is_not_completly_defined,ttypesym(srsym).realname);
            tt:=generrortype;
            exit;
          end;
         { are we parsing a possible forward def ? }
         if isforwarddef and
            not(is_unit_specific) then
          begin
            tt.setdef(tforwarddef.create(s,pos));
            exit;
          end;
         { unknown sym ? }
         if not assigned(srsym) then
          begin
            Message1(sym_e_id_not_found,sorg);
            tt:=generrortype;
            exit;
          end;
         { type sym ? }
         if (srsym.typ<>typesym) then
          begin
            Message(type_e_type_id_expected);
            tt:=generrortype;
            exit;
          end;
         { Give an error when referring to an errordef }
         if (ttypesym(srsym).restype.def.deftype=errordef) then
          begin
            Message(sym_e_error_in_type_def);
            tt:=generrortype;
            exit;
          end;
         { Use the definitions for current unit, because
           they can be refered from the parameters and symbols are not
           loaded at that time. Only write the definition when the
           symbol is the real owner of the definition (not a redefine) }
         if (ttypesym(srsym).owner.unitid=0) and
            ((ttypesym(srsym).restype.def.typesym=nil) or
             (srsym=ttypesym(srsym).restype.def.typesym)) then
          tt.setdef(ttypesym(srsym).restype.def)
         else
          tt.setsym(srsym);
      end;


    procedure single_type(var tt:ttype;var s : string;isforwarddef:boolean);
    { reads a string, file type or a type id and returns a name and }
    { tdef                                                        }
       var
          hs : string;
          t2 : ttype;
       begin
          case token of
            _STRING:
                begin
                   string_dec(tt);
                   s:='STRING';
                end;
            _FILE:
                begin
                   consume(_FILE);
                   if token=_OF then
                     begin
                        consume(_OF);
                        single_type(t2,hs,false);
                        tt.setdef(tfiledef.createtyped(t2));
                        s:='FILE$OF$'+hs;
                     end
                   else
                     begin
                        tt:=cfiletype;
                        s:='FILE';
                     end;
                end;
            _ID:
              begin
                id_type(tt,s,isforwarddef);
              end;
            else
              begin
                message(type_e_type_id_expected);
                s:='<unknown>';
                tt:=generrortype;
              end;
         end;
      end;

    { reads a record declaration }
    function record_dec : tdef;

      var
         symtable : tsymtable;
         storetypecanbeforward : boolean;
         old_object_option : tsymoptions;
      begin
         { create recdef }
         symtable:=trecordsymtable.create(aktpackrecords);
         record_dec:=trecorddef.create(symtable);
         { update symtable stack }
         symtable.next:=symtablestack;
         symtablestack:=symtable;
         { parse record }
         consume(_RECORD);
         old_object_option:=current_object_option;
         current_object_option:=[sp_public];
         storetypecanbeforward:=typecanbeforward;
         { for tp7 don't allow forward types }
         if m_tp7 in aktmodeswitches then
           typecanbeforward:=false;
         read_var_decs(true,false,false);
         consume(_END);
         typecanbeforward:=storetypecanbeforward;
         current_object_option:=old_object_option;
         { make the record size aligned }
         trecordsymtable(symtablestack).addalignmentpadding;
         { restore symtable stack }
         symtablestack:=symtable.next;
      end;


    { reads a type definition and returns a pointer to it }
    procedure read_type(var tt : ttype;const name : stringid;parseprocvardir:boolean);
      var
        pt : tnode;
        tt2 : ttype;
        aktenumdef : tenumdef;
        ap : tarraydef;
        s : stringid;
        l,v : TConstExprInt;
        oldaktpackrecords : longint;
        hs : string;
        defpos,storepos : tfileposinfo;

        procedure expr_type;
        var
           pt1,pt2 : tnode;
           lv,hv   : TConstExprInt;
        begin
           { use of current parsed object ? }
           if (token=_ID) and (testcurobject=2) and (curobjectname=pattern) then
             begin
                consume(_ID);
                tt.setdef(aktobjectdef);
                exit;
             end;
           { classes can be used also in classes }
           if (curobjectname=pattern) and is_class_or_interface(aktobjectdef) then
             begin
                tt.setdef(aktobjectdef);
                consume(_ID);
                exit;
             end;
           { we can't accept a equal in type }
           pt1:=comp_expr(not(ignore_equal));
           if (token=_POINTPOINT) then
             begin
               consume(_POINTPOINT);
               { get high value of range }
               pt2:=comp_expr(not(ignore_equal));
               { make both the same type or give an error. This is not
                 done when both are integer values, because typecasting
                 between -3200..3200 will result in a signed-unsigned
                 conflict and give a range check error (PFV) }
               if not(is_integer(pt1.resulttype.def) and is_integer(pt2.resulttype.def)) then
                 inserttypeconv(pt1,pt2.resulttype);
               { both must be evaluated to constants now }
               if (pt1.nodetype=ordconstn) and
                  (pt2.nodetype=ordconstn) then
                 begin
                   lv:=tordconstnode(pt1).value;
                   hv:=tordconstnode(pt2).value;
                   { Check bounds }
                   if hv<lv then
                     Message(parser_e_upper_lower_than_lower)
                   else
                     begin
                       { All checks passed, create the new def }
                       case pt1.resulttype.def.deftype of
                         enumdef :
                           tt.setdef(tenumdef.create_subrange(tenumdef(pt1.resulttype.def),lv,hv));
                         orddef :
                           begin
                             if is_char(pt1.resulttype.def) then
                               tt.setdef(torddef.create(uchar,lv,hv))
                             else
                               if is_boolean(pt1.resulttype.def) then
                                 tt.setdef(torddef.create(bool8bit,l,hv))
                               else
                                 tt.setdef(torddef.create(range_to_basetype(lv,hv),lv,hv));
                           end;
                       end;
                     end;
                 end
               else
                 Message(sym_e_error_in_type_def);
               pt2.free;
             end
           else
             begin
               { a simple type renaming }
               if (pt1.nodetype=typen) then
                 tt:=ttypenode(pt1).resulttype
               else
                 Message(sym_e_error_in_type_def);
             end;
           pt1.free;
        end;

        procedure array_dec;
        var
          lowval,
          highval   : longint;
          arraytype : ttype;
          ht        : ttype;

          procedure setdefdecl(const t:ttype);
          begin
            case t.def.deftype of
              enumdef :
                begin
                  lowval:=tenumdef(t.def).min;
                  highval:=tenumdef(t.def).max;
                  if tenumdef(t.def).has_jumps then
                   Message(type_e_array_index_enums_with_assign_not_possible);
                  arraytype:=t;
                end;
              orddef :
                begin
                  if torddef(t.def).typ in [uchar,
                    u8bit,u16bit,
                    s8bit,s16bit,s32bit,
                    bool8bit,bool16bit,bool32bit,
                    uwidechar] then
                    begin
                       lowval:=torddef(t.def).low;
                       highval:=torddef(t.def).high;
                       arraytype:=t;
                    end
                  else
                    Message1(parser_e_type_cant_be_used_in_array_index,t.def.gettypename);
                end;
              else
                Message(sym_e_error_in_type_def);
            end;
          end;

        begin
           consume(_ARRAY);
           { open array? }
           if token=_LECKKLAMMER then
             begin
                consume(_LECKKLAMMER);
                { defaults }
                arraytype:=generrortype;
                lowval:=longint($80000000);
                highval:=$7fffffff;
                tt.reset;
                repeat
                  { read the expression and check it, check apart if the
                    declaration is an enum declaration because that needs to
                    be parsed by readtype (PFV) }
                  if token=_LKLAMMER then
                   begin
                     read_type(ht,'',true);
                     setdefdecl(ht);
                   end
                  else
                   begin
                     pt:=expr;
                     if pt.nodetype=typen then
                      setdefdecl(pt.resulttype)
                     else
                       begin
                          if (pt.nodetype=rangen) then
                           begin
                             if (trangenode(pt).left.nodetype=ordconstn) and
                                (trangenode(pt).right.nodetype=ordconstn) then
                              begin
                                { make both the same type or give an error. This is not
                                  done when both are integer values, because typecasting
                                  between -3200..3200 will result in a signed-unsigned
                                  conflict and give a range check error (PFV) }
                                if not(is_integer(trangenode(pt).left.resulttype.def) and is_integer(trangenode(pt).left.resulttype.def)) then
                                  inserttypeconv(trangenode(pt).left,trangenode(pt).right.resulttype);
                                lowval:=tordconstnode(trangenode(pt).left).value;
                                highval:=tordconstnode(trangenode(pt).right).value;
                                if highval<lowval then
                                 begin
                                   Message(parser_e_array_lower_less_than_upper_bound);
                                   highval:=lowval;
                                 end;
                                if is_integer(trangenode(pt).left.resulttype.def) then
                                  range_to_type(lowval,highval,arraytype)
                                else
                                  arraytype:=trangenode(pt).left.resulttype;
                              end
                             else
                              Message(type_e_cant_eval_constant_expr);
                           end
                          else
                           Message(sym_e_error_in_type_def)
                       end;
                     pt.free;
                   end;

                { create arraydef }
                  if not assigned(tt.def) then
                   begin
                     ap:=tarraydef.create(lowval,highval,arraytype);
                     tt.setdef(ap);
                   end
                  else
                   begin
                     ap.elementtype.setdef(tarraydef.create(lowval,highval,arraytype));
                     ap:=tarraydef(ap.elementtype.def);
                   end;

                  if token=_COMMA then
                    consume(_COMMA)
                  else
                    break;
                until false;
                consume(_RECKKLAMMER);
             end
           else
             begin
                ap:=tarraydef.create(0,-1,s32inttype);
                ap.IsDynamicArray:=true;
                tt.setdef(ap);
             end;
           consume(_OF);
           read_type(tt2,'',true);
           { if no error, set element type }
           if assigned(ap) then
             ap.setelementtype(tt2);
        end;

      var
        p  : tnode;
        pd : tabstractprocdef;
        is_func,
        enumdupmsg : boolean;
        newtype : ttypesym;
      begin
         tt.reset;
         case token of
            _STRING,_FILE:
              begin
                single_type(tt,hs,false);
              end;
           _LKLAMMER:
              begin
                consume(_LKLAMMER);
                { allow negativ value_str }
                l:=-1;
                enumdupmsg:=false;
                aktenumdef:=tenumdef.create;
                repeat
                  s:=orgpattern;
                  defpos:=akttokenpos;
                  consume(_ID);
                  { only allow assigning of specific numbers under fpc mode }
                  if not(m_tp7 in aktmodeswitches) and
                     (
                      { in fpc mode also allow := to be compatible
                        with previous 1.0.x versions }
                      ((m_fpc in aktmodeswitches) and
                       try_to_consume(_ASSIGNMENT)) or
                      try_to_consume(_EQUAL)
                     ) then
                    begin
                       p:=comp_expr(true);
                       if (p.nodetype=ordconstn) then
                        begin
                          { we expect an integer or an enum of the
                            same type }
                          if is_integer(p.resulttype.def) or
                             is_char(p.resulttype.def) or
                             equal_defs(p.resulttype.def,aktenumdef) then
                           v:=tordconstnode(p).value
                          else
                           IncompatibleTypes(p.resulttype.def,s32inttype.def);
                        end
                       else
                        Message(parser_e_illegal_expression);
                       p.free;
                       { please leave that a note, allows type save }
                       { declarations in the win32 units ! }
                       if (v<=l) and (not enumdupmsg) then
                        begin
                          Message(parser_n_duplicate_enum);
                          enumdupmsg:=true;
                        end;
                       l:=v;
                    end
                  else
                    inc(l);
                  storepos:=akttokenpos;
                  akttokenpos:=defpos;
                  constsymtable.insert(tenumsym.create(s,aktenumdef,l));
                  akttokenpos:=storepos;
                until not try_to_consume(_COMMA);
                tt.setdef(aktenumdef);
                consume(_RKLAMMER);
              end;
            _ARRAY:
              begin
                array_dec;
              end;
            _SET:
              begin
                consume(_SET);
                consume(_OF);
                read_type(tt2,'',true);
                if assigned(tt2.def) then
                 begin
                   case tt2.def.deftype of
                     { don't forget that min can be negativ  PM }
                     enumdef :
                       if tenumdef(tt2.def).min>=0 then
                        tt.setdef(tsetdef.create(tt2,tenumdef(tt2.def).max))
                       else
                        Message(sym_e_ill_type_decl_set);
                     orddef :
                       begin
                         case torddef(tt2.def).typ of
                           uchar :
                             tt.setdef(tsetdef.create(tt2,255));
                           u8bit,u16bit,u32bit,
                           s8bit,s16bit,s32bit :
                             begin
                               if (torddef(tt2.def).low>=0) then
                                tt.setdef(tsetdef.create(tt2,torddef(tt2.def).high))
                               else
                                Message(sym_e_ill_type_decl_set);
                             end;
                           else
                             Message(sym_e_ill_type_decl_set);
                         end;
                       end;
                     else
                       Message(sym_e_ill_type_decl_set);
                   end;
                 end
                else
                 tt:=generrortype;
              end;
           _CARET:
              begin
                consume(_CARET);
                single_type(tt2,hs,typecanbeforward);
                tt.setdef(tpointerdef.create(tt2));
              end;
            _RECORD:
              begin
                tt.setdef(record_dec);
              end;
            _PACKED:
              begin
                consume(_PACKED);
                if token=_ARRAY then
                  array_dec
                else
                  begin
                    oldaktpackrecords:=aktpackrecords;
                    aktpackrecords:=1;
                    if token in [_CLASS,_OBJECT] then
                      tt.setdef(object_dec(name,nil))
                    else
                      tt.setdef(record_dec);
                    aktpackrecords:=oldaktpackrecords;
                  end;
              end;
            _CLASS,
            _CPPCLASS,
            _INTERFACE,
            _OBJECT:
              begin
                tt.setdef(object_dec(name,nil));
              end;
            _PROCEDURE,
            _FUNCTION:
              begin
                is_func:=(token=_FUNCTION);
                consume(token);
                pd:=tprocvardef.create(normal_function_level);
                if token=_LKLAMMER then
                  parse_parameter_dec(pd);
                if is_func then
                 begin
                   consume(_COLON);
                   single_type(pd.rettype,hs,false);
                 end;
                if token=_OF then
                  begin
                    consume(_OF);
                    consume(_OBJECT);
                    include(pd.procoptions,po_methodpointer);
                  end;
                tt.def:=pd;
                { possible proc directives }
                if parseprocvardir then
                  begin
                    if is_proc_directive(token,true) then
                      begin
                         newtype:=ttypesym.create('unnamed',tt);
                         parse_var_proc_directives(tsym(newtype));
                         newtype.restype.def:=nil;
                         tt.def.typesym:=nil;
                         newtype.free;
                      end;
                    { Add implicit hidden parameters and function result }
                    handle_calling_convention(pd);
                    calc_parast(pd);
                  end;
              end;
            else
              expr_type;
         end;
         if tt.def=nil then
          tt:=generrortype;
      end;

end.
{
  $Log$
  Revision 1.67  2004-06-16 20:07:09  florian
    * dwarf branch merged

  Revision 1.66.2.1  2004/04/28 19:55:52  peter
    * new warning for ordinal-pointer when size is different
    * fixed some cg_e_ messages to the correct section type_e_ or parser_e_

  Revision 1.66  2004/03/29 14:44:10  peter
    * fixes to previous constant integer commit

  Revision 1.65  2004/03/23 22:34:49  peter
    * constants ordinals now always have a type assigned
    * integer constants have the smallest type, unsigned prefered over
      signed

  Revision 1.64  2004/02/03 22:32:54  peter
    * renamed xNNbittype to xNNinttype
    * renamed registers32 to registersint
    * replace some s32bit,u32bit with torddef([su]inttype).def.typ

  Revision 1.63  2004/01/29 16:51:29  peter
    * fixed alignment calculation for variant records
    * fixed alignment padding of records

  Revision 1.62  2004/01/28 22:16:31  peter
    * more record alignment fixes

  Revision 1.61  2004/01/28 20:30:18  peter
    * record alignment splitted in fieldalignment and recordalignment,
      the latter is used when this record is inserted in another record.

  Revision 1.60  2003/10/21 18:16:13  peter
    * IncompatibleTypes() added that will include unit names when
      the typenames are the same

  Revision 1.59  2003/10/03 14:45:09  peter
    * more proc directive for procvar fixes

  Revision 1.58  2003/10/02 21:13:09  peter
    * procvar directive parsing fixes

  Revision 1.57  2003/10/01 19:05:33  peter
    * searchsym_type to search for type definitions. It ignores
      records,objects and parameters

  Revision 1.56  2003/09/23 17:56:06  peter
    * locals and paras are allocated in the code generation
    * tvarsym.localloc contains the location of para/local when
      generating code for the current procedure

  Revision 1.55  2003/05/15 18:58:53  peter
    * removed selfpointer_offset, vmtpointer_offset
    * tvarsym.adjusted_address
    * address in localsymtable is now in the real direction
    * removed some obsolete globals

  Revision 1.54  2003/05/09 17:47:03  peter
    * self moved to hidden parameter
    * removed hdisposen,hnewn,selfn

  Revision 1.53  2003/04/27 11:21:34  peter
    * aktprocdef renamed to current_procdef
    * procinfo renamed to current_procinfo
    * procinfo will now be stored in current_module so it can be
      cleaned up properly
    * gen_main_procsym changed to create_main_proc and release_main_proc
      to also generate a tprocinfo structure
    * fixed unit implicit initfinal

  Revision 1.52  2003/04/27 07:29:51  peter
    * current_procdef cleanup, current_procdef is now always nil when parsing
      a new procdef declaration
    * aktprocsym removed
    * lexlevel removed, use symtable.symtablelevel instead
    * implicit init/final code uses the normal genentry/genexit
    * funcret state checking updated for new funcret handling

  Revision 1.51  2003/04/25 20:59:34  peter
    * removed funcretn,funcretsym, function result is now in varsym
      and aliases for result and function name are added using absolutesym
    * vs_hidden parameter for funcret passed in parameter
    * vs_hidden fixes
    * writenode changed to printnode and released from extdebug
    * -vp option added to generate a tree.log with the nodetree
    * nicer printnode for statements, callnode

  Revision 1.50  2003/01/05 15:54:15  florian
    + added proper support of type = type <type>; for simple types

  Revision 1.49  2003/01/03 23:50:41  peter
    * also allow = in fpc mode to assign enums

  Revision 1.48  2003/01/02 19:49:00  peter
    * update self parameter only for methodpointer and methods

  Revision 1.47  2002/12/21 13:07:34  peter
    * type redefine fix for tb0437

  Revision 1.46  2002/11/25 17:43:23  peter
    * splitted defbase in defutil,symutil,defcmp
    * merged isconvertable and is_equal into compare_defs(_ext)
    * made operator search faster by walking the list only once

  Revision 1.45  2002/09/27 21:13:29  carl
    * low-highval always checked if limit ober 2GB is reached (to avoid overflow)

  Revision 1.44  2002/09/10 16:26:39  peter
    * safety check for typesym added for incomplete type def check

  Revision 1.43  2002/09/09 19:34:07  peter
    * check for incomplete types in the current symtable when parsing
      forwarddef. Maybe this shall be delphi/tp only

  Revision 1.42  2002/07/20 11:57:56  florian
    * types.pas renamed to defbase.pas because D6 contains a types
      unit so this would conflicts if D6 programms are compiled
    + Willamette/SSE2 instructions to assembler added

  Revision 1.41  2002/05/18 13:34:16  peter
    * readded missing revisions

  Revision 1.40  2002/05/16 19:46:44  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.38  2002/05/12 16:53:10  peter
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

  Revision 1.37  2002/04/19 15:46:03  peter
    * mangledname rewrite, tprocdef.mangledname is now created dynamicly
      in most cases and not written to the ppu
    * add mangeledname_prefix() routine to generate the prefix of
      manglednames depending on the current procedure, object and module
    * removed static procprefix since the mangledname is now build only
      on demand from tprocdef.mangledname

  Revision 1.36  2002/04/16 16:12:47  peter
    * give error when using enums with jumps as array index
    * allow char as enum value

  Revision 1.35  2002/04/04 19:06:04  peter
    * removed unused units
    * use tlocation.size in cg.a_*loc*() routines

  Revision 1.34  2002/01/24 18:25:49  peter
   * implicit result variable generation for assembler routines
   * removed m_tp modeswitch, use m_tp7 or not(m_fpc) instead

  Revision 1.33  2002/01/15 16:13:34  jonas
    * fixed web bugs 1758 and 1760

  Revision 1.32  2002/01/06 12:08:15  peter
    * removed uauto from orddef, use new range_to_basetype generating
      the correct ordinal type for a range

}
