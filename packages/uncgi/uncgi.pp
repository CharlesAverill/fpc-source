unit uncgi;
{
  $Id$

  UNCGI UNIT 2.0.11
  ----------------
}

interface
uses
  strings
{$ifdef linux}
 ,linux
{$endif}
 ;

{***********************************************************************}

const
  maxquery      = 100;
  hextable      : array[0..15] of char=('0','1','2','3','4','5','6','7',
                                        '8','9','A','B','C','D','E','F');
  uncgi_version = 'UNCGI 2.0.11';
  uncgi_year    = '1999';
  maintainer_name = 'Your Name Here';
  maintainer_email= 'your@email.address.here';

Type cgi_error_proc = procedure (Const Proc,Err : String);

var
  get_nodata    : boolean;
  query_read    : word;
  query_array   : array[1..2,1..maxquery] of pchar;
  uncgi_error   : cgi_error_proc;

{***********************************************************************}

{ FUNCTION

  This function returns the REQUEST METHOD of the CGI-BIN script

  Input         - Nothing
  Output        - [GET|POST]
}
function http_request_method: pchar;

{ FUNCTION

  This function returns the "referring" page. i.e. the page you followed
  the link to this CGI-BIN from

  Input         - Nothing
  Output        - [http://somewhere.a.tld]
}
function http_referer: pchar;

{ FUNCTION

  This function returns the users's USER AGENT, the browser name etc.

  Input         - Nothing
  Output        - user agent string
}
function http_useragent: pchar;

{ FUNCTION

  This function returns a value from an id=value pair

  Input         - The identifier you want the value from
  Output        - If the identifier was found, the resulting value is
                  the output, otherwise the output is NIL
}
function get_value(id: pchar): pchar;

{ PROCEDURE

  This procedure writes the content-type to the screen

  Input         - The content type in MIME format
  Output        - Nothing

  Example       - set_content('text/plain');
                  set_content('text/html');
}
procedure set_content(ctype: string);

procedure cgi_init;
procedure cgi_deinit;

implementation

{$ifdef win32}
Var EnvP : PChar;
    EnvLen : Longint;
    OldExitProc : Pointer;

function GetEnvironmentStrings : pchar; external 'kernel32' name 'GetEnvironmentStringsA';
function FreeEnvironmentStrings(p : pchar) : longbool; external 'kernel32' name 'FreeEnvironmentStringsA';

Procedure FInitWin32CGI;
begin
  { Free memory }
  FreeMem (EnvP,EnvLen);
  ExitProc:=OldExitProc;
end;

Procedure InitWin32CGI;
var s : String;
    i,len : longint;
    hp,p : pchar;

begin
  { Make a local copy of environment}
  p:=GetEnvironmentStrings;
  hp:=p;
  envp:=Nil;
  envlen:=0;
  while hp[0]<>#0 do
    begin
    len:=strlen(hp);
    hp:=hp+len+1;
    EnvLen:=Envlen+len+1;
    end;
  GetMem(EnvP,Envlen);
  Move(P^,EnvP^,EnvLen);
  FreeEnvironmentStrings(p);
  OldExitProc:=ExitProc;
  ExitProc:=@FinitWin32CGI;
end;

Function GetEnv(envvar: string): pchar;
{ Getenv that can return environment vars of length>255 }
var s : String;
    i,len : longint;
    hp : pchar;

begin
  s:=Envvar+#0;
  getenv:=Nil;
  hp:=envp;
  while hp[0]<>#0 do
    begin
    len:=strlen(hp);
    i:=Longint(strscan(hp,'='))-longint(hp);
    if StrLIComp(@s[1],HP,i-1)=0 then
       begin
       Len:=Len-i;
       getmem (getenv,len);
       Move(HP[I+1],getenv^,len+1);
       break;
       end;
    { next string entry}
    hp:=hp+len+1;
    end;
end;
{$endif}

{$ifdef GO32V2}
Function  GetEnv(envvar: string): pchar;
var
  hp    : ppchar;
  p     : pchar;
  hs    : string;
  eqpos : longint;
begin
  envvar:=upcase(envvar);
  hp:=envp;
  getenv:=nil;
  while assigned(hp^) do
   begin
     hs:=strpas(hp^);
     eqpos:=pos('=',hs);
     if copy(hs,1,eqpos-1)=envvar then
      begin
        getenv:=hp^+eqpos;
        exit;
      end;
     inc(hp);
   end;
end;
{$endif}


var
  done_init     : boolean;

procedure set_content(ctype: string);
begin
  writeln('Content-Type: ',ctype);
  writeln;
end;

function http_request_method: pchar;
begin
  http_request_method :=getenv('REQUEST_METHOD');
end;

function http_referer: pchar;
begin
  http_referer :=getenv('HTTP_REFERER');
end;

function http_useragent: pchar;
begin
  http_useragent :=getenv('HTTP_USER_AGENT');
end;

function hexconv(h1,h2: char): char;
var
  cnt   : byte;
  thex  : byte;
begin
  for cnt :=0 to 15 do if upcase(h1)=hextable[cnt] then thex := cnt * 16;
  for cnt :=0 to 15 do if upcase(h2)=hextable[cnt] then thex := thex + cnt;
  hexconv := chr(thex);
end;

procedure def_uncgi_error(const pname,perr: string);
begin
  set_content('text/html');
  writeln('<html><head><title>UNCGI ERROR</title></head>');
  writeln('<body>');
  writeln('<center><hr><h1>UNCGI ERROR</h1><hr></center><br><br>');
  writeln('UnCgi encountered the following error: <br>');
  writeln('<ul><br>');
  writeln('<li> procedure: ',pname,'<br>');
  writeln('<li> error: ',perr,'<br><hr>');
  writeln(
   '<h5><p><i>uncgi (c) ',uncgi_year,' ',maintainer_name,
{ skelet fix }
   '<a href="mailto:',maintainer_email,'">',
   maintainer_email,'</a></i></p></h5>');
  writeln('</body></html>');
  halt;
end;

function get_value(id: pchar): pchar;
var
  cnt   : word;
begin
  get_value:=Nil;
  if done_init then
    for cnt :=1 to query_read do
      if strcomp(strupper(id),strupper(query_array[1,cnt]))=0 then
        begin
        get_value := query_array[2,cnt];
        exit;
        end;
end;

Function UnEscape(QueryString: PChar): PChar;
var
  qunescaped    : pchar;
  sptr          : longint;
  cnt           : word;
  qslen         : longint;

begin
  qslen:=strlen(QueryString);
  if qslen=0 then
    begin
    Unescape:=#0;
    get_nodata:=true;
    exit;
    end
  else
    get_nodata :=false;
{ skelet fix }
  getmem(qunescaped,qslen+1);
  if qunescaped=nil then
    begin
    writeln ('Oh-oh');
    halt;
    end;
  sptr :=0;
  for cnt := 0 to qslen do
    begin
    case querystring[cnt] of
      '+': qunescaped[sptr] := ' ';
      '%': begin
           qunescaped[sptr] :=
               hexconv(querystring[cnt+1], querystring[cnt+2]);
           inc(cnt,2);
           end;
    else
      qunescaped[sptr] := querystring[cnt];
    end;
    inc(sptr);
{ skelet fix }
    qunescaped[sptr]:=#0;
    end;
  UnEscape:=qunescaped;
end;

Function Chop(QunEscaped : PChar) : Longint;
var
  qptr          : word;
  cnt           : word;
  qslen : longint;

begin
  qptr := 1;
  qslen:=strlen(QUnescaped);
  query_array[1,qptr] := qunescaped;
  for cnt := 0 to qslen-1 do
    case qunescaped[cnt] of
      '=': begin
             qunescaped[cnt] := #0;
             { save address }
             query_array[2,qptr] := @qunescaped[cnt+1];
           end;
      '&': begin
             qunescaped[cnt] := #0;
             { Unescape previous one. }
             query_array[2,qptr]:=unescape(query_array[2,qptr]);
             inc(qptr);
             query_array[1,qptr] := @qunescaped[cnt+1];
           end;
    end; { Case }
  { Unescape last one. }
  query_array[2,qptr]:=unescape(query_array[2,qptr]);
  Chop :=qptr;
end;

procedure cgi_read_get_query;
var
  querystring   : pchar;
  qslen         : longint;
begin
  querystring :=strnew(getenv('QUERY_STRING'));
  if querystring<>NIL then
    begin
    qslen :=strlen(querystring);
    if qslen=0 then
      begin
      get_nodata :=true;
      exit;
      end
    else
      get_nodata :=false;
    query_read:=Chop(QueryString);
    end;
  done_init :=true;
end;

procedure cgi_read_post_query;
var
  querystring   : pchar;
  qslen         : longint;
  sptr          : longint;
  clen          : string;
  ch            : char;

begin
  if getenv('CONTENT_LENGTH')<>Nil then
    begin
    clen:=strpas (getenv('CONTENT_LENGTH'));
    val(clen,qslen);
    if upcase(strpas(getenv('CONTENT_TYPE')))='APPLICATION/X-WWW-FORM-URLENCODED'
      then
      begin
      getmem(querystring,qslen+1);
      sptr :=0;
      while sptr<>qslen do
        begin
        read(ch);
        pchar(longint(querystring)+sptr)^ :=ch;
        inc(sptr);
        end;
      { !!! force null-termination }
      pchar(longint(querystring)+sptr)^ :=#0;
      query_read:=Chop(QueryString);
      end;
    end;
  done_init :=true;
end;

procedure cgi_init;
var
  rmeth : pchar;
begin
  query_read:=0;
  rmeth :=http_request_method;
  if rmeth=nil then
    begin
    uncgi_error('cgi_init()','No REQUEST_METHOD passed from server!');
    exit;
    end;
  if strcomp('POST',rmeth)=0 then cgi_read_post_query else
  if strcomp('GET',rmeth)=0 then cgi_read_get_query else
  uncgi_error('cgi_init()','No REQUEST_METHOD passed from server!');
end;

procedure cgi_deinit;
begin
  done_init :=false;
  query_read :=0;
  fillchar(query_array,sizeof(query_array),0);
end;



begin
  {$ifdef win32}
  InitWin32CGI;
  {$endif}
  uncgi_error:=@def_uncgi_error;
  done_init :=false;
  fillchar(query_array,sizeof(query_array),0);
end.

{
  HISTORY
  $Log$
  Revision 1.6  2000-01-10 23:46:19  peter
    * works also under go32v2

  Revision 1.5  1999/11/14 15:59:06  peter
    * fpcmake'd

  Revision 1.4  1999/07/26 20:07:44  michael
  + Fix for empty values by Andre Steinert



        -       1.0.0   03/07/97
                ----------------
                Only GET method implemented

        -       1.0.1   05/07/97
                ----------------
                +       Extra procedures for getting extra information:
                        *       referrer
                        *       user agent
                        *       request method
                +       Crude POST reading

        -       1.1.0   14/07/97
                ----------------
                +       Bugfix in POST reading, still doesn't work right.

        -       2.0.0   02/08/97
                ----------------
                Started from scratch, POST reading still limited to
                255 characters max. for value

        -       2.0.1  04/08/97
                ---------------
                Conversion from strings to pchar done by
                Michael van Canneyt. (Routines "UnEscape" and "Chop")
                Small changes made to convert everything to pchar usage.

        -       2.0.2  22/04/98
                ---------------
                tested with Apache HTTP Server and bugfix in pchar conversion,
                PChar(Longint(PChar)+x)) syntax modified to PChar[x]
                by Laszlo Nemeth.

        -       2.0.3  05/06/98
                ---------------
                Added maintainer_name,maintainer_email,uncgi_year
                diff from Bernhard van Staveren.

        -       2.0.4  09/07/98
                ---------------
                Some more error checking.
                cgi_error is now a procedural variable with the old
                cgi_erro procedure as a default value, allowing recovery
                incase of an error, and not immediate shutdown.

        -       2.0.6 02/28/99
                --------------
                The unit can be used under Win32 also.

        -       2.0.7 04/04/99
                --------------
                Inversed order of Chop and unescape, thus fixing bug of possible
                '=' and '&' characters in values.
        -       2.0.8 04/08/99
                --------------
                Fixed bug in unescape, qslen wasn't initialized.
        -       2.0.9 05/16/99
                --------------
                Some fixes by Georgi Georgiev
}

