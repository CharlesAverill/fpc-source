{
  $Id$

  "shedit" - Text editor with syntax highlighting
  Copyright (C) 1999  Sebastian Guenther (sguenther@gmx.de)

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}

// Generic text document class

{$MODE objfpc}
{$M+,H+}

unit doc_text;

interface

uses Classes;

type
  PLine = ^TLine;
  TLine = packed record
    info: Pointer;
    flags: LongWord;
    len: LongInt;                       // Length of string in characters
    s: PChar;
  end;

  PLineArray = ^TLineArray;
  TLineArray = array[0..0] of TLine;

const

  {TLine.flags Syntax Highlighting Flags}
  LF_SH_Valid      = $01;
  LF_SH_Multiline1 = $02;
  LF_SH_Multiline2 = $04;
  LF_SH_Multiline3 = $08;
  LF_SH_Multiline4 = $10;
  LF_SH_Multiline5 = $20;
  LF_SH_Multiline6 = $40;
  LF_SH_Multiline7 = $80;

  {Escape character for syntax highlighting (marks start of sh sequence,
   next character is color/sh element number, beginning at #1}
  LF_Escape = #10;

type

  TTextDoc = class;

  TDocLineEvent = procedure(Sender: TTextDoc; Line: Integer) of object;

  TViewInfo = class(TCollectionItem)
  public
    OnLineInsert, OnLineRemove: TDocLineEvent;
    OnModifiedChange: TNotifyEvent;
  end;

  TTextDoc = class
  protected
    FModified: Boolean;
    FLineWidth,
    FLineCount: LongInt;
    FLines: PLineArray;
    FViewInfos: TCollection;
    procedure SetModified(AModified: Boolean);
    function  GetLineText(LineNumber: Integer): String;
    procedure SetLineText(LineNumber: Integer; const NewText: String);
    function  GetLineLen(LineNumber: Integer): Integer;
    function  GetLineFlags(LineNumber: Integer): Byte;
    procedure SetLineFlags(LineNumber: Integer; NewFlags: Byte);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromFile(const filename: String);

    procedure InsertLine(BeforeLine: Integer; const s: String);
    procedure AddLine(const s: String);
    procedure RemoveLine(LineNumber: Integer);

    property Modified: Boolean read FModified write SetModified;
    property LineWidth: Integer read FLineWidth;
    property LineCount: Integer read FLineCount;
    property LineText[LineNumber: Integer]: String
      read GetLineText write SetLineText;
    property LineLen[LineNumber: Integer]: Integer read GetLineLen;
    property LineFlags[LineNumber: Integer]: Byte
      read GetLineFlags write SetLineFlags;

    property ViewInfos: TCollection read FViewInfos;
  end;


implementation
uses Strings;


constructor TTextDoc.Create;
begin
  FModified := false;
  FLines := nil;
  FLineCount := 0;
  FLineWidth := 0;
  FViewInfos := TCollection.Create(TViewInfo);
end;

destructor TTextDoc.Destroy;
begin
  Clear;
end;

procedure TTextDoc.Clear;
var
  i: Integer;
begin
  for i := 0 to FLineCount - 1 do
    StrDispose(FLines^[i].s);
  if assigned(FLines) then
   FreeMem(FLines);

  FLineCount:=0;
  FLineWidth:=0;

  for i := 0 to FViewInfos.Count - 1 do
    if Assigned(TViewInfo(FViewInfos.Items[i]).OnLineRemove) then
      TViewInfo(FViewInfos.Items[i]).OnLineRemove(Self, 0);
end;

procedure TTextDoc.InsertLine(BeforeLine: Integer; const s: String);
var
  l: PLine;
  i: Integer;
begin
  if BeforeLine > FLineCount then
   exit;  // *** throw an intelligent exception
  ReAllocMem(FLines, (FLineCount + 1) * SizeOf(TLine));
  Move(FLines^[BeforeLine], FLines^[BeforeLine + 1],(FLineCount - BeforeLine) * SizeOf(TLine));
  l := @(FLines^[BeforeLine]);
  FillChar(l^, SizeOf(TLine), 0);
  l^.len := Length(s);
  l^.s := StrNew(PChar(s));

  Inc(FLineCount);
  if l^.Len>FLineWidth then
   FLineWidth:=l^.len;

  for i := 0 to FViewInfos.Count - 1 do
    if Assigned(TViewInfo(FViewInfos.Items[i]).OnLineInsert) then
      TViewInfo(FViewInfos.Items[i]).OnLineInsert(Self, BeforeLine);
end;

procedure TTextDoc.AddLine(const s: String);
begin
  InsertLine(FLineCount, s);
end;

procedure TTextDoc.RemoveLine(LineNumber: Integer);
var
  i: Integer;
begin
  StrDispose(FLines^[LineNumber].s);
  ReAllocMem(FLines, (FLineCount - 1) * SizeOf(TLine));
  if LineNumber < FLineCount - 1 then
    Move(FLines^[LineNumber + 1], FLines^[LineNumber],(FLineCount - LineNumber - 1) * SizeOf(TLine));
  Dec(FLineCount);

  for i := 0 to FViewInfos.Count - 1 do
    if Assigned(TViewInfo(FViewInfos.Items[i]).OnLineRemove) then
      TViewInfo(FViewInfos.Items[i]).OnLineRemove(Self, LineNumber);
  Modified := True;
end;

procedure TTextDoc.LoadFromFile(const filename: String);
var
  f: Text;
  s, s2: String;
  i: Integer;
begin
  Clear;
  Assign(f, filename);
  Reset(f);
  while not eof(f) do begin
    ReadLn(f, s);
    // Expand tabs to spaces
    s2 := '';
    for i := 1 to Length(s) do
      if s[i] = #9 then begin
        repeat s2 := s2 + ' ' until (Length(s2) mod 8) = 0;
      end else
        s2 := s2 + s[i];
    AddLine(s2);
  end;
  Close(f);
end;

procedure TTextDoc.SetModified(AModified: Boolean);
var
  i: Integer;
begin
  if AModified = FModified then exit;
  FModified := AModified;

  for i := 0 to FViewInfos.Count - 1 do
    if Assigned(TViewInfo(FViewInfos.Items[i]).OnModifiedChange) then
      TViewInfo(FViewInfos.Items[i]).OnModifiedChange(Self);
end;

function TTextDoc.GetLineText(LineNumber: Integer): String;
begin
  if (LineNumber < 0) or (LineNumber >= FLineCount) then
    Result := ''
  else
    Result := FLines^[LineNumber].s;
end;

procedure TTextDoc.SetLineText(LineNumber: Integer; const NewText: String);
begin
  if (FLines^[LineNumber].s = nil) or
    (StrComp(FLines^[LineNumber].s, PChar(NewText)) <> 0) then begin
    StrDispose(FLines^[LineNumber].s);
    FLines^[LineNumber].len := Length(NewText);
    FLines^[LineNumber].s := StrNew(PChar(NewText));
    if Length(NewText)>FLineWidth then
     FLineWidth:=Length(NewText);
    Modified := True;
  end;
end;

function TTextDoc.GetLineLen(LineNumber: Integer): Integer;
begin
  if (LineNumber < 0) or (LineNumber >= FLineCount) then
    Result := 0
  else
    Result := FLines^[LineNumber].len;
end;

function TTextDoc.GetLineFlags(LineNumber: Integer): Byte;
begin
  if (LineNumber < 0) or (LineNumber >= FLineCount) then
    Result := 0
  else
    Result := FLines^[LineNumber].flags;
end;

procedure TTextDoc.SetLineFlags(LineNumber: Integer; NewFlags: Byte);
begin
  FLines^[LineNumber].flags := NewFlags;
end;


end.


{
  $Log$
  Revision 1.3  1999-12-09 23:16:41  peter
    * cursor walking is now possible, both horz and vert ranges are now
      adapted
    * filter key modifiers
    * selection move routines added, but still no correct output to the
      screen

  Revision 1.2  1999/11/14 21:32:55  peter
    * fixes to get it working without crashes

  Revision 1.1  1999/10/29 15:59:03  peter
    * inserted in fcl

}
