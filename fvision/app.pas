
{ $Id$}
{********[ SOURCE FILE OF GRAPHICAL FREE VISION ]**********}
{                                                          }
{   System independent GRAPHICAL clone of APP.PAS          }
{                                                          }
{   Interface Copyright (c) 1992 Borland International     }
{                                                          }
{   Copyright (c) 1996, 1997, 1998, 1999 by Leon de Boer   }
{   ldeboer@attglobal.net  - primary e-mail addr           }
{   ldeboer@starwon.com.au - backup e-mail addr            }
{                                                          }
{****************[ THIS CODE IS FREEWARE ]*****************}
{                                                          }
{     This sourcecode is released for the purpose to       }
{   promote the pascal language on all platforms. You may  }
{   redistribute it and/or modify with the following       }
{   DISCLAIMER.                                            }
{                                                          }
{     This SOURCE CODE is distributed "AS IS" WITHOUT      }
{   WARRANTIES AS TO PERFORMANCE OF MERCHANTABILITY OR     }
{   ANY OTHER WARRANTIES WHETHER EXPRESSED OR IMPLIED.     }
{                                                          }
{*****************[ SUPPORTED PLATFORMS ]******************}
{     16 and 32 Bit compilers                              }
{        DOS      - Turbo Pascal 7.0 +      (16 Bit)       }
{        DPMI     - Turbo Pascal 7.0 +      (16 Bit)       }
{                 - FPC 0.9912+ (GO32V2)    (32 Bit)       }
{        WINDOWS  - Turbo Pascal 7.0 +      (16 Bit)       }
{                 - Delphi 1.0+             (16 Bit)       }
{        WIN95/NT - Delphi 2.0+             (32 Bit)       }
{                 - Virtual Pascal 2.0+     (32 Bit)       }
{                 - FPC 0.9912+             (32 Bit)       }
{        OS2      - Virtual Pascal 1.0+     (32 Bit)       }
{                                                          }
{******************[ REVISION HISTORY ]********************}
{  Version  Date        Fix                                }
{  -------  ---------   ---------------------------------  }
{  1.00     12 Dec 96   First multi platform release       }
{  1.10     12 Sep 97   FPK pascal 0.92 conversion added.  }
{  1.20     29 Aug 97   Platform.inc sort added.           }
{  1.30     05 May 98   Virtual pascal 2.0 code added.     }
{  1.40     22 Oct 99   Object registration added.         }
{  1.50     22 Oct 99   Complete recheck preformed         }
{  1.51     03 Nov 99   FPC Windows support added          }
{  1.60     26 Nov 99   Graphics stuff moved to GFVGraph   }
{**********************************************************}

UNIT App;

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                  INTERFACE
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{====Include file to sort compiler platform out =====================}
{$I Platform.inc}
{====================================================================}

{==== Compiler directives ===========================================}

{$IFNDEF PPC_FPC}{ FPC doesn't support these switches }
  {$F-} { Near calls are okay }
  {$A+} { Word Align Data }
  {$B-} { Allow short circuit boolean evaluations }
  {$O+} { This unit may be overlaid }
  {$G+} { 286 Code optimization - if you're on an 8088 get a real computer }
  {$P-} { Normal string variables }
  {$N-} { No 80x87 code generation }
  {$E+} { Emulation is on }
{$ENDIF}

{$X+} { Extended syntax is ok }
{$R-} { Disable range checking }
{$S-} { Disable Stack Checking }
{$I-} { Disable IO Checking }
{$Q-} { Disable Overflow Checking }
{$V-} { Turn off strict VAR strings }
{====================================================================}

USES
   {$IFDEF OS_WINDOWS}                                { WIN/NT CODE }
     {$IFNDEF PPC_SPEED}                              { NON SPEED COMPILER }
       {$IFDEF PPC_FPC}                               { FPC WINDOWS COMPILER }
       Windows,                                       { Standard units }
       {$ELSE}                                        { OTHER COMPILERS }
       WinTypes,WinProcs,                             { Standard units }
       {$ENDIF}
       {$IFNDEF PPC_DELPHI}                           { NON DELPHI1 COMPILER }
         {$IFDEF BIT_16} Win31, {$ENDIF}              { 16 BIT WIN 3.1 UNIT }
       {$ENDIF}
     {$ELSE}                                          { SPEEDSOFT COMPILER }
       WinBase, WinDef,                               { Standard units }
     {$ENDIF}
     {$IFDEF PPC_DELPHI}                              { DELPHI COMPILERS }
       Messages,                                      { Standard unit }
     {$ENDIF}
   {$ENDIF}

   {$IFDEF OS_OS2}                                    { OS2 CODE }
     Os2Def, Os2Base, OS2PmApi,                       { Standard units }
   {$ENDIF}

   Common, Memory, GFVGraph,                          { GFV standard units }
   Objects, Drivers, Views, Menus, HistList, Dialogs; { GFV standard units }

{***************************************************************************}
{                              PUBLIC CONSTANTS                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                  STANDARD APPLICATION COMMAND CONSTANTS                   }
{---------------------------------------------------------------------------}
CONST
   cmNew       = 30;                                  { Open new file }
   cmOpen      = 31;                                  { Open a file }
   cmSave      = 32;                                  { Save current }
   cmSaveAs    = 33;                                  { Save current as }
   cmSaveAll   = 34;                                  { Save all files }
   cmChangeDir = 35;                                  { Change directories }
   cmDosShell  = 36;                                  { Dos shell }
   cmCloseAll  = 37;                                  { Close all windows }

{---------------------------------------------------------------------------}
{                       TApplication PALETTE ENTRIES                        }
{---------------------------------------------------------------------------}
CONST
   apColor      = 0;                                  { Coloured app }
   apBlackWhite = 1;                                  { B&W application }
   apMonochrome = 2;                                  { Monochrome app }

{---------------------------------------------------------------------------}
{                           TBackGround PALETTES                            }
{---------------------------------------------------------------------------}
CONST
   CBackground = #1;                                  { Background colour }

{---------------------------------------------------------------------------}
{                           TApplication PALETTES                           }
{---------------------------------------------------------------------------}
CONST
  { Turbo Vision 1.0 Color Palettes }
   CColor =
         #$81#$70#$78#$74#$20#$28#$24#$17#$1F#$1A#$31#$31#$1E#$71#$1F +
     #$37#$3F#$3A#$13#$13#$3E#$21#$3F#$70#$7F#$7A#$13#$13#$70#$7F#$7E +
     #$70#$7F#$7A#$13#$13#$70#$70#$7F#$7E#$20#$2B#$2F#$78#$2E#$70#$30 +
     #$3F#$3E#$1F#$2F#$1A#$20#$72#$31#$31#$30#$2F#$3E#$31#$13#$38#$00;

   CBlackWhite =
         #$70#$70#$78#$7F#$07#$07#$0F#$07#$0F#$07#$70#$70#$07#$70#$0F +
     #$07#$0F#$07#$70#$70#$07#$70#$0F#$70#$7F#$7F#$70#$07#$70#$07#$0F +
     #$70#$7F#$7F#$70#$07#$70#$70#$7F#$7F#$07#$0F#$0F#$78#$0F#$78#$07 +
     #$0F#$0F#$0F#$70#$0F#$07#$70#$70#$70#$07#$70#$0F#$07#$07#$78#$00;

   CMonochrome =
         #$70#$07#$07#$0F#$70#$70#$70#$07#$0F#$07#$70#$70#$07#$70#$00 +
     #$07#$0F#$07#$70#$70#$07#$70#$00#$70#$70#$70#$07#$07#$70#$07#$00 +
     #$70#$70#$70#$07#$07#$70#$70#$70#$0F#$07#$07#$0F#$70#$0F#$70#$07 +
     #$0F#$0F#$07#$70#$07#$07#$70#$07#$07#$07#$70#$0F#$07#$07#$70#$00;

   { Turbo Vision 2.0 Color Palettes }

   CAppColor =
         #$81#$70#$78#$74#$20#$28#$24#$17#$1F#$1A#$31#$31#$1E#$71#$1F +
     #$37#$3F#$3A#$13#$13#$3E#$21#$3F#$70#$7F#$7A#$13#$13#$70#$7F#$7E +
     #$70#$7F#$7A#$13#$13#$70#$70#$7F#$7E#$20#$2B#$2F#$78#$2E#$70#$30 +
     #$3F#$3E#$1F#$2F#$1A#$20#$72#$31#$31#$30#$2F#$3E#$31#$13#$38#$00 +
     #$17#$1F#$1A#$71#$71#$1E#$17#$1F#$1E#$20#$2B#$2F#$78#$2E#$10#$30 +
     #$3F#$3E#$70#$2F#$7A#$20#$12#$31#$31#$30#$2F#$3E#$31#$13#$38#$00 +
     #$37#$3F#$3A#$13#$13#$3E#$30#$3F#$3E#$20#$2B#$2F#$78#$2E#$30#$70 +
     #$7F#$7E#$1F#$2F#$1A#$20#$32#$31#$71#$70#$2F#$7E#$71#$13#$38#$00;

   CAppBlackWhite =
         #$70#$70#$78#$7F#$07#$07#$0F#$07#$0F#$07#$70#$70#$07#$70#$0F +
     #$07#$0F#$07#$70#$70#$07#$70#$0F#$70#$7F#$7F#$70#$07#$70#$07#$0F +
     #$70#$7F#$7F#$70#$07#$70#$70#$7F#$7F#$07#$0F#$0F#$78#$0F#$78#$07 +
     #$0F#$0F#$0F#$70#$0F#$07#$70#$70#$70#$07#$70#$0F#$07#$07#$78#$00 +
     #$07#$0F#$0F#$07#$70#$07#$07#$0F#$0F#$70#$78#$7F#$08#$7F#$08#$70 +
     #$7F#$7F#$7F#$0F#$70#$70#$07#$70#$70#$70#$07#$7F#$70#$07#$78#$00 +
     #$70#$7F#$7F#$70#$07#$70#$70#$7F#$7F#$07#$0F#$0F#$78#$0F#$78#$07 +
     #$0F#$0F#$0F#$70#$0F#$07#$70#$70#$70#$07#$70#$0F#$07#$07#$78#$00;

   CAppMonochrome =
         #$70#$07#$07#$0F#$70#$70#$70#$07#$0F#$07#$70#$70#$07#$70#$00 +
     #$07#$0F#$07#$70#$70#$07#$70#$00#$70#$70#$70#$07#$07#$70#$07#$00 +
     #$70#$70#$70#$07#$07#$70#$70#$70#$0F#$07#$07#$0F#$70#$0F#$70#$07 +
     #$0F#$0F#$07#$70#$07#$07#$70#$07#$07#$07#$70#$0F#$07#$07#$70#$00 +
     #$70#$70#$70#$07#$07#$70#$70#$70#$0F#$07#$07#$0F#$70#$0F#$70#$07 +
     #$0F#$0F#$07#$70#$07#$07#$70#$07#$07#$07#$70#$0F#$07#$07#$70#$00 +
     #$70#$70#$70#$07#$07#$70#$70#$70#$0F#$07#$07#$0F#$70#$0F#$70#$07 +
     #$0F#$0F#$07#$70#$07#$07#$70#$07#$07#$07#$70#$0F#$07#$07#$70#$00;

{---------------------------------------------------------------------------}
{                     STANDRARD HELP CONTEXT CONSTANTS                      }
{---------------------------------------------------------------------------}
CONST
{ Note: range $FF00 - $FFFF of help contexts are reserved by Borland }
   hcNew       = $FF01;                               { New file help }
   hcOpen      = $FF02;                               { Open file help }
   hcSave      = $FF03;                               { Save file help }
   hcSaveAs    = $FF04;                               { Save file as help }
   hcSaveAll   = $FF05;                               { Save all files help }
   hcChangeDir = $FF06;                               { Change dir help }
   hcDosShell  = $FF07;                               { Dos shell help }
   hcExit      = $FF08;                               { Exit program help }

   hcUndo      = $FF10;                               { Clipboard undo help }
   hcCut       = $FF11;                               { Clipboard cut help }
   hcCopy      = $FF12;                               { Clipboard copy help }
   hcPaste     = $FF13;                               { Clipboard paste help }
   hcClear     = $FF14;                               { Clipboard clear help }

   hcTile      = $FF20;                               { Desktop tile help }
   hcCascade   = $FF21;                               { Desktop cascade help }
   hcCloseAll  = $FF22;                               { Desktop close all }
   hcResize    = $FF23;                               { Window resize help }
   hcZoom      = $FF24;                               { Window zoom help }
   hcNext      = $FF25;                               { Window next help }
   hcPrev      = $FF26;                               { Window previous help }
   hcClose     = $FF27;                               { Window close help }

{***************************************************************************}
{                        PUBLIC OBJECT DEFINITIONS                          }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                  TBackGround OBJECT - BACKGROUND OBJECT                   }
{---------------------------------------------------------------------------}
TYPE
   TBackGround = OBJECT (TView)
         Pattern: Char;                               { Background pattern }
      CONSTRUCTOR Init (Var Bounds: TRect; APattern: Char);
      CONSTRUCTOR Load (Var S: TStream);
      FUNCTION GetPalette: PPalette; Virtual;
      PROCEDURE DrawBackGround; Virtual;
      PROCEDURE Store (Var S: TStream);
   END;
   PBackGround = ^TBackGround;

{---------------------------------------------------------------------------}
{                     TDeskTop OBJECT - DESKTOP OBJECT                      }
{---------------------------------------------------------------------------}
TYPE
   TDeskTop = OBJECT (TGroup)
         Background      : PBackground;               { Background view }
         TileColumnsFirst: Boolean;                   { Tile direction }
      CONSTRUCTOR Init (Var Bounds: TRect);
      CONSTRUCTOR Load (Var S: TStream);
      PROCEDURE TileError; Virtual;
      PROCEDURE InitBackGround; Virtual;
      PROCEDURE Tile (Var R: TRect);
      PROCEDURE Store (Var S: TStream);
      PROCEDURE Cascade (Var R: TRect);
      PROCEDURE HandleEvent (Var Event: TEvent); Virtual;
   END;
   PDeskTop = ^TDeskTop;

{---------------------------------------------------------------------------}
{                  TProgram OBJECT - PROGRAM ANCESTOR OBJECT                }
{---------------------------------------------------------------------------}
TYPE
   TProgram = OBJECT (TGroup)
      CONSTRUCTOR Init;
      DESTRUCTOR Done; Virtual;
      FUNCTION GetPalette: PPalette; Virtual;
      FUNCTION CanMoveFocus: Boolean;
      FUNCTION ValidView (P: PView): PView;
      FUNCTION InsertWindow (P: PWindow): PWindow;
      FUNCTION ExecuteDialog (P: PDialog; Data: Pointer): Word;
      PROCEDURE Run; Virtual;
      PROCEDURE Idle; Virtual;
      PROCEDURE InitScreen; Virtual;
      PROCEDURE InitDeskTop; Virtual;
      PROCEDURE OutOfMemory; Virtual;
      PROCEDURE InitMenuBar; Virtual;
      PROCEDURE InitStatusLine; Virtual;
      PROCEDURE SetScreenMode (Mode: Word);
      PROCEDURE PutEvent (Var Event: TEvent); Virtual;
      PROCEDURE GetEvent (Var Event: TEvent); Virtual;
      PROCEDURE HandleEvent (Var Event: TEvent); Virtual;
      {$IFNDEF OS_DOS}                                { WIN/NT/OS2 CODE }
      FUNCTION GetClassName: String; Virtual;
      FUNCTION GetClassText: String; Virtual;
      FUNCTION GetClassAttr: LongInt; Virtual;
      FUNCTION GetMsgHandler: Pointer; Virtual;
      {$ENDIF}
   END;
   PProgram = ^TProgram;

{---------------------------------------------------------------------------}
{                  TApplication OBJECT - APPLICATION OBJECT                 }
{---------------------------------------------------------------------------}
TYPE
   TApplication = OBJECT (TProgram)
      CONSTRUCTOR Init;
      DESTRUCTOR Done; Virtual;
      PROCEDURE Tile;
      PROCEDURE Cascade;
      PROCEDURE DosShell;
      PROCEDURE GetTileRect (Var R: TRect); Virtual;
      PROCEDURE HandleEvent (Var Event: TEvent); Virtual;
   END;
   PApplication = ^TApplication;                      { Application ptr }

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                STANDARD MENU AND STATUS LINES ROUTINES                    }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{-StdStatusKeys------------------------------------------------------
Returns a pointer to a linked list of commonly used status line keys.
The default status line for TApplication uses StdStatusKeys as its
complete list of status keys.
22Oct99 LdB
---------------------------------------------------------------------}
FUNCTION StdStatusKeys (Next: PStatusItem): PStatusItem;

{-StdFileMenuItems---------------------------------------------------
Returns a pointer to a list of menu items for a standard File menu.
The standard File menu items are New, Open, Save, Save As, Save All,
Change Dir, OS Shell, and Exit.
22Oct99 LdB
---------------------------------------------------------------------}
FUNCTION StdFileMenuItems (Next: PMenuItem): PMenuItem;

{-StdEditMenuItems---------------------------------------------------
Returns a pointer to a list of menu items for a standard Edit menu.
The standard Edit menu items are Undo, Cut, Copy, Paste, and Clear.
22Oct99 LdB
---------------------------------------------------------------------}
FUNCTION StdEditMenuItems (Next: PMenuItem): PMenuItem;

{-StdWindowMenuItems-------------------------------------------------
Returns a pointer to a list of menu items for a standard Window menu.
The standard Window menu items are Tile, Cascade, Close All,
Size/Move, Zoom, Next, Previous, and Close.
22Oct99 LdB
---------------------------------------------------------------------}
FUNCTION StdWindowMenuItems (Next: PMenuItem): PMenuItem;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           OBJECT REGISTER ROUTINES                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{-RegisterApp--------------------------------------------------------
Calls RegisterType for each of the object types defined in this unit.
22oct99 LdB
---------------------------------------------------------------------}
PROCEDURE RegisterApp;

{***************************************************************************}
{                           OBJECT REGISTRATION                             }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                      TBackGround STREAM REGISTRATION                      }
{---------------------------------------------------------------------------}
CONST
  RBackGround: TStreamRec = (
     ObjType: 30;                                     { Register id = 30 }
     {$IFDEF BP_VMTLink}                              { BP style VMT link }
     VmtLink: Ofs(TypeOf(TBackGround)^);
     {$ELSE}                                          { Alt style VMT link }
     VmtLink: TypeOf(TBackGround);
     {$ENDIF}
     Load:    @TBackGround.Load;                      { Object load method }
     Store:   @TBackGround.Store                      { Object store method }
  );

{---------------------------------------------------------------------------}
{                       TDeskTop STREAM REGISTRATION                        }
{---------------------------------------------------------------------------}
CONST
  RDeskTop: TStreamRec = (
     ObjType: 31;                                     { Register id = 31 }
     {$IFDEF BP_VMTLink}                              { BP style VMT link }
     VmtLink: Ofs(TypeOf(TDeskTop)^);
     {$ELSE}                                          { Alt style VMT link }
     VmtLink: TypeOf(TDeskTop);
     {$ENDIF}
     Load:    @TDeskTop.Load;                         { Object load method }
     Store:   @TDeskTop.Store                         { Object store method }
  );

{***************************************************************************}
{                        INITIALIZED PUBLIC VARIABLES                       }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                       INITIALIZED PUBLIC VARIABLES                        }
{---------------------------------------------------------------------------}
CONST
   AppPalette: Integer = apColor;                     { Application colour }
   Desktop: PDeskTop = Nil;                           { Desktop object }
   MenuBar: PMenuView = Nil;                          { Application menu }
   StatusLine: PStatusLine = Nil;                     { App status line }
   Application : PApplication = Nil;                  { Application object }

{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
                                IMPLEMENTATION
{<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}

{***************************************************************************}
{                        PRIVATE DEFINED CONSTANTS                          }
{***************************************************************************}

{***************************************************************************}
{                      PRIVATE INITIALIZED VARIABLES                        }
{***************************************************************************}

{---------------------------------------------------------------------------}
{                      INITIALIZED PRIVATE VARIABLES                        }
{---------------------------------------------------------------------------}
CONST Pending: TEvent = (What: evNothing);            { Pending event }

{***************************************************************************}
{                        PRIVATE INTERNAL ROUTINES                          }
{***************************************************************************}
{$IFDEF OS_WINDOWS}
{---------------------------------------------------------------------------}
{  AppMsgHandler -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 13May98 LdB     }
{---------------------------------------------------------------------------}
FUNCTION TvAppMsgHandler (Wnd: hWnd; iMessage, wParam: Sw_Word;
lParam: LongInt): LongInt; {$IFDEF BIT_16} EXPORT; {$ELSE} STDCALL; {$ENDIF}
VAR Li: LongInt; Min, MAx: TPoint; Event: TEvent; P: PView; Wp: ^TWindowPos;
    Mm: ^TMinMaxInfo;
BEGIN
   {$IFDEF BIT_16}                                    { 16 BIT CODE }
   PtrRec(P).Seg := GetProp(Wnd, ViewSeg);            { Fetch seg property }
   PtrRec(P).Ofs := GetProp(Wnd, ViewOfs);            { Fetch ofs property }
   {$ENDIF}
   {$IFDEF BIT_32}                                    { 32 BIT CODE }
   LongInt(P) := GetProp(Wnd, ViewPtr);               { Fetch view property }
   {$ENDIF}
   TvAppMsgHandler := 0;                              { Preset zero return }
   Event.What := evNothing;                           { Preset no event }
   Case iMessage Of
     WM_Destroy:;                                     { Destroy window }
     WM_Close: Begin
       Event.What := evCommand;                       { Command event }
       Event.Command := cmQuit;                       { Quit command }
       Event.InfoPtr := Nil;                          { Clear info ptr }
     End;
     WM_GetMinMaxInfo: Begin                          { Get minmax info }
       TvAppMsgHandler := DefWindowProc(Wnd,
         iMessage, wParam, lParam);                   { Default handler }
       Mm := Pointer(lParam);                         { Create pointer }
       Mm^.ptMaxSize.X := SysScreenWidth;             { Max x size }
       Mm^.ptMaxSize.Y := SysScreenHeight;            { Max y size }
       Mm^.ptMinTrackSize.X := MinWinSize.X *
         SysFontWidth;                                { Drag min x size }
       Mm^.ptMinTrackSize.Y := MinWinSize.Y *
         SysFontHeight;                               { Drag min y size }
       Mm^.ptMaxTrackSize.X := SysScreenWidth;        { Drag max x size }
       Mm^.ptMaxTrackSize.Y := SysScreenHeight;       { Drag max y size }
     End;
     Else Begin                                       { Unhandled message }
       TvAppMsgHandler := DefWindowProc(Wnd,
         iMessage, wParam, lParam);                   { Default handler }
       Exit;                                          { Now exit }
     End;
   End;
   If (Event.What <> evNothing) Then                  { Check any FV event }
     PutEventInQueue(Event);                          { Put event in queue }
END;
{$ENDIF}
{$IFDEF OS_OS2}                                       { OS2 CODE }
FUNCTION TvAppMsgHandler(Wnd: HWnd; Msg: ULong; Mp1, Mp2: MParam): MResult; CDECL;
VAR Event: TEvent; P: PView;
BEGIN
   Event.What := evNothing;                           { Preset no event }
   TvAppMsgHandler := 0;                              { Preset zero return }
   Case Msg Of
     WM_Destroy:;                                     { Destroy window }
     WM_Close: Begin
       Event.What := evCommand;                       { Command event }
       Event.Command := cmQuit;                       { Quit command }
       Event.InfoPtr := Nil;                          { Clear info ptr }
     End;
     Else Begin                                       { Unhandled message }
       TvAppMsgHandler := WinDefWindowProc(Wnd,
         Msg, Mp1, Mp2);                              { Call std handler }
       Exit;                                          { Now exit }
     End;
   End;
   If (Event.What <> evNothing) Then                  { Check any FV event }
     PutEventInQueue(Event);                          { Put event in queue }
END;
{$ENDIF}

{---------------------------------------------------------------------------}
{  Tileable -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB          }
{---------------------------------------------------------------------------}
FUNCTION Tileable (P: PView): Boolean;
BEGIN
   Tileable := (P^.Options AND ofTileable <> 0) AND   { View is tileable }
     (P^.State AND sfVisible <> 0);                   { View is visible }
END;

{---------------------------------------------------------------------------}
{  ISqr -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
FUNCTION ISqr (X: Sw_Integer): Sw_Integer;
VAR I: Sw_Integer;
BEGIN
   I := 0;                                            { Set value to zero }
   Repeat
     Inc(I);                                          { Inc value }
   Until (I * I > X);                                 { Repeat till Sqr > X }
   ISqr := I - 1;                                     { Return result }
END;

{---------------------------------------------------------------------------}
{  MostEqualDivisors -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB }
{---------------------------------------------------------------------------}
PROCEDURE MostEqualDivisors (N: Integer; Var X, Y: Integer; FavorY: Boolean);
VAR I: Integer;
BEGIN
   I := ISqr(N);                                      { Int square of N }
   If ((N MOD I) <> 0) Then                           { Initial guess }
     If ((N MOD (I+1)) = 0) Then Inc(I);              { Add one row/column }
   If (I < (N DIV I)) Then I := N DIV I;              { In first page }
   If FavorY Then Begin                               { Horz preferred }
     X := N DIV I;                                    { Calc x position }
     Y := I;                                          { Set y position  }
   End Else Begin                                     { Vert preferred }
     Y := N DIV I;                                    { Calc y position }
     X := I;                                          { Set x position }
   End;
END;

{***************************************************************************}
{                               OBJECT METHODS                              }
{***************************************************************************}

{--TBackGround--------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TBackGround.Init (Var Bounds: TRect; APattern: Char);
BEGIN
   Inherited Init(Bounds);                            { Call ancestor }
   GrowMode := gfGrowHiX + gfGrowHiY;                 { Set grow modes }
   Pattern := APattern;                               { Hold pattern }
END;

{--TBackGround--------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TBackGround.Load (Var S: TStream);
BEGIN
   Inherited Load(S);                                 { Call ancestor }
   S.Read(Pattern, SizeOf(Pattern));                  { Read pattern data }
END;

{--TBackGround--------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
FUNCTION TBackGround.GetPalette: PPalette;
{$IFDEF PPC_DELPHI3}                                  { DELPHI3+ COMPILER }
CONST P: String = CBackGround;                        { Possible huge string }
{$ELSE}                                               { OTHER COMPILERS }
CONST P: String[Length(CBackGround)] = CbackGround;   { Always normal string }
{$ENDIF}
BEGIN
   GetPalette := @P;                                  { Return palette }
END;

procedure TBackground.DrawbackGround;
var
  B: TDrawBuffer;
begin
  MoveChar(B, Pattern, GetColor($01), Size.X);
  WriteLine(0, 0, Size.X, Size.Y, B);
end;

{--TBackGround--------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TBackGround.Store (Var S: TStream);
BEGIN
   TView.Store(S);                                    { TView store called }
   S.Write(Pattern, SizeOf(Pattern));                 { Write pattern data }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TDesktop OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TDesktop-----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TDesktop.Init (Var Bounds: Objects.TRect);
BEGIN
   Inherited Init(Bounds);                            { Call ancestor }
   GrowMode := gfGrowHiX + gfGrowHiY;                 { Set growmode }
   {GOptions := GOptions AND NOT goNoDrawView;}         { This group draws }
   InitBackground;                                    { Create background }
   If (Background <> Nil) Then Insert(Background);    { Insert background }
END;

{--TDesktop-----------------------------------------------------------------}
{  Load -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TDesktop.Load (Var S: TStream);
BEGIN
   Inherited Load(S);                                 { Call ancestor }
   GetSubViewPtr(S, Background);                      { Load background }
   S.Read(TileColumnsFirst, SizeOf(TileColumnsFirst));{ Read data }
END;

{--TDesktop-----------------------------------------------------------------}
{  TileError -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB         }
{---------------------------------------------------------------------------}
PROCEDURE TDeskTop.TileError;
BEGIN                                                 { Abstract method }
END;

{--TDesktop-----------------------------------------------------------------}
{  InitBackGround -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB    }
{---------------------------------------------------------------------------}
PROCEDURE TDesktop.InitBackground;
{$IFNDEF OS_WINDOWS} CONST Ch: Char = #176; {$ELSE} CONST Ch: Char = #167; {$ENDIF}
VAR R: TRect;
BEGIN                                                 { Compatability only }
   getExtent(R);
   BackGround := New(PbackGround, Init(R, Ch));
END;

{--TDesktop-----------------------------------------------------------------}
{  Tile -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TDeskTop.Tile (Var R: TRect);
VAR NumCols, NumRows, NumTileable, LeftOver, TileNum: Integer;

   FUNCTION DividerLoc (Lo, Hi, Num, Pos: Integer): Integer;
   BEGIN
     DividerLoc := LongInt( LongInt(Hi - Lo) * Pos)
       DIV Num + Lo;                                  { Calc position }
   END;

   PROCEDURE DoCountTileable (P: PView); FAR;
   BEGIN
     If Tileable(P) Then Inc(NumTileable);            { Count tileable views }
   END;

   PROCEDURE CalcTileRect (Pos: Integer; Var NR: TRect);
   VAR X, Y, D: Integer;
   BEGIN
     D := (NumCols - LeftOver) * NumRows;             { Calc d value }
     If (Pos<D) Then Begin
       X := Pos DIV NumRows; Y := Pos MOD NumRows;    { Calc positions }
     End Else Begin
       X := (Pos - D) div (NumRows + 1) +
         (NumCols - LeftOver);                        { Calc x position }
       Y := (Pos - D) mod (NumRows + 1);              { Calc y position }
     End;
     NR.A.X := DividerLoc(R.A.X, R.B.X, NumCols, X);  { Top left x position }
     NR.B.X := DividerLoc(R.A.X, R.B.X, NumCols, X+1);{ Right x position }
     If (Pos >= D) Then Begin
       NR.A.Y := DividerLoc(R.A.Y, R.B.Y,NumRows+1,Y);{ Top y position }
       NR.B.Y := DividerLoc(R.A.Y, R.B.Y, NumRows+1,
        Y+1);                                         { Bottom y position }
     End Else Begin
       NR.A.Y := DividerLoc(R.A.Y, R.B.Y,NumRows,Y);  { Top y position }
       NR.B.Y := DividerLoc(R.A.Y, R.B.Y, NumRows,
        Y+1);                                         { Bottom y position }
     End;
   END;

   PROCEDURE DoTile(P: PView); FAR;
   VAR PState: Word; R: TRect;
   BEGIN
     If Tileable(P) Then Begin
       CalcTileRect(TileNum, R);                      { Calc tileable area }
       PState := P^.State;                            { Hold view state }
       P^.State := P^.State AND NOT sfVisible;        { Temp not visible }
       P^.Locate(R);                                  { Locate view }
       P^.State := PState;                            { Restore view state }
       Dec(TileNum);                                  { One less to tile }
     End;
   END;

BEGIN
   NumTileable := 0;                                  { Zero tileable count }
   ForEach(@DoCountTileable);                         { Count tileable views }
   If (NumTileable>0) Then Begin
     MostEqualDivisors(NumTileable, NumCols, NumRows,
     NOT TileColumnsFirst);                           { Do pre calcs }
     If ((R.B.X - R.A.X) DIV NumCols = 0) OR
     ((R.B.Y - R.A.Y) DIV NumRows = 0) Then TileError { Can't tile }
     Else Begin
       LeftOver := NumTileable MOD NumCols;           { Left over count }
       TileNum := NumTileable-1;                      { Tileable views }
       ForEach(@DoTile);                              { Tile each view }
       DrawView;                                      { Now redraw }
     End;
   End;
END;

{--TDesktop-----------------------------------------------------------------}
{  Store -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TDesktop.Store (Var S: TStream);
BEGIN
   TGroup.Store(S);                                   { Call group store }
   PutSubViewPtr(S, Background);                      { Store background }
   S.Write(TileColumnsFirst,SizeOf(TileColumnsFirst));{ Write data }
END;

{--TDesktop-----------------------------------------------------------------}
{  Cascade -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB           }
{---------------------------------------------------------------------------}
PROCEDURE TDeskTop.Cascade (Var R: TRect);
VAR CascadeNum: Integer; LastView: PView; Min, Max: TPoint;

   PROCEDURE DoCount (P: PView); FAR;
   BEGIN
     If Tileable(P) Then Begin
       Inc(CascadeNum); LastView := P;                { Count cascadable }
     End;
   END;

   PROCEDURE DoCascade (P: PView); FAR;
   VAR PState: Word; NR: TRect;
   BEGIN
     If Tileable(P) AND (CascadeNum >= 0) Then Begin  { View cascadable }
       NR.Copy(R);                                    { Copy rect area }
       Inc(NR.A.X, CascadeNum);                       { Inc x position }
       Inc(NR.A.Y, CascadeNum);                       { Inc y position }
       PState := P^.State;                            { Hold view state }
       P^.State := P^.State AND NOT sfVisible;        { Temp stop draw }
       P^.Locate(NR);                                 { Locate the view }
       P^.State := PState;                            { Now allow draws }
       Dec(CascadeNum);                               { Dec count }
     End;
   END;

BEGIN
   CascadeNum := 0;                                   { Zero cascade count }
   ForEach(@DoCount);                                 { Count cascadable }
   If (CascadeNum>0) Then Begin
     LastView^.SizeLimits(Min, Max);                  { Check size limits }
     If (Min.X > R.B.X - R.A.X - CascadeNum) OR
     (Min.Y > R.B.Y - R.A.Y - CascadeNum) Then
     TileError Else Begin                             { Check for error }
       Dec(CascadeNum);                               { One less view }
       ForEach(@DoCascade);                           { Cascade view }
       DrawView;                                      { Redraw now }
     End;
   End;
END;

{--TDesktop-----------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 11May98 LdB       }
{---------------------------------------------------------------------------}
PROCEDURE TDesktop.HandleEvent (Var Event: TEvent);
BEGIN
   Inherited HandleEvent(Event);                      { Call ancestor }
   If (Event.What = evCommand) Then Begin
     Case Event.Command of                            { Command event }
       cmNext: FocusNext(False);                      { Focus next view }
       cmPrev: If (BackGround <> Nil) Then Begin
         If Valid(cmReleasedFocus) Then
          Current^.PutInFrontOf(Background);          { Focus last view }
       End Else FocusNext(True);                      { Focus prior view }
       Else Exit;
     End;
     ClearEvent(Event);                               { Clear the event }
   End;
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                          TProgram OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

CONST TvProgramClassName = 'TVPROGRAM'+#0;            { TV program class }

{--TProgram-----------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TProgram.Init;
VAR I: Integer; R: TRect; {$IFDEF OS_WINDOWS} ODc: HDc; {$ENDIF}
BEGIN
   Application := @Self;                              { Set application ptr }
   InitScreen;                                        { Initialize screen }
  { R.Assign(0, 0, ScreenWidth, ScreenHeight); }        { Full screen area }
   R.A.X := 0;
   R.A.Y := 0;
   R.B.X := -(SysScreenWidth);
   R.B.Y := -(SysScreenHeight);
   Inherited Init(R);                                 { Call ancestor }
   State := sfVisible + sfSelected + sfFocused +
      sfModal + sfExposed;                            { Deafult states }
   Options := 0;                                      { No options set }
   {$IFDEF OS_WINDOWS}                                { WIN/NT CODE }
   ODc := GetDc(GetDeskTopWindow);                    { Get desktop context }
   For I := 0 To 15 Do Begin
     ColBrush[I] := CreateSolidBrush(GetNearestColor(
       ODc, ColRef[I]));                              { Create brushes }
     ColPen[I] := CreatePen(ps_Solid, 1,
       GetNearestColor(ODc, ColRef[I]));              { Create pens }
   End;
   ReleaseDC(GetDeskTopWindow, ODc);                  { Release context }
   CreateWindowNow(sw_ShowNormal);                    { Create app window }
   {$ENDIF}
   {$IFDEF OS_OS2}
   CreateWindowNow(swp_Show);                         { Create app window }
   {$ENDIF}
   {$IFNDEF OS_DOS}                                   { WIN/NT/OS2 CODE }
   AppWindow := HWindow;
   Size.X := ScreenWidth;
   Size.Y := ScreenHeight;
   RawSize.X := ScreenWidth * SysFontWidth;
   RawSize.Y := ScreenHeight * SysFontHeight - 1;
   {$ENDIF}
   InitStatusLine;                                    { Init status line }
   If (StatusLine <> Nil) Then Insert(StatusLine);    { Insert status line }
   InitMenuBar;                                       { Create a bar menu }
   If (MenuBar <> Nil) Then Insert(MenuBar);          { Insert menu bar }
   InitDesktop;                                       { Create desktop }
   If (Desktop <> Nil) Then Insert(Desktop);          { Insert desktop }
END;

{--TProgram-----------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
DESTRUCTOR TProgram.Done;
VAR I: Integer;
BEGIN
   If (Desktop <> Nil) Then Dispose(Desktop, Done);   { Destroy desktop }
   If (MenuBar <> Nil) Then Dispose(MenuBar, Done);   { Destroy menu bar }
   If (StatusLine <> Nil) Then
     Dispose(StatusLine, Done);                       { Destroy status line }
   Application := Nil;                                { Clear application }
   Inherited Done;                                    { Call ancestor }
  {$IFDEF OS_WINDOWS}                                 { WIN/NT CODE }
   For I := 0 To 15 Do DeleteObject(ColBrush[I]);     { Delete brushes }
   For I := 0 To 15 Do DeleteObject(ColPen[I]);       { Delete pens }
   AppWindow := 0;                                    { Zero app window }
   {$ENDIF}
END;

{--TProgram-----------------------------------------------------------------}
{  GetPalette -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
FUNCTION TProgram.GetPalette: PPalette;
CONST P: Array[apColor..apMonochrome] Of String = (CAppColor, CAppBlackWhite,
  CAppMonochrome);
BEGIN
   GetPalette := @P[AppPalette];                      { Return palette }
END;

{--TProgram-----------------------------------------------------------------}
{  CanMoveFocus -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 23Sep97 LdB      }
{---------------------------------------------------------------------------}
FUNCTION TProgram.CanMoveFocus: Boolean;
BEGIN
   If (Desktop <> Nil) Then                           { Valid desktop view }
     CanMovefocus := DeskTop^.Valid(cmReleasedFocus)  { Check focus move }
     Else CanMoveFocus := True;                       { No desktop who cares! }
END;

{--TProgram-----------------------------------------------------------------}
{  ValidView -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB         }
{---------------------------------------------------------------------------}
FUNCTION TProgram.ValidView (P: PView): PView;
BEGIN
   ValidView := Nil;                                  { Preset failure }
   If (P <> Nil) Then Begin
     If LowMemory Then Begin                          { Check memroy }
       Dispose(P, Done);                              { Dispose view }
       OutOfMemory;                                   { Call out of memory }
       Exit;                                          { Now exit }
     End;
     If NOT P^.Valid(cmValid) Then Begin              { Check view valid }
       Dispose(P, Done);                              { Dipose view }
       Exit;                                          { Now exit }
     End;
     ValidView := P;                                  { Return view }
   End;
END;

{--TProgram-----------------------------------------------------------------}
{  InsertWindow -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB      }
{---------------------------------------------------------------------------}
FUNCTION TProgram.InsertWindow (P: PWindow): PWindow;
BEGIN
   InsertWindow := Nil;                               { Preset failure }
   If (ValidView(P) <> Nil) Then                      { Check view valid }
     If (CanMoveFocus) AND (Desktop <> Nil)           { Can we move focus }
     Then Begin
       Desktop^.Insert(P);                            { Insert window }
       InsertWindow := P;                             { Return view ptr }
     End Else Dispose(P, Done);                       { Dispose view }
END;

{--TProgram-----------------------------------------------------------------}
{  ExecuteDialog -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB     }
{---------------------------------------------------------------------------}
FUNCTION TProgram.ExecuteDialog (P: PDialog; Data: Pointer): Word;
VAR ExecResult: Word;
BEGIN
   ExecuteDialog := cmCancel;                         { Preset cancel }
   If (ValidView(P) <> Nil) Then Begin                { Check view valid }
     If (Data <> Nil) Then P^.SetData(Data^);         { Set data }
     If (P <> Nil) Then P^.SelectDefaultView;         { Select default }
     ExecResult := Desktop^.ExecView(P);              { Execute view }
     If (ExecResult <> cmCancel) AND (Data <> Nil)
       Then P^.GetData(Data^);                        { Get data back }
     Dispose(P, Done);                                { Dispose of dialog }
     ExecuteDialog := ExecResult;                     { Return result }
   End;
END;

{--TProgram-----------------------------------------------------------------}
{  Run -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB               }
{---------------------------------------------------------------------------}
PROCEDURE TProgram.Run;
BEGIN
   Execute;                                           { Call execute }
END;

{--TProgram-----------------------------------------------------------------}
{  Idle -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Oct99 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TProgram.Idle;
BEGIN
   If (StatusLine <> Nil) Then StatusLine^.Update;    { Update statusline }
   If CommandSetChanged Then Begin                    { Check command change }
     Message(@Self, evBroadcast, cmCommandSetChanged,
       Nil);                                          { Send message }
     CommandSetChanged := False;                      { Clear flag }
   End;
END;

{--TProgram-----------------------------------------------------------------}
{  InitScreen -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB        }
{---------------------------------------------------------------------------}
PROCEDURE TProgram.InitScreen;
BEGIN
   If (Lo(ScreenMode) <> smMono) Then Begin           { Coloured mode }
     If (ScreenMode AND smFont8x8 <> 0) Then
       ShadowSize.X := 1 Else                         { Single bit shadow }
       ShadowSize.X := 2;                             { Double size }
     ShadowSize.Y := 1; ShowMarkers := False;         { Set variables }
     If (Lo(ScreenMode) = smBW80) Then
       AppPalette := apBlackWhite Else                { B & W palette }
       AppPalette := apColor;                         { Coloured palette }
   End Else Begin
     ShadowSize.X := 0;                               { No x shadow size }
     ShadowSize.Y := 0;                               { No y shadow size }
     ShowMarkers := True;                             { Show markers }
     AppPalette := apMonochrome;                      { Mono palette }
   End;
END;

{--TProgram-----------------------------------------------------------------}
{  InitDeskTop -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB       }
{---------------------------------------------------------------------------}
PROCEDURE TProgram.InitDesktop;
VAR R: TRect;
BEGIN
   GetExtent(R);                                      { Get view extent }
   If (MenuBar <> Nil) Then Inc(R.A.Y);               { Adjust top down }
   If (StatusLine <> Nil) Then Dec(R.B.Y);            { Adjust bottom up }
   DeskTop := New(PDesktop, Init(R));                 { Create desktop }
END;

{--TProgram-----------------------------------------------------------------}
{  OutOfMemory -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 08May98 LdB       }
{---------------------------------------------------------------------------}
PROCEDURE TProgram.OutOfMemory;
BEGIN                                                 { Abstract method }
END;

{--TProgram-----------------------------------------------------------------}
{  InitMenuBar -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB       }
{---------------------------------------------------------------------------}
PROCEDURE TProgram.InitMenuBar;
VAR R: TRect;
BEGIN
   GetExtent(R);                                      { Get view extents }
   R.B.Y := R.A.Y + 1;                                { One line high  }
   MenuBar := New(PMenuBar, Init(R, Nil));            { Create menu bar }
END;

{--TProgram-----------------------------------------------------------------}
{  InitStatusLine -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB    }
{---------------------------------------------------------------------------}
PROCEDURE TProgram.InitStatusLine;
VAR R: TRect;
BEGIN
   GetExtent(R);                                      { Get view extents }
   R.A.Y := R.B.Y - 1;                                { One line high }
   New(StatusLine, Init(R,
     NewStatusDef(0, $FFFF,
       NewStatusKey('~Alt-X~ Exit', kbAltX, cmQuit,
       StdStatusKeys(Nil)), Nil)));                   { Default status line }
END;

{--TProgram-----------------------------------------------------------------}
{  SetScreenMode -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Oct99 LdB     }
{---------------------------------------------------------------------------}
PROCEDURE TProgram.SetScreenMode (Mode: Word);
BEGIN                                                 { Compatability only }
END;

{--TProgram-----------------------------------------------------------------}
{  PutEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TProgram.PutEvent (Var Event: TEvent);
BEGIN
   Pending := Event;                                  { Set pending event }
END;

{--TProgram-----------------------------------------------------------------}
{  GetEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 10May98 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TProgram.GetEvent (Var Event: TEvent);
BEGIN
   Event.What := evNothing;
   If (Event.What = evNothing) Then Begin
     If (Pending.What <> evNothing) Then Begin        { Pending event }
       Event := Pending;                              { Load pending event }
       Pending.What := evNothing;                     { Clear pending event }
     End Else Begin
       NextQueuedEvent(Event);                        { Next queued event }
       If (Event.What = evNothing) Then Begin
         GetKeyEvent(Event);                          { Fetch key event }
         If (Event.What = evNothing) Then Begin       { No mouse event }
           GetMouseEvent(Event);                      { Load mouse event }
           If (Event.What = evNothing) Then Idle;     { Idle if no event }
         End;
       End;
     End;
   End;
END;

{--TProgram-----------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 12Sep97 LdB       }
{---------------------------------------------------------------------------}
PROCEDURE TProgram.HandleEvent (Var Event: TEvent);
VAR I: Word; C: Char;
BEGIN
   If (Event.What = evKeyDown) Then Begin             { Key press event }
     C := GetAltChar(Event.KeyCode);                  { Get alt char code }
     If (C >= '1') AND (C <= '9') Then
       If (Message(Desktop, evBroadCast, cmSelectWindowNum,
         Pointer(Byte(C) - $30)) <> Nil)              { Select window }
         Then ClearEvent(Event);                      { Clear event }
   End;
   Inherited HandleEvent(Event);                      { Call ancestor }
   If (Event.What = evCommand) AND                    { Command event }
   (Event.Command = cmQuit) Then Begin                { Quit command }
      EndModal(cmQuit);                               { Endmodal operation }
      ClearEvent(Event);                              { Clear event }
   End;
END;

{$IFNDEF OS_DOS}
{***************************************************************************}
{                  TProgram OBJECT WIN/NT/OS2 ONLY METHODS                  }
{***************************************************************************}

{--TProgram-----------------------------------------------------------------}
{  GetClassText -> Platforms WIN/NT/OS2 - Checked 18Mar98 LdB               }
{---------------------------------------------------------------------------}
FUNCTION TProgram.GetClassText: String;
VAR S: String; {$IFDEF OS_OS2} I: Integer; {$ENDIF}
BEGIN
   {$IFDEF OS_WINDOWS}                                { WIN/NT CODE }
     {$IFDEF PPC_DELPHI3}                             { DELPHI3+ CODE }
     SetLength(S, 255);                               { Make string not empty }
     SetLength(S, GetModuleFilename( 0, PChar(S),
       Length(S) ) );                                 { Fetch module name }
     {$ELSE}                                          { OTHER COMPILERS }
     S[0] := Chr(GetModuleFileName(HInstance, @S[1],
       255));                                         { Fetch module name }
     {$ENDIF}
   {$ENDIF}
   {$IFDEF OS_OS2}                                    { OS2 CODE }
   WinQuerySessionTitle(Anchor, 0, @S[1], 255);       { Fetch session name }
   I := 1;                                            { Start on first }
   While (S[I] <> #0) AND (I<255) Do Inc(I);          { Find pchar end }
   S[0] := Chr(I);                                    { Set string length }
   {$ENDIF}
   GetClassText := S;                                 { Return the string }
END;

{--TProgram-----------------------------------------------------------------}
{  GetClassName -> Platforms WIN/NT/OS2 - Updated 13May98 LdB               }
{---------------------------------------------------------------------------}
FUNCTION TProgram.GetClassName: String;
BEGIN
   GetClassName := TvProgramClassName;                { Program class name }
END;

{--TProgram-----------------------------------------------------------------}
{  GetClassAttr -> Platforms WIN/NT/OS2 - Checked 17Mar98 LdB               }
{---------------------------------------------------------------------------}
FUNCTION TProgram.GetClassAttr: LongInt;
VAr Li: LongInt;
BEGIN
   {$IFDEF OS_WINDOWS}                                { WIN/NT CODE }
   Li := Inherited GetClassAttr;                      { Call ancestor }
   Li := Li AND NOT ws_Child;                         { Not child view }
   GetClassAttr := Li OR ws_OverlappedWindow;         { Overlapping window }
   {$ENDIF}
   {$IFDEF OS_OS2}                                    { OS2 CODE }
   GetClassAttr := fcf_TitleBar OR fcf_SysMenu OR
     fcf_SizeBorder OR fcf_MinMax OR fcf_TaskList OR
     fcf_NoByteAlign;                                 { Window defaults }
   {$ENDIF}
END;

{--TProgram-----------------------------------------------------------------}
{  GetMsghandler -> Platforms WIN/NT/OS2 - Updated 13May98 LdB              }
{---------------------------------------------------------------------------}
FUNCTION TProgram.GetMsgHandler: Pointer;
BEGIN
   GetMsgHandler := @TvAppMsgHandler;                 { Application handler }
END;

{$ENDIF}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                        TApplication OBJECT METHODS                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TApplication-------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
CONSTRUCTOR TApplication.Init;
BEGIN
   InitMemory;                                        { Start memory up }
   InitVideo;                                         { Start video up }
   InitEvents;                                        { Start event drive }
   InitSysError;                                      { Start system error }
   InitHistory;                                       { Start history up }
   Inherited Init;                                    { Call ancestor }
END;

{--TApplication-------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
DESTRUCTOR TApplication.Done;
BEGIN
   Inherited Done;                                    { Call ancestor }
   DoneHistory;                                       { Close history }
   DoneSysError;                                      { Close system error }
   DoneEvents;                                        { Close event drive }
   DoneVideo;                                         { Close video }
   DoneMemory;                                        { Close memory }
END;

{--TApplication-------------------------------------------------------------}
{  Tile -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TApplication.Tile;
VAR R: TRect;
BEGIN
   GetTileRect(R);                                    { Tileable area }
   If (Desktop <> Nil) Then Desktop^.Tile(R);         { Tile desktop }
END;

{--TApplication-------------------------------------------------------------}
{  Cascade -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB           }
{---------------------------------------------------------------------------}
PROCEDURE TApplication.Cascade;
VAR R: TRect;
BEGIN
   GetTileRect(R);                                    { Cascade area }
   If (Desktop <> Nil) Then Desktop^.Cascade(R);      { Cascade desktop }
END;

{--TApplication-------------------------------------------------------------}
{  DosShell -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 25Oct99 LdB          }
{---------------------------------------------------------------------------}
PROCEDURE TApplication.DosShell;
BEGIN                                                 { Compatability only }
END;

{--TApplication-------------------------------------------------------------}
{  GetTileRect -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB       }
{---------------------------------------------------------------------------}
PROCEDURE TApplication.GetTileRect (Var R: TRect);
BEGIN
   If (DeskTop <> Nil) Then Desktop^.GetExtent(R)     { Desktop extents }
     Else GetExtent(R);                               { Our extents }
END;

{--TApplication-------------------------------------------------------------}
{  HandleEvent -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB       }
{---------------------------------------------------------------------------}
PROCEDURE TApplication.HandleEvent (Var Event: TEvent);
BEGIN
   Inherited HandleEvent(Event);                      { Call ancestor }
   If (Event.What = evCommand) Then Begin
     Case Event.Command Of
       cmTile: Tile;                                  { Tile request }
       cmCascade: Cascade;                            { Cascade request }
       cmDosShell: DosShell;                          { DOS shell request }
       Else Exit;                                     { Unhandled exit }
     End;
     ClearEvent(Event);                               { Clear the event }
   End;
END;

{***************************************************************************}
{                            INTERFACE ROUTINES                             }
{***************************************************************************}

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                STANDARD MENU AND STATUS LINES ROUTINES                    }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  StdStatusKeys -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB     }
{---------------------------------------------------------------------------}
FUNCTION StdStatusKeys (Next: PStatusItem): PStatusItem;
BEGIN
   StdStatusKeys :=
     NewStatusKey('', kbAltX, cmQuit,
     NewStatusKey('', kbF10, cmMenu,
     NewStatusKey('', kbAltF3, cmClose,
     NewStatusKey('', kbF5, cmZoom,
     NewStatusKey('', kbCtrlF5, cmResize,
     NewStatusKey('', kbF6, cmNext,
     NewStatusKey('', kbShiftF6, cmPrev,
     Next)))))));
END;

{---------------------------------------------------------------------------}
{  StdFileMenuItems -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB  }
{---------------------------------------------------------------------------}
FUNCTION StdFileMenuItems (Next: PMenuItem): PMenuItem;
BEGIN
   StdFileMenuItems :=
     NewItem('~N~ew', '', kbNoKey, cmNew, hcNew,
     NewItem('~O~pen...', 'F3', kbF3, cmOpen, hcOpen,
     NewItem('~S~ave', 'F2', kbF2, cmSave, hcSave,
     NewItem('S~a~ve as...', '', kbNoKey, cmSaveAs, hcSaveAs,
     NewItem('Save a~l~l', '', kbNoKey, cmSaveAll, hcSaveAll,
     NewLine(
     NewItem('~C~hange dir...', '', kbNoKey, cmChangeDir, hcChangeDir,
     NewItem('OS shell', '', kbNoKey, cmDosShell, hcDosShell,
     NewItem('E~x~it', 'Alt+X', kbAltX, cmQuit, hcExit,
     Next)))))))));
END;

{---------------------------------------------------------------------------}
{  StdEditMenuItems -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB  }
{---------------------------------------------------------------------------}
FUNCTION StdEditMenuItems (Next: PMenuItem): PMenuItem;
BEGIN
   StdEditMenuItems :=
     NewItem('~U~ndo', '', kbAltBack, cmUndo, hcUndo,
     NewLine(
     NewItem('Cu~t~', 'Shift+Del', kbShiftDel, cmCut, hcCut,
     NewItem('~C~opy', 'Ctrl+Ins', kbCtrlIns, cmCopy, hcCopy,
     NewItem('~P~aste', 'Shift+Ins', kbShiftIns, cmPaste, hcPaste,
     NewItem('C~l~ear', 'Ctrl+Del', kbCtrlDel, cmClear, hcClear,
     Next))))));
END;

{---------------------------------------------------------------------------}
{ StdWindowMenuItems -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB }
{---------------------------------------------------------------------------}
FUNCTION StdWindowMenuItems (Next: PMenuItem): PMenuItem;
BEGIN
   StdWindowMenuItems :=
     NewItem('~T~ile', '', kbNoKey, cmTile, hcTile,
     NewItem('C~a~scade', '', kbNoKey, cmCascade, hcCascade,
     NewItem('Cl~o~se all', '', kbNoKey, cmCloseAll, hcCloseAll,
     NewLine(
     NewItem('~S~ize/Move','Ctrl+F5', kbCtrlF5, cmResize, hcResize,
     NewItem('~Z~oom', 'F5', kbF5, cmZoom, hcZoom,
     NewItem('~N~ext', 'F6', kbF6, cmNext, hcNext,
     NewItem('~P~revious', 'Shift+F6', kbShiftF6, cmPrev, hcPrev,
     NewItem('~C~lose', 'Alt+F3', kbAltF3, cmClose, hcClose,
     Next)))))))));
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                           OBJECT REGISTER ROUTINES                        }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{---------------------------------------------------------------------------}
{  RegisterApp -> Platforms DOS/DPMI/WIN/NT/OS2 - Updated 22Oct99 LdB       }
{---------------------------------------------------------------------------}
PROCEDURE RegisterApp;
BEGIN
   RegisterType(RBackground);                         { Register background }
   RegisterType(RDesktop);                            { Register desktop }
END;

END.
{
 $Log$
 Revision 1.2  2000-08-24 11:43:13  marco
  * Added CVS log and ID entries.


}


