{
    $Id$

    Borland Pascal 7 Compatible CRT Unit for win32

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit crt;

{$mode objfpc}

interface

const
{ CRT modes }
  BW40          = 0;            { 40x25 B/W on Color Adapter }
  CO40          = 1;            { 40x25 Color on Color Adapter }
  BW80          = 2;            { 80x25 B/W on Color Adapter }
  CO80          = 3;            { 80x25 Color on Color Adapter }
  Mono          = 7;            { 80x25 on Monochrome Adapter }
  Font8x8       = 256;          { Add-in for ROM font }

{ Mode constants for 3.0 compatibility }
  C40           = CO40;
  C80           = CO80;

{ Foreground and background color constants }
  Black         = 0;
  Blue          = 1;
  Green         = 2;
  Cyan          = 3;
  Red           = 4;
  Magenta       = 5;
  Brown         = 6;
  LightGray     = 7;

{ Foreground color constants }
  DarkGray      = 8;
  LightBlue     = 9;
  LightGreen    = 10;
  LightCyan     = 11;
  LightRed      = 12;
  LightMagenta  = 13;
  Yellow        = 14;
  White         = 15;

{ Add-in for blinking }
  Blink         = 128;

var

{ Interface variables }
  CheckBreak: Boolean;    { Enable Ctrl-Break }
  CheckEOF: Boolean;      { Enable Ctrl-Z }
  DirectVideo: Boolean;   { Enable direct video addressing }
  CheckSnow: Boolean;     { Enable snow filtering }
  LastMode: Word;         { Current text mode }
  TextAttr: Byte;         { Current text attribute }
  WindMin: Word;          { Window upper left coordinates }
  WindMax: Word;          { Window lower right coordinates }

{ Interface procedures }
procedure AssignCrt(var F: Text);
function KeyPressed: Boolean;
function ReadKey: Char;
procedure TextMode(Mode: Integer);
procedure Window(X1,Y1,X2,Y2: Byte);
procedure GotoXY(X,Y: Byte);
function WhereX: Byte;
function WhereY: Byte;
procedure ClrScr;
procedure ClrEol;
procedure InsLine;
procedure DelLine;
procedure TextColor(Color: Byte);
procedure TextBackground(Color: Byte);
procedure LowVideo;
procedure HighVideo;
procedure NormVideo;
procedure Delay(MS: Word);
procedure Sound(Hz: Word);
procedure NoSound;

{Extra Functions}
procedure cursoron;
procedure cursoroff;
procedure cursorbig;


implementation

uses
  dos,
  windows;


var OutHandle     : THandle;
    InputHandle   : THandle;

    CursorSaveX   : Longint;
    CursorSaveY   : Longint;

    ScreenWidth   : Longint;
    ScreenHeight  : Longint;

    SaveCursorSize: Longint;

{
  definition of textrec is in textrec.inc
}
{$i textrec.inc}

{****************************************************************************
                           Low level Routines
****************************************************************************}

function GetScreenHeight : longint;
var ConsoleInfo: TConsoleScreenBufferinfo;
begin
  FillChar(ConsoleInfo, SizeOf(ConsoleInfo), 0);
  GetConsoleScreenBufferInfo(OutHandle, ConsoleInfo);
  Result := ConsoleInfo.SrWindow.Bottom + 1;
end;


function GetScreenWidth : longint;
var ConsoleInfo: TConsoleScreenBufferInfo;
begin
  FillChar(ConsoleInfo, SizeOf(ConsoleInfo), 0);
  GetConsoleScreenBufferInfo(OutHandle, ConsoleInfo);

  Result := ConsoleInfo.SrWindow.Right + 1;
end;


procedure SetScreenCursor(x,y : longint);
var CurInfo: TCoord;
begin
  FillChar(Curinfo, SizeOf(Curinfo), 0);
  CurInfo.X := X - 1;
  CurInfo.Y := Y - 1;

  SetConsoleCursorPosition(OutHandle, CurInfo);

  CursorSaveX := X - 1;
  CursorSaveY := Y - 1;
end;


procedure GetScreenCursor(var x,y : longint);
begin
  X := CursorSaveX + 1;
  Y := CursorSaveY + 1;
end;


{****************************************************************************
                              Helper Routines
****************************************************************************}


Function WinMinX: Byte;
{
  Current Minimum X coordinate
}
Begin
  WinMinX:=(WindMin and $ff)+1;
End;



Function WinMinY: Byte;
{
  Current Minimum Y Coordinate
}
Begin
  WinMinY:=(WindMin shr 8)+1;
End;



Function WinMaxX: Byte;
{
  Current Maximum X coordinate
}
Begin
  WinMaxX:=(WindMax and $ff)+1;
End;



Function WinMaxY: Byte;
{
  Current Maximum Y coordinate;
}
Begin
  WinMaxY:=(WindMax shr 8) + 1;
End;



Function FullWin:boolean;
{
  Full Screen 80x25? Window(1,1,80,25) is used, allows faster routines
}
begin
  FullWin:=(WindMax-WindMin=$184f);
end;


{****************************************************************************
                             Public Crt Functions
****************************************************************************}


procedure textmode(mode : integer);
begin
  {!!! Not done yet !!! }
end;


Procedure TextColor(Color: Byte);
{
  Switch foregroundcolor
}
Begin
  TextAttr:=(Color and $8f) or (TextAttr and $70);
End;



Procedure TextBackground(Color: Byte);
{
  Switch backgroundcolor
}
Begin
  TextAttr:=(Color shl 4) or (TextAttr and $0f);
End;



Procedure HighVideo;
{
  Set highlighted output.
}
Begin
  TextColor(TextAttr Or $08);
End;



Procedure LowVideo;
{
  Set normal output
}
Begin
  TextColor(TextAttr And $77);
End;



Procedure NormVideo;
{
  Set normal back and foregroundcolors.
}
Begin
  TextColor(7);
  TextBackGround(0);
End;


Procedure GotoXy(X: Byte; Y: Byte);
{
  Go to coordinates X,Y in the current window.
}
Begin
  If (X>0) and (X<=WinMaxX- WinMinX+1) and
     (Y>0) and (Y<=WinMaxY-WinMinY+1) Then
   Begin
     Inc(X,WinMinX-1);
     Inc(Y,WinMinY-1);
     SetScreenCursor(x,y);
   End;
End;


Procedure Window(X1, Y1, X2, Y2: Byte);
{
  Set screen window to the specified coordinates.
}
Begin
  if (X1>X2) or (X2>ScreenWidth) or
     (Y1>Y2) or (Y2>ScreenHeight) then
   exit;
  WindMin:=((Y1-1) Shl 8)+(X1-1);
  WindMax:=((Y2-1) Shl 8)+(X2-1);
  GoToXY(1,1);
End;


procedure ClrScr;
var Temp    : Dword;
    CharInfo: Char;
    Coord   : TCoord;
begin
  Coord.X := 0;
  Coord.Y := 0;

  Temp := 00;
  Charinfo := #32;

  FillConsoleOutputCharacter(OutHandle, CharInfo, WinMaxX * WinMaxY, Coord, @Temp);

  Temp := 07;   { We don't use black because that will disable the cursor under NT4 }
  FillConsoleOutputAttribute(OutHandle, Temp, WinMaxX * WinMaxY, Coord, @Temp);
  Gotoxy(1,1);
end; { proc. ClrScr }


procedure ClrEol;
{
  Clear from current position to end of line.
}
var Temp: Dword;
    CharInfo: Char;
    Coord: TCoord;
    X,Y: Longint;
begin
  GetScreenCursor(x,y);

  CharInfo := #32;
  Coord.X := X;
  Coord.Y := Y;

  FillConsoleOutputCharacter(OutHandle, CharInfo, WinMaxX - (X + 01), Coord, @Temp);
end;



Function WhereX: Byte;
{
  Return current X-position of cursor.
}
var
  x,y : longint;
Begin
  GetScreenCursor(x,y);
  WhereX:=x-WinMinX+1;
End;



Function WhereY: Byte;
{
  Return current Y-position of cursor.
}
var
  x,y : longint;
Begin
  GetScreenCursor(x,y);
  WhereY:=y-WinMinY+1;
End;


{*************************************************************************
                            KeyBoard
*************************************************************************}

var
   ScanCode : char;
   SpecialKey : boolean;

Function RemapScanCode (ScanCode: byte; CtrlKeyState: byte): byte;
  { Several remappings of scancodes are necessary to comply with what
    we get with MSDOS. Special Windows keys, as Alt-Tab, Ctrl-Esc etc.
    are excluded }
var
  AltKey, CtrlKey, ShiftKey: boolean;
const
  {
    Keypad key scancodes:

      Ctrl Norm

      $77  $47 - Home
      $8D  $48 - Up arrow
      $84  $49 - PgUp
      $8E  $4A - -
      $73  $4B - Left Arrow
      $8F  $4C - 5
      $74  $4D - Right arrow
      $4E  $4E - +
      $75  $4F - End
      $91  $50 - Down arrow
      $76  $51 - PgDn
      $92  $52 - Ins
      $93  $53 - Del
  }
  CtrlKeypadKeys: array[$47..$53] of byte =
    ($77, $8D, $84, $8E, $73, $8F, $74, $4E, $75, $91, $76, $92, $93);

begin
  AltKey := ((CtrlKeyState AND
            (RIGHT_ALT_PRESSED OR LEFT_ALT_PRESSED)) > 0);
  CtrlKey := ((CtrlKeyState AND
            (RIGHT_CTRL_PRESSED OR LEFT_CTRL_PRESSED)) > 0);
  ShiftKey := ((CtrlKeyState AND SHIFT_PRESSED) > 0);
  if AltKey then
    case ScanCode of
    // Digits, -, =
    $02..$0D: inc(ScanCode, $76);
    // Function keys
    $3B..$44: inc(Scancode, $2D);
    $57..$58: inc(Scancode, $34);
    // Extended cursor block keys
    $47..$49, $4B, $4D, $4F..$53:
              inc(Scancode, $50);
    // Other keys
    $1C:      Scancode := $A6;   // Enter
    $35:      Scancode := $A4;   // / (keypad and normal!)
    end
  else if CtrlKey then
    case Scancode of
    // Tab key
    $0F:      Scancode := $94;
    // Function keys
    $3B..$44: inc(Scancode, $23);
    $57..$58: inc(Scancode, $32);
    // Keypad keys
    $35:      Scancode := $95;   // \
    $37:      Scancode := $96;   // *
    $47..$53: Scancode := CtrlKeypadKeys[Scancode];
    end
  else if ShiftKey then
    case Scancode of
    // Function keys
    $3B..$44: inc(Scancode, $19);
    $57..$58: inc(Scancode, $30);
    end
  else
    case Scancode of
    // Function keys
    $57..$58: inc(Scancode, $2E); // F11 and F12
  end;
  Result := ScanCode;
end;


function KeyPressed : boolean;
var
  nevents, nread, i: longint;
  buf : TINPUTRECORD;
begin
  KeyPressed := FALSE;
  if ScanCode <> #0 then
    KeyPressed := TRUE
  else
   begin
     nevents:=0;
     GetNumberOfConsoleInputEvents(TextRec(input).Handle,nevents);
     For i := 1 to nevents do
      begin
        ReadConsoleInputA(TextRec(input).Handle,buf,1,nread);
        if buf.EventType = KEY_EVENT then
         if buf.KeyEvent.bKeyDown then
          begin
            KeyPressed := TRUE;
            if ord(buf.KeyEvent.AsciiChar) = 0 then
             begin
               SpecialKey := TRUE;
               ScanCode := Chr(RemapScanCode(Buf.KeyEvent.wVirtualScanCode, Buf.KeyEvent.dwControlKeyState));
             end
            else
             begin
               SpecialKey := FALSE;
               ScanCode := Chr(Ord(buf.KeyEvent.AsciiChar));
             end;
            break;
          end;
      end;
   end;
end;


function ReadKey: char;
begin
  repeat until KeyPressed;
  if SpecialKey then begin
    ReadKey := #0;
    SpecialKey := FALSE;
  end
  else begin
    ReadKey := ScanCode;
    ScanCode := #0;
  end;
end;


{*************************************************************************
                                   Delay
*************************************************************************}

procedure Delay(MS: Word);
begin
  Sleep(ms);
end; { proc. Delay }


procedure sound(hz : word);
begin
  MessageBeep(0); { lame ;-) }
end;


procedure nosound;
begin
end;



{****************************************************************************
                          HighLevel Crt Functions
****************************************************************************}

procedure removeline(y : longint);
var
  ClipRect: TSmallRect;
  SrcRect: TSmallRect;
  DestCoor: TCoord;
  CharInfo: TCharInfo;
begin
  CharInfo.UnicodeChar := 32;
  CharInfo.Attributes := TextAttr;

  SrcRect.Top := Y - 01;
  SrcRect.Left := WinMinX - 1;
  SrcRect.Right := WinMaxX - 1;
  SrcRect.Bottom := WinMaxY - 1;

  DestCoor.X := WinMinX - 1;
  DestCoor.Y := Y - 2;
  ClipRect := SrcRect;

  ScrollConsoleScreenBuffer(OutHandle, SrcRect, ClipRect, DestCoor, CharInfo);
end; { proc. RemoveLine }


procedure delline;
begin
  removeline(wherey);
end; { proc. DelLine }


procedure insline;
var
  ClipRect: TSmallRect;
  SrcRect: TSmallRect;
  DestCoor: TCoord;
  CharInfo: TCharInfo;
  X,Y: Longint;
begin
  GetScreenCursor(X, Y);

  CharInfo.UnicodeChar := 32;
  CharInfo.Attributes := TextAttr;

  SrcRect.Top := Y - 1;
  SrcRect.Left := WinMinX - 1;
  SrcRect.Right := WinMaxX - 1;
  SrcRect.Bottom := WinMaxY - 1;

  DestCoor.X := WinMinX - 1;
  DestCoor.Y := Y;
  ClipRect := SrcRect;

  ScrollConsoleScreenBuffer(OutHandle, SrcRect, ClipRect, DestCoor, CharInfo);
end; { proc. InsLine }




{****************************************************************************
                             Extra Crt Functions
****************************************************************************}

procedure cursoron;
var CursorInfo: TConsoleCursorInfo;
begin
  GetConsoleCursorInfo(OutHandle, CursorInfo);
  CursorInfo.dwSize := SaveCursorSize;
  CursorInfo.bVisible := true;
  SetConsoleCursorInfo(OutHandle, CursorInfo);
end;


procedure cursoroff;
var CursorInfo: TConsoleCursorInfo;
begin
  GetConsoleCursorInfo(OutHandle, CursorInfo);
  CursorInfo.bVisible := false;
  SetConsoleCursorInfo(OutHandle, CursorInfo);
end;


procedure cursorbig;
var CursorInfo: TConsoleCursorInfo;
begin
  GetConsoleCursorInfo(OutHandle, CursorInfo);
  CursorInfo.dwSize := 100;
  CursorInfo.bVisible := true;
  SetConsoleCursorInfo(OutHandle, CursorInfo);
end;


{*****************************************************************************
                          Read and Write routines
*****************************************************************************}

var
  CurrX, CurrY : longint;

procedure WriteChar(c:char);
var
    Cell    : TCharInfo;
    BufSize : Coord;                    { Column-row size of source buffer }
    WritePos: TCoord;                       { Upper-left cell to write from }
    DestRect: TSmallRect;
begin
  Case C of
   #10 : begin
           Inc(CurrY);
         end;
   #13 : begin
           CurrX := WinMinX;
         end; { if }
   #08 : begin
           if CurrX > WinMinX then Dec(CurrX);
         end; { ^H }
   #07 : begin
           // MessagBeep(0);
         end; { ^G }
     else begin
            BufSize.X := 01;
            BufSize.Y := 01;

            WritePos.X := 0;
            WritePos.Y := 0;

            Cell.UniCodeChar := Ord(c);
            Cell.Attributes := TextAttr;

            DestRect.Left := (CurrX - 01);
            DestRect.Top := (CurrY - 01);
            DestRect.Right := (CurrX - 01) + 01;
            DestRect.Bottom := (CurrY - 01);

            WriteConsoleOutput(OutHandle, Cell, BufSize, WritePos, @DestRect);

            Inc(CurrX);
          end; { else }
  end; { case }

  if CurrX > WinMaxX then
    begin
      CurrX := WinMinX;
      Inc(CurrY);
    end; { if }

  While CurrY > WinMaxY do
   begin
     RemoveLine(1);
     Dec(CurrY);
   end; { while }

end;


Function CrtWrite(var f : textrec):integer;
var
  i : longint;
begin
  GetScreenCursor(CurrX,CurrY);
  for i:=0 to f.bufpos-1 do
   WriteChar(f.buffer[i]);
  SetScreenCursor(CurrX,CurrY);
  f.bufpos:=0;
  CrtWrite:=0;
end;


Function CrtRead(Var F: TextRec): Integer;

  procedure BackSpace;
  begin
    if (f.bufpos>0) and (f.bufpos=f.bufend) then
     begin
       WriteChar(#8);
       WriteChar(' ');
       WriteChar(#8);
       dec(f.bufpos);
       dec(f.bufend);
     end;
  end;

var
  ch : Char;
Begin
  GetScreenCursor(CurrX,CurrY);
  f.bufpos:=0;
  f.bufend:=0;
  repeat
    if f.bufpos>f.bufend then
     f.bufend:=f.bufpos;
    SetScreenCursor(CurrX,CurrY);
    ch:=readkey;
    case ch of
    #0 : case readkey of
          #71 : while f.bufpos>0 do
                 begin
                   dec(f.bufpos);
                   WriteChar(#8);
                 end;
          #75 : if f.bufpos>0 then
                 begin
                   dec(f.bufpos);
                   WriteChar(#8);
                 end;
          #77 : if f.bufpos<f.bufend then
                 begin
                   WriteChar(f.bufptr^[f.bufpos]);
                   inc(f.bufpos);
                 end;
          #79 : while f.bufpos<f.bufend do
                 begin
                   WriteChar(f.bufptr^[f.bufpos]);
                   inc(f.bufpos);
                 end;
         end;
    ^S,
    #8 : BackSpace;
    ^Y,
   #27 : begin
           f.bufpos:=f.bufend;
           while f.bufend>0 do
            BackSpace;
         end;
   #13 : begin
           WriteChar(#13);
           WriteChar(#10);
           f.bufptr^[f.bufend]:=#13;
           f.bufptr^[f.bufend+1]:=#10;
           inc(f.bufend,2);
           break;
         end;
   #26 : if CheckEOF then
          begin
            f.bufptr^[f.bufend]:=#26;
            inc(f.bufend);
            break;
          end;
    else
     begin
       if f.bufpos<f.bufsize-2 then
        begin
          f.buffer[f.bufpos]:=ch;
          inc(f.bufpos);
          WriteChar(ch);
        end;
     end;
    end;
  until false;
  f.bufpos:=0;
  SetScreenCursor(CurrX,CurrY);
  CrtRead:=0;
End;


Function CrtReturn:Integer;
Begin
  CrtReturn:=0;
end;


Function CrtClose(Var F: TextRec): Integer;
Begin
  F.Mode:=fmClosed;
  CrtClose:=0;
End;


Function CrtOpen(Var F: TextRec): Integer;
Begin
  If F.Mode=fmOutput Then
   begin
     TextRec(F).InOutFunc:=@CrtWrite;
     TextRec(F).FlushFunc:=@CrtWrite;
   end
  Else
   begin
     F.Mode:=fmInput;
     TextRec(F).InOutFunc:=@CrtRead;
     TextRec(F).FlushFunc:=@CrtReturn;
   end;
  TextRec(F).CloseFunc:=@CrtClose;
  CrtOpen:=0;
End;


procedure AssignCrt(var F: Text);
begin
  Assign(F,'');

  TextRec(F).OpenFunc:=@CrtOpen;
end;


var CursorInfo : TConsoleCursorInfo;
    ConsoleInfo: TConsoleScreenBufferinfo;
begin
  { Initialize the output handles }
  OutHandle := GetStdHandle(STD_OUTPUT_HANDLE);
  InputHandle := GetStdHandle(STD_INPUT_HANDLE);
  LastMode := 3;

  {--------------------- Get the cursor size and such -----------------------}
  FillChar(CursorInfo, SizeOf(CursorInfo), 00);
  GetConsoleCursorInfo(OutHandle, CursorInfo);
  SaveCursorSize := CursorInfo.dwSize;

  {------------------ Get the current cursor position and attr --------------}
  FillChar(ConsoleInfo, SizeOf(ConsoleInfo), 0);
  GetConsoleScreenBufferInfo(OutHandle, ConsoleInfo);
  CursorSaveX := ConsoleInfo.dwCursorPosition.X;
  CursorSaveY := ConsoleInfo.dwCursorPosition.Y;
  TextAttr := ConsoleInfo.wAttributes;


  { Load startup values }
  ScreenWidth := GetScreenWidth;
  ScreenHeight := GetScreenHeight;
  WindMax := (ScreenWidth - 1) OR ((ScreenHeight - 1) SHL 8);

  { Redirect the standard output }
  AssignCrt(Output);
  Rewrite(Output);
  TextRec(Output).Handle:= OutHandle;

  AssignCrt(Input);
  Reset(Input);
  TextRec(Input).Handle:= InputHandle;
end. { unit Crt }
{
  $Log$
  Revision 1.6  1999-05-19 16:22:02  peter
    * fixed left crt bugs

  Revision 1.5  1999/05/01 13:18:26  peter
    * changed back fixes

  Revision 1.4  1999/04/30 11:34:27  michael
  + Fixed some compiling errors

  Revision 1.3  1999/04/23 09:06:17  michael
  + now it REALLY compiles

  Revision 1.2  1999/04/20 11:34:12  peter
    + crt unit that compiles

}
