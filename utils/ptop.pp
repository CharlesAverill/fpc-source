
Program PtoP;
{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by Michael Van Canneyt, member of
    the Free Pascal development team

    Pascal pretty print program

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

Uses PtoPu,Objects,getopts;

Var
  Infilename,OutFileName,ConfigFile : String;
  BeVerbose : Boolean;
  TheIndent,TheBufSize,TheLineSize : Integer;

Function StrToInt(Const S : String) : Integer;

Var Code : integer;
    Int : integer;

begin
  Val(S,int,Code);
  StrToInt := int;
  If Code<>0 then StrToInt:=0;
end;

Procedure Usage;

begin
  Writeln ('ptop : Usage : ');
  Writeln ('ptop [-v] [-i indent] [-b bufsize ][-c optsfile][-l linesize] infile outfile');
  Writeln ('     converts infile to outfile.');
  Writeln ('     -c : read options from optsfile');
  Writeln ('     -i : Set number of indent spaces.');
  Writeln ('     -l : Set maximum output linesize.');
  Writeln ('     -b : Use buffers of size bufsize');
  Writeln ('     -v : be verbose');
  writeln ('ptop -g ofile');
  writeln ('     generate default options file');
  Writeln ('ptop -h : This help');
  halt(0);
end;

Procedure Genopts;

Var S : PBufStream;

begin
  S:=New(PBufStream,Init(ConfigFile,stCreate,255));
  GeneratecfgFile(S);
{$ifndef tp}
  S^.Close;
{$endif}
  S^.Done;
end;

Procedure ProcessOpts;

Var c : char;

begin
  { Set defaults }
  Infilename:='';
  OutFileName:='';
  ConfigFile:='';
  TheIndent:=2;
  TheBufSize:=255;
  TheLineSize:=MaxLineSize;
  BeVerbose:=False;
  Repeat
    c:=getopt('i:c:g:b:hv');
    case c of
      'i' : begin
            TheIndent:=StrToInt(OptArg);
            If TheIndent=0 then TheIndent:=2;
            end;
      'b' : begin
            TheBufSize:=StrToInt(OptArg);
            If TheBufSize=0 then TheBufSize:=255;
            end;
      'c' : ConfigFile:=OptArg;
      'l' : begin
            TheLineSize:=StrToInt(OptArg);
            If TheLineSIze=0 Then TheLineSize:=MaxLineSize;
            end;
      'g' : begin
            ConfigFIle:=OptArg;
            GenOpts;
            halt(0);
            end;
      'h' : usage;
      'v' : BeVerbose:=True;
    else
    end;
  until c=endofoptions;
  If optind<=paramcount then
    begin
    InFileName:=paramstr(OptInd);
    Inc(optind);
    If OptInd<=paramcount then
      OutFilename:=Paramstr(OptInd);
    end;
end; { Of ProcessOpts }

Var DiagS : PMemoryStream;
    InS,OutS,cfgS : PBufSTream;
    PPrinter : TPrettyPrinter;
    P : Pchar;
    i : longint;


Procedure StreamErrorProcedure(Var S: TStream);{$ifndef fpc}FAR;{$endif}
Begin
 If S.Status = StError then
    WriteLn('ERROR: General Access failure. Halting');
 If S.Status = StInitError then
    WriteLn('ERROR: Cannot Init Stream. Halting. ');
 If S.Status = StReadError then
    WriteLn('ERROR: Read beyond end of Stream. Halting');
 If S.Status = StWriteError then
    WriteLn('ERROR: Cannot expand Stream. Halting');
 If S.Status = StGetError then
    WriteLn('ERROR: Get of Unregistered type. Halting');
 If S.Status = StPutError then
    WriteLn('ERROR: Put of Unregistered type. Halting');
end;


begin
  StreamError:={$ifndef tp}@{$endif}StreamErrorProcedure;
  ProcessOpts;
  If (Length(InfileName)=0) or (Length(OutFileName)=0) Then
    Usage;
  Ins:=New(PBufStream,Init(InFileName,StopenRead,TheBufSize));
  OutS:=New(PBufStream,Init(OutFileName,StCreate,TheBufSize));
  If BeVerbose then
    diagS:=New(PMemoryStream,Init(1000,255))
  else
    DiagS:=Nil;
  If ConfigFile<>'' then
    CfgS:=New(PBufStream,Init(ConfigFile,StOpenRead,TheBufSize))
  else
    CfgS:=Nil;
  PPrinter.Create;
  PPrinter.Indent:=TheIndent;
  PPrinter.LineSize:=TheLineSize;
  PPrinter.Ins:=Ins;
  PPrinter.outS:=OutS;
  PPrinter.cfgS:=CfgS;
  PPrinter.DiagS:=DiagS;
  PPrinter.PrettyPrint;
  If Assigned(DiagS) then
    begin
    I:=DiagS^.GetSize;
    DiagS^.Seek(0);
    getmem (P,I+1);
    DiagS^.Read(P[0],I);
    P[I]:=#0;
{$ifndef tp}
    Writeln (stderr,P);
    Flush(stderr);
{$else}
    Writeln (P);
{$endif}
    DiagS^.Done;
    end;
  If Assigned(CfgS) then
    CfgS^.Done;
  Ins^.Done;
  OutS^.Done;
end.

{
  $Log$
  Revision 1.1  2000-07-13 10:16:22  michael
  + Initial import

  Revision 1.7  2000/07/04 19:05:55  peter
    * be optimistic: version 1.00 for some utils

  Revision 1.6  2000/02/09 16:44:15  peter
    * log truncated

  Revision 1.5  2000/02/07 13:41:51  peter
    * fix wrong $ifdef tp

  Revision 1.4  2000/02/06 19:58:24  carl
    + Error detection of streams

  Revision 1.3  2000/01/07 16:46:04  daniel
    * copyright 2000

}
