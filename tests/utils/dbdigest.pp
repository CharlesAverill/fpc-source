{
  $Id$
    This file is part of the Free Pascal test suite.
    Copyright (c) 2002 by the Free Pascal development team.

    This program generates a digest
    of the last tests run.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$mode objfpc}
{$h+}

program digest;

uses
  sysutils,teststr,testu,dbtests;


Type
  TTestStatus = (
  stFailedToCompile,
  stSuccessCompilationFailed,
  stFailedCompilationsuccessful,
  stSuccessfullyCompiled,
  stFailedToRun,
  stKnownRunProblem,
  stSuccessFullyRun,
  stSkippingGraphTest,
  stSkippingInteractiveTest,
  stSkippingKnownBug,
  stSkippingCompilerVersionTooLow,
  stSkippingOtherCpu,
  stskippingRunUnit,
  stskippingRunTest
  );


Const
  FirstStatus = stFailedToCompile;
  LastStatus = stskippingRunTest; 
  
  TestOK : Array[TTestStatus] of Boolean = (
    False, // stFailedToCompile,
    True,  // stSuccessCompilationFailed,
    False, // stFailedCompilationsuccessful,
    True,  // stSuccessfullyCompiled,
    False, // stFailedToRun,
    True,  // stKnownRunProblem,
    True,  // stSuccessFullyRun,
    False, // stSkippingGraphTest,
    False, // stSkippingInteractiveTest,
    False, // stSkippingKnownBug,
    False, // stSkippingCompilerVersionTooLow,
    False, // stSkippingOtherCpu,
    False, // stskippingRunUnit,
    False  // stskippingRunTest
  );

  TestSkipped : Array[TTestStatus] of Boolean = (
    False,  // stFailedToCompile,
    False,  // stSuccessCompilationFailed,
    False,  // stFailedCompilationsuccessful,
    False,  // stSuccessfullyCompiled,
    False,  // stFailedToRun,
    False,  // stKnownRunProblem,
    False,  // stSuccessFullyRun,
    True,   // stSkippingGraphTest,
    True,   // stSkippingInteractiveTest,
    True,   // stSkippingKnownBug,
    True,   // stSkippingCompilerVersionTooLow,
    True,   // stSkippingOtherCpu,
    True,   // stskippingRunUnit,
    True    // stskippingRunTest
  );

  ExpectRun : Array[TTestStatus] of Boolean = (
    False,  // stFailedToCompile,
    False,  // stSuccessCompilationFailed,
    False,  // stFailedCompilationsuccessful,
    True ,  // stSuccessfullyCompiled,
    False,  // stFailedToRun,
    False,  // stKnownRunProblem,
    False,  // stSuccessFullyRun,
    False,  // stSkippingGraphTest,
    False,  // stSkippingInteractiveTest,
    False,  // stSkippingKnownBug,
    False,  // stSkippingCompilerVersionTooLow,
    False,  // stSkippingOtherCpu,
    False,  // stskippingRunUnit,
    False   // stskippingRunTest
   );

  StatusText : Array[TTestStatus] of String = (
    failed_to_compile,
    success_compilation_failed,
    failed_compilation_successful ,
    successfully_compiled ,
    failed_to_run ,
    known_problem ,
    successfully_run ,
    skipping_graph_test ,
    skipping_interactive_test ,
    skipping_known_bug ,
    skipping_compiler_version_too_low ,
    skipping_other_cpu ,
    skipping_run_unit ,
    skipping_run_test
  );

Var
  StatusCount : Array[TTestStatus] of Integer;
  UnknownLines,
  unexpected_run : Integer;
  next_should_be_run : boolean;
 
var
  prevline : string;
  
Procedure ExtractTestFileName(Var Line : string);

Var I : integer;

begin
  I:=Pos(' ',Line);
  If (I<>0) then 
    Line:=Copy(Line,1,I-1);  
end;  

Function Analyse(Var Line : string; Var Status : TTestStatus) : Boolean;

Var
  TS : TTestStatus;
  Found : Boolean;
  
begin
  TS:=FirstStatus;
  Result:=False;
  For TS:=FirstStatus to LastStatus do
    begin
    Result:=Pos(StatusText[TS],Line)=1;
    If Result then
      begin
      Status:=TS;
      Delete(Line,1,Length(StatusText[TS]));
      ExtractTestFileName(Line);
      Writeln('Detected status ',Ord(ts),' ',StatusText[TS]);
      Break;
      end;
    TS:=succ(TS);
    end;
end;

Type

TConfigOpt = (
  coDatabaseName,
  soHost,
  coUserName,
  coPassword,
  coLogFile,
  coOS,
  coCPU,
  coDate
 );

Const

ConfigStrings : Array [TConfigOpt] of string = (
  'databasename',
  'host',
  'username',
  'password',
  'logfile',
  'os',
  'cpu',
  'date'
);

ConfigOpts : Array[TConfigOpt] of char 
           = ('d','h','u','p','l','o','c','t');

Var
  TestOS,
  TestCPU,
  DatabaseName,
  HostName,
  UserName,
  Password,
  LogFileName  : String;
  TestDate : TDateTime;
  
Procedure SetOpt (O : TConfigOpt; Value : string);

begin
  Case O of
    coDatabaseName : DatabaseName:=Value;
    soHost         : HostName:=Value;
    coUserName     : UserName:=Value;
    coPassword     : Password:=Value;
    coLogFile      : LogFileName:=Value;
    coOS           : TestOS:=Value;
    coCPU          : TestCPU:=Value; 
    coDate         : TestDate:=StrToDate(Value);
  end;
end;

Function ProcessOption(S: String) : Boolean;

Var
  N : String;
  I : Integer;
  Found : Boolean;
  co,o : TConfigOpt;  
    
begin
  Writeln('Processing option',S);
  I:=Pos('=',S);
  Result:=(I<>0);
  If Result then
    begin
    N:=Copy(S,1,I-1);
    Delete(S,1,I);  
    For co:=coDatabaseName to coDate do
      begin
      Result:=CompareText(ConfigStrings[co],N)=0;
      If Result then
        begin
        o:=co;
        Break;
        end;
      end;
    end;  
 If Result then   
   SetOpt(co,S)
 else  
   Verbose(V_ERROR,'Unknown option : '+S);
end;

Procedure ProcessConfigfile(FN : String);

Var
  F : Text;
  S : String;
  I : Integer;
  
begin
  If Not FileExists(FN) Then
    Exit;
  Writeln('Parsing config file',FN);
  Assign(F,FN);
  {$i-}
  Reset(F);
  If IOResult<>0 then
    Exit;
  {$I+}
  While not(EOF(F)) do
    begin
    ReadLn(F,S);
    S:=trim(S);
    I:=Pos('#',S);
    If I<>0 then
      S:=Copy(S,1,I-1);
    If (S<>'') then 
      ProcessOption(S);
    end;
  Close(F);  
end;

Procedure ProcessCommandLine;

Var
  I : Integer;
  O,V : String;
  c,co : TConfigOpt;
  Found : Boolean;
  
begin
  I:=1;
  While I<=ParamCount do
    begin
    O:=Paramstr(I);
    Found:=Length(O)=2;
    If Found then
      For co:=coDatabaseName to coDate do
        begin
        Found:=(O[2]=ConfigOpts[co]);
        If Found then
          begin
          c:=co;
          Break;
          end;
        end;
    If Not Found then
      Verbose(V_ERROR,'Illegal command-line option : '+O)
    else
      begin
      Found:=(I<ParamCount);
      If Not found then
        Verbose(V_ERROR,'Option requires argument : '+O)
      else
        begin
        inc(I);
        O:=Paramstr(I);
        SetOpt(c,o);
        end;
      end;  
    Inc(I);
    end;
end;      

Var
  TestCPUID : Integer;
  TestOSID  : Integer;

Procedure GetIDs;

begin
  TestCPUID := GetCPUId(TestCPU);
  If TestCPUID=-1 then
    Verbose(V_Error,'NO ID for CPU "'+TestCPU+'" found.');
  TestOSID  := GetOSID(TestOS);
  If TestOSID=-1 then
    Verbose(V_Error,'NO ID for OS "'+TestOS+'" found.');
  If (Round(TestDate)=0) then 
    Testdate:=Date;
end;

Function GetLog(FN : String) : String;

begin
  FN:=ChangeFileExt(FN,'.elg');
  If FileExists(FN) then
    Result:=GetFileContents(FN)
  else
    Result:='';  
end;

Procedure Processfile (FN: String);

var
  logfile : text;
  line : string;
  TS : TTestStatus;
  ID : integer;
  Testlog : string;
  
begin
  Assign(logfile,FN);
{$i-}
  reset(logfile);
  if ioresult<>0 then
    Verbose(V_Error,'Unable to open log file'+logfilename);
{$i+}
  while not eof(logfile) do
    begin
    readln(logfile,line);
    If analyse(line,TS) then
      begin
      Inc(StatusCount[TS]);
      If Not ExpectRun[TS] then
        begin
        ID:=RequireTestID(Line);
        If (ID<>-1) then
          begin
          If Not (TestOK[TS] or TestSkipped[TS]) then
            TestLog:=GetLog(Line)
          else
            TestLog:='';  
          AddTestResult(ID,TestOSID,TestCPUID,Ord(TS),
                        TestOK[TS],TestSkipped[TS],
                        TestLog,
                        TestDate);
          end;              
        end
      end  
    else
      Inc(UnknownLines);  
    end;
  close(logfile);
end;


begin
  ProcessConfigFile('dbdigest.cfg');
  ProcessCommandLine;
  If LogFileName<>'' then
    begin
    ConnectToDatabase(DatabaseName,HostName,UserName,Password);
    GetIDs;
    ProcessFile(LogFileName)
    end
  else  
    Verbose(V_ERROR,'Missing log file name');
end.

{
  $Log$
  Revision 1.1  2002-12-17 15:04:32  michael
  + Added dbdigest to store results in a database

  Revision 1.2  2002/11/18 16:42:43  pierre
   + KNOWNRUNERROR added

  Revision 1.1  2002/11/13 15:26:24  pierre
   + digest program added

}
