{
    $Id$
    Copyright (c) 1997-98 by Michael Van Canneyt

    Unit to catch segmentation faults and Ctrl-C and exit gracefully
    under linux and go32v2

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
Unit fpcatch;
interface

{$i globdir.inc}

{$ifdef Unix}
uses
  linux;
{$endif}
{$ifdef go32v2}
uses
  dpmiexcp;
{$endif}
{$ifdef win32}
uses
  signals;
{$endif}

{$ifdef HasSignal}
Var
  NewSignal,OldSigSegm,OldSigILL,
  OldSigInt,OldSigFPE : SignalHandler;
{$endif}

Const
  CtrlCPressed : Boolean = false;

Implementation

uses
{$ifdef FPC}
  keyboard,
  drivers,
{$endif FPC}
  app,commands,msgbox,
  FPString,FPCompil,FPIDE;


{$ifdef HasSignal}
{$ifdef Unix}
Procedure CatchSignal(Sig : Integer);cdecl;
{$else}
Function CatchSignal(Sig : longint):longint;
{$endif}
var MustQuit: boolean;
begin
  case Sig of
   SIGSEGV : begin
               if StopJmpValid then
                 LongJmp(StopJmp,SIGSEGV);
               if Assigned(Application) then IDEApp.Done;
               Writeln('Internal SIGSEGV Error caught');
{$ifndef DEBUG}
               Halt;
{$else DEBUG}
               RunError(216);
{$endif DEBUG}
             end;
    SIGFPE : begin
                if StopJmpValid then
                  LongJmp(StopJmp,SIGFPE);
               if Assigned(Application) then IDEApp.Done;
               Writeln('Internal SIGFPE Error caught');
{$ifndef DEBUG}
               Halt;
{$else DEBUG}
               RunError(207);
{$endif DEBUG}
             end;
    SIGILL : begin
                if StopJmpValid then
                  LongJmp(StopJmp,SIGILL);
               if Assigned(Application) then IDEApp.Done;
               Writeln('Internal SIGILL Error caught');
{$ifndef DEBUG}
               Halt;
{$else DEBUG}
               RunError(216);
{$endif DEBUG}
             end;
    SIGINT : begin
               if StopJmpValid then
                 LongJmp(StopJmp,SIGINT);
               IF NOT CtrlCPressed and Assigned(Application) then
                 begin
                   MustQuit:=false;
{$ifdef FPC}
                   CtrlCPressed:=true;
                   Keyboard.PutKeyEvent((kbCtrl shl 16) or kbCtrlC);
{$endif FPC}
                 end
               else
                 begin
                   if Assigned(Application) then
                     MustQuit:=MessageBox(#3+msg_QuitConfirm,nil,mferror+mfyesbutton+mfnobutton)=cmYes
                   else
                     MustQuit:=true;
                 end;
               if MustQuit then
                begin
                  if Assigned(Application) then IDEApp.Done;
{$ifndef DEBUG}
                  Halt;
{$else DEBUG}
                  RunError(216);
{$endif DEBUG}
                end;
             end;
  end;
{$ifndef Unix}
  CatchSignal:=0;
{$endif}
end;
{$endif def HasSignal}


begin
{$ifdef HasSignal}
{$ifndef TP}
  NewSignal:=SignalHandler(@CatchSignal);
{$else TP}
  NewSignal:=SignalHandler(CatchSignal);
{$endif TP}
  OldSigSegm:=Signal (SIGSEGV,NewSignal);
  OldSigInt:=Signal (SIGINT,NewSignal);
  OldSigFPE:=Signal (SIGFPE,NewSignal);
  OldSigILL:=Signal (SIGILL,NewSignal);
{$endif}
end.

{
  $Log$
  Revision 1.3  2000-11-15 00:14:10  pierre
   new merge

  Revision 1.1.2.2  2000/11/14 09:23:55  marco
   * Second batch

  Revision 1.2  2000/10/31 22:35:54  pierre
   * New big merge from fixes branch

  Revision 1.1.2.1  2000/10/31 07:52:55  pierre
   * recover gracefully if compiler generates a signal

  Revision 1.1  2000/07/13 09:48:34  michael
  + Initial import

  Revision 1.6  2000/06/22 09:07:11  pierre
   * Gabor changes: see fixes.txt

  Revision 1.5  2000/05/02 08:42:26  pierre
   * new set of Gabor changes: see fixes.txt

  Revision 1.4  2000/03/07 21:09:20  pierre
    * Use globdir.inc HasSignal conditional
    + Uses PutKeyEvent for CtrlC

  Revision 1.3  1999/12/20 14:23:16  pierre
    * MyApp renamed IDEApp
    * TDebugController.ResetDebuggerRows added to
      get resetting of debugger rows

  Revision 1.2  1999/04/07 21:55:42  peter
    + object support for browser
    * html help fixes
    * more desktop saving things
    * NODEBUG directive to exclude debugger

  Revision 1.1  1999/02/20 15:18:28  peter
    + ctrl-c capture with confirm dialog
    + ascii table in the tools menu
    + heapviewer
    * empty file fixed
    * fixed callback routines in fpdebug to have far for tp7

}
