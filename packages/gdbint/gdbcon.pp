{
    $Id$
    Copyright (c) 1998 by Peter Vreman

    Lowlevel GDB interface which communicates directly with libgdb

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit GDBCon;
interface

uses
  GDBInt;

type
  PGDBController=^TGDBController;
  TGDBController=object(TGDBInterface)
    progname   : pchar;
    progargs   : pchar;
    in_command,
    init_count : longint;
    constructor Init;
    destructor  Done;
    procedure CommandBegin(const s:string);virtual;
    procedure Command(const s:string);
    procedure CommandEnd(const s:string);virtual;
    procedure Reset;virtual;
    { tracing }
    procedure StartTrace;
    procedure Run;virtual;
    procedure TraceStep;virtual;
    procedure TraceNext;virtual;
    procedure Continue;virtual;
    { needed for dos because newlines are only #10 (PM) }
    procedure WriteErrorBuf;
    procedure WriteOutputBuf;
    function  GetOutput : Pchar;
    function  GetError : Pchar;
    function  LoadFile(var fn:string):boolean;
    procedure SetArgs(const s : string);
    procedure ClearSymbols;
  end;

procedure UnixDir(var s : string);

implementation

uses
  strings;

procedure UnixDir(var s : string);
var i : longint;
begin
  for i:=1 to length(s) do
    if s[i]='\' then s[i]:='/';
end;

constructor TGDBController.Init;
begin
  inherited init;
end;


destructor TGDBController.Done;
begin
  if assigned(progname) then
    strdispose(progname);
  if assigned(progargs) then
    strdispose(progargs);
  inherited done;
end;


procedure TGDBController.Command(const s:string);
begin
  CommandBegin(s);
  gdboutputbuf.reset;
  gdberrorbuf.reset;
  inc(in_command);
  gdb_command(s);
  dec(in_command);
  {
    What is that for ?? PM
    I had to comment it because
    it resets the debuggere after each command !!
    Maybe it can happen on errors ??
  if in_command<0 then
   begin
     in_command:=0;
     inc(in_command);
     Reset;
     dec(in_command);
   end; }
  CommandEnd(s);
end;

procedure TGDBController.CommandBegin(const s:string);
begin
end;

procedure TGDBController.CommandEnd(const s:string);
begin
end;

function TGDBController.LoadFile(var fn:string):boolean;
var
  cmd : string;
begin
  getdir(0,cmd);
  UnixDir(cmd);
  cmd:='cd '+cmd;
  Command(cmd);
  GDB__Init;
  UnixDir(fn);
  if assigned(progname) then
    strdispose(progname);
  getmem(progname,length(fn)+1);
  strpcopy(progname,fn);
  Command('file '+fn);
  LoadFile:=true;
end;

procedure TGDBController.SetArgs(const s : string);
begin
  if assigned(progargs) then
    strdispose(progargs);
  getmem(progargs,length(s)+1);
  strpcopy(progargs,s);
  command('set args '+s);
end;

procedure TGDBController.Reset;
begin
  call_reset:=false;
{ DeleteBreakPoints(); }
  if debuggee_started then
   begin
     reset_command:=true;
     BreakSession;
     Command('kill');
     reset_command:=false;
     debuggee_started:=false;
   end;
end;

procedure TGDBController.StartTrace;
begin
  Command('tbreak PASCALMAIN');
  Run;
end;

procedure TGDBController.Run;
begin
  Command('run');
  inc(init_count);
end;


procedure TGDBController.TraceStep;
begin
  Command('step');
end;


procedure TGDBController.TraceNext;
begin
  Command('next');
end;


procedure TGDBController.Continue;
begin
  Command('continue');
end;


procedure TGDBController.ClearSymbols;
begin
  if debuggee_started then
   Reset;
  if init_count>0 then
   Command('file');
end;


procedure BufWrite(Buf : pchar);
  var p,pe : pchar;
begin
  p:=buf;
  While assigned(p) do
    begin
       pe:=strscan(p,#10);
       if pe<>nil then
         pe^:=#0;
       Writeln(p);
       { restore for dispose }
       if pe<>nil then
         pe^:=#10;
       if pe=nil then
         p:=nil
       else
         begin
           p:=pe;
           inc(p);
         end;
    end;
end;


function  TGDBController.GetOutput : Pchar;
begin
  GetOutput:=gdboutputbuf.buf;
end;

function  TGDBController.GetError : Pchar;
var p : pchar;
begin
  p:=gdberrorbuf.buf;
  if (p^=#0) and got_error then
    GetError:=pchar(longint(gdboutputbuf.buf)+gdboutputbuf.idx)
  else
    GetError:=p;
end;

procedure TGDBController.WriteErrorBuf;
begin
   BufWrite(gdberrorbuf.buf);
end;


procedure TGDBController.WriteOutputBuf;
begin
   BufWrite(gdboutputbuf.buf);
end;


end.
{
  $Log$
  Revision 1.2  2000-07-13 11:33:15  michael
  + removed logs
 
}
