{
    $Id$
    This file is part of the Free Pascal Integrated Development Environment
    Copyright (c) 1998 by Berczi Gabor

    Views and view-related functions for the IDE

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit FPViews;

interface

uses
  Dos,Objects,Drivers,Commands,HelpCtx,Views,Menus,Dialogs,App,
{$ifdef EDITORS}
  Editors,
{$else}
  WEditor,
{$endif}
  WHlpView,
  Comphook,
  FPConst,FPUsrScr;

type
{$IFNDEF EDITORS}
    TEditor = TCodeEditor; PEditor = PCodeEditor;
{$ENDIF}

    PCenterDialog = ^TCenterDialog;
    TCenterDialog = object(TDialog)
      constructor Init(var Bounds: TRect; ATitle: TTitleStr);
    end;

    PIntegerLine = ^TIntegerLine;
    TIntegerLine = object(TInputLine)
      constructor Init(var Bounds: TRect; AMin, AMax: longint);
    end;

    TFPWindow = object(TWindow)
      procedure HandleEvent(var Event: TEvent); virtual;
    end;

    PIDEHelpWindow = ^TIDEHelpWindow;
    TIDEHelpWindow = object(THelpWindow)
      function  GetPalette: PPalette; virtual;
    end;

    PSourceEditor = ^TSourceEditor;
    TSourceEditor = object(TFileEditor)
{$ifndef EDITORS}
      function  IsReservedWord(const S: string): boolean; virtual;
      function  GetSpecSymbolCount(SpecClass: TSpecSymbolClass): integer; virtual;
      function  GetSpecSymbol(SpecClass: TSpecSymbolClass; Index: integer): string; virtual;
{$endif}
      procedure   HandleEvent(var Event: TEvent); virtual;
      procedure   LocalMenu(P: TPoint); virtual;
      function    GetLocalMenu: PMenu; virtual;
      function    GetCommandTarget: PView; virtual;
    private
      LastLocalCmd : word;
    end;

    PSourceWindow = ^TSourceWindow;
    TSourceWindow = object(TFPWindow)
      Editor    : PSourceEditor;
      Indicator : PIndicator;
      constructor Init(var Bounds: TRect; AFileName: string);
      procedure   SetTitle(ATitle: string); virtual;
      procedure   UpdateTitle; virtual;
      procedure   HandleEvent(var Event: TEvent); virtual;
      procedure   SetState(AState: Word; Enable: Boolean); virtual;
      procedure   Update; virtual;
      procedure   UpdateCommands; virtual;
      function    GetPalette: PPalette; virtual;
      destructor  Done; virtual;
    end;

    PGDBSourceEditor = ^TGDBSourceEditor;
    TGDBSourceEditor = object(TSourceEditor)
      function   InsertLine : Sw_integer;virtual;
      function   Valid(Command: Word): Boolean; virtual;
      procedure  AddLine(const S: string); virtual;
      procedure  AddErrorLine(const S: string); virtual;
    private
      Silent,
      AutoRepeat,
      IgnoreStringAtEnd : boolean;
      LastCommand : String;
      end;

    PGDBWindow = ^TGDBWindow;
    TGDBWindow = object(TFPWindow)
      Editor    : PGDBSourceEditor;
      Indicator : PIndicator;
      constructor Init(var Bounds: TRect);
      procedure   WriteText(Buf : pchar;IsError : boolean);
      procedure   WriteString(Const S : string);
      procedure   WriteErrorString(Const S : string);
      procedure   WriteOutputText(Buf : pchar);
      procedure   WriteErrorText(Buf : pchar);
      function    GetPalette: PPalette;virtual;
      destructor  Done; virtual;
    end;

    PClipboardWindow = ^TClipboardWindow;
    TClipboardWindow = object(TSourceWindow)
      constructor Init;
      procedure   Close; virtual;
      destructor  Done; virtual;
    end;

    PAdvancedMenuBox = ^TAdvancedMenuBox;
    TAdvancedMenuBox = object(TMenuBox)
      function NewSubView(var Bounds: TRect; AMenu: PMenu;
                 AParentMenu: PMenuView): PMenuView; virtual;
      function Execute: Word; virtual;
    end;

    PAdvancedMenuPopUp = ^TAdvancedMenuPopup;
    TAdvancedMenuPopUp = object(TMenuPopup)
      function NewSubView(var Bounds: TRect; AMenu: PMenu;
                 AParentMenu: PMenuView): PMenuView; virtual;
      function Execute: Word; virtual;
    end;

    PAdvancedMenuBar = ^TAdvancedMenuBar;
    TAdvancedMenuBar = object(TMenuBar)
      constructor Init(var Bounds: TRect; AMenu: PMenu);
      function  NewSubView(var Bounds: TRect; AMenu: PMenu;
                  AParentMenu: PMenuView): PMenuView; virtual;
      procedure Update; virtual;
      procedure HandleEvent(var Event: TEvent); virtual;
      function  Execute: Word; virtual;
    end;

    PAdvancedStaticText = ^TAdvancedStaticText;
    TAdvancedStaticText = object(TStaticText)
      procedure SetText(S: string); virtual;
    end;

    PAdvancedListBox = ^TAdvancedListBox;
    TAdvancedListBox = object(TListBox)
      Default: boolean;
      procedure HandleEvent(var Event: TEvent); virtual;
    end;

    TLocalMenuListBox = object(TAdvancedListBox)
      procedure   HandleEvent(var Event: TEvent); virtual;
      procedure   LocalMenu(P: TPoint); virtual;
      function    GetLocalMenu: PMenu; virtual;
      function    GetCommandTarget: PView; virtual;
    private
      LastLocalCmd: word;
    end;

    PColorStaticText = ^TColorStaticText;
    TColorStaticText = object(TAdvancedStaticText)
      Color: word;
      DontWrap: boolean;
      Delta: TPoint;
      constructor Init(var Bounds: TRect; AText: String; AColor: word);
      procedure   Draw; virtual;
    end;

    PUnsortedStringCollection = ^TUnsortedStringCollection;
    TUnsortedStringCollection = object(TCollection)
      function  At(Index: Integer): PString;
      procedure FreeItem(Item: Pointer); virtual;
    end;

    PHSListBox = ^THSListBox;
    THSListBox = object(TLocalMenuListBox)
      constructor Init(var Bounds: TRect; ANumCols: Word; AHScrollBar, AVScrollBar: PScrollBar);
    end;

    PDlgWindow = ^TDlgWindow;
    TDlgWindow = object(TDialog)
      constructor Init(var Bounds: TRect; ATitle: TTitleStr; ANumber: Integer);
    end;

    PAdvancedStatusLine = ^TAdvancedStatusLine;
    TAdvancedStatusLine = object(TStatusLine)
      StatusText: PString;
      function  GetStatusText: string; virtual;
      procedure SetStatusText(const S: string); virtual;
      procedure ClearStatusText; virtual;
      procedure Draw; virtual;
    end;

    PMessageItem = ^TMessageItem;
    TMessageItem = object(TObject)
      TClass    : longint;
      Text      : PString;
      Module    : PString;
      ID,Col    : longint;
      constructor Init(AClass: longint; AText, AModule: string; AID,ACol: longint);
      function    GetText(MaxLen: integer): string; virtual;
      procedure   Selected; virtual;
      function    GetModuleName: string; virtual;
      destructor  Done; virtual;
    end;

    PMessageListBox = ^TMessageListBox;
    TMessageListBox = object(THSListBox)
      Transparent: boolean;
      NoSelection: boolean;
      MaxWidth: integer;
      constructor Init(var Bounds: TRect; AHScrollBar, AVScrollBar: PScrollBar);
      procedure   AddItem(P: PMessageItem); virtual;
      function    GetText(Item: Integer; MaxLen: Integer): String; virtual;
      procedure   Clear; virtual;
      procedure   TrackSource; virtual;
      procedure   GotoSource; virtual;
      procedure   Draw; virtual;
      procedure   HandleEvent(var Event: TEvent); virtual;
      function    GetLocalMenu: PMenu; virtual;
      destructor  Done; virtual;
    end;

    PCompilerMessage = ^TCompilerMessage;
    TCompilerMessage = object(TMessageItem)
      function    GetText(MaxLen: Integer): String; virtual;
    end;

    PProgramInfoWindow = ^TProgramInfoWindow;
    TProgramInfoWindow = object(TDlgWindow)
      InfoST: PColorStaticText;
      LogLB : PMessageListBox;
      constructor Init;
      procedure   AddMessage(AClass: longint; Msg, Module: string; Line,Column: longint);
      procedure   ClearMessages;
      procedure   SizeLimits(var Min, Max: TPoint); virtual;
      procedure   Close; virtual;
      procedure   HandleEvent(var Event: TEvent); virtual;
      procedure   Update; virtual;
      destructor  Done; virtual;
    end;

    PTabItem = ^TTabItem;
    TTabItem = record
      Next : PTabItem;
      View : PView;
      Dis  : boolean;
    end;

    PTabDef = ^TTabDef;
    TTabDef = record
      Next     : PTabDef;
      Name     : PString;
      Items    : PTabItem;
      DefItem  : PView;
      ShortCut : char;
    end;

    PTab = ^TTab;
    TTab = object(TGroup)
      TabDefs   : PTabDef;
      ActiveDef : integer;
      DefCount  : word;
      constructor Init(var Bounds: TRect; ATabDef: PTabDef);
      function    AtTab(Index: integer): PTabDef; virtual;
      procedure   SelectTab(Index: integer); virtual;
      function    TabCount: integer;
      function    Valid(Command: Word): Boolean; virtual;
      procedure   ChangeBounds(var Bounds: TRect); virtual;
      procedure   HandleEvent(var Event: TEvent); virtual;
      function    GetPalette: PPalette; virtual;
      procedure   Draw; virtual;
      procedure   SetState(AState: Word; Enable: Boolean); virtual;
      destructor  Done; virtual;
    private
      InDraw: boolean;
    end;

    PScreenView = ^TScreenView;
    TScreenView = object(TScroller)
      Screen: PScreen;
      constructor Init(var Bounds: TRect; AHScrollBar, AVScrollBar: PScrollBar;
                    AScreen: PScreen);
      procedure   Draw; virtual;
      procedure   Update; virtual;
      procedure   HandleEvent(var Event: TEvent); virtual;
    end;

    PScreenWindow = ^TScreenWindow;
    TScreenWindow = object(TFPWindow)
      ScreenView : PScreenView;
      constructor Init(AScreen: PScreen; ANumber: integer);
      destructor  Done; virtual;
    end;

function  SearchFreeWindowNo: integer;

procedure InsertOK(ADialog: PDialog);
procedure InsertButtons(ADialog: PDialog);

procedure ErrorBox(const S: string; Params: pointer);
procedure WarningBox(const S: string; Params: pointer);
procedure InformationBox(const S: string; Params: pointer);
function  ConfirmBox(const S: string; Params: pointer; CanCancel: boolean): word;

function IsThereAnyEditor: boolean;
function IsThereAnyWindow: boolean;
function FirstEditorWindow: PSourceWindow;
function EditorWindowFile(const Name : String): PSourceWindow;

function  SearchMenuItem(Menu: PMenu; Cmd: word): PMenuItem;
procedure SetMenuItemParam(Menu: PMenuItem; Param: string);
function  IsSubMenu(P: PMenuItem): boolean;
function  IsSeparator(P: PMenuItem): boolean;
function  UpdateMenu(M: PMenu): boolean;
function  SearchSubMenu(M: PMenu; Index: integer): PMenuItem;
procedure AppendMenuItem(M: PMenu; I: PMenuItem);
procedure RemoveMenuItem(Menu: PMenu; I: PMenuItem);
function  GetMenuItemBefore(Menu:PMenu; BeforeOf: PMenuItem): PMenuItem;

function  NewTabItem(AView: PView; ANext: PTabItem): PTabItem;
procedure DisposeTabItem(P: PTabItem);
function  NewTabDef(AName: string; ADefItem: PView; AItems: PTabItem; ANext: PTabDef): PTabDef;
procedure DisposeTabDef(P: PTabDef);

function  GetEditorCurWord(Editor: PEditor): string;
procedure InitReservedWords;
procedure DoneReservedWords;

procedure TranslateMouseClick(View: PView; var Event: TEvent);

function GetNextEditorBounds(var Bounds: TRect): boolean;
function OpenEditorWindow(Bounds: PRect; FileName: string; CurX,CurY: integer): PSourceWindow;
function TryToOpenFile(Bounds: PRect; FileName: string; CurX,CurY: integer): PSourceWindow;

const
      SourceCmds  : TCommandSet =
        ([cmSave,cmSaveAs,cmCompile]);
      EditorCmds  : TCommandSet =
        ([cmFind,cmReplace,cmSearchAgain,cmJumpLine,cmHelpTopicSearch]);
      CompileCmds : TCommandSet =
        ([cmMake,cmBuild,cmRun]);

      CalcClipboard  : extended = 0;

      OpenFileName   : string = '';
      NewEditorOpened: boolean = false;

var  MsgParms : array[1..10] of
         record
           case byte of
             0 : (Ptr : pointer);
             1 : (Long: longint);
         end;

implementation

uses
  Strings,Keyboard,Memory,MsgBox,Validate,
  Tokens,FPSwitch,FPSymbol,FPDebug,
  FPVars,FPUtils,FPHelp,FPCompile;

const
  NoNameCount    : integer = 0;
  ReservedWords  : PUnsortedStringCollection = nil;

function IsThereAnyEditor: boolean;
function EditorWindow(P: PView): boolean; {$ifndef FPC}far;{$endif}
begin
  EditorWindow:=(P^.HelpCtx=hcSourceWindow);
end;
begin
  IsThereAnyEditor:=Desktop^.FirstThat(@EditorWindow)<>nil;
end;

function IsThereAnyHelpWindow: boolean;
begin
  IsThereAnyHelpWindow:=(HelpWindow<>nil) and (HelpWindow^.GetState(sfVisible));
end;

function IsThereAnyWindow: boolean;
var _Is: boolean;
begin
  _Is:=Message(Desktop,evBroadcast,cmSearchWindow,nil)<>nil;
  _Is:=_Is or ( (ClipboardWindow<>nil) and ClipboardWindow^.GetState(sfVisible));
  IsThereAnyWindow:=_Is;
end;

function FirstEditorWindow: PSourceWindow;
function EditorWindow(P: PView): boolean; {$ifndef FPC}far;{$endif}
begin
  EditorWindow:=(P^.HelpCtx=hcSourceWindow);
end;
begin
  FirstEditorWindow:=pointer(Desktop^.FirstThat(@EditorWindow));
end;

function EditorWindowFile(const Name : String): PSourceWindow;
function EditorWindow(P: PView): boolean; {$ifndef FPC}far;{$endif}
begin
  EditorWindow:=(TypeOf(P^)=TypeOf(TSourceWindow)) and
{$ifdef linux}
                 (PSourceWindow(P)^.Editor^.FileName=Name);
{$else linux}
                 (UpCaseStr(PSourceWindow(P)^.Editor^.FileName)=UpCaseStr(Name));
{$endif def linux}
end;
begin
  EditorWindowFile:=pointer(Desktop^.FirstThat(@EditorWindow));
end;

procedure InsertButtons(ADialog: PDialog);
var R   : TRect;
    W,H : integer;
    X   : integer;
    X1,X2: Sw_integer;
begin
  with ADialog^ do
  begin
    GetExtent(R);
    W:=R.B.X-R.A.X; H:=(R.B.Y-R.A.Y);
    R.Assign(0,0,W,H+3); ChangeBounds(R);
    X:=W div 2; X1:=X div 2+1; X2:=X+X1-1;
    R.Assign(X1-3,H,X1+7,H+2);
    Insert(New(PButton, Init(R, 'O~K~', cmOK, bfDefault)));
    R.Assign(X2-7,H,X2+3,H+2);
    Insert(New(PButton, Init(R, 'Cancel', cmCancel, bfNormal)));
    SelectNext(true);
  end;
end;

procedure InsertOK(ADialog: PDialog);
var BW: Sw_integer;
    R: TRect;
begin
  with ADialog^ do
  begin
    GetBounds(R); R.Grow(0,1); Inc(R.B.Y);
    ChangeBounds(R);
    BW:=10;
    R.A.Y:=R.B.Y-2; R.B.Y:=R.A.Y+2;
    R.A.X:=R.A.X+(R.B.X-R.A.X-BW) div 2; R.B.X:=R.A.X+BW;
    Insert(New(PButton, Init(R, 'O~K~', cmOK, bfDefault)));
    SelectNext(true);
  end;
end;


function GetEditorCurWord(Editor: PEditor): string;
var S: string;
    PS,PE: byte;
function Trim(S: string): string;
const TrimChars : set of char = [#0,#9,' ',#255];
begin
  while (length(S)>0) and (S[1] in TrimChars) do Delete(S,1,1);
  while (length(S)>0) and (S[length(S)] in TrimChars) do Delete(S,length(S),1);
  Trim:=S;
end;
const AlphaNum : set of char = ['A'..'Z','0'..'9','_'];
begin
  with Editor^ do
  begin
{$ifdef EDITORS}
    S:='';
{$else}
    S:=GetLineText(CurPos.Y);
    PS:=CurPos.X; while (PS>0) and (Upcase(S[PS]) in AlphaNum) do Dec(PS);
    PE:=CurPos.X; while (PE<length(S)) and (Upcase(S[PE+1]) in AlphaNum) do Inc(PE);
    S:=Trim(copy(S,PS+1,PE-PS));
{$endif}
  end;
  GetEditorCurWord:=S;
end;


{*****************************************************************************
                                   Tab
*****************************************************************************}

function NewTabItem(AView: PView; ANext: PTabItem): PTabItem;
var P: PTabItem;
begin
  New(P); FillChar(P^,SizeOf(P^),0);
  P^.Next:=ANext; P^.View:=AView;
  NewTabItem:=P;
end;

procedure DisposeTabItem(P: PTabItem);
begin
  if P<>nil then
  begin
    if P^.View<>nil then Dispose(P^.View, Done);
    Dispose(P);
  end;
end;

function NewTabDef(AName: string; ADefItem: PView; AItems: PTabItem; ANext: PTabDef): PTabDef;
var P: PTabDef;
    x: byte;
begin
  New(P);
  P^.Next:=ANext; P^.Name:=NewStr(AName); P^.Items:=AItems;
  x:=pos('~',AName);
  if (x<>0) and (x<length(AName)) then P^.ShortCut:=Upcase(AName[x+1])
                                  else P^.ShortCut:=#0;
  P^.DefItem:=ADefItem;
  NewTabDef:=P;
end;

procedure DisposeTabDef(P: PTabDef);
var PI,X: PTabItem;
begin
  DisposeStr(P^.Name);
  PI:=P^.Items;
  while PI<>nil do
    begin
      X:=PI^.Next;
      DisposeTabItem(PI);
      PI:=X;
    end;
  Dispose(P);
end;


{*****************************************************************************
                               Reserved Words
*****************************************************************************}

function GetReservedWordCount: integer;
var
  Count,I: integer;
begin
  Count:=0;
  for I:=ord(Low(TokenInfo)) to ord(High(TokenInfo)) do
   with TokenInfo[TToken(I)] do
     if (str<>'') and (str[1] in['A'..'Z']) then
       Inc(Count);
  GetReservedWordCount:=Count;
end;

function GetReservedWord(Index: integer): string;
var
  Count,Idx,I: integer;
  S: string;
begin
  Idx:=-1;
  Count:=-1;
  I:=ord(Low(TokenInfo));
  while (I<=ord(High(TokenInfo))) and (Idx=-1) do
   with TokenInfo[TToken(I)] do
    begin
      if (str<>'') and (str[1] in['A'..'Z']) then
        begin
          Inc(Count);
          if Count=Index then
           Idx:=I;
        end;
      Inc(I);
    end;
  if Idx=-1 then
    S:=''
  else
    S:=TokenInfo[TToken(Idx)].str;
  GetReservedWord:=S;
end;

procedure InitReservedWords;
var S,WordS: string;
    Idx,I: integer;
begin
  New(ReservedWords, Init(50,10));
  for I:=1 to GetReservedWordCount do
    begin
      WordS:=GetReservedWord(I-1); Idx:=length(WordS);
      while ReservedWords^.Count<Idx do
        ReservedWords^.Insert(NewStr(#0));
      S:=ReservedWords^.At(Idx-1)^;
      ReservedWords^.AtFree(Idx-1);
      ReservedWords^.AtInsert(Idx-1,NewStr(S+WordS+#0));
    end;
end;

procedure DoneReservedWords;
begin
  if assigned(ReservedWords) then
    dispose(ReservedWords,done);
end;

function IsFPReservedWord(S: string): boolean;
var _Is: boolean;
    Idx: integer;
    P: PString;
begin
  Idx:=length(S); _Is:=false;
  if (Idx>0) and (ReservedWords<>nil) and (ReservedWords^.Count>=Idx) then
    begin
      S:=UpcaseStr(S);
      P:=ReservedWords^.At(Idx-1);
      _Is:=Pos(#0+S+#0,P^)>0;
    end;
  IsFPReservedWord:=_Is;
end;


{*****************************************************************************
                               SearchWindow
*****************************************************************************}

function SearchWindowWithNo(No: integer): PWindow;
var P: PSourceWindow;
begin
  P:=Message(Desktop,evBroadcast,cmSearchWindow+No,nil);
  if pointer(P)=pointer(Desktop) then P:=nil;
  SearchWindowWithNo:=P;
end;

function SearchFreeWindowNo: integer;
var No: integer;
begin
  No:=1;
  while (No<10) and (SearchWindowWithNo(No)<>nil) do
    Inc(No);
  if No=10 then No:=0;
  SearchFreeWindowNo:=No;
end;


{*****************************************************************************
                              TCenterDialog
*****************************************************************************}

constructor TCenterDialog.Init(var Bounds: TRect; ATitle: TTitleStr);
begin
  inherited Init(Bounds,ATitle);
  Options:=Options or ofCentered;
end;


{*****************************************************************************
                              TIntegerLine
*****************************************************************************}

constructor TIntegerLine.Init(var Bounds: TRect; AMin, AMax: longint);
begin
  inherited Init(Bounds, Bounds.B.X-Bounds.A.X-1);
  Validator:=New(PRangeValidator, Init(AMin, AMax));
end;


{*****************************************************************************
                               SourceEditor
*****************************************************************************}

{$ifndef EDITORS}
function TSourceEditor.GetSpecSymbolCount(SpecClass: TSpecSymbolClass): integer;
var Count: integer;
begin
  case SpecClass of
    ssCommentPrefix   : Count:=3;
    ssCommentSingleLinePrefix   : Count:=1;
    ssCommentSuffix   : Count:=2;
    ssStringPrefix    : Count:=1;
    ssStringSuffix    : Count:=1;
    ssAsmPrefix       : Count:=1;
    ssAsmSuffix       : Count:=1;
    ssDirectivePrefix : Count:=1;
    ssDirectiveSuffix : Count:=1;
  end;
  GetSpecSymbolCount:=Count;
end;

function TSourceEditor.GetSpecSymbol(SpecClass: TSpecSymbolClass; Index: integer): string;
var S: string[20];
begin
  case SpecClass of
    ssCommentPrefix :
      case Index of
        0 : S:='{';
        1 : S:='(*';
        2 : S:='//';
      end;
    ssCommentSingleLinePrefix :
      case Index of
        0 : S:='//';
      end;
    ssCommentSuffix :
      case Index of
        0 : S:='}';
        1 : S:='*)';
      end;
    ssStringPrefix :
      S:='''';
    ssStringSuffix :
      S:='''';
    ssAsmPrefix :
      S:='asm';
    ssAsmSuffix :
      S:='end';
    ssDirectivePrefix :
      S:='{$';
    ssDirectiveSuffix :
      S:='}';
  end;
  GetSpecSymbol:=S;
end;

function TSourceEditor.IsReservedWord(const S: string): boolean;
begin
  IsReservedWord:=IsFPReservedWord(S);
end;
{$endif EDITORS}

procedure TSourceEditor.LocalMenu(P: TPoint);
var M: PMenu;
    MV: PAdvancedMenuPopUp;
    R: TRect;
    Re: word;
begin
  M:=GetLocalMenu;
  if M=nil then Exit;
  if LastLocalCmd<>0 then
     M^.Default:=SearchMenuItem(M,LastLocalCmd);
  Desktop^.GetExtent(R);
  MakeGlobal(P,R.A); {Desktop^.MakeLocal(R.A,R.A);}
  New(MV, Init(R, M));
  Re:=Application^.ExecView(MV);
  if M^.Default=nil then LastLocalCmd:=0
     else LastLocalCmd:=M^.Default^.Command;
  Dispose(MV, Done);
  if Re<>0 then
    Message(GetCommandTarget,evCommand,Re,@Self);
end;

function TSourceEditor.GetLocalMenu: PMenu;
var M: PMenu;
begin
  M:=NewMenu(
    NewItem('Cu~t~','Shift+Del',kbShiftDel,cmCut,hcCut,
    NewItem('~C~opy','Ctrl+Ins',kbCtrlIns,cmCopy,hcCopy,
    NewItem('~P~aste','Shift+Ins',kbShiftIns,cmPaste,hcPaste,
    NewItem('C~l~ear','Ctrl+Del',kbCtrlDel,cmClear,hcClear,
    NewLine(
    NewItem('Open ~f~ile at cursor','',kbNoKey,cmOpenAtCursor,hcOpenAtCursor,
    NewItem('~B~rowse symbol at cursor','',kbNoKey,cmBrowseAtCursor,hcBrowseAtCursor,
    NewItem('Topic ~s~earch','Ctrl+F1',kbCtrlF1,cmHelpTopicSearch,hcHelpTopicSearch,
    NewLine(
    NewItem('~O~ptions...','',kbNoKey,cmEditorOptions,hcEditorOptions,
    nil)))))))))));
  GetLocalMenu:=M;
end;

function TSourceEditor.GetCommandTarget: PView;
begin
  GetCommandTarget:=@Self;
end;

procedure TSourceEditor.HandleEvent(var Event: TEvent);
var DontClear: boolean;
    P: TPoint;
    S: string;
begin
  TranslateMouseClick(@Self,Event);
  case Event.What of
    evMouseDown :
      if MouseInView(Event.Where) and (Event.Buttons=mbRightButton) then
        begin
          MakeLocal(Event.Where,P); Inc(P.X); Inc(P.Y);
          LocalMenu(P);
          ClearEvent(Event);
        end;
    evKeyDown :
      begin
        DontClear:=false;
        case Event.KeyCode of
          kbAltF10 : Message(@Self,evCommand,cmLocalMenu,@Self);
        else DontClear:=true;
        end;
        if DontClear=false then ClearEvent(Event);
      end;
    evCommand :
      begin
        DontClear:=false;
        case Event.Command of
          cmLocalMenu :
            begin
              P:=CurPos; Inc(P.X); Inc(P.Y);
              LocalMenu(P);
            end;
          cmBrowseAtCursor:
            begin
              S:=LowerCaseStr(GetEditorCurWord(@Self));
              OpenOneSymbolBrowser(S);
            end;
          cmOpenAtCursor :
            begin
              S:=LowerCaseStr(GetEditorCurWord(@Self));
              OpenFileName:=S+'.pp'+ListSeparator+
                            S+'.pas'+ListSeparator+
                            S+'.inc';
              Message(Application,evCommand,cmOpen,nil);
            end;
          cmEditorOptions :
            Message(Application,evCommand,cmEditorOptions,@Self);
          cmHelp :
            Message(@Self,evCommand,cmHelpTopicSearch,@Self);
          cmHelpTopicSearch :
            HelpTopicSearch(@Self);
        else DontClear:=true;
        end;
        if not DontClear then ClearEvent(Event);
      end;
  end;
  inherited HandleEvent(Event);
end;

procedure TFPWindow.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evBroadcast :
      case Event.Command of
        cmUpdate :
          ReDraw;
        cmSearchWindow+1..cmSearchWindow+99 :
          if (Event.Command-cmSearchWindow=Number) then
              ClearEvent(Event);
      end;
  end;
  inherited HandleEvent(Event);
end;

function TIDEHelpWindow.GetPalette: PPalette;
const P: string[length(CIDEHelpDialog)] = CIDEHelpDialog;
begin
  GetPalette:=@P;
end;

constructor TSourceWindow.Init(var Bounds: TRect; AFileName: string);
var HSB,VSB: PScrollBar;
    R: TRect;
    LoadFile: boolean;
begin
  inherited Init(Bounds,AFileName,SearchFreeWindowNo);
  Options:=Options or ofTileAble;
  GetExtent(R); R.A.Y:=R.B.Y-1; R.Grow(-1,0); R.A.X:=14;
  New(HSB, Init(R)); HSB^.GrowMode:=gfGrowLoY+gfGrowHiX+gfGrowHiY; Insert(HSB);
  GetExtent(R); R.A.X:=R.B.X-1; R.Grow(0,-1);
  New(VSB, Init(R)); VSB^.GrowMode:=gfGrowLoX+gfGrowHiX+gfGrowHiY; Insert(VSB);
  GetExtent(R); R.A.X:=3; R.B.X:=14; R.A.Y:=R.B.Y-1;
  New(Indicator, Init(R));
  Indicator^.GrowMode:=gfGrowLoY+gfGrowHiY;
  Insert(Indicator);
  GetExtent(R); R.Grow(-1,-1);
  LoadFile:=AFileName<>'';
  if not LoadFile then
     begin SetTitle('noname'+IntToStrZ(NonameCount,2)+'.pas'); Inc(NonameCount); end;
  New(Editor, Init(R, HSB, VSB, Indicator,AFileName));
  Editor^.GrowMode:=gfGrowHiX+gfGrowHiY;
  if LoadFile then
    if Editor^.LoadFile=false then
       ErrorBox(#3'Error reading file.',nil);
  Insert(Editor);
  UpdateTitle;
end;

procedure TSourceWindow.UpdateTitle;
var Name: string;
begin
  if Editor^.FileName<>'' then
  begin Name:=SmartPath(Editor^.FileName); SetTitle(Name); end;
end;

procedure TSourceWindow.SetTitle(ATitle: string);
begin
  if Title<>nil then DisposeStr(Title);
  Title:=NewStr(ATitle);
  Frame^.DrawView;
end;

procedure TSourceWindow.HandleEvent(var Event: TEvent);
var DontClear: boolean;
begin
  case Event.What of
    evBroadcast :
      case Event.Command of
        cmUpdate :
          Update;
        cmUpdateTitle :
          UpdateTitle;
        cmSearchWindow :
          if @Self<>ClipboardWindow then
            ClearEvent(Event);
      end;
    evCommand :
      begin
        DontClear:=false;
        case Event.Command of
          cmSave :
            if Editor^.IsClipboard=false then
            Editor^.Save;
          cmSaveAs :
            if Editor^.IsClipboard=false then
            Editor^.SaveAs;
        else DontClear:=true;
        end;
        if DontClear=false then ClearEvent(Event);
      end;
  end;
  inherited HandleEvent(Event);
end;

procedure TSourceWindow.SetState(AState: Word; Enable: Boolean);
var OldState: word;
begin
  OldState:=State;
  inherited SetState(AState,Enable);
  if ((AState xor State) and sfActive)<>0 then
  UpdateCommands;
end;

procedure TSourceWindow.UpdateCommands;
var Active: boolean;
begin
  Active:=GetState(sfActive);
  if Editor^.IsClipboard=false then
  begin
    SetCmdState(SourceCmds+CompileCmds,Active);
    SetCmdState(EditorCmds,Active);
  end;
  if Active=false then
     SetCmdState(ToClipCmds+FromClipCmds+UndoCmds,false);
end;

procedure TSourceWindow.Update;
begin
  ReDraw;
end;

function TSourceWindow.GetPalette: PPalette;
const P: string[length(CSourceWindow)] = CSourceWindow;
begin
  GetPalette:=@P;
end;

destructor TSourceWindow.Done;
begin
  Message(Application,evBroadcast,cmSourceWndClosing,@Self);
  inherited Done;
  Message(Application,evBroadcast,cmUpdate,@Self);
end;

function TGDBSourceEditor.Valid(Command: Word): Boolean;
var OK: boolean;
begin
  OK:=TCodeEditor.Valid(Command);
  { do NOT ask for save !!
  if OK and ((Command=cmClose) or (Command=cmQuit)) then
     if IsClipboard=false then
    OK:=SaveAsk;  }
  Valid:=OK;
end;

procedure  TGDBSourceEditor.AddLine(const S: string);
begin
   if Silent or (IgnoreStringAtEnd and (S=LastCommand)) then exit;
   inherited AddLine(S);
   LimitsChanged;
end;

procedure  TGDBSourceEditor.AddErrorLine(const S: string);
begin
   if Silent then exit;
   inherited AddLine(S);
   { display like breakpoints in red }
   Lines^.At(GetLineCount-1)^.IsBreakpoint:=true;
   LimitsChanged;
end;

function TGDBSourceEditor.InsertLine: Sw_integer;
Var
  S : string;

begin
  if IsReadOnly then begin InsertLine:=-1; Exit; end;
  if CurPos.Y<GetLineCount then S:=GetLineText(CurPos.Y) else S:='';
  s:=Copy(S,1,CurPos.X);
  if assigned(Debugger) then
    if S<>'' then
      begin
        LastCommand:=S;
        { should be true only if we are at the end ! }
        IgnoreStringAtEnd:=(CurPos.Y=GetLineCount-1) and (CurPos.X=length(GetDisplayText(GetLineCount-1)));
        Debugger^.Command(S);
        IgnoreStringAtEnd:=false;
      end
    else if AutoRepeat then
      Debugger^.Command(LastCommand);
  InsertLine:=inherited InsertLine;
end;


constructor TGDBWindow.Init(var Bounds: TRect);
var HSB,VSB: PScrollBar;
    R: TRect;
begin
  inherited Init(Bounds,'GDB window',SearchFreeWindowNo);
  Options:=Options or ofTileAble;
  GetExtent(R); R.A.Y:=R.B.Y-1; R.Grow(-1,0); R.A.X:=14;
  New(HSB, Init(R)); HSB^.GrowMode:=gfGrowLoY+gfGrowHiX+gfGrowHiY; Insert(HSB);
  GetExtent(R); R.A.X:=R.B.X-1; R.Grow(0,-1);
  New(VSB, Init(R)); VSB^.GrowMode:=gfGrowLoX+gfGrowHiX+gfGrowHiY; Insert(VSB);
  GetExtent(R); R.A.X:=3; R.B.X:=14; R.A.Y:=R.B.Y-1;
  New(Indicator, Init(R));
  Indicator^.GrowMode:=gfGrowLoY+gfGrowHiY;
  Insert(Indicator);
  GetExtent(R); R.Grow(-1,-1);
  New(Editor, Init(R, HSB, VSB, nil, GDBOutputFile));
  Editor^.GrowMode:=gfGrowHiX+gfGrowHiY;
  if ExistsFile(GDBOutputFile) then
    begin
      if Editor^.LoadFile=false then
        ErrorBox(#3'Error reading file.',nil);
    end
  else
  { Empty files are buggy !! }
    Editor^.AddLine('');
  Insert(Editor);
  if assigned(Debugger) then
    Debugger^.Command('set width '+IntToStr(Size.X-1));
  Editor^.silent:=false;
  Editor^.AutoRepeat:=true;
end;

destructor TGDBWindow.Done;
begin
  if @Self=GDBWindow then
    GDBWindow:=nil;
  inherited Done;
end;

function TGDBWindow.GetPalette: PPalette;
const P: string[length(CSourceWindow)] = CSourceWindow;
begin
  GetPalette:=@P;
end;

procedure TGDBWindow.WriteOutputText(Buf : pchar);
begin
  {selected normal color ?}
  WriteText(Buf,false);
end;

procedure TGDBWindow.WriteErrorText(Buf : pchar);
begin
  {selected normal color ?}
  WriteText(Buf,true);
end;

procedure TGDBWindow.WriteString(Const S : string);
begin
  Editor^.AddLine(S);
end;

procedure TGDBWindow.WriteErrorString(Const S : string);
begin
  Editor^.AddErrorLine(S);
end;

procedure TGDBWindow.WriteText(Buf : pchar;IsError : boolean);
  var p,pe : pchar;
      s : string;
begin
  p:=buf;
  DeskTop^.Lock;
  While assigned(p) do
    begin
       pe:=strscan(p,#10);
       if pe<>nil then
         pe^:=#0;
       s:=strpas(p);
       If IsError then
         Editor^.AddErrorLine(S)
       else
         Editor^.AddLine(S);
       { restore for dispose }
       if pe<>nil then
         pe^:=#10;
       if pe=nil then
         p:=nil
       else
         begin
           p:=pe;
           inc(p);
         end;
    end;
  DeskTop^.Unlock;
  Editor^.Draw;
end;



constructor TClipboardWindow.Init;
var R: TRect;
    HSB,VSB: PScrollBar;
begin
  Desktop^.GetExtent(R);
  inherited Init(R, '');
  SetTitle('Clipboard');
  HelpCtx:=hcClipboardWindow;
  Number:=wnNoNumber;

  GetExtent(R); R.A.Y:=R.B.Y-1; R.Grow(-1,0); R.A.X:=14;
  New(HSB, Init(R)); HSB^.GrowMode:=gfGrowLoY+gfGrowHiX+gfGrowHiY; Insert(HSB);
  GetExtent(R); R.A.X:=R.B.X-1; R.Grow(0,-1);
  New(VSB, Init(R)); VSB^.GrowMode:=gfGrowLoX+gfGrowHiX+gfGrowHiY; Insert(VSB);
  GetExtent(R); R.A.X:=3; R.B.X:=14; R.A.Y:=R.B.Y-1;
  New(Indicator, Init(R));
  Indicator^.GrowMode:=gfGrowLoY+gfGrowHiY;
  Insert(Indicator);
  GetExtent(R); R.Grow(-1,-1);
  New(Editor, Init(R, HSB, VSB, Indicator, ''));
  Editor^.GrowMode:=gfGrowHiX+gfGrowHiY;
  Insert(Editor);

  Hide;

  Clipboard:=Editor;
end;

procedure TClipboardWindow.Close;
begin
  Hide;
end;

destructor TClipboardWindow.Done;
begin
  inherited Done;
  Clipboard:=nil;
  ClipboardWindow:=nil;
end;

function TAdvancedMenuBox.NewSubView(var Bounds: TRect; AMenu: PMenu;
  AParentMenu: PMenuView): PMenuView;
begin
  NewSubView := New(PAdvancedMenuBox, Init(Bounds, AMenu, AParentMenu));
end;

function TAdvancedMenuBox.Execute: word;
type
  MenuAction = (DoNothing, DoSelect, DoReturn);
var
  AutoSelect: Boolean;
  Action: MenuAction;
  Ch: Char;
  Result: Word;
  ItemShown, P: PMenuItem;
  Target: PMenuView;
  R: TRect;
  E: TEvent;
  MouseActive: Boolean;
function IsDisabled(Item: PMenuItem): boolean;
var Found: boolean;
begin
  Found:=Item^.Disabled or IsSeparator(Item);
  if (Found=false) and (IsSubMenu(Item)=false) then
     Found:=CommandEnabled(Item^.Command)=false;
  IsDisabled:=Found;
end;

procedure TrackMouse;
var
  Mouse: TPoint;
  R: TRect;
  OldC: PMenuItem;
begin
  MakeLocal(E.Where, Mouse);
  OldC:=Current;
  Current := Menu^.Items;
  while Current <> nil do
  begin
    GetItemRect(Current, R);
    if R.Contains(Mouse) then
    begin
      MouseActive := True;
      Break;
    end;
    Current := Current^.Next;
  end;
  if (Current<>nil) and IsDisabled(Current) then
  begin
     Current:={OldC}nil;
     MouseActive:=false;
  end;
end;

procedure TrackKey(FindNext: Boolean);

procedure NextItem;
begin
  Current := Current^.Next;
  if Current = nil then Current := Menu^.Items;
end;

procedure PrevItem;
var
  P: PMenuItem;
begin
  P := Current;
  if P = Menu^.Items then P := nil;
  repeat NextItem until Current^.Next = P;
end;

begin
  if Current <> nil then
    repeat
      if FindNext then NextItem else PrevItem;
    until (Current^.Name <> nil) and (IsDisabled(Current)=false);
end;

function MouseInOwner: Boolean;
var
  Mouse: TPoint;
  R: TRect;
begin
  MouseInOwner := False;
  if (ParentMenu <> nil) and (ParentMenu^.Size.Y = 1) then
  begin
    ParentMenu^.MakeLocal(E.Where, Mouse);
    ParentMenu^.GetItemRect(ParentMenu^.Current, R);
    MouseInOwner := R.Contains(Mouse);
  end;
end;

function MouseInMenus: Boolean;
var
  P: PMenuView;
begin
  P := ParentMenu;
  while (P <> nil) and (P^.MouseInView(E.Where)=false) do
        P := P^.ParentMenu;
  MouseInMenus := P <> nil;
end;

function TopMenu: PMenuView;
var
  P: PMenuView;
begin
  P := @Self;
  while P^.ParentMenu <> nil do P := P^.ParentMenu;
  TopMenu := P;
end;

begin
  AutoSelect := False; E.What:=evNothing;
  Result := 0;
  ItemShown := nil;
  Current := Menu^.Default;
  MouseActive := False;
  if UpdateMenu(Menu) then
 begin
  if Current<>nil then
    if Current^.Disabled then
       TrackKey(true);
  repeat
    Action := DoNothing;
    GetEvent(E);
    case E.What of
      evMouseDown:
        if MouseInView(E.Where) or MouseInOwner then
        begin
          TrackMouse;
          if Size.Y = 1 then AutoSelect := True;
        end else Action := DoReturn;
      evMouseUp:
        begin
          TrackMouse;
          if MouseInOwner then
            Current := Menu^.Default
          else
            if (Current <> nil) and (Current^.Name <> nil) then
              Action := DoSelect
            else
              if MouseActive or MouseInView(E.Where) then Action := DoReturn
              else
              begin
                Current := Menu^.Default;
                if Current = nil then Current := Menu^.Items;
                Action := DoNothing;
              end;
        end;
      evMouseMove:
        if E.Buttons <> 0 then
        begin
          TrackMouse;
          if not (MouseInView(E.Where) or MouseInOwner) and
            MouseInMenus then Action := DoReturn;
        end;
      evKeyDown:
        case CtrlToArrow(E.KeyCode) of
          kbUp, kbDown:
            if Size.Y <> 1 then
              TrackKey(CtrlToArrow(E.KeyCode) = kbDown) else
              if E.KeyCode = kbDown then AutoSelect := True;
          kbLeft, kbRight:
            if ParentMenu = nil then
              TrackKey(CtrlToArrow(E.KeyCode) = kbRight) else
              Action := DoReturn;
          kbHome, kbEnd:
            if Size.Y <> 1 then
            begin
              Current := Menu^.Items;
              if E.KeyCode = kbEnd then TrackKey(False);
            end;
          kbEnter:
            begin
              if Size.Y = 1 then AutoSelect := True;
              Action := DoSelect;
            end;
          kbEsc:
            begin
              Action := DoReturn;
              if (ParentMenu = nil) or (ParentMenu^.Size.Y <> 1) then
                ClearEvent(E);
            end;
        else
          Target := @Self;
          Ch := GetAltChar(E.KeyCode);
          if Ch = #0 then Ch := E.CharCode else Target := TopMenu;
          P := Target^.FindItem(Ch);
          if P = nil then
          begin
            P := TopMenu^.HotKey(E.KeyCode);
            if (P <> nil) and CommandEnabled(P^.Command) then
            begin
              Result := P^.Command;
              Action := DoReturn;
            end
          end else
            if Target = @Self then
            begin
              if Size.Y = 1 then AutoSelect := True;
              Action := DoSelect;
              Current := P;
            end else
              if (ParentMenu <> Target) or (ParentMenu^.Current <> P) then
                Action := DoReturn;
        end;
      evCommand:
        if E.Command = cmMenu then
        begin
          AutoSelect := False;
          if ParentMenu <> nil then Action := DoReturn;
        end else Action := DoReturn;
    end;
    if ItemShown <> Current then
    begin
      ItemShown := Current;
      DrawView;
    end;
    if (Action = DoSelect) or ((Action = DoNothing) and AutoSelect) then
      if Current <> nil then with Current^ do if Name <> nil then
        if Command = 0 then
        begin
          if E.What and (evMouseDown + evMouseMove) <> 0 then PutEvent(E);
          GetItemRect(Current, R);
          R.A.X := R.A.X + Origin.X;
          R.A.Y := R.B.Y + Origin.Y;
          R.B := Owner^.Size;
          if Size.Y = 1 then Dec(R.A.X);
          Target := TopMenu^.NewSubView(R, SubMenu, @Self);
          Result := Owner^.ExecView(Target);
          Dispose(Target, Done);
        end else if Action = DoSelect then Result := Command;
    if (Result <> 0) and CommandEnabled(Result) then
    begin
      Action := DoReturn;
      ClearEvent(E);
    end
    else
      Result := 0;
  until Action = DoReturn;
 end;
  if E.What <> evNothing then
    if (ParentMenu <> nil) or (E.What = evCommand) then PutEvent(E);
  if Current <> nil then
  begin
    Menu^.Default := Current;
    Current := nil;
    DrawView;
  end;
  Execute := Result;
end;

function TAdvancedMenuPopup.NewSubView(var Bounds: TRect; AMenu: PMenu;
  AParentMenu: PMenuView): PMenuView;
begin
  NewSubView := New(PAdvancedMenuBox, Init(Bounds, AMenu, AParentMenu));
end;

function TAdvancedMenuPopup.Execute: word;
type
  MenuAction = (DoNothing, DoSelect, DoReturn);
var
  AutoSelect: Boolean;
  Action: MenuAction;
  Ch: Char;
  Result: Word;
  ItemShown, P: PMenuItem;
  Target: PMenuView;
  R: TRect;
  E: TEvent;
  MouseActive: Boolean;
function IsDisabled(Item: PMenuItem): boolean;
var Found: boolean;
begin
  Found:=Item^.Disabled or IsSeparator(Item);
  if (Found=false) and (IsSubMenu(Item)=false) then
     Found:=CommandEnabled(Item^.Command)=false;
  IsDisabled:=Found;
end;

procedure TrackMouse;
var
  Mouse: TPoint;
  R: TRect;
  OldC: PMenuItem;
begin
  MakeLocal(E.Where, Mouse);
  OldC:=Current;
  Current := Menu^.Items;
  while Current <> nil do
  begin
    GetItemRect(Current, R);
    if R.Contains(Mouse) then
    begin
      MouseActive := True;
      Break;
    end;
    Current := Current^.Next;
  end;
  if (Current<>nil) and IsDisabled(Current) then
  begin
     Current:={OldC}nil;
     MouseActive:=false;
  end;
end;

procedure TrackKey(FindNext: Boolean);

procedure NextItem;
begin
  Current := Current^.Next;
  if Current = nil then Current := Menu^.Items;
end;

procedure PrevItem;
var
  P: PMenuItem;
begin
  P := Current;
  if P = Menu^.Items then P := nil;
  repeat NextItem until Current^.Next = P;
end;

begin
  if Current <> nil then
    repeat
      if FindNext then NextItem else PrevItem;
    until (Current^.Name <> nil) and (IsDisabled(Current)=false);
end;

function MouseInOwner: Boolean;
var
  Mouse: TPoint;
  R: TRect;
begin
  MouseInOwner := False;
  if (ParentMenu <> nil) and (ParentMenu^.Size.Y = 1) then
  begin
    ParentMenu^.MakeLocal(E.Where, Mouse);
    ParentMenu^.GetItemRect(ParentMenu^.Current, R);
    MouseInOwner := R.Contains(Mouse);
  end;
end;

function MouseInMenus: Boolean;
var
  P: PMenuView;
begin
  P := ParentMenu;
  while (P <> nil) and (P^.MouseInView(E.Where)=false) do
        P := P^.ParentMenu;
  MouseInMenus := P <> nil;
end;

function TopMenu: PMenuView;
var
  P: PMenuView;
begin
  P := @Self;
  while P^.ParentMenu <> nil do P := P^.ParentMenu;
  TopMenu := P;
end;

begin
  AutoSelect := False; E.What:=evNothing;
  Result := 0;
  ItemShown := nil;
  Current := Menu^.Default;
  MouseActive := False;
  if UpdateMenu(Menu) then
 begin
  if Current<>nil then
    if Current^.Disabled then
       TrackKey(true);
  repeat
    Action := DoNothing;
    GetEvent(E);
    case E.What of
      evMouseDown:
        if MouseInView(E.Where) or MouseInOwner then
        begin
          TrackMouse;
          if Size.Y = 1 then AutoSelect := True;
        end else Action := DoReturn;
      evMouseUp:
        begin
          TrackMouse;
          if MouseInOwner then
            Current := Menu^.Default
          else
            if (Current <> nil) and (Current^.Name <> nil) then
              Action := DoSelect
            else
              if MouseActive or MouseInView(E.Where) then Action := DoReturn
              else
              begin
                Current := Menu^.Default;
                if Current = nil then Current := Menu^.Items;
                Action := DoNothing;
              end;
        end;
      evMouseMove:
        if E.Buttons <> 0 then
        begin
          TrackMouse;
          if not (MouseInView(E.Where) or MouseInOwner) and
            MouseInMenus then Action := DoReturn;
        end;
      evKeyDown:
        case CtrlToArrow(E.KeyCode) of
          kbUp, kbDown:
            if Size.Y <> 1 then
              TrackKey(CtrlToArrow(E.KeyCode) = kbDown) else
              if E.KeyCode = kbDown then AutoSelect := True;
          kbLeft, kbRight:
            if ParentMenu = nil then
              TrackKey(CtrlToArrow(E.KeyCode) = kbRight) else
              Action := DoReturn;
          kbHome, kbEnd:
            if Size.Y <> 1 then
            begin
              Current := Menu^.Items;
              if E.KeyCode = kbEnd then TrackKey(False);
            end;
          kbEnter:
            begin
              if Size.Y = 1 then AutoSelect := True;
              Action := DoSelect;
            end;
          kbEsc:
            begin
              Action := DoReturn;
              if (ParentMenu = nil) or (ParentMenu^.Size.Y <> 1) then
                ClearEvent(E);
            end;
        else
          Target := @Self;
          Ch := GetAltChar(E.KeyCode);
          if Ch = #0 then Ch := E.CharCode else Target := TopMenu;
          P := Target^.FindItem(Ch);
          if P = nil then
          begin
            P := TopMenu^.HotKey(E.KeyCode);
            if (P <> nil) and CommandEnabled(P^.Command) then
            begin
              Result := P^.Command;
              Action := DoReturn;
            end
          end else
            if Target = @Self then
            begin
              if Size.Y = 1 then AutoSelect := True;
              Action := DoSelect;
              Current := P;
            end else
              if (ParentMenu <> Target) or (ParentMenu^.Current <> P) then
                Action := DoReturn;
        end;
      evCommand:
        if E.Command = cmMenu then
        begin
          AutoSelect := False;
          if ParentMenu <> nil then Action := DoReturn;
        end else Action := DoReturn;
    end;
    if ItemShown <> Current then
    begin
      ItemShown := Current;
      DrawView;
    end;
    if (Action = DoSelect) or ((Action = DoNothing) and AutoSelect) then
      if Current <> nil then with Current^ do if Name <> nil then
        if Command = 0 then
        begin
          if E.What and (evMouseDown + evMouseMove) <> 0 then PutEvent(E);
          GetItemRect(Current, R);
          R.A.X := R.A.X + Origin.X;
          R.A.Y := R.B.Y + Origin.Y;
          R.B := Owner^.Size;
          if Size.Y = 1 then Dec(R.A.X);
          Target := TopMenu^.NewSubView(R, SubMenu, @Self);
          Result := Owner^.ExecView(Target);
          Dispose(Target, Done);
        end else if Action = DoSelect then Result := Command;
    if (Result <> 0) and CommandEnabled(Result) then
    begin
      Action := DoReturn;
      ClearEvent(E);
    end
    else
      Result := 0;
  until Action = DoReturn;
 end;
  if E.What <> evNothing then
    if (ParentMenu <> nil) or (E.What = evCommand) then PutEvent(E);
  if Current <> nil then
  begin
    Menu^.Default := Current;
    Current := nil;
    DrawView;
  end;
  Execute := Result;
end;

constructor TAdvancedMenuBar.Init(var Bounds: TRect; AMenu: PMenu);
begin
  inherited Init(Bounds, AMenu);
  EventMask:=EventMask or evBroadcast;
end;

function TAdvancedMenuBar.NewSubView(var Bounds: TRect; AMenu: PMenu;
  AParentMenu: PMenuView): PMenuView;
begin
  NewSubView := New(PAdvancedMenuBox, Init(Bounds, AMenu, AParentMenu));
end;

procedure TAdvancedMenuBar.Update;
begin
  UpdateMenu(Menu);
  DrawView;
end;

procedure TAdvancedMenuBar.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evBroadcast :
      case Event.Command of
        cmUpdate   : Update;
      end;
  end;
  inherited HandleEvent(Event);
end;

function TAdvancedMenuBar.Execute: word;
type
  MenuAction = (DoNothing, DoSelect, DoReturn);
var
  AutoSelect: Boolean;
  Action: MenuAction;
  Ch: Char;
  Result: Word;
  ItemShown, P: PMenuItem;
  Target: PMenuView;
  R: TRect;
  E: TEvent;
  MouseActive: Boolean;
function IsDisabled(Item: PMenuItem): boolean;
var Dis : boolean;
begin
  Dis:=Item^.Disabled or IsSeparator(Item);
  if (Dis=false) and (IsSubMenu(Item)=false) then
     Dis:=CommandEnabled(Item^.Command)=false;
  IsDisabled:=Dis;
end;

procedure TrackMouse;
var
  Mouse: TPoint;
  R: TRect;
  OldC: PMenuItem;
begin
  MakeLocal(E.Where, Mouse);
  OldC:=Current;
  Current := Menu^.Items;
  while Current <> nil do
  begin
    GetItemRect(Current, R);
    if R.Contains(Mouse) then
    begin
      MouseActive := True;
      Break;
    end;
    Current := Current^.Next;
  end;
  if (Current<>nil) and IsDisabled(Current) then
    Current:=nil;
end;

procedure TrackKey(FindNext: Boolean);

procedure NextItem;
begin
  Current := Current^.Next;
  if Current = nil then Current := Menu^.Items;
end;

procedure PrevItem;
var
  P: PMenuItem;
begin
  P := Current;
  if P = Menu^.Items then P := nil;
  repeat NextItem until Current^.Next = P;
end;

begin
  if Current <> nil then
    repeat
      if FindNext then NextItem else PrevItem;
    until (Current^.Name <> nil) and (IsDisabled(Current)=false);
end;

function MouseInOwner: Boolean;
var
  Mouse: TPoint;
  R: TRect;
begin
  MouseInOwner := False;
  if (ParentMenu <> nil) and (ParentMenu^.Size.Y = 1) then
  begin
    ParentMenu^.MakeLocal(E.Where, Mouse);
    ParentMenu^.GetItemRect(ParentMenu^.Current, R);
    MouseInOwner := R.Contains(Mouse);
  end;
end;

function MouseInMenus: Boolean;
var
  P: PMenuView;
begin
  P := ParentMenu;
  while (P <> nil) and not P^.MouseInView(E.Where) do P := P^.ParentMenu;
  MouseInMenus := P <> nil;
end;

function TopMenu: PMenuView;
var
  P: PMenuView;
begin
  P := @Self;
  while P^.ParentMenu <> nil do P := P^.ParentMenu;
  TopMenu := P;
end;

begin
  AutoSelect := False; E.What:=evNothing;
  Result := 0;
  ItemShown := nil;
  Current := Menu^.Default;
  MouseActive := False;
  if UpdateMenu(Menu) then
 begin
  if Current<>nil then
    if Current^.Disabled then
       TrackKey(true);
  repeat
    Action := DoNothing;
    GetEvent(E);
    case E.What of
      evMouseDown:
        if MouseInView(E.Where) or MouseInOwner then
        begin
          TrackMouse;
          if Size.Y = 1 then AutoSelect := True;
        end else Action := DoReturn;
      evMouseUp:
        begin
          TrackMouse;
          if MouseInOwner then
            Current := Menu^.Default
          else
            if (Current <> nil) and (Current^.Name <> nil) then
              Action := DoSelect
            else
              if MouseActive or MouseInView(E.Where) then Action := DoReturn
              else
              begin
                Current := Menu^.Default;
                if Current = nil then Current := Menu^.Items;
                Action := DoNothing;
              end;
        end;
      evMouseMove:
        if E.Buttons <> 0 then
        begin
          TrackMouse;
          if not (MouseInView(E.Where) or MouseInOwner) and
            MouseInMenus then Action := DoReturn;
        end;
      evKeyDown:
        case CtrlToArrow(E.KeyCode) of
          kbUp, kbDown:
            if Size.Y <> 1 then
              TrackKey(CtrlToArrow(E.KeyCode) = kbDown) else
              if E.KeyCode = kbDown then AutoSelect := True;
          kbLeft, kbRight:
            if ParentMenu = nil then
              TrackKey(CtrlToArrow(E.KeyCode) = kbRight) else
              Action := DoReturn;
          kbHome, kbEnd:
            if Size.Y <> 1 then
            begin
              Current := Menu^.Items;
              if E.KeyCode = kbEnd then TrackKey(False);
            end;
          kbEnter:
            begin
              if Size.Y = 1 then AutoSelect := True;
              Action := DoSelect;
            end;
          kbEsc:
            begin
              Action := DoReturn;
              if (ParentMenu = nil) or (ParentMenu^.Size.Y <> 1) then
                ClearEvent(E);
            end;
        else
          Target := @Self;
          Ch := GetAltChar(E.KeyCode);
          if Ch = #0 then Ch := E.CharCode else Target := TopMenu;
          P := Target^.FindItem(Ch);
          if P = nil then
          begin
            P := TopMenu^.HotKey(E.KeyCode);
            if (P <> nil) and CommandEnabled(P^.Command) then
            begin
              Result := P^.Command;
              Action := DoReturn;
            end
          end else
            if Target = @Self then
            begin
              if Size.Y = 1 then AutoSelect := True;
              Action := DoSelect;
              Current := P;
            end else
              if (ParentMenu <> Target) or (ParentMenu^.Current <> P) then
                Action := DoReturn;
        end;
      evCommand:
        if E.Command = cmMenu then
        begin
          AutoSelect := False;
          if ParentMenu <> nil then Action := DoReturn;
        end else Action := DoReturn;
    end;
    if ItemShown <> Current then
    begin
      ItemShown := Current;
      DrawView;
    end;
    if (Action = DoSelect) or ((Action = DoNothing) and AutoSelect) then
      if Current <> nil then with Current^ do if Name <> nil then
        if Command = 0 then
        begin
          if E.What and (evMouseDown + evMouseMove) <> 0 then PutEvent(E);
          GetItemRect(Current, R);
          R.A.X := R.A.X + Origin.X;
          R.A.Y := R.B.Y + Origin.Y;
          R.B := Owner^.Size;
          if Size.Y = 1 then Dec(R.A.X);
          Target := TopMenu^.NewSubView(R, SubMenu, @Self);
          Result := Owner^.ExecView(Target);
          Dispose(Target, Done);
        end else if Action = DoSelect then Result := Command;
    if (Result <> 0) and CommandEnabled(Result) then
    begin
      Action := DoReturn;
      ClearEvent(E);
    end
    else
      Result := 0;
  until Action = DoReturn;
 end;
  if E.What <> evNothing then
    if (ParentMenu <> nil) or (E.What = evCommand) then PutEvent(E);
  if Current <> nil then
  begin
    Menu^.Default := Current;
    Current := nil;
    DrawView;
  end;
  Execute := Result;
end;

procedure ErrorBox(const S: string; Params: pointer);
begin
  MessageBox(S,Params,mfError+mfInsertInApp+mfOKButton);
end;

procedure WarningBox(const S: string; Params: pointer);
begin
  MessageBox(S,Params,mfWarning+mfInsertInApp+mfOKButton);
end;

procedure InformationBox(const S: string; Params: pointer);
begin
  MessageBox(S,Params,mfInformation+mfInsertInApp+mfOKButton);
end;

function ConfirmBox(const S: string; Params: pointer; CanCancel: boolean): word;
begin
  ConfirmBox:=MessageBox(S,Params,mfConfirmation+mfInsertInApp+mfYesButton+mfNoButton+integer(CanCancel)*mfCancelButton);
end;

function IsSeparator(P: PMenuItem): boolean;
begin
  IsSeparator:=(P<>nil) and (P^.Name=nil) and (P^.HelpCtx=hcNoContext);
end;

function IsSubMenu(P: PMenuItem): boolean;
begin
  IsSubMenu:=(P<>nil) and (P^.Name<>nil) and (P^.Command=0) and (P^.SubMenu<>nil);
end;

function SearchMenuItem(Menu: PMenu; Cmd: word): PMenuItem;
var P,I: PMenuItem;
begin
  I:=nil;
  if Menu=nil then P:=nil else P:=Menu^.Items;
  while (P<>nil) and (I=nil) do
  begin
    if IsSubMenu(P) then
       I:=SearchMenuItem(P^.SubMenu,Cmd);
    if I=nil then
    if P^.Command=Cmd then I:=P else
    P:=P^.Next;
  end;
  SearchMenuItem:=I;
end;

procedure SetMenuItemParam(Menu: PMenuItem; Param: string);
begin
  if Menu=nil then Exit;
  if Menu^.Param<>nil then DisposeStr(Menu^.Param);
  Menu^.Param:=NewStr(Param);
end;

function UpdateMenu(M: PMenu): boolean;
var P: PMenuItem;
    IsEnabled: boolean;
begin
  if M=nil then begin UpdateMenu:=false; Exit; end;
  P:=M^.Items; IsEnabled:=false;
  while (P<>nil) do
  begin
    if IsSubMenu(P) then
       P^.Disabled:=not UpdateMenu(P^.SubMenu);
    if (IsSeparator(P)=false) and (P^.Disabled=false) and (Application^.CommandEnabled(P^.Command)=true) then
       IsEnabled:=true;
    P:=P^.Next;
  end;
  UpdateMenu:=IsEnabled;
end;

function SearchSubMenu(M: PMenu; Index: integer): PMenuItem;
var P,C: PMenuItem;
    Count: integer;
begin
  P:=nil; Count:=-1;
  if M<>nil then C:=M^.Items else C:=nil;
  while (C<>nil) and (P=nil) do
  begin
    if IsSubMenu(C) then
     begin
       Inc(Count);
       if Count=Index then P:=C;
     end;
    C:=C^.Next;
  end;
  SearchSubMenu:=P;
end;

procedure AppendMenuItem(M: PMenu; I: PMenuItem);
var P: PMenuItem;
begin
  if (M=nil) or (I=nil) then Exit;
  I^.Next:=nil;
  if M^.Items=nil then M^.Items:=I else
  begin
    P:=M^.Items;
    while (P^.Next<>nil) do P:=P^.Next;
    P^.Next:=I;
  end;
end;

procedure DisposeMenuItem(P: PMenuItem);
begin
  if P<>nil then
  begin
    if IsSubMenu(P) then DisposeMenu(P^.SubMenu) else
      if IsSeparator(P)=false then
       if P^.Param<>nil then DisposeStr(P^.Param);
    if P^.Name<>nil then DisposeStr(P^.Name);
    Dispose(P);
  end;
end;

procedure RemoveMenuItem(Menu: PMenu; I: PMenuItem);
var P,PrevP: PMenuItem;
begin
  if (Menu=nil) or (I=nil) then Exit;
  P:=Menu^.Items; PrevP:=nil;
  while (P<>nil) do
  begin
    if P=I then
      begin
        if Menu^.Items<>I then PrevP^.Next:=P^.Next
                          else Menu^.Items:=P^.Next;
        DisposeMenuItem(P);
        Break;
      end;
    PrevP:=P; P:=P^.Next;
  end;
end;

function GetMenuItemBefore(Menu: PMenu; BeforeOf: PMenuItem): PMenuItem;
var P,C: PMenuItem;
begin
  P:=nil;
  if Menu<>nil then C:=Menu^.Items else C:=nil;
  while (C<>nil) do
    begin
      if C^.Next=BeforeOf then begin P:=C; Break; end;
      C:=C^.Next;
    end;
  GetMenuItemBefore:=P;
end;

procedure TAdvancedStaticText.SetText(S: string);
begin
  if Text<>nil then DisposeStr(Text);
  Text:=NewStr(S);
  DrawView;
end;

procedure TAdvancedListBox.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evMouseDown :
      if MouseInView(Event.Where) and (Event.Double) then
      begin
        inherited HandleEvent(Event);
        if Range>Focused then SelectItem(Focused);
      end;
    evBroadcast :
      case Event.Command of
        cmListItemSelected :
          Message(Owner,evBroadcast,cmDefault,nil);
      end;
  end;
  inherited HandleEvent(Event);
end;

constructor TColorStaticText.Init(var Bounds: TRect; AText: String; AColor: word);
begin
  inherited Init(Bounds,AText);
  Color:=AColor;
end;

procedure TColorStaticText.Draw;
var
  C: word;
  Center: Boolean;
  I, J, L, P, Y: Integer;
  B: TDrawBuffer;
  S: String;
  T: string;
  CurS: string;
  TildeCount,Po: integer;
  TempS: string;
begin
  if Size.X=0 then Exit;
  if DontWrap=false then
 begin
  C:=Color;
  GetText(S);
  L := Length(S);
  P := 1;
  Y := 0;
  Center := False;
  while Y < Size.Y do
  begin
    MoveChar(B, ' ', Lo(C), Size.X);
    if P <= L then
    begin
      if S[P] = #3 then
      begin
        Center := True;
        Inc(P);
      end;
      I := P;
      repeat
        J := P;
        while (P <= L) and (S[P] = ' ') do Inc(P);
        while (P <= L) and (S[P] <> ' ') and (S[P] <> #13) do Inc(P);
      until (P > L) or (P >= I + Size.X) or (S[P] = #13);
      TildeCount:=0; TempS:=copy(S,I,P-I);
      repeat
        Po:=Pos('~',TempS);
        if Po>0 then begin Inc(TildeCount); Delete(TempS,1,Po); end;
      until Po=0;
      if P > I + Size.X + TildeCount then
        if J > I then P := J else P := I + Size.X;
      T:=copy(S,I,P-I);
      if Center then J := (Size.X - {P + I}CStrLen(T)) div 2 else J := 0;
      MoveCStr(B[J],T,C);
      while (P <= L) and (S[P] = ' ') do Inc(P);
      if (P <= L) and (S[P] = #13) then
      begin
        Center := False;
        Inc(P);
        if (P <= L) and (S[P] = #10) then Inc(P);
      end;
    end;
    WriteLine(0, Y, Size.X, 1, B);
    Inc(Y);
  end;
 end { Wrap=false } else
 begin
  C := Color;
  GetText(S);
  I:=1;
  for Y:=0 to Size.Y-1 do
  begin
    MoveChar(B, ' ', Lo(C), Size.X);
    CurS:='';
    if S<>'' then
    begin
    P:=Pos(#13,S);
    if P=0 then P:=length(S)+1;
    CurS:=copy(S,1,P-1);
    CurS:=copy(CurS,Delta.X+1,255);
    CurS:=copy(CurS,1,MaxViewWidth);
    Delete(S,1,P);
    end;
    if CurS<>'' then MoveCStr(B,CurS,C);
    WriteLine(0,Y,Size.X,1,B);
  end;
 end;
end;

function TUnsortedStringCollection.At(Index: Integer): PString;
begin
  At:=inherited At(Index);
end;

procedure TUnsortedStringCollection.FreeItem(Item: Pointer);
begin
  if Item<>nil then DisposeStr(Item);
end;

constructor THSListBox.Init(var Bounds: TRect; ANumCols: Word; AHScrollBar, AVScrollBar: PScrollBar);
begin
  inherited Init(Bounds,ANumCols,AVScrollBar);
  HScrollBar:=AHScrollBar;
end;

constructor TDlgWindow.Init(var Bounds: TRect; ATitle: TTitleStr; ANumber: Integer);
begin
  inherited Init(Bounds,ATitle);
  Number:=ANumber;
  Flags:=Flags or (wfMove + wfGrow + wfClose + wfZoom);
end;

procedure TLocalMenuListBox.LocalMenu(P: TPoint);
var M: PMenu;
    MV: PAdvancedMenuPopUp;
    R: TRect;
    Re: word;
begin
  M:=GetLocalMenu;
  if M=nil then Exit;
  if LastLocalCmd<>0 then
     M^.Default:=SearchMenuItem(M,LastLocalCmd);
  Desktop^.GetExtent(R);
  MakeGlobal(P,R.A); {Desktop^.MakeLocal(R.A,R.A);}
  New(MV, Init(R, M));
  Re:=Application^.ExecView(MV);
  if M^.Default=nil then LastLocalCmd:=0
     else LastLocalCmd:=M^.Default^.Command;
  Dispose(MV, Done);
  if Re<>0 then
    Message(GetCommandTarget,evCommand,Re,@Self);
end;

function TLocalMenuListBox.GetLocalMenu: PMenu;
begin
  GetLocalMenu:=nil;
  Abstract;
end;

function TLocalMenuListBox.GetCommandTarget: PView;
begin
  GetCommandTarget:=@Self;
end;

procedure TLocalMenuListBox.HandleEvent(var Event: TEvent);
var DontClear: boolean;
    P: TPoint;
begin
  case Event.What of
    evMouseDown :
      if MouseInView(Event.Where) and (Event.Buttons=mbRightButton) then
        begin
          MakeLocal(Event.Where,P); Inc(P.X); Inc(P.Y);
          LocalMenu(P);
          ClearEvent(Event);
        end;
    evKeyDown :
      begin
        DontClear:=false;
        case Event.KeyCode of
          kbAltF10 : Message(@Self,evCommand,cmLocalMenu,@Self);
        else DontClear:=true;
        end;
        if DontClear=false then ClearEvent(Event);
      end;
    evCommand :
      begin
        DontClear:=false;
        case Event.Command of
          cmLocalMenu :
            begin
              P:=Cursor; Inc(P.X); Inc(P.Y);
              LocalMenu(P);
            end;
        else DontClear:=true;
        end;
        if not DontClear then ClearEvent(Event);
      end;
  end;
  inherited HandleEvent(Event);
end;


constructor TMessageListBox.Init(var Bounds: TRect; AHScrollBar, AVScrollBar: PScrollBar);
begin
  inherited Init(Bounds,1,AHScrollBar, AVScrollBar);
  NoSelection:=true;
end;

function TMessageListBox.GetLocalMenu: PMenu;
var M: PMenu;
begin
  if (Owner<>nil) and (Owner^.GetState(sfModal)) then M:=nil else
  M:=NewMenu(
    NewItem('~C~lear','',kbNoKey,cmMsgClear,hcMsgClear,
    NewLine(
    NewItem('~G~oto source','',kbNoKey,cmMsgGotoSource,hcMsgGotoSource,
    NewItem('~T~rack source','',kbNoKey,cmMsgTrackSource,hcMsgTrackSource,
    nil)))));
  GetLocalMenu:=M;
end;

procedure TMessageListBox.HandleEvent(var Event: TEvent);
var DontClear: boolean;
begin
  case Event.What of
    evKeyDown :
      begin
        DontClear:=false;
        case Event.KeyCode of
          kbEnter :
            if Owner<>pointer(SD) then
              Message(@Self,evCommand,cmMsgGotoSource,nil);
        else DontClear:=true;
        end;
        if DontClear=false then ClearEvent(Event);
      end;
    evBroadcast :
      case Event.Command of
        cmListItemSelected :
          if Event.InfoPtr=@Self then
            Message(@Self,evCommand,cmMsgTrackSource,nil);
      end;
    evCommand :
      begin
        DontClear:=false;
        case Event.Command of
          cmMsgGotoSource :
            if Range>0 then
            GotoSource;
          cmMsgTrackSource :
            if Range>0 then
            TrackSource;
          cmMsgClear :
            Clear;
        else DontClear:=true;
        end;
        if DontClear=false then ClearEvent(Event);
      end;
  end;
  inherited HandleEvent(Event);
end;

procedure TMessageListBox.AddItem(P: PMessageItem);
var W: integer;
begin
  if List=nil then New(List, Init(500,500));
  W:=length(P^.GetText(255));
  if W>MaxWidth then
  begin
    MaxWidth:=W;
    if HScrollBar<>nil then
       HScrollBar^.SetRange(0,MaxWidth);
  end;
  List^.Insert(P);
  SetRange(List^.Count);
  if Focused=List^.Count-1-1 then
     FocusItem(List^.Count-1);
  DrawView;
end;

function TMessageListBox.GetText(Item: Integer; MaxLen: Integer): String;
var P: PMessageItem;
    S: string;
begin
  P:=List^.At(Item);
  S:=P^.GetText(MaxLen);
  GetText:=copy(S,1,MaxLen);
end;

procedure TMessageListBox.Clear;
begin
  if List<>nil then Dispose(List, Done); List:=nil; MaxWidth:=0;
  SetRange(0); DrawView;
end;

procedure TMessageListBox.TrackSource;
var W: PSourceWindow;
    P: PMessageItem;
    R: TRect;
begin
  if Range=0 then Exit;
  P:=List^.At(Focused);
  if P^.ID=0 then Exit;
  Desktop^.Lock;
  GetNextEditorBounds(R);
  if Assigned(Owner) and (Owner=pointer(ProgramInfoWindow)) then
    R.B.Y:=Owner^.Origin.Y;
  W:=EditorWindowFile(P^.GetModuleName);
  if assigned(W) then
    begin
      W^.GetExtent(R);
      if Assigned(Owner) and (Owner=pointer(ProgramInfoWindow)) then
        R.B.Y:=Owner^.Origin.Y;
      W^.ChangeBounds(R);
      W^.Editor^.SetCurPtr(P^.Col-1,P^.ID-1);
    end
  else
    W:=TryToOpenFile(@R,P^.GetModuleName,P^.Col-1,P^.ID-1);
  if W<>nil then
    begin
      W^.Select;
      W^.Editor^.SetHighlightRow(P^.ID-1);
    end;
  if Assigned(Owner) then
    Owner^.Select;
  Desktop^.UnLock;
end;

procedure TMessageListBox.GotoSource;
var W: PSourceWindow;
    P: PMessageItem;
begin
  if Range=0 then Exit;
  P:=List^.At(Focused);
  if P^.ID=0 then Exit;
  Desktop^.Lock;
  W:=TryToOpenFile(nil,P^.GetModuleName,P^.Col-1,P^.ID-1);
  Message(Owner,evCommand,cmClose,nil);
  Desktop^.UnLock;
end;

procedure TMessageListBox.Draw;
var
  I, J, Item: Integer;
  NormalColor, SelectedColor, FocusedColor, Color: Word;
  ColWidth, CurCol, Indent: Integer;
  B: TDrawBuffer;
  Text: String;
  SCOff: Byte;
  TC: byte;
procedure MT(var C: word); begin if TC<>0 then C:=(C and $ff0f) or (TC and $f0); end;
begin
  if (Owner<>nil) then TC:=ord(Owner^.GetColor(6)) else TC:=0;
  if State and (sfSelected + sfActive) = (sfSelected + sfActive) then
  begin
    NormalColor := GetColor(1);
    FocusedColor := GetColor(3);
    SelectedColor := GetColor(4);
  end else
  begin
    NormalColor := GetColor(2);
    SelectedColor := GetColor(4);
  end;
  if Transparent then
    begin MT(NormalColor); MT(SelectedColor); end;
  if NoSelection then
     SelectedColor:=NormalColor;
  if HScrollBar <> nil then Indent := HScrollBar^.Value
  else Indent := 0;
  ColWidth := Size.X div NumCols + 1;
  for I := 0 to Size.Y - 1 do
  begin
    for J := 0 to NumCols-1 do
    begin
      Item := J*Size.Y + I + TopItem;
      CurCol := J*ColWidth;
      if (State and (sfSelected + sfActive) = (sfSelected + sfActive)) and
        (Focused = Item) and (Range > 0) then
      begin
        Color := FocusedColor;
        SetCursor(CurCol+1,I);
        SCOff := 0;
      end
      else if (Item < Range) and IsSelected(Item) then
      begin
        Color := SelectedColor;
        SCOff := 2;
      end
      else
      begin
        Color := NormalColor;
        SCOff := 4;
      end;
      MoveChar(B[CurCol], ' ', Color, ColWidth);
      if Item < Range then
      begin
        Text := GetText(Item, ColWidth + Indent);
        Text := Copy(Text,Indent,ColWidth);
        MoveStr(B[CurCol+1], Text, Color);
        if ShowMarkers then
        begin
          WordRec(B[CurCol]).Lo := Byte(SpecialChars[SCOff]);
          WordRec(B[CurCol+ColWidth-2]).Lo := Byte(SpecialChars[SCOff+1]);
        end;
      end;
      MoveChar(B[CurCol+ColWidth-1], #179, GetColor(5), 1);
    end;
    WriteLine(0, I, Size.X, 1, B);
  end;
end;

destructor TMessageListBox.Done;
begin
  inherited Done;
  if List<>nil then Dispose(List, Done);
end;

constructor TMessageItem.Init(AClass: longint; AText, AModule: string; AID,ACol: longint);
begin
  inherited Init;
  TClass:=AClass;
  Text:=NewStr(AText);
  Module:=NewStr(AModule);
  ID:=AID;
  Col:=ACol;
end;

function TMessageItem.GetText(MaxLen: integer): string;
var S: string;
begin
  if Text=nil then S:='' else S:=Text^;
  if length(S)>MaxLen then S:=copy(S,1,MaxLen-2)+'..';
  GetText:=S;
end;

procedure TMessageItem.Selected;
begin
end;

function TMessageItem.GetModuleName: string;
begin
  GetModuleName:=GetStr(Module);
end;

destructor TMessageItem.Done;
begin
  inherited Done;
  if Text<>nil then DisposeStr(Text);
  if Module<>nil then DisposeStr(Module);
end;

function TCompilerMessage.GetText(MaxLen: Integer): String;
var ClassS: string[20];
    S: string;
begin
  if TClass=
    V_Fatal       then ClassS:='Fatal'       else if TClass =
    V_Error       then ClassS:='Error'       else if TClass =
    V_Normal      then ClassS:=''            else if TClass =
    V_Warning     then ClassS:='Warning'     else if TClass =
    V_Note        then ClassS:='Note'        else if TClass =
    V_Hint        then ClassS:='Hint'        else if TClass =
    V_Macro       then ClassS:='Macro'       else if TClass =
    V_Procedure   then ClassS:='Procedure'   else if TClass =
    V_Conditional then ClassS:='Conditional' else if TClass =
    V_Info      then ClassS:='Info'     else if TClass =
    V_Status      then ClassS:='Status'      else if TClass =
    V_Used      then ClassS:='Used'     else if TClass =
    V_Tried       then ClassS:='Tried'       else if TClass =
    V_Debug       then ClassS:='Debug'
  else
   ClassS:='???';
  if ClassS<>'' then
   ClassS:=RExpand(ClassS,0)+': ';
  S:=ClassS;
  if (Module<>nil) {and (ID<>0)} then
     S:=S+Module^+' ('+IntToStr(ID)+'): ';
  if Text<>nil then S:=ClassS+Text^;
  if length(S)>MaxLen then S:=copy(S,1,MaxLen-2)+'..';
  GetText:=S;
 end;

constructor TProgramInfoWindow.Init;
var R,R2: TRect;
    HSB,VSB: PScrollBar;
    ST: PStaticText;
    C: word;
const White = 15;
begin
  Desktop^.GetExtent(R); R.A.Y:=R.B.Y-13;
  inherited Init(R, 'Program Information', wnNoNumber);

  HelpCtx:=hcInfoWindow;

  GetExtent(R); R.Grow(-1,-1); R.B.Y:=R.A.Y+3;
  C:=((Desktop^.GetColor(32+6) and $f0) or White)*256+Desktop^.GetColor(32+6);
  New(InfoST, Init(R,'', C)); InfoST^.GrowMode:=gfGrowHiX;
  InfoST^.DontWrap:=true;
  Insert(InfoST);
  GetExtent(R); R.Grow(-1,-1); Inc(R.A.Y,3); R.B.Y:=R.A.Y+1;
  New(ST, Init(R, CharStr('�', MaxViewWidth))); ST^.GrowMode:=gfGrowHiX; Insert(ST);
  GetExtent(R); R.Grow(-1,-1); Inc(R.A.Y,4);
  R2.Copy(R); Inc(R2.B.Y); R2.A.Y:=R2.B.Y-1;
  New(HSB, Init(R2)); HSB^.GrowMode:=gfGrowLoY+gfGrowHiY+gfGrowHiX; Insert(HSB);
  R2.Copy(R); Inc(R2.B.X); R2.A.X:=R2.B.X-1;
  New(VSB, Init(R2)); VSB^.GrowMode:=gfGrowLoX+gfGrowHiX+gfGrowHiY; Insert(VSB);
  New(LogLB, Init(R,HSB,VSB));
  LogLB^.GrowMode:=gfGrowHiX+gfGrowHiY;
  LogLB^.Transparent:=true;
  Insert(LogLB);
  Update;
end;

procedure TProgramInfoWindow.AddMessage(AClass: longint; Msg, Module: string; Line,Column: longint);
begin
  if AClass>=V_Info then Line:=0;
  LogLB^.AddItem(New(PCompilerMessage, Init(AClass, Msg, Module, Line,Column)));
end;

procedure TProgramInfoWindow.ClearMessages;
begin
  LogLB^.Clear;
  ReDraw;
end;

procedure TProgramInfoWindow.SizeLimits(var Min, Max: TPoint);
begin
  inherited SizeLimits(Min,Max);
  Min.X:=30; Min.Y:=9;
end;

procedure TProgramInfoWindow.Close;
begin
  Hide;
end;

procedure TProgramInfoWindow.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evBroadcast :
      case Event.Command of
        cmUpdate :
          Update;
      end;
  end;
  inherited HandleEvent(Event);
end;

procedure TProgramInfoWindow.Update;
begin
  InfoST^.SetText(
    {#13+ }
    '   Current module : '+MainFile+#13+
    '   Last exit code : '+IntToStr(LastExitCode)+#13+
    ' Available memory : '+IntToStrL(MemAvail div 1024,5)+'K'+#13+
    ''
  );
end;

destructor TProgramInfoWindow.Done;
begin
  inherited Done;
  ProgramInfoWindow:=nil;
end;

function TAdvancedStatusLine.GetStatusText: string;
var S: string;
begin
  if StatusText=nil then S:='' else S:=StatusText^;
  GetStatusText:=S;
end;

procedure TAdvancedStatusLine.SetStatusText(const S: string);
begin
  if StatusText<>nil then DisposeStr(StatusText);
  StatusText:=NewStr(S);
  DrawView;
end;

procedure TAdvancedStatusLine.ClearStatusText;
begin
  SetStatusText('');
end;

procedure TAdvancedStatusLine.Draw;
var B: TDrawBuffer;
    C: word;
    S: string;
begin
  S:=GetStatusText;
  if S='' then inherited Draw else
  begin
    C:=GetColor(1);
    MoveChar(B,' ',C,Size.X);
    MoveStr(B[1],S,C);
    WriteLine(0,0,Size.X,Size.Y,B);
  end;
end;

constructor TTab.Init(var Bounds: TRect; ATabDef: PTabDef);
begin
  inherited Init(Bounds);
  Options:=Options or ofSelectable or ofFirstClick or ofPreProcess or ofPostProcess;
  GrowMode:=gfGrowHiX+gfGrowHiY+gfGrowRel;
  TabDefs:=ATabDef;
  ActiveDef:=-1;
  SelectTab(0);
  ReDraw;
end;

function TTab.TabCount: integer;
var i: integer;
    P: PTabDef;
begin
  I:=0; P:=TabDefs;
  while (P<>nil) do
    begin
      Inc(I);
      P:=P^.Next;
    end;
  TabCount:=I;
end;

function TTab.AtTab(Index: integer): PTabDef;
var i: integer;
    P: PTabDef;
begin
  i:=0; P:=TabDefs;
  while (I<Index) do
    begin
      if P=nil then RunError($AA);
      P:=P^.Next;
      Inc(i);
    end;
  AtTab:=P;
end;

procedure TTab.SelectTab(Index: integer);
var P: PTabItem;
    V: PView;
begin
  if ActiveDef<>Index then
  begin
    if Owner<>nil then Owner^.Lock;
    Lock;
    { --- Update --- }
    if TabDefs<>nil then
       begin
         DefCount:=1;
         while AtTab(DefCount-1)^.Next<>nil do Inc(DefCount);
       end
       else DefCount:=0;
    if ActiveDef<>-1 then
    begin
      P:=AtTab(ActiveDef)^.Items;
      while P<>nil do
        begin
          if P^.View<>nil then Delete(P^.View);
          P:=P^.Next;
        end;
    end;
    ActiveDef:=Index;
    P:=AtTab(ActiveDef)^.Items;
    while P<>nil do
      begin
        if P^.View<>nil then Insert(P^.View);
        P:=P^.Next;
      end;
    V:=AtTab(ActiveDef)^.DefItem;
    if V<>nil then V^.Select;
    ReDraw;
    { --- Update --- }
    UnLock;
    if Owner<>nil then Owner^.UnLock;
    DrawView;
  end;
end;

procedure TTab.ChangeBounds(var Bounds: TRect);
var D: TPoint;
procedure DoCalcChange(P: PView); {$ifndef FPC}far;{$endif}
var
  R: TRect;
begin
  if P^.Owner=nil then Exit; { it think this is a bug in TV }
  P^.CalcBounds(R, D);
  P^.ChangeBounds(R);
end;
var
    P: PTabItem;
    I: integer;
begin
  D.X := Bounds.B.X - Bounds.A.X - Size.X;
  D.Y := Bounds.B.Y - Bounds.A.Y - Size.Y;
  inherited ChangeBounds(Bounds);
  for I:=0 to TabCount-1 do
  if I<>ActiveDef then
    begin
      P:=AtTab(I)^.Items;
      while P<>nil do
        begin
          if P^.View<>nil then DoCalcChange(P^.View);
          P:=P^.Next;
        end;
    end;
end;

procedure TTab.HandleEvent(var Event: TEvent);
var Index : integer;
    I     : integer;
    X     : integer;
    Len   : byte;
    P     : TPoint;
    V     : PView;
    CallOrig: boolean;
    LastV : PView;
    FirstV: PView;
function FirstSelectable: PView;
var
    FV : PView;
begin
  FV := First;
  while (FV<>nil) and ((FV^.Options and ofSelectable)=0) and (FV<>Last) do
        FV:=FV^.Next;
  if FV<>nil then
    if (FV^.Options and ofSelectable)=0 then FV:=nil;
  FirstSelectable:=FV;
end;
function LastSelectable: PView;
var
    LV : PView;
begin
  LV := Last;
  while (LV<>nil) and ((LV^.Options and ofSelectable)=0) and (LV<>First) do
        LV:=LV^.Prev;
  if LV<>nil then
    if (LV^.Options and ofSelectable)=0 then LV:=nil;
  LastSelectable:=LV;
end;
begin
  if (Event.What and evMouseDown)<>0 then
     begin
       MakeLocal(Event.Where,P);
       if P.Y<3 then
          begin
            Index:=-1; X:=1;
            for i:=0 to DefCount-1 do
                begin
                  Len:=CStrLen(AtTab(i)^.Name^);
                  if (P.X>=X) and (P.X<=X+Len+1) then Index:=i;
                  X:=X+Len+3;
                end;
            if Index<>-1 then
               SelectTab(Index);
          end;
     end;
  if Event.What=evKeyDown then
     begin
       Index:=-1;
       case Event.KeyCode of
            kbTab,kbShiftTab  :
              if GetState(sfSelected) then
                 begin
                   if Current<>nil then
                   begin
                   LastV:=LastSelectable; FirstV:=FirstSelectable;
                   if ((Current=LastV) or (Current=PLabel(LastV)^.Link)) and (Event.KeyCode=kbShiftTab) then
                      begin
                        if Owner<>nil then Owner^.SelectNext(true);
                      end else
                   if ((Current=FirstV) or (Current=PLabel(FirstV)^.Link)) and (Event.KeyCode=kbTab) then
                      begin
                        Lock;
                        if Owner<>nil then Owner^.SelectNext(false);
                        UnLock;
                      end else
                   SelectNext(Event.KeyCode=kbShiftTab);
                   ClearEvent(Event);
                   end;
                 end;
       else
       for I:=0 to DefCount-1 do
           begin
             if Upcase(GetAltChar(Event.KeyCode))=AtTab(I)^.ShortCut
                then begin
                       Index:=I;
                       ClearEvent(Event);
                       Break;
                     end;
           end;
       end;
       if Index<>-1 then
          begin
            Select;
            SelectTab(Index);
            V:=AtTab(ActiveDef)^.DefItem;
            if V<>nil then V^.Focus;
          end;
     end;
  CallOrig:=true;
  if Event.What=evKeyDown then
     begin
     if ((Owner<>nil) and (Owner^.Phase=phPostProcess) and (GetAltChar(Event.KeyCode)<>#0)) or GetState(sfFocused)
        then
        else CallOrig:=false;
     end;
  if CallOrig then inherited HandleEvent(Event);
end;

function TTab.GetPalette: PPalette;
begin
  GetPalette:=nil;
end;

procedure TTab.Draw;
var B     : TDrawBuffer;
    i     : integer;
    C1,C2,C3,C : word;
    HeaderLen  : integer;
    X,X2       : integer;
    Name       : PString;
    ActiveKPos : integer;
    ActiveVPos : integer;
    FC   : char;
    ClipR      : TRect;
procedure SWriteBuf(X,Y,W,H: integer; var Buf);
var i: integer;
begin
  if Y+H>Size.Y then H:=Size.Y-Y;
  if X+W>Size.X then W:=Size.X-X;
  if Buffer=nil then WriteBuf(X,Y,W,H,Buf)
                else for i:=1 to H do
                         Move(Buf,Buffer^[X+(Y+i-1)*Size.X],W*2);
end;
procedure ClearBuf;
begin
  MoveChar(B,' ',C1,Size.X);
end;
begin
  if InDraw then Exit;
  InDraw:=true;
  { - Start of TGroup.Draw - }
  if Buffer = nil then
  begin
    GetBuffer;
  end;
  { - Start of TGroup.Draw - }

  C1:=GetColor(1); C2:=(GetColor(7) and $f0 or $08)+GetColor(9)*256; C3:=GetColor(8)+GetColor({9}8)*256;
  HeaderLen:=0; for i:=0 to DefCount-1 do HeaderLen:=HeaderLen+CStrLen(AtTab(i)^.Name^)+3; Dec(HeaderLen);
  if HeaderLen>Size.X-2 then HeaderLen:=Size.X-2;

  { --- 1. sor --- }
  ClearBuf; MoveChar(B[0],'�',C1,1); MoveChar(B[HeaderLen+1],'�',C1,1);
  X:=1;
  for i:=0 to DefCount-1 do
      begin
        Name:=AtTab(i)^.Name; X2:=CStrLen(Name^);
        if i=ActiveDef
           then begin
                  ActiveKPos:=X-1;
                  ActiveVPos:=X+X2+2;
                  if GetState(sfFocused) then C:=C3 else C:=C2;
                end
           else C:=C2;
        MoveCStr(B[X],' '+Name^+' ',C); X:=X+X2+3;
        MoveChar(B[X-1],'�',C1,1);
      end;
  SWriteBuf(0,1,Size.X,1,B);

  { --- 0. sor --- }
  ClearBuf; MoveChar(B[0],'�',C1,1);
  X:=1;
  for i:=0 to DefCount-1 do
      begin
        if I<ActiveDef then FC:='�'
                       else FC:='�';
        X2:=CStrLen(AtTab(i)^.Name^)+2;
        MoveChar(B[X+X2],{'�'}FC,C1,1);
        if i=DefCount-1 then X2:=X2+1;
        if X2>0 then
        MoveChar(B[X],'�',C1,X2);
        X:=X+X2+1;
      end;
  MoveChar(B[HeaderLen+1],'�',C1,1);
  MoveChar(B[ActiveKPos],'�',C1,1); MoveChar(B[ActiveVPos],'�',C1,1);
  SWriteBuf(0,0,Size.X,1,B);

  { --- 2. sor --- }
  MoveChar(B[1],'�',C1,Max(HeaderLen,0)); MoveChar(B[HeaderLen+2],'�',C1,Max(Size.X-HeaderLen-3,0));
  MoveChar(B[Size.X-1],'�',C1,1);
  MoveChar(B[ActiveKPos],'�',C1,1);
  if ActiveDef=0 then MoveChar(B[0],'�',C1,1)
                 else MoveChar(B[0],{'�'}'�',C1,1);
  MoveChar(B[HeaderLen+1],'�'{'�'},C1,1); MoveChar(B[ActiveVPos],'�',C1,1);
  MoveChar(B[ActiveKPos+1],' ',C1,Max(ActiveVPos-ActiveKPos-1,0));
  SWriteBuf(0,2,Size.X,1,B);

  { --- marad�k sor --- }
  ClearBuf; MoveChar(B[0],'�',C1,1); MoveChar(B[Size.X-1],'�',C1,1);
  SWriteBuf(0,3,Size.X,Size.Y-4,B);

  { --- Size.X . sor --- }
  MoveChar(B[0],'�',C1,1); MoveChar(B[1],'�',C1,Max(Size.X-2,0)); MoveChar(B[Size.X-1],'�',C1,1);
  SWriteBuf(0,Size.Y-1,Size.X,1,B);

  { - End of TGroup.Draw - }
  if Buffer <> nil then
  begin
    Lock;
    Redraw;
    UnLock;
  end;
  if Buffer <> nil then WriteBuf(0, 0, Size.X, Size.Y, Buffer^) else
  begin
    GetClipRect(ClipR);
    Redraw;
    GetExtent(ClipR);
  end;
  { - End of TGroup.Draw - }
  InDraw:=false;
end;

function TTab.Valid(Command: Word): Boolean;
var PT : PTabDef;
    PI : PTabItem;
    OK : boolean;
begin
  OK:=true;
  PT:=TabDefs;
  while (PT<>nil) and (OK=true) do
        begin
          PI:=PT^.Items;
          while (PI<>nil) and (OK=true) do
                begin
                  if PI^.View<>nil then OK:=OK and PI^.View^.Valid(Command);
                  PI:=PI^.Next;
                end;
          PT:=PT^.Next;
        end;
  Valid:=OK;
end;

procedure TTab.SetState(AState: Word; Enable: Boolean);
begin
  inherited SetState(AState,Enable);
  if (AState and sfFocused)<>0 then DrawView;
end;

destructor TTab.Done;
var P,X: PTabDef;
procedure DeleteViews(P: PView); {$ifndef FPC}far;{$endif}
begin
  if P<>nil then Delete(P);
end;
begin
  ForEach(@DeleteViews);
  inherited Done;
  P:=TabDefs;
  while P<>nil do
        begin
          X:=P^.Next;
          DisposeTabDef(P);
          P:=X;
        end;
end;

constructor TScreenView.Init(var Bounds: TRect; AHScrollBar, AVScrollBar: PScrollBar;
              AScreen: PScreen);
begin
  inherited Init(Bounds,AHScrollBar,AVScrollBar);
  Screen:=AScreen;
  if Screen=nil then
   Fail;
  SetState(sfCursorVis,true);
  Update;
end;

procedure TScreenView.Update;
begin
  SetLimit(UserScreen^.GetWidth,UserScreen^.GetHeight);
  DrawView;
end;

procedure TScreenView.HandleEvent(var Event: TEvent);
begin
  case Event.What of
    evBroadcast :
      case Event.Command of
        cmUpdate  : Update;
      end;
  end;
  inherited HandleEvent(Event);
end;

procedure TScreenView.Draw;
var B: TDrawBuffer;
    X,Y: integer;
    Text,Attr: string;
    P: TPoint;
begin
  Screen^.GetCursorPos(P);
  for Y:=Delta.Y to Delta.Y+Size.Y-1 do
  begin
    if Y<Screen^.GetHeight then
      Screen^.GetLine(Y,Text,Attr)
    else
       begin Text:=''; Attr:=''; end;
    Text:=copy(Text,Delta.X+1,255); Attr:=copy(Attr,Delta.X+1,255);
    MoveChar(B,' ',0,Size.X);
    for X:=1 to length(Text) do
      MoveChar(B[X-1],Text[X],ord(Attr[X]),1);
    WriteLine(0,Y-Delta.Y,Size.X,1,B);
  end;
  SetCursor(P.X-Delta.X,P.Y-Delta.Y);
end;

constructor TScreenWindow.Init(AScreen: PScreen; ANumber: integer);
var R: TRect;
    VSB,HSB: PScrollBar;
begin
  Desktop^.GetExtent(R);
  inherited Init(R, 'User screen', ANumber);
  Options:=Options or ofTileAble;
  GetExtent(R); R.Grow(-1,-1); R.Move(1,0); R.A.X:=R.B.X-1;
  New(VSB, Init(R)); VSB^.Options:=VSB^.Options or ofPostProcess;
  VSB^.GrowMode:=gfGrowLoX+gfGrowHiX+gfGrowHiY; Insert(VSB);
  GetExtent(R); R.Grow(-1,-1); R.Move(0,1); R.A.Y:=R.B.Y-1;
  New(HSB, Init(R)); HSB^.Options:=HSB^.Options or ofPostProcess;
  HSB^.GrowMode:=gfGrowLoY+gfGrowHiX+gfGrowHiY; Insert(HSB);
  GetExtent(R); R.Grow(-1,-1);
  New(ScreenView, Init(R, HSB, VSB, AScreen));
  ScreenView^.GrowMode:=gfGrowHiX+gfGrowHiY;
  Insert(ScreenView);

  UserScreenWindow:=@Self;
end;

destructor TScreenWindow.Done;
begin
  inherited Done;
  UserScreenWindow:=nil;
end;

const InTranslate : boolean = false;

procedure TranslateMouseClick(View: PView; var Event: TEvent);
procedure TranslateAction(Action: integer);
var E: TEvent;
begin
  if Action<>acNone then
  begin
    E:=Event;
    E.What:=evMouseDown; E.Buttons:=mbLeftButton;
    View^.HandleEvent(E);
    Event.What:=evCommand;
    Event.Command:=ActionCommands[Action];
  end;
end;
begin
  if InTranslate then Exit;
  InTranslate:=true;
  case Event.What of
    evMouseDown :
      if (GetShiftState and kbAlt)<>0 then
        TranslateAction(AltMouseAction) else
      if (GetShiftState and kbCtrl)<>0 then
        TranslateAction(CtrlMouseAction);
  end;
  InTranslate:=false;
end;

function GetNextEditorBounds(var Bounds: TRect): boolean;
var P: PView;
begin
  P:=Desktop^.First;
  while P<>nil do
  begin
    if P^.HelpCtx=hcSourceWindow then Break;
    P:=P^.NextView;
  end;
  if P=nil then Desktop^.GetExtent(Bounds) else
     begin
       P^.GetBounds(Bounds);
       Inc(Bounds.A.X); Inc(Bounds.A.Y);
     end;
  GetNextEditorBounds:=P<>nil;
end;

function OpenEditorWindow(Bounds: PRect; FileName: string; CurX,CurY: integer): PSourceWindow;
var R: TRect;
    W: PSourceWindow;
begin
  if Assigned(Bounds) then R.Copy(Bounds^) else
    GetNextEditorBounds(R);
  PushStatus('Opening source file... ('+SmartPath(FileName)+')');
  New(W, Init(R, FileName));
  if W<>nil then
  begin
    if (CurX<>0) or (CurY<>0) then
       with W^.Editor^ do
       begin
         SetCurPtr(CurX,CurY);
         TrackCursor(true);
       end;
    W^.HelpCtx:=hcSourceWindow;
    Desktop^.Insert(W);
    If assigned(BreakpointCollection) then
      BreakPointCollection^.ShowBreakpoints(W);
    Message(Application,evBroadcast,cmUpdate,nil);
  end;
  PopStatus;
  OpenEditorWindow:=W;
end;

function TryToOpenFile(Bounds: PRect; FileName: string; CurX,CurY: integer): PSourceWindow;
var D : DirStr;
    N : NameStr;
    E : ExtStr;
    DrStr : String;

function CheckDir(NewDir: DirStr; NewName: NameStr; NewExt: ExtStr): boolean;
var OK: boolean;
begin
  NewDir:=CompleteDir(NewDir);
  OK:=ExistsFile(NewDir+NewName+NewExt);
  if OK then begin D:=NewDir; N:=NewName; E:=NewExt; end;
  CheckDir:=OK;
end;
function CheckExt(NewExt: ExtStr): boolean;
var OK: boolean;
begin
  OK:=false;
  if D<>'' then OK:=CheckDir(D,N,NewExt) else
    if CheckDir('.'+DirSep,N,NewExt) then OK:=true;
  CheckExt:=OK;
end;

function TryToOpen(const DD : dirstr): PSourceWindow;
var Found: boolean;
    W : PSourceWindow;
begin
  D:=CompleteDir(DD);
  Found:=true;
  if E<>'' then Found:=CheckExt(E) else
    if CheckExt('.pp') then Found:=true else
      if CheckExt('.pas') then Found:=true else
        if CheckExt('.inc')=false then
          Found:=false;
  if Found=false then W:=nil else
    begin
      FileName:=FExpand(D+N+E);
      W:=OpenEditorWindow(Bounds,FileName,CurX,CurY);
    end;
  TryToOpen:=W;
end;
function SearchOnDesktop: PSourceWindow;
var W: PWindow;
    I: integer;
    Found: boolean;
    SName : string;
begin
  for I:=1 to 100 do
  begin
    W:=SearchWindowWithNo(I);
    if (W<>nil) and (W^.HelpCtx=hcSourceWindow) then
      begin
        if (D='') then
          SName:=NameAndExtOf(PSourceWindow(W)^.Editor^.FileName)
        else
          SName:=PSourceWindow(W)^.Editor^.FileName;
        SName:=UpcaseStr(SName);

        if E<>'' then
          begin
            if D<>'' then
              Found:=SName=UpcaseStr(D+N+E)
            else
              Found:=SName=UpcaseStr(N+E);
          end
        else
          begin
            Found:=SName=UpcaseStr(N+'.pp');
            if Found=false then
              Found:=SName=UpcaseStr(N+'.pas');
          end;
        if Found then Break;
      end;
  end;
  if Found=false then W:=nil;
  SearchOnDesktop:=PSourceWindow(W);
end;
var W: PSourceWindow;
begin
  FSplit(FileName,D,N,E);
  W:=SearchOnDesktop;
  if W<>nil then
    begin
      NewEditorOpened:=false;
      if assigned(Bounds) then
        W^.ChangeBounds(Bounds^);
      W^.Editor^.SetCurPtr(CurX,CurY);
    end
  else
    begin
      DrStr:=GetSourceDirectories;
      While pos(';',DrStr)>0 do
        Begin
           W:=TryToOpen(Copy(DrStr,1,pos(';',DrStr)-1));
           if assigned(W) then
             break;
           DrStr:=Copy(DrStr,pos(';',DrStr)+1,255);
        End;
      if not assigned(W) then
        W:=TryToOpen(DrStr);
      NewEditorOpened:=W<>nil;
      if assigned(W) then
        W^.Editor^.SetCurPtr(CurX,CurY);
    end;
  TryToOpenFile:=W;
end;


END.
{
  $Log$
  Revision 1.19  1999-02-22 11:51:39  peter
    * browser updates from gabor

  Revision 1.18  1999/02/22 11:29:38  pierre
    + added col info in MessageItem
    + grep uses HighLightExts and should work for linux

  Revision 1.17  1999/02/22 02:15:22  peter
    + default extension for save in the editor
    + Separate Text to Find for the grep dialog
    * fixed redir crash with tp7

  Revision 1.16  1999/02/19 18:43:49  peter
    + open dialog supports mask list

  Revision 1.15  1999/02/17 15:04:02  pierre
   + file(line) added in TProgramInfo message list

  Revision 1.14  1999/02/16 12:45:18  pierre
   * GDBWindow size and grow corrected

  Revision 1.13  1999/02/15 09:36:06  pierre
    * // comment ends at end of line !
      GDB window changed !
      now all is in a normal text editor, but pressing
      Enter key will send part of line before cursor to GDB !

  Revision 1.12  1999/02/11 19:07:25  pierre
    * GDBWindow redesigned :
      normal editor apart from
      that any kbEnter will send the line (for begin to cursor)
      to GDB command !
      GDBWindow opened in Debugger Menu
       still buggy :
       -echo should not be present if at end of text
       -GDBWindow becomes First after each step (I don't know why !)

  Revision 1.11  1999/02/11 13:08:39  pierre
   + TGDBWindow : direct gdb input/output

  Revision 1.10  1999/02/10 09:42:52  pierre
    + DoneReservedWords to avoid memory leaks
    * TMessageItem Module field was not disposed

  Revision 1.9  1999/02/05 12:12:02  pierre
    + SourceDir that stores directories for sources that the
      compiler should not know about
      Automatically asked for addition when a new file that
      needed filedialog to be found is in an unknown directory
      Stored and retrieved from INIFile
    + Breakpoints conditions added to INIFile
    * Breakpoints insterted and removed at debin and end of debug session

  Revision 1.8  1999/02/04 17:45:23  pierre
    + BrowserAtCursor started
    * bug in TryToOpenFile removed

  Revision 1.7  1999/02/04 13:32:11  pierre
    * Several things added (I cannot commit them independently !)
    + added TBreakpoint and TBreakpointCollection
    + added cmResetDebugger,cmGrep,CmToggleBreakpoint
    + Breakpoint list in INIFile
    * Select items now also depend of SwitchMode
    * Reading of option '-g' was not possible !
    + added search for -Fu args pathes in TryToOpen
    + added code for automatic opening of FileDialog
      if source not found

  Revision 1.6  1999/01/21 11:54:27  peter
    + tools menu
    + speedsearch in symbolbrowser
    * working run command

  Revision 1.5  1999/01/14 21:42:25  peter
    * source tracking from Gabor

  Revision 1.4  1999/01/12 14:29:42  peter
    + Implemented still missing 'switch' entries in Options menu
    + Pressing Ctrl-B sets ASCII mode in editor, after which keypresses (even
      ones with ASCII < 32 ; entered with Alt+<###>) are interpreted always as
      ASCII chars and inserted directly in the text.
    + Added symbol browser
    * splitted fp.pas to fpide.pas

  Revision 1.3  1999/01/04 11:49:53  peter
   * 'Use tab characters' now works correctly
   + Syntax highlight now acts on File|Save As...
   + Added a new class to syntax highlight: 'hex numbers'.
   * There was something very wrong with the palette managment. Now fixed.
   + Added output directory (-FE<xxx>) support to 'Directories' dialog...
   * Fixed some possible bugs in Running/Compiling, and the compilation/run
     process revised

  Revision 1.2  1998/12/28 15:47:54  peter
    + Added user screen support, display & window
    + Implemented Editor,Mouse Options dialog
    + Added location of .INI and .CFG file
    + Option (INI) file managment implemented (see bottom of Options Menu)
    + Switches updated
    + Run program

  Revision 1.4  1998/12/22 10:39:53  peter
    + options are now written/read
    + find and replace routines

}
