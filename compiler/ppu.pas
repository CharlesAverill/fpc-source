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
    globtype;

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
  CurrentPPUVersion=46;

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
  ibtypesym        = 20;
  ibprocsym        = 21;
  ibglobalvarsym   = 22;
  ibconstsym       = 23;
  ibenumsym        = 24;
  ibtypedconstsym  = 25;
  ibabsolutevarsym = 26;
  ibpropertysym    = 27;
  ibfieldvarsym    = 28;
  ibunitsym        = 29;  { needed for browser }
  iblabelsym       = 30;
  ibsyssym         = 31;
  ibrttisym        = 32;
  iblocalvarsym    = 33;
  ibparavarsym     = 34;
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
{$ifdef ansistring_bits}
  ibansistring16def  = 58;
  ibansistring32def  = 55;
  ibansistring64def  = 59;
{$else}
  ibansistringdef  = 55;
{$endif}
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
  uf_has_debuginfo = $10000;  { this unit has debuginfo generated }
  uf_local_symtable = $20000; { this unit has a local symtable stored }
  uf_uses_variants  = $40000; { this unit uses variants }

type
  ppureal=extended;

  tppuerror=(ppuentrytoobig,ppuentryerror);

  tppuheader=record
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
  if change_endian then
   entry.size:=swaplong(entry.size);
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
  Revision 1.60  2004-12-06 19:23:05  peter
  implicit load of variants unit

  Revision 1.59  2004/11/15 23:35:31  peter
    * tparaitem removed, use tparavarsym instead
    * parameter order is now calculated from paranr value in tparavarsym

  Revision 1.58  2004/11/08 22:09:59  peter
    * tvarsym splitted

  Revision 1.57  2004/09/21 17:25:12  peter
    * paraloc branch merged

  Revision 1.56.4.1  2004/09/12 14:01:23  peter
    * entry.size need endian update

  Revision 1.56  2004/08/27 21:59:26  peter
  browser disabled
  uf_local_symtable ppu flag when a localsymtable is stored

  Revision 1.55  2004/08/22 20:11:38  florian
    * morphos now takes any pointer var. as libbase
    * alignment for sparc fixed
    * int -> double conversion on sparc fixed

  Revision 1.54  2004/08/17 16:29:21  jonas
    + padalgingment field for recordsymtables (saved by recorddefs)
    + support for Macintosh PowerPC alignment (if the first field of a record
      or union has an alignment > 4, then the record or union size must be
      padded to a multiple of this size)

  Revision 1.53  2004/07/12 09:14:04  jonas
    * inline procedures at the node tree level, but only under some very
      limited circumstances for now (only procedures, and only if they have
      no or only vs_out/vs_var parameters).
    * fixed ppudump for inline procedures
    * fixed ppudump for ppc

  Revision 1.52  2004/07/09 23:11:05  peter
    * new format

  Revision 1.51  2004/06/20 08:55:30  florian
    * logs truncated

  Revision 1.50  2004/06/16 20:07:09  florian
    * dwarf branch merged

  Revision 1.49  2004/05/19 21:16:13  peter
    * add DEBUGINFO symbol to reference the .o file that includes the
      stabs info for types and global/static variables
    * debuginfo flag added to ppu to indicate whether debuginfo is
      generated or not

  Revision 1.48  2004/04/29 19:56:37  daniel
    * Prepare compiler infrastructure for multiple ansistring types

  Revision 1.47.2.1  2004/05/01 16:02:09  peter
    * POINTER_SIZE replaced with sizeof(aint)
    * aint,aword,tconst*int moved to globtype

  Revision 1.47  2004/03/23 22:34:49  peter
    * constants ordinals now always have a type assigned
    * integer constants have the smallest type, unsigned prefered over
      signed

}
