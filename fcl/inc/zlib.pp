unit zlib;

interface
  
{ Needed for array of const }
{$mode objfpc}
{$PACKRECORDS 4}

const
  SZLIB_VERSION = '1.1.3';

type

  { Compatibility types }
  Uint = cardinal;
  Ulong = Cardinal;
  Ulongf = Cardinal;
  Pulongf = ^Ulongf;
  z_off_t = longint;  

  TAllocfunc = function (opaque:pointer; items:uInt; size:uInt):pointer;cdecl;
  TFreeFunc = procedure (opaque:pointer; address:pointer);cdecl;

  TInternalState = record
    end;
  PInternalState = ^TInternalstate;
  
  TZStream = record
    next_in : pchar;
    avail_in : uInt;
    total_in : uLong;
    next_out : pchar;
    avail_out : uInt;
    total_out : uLong;
    msg : pchar;
    state : PInternalState;
    zalloc : TAllocFunc;
    zfree : TFreeFunc;
    opaque : pointer;
    data_type : longint;
    adler : uLong;
    reserved : uLong;
  end;
  PZstream = ^TZStream;
  gzFile = pointer;


const
  Z_NO_FLUSH = 0;

  Z_PARTIAL_FLUSH = 1;
  Z_SYNC_FLUSH = 2;
  Z_FULL_FLUSH = 3;
  Z_FINISH = 4;

  Z_OK = 0;
  Z_STREAM_END = 1;
  Z_NEED_DICT = 2;
  Z_ERRNO = -(1);
  Z_STREAM_ERROR = -(2);
  Z_DATA_ERROR = -(3);
  Z_MEM_ERROR = -(4);
  Z_BUF_ERROR = -(5);
  Z_VERSION_ERROR = -(6);

  Z_NO_COMPRESSION = 0;
  Z_BEST_SPEED = 1;
  Z_BEST_COMPRESSION = 9;
  Z_DEFAULT_COMPRESSION = -(1);

  Z_FILTERED = 1;
  Z_HUFFMAN_ONLY = 2;
  Z_DEFAULT_STRATEGY = 0;

  Z_BINARY = 0;
  Z_ASCII = 1;
  Z_UNKNOWN = 2;

  Z_DEFLATED = 8;

  Z_NULL = 0;

  function zlibVersion:pchar;cdecl;
  function deflate(var strm:TZstream; flush:longint):longint;cdecl;
  function deflateEnd(var strm:TZstream):longint;cdecl;
  function inflate(var strm:TZstream; flush:longint):longint;cdecl;
  function inflateEnd(var strm:TZstream):longint;cdecl;
  function deflateSetDictionary(var strm:TZstream;dictionary : pchar; dictLength:uInt):longint;cdecl;
  function deflateCopy(var dest,source:TZstream):longint;cdecl;
  function deflateReset(var strm:TZstream):longint;cdecl;
  function deflateParams(var strm:TZstream; level:longint; strategy:longint):longint;cdecl;
  function inflateSetDictionary(var strm:TZStream;dictionary : pchar; dictLength:uInt):longint;cdecl;
  function inflateSync(var strm:TZStream):longint;cdecl;
  function inflateReset(var strm:TZStream):longint;cdecl;
  function compress(dest:pchar;destLen:uLongf; source : pchar; sourceLen:uLong):longint;cdecl;
  function compress2(dest:pchar;destLen:uLongf; source : pchar; sourceLen:uLong; level:longint):longint;cdecl;
  function uncompress(dest:pchar;destLen:uLongf; source : pchar; sourceLen:uLong):longint;cdecl;
  function gzopen(path:pchar; mode:pchar):gzFile;cdecl;
  function gzdopen(fd:longint; mode:pchar):gzFile;cdecl;
  function gzsetparams(Thefile:gzFile; level:longint; strategy:longint):longint;cdecl;
  function gzread(thefile:gzFile; buf : pointer; len:cardinal):longint;cdecl;
  function gzwrite(thefile:gzFile; buf: pointer; len:cardinal):longint;cdecl;
  function gzprintf(thefile:gzFile; format:pchar; args:array of const):longint;cdecl;
  function gzputs(thefile:gzFile; s:pchar):longint;cdecl;
  function gzgets(thefile:gzFile; buf:pchar; len:longint):pchar;cdecl;
  function gzputc(thefile:gzFile; c:longint):longint;cdecl;
  function gzgetc(thefile:gzFile):longint;cdecl;
  function gzflush(thefile:gzFile; flush:longint):longint;cdecl;
  function gzseek(thefile:gzFile; offset:z_off_t; whence:longint):z_off_t;cdecl;
  function gzrewind(thefile:gzFile):longint;cdecl;
  function gztell(thefile:gzFile):z_off_t;cdecl;
  function gzeof(thefile:gzFile):longint;cdecl;
  function gzclose(thefile:gzFile):longint;cdecl;
  function gzerror(thefile:gzFile; var errnum:longint):pchar;cdecl;
  function adler32(adler:uLong;buf : pchar; len:uInt):uLong;cdecl;
  function crc32(crc:uLong;buf : pchar; len:uInt):uLong;cdecl;
  function deflateInit_(var strm:TZStream; level:longint; version:pchar; stream_size:longint):longint;cdecl;
  function inflateInit_(var strm:TZStream; version:pchar; stream_size:longint):longint;cdecl;
  function deflateInit2_(var strm:TZStream; level:longint; method:longint; windowBits:longint; memLevel:longint; 
             strategy:longint; version:pchar; stream_size:longint):longint;cdecl;
  function inflateInit2_(var strm:TZStream; windowBits:longint; version:pchar; stream_size:longint):longint;cdecl;
  function deflateInit(var strm:TZStream;level : longint) : longint;
  function inflateInit(var strm:TZStream) : longint;
  function deflateInit2(var strm:TZStream;level,method,windowBits,memLevel,strategy : longint) : longint;
  function inflateInit2(var strm:TZStream; windowBits : longint) : longint;
  function zError(err:longint):pchar;cdecl;
  function inflateSyncPoint(z:PZstream):longint;cdecl;
  function get_crc_table:puLongf;cdecl;

implementation

{$ifndef win32}
const External_library='z';
{$else}
const External_library='z';
{$endif}


function zlibVersion:pchar;cdecl;external External_library name 'zlibVersion';
function deflate(var strm:TZStream; flush:longint):longint;cdecl;external External_library name 'deflate';
function deflateEnd(var strm:TZStream):longint;cdecl;external External_library name 'deflateEnd';
function inflate(var strm:TZStream; flush:longint):longint;cdecl;external External_library name 'inflate';
function inflateEnd(var strm:TZStream):longint;cdecl;external External_library name 'inflateEnd';
function deflateSetDictionary(var strm:TZStream;dictionary : pchar; dictLength:uInt):longint;cdecl;external External_library name 'deflateSetDictionary';
function deflateCopy(var dest,source:TZstream):longint;cdecl;external External_library name 'deflateCopy';
function deflateReset(var strm:TZStream):longint;cdecl;external External_library name 'deflateReset';
function deflateParams(var strm:TZStream; level:longint; strategy:longint):longint;cdecl;external External_library name 'deflateParams';
function inflateSetDictionary(var strm:TZStream;dictionary : pchar; dictLength:uInt):longint;cdecl;external External_library name 'inflateSetDictionary';
function inflateSync(var strm:TZStream):longint;cdecl;external External_library name 'inflateSync';
function inflateReset(var strm:TZStream):longint;cdecl;external External_library name 'inflateReset';
function compress(dest:pchar;destLen:uLongf; source : pchar; sourceLen:uLong):longint;cdecl;external External_library name 'compress';
function compress2(dest:pchar;destLen:uLongf; source : pchar; sourceLen:uLong; level:longint):longint;cdecl;external External_library name 'compress2';
function uncompress(dest:pchar;destLen:uLongf; source : pchar; sourceLen:uLong):longint;cdecl;external External_library name 'uncompress';
function gzopen(path:pchar; mode:pchar):gzFile;cdecl;external External_library name 'gzopen';
function gzdopen(fd:longint; mode:pchar):gzFile;cdecl;external External_library name 'gzdopen';
function gzsetparams(thefile:gzFile; level:longint; strategy:longint):longint;cdecl;external External_library name 'gzsetparams';
function gzread(thefile:gzFile; buf:pointer; len:cardinal):longint;cdecl;external External_library name 'gzread';
function gzwrite(thefile:gzFile; buf:pointer; len:cardinal):longint;cdecl;external External_library name 'gzwrite';
function gzprintf(thefile:gzFile; format:pchar; args:array of const):longint;cdecl;external External_library name 'gzprintf';
function gzputs(thefile:gzFile; s:pchar):longint;cdecl;external External_library name 'gzputs';
function gzgets(thefile:gzFile; buf:pchar; len:longint):pchar;cdecl;external External_library name 'gzgets';
function gzputc(thefile:gzFile; c:longint):longint;cdecl;external External_library name 'gzputc';
function gzgetc(thefile:gzFile):longint;cdecl;external External_library name 'gzgetc';
function gzflush(thefile:gzFile; flush:longint):longint;cdecl;external External_library name 'gzflush';
function gzseek(thefile:gzFile; offset:z_off_t; whence:longint):z_off_t;cdecl;external External_library name 'gzseek';
function gzrewind(thefile:gzFile):longint;cdecl;external External_library name 'gzrewind';
function gztell(thefile:gzFile):z_off_t;cdecl;external External_library name 'gztell';
function gzeof(thefile:gzFile):longint;cdecl;external External_library name 'gzeof';
function gzclose(thefile:gzFile):longint;cdecl;external External_library name 'gzclose';
function gzerror(thefile:gzFile; var errnum:longint):pchar;cdecl;external External_library name 'gzerror';
function adler32(adler:uLong;buf : pchar; len:uInt):uLong;cdecl;external External_library name 'adler32';
function crc32(crc:uLong;buf : pchar; len:uInt):uLong;cdecl;external External_library name 'crc32';
function deflateInit_(var strm:TZStream; level:longint; version:pchar; stream_size:longint):longint;cdecl;external External_library name 'deflateInit_';
function inflateInit_(var strm:TZStream; version:pchar; stream_size:longint):longint;cdecl;external External_library name 'inflateInit_';
function deflateInit2_(var strm:TZStream; level:longint; method:longint; windowBits:longint; memLevel:longint; 
           strategy:longint; version:pchar; stream_size:longint):longint;cdecl;external External_library name 'deflateInit2_';
function inflateInit2_(var strm:TZStream; windowBits:longint; version:pchar; stream_size:longint):longint;cdecl;external External_library name 'inflateInit2_';
function zError(err:longint):pchar;cdecl;external External_library name 'zError';
function inflateSyncPoint(z:PZstream):longint;cdecl;external External_library name 'inflateSyncPoint';
function get_crc_table:puLongf;cdecl;external External_library name 'get_crc_table';

function zlib_version : pchar;
  begin
     zlib_version:=zlibVersion;
  end;

function deflateInit(var strm:TZStream;level : longint) : longint;
  begin
     deflateInit:=deflateInit_(strm,level,ZLIB_VERSION,sizeof(TZStream));
  end;

function inflateInit(var strm:TZStream) : longint;
  begin
     inflateInit:=inflateInit_(strm,ZLIB_VERSION,sizeof(TZStream));
  end;

function deflateInit2(var strm:TZStream;level,method,windowBits,memLevel,strategy : longint) : longint;
  begin
     deflateInit2:=deflateInit2_(strm,level,method,windowBits,memLevel,strategy,ZLIB_VERSION,sizeof(TZStream));
  end;

function inflateInit2(var strm:TZStream;windowBits : longint) : longint;
  begin
     inflateInit2:=inflateInit2_(strm,windowBits,ZLIB_VERSION,sizeof(TZStream));
  end;

end.