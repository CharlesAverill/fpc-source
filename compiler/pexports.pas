{
    $Id$
    Copyright (c) 1998 by Florian Klaempfl

    This unit handles the exports parsing

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
unit pexports;

  interface

    { reads an exports statement in a library }
    procedure read_exports;

  implementation

    uses
      globtype,systems,tokens,
      strings,cobjects,globals,verbose,
      scanner,symconst,symtable,pbase,
      export,GenDef;

    procedure read_exports;

      var
         hp : pexported_item;
         code : integer;
         DefString:string;
         ProcName:string;
         InternalProcName:string;
      begin
         DefString:='';
         InternalProcName:='';
         consume(_EXPORTS);
         while true do
           begin
              hp:=new(pexported_item,init);
              if token=_ID then
                begin
                   getsym(pattern,true);
                   if srsym^.typ=unitsym then
                     begin
                        consume(_ID);
                        consume(_POINT);
                        getsymonlyin(punitsym(srsym)^.unitsymtable,pattern);
                     end;
                   consume(_ID);
                   if assigned(srsym) then
                     begin
                        hp^.sym:=srsym;
                        if ((srsym^.typ<>procsym) or
                            not(po_exports in pprocdef(pprocsym(srsym)^.definition)^.procoptions)) and
                           (srsym^.typ<>varsym) and (srsym^.typ<>typedconstsym) then
                         Message(parser_e_illegal_symbol_exported)
                        else
                         begin
                          ProcName:=hp^.sym^.name;
                          InternalProcName:=hp^.sym^.mangledname;
                          delete(InternalProcName,1,1);
                          DefString:=ProcName+'='+InternalProcName;
                         end;
                        if (idtoken=_INDEX) then
                          begin
                             consume(_INDEX);
                             hp^.options:=hp^.options or eo_index;
                             val(pattern,hp^.index,code);
                             consume(_INTCONST);
                             DefString:=ProcName+'='+InternalProcName;{Index ignored!}
                             (* DefString:=ProcName+'@'+pattern+'='+InternalProcName;{Index ignored!} *)
                          end;
                        if (idtoken=_NAME) then
                          begin
                             consume(_NAME);
                             hp^.name:=stringdup(pattern);
                             hp^.options:=hp^.options or eo_name;
                             consume(_CSTRING); {Bug fixed?}
                             DefString:=hp^.name^+'='+InternalProcName;
                          end;
                        if (idtoken=_RESIDENT) then
                          begin
                             consume(_RESIDENT);
                             hp^.options:=hp^.options or eo_resident;
                             DefString:=ProcName+'='+InternalProcName;{Resident ignored!}
                          end;
                        if DefString<>''then
                         DefFile.AddExport(DefString);
                        if srsym^.typ=procsym then
                          exportlib^.exportprocedure(hp)
                        else
                          begin
                             exportlib^.exportvar(hp);
                          end;
                     end;
                end
              else
                consume(_ID);
              if token=_COMMA then
                consume(_COMMA)
              else
                break;
           end;
         consume(_SEMICOLON);
        if not DefFile.empty then
         DefFile.writefile;
      end;

end.

{
  $Log$
  Revision 1.12  1999-08-10 12:51:19  pierre
    * bind_win32_dll removed (Relocsection used instead)
    * now relocsection is true by default ! (needs dlltool
      for DLL generation)

  Revision 1.11  1999/08/04 13:02:54  jonas
    * all tokens now start with an underscore
    * PowerPC compiles!!

  Revision 1.10  1999/08/03 22:02:58  peter
    * moved bitmask constants to sets
    * some other type/const renamings

  Revision 1.9  1999/05/04 21:44:56  florian
    * changes to compile it with Delphi 4.0

  Revision 1.8  1999/03/26 00:05:35  peter
    * released valintern
    + deffile is now removed when compiling is finished
    * ^( compiles now correct
    + static directive
    * shrd fixed

  Revision 1.7  1999/02/22 02:44:12  peter
    * ag386bin doesn't use i386.pas anymore

  Revision 1.6  1998/12/11 00:03:31  peter
    + globtype,tokens,version unit splitted from globals

  Revision 1.5  1998/11/30 13:26:25  pierre
    * the code for ordering the exported procs/vars was buggy
    + added -WB to force binding (Ozerski way of creating DLL)
      this is off by default as direct writing of .edata section seems
      OK

  Revision 1.4  1998/11/30 09:43:21  pierre
    * some range check bugs fixed (still not working !)
    + added DLL writing support for win32 (also accepts variables)
    + TempAnsi for code that could be used for Temporary ansi strings
      handling

  Revision 1.3  1998/10/29 11:35:51  florian
    * some dll support for win32
    * fixed assembler writing for PalmOS

  Revision 1.2  1998/09/26 17:45:35  peter
    + idtoken and only one token table

}
