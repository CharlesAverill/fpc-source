{
    $Id$

    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by Florian Klaempfl
    member of the Free Pascal development team

    Sysutils unit for OS/2

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit sysutils;
interface

{$MODE objfpc}
{ force ansistrings }
{$H+}

uses
 Dos;

{ Include platform independent interface part }
{$i sysutilh.inc}


implementation

{ Include platform independent implementation part }
{$i sysutils.inc}


{****************************************************************************
                        System (imported) calls
****************************************************************************}

(* "uses DosCalls" could not be used here due to type    *)
(* conflicts, so needed parts had to be redefined here). *)

type
 TFileStatus = object
               end;
 PFileStatus = ^TFileStatus;

 TFileStatus0 = object (TFileStatus)
                 DateCreation,        {Date of file creation.}
                 TimeCreation,        {Time of file creation.}
                 DateLastAccess,      {Date of last access to file.}
                 TimeLastAccess,      {Time of last access to file.}
                 DateLastWrite,       {Date of last modification of file.}
                 TimeLastWrite: word; {Time of last modification of file.}
                 FileSize,            {Size of file.}
                 FileAlloc: cardinal; {Amount of space the file really
                                       occupies on disk.}
                end;
 PFileStatus0 = ^TFileStatus0;

 TFileStatus3 = object (TFileStatus)
                 NextEntryOffset: cardinal; {Offset of next entry}
                 DateCreation,             {Date of file creation.}
                 TimeCreation,             {Time of file creation.}
                 DateLastAccess,           {Date of last access to file.}
                 TimeLastAccess,           {Time of last access to file.}
                 DateLastWrite,            {Date of last modification of file.}
                 TimeLastWrite: word;      {Time of last modification of file.}
                 FileSize,                 {Size of file.}
                 FileAlloc: cardinal;      {Amount of space the file really
                                            occupies on disk.}
                 AttrFile: cardinal;       {Attributes of file.}
                end;
 PFileStatus3 = ^TFileStatus3;

 TFileFindBuf3 = object (TFileStatus3)
                  Name: ShortString;       {Also possible to use as ASCIIZ.
                                            The byte following the last string
                                            character is always zero.}
                 end;
 PFileFindBuf3 = ^TFileFindBuf3;

 TFSInfo = record
            case word of
             1:
              (File_Sys_ID,
               Sectors_Per_Cluster,
               Total_Clusters,
               Free_Clusters: cardinal;
               Bytes_Per_Sector: word);
             2:                           {For date/time description,
                                           see file searching realted
                                           routines.}
              (Label_Date,                {Date when volume label was created.}
               Label_Time: word;          {Time when volume label was created.}
               VolumeLabel: ShortString); {Volume label. Can also be used
                                           as ASCIIZ, because the byte
                                           following the last character of
                                           the string is always zero.}
           end;
 PFSInfo = ^TFSInfo;

 TCountryCode=record
               Country,            {Country to query info about (0=current).}
               CodePage: cardinal; {Code page to query info about (0=current).}
              end;
 PCountryCode=^TCountryCode;

 TTimeFmt = (Clock12, Clock24);

 TCountryInfo=record
               Country, CodePage: cardinal;  {Country and codepage requested.}
               case byte of
                0:
                 (DateFormat: cardinal;     {1=ddmmyy 2=yymmdd 3=mmddyy}
                  CurrencyUnit: array [0..4] of char;
                  ThousandSeparator: char;  {Thousands separator.}
                  Zero1: byte;              {Always zero.}
                  DecimalSeparator: char;   {Decimals separator,}
                  Zero2: byte;
                  DateSeparator: char;      {Date separator.}
                  Zero3: byte;
                  TimeSeparator: char;      {Time separator.}
                  Zero4: byte;
                  CurrencyFormat,           {Bit field:
                                             Bit 0: 0=indicator before value
                                                    1=indicator after value
                                             Bit 1: 1=insert space after
                                                      indicator.
                                             Bit 2: 1=Ignore bit 0&1, replace
                                                      decimal separator with
                                                      indicator.}
                  DecimalPlace: byte;       {Number of decimal places used in
                                             currency indication.}
                  TimeFormat: TTimeFmt;     {12/24 hour.}
                  Reserve1: array [0..1] of word;
                  DataSeparator: char;      {Data list separator}
                  Zero5: byte;
                  Reserve2: array [0..4] of word);
                1:
                 (fsDateFmt: cardinal;      {1=ddmmyy 2=yymmdd 3=mmddyy}
                  szCurrency: array [0..4] of char;
                                            {null terminated currency symbol}
                  szThousandsSeparator: array [0..1] of char;
                                            {Thousands separator + #0}
                  szDecimal: array [0..1] of char;
                                            {Decimals separator + #0}
                  szDateSeparator: array [0..1] of char;
                                            {Date separator + #0}
                  szTimeSeparator: array [0..1] of char;
                                            {Time separator + #0}
                  fsCurrencyFmt,            {Bit field:
                                             Bit 0: 0=indicator before value
                                                    1=indicator after value
                                             Bit 1: 1=insert space after
                                                      indicator.
                                             Bit 2: 1=Ignore bit 0&1, replace
                                                      decimal separator with
                                                      indicator}
                  cDecimalPlace: byte;      {Number of decimal places used in
                                             currency indication}
                  fsTimeFmt: byte;          {0=12,1=24 hours}
                  abReserved1: array [0..1] of word;
                  szDataSeparator: array [0..1] of char;
                                            {Data list separator + #0}
                  abReserved2: array [0..4] of word);
              end;
 PCountryInfo=^TCountryInfo;

const
 ilStandard      = 1;
 ilQueryEAsize   = 2;
 ilQueryEAs      = 3;
 ilQueryFullName = 5;

{This is the correct way to call external assembler procedures.}
procedure syscall;external name '___SYSCALL';

function DosSetFileInfo (Handle: longint; InfoLevel: cardinal; AFileStatus: PFileStatus;
        FileStatusLen: cardinal): cardinal; cdecl; external 'DOSCALLS' index 218;

function DosQueryFSInfo (DiskNum, InfoLevel: cardinal; var Buffer: TFSInfo;
               BufLen: cardinal): cardinal; cdecl; external 'DOSCALLS' index 278;

function DosQueryFileInfo (Handle: longint; InfoLevel: cardinal;
           AFileStatus: PFileStatus; FileStatusLen: cardinal): cardinal; cdecl;
                                                 external 'DOSCALLS' index 279;

function DosScanEnv (Name: PChar; var Value: PChar): cardinal; cdecl;
                                                 external 'DOSCALLS' index 227;

function DosFindFirst (FileMask: PChar; var Handle: longint; Attrib: cardinal;
                       AFileStatus: PFileStatus; FileStatusLen: cardinal;
                    var Count: cardinal; InfoLevel: cardinal): cardinal; cdecl;
                                                 external 'DOSCALLS' index 264;

function DosFindNext (Handle: longint; AFileStatus: PFileStatus;
                FileStatusLen: cardinal; var Count: cardinal): cardinal; cdecl;
                                                 external 'DOSCALLS' index 265;

function DosFindClose (Handle: longint): cardinal; cdecl;
                                                 external 'DOSCALLS' index 263;

function DosQueryCtryInfo (Size: cardinal; var Country: TCountryCode;
           var Res: TCountryInfo; var ActualSize: cardinal): cardinal; cdecl;
                                                        external 'NLS' index 5;

function DosMapCase (Size: cardinal; var Country: TCountryCode;
                      AString: PChar): cardinal; cdecl; external 'NLS' index 7;


{****************************************************************************
                              File Functions
****************************************************************************}

const
 ofRead        = $0000;     {Open for reading}
 ofWrite       = $0001;     {Open for writing}
 ofReadWrite   = $0002;     {Open for reading/writing}
 doDenyRW      = $0010;     {DenyAll (no sharing)}
 faCreateNew   = $00010000; {Create if file does not exist}
 faOpenReplace = $00040000; {Truncate if file exists}
 faCreate      = $00050000; {Create if file does not exist, truncate otherwise}

 FindResvdMask = $00003737; {Allowed bits in attribute
                             specification for DosFindFirst call.}

{$ASMMODE INTEL}
function FileOpen (const FileName: string; Mode: integer): longint; assembler;
asm
 push ebx
 mov eax, Mode
(* DenyAll if sharing not specified. *)
 test eax, 112
 jnz @FOpen1
 or eax, 16
@FOpen1:
 mov ecx, eax
 mov eax, 7F2Bh
 mov edx, FileName
 call syscall
 pop ebx
end {['eax', 'ebx', 'ecx', 'edx']};


function FileCreate (const FileName: string): longint; assembler;
asm
 push ebx
 mov eax, 7F2Bh
 mov ecx, ofReadWrite or faCreate or doDenyRW   (* Sharing to DenyAll *)
 mov edx, FileName
 call syscall
 pop ebx
end {['eax', 'ebx', 'ecx', 'edx']};


function FileCreate (const FileName: string; Mode: longint): longint;
begin
 FileCreate := FileCreate(FileName);
end;


function FileRead (Handle: longint; var Buffer; Count: longint): longint;
                                                                     assembler;
asm
 push ebx
 mov eax, 3F00h
 mov ebx, Handle
 mov ecx, Count
 mov edx, Buffer
 call syscall
 jnc @FReadEnd
 mov eax, -1
@FReadEnd:
 pop ebx
end {['eax', 'ebx', 'ecx', 'edx']};


function FileWrite (Handle: longint; const Buffer; Count: longint): longint;
                                                                     assembler;
asm
 push ebx
 mov eax, 4000h
 mov ebx, Handle
 mov ecx, Count
 mov edx, Buffer
 call syscall
 jnc @FWriteEnd
 mov eax, -1
@FWriteEnd:
 pop ebx
end {['eax', 'ebx', 'ecx', 'edx']};


function FileSeek (Handle, FOffset, Origin: longint): longint; assembler;
asm
 push ebx
 mov eax, Origin
 mov ah, 42h
 mov ebx, Handle
 mov edx, FOffset
 call syscall
 jnc @FSeekEnd
 mov eax, -1
@FSeekEnd:
 pop ebx
end {['eax', 'ebx', 'edx']};

function FileSeek (Handle: longint; FOffset, Origin: Int64): Int64;
begin
  {$warning need to add 64bit call }
  Result:=FileSeek(Handle,Longint(Foffset),Longint(Origin));
end;

procedure FileClose (Handle: longint); assembler;
asm
 push ebx
 mov eax, Handle
 cmp eax, 2
 jbe @FCloseEnd
 mov ebx, eax
 mov eax, 3E00h
 call syscall
@FCloseEnd:
 pop ebx
end {['eax', 'ebx']};


function FileTruncate (Handle, Size: longint): boolean; assembler;
asm
 push ebx
 mov eax, 7F25h
 mov ebx, Handle
 mov edx, Size
 call syscall
 jc @FTruncEnd
 mov eax, 4202h
 mov ebx, Handle
 mov edx, 0
 call syscall
 mov eax, 0
 jnc @FTruncEnd
 dec eax
@FTruncEnd:
 pop ebx
end {['eax', 'ebx', 'ecx', 'edx']};


function FileAge (const FileName: string): longint;
var Handle: longint;
begin
    Handle := FileOpen (FileName, 0);
    if Handle <> -1 then
        begin
            Result := FileGetDate (Handle);
            FileClose (Handle);
        end
    else
        Result := -1;
end;


function FileExists (const FileName: string): boolean; assembler;
asm
 mov ax, 4300h
 mov edx, FileName
 call syscall
 mov eax, 0
 jc @FExistsEnd
 test cx, 18h
 jnz @FExistsEnd
 inc eax
@FExistsEnd:
end {['eax', 'ecx', 'edx']};


type    TRec = record
            T, D: word;
        end;
        PSearchRec = ^SearchRec;

function FindFirst (const Path: string; Attr: longint; var Rslt: TSearchRec): longint;

var SR: PSearchRec;
    FStat: PFileFindBuf3;
    Count: cardinal;
    Err: cardinal;

begin
  New (FStat);
  Rslt.FindHandle := $FFFFFFFF;
  Count := 1;
  Err := DosFindFirst (PChar (Path), Rslt.FindHandle,
               Attr and FindResvdMask, FStat, SizeOf (FStat^), Count,
                                                          ilStandard);
  if (Err = 0) and (Count = 0) then Err := 18;
  FindFirst := -Err;
  if Err = 0 then
  begin
    Rslt.Name := FStat^.Name;
    Rslt.Size := FStat^.FileSize;
    Rslt.Attr := FStat^.AttrFile;
    Rslt.ExcludeAttr := 0;
    TRec (Rslt.Time).T := FStat^.TimeLastWrite;
    TRec (Rslt.Time).D := FStat^.DateLastWrite;
  end;
  Dispose (FStat);
end;


function FindNext (var Rslt: TSearchRec): longint;

var SR: PSearchRec;
    FStat: PFileFindBuf3;
    Count: cardinal;
    Err: cardinal;

begin
            New (FStat);
            Count := 1;
            Err := DosFindNext (Rslt.FindHandle, FStat, SizeOf (FStat^),
                                                                        Count);
            if (Err = 0) and (Count = 0) then Err := 18;
            FindNext := -Err;
            if Err = 0 then
                begin
                    Rslt.Name := FStat^.Name;
                    Rslt.Size := FStat^.FileSize;
                    Rslt.Attr := FStat^.AttrFile;
                    Rslt.ExcludeAttr := 0;
                    TRec (Rslt.Time).T := FStat^.TimeLastWrite;
                    TRec (Rslt.Time).D := FStat^.DateLastWrite;
                end;
            Dispose (FStat);
end;


procedure FindClose (var F: TSearchrec);

var SR: PSearchRec;

begin
    DosFindClose (F.FindHandle);
    F.FindHandle := 0;
end;


function FileGetDate (Handle: longint): longint; assembler;
asm
 push ebx
 mov ax, 5700h
 mov ebx, Handle
 call syscall
 mov eax, -1
 jc @FGetDateEnd
 mov ax, dx
 shld eax, ecx, 16
@FGetDateEnd:
 pop ebx
end {['eax', 'ebx', 'ecx', 'edx']};


function FileSetDate (Handle, Age: longint): longint;
var FStat: PFileStatus0;
    RC: cardinal;
begin
            New (FStat);
            RC := DosQueryFileInfo (Handle, ilStandard, FStat,
                                                              SizeOf (FStat^));
            if RC <> 0 then
                FileSetDate := -1
            else
                begin
                    FStat^.DateLastAccess := Hi (Age);
                    FStat^.DateLastWrite := Hi (Age);
                    FStat^.TimeLastAccess := Lo (Age);
                    FStat^.TimeLastWrite := Lo (Age);
                    RC := DosSetFileInfo (Handle, ilStandard, FStat,
                                                              SizeOf (FStat^));
                    if RC <> 0 then
                        FileSetDate := -1
                    else
                        FileSetDate := 0;
                end;
            Dispose (FStat);
end;


function FileGetAttr (const FileName: string): longint; assembler;
asm
 mov ax, 4300h
 mov edx, FileName
 call syscall
 jnc @FGetAttrEnd
 mov eax, -1
@FGetAttrEnd:
end {['eax', 'edx']};


function FileSetAttr (const Filename: string; Attr: longint): longint; assembler;
asm
 mov ax, 4301h
 mov ecx, Attr
 mov edx, FileName
 call syscall
 mov eax, 0
 jnc @FSetAttrEnd
 mov eax, -1
@FSetAttrEnd:
end {['eax', 'ecx', 'edx']};


function DeleteFile (const FileName: string): boolean; assembler;
asm
 mov ax, 4100h
 mov edx, FileName
 call syscall
 mov eax, 0
 jc @FDeleteEnd
 inc eax
@FDeleteEnd:
end {['eax', 'edx']};


function RenameFile (const OldName, NewName: string): boolean; assembler;
asm
 push edi
 mov ax, 5600h
 mov edx, OldName
 mov edi, NewName
 call syscall
 mov eax, 0
 jc @FRenameEnd
 inc eax
@FRenameEnd:
 pop edi
end {['eax', 'edx', 'edi']};


{****************************************************************************
                              Disk Functions
****************************************************************************}

{$ASMMODE ATT}

function DiskFree (Drive: byte): int64;

var FI: TFSinfo;
    RC: cardinal;

begin
        {In OS/2, we use the filesystem information.}
            RC := DosQueryFSInfo (Drive, 1, FI, SizeOf (FI));
            if RC = 0 then
                DiskFree := int64 (FI.Free_Clusters) *
                   int64 (FI.Sectors_Per_Cluster) * int64 (FI.Bytes_Per_Sector)
            else
                DiskFree := -1;
end;

function DiskSize (Drive: byte): int64;

var FI: TFSinfo;
    RC: cardinal;

begin
        {In OS/2, we use the filesystem information.}
            RC := DosQueryFSinfo (Drive, 1, FI, SizeOf (FI));
            if RC = 0 then
                DiskSize := int64 (FI.Total_Clusters) *
                   int64 (FI.Sectors_Per_Cluster) * int64 (FI.Bytes_Per_Sector)
            else
                DiskSize := -1;
end;


function GetCurrentDir: string;
begin
 GetDir (0, Result);
end;


function SetCurrentDir (const NewDir: string): boolean;
begin
{$I-}
 ChDir (NewDir);
 Result := (IOResult = 0);
{$I+}
end;


function CreateDir (const NewDir: string): boolean;
begin
{$I-}
 MkDir (NewDir);
 Result := (IOResult = 0);
{$I+}
end;


function RemoveDir (const Dir: string): boolean;
begin
{$I-}
 RmDir (Dir);
 Result := (IOResult = 0);
 {$I+}
end;


{$ASMMODE INTEL}
function DirectoryExists (const Directory: string): boolean; assembler;
asm
 mov ax, 4300h
 mov edx, Directory
 call syscall
 mov eax, 0
 jc @FExistsEnd
 test cx, 10h
 jz @FExistsEnd
 inc eax
@FExistsEnd:
end {['eax', 'ecx', 'edx']};


{****************************************************************************
                              Time Functions
****************************************************************************}

procedure GetLocalTime (var SystemTime: TSystemTime); assembler;
asm
(* Expects the default record alignment (word)!!! *)
 push edi
 mov ah, 2Ah
 call syscall
 mov edi, SystemTime
 mov ax, cx
 stosw
 xor eax, eax
 mov al, 10
 mul dl
 shl eax, 16
 mov al, dh
 stosd
 push edi
 mov ah, 2Ch
 call syscall
 pop edi
 xor eax, eax
 mov al, cl
 shl eax, 16
 mov al, ch
 stosd
 mov al, dl
 shl eax, 16
 mov al, dh
 stosd
 pop edi
end {['eax', 'ecx', 'edx', 'edi']};
{$asmmode default}

{****************************************************************************
                              Misc Functions
****************************************************************************}

procedure Beep;
begin
end;


{****************************************************************************
                              Locale Functions
****************************************************************************}

procedure InitAnsi;
var I: byte;
    Country: TCountryCode;
begin
    for I := 0 to 255 do
        UpperCaseTable [I] := Chr (I);
    Move (UpperCaseTable, LowerCaseTable, SizeOf (UpperCaseTable));
            FillChar (Country, SizeOf (Country), 0);
            DosMapCase (SizeOf (UpperCaseTable), Country, @UpperCaseTable);
    for I := 0 to 255 do
        if UpperCaseTable [I] <> Chr (I) then
            LowerCaseTable [Ord (UpperCaseTable [I])] := Chr (I);
end;


procedure InitInternational;
var Country: TCountryCode;
    CtryInfo: TCountryInfo;
    Size: cardinal;
    RC: cardinal;
begin
    Size := 0;
    FillChar (Country, SizeOf (Country), 0);
    FillChar (CtryInfo, SizeOf (CtryInfo), 0);
    RC := DosQueryCtryInfo (SizeOf (CtryInfo), Country, CtryInfo, Size);
    if RC = 0 then
        begin
            DateSeparator := CtryInfo.DateSeparator;
            case CtryInfo.DateFormat of
             1: begin
                    ShortDateFormat := 'd/m/y';
                    LongDateFormat := 'dd" "mmmm" "yyyy';
                end;
             2: begin
                    ShortDateFormat := 'y/m/d';
                    LongDateFormat := 'yyyy" "mmmm" "dd';
                end;
             3: begin
                    ShortDateFormat := 'm/d/y';
                    LongDateFormat := 'mmmm" "dd" "yyyy';
                end;
            end;
            TimeSeparator := CtryInfo.TimeSeparator;
            DecimalSeparator := CtryInfo.DecimalSeparator;
            ThousandSeparator := CtryInfo.ThousandSeparator;
            CurrencyFormat := CtryInfo.CurrencyFormat;
            CurrencyString := PChar (CtryInfo.CurrencyUnit);
        end;
    InitAnsi;
end;

function SysErrorMessage(ErrorCode: Integer): String;

begin
  Result:=Format(SUnknownErrorCode,[ErrorCode]);
end;


{****************************************************************************
                              OS Utils
****************************************************************************}

Function GetEnvironmentVariable(Const EnvVar : String) : String;

begin
    GetEnvironmentVariable := StrPas (GetEnvPChar (EnvVar));
end;


{****************************************************************************
                              Initialization code
****************************************************************************}

Initialization
  InitExceptions;       { Initialize exceptions. OS independent }
  InitInternational;    { Initialize internationalization settings }
Finalization
  DoneExceptions;
end.

{
  $Log$
  Revision 1.34  2003-10-18 16:58:39  hajny
    * stdcall fixes again

  Revision 1.33  2003/10/13 21:17:31  hajny
    * longint to cardinal corrections

  Revision 1.32  2003/10/08 05:22:47  yuri
  * Some emx code removed

  Revision 1.31  2003/10/07 21:26:34  hajny
    * stdcall fixes and asm routines cleanup

  Revision 1.30  2003/10/03 21:46:41  peter
    * stdcall fixes

  Revision 1.29  2003/06/06 23:34:40  hajny
    * better fix for bug 2518

  Revision 1.28  2003/06/06 23:31:17  hajny
    * fix for bug 2518 applied to OS/2 as well

  Revision 1.27  2003/04/01 15:57:41  peter
    * made THandle platform dependent and unique type

  Revision 1.26  2003/03/31 02:18:39  yuri
  FileClose bug fixed (again ;))

  Revision 1.25  2003/03/29 19:14:16  yuri
    * Directoryexists function header changed back.

  Revision 1.24  2003/03/29 18:53:10  yuri
    * Fixed DirectoryExists function header

  Revision 1.23  2003/03/29 15:01:20  hajny
    + DirectoryExists added for main branch OS/2 too

  Revision 1.22  2003/03/01 21:19:14  hajny
    * FileClose bug fixed

  Revision 1.21  2003/01/04 16:25:08  hajny
    * modified to make use of the common GetEnv code

  Revision 1.20  2003/01/03 20:41:04  peter
    * FileCreate(string,mode) overload added

  Revision 1.19  2002/11/18 19:51:00  hajny
    * another bunch of type corrections

  Revision 1.18  2002/09/23 17:42:37  hajny
    * AnsiString to PChar typecast

  Revision 1.17  2002/09/07 16:01:25  peter
    * old logs removed and tabs fixed

  Revision 1.16  2002/07/11 16:00:05  hajny
    * FindFirst fix (invalid attribute bits masked out)

  Revision 1.15  2002/01/25 16:23:03  peter
    * merged filesearch() fix

}
