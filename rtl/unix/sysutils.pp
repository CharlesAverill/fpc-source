{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by Florian Klaempfl
    member of the Free Pascal development team

    Sysutils unit for linux

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit sysutils;
interface

{$MODE objfpc}
{ force ansistrings }
{$H+}

{$DEFINE HAS_SLEEP}
{$DEFINE HAS_OSERROR}

uses
  Unix,errors,sysconst;

{ Include platform independent interface part }
{$i sysutilh.inc}


implementation

Uses UnixUtil,Baseunix,UnixType;

{$Define OS_FILEISREADONLY} // Specific implementation for Unix.

{ Include platform independent implementation part }
{$i sysutils.inc}

{****************************************************************************
                              File Functions
****************************************************************************}

Function FileOpen (Const FileName : string; Mode : Integer) : Longint;

Var LinuxFlags : longint;

BEGIN
  LinuxFlags:=0;
  Case (Mode and 3) of
    0 : LinuxFlags:=LinuxFlags or O_RdOnly;
    1 : LinuxFlags:=LinuxFlags or O_WrOnly;
    2 : LinuxFlags:=LinuxFlags or O_RdWr;
  end;
  FileOpen:=fpOpen (FileName,LinuxFlags);
  //!! We need to set locking based on Mode !!
end;


Function FileCreate (Const FileName : String) : Longint;

begin
  FileCreate:=fpOpen(FileName,O_RdWr or O_Creat or O_Trunc);
end;


Function FileCreate (Const FileName : String;Mode : Longint) : Longint;

Var LinuxFlags : longint;

BEGIN
  LinuxFlags:=0;
  Case (Mode and 3) of
    0 : LinuxFlags:=LinuxFlags or O_RdOnly;
    1 : LinuxFlags:=LinuxFlags or O_WrOnly;
    2 : LinuxFlags:=LinuxFlags or O_RdWr;
  end;
  FileCreate:=fpOpen(FileName,LinuxFlags or O_Creat or O_Trunc);
end;


Function FileRead (Handle : Longint; Var Buffer; Count : longint) : Longint;

begin
  FileRead:=fpRead (Handle,Buffer,Count);
end;


Function FileWrite (Handle : Longint; const Buffer; Count : Longint) : Longint;

begin
  FileWrite:=fpWrite (Handle,Buffer,Count);
end;


Function FileSeek (Handle,FOffset,Origin : Longint) : Longint;

begin
  FileSeek:=fplSeek (Handle,FOffset,Origin);
end;


Function FileSeek (Handle : Longint; FOffset,Origin : Int64) : Int64;

begin
  {$warning need to add 64bit call }
  FileSeek:=fplSeek (Handle,FOffset,Origin);
end;


Procedure FileClose (Handle : Longint);

begin
  fpclose(Handle);
end;

Function FileTruncate (Handle,Size: Longint) : boolean;

begin
  FileTruncate:=fpftruncate(Handle,Size)>=0;
end;

Function FileAge (Const FileName : String): Longint;

Var Info : Stat;
    Y,M,D,hh,mm,ss : word;

begin
  If  fpstat (FileName,Info)<0 then
    exit(-1)
  else
    begin
    EpochToLocal(info.st_mtime,y,m,d,hh,mm,ss);
    Result:=DateTimeToFileDate(EncodeDate(y,m,d)+EncodeTime(hh,mm,ss,0));
    end;
end;


Function FileExists (Const FileName : String) : Boolean;

Var Info : Stat;

begin
  FileExists:=fpstat(filename,Info)>=0;
end;


Function DirectoryExists (Const Directory : String) : Boolean;

Var Info : Stat;

begin
  DirectoryExists:=(fpstat(Directory,Info)>=0) and fpS_ISDIR(Info.st_mode);
end;


Function LinuxToWinAttr (FN : Pchar; Const Info : Stat) : Longint;

begin
  Result:=faArchive;
  If fpS_ISDIR(Info.st_mode) then
    Result:=Result or faDirectory;
  If (FN[0]='.') and (not (FN[1] in [#0,'.']))  then
    Result:=Result or faHidden;
  If (Info.st_Mode and S_IWUSR)=0 Then
     Result:=Result or faReadOnly;
  If fpS_ISSOCK(Info.st_mode) or fpS_ISBLK(Info.st_mode) or fpS_ISCHR(Info.st_mode) or fpS_ISFIFO(Info.st_mode) Then
     Result:=Result or faSysFile;
end;

{
 GlobToSearch takes a glob entry, stats the file.
 The glob entry is removed.
 If FileAttributes match, the entry is reused
}

Type
  TGlobSearchRec = Record
    Path       : String;
    GlobHandle : PGlob;
  end;
  PGlobSearchRec = ^TGlobSearchRec;

Function GlobToTSearchRec (Var Info : TSearchRec) : Boolean;

Var SInfo : Stat;
    p     : Pglob;
    GlobSearchRec : PGlobSearchrec;

begin
  GlobSearchRec:=PGlobSearchrec(Info.FindHandle);
  P:=GlobSearchRec^.GlobHandle;
  Result:=P<>Nil;
  If Result then
    begin
    GlobSearchRec^.GlobHandle:=P^.Next;
    Result:=Fpstat(GlobSearchRec^.Path+StrPas(p^.name),SInfo)>=0;
    If Result then
      begin
      Info.Attr:=LinuxToWinAttr(p^.name,SInfo);
      Result:=(Info.ExcludeAttr and Info.Attr)=0;
      If Result Then
         With Info do
           begin
           Attr:=Info.Attr;
           If P^.Name<>Nil then
           Name:=strpas(p^.name);
           Time:=Sinfo.st_mtime;
           Size:=Sinfo.st_Size;
           end;
      end;
    P^.Next:=Nil;
    GlobFree(P);
    end;
end;

Function DoFind(Var Rslt : TSearchRec) : Longint;

Var
  GlobSearchRec : PGlobSearchRec;

begin
  Result:=-1;
  GlobSearchRec:=PGlobSearchRec(Rslt.FindHandle);
  If (GlobSearchRec^.GlobHandle<>Nil) then
    While (GlobSearchRec^.GlobHandle<>Nil) and not (Result=0) do
      If GlobToTSearchRec(Rslt) Then Result:=0;
end;



Function FindFirst (Const Path : String; Attr : Longint; Var Rslt : TSearchRec) : Longint;

Var
  GlobSearchRec : PGlobSearchRec;

begin
  New(GlobSearchRec);
  GlobSearchRec^.Path:=ExpandFileName(ExtractFilePath(Path));
  GlobSearchRec^.GlobHandle:=Glob(Path);
  Rslt.ExcludeAttr:=Not Attr; //!! Not correct !!
  Rslt.FindHandle:=Longint(GlobSearchRec);
  Result:=DoFind (Rslt);
end;


Function FindNext (Var Rslt : TSearchRec) : Longint;

begin
  Result:=DoFind (Rslt);
end;


Procedure FindClose (Var F : TSearchrec);

Var
  GlobSearchRec : PGlobSearchRec;

begin
  GlobSearchRec:=PGlobSearchRec(F.FindHandle);
  GlobFree (GlobSearchRec^.GlobHandle);
  Dispose(GlobSearchRec);
end;


Function FileGetDate (Handle : Longint) : Longint;

Var Info : Stat;

begin
  If (fpFStat(Handle,Info))<0 then
    Result:=-1
  else
    Result:=Info.st_Mtime;
end;


Function FileSetDate (Handle,Age : Longint) : Longint;

begin
  // Impossible under Linux from FileHandle !!
  FileSetDate:=-1;
end;


Function FileGetAttr (Const FileName : String) : Longint;

Var Info : Stat;

begin
  If  FpStat (FileName,Info)<0 then
    Result:=-1
  Else
    Result:=LinuxToWinAttr(Pchar(FileName),Info);
end;


Function FileSetAttr (Const Filename : String; Attr: longint) : Longint;

begin
  Result:=-1;
end;


Function DeleteFile (Const FileName : String) : Boolean;

begin
  Result:=fpUnLink (FileName)>=0;
end;


Function RenameFile (Const OldName, NewName : String) : Boolean;

begin
  RenameFile:=BaseUnix.FpRename(OldNAme,NewName)>=0;
end;

Function FileIsReadOnly(const FileName: String): Boolean; 
 
begin
  Result := fpAccess(PChar(FileName),W_OK)= 0;
end;  

{****************************************************************************
                              Disk Functions
****************************************************************************}

{
  The Diskfree and Disksize functions need a file on the specified drive, since this
  is required for the statfs system call.
  These filenames are set in drivestr[0..26], and have been preset to :
   0 - '.'      (default drive - hence current dir is ok.)
   1 - '/fd0/.'  (floppy drive 1 - should be adapted to local system )
   2 - '/fd1/.'  (floppy drive 2 - should be adapted to local system )
   3 - '/'       (C: equivalent of dos is the root partition)
   4..26          (can be set by you're own applications)
  ! Use AddDisk() to Add new drives !
  They both return -1 when a failure occurs.
}
Const
  FixDriveStr : array[0..3] of pchar=(
    '.',
    '/fd0/.',
    '/fd1/.',
    '/.'
    );
var
  Drives   : byte;
  DriveStr : array[4..26] of pchar;

Procedure AddDisk(const path:string);
begin
  if not (DriveStr[Drives]=nil) then
   FreeMem(DriveStr[Drives],StrLen(DriveStr[Drives])+1);
  GetMem(DriveStr[Drives],length(Path)+1);
  StrPCopy(DriveStr[Drives],path);
  inc(Drives);
  if Drives>26 then
   Drives:=4;
end;


Function DiskFree(Drive: Byte): int64;
var
  fs : tstatfs;
Begin
  if ((Drive<4) and (not (fixdrivestr[Drive]=nil)) and (statfs(StrPas(fixdrivestr[drive]),fs)<>-1)) or
     ((not (drivestr[Drive]=nil)) and (statfs(StrPas(drivestr[drive]),fs)<>-1)) then
   Diskfree:=int64(fs.bavail)*int64(fs.bsize)
  else
   Diskfree:=-1;
End;



Function DiskSize(Drive: Byte): int64;
var
  fs : tstatfs;
Begin
  if ((Drive<4) and (not (fixdrivestr[Drive]=nil)) and (statfs(StrPas(fixdrivestr[drive]),fs)<>-1)) or
     ((not (drivestr[Drive]=nil)) and (statfs(StrPas(drivestr[drive]),fs)<>-1)) then
   DiskSize:=int64(fs.blocks)*int64(fs.bsize)
  else
   DiskSize:=-1;
End;


Function GetCurrentDir : String;
begin
  GetDir (0,Result);
end;


Function SetCurrentDir (Const NewDir : String) : Boolean;
begin
  {$I-}
   ChDir(NewDir);
  {$I+}
  result := (IOResult = 0);
end;


Function CreateDir (Const NewDir : String) : Boolean;
begin
  {$I-}
   MkDir(NewDir);
  {$I+}
  result := (IOResult = 0);
end;


Function RemoveDir (Const Dir : String) : Boolean;
begin
  {$I-}
   RmDir(Dir);
  {$I+}
  result := (IOResult = 0);
end;


{****************************************************************************
                              Misc Functions
****************************************************************************}

procedure Beep;
begin
end;


{****************************************************************************
                              Locale Functions
****************************************************************************}

Procedure GetLocalTime(var SystemTime: TSystemTime);
begin
  Unix.GetTime(SystemTime.Hour, SystemTime.Minute, SystemTime.Second);
  Unix.GetDate(SystemTime.Year, SystemTime.Month, SystemTime.Day);
  SystemTime.MilliSecond := 0;
end ;


Procedure InitAnsi;
Var
  i : longint;
begin
  {  Fill table entries 0 to 127  }
  for i := 0 to 96 do
    UpperCaseTable[i] := chr(i);
  for i := 97 to 122 do
    UpperCaseTable[i] := chr(i - 32);
  for i := 123 to 191 do
    UpperCaseTable[i] := chr(i);
  Move (CPISO88591UCT,UpperCaseTable[192],SizeOf(CPISO88591UCT));

  for i := 0 to 64 do
    LowerCaseTable[i] := chr(i);
  for i := 65 to 90 do
    LowerCaseTable[i] := chr(i + 32);
  for i := 91 to 191 do
    LowerCaseTable[i] := chr(i);
  Move (CPISO88591LCT,LowerCaseTable[192],SizeOf(CPISO88591UCT));
end;


Procedure InitInternational;
begin
  InitAnsi;
end;

function SysErrorMessage(ErrorCode: Integer): String;

begin
  Result:=StrError(ErrorCode);
end;

{****************************************************************************
                              OS utility functions
****************************************************************************}

Function GetEnvironmentVariable(Const EnvVar : String) : String;

begin
  Result:=StrPas(BaseUnix.FPGetenv(PChar(EnvVar)));
end;

{$define FPC_USE_FPEXEC}  // leave the old code under IFDEF for a while.
function ExecuteProcess(Const Path: AnsiString; Const ComLine: AnsiString):integer;
var
  pid    : longint;
  err    : longint;
  e      : EOSError;
  CommandLine: AnsiString;
  cmdline2 : ppchar;

Begin
  { always surround the name of the application by quotes
    so that long filenames will always be accepted. But don't
    do it if there are already double quotes!
  }
  {$ifdef FPC_USE_FPEXEC}	// Only place we still parse
   cmdline2:=nil;		
   if Comline<>'' Then
     begin
       CommandLine:=ComLine;
       cmdline2:=StringtoPPChar(CommandLine,1);
       cmdline2^:=pchar(Path);
     end;	
  {$else}
  if Pos ('"', Path) = 0 then
    CommandLine := '"' + Path + '"'
  else
    CommandLine := Path;
  if ComLine <> '' then
    CommandLine := Commandline + ' ' + ComLine;
  {$endif}
  pid:=fpFork;
  if pid=0 then
   begin
   {The child does the actual exec, and then exits}
    {$ifdef FPC_USE_FPEXEC}
      fpexecv(pchar(Path),Cmdline2);	
    {$else}
      Execl(CommandLine);
    {$endif}
     { If the execve fails, we return an exitvalue of 127, to let it be known}
     fpExit(127);
   end
  else
   if pid=-1 then         {Fork failed}
    begin
      e:=EOSError.CreateFmt(SExecuteProcessFailed,[CommandLine,-1]);
      e.ErrorCode:=-1;
      raise e;
    end;
    
  { We're in the parent, let's wait. }
  result:=WaitProcess(pid); // WaitPid and result-convert

  if (result>=0) and (result<>127) then
    result:=0
  else
    begin
      e:=EOSError.CreateFmt(SExecuteProcessFailed,[CommandLine,result]);
      e.ErrorCode:=result;
      raise e;
    end;
End;

function ExecuteProcess(Const Path: AnsiString; Const ComLine: Array Of AnsiString):integer;

var
  pid    : longint;
  err    : longint;
  e : EOSError;

Begin
  { always surround the name of the application by quotes
    so that long filenames will always be accepted. But don't
    do it if there are already double quotes!
  }
  pid:=fpFork;
  if pid=0 then
   begin
     {The child does the actual exec, and then exits}
      fpexecl(Path,Comline);
     { If the execve fails, we return an exitvalue of 127, to let it be known}
     fpExit(127);
   end
  else
   if pid=-1 then         {Fork failed}
    begin
      e:=EOSError.CreateFmt(SExecuteProcessFailed,[Path,-1]);
      e.ErrorCode:=-1;
      raise e;
    end;
    
  { We're in the parent, let's wait. }
  result:=WaitProcess(pid); // WaitPid and result-convert

  if (result>=0) and (result<>127) then
    result:=0
  else
    begin
      e:=EOSError.CreateFmt(SExecuteProcessFailed,[Path,result]);
      e.ErrorCode:=result;
      raise e;
    end;
End;


procedure Sleep(milliseconds: Cardinal);

Var
  fd : Integer;
  fds : TfdSet;
  timeout : TimeVal;
  
begin
  fd:=FileOpen('/dev/null',fmOpenRead);
  If Not(Fd<0) then
    begin
    fpfd_zero(fds);
    fpfd_set(0,fds);
    timeout.tv_sec:=Milliseconds div 1000;
    timeout.tv_usec:=(Milliseconds mod 1000) * 1000;
    fpSelect(1,Nil,Nil,@fds,@timeout);
    end;
end;

Function GetLastOSError : Integer;

begin
  Result:=fpgetErrNo;
end;
  
{****************************************************************************
                              Initialization code
****************************************************************************}

Initialization
  InitExceptions;       { Initialize exceptions. OS independent }
  InitInternational;    { Initialize internationalization settings }
Finalization
  DoneExceptions;
end.
{

  $Log$
  Revision 1.37  2004-03-04 22:15:16  marco
   * UnixType changes. Please report problems to me.

  Revision 1.36  2004/02/13 10:50:23  marco
   * Hopefully last large changes to fpexec and friends.
  	- naming conventions changes from Michael.
  	- shell functions get alternative under ifdef.
  	- arraystring function moves to unixutil
  	- unixutil now regards quotes in stringtoppchar.
  	- sysutils/unix get executeprocess(ansi,array of ansi), and
  		both executeprocess functions are fixed
   	- Sysutils/win32 get executeprocess(ansi,array of ansi)

  Revision 1.35  2004/02/12 15:31:06  marco
   * First version of fpexec change. Still under ifdef or silently overloaded

  Revision 1.34  2004/02/09 17:11:17  marco
   * fixed for 1.0 errno->fpgeterrno

  Revision 1.33  2004/02/08 14:50:51  michael
  + Added fileIsReadOnly

  Revision 1.32  2004/02/08 11:01:17  michael
  + Implemented getlastoserror

  Revision 1.31  2004/01/20 23:13:53  hajny
    * ExecuteProcess fixes, ProcessID and ThreadID added

  Revision 1.30  2004/01/10 17:34:36  michael
  + Implemented sleep() on Unix.

  Revision 1.29  2004/01/05 22:42:35  florian
    * compilation error fixed

  Revision 1.28  2004/01/05 22:37:15  florian
    * changed sysutils.exec to ExecuteProcess

  Revision 1.27  2004/01/03 09:09:11  marco
   * Unix exec(ansistring)

  Revision 1.26  2003/11/26 20:35:14  michael
  + Some fixes to have everything compile again

  Revision 1.25  2003/11/17 10:05:51  marco
   * threads for FreeBSD. Not working tho

  Revision 1.24  2003/10/25 23:43:59  hajny
    * THandle in sysutils common using System.THandle

  Revision 1.23  2003/10/07 08:28:49  marco
   * fix from Vincent to casetables

  Revision 1.22  2003/09/27 12:51:33  peter
    * fpISxxx macros renamed to C compliant fpS_ISxxx

  Revision 1.21  2003/09/17 19:07:44  marco
   * more fixes for Unix<->unixutil

  Revision 1.20  2003/09/17 12:41:31  marco
   * Uses more baseunix, less unix now

  Revision 1.19  2003/09/14 20:15:01  marco
   * Unix reform stage two. Remove all calls from Unix that exist in Baseunix.

  Revision 1.18  2003/04/01 15:57:41  peter
    * made THandle platform dependent and unique type

  Revision 1.17  2003/03/30 10:38:00  armin
  * corrected typo in DirectoryExists

  Revision 1.16  2003/03/29 18:21:42  hajny
    * DirectoryExists declaration changed to that one from fixes branch

  Revision 1.15  2003/03/28 19:06:59  peter
    * directoryexists added

  Revision 1.14  2003/01/03 20:41:04  peter
    * FileCreate(string,mode) overload added

  Revision 1.13  2002/09/07 16:01:28  peter
    * old logs removed and tabs fixed

  Revision 1.12  2002/01/25 16:23:03  peter
    * merged filesearch() fix

}