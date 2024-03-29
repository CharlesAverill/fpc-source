{
    This file is part of the Free Pascal run time library.
    Copyright (c) 2006 by Karoly Balogh

    dos.library functions for AmigaOS 4.x/PowerPC

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

function Open(name: PAnsiChar; accessMode: longint): longint; syscall IDOS 76;
function dosClose(_file: longint): LongBool; syscall IDOS 80;
function dosRead(_file: longint; buffer: Pointer; length: longint): longint; syscall IDOS 84;
function dosWrite(_file: longint; buffer: Pointer; length: longint): longint; syscall IDOS 88;
function dosInput: longint; syscall IDOS 92;
function dosOutput: longint; syscall IDOS 96;
function dosSeek(_file: longint;position: longint;offset: longint): longint; syscall IDOS 100;
function dosDeleteFile(name: PAnsiChar): LongBool; syscall IDOS 104;
function dosRename(oldName: PAnsiChar;newName: PAnsiChar): longint; syscall IDOS 108;
function Lock(name: PAnsiChar;_type: longint): longint; syscall IDOS 112;
procedure UnLock(lock: longint); syscall IDOS 116;

function Examine(lock: longint; fileInfoBlock: PFileInfoBlock): LongInt; syscall IDOS 124;

function Info(lock: longint; parameterBlock: PInfoData): LongInt; syscall IDOS 132;
function dosCreateDir(name: PAnsiChar): longint; syscall IDOS 136;
function CurrentDir(lock: longint): longint; syscall IDOS 140;
function IoErr: longint; syscall IDOS 144;

function SetProtection(name: PAnsiChar; protect: longword): LongInt; syscall IDOS 180;
function DateStamp(date: PDateStamp): PDateStamp; syscall IDOS 184;
procedure DOSDelay(timeout: LongInt); syscall IDOS 188;

function AllocDosObject(type1: Cardinal; tags : PTagItem): Pointer; syscall IDOS 208;
procedure FreeDosObject(type1: Cardinal; ptr  : Pointer); syscall IDOS 220;

function ExamineFH(fh : BPTR; fib: PFileInfoBlock): LongBool; syscall IDOS 352;
function SetFileDate(name: PAnsiChar; date: PDateStamp): LongBool; syscall IDOS 356; { Seems this got renamed to SetDate() in OS4? }
function NameFromLock(lock: longint; buffer: PAnsiChar; len: longint): LongBool; syscall IDOS 360;
function NameFromFH(fh: longint; buffer: PAnsiChar; len: longint): LongBool; syscall IDOS 364;

function SetFileSize(fh: longint; pos: longint; mode: longint): longint; syscall IDOS 396;

function CreateNewProc(tags: PTagItem): PProcess; syscall IDOS 424;

function GetArgStr: PAnsiChar; syscall IDOS 456;
function SetArgStr(_string: PAnsiChar): PAnsiChar; syscall IDOS 460;

function GetCurrentDirName(buf: PAnsiChar; len: longint): LongBool; syscall IDOS 476;

function GetProgramName(buf: PAnsiChar; len: longint): LongBool; syscall IDOS 484;

function GetProgramDir: longint; syscall IDOS 500;
function SystemTagList(command: PAnsiChar; tags: PTagItem): longint; syscall IDOS 504;

function LockDosList(flags: longword): PDosList; syscall IDOS 544;
procedure UnLockDosList(flags: longword); syscall IDOS 548;

function NextDosEntry(dlist: PDosList; flags: longword): PDosList; syscall IDOS 568;

function MatchFirst(pat: PAnsiChar; anchor: PAnchorPath): longint; syscall IDOS 664;
function MatchNext(anchor: PAnchorPath): longint; syscall IDOS 668;
procedure MatchEnd(anchor: PAnchorPath); syscall IDOS 672;

function GetVar(name: PAnsiChar; buffer: PAnsiChar; size: longint; flags: longword): longint; syscall IDOS 720;
