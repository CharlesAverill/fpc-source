{
    $Id$
    Copyright (c) 1998-2000 by Peter Vreman

    This unit implements support import,export,link routines
    for the (i386) BeOS target.

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
unit t_beos;

{$i defines.inc}

interface

  uses
    import,export,link;

  type
    timportlibbeos=class(timportlib)
      procedure preparelib(const s:string);override;
      procedure importprocedure(const func,module:string;index:longint;const name:string);override;
      procedure importvariable(const varname,module:string;const name:string);override;
      procedure generatelib;override;
    end;

    texportlibbeos=class(texportlib)
      procedure preparelib(const s : string);override;
      procedure exportprocedure(hp : texported_item);override;
      procedure exportvar(hp : texported_item);override;
      procedure generatelib;override;
    end;

    tlinkerbeos=class(tlinker)
    private
      Function  WriteResponseFile(isdll:boolean;makelib:boolean) : Boolean;
    public
      constructor Create;override;
      procedure SetDefaultInfo;override;
      function  MakeExecutable:boolean;override;
      function  MakeSharedLibrary:boolean;override;
    end;


implementation

  uses
    dos,
    cutils,cclasses,
    verbose,systems,globtype,globals,
    symconst,script,
    fmodule,aasm,cpuasm,cpubase,symsym;

{*****************************************************************************
                               TIMPORTLIBBEOS
*****************************************************************************}

procedure timportlibbeos.preparelib(const s : string);
begin
end;


procedure timportlibbeos.importprocedure(const func,module : string;index : longint;const name : string);
begin
  { insert sharedlibrary }
  current_module.linkothersharedlibs.add(SplitName(module),link_allways);
  { do nothing with the procedure, only set the mangledname }
  if name<>'' then
    aktprocsym.definition.setmangledname(name)
  else
    message(parser_e_empty_import_name);
end;


procedure timportlibbeos.importvariable(const varname,module:string;const name:string);
begin
  { insert sharedlibrary }
  current_module.linkothersharedlibs.add(SplitName(module),link_allways);
  { reset the mangledname and turn off the dll_var option }
  aktvarsym.setmangledname(name);
  exclude(aktvarsym.varoptions,vo_is_dll_var);
end;


procedure timportlibbeos.generatelib;
begin
end;


{*****************************************************************************
                               TEXPORTLIBBEOS
*****************************************************************************}

procedure texportlibbeos.preparelib(const s:string);
begin
end;


procedure texportlibbeos.exportprocedure(hp : texported_item);
var
  hp2 : texported_item;
begin
  { first test the index value }
  if (hp.options and eo_index)<>0 then
   begin
     Message1(parser_e_no_export_with_index_for_target,'beos');
     exit;
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
    current_module._exports.concat(hp)
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


procedure texportlibbeos.exportvar(hp : texported_item);
begin
  hp.is_var:=true;
  exportprocedure(hp);
end;


procedure texportlibbeos.generatelib;
var
  hp2 : texported_item;
begin
  hp2:=texported_item(current_module._exports.first);
  while assigned(hp2) do
   begin
     if not hp2.is_var then
      begin
{$ifdef i386}
        { place jump in codesegment }
        codesegment.concat(Tai_align.Create_op(4,$90));
        codeSegment.concat(Tai_symbol.Createname_global(hp2.name^,0));
        codeSegment.concat(Taicpu.Op_sym(A_JMP,S_NO,newasmsymbol(hp2.sym.mangledname)));
        codeSegment.concat(Tai_symbol_end.Createname(hp2.name^));
{$endif i386}
      end
     else
      Message1(parser_e_no_export_of_variables_for_target,'beos');
     hp2:=texported_item(hp2.next);
   end;
end;


{*****************************************************************************
                                  TLINKERBEOS
*****************************************************************************}

Constructor TLinkerBeos.Create;
begin
  Inherited Create;
  LibrarySearchPath.AddPath(GetEnv('BELIBRARIES'),true); {format:'path1;path2;...'}
end;


procedure TLinkerBeOS.SetDefaultInfo;
begin
  with Info do
   begin
     ExeCmd[1]:='sh $RES $EXE $OPT $STATIC $STRIP -L.';
{     ExeCmd[1]:='sh $RES $EXE $OPT $DYNLINK $STATIC $STRIP -L.';}
      DllCmd[1]:='sh $RES $EXE $OPT -L.';

{     DllCmd[1]:='sh $RES $EXE $OPT -L. -g -nostart -soname=$EXE';
 }    DllCmd[2]:='strip --strip-unneeded $EXE';
{     DynamicLinker:='/lib/ld-beos.so.2';}
   end;
end;


function TLinkerBeOS.WriteResponseFile(isdll:boolean;makelib:boolean) : Boolean;
Var
  linkres  : TLinkRes;
  i        : integer;
  cprtobj,
  prtobj   : string[80];
  HPath    : TStringListItem;
  s        : string;
  linklibc : boolean;
begin
  WriteResponseFile:=False;
{ set special options for some targets }
  linklibc:=(SharedLibFiles.Find('root')<>nil);

  prtobj:='prt0';
  cprtobj:='cprt0';
  if (cs_profile in aktmoduleswitches) or
     (not SharedLibFiles.Empty) then
   begin
     AddSharedLibrary('root');
     linklibc:=true;
   end;

  if (not linklibc) and makelib then
   begin
     linklibc:=true;
     cprtobj:='dllprt.o';
   end;

  if linklibc then
   prtobj:=cprtobj;

  { Open link.res file }
  LinkRes:=TLinkRes.Create(outputexedir+Info.ResName);

  if not isdll then
   LinkRes.Add('ld -o $1 $2 $3 $4 $5 $6 $7 $8 $9 \')
  else
   LinkRes.Add('ld -o $1 -e 0 $2 $3 $4 $5 $6 $7 $8 $9\');

  LinkRes.Add('-m elf_i386_be -shared -Bsymbolic \');

  { Write path to search libraries }
  HPath:=TStringListItem(current_module.locallibrarysearchpath.First);
  while assigned(HPath) do
   begin
     LinkRes.Add('-L'+HPath.Str+' \');
     HPath:=TStringListItem(HPath.Next);
   end;
  HPath:=TStringListItem(LibrarySearchPath.First);
  while assigned(HPath) do
   begin
     LinkRes.Add('-L'+HPath.Str+' \');
     HPath:=TStringListItem(HPath.Next);
   end;

  { try to add crti and crtbegin if linking to C }
  if linklibc then
   begin
     if librarysearchpath.FindFile('crti.o',s) then
      LinkRes.AddFileName(s+' \');
     if librarysearchpath.FindFile('crtbegin.o',s) then
      LinkRes.AddFileName(s+' \');
{      s:=librarysearchpath.FindFile('start_dyn.o',found)+'start_dyn.o';
     if found then LinkRes.AddFileName(s+' \');}

     if prtobj<>'' then
      LinkRes.AddFileName(FindObjectFile(prtobj,'')+' \');

     if isdll then
      LinkRes.AddFileName(FindObjectFile('func.o','')+' \');

     if librarysearchpath.FindFile('init_term_dyn.o',s) then
      LinkRes.AddFileName(s+' \');
   end
  else
   begin
     if prtobj<>'' then
      LinkRes.AddFileName(FindObjectFile(prtobj,'')+' \');
   end;

  { main objectfiles }
  while not ObjectFiles.Empty do
   begin
     s:=ObjectFiles.GetFirst;
     if s<>'' then
      LinkRes.AddFileName(s+' \');
   end;

{  LinkRes.Add('-lroot \');
  LinkRes.Add('/boot/develop/tools/gnupro/lib/gcc-lib/i586-beos/2.9-beos-991026/crtend.o \');
  LinkRes.Add('/boot/develop/lib/x86/crtn.o \');}

  { Write staticlibraries }
  if not StaticLibFiles.Empty then
   begin
     While not StaticLibFiles.Empty do
      begin
        S:=StaticLibFiles.GetFirst;
        LinkRes.AddFileName(s+' \')
      end;
   end;

  { Write sharedlibraries like -l<lib> }
  if not SharedLibFiles.Empty then
   begin
     While not SharedLibFiles.Empty do
      begin
        S:=SharedLibFiles.GetFirst;
        if s<>'c' then
         begin
           i:=Pos(target_info.sharedlibext,S);
           if i>0 then
            Delete(S,i,255);
           LinkRes.Add('-l'+s+' \');
         end
        else
         begin
           linklibc:=true;
         end;
      end;
     { be sure that libc is the last lib }
{     if linklibc then
       LinkRes.Add('-lroot');}
{     if linkdynamic and (Info.DynamicLinker<>'') then
       LinkRes.AddFileName(Info.DynamicLinker);}
   end;
  if isdll then
   LinkRes.Add('-lroot \');

  { objects which must be at the end }
  if linklibc then
   begin
     if librarysearchpath.FindFile('crtend.o',s) then
      LinkRes.AddFileName(s+' \');
     if librarysearchpath.FindFile('crtn.o',s) then
      LinkRes.AddFileName(s+' \');
   end;

{ Write and Close response }
  linkres.Add(' ');
  linkres.writetodisk;
  linkres.free;

  WriteResponseFile:=True;
end;


function TLinkerBeOS.MakeExecutable:boolean;
var
  binstr,
  cmdstr  : string;
  success : boolean;
{  DynLinkStr : string[60];}
  StaticStr,
  StripStr   : string[40];
begin
  if not(cs_link_extern in aktglobalswitches) then
   Message1(exec_i_linking,current_module.exefilename^);

{ Create some replacements }
  StaticStr:='';
  StripStr:='';
{  DynLinkStr:='';}
  if (cs_link_staticflag in aktglobalswitches) then
   StaticStr:='-static';
  if (cs_link_strip in aktglobalswitches) then
   StripStr:='-s';
{  If (cs_profile in aktmoduleswitches) or
     ((Info.DynamicLinker<>'') and (not SharedLibFiles.Empty)) then
   DynLinkStr:='-dynamic-linker='+Info.DynamicLinker;}

{ Write used files and libraries }
  WriteResponseFile(false,false);

{ Call linker }
  SplitBinCmd(Info.ExeCmd[1],binstr,cmdstr);
  Replace(cmdstr,'$EXE',current_module.exefilename^);
  Replace(cmdstr,'$OPT',Info.ExtraOptions);
  Replace(cmdstr,'$RES',outputexedir+Info.ResName);
  Replace(cmdstr,'$STATIC',StaticStr);
  Replace(cmdstr,'$STRIP',StripStr);
{  Replace(cmdstr,'$DYNLINK',DynLinkStr);}
  success:=DoExec(FindUtil(BinStr),CmdStr,true,false);

{ Remove ReponseFile }
  if (success) and not(cs_link_extern in aktglobalswitches) then
   RemoveFile(outputexedir+Info.ResName);

  MakeExecutable:=success;   { otherwise a recursive call to link method }
end;


Function TLinkerBeOS.MakeSharedLibrary:boolean;
var
  binstr,
  cmdstr  : string;
  success : boolean;
begin
  MakeSharedLibrary:=false;
  if not(cs_link_extern in aktglobalswitches) then
   Message1(exec_i_linking,current_module.sharedlibfilename^);

{ Write used files and libraries }
  WriteResponseFile(true,true);

{ Call linker }
  SplitBinCmd(Info.DllCmd[1],binstr,cmdstr);
  Replace(cmdstr,'$EXE',current_module.sharedlibfilename^);
  Replace(cmdstr,'$OPT',Info.ExtraOptions);
  Replace(cmdstr,'$RES',outputexedir+Info.ResName);
  success:=DoExec(FindUtil(binstr),cmdstr,true,false);

{ Strip the library ? }
  if success and (cs_link_strip in aktglobalswitches) then
   begin
     SplitBinCmd(Info.DllCmd[2],binstr,cmdstr);
     Replace(cmdstr,'$EXE',current_module.sharedlibfilename^);
     success:=DoExec(FindUtil(binstr),cmdstr,true,false);
   end;

{ Remove ReponseFile }
  if (success) and not(cs_link_extern in aktglobalswitches) then
   RemoveFile(outputexedir+Info.ResName);

  MakeSharedLibrary:=success;   { otherwise a recursive call to link method }
end;


{*****************************************************************************
                                  Initialize
*****************************************************************************}

{$ifdef i386}
    const
       target_i386_beos_info : ttargetinfo =
          (
            target       : target_i386_BeOS;
            name         : 'Beos for i386';
            shortname    : 'Beos';
            flags        : [tf_under_development];
            cpu          : i386;
            unit_env     : 'BEOSUNITS';
            extradefines : '';
            sharedlibext : '.so';
            staticlibext : '.a';
            sourceext    : '.pp';
            pasext       : '.pas';
            exeext       : '';
            defext       : '.def';
            scriptext    : '.sh';
            smartext     : '.sl';
            unitext      : '.ppu';
            unitlibext   : '.ppl';
            asmext       : '.s';
            objext       : '.o';
            resext       : '.res';
            resobjext    : '.or';
            staticlibprefix : 'libp';
            sharedlibprefix : 'lib';
            Cprefix      : '';
            newline      : #10;
            dirsep       : '/';
            files_case_relevent : true;
            assem        : as_i386_as;
            assemextern  : as_i386_as;
            link         : ld_i386_beos;
            linkextern   : ld_i386_beos;
            ar           : ar_gnu_ar;
            res          : res_none;
            script       : script_unix;
            endian       : endian_little;
            alignment    :
              (
                procalign       : 4;
                loopalign       : 4;
                jumpalign       : 0;
                constalignmin   : 0;
                constalignmax   : 1;
                varalignmin     : 0;
                varalignmax     : 1;
                localalignmin   : 0;
                localalignmax   : 1;
                paraalign       : 4;
                recordalignmin  : 0;
                recordalignmax  : 2;
                maxCrecordalign : 4
              );
            size_of_pointer : 4;
            size_of_longint : 4;
            heapsize     : 256*1024;
            maxheapsize  : 32768*1024;
            stacksize    : 8192;
            DllScanSupported:false;
            use_bound_instruction : false;
            use_function_relative_addresses : true
          );
{$endif i386}

initialization
{$ifdef i386}
  RegisterLinker(ld_i386_beos,TLinkerbeos);
  RegisterImport(target_i386_beos,timportlibbeos);
  RegisterExport(target_i386_beos,texportlibbeos);
  RegisterTarget(target_i386_beos_info);
{$endif i386}
end.
{
  $Log$
  Revision 1.7  2001-09-17 21:29:15  peter
    * merged netbsd, fpu-overflow from fixes branch

  Revision 1.6  2001/08/12 17:57:07  peter
    * under development flag for targets

  Revision 1.5  2001/08/07 18:47:15  peter
    * merged netbsd start
    * profile for win32

  Revision 1.4  2001/07/01 20:16:20  peter
    * alignmentinfo record added
    * -Oa argument supports more alignment settings that can be specified
      per type: PROC,LOOP,VARMIN,VARMAX,CONSTMIN,CONSTMAX,RECORDMIN
      RECORDMAX,LOCALMIN,LOCALMAX. It is possible to set the mimimum
      required alignment and the maximum usefull alignment. The final
      alignment will be choosen per variable size dependent on these
      settings

  Revision 1.3  2001/06/28 19:46:25  peter
    * added override and virtual for constructors

  Revision 1.2  2001/06/03 15:15:31  peter
    * dllprt0 stub for linux shared libs
    * pass -init and -fini for linux shared libs
    * libprefix splitted into staticlibprefix and sharedlibprefix

  Revision 1.1  2001/06/02 19:29:37  peter
    * beos target

}
