{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    Routines to read/write ppu files

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

 ****************************************************************************
}
unit ppu;

{$i fpcdefs.inc}

interface

  uses
    cpuinfo;

{ Also write the ppu if only crc if done, this can be used with ppudump to
  see the differences between the intf and implementation }
{ define INTFPPU}

{$ifdef Test_Double_checksum}
var
  CRCFile : text;
const
  CRC_array_Size = 200000;
type
  tcrc_array = array[0..crc_array_size] of longint;
  pcrc_array = ^tcrc_array;
{$endif Test_Double_checksum}

const
  CurrentPPUVersion=40;

{ buffer sizes }
  maxentrysize = 1024;
  ppubufsize   = 16384;

{ppu entries}
  mainentryid         = 1;
  subentryid          = 2;
  {special}
  iberror             = 0;
  ibstartdefs         = 248;
  ibenddefs           = 249;
  ibstartsyms         = 250;
  ibendsyms           = 251;
  ibendinterface      = 252;
  ibendimplementation = 253;
  ibendbrowser        = 254;
  ibend               = 255;
  {general}
  ibmodulename           = 1;
  ibsourcefiles          = 2;
  ibloadunit             = 3;
  ibinitunit             = 4;
  iblinkunitofiles       = 5;
  iblinkunitstaticlibs   = 6;
  iblinkunitsharedlibs   = 7;
  iblinkotherofiles      = 8;
  iblinkotherstaticlibs  = 9;
  iblinkothersharedlibs  = 10;
  ibdbxcount             = 11;
  ibsymref               = 12;
  ibdefref               = 13;
  ibendsymtablebrowser   = 14;
  ibbeginsymtablebrowser = 15;
  ibusedmacros           = 16;
  ibderefdata            = 17;
  {syms}
  ibtypesym       = 20;
  ibprocsym       = 21;
  ibvarsym        = 22;
  ibconstsym      = 23;
  ibenumsym       = 24;
  ibtypedconstsym = 25;
  ibabsolutesym   = 26;
  ibpropertysym   = 27;
  ibvarsym_C      = 28;
  ibunitsym       = 29;  { needed for browser }
  iblabelsym      = 30;
  ibsyssym        = 31;
  ibrttisym       = 32;
  {definitions}
  iborddef         = 40;
  ibpointerdef     = 41;
  ibarraydef       = 42;
  ibprocdef        = 43;
  ibshortstringdef = 44;
  ibrecorddef      = 45;
  ibfiledef        = 46;
  ibformaldef      = 47;
  ibobjectdef      = 48;
  ibenumdef        = 49;
  ibsetdef         = 50;
  ibprocvardef     = 51;
  ibfloatdef       = 52;
  ibclassrefdef    = 53;
  iblongstringdef  = 54;
  ibansistringdef  = 55;
  ibwidestringdef  = 56;
  ibvariantdef     = 57;
  {implementation/objectdata}
  ibnodetree       = 80;
  ibasmsymbols     = 81;

{ unit flags }
  uf_init          = $1;
  uf_finalize      = $2;
  uf_big_endian    = $4;
  uf_has_dbx       = $8;
  uf_has_browser   = $10;
  uf_in_library    = $20;     { is the file in another file than <ppufile>.* ? }
  uf_smart_linked  = $40;     { the ppu can be smartlinked }
  uf_static_linked = $80;     { the ppu can be linked static }
  uf_shared_linked = $100;    { the ppu can be linked shared }
  uf_local_browser = $200;
  uf_no_link       = $400;    { unit has no .o generated, but can still have
                                external linking! }
  uf_has_resources = $800;    { unit has resource section }
  uf_little_endian = $1000;
  uf_release       = $2000;   { unit was compiled with -Ur option }
  uf_threadvars    = $4000;   { unit has threadvars }
  uf_fpu_emulation = $8000;   { this unit was compiled with fpu emulation on }

type
  ppureal=extended;

  tppuerror=(ppuentrytoobig,ppuentryerror);

  tppuheader=packed record { 36 bytes }
    id       : array[1..3] of char; { = 'PPU' }
    ver      : array[1..3] of char;
    compiler : word;
    cpu      : word;
    target   : word;
    flags    : longint;
    size     : longint; { size of the ppufile without header }
    checksum : cardinal; { checksum for this ppufile }
    interface_checksum : cardinal;
    future   : array[0..2] of longint;
  end;

  tppuentry=packed record
    size : longint;
    id   : byte;
    nr   : byte;
  end;

  tppufile=class
  private
    f        : file;
    mode     : byte; {0 - Closed, 1 - Reading, 2 - Writing}
    fname    : string;
    fsize    : integer;
{$ifdef Test_Double_checksum}
  public
    crcindex,
    crc_index,
    crcindex2,
    crc_index2 : cardinal;
    crc_test,
    crc_test2  : pcrc_array;
  private
{$endif def Test_Double_checksum}
    change_endian : boolean;
    buf      : pchar;
    bufstart,
    bufsize,
    bufidx   : integer;
    entrybufstart,
    entrystart,
    entryidx : integer;
    entry    : tppuentry;
    closed,
    tempclosed : boolean;
    closepos : integer;
  public
    entrytyp : byte;
    header           : tppuheader;
    size             : integer;
    crc,
    interface_crc    : cardinal;
    error,
    do_crc,
    do_interface_crc : boolean;
    crc_only         : boolean;    { used to calculate interface_crc before implementation }
    constructor Create(const fn:string);
    destructor  Destroy;override;
    procedure flush;
    procedure closefile;
    function  CheckPPUId:boolean;
    function  GetPPUVersion:integer;
    procedure NewHeader;
    procedure NewEntry;
  {read}
    function  openfile:boolean;
    procedure reloadbuf;
    procedure readdata(var b;len:integer);
    procedure skipdata(len:integer);
    function  readentry:byte;
    function  EndOfEntry:boolean;
    function  entrysize:longint;
    procedure getdatabuf(var b;len:integer;var res:integer);
    procedure getdata(var b;len:integer);
    function  getbyte:byte;
    function  getword:word;
    function  getlongint:longint;
    function getint64:int64;
    function getaint:aint;
    function  getreal:ppureal;
    function  getstring:string;
    procedure getnormalset(var b);
    procedure getsmallset(var b);
    function  skipuntilentry(untilb:byte):boolean;
  {write}
    function  createfile:boolean;
    procedure writeheader;
    procedure writebuf;
    procedure writedata(const b;len:integer);
    procedure writeentry(ibnr:byte);
    procedure putdata(const b;len:integer);
    procedure putbyte(b:byte);
    procedure putword(w:word);
    procedure putlongint(l:longint);
    procedure putint64(i:int64);
    procedure putaint(i:aint);
    procedure putreal(d:ppureal);
    procedure putstring(s:string);
    procedure putnormalset(const b);
    procedure putsmallset(const b);
    procedure tempclose;
    function  tempopen:boolean;
  end;

implementation

  uses
{$ifdef Test_Double_checksum}
    comphook,
{$endif def Test_Double_checksum}
    crc,
    cutils;

{*****************************************************************************
                             Endian Handling
*****************************************************************************}

Function SwapLong(x : longint): longint;
var
  y : word;
  z : word;
Begin
  y := x shr 16;
  y := word(longint(y) shl 8) or (y shr 8);
  z := x and $FFFF;
  z := word(longint(z) shl 8) or (z shr 8);
  SwapLong := (longint(z) shl 16) or longint(y);
End;


Function SwapWord(x : word): word;
var
  z : byte;
Begin
  z := x shr 8;
  x := x and $ff;
  x := word(x shl 8);
  SwapWord := x or z;
End;


{*****************************************************************************
                                  TPPUFile
*****************************************************************************}

constructor tppufile.Create(const fn:string);
begin
  fname:=fn;
  change_endian:=false;
  crc_only:=false;
  Mode:=0;
  NewHeader;
  Error:=false;
  closed:=true;
  tempclosed:=false;
  getmem(buf,ppubufsize);
end;


destructor tppufile.destroy;
begin
  closefile;
  if assigned(buf) then
    freemem(buf,ppubufsize);
end;


procedure tppufile.flush;
begin
  if Mode=2 then
   writebuf;
end;


procedure tppufile.closefile;
begin
{$ifdef Test_Double_checksum}
  if mode=2 then
   begin
     if assigned(crc_test) then
      dispose(crc_test);
     if assigned(crc_test2) then
      dispose(crc_test2);
   end;
{$endif Test_Double_checksum}
  if Mode<>0 then
   begin
     Flush;
     {$I-}
      system.close(f);
     {$I+}
     if ioresult<>0 then;
     Mode:=0;
     closed:=true;
   end;
end;


function tppufile.CheckPPUId:boolean;
begin
  CheckPPUId:=((Header.Id[1]='P') and (Header.Id[2]='P') and (Header.Id[3]='U'));
end;


function tppufile.GetPPUVersion:integer;
var
  l    : integer;
  code : integer;
begin
  Val(header.ver[1]+header.ver[2]+header.ver[3],l,code);
  if code=0 then
   GetPPUVersion:=l
  else
   GetPPUVersion:=0;
end;


procedure tppufile.NewHeader;
var
  s : string;
begin
  fillchar(header,sizeof(tppuheader),0);
  str(currentppuversion,s);
  while length(s)<3 do
   s:='0'+s;
  with header do
   begin
     Id[1]:='P';
     Id[2]:='P';
     Id[3]:='U';
     Ver[1]:=s[1];
     Ver[2]:=s[2];
     Ver[3]:=s[3];
   end;
end;


{*****************************************************************************
                                TPPUFile Reading
*****************************************************************************}

function tppufile.openfile:boolean;
var
  ofmode : byte;
  i      : integer;
begin
  openfile:=false;
  assign(f,fname);
  ofmode:=filemode;
  filemode:=$0;
  {$I-}
   reset(f,1);
  {$I+}
  filemode:=ofmode;
  if ioresult<>0 then
   exit;
  closed:=false;
{read ppuheader}
  fsize:=filesize(f);
  if fsize<sizeof(tppuheader) then
   exit;
  blockread(f,header,sizeof(tppuheader),i);
  { The header is always stored in little endian order }
  { therefore swap if on a big endian machine          }
{$IFDEF ENDIAN_BIG}
  header.compiler := SwapWord(header.compiler);
  header.cpu := SwapWord(header.cpu);
  header.target := SwapWord(header.target);
  header.flags := SwapLong(header.flags);
  header.size := SwapLong(header.size);
  header.checksum := cardinal(SwapLong(longint(header.checksum)));
  header.interface_checksum := cardinal(SwapLong(longint(header.interface_checksum)));
{$ENDIF}
  { the PPU DATA is stored in native order }
  if (header.flags and uf_big_endian) = uf_big_endian then
   Begin
{$IFDEF ENDIAN_LITTLE}
     change_endian := TRUE;
{$ELSE}
     change_endian := FALSE;
{$ENDIF}
   End
  else if (header.flags and uf_little_endian) = uf_little_endian then
   Begin
{$IFDEF ENDIAN_BIG}
     change_endian := TRUE;
{$ELSE}
     change_endian := FALSE;
{$ENDIF}
   End;
{reset buffer}
  bufstart:=i;
  bufsize:=0;
  bufidx:=0;
  Mode:=1;
  FillChar(entry,sizeof(tppuentry),0);
  entryidx:=0;
  entrystart:=0;
  entrybufstart:=0;
  Error:=false;
  openfile:=true;
end;


procedure tppufile.reloadbuf;
begin
  inc(bufstart,bufsize);
  blockread(f,buf^,ppubufsize,bufsize);
  bufidx:=0;
end;


procedure tppufile.readdata(var b;len:integer);
var
  p   : pchar;
  left,
  idx : integer;
begin
  p:=pchar(@b);
  idx:=0;
  while len>0 do
   begin
     left:=bufsize-bufidx;
     if len>left then
      begin
        move(buf[bufidx],p[idx],left);
        dec(len,left);
        inc(idx,left);
        reloadbuf;
        if bufsize=0 then
         exit;
      end
     else
      begin
        move(buf[bufidx],p[idx],len);
        inc(bufidx,len);
        exit;
      end;
   end;
end;


procedure tppufile.skipdata(len:integer);
var
  left : integer;
begin
  while len>0 do
   begin
     left:=bufsize-bufidx;
     if len>left then
      begin
        dec(len,left);
        reloadbuf;
        if bufsize=0 then
         exit;
      end
     else
      begin
        inc(bufidx,len);
        exit;
      end;
   end;
end;


function tppufile.readentry:byte;
begin
  if entryidx<entry.size then
   skipdata(entry.size-entryidx);
  readdata(entry,sizeof(tppuentry));
  entrystart:=bufstart+bufidx;
  entryidx:=0;
  if not(entry.id in [mainentryid,subentryid]) then
   begin
     readentry:=iberror;
     error:=true;
     exit;
   end;
  readentry:=entry.nr;
end;


function tppufile.endofentry:boolean;
begin
  endofentry:=(entryidx>=entry.size);
end;


function tppufile.entrysize:longint;
begin
  entrysize:=entry.size;
end;


procedure tppufile.getdatabuf(var b;len:integer;var res:integer);
begin
  if entryidx+len>entry.size then
   res:=entry.size-entryidx
  else
   res:=len;
  readdata(b,res);
  inc(entryidx,res);
end;


procedure tppufile.getdata(var b;len:integer);
begin
  if entryidx+len>entry.size then
   begin
     error:=true;
     exit;
   end;
  readdata(b,len);
  inc(entryidx,len);
end;


function tppufile.getbyte:byte;
var
  b : byte;
begin
  if entryidx+1>entry.size then
   begin
     error:=true;
     getbyte:=0;
     exit;
   end;
  readdata(b,1);
  getbyte:=b;
  inc(entryidx);
end;


function tppufile.getword:word;
var
  w : word;
begin
  if entryidx+2>entry.size then
   begin
     error:=true;
     getword:=0;
     exit;
   end;
  readdata(w,2);
  if change_endian then
   getword:=swapword(w)
  else
   getword:=w;
  inc(entryidx,2);
end;


function tppufile.getlongint:longint;
var
  l : longint;
begin
  if entryidx+4>entry.size then
   begin
     error:=true;
     getlongint:=0;
     exit;
   end;
  readdata(l,4);
  if change_endian then
   getlongint:=swaplong(l)
  else
   getlongint:=l;
  inc(entryidx,4);
end;


function tppufile.getint64:int64;
var
  i : int64;
begin
  if entryidx+8>entry.size then
   begin
     error:=true;
     result:=0;
     exit;
   end;
  readdata(i,8);
  if change_endian then
    result:=swapint64(i)
  else
    result:=i;
  inc(entryidx,8);
end;


function tppufile.getaint:aint;
begin
{$ifdef cpu64bit}
  result:=getint64;
{$else cpu64bit}
  result:=getlongint;
{$endif cpu64bit}
end;


function tppufile.getreal:ppureal;
var
  d : ppureal;
begin
  if entryidx+sizeof(ppureal)>entry.size then
   begin
     error:=true;
     getreal:=0;
     exit;
   end;
  readdata(d,sizeof(ppureal));
  getreal:=d;
  inc(entryidx,sizeof(ppureal));
end;


function tppufile.getstring:string;
var
  s : string;
begin
  s[0]:=chr(getbyte);
  if entryidx+length(s)>entry.size then
   begin
     error:=true;
     exit;
   end;
  ReadData(s[1],length(s));
  getstring:=s;
  inc(entryidx,length(s));
end;


procedure tppufile.getsmallset(var b);
var
  l : longint;
begin
  l:=getlongint;
  longint(b):=l;
end;


procedure tppufile.getnormalset(var b);
type
  SetLongintArray = Array [0..7] of longint;
var
  i : longint;
begin
  if change_endian then
    begin
      for i:=0 to 7 do
        SetLongintArray(b)[i]:=getlongint;
    end
  else
    getdata(b,32);
end;


function tppufile.skipuntilentry(untilb:byte):boolean;
var
  b : byte;
begin
  repeat
    b:=readentry;
  until (b in [ibend,iberror]) or ((b=untilb) and (entry.id=mainentryid));
  skipuntilentry:=(b=untilb);
end;


{*****************************************************************************
                                TPPUFile Writing
*****************************************************************************}

function tppufile.createfile:boolean;
begin
  createfile:=false;
{$ifdef INTFPPU}
  if crc_only then
   begin
     fname:=fname+'.intf';
     crc_only:=false;
   end;
{$endif}
  if not crc_only then
    begin
      assign(f,fname);
      {$I-}
       rewrite(f,1);
      {$I+}
      if ioresult<>0 then
       exit;
      Mode:=2;
    {write header for sure}
      blockwrite(f,header,sizeof(tppuheader));
    end;
  bufsize:=ppubufsize;
  bufstart:=sizeof(tppuheader);
  bufidx:=0;
{reset}
  crc:=cardinal($ffffffff);
  interface_crc:=cardinal($ffffffff);
  do_interface_crc:=true;
  Error:=false;
  do_crc:=true;
  size:=0;
  entrytyp:=mainentryid;
{start}
  NewEntry;
  createfile:=true;
end;


procedure tppufile.writeheader;
var
  opos : integer;
begin
  if crc_only then
   exit;
  { flush buffer }
  writebuf;
  { update size (w/o header!) in the header }
  header.size:=bufstart-sizeof(tppuheader);
  { set the endian flag }
{$ifndef FPC_BIG_ENDIAN}
    header.flags := header.flags or uf_little_endian;
{$else not FPC_BIG_ENDIAN}
    header.flags := header.flags or uf_big_endian;
    { Now swap the header in the correct endian (always little endian) }
    header.compiler := SwapWord(header.compiler);
    header.cpu := SwapWord(header.cpu);
    header.target := SwapWord(header.target);
    header.flags := SwapLong(header.flags);
    header.size := SwapLong(header.size);
    header.checksum := cardinal(SwapLong(longint(header.checksum)));
    header.interface_checksum := cardinal(SwapLong(longint(header.interface_checksum)));
{$endif not FPC_BIG_ENDIAN}
{ write header and restore filepos after it }
  opos:=filepos(f);
  seek(f,0);
  blockwrite(f,header,sizeof(tppuheader));
  seek(f,opos);
end;


procedure tppufile.writebuf;
begin
  if not crc_only then
    blockwrite(f,buf^,bufidx);
  inc(bufstart,bufidx);
  bufidx:=0;
end;


procedure tppufile.writedata(const b;len:integer);
var
  p   : pchar;
  left,
  idx : integer;
begin
  if crc_only then
    exit;
  p:=pchar(@b);
  idx:=0;
  while len>0 do
   begin
     left:=bufsize-bufidx;
     if len>left then
      begin
        move(p[idx],buf[bufidx],left);
        dec(len,left);
        inc(idx,left);
        inc(bufidx,left);
        writebuf;
      end
     else
      begin
        move(p[idx],buf[bufidx],len);
        inc(bufidx,len);
        exit;
      end;
   end;
end;


procedure tppufile.NewEntry;
begin
  with entry do
   begin
     id:=entrytyp;
     nr:=ibend;
     size:=0;
   end;
{Reset Entry State}
  entryidx:=0;
  entrybufstart:=bufstart;
  entrystart:=bufstart+bufidx;
{Alloc in buffer}
  writedata(entry,sizeof(tppuentry));
end;


procedure tppufile.writeentry(ibnr:byte);
var
  opos : integer;
begin
{create entry}
  entry.id:=entrytyp;
  entry.nr:=ibnr;
  entry.size:=entryidx;
{it's already been sent to disk ?}
  if entrybufstart<>bufstart then
   begin
    if not crc_only then
      begin
      {flush to be sure}
        WriteBuf;
      {write entry}
        opos:=filepos(f);
        seek(f,entrystart);
        blockwrite(f,entry,sizeof(tppuentry));
        seek(f,opos);
      end;
     entrybufstart:=bufstart;
   end
  else
   move(entry,buf[entrystart-bufstart],sizeof(entry));
{Add New Entry, which is ibend by default}
  entrystart:=bufstart+bufidx; {next entry position}
  NewEntry;
end;


procedure tppufile.putdata(const b;len:integer);
begin
  if do_crc then
   begin
     crc:=UpdateCrc32(crc,b,len);
{$ifdef Test_Double_checksum}
     if crc_only then
       begin
         crc_test2^[crc_index2]:=crc;
{$ifdef Test_Double_checksum_write}
         Writeln(CRCFile,crc);
{$endif Test_Double_checksum_write}
         if crc_index2<crc_array_size then
          inc(crc_index2);
       end
     else
       begin
         if (crcindex2<crc_array_size) and (crcindex2<crc_index2) and
            (crc_test2^[crcindex2]<>crc) then
           Do_comment(V_Note,'impl CRC changed');
{$ifdef Test_Double_checksum_write}
         Writeln(CRCFile,crc);
{$endif Test_Double_checksum_write}
         inc(crcindex2);
       end;
{$endif def Test_Double_checksum}
     if do_interface_crc then
       begin
         interface_crc:=UpdateCrc32(interface_crc,b,len);
{$ifdef Test_Double_checksum}
        if crc_only then
          begin
            crc_test^[crc_index]:=interface_crc;
{$ifdef Test_Double_checksum_write}
            Writeln(CRCFile,interface_crc);
{$endif Test_Double_checksum_write}
            if crc_index<crc_array_size then
             inc(crc_index);
          end
        else
          begin
            if (crcindex<crc_array_size) and (crcindex<crc_index) and
               (crc_test^[crcindex]<>interface_crc) then
              Do_comment(V_Warning,'CRC changed');
{$ifdef Test_Double_checksum_write}
            Writeln(CRCFile,interface_crc);
{$endif Test_Double_checksum_write}
            inc(crcindex);
          end;
{$endif def Test_Double_checksum}
       end;
    end;
  if not crc_only then
    writedata(b,len);
  inc(entryidx,len);
end;


procedure tppufile.putbyte(b:byte);
begin
  putdata(b,1);
end;


procedure tppufile.putword(w:word);
begin
  putdata(w,2);
end;


procedure tppufile.putlongint(l:longint);
begin
  putdata(l,4);
end;


procedure tppufile.putint64(i:int64);
begin
  putdata(i,8);
end;


procedure tppufile.putaint(i:aint);
begin
  putdata(i,sizeof(aint));
end;


procedure tppufile.putreal(d:ppureal);
begin
  putdata(d,sizeof(ppureal));
end;


    procedure tppufile.putstring(s:string);
      begin
        putdata(s,length(s)+1);
      end;


    procedure tppufile.putsmallset(const b);
      var
        l : longint;
      begin
        l:=longint(b);
        putlongint(l);
      end;


    procedure tppufile.putnormalset(const b);
      type
        SetLongintArray = Array [0..7] of longint;
      var
        i : longint;
        tempb : setlongintarray;
      begin
        if change_endian then
          begin
            for i:=0 to 7 do
              tempb[i]:=SwapLong(SetLongintArray(b)[i]);
            putdata(tempb,32);
          end
        else
          putdata(b,32);
      end;


    procedure tppufile.tempclose;
      begin
        if not closed then
         begin
           closepos:=filepos(f);
           {$I-}
            system.close(f);
           {$I+}
           if ioresult<>0 then;
           closed:=true;
           tempclosed:=true;
         end;
      end;


    function tppufile.tempopen:boolean;
      var
        ofm : byte;
      begin
        tempopen:=false;
        if not closed or not tempclosed then
         exit;
        ofm:=filemode;
        filemode:=0;
        {$I-}
         reset(f,1);
        {$I+}
        filemode:=ofm;
        if ioresult<>0 then
         exit;
        closed:=false;
        tempclosed:=false;

      { restore state }
        seek(f,closepos);
        tempopen:=true;
      end;

end.
{
  $Log$
  Revision 1.47  2004-03-23 22:34:49  peter
    * constants ordinals now always have a type assigned
    * integer constants have the smallest type, unsigned prefered over
      signed

  Revision 1.46  2004/02/27 10:21:05  florian
    * top_symbol killed
    + refaddr to treference added
    + refsymbol to treference added
    * top_local stuff moved to an extra record to save memory
    + aint introduced
    * tppufile.get/putint64/aint implemented

  Revision 1.45  2004/01/30 13:42:03  florian
    * fixed more alignment issues

  Revision 1.44  2003/11/10 22:02:52  peter
    * cross unit inlining fixed

  Revision 1.43  2003/10/22 20:40:00  peter
    * write derefdata in a separate ppu entry

  Revision 1.42  2003/09/23 17:56:05  peter
    * locals and paras are allocated in the code generation
    * tvarsym.localloc contains the location of para/local when
      generating code for the current procedure

  Revision 1.41  2003/07/05 20:06:28  jonas
    * fixed some range check errors that occurred on big endian systems
    * slightly optimized the swap*() functions

  Revision 1.40  2003/06/17 16:34:44  jonas
    * lots of newra fixes (need getfuncretparaloc implementation for i386)!
    * renamed all_intregisters to volatile_intregisters and made it
      processor dependent

  Revision 1.39  2003/06/07 20:26:32  peter
    * re-resolving added instead of reloading from ppu
    * tderef object added to store deref info for resolving

  Revision 1.38  2003/05/26 19:39:51  peter
    * removed systems unit

  Revision 1.37  2003/05/26 15:49:54  jonas
    * endian fix is now done using a define instead of with source_info

  Revision 1.36  2003/05/24 13:37:10  jonas
    * endian fixes

  Revision 1.35  2003/05/23 17:03:51  peter
    * write header for crc_only

  Revision 1.34  2003/04/25 20:59:34  peter
    * removed funcretn,funcretsym, function result is now in varsym
      and aliases for result and function name are added using absolutesym
    * vs_hidden parameter for funcret passed in parameter
    * vs_hidden fixes
    * writenode changed to printnode and released from extdebug
    * -vp option added to generate a tree.log with the nodetree
    * nicer printnode for statements, callnode

  Revision 1.33  2003/04/24 13:03:01  florian
    * comp is now written with its bit pattern to the ppu instead as an extended

  Revision 1.32  2003/04/23 14:42:07  daniel
    * Further register allocator work. Compiler now smaller with new
      allocator than without.
    * Somebody forgot to adjust ppu version number

  Revision 1.31  2003/04/10 17:57:53  peter
    * vs_hidden released

  Revision 1.30  2003/03/17 15:54:22  peter
    * store symoptions also for procdef
    * check symoptions (private,public) when calculating possible
      overload candidates

  Revision 1.29  2003/01/08 18:43:56  daniel
   * Tregister changed into a record

  Revision 1.28  2002/11/15 01:58:53  peter
    * merged changes from 1.0.7 up to 04-11
      - -V option for generating bug report tracing
      - more tracing for option parsing
      - errors for cdecl and high()
      - win32 import stabs
      - win32 records<=8 are returned in eax:edx (turned off by default)
      - heaptrc update
      - more info for temp management in .s file with EXTDEBUG

  Revision 1.27  2002/10/14 19:42:33  peter
    * only use init tables for threadvars

  Revision 1.26  2002/08/18 20:06:25  peter
    * inlining is now also allowed in interface
    * renamed write/load to ppuwrite/ppuload
    * tnode storing in ppu
    * nld,ncon,nbas are already updated for storing in ppu

  Revision 1.25  2002/08/15 19:10:35  peter
    * first things tai,tnode storing in ppu

  Revision 1.24  2002/08/15 15:09:42  carl
    + fpu emulation helpers (ppu checking also)

  Revision 1.23  2002/08/13 21:40:56  florian
    * more fixes for ppc calling conventions

  Revision 1.22  2002/08/11 13:24:12  peter
    * saving of asmsymbols in ppu supported
    * asmsymbollist global is removed and moved into a new class
      tasmlibrarydata that will hold the info of a .a file which
      corresponds with a single module. Added librarydata to tmodule
      to keep the library info stored for the module. In the future the
      objectfiles will also be stored to the tasmlibrarydata class
    * all getlabel/newasmsymbol and friends are moved to the new class

  Revision 1.21  2002/08/09 07:33:02  florian
    * a couple of interface related fixes

  Revision 1.20  2002/05/18 13:34:13  peter
    * readded missing revisions

  Revision 1.19  2002/05/16 19:46:44  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.17  2002/04/04 19:06:03  peter
    * removed unused units
    * use tlocation.size in cg.a_*loc*() routines

  Revision 1.16  2002/03/31 20:26:36  jonas
    + a_loadfpu_* and a_loadmm_* methods in tcg
    * register allocation is now handled by a class and is mostly processor
      independent (+rgobj.pas and i386/rgcpu.pas)
    * temp allocation is now handled by a class (+tgobj.pas, -i386\tgcpu.pas)
    * some small improvements and fixes to the optimizer
    * some register allocation fixes
    * some fpuvaroffset fixes in the unary minus node
    * push/popusedregisters is now called rg.save/restoreusedregisters and
      (for i386) uses temps instead of push/pop's when using -Op3 (that code is
      also better optimizable)
    * fixed and optimized register saving/restoring for new/dispose nodes
    * LOC_FPU locations now also require their "register" field to be set to
      R_ST, not R_ST0 (the latter is used for LOC_CFPUREGISTER locations only)
    - list field removed of the tnode class because it's not used currently
      and can cause hard-to-find bugs

  Revision 1.15  2002/03/28 16:07:52  armin
  + initialize threadvars defined local in units

}
