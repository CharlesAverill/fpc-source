{
    $Id$
    This file is part of the Free Pascal Integrated Development Environment
    Copyright (c) 1998 by Berczi Gabor

    Write/Read Options to INI File

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit FPIni;
interface

uses
  FPUtils;

const
    ININame = 'fp.ini';

    ConfigDir  : string{$ifdef GABOR}[50]{$endif} = '.'+DirSep;
    INIFileName: string{$ifdef GABOR}[50]{$endif} = ININame;


procedure InitINIFile;
function  ReadINIFile: boolean;
function  WriteINIFile: boolean;


implementation

uses
  Dos,Objects,Drivers,App,
  WINI,{$ifndef EDITORS}WEditor{$else}Editors{$endif},
  {$ifndef NODEBUG}FPDebug,{$endif}FPConst,FPVars,FPViews,
  FPIntf,FPTools,FPSwitch;

const
  { INI file sections }
  secFiles       = 'Files';
  secRun         = 'Run';
  secCompile     = 'Compile';
  secColors      = 'Colors';
  secHelp        = 'Help';
  secEditor      = 'Editor';
  secBreakpoint  = 'Breakpoints';
  secHighlight   = 'Highlight';
  secMouse       = 'Mouse';
  secSearch      = 'Search';
  secTools       = 'Tools';
  secSourcePath  = 'SourcePath';
  secPreferences = 'Preferences';

  { INI file tags }
  ieRecentFile       = 'RecentFile';
(*  ieOpenFile         = 'OpenFile';
  ieOpenFileCount    = 'OpenFileCount'; *)
  ieRunParameters    = 'Parameters';
  iePrimaryFile      = 'PrimaryFile';
  ieCompileMode      = 'CompileMode';
  iePalette          = 'Palette';
  ieHelpFiles        = 'Files';
  ieDefaultTabSize   = 'DefaultTabSize';
  ieDefaultEditorFlags='DefaultFlags';
  ieDefaultSaveExt   = 'DefaultSaveExt';
  ieOpenExts         = 'OpenExts';
  ieHighlightExts    = 'Exts';
  ieTabsPattern      = 'NeedsTabs';
  ieDoubleClickDelay = 'DoubleDelay';
  ieReverseButtons   = 'ReverseButtons';
  ieAltClickAction   = 'AltClickAction';
  ieCtrlClickAction  = 'CtrlClickAction';
  ieFindFlags        = 'FindFlags';
  ieToolName         = 'Title';
  ieToolProgram      = 'Program';
  ieToolParams       = 'Params';
  ieToolHotKey       = 'HotKey';
  ieBreakpointTyp    = 'Type';
  ieBreakpointCount  = 'Count';
  ieBreakpointState  = 'State';
  ieBreakpointName   = 'Name';
  ieBreakpointFile   = 'FileName';
  ieBreakpointLine   = 'LineNumber';
  ieBreakpointCond   = 'Condition';
  ieSourceList       = 'SourceList';
  ieVideoMode        = 'VideoMode';
  ieAutoSave         = 'AutoSaveFlags';
  ieMiscOptions      = 'MiscOptions';
  ieDesktopLocation  = 'DesktopLocation';
  ieDesktopFlags     = 'DesktopFileFlags';

procedure InitINIFile;
var S: string;
begin
  S:=LocateFile(ININame);
  if S<>'' then
    INIPath:=S;
  INIPath:=FExpand(INIPath);
end;

function PaletteToStr(S: string): string;
var C: string;
    I: integer;
begin
  C:='';
  for I:=1 to length(S) do
    begin
      C:=C+'#$'+IntToHexL(ord(S[I]),2);
    end;
  PaletteToStr:=C;
end;

function StrToPalette(S: string): string;
var I,P,X: integer;
    C: string;
    Hex: boolean;
    OK: boolean;
begin
  C:=''; I:=1;
  OK:=S<>'';
  while OK and (I<=length(S)) and (S[I]='#') do
  begin
    Inc(I); Hex:=false;
    if S[I]='$' then begin Inc(I); Hex:=true; end;
    P:=Pos('#',copy(S,I,255)); if P>0 then P:=I+P-1 else P:=length(S)+1;
    if Hex=false then
      begin
        X:=StrToInt(copy(S,I,P-I));
        OK:=(LastStrToIntResult=0) and (0<=X) and (X<=255);
      end
    else
      begin
        X:=HexToInt(copy(S,I,P-I));
        OK:=(LastHexToIntResult=0) and (0<=X) and (X<=255);
      end;
    if OK then C:=C+chr(X);
    Inc(I,P-I);
  end;
  StrToPalette:=C;
end;

{$ifndef NODEBUG}
procedure WriteOneBreakPointEntry(I : longint;INIFile : PINIFile);
var PB : PBreakpoint;
    S : String;
begin
  Str(I,S);
  PB:=BreakpointCollection^.At(I);
  If assigned(PB) then
   With PB^ do
    Begin
      INIFile^.SetEntry(secBreakpoint,ieBreakpointTyp+S,BreakpointTypeStr[typ]);
      INIFile^.SetEntry(secBreakpoint,ieBreakpointState+S,BreakpointStateStr[state]);
      if typ=bt_file_line then
        begin
          INIFile^.SetEntry(secBreakpoint,ieBreakpointFile+S,FileName^);
          INIFile^.SetIntEntry(secBreakpoint,ieBreakpointLine+S,Line);
        end
      else
        INIFile^.SetEntry(secBreakpoint,ieBreakpointName+S,Name^);
      if assigned(Conditions) then
        INIFile^.SetEntry(secBreakpoint,ieBreakpointCond+S,Conditions^);
    end;
end;

procedure ReadOneBreakPointEntry(i : longint;INIFile : PINIFile);
var PB : PBreakpoint;
    S,S2,SC : string;
    Line : longint;
    typ : BreakpointType;
    state : BreakpointState;

begin
  Str(I,S2);
  typ:=bt_invalid;
  S:=INIFile^.GetEntry(secBreakpoint,ieBreakpointTyp+S2,BreakpointTypeStr[typ]);
  for typ:=low(BreakpointType) to high(BreakpointType) do
    If pos(BreakpointTypeStr[typ],S)>0 then break;
  state:=bs_deleted;
  S:=INIFile^.GetEntry(secBreakpoint,ieBreakpointState+S2,BreakpointStateStr[state]);
  for state:=low(BreakpointState) to high(BreakpointState) do
    If pos(BreakpointStateStr[state],S)>0 then break;
  case typ of
     bt_invalid :;
     bt_file_line :
       begin
         S:=INIFile^.GetEntry(secBreakpoint,ieBreakpointFile+S2,'');
         Line:=INIFile^.GetIntEntry(secBreakpoint,ieBreakpointLine+S2,0);
       end;
     else
       begin
         S:=INIFile^.GetEntry(secBreakpoint,ieBreakpointName+S2,'');
       end;
     end;
   SC:=INIFile^.GetEntry(secBreakpoint,ieBreakpointCond+S,'');
   if (typ=bt_function) and (S<>'') then
     new(PB,init_function(S))
   else if (typ=bt_file_line) and (S<>'') then
     new(PB,init_file_line(S,Line))
   else
     new(PB,init_type(typ,S));
   If assigned(PB) then
     begin
       PB^.state:=state;
       If SC<>'' then
         PB^.conditions:=NewStr(SC);
       BreakpointCollection^.Insert(PB);
     end;
end;
{$endif NODEBUG}

function ReadINIFile: boolean;
var INIFile: PINIFile;
    S,PS,S1,S2,S3: string;
    I,P: integer;
    X,Y : sw_integer;
    BreakPointCount:longint;
    OK: boolean;
    ts : TSwitchMode;
    W: word;
    R : TRect;
begin
  OK:=ExistsFile(INIPath);
  if OK then
 begin
  New(INIFile, Init(INIPath));
  { Files }
  OpenExts:=INIFile^.GetEntry(secFiles,ieOpenExts,OpenExts);
  RecentFileCount:=High(RecentFiles);
  for I:=Low(RecentFiles) to High(RecentFiles) do
    begin
      S:=INIFile^.GetEntry(secFiles,ieRecentFile+IntToStr(I),'');
      if (S='') and (RecentFileCount>I-1) then RecentFileCount:=I-1;
      with RecentFiles[I] do
      begin
        P:=Pos(',',S); if P=0 then P:=length(S)+1;
        FileName:=copy(S,1,P-1); Delete(S,1,P);
        P:=Pos(',',S); if P=0 then P:=length(S)+1;
        LastPos.X:=Max(0,StrToInt(copy(S,1,P-1))); Delete(S,1,P);
        P:=Pos(',',S); if P=0 then P:=length(S)+1;
        LastPos.Y:=Max(0,StrToInt(copy(S,1,P-1))); Delete(S,1,P);
      end;
    end;
  { Run }
  { First read the primary file, which can also set the parameters which can
    be overruled with the parameter loading }
  SetPrimaryFile(INIFile^.GetEntry(secCompile,iePrimaryFile,PrimaryFile));
  SetRunParameters(INIFile^.GetEntry(secRun,ieRunParameters,GetRunParameters));
  { Compile }
  S:=INIFile^.GetEntry(secCompile,ieCompileMode,'');
  for ts:=low(TSwitchMode) to high(TSwitchMode) do
    begin
      if SwitchesModeStr[ts]=S then
        SwitchesMode:=ts;
    end;
  { Help }
  S:=INIFile^.GetEntry(secHelp,ieHelpFiles,'');
  repeat
    P:=Pos(';',S); if P=0 then P:=length(S)+1;
    PS:=copy(S,1,P-1);
    if PS<>'' then HelpFiles^.Insert(NewStr(PS));
    Delete(S,1,P);
  until S='';
  { Editor }
{$ifndef EDITORS}
  DefaultTabSize:=INIFile^.GetIntEntry(secEditor,ieDefaultTabSize,DefaultTabSize);
  DefaultCodeEditorFlags:=INIFile^.GetIntEntry(secEditor,ieDefaultEditorFlags,DefaultCodeEditorFlags);
  DefaultSaveExt:=INIFile^.GetEntry(secEditor,ieDefaultSaveExt,DefaultSaveExt);
{$endif}
  { Highlight }
  HighlightExts:=INIFile^.GetEntry(secHighlight,ieHighlightExts,HighlightExts);
  TabsPattern:=INIFile^.GetEntry(secHighlight,ieTabsPattern,TabsPattern);
  { SourcePath }
  SourceDirs:=INIFile^.GetEntry(secSourcePath,ieSourceList,SourceDirs);
  { Mouse }
  DoubleDelay:=INIFile^.GetIntEntry(secMouse,ieDoubleClickDelay,DoubleDelay);
  MouseReverse:=boolean(INIFile^.GetIntEntry(secMouse,ieReverseButtons,byte(MouseReverse)));
  AltMouseAction:=INIFile^.GetIntEntry(secMouse,ieAltClickAction,AltMouseAction);
  CtrlMouseAction:=INIFile^.GetIntEntry(secMouse,ieCtrlClickAction,CtrlMouseAction);
  { Search }
  FindFlags:=INIFile^.GetIntEntry(secSearch,ieFindFlags,FindFlags);
  { Breakpoints }
{$ifndef NODEBUG}
  BreakpointCount:=INIFile^.GetIntEntry(secBreakpoint,ieBreakpointCount,0);
  for i:=1 to BreakpointCount do
    ReadOneBreakPointEntry(i-1,INIFile);
{$endif}
  { Tools }
  for I:=1 to MaxToolCount do
    begin
      S:=IntToStr(I);
      S1:=INIFile^.GetEntry(secTools,ieToolName+S,'');
      if S1='' then Break; { !!! }
      S2:=INIFile^.GetEntry(secTools,ieToolProgram+S,'');
      S3:=INIFile^.GetEntry(secTools,ieToolParams+S,'');
      W:=Max(0,Min(65535,INIFile^.GetIntEntry(secTools,ieToolHotKey+S,0)));
      AddTool(S1,S2,S3,W);
    end;
  { Colors }
  S:=AppPalette;
  PS:=StrToPalette(INIFile^.GetEntry(secColors,iePalette+'_1_40',PaletteToStr(copy(S,1,40))));
  PS:=PS+StrToPalette(INIFile^.GetEntry(secColors,iePalette+'_41_80',PaletteToStr(copy(S,41,40))));
  PS:=PS+StrToPalette(INIFile^.GetEntry(secColors,iePalette+'_81_120',PaletteToStr(copy(S,81,40))));
  PS:=PS+StrToPalette(INIFile^.GetEntry(secColors,iePalette+'_121_160',PaletteToStr(copy(S,121,40))));
  PS:=PS+StrToPalette(INIFile^.GetEntry(secColors,iePalette+'_161_200',PaletteToStr(copy(S,161,40))));
  PS:=PS+StrToPalette(INIFile^.GetEntry(secColors,iePalette+'_201_240',PaletteToStr(copy(S,201,40))));
  AppPalette:=PS;
(*  { Open files }
  for I:=INIFile^.GetIntEntry(secFiles,ieOpenFileCount,0) downto 1 do
    begin
      S:=INIFile^.GetEntry(secFiles,ieOpenFile+IntToStr(I),'');
      if (S='') then
        break;
      P:=Pos(',',S); if P=0 then P:=length(S)+1;
      S1:=copy(S,1,P-1);
      Delete(S,1,P);
      P:=Pos(',',S);
      if P=0 then P:=length(S)+1;
      X:=Max(0,StrToInt(copy(S,1,P-1)));
      Delete(S,1,P);
      P:=Pos(',',S);
      if P=0 then P:=length(S)+1;
      Y:=Max(0,StrToInt(copy(S,1,P-1)));
      Delete(S,1,P);
      P:=Pos(',',S);
      if P=0 then P:=length(S)+1;
      R.A.X:=Max(0,StrToInt(copy(S,1,P-1)));
      Delete(S,1,P);
      P:=Pos(',',S);
      if P=0 then P:=length(S)+1;
      R.A.Y:=Max(0,StrToInt(copy(S,1,P-1)));
      Delete(S,1,P);
      P:=Pos(',',S);
      if P=0 then P:=length(S)+1;
      R.B.X:=Max(0,StrToInt(copy(S,1,P-1)));
      Delete(S,1,P);
      P:=Pos(',',S);
      if P=0 then P:=length(S)+1;
      R.B.Y:=Max(0,StrToInt(copy(S,1,P-1)));
      if (R.A.X<R.B.X) and (R.A.Y<R.B.Y) then
        TryToOpenFile(@R,S1,X,Y,false)
      else
        TryToOpenFile(nil,S1,X,Y,false);
      { remove it because otherwise we allways keep old files }
      INIFile^.DeleteEntry(secFiles,ieOpenFile+IntToStr(I));
    end;
*)
  { Desktop }
  DesktopFileFlags:=INIFile^.GetIntEntry(secPreferences,ieDesktopFlags,DesktopFileFlags);
  { Preferences }
  AutoSaveOptions:=INIFile^.GetIntEntry(secPreferences,ieAutoSave,AutoSaveOptions);
  MiscOptions:=INIFile^.GetIntEntry(secPreferences,ieMiscOptions,MiscOptions);
  DesktopLocation:=INIFile^.GetIntEntry(secPreferences,ieDesktopLocation,DesktopLocation);
  Dispose(INIFile, Done);
 end;
  ReadINIFile:=OK;
end;

function WriteINIFile: boolean;
var INIFile: PINIFile;
    S: string;
    R : TRect;
    S1,S2,S3: string;
    W: word;
    BreakPointCount:longint;
    I(*,OpenFileCount*): integer;
    OK: boolean;
    PW,PPW : PSourceWindow;

procedure ConcatName(P: PString); {$ifndef FPC}far;{$endif}
begin
  if (S<>'') then S:=S+';';
  S:=S+P^;
end;
begin
  New(INIFile, Init(INIPath));
  { Files }
  { avoid keeping old files }
  INIFile^.DeleteSection(secFiles);
  INIFile^.SetEntry(secFiles,ieOpenExts,'"'+OpenExts+'"');
  for I:=1 to High(RecentFiles) do
    begin
      if I<=RecentFileCount then
         with RecentFiles[I] do S:=FileName+','+IntToStr(LastPos.X)+','+IntToStr(LastPos.Y)
      else
         S:='';
      INIFile^.SetEntry(secFiles,ieRecentFile+IntToStr(I),S);
    end;

(*
    PW:=FirstEditorWindow;
    PPW:=PW;
    I:=1;
    while assigned(PW) do
      begin
        If PW^.HelpCtx=hcSourceWindow then
          begin
            With PW^.editor^ do
              S:=FileName+','+IntToStr(CurPos.X)+','+IntToStr(CurPos.Y);
            PW^.GetBounds(R);
            S:=S+','+IntToStr(R.A.X)+','+IntToStr(R.A.Y)+','+
              IntToStr(R.B.X)+','+IntToStr(R.B.Y);
            INIFile^.SetEntry(secFiles,ieOpenFile+IntToStr(I),S);
            Inc(I);
            OpenFileCount:=I-1;
          end;

        PW:=PSourceWindow(PW^.next);
        While assigned(PW) and (PW<>PPW) and (PW^.HelpCtx<>hcSourceWindow) do
          PW:=PSourceWindow(PW^.next);
        If PW=PPW then
          break;
      end;

  INIFile^.SetIntEntry(secFiles,ieOpenFileCount,OpenFileCount);
*)
  { Run }
  INIFile^.SetEntry(secRun,ieRunParameters,GetRunParameters);
  { Compile }
  INIFile^.SetEntry(secCompile,iePrimaryFile,PrimaryFile);
  INIFile^.SetEntry(secCompile,ieCompileMode,SwitchesModeStr[SwitchesMode]);
  { Help }
  S:='';
  HelpFiles^.ForEach(@ConcatName);
  INIFile^.SetEntry(secHelp,ieHelpFiles,'"'+S+'"');
  { Editor }
{$ifndef EDITORS}
  INIFile^.SetIntEntry(secEditor,ieDefaultTabSize,DefaultTabSize);
  INIFile^.SetIntEntry(secEditor,ieDefaultEditorFlags,DefaultCodeEditorFlags);
  INIFile^.SetEntry(secEditor,ieDefaultSaveExt,DefaultSaveExt);
{$endif}
  { Highlight }
  INIFile^.SetEntry(secHighlight,ieHighlightExts,'"'+HighlightExts+'"');
  INIFile^.SetEntry(secHighlight,ieTabsPattern,'"'+TabsPattern+'"');
  { SourcePath }
  INIFile^.SetEntry(secSourcePath,ieSourceList,'"'+SourceDirs+'"');
  { Mouse }
  INIFile^.SetIntEntry(secMouse,ieDoubleClickDelay,DoubleDelay);
  INIFile^.SetIntEntry(secMouse,ieReverseButtons,byte(MouseReverse));
  INIFile^.SetIntEntry(secMouse,ieAltClickAction,AltMouseAction);
  INIFile^.SetIntEntry(secMouse,ieCtrlClickAction,CtrlMouseAction);
  { Search }
  INIFile^.SetIntEntry(secSearch,ieFindFlags,FindFlags);
  { Breakpoints }
{$ifndef NODEBUG}
  BreakPointCount:=BreakpointCollection^.Count;
  INIFile^.SetIntEntry(secBreakpoint,ieBreakpointCount,BreakpointCount);
  for i:=1 to BreakpointCount do
    WriteOneBreakPointEntry(I-1,INIFile);
{$endif}
  { Tools }
  INIFile^.DeleteSection(secTools);
  for I:=1 to GetToolCount do
    begin
      S:=IntToStr(I);
      GetToolParams(I-1,S1,S2,S3,W);
      if S1<>'' then S1:='"'+S1+'"';
      if S2<>'' then S2:='"'+S2+'"';
      if S3<>'' then S3:='"'+S3+'"';
      INIFile^.SetEntry(secTools,ieToolName+S,S1);
      INIFile^.SetEntry(secTools,ieToolProgram+S,S2);
      INIFile^.SetEntry(secTools,ieToolParams+S,S3);
      INIFile^.SetIntEntry(secTools,ieToolHotKey+S,W);
    end;
  { Colors }
  if AppPalette<>CIDEAppColor then
  begin
    { this has a bug. if a different palette has been read on startup, and
      then changed back to match the default, this will not update it in the
      ini file, eg. the original (non-default) will be left unmodified... }
    S:=AppPalette;
    INIFile^.SetEntry(secColors,iePalette+'_1_40',PaletteToStr(copy(S,1,40)));
    INIFile^.SetEntry(secColors,iePalette+'_41_80',PaletteToStr(copy(S,41,40)));
    INIFile^.SetEntry(secColors,iePalette+'_81_120',PaletteToStr(copy(S,81,40)));
    INIFile^.SetEntry(secColors,iePalette+'_121_160',PaletteToStr(copy(S,121,40)));
    INIFile^.SetEntry(secColors,iePalette+'_161_200',PaletteToStr(copy(S,161,40)));
    INIFile^.SetEntry(secColors,iePalette+'_201_240',PaletteToStr(copy(S,201,40)));
  end;
  { Desktop }
  INIFile^.SetIntEntry(secPreferences,ieDesktopFlags,DesktopFileFlags);
  { Preferences }
  INIFile^.SetIntEntry(secPreferences,ieAutoSave,AutoSaveOptions);
  INIFile^.SetIntEntry(secPreferences,ieMiscOptions,MiscOptions);
  INIFile^.SetIntEntry(secPreferences,ieDesktopLocation,DesktopLocation);
  OK:=INIFile^.Update;
  Dispose(INIFile, Done);
  WriteINIFile:=OK;
end;

end.
{
  $Log$
  Revision 1.21  1999-08-03 20:22:33  peter
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

  Revision 1.20  1999/06/28 12:36:51  pierre
   * avoid keeping old open file names

  Revision 1.19  1999/04/07 21:55:48  peter
    + object support for browser
    * html help fixes
    * more desktop saving things
    * NODEBUG directive to exclude debugger

  Revision 1.18  1999/03/23 15:11:31  peter
    * desktop saving things
    * vesa mode
    * preferences dialog

  Revision 1.17  1999/03/12 01:13:58  peter
    * flag if trytoopen should look for other extensions
    + browser tab in the tools-compiler

  Revision 1.16  1999/03/08 14:58:09  peter
    + prompt with dialogs for tools

  Revision 1.15  1999/03/05 17:53:02  pierre
   + saving and opening of open files on exit

  Revision 1.14  1999/03/01 15:41:55  peter
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

  Revision 1.13  1999/02/22 02:15:14  peter
    + default extension for save in the editor
    + Separate Text to Find for the grep dialog
    * fixed redir crash with tp7

  Revision 1.12  1999/02/19 18:43:46  peter
    + open dialog supports mask list

  Revision 1.11  1999/02/10 09:53:14  pierre
  * better storing of breakpoints

  Revision 1.10  1999/02/05 13:08:42  pierre
   + new breakpoint types added

  Revision 1.9  1999/02/05 12:11:55  pierre
    + SourceDir that stores directories for sources that the
      compiler should not know about
      Automatically asked for addition when a new file that
      needed filedialog to be found is in an unknown directory
      Stored and retrieved from INIFile
    + Breakpoints conditions added to INIFile
    * Breakpoints insterted and removed at debin and end of debug session

  Revision 1.8  1999/02/04 17:52:38  pierre
   * bs_invalid renamed bs_deleted

  Revision 1.7  1999/02/04 17:19:24  peter
    * linux fixes

  Revision 1.6  1999/02/04 13:32:04  pierre
    * Several things added (I cannot commit them independently !)
    + added TBreakpoint and TBreakpointCollection
    + added cmResetDebugger,cmGrep,CmToggleBreakpoint
    + Breakpoint list in INIFile
    * Select items now also depend of SwitchMode
    * Reading of option '-g' was not possible !
    + added search for -Fu args pathes in TryToOpen
    + added code for automatic opening of FileDialog
      if source not found

  Revision 1.5  1999/01/21 11:54:15  peter
    + tools menu
    + speedsearch in symbolbrowser
    * working run command

  Revision 1.4  1999/01/04 11:49:45  peter
   * 'Use tab characters' now works correctly
   + Syntax highlight now acts on File|Save As...
   + Added a new class to syntax highlight: 'hex numbers'.
   * There was something very wrong with the palette managment. Now fixed.
   + Added output directory (-FE<xxx>) support to 'Directories' dialog...
   * Fixed some possible bugs in Running/Compiling, and the compilation/run
     process revised

  Revision 1.1  1998/12/28 15:47:45  peter
    + Added user screen support, display & window
    + Implemented Editor,Mouse Options dialog
    + Added location of .INI and .CFG file
    + Option (INI) file managment implemented (see bottom of Options Menu)
    + Switches updated
    + Run program

}
