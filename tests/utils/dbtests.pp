{$mode objfpc}
{$H+}

unit dbtests;

Interface 

Uses 
  mysql,testu;

{ ---------------------------------------------------------------------
  High-level access  
  ---------------------------------------------------------------------}

Function GetTestID(Name : string) : Integer; 
Function GetOSID(Name : String) : Integer;
Function GetCPUID(Name : String) : Integer;
Function GetVersionID(Name : String) : Integer;
Function GetRunID(OSID, CPUID, VERSIONID : Integer; Date : TDateTime) : Integer;
Function AddRun(OSID, CPUID, VERSIONID : Integer; Date : TDateTime) : Integer;
Function AddTest(Name : String; AddSource : Boolean) : Integer;
Function UpdateTest(ID : Integer; Info : TConfig; Source : String) : Boolean;
Function AddTestResult(TestID,RunID,TestRes : Integer; 
                       OK, Skipped : Boolean;
                       Log : String) : Integer;
Function RequireTestID(Name : String): Integer;
Function CleanTestRun(ID : Integer) : Boolean;

{ ---------------------------------------------------------------------
    Low-level DB access.
  ---------------------------------------------------------------------}
 

Type
  TQueryResult = PMYSQL_RES;

Function  ConnectToDatabase(DatabaseName,Host,User,Password : String) : Boolean;
Procedure DisconnectDatabase;
Function  RunQuery (Qry : String; Var res : TQueryResult) : Boolean ;
Procedure FreeQueryResult (Res : TQueryResult);
Function  GetResultField (Res : TQueryResult; Id : Integer) : String;
Function  IDQuery(Qry : String) : Integer;
Function  EscapeSQL( S : String) : String;
Function SQLDate(D : TDateTime) : String;

Implementation

Uses 
  SysUtils;

{ ---------------------------------------------------------------------
    Low-level DB access.
  ---------------------------------------------------------------------}


Var
  Connection : TMYSQL;
    

Function ConnectToDatabase(DatabaseName,Host,User,Password : String) : Boolean;

Var 
  S : String;

begin
  Verbose(V_DEBUG,'Connection params : '+DatabaseName+' '+Host+' '+User+' '+Password);
  Result:=mysql_connect(@Connection,PChar(Host),PChar(User),PChar(Password))<>Nil;
  If Not Result then 
    begin
    S:=Strpas(mysql_error(@connection));
    Verbose(V_ERROR,'Failed to connect to database : '+S);
    end
  else
    begin
    Result:=Mysql_select_db(@Connection,Pchar(DatabaseName))>=0;
    If Not result then
      begin
      S:=StrPas(mysql_error(@connection));
      DisconnectDatabase;
      Verbose(V_Error,'Failed to select database : '+S);
      end;
    end;  
end;

Procedure DisconnectDatabase;

begin
  mysql_close(@Connection);
end;

Function RunQuery (Qry : String; Var res : TQueryResult) : Boolean ;

begin
  Verbose(V_DEBUG,'Running query:'+Qry);
  Result:=mysql_query(@Connection,PChar(qry))>=0;
  If Not Result then
    Verbose(V_WARNING,'Query : '+Qry+'Failed : '+Strpas(mysql_error(@connection)))
  else
    Res:=Mysql_store_result(@connection);
end;

Function GetResultField (Res : TQueryResult; Id : Integer) : String;

Var
  Row : TMYSQL_ROW;

begin
  if Res=Nil then
    Result:=''
  else  
    begin
    Row:=mysql_fetch_row(Res);
    If (Row=Nil) or (Row[ID]=Nil) then
      Result:=''
    else  
      Result:=strpas(Row[ID]); 
    end;
  Verbose(V_DEBUG,'Field value '+Result);  
end;

Procedure FreeQueryResult (Res : TQueryResult);

begin
  mysql_free_result(Res);
end;

Function IDQuery(Qry : String) : Integer;

Var
  Res : TQueryResult;

begin
  Result:=-1;
  If RunQuery(Qry,Res) then
    begin
    Result:=StrToIntDef(GetResultField(Res,0),-1);
    FreeQueryResult(Res);
    end;
end; 

Function EscapeSQL( S : String) : String;


begin
  Result:=StringReplace(S,'"','\"',[rfReplaceAll]);
  Verbose(V_DEBUG,'EscapeSQL : "'+S+'" -> "'+Result+'"');
end;


Function SQLDate(D : TDateTime) : String;

begin
  Result:=FormatDateTime('YYYY/MM/DD hh:nn:ss',D);
end;

{ ---------------------------------------------------------------------
  High-level access  
  ---------------------------------------------------------------------}
 
  
Function GetTestID(Name : string) : Integer; 

Const
  SFromName = 'SELECT T_ID FROM TESTS WHERE (T_NAME="%s")';
  SFromFullName = 'SELECT T_ID FROM TESTS WHERE (T_FULLNAME="%s")';
  
Var
  FN : String;

begin
  FN:=ExtractFileName(Name);
  Result:=IDQuery(Format(SFromName,[FN]));
  If Result=-1 then
    Result:=IDQuery(Format(SFromFullName,[Name]))
end;

Function GetOSID(Name : String) : Integer;

Const 
  SFromName = 'SELECT TO_ID FROM TESTOS WHERE (TO_NAME="%s")';

begin
  Result:=IDQuery(Format(SFromName,[Name]));
end;

Function GetVersionID(Name : String) : Integer;

Const 
  SFromName = 'SELECT TV_ID FROM TESTVERSION WHERE (TV_VERSION="%s")';

begin
  Result:=IDQuery(Format(SFromName,[Name]));
end;

Function GetCPUID(Name : String) : Integer;

Const 
  SFromName = 'SELECT TC_ID FROM TESTCPU WHERE (TC_NAME="%s")';

begin
  Result:=IDQuery(Format(SFromName,[Name]));
end;


Function GetRunID(OSID, CPUID, VERSIONID : Integer; Date : TDateTime) : Integer;


Const 
  SFromIDS = 'SELECT TU_ID FROM TESTRUN WHERE '+
             ' (TU_OS_FK=%d) '+
             ' AND (TU_CPU_FK=%d) '+
             ' AND (TU_VERSION_FK=%d) '+
             ' AND (TU_DATE="%s")';
              
begin
  Result:=IDQuery(Format(SFromIDS,[OSID,CPUID,VERSIONID,SQLDate(Date)]));
end;

Function AddRun(OSID, CPUID, VERSIONID : Integer; Date : TDateTime) : Integer;

Const 
  SInsertRun = 'INSERT INTO TESTRUN '+
               '(TU_OS_FK,TU_CPU_FK,TU_VERSION_FK,TU_DATE)'+
               ' VALUES '+
               '(%d,%d,%d,"%s")'; 

Var
  Res : TQueryResult;

begin
  If RunQuery(Format(SInsertRun,[OSID,CPUID,VERSIONID,SQLDate(Date)]),Res) then
    Result:=mysql_insert_id(@connection)
  else
    Result:=-1;  
end;


Function AddTest(Name : String; AddSource : Boolean) : Integer;

Const 
  SInsertTest = 'INSERT INTO TESTS (T_NAME,T_FULLNAME,T_ADDDATE)'+
                ' VALUES ("%s","%s",NOW())'; 

Var
  Info : TConfig;
  Res  : TQueryResult;
    
begin
  Result:=-1;
  If FileExists(Name) and GetConfig(Name,Info) then
    begin
    If RunQuery(Format(SInsertTest,[ExtractFileName(Name),Name]),Res) then
      begin
      Result:=GetTestID(Name);
      If Result=-1 then
        Verbose(V_WARNING,'Could not find newly added test!')
      else
        If AddSource then
          UpdateTest(Result,Info,GetFileContents(Name))
        else
          UpdateTest(Result,Info,'');  
      end
    end
  else    
    Verbose(V_ERROR,'Could not find test "'+Name+'" or info about this test.');
end;

Const
  B : Array[Boolean] of String = ('-','+');

Function UpdateTest(ID : Integer; Info : TConfig; Source : String) : Boolean;

Const
  SUpdateTest = 'Update TESTS SET '+
                ' T_CPU="%s", T_OS="%s", T_VERSION="%s",'+
                ' T_GRAPH="%s", T_INTERACTIVE="%s", T_RESULT=%d,'+
                ' T_FAIL="%s", T_RECOMPILE="%s", T_NORUN="%s",'+
                ' T_NEEDLIBRARY="%s", T_KNOWNRUNERROR=%d,'+
                ' T_KNOWN="%s", T_NOTE="%s", T_OPTS = "%s"'+
                ' %s '+
                'WHERE'+
                ' T_ID=%d';

 
Var
  Qry : String;
  Res : TQueryResult;
      
begin
  If Source<>'' then
    begin
    Source:=EscapeSQL(Source);
    Source:=', T_SOURCE="'+Source+'"';
    end;
  With Info do
    Qry:=Format(SUpdateTest,[EscapeSQL(NeedCPU),'',EscapeSQL(MinVersion),
                             B[usesGraph],B[IsInteractive],ResultCode,
                             B[ShouldFail],B[NeedRecompile],B[NoRun],
                             B[NeedLibrary],KnownRunError,
                             B[IsKnown],EscapeSQL(Note),EscapeSQL(NeedOptions),
                             Source,
                             ID
     ]);
  Result:=RunQuery(Qry,res)
end;

Function AddTestResult(TestID,RunID,TestRes : Integer; 
                       OK, Skipped : Boolean;
                       Log : String) : Integer;

Const
  SInsertRes='Insert into TESTRESULTS '+
             '(TR_TEST_FK,TR_TESTRUN_FK,TR_OK,TR_SKIP,TR_RESULT,TR_LOG) '+
             ' VALUES '+
             '(%d,%d,"%s","%s",%d,"%s") ';

Var
  Qry : String;
  Res : TQueryResult;
   
begin
  Result:=-1;
  Qry:=Format(SInsertRes,
              [TestID,RunID,B[OK],B[Skipped],TestRes,EscapeSQL(Log)]);
  If RunQuery(Qry,Res) then
    Result:=mysql_insert_id(@connection);
end;

Function RequireTestID(Name : String): Integer;

begin
  Result:=GetTestID(Name);
  If Result=-1 then
    Result:=AddTest(Name,FileExists(Name));
  If Result=-1 then
    Verbose(V_WARNING,'Could not find or create entry for test '+Name);
end;

Function CleanTestRun(ID : Integer) : Boolean;

Const
  SDeleteRun = 'DELETE FROM TESTRESULTS WHERE TR_TESTRUN_FK=%d';

Var
 Res : TQueryResult;

begin
  Result:=RunQuery(Format(SDeleteRun,[ID]),Res);
end;

end.