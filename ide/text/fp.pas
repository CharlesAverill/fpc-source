
{
    $Id$
    This file is part of the Free Pascal Integrated Development Environment
    Copyright (c) 1998 by Berczi Gabor

    Main program of the IDE

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
program FP;

{$I globdir.inc}
(**********************************************************************)
(* CONDITIONAL DEFINES                                                *)
(*  - NODEBUG    No Debugging support                                 *)
(*  - TP         Turbo Pascal mode                                    *)
(*  - i386       Target is an i386 IDE                                *)
(**********************************************************************)

uses
{$ifdef IDEHeapTrc}
  HeapTrc,
{$endif IDEHeapTrc}
{$ifdef go32v2}
  dpmiexcp,
{$endif go32v2}
{$ifdef debug}
  lineinfo,
{$endif debug}
  Dos,Objects,
  BrowCol,
  Views,App,Dialogs,ColorSel,Menus,StdDlg,Validate,
  {$ifdef EDITORS}Editors{$else}WEditor{$endif},
  ASCIITab,Calc,
  WUtils,WViews,
  FPIDE,FPCalc,FPCompile,
  FPIni,FPViews,FPConst,FPVars,FPUtils,FPHelp,FPSwitch,FPUsrScr,
  FPTools,{$ifndef NODEBUG}FPDebug,{$endif}FPTemplt,FPCatch,FPRedir,FPDesk,
  FPSymbol,FPCodTmp,FPCodCmp;


procedure ProcessParams(BeforeINI: boolean);

  function IsSwitch(const Param: string): boolean;
  begin
    IsSwitch:=(Param<>'') and (Param[1]<>DirSep) { <- allow UNIX root-relative paths            }
          and (Param[1] in ['-','/']);           { <- but still accept dos switch char, eg. '/' }
  end;

var I: Sw_integer;
    Param: string;
begin
  for I:=1 to ParamCount do
  begin
    Param:=System.ParamStr(I);
    if IsSwitch(Param) then
      begin
        Param:=copy(Param,2,255);
        if Param<>'' then
        case Upcase(Param[1]) of
          'C' : { custom config file (BP compatiblity) }
           if BeforeINI then
            begin
              if (length(Param)>=1) and (Param[1] in['=',':']) then
                Delete(Param,1,1); { eat separator }
              INIPath:=copy(Param,2,255);
            end;
{$ifdef go32v2}
          'N' :
             if UpCase(Param)='NOLFN' then
               LFNSupport:=false;
{$endif go32v2}
          'R' : { enter the directory last exited from (BP comp.) }
            begin
              Param:=copy(Param,2,255);
              if (Param='') or (Param='+') then
                StartupOptions:=StartupOptions or soReturnToLastDir
              else
              if (Param='-') then
                StartupOptions:=StartupOptions and (not soReturnToLastDir);
            end;
        end;
      end
    else
      if not BeforeINI then
        TryToOpenFile(nil,Param,0,0,{false}true);
  end;
end;

Procedure MyStreamError(Var S: TStream); {$ifndef FPC}far;{$endif}
var ErrS: string;
begin
  case S.Status of
    stGetError : ErrS:='Get of unregistered object type';
    stPutError : ErrS:='Put of unregistered object type';
  else ErrS:='';
  end;
  if ErrS<>'' then
  begin
    {$ifdef GABOR}{$ifdef TP}asm int 3;end;{$endif}{$endif}
    if Assigned(Application) then
      ErrorBox('Stream error: '+#13+ErrS,nil)
    else

      writeln('Error: ',ErrS);
  end;
end;

procedure RegisterIDEObjects;
begin
  RegisterApp;
  RegisterAsciiTab;
  RegisterCalc;
  RegisterCodeComplete;
  RegisterCodeTemplates;
  RegisterColorSel;
  RegisterDialogs;
{$ifdef EDITORS}
  RegisterEditors;
{$else}
  RegisterCodeEditors;
{$endif}
  RegisterFPCalc;
  RegisterFPCompile;
  RegisterFPTools;
  RegisterFPViews;
{$ifndef NODEBUG}
  RegisterFPDebugViews;
{$endif}
  RegisterMenus;
  RegisterStdDlg;
  RegisterSymbols;
  RegisterObjects;
  RegisterValidate;
  RegisterViews;

  RegisterWUtils;
  RegisterWViews;
end;

var CanExit : boolean;

BEGIN
  {$ifdef DEV}HeapLimit:=4096;{$endif}
  writeln('� Free Pascal IDE  Version '+VersionStr);

  ProcessParams(true);

  StartupDir:=CompleteDir(FExpand('.'));
  IDEDir:=CompleteDir(DirOf(system.Paramstr(0)));

  RegisterIDEObjects;
  StreamError:=@MyStreamError;

{$ifdef win32}
  DosExecute(GetEnv('COMSPEC'),'/C echo This dummy call gets the mouse to become visible');
{$endif win32}
{$ifdef VESA}
  InitVESAScreenModes;
{$endif}
  InitRedir;
{$ifndef NODEBUG}
  InitBreakpoints;
  InitWatches;
{$endif}
  InitReservedWords;
  InitHelpFiles;
  InitSwitches;
  InitINIFile;
  InitUserScreen;
  InitTools;
  InitTemplates;
  InitCodeTemplates;
  InitCodeComplete;

  ReadSwitches(SwitchesPath);
  IDEApp.Init;
  { load all options after init because of open files }
  ReadINIFile;
  InitDesktopFile;
  LoadDesktop;
  ParseUserScreen;

  { Update IDE }
  IDEApp.Update;
  IDEApp.UpdateMode;
  IDEApp.UpdateTarget;

  ProcessParams(false);

  repeat
    IDEApp.Run;
    if (AutoSaveOptions and asEditorFiles)=0 then
      CanExit:=true
    else
      CanExit:=IDEApp.SaveAll;
  until CanExit;

  IDEApp.AutoSave;

  DoneDesktopFile;

  IDEApp.Done;
  WriteSwitches(SwitchesPath);

  DoneCodeComplete;
  DoneCodeTemplates;
  DoneTemplates;
  DoneTools;
  DoneUserScreen;
  DoneSwitches;
  DoneHelpFiles;
  DoneReservedWords;
  ClearToolMessages;
  DoneBrowserCol;
{$ifndef NODEBUG}
  DoneDebugger;
  DoneBreakpoints;
  DoneWatches;
{$endif}

  StreamError:=nil;
END.
{
  $Log$
  Revision 1.40  2000-03-07 21:58:58  pierre
   + uses ParseUserScreen and UpdateMode

  Revision 1.39  2000/02/12 23:58:26  carl
    + Conditional define explanaations

  Revision 1.38  2000/02/07 11:54:17  pierre
   + RegisterWUtils by Gabor

  Revision 1.37  2000/01/25 00:26:35  pierre
   + Browser info saving

  Revision 1.36  2000/01/10 15:53:37  pierre
  * WViews objects were not registered

  Revision 1.35  2000/01/03 11:38:33  michael
  Changes from Gabor

  Revision 1.34  1999/12/20 14:23:16  pierre
    * MyApp renamed IDEApp
    * TDebugController.ResetDebuggerRows added to
      get resetting of debugger rows

  Revision 1.33  1999/12/20 09:36:49  pierre
   * get the mouse visible on win32 fp

  Revision 1.32  1999/12/10 13:02:05  pierre
  + VideoMode save/restore

  Revision 1.31  1999/09/13 11:43:59  peter
    * fixes from gabor, idle event, html fix

  Revision 1.30  1999/08/22 22:24:15  pierre
   * avoid objpas paramstr functions

  Revision 1.29  1999/08/03 20:22:25  peter
    + TTab acts now on Ctrl+Tab and Ctrl+Shift+Tab...
    + Desktop saving should work now
       - History saved
       - Clipboard content saved
       - Desktop saved
       - Symbol info saved
    * syntax-highlight bug fixed, which compared special keywords case sensitive
      (for ex. 'asm' caused asm-highlighting, while 'ASM' didn't)
    * with 'whole words only' set, the editor didn't found occourences of the
      searched text, if the text appeared previously in the same line, but didn't
      satisfied the 'whole-word' condition
    * ^QB jumped to (SelStart.X,SelEnd.X) instead of (SelStart.X,SelStart.Y)
      (ie. the beginning of the selection)
    * when started typing in a new line, but not at the start (X=0) of it,
      the editor inserted the text one character more to left as it should...
    * TCodeEditor.HideSelection (Ctrl-K+H) didn't update the screen
    * Shift shouldn't cause so much trouble in TCodeEditor now...
    * Syntax highlight had problems recognizing a special symbol if it was
      prefixed by another symbol character in the source text
    * Auto-save also occours at Dos shell, Tool execution, etc. now...

  Revision 1.28  1999/07/10 01:24:11  pierre
   + First implementation of watches window

  Revision 1.27  1999/06/29 22:43:12  peter
    * try to add extensions to params

  Revision 1.26  1999/06/28 23:31:14  pierre
   * typo inside go32v2 cond error removed

  Revision 1.25  1999/06/28 19:25:34  peter
    * fixes from gabor

  Revision 1.24  1999/06/28 12:40:56  pierre
   + clear tool messages at exit

  Revision 1.23  1999/06/25 00:48:05  pierre
   + adds current target in menu at startup

  Revision 1.22  1999/05/22 13:44:28  peter
    * fixed couple of bugs

  Revision 1.21  1999/04/07 21:55:40  peter
    + object support for browser
    * html help fixes
    * more desktop saving things
    * NODEBUG directive to exclude debugger

  Revision 1.20  1999/03/23 16:16:36  peter
    * linux fixes

  Revision 1.19  1999/03/23 15:11:26  peter
    * desktop saving things
    * vesa mode
    * preferences dialog

  Revision 1.18  1999/03/21 22:51:35  florian
    + functional screen mode switching added

  Revision 1.17  1999/03/16 12:38:06  peter
    * tools macro fixes
    + tph writer
    + first things for resource files

  Revision 1.16  1999/03/12 01:13:01  peter
    * use TryToOpen() with parameter files to overcome double opened files
      at startup

  Revision 1.15  1999/03/08 14:58:08  peter
    + prompt with dialogs for tools

  Revision 1.14  1999/03/05 17:53:00  pierre
   + saving and opening of open files on exit

  Revision 1.13  1999/03/01 15:41:48  peter
    + Added dummy entries for functions not yet implemented
    * MenuBar didn't update itself automatically on command-set changes
    * Fixed Debugging/Profiling options dialog
    * TCodeEditor converts spaces to tabs at save only if efUseTabChars is
 set
    * efBackSpaceUnindents works correctly
    + 'Messages' window implemented
    + Added '$CAP MSG()' and '$CAP EDIT' to available tool-macros
    + Added TP message-filter support (for ex. you can call GREP thru
      GREP2MSG and view the result in the messages window - just like in TP)
    * A 'var' was missing from the param-list of THelpFacility.TopicSearch,
      so topic search didn't work...
    * In FPHELP.PAS there were still context-variables defined as word instead
      of THelpCtx
    * StdStatusKeys() was missing from the statusdef for help windows
    + Topic-title for index-table can be specified when adding a HTML-files

  Revision 1.12  1999/02/20 15:18:25  peter
    + ctrl-c capture with confirm dialog
    + ascii table in the tools menu
    + heapviewer
    * empty file fixed
    * fixed callback routines in fpdebug to have far for tp7

  Revision 1.11  1999/02/18 13:44:30  peter
    * search fixed
    + backward search
    * help fixes
    * browser updates

  Revision 1.10  1999/02/15 09:07:10  pierre
   * HEAPTRC conditionnal renamed IDEHEAPTRC

  Revision 1.9  1999/02/10 09:55:43  pierre
     + Memory tracing if compiled with -dHEAPTRC
     * Many memory leaks removed

  Revision 1.8  1999/02/08 09:30:59  florian
    + some split heap stuff, in $ifdef TEMPHEAP

  Revision 1.7  1999/02/05 13:51:38  peter
    * unit name of FPSwitches -> FPSwitch which is easier to use
    * some fixes for tp7 compiling

  Revision 1.6  1999/01/21 11:54:10  peter
    + tools menu
    + speedsearch in symbolbrowser
    * working run command

  Revision 1.5  1999/01/12 14:29:31  peter
    + Implemented still missing 'switch' entries in Options menu
    + Pressing Ctrl-B sets ASCII mode in editor, after which keypresses (even
      ones with ASCII < 32 ; entered with Alt+<###>) are interpreted always as
      ASCII chars and inserted directly in the text.
    + Added symbol browser
    * splitted fp.pas to fpide.pas

}