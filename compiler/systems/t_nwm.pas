{
    $Id$
    Copyright (c) 1998-2002 by Peter Vreman

    This unit implements support import,export,link routines
    for the (i386) Netware target

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

    Currently generating NetWare-NLM's only work under Linux and win32.
    (see http://home.arcor.de/armin.diehl/fpcnw for binutils working
    with win32) while not included in fpc-releases.

    The following compiler-swiches are supported for NetWare:
    $DESCRIPTION    : NLM-Description, will be displayed at load-time
    $M              : For Stack-Size, Heap-Size will be ignored
                      32K is the accepted minimum
    $VERSION x.x.x  : Sets Major, Minor and Revision
    $SCREENNAME     : Sets the ScreenName
    $THREADNAME     : Sets current threadname

    Displaying copyright does not work with nlmconv from gnu bunutils
    version less that 2.13

    Additional parameters for the nlmvonv-inputfile can be passed with
    -k, i.e. -kREENTRANT will add the option REENTRANT to the nlmconv
    inputfile. A ; will be converted into a newline

    Exports will be handled like in win32:
    procedure bla;
    begin
    end;

    exports foo name 'Bar';

    The path to the import-Files must be specified by the library-path.
    All external modules are defined as autoload. (Note: the import-files have
    to be in unix-format for exe2nlm)
    By default, the most import files are included in freepascal.

    i.e. Procedure ConsolePrintf (p:pchar); cdecl; external 'clib.nlm';
    sets IMPORT @clib.imp and MODULE clib.

    Function simply defined as external work without generating autoload but
    you will get a warnung from nlmconv.

    If you dont have nlmconv, compile gnu-binutils with
       ./configure --enable-targets=i386-linux,i386-netware
       make all

    Debugging is possible with gdb and a converter from gdb to ndi available
    at http://home.arcor.de/armin.diehl/gdbnw

    A sample program:

    Program Hello;
    (*$DESCRIPTION HelloWorldNlm*)
    (*$VERSION 1.2.3*)
    (*$ScreenName Hello*)
    (*$M 60000,60000*)
    begin
      writeLn ('hello world');
    end.

    compile with:
    ppc386 -Tnetware hello

    ToDo:
      - No duplicate imports and autoloads
      - libc support (needs new target)

****************************************************************************
}
unit t_nwm;

{$i fpcdefs.inc}

interface


implementation

  uses
    cutils,
    verbose,systems,globtype,globals,
    symconst,script,
    fmodule,aasmbase,aasmtai,aasmcpu,cpubase,symsym,symdef,
    import,export,link,i_nwm;

  type
    timportlibnetware=class(timportlib)
      procedure preparelib(const s:string);override;
      procedure importprocedure(aprocdef:tprocdef;const module:string;index:longint;const name:string);override;
      procedure importvariable(vs:tvarsym;const name,module:string);override;
      procedure generatelib;override;
    end;

    texportlibnetware=class(texportlib)
      procedure preparelib(const s : string);override;
      procedure exportprocedure(hp : texported_item);override;
      procedure exportvar(hp : texported_item);override;
      procedure generatelib;override;
    end;

    tlinkernetware=class(texternallinker)
    private
      NLMConvLinkFile: TLinkRes;  {for second pass, fist pass is ld}
      Function  WriteResponseFile(isdll:boolean) : Boolean;
    public
      constructor Create;override;
      procedure SetDefaultInfo;override;
      function  MakeExecutable:boolean;override;
    end;

Const tmpLinkFileName = 'link~tmp._o_';
      minStackSize = 32768;

{*****************************************************************************
                               TIMPORTLIBNETWARE
*****************************************************************************}

procedure timportlibnetware.preparelib(const s : string);
begin
end;


procedure timportlibnetware.importprocedure(aprocdef:tprocdef;const module:string;index:longint;const name:string);
begin
  { insert sharedlibrary }
  current_module.linkothersharedlibs.add(SplitName(module),link_allways);
  { do nothing with the procedure, only set the mangledname }
  if name<>'' then
   begin
     aprocdef.setmangledname(name);
   end
  else
    message(parser_e_empty_import_name);
end;


procedure timportlibnetware.importvariable(vs:tvarsym;const name,module:string);
begin
  { insert sharedlibrary }
  current_module.linkothersharedlibs.add(SplitName(module),link_allways);
  { reset the mangledname and turn off the dll_var option }
  vs.set_mangledname(name);
  exclude(vs.varoptions,vo_is_dll_var);
end;


procedure timportlibnetware.generatelib;
begin
end;


{*****************************************************************************
                               TEXPORTLIBNETWARE
*****************************************************************************}

procedure texportlibnetware.preparelib(const s:string);
begin
end;


procedure texportlibnetware.exportprocedure(hp : texported_item);
var
  hp2 : texported_item;
begin
  { first test the index value }
  if (hp.options and eo_index)<>0 then
   begin
     Comment(V_Error,'can''t export with index under netware');
     exit;
   end;
  { use pascal name is none specified }
  if (hp.options and eo_name)=0 then
    begin
       hp.name:=stringdup(hp.sym.name);
       hp.options:=hp.options or eo_name;
    end;
  { now place in correct order }
  hp2:=texported_item(current_module._exports.first);
  while assigned(hp2) and
     (hp.name^>hp2.name^) do
    hp2:=texported_item(hp2.next);
  { insert hp there !! }
  if assigned(hp2) and (hp2.name^=hp.name^) then
    begin
      { this is not allowed !! }
      Message1(parser_e_export_name_double,hp.name^);
      exit;
    end;
  if hp2=texported_item(current_module._exports.first) then
    current_module._exports.insert(hp)
  else if assigned(hp2) then
    begin
       hp.next:=hp2;
       hp.previous:=hp2.previous;
       if assigned(hp2.previous) then
         hp2.previous.next:=hp;
       hp2.previous:=hp;
    end
  else
    current_module._exports.concat(hp);
end;


procedure texportlibnetware.exportvar(hp : texported_item);
begin
  hp.is_var:=true;
  exportprocedure(hp);
end;


procedure texportlibnetware.generatelib;
var
  hp2 : texported_item;
begin
  hp2:=texported_item(current_module._exports.first);
  while assigned(hp2) do
   begin
     if (not hp2.is_var) and
        (hp2.sym.typ=procsym) then
      begin
        { the manglednames can already be the same when the procedure
          is declared with cdecl }
        if tprocsym(hp2.sym).first_procdef.mangledname<>hp2.name^ then
         begin
{$ifdef i386}
           { place jump in codesegment }
           codesegment.concat(Tai_align.Create_op(4,$90));
           codeSegment.concat(Tai_symbol.Createname_global(hp2.name^,0));
           codeSegment.concat(Taicpu.Op_sym(A_JMP,S_NO,objectlibrary.newasmsymbol(tprocsym(hp2.sym).first_procdef.mangledname)));
           codeSegment.concat(Tai_symbol_end.Createname(hp2.name^));
{$endif i386}
         end;
      end
     else
      //Comment(V_Error,'Exporting of variables is not supported under netware');
      Message1(parser_e_no_export_of_variables_for_target,'netware');
     hp2:=texported_item(hp2.next);
   end;
end;


{*****************************************************************************
                                  TLINKERNETWARE
*****************************************************************************}

Constructor TLinkerNetware.Create;
begin
  Inherited Create;
end;


procedure TLinkerNetware.SetDefaultInfo;
begin
  with Info do
   begin
     ExeCmd[1]:= 'ld -Ur -T $RES $STRIP -o $TMPOBJ';
     if source_info.system<>target_info.system Then
      ExeCmd[2]:='nlmconv -m i386nw -T$RES'
     else
      ExeCmd[2]:='nlmconv -T$RES';
   end;
end;


Function TLinkerNetware.WriteResponseFile(isdll:boolean) : Boolean;
Var
  linkres      : TLinkRes;
  i            : longint;
  s,s2,s3      : string;
  ProgNam      : string [80];
  NlmNam       : string [80];
  hp2          : texported_item;  { for exports }
  p            : byte;
begin
  WriteResponseFile:=False;

  ProgNam := current_module.exefilename^;
  i:=Pos(target_info.exeext,ProgNam);
  if i>0 then
    Delete(ProgNam,i,255);
  NlmNam := ProgNam + target_info.exeext;

  { Open link.res file }
  LinkRes:=TLinkRes.Create(outputexedir+Info.ResName);             {for ld}
  NLMConvLinkFile:=TLinkRes.Create(outputexedir+'n'+Info.ResName); {for nlmconv, written in CreateExeFile}

  p := Pos ('"', Description);
  while (p > 0) do
  begin
    delete (Description,p,1);
    p := Pos ('"', Description);
  end;
  if Description <> '' then
    NLMConvLinkFile.Add('DESCRIPTION "' + Description + '"');
  NLMConvLinkFile.Add('VERSION '+tostr(dllmajor)+','+tostr(dllminor)+','+tostr(dllrevision));

  p := Pos ('"', nwscreenname);
  while (p > 0) do
  begin
    delete (nwscreenname,p,1);
    p := Pos ('"', nwscreenname);
  end;
  p := Pos ('"', nwthreadname);
  while (p > 0) do
  begin
    delete (nwthreadname,p,1);
    p := Pos ('"', nwthreadname);
  end;
  p := Pos ('"', nwcopyright);
  while (p > 0) do
  begin
    delete (nwcopyright,p,1);
    p := Pos ('"', nwcopyright);
  end;

  if nwscreenname <> '' then
    NLMConvLinkFile.Add('SCREENNAME "' + nwscreenname + '"');
  if nwthreadname <> '' then
    NLMConvLinkFile.Add('THREADNAME "' + nwthreadname + '"');
  if nwcopyright <> '' then
    NLMConvLinkFile.Add('COPYRIGHT "' + nwcopyright + '"');

  if stacksize < minStackSize then stacksize := minStackSize;
  str (stacksize, s);
  NLMConvLinkFile.Add ('STACKSIZE '+s);
  NLMConvLinkFile.Add ('INPUT '+tmpLinkFileName);

  { add objectfiles, start with nwpre always }
  LinkRes.Add ('INPUT (');
  s2 := FindObjectFile('nwpre','',false);
  Comment (V_Debug,'adding Object File '+s2);
  LinkRes.Add (s2);

  { main objectfiles, add to linker input }
  while not ObjectFiles.Empty do
  begin
    s:=ObjectFiles.GetFirst;
    if s<>'' then
    begin
      s2 := FindObjectFile (s,'',false);
      Comment (V_Debug,'adding Object File '+s2);
      LinkRes.Add (s2);
    end;
  end;

  { output file (nlm), add to nlmconv }
  NLMConvLinkFile.Add ('OUTPUT ' + NlmNam);

  { start and stop-procedures }
  NLMConvLinkFile.Add ('START _Prelude');  { defined in rtl/netware/nwpre.as }
  NLMConvLinkFile.Add ('EXIT _Stop');                             { nwpre.as }
  NLMConvLinkFile.Add ('CHECK FPC_NW_CHECKFUNCTION');            { system.pp }

  if not (cs_link_strip in aktglobalswitches) then
  begin
    NLMConvLinkFile.Add ('DEBUG');
    Comment(V_Debug,'DEBUG');
  end;

  { Write staticlibraries, is that correct ? }
  if not StaticLibFiles.Empty then
   begin
     While not StaticLibFiles.Empty do
      begin
        S:=lower (StaticLibFiles.GetFirst);
        if s<>'' then
        begin
          {ad: that's a hack !
           whith -XX we get the .a files as static libs (in addition to the
           imported libraries}
         if (pos ('.a',s) <> 0) OR (pos ('.A', s) <> 0) then
         begin
           S2 := FindObjectFile(s,'',false);
           LinkRes.Add (S2);
           Comment(V_Debug,'adding Object File (StaticLibFiles) '+S2);
         end else
         begin
           i:=Pos(target_info.staticlibext,S);
           if i>0 then
             Delete(S,i,255);
           S := S + '.imp'; S2 := '';
           librarysearchpath.FindFile(S,S2);
           NLMConvLinkFile.Add('IMPORT @'+S2);
           Comment(V_Debug,'IMPORT @'+s2);
         end;
        end
      end;
   end;

  if not SharedLibFiles.Empty then
   begin
     While not SharedLibFiles.Empty do
      begin
        {becuase of upper/lower case mix, we may get duplicate
         names but nlmconv ignores that.
         Here we are setting the import-files for nlmconv. I.e. for
         the module clib or clib.nlm we add IMPORT @clib.imp and also
         the module clib.nlm (autoload)
         ? may it be better to set autoload's via StaticLibFiles ? }
        S:=lower (SharedLibFiles.GetFirst);
        if s<>'' then
         begin
           s2:=s;
           i:=Pos(target_info.sharedlibext,S);
           if i>0 then
             Delete(S,i,255);
           S := S + '.imp';
           librarysearchpath.FindFile(S,S3);
           NLMConvLinkFile.Add('IMPORT @'+S3);
           NLMConvLinkFile.Add('MODULE '+s2);
           Comment(V_Debug,'MODULE '+S2);
           Comment(V_Debug,'IMPORT @'+S3);
         end
      end;
   end;

  { write exports }
  hp2:=texported_item(current_module._exports.first);
  while assigned(hp2) do
   begin
     if not hp2.is_var then
      begin
        { Export the Symbol }
        Comment(V_Debug,'EXPORT '+hp2.name^);
        NLMConvLinkFile.Add ('EXPORT '+hp2.name^);
      end
     else
      { really, i think it is possible }
      Comment(V_Error,'Exporting of variables is not supported under netware');
     hp2:=texported_item(hp2.next);
   end;

{ Write and Close response for ld, response for nlmconv is in NLMConvLinkFile(not written) }
  linkres.Add (')');
  linkres.writetodisk;
  LinkRes.Free;

{ pass options from -k to nlmconv, ; is interpreted as newline }
  s := ParaLinkOptions;
  while(Length(s) > 0) and (s[1] = ' ') do
    delete (s,1,1);
  p := pos ('"',s);
  while p > 0 do
  begin
    delete (s,p,1);
    p := pos ('"',s);
  end;

  p := pos (';',s);
  while p > 0 do
  begin
    s2 := copy(s,1,p-1);
    comment (V_Debug,'adding "'+s2+'" to nlmvonv input');
    NLMConvLinkFile.Add(s2);
    delete (s,1,p);
    p := pos (';',s);
  end;
  if s <> '' then
  begin
    comment (V_Debug,'adding "'+s+'" to nlmvonv input');
    NLMConvLinkFile.Add(s);
  end;

  WriteResponseFile:=True;
end;


function TLinkerNetware.MakeExecutable:boolean;
var
  binstr,
  cmdstr   : string;
  success  : boolean;
  StripStr : string[2];
begin
  if not(cs_link_extern in aktglobalswitches) then
   Message1(exec_i_linking,current_module.exefilename^);

{ Create some replacements }
  StripStr:='';

  if (cs_link_strip in aktglobalswitches) then
   StripStr:='-s';

{ Write used files and libraries and create Headerfile for
  nlmconv in NLMConvLinkFile }
  WriteResponseFile(false);

{ Call linker, this will generate a new object file that will be passed
  to nlmconv. Otherwise we could not create nlms without debug info }
  SplitBinCmd(Info.ExeCmd[1],binstr,cmdstr);
  Replace(cmdstr,'$EXE',current_module.exefilename^);
  Replace(cmdstr,'$RES',outputexedir+Info.ResName);
  Replace(cmdstr,'$STRIP',StripStr);
  Replace(cmdstr,'$TMPOBJ',outputexedir+tmpLinkFileName);
  Comment (v_debug,'Executing '+BinStr+' '+cmdstr);
  success:=DoExec(FindUtil(BinStr),CmdStr,true,false);

  { Remove ReponseFile }
  if (success) and not(cs_link_extern in aktglobalswitches) then
    RemoveFile(outputexedir+Info.ResName);

{ Call nlmconv }
  if success then
  begin
    NLMConvLinkFile.writetodisk;
    NLMConvLinkFile.Free;
    SplitBinCmd(Info.ExeCmd[2],binstr,cmdstr);
    Replace(cmdstr,'$RES',outputexedir+'n'+Info.ResName);
    Comment (v_debug,'Executing '+BinStr+' '+cmdstr);
    success:=DoExec(FindUtil(BinStr),CmdStr,true,false);
    if (success) and not(cs_link_extern in aktglobalswitches) then
      RemoveFile(outputexedir+'n'+Info.ResName);
    {always remove the temp object file}
    RemoveFile(outputexedir+tmpLinkFileName);
  end;

  MakeExecutable:=success;   { otherwise a recursive call to link method }
end;


{*****************************************************************************
                                     Initialize
*****************************************************************************}


initialization
  RegisterExternalLinker(system_i386_netware_info,TLinkerNetware);
  RegisterImport(system_i386_netware,TImportLibNetware);
  RegisterExport(system_i386_netware,TExportLibNetware);
  RegisterTarget(system_i386_netware_info);
end.
{
  $Log$
  Revision 1.9  2003-11-11 16:46:40  marco
   * minor fix

  Revision 1.8  2003/04/27 07:29:52  peter
    * aktprocdef cleanup, aktprocdef is now always nil when parsing
      a new procdef declaration
    * aktprocsym removed
    * lexlevel removed, use symtable.symtablelevel instead
    * implicit init/final code uses the normal genentry/genexit
    * funcret state checking updated for new funcret handling

  Revision 1.7  2003/04/26 09:16:08  peter
    * .o files belonging to the unit are first searched in the same dir
      as the .ppu

  Revision 1.6  2003/03/22 14:51:27  armin
  * support -k for additional nlmvonv headeroptions, -m i386nw for win32, support -sh

  Revision 1.5  2003/03/21 22:36:42  armin
  * changed linking: now we will link all objects to a single one and call nlmconv with that one object file. This makes it possible to create nlms without debug info.

  Revision 1.4  2003/03/21 19:19:51  armin
  * search of .imp files was broken, debug only if -gg was specified

  Revision 1.3  2002/11/17 16:32:04  carl
    * memory optimization (3-4%) : cleanup of tai fields,
       cleanup of tdef and tsym fields.
    * make it work for m68k

  Revision 1.2  2002/09/09 17:34:17  peter
    * tdicationary.replace added to replace and item in a dictionary. This
      is only allowed for the same name
    * varsyms are inserted in symtable before the types are parsed. This
      fixes the long standing "var longint : longint" bug
    - consume_idlist and idstringlist removed. The loops are inserted
      at the callers place and uses the symtable for duplicate id checking

  Revision 1.1  2002/09/06 15:03:50  carl
    * moved files to systems directory

  Revision 1.30  2002/09/03 16:26:29  daniel
    * Make Tprocdef.defs protected

  Revision 1.29  2002/08/12 15:08:44  carl
    + stab register indexes for powerpc (moved from gdb to cpubase)
    + tprocessor enumeration moved to cpuinfo
    + linker in target_info is now a class
    * many many updates for m68k (will soon start to compile)
    - removed some ifdef or correct them for correct cpu

  Revision 1.28  2002/08/11 14:32:32  peter
    * renamed current_library to objectlibrary

  Revision 1.27  2002/08/11 13:24:20  peter
    * saving of asmsymbols in ppu supported
    * asmsymbollist global is removed and moved into a new class
      tasmlibrarydata that will hold the info of a .a file which
      corresponds with a single module. Added librarydata to tmodule
      to keep the library info stored for the module. In the future the
      objectfiles will also be stored to the tasmlibrarydata class
    * all getlabel/newasmsymbol and friends are moved to the new class

  Revision 1.26  2002/07/26 21:15:46  florian
    * rewrote the system handling

  Revision 1.25  2002/07/01 18:46:35  peter
    * internal linker
    * reorganized aasm layer

  Revision 1.24  2002/05/18 13:34:27  peter
    * readded missing revisions

  Revision 1.23  2002/05/16 19:46:53  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.21  2002/04/22 18:19:22  carl
  - remove use_bound_instruction field

  Revision 1.20  2002/04/20 21:43:18  carl
  * fix stack size for some targets
  + add offset to parameters from frame pointer info.
  - remove some unused stuff

  Revision 1.19  2002/04/19 15:46:05  peter
    * mangledname rewrite, tprocdef.mangledname is now created dynamicly
      in most cases and not written to the ppu
    * add mangeledname_prefix() routine to generate the prefix of
      manglednames depending on the current procedure, object and module
    * removed static procprefix since the mangledname is now build only
      on demand from tprocdef.mangledname

  Revision 1.18  2002/04/15 19:16:57  carl
  - remove size_of_pointer field

  Revision 1.17  2002/03/30 09:09:47  armin
  + support check-function for netware

  Revision 1.16  2002/03/29 17:19:51  armin
  + allow exports for netware

  Revision 1.15  2002/03/19 20:23:57  armin
  + smart linking now works with netware

  Revision 1.14  2002/03/04 17:54:59  peter
    * allow oridinal labels again

  Revision 1.13  2002/03/03 13:00:39  hajny
    * importprocedure fix by Armin Diehl

}
