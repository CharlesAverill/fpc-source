{
    $Id$
    Copyright (c) 1998-2002 by the FPC Development Team

    Dumps the contents of a FPC unit file (PPU File)

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

 ****************************************************************************}
{$ifdef TP}
  {$N+,E+}
{$endif}
program pppdump;
uses
  dos,
  ppu;

const
  Version   = 'Version 1.10';
  Title     = 'PPU-Analyser';
  Copyright = 'Copyright (c) 1998-2003 by the Free Pascal Development Team';

{ verbosity }
  v_none           = $0;
  v_header         = $1;
  v_defs           = $2;
  v_syms           = $4;
  v_interface      = $8;
  v_implementation = $10;
  v_browser        = $20;
  v_all            = $ff;

type
  tprocinfoflag=(
    {# procedure uses asm }
    pi_uses_asm,
    {# procedure does a call }
    pi_do_call,
    {# procedure has a try statement = no register optimization }
    pi_uses_exceptions,
    {# procedure is declared as @var(assembler), don't optimize}
    pi_is_assembler,
    {# procedure contains data which needs to be finalized }
    pi_needs_implicit_finally
  );
  tprocinfoflags=set of tprocinfoflag;

  { Copied from systems.pas }
  ttargetcpu=
  (
        no_cpu,                   { 0 }
        i386,                     { 1 }
        m68k,                     { 2 }
        alpha,                    { 3 }
        powerpc,                  { 4 }
        sparc,                    { 5 }
        vm                        { 6 }
  );

var
  ppufile     : tppufile;
  space       : string;
  unitnumber,
  unitindex   : longint;
  verbose     : longint;
  derefdata   : pbyte;
  derefdatalen : longint;

{****************************************************************************
                          Helper Routines
****************************************************************************}

const has_errors : boolean = false;
Procedure Error(const S : string);
Begin
   Writeln(S);
   has_errors:=true;
End;

Function Target2Str(w:longint):string;
type
       { taken from systems.pas }
       ttarget =
       (
             target_none,               { 0 }
             target_i386_GO32V1,        { 1 }
             target_i386_GO32V2,        { 2 }
             target_i386_linux,         { 3 }
             target_i386_OS2,           { 4 }
             target_i386_Win32,         { 5 }
             target_i386_freebsd,       { 6 }
             target_m68k_Amiga,         { 7 }
             target_m68k_Atari,         { 8 }
             target_m68k_Mac,           { 9 }
             target_m68k_linux,         { 10 }
             target_m68k_PalmOS,        { 11 }
             target_alpha_linux,        { 12 }
             target_powerpc_linux,      { 13 }
             target_powerpc_macos,      { 14 }
             target_i386_sunos,         { 15 }
             target_i386_beos,          { 16 }
             target_i386_netbsd,        { 17 }
             target_m68k_netbsd,        { 18 }
             target_i386_Netware,       { 19 }
             target_i386_qnx,           { 20 }
             target_i386_wdosx,         { 21 }
             target_sparc_sunos,        { 22 }
             target_sparc_linux,        { 23 }
             target_i386_openbsd,       { 24 }
             target_m68k_openbsd,       { 25 }
             system_x86_64_linux,       { 26 }
             system_powerpc_macosx,     { 27 }
             target_i386_emx            { 28 }
       );
const
  Targets : array[ttarget] of string[16]=(
  { 0 }   'none',
  { 1 }   'GO32V1',
  { 2 }   'GO32V2',
  { 3 }   'Linux-i386',
  { 4 }   'OS/2',
  { 5 }   'Win32',
  { 6 }   'FreeBSD-i386',
  { 7 }   'Amiga',
  { 8 }   'Atari',
  { 9 }   'MacOS-m68k',
  { 10 }  'Linux-m68k',
  { 11 }  'PalmOS-m68k',
  { 12 }  'Linux-alpha',
  { 13 }  'Linux-ppc',
  { 14 }  'MacOS-ppc',
  { 15 }  'Solaris-i386',
  { 16 }  'BeOS-i386',
  { 17 }  'NetBSD-i386',
  { 18 }  'NetBSD-m68k',
  { 19 }  'Netware',
  { 20 }  'Qnx-i386',
  { 21 }  'WDOSX-i386',
  { 22 }  'Solaris-sparc',
  { 23 }  'Linux-sparc',
  { 24 }  'OpenBSD-i386',
  { 25 }  'OpenBSD-m68k',
  { 26 }  'Linux-x86-64',
  { 27 }  'MacOSX-ppc',
  { 28 }  'OS/2 via EMX'
  );
begin
  if w<=ord(high(ttarget)) then
    Target2Str:=Targets[ttarget(w)]
  else
    Target2Str:='<Unknown>';
end;


Function Cpu2Str(w:longint):string;
const
  CpuTxt : array[ttargetcpu] of string[7]=
    ('none','i386','m68k','alpha','powerpc','sparc','vis');
begin
  if w<=ord(high(ttargetcpu)) then
    Cpu2Str:=CpuTxt[ttargetcpu(w)]
  else
    Cpu2Str:='<Unknown>';
end;


Function Varspez2Str(w:longint):string;
const
  varspezstr : array[0..4] of string[6]=('Value','Const','Var','Out','Hidden');
begin
  if w<=ord(high(varspezstr)) then
    Varspez2Str:=varspezstr[w]
  else
    Varspez2Str:='<Unknown>';
end;


function PPUFlags2Str(flags:longint):string;
type
  tflagopt=record
    mask : longint;
    str  : string[30];
  end;
const
  flagopts=16;
  flagopt : array[1..flagopts] of tflagopt=(
    (mask: $1    ;str:'init'),
    (mask: $2    ;str:'final'),
    (mask: $4    ;str:'big_endian'),
    (mask: $8    ;str:'dbx'),
    (mask: $10   ;str:'browser'),
    (mask: $20   ;str:'in_library'),
    (mask: $40   ;str:'smart_linked'),
    (mask: $80   ;str:'static_linked'),
    (mask: $100  ;str:'shared_linked'),
    (mask: $200  ;str:'local_browser'),
    (mask: $400  ;str:'no_link'),
    (mask: $800  ;str:'has_resources'),
    (mask: $1000  ;str:'little_endian'),
    (mask: $2000  ;str:'release'),
    (mask: $4000  ;str:'local_threadvars'),
    (mask: $8000  ;str:'fpu emulation on')
  );
var
  i : longint;
  first  : boolean;
  s : string;
begin
  s:='';
  if flags<>0 then
   begin
     first:=true;
     for i:=1to flagopts do
      if (flags and flagopt[i].mask)<>0 then
       begin
         if first then
           first:=false
         else
           s:=s+', ';
         s:=s+flagopt[i].str;
       end;
   end
  else
   s:='none';
  PPUFlags2Str:=s;
end;


const
  HexTbl : array[0..15] of char='0123456789ABCDEF';
function HexB(b:byte):string;
begin
  HexB[0]:=#2;
  HexB[1]:=HexTbl[b shr 4];
  HexB[2]:=HexTbl[b and $f];
end;


function hexstr(val : cardinal;cnt : byte) : string;
const
  HexTbl : array[0..15] of char='0123456789ABCDEF';
var
  i : longint;
begin
  hexstr[0]:=char(cnt);
  for i:=cnt downto 1 do
   begin
     hexstr[i]:=hextbl[val and $f];
     val:=val shr 4;
   end;
end;


    Function L0(l:longint):string;
    {
      return the string of value l, if l<10 then insert a zero, so
      the string is always at least 2 chars '01','02',etc
    }
      var
        s : string;
      begin
        Str(l,s);
        if l<10 then
         s:='0'+s;
        L0:=s;
      end;


   function  filetimestring( t : longint) : string;
   {
     convert dos datetime t to a string YY/MM/DD HH:MM:SS
   }
     var
       DT : DateTime;
     begin
       if t=-1 then
        begin
          FileTimeString:='Not Found';
          exit;
        end;
       unpacktime(t,DT);
       filetimestring:=L0(dt.Year)+'/'+L0(dt.Month)+'/'+L0(dt.Day)+' '+L0(dt.Hour)+':'+L0(dt.min)+':'+L0(dt.sec);
     end;


{****************************************************************************
                             Read Routines
****************************************************************************}

Procedure ReadLinkContainer(const prefix:string);
{
  Read a serie of strings and write to the screen starting every line
  with prefix
}
  function maskstr(m:longint):string;
  const
    { link options }
    link_none    = $0;
    link_allways = $1;
    link_static  = $2;
    link_smart   = $4;
    link_shared  = $8;
  var
    s : string;
  begin
    s:='';
    if (m and link_allways)<>0 then
     s:=s+'always ';
    if (m and link_static)<>0 then
     s:=s+'static ';
    if (m and link_smart)<>0 then
     s:=s+'smart ';
    if (m and link_shared)<>0 then
     s:=s+'shared ';
    maskstr:=s;
  end;

var
  s : string;
  m : longint;
begin
  while not ppufile.endofentry do
   begin
     s:=ppufile.getstring;
     m:=ppufile.getlongint;
     WriteLn(prefix,s,' (',maskstr(m),')');
   end;
end;


Procedure ReadContainer(const prefix:string);
{
  Read a serie of strings and write to the screen starting every line
  with prefix
}
begin
  while not ppufile.endofentry do
   WriteLn(prefix,ppufile.getstring);
end;


procedure ReadLoadUnit;
var
  ucrc,uintfcrc : longint;
begin
  while not ppufile.EndOfEntry do
    begin
      inc(unitnumber);
      write('Uses unit: ',ppufile.getstring,' (Number: ',unitnumber,')');
      ucrc:=ppufile.getlongint;
      uintfcrc:=ppufile.getlongint;
      writeln(' (Crc: ',hexstr(ucrc,8),', IntfcCrc: ',hexstr(uintfcrc,8),')');
    end;
end;


Procedure ReadDerefdata;
begin
  derefdatalen:=ppufile.entrysize;
  if derefdatalen=0 then
    begin
      writeln('!! Error: derefdatalen=0');
      exit;
    end;
  Writeln('Derefdata length: ',derefdatalen);
  derefdata:=allocmem(derefdatalen);
  ppufile.getdata(derefdata^,derefdatalen);
end;


Procedure ReadRef;
begin
  if (verbose and v_browser)=0 then
   exit;
  while (not ppufile.endofentry) and (not ppufile.error) do
   Writeln(space,'        - Refered : ',ppufile.getword,', (',ppufile.getlongint,',',ppufile.getword,')');
end;


Procedure ReadAsmSymbols;
type
  { Copied from aasmbase.pas }
  TAsmsymbind=(AB_NONE,AB_EXTERNAL,AB_COMMON,AB_LOCAL,AB_GLOBAL);
  TAsmsymtype=(AT_NONE,AT_FUNCTION,AT_DATA,AT_SECTION);
var
  s,
  bindstr,
  typestr  : string;
  i : longint;
begin
  writeln(space,'Number of AsmSymbols: ',ppufile.getlongint);
  i:=0;
  while (not ppufile.endofentry) and (not ppufile.error) do
   begin
     s:=ppufile.getstring;
     case tasmsymbind(ppufile.getbyte) of
       AB_EXTERNAL :
         bindstr:='External';
       AB_COMMON :
         bindstr:='Common';
       AB_LOCAL :
         bindstr:='Local';
       AB_GLOBAL :
         bindstr:='Global';
       else
         bindstr:='<Error !!>'
     end;
     case tasmsymtype(ppufile.getbyte) of
       AT_FUNCTION :
         typestr:='Function';
       AT_DATA :
         typestr:='Data';
       AT_SECTION :
         typestr:='Section';
       else
         typestr:='<Error !!>'
     end;
     Writeln(space,'  ',i,' : ',s,' [',bindstr,',',typestr,']');
     inc(i);
   end;
end;


Procedure ReadPosInfo;
var
  info : byte;
  fileindex,line,column : longint;
begin
  with ppufile do
   begin
     {
       info byte layout in bits:
       0-1 - amount of bytes for fileindex
       2-3 - amount of bytes for line
       4-5 - amount of bytes for column
     }
     info:=getbyte;
     case (info and $03) of
      0 : fileindex:=getbyte;
      1 : fileindex:=getword;
      2 : fileindex:=(getbyte shl 16) or getword;
      3 : fileindex:=getlongint;
     end;
     case ((info shr 2) and $03) of
      0 : line:=getbyte;
      1 : line:=getword;
      2 : line:=(getbyte shl 16) or getword;
      3 : line:=getlongint;
     end;
     case ((info shr 4) and $03) of
      0 : column:=getbyte;
      1 : column:=getword;
      2 : column:=(getbyte shl 16) or getword;
      3 : column:=getlongint;
     end;
     Writeln(fileindex,' (',line,',',column,')');
   end;
end;


procedure readderef;
type
  tdereftype = (deref_nil,
    deref_sym,
    deref_def,
    deref_aktrecord,
    deref_aktstatic,
    deref_aktglobal,
    deref_aktlocal,
    deref_aktpara,
    deref_unit,
    deref_record,
    deref_local,
    deref_para,
    deref_parent_object
  );
var
  b : tdereftype;
  first : boolean;
  idx : word;
  i,n : byte;
  pdata : pbyte;
begin
  if not assigned(derefdata) then
    exit;
  first:=true;
  idx:=ppufile.getlongint;
  if (idx>derefdatalen) then
    begin
      writeln('!! Error: Deref idx ',idx,' > ',derefdatalen);
      exit;
    end;
  write('(',idx,') ');
  pdata:=@derefdata[idx];
  i:=0;
  n:=pdata[i];
  inc(i);
  if n<1 then
    begin
      writeln('!! Error: Deref len < 1');
      exit;
    end;
  while (i<n) do
   begin
     if not first then
      write(', ')
     else
      first:=false;
     b:=tdereftype(pdata[i]);
     inc(i);
     case b of
       deref_nil :
         write('Nil');
       deref_def :
         begin
           idx:=pdata[i] shl 8;
           idx:=idx or pdata[i+1];
           inc(i,2);
           write('Definition ',idx);
         end;
       deref_sym :
         begin
           idx:=pdata[i] shl 8;
           idx:=idx or pdata[i+1];
           inc(i,2);
           write('Symbol ',idx);
         end;
       deref_aktrecord :
         write('AktRecord');
       deref_aktstatic :
         write('AktStatic');
       deref_aktglobal :
         write('AktGlobal');
       deref_aktlocal :
         write('AktLocal');
       deref_aktpara :
         write('AktPara');
       deref_unit :
         begin
           idx:=pdata[i] shl 8;
           idx:=idx or pdata[i+1];
           inc(i,2);
           write('Unit ',idx);
         end;
       deref_record :
         write('RecordDef');
       deref_para :
         write('Parameter of procdef');
       deref_local :
         write('Local of procdef');
       deref_parent_object :
         write('Parent object');
       else
         begin
           writeln('!! unsupported dereftyp: ',ord(b));
           break;
         end;
     end;
   end;
  writeln;
end;


procedure readtype;
begin
  readderef;
end;


procedure readsymlist(const s:string);
type
  tsltype = (sl_none,
    sl_load,
    sl_call,
    sl_subscript,
    sl_vec
  );
const
  slstr : array[tsltype] of string[9] = ('',
    'load',
    'call',
    'subscript',
    'vec'
  );
var
  sl : tsltype;
begin
  readderef;
  repeat
    sl:=tsltype(ppufile.getbyte);
    if sl=sl_none then
     break;
    write(s,'(',slstr[sl],') ');
    case sl of
      sl_call,
      sl_load,
      sl_subscript :
        readderef;
      sl_vec :
        writeln(ppufile.getlongint);
    end;
  until false;
end;


procedure readsymoptions;
type
  tsymoption=(sp_none,
    sp_public,
    sp_private,
    sp_published,
    sp_protected,
    sp_forwarddef,
    sp_static,
    sp_primary_typesym    { this is for typesym, to know who is the primary symbol of a def }
  );
  tsymoptions=set of tsymoption;
  tsymopt=record
    mask : tsymoption;
    str  : string[30];
  end;
const
  symopts=7;
  symopt : array[1..symopts] of tsymopt=(
     (mask:sp_public;         str:'Public'),
     (mask:sp_private;        str:'Private'),
     (mask:sp_published;      str:'Published'),
     (mask:sp_protected;      str:'Protected'),
     (mask:sp_forwarddef;     str:'ForwardDef'),
     (mask:sp_static;         str:'Static'),
     (mask:sp_primary_typesym;str:'PrimaryTypeSym')
  );
var
  symoptions : tsymoptions;
  i      : longint;
  first  : boolean;
begin
  ppufile.getsmallset(symoptions);
  if symoptions<>[] then
   begin
     first:=true;
     for i:=1to symopts do
      if (symopt[i].mask in symoptions) then
       begin
         if first then
           first:=false
         else
           write(', ');
         write(symopt[i].str);
       end;
   end;
  writeln;
end;


{ Read abstract procdef and return if inline procdef }
type
  tproccalloption=(pocall_none,
    { procedure uses C styled calling }
    pocall_cdecl,
    { C++ calling conventions }
    pocall_cppdecl,
    { Procedure is used for internal compiler calls }
    pocall_compilerproc,
    { Far16 for OS/2 }
    pocall_far16,
    { Old style FPC default calling }
    pocall_oldfpccall,
    { Procedure is an assembler macro }
    pocall_inline,
    { Procedure has compiler magic}
    pocall_internproc,
    { procedure is a system call, applies e.g. to MorphOS and PalmOS }
    pocall_syscall,
    { pascal standard left to right }
    pocall_pascal,
    { procedure uses register (fastcall) calling }
    pocall_register,
    { safe call calling conventions }
    pocall_safecall,
    { procedure uses stdcall call }
    pocall_stdcall,
    { Special calling convention for cpus without a floating point
      unit. Floating point numbers are passed in integer registers
      instead of floating point registers. Depending on the other
      available calling conventions available for the cpu
      this replaces either pocall_fastcall or pocall_stdcall.
    }
    pocall_softfloat
  );
  tproccalloptions=set of tproccalloption;
  tproctypeoption=(potype_none,
    potype_proginit,     { Program initialization }
    potype_unitinit,     { unit initialization }
    potype_unitfinalize, { unit finalization }
    potype_constructor,  { Procedure is a constructor }
    potype_destructor,   { Procedure is a destructor }
    potype_operator      { Procedure defines an operator }
  );
  tproctypeoptions=set of tproctypeoption;
  tprocoption=(po_none,
    po_classmethod,       { class method }
    po_virtualmethod,     { Procedure is a virtual method }
    po_abstractmethod,    { Procedure is an abstract method }
    po_staticmethod,      { static method }
    po_overridingmethod,  { method with override directive }
    po_methodpointer,     { method pointer, only in procvardef, also used for 'with object do' }
    po_interrupt,         { Procedure is an interrupt handler }
    po_iocheck,           { IO checking should be done after a call to the procedure }
    po_assembler,         { Procedure is written in assembler }
    po_msgstr,            { method for string message handling }
    po_msgint,            { method for int message handling }
    po_exports,           { Procedure has export directive (needed for OS/2) }
    po_external,          { Procedure is external (in other object or lib)}
    po_saveregisters,     { save all registers }
    po_overload,          { procedure is declared with overload directive }
    po_varargs,           { printf like arguments }
    po_internconst,       { procedure has constant evaluator intern }
    { flag that only the address of a method is returned and not a full methodpointer }
    po_addressonly,
    { procedure is exported }
    po_public,
    { calling convention is specified explicitly }
    po_hascallingconvention,
    { reintroduce flag }
    po_reintroduce,
    { location of parameters is given explicitly as it is necessary for some syscall
      conventions like that one of MorphOS }
    po_explicitparaloc,
    { no stackframe will be generated, used by lowlevel assembler like get_frame }
    po_nostackframe,
    { localst is valid }
    po_haslocalst
  );
  tprocoptions=set of tprocoption;
procedure read_abstract_proc_def(var proccalloption:tproccalloption;var procoptions:tprocoptions);
type
  tproccallopt=record
    mask : tproccalloption;
    str  : string[30];
  end;
  tproctypeopt=record
    mask : tproctypeoption;
    str  : string[30];
  end;
  tprocopt=record
    mask : tprocoption;
    str  : string[30];
  end;
const
  proccalloptionStr : array[tproccalloption] of string[14]=('',
     'CDecl',
     'CPPDecl',
     'CompilerProc',
     'Far16',
     'OldFPCCall',
     'Inline',
     'InternProc',
     'SysCall',
     'Pascal',
     'Register',
     'SafeCall',
     'StdCall',
     'SoftFloat'
   );
  proctypeopts=6;
  proctypeopt : array[1..proctypeopts] of tproctypeopt=(
     (mask:potype_proginit;    str:'ProgInit'),
     (mask:potype_unitinit;    str:'UnitInit'),
     (mask:potype_unitfinalize;str:'UnitFinalize'),
     (mask:potype_constructor; str:'Constructor'),
     (mask:potype_destructor;  str:'Destructor'),
     (mask:potype_operator;    str:'Operator')
  );
  procopts=24;
  procopt : array[1..procopts] of tprocopt=(
     (mask:po_classmethod;     str:'ClassMethod'),
     (mask:po_virtualmethod;   str:'VirtualMethod'),
     (mask:po_abstractmethod;  str:'AbstractMethod'),
     (mask:po_staticmethod;    str:'StaticMethod'),
     (mask:po_overridingmethod;str:'OverridingMethod'),
     (mask:po_methodpointer;   str:'MethodPointer'),
     (mask:po_interrupt;       str:'Interrupt'),
     (mask:po_iocheck;         str:'IOCheck'),
     (mask:po_assembler;       str:'Assembler'),
     (mask:po_msgstr;          str:'MsgStr'),
     (mask:po_msgint;          str:'MsgInt'),
     (mask:po_exports;         str:'Exports'),
     (mask:po_external;        str:'External'),
     (mask:po_saveregisters;   str:'SaveRegisters'),
     (mask:po_overload;        str:'Overload'),
     (mask:po_varargs;         str:'VarArgs'),
     (mask:po_internconst;     str:'InternConst'),
     (mask:po_addressonly;     str:'AddressOnly'),
     (mask:po_public;          str:'Public'),
     (mask:po_hascallingconvention;str:'HasCallingConvention'),
     (mask:po_reintroduce;     str:'ReIntroduce'),
     (mask:po_explicitparaloc; str:'ExplicitParaloc'),
     (mask:po_nostackframe;    str:'NoStackFrame'),
     (mask:po_haslocalst;      str:'HasLocalst')
  );
var
  proctypeoption  : tproctypeoption;
  i,params : longint;
  first    : boolean;
begin
  write(space,'      Return type : ');
  readtype;
  writeln(space,'         Fpu used : ',ppufile.getbyte);
  proctypeoption:=tproctypeoption(ppufile.getbyte);
  if proctypeoption<>potype_none then
   begin
     write(space,'       TypeOption : ');
     first:=true;
     for i:=1 to proctypeopts do
      if (proctypeopt[i].mask=proctypeoption) then
       begin
         if first then
           first:=false
         else
           write(', ');
         write(proctypeopt[i].str);
       end;
     writeln;
   end;
  proccalloption:=tproccalloption(ppufile.getbyte);
  writeln(space,'       CallOption : ',proccalloptionStr[proccalloption]);
  ppufile.getsmallset(procoptions);
  if procoptions<>[] then
   begin
     write(space,'          Options : ');
     first:=true;
     for i:=1to procopts do
      if (procopt[i].mask in procoptions) then
       begin
         if first then
           first:=false
         else
           write(', ');
         write(procopt[i].str);
       end;
     writeln;
   end;
  params:=ppufile.getbyte;
  writeln(space,' Nr of parameters : ',params);
  for i:=1 to params do
   begin
     writeln(space,' - Parameter ',i);
     writeln(space,'       Spez : ',Varspez2Str(ppufile.getbyte));
     write  (space,'       Type : ');
     readtype;
     write  (space,'    Default : ');
     readderef;
     write  (space,'     Symbol : ');
     readderef;
     writeln(space,'  Is Hidden : ',(ppufile.getbyte<>0));
   end;
end;


procedure readcommonsym(const s:string);
begin
  writeln(space,'** Symbol Nr. ',ppufile.getword,' **');
  writeln(space,s,ppufile.getstring);
  write(space,'    File Pos: ');
  readposinfo;
  write(space,'  SymOptions: ');
  readsymoptions;
end;


procedure readcommondef(const s:string);
type
  tdefoption=(df_none,
    df_has_inittable,           { init data has been generated }
    df_has_rttitable,           { rtti data has been generated }
    df_unique
  );
  tdefoptions=set of tdefoption;
var
  defopts : tdefoptions;
begin
  writeln(space,'** Definition Nr. ',ppufile.getword,' **');
  writeln(space,s);
  write  (space,'      Type symbol : ');
  readderef;
  ppufile.getsmallset(defopts);

  if df_unique in defopts then
    writeln  (space,'      Unique type symbol');

  if df_has_rttitable in defopts then
   begin
     write  (space,'      RTTI symbol : ');
     readderef;
   end;
  if df_has_inittable in defopts then
   begin
     write  (space,'      Init symbol : ');
     readderef;
   end;
end;


procedure readnodetree;
var
  l : longint;
  p : pointer;
begin
  with ppufile do
   begin
     if space<>'' then
      Writeln(space,'------ nodetree ------');
     if readentry=ibnodetree then
      begin
        l:=entrysize;
        Writeln(space,'Tree size : ',l);
        { Read data to prevent error that entry is not completly read }
        getmem(p,l);
        getdata(p^,l);
        freemem(p);
      end
     else
      begin
        Writeln('!! ibnodetree not found');
      end;
   end;
end;


{****************************************************************************
                             Read Symbols Part
****************************************************************************}

procedure readsymbols(const s:string);
type
  { options for variables }
  tvaroption=(vo_none,
    vo_regable,
    vo_is_C_var,
    vo_is_external,
    vo_is_dll_var,
    vo_is_thread_var,
    vo_fpuregable,
    vo_is_local_copy,
    vo_is_const,  { variable is declared as const (parameter) and can't be written to }
    vo_is_exported,
    vo_is_high_value
  );
  tvaroptions=set of tvaroption;

  pguid = ^tguid;
  tguid = packed record
    D1: LongWord;
    D2: Word;
    D3: Word;
    D4: array[0..7] of Byte;
  end;

  absolutetyp = (tovar,toasm,toaddr);
  tconsttyp = (constnone,
    constord,conststring,constreal,
    constset,constpointer,constnil,
    constresourcestring,constwstring,constguid
  );
var
  b      : byte;
  pc     : pchar;
  totalsyms,
  symcnt,
  i,j,len : longint;
  guid : tguid;

begin
  symcnt:=1;
  with ppufile do
   begin
     if space<>'' then
      Writeln(space,'------ ',s,' ------');
     if readentry=ibstartsyms then
      begin
        totalsyms:=getlongint;
        Writeln(space,'Number of symbols : ',totalsyms);
        Writeln(space,'Symtable datasize : ',getlongint);
        Writeln(space,'Symtable alignment: ',getlongint);
      end
     else
      begin
        totalsyms:=-1;
        Writeln('!! ibstartsym not found');
      end;
     repeat
       b:=readentry;
       if not (b in [iberror,ibendsyms]) then
        inc(symcnt);
       case b of

         ibunitsym :
           readcommonsym('Unit symbol ');

         iblabelsym :
           readcommonsym('Label symbol ');

         ibtypesym :
           begin
             readcommonsym('Type symbol ');
             write(space,' Result Type: ');
             readtype;
           end;

         ibprocsym :
           begin
             readcommonsym('Procedure symbol ');
             len:=ppufile.getword;
             for i:=1 to len do
              begin
                write(space,'  Definition: ');
                readderef;
              end;
           end;

         ibconstsym :
           begin
             readcommonsym('Constant symbol ');
             b:=getbyte;
             case tconsttyp(b) of
               constord :
                 begin
                   write  (space,' OrdinalType: ');
                   readtype;
                   writeln(space,'       Value: ',getint64);
                 end;
               constpointer :
                 begin
                   write  (space,' PointerType: ');
                   readtype;
                   writeln(space,'       Value: ',getlongint)
                 end;
               conststring,
               constresourcestring :
                 begin
                   len:=getlongint;
                   getmem(pc,len+1);
                   getdata(pc^,len);
                   writeln(space,'      Length: ',len);
                   writeln(space,'       Value: "',pc,'"');
                   freemem(pc,len+1);
                   if tconsttyp(b)=constresourcestring then
                    writeln(space,'       Index: ',getlongint);
                 end;
               constreal :
                 writeln(space,'       Value: ',getreal);
               constset :
                 begin
                   write (space,'     Set Type: ');
                   readtype;
                   for i:=1to 4 do
                    begin
                      write (space,'       Value: ');
                      for j:=1to 8 do
                       begin
                         if j>1 then
                          write(',');
                         write(hexb(getbyte));
                       end;
                      writeln;
                    end;
                 end;
               constwstring:
                 begin
                 end;
               constguid:
                 begin
                    getdata(guid,sizeof(guid));
                    write (space,'     IID String: {',hexstr(guid.d1,8),'-',hexstr(guid.d2,4),'-',hexstr(guid.d3,4),'-');
                    for i:=0 to 7 do
                      begin
                         write(hexstr(guid.d4[i],2));
                         if i=1 then write('-');
                      end;
                    writeln('}');
                 end
               else
                 Writeln ('!! Invalid unit format : Invalid const type encountered: ',b);
             end;
           end;

         ibvarsym :
           begin
             readcommonsym('Variable symbol ');
             writeln(space,'        Spez: ',Varspez2Str(getbyte));
             writeln(space,'     Address: ',getlongint);
             write  (space,'    Var Type: ');
             readtype;
             i:=getlongint;
             writeln(space,'     Options: ',i);
             if (vo_is_C_var in tvaroptions(i)) then
               writeln(space,' Mangledname: ',getstring);
           end;

         ibenumsym :
           begin
             readcommonsym('Enumeration symbol ');
             write  (space,'  Definition: ');
             readderef;
             writeln(space,'       Value: ',getlongint);
           end;

         ibsyssym :
           begin
             readcommonsym('Internal system symbol ');
             writeln(space,' Internal Nr: ',getlongint);
           end;

         ibrttisym :
           begin
             readcommonsym('RTTI symbol ');
             writeln(space,'   RTTI Type: ',getbyte);
           end;

         ibtypedconstsym :
           begin
             readcommonsym('Typed constant ');
             write  (space,' Constant Type: ');
             readtype;
             writeln(space,'   ReallyConst: ',(getbyte<>0));
           end;

         ibabsolutesym :
           begin
             readcommonsym('Absolute variable symbol ');
             writeln(space,'          Type: ',getbyte);
             writeln(space,'       Address: ',getlongint);
             write  (space,'      Var Type: ');
             readtype;
             writeln(space,'       Options: ',getlongint);
             Write (space,' Relocated to ');
             b:=getbyte;
             case absolutetyp(b) of
               tovar :
                 readsymlist(space+'         Sym: ');
               toasm :
                 Writeln('Assembler name : ',getstring);
               toaddr :
                 begin
                   Write('Address : ',getlongint);
                   if ttargetcpu(ppufile.header.cpu)=i386 then
                     WriteLn(' (Far: ',getbyte<>0,')');
                 end;
               else
                 Writeln ('!! Invalid unit format : Invalid absolute type encountered: ',b);
             end;
           end;

         ibpropertysym :
           begin
             readcommonsym('Property ');
             i:=getlongint;
             writeln(space,' PropOptions: ',i);
             if (i and 32)>0 then
              begin
                write  (space,'OverrideProp: ');
                readderef;
              end
             else
              begin
                write  (space,'   Prop Type: ');
                readtype;
                writeln(space,'       Index: ',getlongint);
                writeln(space,'     Default: ',getlongint);
                write  (space,'  Index Type: ');
                readtype;
                write  (space,'  Readaccess: ');
                readsymlist(space+'         Sym: ');
                write  (space,' Writeaccess: ');
                readsymlist(space+'         Sym: ');
                write  (space,'Storedaccess: ');
                readsymlist(space+'         Sym: ');
              end;
           end;

         iberror :
           begin
             Writeln('!! Error in PPU');
             exit;
           end;

         ibendsyms :
           break;

         else
           WriteLn('!! Skipping unsupported PPU Entry in Symbols: ',b);
       end;
       if not EndOfEntry then
        Writeln('!! Entry has more information stored');
     until false;
     if (totalsyms<>-1) and (symcnt-1<>totalsyms) then
       Writeln('!! Only read ',symcnt-1,' of ',totalsyms,' symbols');
   end;
end;


{****************************************************************************
                         Read defintions Part
****************************************************************************}

procedure readdefinitions(const s:string;start_read : boolean);
type
  tsettype  = (normset,smallset,varset);
  tbasetype = (
    uvoid,
    u8bit,u16bit,u32bit,u64bit,
    s8bit,s16bit,s32bit,s64bit,
    bool8bit,bool16bit,bool32bit,
    uchar,uwidechar
  );
  tobjectdeftype = (odt_none,
    odt_class,
    odt_object,
    odt_interfacecom,
    odt_interfacecorba,
    odt_cppclass
  );
  tvarianttype = (
    vt_normalvariant,vt_olevariant
  );
var
  b : byte;
  totaldefs,l,j,
  defcnt : longint;
  calloption : tproccalloption;
  procoptions : tprocoptions;
  procinfooptions : tprocinfoflag;

begin
  defcnt:=0;
  with ppufile do
   begin
     if space<>'' then
      Writeln(space,'------ ',s,' ------');
     if not start_read then
       if readentry=ibstartdefs then
         begin
           totaldefs:=getlongint;
           Writeln(space,'Number of definitions: ',totaldefs);
         end
       else
         begin
           totaldefs:=-1;
           Writeln('!! ibstartdef not found');
         end;
     repeat
       b:=readentry;
       if not (b in [iberror,ibenddefs]) then
        inc(defcnt);
       case b of

         ibpointerdef :
           begin
             readcommondef('Pointer definition');
             write  (space,'     Pointed Type : ');
             readtype;
             writeln(space,'           Is Far : ',(getbyte<>0));
           end;

         iborddef :
           begin
             readcommondef('Ordinal definition');
             write  (space,'        Base type : ');
             b:=getbyte;
             case tbasetype(b) of
               uvoid     : writeln('uvoid');
               u8bit     : writeln('u8bit');
               u16bit    : writeln('u16bit');
               u32bit    : writeln('s32bit');
               u64bit    : writeln('u64bit');
               s8bit     : writeln('s8bit');
               s16bit    : writeln('s16bit');
               s32bit    : writeln('s32bit');
               s64bit    : writeln('s64bit');
               bool8bit  : writeln('bool8bit');
               bool16bit : writeln('bool16bit');
               bool32bit : writeln('bool32bit');
               uchar     : writeln('uchar');
               uwidechar : writeln('uwidechar');
               else        writeln('!! Warning: Invalid base type ',b);
             end;
             writeln(space,'            Range : ',getint64,' to ',getint64);
           end;

         ibfloatdef :
           begin
             readcommondef('Float definition');
             writeln(space,'       Float type : ',getbyte);
           end;

         ibarraydef :
           begin
             readcommondef('Array definition');
             write  (space,'     Element type : ');
             readtype;
             write  (space,'       Range Type : ');
             readtype;
             writeln(space,'            Range : ',getlongint,' to ',getlongint);
             writeln(space,'   Is Constructor : ',(getbyte<>0));
             writeln(space,'       Is Dynamic : ',(getbyte<>0));
           end;

         ibprocdef :
           begin
             readcommondef('Procedure definition');
             read_abstract_proc_def(calloption,procoptions);
             if (getbyte<>0) then
               writeln(space,'     Mangled name : ',getstring);
             writeln(space,'  Overload Number : ',getword);
             writeln(space,'           Number : ',getword);
             writeln(space,'            Level : ',getbyte);
             write  (space,'            Class : ');
             readderef;
             write  (space,'          Procsym : ');
             readderef;
             write  (space,'         File Pos : ');
             readposinfo;
             write  (space,'       SymOptions : ');
             readsymoptions;
{$ifdef powerpc}
             { library symbol for AmigaOS/MorphOS }
             write  (space,'   Library symbol : ');
             readderef;
{$endif powerpc}
             if (calloption=pocall_inline) then
              begin
                write  (space,'       FuncretSym : ');
                readderef;
                ppufile.getsmallset(procinfooptions);
                writeln(space,'  ProcInfoOptions : ',dword(procinfooptions));
                b := ppufile.getbyte;
                writeln(space,' Inline node tree : ',b);
              end;
             if not EndOfEntry then
              Writeln('!! Entry has more information stored');
             space:='    '+space;
             { parast }
             readdefinitions('parast',false);
             readsymbols('parast');
             { localst }
             if (po_haslocalst in procoptions) or
                (calloption = pocall_inline) then
              begin
                readdefinitions('localst',false);
                readsymbols('localst');
              end;
             if (calloption=pocall_inline) then
               readnodetree;
             delete(space,1,4);
           end;

         ibprocvardef :
           begin
             readcommondef('Procedural type (ProcVar) definition');
             read_abstract_proc_def(calloption,procoptions);
             if not EndOfEntry then
              Writeln('!! Entry has more information stored');
             space:='    '+space;
             { parast }
             readdefinitions('parast',false);
             readsymbols('parast');
             delete(space,1,4);
           end;

         ibshortstringdef :
           begin
             readcommondef('ShortString definition');
             writeln(space,'           Length : ',getbyte);
           end;

         ibwidestringdef :
           begin
             readcommondef('WideString definition');
             writeln(space,'           Length : ',getlongint);
           end;

         ibansistringdef :
           begin
             readcommondef('AnsiString definition');
             writeln(space,'           Length : ',getlongint);
           end;

         iblongstringdef :
           begin
             readcommondef('Longstring definition');
             writeln(space,'           Length : ',getlongint);
           end;

         ibrecorddef :
           begin
             readcommondef('Record definition');
             writeln(space,'         DataSize : ',getlongint);
             writeln(space,'       FieldAlign : ',getbyte);
             writeln(space,'      RecordAlign : ',getbyte);
             if not EndOfEntry then
              Writeln('!! Entry has more information stored');
             {read the record definitions and symbols}
             space:='    '+space;
             readdefinitions('fields',false);
             readsymbols('fields');
             Delete(space,1,4);
           end;

         ibobjectdef :
           begin
             readcommondef('Object/Class definition');
             b:=getbyte;
             write  (space,'             Type : ');
             case tobjectdeftype(b) of
               odt_class          : writeln('class');
               odt_object         : writeln('object');
               odt_interfacecom   : writeln('interfacecom');
               odt_interfacecorba : writeln('interfacecorba');
               odt_cppclass       : writeln('cppclass');
               else                 writeln('!! Warning: Invalid object type ',b);
             end;
             writeln(space,'    Name of Class : ',getstring);
             writeln(space,'         DataSize : ',getlongint);
             writeln(space,'       FieldAlign : ',getbyte);
             writeln(space,'      RecordAlign : ',getbyte);
             writeln(space,'       Vmt offset : ',getlongint);
             write(space,  '   Ancestor Class : ');
             readderef;
             writeln(space,'          Options : ',getlongint);

             if tobjectdeftype(b) in [odt_interfacecom,odt_interfacecorba] then
               begin
                  { IIDGUID }
                  for j:=1to 16 do
                   getbyte;
                  writeln(space,'       IID String : ',getstring);
                  writeln(space,'  Last VTable idx : ',getlongint);
               end;

             if tobjectdeftype(b) in [odt_class,odt_interfacecorba] then
              begin
                l:=getlongint;
                writeln(space,'  Impl Intf Count : ',l);
                for j:=1 to l do
                 begin
                   write  (space,'  - Definition : ');
                   readderef;
                   writeln(space,'       IOffset : ',getlongint);
                 end;
              end;

             if not EndOfEntry then
              Writeln('!! Entry has more information stored');
             {read the record definitions and symbols}
             space:='    '+space;
             readdefinitions('fields',false);
             readsymbols('fields');
             Delete(space,1,4);
           end;

         ibfiledef :
           begin
             ReadCommonDef('File definition');
             write  (space,'             Type : ');
             case getbyte of
              0 : writeln('Text');
              1 : begin
                    writeln('Typed');
                    write  (space,'      File of Type : ');
                    Readtype;
                  end;
              2 : writeln('Untyped');
             end;
           end;

         ibformaldef :
           readcommondef('Generic Definition (void-typ)');

         ibenumdef :
           begin
             readcommondef('Enumeration type definition');
             write(space,'Base enumeration type : ');
             readderef;
             writeln(space,' Smallest element : ',getlongint);
             writeln(space,'  Largest element : ',getlongint);
             writeln(space,'             Size : ',getlongint);
           end;

         ibclassrefdef :
           begin
             readcommondef('Class reference definition');
             write  (space,'    Pointed Type : ');
             readtype;
           end;

         ibsetdef :
           begin
             readcommondef('Set definition');
             write  (space,'     Element type : ');
             readtype;
             b:=getbyte;
             case tsettype(b) of
               smallset : writeln(space,'  Set with 32 Elements');
               normset  : writeln(space,'  Set with 256 Elements');
               varset   : writeln(space,'  Set with ',getlongint,' Elements');
               else       writeln('!! Warning: Invalid set type ',b);
             end;
           end;

         ibvariantdef :
           begin
             readcommondef('Variant definition');
             write  (space,'      Varianttype : ');
             b:=getbyte;
             case tvarianttype(b) of
               vt_normalvariant :
                 writeln('Normal');
               vt_olevariant :
                 writeln('OLE');
               else
                 writeln('!! Warning: Invalid varianttype ',b);
             end;

           end;

         iberror :
           begin
             Writeln('!! Error in PPU');
             exit;
           end;

         ibenddefs :
           break;

         else
           WriteLn('!! Skipping unsupported PPU Entry in definitions: ',b);
       end;
       if not EndOfEntry then
        Writeln('!! Entry has more information stored');
     until false;
     if (totaldefs<>-1) and (defcnt<>totaldefs) then
      Writeln('!! Only read ',defcnt,' of ',totaldefs,' definitions');
   end;
end;


{****************************************************************************
                           Read General Part
****************************************************************************}

procedure readinterface;
var
  b : byte;
  sourcenumber : longint;
begin
  with ppufile do
   begin
     repeat
       b:=readentry;
       case b of

         ibmodulename :
           Writeln('Module Name: ',getstring);

         ibsourcefiles :
           begin
             sourcenumber:=1;
             while not EndOfEntry do
              begin
                Writeln('Source file ',sourcenumber,' : ',getstring,' ',filetimestring(getlongint));
                inc(sourcenumber);
              end;
           end;

         ibusedmacros :
           begin
             while not EndOfEntry do
              begin
                Write('Conditional ',getstring);
                b:=getbyte;
                if boolean(b)=true then
                  write(' defined at startup')
                else
                  write(' not defined at startup');
                b:=getbyte;
                if boolean(b)=true then
                  writeln(' was used')
                else
                  writeln;
              end;
           end;

         ibloadunit :
           ReadLoadUnit;

         iblinkunitofiles :
           ReadLinkContainer('Link unit object file: ');

         iblinkunitstaticlibs :
           ReadLinkContainer('Link unit static lib: ');

         iblinkunitsharedlibs :
           ReadLinkContainer('Link unit shared lib: ');

         iblinkotherofiles :
           ReadLinkContainer('Link other object file: ');

         iblinkotherstaticlibs :
           ReadLinkContainer('Link other static lib: ');

         iblinkothersharedlibs :
           ReadLinkContainer('Link other shared lib: ');

         ibderefdata :
           ReadDerefData;

         iberror :
           begin
             Writeln('Error in PPU');
             exit;
           end;

         ibendinterface :
           break;

         else
           WriteLn('!! Skipping unsupported PPU Entry in General Part: ',b);
       end;
     until false;
   end;
end;



{****************************************************************************
                        Read Implementation Part
****************************************************************************}

procedure readimplementation;
var
  b : byte;
begin
  with ppufile do
   begin
     repeat
       b:=readentry;
       case b of
         ibasmsymbols :
           ReadAsmSymbols;

         ibloadunit :
           ReadLoadUnit;

         iberror :
           begin
             Writeln('Error in PPU');
             exit;
           end;
         ibendimplementation :
           break;
         else
           WriteLn('!! Skipping unsupported PPU Entry in Implementation: ',b);
       end;
     until false;
   end;
end;


{****************************************************************************
                            Read Browser Part
****************************************************************************}

procedure readbrowser;
var
  b : byte;
const indent : string = '';
begin
  Writeln(indent,'Start of symtable browser');
  indent:=indent+'**';
  with ppufile do
   begin
     repeat
       b:=readentry;
       case b of
         ibbeginsymtablebrowser :
           begin
             { here we must read object and record symtables !! }
             indent:=indent+'  ';
             Writeln(indent,'Record/Object symtable');
             readbrowser;
             Indent:=Copy(Indent,1,Length(Indent)-2);
           end;
         ibsymref :
           begin
             readderef;
             readref;
           end;
         ibdefref :
           begin
             readderef;
             readref;
             if ((ppufile.header.flags and uf_local_browser)<>0) and
                (UnitIndex=0) then
              begin
                { parast and localst }
                indent:=indent+'  ';
                b:=ppufile.readentry;
                if b=ibbeginsymtablebrowser then
                 readbrowser;
                b:=ppufile.readentry;
                if b=ibbeginsymtablebrowser then
                 readbrowser;
                Indent:=Copy(Indent,1,Length(Indent)-2);
              end;
           end;
         iberror :
           begin
             Writeln('Error in PPU');
             exit;
           end;
         ibendsymtablebrowser :
           break;
         else
           begin
             WriteLn('!! Skipping unsupported PPU Entry in Browser: ',b);
             Halt;
           end;
       end;
     until false;
   end;
  Indent:=Copy(Indent,1,Length(Indent)-2);
  Writeln(Indent,'End of symtable browser');
end;




procedure dofile (filename : string);
var
  b : byte;
begin
{ reset }
  space:='';
{ fix filename }
  if pos('.',filename)=0 then
   filename:=filename+'.ppu';
  ppufile:=tppufile.create(filename);
  if not ppufile.openfile then
   begin
     writeln ('IO-Error when opening : ',filename,', Skipping');
     exit;
   end;
{ PPU File is open, check for PPU Id }
  if not ppufile.CheckPPUID then
   begin
     writeln(Filename,' : Not a valid PPU file, Skipping');
     exit;
   end;
{ Check PPU Version }
  Writeln('Analyzing ',filename,' (v',ppufile.GetPPUVersion,')');
  if ppufile.GetPPUVersion<16 then
   begin
     writeln(Filename,' : Old PPU Formats (<v16) are not supported, Skipping');
     exit;
   end;
{ Write PPU Header Information }
  if (verbose and v_header)<>0 then
   begin
     Writeln;
     Writeln('Header');
     Writeln('-------');
     with ppufile.header do
      begin
        Writeln('Compiler version        : ',ppufile.header.compiler shr 14,'.',
                                             (ppufile.header.compiler shr 7) and $7f,'.',
                                             ppufile.header.compiler and $7f);
        WriteLn('Target processor        : ',Cpu2Str(cpu));
        WriteLn('Target operating system : ',Target2Str(target));
        Writeln('Unit flags              : ',PPUFlags2Str(flags));
        Writeln('FileSize (w/o header)   : ',size);
        Writeln('Checksum                : ',hexstr(checksum,8));
        Writeln('Interface Checksum      : ',hexstr(interface_checksum,8));
      end;
   end;
{read the general stuff}
  if (verbose and v_interface)<>0 then
   begin
     Writeln;
     Writeln('Interface section');
     Writeln('------------------');
     readinterface;
   end
  else
   ppufile.skipuntilentry(ibendinterface);
{read the definitions}
  if (verbose and v_defs)<>0 then
   begin
     Writeln;
     Writeln('Interface definitions');
     Writeln('----------------------');
     readdefinitions('interface',false);
   end
  else
   ppufile.skipuntilentry(ibenddefs);
{read the symbols}
  if (verbose and v_syms)<>0 then
   begin
     Writeln;
     Writeln('Interface Symbols');
     Writeln('------------------');
     readsymbols('interface');
   end
  else
   ppufile.skipuntilentry(ibendsyms);
{read the implementation stuff}
  if (verbose and v_implementation)<>0 then
   begin
     Writeln;
     Writeln('Implementation section');
     Writeln('-----------------------');
     readimplementation;
   end
  else
   ppufile.skipuntilentry(ibendimplementation);
{read the static browser units stuff}
  if (ppufile.header.flags and uf_local_browser)<>0 then
   begin
     if (verbose and v_defs)<>0 then
      begin
        Writeln;
        Writeln('Static definitions');
        Writeln('----------------------');
        readdefinitions('implementation',false);
      end
     else
      ppufile.skipuntilentry(ibenddefs);
   {read the symbols}
     if (verbose and v_syms)<>0 then
      begin
        Writeln;
        Writeln('Static Symbols');
        Writeln('------------------');
        readsymbols('implementation');
      end;
   end;
{read the definitions}
  if (verbose and v_defs)<>0 then
   begin
     Writeln;
     Writeln('Implementation definitions');
     Writeln('----------------------');
     readdefinitions('implementation',false);
   end
  else
   ppufile.skipuntilentry(ibenddefs);
{read the symbols}
  if (verbose and v_syms)<>0 then
   begin
     Writeln;
     Writeln('Implementation Symbols');
     Writeln('------------------');
     readsymbols('implementation');
   end
  else
   ppufile.skipuntilentry(ibendsyms);
{read the browser units stuff}
  if (ppufile.header.flags and uf_has_browser)<>0 then
   begin
     if (verbose and v_browser)<>0 then
      begin
        Writeln;
        Writeln('Browser section');
        Writeln('---------------');
        UnitIndex:=0;
        repeat
          b:=ppufile.readentry;
          if b = ibendbrowser then break;
          if b=ibbeginsymtablebrowser then
            begin
               Writeln('Unit ',UnitIndex);
               readbrowser;
               Inc(UnitIndex);
            end
          else
            Writeln('Wrong end browser entry ',b,' should be ',ibendbrowser);
        until false;
      end;
   end;
{read the static browser units stuff}
  if (ppufile.header.flags and uf_local_browser)<>0 then
   begin
     if (verbose and v_browser)<>0 then
      begin
        Writeln;
        Writeln('Static browser section');
        Writeln('---------------');
        UnitIndex:=0;
        b:=ppufile.readentry;
        if b=ibbeginsymtablebrowser then
          readbrowser
        else
          Writeln('Wrong end browser entry ',b,' should be ',ibendbrowser);
      end;
   end;
{shutdown ppufile}
  ppufile.closefile;
  ppufile.free;
  Writeln;
end;



procedure help;
begin
  writeln('usage: ppudump [options] <filename1> <filename2>...');
  writeln;
  writeln('[options] can be:');
  writeln('    -V<verbose>  Set verbosity to <verbose>');
  writeln('                   H - Show header info');
  writeln('                   I - Show interface');
  writeln('                   M - Show implementation');
  writeln('                   S - Show interface symbols');
  writeln('                   D - Show interface definitions');
  writeln('                   B - Show browser info');
  writeln('                   A - Show all');
  writeln('    -?           This helpscreen');
  halt;
end;

var
  startpara,
  nrfile,i  : longint;
  para      : string;
begin
  writeln(Title+' '+Version);
  writeln(Copyright);
  writeln;
  if paramcount<1 then
   begin
     writeln('usage: dumpppu [options] <filename1> <filename2>...');
     halt(1);
   end;
{ turn verbose on by default }
  verbose:=v_all;
{ read options }
  startpara:=1;
  while copy(paramstr(startpara),1,1)='-' do
   begin
     para:=paramstr(startpara);
     case upcase(para[2]) of
      'V' : begin
              verbose:=0;
              for i:=3to length(para) do
               case upcase(para[i]) of
                'H' : verbose:=verbose or v_header;
                'I' : verbose:=verbose or v_interface;
                'M' : verbose:=verbose or v_implementation;
                'D' : verbose:=verbose or v_defs;
                'S' : verbose:=verbose or v_syms;
                'B' : verbose:=verbose or v_browser;
                'A' : verbose:=verbose or v_all;
               end;
            end;
      '?' : help;
     end;
     inc(startpara);
   end;
{ process files }
  for nrfile:=startpara to paramcount do
   dofile (paramstr(nrfile));
  if has_errors then
    Halt(1);
end.
{
  $Log$
  Revision 1.53  2004-07-12 09:14:04  jonas
    * inline procedures at the node tree level, but only under some very
      limited circumstances for now (only procedures, and only if they have
      no or only vs_out/vs_var parameters).
    * fixed ppudump for inline procedures
    * fixed ppudump for ppc

  Revision 1.52  2004/07/09 22:17:32  peter
    * revert has_localst patch
    * replace aktstaticsymtable/aktglobalsymtable with current_module

  Revision 1.51  2004/07/06 19:52:04  peter
    * fix storing of localst in ppu

  Revision 1.50  2003/12/16 21:29:25  florian
    + inlined procedures inherit procinfo flags

  Revision 1.49  2003/12/08 21:04:08  peter
    * line break in uses unit

  Revision 1.48  2003/11/10 22:02:52  peter
    * cross unit inlining fixed

  Revision 1.47  2003/10/22 20:40:00  peter
    * write derefdata in a separate ppu entry

  Revision 1.46  2003/07/02 22:18:04  peter
    * paraloc splitted in callerparaloc,calleeparaloc
    * sparc calling convention updates

  Revision 1.45  2003/06/25 18:31:23  peter
    * sym,def resolving partly rewritten to support also parent objects
      not directly available through the uses clause

  Revision 1.44  2003/06/09 12:59:00  peter
    * updated for new deref info

  Revision 1.43  2003/06/05 20:06:11  peter
    * new procoptions

  Revision 1.42  2003/05/09 17:47:03  peter
    * self moved to hidden parameter
    * removed hdisposen,hnewn,selfn

  Revision 1.41  2003/04/27 07:29:52  peter
    * aktprocdef cleanup, aktprocdef is now always nil when parsing
      a new procdef declaration
    * aktprocsym removed
    * lexlevel removed, use symtable.symtablelevel instead
    * implicit init/final code uses the normal genentry/genexit
    * funcret state checking updated for new funcret handling

  Revision 1.39  2003/04/25 20:59:35  peter
    * removed funcretn,funcretsym, function result is now in varsym
      and aliases for result and function name are added using absolutesym
    * vs_hidden parameter for funcret passed in parameter
    * vs_hidden fixes
    * writenode changed to printnode and released from extdebug
    * -vp option added to generate a tree.log with the nodetree
    * nicer printnode for statements, callnode

  Revision 1.38  2003/04/10 17:57:53  peter
    * vs_hidden released

  Revision 1.37  2003/03/24 19:57:54  hajny
    + emx target added

  Revision 1.36  2003/03/17 15:54:22  peter
    * store symoptions also for procdef
    * check symoptions (private,public) when calculating possible
      overload candidates

  Revision 1.35  2003/01/03 22:16:29  peter
    * updated for absolutesym and varsym

  Revision 1.34  2002/11/17 16:32:04  carl
    * memory optimization (3-4%) : cleanup of tai fields,
       cleanup of tdef and tsym fields.
    * make it work for m68k

  Revision 1.33  2002/10/20 14:49:31  peter
    * store original source time in ppu so it can be compared instead of
      comparing with the ppu time

  Revision 1.32  2002/10/06 12:25:53  florian
    + dump of tdefoptions.df_unique

  Revision 1.31  2002/09/27 21:22:04  carl
    * update system information

  Revision 1.30  2002/09/26 12:03:54  florian
    + support of constguid and constwchar const symbols added

  Revision 1.29  2002/08/20 16:54:40  peter
    * write address of varsym always

  Revision 1.28  2002/08/19 19:36:44  peter
    * More fixes for cross unit inlining, all tnodes are now implemented
    * Moved pocall_internconst to po_internconst because it is not a
      calling type at all and it conflicted when inlining of these small
      functions was requested

  Revision 1.27  2002/08/15 15:15:56  carl
    * jmpbuf size allocation for exceptions is now cpu specific (as it should)
    * more generic nodes for maths
    * several fixes for better m68k support

  Revision 1.26  2002/08/11 13:24:20  peter
    * saving of asmsymbols in ppu supported
    * asmsymbollist global is removed and moved into a new class
      tasmlibrarydata that will hold the info of a .a file which
      corresponds with a single module. Added librarydata to tmodule
      to keep the library info stored for the module. In the future the
      objectfiles will also be stored to the tasmlibrarydata class
    * all getlabel/newasmsymbol and friends are moved to the new class

  Revision 1.25  2002/05/18 13:34:27  peter
    * readded missing revisions

  Revision 1.24  2002/05/16 19:46:54  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.22  2002/05/12 16:53:18  peter
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

  Revision 1.21  2002/04/23 13:12:58  peter
    * updated for posinfo change
    * updated for mangledname change
    * include i386 registers, removed reference to cpubase unit that would
      make ppudump dependent on the source processor

  Revision 1.20  2002/04/15 19:15:09  carl
  + write std_reg2str instead of gas registers

  Revision 1.19  2002/04/14 17:02:19  carl
  + att_reg2str -> gas_reg2str

  Revision 1.18  2002/04/07 10:23:36  carl
  + added vm / sparc targets

  Revision 1.17  2002/04/04 19:06:14  peter
    * removed unused units
    * use tlocation.size in cg.a_*loc*() routines

  Revision 1.16  2002/04/04 18:50:27  carl
  + added wdosx support (patch from Pavel)

  Revision 1.15  2002/03/31 20:26:42  jonas
    + a_loadfpu_* and a_loadmm_* methods in tcg
    * register allocation is now handled by a class and is mostly processor
      independent (+rgobj.pas and i386/rgcpu.pas)
    * temp allocation is now handled by a class (+tgobj.pas, -i386\tgcpu.pas)
    * some small improvements and fixes to the optimizer
    * some register allocation fixes
    * some fpuvaroffset fixes in the unary minus node
    * push/popusedregisters is now called rg.save/restoreusedregisters and
      (for i386) uses temps instead of push/pop's when using -Op3 (that code is
      also better optimizable)
    * fixed and optimized register saving/restoring for new/dispose nodes
    * LOC_FPU locations now also require their "register" field to be set to
      R_ST, not R_ST0 (the latter is used for LOC_CFPUREGISTER locations only)
    - list field removed of the tnode class because it's not used currently
      and can cause hard-to-find bugs

  Revision 1.14  2002/03/28 20:48:52  carl
  - remove go32v1 support

  Revision 1.13  2002/03/28 16:44:59  armin
  + new flag if unit has local threadvars

  Revision 1.12  2002/03/01 14:08:47  peter
    * parasym added

  Revision 1.11  2002/01/06 12:08:16  peter
    * removed uauto from orddef, use new range_to_basetype generating
      the correct ordinal type for a range

}
