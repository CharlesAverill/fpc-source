{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 1993,97 by Michael Van Canneyt,
    member of the Free Pascal development team.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{ These things are set in the makefile, }
{ But you can override them here.}

{ If you want to link to the C library, set the conditional crtlib }
{ $define crtlib}

{ If you use an aout system, set the conditional AOUT}
{ $Define AOUT}


Unit SysLinux;

{$I os.inc}

Interface

{$I systemh.inc}
{$I heaph.inc}

const
  UnusedHandle=$ffff; 
  StdInputHandle=0;
  StdOutputHandle=1;
  StdErrorHandle=2; 

var argc : longint;
    argv : ppchar;
    envp : ppchar;

Implementation

{$I system.inc}

Type
  PLongint = ^Longint;

{$ifdef crtlib}
Procedure _rtl_exit(l: longint); [ C ];
Function  _rtl_paramcount: longint; [ C ];
Procedure _rtl_paramstr(st: pchar; l: longint); [ C ];
Function  _rtl_open(f: pchar; flags: longint): longint; [ C ];
Procedure _rtl_close(h: longint); [ C ];
Procedure _rtl_write(h: longint; addr: longInt; len : longint); [ C ];
Procedure _rtl_erase(p: pchar); [ C ];
Procedure _rtl_rename(p1: pchar; p2 : pchar); [ C ];
Function  _rtl_read(h: longInt; addr: longInt; len : longint) : longint; [ C ];
Function  _rtl_filepos(Handle: longint): longint; [ C ];
Procedure _rtl_seek(Handle: longint; pos:longint); [ C ];
Function  _rtl_filesize(Handle:longint): longInt; [ C ];
Procedure _rtl_rmdir(buffer: pchar); [ C ];
Procedure _rtl_mkdir(buffer: pchar); [ C ];
Procedure _rtl_chdir(buffer: pchar); [ C ];
{$else}

{ used in syscall to report errors.}
var Errno : longint;

{ Include constant and type definitions }
{$i errno.inc    }  { Error numbers                 }
{$i sysnr.inc    }  { System call numbers           }
{$i sysconst.inc }  { Miscellaneous constants       }
{$i systypes.inc }  { Types needed for system calls }

{ Read actual system call definitions. }
{$i syscalls.inc }  

{$endif}

{*****************************************************************************
                       Misc. System Dependent Functions
*****************************************************************************}

Procedure Halt(ErrNum: Byte);
Begin
  ExitCode:=Errnum;
  ErrorAddr:=nil;
  Do_Exit;
{$ifdef i386}
  asm
    jmp _haltproc
  end;
{$else}
{$endif}
End;


Function ParamCount: Longint;
Begin
{$ifdef crtlib}
  ParamCount := _rtl_paramcount;
{$else}  
  Paramcount := argc-1
{$endif}
End;


Function ParamStr(l: Longint): String;
Var
  b      : Array[0..255] of Char;
{$ifndef crtlib}
  i      : longint;
  pp     : ppchar;
{$endif}
Begin
{$ifdef crtlib}
  _rtl_paramstr(@b, l);
{$else}  
  if l>argc then
   begin
     paramstr:='';
     exit
   end;
  pp:=argv;
  i:=0;
  while (i<l) and (pp^<>nil) do 
   begin
     pp:=pp+4;
     inc(i);
   end;
  if pp^<>nil then
   move (pp^^,b[0],255)
  else 
   b[0]:=#0;
{$endif}
  ParamStr:=StrPas(b);
End;

  
Procedure Randomize;
Begin
{$ifdef crtlib}
  _rtl_gettime(longint(@randseed));
{$else}
  randseed:=sys_time;
{$endif}
End;


{*****************************************************************************
                              Heap Management
*****************************************************************************}

{ ___brk_addr is defined and allocated in prt1.S. }

Function Get_Brk_addr : longint;
begin
{$ifdef i386}
  asm
    movl ___brk_addr,%eax
    leave
    ret
  end ['EAX'];
{$else}
{$endif}
end;


Procedure Set_brk_addr (NewAddr : longint);
begin
{$ifdef i386}
  asm
    movl 8(%ebp),%eax
    movl %eax,___brk_addr
  end ['EAX'];
{$else}
{$endif}
end;


Function brk(Location : longint) : Longint;
{ set end of data segment to location }
var t     : syscallregs;
    dummy : longint;

begin
  t.reg2:=Location;
  dummy:=syscall (syscall_nr_brk,t);
{$ifdef debug}
  writeln ('Brk syscall returned : ',dummy);
  writeln ('Errno = ',errno);
{$endif}
  set_brk_addr(dummy);
  brk:=dummy;
end;


Function init_brk : longint;
begin
  if Get_Brk_addr=0 then
   begin
     Set_brk_addr(brk(0));
     if Get_brk_addr=0 then
      exit(-1);
   end; 
  init_brk:=0; 
end;


Function sbrk(size : longint) : Longint;
var
  Temp  : longint;
begin
  if init_brk=0 then
   begin
     Temp:=Get_Brk_Addr+size;
     if brk(temp)=-1 then
      exit(-1);
     if Get_brk_addr=temp then
      exit(temp-size);
   end;
  exit(-1);
end;

{ include standard heap management }
{$I heap.inc}


{*****************************************************************************
                          Low Level File Routines
*****************************************************************************}

{
  The lowlevel file functions should take care of setting the InOutRes to the
  correct value if an error has occured, else leave it untouched
}

Procedure Errno2Inoutres;
{
  Convert ErrNo error to the correct Inoutres value
}  
begin
  if ErrNo=0 then { Else it will go through all the cases }
   exit;
  case ErrNo of
   Sys_ENFILE,
   Sys_EMFILE : Inoutres:=4;
   Sys_ENOENT : Inoutres:=2;
    Sys_EBADF : Inoutres:=6;
   Sys_ENOMEM,
   Sys_EFAULT : Inoutres:=217;
   Sys_EINVAL : Inoutres:=218;
    Sys_EPIPE,
    Sys_EINTR,
      Sys_EIO,
   Sys_EAGAIN,
   Sys_ENOSPC : Inoutres:=101;
 Sys_ENAMETOOLONG,
    Sys_ELOOP,
  Sys_ENOTDIR : Inoutres:=3;        
    Sys_EROFS : Inoutres:=150;
   Sys_EEXIST,
   Sys_EACCES : Inoutres:=5;
  Sys_ETXTBSY : Inoutres:=162;
  end; 
end;


Procedure Do_Close(Handle:Longint);
Begin
{$ifdef crtlib}
  _rtl_close(Handle);
{$else}
  sys_close(Handle);
{$endif}
End;


Procedure Do_Erase(p:pchar);
Begin
{$ifdef crtlib}
  _rtl_erase(p);
{$else}
  sys_unlink(p);
  Errno2Inoutres; 
{$endif}
End;


Procedure Do_Rename(p1,p2:pchar);
Begin
{$ifdef crtlib}
  _rtl_rename(p1,p2);
{$else }
  sys_rename(p1,p2);
  Errno2Inoutres; 
{$endif}
End;


Function Do_Write(Handle,Addr,Len:Longint):longint;
Begin
{$ifdef crtlib}
  _rtl_write(Handle,addr,len);
  Do_Write:=Len;
{$else}
  Do_Write:=sys_write(Handle,pchar(addr),len);
  Errno2Inoutres; 
{$endif}
  if Do_Write<0 then
   Do_Write:=0;
End;


Function Do_Read(Handle,Addr,Len:Longint):Longint;
Begin
{$ifdef crtlib}
  Do_Read:=_rtl_read(Handle,addr,len);
{$else}
  Do_Read:=sys_read(Handle,pchar(addr),len);
  Errno2Inoutres; 
{$endif}
  if Do_Read<0 then
   Do_Read:=0;
End;


Function Do_FilePos(Handle: Longint): Longint;
Begin
{$ifdef crtlib}
  Do_FilePos:=_rtl_filepos(Handle);
{$else}
  Do_FilePos:=sys_lseek(Handle, 0, Seek_Cur);
  Errno2Inoutres; 
{$endif}
End;


Procedure Do_Seek(Handle,Pos:Longint);
Begin
{$ifdef crtlib}
  _rtl_seek(Handle, Pos);
{$else}
  sys_lseek(Handle, pos, Seek_set);
{$endif}
End;


Function Do_SeekEnd(Handle:Longint): Longint;
begin
{$ifdef crtlib}
  Do_SeekEnd:=_rtl_filesize(Handle);
{$else}
  Do_SeekEnd:=sys_lseek(Handle,0,Seek_End);
{$endif}
end;


Function Do_FileSize(Handle:Longint): Longint;
{$ifndef crtlib}
var
  regs : Syscallregs;
  Info : Stat;
{$endif}
Begin
{$ifdef crtlib}
  Do_FileSize:=_rtl_filesize(Handle);
{$else}
  regs.reg2:=Handle;
  regs.reg3:=longint(@Info);
  if SysCall(SysCall_nr_fstat,regs)=0 then
   Do_FileSize:=Info.Size
  else
   Do_FileSize:=-1; 
  Errno2Inoutres; 
{$endif}
End;


Procedure Do_Truncate(Handle,Pos:longint);
{$ifndef crtlib}
var
  sr : syscallregs;
{$endif}  
begin
{$ifndef crtlib}
  sr.reg2:=Handle;
  sr.reg3:=Pos;
  syscall(syscall_nr_ftruncate,sr);
  Errno2Inoutres; 
{$endif}  
end;


Procedure Do_Open(var f;p:pchar;flags:longint);
{
  FileRec and textrec have both Handle and mode as the first items so
  they could use the same routine for opening/creating.
  when (flags and $10)   the file will be append
  when (flags and $100)  the file will be truncate/rewritten
  when (flags and $1000) there is no check for close (needed for textfiles)
}
var
{$ifndef crtlib}
  oflags : longint;
{$endif}
Begin
{ close first if opened }
  if ((flags and $1000)=0) then
   begin
     case FileRec(f).mode of
      fminput,fmoutput,fminout : Do_Close(FileRec(f).Handle);
      fmclosed : ;
     else
      begin
        inoutres:=102; {not assigned}
        exit;
      end;
     end;
   end;
{ reset file Handle }
  FileRec(f).Handle:=UnusedHandle;
{ We do the conversion of filemodes here, concentrated on 1 place }
  case (flags and 3) of
   0 : begin
         oflags :=Open_RDONLY;
         FileRec(f).mode:=fminput;
       end;      
   1 : begin
         oflags :=Open_WRONLY;
         FileRec(f).mode:=fmoutput;
       end;      
   2 : begin
         oflags :=Open_RDWR;
         FileRec(f).mode:=fminout;
       end;      
  end;
  if (flags and $100)=$100 then 
   oflags:=oflags or (Open_CREAT or Open_TRUNC)
  else
   if (flags and $10)=$10 then
    oflags:=oflags or (Open_APPEND);
{ empty name is special }
  if p[0]=#0 then
   begin
     case FileRec(f).mode of
       fminput : FileRec(f).Handle:=StdInputHandle;
      fmoutput,
      fmappend : begin
                   FileRec(f).Handle:=StdOutputHandle;
                   FileRec(f).mode:=fmoutput; {fool fmappend}
                 end;  
     end;
     exit;
   end;
{ real open call }  
{$ifdef crtlib}
  FileRec(f).Handle:=_rtl_open(p, oflags);
  if FileRec(f).Handle<0 then
   InOutRes:=2
  else
   InOutRes:=0; 
{$else}
  FileRec(f).Handle:=sys_open(p,oflags,438);
  Errno2Inoutres;
{$endif}
End;

{*****************************************************************************
                           UnTyped File Handling
*****************************************************************************}

{$i file.inc}

{*****************************************************************************
                           Typed File Handling
*****************************************************************************}

{$i typefile.inc}

{*****************************************************************************
                           Text File Handling
*****************************************************************************}

{$DEFINE SHORT_LINEBREAK}
{$DEFINE EXTENDED_EOF}

{$i text.inc}

{*****************************************************************************
                           Directory Handling
*****************************************************************************}

Procedure MkDir(Const s: String);
Var
  Buffer: Array[0..255] of Char;
Begin
  Move(s[1], Buffer, Length(s));
  Buffer[Length(s)] := #0;
{$ifdef crtlib}
  _rtl_mkdir(@buffer);
{$else}
  sys_mkdir(@buffer, 511);
  Errno2Inoutres;
{$endif}
End;


Procedure RmDir(Const s: String);
Var
  Buffer: Array[0..255] of Char;
Begin
  Move(s[1], Buffer, Length(s));
  Buffer[Length(s)] := #0;
{$ifdef crtlib}
  _rtl_rmdir(@buffer);
{$else}
  sys_rmdir(@buffer);
  Errno2Inoutres;
{$endif}
End;


Procedure ChDir(Const s: String);
Var
  Buffer: Array[0..255] of Char;
Begin
  Move(s[1], Buffer, Length(s));
  Buffer[Length(s)] := #0;
{$ifdef crtlib}
  _rtl_chdir(@buffer);
{$else}
  sys_chdir(@buffer);
  Errno2Inoutres;
{$endif}
End;


procedure getdir(drivenr : byte;var dir : string);
{$ifndef crtlib}
var
  thisdir      : stat;
  rootino,
  thisino,
  dotdotino    : longint;
  rootdev,
  thisdev,
  dotdotdev    : word;
  thedir,dummy : string[255];
  dirstream    : pdir;
  d            : pdirent;
  mountpoint   : boolean;
  predot       : string[255];

  procedure dodispose (p : pdir);
  begin
    dispose (p^.buf);
    dispose (p)
  end;
{$endif}
begin
  drivenr:=0;
  dir:='';
{$ifndef crtlib}  
  thedir:='/'#0;
  if sys_stat(@thedir[1],thisdir)<0 then
   exit;
  rootino:=thisdir.ino;
  rootdev:=thisdir.dev;
  thedir:='.'#0;
  if sys_stat(@thedir[1],thisdir)<0 then
   exit;
  thisino:=thisdir.ino;
  thisdev:=thisdir.dev;
  { Now we can uniquely identify the current and root dir }
  thedir:='';
  predot:='';
  while not ((thisino=rootino) and (thisdev=rootdev)) do
   begin
   { Are we on a mount point ? }
     dummy:=predot+'..'#0;
     if sys_stat(@dummy[1],thisdir)<0 then
      exit;
     dotdotino:=thisdir.ino;
     dotdotdev:=thisdir.dev;
     mountpoint:=(thisdev<>dotdotdev);
   { Now, Try to find the name of this dir in the previous one }
     dirstream:=opendir (@dummy[1]);
     if dirstream=nil then
      exit;
     repeat
       d:=sys_readdir (dirstream);
       if (d<>nil) and 
          (not ((d^.name[0]='.') and ((d^.name[1]=#0) or ((d^.name[1]='.') and (d^.name[2]=#0))))) and
          (mountpoint or (d^.ino=thisino)) then
        begin
          dummy:=predot+'../'+strpas(@(d^.name[0]))+#0;
          if sys_stat (@(dummy[1]),thisdir)<0 then
           d:=nil;
        end;
     until (d=nil) or ((thisdir.dev=thisdev) and (thisdir.ino=thisino) );
     if (closedir (dirstream)<0) or (d=nil) then
      begin
        dodispose (dirstream);
        exit;
      end;
   { At this point, d.name contains the name of the current dir}
     thedir:='/'+strpas(@(d^.name[0]))+thedir;
     thisdev:=dotdotdev;
     thisino:=dotdotino;
     predot:=predot+'../';
   { We don't want to clutter op the heap with DIR records... }
     dodispose (dirstream);
   end;
{ Now rootino=thisino and rootdev=thisdev so we've reached / }
  dir:=thedir
{$endif}
end;


{*****************************************************************************
                         SystemUnit Initialization
*****************************************************************************}

Procedure SegFaultHandler (Sig : longint);
begin
  if sig=11 then
   RunError (216);
end;


Procedure InstallSegFaultHandler;
var
  sr : syscallregs;
begin
  sr.reg2:=11;
  sr.reg3:=longint(@SegFaultHandler);
  syscall(syscall_nr_signal,sr);
end;


procedure OpenStdIO(var f:text;mode:word;const std:string;hdl:longint);
begin
  Assign(f,std);
  TextRec(f).Handle:=hdl;
  TextRec(f).Mode:=mode;
  TextRec(f).InOutFunc:=@FileInOutFunc;
  TextRec(f).FlushFunc:=@FileInOutFunc;
  TextRec(f).Closefunc:=@fileclosefunc;
end;


Begin
{ Initialize ExitProc }
  ExitProc:=Nil;
{ Set up segfault Handler }
  InstallSegFaultHandler;
{ Setup heap }
  InitHeap;
{ Setup stdin, stdout and stderr }
  OpenStdIO(Input,fmInput,'stdin',StdInputHandle);
  OpenStdIO(Output,fmOutput,'stdout',StdOutputHandle);
  OpenStdIO(StdErr,fmOutput,'stderr',StdErrorHandle);
{ Reset IO Error }  
  InOutRes:=0;
End.

{
  $Log$
  Revision 1.2  1998-05-06 12:35:26  michael
  + Removed log from before restored version.

  Revision 1.1.1.1  1998/03/25 11:18:43  root
  * Restored version
}
