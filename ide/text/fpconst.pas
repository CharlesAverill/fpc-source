{
    $Id$
    This file is part of the Free Pascal Integrated Development Environment
    Copyright (c) 1998 by Berczi Gabor

    Constants used by the IDE

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit FPConst;

interface

uses Views,App,Commands,
     WViews;

const
     VersionStr           = '0.9';

     MaxRecentFileCount   = 5;
     MaxToolCount         = 16;

     ReservedWordMaxLen   = 16;

     CompilerStatusUpdateDelay = 0.8; { in secs }

     ININame              = 'fp.ini';
     SwitchesName         = 'fp.cfg';
     DesktopName          = 'fp.dsk';

     ToolCaptureName      = '__TOOL__.OUT'; { all '$' signs replaces with '_'s }
     FilterCaptureName    = '_FILTER_.OUT';
     FPOutFileName        = 'FP___.OUT';
     FPErrFileName        = 'FP___.ERR';
     GDBOutFileName       = 'GDB___.OUT';
     GDBOutPutFileName    = 'GDB___.txt';

     HelpFileExts         = '*.tph;*.htm*';

     EnterSign            = #17#196#217;

     { Strings/Messages }
     strLoadingHelp       = 'Loading help files...';
     strBuildingHelpIndex = 'Building Help Index...';
     strLocatingTopic     = 'Locating topic...';

     { Main menu submenu indexes }
     menuFile             = 0;
     menuTools            = 6;

     { MouseAction constants }
     acNone               = 0;
     acTopicSearch        = 1;
     acGotoCursor         = 2;
     acBreakpoint         = 3;
     acEvaluate           = 4;
     acAddWatch           = 5;
     acBrowseSymbol       = 6;
     acFirstAction        = acTopicSearch;
     acLastAction         = acBrowseSymbol;

     { Startup Option constants }
     soReturnToLastDir    = $00000001;

     { Desktop Flag constants - what to include in the desktop file }
     dfHistoryLists       = $00000001;
     dfClipboardContent   = $00000002;
     dfWatches            = $00000004;
     dfBreakpoints        = $00000008;
     dfOpenWindows        = $00000010;
     dfSymbolInformation  = $00000020;

     { Auto Save flag constants }
     asEditorFiles        = $00000001; { Editor files }
     asEnvironment        = $00000002; { .INI file }
     asDesktop            = $00000004; { .DSK file }

     { Misc. Options flag constants }
     moAutoTrackSource    = $00000001;
     moCloseOnGotoSource  = $00000002;
     moChangeDirOnOpen    = $00000004;

     { Desktop Location constants }
     dlCurrentDir         = $00;
     dlConfigFileDir      = $01;

     { Command constants }
     cmShowClipboard     = 201;
     cmFindProcedure     = 206;
     cmObjects           = 207;
     cmModules           = 208;
     cmGlobals           = 209;
     cmRun               = 210;
     cmParameters        = 211;
     cmCompile           = 212;
     cmMake              = 213;
     cmBuild             = 214;
     cmTarget            = 215;
     cmPrimaryFile       = 216;
     cmClearPrimary      = 217;
     cmInformation       = 218;
     cmWindowList        = 219;
     cmHelpTopicSearch   = 220;
     cmMsgGotoSource     = 221;
     cmMsgTrackSource    = 222;
     cmGotoCursor        = 223;
     {cmToggleBreakpoint  = 224; never disabled =>2403 }
     cmAddWatch          = 225;
     cmTraceInto         = 226;
     cmStepOver          = 227;
     cmResetDebugger     = 228;
     cmContToCursor      = 229;
     cmOpenGDBWindow     = 230;
     cmToolsMsgNext      = 231;
     cmToolsMsgPrev      = 232;
     cmGrep              = 233;
     cmCompilerMessages  = 234;
     cmSymbol            = 235;
     cmStack             = 236;
     cmBreakpointList    = 237;
     cmWatches           = 238;
     cmUntilReturn       = 239;
     { WARNING these two are also defined in weditor.pas PM }
     cmCopyWin           = 240;
     cmPasteWin          = 241;

     cmNotImplemented    = 1000;
     cmNewFromTemplate   = 1001;

     cmSearchWindow      = 1500;
     cmSourceWndClosing  = 1601;
     cmCalculatorPaste   = 1603;
     cmMsgClear          = 1604;
     cmUpdateTools       = 1605;
{     cmGrep              = 160?;}

     cmAddItem           = 1620;
     cmEditItem          = 1621;
     cmDeleteItem        = 1622;

     cmUserScreen        = 1650;
     cmUserScreenWindow  = 1651;
     cmEvaluate          = 1652;
     cmCalculator        = 1653;
     cmASCIITable        = 1654;

     cmToolsMessages     = 1700;
     cmToolsBase         = 1800;
     cmRecentFileBase    = 1850;

     cmCompiler          = 2000;
     cmMemorySizes       = 2001;
     cmLinker            = 2002;
     cmDebugger          = 2003;
     cmDirectories       = 2004;
     cmTools             = 2005;
     cmPreferences       = 2006;
     cmEditor            = 2007;
     cmMouse             = 2008;
     cmStartup           = 2009;
     cmColors            = 2010;
     cmOpenINI           = 2011;
     cmSaveINI           = 2012;
     cmSaveAsINI         = 2013;
     cmSwitchesMode      = 2014;
     cmBrowser           = 2015;
     cmDesktopOptions    = 2016;

     cmHelpContents      = 2100;
     cmHelpIndex         = 2101;
     cmHelpPrevTopic     = 2103;
     cmHelpUsingHelp     = 2104;
     cmHelpFiles         = 2105;
     cmAbout             = 2106;

     cmOpenAtCursor      = 2200;
     cmBrowseAtCursor    = 2201;
     cmEditorOptions     = 2202;
     cmBrowserOptions    = 2203;

     cmTrackReference    = 2300;
     cmGotoReference     = 2301;

     cmEditBreakpoint    = 2400;
     cmNewBreakpoint     = 2401;
     cmDeleteBreakpoint  = 2402;
     cmToggleBreakpoint  = 2403;

     { Help constants }
     hcSourceWindow      = 8000;
     hcHelpWindow        = 8001;
     hcClipboardWindow   = 8002;
     hcCalcWindow        = 8003;
     hcInfoWindow        = 8004;
     hcBrowserWindow     = 8005;
     hcMessagesWindow    = 8006;
     hcGDBWindow         = 8007;
     hcBreakpointListWindow = 8008;

     hcShift             = 10000;

     hcUsingHelp         = 2;
     hcContents          = 3;
     hcQuit              = hcShift+cmQuit;
     hcRedo              = hcShift+cmRedo;
     hcFind              = hcShift+cmFind;
     hcReplace           = hcShift+cmReplace;
     hcSearchAgain       = hcShift+cmSearchAgain;
     hcGotoLine          = hcShift+cmJumpLine;

     hcUserScreen        = hcShift+cmUserScreen;
     hcUserScreenWindow  = hcShift+cmUserScreenWindow;

     hcToolsMessages     = hcShift+cmToolsMessages;
     hcToolsBase         = hcShift+cmToolsBase;
     hcRecentFileBase    = hcShift+cmRecentFileBase;

     hcCompiler          = hcShift+cmCompiler;
     hcMemorySizes       = hcShift+cmMemorySizes;
     hcLinker            = hcShift+cmLinker;
     hcDebugger          = hcShift+cmDebugger;
     hcDirectories       = hcShift+cmDirectories;
     hcTools             = hcShift+cmTools;
     hcPreferences       = hcShift+cmPreferences;
     hcEditor            = hcShift+cmEditor;
     hcMouse             = hcShift+cmMouse;
     hcStartup           = hcShift+cmStartup;
     hcColors            = hcShift+cmColors;
     hcOpenINI           = hcShift+cmOpenINI;
     hcSaveINI           = hcShift+cmSaveINI;
     hcSaveAsINI         = hcShift+cmSaveAsINI;
     hcCalculator        = hcShift+cmCalculator;
     hcAsciiTable        = hcShift+cmAsciiTable;
{     hcGrep              = hcShift+cmGrep;}
     hcSwitchesMode      = hcShift+cmSwitchesMode;
     hcBrowser           = hcShift+cmBrowser;
     hcDesktopOptions    = hcShift+cmDesktopOptions;
     hcAbout             = hcShift+cmAbout;
     hcCompilerMessages  = hcShift+cmCompilerMessages;

     hcSystemMenu        = 9000;
     hcFileMenu          = 9001;
     hcEditMenu          = 9002;
     hcSearchMenu        = 9003;
     hcRunMenu           = 9004;
     hcCompileMenu       = 9005;
     hcDebugMenu         = 9006;
     hcToolsMenu         = 9007;
     hcOptionsMenu       = 9008;
     hcEnvironmentMenu   = 9009;
     hcWindowMenu        = 9010;
     hcHelpMenu          = 9011;

     hcFirstCommand      = hcSystemMenu;
     hcLastCommand       = 65535;

     hcShowClipboard     = hcShift+cmShowClipboard;
     hcCopyWin           = hcShift+cmCopyWin;
     hcPasteWin          = hcShift+cmPasteWin;

     hcFindProcedure     = hcShift+cmFindProcedure;
     hcObjects           = hcShift+cmObjects;
     hcModules           = hcShift+cmModules;
     hcGlobals           = hcShift+cmGlobals;
     hcSymbol            = hcShift+cmSymbol;
     hcRun               = hcShift+cmRun;
     hcParameters        = hcShift+cmParameters;
     hcResetDebugger     = hcShift+cmResetDebugger;
     hcContToCursor      = hcShift+cmContToCursor;
     hcUntilReturn       = hcShift+cmUntilReturn;
     hcOpenGDBWindow     = hcShift+cmOpenGDBWindow;
     hcToolsMsgNext      = hcShift+cmToolsMsgNext;
     hcToolsMsgPrev      = hcShift+cmToolsMsgPrev;
     hcCompile           = hcShift+cmCompile;
     hcMake              = hcShift+cmMake;
     hcBuild             = hcShift+cmBuild;
     hcTarget            = hcShift+cmTarget;
     hcPrimaryFile       = hcShift+cmPrimaryFile;
     hcClearPrimary      = hcShift+cmClearPrimary;
     hcInformation       = hcShift+cmInformation;
     hcWindowList        = hcShift+cmWindowList;
     hcNewFromTemplate   = hcShift+cmNewFromTemplate;
     hcHelpTopicSearch   = hcShift+cmHelpTopicSearch;
     hcHelpContents      = hcShift+cmHelpContents;
     hcHelpIndex         = hcShift+cmHelpIndex;
     hcHelpPrevTopic     = hcShift+cmHelpPrevTopic;
     hcHelpUsingHelp     = hcShift+cmHelpUsingHelp;
     hcHelpFiles         = hcShift+cmHelpFiles;
     hcUpdate            = hcShift+cmUpdate;
     hcMsgClear          = hcShift+cmMsgClear;
     hcMsgGotoSource     = hcShift+cmMsgGotoSource;
     hcMsgTrackSource    = hcShift+cmMsgTrackSource;
     hcGotoCursor        = hcShift+cmGotoCursor;
     hcNewBreakpoint     = hcShift+cmNewBreakpoint;
     hcEditBreakpoint    = hcShift+cmEditBreakpoint;
     hcDeleteBreakpoint  = hcShift+cmDeleteBreakpoint;
     hcToggleBreakpoint  = hcShift+cmToggleBreakpoint;
     hcEvaluate          = hcShift+cmEvaluate;
     hcAddWatch          = hcShift+cmAddWatch;
     hcWatches           = hcShift+cmWatches;
     hcGrep              = hcShift+cmGrep;
     hcStack             = hcShift+cmStack;
     hcBreakPointList    = hcShift+cmBreakpointList;

     hcOpenAtCursor      = hcShift+cmOpenAtCursor;
     hcBrowseAtCursor    = hcShift+cmBrowseAtCursor;
     hcEditorOptions     = hcShift+cmEditorOptions;

     { History constants }
     hisChDirDialog      = 2000;

     CIDEHelpDialog      =
        #128#129#130#131#132#133#134#135#136#137#138#139#140#141#142#143 +
        #144#145#146#147#148#149#150#151#152#153#154#155#156#157#158#159 +
        #160#161#162#163 +
        #164#165#166;

     CSourceWindow =
        #167#168#169#170#171#172#173#174#175#176#177#178#179#180#181#182 +
        #183#184#185#186#187#188#189#190#191#192#193#194#195#196#197#198 +
        #199#200#201#202#203#204#205#206#207#208#209#210#211#212#213#214 ;

     CBrowserWindow =
        #215#216#217#218#219#220#221#222#223#224#225#226;

     CBrowserListBox =
        #9#9#10#11#12;

     CBrowserTab =
        #6#12;

     CBrowserOutline = #9#10#10#11;

     CGDBInputLine   = #9#9#10#11#12;

     CFPClockView = #0#227;

     CIDEAppColor = CAppColor +
         { CIDEHelpDialog }
{128-143}#$70#$7F#$7A#$13#$13#$70#$70#$7F#$7E#$20#$2B#$2F#$78#$2E#$70#$30 + { 1-16}
{144-159}#$3F#$3E#$1F#$2F#$1A#$20#$72#$31#$31#$30#$2F#$3E#$31#$13#$38#$00 + {17-32}
{160-163}#$30#$3E#$1E#$70 + { CHelpViewer }                                 {33-36}
{164-166}#$30#$3F#$3A +     { CHelpFrame }                                  {37-39}
         { CSourceWindow }
{167-182}#$17#$1F#$1A#$31#$31#$1E#$71#$1F#$00#$00#$00#$00#$00#$00#$00#$00 + { 1-16}
{183-198}#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00#$00 + {17-32}
{199-214}#$1E#$1F#$17#$1F#$1E#$1B#$13#$1A#$1E#$71#$3F#$30#$1C#$13#$1F#$4E + {33-48}
         { CBrowserWindow }
{215-226}#$31#$3F#$3A#$31#$31#$31#$71#$1F#$31#$2F#$3E#$3F +
         { CFPClockView }
{227-   }#$70;

implementation

END.
{
  $Log$
  Revision 1.28  1999-10-14 10:23:44  pierre
   ClockView Black on Gray by default

  Revision 1.27  1999/09/13 16:24:43  peter
    + clock
    * backspace unident like tp7

  Revision 1.26  1999/09/09 16:31:45  pierre
   * some breakpoint related fixes and Help contexts

  Revision 1.25  1999/09/09 14:15:27  pierre
   + cmCopyWin,cmPasteWin

  Revision 1.24  1999/08/16 18:25:14  peter
    * Adjusting the selection when the editor didn't contain any line.
    * Reserved word recognition redesigned, but this didn't affect the overall
      syntax highlight speed remarkably (at least not on my Amd-K6/350).
      The syntax scanner loop is a bit slow but the main problem is the
      recognition of special symbols. Switching off symbol processing boosts
      the performance up to ca. 200%...
    * The editor didn't allow copying (for ex to clipboard) of a single character
    * 'File|Save as' caused permanently run-time error 3. Not any more now...
    * Compiler Messages window (actually the whole desktop) did not act on any
      keypress when compilation failed and thus the window remained visible
    + Message windows are now closed upon pressing Esc
    + At 'Run' the IDE checks whether any sources are modified, and recompiles
      only when neccessary
    + BlockRead and BlockWrite (Ctrl+K+R/W) implemented in TCodeEditor
    + LineSelect (Ctrl+K+L) implemented
    * The IDE had problems closing help windows before saving the desktop

  Revision 1.23  1999/08/03 20:22:27  peter
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

  Revision 1.22  1999/07/12 13:14:14  pierre
    * LineEnd bug corrected, now goes end of text even if selected
    + Until Return for debugger
    + Code for Quit inside GDB Window

  Revision 1.21  1999/07/10 01:24:13  pierre
   + First implementation of watches window

  Revision 1.20  1999/06/30 23:58:11  pierre
    + BreakpointsList Window implemented
      with Edit/New/Delete functions
    + Individual breakpoint dialog with support for all types
      ignorecount and conditions
      (commands are not yet implemented, don't know if this wolud be useful)
      awatch and rwatch have problems because GDB does not annotate them
      I fixed v4.16 for this

  Revision 1.19  1999/06/28 19:32:18  peter
    * fixes from gabor

  Revision 1.18  1999/06/25 00:38:59  pierre
   +cmSymbol,cmStack,cmBreakpointList

  Revision 1.17  1999/04/07 21:55:44  peter
    + object support for browser
    * html help fixes
    * more desktop saving things
    * NODEBUG directive to exclude debugger

  Revision 1.16  1999/03/23 15:11:27  peter
    * desktop saving things
    * vesa mode
    * preferences dialog

  Revision 1.15  1999/03/19 16:04:28  peter
    * new compiler dialog

  Revision 1.14  1999/03/16 12:38:08  peter
    * tools macro fixes
    + tph writer
    + first things for resource files

  Revision 1.13  1999/03/01 15:41:51  peter
    + Added dummy entries for functions not yet implemented
    * MenuBar didn't update itself automatically on command-set changes
    * Fixed Debugging/Profiling options dialog
    * TCodeEditor converts spaces to tabs at save only if efUseTabChars is set
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

  Revision 1.12  1999/02/22 11:51:34  peter
    * browser updates from gabor

  Revision 1.11  1999/02/20 15:18:28  peter
    + ctrl-c capture with confirm dialog
    + ascii table in the tools menu
    + heapviewer
    * empty file fixed
    * fixed callback routines in fpdebug to have far for tp7

  Revision 1.10  1999/02/11 19:07:19  pierre
    * GDBWindow redesigned :
      normal editor apart from
      that any kbEnter will send the line (for begin to cursor)
      to GDB command !
      GDBWindow opened in Debugger Menu
       still buggy :
       -echo should not be present if at end of text
       -GDBWindow becomes First after each step (I don't know why !)

  Revision 1.9  1999/02/08 17:40:00  pierre
   + cmContToCursor added

  Revision 1.8  1999/02/04 12:23:43  pierre
    + cmResetDebugger and cmGrep
    * Avoid StatusStack overflow

  Revision 1.7  1999/01/22 10:24:02  peter
    * first debugger things

  Revision 1.6  1999/01/21 11:54:12  peter
    + tools menu
    + speedsearch in symbolbrowser
    * working run command

  Revision 1.5  1999/01/12 14:29:33  peter
    + Implemented still missing 'switch' entries in Options menu
    + Pressing Ctrl-B sets ASCII mode in editor, after which keypresses (even
      ones with ASCII < 32 ; entered with Alt+<###>) are interpreted always as
      ASCII chars and inserted directly in the text.
    + Added symbol browser
    * splitted fp.pas to fpide.pas

  Revision 1.4  1999/01/04 11:49:43  peter
   * 'Use tab characters' now works correctly
   + Syntax highlight now acts on File|Save As...
   + Added a new class to syntax highlight: 'hex numbers'.
   * There was something very wrong with the palette managment. Now fixed.
   + Added output directory (-FE<xxx>) support to 'Directories' dialog...
   * Fixed some possible bugs in Running/Compiling, and the compilation/run
     process revised

  Revision 1.2  1998/12/28 15:47:43  peter
    + Added user screen support, display & window
    + Implemented Editor,Mouse Options dialog
    + Added location of .INI and .CFG file
    + Option (INI) file managment implemented (see bottom of Options Menu)
    + Switches updated
    + Run program

  Revision 1.3  1998/12/22 10:39:41  peter
    + options are now written/read
    + find and replace routines

}
