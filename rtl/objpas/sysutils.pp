{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 1998 by Florian Klaempfl
    member of the Free Pascal development team

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

    uses
    {$ifdef linux}
       linux
    {$endif}
    {$ifdef win32}
       dos,windows
    {$endif}
    {$ifdef go32v1}
       go32,dos
    {$endif}
    {$ifdef go32v2}
       go32,dos
    {$endif}
       ;


type
   { some helpful data types }

   tprocedure = procedure;

   tfilename = string;

   longrec = packed record
      lo,hi : word;
   end;

   wordrec = packed record
      lo,hi : byte;
   end;

   { exceptions }
   exception = class(TObject)
    private
      fmessage : string;
      fhelpcontext : longint;
    public
      constructor create(const msg : string);
      constructor createfmt(const msg : string; const args : array of const);
      constructor createres(ident : longint);
      { !!!! }
      property helpcontext : longint read fhelpcontext write fhelpcontext;
      property message : string read fmessage write fmessage;
   end;

   exceptclass = class of exception;

   { integer math exceptions }
   EInterror    = Class(Exception);
   EDivByZero   = Class(EIntError);
   ERangeError  = Class(EIntError);
   EIntOverflow = Class(EIntError);

   { General math errors }
   EMathError  = Class(Exception);
   EInvalidOp  = Class(EMathError);
   EZeroDivide = Class(EMathError);
   EOverflow   = Class(EMathError);
   EUnderflow  = Class(EMathError);

   { Run-time and I/O Errors }
   EInOutError = class(Exception)
     public
     ErrorCode : Longint;
     end;
   EInvalidPointer  = Class(Exception);
   EOutOfMemory     = Class(Exception);
   EAccessViolation = Class(Exception);
   EInvalidCast = Class(Exception);


   { String conversion errors }
   EConvertError = class(Exception);

   { Other errors }
   EAbort           = Class(Exception);
   EAbstractError   = Class(Exception);
   EAssertionFailed = Class(Exception);


   { Memory management routines }
   function AllocMem(size : longint) : Pointer;
   procedure ReAllocMem(var P: Pointer; currentSize: longint; newSize: longint);

  { FileRec/TextRec }
  {$i filerec.inc}
  {$i textrec.inc}

  { Read internationalization settings }
  {$i sysinth.inc}

  { Read date & Time function declarations }
  {$i datih.inc}

  { Read String Handling functions declaration }
  {$i sysstrh.inc}

  { Read pchar handling functions declration }
  {$i syspchh.inc}

  { Read filename handling functions declaration }
  {$i finah.inc}

  { Read other file handling function declarations }
  {$i filutilh.inc}

  { Read disk function declarations }
  {$i diskh.inc}

  implementation

  { Read message string definitions }
  {
   Add a language with IFDEF LANG_NAME
   just befor the final ELSE. This way English will always be the default.
  }

  {$IFDEF LANG_GERMAN}
  {$i strg.inc} // Does not exist yet !!
  {$ELSE}
  {$i stre.inc}
  {$ENDIF}

  { Read filename handling functions implementation }
  {$i fina.inc}

  { Read String Handling functions implementation }
  {$i sysstr.inc}

  { Read other file handling function implementations }
  {$i filutil.inc}

  { Read disk function implementations }
  {$i disk.inc}

  { Read date & Time function implementations }
  {$i dati.inc}

  { Read pchar handling functions implementation }
  {$i syspch.inc}


    constructor exception.create(const msg : string);

      begin
         inherited create;
         fmessage:=msg;
      end;


    constructor exception.createfmt(const msg : string; const args : array of const);

      begin
         inherited create;
         fmessage:=Format(msg,args);
      end;


    constructor exception.createres(ident : longint);

      begin
         inherited create;
         {!!!!!}
      end;


Procedure CatchUnhandledException (Obj : TObject; Addr: Pointer);
Var
  Message : String;
begin
{$ifndef USE_WINDOWS}
  Writeln ('An unhandled exception occurred at ',HexStr(Longint(Addr),8),' : ');
  if Obj is exception then
   begin
     Message:=Exception(Obj).Message;
     Writeln (Message);
   end
  else
   Writeln ('Exception object ',Obj.ClassName,' is not of class Exception.');
  Halt(217);
{$else}
{$endif}
end;


Var OutOfMemory : EOutOfMemory;
    InValidPointer : EInvalidPointer;


Procedure RunErrorToExcept (ErrNo : Longint; Address : Pointer);

Var E : Exception;
    S : String;

begin
  Case Errno of
   1,203 : E:=OutOfMemory;
   204 : E:=InvalidPointer;
   2,3,4,5,6,100,101,102,103,105,106 : { I/O errors }
     begin
     Case Errno of
       2 : S:=SFileNotFound;
       3 : S:=SInvalidFileName;
       4 : S:=STooManyOpenFiles;
       5 : S:=SAccessDenied;
       6 : S:=SInvalidFileHandle;
       15 : S:=SInvalidDrive;
       100 : S:=SEndOfFile;
       101 : S:=SDiskFull;
       102 : S:=SFileNotAssigned;
       103 : S:=SFileNotOpen;
       104 : S:=SFileNotOpenForInput;
       105 : S:=SFileNotOpenForOutput;
       106 : S:=SInvalidInput;
     end;
     E:=EinOutError.Create (S);
     EInoutError(E).ErrorCode:=IOresult; // Clears InOutRes !!
     end;
  // We don't set abstracterrorhandler, but we do it here.
  // Unless the use sets another handler we'll get here anyway...
  200 : E:=EDivByZero.Create(SDivByZero);
  201 : E:=ERangeError.Create(SRangeError);
  205 : E:=EOverflow.Create(SOverflow);
  206 : E:=EOverflow.Create(SUnderflow);
  207 : E:=EInvalidOp.Create(SInvalidOp);
  211 : E:=EAbstractError.Create(SAbstractError);
  215 : E:=EIntOverflow.Create(SIntOverflow);
  216 : E:=EAccessViolation.Create(SAccessViolation);
  219 : E:=EInvalidCast.Create(SInvalidCast);
  227 : E:=EAssertionFailed.Create(SAssertionFailed);
  else
   E:=Exception.CreateFmt (SUnKnownRunTimeError,[Errno]);
  end;
  Raise E {at Address};
end;


Procedure AssertErrorHandler (Const Msg,FN : String;LineNo,TheAddr : Longint);
Var
  S : String;
begin
  If Msg='' then
    S:=SAssertionFailed
  else
    S:=Msg;
  Raise EAssertionFailed.Createfmt(SAssertError,[S,Fn,LineNo]); // at Pointer(theAddr);
end;


Procedure InitExceptions;
{
  Must install uncaught exception handler (ExceptProc)
  and install exceptions for system exceptions or signals.
  (e.g: SIGSEGV -> ESegFault or so.)
}
begin
  ExceptProc:=@CatchUnhandledException;
  // Create objects that may have problems when there is no memory.
  OutOfMemory:=EOutOfMemory.Create(SOutOfMemory);
  InvalidPointer:=EInvalidPointer.Create(SInvalidPointer);
  AssertErrorProc:=@AssertErrorHandler;
  ErrorProc:=@RunErrorToExcept;
end;

{ ---------------------------------------------------------------------
    Memory handling routines.
  ---------------------------------------------------------------------}


function AllocMem(size : longint) : Pointer;
var
   newP : Pointer;
begin
   GetMem(newP, size);
   if newP <> nil then
      FillChar(newP^, size, 0);
   result := newP;
end;

{ ReAllocMem
1. if P is nil and newSize is zero do nothing
2. if P is nil and newSize is NOT zero allocate memory and clear it to 0
3. if P is NOT nil and newSize is NOT zero a new memory block is allocated
   the data is copied from the old block to the new block and the old
   block is disposed of.

if P is NOT nil then currentSize must be the size used to allocate memory
for P whether it was using AllocMem or ReAllocMem.

This is similar to the functions found in Delphi 1
The same functions in Dephi 2, 3, and 4 use memory management. When
I get a chance I might attempt to incorporate that feature.
}

procedure ReAllocMem(var P: Pointer; currentSize: longint; newSize: longint);
var
   newP : Pointer;

begin
   if (P = nil) then
     begin
     If NewSize>0 then 
       P := AllocMem(newSize)
     end
   else 
     begin
     If NewSize>0 then 
       NewP := AllocMem(newSize)
     else 
       NewP:=Nil;
     if NewSize > currentSize then
       NewSize := currentSize;
     If NewSize>0 then 
        Move(P^, newP^, NewSize);
     If CurrentSize>0 then   
       FreeMem(P, currentSize);
     P := newP;
     end;
end;


{  Initialization code. }

Initialization
  InitExceptions;       { Initialize exceptions. OS independent }
  InitInternational;    { Initialize internationalization settings }
Finalization
  OutOfMemory.Free;
  InValidPointer.Free;
end.
{
    $Log$
    Revision 1.31  1999-08-28 14:53:27  florian
      * bug 471 fixed: run time error 2 is now converted into a file not
        found exception

    Revision 1.30  1999/08/18 11:28:24  michael
    * Fixed reallocmem bug 535

    Revision 1.29  1999/07/27 13:01:12  peter
      + filerec,textrec declarations

    Revision 1.28  1999/07/08 19:32:36  michael
    + Freed exception classes in finalization code

    Revision 1.27  1999/07/02 17:03:24  florian
      + added some runtime->excpetin wrappers: eintoverflow, eoverflow, eunderflow, einvalidop

    Revision 1.26  1999/04/09 08:40:46  michael
    + Fixed tfiletime problem

    Revision 1.25  1999/04/08 16:26:31  michael
    + Added (re)allocmem

    Revision 1.24  1999/04/08 12:23:05  peter
      * removed os.inc

    Revision 1.23  1999/02/28 13:17:37  michael
    + Added internationalization support and more format functions

    Revision 1.22  1999/02/10 22:15:13  michael
    + Changed to ansistrings

    Revision 1.21  1999/02/09 14:24:50  pierre
     * dos unit missing for go32v2 !!

    Revision 1.20  1999/02/09 12:38:44  michael
    * Fixed INt() proble. Defined THandle, included Filemode constants

    Revision 1.19  1999/02/03 16:18:58  michael
    + Uses Windows on win32 platform

    Revision 1.18  1998/12/15 22:43:12  peter
      * removed temp symbols

    Revision 1.17  1998/10/20 19:26:37  michael
    + Forgot to include disk functions

    Revision 1.16  1998/10/11 12:23:41  michael
    + More sysutils calls.

    Revision 1.15  1998/10/10 09:53:10  michael
    Added assertion handling

    Revision 1.14  1998/10/03 15:08:05  florian
      * EInvalidCast added (from runerror 219)

    Revision 1.13  1998/10/02 13:00:11  michael
    + More RTL error handling

    Revision 1.12  1998/10/02 12:17:18  michael
    + Made sure it compiles with official 0.99.8

    Revision 1.11  1998/10/01 16:04:11  michael
    + Added RTL error handling

    Revision 1.10  1998/09/24 23:45:27  peter
      * updated for auto objpas loading

    Revision 1.9  1998/09/24 16:13:49  michael
    Changes in exception and open array handling

    Revision 1.8  1998/09/18 23:57:26  michael
    * Changed use_excepions to useexceptions

    Revision 1.7  1998/09/16 14:34:38  pierre
      * go32v2 did not compile
      * wrong code in systr.inc corrected

    Revision 1.6  1998/09/16 08:28:44  michael
    Update from gertjan Schouten, plus small fix for linux

    Revision 1.5  1998/09/04 08:49:07  peter
      * 0.99.5 doesn't compile a whole objpas anymore to overcome crashes

    Revision 1.4  1998/08/10 15:52:27  peter
      * fixed so 0.99.5 compiles it, but no exception class

    Revision 1.3  1998/07/29 15:44:32  michael
     included sysutils and math.pp as target. They compile now.
}
