{*****************************************************************************}
{
    $Id$
    This file is part of the Free Pascal's "Free Components Library".
    Copyright (c) 2003 by Mazen NEIFER of the Free Pascal development team

    BMP writer implementation.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
}
{*****************************************************************************}

{$mode objfpc}
{$h+}

unit FPReadBMP;

interface

uses FPImage, classes, sysutils, BMPcomn;

type
  TFPReaderBMP = class (TFPCustomImageReader)
    Private
      Procedure FreeBufs;       // Free (and nil) buffers.
    protected
      ReadSize : Integer;       // Size (in bytes) of 1 scanline.
      BFI : TBitMapInfoHeader;  // The header as read from the stream.
      FPalette : PFPcolor;      // Buffer with Palette entries.
      LineBuf : PByte;          // Buffer for 1 scanline. Can be Byte, TColorRGB or TColorRGBA

      // SetupRead will allocate the needed buffers, and read the colormap if needed.
      procedure SetupRead(nPalette, nRowBits: Integer; Stream : TStream); virtual;
      procedure ReadScanLine(Row : Integer; Stream : TStream); virtual;
      procedure WriteScanLine(Row : Integer; Img : TFPCustomImage); virtual;
      // required by TFPCustomImageReader
      procedure InternalRead  (Stream:TStream; Img:TFPCustomImage); override;
      function  InternalCheck (Stream:TStream) : boolean; override;
    public
      constructor Create; override;
      destructor Destroy; override;
  end;

implementation


function RGBAToFPColor(Const RGBA: TColorRGBA) : TFPcolor;

begin
  with Result, RGBA do
    begin
    Red   :=(R shl 8) or R;
    Green :=(G shl 8) or G;
    Blue  :=(B shl 8) or B;
    alpha :=A; //!! MVC: Used to be AlphaOpaque ???
    end;
end;

Function RGBToFPColor(Const RGB : TColorRGB) : TFPColor;

begin
  with Result,RGB do
    begin  {Use only the high byte to convert the color}
    Red   := (R shl 8) + R;
    Green := (G shl 8) + G;
    Blue  := (B shl 8) + B;
    Alpha := AlphaOpaque;
    end;
end;

Constructor TFPReaderBMP.create;

begin
  inherited create;
end;

Destructor TFPReaderBMP.Destroy;

begin
  FreeBufs;
  inherited destroy;
end;

Procedure TFPReaderBMP.FreeBufs;

begin
  If (LineBuf<>Nil) then
    begin
    FreeMem(LineBuf);
    LineBuf:=Nil;
    end;
  If (FPalette<>Nil) then
    begin
    FreeMem(FPalette);
    FPalette:=Nil;
    end;
end;

procedure TFPReaderBMP.SetupRead(nPalette, nRowBits: Integer; Stream : TStream);

{$ifdef VER1_0}
type
  tcolinfo = ARRAY [0..0] OF TColorRGBA;
  pcolinfo = ^tcolinfo;
var
  ColInfo: pcolinfo;
{$else}
var
  ColInfo: ARRAY OF TColorRGBA;
{$endif}
  i: Integer;

begin
  if nPalette>0 then
    begin
    GetMem(FPalette, nPalette*SizeOf(TFPColor));
{$ifdef VER1_0}
    GetMem(ColInfo, nPalette*Sizeof(TColorRGBA));
    if BFI.ClrUsed>0 then
      Stream.Read(ColInfo^[0],BFI.ClrUsed*SizeOf(TColorRGBA))
    else // Seems to me that this is dangerous.
      Stream.Read(ColInfo^[0],nPalette*SizeOf(TColorRGBA));
    for i := 0 to nPalette-1 do
      FPalette[i] := RGBAToFPColor(ColInfo^[i]);
{$else}
    SetLength(ColInfo, nPalette);
    if BFI.ClrUsed>0 then
      Stream.Read(ColInfo[0],BFI.ClrUsed*SizeOf(TColorRGBA))
    else // Seems to me that this is dangerous.
      Stream.Read(ColInfo[0],nPalette*SizeOf(TColorRGBA));
    for i := 0 to High(ColInfo) do
      FPalette[i] := RGBAToFPColor(ColInfo[i]);
{$endif}
    end
  else if BFI.ClrUsed>0 then { Skip palette }
    Stream.Position := Stream.Position + BFI.ClrUsed*SizeOf(TColorRGBA);
  ReadSize:=((nRowBits + 31) div 32) shl 2;
  GetMem(LineBuf,ReadSize);
{$ifdef VER1_0}
    FreeMem(ColInfo, nPalette*Sizeof(TColorRGBA));
{$endif}
end;

procedure TFPReaderBMP.InternalRead(Stream:TStream; Img:TFPCustomImage);

Var
  Row : Integer;

begin
  Stream.Read(BFI,SizeOf(BFI));
  { This will move past any junk after the BFI header }
  Stream.Position:=Stream.Position-SizeOf(BFI)+BFI.Size;
  with BFI do
    begin
    if (Compression<>0) then
      Raise FPImageException.Create('Compressed bitmaps not supported');
    Img.Width:=Width;
    Img.Height:=Height;
    end;
  Case BFI.BitCount of
    1 : { Monochrome }
      SetupRead(2,Img.Width,Stream);
    4 :
      SetupRead(16,Img.Width*4,Stream);
    8 :
      SetupRead(256,Img.Width*8,Stream);
    16 :
      Raise FPImageException.Create('16 bpp bitmaps not supported');
    24:
      SetupRead(0,Img.Width*8*3,Stream);
    32:
      SetupRead(0,Img.Width*8*4,Stream);
  end;
  Try
    for Row:=Img.Height-1 downto 0 do
      begin
      ReadScanLine(Row,Stream); // Scanline in LineBuf with Size ReadSize.
      WriteScanLine(Row,Img);
      end;
  finally
    FreeBufs;
  end;
end;

procedure TFPReaderBMP.ReadScanLine(Row : Integer; Stream : TStream);

begin
  {
    Add here support for compressed lines. The 'readsize' is the same in the end.
  }
  Stream.Read(LineBuf[0],ReadSize);
end;

procedure TFPReaderBMP.WriteScanLine(Row : Integer; Img : TFPCustomImage);

Var
  Column : Integer;

begin
  Case BFI.BitCount of
   1 :
     for Column:=0 to Img.Width-1 do
       if ((LineBuf[Column div 8] shr (7-(Column and 7)) ) and 1) <> 0 then
         img.colors[Column,Row]:=FPalette[1]
       else
         img.colors[Column,Row]:=FPalette[0];
   4 :
      for Column:=0 to img.Width-1 do
        img.colors[Column,Row]:=FPalette[(LineBuf[Column div 2] shr (((Column+1) and 1)*4)) and $0f];
   8 :
      for Column:=0 to img.Width-1 do
        img.colors[Column,Row]:=FPalette[LineBuf[Column]];
   16 :
      Raise FPImageException.Create('16 bpp bitmaps not supported');
   24 :
      for Column:=0 to img.Width-1 do
        img.colors[Column,Row]:=RGBToFPColor(PColorRGB(LineBuf)[Column]);
   32 :
      for Column:=0 to img.Width-1 do
        img.colors[Column,Row]:=RGBAToFPColor(PColorRGBA(LineBuf)[Column]);
    end;
end;

function  TFPReaderBMP.InternalCheck (Stream:TStream) : boolean;

var
  BFH:TBitMapFileHeader;
begin
  stream.Read(BFH,SizeOf(BFH));
  With BFH do
    Result:=(bfType=BMmagic); // Just check magic number
end;

initialization
  ImageHandlers.RegisterImageReader ('BMP Format', 'bmp', TFPReaderBMP);
end.
{
$Log$
Revision 1.11  2004-02-25 02:36:51  pierre
* fix compilation with 1.0 compiler

Revision 1.10  2004/02/20 23:12:57  michael
+ Read/WriteScanline virtual, as intended

Revision 1.9  2004/02/20 23:07:44  michael
+ Small improvements. More cosmetic in nature

Revision 1.8  2004/02/20 23:00:35  michael
+ Small improvements. More cosmetic in nature

Revision 1.7  2004/02/20 22:42:44  michael
+ More modular reading of BMP for easier overriding in descendents

Revision 1.6  2004/02/15 20:59:06  michael
+ Patch from Colin Western

Revision 1.5  2003/09/30 14:17:05  luk
* better color conversion (White didn't stay white)

Revision 1.4  2003/09/30 06:17:38  mazen
- all common defintions are now included into bmpcomn unit

Revision 1.3  2003/09/15 11:39:01  mazen
* fixed InternalRead method to load BMP files.
  But still too long to load images.

Revision 1.2  2003/09/09 11:26:59  mazen
+ setting image attributes when loading images
* fixing copyright section in the file header

Revision 1.1  2003/09/08 14:10:10  mazen
+ adding support for loading bmp images

}
