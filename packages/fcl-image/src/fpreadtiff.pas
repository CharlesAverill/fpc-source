{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2008 by the Free Pascal development team

    Tiff reader for fpImage.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************

  Working:
    Grayscale 8,16bit (optional alpha),
    RGB 8,16bit (optional alpha),
    Orientation,
    skipping Thumbnail to read first image,
    compression: packbits,
    endian

  ToDo:
    Compression: deflate, jpeg, ...
    Planar
    ColorMap
    multiple images
    separate mask
    pages
    fillorder - not needed by baseline tiff reader
    bigtiff 64bit offsets
}
unit FPReadTiff;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FPimage, ctypes, FPTiffCmn;

type

  { TFPReaderTiff }

  TFPReaderTiff = class(TFPCustomImageReader)
  private
    FReverserEndian: boolean;
    IDF: TTiffIDF;
    FDebug: boolean;
    fIFDStarts: TFPList;
    FReverseEndian: Boolean;
    fStartPos: int64;
    s: TStream;
    procedure TiffError(Msg: string);
    procedure SetStreamPos(p: DWord);
    function ReadTiffHeader(QuickTest: boolean; out IFD: DWord): boolean; // returns IFD: offset to first IFD
    function ReadIFD(Start: dword): DWord;// Image File Directory
    procedure ReadDirectoryEntry(var EntryTag: Word);
    function ReadEntryUnsigned: DWord;
    function ReadEntrySigned: Cint32;
    function ReadEntryRational: TTiffRational;
    function ReadEntryString: string;
    function ReadByte: Byte;
    function ReadWord: Word;
    function ReadDWord: DWord;
    procedure ReadValues(StreamPos: DWord;
                         out EntryType: word; out EntryCount: DWord;
                         out Buffer: Pointer; out ByteCount: PtrUInt);
    procedure ReadShortOrLongValues(StreamPos: DWord;
                                    out Buffer: PDWord; out Count: DWord);
    procedure ReadShortValues(StreamPos: DWord;
                              out Buffer: PWord; out Count: DWord);
    procedure ReadImage(Index: integer);
    function FixEndian(w: Word): Word; inline;
    function FixEndian(d: DWord): DWord; inline;
    procedure DecompressPackBits(var Buffer: Pointer; var Count: PtrInt);
  protected
    procedure InternalRead(Str: TStream; AnImage: TFPCustomImage); override;
    function InternalCheck(Str: TStream): boolean; override;
  public
    FirstImg: TTiffIDF;
    constructor Create; override;
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromStream(aStream: TStream);
    property Debug: boolean read FDebug write FDebug;
    property StartPos: int64 read fStartPos;
    property ReverserEndian: boolean read FReverserEndian;
    property TheStream: TStream read s;
  end;

implementation

procedure TFPReaderTiff.TiffError(Msg: string);
begin
  Msg:=Msg+' at position '+IntToStr(s.Position);
  if fStartPos>0 then
    Msg:=Msg+'(TiffPosition='+IntToStr(fStartPos)+')';
  raise Exception.Create(Msg);
end;

procedure TFPReaderTiff.SetStreamPos(p: DWord);
var
  NewPosition: int64;
begin
  NewPosition:=Int64(p)+fStartPos;
  if NewPosition>s.Size then
    TiffError('Offset outside of stream');
  s.Position:=NewPosition;
end;

procedure TFPReaderTiff.LoadFromStream(aStream: TStream);
var
  IFDStart: LongWord;
  i: Integer;
begin
  Clear;
  s:=aStream;
  fStartPos:=s.Position;
  ReadTiffHeader(false,IFDStart);
  i:=0;
  while IFDStart>0 do begin
    IFDStart:=ReadIFD(IFDStart);
    ReadImage(i);
    inc(i);
  end;
end;

function TFPReaderTiff.ReadTiffHeader(QuickTest: boolean; out IFD: DWord): boolean;
var
  ByteOrder: String;
  BigEndian: Boolean;
  FortyTwo: Word;
begin
  Result:=false;
  // read byte order  II low endian, MM big endian
  ByteOrder:='  ';
  s.Read(ByteOrder[1],2);
  //debugln(['TForm1.ReadTiffHeader ',dbgstr(ByteOrder)]);
  if ByteOrder='II' then
    BigEndian:=false
  else if ByteOrder='MM' then
    BigEndian:=true
  else if QuickTest then
    exit
  else
    TiffError('expected II or MM');
  FReverseEndian:={$IFDEF FPC_BIG_ENDIAN}not{$ENDIF} BigEndian;
  if Debug then
    writeln('TFPReaderTiff.ReadTiffHeader Endian Big=',BigEndian,' ReverseEndian=',FReverseEndian);
  // read magic number 42
  FortyTwo:=ReadWord;
  if FortyTwo<>42 then begin
    if QuickTest then
      exit
    else
      TiffError('expected 42, because of its deep philosophical impact, but found '+IntToStr(FortyTwo));
  end;
  // read offset to first IDF
  IFD:=ReadDWord;
  //debugln(['TForm1.ReadTiffHeader IFD=',IFD]);
  Result:=true;
end;

function TFPReaderTiff.ReadIFD(Start: dword): DWord;
var
  Count: Word;
  i: Integer;
  EntryTag: Word;
  p: Int64;
begin
  Result:=0;
  SetStreamPos(Start);
  Count:=ReadWord;
  EntryTag:=0;
  p:=s.Position;
  for i:=1 to Count do begin
    ReadDirectoryEntry(EntryTag);
    inc(p,12);
    s.Position:=p;
  end;
  // read start of next IFD
  Result:=ReadDWord;
  if (Result<>0) and (Result<Start) then begin
    // backward jump: check for loops
    if fIFDStarts=nil then
      fIFDStarts:=TFPList.Create
    else if fIFDStarts.IndexOf(Pointer(PtrUInt(Result)))>0 then
      TiffError('endless loop in Image File Descriptors');
    fIFDStarts.Add(Pointer(PtrUInt(Result)));
  end;
end;

procedure TFPReaderTiff.ReadDirectoryEntry(var EntryTag: Word);
var
  EntryType: Word;
  EntryCount: LongWord;
  EntryStart: LongWord;
  NewEntryTag: Word;
  UValue: LongWord;
  WordBuffer: PWord;
  Count: DWord;
  i: Integer;
begin
  NewEntryTag:=ReadWord;
  if NewEntryTag<EntryTag then
    TiffError('Tags must be in ascending order');
  EntryTag:=NewEntryTag;
  case EntryTag of
  254:
    begin
      // NewSubFileType
      UValue:=ReadEntryUnsigned;
      IDF.ImageIsThumbNail:=UValue and 1<>0;
      IDF.ImageIsPage:=UValue and 2<>0;
      IDF.ImageIsMask:=UValue and 4<>0;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry NewSubFileType ThumbNail=',IDF.ImageIsThumbNail,' Page=',IDF.ImageIsPage,' Mask=',IDF.ImageIsMask);
    end;
  255:
    begin
      // SubFileType (deprecated)
      UValue:=ReadEntryUnsigned;
      IDF.ImageIsThumbNail:=false;
      IDF.ImageIsPage:=false;
      IDF.ImageIsMask:=false;
      case UValue of
      1: ;
      2: IDF.ImageIsThumbNail:=true;
      3: IDF.ImageIsPage:=true;
      else
        TiffError('SubFileType expected, but found '+IntToStr(UValue));
      end;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry SubFileType ThumbNail=',IDF.ImageIsThumbNail,' Page=',IDF.ImageIsPage,' Mask=',IDF.ImageIsMask);
    end;
  256:
    begin
      // fImageWidth
      IDF.ImageWidth:=ReadEntryUnsigned;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry ImageWidth=',IDF.ImageWidth);
    end;
  257:
    begin
      // ImageLength
      IDF.ImageHeight:=ReadEntryUnsigned;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry ImageHeight=',IDF.ImageHeight);
    end;
  258:
    begin
      // BitsPerSample
      IDF.BitsPerSample:=DWord(s.Position-fStartPos-2);
      ReadShortValues(IDF.BitsPerSample,WordBuffer,Count);
      try
        SetLength(IDF.BitsPerSampleArray,Count);
        for i:=0 to Count-1 do
          IDF.BitsPerSampleArray[i]:=WordBuffer[i];
      finally
        ReAllocMem(WordBuffer,0);
      end;
      if Debug then begin
        write('TFPReaderTiff.ReadDirectoryEntry BitsPerSample: ');
        for i:=0 to Count-1 do
          write(IntToStr(WordBuffer[i]),' ');
        writeln;
        ReAllocMem(WordBuffer,0);
      end;
    end;
  259:
    begin
      // fCompression
      UValue:=ReadEntryUnsigned;
      case UValue of
      1: ; { No fCompression, but pack data into bytes as tightly as possible,
           leaving no unused bits (except at the end of a row). The component
           values are stored as an array of type BYTE. Each scan line (row)
           is padded to the next BYTE boundary. }
      2: ; { CCITT Group 3 1-Dimensional Modified Huffman run length encoding. }
      5: ; { LZW }
      7: ; { JPEG }
      32946: ; { Deflate }
      32773: ; { PackBits fCompression, a simple byte-oriented run length scheme.
               See the PackBits section for details. Data fCompression applies
               only to raster image data. All other TIFF fields are unaffected. }
      else
        TiffError('expected Compression, but found '+IntToStr(UValue));
      end;
      IDF.Compression:=UValue;
      if Debug then begin
        write('TFPReaderTiff.ReadDirectoryEntry Compression=',IntToStr(IDF.Compression),'=');
        case IDF.Compression of
        1: write('no compression');
        2: write('CCITT Group 3 1-Dimensional Modified Huffman run length encoding');
        5: write('LZW');
        7: write('JPEG');
        32946: write('Deflate');
        32773: write('PackBits');
        end;
        writeln;
      end;
    end;
  262:
    begin
      // PhotometricInterpretation
      UValue:=ReadEntryUnsigned;
      case UValue of
      0: ; // bilevel grayscale 0 is white
      1: ; // bilevel grayscale 0 is black
      2: ; // RGB 0,0,0 is black
      3: ; // Palette color
      4: ; // Transparency Mask
      else
        TiffError('expected PhotometricInterpretation, but found '+IntToStr(UValue));
      end;
      IDF.PhotoMetricInterpretation:=UValue;
      if Debug then begin
        write('TFPReaderTiff.ReadDirectoryEntry PhotometricInterpretation=');
        case IDF.PhotoMetricInterpretation of
        0: write('0=bilevel grayscale 0 is white');
        1: write('1=bilevel grayscale 0 is black');
        2: write('2=RGB 0,0,0 is black');
        3: write('3=Palette color');
        4: write('4=Transparency Mask');
        end;
        writeln;
      end;
    end;
  263:
    begin
      // Treshholding
      UValue:=ReadEntryUnsigned;
      case UValue of
      1: ; // no dithering or halftoning was applied
      2: ; // an ordered dithering or halftoning was applied
      3: ; // a randomized dithering or halftoning was applied
      else
        TiffError('expected Treshholding, but found '+IntToStr(UValue));
      end;
      IDF.Treshholding:=UValue;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry Treshholding=',IDF.Treshholding);
    end;
  264:
    begin
      // CellWidth
      IDF.CellWidth:=ReadEntryUnsigned;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry CellWidth=',IDF.CellWidth);
    end;
  265:
    begin
      // CellLength
      IDF.CellLength:=ReadEntryUnsigned;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry CellLength=',IDF.CellLength);
    end;
  266:
    begin
      // FillOrder
      UValue:=ReadEntryUnsigned;
      case UValue of
      1: IDF.FillOrder:=1; // left to right = high to low
      2: IDF.FillOrder:=2; // left to right = low to high
      else
        TiffError('expected FillOrder, but found '+IntToStr(UValue));
      end;
      if Debug then begin
        write('TFPReaderTiff.ReadDirectoryEntry FillOrder=',IntToStr(IDF.FillOrder),'=');
        case IDF.FillOrder of
        1: write('left to right = high to low');
        2: write('left to right = low to high');
        end;
        writeln;
      end;
    end;
  269:
    begin
      // DocumentName
      IDF.DocumentName:=ReadEntryString;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry DocumentName=',IDF.DocumentName);
    end;
  270:
    begin
      // ImageDescription
      IDF.ImageDescription:=ReadEntryString;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry ImageDescription=',IDF.ImageDescription);
    end;
  271:
    begin
      // Make - scanner manufacturer
      IDF.Make_ScannerManufacturer:=ReadEntryString;
      writeln('TFPReaderTiff.ReadDirectoryEntry Make_ScannerManufacturer=',IDF.Make_ScannerManufacturer);
    end;
  272:
    begin
      // Model - scanner model
      IDF.Model_Scanner:=ReadEntryString;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry Model_Scanner=',IDF.Model_Scanner);
    end;
  273:
    begin
      // StripOffsets
      IDF.StripOffsets:=DWord(s.Position-fStartPos-2);
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry StripOffsets=',IDF.StripOffsets);
    end;
  274:
    begin
      // Orientation
      UValue:=ReadEntryUnsigned;
      case UValue of
      1: ;// 0,0 is left, top
      2: ;// 0,0 is right, top
      3: ;// 0,0 is right, bottom
      4: ;// 0,0 is left, bottom
      5: ;// 0,0 is top, left (rotated)
      6: ;// 0,0 is top, right (rotated)
      7: ;// 0,0 is bottom, right (rotated)
      8: ;// 0,0 is bottom, left (rotated)
      else
        TiffError('expected Orientation, but found '+IntToStr(UValue));
      end;
      IDF.Orientation:=UValue;
      if Debug then begin
        write('TFPReaderTiff.ReadDirectoryEntry Orientation=',IntToStr(IDF.Orientation),'=');
        case IDF.Orientation of
        1: write('0,0 is left, top');
        2: write('0,0 is right, top');
        3: write('0,0 is right, bottom');
        4: write('0,0 is left, bottom');
        5: write('0,0 is top, left (rotated)');
        6: write('0,0 is top, right (rotated)');
        7: write('0,0 is bottom, right (rotated)');
        8: write('0,0 is bottom, left (rotated)');
        end;
        writeln;
      end;
    end;
  277:
    begin
      // SamplesPerPixel
      IDF.SamplesPerPixel:=ReadEntryUnsigned;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry SamplesPerPixel=',IDF.SamplesPerPixel);
    end;
  278:
    begin
      // RowsPerStrip
      UValue:=ReadEntryUnsigned;
      if UValue=0 then
        TiffError('expected RowsPerStrip, but found '+IntToStr(UValue));
      IDF.RowsPerStrip:=UValue;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry RowsPerStrip=',IDF.RowsPerStrip);
    end;
  279:
    begin
      // StripByteCounts
      IDF.StripByteCounts:=DWord(s.Position-fStartPos-2);
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry StripByteCounts=',IDF.StripByteCounts);
    end;
  280:
    begin
      // MinSampleValue
    end;
  281:
    begin
      // MaxSampleValue
    end;
  282:
    begin
      // XResolution
      IDF.XResolution:=ReadEntryRational;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry XResolution=',IDF.XResolution.Numerator,',',IDF.XResolution.Denominator);
    end;
  283:
    begin
      // YResolution
      IDF.YResolution:=ReadEntryRational;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry YResolution=',IDF.YResolution.Numerator,',',IDF.YResolution.Denominator);
    end;
  284:
    begin
      // PlanarConfiguration
      UValue:=ReadEntryUnsigned;
      case UValue of
      1: ; // chunky format
      2: ; // planar format
      else
        TiffError('expected PlanarConfiguration, but found '+IntToStr(UValue));
      end;
      IDF.PlanarConfiguration:=UValue;
      if Debug then begin
        write('TFPReaderTiff.ReadDirectoryEntry PlanarConfiguration=');
        case UValue of
        1: write('chunky format');
        2: write('planar format');
        end;
        writeln;
      end;
    end;
  288:
    begin
      // FreeOffsets
      // The free bytes in a tiff file are described with FreeByteCount and FreeOffsets
    end;
  289:
    begin
      // FreeByteCount
      // The free bytes in a tiff file are described with FreeByteCount and FreeOffsets
    end;
  290:
    begin
      // GrayResponseUnit
      // precision of GrayResponseCurve
    end;
  291:
    begin
      // GrayResponseCurve
      // the optical density for each possible pixel value
    end;
  296:
    begin
      // fResolutionUnit
      UValue:=ReadEntryUnsigned;
      case UValue of
      1: IDF.ResolutionUnit:=1; // none
      2: IDF.ResolutionUnit:=2; // inch
      3: IDF.ResolutionUnit:=3; // centimeter
      else
        TiffError('expected ResolutionUnit, but found '+IntToStr(UValue));
      end;
      if Debug then begin
        write('TFPReaderTiff.ReadDirectoryEntry ResolutionUnit=');
        case IDF.ResolutionUnit of
        1: write('none');
        2: write('inch');
        3: write('centimeter');
        end;
        writeln;
      end;
    end;
  305:
    begin
      // Software
      IDF.Software:=ReadEntryString;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry Software="',IDF.Software,'"');
    end;
  306:
    begin
      // DateAndTime
      IDF.DateAndTime:=ReadEntryString;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry DateAndTime="',IDF.DateAndTime,'"');
    end;
  315:
    begin
      // Artist
      IDF.Artist:=ReadEntryString;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry Artist="',IDF.Artist,'"');
    end;
  316:
    begin
      // HostComputer
      IDF.HostComputer:=ReadEntryString;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry HostComputer="',IDF.HostComputer,'"');
    end;
  320:
    begin
      // ColorMap: N = 3*2^BitsPerSample
      IDF.ColorMap:=DWord(s.Position-fStartPos-2);
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry ColorMap');
    end;
  338:
    begin
      // ExtraSamples: if SamplesPerPixel is bigger than PhotometricInterpretation
      // then ExtraSamples is an array defining the extra samples
      // 0=unspecified
      // 1=alpha (premultiplied)
      // 2=alpha (unassociated)
      IDF.ExtraSamples:=DWord(s.Position-fStartPos-2);
      if Debug then begin
        ReadShortValues(IDF.ExtraSamples,WordBuffer,Count);
        write('TFPReaderTiff.ReadDirectoryEntry ExtraSamples: ');
        for i:=0 to Count-1 do
          write(IntToStr(WordBuffer[i]),' ');
        writeln;
        ReAllocMem(WordBuffer,0);
      end;
    end;
  33432:
    begin
      // Copyright
      IDF.Copyright:=ReadEntryString;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry Copyright="',IDF.Copyright,'"');
    end;
  else
    begin
      EntryType:=ReadWord;
      EntryCount:=ReadDWord;
      EntryStart:=ReadDWord;
      if Debug then
        writeln('TFPReaderTiff.ReadDirectoryEntry Tag=',EntryTag,' Type=',EntryType,' Count=',EntryCount,' ValuesStart=',EntryStart);
    end;
  end;
end;

function TFPReaderTiff.ReadEntryUnsigned: DWord;
var
  EntryCount: LongWord;
  EntryType: Word;
begin
  Result:=0;
  EntryType:=ReadWord;
  EntryCount:=ReadDWord;
  if EntryCount<>1 then
    TiffError('EntryCount=1 expected, but found '+IntToStr(EntryCount));
  //writeln('TFPReaderTiff.ReadEntryUnsigned Tag=',EntryTag,' Type=',EntryType,' Count=',EntryCount,' ValuesStart=',EntryStart]);
  case EntryType of
  1: begin
      // byte: 8bit unsigned
      Result:=ReadByte;
    end;
  3: begin
      // short: 16bit unsigned
      Result:=ReadWord;
    end;
  4: begin
      // long: 32bit unsigned long
      Result:=ReadDWord;
    end;
  else
    TiffError('expected single unsigned value, but found type='+IntToStr(EntryType));
  end;
end;

function TFPReaderTiff.ReadEntrySigned: Cint32;
var
  EntryCount: LongWord;
  EntryType: Word;
begin
  Result:=0;
  EntryType:=ReadWord;
  EntryCount:=ReadDWord;
  if EntryCount<>1 then
    TiffError('EntryCount+1 expected, but found '+IntToStr(EntryCount));
  //writeln('TFPReaderTiff.ReadEntrySigned Tag=',EntryTag,' Type=',EntryType,' Count=',EntryCount,' ValuesStart=',EntryStart]);
  case EntryType of
  1: begin
      // byte: 8bit unsigned
      Result:=cint8(ReadByte);
    end;
  3: begin
      // short: 16bit unsigned
      Result:=cint16(ReadWord);
    end;
  4: begin
      // long: 32bit unsigned long
      Result:=cint32(ReadDWord);
    end;
  else
    TiffError('expected single signed value, but found type='+IntToStr(EntryType));
  end;
end;

function TFPReaderTiff.ReadEntryRational: TTiffRational;
var
  EntryCount: LongWord;
  EntryStart: LongWord;
  EntryType: Word;
begin
  Result:=TiffRational0;
  EntryType:=ReadWord;
  EntryCount:=ReadDWord;
  if EntryCount<>1 then
    TiffError('EntryCount+1 expected, but found '+IntToStr(EntryCount));
  //writeln('TFPReaderTiff.ReadEntryUnsigned Tag=',EntryTag,' Type=',EntryType,' Count=',EntryCount,' ValuesStart=',EntryStart]);
  case EntryType of
  1: begin
      // byte: 8bit unsigned
      Result.Numerator:=ReadByte;
    end;
  3: begin
      // short: 16bit unsigned
      Result.Numerator:=ReadWord;
    end;
  4: begin
      // long: 32bit unsigned long
      Result.Numerator:=ReadDWord;
    end;
  5: begin
      // rational: Two longs: numerator + denominator
      // this does not fit into 4 bytes
      EntryStart:=ReadDWord;
      SetStreamPos(EntryStart);
      Result.Numerator:=ReadDWord;
      Result.Denominator:=ReadDWord;
    end;
  else
    TiffError('expected rational unsigned value, but found type='+IntToStr(EntryType));
  end;
end;

function TFPReaderTiff.ReadEntryString: string;
var
  EntryType: Word;
  EntryCount: LongWord;
  EntryStart: LongWord;
begin
  Result:='';
  EntryType:=ReadWord;
  if EntryType<>2 then
    TiffError('asciiz expected, but found '+IntToStr(EntryType));
  EntryCount:=ReadDWord;
  EntryStart:=ReadDWord;
  SetStreamPos(EntryStart);
  SetLength(Result,EntryCount-1);
  if EntryCount>1 then
    s.Read(Result[1],EntryCount-1);
end;

function TFPReaderTiff.ReadByte: Byte;
begin
  Result:=s.ReadByte;
end;

function TFPReaderTiff.ReadWord: Word;
begin
  Result:=FixEndian(s.ReadWord);
end;

function TFPReaderTiff.ReadDWord: DWord;
begin
  Result:=FixEndian(s.ReadDWord);
end;

procedure TFPReaderTiff.ReadValues(StreamPos: DWord;
  out EntryType: word; out EntryCount: DWord;
  out Buffer: Pointer; out ByteCount: PtrUint);
var
  EntryStart: DWord;
begin
  Buffer:=nil;
  ByteCount:=0;
  EntryType:=0;
  EntryCount:=0;
  SetStreamPos(StreamPos);
  ReadWord; // skip tag
  EntryType:=ReadWord;
  EntryCount:=ReadDWord;
  if EntryCount=0 then exit;
  case EntryType of
  1,6,7: ByteCount:=EntryCount; // byte
  2: ByteCount:=EntryCount; // asciiz
  3,8: ByteCount:=2*EntryCount; // short
  4,9: ByteCount:=4*EntryCount; // long
  5,10: ByteCount:=8*EntryCount; // rational
  11: ByteCount:=4*EntryCount; // single
  12: ByteCount:=8*EntryCount; // double
  else
    TiffError('invalid EntryType '+IntToStr(EntryType));
  end;
  if ByteCount>4 then begin
    EntryStart:=ReadDWord;
    SetStreamPos(EntryStart);
  end;
  GetMem(Buffer,ByteCount);
  s.Read(Buffer^,ByteCount);
end;

procedure TFPReaderTiff.ReadShortOrLongValues(StreamPos: DWord; out
  Buffer: PDWord; out Count: DWord);
var
  p: Pointer;
  ByteCount: PtrUInt;
  EntryType: word;
  i: DWord;
begin
  Buffer:=nil;
  Count:=0;
  p:=nil;
  try
    ReadValues(StreamPos,EntryType,Count,p,ByteCount);
    if Count=0 then exit;
    if EntryType=3 then begin
      // short
      GetMem(Buffer,SizeOf(DWord)*Count);
      for i:=0 to Count-1 do
        Buffer[i]:=FixEndian(PWord(p)[i]);
    end else if EntryType=4 then begin
      // long
      Buffer:=p;
      p:=nil;
      if FReverseEndian then
        for i:=0 to Count-1 do
          Buffer[i]:=FixEndian(PDWord(Buffer)[i]);
    end else
      TiffError('only short or long allowed');
  finally
    if p<>nil then FreeMem(p);
  end;
end;

procedure TFPReaderTiff.ReadShortValues(StreamPos: DWord; out Buffer: PWord;
  out Count: DWord);
var
  p: Pointer;
  ByteCount: PtrUInt;
  EntryType: word;
  i: DWord;
begin
  Buffer:=nil;
  Count:=0;
  p:=nil;
  try
    ReadValues(StreamPos,EntryType,Count,p,ByteCount);
    if Count=0 then exit;
    if EntryType=3 then begin
      // short
      Buffer:=p;
      p:=nil;
      if FReverseEndian then
        for i:=0 to Count-1 do
          Buffer[i]:=FixEndian(Buffer[i]);
    end else
      TiffError('only short allowed, but found '+IntToStr(EntryType));
  finally
    if p<>nil then FreeMem(p);
  end;
end;

procedure TFPReaderTiff.ReadImage(Index: integer);
var
  StripCount: DWord;
  StripOffsets: PDWord;
  StripByteCounts: PDWord;
  StripIndex: Dword;
  SOCount: DWord;
  SBCCount: DWord;
  CurOffset: DWord;
  CurByteCnt: PtrInt;
  Strip: PByte;
  Run: Dword;
  y: DWord;
  y2: DWord;
  x: DWord;
  Pixel: DWord;
  dx: LongInt;
  dy: LongInt;
  SampleCnt: DWord;
  SampleBits: PWord;
  ExtraSampleCnt: DWord;
  ExtraSamples: PWord;
  RedValue: Word;
  GreenValue: Word;
  BlueValue: Word;
  AlphaValue: Word;
  Col: TFPColor;
  i: Integer;
  CurImg: TFPCustomImage;
  GrayBits: Word;
  RedBits: Word;
  GreenBits: Word;
  BlueBits: Word;
  AlphaBits: Word;
  BytesPerPixel: Integer;
begin
  if IDF.PhotoMetricInterpretation=High(IDF.PhotoMetricInterpretation) then
    TiffError('missing PhotometricInterpretation');
  if IDF.RowsPerStrip=0 then
    TiffError('missing RowsPerStrip');
  if IDF.BitsPerSample=0 then
    TiffError('missing BitsPerSample');
  if (IDF.ImageWidth=0) or (IDF.ImageHeight=0) then begin
    exit;
  end;

  if (Index>0) and (not FirstImg.ImageIsThumbNail) then begin
    // Image already read
    exit;
  end;
  CurImg:=FirstImg.Img;
  FirstImg.Assign(IDF);

  ClearTiffExtras(CurImg);
  // set Tiff extra attributes
  CurImg.Extra[TiffPhotoMetric]:=IntToStr(IDF.PhotoMetricInterpretation);
  //writeln('TFPReaderTiff.ReadImage PhotoMetric=',CurImg.Extra[TiffPhotoMetric]);
  if IDF.Artist<>'' then
    CurImg.Extra[TiffArtist]:=IDF.Artist;
  if IDF.Copyright<>'' then
    CurImg.Extra[TiffCopyright]:=IDF.Copyright;
  if IDF.DocumentName<>'' then
    CurImg.Extra[TiffDocumentName]:=IDF.DocumentName;
  if IDF.DateAndTime<>'' then
    CurImg.Extra[TiffDateTime]:=IDF.DateAndTime;
  if IDF.ImageDescription<>'' then
    CurImg.Extra[TiffImageDescription]:=IDF.ImageDescription;
  if IDF.Orientation<>0 then
    CurImg.Extra[TiffOrientation]:=IntToStr(IDF.Orientation);
  if IDF.ResolutionUnit<>0 then
    CurImg.Extra[TiffResolutionUnit]:=IntToStr(IDF.ResolutionUnit);
  if (IDF.XResolution.Numerator<>0) or (IDF.XResolution.Denominator<>0) then
    CurImg.Extra[TiffXResolution]:=TiffRationalToStr(IDF.XResolution);
  if (IDF.YResolution.Numerator<>0) or (IDF.YResolution.Denominator<>0) then
    CurImg.Extra[TiffYResolution]:=TiffRationalToStr(IDF.YResolution);
  //WriteTiffExtras('ReadImage',CurImg);

  StripCount:=((IDF.ImageHeight-1) div IDF.RowsPerStrip)+1;
  StripOffsets:=nil;
  StripByteCounts:=nil;
  Strip:=nil;
  ExtraSamples:=nil;
  SampleBits:=nil;
  ExtraSampleCnt:=0;
  try
    ReadShortOrLongValues(IDF.StripOffsets,StripOffsets,SOCount);
    if SOCount<>StripCount then
      TiffError('number of StripCounts is wrong');
    ReadShortOrLongValues(IDF.StripByteCounts,StripByteCounts,SBCCount);
    if SBCCount<>StripCount then
      TiffError('number of StripByteCounts is wrong');

    ReadShortValues(IDF.BitsPerSample,SampleBits,SampleCnt);
    if SampleCnt<>IDF.SamplesPerPixel then
      TiffError('Samples='+IntToStr(SampleCnt)+' <> SamplesPerPixel='+IntToStr(IDF.SamplesPerPixel));
    if IDF.ExtraSamples>0 then
      ReadShortValues(IDF.ExtraSamples,ExtraSamples,ExtraSampleCnt);
    if ExtraSampleCnt>=SampleCnt then
      TiffError('Samples='+IntToStr(SampleCnt)+' ExtraSampleCnt='+IntToStr(ExtraSampleCnt));

    case IDF.PhotoMetricInterpretation of
    0,1: if SampleCnt-ExtraSampleCnt<>1 then
      TiffError('gray images expects one sample per pixel, but found '+IntToStr(SampleCnt));
    2: if SampleCnt-ExtraSampleCnt<>3 then
      TiffError('rgb images expects three samples per pixel, but found '+IntToStr(SampleCnt));
    3: if SampleCnt-ExtraSampleCnt<>1 then
      TiffError('palette images expects one sample per pixel, but found '+IntToStr(SampleCnt));
    4: if SampleCnt-ExtraSampleCnt<>1 then
      TiffError('mask images expects one sample per pixel, but found '+IntToStr(SampleCnt));
    end;

    GrayBits:=0;
    RedBits:=0;
    GreenBits:=0;
    BlueBits:=0;
    AlphaBits:=0;
    BytesPerPixel:=0;
    case IDF.PhotoMetricInterpretation of
    0,1:
      begin
        GrayBits:=SampleBits[0];
        CurImg.Extra[TiffGrayBits]:=IntToStr(GrayBits);
        for i:=0 to ExtraSampleCnt-1 do
          if ExtraSamples[i]=2 then begin
            AlphaBits:=SampleBits[3+i];
            CurImg.Extra[TiffAlphaBits]:=IntToStr(AlphaBits);
          end;
      end;
    2:
      begin
        RedBits:=SampleBits[0];
        GreenBits:=SampleBits[0];
        BlueBits:=SampleBits[0];
        CurImg.Extra[TiffRedBits]:=IntToStr(RedBits);
        CurImg.Extra[TiffGreenBits]:=IntToStr(GreenBits);
        CurImg.Extra[TiffBlueBits]:=IntToStr(BlueBits);
        for i:=0 to ExtraSampleCnt-1 do
          if ExtraSamples[i]=2 then begin
            AlphaBits:=SampleBits[3+i];
            CurImg.Extra[TiffAlphaBits]:=IntToStr(AlphaBits);
          end;
      end;
    end;
    BytesPerPixel:=(GrayBits+RedBits+GreenBits+BlueBits+AlphaBits) div 8;

    if not (IDF.FillOrder in [0,1]) then
      TiffError('FillOrder unsupported: '+IntToStr(IDF.FillOrder));

    for StripIndex:=0 to SampleCnt-1 do begin
      if not (SampleBits[StripIndex] in [8,16]) then
        TiffError('SampleBits unsupported: '+IntToStr(SampleBits[StripIndex]));
    end;

    if CurImg=nil then exit;
    case IDF.Orientation of
    0,1..4: CurImg.SetSize(IDF.ImageWidth,IDF.ImageHeight);
    5..8: CurImg.SetSize(IDF.ImageHeight,IDF.ImageWidth);
    end;

    y:=0;
    for StripIndex:=0 to StripCount-1 do begin
      CurOffset:=StripOffsets[StripIndex];
      CurByteCnt:=StripByteCounts[StripIndex];
      //writeln('TFPReaderTiff.ReadImage CurOffset=',CurOffset,' CurByteCnt=',CurByteCnt);
      if CurByteCnt<=0 then continue;
      ReAllocMem(Strip,CurByteCnt);
      SetStreamPos(CurOffset);
      s.Read(Strip^,CurByteCnt);

      // decompress
      case IDF.Compression of
      1: ; // not compressed
      2: DecompressPackBits(Strip,CurByteCnt); // packbits
      else
        TiffError('compression '+IntToStr(IDF.Compression)+' not supported yet');
      end;
      if CurByteCnt<=0 then continue;

      Run:=0;
      dx:=0;
      dy:=0;
      for y2:=0 to IDF.RowsPerStrip-1 do begin
        if y>=IDF.ImageHeight then break;
        //writeln('TFPReaderTiff.ReadImage y=',y,' IDF.ImageWidth=',IDF.ImageWidth);
        for x:=0 to IDF.ImageWidth-1 do begin
          if PtrInt(Run)+BytesPerPixel>CurByteCnt then begin
            TiffError('TFPReaderTiff.ReadImage Strip too short Run='+IntToStr(Run)+' CurByteCnt='+IntToStr(CurByteCnt)+' x='+IntToStr(x)+' y='+IntToStr(y)+' y2='+IntToStr(y2));
            break;
          end;
          case IDF.PhotoMetricInterpretation of
          0,1:
            begin
              if GrayBits=8 then begin
                Pixel:=PCUInt8(Strip)[Run];
                Pixel:=Pixel shl 8+Pixel;
                inc(Run);
              end else if GrayBits=16 then begin
                Pixel:=FixEndian(PCUInt16(@Strip[Run])^);
                inc(Run,2);
              end else
                TiffError('gray image only supported with BitsPerSample 8 or 16 not yet supported');
              if IDF.PhotoMetricInterpretation=0 then
                Pixel:=$ffff-Pixel;
              AlphaValue:=alphaOpaque;
              for i:=0 to ExtraSampleCnt-1 do begin
                if ExtraSamples[i]=2 then begin
                  if SampleBits[3+i]=8 then begin
                    AlphaValue:=PCUInt8(Strip)[Run];
                    AlphaValue:=AlphaValue shl 8+AlphaValue;
                    inc(Run);
                  end else begin
                    AlphaValue:=FixEndian(PCUInt16(@Strip[Run])^);
                    inc(Run,2);
                  end;
                end else begin
                  inc(Run,ExtraSamples[i] div 8);
                end;
              end;
              Col:=FPColor(Pixel,Pixel,Pixel,AlphaValue);
            end;

          2:
            begin
              if RedBits=8 then begin
                RedValue:=PCUInt8(Strip)[Run];
                RedValue:=RedValue shl 8+RedValue;
                inc(Run);
              end else begin
                RedValue:=FixEndian(PCUInt16(@Strip[Run])^);
                inc(Run,2);
              end;
              if GreenBits=8 then begin
                GreenValue:=PCUInt8(Strip)[Run];
                GreenValue:=GreenValue shl 8+GreenValue;
                inc(Run);
              end else begin
                GreenValue:=FixEndian(PCUInt16(@Strip[Run])^);
                inc(Run,2);
              end;
              if BlueBits=8 then begin
                BlueValue:=PCUInt8(Strip)[Run];
                BlueValue:=BlueValue shl 8+BlueValue;
                inc(Run);
              end else begin
                BlueValue:=FixEndian(PCUInt16(@Strip[Run])^);
                inc(Run,2);
              end;
              AlphaValue:=alphaOpaque;
              for i:=0 to ExtraSampleCnt-1 do begin
                if ExtraSamples[i]=2 then begin
                  if SampleBits[3+i]=8 then begin
                    AlphaValue:=PCUInt8(Strip)[Run];
                    AlphaValue:=AlphaValue shl 8+AlphaValue;
                    inc(Run);
                  end else begin
                    AlphaValue:=FixEndian(PCUInt16(@Strip[Run])^);
                    inc(Run,2);
                  end;
                end else begin
                  inc(Run,ExtraSamples[i] div 8);
                end;
              end;
              Col:=FPColor(RedValue,GreenValue,BlueValue,AlphaValue);
            end;
          else
            TiffError('PhotometricInterpretation='+IntToStr(IDF.PhotoMetricInterpretation)+' not supported');
          end;

          // Orientation
          case IDF.Orientation of
          1: begin dx:=x; dy:=y; end;// 0,0 is left, top
          2: begin dx:=IDF.ImageWidth-x-1; dy:=y; end;// 0,0 is right, top
          3: begin dx:=IDF.ImageWidth-x-1; dy:=IDF.ImageHeight-y-1; end;// 0,0 is right, bottom
          4: begin dx:=x; dy:=IDF.ImageHeight-y; end;// 0,0 is left, bottom
          5: begin dx:=y; dy:=x; end;// 0,0 is top, left (rotated)
          6: begin dx:=IDF.ImageHeight-y-1; dy:=x; end;// 0,0 is top, right (rotated)
          7: begin dx:=IDF.ImageHeight-y-1; dy:=IDF.ImageWidth-x-1; end;// 0,0 is bottom, right (rotated)
          8: begin dx:=y; dy:=IDF.ImageWidth-x-1; end;// 0,0 is bottom, left (rotated)
          end;
          CurImg.Colors[dx,dy]:=Col;
        end;
        inc(y);
      end;
    end;
  finally
    ReAllocMem(ExtraSamples,0);
    ReAllocMem(SampleBits,0);
    ReAllocMem(StripOffsets,0);
    ReAllocMem(StripByteCounts,0);
    ReAllocMem(Strip,0);
    FirstImg.Assign(IDF);
  end;
end;

function TFPReaderTiff.FixEndian(w: Word): Word; inline;
begin
  Result:=w;
  if FReverseEndian then
    Result:=((Result and $ff) shl 8) or (Result shr 8);
end;

function TFPReaderTiff.FixEndian(d: DWord): DWord; inline;
begin
  Result:=d;
  if FReverseEndian then
    Result:=((Result and $ff) shl 24)
          or ((Result and $ff00) shl 8)
          or ((Result and $ff0000) shr 8)
          or (Result shr 24);
end;

procedure TFPReaderTiff.DecompressPackBits(var Buffer: Pointer; var Count: PtrInt
  );
var
  p: Pcint8;
  n: cint8;
  NewBuffer: Pcint8;
  SrcStep: PtrInt;
  NewCount: Integer;
  i: PtrInt;
  d: pcint8;
  j: ShortInt;
begin
  // compute NewCount
  NewCount:=0;
  p:=Pcint8(Buffer);
  i:=Count;
  while i>0 do begin
    n:=p^;
    case n of
    0..127:   begin inc(NewCount,n+1);  SrcStep:=n+2; end; // copy the next n+1 bytes
    -127..-1: begin inc(NewCount,-n+1); SrcStep:=2;   end; // copy the next byte n+1 times
    else SrcStep:=1; // noop
    end;
    inc(p,SrcStep);
    dec(i,SrcStep);
  end;

  // decompress
  if NewCount=0 then begin
    NewBuffer:=nil;
  end else begin
    GetMem(NewBuffer,NewCount);
    i:=Count;
    p:=Pcint8(Buffer);
    d:=Pcint8(NewBuffer);
    while i>0 do begin
      n:=p^;
      case n of
      0..127:
        begin
          // copy the next n+1 bytes
          inc(NewCount,n+1);  SrcStep:=n+2;
          System.Move(p[1],d^,n+1);
          inc(d,n+1);
        end;
      -127..-1:
        begin
          // copy the next byte n+1 times
          inc(NewCount,-n+1); SrcStep:=2;
          j:=-n;
          n:=p[1];
          while j>=0 do begin
            d[j]:=n;
            dec(j);
          end;
        end;
      else SrcStep:=1; // noop
      end;
      inc(p,SrcStep);
      dec(i,SrcStep);
    end;
  end;
  FreeMem(Buffer);
  Buffer:=NewBuffer;
  Count:=NewCount;
end;

procedure TFPReaderTiff.InternalRead(Str: TStream; AnImage: TFPCustomImage);
begin
  FirstImg.Img:=AnImage;
  try
    LoadFromStream(Str);
  finally
    FirstImg.Img:=nil;
  end;
end;

function TFPReaderTiff.InternalCheck(Str: TStream): boolean;
var
  IFD: DWord;
begin
  try
    s:=Str;
    fStartPos:=s.Position;
    Result:=ReadTiffHeader(true,IFD) and (IFD<>0);
    s.Position:=fStartPos;
  except
    Result:=false;
  end;
end;

constructor TFPReaderTiff.Create;
begin
  IDF:=TTiffIDF.Create;
  FirstImg:=TTiffIDF.Create;
end;

destructor TFPReaderTiff.Destroy;
begin
  Clear;
  FreeAndNil(FirstImg);
  FreeAndNil(IDF);
  inherited Destroy;
end;

procedure TFPReaderTiff.Clear;
begin
  IDF.Clear;
  FirstImg.Clear;
  FReverseEndian:=false;
  FreeAndNil(fIFDStarts);
end;

end.

