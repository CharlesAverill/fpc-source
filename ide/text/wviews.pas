{
    $Id$
    This file is part of the Free Pascal Integrated Development Environment
    Copyright (c) 1998 by Berczi Gabor

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit WViews;

interface

uses Objects,Drivers,Views,Menus,Dialogs;

const
      evIdle                 = $8000;

      cmLocalMenu            = 54100;
      cmUpdate               = 54101;
      cmListFocusChanged     = 54102;

      CPlainCluster          = #7#8#9#9;

type
    PCenterDialog = ^TCenterDialog;
    TCenterDialog = object(TDialog)
      constructor Init(var Bounds: TRect; ATitle: TTitleStr);
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
      procedure FocusItem(Item: sw_integer); virtual;
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

    PHSListBox = ^THSListBox;
    THSListBox = object(TLocalMenuListBox)
      constructor Init(var Bounds: TRect; ANumCols: Word; AHScrollBar, AVScrollBar: PScrollBar);
    end;

    PDlgWindow = ^TDlgWindow;
    TDlgWindow = object(TDialog)
      constructor Init(var Bounds: TRect; ATitle: TTitleStr; ANumber: Sw_Integer);
    end;

    PAdvancedStatusLine = ^TAdvancedStatusLine;
    TAdvancedStatusLine = object(TStatusLine)
      StatusText: PString;
      function  GetStatusText: string; virtual;
      procedure SetStatusText(const S: string); virtual;
      procedure ClearStatusText; virtual;
      procedure Draw; virtual;
    end;

    PDropDownListBox = ^TDropDownListBox;

    PDDHelperLB = ^TDDHelperLB;
    TDDHelperLB = object(TLocalMenuListBox)
      constructor Init(ALink: PDropDownListBox; var Bounds: TRect; ANumCols: Word; AScrollBar: PScrollBar);
      procedure   HandleEvent(var Event: TEvent); virtual;
      procedure   SetState(AState: Word; Enable: Boolean); virtual;
      procedure   SelectItem(Item: Sw_Integer); virtual;
      function    GetText(Item,MaxLen: Sw_Integer): String; virtual;
      function    GetLocalMenu: PMenu; virtual;
      function    GetCommandTarget: PView; virtual;
    private
      Link : PDropDownListBox;
      LastTT: longint;
      InClose: boolean;
    end;

    TDropDownListBox = object(TView)
      Text: string;
      Focused: sw_integer;
      List: PCollection;
      constructor Init(var Bounds: TRect; ADropLineCount: Sw_integer; AList: PCollection);
      procedure   HandleEvent(var Event: TEvent); virtual;
      function    GetText(Item: pointer; MaxLen: sw_integer): string; virtual;
      procedure   NewList(AList: PCollection); virtual;
      procedure   CreateListBox(var R: TRect);
      procedure   DropList(Drop: boolean); virtual;
      function    GetItemCount: sw_integer; virtual;
      procedure   FocusItem(Item: sw_integer); virtual;
      function    LBGetLocalMenu: PMenu; virtual;
      function    LBGetCommandTarget: PView; virtual;
      procedure   SetState(AState: Word; Enable: Boolean); virtual;
      procedure   Draw; virtual;
      function    GetPalette: PPalette; virtual;
      destructor  Done; virtual;
    private
      DropLineCount: Sw_integer;
      ListDropped : boolean;
      ListBox     : PDDHelperLB;
      SB          : PScrollBar;
    end;

    PGroupView = ^TGroupView;
    TGroupView = object(TLabel)
      constructor Init(var Bounds: TRect; AText: String; ALink: PView);
      procedure   Draw; virtual;
    end;

    PPlainCheckBoxes = ^TPlainCheckBoxes;
    TPlainCheckBoxes = object(TCheckBoxes)
      function GetPalette: PPalette; virtual;
    end;

    PPlainRadioButtons = ^TPlainRadioButtons;
    TPlainRadioButtons = object(TRadioButtons)
      function GetPalette: PPalette; virtual;
    end;

procedure InsertOK(ADialog: PDialog);
procedure InsertButtons(ADialog: PDialog);

procedure ErrorBox(const S: string; Params: pointer);
procedure WarningBox(const S: string; Params: pointer);
procedure InformationBox(const S: string; Params: pointer);
function  ConfirmBox(const S: string; Params: pointer; CanCancel: boolean): word;

procedure ShowMessage(Msg: string);
procedure HideMessage;

function  SearchMenuItem(Menu: PMenu; Cmd: word): PMenuItem;
procedure SetMenuItemParam(Menu: PMenuItem; Param: string);
function  IsSubMenu(P: PMenuItem): boolean;
function  IsSeparator(P: PMenuItem): boolean;
function  UpdateMenu(M: PMenu): boolean;
function  SearchSubMenu(M: PMenu; Index: Sw_integer): PMenuItem;
procedure AppendMenuItem(M: PMenu; I: PMenuItem);
procedure RemoveMenuItem(Menu: PMenu; I: PMenuItem);
function  GetMenuItemBefore(Menu:PMenu; BeforeOf: PMenuItem): PMenuItem;

procedure NotImplemented;

implementation

uses Mouse,
     Commands,App,MsgBox,
     WUtils;

const
  MessageDialog  : PCenterDialog = nil;

{*****************************************************************************
                              TCenterDialog
*****************************************************************************}

constructor TCenterDialog.Init(var Bounds: TRect; ATitle: TTitleStr);
begin
  inherited Init(Bounds,ATitle);
  Options:=Options or ofCentered;
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
  GrowMode:=gfGrowHiX;
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
        cmCommandSetChanged : Update;
        cmUpdate            : Update;
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

procedure TAdvancedStaticText.SetText(S: string);
begin
  if Text<>nil then DisposeStr(Text);
  Text:=NewStr(S);
  DrawView;
end;

procedure TAdvancedListBox.FocusItem(Item: sw_integer);
var OFocused: sw_integer;
begin
  OFocused:=Focused;
  inherited FocusItem(Item);
  if Focused<>OFocused then
  Message(Owner,evBroadcast,cmListFocusChanged,@Self);
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

  procedure MoveColorTxt(var b;const curs:string;c:word);
  var
    p : ^word;
    i : sw_integer;
    col : byte;
    tilde : boolean;
  begin
    tilde:=false;
    col:=lo(c);
    p:=@b;
    i:=0;
    while (i<length(Curs)) do
     begin
       Inc(i);
       case CurS[i] of
         #1 :
           begin
             Inc(i);
             Col:=ord(curS[i]);
           end;
         #2 :
           begin
             if tilde then
              col:=hi(Color)
             else
              col:=lo(Color)
           end;
         '~' :
           begin
             tilde:=not tilde;
             if tilde then
              col:=hi(Color)
             else
              col:=lo(Color)
           end;
         else
           begin
             p^:=(col shl 8) or ord(curs[i]);
             inc(p);
           end;
       end;
     end;
  end;

var
  C: word;
  Center: Boolean;
  I, J, L, P, Y: Sw_Integer;
  B: TDrawBuffer;
  S: String;
  T: string;
  CurS: string;
  TildeCount,Po: Sw_integer;
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
      MoveColorTxt(B[J],T,C);
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
    if CurS<>'' then
      MoveColorTxt(B,CurS,C);
    WriteLine(0,Y,Size.X,1,B);
  end;
 end;
end;

constructor THSListBox.Init(var Bounds: TRect; ANumCols: Word; AHScrollBar, AVScrollBar: PScrollBar);
begin
  inherited Init(Bounds,ANumCols,AVScrollBar);
  HScrollBar:=AHScrollBar;
end;

constructor TDlgWindow.Init(var Bounds: TRect; ATitle: TTitleStr; ANumber: Sw_Integer);
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

function SearchSubMenu(M: PMenu; Index: Sw_integer): PMenuItem;
var P,C: PMenuItem;
    Count: Sw_integer;
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

procedure NotImplemented;
begin
  InformationBox('This function is not yet implemented...',nil);
end;

procedure InsertButtons(ADialog: PDialog);
var R   : TRect;
    W,H : Sw_integer;
    X   : Sw_integer;
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

procedure ShowMessage(Msg: string);
var R: TRect;
    Width: Sw_integer;
begin
  Width:=length(Msg)+4*2;
  if Width<(Desktop^.Size.X div 2) then Width:=(Desktop^.Size.X div 2);
  R.Assign(0,0,Width,5);
  New(MessageDialog, Init(R, ''));
  with MessageDialog^ do
  begin
    Flags:=0;
    GetExtent(R); R.Grow(-4,-2);
    if copy(Msg,1,1)<>^C then Msg:=^C+Msg;
    Insert(New(PStaticText, Init(R, Msg)));
  end;
  Application^.Insert(MessageDialog);
end;

procedure HideMessage;
begin
  if MessageDialog<>nil then
    begin
      Application^.Delete(MessageDialog);
      Dispose(MessageDialog, Done);
      MessageDialog:=nil;
    end;
end;


constructor TDDHelperLB.Init(ALink: PDropDownListBox; var Bounds: TRect; ANumCols: Word; AScrollBar: PScrollBar);
begin
  inherited Init(Bounds,ANumCols,AScrollBar);
  EventMask:=EventMask or (evMouseMove+evIdle);
{  Options:=Options or ofPreProcess;}
  Link:=ALink;
end;

procedure TDDHelperLB.SetState(AState: Word; Enable: Boolean);
var OState: longint;
begin
  OState:=State;
  inherited SetState(AState,Enable);
{  if (((State xor OState) and sfFocused)<>0) and (GetState(sfFocused)=false) then
    Link^.DropList(false);}
end;

function TDDHelperLB.GetText(Item,MaxLen: Sw_Integer): String;
var P: pointer;
    S: string;
begin
  P:=List^.At(Item);
  if Link=nil then S:='' else
    S:=Link^.GetText(P,MaxLen);
  GetText:=S;
end;

function TDDHelperLB.GetLocalMenu: PMenu;
begin
  GetLocalMenu:=Link^.LBGetLocalMenu;
end;

function TDDHelperLB.GetCommandTarget: PView;
begin
  GetCommandTarget:=Link^.LBGetCommandTarget;
end;

procedure TDDHelperLB.HandleEvent(var Event: TEvent);
const
  MouseAutosToSkip = 4;
var
  Mouse : TPoint;
  OldItem, NewItem : Sw_Integer;
  ColWidth,Count : Sw_Word;
  GoSelectItem: sw_integer;
  MouseWhere: TPoint;
begin
  GoSelectItem:=-1;
  TView.HandleEvent(Event);
  case Event.What of
    evMouseDown :
      if MouseInView(Event.Where)=false then
        GoSelectItem:=-2
      else
      begin
        ColWidth := Size.X div NumCols + 1;
        OldItem := Focused;
        MakeLocal(Event.Where, Mouse);
        if MouseInView(Event.Where) then
          NewItem := Mouse.Y + (Size.Y * (Mouse.X div ColWidth)) + TopItem
        else
          NewItem := OldItem;
        Count := 0;
        repeat
          if NewItem <> OldItem then
           begin
             FocusItemNum(NewItem);
             DrawView;
           end;
          OldItem := NewItem;
          MakeLocal(Event.Where, Mouse);
          if MouseInView(Event.Where) then
            NewItem := Mouse.Y + (Size.Y * (Mouse.X div ColWidth)) + TopItem
          else
          begin
            if NumCols = 1 then
            begin
              if Event.What = evMouseAuto then Inc(Count);
              if Count = MouseAutosToSkip then
              begin
                Count := 0;
                if Mouse.Y < 0 then NewItem := Focused-1
                else if Mouse.Y >= Size.Y then NewItem := Focused+1;
              end;
            end
            else
            begin
              if Event.What = evMouseAuto then Inc(Count);
              if Count = MouseAutosToSkip then
              begin
                Count := 0;
                if Mouse.X < 0 then NewItem := Focused-Size.Y
                else if Mouse.X >= Size.X then NewItem := Focused+Size.Y
                else if Mouse.Y < 0 then
                  NewItem := Focused - Focused mod Size.Y
                else if Mouse.Y > Size.Y then
                  NewItem := Focused - Focused mod Size.Y + Size.Y - 1;
              end
            end;
          end;
        until not MouseEvent(Event, evMouseMove + evMouseAuto);
        FocusItemNum(NewItem);
        DrawView;
        if Event.Double and (Range > Focused) then SelectItem(Focused);
        ClearEvent(Event);
        GoSelectItem:=Focused;
      end;
    evMouseMove,evMouseAuto:
     if GetState(sfFocused) then
      if MouseInView(Event.Where) then
        begin
          MakeLocal(Event.Where,Mouse);
          FocusItemNum(TopItem+Mouse.Y);
          ClearEvent(Event);
        end;
    evKeyDown :
      begin
        if (Event.KeyCode=kbEsc) then
          begin
            GoSelectItem:=-2;
            ClearEvent(Event);
          end else
        if (Event.CharCode = ' ') and (Focused < Range) then
          begin
            GoSelectItem:=Focused;
            NewItem := Focused;
          end
        else
          case CtrlToArrow(Event.KeyCode) of
            kbUp   : NewItem := Focused - 1;
            kbDown : NewItem := Focused + 1;
            kbRight: if NumCols > 1 then NewItem := Focused + Size.Y else Exit;
            kbLeft : if NumCols > 1 then NewItem := Focused - Size.Y else Exit;
            kbPgDn : NewItem := Focused + Size.Y * NumCols;
            kbPgUp : NewItem := Focused - Size.Y * NumCols;
            kbHome : NewItem := TopItem;
            kbEnd  : NewItem := TopItem + (Size.Y * NumCols) - 1;
            kbCtrlPgDn: NewItem := Range - 1;
            kbCtrlPgUp: NewItem := 0;
        else
          Exit;
        end;
        FocusItemNum(NewItem);
        DrawView;
        ClearEvent(Event);
      end;
    evBroadcast :
      case Event.Command of
        cmReceivedFocus :
          if (Event.InfoPtr<>@Self) and (InClose=false) then
            begin
              GoSelectItem:=-2;
            end;
      else
        if Options and ofSelectable <> 0 then
          if (Event.Command = cmScrollBarClicked) and
             ((Event.InfoPtr = HScrollBar) or (Event.InfoPtr = VScrollBar)) then
            Select
          else
            if (Event.Command = cmScrollBarChanged) then
              begin
                if (VScrollBar = Event.InfoPtr) then
                  begin
                    FocusItemNum(VScrollBar^.Value);
                    DrawView;
                  end
                else
                  if (HScrollBar = Event.InfoPtr) then
                    DrawView;
              end;
      end;
    evIdle :
      begin
        MouseWhere.X:=MouseWhereX shr 3; MouseWhere.Y:=MouseWhereY shr 3;
        if MouseInView(MouseWhere)=false then
         if abs(GetDosTicks-LastTT)>=1 then
          begin
            LastTT:=GetDosTicks;
            MakeLocal(MouseWhere,Mouse);
            if ((Mouse.Y<-1) or (Mouse.Y>=Size.Y)) and
               ((0<=Mouse.X) and (Mouse.X<Size.X)) then
            if Range>0 then
              if Mouse.Y<0 then
                FocusItemNum(Focused-(0-Mouse.Y))
              else
                FocusItemNum(Focused+(Mouse.Y-(Size.Y-1)));
          end;
      end;
  end;
  if (Range>0) and (GoSelectItem<>-1) then
   begin
     InClose:=true;
     if GoSelectItem=-2 then
       Link^.DropList(false)
     else
       SelectItem(GoSelectItem);
   end;
end;

procedure TDDHelperLB.SelectItem(Item: Sw_Integer);
begin
  inherited SelectItem(Item);
  Link^.FocusItem(Focused);
  Link^.DropList(false);
end;

constructor TDropDownListBox.Init(var Bounds: TRect; ADropLineCount: Sw_integer; AList: PCollection);
begin
  inherited Init(Bounds);
  Options:=Options or (ofSelectable);
  EventMask:=EventMask or (evBroadcast);
  DropLineCount:=ADropLineCount;
  NewList(AList);
end;

procedure TDropDownListBox.HandleEvent(var Event: TEvent);
var DontClear: boolean;
    Count: sw_integer;
begin
  case Event.What of
    evKeyDown :
      if GetState(sfFocused) then
       begin
         DontClear:=false;
         Count:=GetItemCount;
         if Count>0 then
         case Event.KeyCode of
           kbUp :
             if Focused>0 then
               FocusItem(Focused-1);
           kbDown :
             if Focused<Count-1 then
               FocusItem(Focused+1);
           kbHome :
             FocusItem(0);
           kbEnd  :
             FocusItem(Count-1);
           kbPgDn :
             DropList(true);
         else DontClear:=true;
         end;
         if DontClear=false then ClearEvent(Event);
       end;
    evBroadcast :
      case Event.Command of
{        cmReleasedFocus :
          if (ListBox<>nil) and (Event.InfoPtr=ListBox) then
            DropList(false);}
        cmListItemSelected :
          if (ListBox<>nil) and (Event.InfoPtr=ListBox) then
            begin
              FocusItem(ListBox^.Focused);
              Text:=GetText(List^.At(Focused),255);
              DrawView;
              DropList(false);
            end;
      end;
    evMouseDown :
      if MouseInView(Event.Where) then
        begin
          DropList(not ListDropped);
          ClearEvent(Event);
        end;
  end;
  inherited HandleEvent(Event);
end;

function TDropDownListBox.GetText(Item: pointer; MaxLen: Sw_integer): string;
var S: string;
begin
  S:=GetStr(Item);
  GetText:=copy(S,1,MaxLen);
end;

procedure TDropDownListBox.NewList(AList: PCollection);
begin
  if List<>nil then Dispose(List, Done); List:=nil;
  List:=AList; FocusItem(0);
end;

procedure TDropDownListBox.CreateListBox(var R: TRect);
var R2: TRect;
begin
  R2.Copy(R); R2.A.X:=R2.B.X-1;
  New(SB, Init(R2));
  Dec(R.B.X);
  New(ListBox, Init(@Self,R,1,SB));
end;

procedure TDropDownListBox.DropList(Drop: boolean);
var R: TRect;
begin
  if ListDropped=Drop then Exit;

  if Drop then
    begin
      R.Assign(Origin.X+1,Origin.Y+Size.Y,Origin.X+Size.X,Origin.Y+Size.Y+DropLineCount);
      if Owner<>nil then Owner^.Lock;
      CreateListBox(R);
      if SB<>nil then
        Owner^.Insert(SB);
      if ListBox<>nil then
        begin
          ListBox^.NewList(List);
          ListBox^.FocusItem(Focused);
          Owner^.Insert(ListBox);
        end;
      if Owner<>nil then Owner^.UnLock;
    end
  else
    begin
      if Owner<>nil then Owner^.Lock;
      if ListBox<>nil then
        begin
{          ListBox^.List:=nil;}
          Dispose(ListBox, Done);
          ListBox:=nil;
        end;
      if SB<>nil then
        begin
          Dispose(SB, Done);
          SB:=nil;
        end;
      Select;
      if Owner<>nil then Owner^.UnLock;
    end;

  ListDropped:=Drop;
  DrawView;
end;

function TDropDownListBox.GetItemCount: sw_integer;
var Count: sw_integer;
begin
  if assigned(List)=false then Count:=0 else
    Count:=List^.Count;
  GetItemCount:=Count;
end;

procedure TDropDownListBox.FocusItem(Item: sw_integer);
var P: pointer;
begin
  Focused:=Item;
  if assigned(ListBox) and (Item>=0) then
    ListBox^.FocusItem(Item);
  if (GetItemCount>0) and (Focused>=0) then
    begin
      P:=List^.At(Focused);
      Text:=GetText(P,Size.X-4);
    end;
  DrawView;
end;

function TDropDownListBox.LBGetLocalMenu: PMenu;
begin
  LBGetLocalMenu:=nil;
end;

function TDropDownListBox.LBGetCommandTarget: PView;
begin
  LBGetCommandTarget:=@Self;
end;

procedure TDropDownListBox.SetState(AState: Word; Enable: Boolean);
begin
  inherited SetState(AState,Enable);
  if (AState and (sfSelected + sfActive + sfFocused)) <> 0 then DrawView;
end;

procedure TDropDownListBox.Draw;
var B: TDrawBuffer;
    C,TextC: word;
    LC: char;
begin
  if GetState(sfFocused)=false then
    begin
      C:=GetColor(2);
      TextC:=GetColor(2);
    end
  else
    begin
      C:=GetColor(3);
      TextC:=GetColor(3);
    end;
  MoveChar(B,' ',C,Size.X);
  MoveStr(B[1],copy(Text,1,Size.X-2),TextC);
  if ListDropped then LC:=#30 else LC:=#31;
  MoveChar(B[Size.X-2],LC,C,1);
  WriteLine(0,0,Size.X,Size.Y,B);
end;

function TDropDownListBox.GetPalette: PPalette;
const P: string[length(CListViewer)] = CListViewer;
begin
  GetPalette:=@P;
end;

destructor TDropDownListBox.Done;
begin
  if ListDropped then DropList(false);
  inherited Done;
end;

constructor TGroupView.Init(var Bounds: TRect; AText: String; ALink: PView);
begin
  inherited Init(Bounds,AText,ALink);
end;

procedure TGroupView.Draw;
var B: TDrawBuffer;
    FrameC,LabelC: word;
begin
  FrameC:=GetColor(1);
  if Light then
    LabelC:=GetColor(2)+GetColor(4) shl 8
  else
    LabelC:=GetColor(1)+GetColor(3) shl 8;
  { First Line }
  MoveChar(B[0],'�',FrameC,1);
  MoveChar(B[1],'�',FrameC,Size.X-2);
  MoveChar(B[Size.X-1],'�',FrameC,1);
  if Text<>nil then
    begin
      MoveCStr(B[1],' '+Text^+' ',LabelC);
    end;
  WriteLine(0,0,Size.X,1,B);
  { Mid Lines }
  MoveChar(B[0],'�',FrameC,1);
  MoveChar(B[1],' ',FrameC,Size.X-2);
  MoveChar(B[Size.X-1],'�',FrameC,1);
  WriteLine(0,1,Size.X,Size.Y-2,B);
  { Last Line }
  MoveChar(B[0],'�',FrameC,1);
  MoveChar(B[1],'�',FrameC,Size.X-2);
  MoveChar(B[Size.X-1],'�',FrameC,1);
  WriteLine(0,Size.Y-1,Size.X,1,B);
end;

function TPlainCheckBoxes.GetPalette: PPalette;
const P: string[length(CPlainCluster)] = CPlainCluster;
begin
  GetPalette:=@P;
end;

function TPlainRadioButtons.GetPalette: PPalette;
const P: string[length(CPlainCluster)] = CPlainCluster;
begin
  GetPalette:=@P;
end;

END.
{
  $Log$
  Revision 1.5  1999-03-23 16:16:44  peter
    * linux fixes

  Revision 1.4  1999/03/23 15:11:42  peter
    * desktop saving things
    * vesa mode
    * preferences dialog

  Revision 1.3  1999/03/19 16:04:35  peter
    * new compiler dialog

  Revision 1.2  1999/03/08 14:58:23  peter
    + prompt with dialogs for tools

  Revision 1.1  1999/03/01 15:51:43  peter
    + Log

}
