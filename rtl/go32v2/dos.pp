{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 1993,97 by the Free Pascal development team.

    Dos unit for BP7 compatible RTL

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit dos;
interface

Uses
  Go32;

Const
  {Bitmasks for CPU Flags}
  fcarry     = $0001;
  fparity    = $0004;
  fauxiliary = $0010;
  fzero      = $0040;
  fsign      = $0080;
  foverflow  = $0800;

  {Bitmasks for file attribute}
  readonly  = $01;
  hidden    = $02;
  sysfile   = $04;
  volumeid  = $08;
  directory = $10;
  archive   = $20;
  anyfile   = $3F;

  {File Status}
  fmclosed = $D7B0;
  fminput  = $D7B1;
  fmoutput = $D7B2;
  fminout  = $D7B3;


Type
{ Needed for LFN Support }
  ComStr  = String[255];
  PathStr = String[255];
  DirStr  = String[255];
  NameStr = String[255];
  ExtStr  = String[255];

{
  filerec.inc contains the definition of the filerec.
  textrec.inc contains the definition of the textrec.
  It is in a separate file to make it available in other units without
  having to use the DOS unit for it.
}
{$i filerec.inc}
{$i textrec.inc}

  DateTime = packed record
    Year,
    Month,
    Day,
    Hour,
    Min,
    Sec   : word;
  End;

  searchrec = packed record
     fill : array[1..21] of byte;
     attr : byte;
     time : longint;
     { reserved : word; not in DJGPP V2 }
     size : longint;
     name : string[255]; { LFN Name, DJGPP uses only [12] but more can't hurt (PFV) }
  end;

  Registers = Go32.Registers;

Var
  DosError : integer;

{Interrupt}
Procedure Intr(intno: byte; var regs: registers);
Procedure MSDos(var regs: registers);

{Info/Date/Time}
Function  DosVersion: Word;
Procedure GetDate(var year, month, mday, wday: word);
Procedure GetTime(var hour, minute, second, sec100: word);
procedure SetDate(year,month,day: word);
Procedure SetTime(hour,minute,second,sec100: word);
Procedure UnpackTime(p: longint; var t: datetime);
Procedure PackTime(var t: datetime; var p: longint);

{Exec}
Procedure Exec(const path: pathstr; const comline: comstr);
Function  DosExitCode: word;

{Disk}
Function  DiskFree(drive: byte) : longint;
Function  DiskSize(drive: byte) : longint;
Procedure FindFirst(const path: pathstr; attr: word; var f: searchRec);
Procedure FindNext(var f: searchRec);
Procedure FindClose(Var f: SearchRec);

{File}
Procedure GetFAttr(var f; var attr: word);
Procedure GetFTime(var f; var time: longint);
Function  FSearch(path: pathstr; dirlist: string): pathstr;
Function  FExpand(const path: pathstr): pathstr;
Procedure FSplit(path: pathstr; var dir: dirstr; var name: namestr; var ext: extstr);

{Environment}
Function  EnvCount: longint;
Function  EnvStr(index: integer): string;
Function  GetEnv(envvar: string): string;

{Misc}
Procedure SetFAttr(var f; attr: word);
Procedure SetFTime(var f; time: longint);
Procedure GetCBreak(var breakvalue: boolean);
Procedure SetCBreak(breakvalue: boolean);
Procedure GetVerify(var verify: boolean);
Procedure SetVerify(verify: boolean);

{Do Nothing Functions}
Procedure SwapVectors;
Procedure GetIntVec(intno: byte; var vector: pointer);
Procedure SetIntVec(intno: byte; vector: pointer);
Procedure Keep(exitcode: word);

implementation

uses
  strings;

{$ASMMODE ATT}

{******************************************************************************
                           --- Dos Interrupt ---
******************************************************************************}

var
  dosregs : registers;

procedure LoadDosError;
begin
  if (dosregs.flags and carryflag) <> 0 then
  { conversion from word to integer !!
    gave a Bound check error if ax is $FFFF !! PM }
    doserror:=integer(dosregs.ax)
  else
    doserror:=0;
end;


procedure intr(intno : byte;var regs : registers);
begin
  realintr(intno,regs);
end;


procedure msdos(var regs : registers);
begin
  intr($21,regs);
end;


{******************************************************************************
                        --- Info / Date / Time ---
******************************************************************************}

function dosversion : word;
begin
  dosregs.ax:=$3000;
  msdos(dosregs);
  dosversion:=dosregs.ax;
end;


procedure getdate(var year,month,mday,wday : word);
begin
  dosregs.ax:=$2a00;
  msdos(dosregs);
  wday:=dosregs.al;
  year:=dosregs.cx;
  month:=dosregs.dh;
  mday:=dosregs.dl;
end;


procedure setdate(year,month,day : word);
begin
   dosregs.cx:=year;
   dosregs.dh:=month;
   dosregs.dl:=day;
   dosregs.ah:=$2b;
   msdos(dosregs);
   DosError:=0;
end;


procedure gettime(var hour,minute,second,sec100 : word);
begin
  dosregs.ah:=$2c;
  msdos(dosregs);
  hour:=dosregs.ch;
  minute:=dosregs.cl;
  second:=dosregs.dh;
  sec100:=dosregs.dl;
  DosError:=0;
end;


procedure settime(hour,minute,second,sec100 : word);
begin
  dosregs.ch:=hour;
  dosregs.cl:=minute;
  dosregs.dh:=second;
  dosregs.dl:=sec100;
  dosregs.ah:=$2d;
  msdos(dosregs);
  DosError:=0;
end;


Procedure packtime(var t : datetime;var p : longint);
Begin
  p:=(t.sec shr 1)+(t.min shl 5)+(t.hour shl 11)+(t.day shl 16)+(t.month shl 21)+((t.year-1980) shl 25);
End;


Procedure unpacktime(p : longint;var t : datetime);
Begin
  with t do
   begin
     sec:=(p and 31) shl 1;
     min:=(p shr 5) and 63;
     hour:=(p shr 11) and 31;
     day:=(p shr 16) and 31;
     month:=(p shr 21) and 15;
     year:=(p shr 25)+1980;
   end;
End;


{******************************************************************************
                               --- Exec ---
******************************************************************************}

var
  lastdosexitcode : word;

procedure exec(const path : pathstr;const comline : comstr);
type
  realptr = packed record
    ofs,seg : word;
  end;
  texecblock = packed record
    envseg    : word;
    comtail   : realptr;
    firstFCB  : realptr;
    secondFCB : realptr;
    iniStack  : realptr;
    iniCSIP   : realptr;
  end;
var
  current_dos_buffer_pos,
  arg_ofs,
  i,la_env,
  la_p,la_c,la_e,
  fcb1_la,fcb2_la : longint;
  execblock       : texecblock;
  c,p             : string;

  function paste_to_dos(src : string) : boolean;
  var
    c : array[0..255] of char;
  begin
     paste_to_dos:=false;
     if current_dos_buffer_pos+length(src)+1>transfer_buffer+tb_size then
      RunError(217);
     move(src[1],c[0],length(src));
     c[length(src)]:=#0;
     seg_move(get_ds,longint(@c),dosmemselector,current_dos_buffer_pos,length(src)+1);
     current_dos_buffer_pos:=current_dos_buffer_pos+length(src)+1;
     paste_to_dos:=true;
  end;

begin
{ create command line }
  move(comline[0],c[1],length(comline)+1);
  c[length(comline)+2]:=#13;
  c[0]:=char(length(comline)+2);
{ create path }
  p:=path;
  for i:=1 to length(p) do
   if p[i]='/' then
    p[i]:='\';
{ create buffer }
  la_env:=transfer_buffer;
  while (la_env and 15)<>0 do
   inc(la_env);
  current_dos_buffer_pos:=la_env;
{ copy environment }
  for i:=1 to envcount do
   paste_to_dos(envstr(i));
  paste_to_dos(''); { adds a double zero at the end }
{ allow slash as backslash }
  la_p:=current_dos_buffer_pos;
  paste_to_dos(p);
  la_c:=current_dos_buffer_pos;
  paste_to_dos(c);
  la_e:=current_dos_buffer_pos;
  fcb1_la:=la_e;
  la_e:=la_e+16;
  fcb2_la:=la_e;
  la_e:=la_e+16;
{ allocate FCB see dosexec code }
  arg_ofs:=1;
  while (c[arg_ofs] in [' ',#9]) do
   inc(arg_ofs);
  dosregs.ax:=$2901;
  dosregs.ds:=(la_c+arg_ofs) shr 4;
  dosregs.esi:=(la_c+arg_ofs) and 15;
  dosregs.es:=fcb1_la shr 4;
  dosregs.edi:=fcb1_la and 15;
  msdos(dosregs);
{ allocate second FCB see dosexec code }
  repeat
    inc(arg_ofs);
  until (c[arg_ofs] in [' ',#9,#13]);
  if c[arg_ofs]<>#13 then
   begin
     repeat
       inc(arg_ofs);
     until not (c[arg_ofs] in [' ',#9]);
   end;
  dosregs.ax:=$2901;
  dosregs.ds:=(la_c+arg_ofs) shr 4;
  dosregs.si:=(la_c+arg_ofs) and 15;
  dosregs.es:=fcb2_la shr 4;
  dosregs.di:=fcb2_la and 15;
  msdos(dosregs);
  with execblock do
   begin
     envseg:=la_env shr 4;
     comtail.seg:=la_c shr 4;
     comtail.ofs:=la_c and 15;
     firstFCB.seg:=fcb1_la shr 4;
     firstFCB.ofs:=fcb1_la and 15;
     secondFCB.seg:=fcb2_la shr 4;
     secondFCB.ofs:=fcb2_la and 15;
   end;
  seg_move(get_ds,longint(@execblock),dosmemselector,la_e,sizeof(texecblock));
  dosregs.edx:=la_p and 15;
  dosregs.ds:=la_p shr 4;
  dosregs.ebx:=la_e and 15;
  dosregs.es:=la_e shr 4;
  dosregs.ax:=$4b00;
  msdos(dosregs);
  LoadDosError;
  if DosError=0 then
   begin
     dosregs.ax:=$4d00;
     msdos(dosregs);
     LastDosExitCode:=DosRegs.al
   end
  else
   LastDosExitCode:=0;
end;


function dosexitcode : word;
begin
  dosexitcode:=lastdosexitcode;
end;


procedure getcbreak(var breakvalue : boolean);
begin
  DosError:=0;
  dosregs.ax:=$3300;
  msdos(dosregs);
  breakvalue:=dosregs.dl<>0;
end;


procedure setcbreak(breakvalue : boolean);
begin
  DosError:=0;
  dosregs.ax:=$3301;
  dosregs.dl:=ord(breakvalue);
  msdos(dosregs);
end;


procedure getverify(var verify : boolean);
begin
  DosError:=0;
  dosregs.ah:=$54;
  msdos(dosregs);
  verify:=dosregs.al<>0;
end;


procedure setverify(verify : boolean);
begin
  DosError:=0;
  dosregs.ah:=$2e;
  dosregs.al:=ord(verify);
  msdos(dosregs);
end;


{******************************************************************************
                               --- Disk ---
******************************************************************************}

function diskfree(drive : byte) : longint;
begin
  DosError:=0;
  dosregs.dl:=drive;
  dosregs.ah:=$36;
  msdos(dosregs);
  if dosregs.ax<>$FFFF then
   diskfree:=dosregs.ax*dosregs.bx*dosregs.cx
  else
   diskfree:=-1;
end;


function disksize(drive : byte) : longint;
begin
  DosError:=0;
  dosregs.dl:=drive;
  dosregs.ah:=$36;
  msdos(dosregs);
  if dosregs.ax<>$FFFF then
   disksize:=dosregs.ax*dosregs.cx*dosregs.dx
  else
   disksize:=-1;
end;


{******************************************************************************
                      --- LFNFindfirst LFNFindNext ---
******************************************************************************}

type
  LFNSearchRec=packed record
    attr,
    crtime,
    crtimehi,
    actime,
    actimehi,
    lmtime,
    lmtimehi,
    sizehi,
    size      : longint;
    reserved  : array[0..7] of byte;
    name      : array[0..259] of byte;
    shortname : array[0..13] of byte;
  end;

procedure LFNSearchRec2Dos(const w:LFNSearchRec;hdl:longint;var d:Searchrec);
var
  Len : longint;
begin
  With w do
   begin
     FillChar(d,sizeof(SearchRec),0);
     if DosError=0 then
      len:=StrLen(@Name)
     else
      len:=0;
     d.Name[0]:=chr(len);
     Move(Name[0],d.Name[1],Len);
     d.Time:=lmTime;
     d.Size:=Size;
     d.Attr:=Attr and $FF;
     Move(hdl,d.Fill,4);
   end;
end;


procedure LFNFindFirst(path:pchar;attr:longint;var s:searchrec);
var
  i : longint;
  w : LFNSearchRec;
begin
  { allow slash as backslash }
  for i:=0 to strlen(path) do
    if path[i]='/' then path[i]:='\';
  dosregs.si:=1; { use ms-dos time }
  { don't include the label if not asked for it, needed for network drives }
  if attr=$8 then
   dosregs.ecx:=8
  else
   dosregs.ecx:=attr and (not 8);
  dosregs.edx:=tb_offset+Sizeof(LFNSearchrec)+1;
  dosmemput(tb_segment,tb_offset+Sizeof(LFNSearchrec)+1,path^,strlen(path)+1);
  dosregs.ds:=tb_segment;
  dosregs.edi:=tb_offset;
  dosregs.es:=tb_segment;
  dosregs.ax:=$714e;
  msdos(dosregs);
  LoadDosError;
  copyfromdos(w,sizeof(LFNSearchRec));
  LFNSearchRec2Dos(w,dosregs.ax,s);
end;


procedure LFNFindNext(var s:searchrec);
var
  hdl : longint;
  w   : LFNSearchRec;
begin
  Move(s.Fill,hdl,4);
  dosregs.si:=1; { use ms-dos time }
  dosregs.edi:=tb_offset;
  dosregs.es:=tb_segment;
  dosregs.ebx:=hdl;
  dosregs.ax:=$714f;
  msdos(dosregs);
  LoadDosError;
  copyfromdos(w,sizeof(LFNSearchRec));
  LFNSearchRec2Dos(w,hdl,s);
end;


procedure LFNFindClose(var s:searchrec);
var
  hdl : longint;
begin
  Move(s.Fill,hdl,4);
  dosregs.ebx:=hdl;
  dosregs.ax:=$71a1;
  msdos(dosregs);
  LoadDosError;
end;


{******************************************************************************
                     --- DosFindfirst DosFindNext ---
******************************************************************************}

procedure dossearchrec2searchrec(var f : searchrec);
var
  len : longint;
begin
  len:=StrLen(@f.Name);
  Move(f.Name[0],f.Name[1],Len);
  f.Name[0]:=chr(len);
end;


procedure DosFindfirst(path : pchar;attr : word;var f : searchrec);
var
   i : longint;
begin
  { allow slash as backslash }
  for i:=0 to strlen(path) do
    if path[i]='/' then path[i]:='\';
  copytodos(f,sizeof(searchrec));
  dosregs.edx:=tb_offset;
  dosregs.ds:=tb_segment;
  dosregs.ah:=$1a;
  msdos(dosregs);
  dosregs.ecx:=attr;
  dosregs.edx:=tb_offset+Sizeof(searchrec)+1;
  dosmemput(tb_segment,tb_offset+Sizeof(searchrec)+1,path^,strlen(path)+1);
  dosregs.ds:=tb_segment;
  dosregs.ah:=$4e;
  msdos(dosregs);
  copyfromdos(f,sizeof(searchrec));
  LoadDosError;
  dossearchrec2searchrec(f);
end;


procedure Dosfindnext(var f : searchrec);
begin
  copytodos(f,sizeof(searchrec));
  dosregs.edx:=tb_offset;
  dosregs.ds:=tb_segment;
  dosregs.ah:=$1a;
  msdos(dosregs);
  dosregs.ah:=$4f;
  msdos(dosregs);
  copyfromdos(f,sizeof(searchrec));
  LoadDosError;
  dossearchrec2searchrec(f);
end;


{******************************************************************************
                     --- Findfirst FindNext ---
******************************************************************************}

procedure findfirst(const path : pathstr;attr : word;var f : searchRec);
var
  path0 : array[0..256] of char;
begin
  doserror:=0;
  strpcopy(path0,path);
  if LFNSupport then
   LFNFindFirst(path0,attr,f)
  else
   Dosfindfirst(path0,attr,f);
end;


procedure findnext(var f : searchRec);
begin
  doserror:=0;
  if LFNSupport then
   LFNFindnext(f)
  else
   Dosfindnext(f);
end;


Procedure FindClose(Var f: SearchRec);
begin
  DosError:=0;
  if LFNSupport then
   LFNFindClose(f);
end;


type swap_proc = procedure;

var
  _swap_in  : swap_proc;external name '_swap_in';
  _swap_out : swap_proc;external name '_swap_out';
  _exception_exit : pointer;external name '_exception_exit';
  _v2prt0_exceptions_on : longbool;external name '_v2prt0_exceptions_on';

procedure swapvectors;
begin
  DosError:=0;
  if _exception_exit<>nil then
    if _v2prt0_exceptions_on then
      _swap_in()
    else
      _swap_out();

(*  asm
{ uses four global symbols from v2prt0.as to be able to know the current
  exception state without using dpmiexcp unit }
            movl _exception_exit,%eax
            orl  %eax,%eax
            je   .Lno_excep
            movl _v2prt0_exceptions_on,%eax
            orl  %eax,%eax
            je   .Lexceptions_off
            call *_swap_out
            jmp  .Lno_excep
         .Lexceptions_off:
            call *_swap_in
         .Lno_excep:
  end; *)
end;


{******************************************************************************
                               --- File ---
******************************************************************************}

procedure fsplit(path : pathstr;var dir : dirstr;var name : namestr;var ext : extstr);
var
   dotpos,p1,i : longint;
begin
  { allow slash as backslash }
  for i:=1 to length(path) do
   if path[i]='/' then path[i]:='\';
  { get drive name }
  p1:=pos(':',path);
  if p1>0 then
    begin
       dir:=path[1]+':';
       delete(path,1,p1);
    end
  else
    dir:='';
  { split the path and the name, there are no more path informtions }
  { if path contains no backslashes                                 }
  while true do
    begin
       p1:=pos('\',path);
       if p1=0 then
         break;
       dir:=dir+copy(path,1,p1);
       delete(path,1,p1);
    end;
  { try to find out a extension }
  if LFNSupport then
    begin
       Ext:='';
       i:=Length(Path);
       DotPos:=256;
       While (i>0) Do
         Begin
            If (Path[i]='.') Then
              begin
                 DotPos:=i;
                 break;
              end;
            Dec(i);
         end;
       Ext:=Copy(Path,DotPos,255);
       Name:=Copy(Path,1,DotPos - 1);
    end
  else
    begin
       p1:=pos('.',path);
       if p1>0 then
         begin
            ext:=copy(path,p1,4);
            delete(path,p1,length(path)-p1+1);
         end
       else
         ext:='';
       name:=path;
    end;
end;


    function fexpand(const path : pathstr) : pathstr;
       var
         s,pa : pathstr;
         i,j  : longint;
       begin
          getdir(0,s);
          i:=ioresult;
          if LFNSupport then
           begin
             pa:=path;
           end
          else
           if FileNameCaseSensitive then
            pa:=path
           else
            pa:=upcase(path);

          { allow slash as backslash }
          for i:=1 to length(pa) do
           if pa[i]='/' then
            pa[i]:='\';

          if (length(pa)>1) and (pa[2]=':') and (pa[1] in ['A'..'Z','a'..'z']) then
            begin
               { Always uppercase driveletter }
               if (pa[1] in ['a'..'z']) then
                pa[1]:=Chr(Ord(Pa[1])-32);
               { we must get the right directory }
               getdir(ord(pa[1])-ord('A')+1,s);
               i:=ioresult;
               if (ord(pa[0])>2) and (pa[3]<>'\') then
                 if pa[1]=s[1] then
                   begin
                     { remove ending slash if it already exists }
                     if s[length(s)]='\' then
                      dec(s[0]);
                     pa:=s+'\'+copy (pa,3,length(pa));
                   end
                 else
                   pa:=pa[1]+':\'+copy (pa,3,length(pa))
            end
          else
            if pa[1]='\' then
              pa:=s[1]+':'+pa
            else if s[0]=#3 then
              pa:=s+pa
            else
              pa:=s+'\'+pa;

        { Turbo Pascal gives current dir on drive if only drive given as parameter! }
        if length(pa) = 2 then
         begin
           getdir(byte(pa[1])-64,s);
           pa := s;
         end;

        {First remove all references to '\.\'}
          while pos ('\.\',pa)<>0 do
           delete (pa,pos('\.\',pa),2);
        {Now remove also all references to '\..\' + of course previous dirs..}
          repeat
            i:=pos('\..\',pa);
            if i<>0 then
             begin
               j:=i-1;
               while (j>1) and (pa[j]<>'\') do
                dec (j);
               if pa[j+1] = ':' then j := 3;
               delete (pa,j,i-j+3);
             end;
          until i=0;

          { Turbo Pascal gets rid of a \.. at the end of the path }
          { Now remove also any reference to '\..'  at end of line
            + of course previous dir.. }
          i:=pos('\..',pa);
          if i<>0 then
           begin
             if i = length(pa) - 2 then
              begin
                j:=i-1;
                while (j>1) and (pa[j]<>'\') do
                 dec (j);
                delete (pa,j,i-j+3);
              end;
              pa := pa + '\';
            end;
          { Remove End . and \}
          if (length(pa)>0) and (pa[length(pa)]='.') then
           dec(byte(pa[0]));
          { if only the drive + a '\' is left then the '\' should be left to prevtn the program
            accessing the current directory on the drive rather than the root!}
          { if the last char of path = '\' then leave it in as this is what TP does! }
          if ((length(pa)>3) and (pa[length(pa)]='\')) and (path[length(path)] <> '\') then
           dec(byte(pa[0]));
          { if only a drive is given in path then there should be a '\' at the
            end of the string given back }
          if length(pa) = 2 then pa := pa + '\';
          fexpand:=pa;
       end;


Function FSearch(path: pathstr; dirlist: string): pathstr;
var
  i,p1   : longint;
  s      : searchrec;
  newdir : pathstr;
begin
{ check if the file specified exists }
  findfirst(path,anyfile,s);
  if doserror=0 then
   begin
     findclose(s);
     fsearch:=path;
     exit;
   end;
{ No wildcards allowed in these things }
  if (pos('?',path)<>0) or (pos('*',path)<>0) then
    fsearch:=''
  else
    begin
       { allow slash as backslash }
       for i:=1 to length(dirlist) do
         if dirlist[i]='/' then dirlist[i]:='\';
       repeat
         p1:=pos(';',dirlist);
         if p1<>0 then
          begin
            newdir:=copy(dirlist,1,p1-1);
            delete(dirlist,1,p1);
          end
         else
          begin
            newdir:=dirlist;
            dirlist:='';
          end;
         if (newdir<>'') and (not (newdir[length(newdir)] in ['\',':'])) then
          newdir:=newdir+'\';
         findfirst(newdir+path,anyfile,s);
         if doserror=0 then
          newdir:=newdir+path
         else
          newdir:='';
       until (dirlist='') or (newdir<>'');
       fsearch:=newdir;
    end;
  findclose(s);
end;


{******************************************************************************
                       --- Get/Set File Time,Attr ---
******************************************************************************}

procedure getftime(var f;var time : longint);
begin
  dosregs.bx:=textrec(f).handle;
  dosregs.ax:=$5700;
  msdos(dosregs);
  loaddoserror;
  time:=(dosregs.dx shl 16)+dosregs.cx;
end;


procedure setftime(var f;time : longint);
begin
  dosregs.bx:=textrec(f).handle;
  dosregs.cx:=time and $ffff;
  dosregs.dx:=time shr 16;
  dosregs.ax:=$5701;
  msdos(dosregs);
  loaddoserror;
end;


procedure getfattr(var f;var attr : word);
begin
  copytodos(filerec(f).name,strlen(filerec(f).name)+1);
  dosregs.edx:=tb_offset;
  dosregs.ds:=tb_segment;
  if LFNSupport then
   begin
     dosregs.ax:=$7143;
     dosregs.bx:=0;
   end
  else
   dosregs.ax:=$4300;
  msdos(dosregs);
  LoadDosError;
  Attr:=dosregs.cx;
end;


procedure setfattr(var f;attr : word);
begin
  copytodos(filerec(f).name,strlen(filerec(f).name)+1);
  dosregs.edx:=tb_offset;
  dosregs.ds:=tb_segment;
  if LFNSupport then
   begin
     dosregs.ax:=$7143;
     dosregs.bx:=1;
   end
  else
   dosregs.ax:=$4301;
  dosregs.cx:=attr;
  msdos(dosregs);
  LoadDosError;
end;


{******************************************************************************
                             --- Environment ---
******************************************************************************}

function envcount : longint;
var
  hp : ppchar;
begin
  hp:=envp;
  envcount:=0;
  while assigned(hp^) do
   begin
     inc(envcount);
     inc(hp);
   end;
end;


function envstr(index : integer) : string;
begin
  if (index<=0) or (index>envcount) then
   begin
     envstr:='';
     exit;
   end;
  envstr:=strpas(ppchar(pointer(envp)+4*(index-1))^);
end;


Function  GetEnv(envvar: string): string;
var
  hp      : ppchar;
  hs    : string;
  eqpos : longint;
begin
  envvar:=upcase(envvar);
  hp:=envp;
  getenv:='';
  while assigned(hp^) do
   begin
     hs:=strpas(hp^);
     eqpos:=pos('=',hs);
     if copy(hs,1,eqpos-1)=envvar then
      begin
        getenv:=copy(hs,eqpos+1,255);
        exit;
      end;
     inc(hp);
   end;
end;


{******************************************************************************
                             --- Not Supported ---
******************************************************************************}

Procedure keep(exitcode : word);
Begin
End;

Procedure getintvec(intno : byte;var vector : pointer);
Begin
End;

Procedure setintvec(intno : byte;vector : pointer);
Begin
End;


end.
{
  $Log$
  Revision 1.11  1999-09-08 18:55:49  peter
    * pointer fixes

  Revision 1.10  1999/08/13 21:23:15  peter
    * fsearch checks first if the specified file exists and returns that
      if it was found

  Revision 1.9  1999/05/16 17:08:58  peter
    * fixed driveletter checking

  Revision 1.8  1999/05/08 19:47:22  peter
    * check ioresult after getdir calls

  Revision 1.7  1999/05/04 23:55:50  pierre
   * unneeded assembler code converted to pascal

  Revision 1.6  1999/04/28 11:42:44  peter
    + FileNameCaseSensetive boolean

  Revision 1.5  1999/04/02 00:01:29  peter
    * fixed LFNFindfirst on network drives

  Revision 1.4  1999/03/01 15:40:48  peter
    * use external names
    * removed all direct assembler modes

  Revision 1.3  1999/01/22 15:44:59  pierre
   Daniel change removed : broke make cycle !!

  Revision 1.2  1999/01/22 10:07:03  daniel
  - Findclose removed: This is TP incompatible!!

  Revision 1.1  1998/12/21 13:07:02  peter
    * use -FE

  Revision 1.19  1998/11/23 13:53:59  peter
    * more fexpand fixes from marco van de voort

  Revision 1.18  1998/11/23 12:48:02  peter
    * fexpand('o:') fixed to return o:\ (from the mailinglist)

  Revision 1.17  1998/11/22 09:33:21  florian
    * fexpand bug (temp. strings were too shoort) fixed, was reported
      by Marco van de Voort

  Revision 1.16  1998/11/17 09:37:41  pierre
   * explicit conversion from word dosreg.ax to integer doserror

  Revision 1.15  1998/11/01 20:27:18  peter
    * fixed some doserror settings

  Revision 1.14  1998/10/22 15:05:28  pierre
   * fsplit adapted to long filenames

  Revision 1.13  1998/09/16 16:47:24  peter
    * merged fixes

  Revision 1.11.2.2  1998/09/16 16:16:04  peter
    * go32v1 compiles again

  Revision 1.12  1998/09/11 12:46:44  pierre
    * range check problem with LFN attr removed

  Revision 1.11.2.1  1998/09/11 12:38:41  pierre
    * conversion from LFN attr to Dos attr did not respect range checking

  Revision 1.11  1998/08/28 10:45:58  peter
    * fixed path buffer in findfirst

  Revision 1.10  1998/08/27 10:30:48  pierre
    * go32v1 RTL did not compile (LFNsupport outside go32v2 defines !)
      I renamed tb_selector to tb_segment because
        it is a real mode segment as opposed to
        a protected mode selector
      Fixed it for go32v1 (remove the $E0000000 offset !)

  Revision 1.9  1998/08/26 10:04:01  peter
    * new lfn check from mailinglist
    * renamed win95 -> LFNSupport
    + tb_selector, tb_offset for easier access to transferbuffer

  Revision 1.8  1998/08/16 20:39:49  peter
    + LFN Support

  Revision 1.7  1998/08/16 09:12:13  michael
  Corrected fexpand behaviour.

  Revision 1.6  1998/08/05 21:01:50  michael
  applied bugfix from maillist to fsearch

  Revision 1.5  1998/05/31 14:18:13  peter
    * force att or direct assembling
    * cleanup of some files

  Revision 1.4  1998/05/22 00:39:22  peter
    * go32v1, go32v2 recompiles with the new objects
    * remake3 works again with go32v2
    - removed some "optimizes" from daniel which were wrong

  Revision 1.3  1998/05/21 19:30:47  peter
    * objects compiles for linux
    + assign(pchar), assign(char), rename(pchar), rename(char)
    * fixed read_text_as_array
    + read_text_as_pchar which was not yet in the rtl
}



