{
    $Id$

    Fake GDBCon unit (including base from GDBInt)

 **********************************************************************}
unit GDBCon;
interface
uses
  GdbInt;

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
    function  LoadFile(const fn:string):boolean;
    procedure SetArgs(const s : string);
    procedure ClearSymbols;
  end;

  { gdb does not allow \ in dir or filenames }
  procedure UnixDir(var s : string);


implementation


procedure UnixDir(var s : string);
var i : longint;
begin
  for i:=1 to length(s) do
    if s[i]='\' then s[i]:='/';
end;


constructor TGDBController.Init;
begin
  inherited Init;
end;


destructor TGDBController.Done;
begin
  inherited Done;
end;


procedure TGDBController.Command(const s:string);
begin
end;

procedure TGDBController.CommandBegin(const s:string);
begin
end;

procedure TGDBController.CommandEnd(const s:string);
begin
end;

procedure TGDBController.Reset;
begin
end;


function TGDBController.LoadFile(const fn:string):boolean;
begin
  LoadFile:=true;
end;

procedure TGDBController.SetArgs(const s : string);
begin
end;


var
  stepline : longint;
procedure TGDBController.StartTrace;
begin
  Run;
end;

procedure TGDBController.Run;
begin
  stepline:=1;
  DoSelectSourceLine('test.pas',stepline);
end;

procedure TGDBController.TraceStep;
begin
  inc(stepline);
  DoUserScreen;
  DoDebuggerScreen;
  DoSelectSourceLine('test.pas',stepline);
end;


procedure TGDBController.TraceNext;
begin
  inc(stepline,2);
  DoUserScreen;
  DoDebuggerScreen;
  DoSelectSourceLine('test.pas',stepline);
end;


procedure TGDBController.Continue;
begin
end;


procedure TGDBController.ClearSymbols;
begin
end;


procedure TGDBController.WriteErrorBuf;
begin
end;


procedure TGDBController.WriteOutputBuf;
begin
end;

function  TGDBController.GetOutput : Pchar;
begin
  GetOutput:=nil;
end;

function  TGDBController.GetError : Pchar;
begin
  GetError:=nil;
end;

end.
{
  $Log$
  Revision 1.10  1999-02-16 10:44:14  peter
    * updated

  Revision 1.9  1999/02/11 13:03:28  pierre
      Problem with last commit
    + added virtuals CommandBegin and CommandEnd
    + added command_level for TGDBInterface


  Revision 1.7  1999/02/10 09:00:43  pierre
     * duplicate call_reset removed
     * frames allocation and freeing corrected
     + GetError and GetOutput pchar function added
     + stop_breakpoint_number to know why the program stopped
       (used for watches)

  Revision 1.6  1999/02/08 17:35:07  pierre
    + added Run made TraceStep TraceNext Continue virtual

  Revision 1.5  1999/02/08 13:59:58  pierre
    - removed second debugger_started in TGDBController
    + StartTrace and Reset made virtual to be able to
      change CmResetDebugger state in IDE

  Revision 1.4  1999/02/08 11:39:33  pierre
   * reflect added setArgs in gdbint

  Revision 1.3  1999/02/06 00:04:55  florian
    * faked gdb fixed

  Revision 1.2  1999/02/04 17:19:22  peter
    * linux fixes

  Revision 1.1  1999/02/02 16:38:05  peter
    * renamed for better tp7 usage

  Revision 1.1  1999/01/28 19:56:12  peter
    * moved to include compiler/gdb independent of each other

  Revision 1.1  1999/01/22 10:24:17  peter
    + gdbcon fake unit

}

