{
 $Id$
 ****************************************************************************

    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2002 by Free Pascal development team

    Free Pascal - OS/2 runtime library

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

****************************************************************************}

unit {$ifdef VER1_0}sysos2{$else}System{$endif};

interface

{$ifdef SYSTEMDEBUG}
  {$define SYSTEMEXCEPTIONDEBUG}
  {.$define IODEBUG}
  {.$define DEBUGENVIRONMENT}
  {.$define DEBUGARGUMENTS}
{$endif SYSTEMDEBUG}

{ $DEFINE OS2EXCEPTIONS}

{$I systemh.inc}

{$IFDEF OS2EXCEPTIONS}
(* Types and constants for exception handler support *)
type
{x}   PEXCEPTION_FRAME = ^TEXCEPTION_FRAME;
{x}   TEXCEPTION_FRAME = record
{x}     next : PEXCEPTION_FRAME;
{x}     handler : pointer;
{x}   end;

{$ENDIF OS2EXCEPTIONS}

{$I heaph.inc}

{Platform specific information}
type
  THandle = Longint;

const
  LineEnding = #13#10;
{ LFNSupport is defined separately below!!! }
  DirectorySeparator = '\';
  DriveSeparator = ':';
  PathSeparator = ';';
{ FileNameCaseSensitive is defined separately below!!! }

type    Tos=(osDOS,osOS2,osDPMI);

const   os_mode: Tos = osOS2;
        first_meg: pointer = nil;

{$IFDEF OS2EXCEPTIONS}
{x}  System_exception_frame : PEXCEPTION_FRAME =nil;
{$ENDIF OS2EXCEPTIONS}

type    TByteArray = array [0..$ffff] of byte;
        PByteArray = ^TByteArray;

        TSysThreadIB = record
            TID,
            Priority,
            Version: cardinal;
            MCCount,
            MCForceFlag: word;
        end;
        PSysThreadIB = ^TSysThreadIB;

        TThreadInfoBlock = record
            PExChain,
            Stack,
            StackLimit: pointer;
            TIB2: PSysThreadIB;
            Version,
            Ordinal: cardinal;
        end;
        PThreadInfoBlock = ^TThreadInfoBlock;
        PPThreadInfoBlock = ^PThreadInfoBlock;

        TProcessInfoBlock = record
            PID,
            ParentPid,
            Handle: cardinal;
            Cmd,
            Env: PByteArray;
            Status,
            ProcType: cardinal;
        end;
        PProcessInfoBlock = ^TProcessInfoBlock;
        PPProcessInfoBlock = ^PProcessInfoBlock;

const   UnusedHandle=-1;
        StdInputHandle=0;
        StdOutputHandle=1;
        StdErrorHandle=2;

        LFNSupport: boolean = true;
        FileNameCaseSensitive: boolean = false;

        sLineBreak = LineEnding;
        DefaultTextLineBreakStyle : TTextLineBreakStyle = tlbsCRLF;

var
{ C-compatible arguments and environment }
  argc  : longint;
  argv  : ppchar;
  envp  : ppchar;
  EnvC: cardinal;

(* Pointer to the block of environment variables - used e.g. in unit Dos. *)
  Environment: PChar;

var
(* Type / run mode of the current process: *)
(* 0 .. full screen OS/2 session           *)
(* 1 .. DOS session                        *)
(* 2 .. VIO windowable OS/2 session        *)
(* 3 .. Presentation Manager OS/2 session  *)
(* 4 .. detached (background) OS/2 process *)
  ApplicationType: cardinal;

implementation

{$I system.inc}


procedure DosGetInfoBlocks (PATIB: PPThreadInfoBlock;
                            PAPIB: PPProcessInfoBlock); cdecl;
                            external 'DOSCALLS' index 312;

function DosLoadModule (ObjName: PChar; ObjLen: cardinal; DLLName: PChar;
                                        var Handle: cardinal): cardinal; cdecl;
external 'DOSCALLS' index 318;

function DosQueryProcAddr (Handle, Ordinal: cardinal; ProcName: PChar;
                                        var Address: pointer): cardinal; cdecl;
external 'DOSCALLS' index 321;

function DosSetRelMaxFH (var ReqCount: longint; var CurMaxFH: cardinal):
                                                               cardinal; cdecl;
external 'DOSCALLS' index 382;

function DosSetCurrentDir (Name:PChar): cardinal; cdecl;
external 'DOSCALLS' index 255;

procedure DosQueryCurrentDisk(var DiskNum:cardinal;var Logical:cardinal); cdecl;
external 'DOSCALLS' index 275;

function DosSetDefaultDisk (DiskNum:cardinal): cardinal; cdecl;
external 'DOSCALLS' index 220;

{ This is not real prototype, but is close enough }
{ for us (the 2nd parameter is actually a pointer }
{ to a structure).                                }
function DosCreateDir (Name: PChar; P: pointer): cardinal; cdecl;
external 'DOSCALLS' index 270;

function DosDeleteDir (Name: PChar): cardinal; cdecl;
external 'DOSCALLS' index 226;

function DosQueryCurrentDir(DiskNum:cardinal;var Buffer;
                            var BufLen:cardinal): cardinal; cdecl;
external 'DOSCALLS' index 274;

function DosMove(OldFile,NewFile:PChar):cardinal; cdecl;
    external 'DOSCALLS' index 271;

function DosDelete(FileName:PChar):cardinal; cdecl;
    external 'DOSCALLS' index 259;

procedure DosExit(Action, Result: cardinal); cdecl;
    external 'DOSCALLS' index 234;

// EAs not used in System unit
function DosOpen(FileName:PChar;var Handle: THandle;var Action:cardinal;
                 InitSize,Attrib,OpenFlags,FileMode:cardinal;
                 EA:Pointer): cardinal; cdecl;
    external 'DOSCALLS' index 273;

function DosClose(Handle: THandle): cardinal; cdecl;
    external 'DOSCALLS' index 257;

function DosRead(Handle: THandle; Buffer: Pointer; Count: cardinal;
                                      var ActCount: cardinal): cardinal; cdecl;
    external 'DOSCALLS' index 281;

function DosWrite(Handle: THandle; Buffer: Pointer;Count: cardinal;
                                      var ActCount: cardinal): cardinal; cdecl;
    external 'DOSCALLS' index 282;

function DosSetFilePtr(Handle: THandle; Pos:longint; Method:cardinal;
                                     var PosActual: cardinal): cardinal; cdecl;
    external 'DOSCALLS' index 256;

function DosSetFileSize(Handle: THandle; Size: cardinal): cardinal; cdecl;
    external 'DOSCALLS' index 272;

function DosQueryHType(Handle: THandle; var HandType: cardinal;
                                          var Attr: cardinal): cardinal; cdecl;
    external 'DOSCALLS' index 224;

type
  TSysDateTime=packed record
    Hour,
    Minute,
    Second,
    Sec100,
    Day,
    Month: byte;
    Year: word;
    TimeZone: smallint;
    WeekDay: byte;
  end;

function DosGetDateTime(var Buf:TSysDateTime): cardinal; cdecl;
    external 'DOSCALLS' index 230;

   { converts an OS/2 error code to a TP compatible error }
   { code. Same thing exists under most other supported   }
   { systems.                                             }
   { Only call for OS/2 DLL imported routines             }
   Procedure Errno2InOutRes;
   Begin
     { errors 1..18 are the same as in DOS }
     case InOutRes of
      { simple offset to convert these error codes }
      { exactly like the error codes in Win32      }
      19..31 : InOutRes := InOutRes + 131;
      { gets a bit more complicated ... }
      32..33 : InOutRes := 5;
      38 : InOutRes := 100;
      39 : InOutRes := 101;
      112 : InOutRes := 101;
      110 : InOutRes := 5;
      114 : InOutRes := 6;
      290 : InOutRes := 290;
     end;
     { all other cases ... we keep the same error code }
   end;


{$IFDEF OS2EXCEPTIONS}
(*
The operating system defines a class of error conditions called exceptions, and specifies the default actions that are taken when these exceptions occur. The system default action in most cases is to terminate the thread that caused the exception.

Exception values have the following 32-bit format:

 3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
���������������������������������������������������������������Ŀ
�Sev�C�       Facility          �               Code            �
�����������������������������������������������������������������


Sev Severity code. Possible values are described in the following list:

00 Success
01 Informational
10 Warning
11 Error

C Customer code flag.

Facility Facility code.

Code Facility's status code.

Exceptions that are specific to OS/2 Version 2.X (for example, XCPT_SIGNAL)
have a facility code of 1.

System exceptions include both synchronous and asynchronous exceptions.
Synchronous exceptions are caused by events that are internal to a thread's
execution. For example, synchronous exceptions could be caused by invalid
parameters, or by a thread's request to end its own execution.

Asynchronous exceptions are caused by events that are external to a thread's
execution. For example, an asynchronous exception can be caused by a user's
entering a Ctrl+C or Ctrl+Break key sequence, or by a process' issuing
DosKillProcess to end the execution of another process.

The Ctrl+Break and Ctrl+C exceptions are also known as signals, or as signal
exceptions.

The following tables show the symbolic names of system exceptions, their
numerical values, and related information fields.

Portable, Non-Fatal, Software-Generated Exceptions

������������������������������������������������Ŀ
�Exception Name                       �Value     �
������������������������������������������������Ĵ
�XCPT_GUARD_PAGE_VIOLATION            �0x80000001�
�  ExceptionInfo[0] - R/W flag        �          �
�  ExceptionInfo[1] - FaultAddr       �          �
������������������������������������������������Ĵ
�XCPT_UNABLE_TO_GROW_STACK            �0x80010001�
��������������������������������������������������


Portable, Fatal, Hardware-Generated Exceptions

��������������������������������������������������������������Ŀ
�Exception Name                       �Value     �Related Trap �
��������������������������������������������������������������Ĵ
�XCPT_ACCESS_VIOLATION                �0xC0000005�0x09, 0x0B,  �
�  ExceptionInfo[0] - Flags           �          �0x0C, 0x0D,  �
�    XCPT_UNKNOWN_ACCESS  0x0         �          �0x0E         �
�    XCPT_READ_ACCESS     0x1         �          �             �
�    XCPT_WRITE_ACCESS    0x2         �          �             �
�    XCPT_EXECUTE_ACCESS  0x4         �          �             �
�    XCPT_SPACE_ACCESS    0x8         �          �             �
�    XCPT_LIMIT_ACCESS    0x10        �          �             �
�  ExceptionInfo[1] - FaultAddr       �          �             �
��������������������������������������������������������������Ĵ
�XCPT_INTEGER_DIVIDE_BY_ZERO          �0xC000009B�0            �
��������������������������������������������������������������Ĵ
�XCPT_FLOAT_DIVIDE_BY_ZERO            �0xC0000095�0x10         �
��������������������������������������������������������������Ĵ
�XCPT_FLOAT_INVALID_OPERATION         �0xC0000097�0x10         �
��������������������������������������������������������������Ĵ
�XCPT_ILLEGAL_INSTRUCTION             �0xC000001C�0x06         �
��������������������������������������������������������������Ĵ
�XCPT_PRIVILEGED_INSTRUCTION          �0xC000009D�0x0D         �
��������������������������������������������������������������Ĵ
�XCPT_INTEGER_OVERFLOW                �0xC000009C�0x04         �
��������������������������������������������������������������Ĵ
�XCPT_FLOAT_OVERFLOW                  �0xC0000098�0x10         �
��������������������������������������������������������������Ĵ
�XCPT_FLOAT_UNDERFLOW                 �0xC000009A�0x10         �
��������������������������������������������������������������Ĵ
�XCPT_FLOAT_DENORMAL_OPERAND          �0xC0000094�0x10         �
��������������������������������������������������������������Ĵ
�XCPT_FLOAT_INEXACT_RESULT            �0xC0000096�0x10         �
��������������������������������������������������������������Ĵ
�XCPT_FLOAT_STACK_CHECK               �0xC0000099�0x10         �
��������������������������������������������������������������Ĵ
�XCPT_DATATYPE_MISALIGNMENT           �0xC000009E�0x11         �
�  ExceptionInfo[0] - R/W flag        �          �             �
�  ExceptionInfo[1] - Alignment       �          �             �
�  ExceptionInfo[2] - FaultAddr       �          �             �
��������������������������������������������������������������Ĵ
�XCPT_BREAKPOINT                      �0xC000009F�0x03         �
��������������������������������������������������������������Ĵ
�XCPT_SINGLE_STEP                     �0xC00000A0�0x01         �
����������������������������������������������������������������


Portable, Fatal, Software-Generated Exceptions

��������������������������������������������������������������Ŀ
�Exception Name                       �Value     �Related Trap �
��������������������������������������������������������������Ĵ
�XCPT_IN_PAGE_ERROR                   �0xC0000006�0x0E         �
�  ExceptionInfo[0] - FaultAddr       �          �             �
��������������������������������������������������������������Ĵ
�XCPT_PROCESS_TERMINATE               �0xC0010001�             �
��������������������������������������������������������������Ĵ
�XCPT_ASYNC_PROCESS_TERMINATE         �0xC0010002�             �
�  ExceptionInfo[0] - TID of          �          �             �
�      terminating thread             �          �             �
��������������������������������������������������������������Ĵ
�XCPT_NONCONTINUABLE_EXCEPTION        �0xC0000024�             �
��������������������������������������������������������������Ĵ
�XCPT_INVALID_DISPOSITION             �0xC0000025�             �
����������������������������������������������������������������


Non-Portable, Fatal Exceptions

��������������������������������������������������������������Ŀ
�Exception Name                       �Value     �Related Trap �
��������������������������������������������������������������Ĵ
�XCPT_INVALID_LOCK_SEQUENCE           �0xC000001D�             �
��������������������������������������������������������������Ĵ
�XCPT_ARRAY_BOUNDS_EXCEEDED           �0xC0000093�0x05         �
����������������������������������������������������������������


Unwind Operation Exceptions

������������������������������������������������Ŀ
�Exception Name                       �Value     �
������������������������������������������������Ĵ
�XCPT_UNWIND                          �0xC0000026�
������������������������������������������������Ĵ
�XCPT_BAD_STACK                       �0xC0000027�
������������������������������������������������Ĵ
�XCPT_INVALID_UNWIND_TARGET           �0xC0000028�
��������������������������������������������������


Fatal Signal Exceptions

������������������������������������������������Ŀ
�Exception Name                       �Value     �
������������������������������������������������Ĵ
�XCPT_SIGNAL                          �0xC0010003�
�  ExceptionInfo[ 0 ] - Signal        �          �
�      Number                         �          �
��������������������������������������������������
*)
{$ENDIF OS2EXCEPTIONS}



{****************************************************************************

                    Miscellaneous related routines.

****************************************************************************}

procedure system_exit;
begin
  DosExit(1{process}, exitcode);
end;

{$ASMMODE ATT}

function paramcount:longint;assembler;
asm
    movl argc,%eax
    decl %eax
end {['EAX']};

function args:pointer;assembler;
asm
  movl argv,%eax
end {['EAX']};


function paramstr(l:longint):string;

var p:^Pchar;

begin
  if (l>=0) and (l<=paramcount) then
  begin
    p:=args;
    paramstr:=strpas(p[l]);
  end
    else paramstr:='';
end;

procedure randomize;
var
  dt: TSysDateTime;
begin
  // Hmm... Lets use timer
  DosGetDateTime(dt);
  randseed:=dt.hour+(dt.minute shl 8)+(dt.second shl 16)+(dt.sec100 shl 32);
end;

{$ASMMODE ATT}

{****************************************************************************

                    Heap management releated routines.

****************************************************************************}

{Get some memory.
 P          = Pointer to memory will be returned here.
 Size       = Number of bytes to get. The size is rounded up to a multiple
              of 4096. This is probably not the case on non-intel 386
              versions of OS/2.
 Flags      = One or more of the mfXXXX constants.}

function DosAllocMem(var P:pointer;Size,Flag:cardinal): cardinal; cdecl;
external 'DOSCALLS' index 299;

function DosSetMem(P:pointer;Size,Flag:cardinal): cardinal; cdecl;
external 'DOSCALLS' index 305;

var
  Int_Heap_End: pointer;
  Int_Heap: pointer;
{$IFNDEF VER1_0}
                     external name 'HEAP';
{$ENDIF VER1_0}
  Int_HeapSize: cardinal; external name 'HEAPSIZE';
  PreviousHeap: cardinal;
  AllocatedMemory: cardinal;


function GetHeapSize: longint;
begin
  GetHeapSize := PreviousHeap + longint (Int_Heap_End) - longint (Int_Heap);
end;


function Sbrk (Size: longint): pointer;
var
  P: pointer;
  RC: cardinal;
const
  MemAllocBlock = 4 * 1024 * 1024;
begin
{$IFDEF DUMPGROW}
  WriteLn ('Trying to grow heap by ', Size, ' to ', HeapSize + Size);
{$ENDIF}
  // commit memory
{$WARNING Not threadsafe at the moment!}
  RC := DosSetMem (Int_Heap_End, Size, $13);

  if RC <> 0 then

(* Not enough memory was allocated - let's try to allocate more
   (4 MB steps or as much as requested if more than 4 MB needed). *)

   begin
    if Size > MemAllocBlock then
     begin
      RC := DosAllocMem (P, Size, 3);
      if RC = 0 then Inc (AllocatedMemory, Size);
     end
    else
     begin
      RC := DosAllocMem (P, MemAllocBlock, 3);
      if RC = 0 then Inc (AllocatedMemory, MemAllocBlock);
     end;
    if RC = 0 then
     begin
      PreviousHeap := GetHeapSize;
      Int_Heap := P;
      Int_Heap_End := P;
      RC := DosSetMem (Int_Heap_End, Size, $13);
     end
    else
     begin
      Sbrk := nil;
{$IFDEF DUMPGROW}
      WriteLn ('Error ', RC, ' during additional memory allocation!');
      WriteLn ('Total allocated memory is ', cardinal (AllocatedMemory), ', ',
                                                   GetHeapSize, ' committed.');
{$ENDIF DUMPGROW}
      Exit;
     end;
   end;

  if RC <> 0 then
   begin
{$IFDEF DUMPGROW}
    WriteLn ('Error ', RC, ' while trying to commit more memory!');
    WriteLn ('Current memory object starts at ', cardinal (Int_Heap),
                             ' and committed until ', cardinal (Int_Heap_End));
    WriteLn ('Total allocated memory is ', cardinal (AllocatedMemory), ', ',
                                                   GetHeapSize, ' committed.');
{$ENDIF DUMPGROW}
    Sbrk := nil;
   end
  else
   begin
    Sbrk := Int_Heap_End;
{$IFDEF DUMPGROW}
    WriteLn ('New heap at ', cardinal (Int_Heap_End));
{$ENDIF DUMPGROW}
    Inc (Int_Heap_End, Size);
   end;
end;


function GetHeapStart: pointer;
begin
  GetHeapStart := Int_Heap;
end;


{$i heap.inc}



{****************************************************************************

                          Low Level File Routines

****************************************************************************}

procedure allowslash(p:Pchar);
{Allow slash as backslash.}
var i:longint;
begin
    for i:=0 to strlen(p) do
        if p[i]='/' then p[i]:='\';
end;

procedure do_close(h:longint);
begin
{ Only three standard handles under real OS/2 }
  if h>2 then
  begin
    InOutRes:=DosClose(h);
  end;
{$ifdef IODEBUG}
  writeln('do_close: handle=', H, ', InOutRes=', InOutRes);
{$endif}
end;

procedure do_erase(p:Pchar);
begin
  allowslash(p);
  inoutres:=DosDelete(p);
end;

procedure do_rename(p1,p2:Pchar);
begin
  allowslash(p1);
  allowslash(p2);
  inoutres:=DosMove(p1, p2);
end;

function do_read(h,addr,len:longint):longint;
Var
  T: cardinal;
begin
{$ifdef IODEBUG}
  write('do_read: handle=', h, ', addr=', addr, ', length=', len);
{$endif}
  InOutRes:=DosRead(H, Pointer(Addr), Len, T);
  do_read:= longint (T);
{$ifdef IODEBUG}
  writeln(', actual_len=', t, ', InOutRes=', InOutRes);
{$endif}
end;

function do_write(h,addr,len:longint) : longint;
Var
  T: cardinal;
begin
{$ifdef IODEBUG}
  write('do_write: handle=', h, ', addr=', addr, ', length=', len);
{$endif}
  InOutRes:=DosWrite(H, Pointer(Addr), Len, T);
  do_write:= longint (T);
{$ifdef IODEBUG}
  writeln(', actual_len=', t, ', InOutRes=', InOutRes);
{$endif}
end;

function do_filepos(handle:longint): longint;
var
  PosActual: cardinal;
begin
  InOutRes:=DosSetFilePtr(Handle, 0, 1, PosActual);
  do_filepos:=longint (PosActual);
{$ifdef IODEBUG}
  writeln('do_filepos: handle=', Handle, ', actual_pos=', PosActual, ', InOutRes=', InOutRes);
{$endif}
end;

procedure do_seek(handle,pos:longint);
var
  PosActual: cardinal;
begin
  InOutRes:=DosSetFilePtr(Handle, Pos, 0 {ZeroBased}, PosActual);
{$ifdef IODEBUG}
  writeln('do_seek: handle=', Handle, ', pos=', pos, ', actual_pos=', PosActual, ', InOutRes=', InOutRes);
{$endif}
end;

function do_seekend(handle:longint):longint;
var
  PosActual: cardinal;
begin
  InOutRes:=DosSetFilePtr(Handle, 0, 2 {EndBased}, PosActual);
  do_seekend:=longint (PosActual);
{$ifdef IODEBUG}
  writeln('do_seekend: handle=', Handle, ', actual_pos=', PosActual, ', InOutRes=', InOutRes);
{$endif}
end;

function do_filesize(handle:longint):longint;
var aktfilepos: cardinal;
begin
  aktfilepos:=do_filepos(handle);
  do_filesize:=do_seekend(handle);
  do_seek(handle,aktfilepos);
end;

procedure do_truncate(handle,pos:longint);
begin
  InOutRes:=DosSetFileSize(Handle, Pos);
  do_seekend(handle);
end;

const
    FileHandleCount: cardinal = 20;

function Increase_File_Handle_Count: boolean;
var Err: word;
    L1: longint;
    L2: cardinal;
begin
  L1 := 10;
  if DosSetRelMaxFH (L1, L2) <> 0 then
    Increase_File_Handle_Count := false
  else
    if L2 > FileHandleCount then
    begin
      FileHandleCount := L2;
      Increase_File_Handle_Count := true;
    end
    else
      Increase_File_Handle_Count := false;
end;

procedure do_open(var f;p:pchar;flags:longint);
{
  filerec and textrec have both handle and mode as the first items so
  they could use the same routine for opening/creating.

  when (flags and $100)   the file will be append
  when (flags and $1000)  the file will be truncate/rewritten
  when (flags and $10000) there is no check for close (needed for textfiles)
}
var
  Action, Attrib, OpenFlags, FM: Cardinal;
begin
  // convert unix slashes to normal slashes
  allowslash(p);

  // close first if opened
  if ((flags and $10000)=0) then
  begin
    case filerec(f).mode of
      fminput,fmoutput,fminout : Do_Close(filerec(f).handle);
      fmclosed:;
    else
      begin
        inoutres:=102; {not assigned}
        exit;
      end;
    end;
  end;

  // reset file handle
  filerec(f).handle := UnusedHandle;

  Attrib:=0;
  OpenFlags:=0;

  // convert filesharing
  FM := Flags and $FF and not (8);
(* DenyNone if sharing not specified. *)
  if FM and 112 = 0 then
    FM := FM or 64;
  // convert filemode to filerec modes and access mode
  case (FM and 3) of
    0: filerec(f).mode:=fminput;
    1: filerec(f).mode:=fmoutput;
    2: filerec(f).mode:=fminout;
  end;

  if (flags and $1000)<>0 then
    OpenFlags:=OpenFlags or 2 {doOverwrite} or 16 {doCreate} // Create/overwrite
  else
    OpenFlags:=OpenFlags or 1 {doOpen}; // Open existing

  // Handle Std I/O
  if p[0]=#0 then
  begin
    case FileRec(f).mode of
      fminput :
        FileRec(f).Handle:=StdInputHandle;
      fminout, // this is set by rewrite
      fmoutput :
        FileRec(f).Handle:=StdOutputHandle;
      fmappend :
        begin
          FileRec(f).Handle:=StdOutputHandle;
          FileRec(f).mode:=fmoutput; // fool fmappend
        end;
    end;
    exit;
  end;

  Attrib:=32 {faArchive};

  InOutRes:=DosOpen(p, FileRec(F).Handle, Action, 0, Attrib, OpenFlags, FM, nil);

  // If too many open files try to set more file handles and open again
  if (InOutRes = 4) then
    if Increase_File_Handle_Count then
      InOutRes:=DosOpen(p, FileRec(F).Handle, Action, 0, Attrib, OpenFlags, FM, nil);

  If InOutRes<>0 then FileRec(F).Handle:=UnusedHandle;

  // If Handle created -> make some things
  if (FileRec(F).Handle <> UnusedHandle) then
  begin

    // Move to end of file for Append command
    if ((Flags and $100) <> 0) then
    begin
      do_seekend(FileRec(F).Handle);
      FileRec(F).Mode := fmOutput;
    end;

  end;

{$ifdef IODEBUG}
  writeln('do_open,', filerec(f).handle, ',', filerec(f).name, ',', filerec(f).mode, ', InOutRes=', InOutRes);
{$endif}
end;

function do_isdevice (Handle: longint): boolean;
var
  HT, Attr: cardinal;
begin
  do_isdevice:=false;
  If DosQueryHType(Handle, HT, Attr)<>0 then exit;
  if ht=1 then do_isdevice:=true;
end;
{$ASMMODE ATT}


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

{$DEFINE EOF_CTRLZ}

{$i text.inc}

{****************************************************************************

                          Directory related routines.

****************************************************************************}

{*****************************************************************************
                           Directory Handling
*****************************************************************************}

procedure MkDir (const S: string);[IOCHECK];
var buffer:array[0..255] of char;
    Rc : word;
begin
  If (s='') or (InOutRes <> 0) then
   exit;
      move(s[1],buffer,length(s));
      buffer[length(s)]:=#0;
      allowslash(Pchar(@buffer));
      Rc := DosCreateDir(buffer,nil);
      if Rc <> 0 then
       begin
         InOutRes := Rc;
         Errno2Inoutres;
       end;
end;


procedure rmdir(const s : string);[IOCHECK];
var buffer:array[0..255] of char;
    Rc : word;
begin
  if (s = '.' ) then
    InOutRes := 16;
  If (s='') or (InOutRes <> 0) then
   exit;
      move(s[1],buffer,length(s));
      buffer[length(s)]:=#0;
      allowslash(Pchar(@buffer));
      Rc := DosDeleteDir(buffer);
      if Rc <> 0 then
       begin
         InOutRes := Rc;
         Errno2Inoutres;
       end;
end;

{$ASMMODE INTEL}

procedure ChDir (const S: string);[IOCheck];

var RC: cardinal;
    Buffer: array [0..255] of char;

begin
  If (s='') or (InOutRes <> 0) then exit;
  if (Length (S) >= 2) and (S [2] = ':') then
  begin
    RC := DosSetDefaultDisk ((Ord (S [1]) and not ($20)) - $40);
    if RC <> 0 then
      InOutRes := RC
    else
      if Length (S) > 2 then
      begin
        Move (S [1], Buffer, Length (S));
        Buffer [Length (S)] := #0;
        AllowSlash (PChar (@Buffer));
        RC := DosSetCurrentDir (@Buffer);
        if RC <> 0 then
        begin
          InOutRes := RC;
          Errno2InOutRes;
        end;
      end;
  end else begin
    Move (S [1], Buffer, Length (S));
    Buffer [Length (S)] := #0;
    AllowSlash (PChar (@Buffer));
    RC := DosSetCurrentDir (@Buffer);
    if RC <> 0 then
    begin
      InOutRes:= RC;
      Errno2InOutRes;
    end;
  end;
end;

{$ASMMODE ATT}

procedure GetDir (DriveNr: byte; var Dir: ShortString);
{Written by Michael Van Canneyt.}
var sof: Pchar;
    i:byte;
    l,l2:cardinal;
begin
    Dir [4] := #0;
    { Used in case the specified drive isn't available }
    sof:=pchar(@dir[4]);
    { dir[1..3] will contain '[drivenr]:\', but is not }
    { supplied by DOS, so we let dos string start at   }
    { dir[4]                                           }
    { Get dir from drivenr : 0=default, 1=A etc... }
    l:=255-3;
    InOutRes:=longint (DosQueryCurrentDir(DriveNr, sof^, l));
{$WARNING Result code should be translated in some cases!}
    { Now Dir should be filled with directory in ASCIIZ, }
    { starting from dir[4]                               }
    dir[0]:=#3;
    dir[2]:=':';
    dir[3]:='\';
    i:=4;
    {Conversion to Pascal string }
    while (dir[i]<>#0) do
        begin
            { convert path name to DOS }
            if dir[i]='/' then
            dir[i]:='\';
            dir[0]:=char(i);
            inc(i);
        end;
    { upcase the string (FPC function) }
    if drivenr<>0 then   { Drive was supplied. We know it }
        dir[1]:=chr(64+drivenr)
    else
        begin
            { We need to get the current drive from DOS function 19H  }
            { because the drive was the default, which can be unknown }
            DosQueryCurrentDisk(l, l2);
            dir[1]:=chr(64+l);
        end;
    if not (FileNameCaseSensitive) then dir:=upcase(dir);
end;


{*****************************************************************************

                        System unit initialization.

****************************************************************************}

{****************************************************************************
                    Error Message writing using messageboxes
****************************************************************************}

type
  TWinMessageBox = function (Parent, Owner: cardinal;
         BoxText, BoxTitle: PChar; Identity, Style: cardinal): cardinal; cdecl;
  TWinInitialize = function (Options: cardinal): cardinal; cdecl;
  TWinCreateMsgQueue = function (Handle: cardinal; cmsg: longint): cardinal;
                                                                         cdecl;

const
  ErrorBufferLength = 1024;
  mb_OK = $0000;
  mb_Error = $0040;
  mb_Moveable = $4000;
  MBStyle = mb_OK or mb_Error or mb_Moveable;
  WinInitialize: TWinInitialize = nil;
  WinCreateMsgQueue: TWinCreateMsgQueue = nil;
  WinMessageBox: TWinMessageBox = nil;
  EnvSize: cardinal = 0;

var
  ErrorBuf: array [0..ErrorBufferLength] of char;
  ErrorLen: longint;
  PMWinHandle: cardinal;

function ErrorWrite (var F: TextRec): integer;
{
  An error message should always end with #13#10#13#10
}
var
  P: PChar;
  I: longint;
begin
  if F.BufPos > 0 then
   begin
     if F.BufPos + ErrorLen > ErrorBufferLength then
       I := ErrorBufferLength - ErrorLen
     else
       I := F.BufPos;
     Move (F.BufPtr^, ErrorBuf [ErrorLen], I);
     Inc (ErrorLen, I);
     ErrorBuf [ErrorLen] := #0;
   end;
  if ErrorLen > 3 then
   begin
     P := @ErrorBuf [ErrorLen];
     for I := 1 to 4 do
      begin
        Dec (P);
        if not (P^ in [#10, #13]) then
          break;
      end;
   end;
   if ErrorLen = ErrorBufferLength then
     I := 4;
   if (I = 4) then
    begin
      WinMessageBox (0, 0, @ErrorBuf, PChar ('Error'), 0, MBStyle);
      ErrorLen := 0;
    end;
  F.BufPos := 0;
  ErrorWrite := 0;
end;

function ErrorClose (var F: TextRec): integer;
begin
  if ErrorLen > 0 then
   begin
     WinMessageBox (0, 0, @ErrorBuf, PChar ('Error'), 0, MBStyle);
     ErrorLen := 0;
   end;
  ErrorLen := 0;
  ErrorClose := 0;
end;

function ErrorOpen (var F: TextRec): integer;
begin
  TextRec(F).InOutFunc := @ErrorWrite;
  TextRec(F).FlushFunc := @ErrorWrite;
  TextRec(F).CloseFunc := @ErrorClose;
  ErrorOpen := 0;
end;


procedure AssignError (var T: Text);
begin
  Assign (T, '');
  TextRec (T).OpenFunc := @ErrorOpen;
  Rewrite (T);
end;

procedure SysInitStdIO;
begin
  { Setup stdin, stdout and stderr, for GUI apps redirect stderr,stdout to be
    displayed in a messagebox }
(*
  StdInputHandle := longint(GetStdHandle(cardinal(STD_INPUT_HANDLE)));
  StdOutputHandle := longint(GetStdHandle(cardinal(STD_OUTPUT_HANDLE)));
  StdErrorHandle := longint(GetStdHandle(cardinal(STD_ERROR_HANDLE)));

  if not IsConsole then
    begin
      if (DosLoadModule (nil, 0, 'PMWIN', PMWinHandle) = 0) and
       (DosQueryProcAddr (PMWinHandle, 789, nil, pointer (WinMessageBox)) = 0)
                                                                           and
       (DosQueryProcAddr (PMWinHandle, 763, nil, pointer (WinInitialize)) = 0)
                                                                           and
       (DosQueryProcAddr (PMWinHandle, 716, nil, pointer (WinCreateMsgQueue))
                                                                           = 0)
        then
          begin
            WinInitialize (0);
            WinCreateMsgQueue (0, 0);
          end
        else
          HandleError (2);
     AssignError (StdErr);
     AssignError (StdOut);
     Assign (Output, '');
     Assign (Input, '');
   end
  else
   begin
*)
     OpenStdIO (Input, fmInput, StdInputHandle);
     OpenStdIO (Output, fmOutput, StdOutputHandle);
     OpenStdIO (StdOut, fmOutput, StdOutputHandle);
     OpenStdIO (StdErr, fmOutput, StdErrorHandle);
(*
   end;
*)
end;


function strcopy(dest,source : pchar) : pchar;assembler;
var
  saveeax,saveesi,saveedi : longint;
asm
        movl    %edi,saveedi
        movl    %esi,saveesi
{$ifdef REGCALL}
        movl    %eax,saveeax
        movl    %edx,%edi
{$else}
        movl    source,%edi
{$endif}
        testl   %edi,%edi
        jz      .LStrCopyDone
        leal    3(%edi),%ecx
        andl    $-4,%ecx
        movl    %edi,%esi
        subl    %edi,%ecx
{$ifdef REGCALL}
        movl    %eax,%edi
{$else}
        movl    dest,%edi
{$endif}
        jz      .LStrCopyAligned
.LStrCopyAlignLoop:
        movb    (%esi),%al
        incl    %edi
        incl    %esi
        testb   %al,%al
        movb    %al,-1(%edi)
        jz      .LStrCopyDone
        decl    %ecx
        jnz     .LStrCopyAlignLoop
        .balign  16
.LStrCopyAligned:
        movl    (%esi),%eax
        movl    %eax,%edx
        leal    0x0fefefeff(%eax),%ecx
        notl    %edx
        addl    $4,%esi
        andl    %edx,%ecx
        andl    $0x080808080,%ecx
        jnz     .LStrCopyEndFound
        movl    %eax,(%edi)
        addl    $4,%edi
        jmp     .LStrCopyAligned
.LStrCopyEndFound:
        testl   $0x0ff,%eax
        jz      .LStrCopyByte
        testl   $0x0ff00,%eax
        jz      .LStrCopyWord
        testl   $0x0ff0000,%eax
        jz      .LStrCopy3Bytes
        movl    %eax,(%edi)
        jmp     .LStrCopyDone
.LStrCopy3Bytes:
        xorb     %dl,%dl
        movw     %ax,(%edi)
        movb     %dl,2(%edi)
        jmp     .LStrCopyDone
.LStrCopyWord:
        movw    %ax,(%edi)
        jmp     .LStrCopyDone
.LStrCopyByte:
        movb    %al,(%edi)
.LStrCopyDone:
{$ifdef REGCALL}
        movl    saveeax,%eax
{$else}
        movl    dest,%eax
{$endif}
        movl    saveedi,%edi
        movl    saveesi,%esi
end;


procedure InitEnvironment;
var env_count : longint;
    dos_env,cp : pchar;
begin
  env_count:=0;
  cp:=environment;
  while cp ^ <> #0 do
    begin
    inc(env_count);
    while (cp^ <> #0) do inc(longint(cp)); { skip to NUL }
    inc(longint(cp)); { skip to next character }
    end;
  envp := sysgetmem((env_count+1) * sizeof(pchar));
  envc := env_count;
  if (envp = nil) then exit;
  cp:=environment;
  env_count:=0;
  while cp^ <> #0 do
  begin
    envp[env_count] := sysgetmem(strlen(cp)+1);
    strcopy(envp[env_count], cp);
{$IfDef DEBUGENVIRONMENT}
    Writeln(stderr,'env ',env_count,' = "',envp[env_count],'"');
{$EndIf}
    inc(env_count);
    while (cp^ <> #0) do
      inc(longint(cp)); { skip to NUL }
    inc(longint(cp)); { skip to next character }
  end;
  envp[env_count]:=nil;
end;

procedure InitArguments;
var
  arglen,
  count   : longint;
  argstart,
  pc,arg  : pchar;
  quote   : char;
  argvlen : longint;

  procedure allocarg(idx,len:longint);
  begin
    if idx>=argvlen then
     begin
       argvlen:=(idx+8) and (not 7);
       sysreallocmem(argv,argvlen*sizeof(pointer));
     end;
    { use realloc to reuse already existing memory }
    { always allocate, even if length is zero, since }
    { the arg. is still present!                     }
    sysreallocmem(argv[idx],len+1);
  end;

begin
  count:=0;
  argv:=nil;
  argvlen:=0;

  // Get argv[0]
  pc:=cmdline;
  Arglen:=0;
  repeat
    Inc(Arglen);
  until (pc[Arglen]=#0);
  allocarg(count,arglen);
  move(pc^,argv[count]^,arglen);

  { ReSetup cmdline variable }
  repeat
    Inc(Arglen);
  until (pc[Arglen]=#0);
  Inc(Arglen);
  pc:=GetMem(ArgLen);
  move(cmdline^, pc^, arglen);
  Arglen:=0;
  repeat
    Inc(Arglen);
  until (pc[Arglen]=#0);
  pc[Arglen]:=' '; // combine argv[0] and command line
  CmdLine:=pc;

  { process arguments }
  pc:=cmdline;
{$IfDef DEBUGARGUMENTS}
  Writeln(stderr,'GetCommandLine is #',pc,'#');
{$EndIf }
  while pc^<>#0 do
   begin
     { skip leading spaces }
     while pc^ in [#1..#32] do
      inc(pc);
     if pc^=#0 then
      break;
     { calc argument length }
     quote:=' ';
     argstart:=pc;
     arglen:=0;
     while (pc^<>#0) do
      begin
        case pc^ of
          #1..#32 :
            begin
              if quote<>' ' then
               inc(arglen)
              else
               break;
            end;
          '"' :
            begin
              if quote<>'''' then
               begin
                 if pchar(pc+1)^<>'"' then
                  begin
                    if quote='"' then
                     quote:=' '
                    else
                     quote:='"';
                  end
                 else
                  inc(pc);
               end
              else
               inc(arglen);
            end;
          '''' :
            begin
              if quote<>'"' then
               begin
                 if pchar(pc+1)^<>'''' then
                  begin
                    if quote=''''  then
                     quote:=' '
                    else
                     quote:='''';
                  end
                 else
                  inc(pc);
               end
              else
               inc(arglen);
            end;
          else
            inc(arglen);
        end;
        inc(pc);
      end;
     { copy argument }
     { Don't copy the first one, it is already there.}
     If Count<>0 then
      begin
        allocarg(count,arglen);
        quote:=' ';
        pc:=argstart;
        arg:=argv[count];
        while (pc^<>#0) do
         begin
           case pc^ of
             #1..#32 :
               begin
                 if quote<>' ' then
                  begin
                    arg^:=pc^;
                    inc(arg);
                  end
                 else
                  break;
               end;
             '"' :
               begin
                 if quote<>'''' then
                  begin
                    if pchar(pc+1)^<>'"' then
                     begin
                       if quote='"' then
                        quote:=' '
                       else
                        quote:='"';
                     end
                    else
                     inc(pc);
                  end
                 else
                  begin
                    arg^:=pc^;
                    inc(arg);
                  end;
               end;
             '''' :
               begin
                 if quote<>'"' then
                  begin
                    if pchar(pc+1)^<>'''' then
                     begin
                       if quote=''''  then
                        quote:=' '
                       else
                        quote:='''';
                     end
                    else
                     inc(pc);
                  end
                 else
                  begin
                    arg^:=pc^;
                    inc(arg);
                  end;
               end;
             else
               begin
                 arg^:=pc^;
                 inc(arg);
               end;
           end;
           inc(pc);
         end;
        arg^:=#0;
      end;
 {$IfDef DEBUGARGUMENTS}
     Writeln(stderr,'dos arg ',count,' #',arglen,'#',argv[count],'#');
 {$EndIf}
     inc(count);
   end;
  { get argc and create an nil entry }
  argc:=count;
  allocarg(argc,0);
  { free unused memory }
  sysreallocmem(argv,(argc+1)*sizeof(pointer));
end;

function GetFileHandleCount: longint;
var L1: longint;
    L2: cardinal;
begin
    L1 := 0; (* Don't change the amount, just check. *)
    if DosSetRelMaxFH (L1, L2) <> 0 then GetFileHandleCount := 50
                                                 else GetFileHandleCount := L2;
end;

var TIB: PThreadInfoBlock;
    PIB: PProcessInfoBlock;
    RC: cardinal;
    ErrStr: string;

begin
    IsLibrary := FALSE;

    (* Initialize the amount of file handles *)
    FileHandleCount := GetFileHandleCount;
    DosGetInfoBlocks (@TIB, @PIB);
    StackBottom := TIB^.Stack;

    {Set type of application}
    ApplicationType := PIB^.ProcType;
    ProcessID := PIB^.PID;
    ThreadID := TIB^.TIB2^.TID;
    IsConsole := ApplicationType <> 3;

    exitproc:=nil;

    {Initialize the heap.}
    // Logic is following:
    //   Application allocates the amount of memory specified by the compiler
    //   switch -Ch but without commiting. On heap growing required amount of
    //   memory commited. More memory is allocated as needed within sbrk.

    RC := DosAllocMem (Int_Heap, Int_HeapSize, 3);

    if RC <> 0 then
     begin
      Str (RC, ErrStr);
      ErrStr := 'Error during heap initialization (' + ErrStr + ')!!';
      DosWrite (2, @ErrStr [1], Length (ErrStr), RC);
      HandleError (204);
     end;
    AllocatedMemory := Int_HeapSize;
    Int_Heap_End := Int_Heap;
    PreviousHeap := 0;
    InitHeap;

    { ... and exceptions }
    SysInitExceptions;

    { ... and I/O }
    SysInitStdIO;

    { no I/O-Error }
    inoutres:=0;

    {Initialize environment (must be after InitHeap because allocates memory)}
    Environment := pointer (PIB^.Env);
    InitEnvironment;

    CmdLine := pointer (PIB^.Cmd);
    InitArguments;

{$ifdef HASVARIANT}
    initvariantmanager;
{$endif HASVARIANT}

{$IFDEF DUMPGROW}
    WriteLn ('Initial brk size is ', GetHeapSize);
{$ENDIF DUMPGROW}
end.
{
  $Log$
  Revision 1.68  2004-03-24 19:15:59  hajny
    * heap management modified to be able to grow heap as needed

  Revision 1.67  2004/02/22 15:01:49  hajny
    * lots of fixes (regcall, THandle, string operations in sysutils, longint2cardinal according to OS/2 docs, dosh.inc, ...)

  Revision 1.66  2004/02/16 22:18:44  hajny
    * LastDosExitCode changed back from threadvar temporarily

  Revision 1.65  2004/02/02 03:24:09  yuri
  - prt1.as removed
  - removed tmporary code/comments
  - prt1 compilation error workaround removed

  Revision 1.64  2004/01/25 21:41:48  hajny
    * reformatting of too long comment lines - not accepted by FP IDE

  Revision 1.63  2004/01/21 14:15:42  florian
    * fixed win32 compilation

  Revision 1.62  2004/01/20 23:11:20  hajny
    * ExecuteProcess fixes, ProcessID and ThreadID added

  Revision 1.61  2003/12/04 21:22:38  peter
    * regcall updates (untested)

  Revision 1.60  2003/11/23 07:21:16  yuri
  * native heap

  Revision 1.59  2003/11/19 18:21:11  yuri
  * Memory allocation bug fixed

  Revision 1.58  2003/11/19 16:50:21  yuri
  * Environment and arguments initialization now native

  Revision 1.57  2003/11/06 17:20:44  yuri
  * Unused constants removed

  Revision 1.56  2003/11/03 09:42:28  marco
   * Peter's Cardinal<->Longint fixes patch

  Revision 1.55  2003/11/02 00:51:17  hajny
    * corrections for do_open and os_mode back

  Revision 1.54  2003/10/28 14:57:31  yuri
  * do_* functions now native

  Revision 1.53  2003/10/27 04:33:58  yuri
  * os_mode removed (not required anymore)

  Revision 1.52  2003/10/25 22:45:37  hajny
    * file handling related fixes

  Revision 1.51  2003/10/19 12:13:41  hajny
    * UnusedHandle value made the same as with other targets

  Revision 1.50  2003/10/19 09:37:00  hajny
    * minor fix in non-default sbrk code

  Revision 1.49  2003/10/19 09:06:28  hajny
    * fix for terrible long-time bug in do_open

  Revision 1.48  2003/10/18 16:58:39  hajny
    * stdcall fixes again

  Revision 1.47  2003/10/16 15:43:13  peter
    * THandle is platform dependent

  Revision 1.46  2003/10/14 21:10:06  hajny
    * another longint2cardinal fix

  Revision 1.45  2003/10/13 21:17:31  hajny
    * longint to cardinal corrections

  Revision 1.44  2003/10/12 18:07:30  hajny
    * wrong use of Intel syntax

  Revision 1.43  2003/10/12 17:59:40  hajny
    * wrong use of Intel syntax

  Revision 1.42  2003/10/12 17:52:28  hajny
    * wrong use of Intel syntax

  Revision 1.41  2003/10/12 10:45:36  hajny
    * sbrk error handling corrected

  Revision 1.40  2003/10/07 21:26:35  hajny
    * stdcall fixes and asm routines cleanup

  Revision 1.39  2003/10/06 16:58:27  yuri
  * Another set of native functions.

  Revision 1.38  2003/10/06 14:22:40  yuri
  * Some emx code removed. Now withous so stupid error as with dos ;)

  Revision 1.37  2003/10/04 08:30:59  yuri
  * at&t syntax instead of intel syntax was used

  Revision 1.36  2003/10/03 21:46:41  peter
    * stdcall fixes

  Revision 1.35  2003/10/01 18:42:49  yuri
  * Unclosed comment

  Revision 1.34  2003/09/29 18:39:59  hajny
    * append fix applied to GO32v2, OS/2 and EMX

  Revision 1.33  2003/09/27 11:52:36  peter
    * sbrk returns pointer

  Revision 1.32  2003/03/30 09:20:30  hajny
    * platform extension unification

  Revision 1.31  2003/01/15 22:16:12  hajny
    * default sharing mode changed to DenyNone

  Revision 1.30  2002/12/15 22:41:41  hajny
    * First_Meg fixed + Environment initialization under Dos

  Revision 1.29  2002/12/08 16:39:58  hajny
    - WriteLn in GUI mode support commented out until fixed

  Revision 1.28  2002/12/07 19:17:14  hajny
    * GetEnv correction, better PM support, ...

  Revision 1.27  2002/11/17 22:31:02  hajny
    * type corrections (longint x cardinal)

  Revision 1.26  2002/10/27 14:29:00  hajny
    * heap management (hopefully) fixed

  Revision 1.25  2002/10/14 19:39:17  peter
    * threads unit added for thread support

  Revision 1.24  2002/10/13 09:28:45  florian
    + call to initvariantmanager inserted

  Revision 1.23  2002/09/07 16:01:25  peter
    * old logs removed and tabs fixed

  Revision 1.22  2002/07/01 16:29:05  peter
    * sLineBreak changed to normal constant like Kylix

  Revision 1.21  2002/04/21 15:54:20  carl
  + initialize some global variables

  Revision 1.20  2002/04/12 17:42:16  carl
  + generic stack checking

  Revision 1.19  2002/03/11 19:10:33  peter
    * Regenerated with updated fpcmake

  Revision 1.18  2002/02/10 13:46:20  hajny
    * heap management corrected (heap_brk)

}
