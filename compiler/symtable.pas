{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl, Pierre Muller

    This unit handles the symbol tables

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
unit symtable;

{$i fpcdefs.inc}

interface

    uses
       { common }
       cutils,cclasses,
       { global }
       cpuinfo,globtype,tokens,
       { symtable }
       symconst,symbase,symtype,symdef,symsym,
       { ppu }
       ppu,
       { assembler }
       aasmtai
       ;


{****************************************************************************
                             Symtable types
****************************************************************************}

    type
       tstoredsymtable = class(tsymtable)
       private
          b_needs_init_final : boolean;
          procedure _needs_init_final(p : tnamedindexitem;arg:pointer);
          procedure check_forward(sym : TNamedIndexItem;arg:pointer);
          procedure labeldefined(p : TNamedIndexItem;arg:pointer);
          procedure varsymbolused(p : TNamedIndexItem;arg:pointer);
          procedure TestPrivate(p : TNamedIndexItem;arg:pointer);
          procedure objectprivatesymbolused(p : TNamedIndexItem;arg:pointer);
{$ifdef GDB}
       private
          procedure concatstab(p : TNamedIndexItem;arg:pointer);
          procedure resetstab(p : TNamedIndexItem;arg:pointer);
          procedure concattypestab(p : TNamedIndexItem;arg:pointer);
{$endif}
          procedure unchain_overloads(p : TNamedIndexItem;arg:pointer);
          procedure loaddefs(ppufile:tcompilerppufile);
          procedure loadsyms(ppufile:tcompilerppufile);
          procedure reset_def(def:Tnamedindexitem;arg:pointer);
          procedure writedefs(ppufile:tcompilerppufile);
          procedure writesyms(ppufile:tcompilerppufile);
       public
          { load/write }
          procedure ppuload(ppufile:tcompilerppufile);virtual;
          procedure ppuwrite(ppufile:tcompilerppufile);virtual;
          procedure load_references(ppufile:tcompilerppufile;locals:boolean);virtual;
          procedure write_references(ppufile:tcompilerppufile;locals:boolean);virtual;
          procedure buildderef;virtual;
          procedure buildderefimpl;virtual;
          procedure deref;virtual;
          procedure derefimpl;virtual;
          procedure insert(sym : tsymentry);override;
          procedure reset_all_defs;virtual;
          function  speedsearch(const s : stringid;speedvalue : cardinal) : tsymentry;override;
          procedure allsymbolsused;
          procedure allprivatesused;
          procedure check_forwards;
          procedure checklabels;
          function  needs_init_final : boolean;
          procedure unchain_overloaded;
{$ifdef GDB}
          procedure concatstabto(asmlist : taasmoutput);virtual;
          function  getnewtypecount : word; override;
{$endif GDB}
          procedure testfordefaultproperty(p : TNamedIndexItem;arg:pointer);
       end;

       tabstractrecordsymtable = class(tstoredsymtable)
       public
          datasize       : longint;
          usefieldalignment,     { alignment to use for fields (PACKRECORDS value), -1 is C style }
          recordalignment,       { alignment required when inserting this record }
          fieldalignment : shortint; { alignment current alignment used when fields are inserted }
          constructor create(const n:string;usealign:shortint);
          procedure ppuload(ppufile:tcompilerppufile);override;
          procedure ppuwrite(ppufile:tcompilerppufile);override;
          procedure load_references(ppufile:tcompilerppufile;locals:boolean);override;
          procedure write_references(ppufile:tcompilerppufile;locals:boolean);override;
          procedure insertfield(sym:tvarsym;addsym:boolean);
          procedure addalignmentpadding;
       end;

       trecordsymtable = class(tabstractrecordsymtable)
       public
          constructor create(usealign:shortint);
          procedure insertunionst(unionst : trecordsymtable;offset : longint);
       end;

       tobjectsymtable = class(tabstractrecordsymtable)
       public
          constructor create(const n:string;usealign:shortint);
          procedure insert(sym : tsymentry);override;
       end;

       tabstractlocalsymtable = class(tstoredsymtable)
       public
          procedure ppuwrite(ppufile:tcompilerppufile);override;
       end;

       tlocalsymtable = class(tabstractlocalsymtable)
       public
          constructor create(level:byte);
          procedure insert(sym : tsymentry);override;
       end;

       tparasymtable = class(tabstractlocalsymtable)
       public
          constructor create(level:byte);
          procedure insert(sym : tsymentry);override;
       end;

       tabstractunitsymtable = class(tstoredsymtable)
       public
{$ifdef GDB}
          dbx_count : longint;
          prev_dbx_counter : plongint;
          dbx_count_ok : boolean;
          is_stab_written : boolean;
{$endif GDB}
          constructor create(const n : string);
{$ifdef GDB}
          procedure concattypestabto(asmlist : taasmoutput);
{$endif GDB}
       end;

       tglobalsymtable = class(tabstractunitsymtable)
       public
          unittypecount : word;
          constructor create(const n : string);
          procedure ppuload(ppufile:tcompilerppufile);override;
          procedure ppuwrite(ppufile:tcompilerppufile);override;
          procedure load_references(ppufile:tcompilerppufile;locals:boolean);override;
          procedure write_references(ppufile:tcompilerppufile;locals:boolean);override;
          procedure insert(sym : tsymentry);override;
{$ifdef GDB}
          function getnewtypecount : word; override;
{$endif}
       end;

       tstaticsymtable = class(tabstractunitsymtable)
       public
          constructor create(const n : string);
          procedure ppuload(ppufile:tcompilerppufile);override;
          procedure ppuwrite(ppufile:tcompilerppufile);override;
          procedure load_references(ppufile:tcompilerppufile;locals:boolean);override;
          procedure write_references(ppufile:tcompilerppufile;locals:boolean);override;
          procedure insert(sym : tsymentry);override;
       end;

       twithsymtable = class(tsymtable)
          withrefnode : pointer; { tnode }
          constructor create(aowner:tdef;asymsearch:TDictionary;refnode:pointer{tnode});
          destructor  destroy;override;
          procedure clear;override;
        end;

       tstt_exceptsymtable = class(tsymtable)
       public
          constructor create;
       end;


    var
       constsymtable  : tsymtable;      { symtable were the constants can be inserted }
       systemunit     : tglobalsymtable; { pointer to the system unit }

{****************************************************************************
                             Functions
****************************************************************************}

{*** Misc ***}
    procedure globaldef(const s : string;var t:ttype);
    function  findunitsymtable(st:tsymtable):tsymtable;
    procedure duplicatesym(sym:tsym);
    procedure incompatibletypes(def1,def2:tdef);

{*** Search ***}
    function  searchsym(const s : stringid;var srsym:tsym;var srsymtable:tsymtable):boolean;
    function  searchsym_type(const s : stringid;var srsym:tsym;var srsymtable:tsymtable):boolean;
    function  searchsymonlyin(p : tsymtable;const s : stringid):tsym;
    function  searchsym_in_class(classh:tobjectdef;const s : stringid):tsym;
    function  searchsym_in_class_by_msgint(classh:tobjectdef;i:longint):tsym;
    function  searchsym_in_class_by_msgstr(classh:tobjectdef;const s:string):tsym;
    function  searchsystype(const s: stringid; var srsym: ttypesym): boolean;
    function  searchsysvar(const s: stringid; var srsym: tvarsym; var symowner: tsymtable): boolean;
    function  search_class_member(pd : tobjectdef;const s : string):tsym;
    function  search_assignment_operator(from_def,to_def:Tdef):Tprocdef;
    function  search_unary_operator(op:Ttoken;def:Tdef):Tprocdef;
    function  search_binary_operator(op:Ttoken;def1,def2:Tdef):Tprocdef;

{*** Object Helpers ***}
    procedure search_class_overloads(aprocsym : tprocsym);
    function search_default_property(pd : tobjectdef) : tpropertysym;

    procedure reset_all_defs;

{*** symtable stack ***}
{$ifdef DEBUG}
    procedure test_symtablestack;
    procedure list_symtablestack;
{$endif DEBUG}

{$ifdef UNITALIASES}
    type
       punit_alias = ^tunit_alias;
       tunit_alias = object(TNamedIndexItem)
          newname : pstring;
          constructor init(const n:string);
          destructor  done;virtual;
       end;
    var
       unitaliases : pdictionary;

    procedure addunitalias(const n:string);
    function getunitalias(const n:string):string;
{$endif UNITALIASES}

{*** Init / Done ***}
    procedure InitSymtable;
    procedure DoneSymtable;

    const
       overloaded_names : array [NOTOKEN..last_overloaded] of string[16] =
         ('error',
          'plus','minus','star','slash','equal',
          'greater','lower','greater_or_equal',
          'lower_or_equal',
          'sym_diff','starstar',
          'as','is','in','or',
          'and','div','mod','not','shl','shr','xor',
          'assign');



implementation

    uses
      { global }
      verbose,globals,
      { target }
      systems,
      { symtable }
      symutil,defcmp,
      { module }
      fmodule,
{$ifdef GDB}
      gdb,
{$endif GDB}
      { codegen }
      procinfo
      ;


{*****************************************************************************
                             TStoredSymtable
*****************************************************************************}

    procedure tstoredsymtable.ppuload(ppufile:tcompilerppufile);
      begin
        { load definitions }
        loaddefs(ppufile);

        { load symbols }
        loadsyms(ppufile);
      end;


    procedure tstoredsymtable.ppuwrite(ppufile:tcompilerppufile);
      begin
         { write definitions }
         writedefs(ppufile);

         { write symbols }
         writesyms(ppufile);
      end;


    procedure tstoredsymtable.loaddefs(ppufile:tcompilerppufile);
      var
        hp : tdef;
        b  : byte;
      begin
      { load start of definition section, which holds the amount of defs }
         if ppufile.readentry<>ibstartdefs then
          Message(unit_f_ppu_read_error);
         ppufile.getlongint;
      { read definitions }
         repeat
           b:=ppufile.readentry;
           case b of
              ibpointerdef : hp:=tpointerdef.ppuload(ppufile);
                ibarraydef : hp:=tarraydef.ppuload(ppufile);
                  iborddef : hp:=torddef.ppuload(ppufile);
                ibfloatdef : hp:=tfloatdef.ppuload(ppufile);
                 ibprocdef : hp:=tprocdef.ppuload(ppufile);
          ibshortstringdef : hp:=tstringdef.loadshort(ppufile);
           iblongstringdef : hp:=tstringdef.loadlong(ppufile);
           ibansistringdef : hp:=tstringdef.loadansi(ppufile);
           ibwidestringdef : hp:=tstringdef.loadwide(ppufile);
               ibrecorddef : hp:=trecorddef.ppuload(ppufile);
               ibobjectdef : hp:=tobjectdef.ppuload(ppufile);
                 ibenumdef : hp:=tenumdef.ppuload(ppufile);
                  ibsetdef : hp:=tsetdef.ppuload(ppufile);
              ibprocvardef : hp:=tprocvardef.ppuload(ppufile);
                 ibfiledef : hp:=tfiledef.ppuload(ppufile);
             ibclassrefdef : hp:=tclassrefdef.ppuload(ppufile);
               ibformaldef : hp:=tformaldef.ppuload(ppufile);
              ibvariantdef : hp:=tvariantdef.ppuload(ppufile);
                 ibenddefs : break;
                     ibend : Message(unit_f_ppu_read_error);
           else
             Message1(unit_f_ppu_invalid_entry,tostr(b));
           end;
           hp.owner:=self;
           defindex.insert(hp);
         until false;
      end;


    procedure tstoredsymtable.loadsyms(ppufile:tcompilerppufile);
      var
        b   : byte;
        sym : tsym;
      begin
      { load start of definition section, which holds the amount of defs }
         if ppufile.readentry<>ibstartsyms then
          Message(unit_f_ppu_read_error);
         { skip amount of symbols, not used currently }
         ppufile.getlongint;
         { now read the symbols }
         repeat
           b:=ppufile.readentry;
           case b of
                ibtypesym : sym:=ttypesym.ppuload(ppufile);
                ibprocsym : sym:=tprocsym.ppuload(ppufile);
               ibconstsym : sym:=tconstsym.ppuload(ppufile);
                 ibvarsym : sym:=tvarsym.ppuload(ppufile);
            ibabsolutesym : sym:=tabsolutesym.ppuload(ppufile);
                ibenumsym : sym:=tenumsym.ppuload(ppufile);
          ibtypedconstsym : sym:=ttypedconstsym.ppuload(ppufile);
            ibpropertysym : sym:=tpropertysym.ppuload(ppufile);
                ibunitsym : sym:=tunitsym.ppuload(ppufile);
               iblabelsym : sym:=tlabelsym.ppuload(ppufile);
                 ibsyssym : sym:=tsyssym.ppuload(ppufile);
                ibrttisym : sym:=trttisym.ppuload(ppufile);
                ibendsyms : break;
                    ibend : Message(unit_f_ppu_read_error);
           else
             Message1(unit_f_ppu_invalid_entry,tostr(b));
           end;
           sym.owner:=self;
           symindex.insert(sym);
           symsearch.insert(sym);
         until false;
      end;


    procedure tstoredsymtable.writedefs(ppufile:tcompilerppufile);
      var
         pd : tstoreddef;
      begin
         { each definition get a number, write then the amount of defs to the
           ibstartdef entry }
         ppufile.putlongint(defindex.count);
         ppufile.writeentry(ibstartdefs);
         { now write the definition }
         pd:=tstoreddef(defindex.first);
         while assigned(pd) do
           begin
              pd.ppuwrite(ppufile);
              pd:=tstoreddef(pd.indexnext);
           end;
         { write end of definitions }
         ppufile.writeentry(ibenddefs);
      end;


    procedure tstoredsymtable.writesyms(ppufile:tcompilerppufile);
      var
        pd : Tsym;
      begin
         { each definition get a number, write then the amount of syms and the
           datasize to the ibsymdef entry }
         ppufile.putlongint(symindex.count);
         ppufile.writeentry(ibstartsyms);
         { foreach is used to write all symbols }
         pd:=Tsym(symindex.first);
         while assigned(pd) do
           begin
              pd.ppuwrite(ppufile);
              pd:=Tsym(pd.indexnext);
           end;
         { end of symbols }
         ppufile.writeentry(ibendsyms);
      end;


    procedure tstoredsymtable.load_references(ppufile:tcompilerppufile;locals:boolean);
      var
        b     : byte;
        d     : tderef;
        sym   : Tsym;
        prdef : tstoreddef;
      begin
         b:=ppufile.readentry;
         if b <> ibbeginsymtablebrowser then
           Message1(unit_f_ppu_invalid_entry,tostr(b));
         repeat
           b:=ppufile.readentry;
           case b of
             ibsymref :
               begin
                 ppufile.getderef(d);
                 sym:=Tsym(d.resolve);
                 if assigned(sym) then
                   sym.load_references(ppufile,locals);
               end;
             ibdefref :
               begin
                 ppufile.getderef(d);
                 prdef:=tstoreddef(d.resolve);
                 if assigned(prdef) then
                   begin
                     if prdef.deftype<>procdef then
                       Message(unit_f_ppu_read_error);
                     tprocdef(prdef).load_references(ppufile,locals);
                   end;
               end;
             ibendsymtablebrowser :
               break;
             else
               Message1(unit_f_ppu_invalid_entry,tostr(b));
           end;
         until false;
      end;


    procedure tstoredsymtable.write_references(ppufile:tcompilerppufile;locals:boolean);
      var
        pd : Tsym;
      begin
         ppufile.writeentry(ibbeginsymtablebrowser);
         { write all symbols }
         pd:=Tsym(symindex.first);
         while assigned(pd) do
           begin
              pd.write_references(ppufile,locals);
              pd:=Tsym(pd.indexnext);
           end;
         ppufile.writeentry(ibendsymtablebrowser);
      end;


    procedure tstoredsymtable.buildderef;
      var
        hp : tdef;
        hs : tsym;
      begin
        { interface definitions }
        hp:=tdef(defindex.first);
        while assigned(hp) do
         begin
           hp.buildderef;
           hp:=tdef(hp.indexnext);
         end;
        { interface symbols }
        hs:=tsym(symindex.first);
        while assigned(hs) do
         begin
           hs.buildderef;
           hs:=tsym(hs.indexnext);
         end;
      end;


    procedure tstoredsymtable.buildderefimpl;
      var
        hp : tdef;
      begin
        { definitions }
        hp:=tdef(defindex.first);
        while assigned(hp) do
         begin
           hp.buildderefimpl;
           hp:=tdef(hp.indexnext);
         end;
      end;


    procedure tstoredsymtable.deref;
      var
        hp : tdef;
        hs : tsym;
      begin
        { first deref the interface ttype symbols. This is needs
          to be done before the interface defs are derefed, because
          the interface defs can contain references to the type symbols
          which then already need to contain a resolved restype field (PFV) }
        hs:=tsym(symindex.first);
        while assigned(hs) do
         begin
           if hs.typ=typesym then
             hs.deref;
           hs:=tsym(hs.indexnext);
         end;
        { deref the interface definitions }
        hp:=tdef(defindex.first);
        while assigned(hp) do
         begin
           hp.deref;
           hp:=tdef(hp.indexnext);
         end;
        { deref the interface symbols }
        hs:=tsym(symindex.first);
        while assigned(hs) do
         begin
           if hs.typ<>typesym then
             hs.deref;
           hs:=tsym(hs.indexnext);
         end;
      end;


    procedure tstoredsymtable.derefimpl;
      var
        hp : tdef;
      begin
        { definitions }
        hp:=tdef(defindex.first);
        while assigned(hp) do
         begin
           hp.derefimpl;
           hp:=tdef(hp.indexnext);
         end;
      end;


    procedure tstoredsymtable.insert(sym:tsymentry);
      var
         hsym : tsym;
      begin
         { set owner and sym indexnb }
         sym.owner:=self;

         { check the current symtable }
         hsym:=tsym(search(sym.name));
         if assigned(hsym) then
          begin
            { in TP and Delphi you can have a local with the
              same name as the function, the function is then hidden for
              the user. (Under delphi it can still be accessed using result),
              but don't allow hiding of RESULT }
            if (m_duplicate_names in aktmodeswitches) and
               (sym.typ in [varsym,absolutesym]) and
               (vo_is_funcret in tvarsym(sym).varoptions) and
               not((m_result in aktmodeswitches) and
                   (vo_is_result in tvarsym(sym).varoptions)) then
             sym.name:='hidden'+sym.name
            else
             begin
               DuplicateSym(hsym);
               exit;
             end;
          end;

         { register definition of typesym }
         if (sym.typ = typesym) and
            assigned(ttypesym(sym).restype.def) then
          begin
            if not(assigned(ttypesym(sym).restype.def.owner)) and
               (ttypesym(sym).restype.def.deftype<>errordef) then
              registerdef(ttypesym(sym).restype.def);
{$ifdef GDB}
            if (cs_debuginfo in aktmoduleswitches) and assigned(debuglist) and
               (symtabletype in [globalsymtable,staticsymtable]) then
              begin
                ttypesym(sym).isusedinstab := true;
                {sym.concatstabto(debuglist);}
              end;
{$endif GDB}
          end;

         { insert in index and search hash }
         symindex.insert(sym);
         symsearch.insert(sym);
      end;


    function tstoredsymtable.speedsearch(const s : stringid;speedvalue : cardinal) : tsymentry;
      var
        hp : Tsym;
        newref : tref;
      begin
        hp:=Tsym(inherited speedsearch(s,speedvalue));
        if assigned(hp) then
         begin
           { reject non static members in static procedures }
           if (symtabletype=objectsymtable) and
              not(sp_static in hp.symoptions) and
              allow_only_static then
             Message(sym_e_only_static_in_static);

           { unit uses count }
           if (unitid<>0) and
              (symtabletype = globalsymtable) and
              assigned(current_module) and
              (unitid<current_module.mapsize) and
              assigned(current_module.map[unitid].unitsym) then
             inc(current_module.map[unitid].unitsym.refs);

{$ifdef GDB}
           { if it is a type, we need the stabs of this type
             this might be the cause of the class debug problems
             as TCHILDCLASS.Create did not generate appropriate
             stabs debug info if TCHILDCLASS wasn't used anywhere else PM }
           if (cs_debuginfo in aktmoduleswitches) and
              (hp.typ=typesym) and make_ref then
             begin
               if assigned(ttypesym(hp).restype.def) then
                 tstoreddef(ttypesym(hp).restype.def).numberstring
               else
                 ttypesym(hp).isusedinstab:=true;
             end;
{$endif GDB}

           { unitsym are only loaded for browsing PM    }
           { this was buggy anyway because we could use }
           { unitsyms from other units in _USES !!      }
           {if (symtabletype=unitsymtable) and (hp.typ=unitsym) and
              assigned(current_module) and (current_module.globalsymtable<>.load) then
             hp:=nil;}
           if make_ref and (cs_browser in aktmoduleswitches) then
             begin
                newref:=tref.create(hp.lastref,@akttokenpos);
                { for symbols that are in tables without browser info or syssyms }
                if hp.refcount=0 then
                  begin
                    hp.defref:=newref;
                    hp.lastref:=newref;
                  end
                else
                if resolving_forward and assigned(hp.defref) then
                { put it as second reference }
                  begin
                   newref.nextref:=hp.defref.nextref;
                   hp.defref.nextref:=newref;
                   hp.lastref.nextref:=nil;
                  end
                else
                  hp.lastref:=newref;
                inc(hp.refcount);
             end;
           if make_ref then
               inc(hp.refs);
         end; { value was not found }
        speedsearch:=hp;
      end;


{**************************************
             Callbacks
**************************************}

    procedure TStoredSymtable.check_forward(sym : TNamedIndexItem;arg:pointer);
      begin
         if tsym(sym).typ=procsym then
           tprocsym(sym).check_forward
         { check also object method table            }
         { we needn't to test the def list          }
         { because each object has to have a type sym }
         else
          if (tsym(sym).typ=typesym) and
             assigned(ttypesym(sym).restype.def) and
             (ttypesym(sym).restype.def.deftype=objectdef) then
           tobjectdef(ttypesym(sym).restype.def).check_forwards;
      end;


    procedure TStoredSymtable.labeldefined(p : TNamedIndexItem;arg:pointer);
      begin
        if (tsym(p).typ=labelsym) and
           not(tlabelsym(p).defined) then
         begin
           if tlabelsym(p).used then
            Message1(sym_e_label_used_and_not_defined,tlabelsym(p).realname)
           else
            Message1(sym_w_label_not_defined,tlabelsym(p).realname);
         end;
      end;


    procedure TStoredSymtable.varsymbolused(p : TNamedIndexItem;arg:pointer);
      begin
         if (tsym(p).typ=varsym) and
            ((tsym(p).owner.symtabletype in
             [parasymtable,localsymtable,objectsymtable,staticsymtable])) then
          begin
           { unused symbol should be reported only if no }
           { error is reported                     }
           { if the symbol is in a register it is used   }
           { also don't count the value parameters which have local copies }
           { also don't claim for high param of open parameters (PM) }
           if (Errorcount<>0) or
              (assigned(tvarsym(p).paraitem) and
               tvarsym(p).paraitem.is_hidden) then
             exit;
           if (tvarsym(p).refs=0) then
             begin
                if (vo_is_funcret in tvarsym(p).varoptions) then
                  begin
                    { don't warn about the result of constructors }
                    if (tsym(p).owner.symtabletype<>localsymtable) or
                       (tprocdef(tsym(p).owner.defowner).proctypeoption<>potype_constructor) then
                      MessagePos(tsym(p).fileinfo,sym_w_function_result_not_set)
                  end
                else if (tsym(p).owner.symtabletype=parasymtable) then
                  MessagePos1(tsym(p).fileinfo,sym_h_para_identifier_not_used,tsym(p).realname)
                else if (tsym(p).owner.symtabletype=objectsymtable) then
                  MessagePos2(tsym(p).fileinfo,sym_n_private_identifier_not_used,tsym(p).owner.realname^,tsym(p).realname)
                else
                  MessagePos1(tsym(p).fileinfo,sym_n_local_identifier_not_used,tsym(p).realname);
             end
           else if tvarsym(p).varstate=vs_assigned then
             begin
                if (tsym(p).owner.symtabletype=parasymtable) then
                  begin
                    if not(tvarsym(p).varspez in [vs_var,vs_out]) and
                       not(vo_is_funcret in tvarsym(p).varoptions) then
                      MessagePos1(tsym(p).fileinfo,sym_h_para_identifier_only_set,tsym(p).realname)
                  end
                else if (tsym(p).owner.symtabletype=objectsymtable) then
                  MessagePos2(tsym(p).fileinfo,sym_n_private_identifier_only_set,tsym(p).owner.realname^,tsym(p).realname)
                else if not(vo_is_exported in tvarsym(p).varoptions) and
                        not(vo_is_funcret in tvarsym(p).varoptions) then
                  MessagePos1(tsym(p).fileinfo,sym_n_local_identifier_only_set,tsym(p).realname);
             end;
         end
      else if ((tsym(p).owner.symtabletype in
              [objectsymtable,parasymtable,localsymtable,staticsymtable])) then
          begin
           if (Errorcount<>0) or
              (sp_internal in tsym(p).symoptions) then
             exit;
           { do not claim for inherited private fields !! }
           if (Tsym(p).refs=0) and (tsym(p).owner.symtabletype=objectsymtable) then
             MessagePos2(tsym(p).fileinfo,sym_n_private_method_not_used,tsym(p).owner.realname^,tsym(p).realname)
           { units references are problematic }
           else
            begin
              if (Tsym(p).refs=0) and
                 not(tsym(p).typ in [enumsym,unitsym]) and
                 not(is_funcret_sym(tsym(p))) and
                 (
                  (tsym(p).typ<>procsym) or
{$ifdef GDB}
                  not (tprocsym(p).is_global) or
{$endif GDB}
                  { all program functions are declared global
                    but unused should still be signaled PM }
                  ((tsym(p).owner.symtabletype=staticsymtable) and
                   not current_module.is_unit)
                 ) then
                MessagePos2(tsym(p).fileinfo,sym_h_local_symbol_not_used,SymTypeName[tsym(p).typ],tsym(p).realname);
            end;
          end;
      end;


    procedure TStoredSymtable.TestPrivate(p : TNamedIndexItem;arg:pointer);
      begin
        if sp_private in tsym(p).symoptions then
          varsymbolused(p,arg);
      end;


    procedure TStoredSymtable.objectprivatesymbolused(p : TNamedIndexItem;arg:pointer);
      begin
         {
           Don't test simple object aliases PM
         }
         if (tsym(p).typ=typesym) and
            (ttypesym(p).restype.def.deftype=objectdef) and
            (ttypesym(p).restype.def.typesym=tsym(p)) then
           tobjectdef(ttypesym(p).restype.def).symtable.foreach({$ifdef FPCPROCVAR}@{$endif}TestPrivate,nil);
      end;


    procedure tstoredsymtable.unchain_overloads(p : TNamedIndexItem;arg:pointer);
      begin
         if tsym(p).typ=procsym then
           tprocsym(p).unchain_overload;
      end;


    procedure Tstoredsymtable.reset_def(def:Tnamedindexitem;arg:pointer);
      begin
        Tstoreddef(def).reset;
      end;


{$ifdef GDB}

    procedure TStoredSymtable.concatstab(p : TNamedIndexItem;arg:pointer);

    var stabstr:Pchar;
        ao:Taasmoutput;

    begin
      if Tsym(p).typ<>procsym then
        begin
          ao:=Taasmoutput(arg);
          if not Tsym(p).isstabwritten then
            begin
              stabstr:=Tsym(p).stabstring;
              if stabstr<>nil then
                ao.concat(Tai_stabs.create(stabstr));
              Tsym(p).isstabwritten:=true;
            end;
        end;
    end;


    procedure TStoredSymtable.resetstab(p : TNamedIndexItem;arg:pointer);
      begin
        if tsym(p).typ <> procsym then
          Tstoredsym(p).isstabwritten:=false;
      end;


    procedure TStoredSymtable.concattypestab(p : TNamedIndexItem;arg:pointer);

    var stabstr:Pchar;
        ao:Taasmoutput;

    begin
      if Tsym(p).typ=typesym then
        begin
          ao:=Taasmoutput(arg);
          if Ttypesym(p).restype.def.typesym=p then
            Tstoreddef(Ttypesym(p).restype.def).concatstabto(ao)
          else
            begin
              Tsym(p).isstabwritten:=false;
              stabstr:=Tsym(p).stabstring;
              if stabstr<>nil then
                ao.concat(Tai_stabs.create(stabstr));
              Tsym(p).isstabwritten:=true;
            end;
        end;
    end;


   function tstoredsymtable.getnewtypecount : word;
      begin
         getnewtypecount:=pglobaltypecount^;
         inc(pglobaltypecount^);
      end;
{$endif GDB}


{***********************************************
           Process all entries
***********************************************}

    procedure Tstoredsymtable.reset_all_defs;
      begin
        defindex.foreach(@reset_def,nil);
      end;


    { checks, if all procsyms and methods are defined }
    procedure tstoredsymtable.check_forwards;
      begin
         foreach({$ifdef FPCPROCVAR}@{$endif}check_forward,nil);
      end;


    procedure tstoredsymtable.checklabels;
      begin
         foreach({$ifdef FPCPROCVAR}@{$endif}labeldefined,nil);
      end;


    procedure tstoredsymtable.allsymbolsused;
      begin
         foreach({$ifdef FPCPROCVAR}@{$endif}varsymbolused,nil);
      end;


    procedure tstoredsymtable.allprivatesused;
      begin
         foreach({$ifdef FPCPROCVAR}@{$endif}objectprivatesymbolused,nil);
      end;


    procedure tstoredsymtable.unchain_overloaded;
      begin
         foreach({$ifdef FPCPROCVAR}@{$endif}unchain_overloads,nil);
      end;


{$ifdef GDB}
    procedure tstoredsymtable.concatstabto(asmlist : taasmoutput);
      begin
        foreach({$ifdef FPCPROCVAR}@{$endif}concatstab,asmlist);
      end;
{$endif}


    procedure TStoredSymtable._needs_init_final(p : tnamedindexitem;arg:pointer);
      begin
         if b_needs_init_final then
          exit;
         case tsym(p).typ of
           varsym :
             begin
               if not(is_class(tvarsym(p).vartype.def)) and
                  tstoreddef(tvarsym(p).vartype.def).needs_inittable then
                 b_needs_init_final:=true;
             end;
           typedconstsym :
             begin
               if ttypedconstsym(p).is_writable and
                  tstoreddef(ttypedconstsym(p).typedconsttype.def).needs_inittable then
                 b_needs_init_final:=true;
             end;
         end;
      end;


    { returns true, if p contains data which needs init/final code }
    function tstoredsymtable.needs_init_final : boolean;
      begin
         b_needs_init_final:=false;
         foreach({$ifdef FPCPROCVAR}@{$endif}_needs_init_final,nil);
         needs_init_final:=b_needs_init_final;
      end;


{****************************************************************************
                          TAbstractRecordSymtable
****************************************************************************}

    constructor tabstractrecordsymtable.create(const n:string;usealign:shortint);
      begin
        inherited create(n);
        datasize:=0;
        recordalignment:=1;
        usefieldalignment:=usealign;
        { recordalign -1 means C record packing, that starts
          with an alignment of 1 }
        if usealign=-1 then
          fieldalignment:=1
        else
          fieldalignment:=usealign;
      end;


    procedure tabstractrecordsymtable.ppuload(ppufile:tcompilerppufile);
      var
        storesymtable : tsymtable;
      begin
        storesymtable:=aktrecordsymtable;
        aktrecordsymtable:=self;

        inherited ppuload(ppufile);

        aktrecordsymtable:=storesymtable;
      end;


    procedure tabstractrecordsymtable.ppuwrite(ppufile:tcompilerppufile);
      var
        oldtyp : byte;
        storesymtable : tsymtable;
      begin
         storesymtable:=aktrecordsymtable;
         aktrecordsymtable:=self;
         oldtyp:=ppufile.entrytyp;
         ppufile.entrytyp:=subentryid;

         inherited ppuwrite(ppufile);

         ppufile.entrytyp:=oldtyp;
         aktrecordsymtable:=storesymtable;
      end;


    procedure tabstractrecordsymtable.load_references(ppufile:tcompilerppufile;locals:boolean);
      var
        storesymtable : tsymtable;
      begin
        storesymtable:=aktrecordsymtable;
        aktrecordsymtable:=self;

        inherited load_references(ppufile,locals);

        aktrecordsymtable:=storesymtable;
      end;


    procedure tabstractrecordsymtable.write_references(ppufile:tcompilerppufile;locals:boolean);
      var
        storesymtable : tsymtable;
      begin
        storesymtable:=aktrecordsymtable;
        aktrecordsymtable:=self;

        inherited write_references(ppufile,locals);

        aktrecordsymtable:=storesymtable;
      end;


    procedure tabstractrecordsymtable.insertfield(sym : tvarsym;addsym:boolean);
      var
        l,
        varalignrecord,
        varalignfield,
        varalign : longint;
        vardef : tdef;
      begin
        if addsym then
          insert(sym);
        { this symbol can't be loaded to a register }
        exclude(tvarsym(sym).varoptions,vo_regable);
        exclude(tvarsym(sym).varoptions,vo_fpuregable);
        { Calculate field offset }
        l:=tvarsym(sym).getvaluesize;
        vardef:=tvarsym(sym).vartype.def;
        varalign:=vardef.alignment;
        { Calc the alignment size for C style records }
        if (usefieldalignment=-1) then
         begin
           if (varalign>4) and
              ((varalign mod 4)<>0) and
              (vardef.deftype=arraydef) then
             Message1(sym_w_wrong_C_pack,vardef.typename);
           if varalign=0 then
             varalign:=l;
           if (fieldalignment<aktalignment.maxCrecordalign) then
            begin
              if (varalign>16) and (fieldalignment<32) then
               fieldalignment:=32
              else if (varalign>12) and (fieldalignment<16) then
               fieldalignment:=16
              { 12 is needed for long double }
              else if (varalign>8) and (fieldalignment<12) then
               fieldalignment:=12
              else if (varalign>4) and (fieldalignment<8) then
               fieldalignment:=8
              else if (varalign>2) and (fieldalignment<4) then
               fieldalignment:=4
              else if (varalign>1) and (fieldalignment<2) then
               fieldalignment:=2;
            end;
           fieldalignment:=min(fieldalignment,aktalignment.maxCrecordalign);
         end;
        if varalign=0 then
          varalign:=size_2_align(l);
        varalignfield:=used_align(varalign,aktalignment.recordalignmin,fieldalignment);
        tvarsym(sym).fieldoffset:=align(datasize,varalignfield);
        datasize:=tvarsym(sym).fieldoffset+l;
        { Calc alignment needed for this record }
        if (usefieldalignment=-1) then
          varalignrecord:=used_align(varalign,aktalignment.recordalignmin,aktalignment.maxCrecordalign)
        else
          varalignrecord:=used_align(varalign,aktalignment.recordalignmin,aktalignment.recordalignmax);
        recordalignment:=max(recordalignment,varalignrecord);
      end;


    procedure tabstractrecordsymtable.addalignmentpadding;
      var
        padalign : shortint;
      begin
        { make the record size aligned correctly so it can be
          used as elements in an array. For C records we
          use the fieldalignment, because that is updated with the
          used alignment. For normal records we use minimum from
          recordalginment or fieldalignment. This is required to
          be able to override the natural alignment with 'packed' }
        if usefieldalignment=-1 then
          padalign:=fieldalignment
        else
          padalign:=min(fieldalignment,recordalignment);
        datasize:=align(datasize,padalign);
      end;


{****************************************************************************
                              TRecordSymtable
****************************************************************************}

    constructor trecordsymtable.create(usealign:shortint);
      begin
        inherited create('',usealign);
        symtabletype:=recordsymtable;
      end;


   { this procedure is reserved for inserting case variant into
      a record symtable }
    { the offset is the location of the start of the variant
      and datasize and dataalignment corresponds to
      the complete size (see code in pdecl unit) PM }
    procedure trecordsymtable.insertunionst(unionst : trecordsymtable;offset : longint);
      var
        ps,nps : tvarsym;
        pd,npd : tdef;
        varalignrecord,varalign,
        storesize,storealign : longint;
      begin
        storesize:=datasize;
        storealign:=fieldalignment;
        datasize:=offset;
        ps:=tvarsym(unionst.symindex.first);
        while assigned(ps) do
          begin
            nps:=tvarsym(ps.indexnext);
            { remove from current symtable }
            unionst.symindex.deleteindex(ps);
            ps.left:=nil;
            ps.right:=nil;
            { add to this record }
            ps.owner:=self;
            datasize:=ps.fieldoffset+offset;
            symindex.insert(ps);
            symsearch.insert(ps);
            { update address }
            ps.fieldoffset:=datasize;

            { update alignment of this record }
            varalign:=ps.vartype.def.alignment;
            if varalign=0 then
              varalign:=size_2_align(ps.getvaluesize);
            varalignrecord:=used_align(varalign,aktalignment.recordalignmin,aktalignment.recordalignmax);
            recordalignment:=max(recordalignment,varalignrecord);

            { next }
            ps:=nps;
          end;
        pd:=tdef(unionst.defindex.first);
        while assigned(pd) do
          begin
            npd:=tdef(pd.indexnext);
            unionst.defindex.deleteindex(pd);
            pd.left:=nil;
            pd.right:=nil;
            registerdef(pd);
            pd:=npd;
          end;
        datasize:=storesize;
        fieldalignment:=storealign;
      end;


{****************************************************************************
                              TObjectSymtable
****************************************************************************}

    constructor tobjectsymtable.create(const n:string;usealign:shortint);
      begin
        inherited create(n,usealign);
        symtabletype:=objectsymtable;
      end;


    procedure tobjectsymtable.insert(sym:tsymentry);
      var
         hsym : tsym;
      begin
         { check for duplicate field id in inherited classes }
         if (sym.typ=varsym) and
            assigned(defowner) and
            (
             not(m_delphi in aktmodeswitches) or
             is_object(tdef(defowner))
            ) then
           begin
              { but private ids can be reused }
              hsym:=search_class_member(tobjectdef(defowner),sym.name);
              if assigned(hsym) and
                 Tsym(hsym).is_visible_for_object(tobjectdef(defowner)) then
               begin
                 DuplicateSym(hsym);
                 exit;
               end;
           end;
         inherited insert(sym);
      end;


{****************************************************************************
                          TAbstractLocalSymtable
****************************************************************************}

   procedure tabstractlocalsymtable.ppuwrite(ppufile:tcompilerppufile);
      var
        oldtyp : byte;
      begin
         oldtyp:=ppufile.entrytyp;
         ppufile.entrytyp:=subentryid;

         { write definitions }
         writedefs(ppufile);
         { write symbols }
         writesyms(ppufile);

         ppufile.entrytyp:=oldtyp;
      end;


{****************************************************************************
                              TLocalSymtable
****************************************************************************}

    constructor tlocalsymtable.create(level:byte);
      begin
        inherited create('');
        symtabletype:=localsymtable;
        symtablelevel:=level;
      end;


    procedure tlocalsymtable.insert(sym:tsymentry);
      var
         hsym : tsym;
      begin
        { need to hide function result? }
        hsym:=tsym(search(sym.name));
        if assigned(hsym) then
          begin
            { a local and the function can have the same
              name in TP and Delphi, but RESULT not }
            if (m_duplicate_names in aktmodeswitches) and
               (hsym.typ in [absolutesym,varsym]) and
               (vo_is_funcret in tvarsym(hsym).varoptions) and
               not((m_result in aktmodeswitches) and
                   (vo_is_result in tvarsym(hsym).varoptions)) then
              hsym.owner.rename(hsym.name,'hidden'+hsym.name)
            else
              begin
                DuplicateSym(hsym);
                exit;
              end;
          end;

        if assigned(next) and
           (next.symtabletype=parasymtable) then
          begin
            { check para symtable }
            hsym:=tsym(next.search(sym.name));
            if assigned(hsym) then
              begin
                { a local and the function can have the same
                  name in TP and Delphi, but RESULT not }
                if (m_duplicate_names in aktmodeswitches) and
                   (sym.typ in [absolutesym,varsym]) and
                   (vo_is_funcret in tvarsym(sym).varoptions) and
                   not((m_result in aktmodeswitches) and
                       (vo_is_result in tvarsym(sym).varoptions)) then
                  sym.name:='hidden'+sym.name
                else
                  begin
                    DuplicateSym(hsym);
                    exit;
                  end;
              end;
            { check for duplicate id in local symtable of methods }
            if assigned(next.next) and
               { funcretsym is allowed !! }
               (not is_funcret_sym(sym)) and
               (next.next.symtabletype=objectsymtable) then
             begin
               hsym:=search_class_member(tobjectdef(next.next.defowner),sym.name);
               if assigned(hsym) and
                 { private ids can be reused }
                  (not(sp_private in hsym.symoptions) or
                   (hsym.owner.defowner.owner.symtabletype<>globalsymtable)) then
                begin
                  { delphi allows to reuse the names in a class, but not
                    in object (tp7 compatible) }
                  if not((m_delphi in aktmodeswitches) and
                         is_class(tdef(next.next.defowner))) then
                   begin
                     DuplicateSym(hsym);
                     exit;
                   end;
                end;
             end;
          end;

         inherited insert(sym);
      end;


{****************************************************************************
                              TParaSymtable
****************************************************************************}

    constructor tparasymtable.create(level:byte);
      begin
        inherited create('');
        symtabletype:=parasymtable;
        symtablelevel:=level;
      end;


    procedure tparasymtable.insert(sym:tsymentry);
      var
         hsym : tsym;
      begin
         { check for duplicate id in para symtable of methods }
         if assigned(next) and
            (next.symtabletype=objectsymtable) and
            { funcretsym is allowed }
            (not is_funcret_sym(sym)) then
           begin
              hsym:=search_class_member(tobjectdef(next.defowner),sym.name);
              { private ids can be reused }
              if assigned(hsym) and
                 Tsym(hsym).is_visible_for_object(tobjectdef(next.defowner)) then
               begin
                 { delphi allows to reuse the names in a class, but not
                   in object (tp7 compatible) }
                 if not((m_delphi in aktmodeswitches) and
                        is_class_or_interface(tobjectdef(next.defowner))) then
                  begin
                    DuplicateSym(hsym);
                    exit;
                  end;
               end;
           end;

         inherited insert(sym);
      end;


{****************************************************************************
                         TAbstractUnitSymtable
****************************************************************************}

    constructor tabstractunitsymtable.create(const n : string);
      begin
        inherited create(n);
        symsearch.usehash;
{$ifdef GDB}
         { reset GDB things }
         prev_dbx_counter := dbx_counter;
         dbx_counter := nil;
         is_stab_written:=false;
         dbx_count := -1;
{$endif GDB}
      end;


{$ifdef GDB}
      procedure tabstractunitsymtable.concattypestabto(asmlist : taasmoutput);
        var prev_dbx_count : plongint;
        begin
           if is_stab_written then
             exit;
           if not assigned(name) then
             name := stringdup('Main_program');
           {if (symtabletype = globalsymtable) and
              (current_module.globalsymtable<>self) then
             begin
                unitid:=current_module.unitcount;
                inc(current_module.unitcount);
             end;}
           asmList.concat(tai_comment.Create(strpnew('Begin unit '+name^+' has index '+tostr(unitid))));
           if cs_gdb_dbx in aktglobalswitches then
             begin
                if dbx_count_ok then
                  begin
                     asmList.concat(tai_comment.Create(strpnew('"repeated" unit '+name^
                              +' has index '+tostr(unitid)+' dbx count = '+tostr(dbx_count))));
                     asmList.concat(Tai_stabs.Create(strpnew('"'+name^+'",'
                       +tostr(N_EXCL)+',0,0,'+tostr(dbx_count))));
                     exit;
                  end
                else if (current_module.globalsymtable<>self) then
                  begin
                    prev_dbx_count := dbx_counter;
                    dbx_counter := nil;
                    do_count_dbx:=false;
                    if (symtabletype = globalsymtable) and (unitid<>0) then
                      asmList.concat(Tai_stabs.Create(strpnew('"'+name^+'",'+tostr(N_BINCL)+',0,0,0')));
                    dbx_counter := @dbx_count;
                    dbx_count:=0;
                    do_count_dbx:=assigned(dbx_counter);
                  end;
             end;
           foreach({$ifdef FPCPROCVAR}@{$endif}concattypestab,asmlist);
           if cs_gdb_dbx in aktglobalswitches then
             begin
                if (current_module.globalsymtable<>self) then
                  begin
                    dbx_counter := prev_dbx_count;
                    do_count_dbx:=false;
                    asmList.concat(tai_comment.Create(strpnew('End unit '+name^
                      +' has index '+tostr(unitid))));
                    asmList.concat(Tai_stabs.Create(strpnew('"'+name^+'",'
                      +tostr(N_EINCL)+',0,0,0')));
                    do_count_dbx:=assigned(dbx_counter);
                    dbx_count_ok := {true}false;
                  end;
             end;
           is_stab_written:=true;
        end;
{$endif GDB}


{****************************************************************************
                              TStaticSymtable
****************************************************************************}

    constructor tstaticsymtable.create(const n : string);
      begin
        inherited create(n);
        symtabletype:=staticsymtable;
        symtablelevel:=main_program_level;
      end;


    procedure tstaticsymtable.ppuload(ppufile:tcompilerppufile);
      begin
        aktstaticsymtable:=self;

        next:=symtablestack;
        symtablestack:=self;

        inherited ppuload(ppufile);

        { now we can deref the syms and defs }
        deref;

        { restore symtablestack }
        symtablestack:=next;
      end;


    procedure tstaticsymtable.ppuwrite(ppufile:tcompilerppufile);
      begin
        aktstaticsymtable:=self;

        inherited ppuwrite(ppufile);
      end;


    procedure tstaticsymtable.load_references(ppufile:tcompilerppufile;locals:boolean);
      begin
        aktstaticsymtable:=self;

        inherited load_references(ppufile,locals);
      end;


    procedure tstaticsymtable.write_references(ppufile:tcompilerppufile;locals:boolean);
      begin
        aktstaticsymtable:=self;

        inherited write_references(ppufile,locals);
      end;


    procedure tstaticsymtable.insert(sym:tsymentry);
      var
         hsym : tsym;
      begin
         { also check the global symtable }
         if assigned(next) and
            (next.unitid=0) then
          begin
            hsym:=tsym(next.search(sym.name));
            if assigned(hsym) then
             begin
               { Delphi you can have a symbol with the same name as the
                 unit, the unit can then not be accessed anymore using
                 <unit>.<id>, so we can hide the symbol }
               if (m_duplicate_names in aktmodeswitches) and
                  (hsym.typ=symconst.unitsym) then
                hsym.owner.rename(hsym.name,'hidden'+hsym.name)
               else
                begin
                  DuplicateSym(hsym);
                  exit;
                end;
             end;
          end;

         inherited insert(sym);
      end;


{****************************************************************************
                              TGlobalSymtable
****************************************************************************}

    constructor tglobalsymtable.create(const n : string);
      begin
         inherited create(n);
         symtabletype:=globalsymtable;
         symtablelevel:=main_program_level;
         unitid:=0;
{$ifdef GDB}
         if cs_gdb_dbx in aktglobalswitches then
           begin
             dbx_count := 0;
             unittypecount:=1;
             pglobaltypecount := @unittypecount;
             {unitid:=current_module.unitcount;}
             debugList.concat(tai_comment.Create(strpnew('Global '+name^+' has index '+tostr(unitid))));
             debugList.concat(Tai_stabs.Create(strpnew('"'+name^+'",'+tostr(N_BINCL)+',0,0,0')));
             {inc(current_module.unitcount);}
             { we can't use dbx_vcount, because we don't know
               if the object file will be loaded before or afeter PM }
             dbx_count_ok:=false;
             dbx_counter:=@dbx_count;
             do_count_dbx:=true;
           end;
{$endif GDB}
      end;


    procedure tglobalsymtable.ppuload(ppufile:tcompilerppufile);
{$ifdef GDB}
      var
        b : byte;
{$endif GDB}
      begin
{$ifdef GDB}
         if cs_gdb_dbx in aktglobalswitches then
           begin
              UnitTypeCount:=1;
              PglobalTypeCount:=@UnitTypeCount;
           end;
{$endif GDB}

         aktglobalsymtable:=self;

         next:=symtablestack;
         symtablestack:=self;

         inherited ppuload(ppufile);

         { now we can deref the syms and defs }
         deref;

         { restore symtablestack }
         symtablestack:=next;

         { read dbx count }
{$ifdef GDB}
        if (current_module.flags and uf_has_dbx)<>0 then
         begin
           b:=ppufile.readentry;
           if b<>ibdbxcount then
             Message(unit_f_ppu_dbx_count_problem)
           else
             dbx_count:=ppufile.getlongint;
{$IfDef EXTDEBUG}
           writeln('Read dbx_count ',dbx_count,' in unit ',name^,'.ppu');
{$ENDIF EXTDEBUG}
           { we can't use dbx_vcount, because we don't know
             if the object file will be loaded before or afeter PM }
           dbx_count_ok := {true}false;
         end
        else
         begin
           dbx_count:=-1;
           dbx_count_ok:=false;
         end;
{$endif GDB}
      end;


    procedure tglobalsymtable.ppuwrite(ppufile:tcompilerppufile);
      begin
        aktglobalsymtable:=self;

        { write the symtable entries }
        inherited ppuwrite(ppufile);

        { write dbx count }
{$ifdef GDB}
        if cs_gdb_dbx in aktglobalswitches then
         begin
{$IfDef EXTDEBUG}
           writeln('Writing dbx_count ',dbx_count,' in unit ',name^,'.ppu');
{$ENDIF EXTDEBUG}
           ppufile.do_crc:=false;
           ppufile.putlongint(dbx_count);
           ppufile.writeentry(ibdbxcount);
           ppufile.do_crc:=true;
         end;
{$endif GDB}
      end;


    procedure tglobalsymtable.load_references(ppufile:tcompilerppufile;locals:boolean);
      begin
        aktglobalsymtable:=self;

        inherited load_references(ppufile,locals);
      end;


    procedure tglobalsymtable.write_references(ppufile:tcompilerppufile;locals:boolean);
      begin
        aktglobalsymtable:=self;

        inherited write_references(ppufile,locals);
      end;


    procedure tglobalsymtable.insert(sym:tsymentry);
      var
         hsym : tsym;
      begin
         { also check the global symtable }
         if assigned(next) and
            (next.unitid=0) then
          begin
            hsym:=tsym(next.search(sym.name));
            if assigned(hsym) then
             begin
               { Delphi you can have a symbol with the same name as the
                 unit, the unit can then not be accessed anymore using
                 <unit>.<id>, so we can hide the symbol }
               if (m_duplicate_names in aktmodeswitches) and
                  (hsym.typ=symconst.unitsym) then
                hsym.owner.rename(hsym.name,'hidden'+hsym.name)
               else
                begin
                  DuplicateSym(hsym);
                  exit;
                end;
             end;
          end;

         hsym:=tsym(search(sym.name));
         if assigned(hsym) then
          begin
            { Delphi you can have a symbol with the same name as the
              unit, the unit can then not be accessed anymore using
              <unit>.<id>, so we can hide the symbol }
            if (m_duplicate_names in aktmodeswitches) and
               (hsym.typ=symconst.unitsym) then
             hsym.owner.rename(hsym.name,'hidden'+hsym.name)
            else
             begin
               DuplicateSym(hsym);
               exit;
             end;
          end;

         inherited insert(sym);
      end;


{$ifdef GDB}
   function tglobalsymtable.getnewtypecount : word;
      begin
         if not (cs_gdb_dbx in aktglobalswitches) then
           getnewtypecount:=inherited getnewtypecount
         else
           begin
              getnewtypecount:=unittypecount;
              inc(unittypecount);
           end;
      end;
{$endif}


{****************************************************************************
                              TWITHSYMTABLE
****************************************************************************}

    constructor twithsymtable.create(aowner:tdef;asymsearch:TDictionary;refnode:pointer{tnode});
      begin
         inherited create('');
         symtabletype:=withsymtable;
         withrefnode:=refnode;
         { we don't need the symsearch }
         symsearch.free;
         { set the defaults }
         symsearch:=asymsearch;
         defowner:=aowner;
      end;


    destructor twithsymtable.destroy;
      begin
        tobject(withrefnode).free;
        symsearch:=nil;
        inherited destroy;
      end;


    procedure twithsymtable.clear;
      begin
         { remove no entry from a withsymtable as it is only a pointer to the
           recorddef  or objectdef symtable }
      end;


{****************************************************************************
                          TSTT_ExceptionSymtable
****************************************************************************}

    constructor tstt_exceptsymtable.create;
      begin
        inherited create('');
        symtabletype:=stt_exceptsymtable;
      end;


{*****************************************************************************
                             Helper Routines
*****************************************************************************}

    function findunitsymtable(st:tsymtable):tsymtable;
      begin
        findunitsymtable:=nil;
        repeat
          if not assigned(st) then
           internalerror(5566561);
          case st.symtabletype of
            localsymtable,
            parasymtable,
            staticsymtable :
              exit;
            globalsymtable :
              begin
                findunitsymtable:=st;
                exit;
              end;
            objectsymtable :
              st:=st.defowner.owner;
            recordsymtable :
              begin
                { don't continue when the current
                  symtable is used for variant records }
                if trecorddef(st.defowner).isunion then
                 begin
                   findunitsymtable:=nil;
                   exit;
                 end
                else
                 st:=st.defowner.owner;
              end;
            else
              internalerror(5566562);
          end;
        until false;
      end;


     procedure duplicatesym(sym:tsym);
       var
         st : tsymtable;
       begin
         Message1(sym_e_duplicate_id,sym.realname);
         st:=findunitsymtable(sym.owner);
         with sym.fileinfo do
           begin
             if assigned(st) and (st.unitid<>0) then
               Message2(sym_h_duplicate_id_where,'unit '+st.name^,tostr(line))
             else
               Message2(sym_h_duplicate_id_where,current_module.sourcefiles.get_file_name(fileindex),tostr(line));
           end;
       end;


    procedure incompatibletypes(def1,def2:tdef);
      var
        s1,s2 : string;
      begin
        s1:=def1.typename;
        s2:=def2.typename;
        { When the names are the same try to include the unit name }
        if upper(s1)=upper(s2) then
          begin
            if (def1.owner.symtabletype in [globalsymtable,staticsymtable]) then
              s1:=def1.owner.realname^+'.'+s1;
            if (def2.owner.symtabletype in [globalsymtable,staticsymtable]) then
              s2:=def2.owner.realname^+'.'+s2;
          end;
        if def2.deftype<>errordef then
          CGMessage2(type_e_incompatible_types,s1,s2);
      end;


{*****************************************************************************
                                  Search
*****************************************************************************}

    function  searchsym(const s : stringid;var srsym:tsym;var srsymtable:tsymtable):boolean;
      var
        speedvalue : cardinal;
        topclass   : tobjectdef;
      begin
         speedvalue:=getspeedvalue(s);
         srsymtable:=symtablestack;
         while assigned(srsymtable) do
           begin
             srsym:=tsym(srsymtable.speedsearch(s,speedvalue));
             if assigned(srsym) then
               begin
                 topclass:=nil;
                 if (srsymtable.symtabletype=withsymtable) and
                    assigned(srsymtable.defowner) and
                    (srsymtable.defowner.deftype=objectdef) then
                   topclass:=tobjectdef(srsymtable.defowner)
                 else
                   begin
                     if assigned(current_procinfo) then
                       topclass:=current_procinfo.procdef._class;
                   end;
                 if (not assigned(topclass)) or
                    Tsym(srsym).is_visible_for_object(topclass) then
                   begin
                     searchsym:=true;
                     exit;
                   end;
               end;
             srsymtable:=srsymtable.next;
           end;
         searchsym:=false;
      end;


    function  searchsym_type(const s : stringid;var srsym:tsym;var srsymtable:tsymtable):boolean;
      var
        speedvalue : cardinal;
      begin
         speedvalue:=getspeedvalue(s);
         srsymtable:=symtablestack;
         while assigned(srsymtable) do
           begin
              {
                It is not possible to have type defintions in:
                  records
                  objects
                  parameters
              }
              if not(srsymtable.symtabletype in [recordsymtable,objectsymtable,parasymtable]) then
                begin
                  srsym:=tsym(srsymtable.speedsearch(s,speedvalue));
                  if assigned(srsym) and
                     (not assigned(current_procinfo) or
                      Tsym(srsym).is_visible_for_object(current_procinfo.procdef._class)) then
                    begin
                      result:=true;
                      exit;
                    end
                end;
              srsymtable:=srsymtable.next;
           end;
         result:=false;
      end;


    function  searchsymonlyin(p : tsymtable;const s : stringid):tsym;
      var
        srsym      : tsym;
      begin
         { the caller have to take care if srsym=nil }
         if assigned(p) then
           begin
              srsym:=tsym(p.search(s));
              if assigned(srsym) then
               begin
                 searchsymonlyin:=srsym;
                 exit;
               end;
              { also check in the local symtbale if it exists }
              if (p=tsymtable(current_module.globalsymtable)) then
                begin
                   srsym:=tsym(current_module.localsymtable.search(s));
                   if assigned(srsym) then
                    begin
                      searchsymonlyin:=srsym;
                      exit;
                    end;
                end
           end;
         searchsymonlyin:=nil;
       end;


    function  searchsym_in_class(classh:tobjectdef;const s : stringid):tsym;
      var
        speedvalue : cardinal;
        topclassh  : tobjectdef;
        sym        : tsym;
      begin
         speedvalue:=getspeedvalue(s);
         { when the class passed is defined in this unit we
           need to use the scope of that class. This is a trick
           that can be used to access protected members in other
           units. At least kylix supports it this way (PFV) }
         if assigned(classh) and
            (classh.owner.symtabletype in [globalsymtable,staticsymtable]) and
            (classh.owner.unitid=0) then
           topclassh:=classh
         else
           begin
             if assigned(current_procinfo) then
               topclassh:=current_procinfo.procdef._class
             else
               topclassh:=nil;
           end;
         sym:=nil;
         while assigned(classh) do
          begin
            sym:=tsym(classh.symtable.speedsearch(s,speedvalue));
            if assigned(sym) and
               Tsym(sym).is_visible_for_object(topclassh) then
              break;
            classh:=classh.childof;
          end;
         searchsym_in_class:=sym;
      end;


    function  searchsym_in_class_by_msgint(classh:tobjectdef;i:longint):tsym;
      var
        topclassh  : tobjectdef;
        def        : tdef;
        sym        : tsym;
      begin
         { when the class passed is defined in this unit we
           need to use the scope of that class. This is a trick
           that can be used to access protected members in other
           units. At least kylix supports it this way (PFV) }
         if assigned(classh) and
            (classh.owner.symtabletype in [globalsymtable,staticsymtable]) and
            (classh.owner.unitid=0) then
           topclassh:=classh
         else
           begin
             if assigned(current_procinfo) then
               topclassh:=current_procinfo.procdef._class
             else
               topclassh:=nil;
           end;
         sym:=nil;
         def:=nil;
         while assigned(classh) do
          begin
            def:=tdef(classh.symtable.defindex.first);
            while assigned(def) do
             begin
               if (def.deftype=procdef) and
                  (po_msgint in tprocdef(def).procoptions) and
                  (tprocdef(def).messageinf.i=i) then
                begin
                  sym:=tprocdef(def).procsym;
                  if assigned(topclassh) then
                   begin
                     if tprocdef(def).is_visible_for_object(topclassh) then
                      break;
                   end
                  else
                   break;
                end;
               def:=tdef(def.indexnext);
             end;
            if assigned(sym) then
             break;
            classh:=classh.childof;
          end;
         searchsym_in_class_by_msgint:=sym;
      end;


    function  searchsym_in_class_by_msgstr(classh:tobjectdef;const s:string):tsym;
      var
        topclassh  : tobjectdef;
        def        : tdef;
        sym        : tsym;
      begin
         { when the class passed is defined in this unit we
           need to use the scope of that class. This is a trick
           that can be used to access protected members in other
           units. At least kylix supports it this way (PFV) }
         if assigned(classh) and
            (classh.owner.symtabletype in [globalsymtable,staticsymtable]) and
            (classh.owner.unitid=0) then
           topclassh:=classh
         else
           begin
             if assigned(current_procinfo) then
               topclassh:=current_procinfo.procdef._class
             else
               topclassh:=nil;
           end;
         sym:=nil;
         def:=nil;
         while assigned(classh) do
          begin
            def:=tdef(classh.symtable.defindex.first);
            while assigned(def) do
             begin
               if (def.deftype=procdef) and
                  (po_msgstr in tprocdef(def).procoptions) and
                  (tprocdef(def).messageinf.str=s) then
                begin
                  sym:=tprocdef(def).procsym;
                  if assigned(topclassh) then
                   begin
                     if tprocdef(def).is_visible_for_object(topclassh) then
                      break;
                   end
                  else
                   break;
                end;
               def:=tdef(def.indexnext);
             end;
            if assigned(sym) then
             break;
            classh:=classh.childof;
          end;
         searchsym_in_class_by_msgstr:=sym;
      end;


    function search_assignment_operator(from_def,to_def:Tdef):Tprocdef;

    var st:Tsymtable;
        sym:Tprocsym;
        sv:cardinal;

    begin
      st:=symtablestack;
      sv:=getspeedvalue('assign');
      while st<>nil do
        begin
          sym:=Tprocsym(st.speedsearch('assign',sv));
          if sym<>nil then
            begin
              if sym.typ<>procsym then
                internalerror(200402031);
              search_assignment_operator:=sym.search_procdef_assignment_operator(from_def,to_def);
              if search_assignment_operator<>nil then
                break;
            end;
          st:=st.next;
        end;
    end;

    function search_unary_operator(op:Ttoken;def:Tdef):Tprocdef;

    var st:Tsymtable;
        sym:Tprocsym;
        sv:cardinal;

    begin
      result:=nil;
      st:=symtablestack;
      sv:=getspeedvalue(overloaded_names[op]);
      while st<>nil do
        begin
          sym:=Tprocsym(st.speedsearch(overloaded_names[op],sv));
          if sym<>nil then
            begin
              if sym.typ<>procsym then
                internalerror(200402031);
              result:=sym.search_procdef_unary_operator(def);
              if result<>nil then
                exit;
            end;
          st:=st.next;
        end;
    end;


    function search_binary_operator(op:Ttoken;def1,def2:Tdef):Tprocdef;

    var st:Tsymtable;
        sym:Tprocsym;
        sv:cardinal;

    begin
      result:=nil;
      st:=symtablestack;
      sv:=getspeedvalue(overloaded_names[op]);
      while st<>nil do
        begin
          sym:=Tprocsym(st.speedsearch(overloaded_names[op],sv));
          if sym<>nil then
            begin
              if sym.typ<>procsym then
                internalerror(200402031);
              result:=sym.search_procdef_binary_operator(def1,def2);
              if result<>nil then
                exit;
            end;
          st:=st.next;
        end;
    end;


    function searchsystype(const s: stringid; var srsym: ttypesym): boolean;
      var
        symowner: tsymtable;
      begin
        if not(cs_compilesystem in aktmoduleswitches) then
          srsym := ttypesym(searchsymonlyin(systemunit,s))
        else
          searchsym(s,tsym(srsym),symowner);
        searchsystype :=
          assigned(srsym) and
          (srsym.typ = typesym);
      end;


    function searchsysvar(const s: stringid; var srsym: tvarsym; var symowner: tsymtable): boolean;
      begin
        if not(cs_compilesystem in aktmoduleswitches) then
          begin
            srsym := tvarsym(searchsymonlyin(systemunit,s));
            symowner := systemunit;
          end
        else
          searchsym(s,tsym(srsym),symowner);
        searchsysvar :=
          assigned(srsym) and
          (srsym.typ = varsym);
      end;


    function search_class_member(pd : tobjectdef;const s : string):tsym;
    { searches n in symtable of pd and all anchestors }
      var
        speedvalue : cardinal;
        srsym      : tsym;
      begin
        speedvalue:=getspeedvalue(s);
        while assigned(pd) do
         begin
           srsym:=tsym(pd.symtable.speedsearch(s,speedvalue));
           if assigned(srsym) then
            begin
              search_class_member:=srsym;
              exit;
            end;
           pd:=pd.childof;
         end;
        search_class_member:=nil;
      end;

    procedure reset_all_defs;

    var st:Tsymtable;

    begin
      st:=symtablestack;
      while st<>nil do
        begin
          Tstoredsymtable(st).reset_all_defs;
          st:=st.next;
        end;
    end;

{*****************************************************************************
                            Definition Helpers
*****************************************************************************}

    procedure globaldef(const s : string;var t:ttype);

      var st : string;
          symt : tsymtable;
          srsym      : tsym;
          srsymtable : tsymtable;
      begin
         srsym := nil;
         if pos('.',s) > 0 then
           begin
           st := copy(s,1,pos('.',s)-1);
           searchsym(st,srsym,srsymtable);
           st := copy(s,pos('.',s)+1,255);
           if assigned(srsym) then
             begin
             if srsym.typ = unitsym then
               begin
               symt := tunitsym(srsym).unitsymtable;
               srsym := tsym(symt.search(st));
               end else srsym := nil;
             end;
           end else st := s;
         if srsym = nil then
          searchsym(st,srsym,srsymtable);
         if srsym = nil then
           srsym:=searchsymonlyin(systemunit,st);
         if (not assigned(srsym)) or
            (srsym.typ<>typesym) then
           begin
             Message(type_e_type_id_expected);
             t:=generrortype;
             exit;
           end;
         t := ttypesym(srsym).restype;
      end;

{****************************************************************************
                              Object Helpers
****************************************************************************}

    procedure search_class_overloads(aprocsym : tprocsym);
    { searches n in symtable of pd and all anchestors }
      var
        speedvalue : cardinal;
        srsym      : tprocsym;
        s          : string;
        objdef     : tobjectdef;
      begin
        if aprocsym.overloadchecked then
         exit;
        aprocsym.overloadchecked:=true;
        if (aprocsym.owner.symtabletype<>objectsymtable) then
         internalerror(200111021);
        objdef:=tobjectdef(aprocsym.owner.defowner);
        { we start in the parent }
        if not assigned(objdef.childof) then
         exit;
        objdef:=objdef.childof;
        s:=aprocsym.name;
        speedvalue:=getspeedvalue(s);
        while assigned(objdef) do
         begin
           srsym:=tprocsym(objdef.symtable.speedsearch(s,speedvalue));
           if assigned(srsym) then
            begin
              if (srsym.typ<>procsym) then
               internalerror(200111022);
              if srsym.is_visible_for_object(tobjectdef(aprocsym.owner.defowner)) then
               begin
                 srsym.add_para_match_to(Aprocsym,[cpo_ignorehidden,cpo_allowdefaults]);
                 { we can stop if the overloads were already added
                  for the found symbol }
                 if srsym.overloadchecked then
                  break;
               end;
            end;
           { next parent }
           objdef:=objdef.childof;
         end;
      end;


   procedure tstoredsymtable.testfordefaultproperty(p : TNamedIndexItem;arg:pointer);
     begin
        if (tsym(p).typ=propertysym) and
           (ppo_defaultproperty in tpropertysym(p).propoptions) then
          ppointer(arg)^:=p;
     end;


   function search_default_property(pd : tobjectdef) : tpropertysym;
   { returns the default property of a class, searches also anchestors }
     var
       _defaultprop : tpropertysym;
     begin
        _defaultprop:=nil;
        while assigned(pd) do
          begin
             pd.symtable.foreach({$ifdef FPCPROCVAR}@{$endif}tstoredsymtable(pd.symtable).testfordefaultproperty,@_defaultprop);
             if assigned(_defaultprop) then
               break;
             pd:=pd.childof;
          end;
        search_default_property:=_defaultprop;
     end;


{$ifdef UNITALIASES}
{****************************************************************************
                              TUNIT_ALIAS
 ****************************************************************************}

    constructor tunit_alias.create(const n:string);
      var
        i : longint;
      begin
        i:=pos('=',n);
        if i=0 then
         fail;
        inherited createname(Copy(n,1,i-1));
        newname:=stringdup(Copy(n,i+1,255));
      end;


    destructor tunit_alias.destroy;
      begin
        stringdispose(newname);
        inherited destroy;
      end;


    procedure addunitalias(const n:string);
      begin
        unitaliases^.insert(tunit_alias,init(Upper(n))));
      end;


    function getunitalias(const n:string):string;
      var
        p : punit_alias;
      begin
        p:=punit_alias(unitaliases^.search(Upper(n)));
        if assigned(p) then
         getunitalias:=punit_alias(p).newname^
        else
         getunitalias:=n;
      end;
{$endif UNITALIASES}


{****************************************************************************
                            Symtable Stack
****************************************************************************}

{$ifdef DEBUG}
    procedure test_symtablestack;
      var
         p : tsymtable;
         i : longint;
      begin
         p:=symtablestack;
         i:=0;
         while assigned(p) do
           begin
              inc(i);
              p:=p.next;
              if i>500 then
               Message(sym_f_internal_error_in_symtablestack);
           end;
      end;

    procedure list_symtablestack;
      var
         p : tsymtable;
         i : longint;
      begin
         p:=symtablestack;
         i:=0;
         while assigned(p) do
           begin
              inc(i);
              writeln(i,' ',p.name^);
              p:=p.next;
              if i>500 then
               Message(sym_f_internal_error_in_symtablestack);
           end;
      end;
{$endif DEBUG}


{****************************************************************************
                           Init/Done Symtable
****************************************************************************}

   procedure InitSymtable;
     var
       token : ttoken;
     begin
        { Reset symbolstack }
        registerdef:=false;
        symtablestack:=nil;
        systemunit:=nil;
{$ifdef GDB}
        globaltypecount:=1;
        pglobaltypecount:=@globaltypecount;
{$endif GDB}
        { defs for internal use }
        voidprocdef:=tprocdef.create(unknown_level);
        { create error syms and def }
        generrorsym:=terrorsym.create;
        generrortype.setdef(terrordef.create);
{$ifdef UNITALIASES}
        { unit aliases }
        unitaliases:=tdictionary.create;
{$endif}
     end;


   procedure DoneSymtable;
      begin
        voidprocdef.free;
        generrorsym.free;
        generrortype.def.free;
{$ifdef UNITALIASES}
        unitaliases.free;
{$endif}
     end;

end.
{
  $Log$
  Revision 1.139  2004-02-20 21:55:59  peter
    * procvar cleanup

  Revision 1.138  2004/02/17 15:57:49  peter
  - fix rtti generation for properties containing sl_vec
  - fix crash when overloaded operator is not available
  - fix record alignment for C style variant records

  Revision 1.137  2004/02/13 15:40:58  peter
    * fixed protected checking in withsymtable

  Revision 1.136  2004/02/11 19:59:06  peter
    * fix compilation without GDB

  Revision 1.135  2004/02/06 22:37:00  daniel
    * Removed not very usefull nextglobal & previousglobal fields from
      Tstoreddef, saving 78 kb of memory

  Revision 1.134  2004/02/04 22:15:16  daniel
    * Rtti generation moved to ncgutil
    * Assmtai usage of symsym removed
    * operator overloading cleanup up

  Revision 1.133  2004/01/31 22:48:31  daniel
    * Fix stabs generation problem reported by Jonas

  Revision 1.132  2004/01/31 18:40:15  daniel
    * Last steps before removal of aasmtai dependency in symsym can be
      accomplished.

  Revision 1.131  2004/01/30 14:33:06  florian
    * fixed more alignment issues

  Revision 1.130  2004/01/30 13:42:03  florian
    * fixed more alignment issues

  Revision 1.129  2004/01/29 16:51:29  peter
    * fixed alignment calculation for variant records
    * fixed alignment padding of records

  Revision 1.128  2004/01/28 22:16:31  peter
    * more record alignment fixes

  Revision 1.127  2004/01/28 20:30:18  peter
    * record alignment splitted in fieldalignment and recordalignment,
      the latter is used when this record is inserted in another record.

  Revision 1.126  2004/01/26 16:12:28  daniel
    * reginfo now also only allocated during register allocation
    * third round of gdb cleanups: kick out most of concatstabto

  Revision 1.125  2004/01/15 15:16:18  daniel
    * Some minor stuff
    * Managed to eliminate speed effects of string compression

  Revision 1.124  2004/01/11 23:56:20  daniel
    * Experiment: Compress strings to save memory
      Did not save a single byte of mem; clearly the core size is boosted by
      temporary memory usage...

  Revision 1.123  2003/11/10 22:02:52  peter
    * cross unit inlining fixed

  Revision 1.122  2003/11/08 17:08:44  florian
    * fixed strange error message about expecting erroneous types,
      usually this is caused by other errors so it isn't important

  Revision 1.121  2003/10/30 16:23:13  peter
    * don't search for overloads in parents for constructors

  Revision 1.120  2003/10/23 14:44:07  peter
    * splitted buildderef and buildderefimpl to fix interface crc
      calculation

  Revision 1.119  2003/10/22 20:40:00  peter
    * write derefdata in a separate ppu entry

  Revision 1.118  2003/10/22 15:22:33  peter
    * fixed unitsym-globalsymtable relation so the uses of a unit
      is counted correctly

  Revision 1.117  2003/10/21 18:16:13  peter
    * IncompatibleTypes() added that will include unit names when
      the typenames are the same

  Revision 1.116  2003/10/17 14:38:32  peter
    * 64k registers supported
    * fixed some memory leaks

  Revision 1.115  2003/10/13 14:05:12  peter
    * removed is_visible_for_proc
    * search also for class overloads when finding interface
      implementations

  Revision 1.114  2003/10/07 15:17:07  peter
    * inline supported again, LOC_REFERENCEs are used to pass the
      parameters
    * inlineparasymtable,inlinelocalsymtable removed
    * exitlabel inserting fixed

  Revision 1.113  2003/10/03 14:43:29  peter
    * don't report unused hidden parameters

  Revision 1.112  2003/10/02 21:13:46  peter
    * protected visibility fixes

  Revision 1.111  2003/10/01 19:05:33  peter
    * searchsym_type to search for type definitions. It ignores
      records,objects and parameters

  Revision 1.110  2003/09/23 17:56:06  peter
    * locals and paras are allocated in the code generation
    * tvarsym.localloc contains the location of para/local when
      generating code for the current procedure

  Revision 1.109  2003/08/23 22:31:08  peter
    * unchain operators before adding to overloaded list

  Revision 1.108  2003/06/25 18:31:23  peter
    * sym,def resolving partly rewritten to support also parent objects
      not directly available through the uses clause

  Revision 1.107  2003/06/13 21:19:31  peter
    * current_procdef removed, use current_procinfo.procdef instead

  Revision 1.106  2003/06/09 18:26:27  peter
    * para can be the same as function name in delphi

  Revision 1.105  2003/06/08 11:40:00  peter
    * check parast when inserting in localst

  Revision 1.104  2003/06/07 20:26:32  peter
    * re-resolving added instead of reloading from ppu
    * tderef object added to store deref info for resolving

  Revision 1.103  2003/05/25 11:34:17  peter
    * methodpointer self pushing fixed

  Revision 1.102  2003/05/23 14:27:35  peter
    * remove some unit dependencies
    * current_procinfo changes to store more info

  Revision 1.101  2003/05/16 14:32:58  peter
    * fix dup check for hiding the result varsym in localst, the result
      sym was already in the localst when adding the locals

  Revision 1.100  2003/05/15 18:58:53  peter
    * removed selfpointer_offset, vmtpointer_offset
    * tvarsym.adjusted_address
    * address in localsymtable is now in the real direction
    * removed some obsolete globals

  Revision 1.99  2003/05/13 15:17:13  peter
    * fix crash with hiding function result. The function result is now
      inserted as last so the symbol that we are going to insert is the
      result and needs to be renamed instead of the already existing
      symbol

  Revision 1.98  2003/05/11 14:45:12  peter
    * tloadnode does not support objectsymtable,withsymtable anymore
    * withnode cleanup
    * direct with rewritten to use temprefnode

  Revision 1.97  2003/04/27 11:21:34  peter
    * aktprocdef renamed to current_procinfo.procdef
    * procinfo renamed to current_procinfo
    * procinfo will now be stored in current_module so it can be
      cleaned up properly
    * gen_main_procsym changed to create_main_proc and release_main_proc
      to also generate a tprocinfo structure
    * fixed unit implicit initfinal

  Revision 1.96  2003/04/27 07:29:51  peter
    * current_procinfo.procdef cleanup, current_procdef is now always nil when parsing
      a new procdef declaration
    * aktprocsym removed
    * lexlevel removed, use symtable.symtablelevel instead
    * implicit init/final code uses the normal genentry/genexit
    * funcret state checking updated for new funcret handling

  Revision 1.95  2003/04/26 00:33:07  peter
    * vo_is_result flag added for the special RESULT symbol

  Revision 1.94  2003/04/25 20:59:35  peter
    * removed funcretn,funcretsym, function result is now in varsym
      and aliases for result and function name are added using absolutesym
    * vs_hidden parameter for funcret passed in parameter
    * vs_hidden fixes
    * writenode changed to printnode and released from extdebug
    * -vp option added to generate a tree.log with the nodetree
    * nicer printnode for statements, callnode

  Revision 1.93  2003/04/16 07:53:11  jonas
    * calculation of parameter and resultlocation offsets now depends on
      tg.direction instead of if(n)def powerpc

  Revision 1.92  2003/04/05 21:09:32  jonas
    * several ppc/generic result offset related fixes. The "normal" result
      offset seems now to be calculated correctly and a lot of duplicate
      calculations have been removed. Nested functions accessing the parent's
      function result don't work at all though :(

  Revision 1.91  2003/03/17 18:56:49  peter
    * ignore hints for default parameter values

  Revision 1.90  2003/03/17 16:54:41  peter
    * support DefaultHandler and anonymous inheritance fixed
      for message methods

  Revision 1.89  2002/12/29 14:57:50  peter
    * unit loading changed to first register units and load them
      afterwards. This is needed to support uses xxx in yyy correctly
    * unit dependency check fixed

  Revision 1.88  2002/12/27 18:07:45  peter
    * fix crashes when searching symbols

  Revision 1.87  2002/12/25 01:26:56  peter
    * duplicate procsym-unitsym fix

  Revision 1.86  2002/12/21 13:07:34  peter
    * type redefine fix for tb0437

  Revision 1.85  2002/12/07 14:27:10  carl
    * 3% memory optimization
    * changed some types
    + added type checking with different size for call node and for
       parameters

  Revision 1.84  2002/12/06 17:51:11  peter
    * merged cdecl and array fixes

  Revision 1.83  2002/11/30 11:12:48  carl
    + checking for symbols used with hint directives is done mostly in pexpr
      only now

  Revision 1.82  2002/11/29 22:31:20  carl
    + unimplemented hint directive added
    * hint directive parsing implemented
    * warning on these directives

  Revision 1.81  2002/11/27 20:04:09  peter
    * tvarsym.get_push_size replaced by paramanager.push_size

  Revision 1.80  2002/11/22 22:45:49  carl
  + small optimization for speed

  Revision 1.79  2002/11/19 16:26:33  pierre
   * correct a stabs generation problem that lead to use errordef in stabs

  Revision 1.78  2002/11/18 17:32:00  peter
    * pass proccalloption to ret_in_xxx and push_xxx functions

  Revision 1.77  2002/11/15 01:58:54  peter
    * merged changes from 1.0.7 up to 04-11
      - -V option for generating bug report tracing
      - more tracing for option parsing
      - errors for cdecl and high()
      - win32 import stabs
      - win32 records<=8 are returned in eax:edx (turned off by default)
      - heaptrc update
      - more info for temp management in .s file with EXTDEBUG

  Revision 1.76  2002/11/09 15:29:28  carl
    + bss / constant alignment fixes
    * avoid incrementing address/datasize in local symtable for const's

  Revision 1.75  2002/10/14 19:44:43  peter
    * threadvars need 4 bytes extra for storing the threadvar index

  Revision 1.74  2002/10/06 19:41:31  peter
    * Add finalization of typed consts
    * Finalization of globals in the main program

  Revision 1.73  2002/10/05 12:43:29  carl
    * fixes for Delphi 6 compilation
     (warning : Some features do not work under Delphi)

  Revision 1.72  2002/09/09 19:41:46  peter
    * real fix internalerror for dup ids in union sym

  Revision 1.71  2002/09/09 17:34:16  peter
    * tdicationary.replace added to replace and item in a dictionary. This
      is only allowed for the same name
    * varsyms are inserted in symtable before the types are parsed. This
      fixes the long standing "var longint : longint" bug
    - consume_idlist and idstringlist removed. The loops are inserted
      at the callers place and uses the symtable for duplicate id checking

  Revision 1.70  2002/09/05 19:29:45  peter
    * memdebug enhancements

  Revision 1.69  2002/08/25 19:25:21  peter
    * sym.insert_in_data removed
    * symtable.insertvardata/insertconstdata added
    * removed insert_in_data call from symtable.insert, it needs to be
      called separatly. This allows to deref the address calculation
    * procedures now calculate the parast addresses after the procedure
      directives are parsed. This fixes the cdecl parast problem
    * push_addr_param has an extra argument that specifies if cdecl is used
      or not

  Revision 1.68  2002/08/18 20:06:27  peter
    * inlining is now also allowed in interface
    * renamed write/load to ppuwrite/ppuload
    * tnode storing in ppu
    * nld,ncon,nbas are already updated for storing in ppu

  Revision 1.67  2002/08/17 09:23:43  florian
    * first part of procinfo rewrite

  Revision 1.66  2002/08/11 13:24:15  peter
    * saving of asmsymbols in ppu supported
    * asmsymbollist global is removed and moved into a new class
      tasmlibrarydata that will hold the info of a .a file which
      corresponds with a single module. Added librarydata to tmodule
      to keep the library info stored for the module. In the future the
      objectfiles will also be stored to the tasmlibrarydata class
    * all getlabel/newasmsymbol and friends are moved to the new class

  Revision 1.65  2002/07/23 09:51:27  daniel
  * Tried to make Tprocsym.defs protected. I didn't succeed but the cleanups
    are worth comitting.

  Revision 1.64  2002/07/16 15:34:21  florian
    * exit is now a syssym instead of a keyword

  Revision 1.63  2002/07/15 19:44:53  florian
    * fixed crash with default parameters and stdcall calling convention

  Revision 1.62  2002/07/01 18:46:28  peter
    * internal linker
    * reorganized aasm layer

  Revision 1.61  2002/05/18 13:34:19  peter
    * readded missing revisions

  Revision 1.60  2002/05/16 19:46:45  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.58  2002/05/12 16:53:15  peter
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

  Revision 1.57  2002/04/04 19:06:05  peter
    * removed unused units
    * use tlocation.size in cg.a_*loc*() routines

  Revision 1.56  2002/03/04 19:10:11  peter
    * removed compiler warnings

  Revision 1.55  2002/02/03 09:30:07  peter
    * more fixes for protected handling

  Revision 1.54  2002/01/29 21:30:25  peter
    * allow also dup id in delphi mode in interfaces

  Revision 1.53  2002/01/29 19:46:00  peter
    * fixed recordsymtable.insert_in() for inserting variant record fields
      to not used symtable.insert() because that also updates alignmentinfo
      which was already set

  Revision 1.52  2002/01/24 18:25:50  peter
   * implicit result variable generation for assembler routines
   * removed m_tp modeswitch, use m_tp7 or not(m_fpc) instead

}
