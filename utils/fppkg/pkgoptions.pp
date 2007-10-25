{
    This file is part of the Free Pascal Utilities
    Copyright (c) 1999-2000 by the Free Pascal development team

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$mode objfpc}
{$h+}
unit pkgoptions;

interface

uses Classes, Sysutils, Inifiles, fprepos;

Const
  DefaultManifestFile      = 'manifest.xml';

Type

  { TPackagerOptions }

  TPackagerOptions = Class(TPersistent)
  private
    FDirty: Boolean;
    // Global options
    FRemoteMirrorsLocation : String;
    FLocalMirrorsLocation : String;
    FRemoteRepository : String;
    FLocalRepository : String;
    FCompilerConfigDir,
    FPackagesDir,
    FBuildDir : String;
    FDefaultVerbosity,
    FCurrentCompilerConfig,
    FDefaultCompilerConfig : String;
    // Compiler specific options
    FCompiler : String;
    FCompilerCPU: TCPU;
    FCompilerOS: TOS;
    FCompilerVersion : String;
    FInstallDir : String;
    // Compiler settings for compiling FPMake.pp
    FFPMakeCompiler : String;
    FFPMakeUnitDir : String;
    // Parameter options
    FBootStrap : Boolean;
    function GetOptString(Index: integer): String;
    procedure SetOptString(Index: integer; const AValue: String);
    procedure SetCompilerCPU(const AValue: TCPU);
    procedure SetCompilerOS(const AValue: TOS);
  Public
    Constructor Create;
    Procedure InitGlobalDefaults;
    Procedure LoadGlobalFromIni(Ini : TCustomIniFile); virtual;
    Procedure SaveGlobalToIni(Ini : TCustomIniFile); virtual;
    Procedure LoadGlobalFromFile(FileName : String);
    Procedure SaveGlobalToFile(FileName : String);
    Procedure InitCompilerDefaults;
    Procedure LoadCompilerFromIni(Ini : TCustomIniFile); virtual;
    Procedure SaveCompilerToIni(Ini : TCustomIniFile); virtual;
    Procedure LoadCompilerFromFile(FileName : String);
    Procedure SaveCompilerToFile(FileName : String);
    Property Dirty : Boolean Read FDirty;
    function RemotePackagesFile:string;
    function LocalPackagesFile:string;
    function LocalVersionsFile(CompilerConfig:String):string;
  Published
    Property RemoteMirrorsLocation : String Index 0 Read GetOptString Write SetOptString;
    Property LocalMirrorsLocation : String Index 1 Read GetOptString Write SetOptString;
    Property RemoteRepository : String Index 2 Read GetOptString Write SetOptString;
    Property LocalRepository : String Index 3 Read GetOptString Write SetOptString;
    Property BuildDir : String Index 5 Read GetOptString Write SetOptString;
    Property Compiler : String Index 6 Read GetOptString Write SetOptString;
    Property CompilerTarget : String Index 7 Read GetOptString Write SetOptString;
    Property DefaultCompilerConfig : String Index 8 Read GetOptString Write SetOptString;
    Property CompilerVersion : String Index 9 Read GetOptString Write SetOptString;
    Property InstallDir : String Index 10 Read GetOptString Write SetOptString;
    Property DefaultVerbosity : String Index 11 Read GetOptString Write SetOptString;
    Property PackagesDir : String Index 12 Read GetOptString Write SetOptString;
    Property CompilerConfigDir : String Index 13 Read GetOptString Write SetOptString;
    Property FPMakeCompiler : String Index 14 Read GetOptString Write SetOptString;
    Property FPMakeUnitDir : String Index 15 Read GetOptString Write SetOptString;
    Property CurrentCompilerConfig : String Index 16 Read GetOptString Write SetOptString;
    Property CompilerOS : TOS Read FCompilerOS Write SetCompilerOS;
    Property CompilerCPU : TCPU Read FCompilerCPU Write SetCompilerCPU;
    Property BootStrap : Boolean Read FBootStrap Write FBootStrap;
  end;

var
  Options : TPackagerOptions;

Implementation

uses
{$ifdef unix}
  baseunix,
{$endif}
  pkgglobals,
  pkgmessages;

Const
  DefaultMirrorFile       = 'mirrors.xml';
  DefaultPackagesFile     = 'packages.xml';
  DefaultVersionsFile     = 'versions-%s.dat';
  DefaultMirrorsLocation  = 'http://www.freepascal.org/repository/'+DefaultMirrorFile;
{$warning TODO use real repository}
{$ifdef unix}
  DefaultRemoteRepository = 'file://'+{$I %HOME%}+'/repository/';
{$else}
  DefaultRemoteRepository = 'c:/repository/';
{$endif}

  // ini file keys
  SDefaults = 'Defaults';

  // Global config
  KeyLocalMirrorsLocation  = 'LocalMirrors';
  KeyRemoteMirrorsLocation = 'RemoteMirrors';
  KeyRemoteRepository      = 'RemoteRepository';
  KeyLocalRepository       = 'LocalRepository';
  KeyCompilerConfigDir     = 'CompilerConfigDir';
  KeyPackagesDir           = 'PackagesDir';
  KeyBuildDir              = 'BuildDir';
  KeyCompilerConfig        = 'CompilerConfig';
  KeyVerbosity             = 'Verbosity';
  // Compiler dependent config
  KeyInstallDir            = 'InstallDir';
  KeyCompiler              = 'Compiler' ;
  KeyCompilerOS            = 'OS';
  KeyCompilerCPU           = 'CPU';
  KeyCompilerVersion       = 'Version';
  KeyFPMakeCompiler        = 'FPMakeCompiler';
  KeyFPMakeUnitDir         = 'FPMakeUnitDir';


{ TPackagerOptions }

constructor TPackagerOptions.Create;
begin
  InitGlobalDefaults;
end;


function TPackagerOptions.GetOptString(Index: integer): String;
begin
  Case Index of
    0 : Result:=FRemoteMirrorsLocation;
    1 : Result:=FLocalMirrorsLocation;
    2 : Result:=FRemoteRepository;
    3 : Result:=FLocalRepository;
    5 : Result:=FBuildDir;
    6 : Result:=FCompiler;
    7 : Result:=MakeTargetString(CompilerCPU,CompilerOS);
    8 : Result:=FDefaultCompilerConfig;
    9 : Result:=FCompilerVersion;
   10 : Result:=FInstallDir;
   11 : Result:=FDefaultVerbosity;
   12 : Result:=FPackagesDir;
   13 : Result:=FCompilerConfigDir;
   14 : Result:=FFPMakeCompiler;
   15 : Result:=FFPMakeUnitDir;
   16 : Result:=FCurrentCompilerConfig;
  end;
end;

procedure TPackagerOptions.SetOptString(Index: integer; const AValue: String);
begin
  If AValue=GetOptString(Index) then
    Exit;
  Case Index of
    0 : FLocalMirrorsLocation:=AValue;
    1 : FRemoteMirrorsLocation:=AValue;
    2 : FRemoteRepository:=AValue;
    3 : FLocalRepository:=AValue;
    5 : FBuildDir:=FixPath(AValue);
    6 : FCompiler:=AValue;
    7 : StringToCPUOS(AValue,FCompilerCPU,FCompilerOS);
    8 : FDefaultCompilerConfig:=AValue;
    9 : FCompilerVersion:=AValue;
   10 : FInstallDir:=FixPath(AValue);
   11 : FDefaultVerbosity:=AValue;
   12 : FPackagesDir:=FixPath(AValue);
   13 : FCompilerConfigDir:=FixPath(AValue);
   14 : FFPMakeCompiler:=AValue;
   15 : FFPMakeUnitDir:=FixPath(AValue);
   16 : FCurrentCompilerConfig:=AValue;
  end;
  FDirty:=True;
end;


procedure TPackagerOptions.SetCompilerCPU(const AValue: TCPU);
begin
  if FCompilerCPU=AValue then
    exit;
  FCompilerCPU:=AValue;
  FDirty:=True;
end;


procedure TPackagerOptions.SetCompilerOS(const AValue: TOS);
begin
  if FCompilerOS=AValue then
    exit;
  FCompilerOS:=AValue;
  FDirty:=True;
end;


function TPackagerOptions.RemotePackagesFile:string;
begin
  Result:=FRemoteRepository+DefaultPackagesFile;
end;


function TPackagerOptions.LocalPackagesFile:string;
begin
  Result:=FLocalRepository+DefaultPackagesFile;
end;


function TPackagerOptions.LocalVersionsFile(CompilerConfig:String):string;
begin
  Result:=FLocalRepository+Format(DefaultVersionsFile,[CompilerConfig]);
end;

Procedure TPackagerOptions.InitGlobalDefaults;
var
  LocalDir : String;
begin
  // Retrieve Local fppkg directory
{$ifdef unix}
  if (fpGetUID=0) then
    begin
      if DirectoryExists('/usr/local/lib/fpc') then
        LocalDir:='/usr/local/lib/fpc/fppkg/'
      else
        LocalDir:='/usr/lib/fpc/fppkg/';
    end
  else
    LocalDir:=IncludeTrailingPathDelimiter(GetEnvironmentVariable('HOME'))+'.fppkg/';
{$else}
  // Change as needed on all OS-es...
  LocalDir:=ExtractFilePath(Paramstr(0))+'fppkg'+PathDelim;
{$endif}
  // Directories
  FBuildDir:=LocalDir+'build'+PathDelim;
  FPackagesDir:=LocalDir+'packages'+PathDelim;
  FCompilerConfigDir:=LocalDir+'config'+PathDelim;
  FLocalMirrorsLocation:=LocalDir+DefaultMirrorFile;
  FLocalRepository:=LocalDir;
  // Remote
  FRemoteMirrorsLocation:=DefaultMirrorsLocation;
  FRemoteRepository:=DefaultRemoteRepository;
  // Other config
  FDefaultCompilerConfig:='default';
  FCurrentCompilerConfig:=FDefaultCompilerConfig;
  FDefaultVerbosity:='error,warning,info,debug,commands';
  FBootStrap:=False;
end;


Procedure TPackagerOptions.InitCompilerDefaults;
var
  infoSL : TStringList;
  DepDir : String;
  i : Integer;
begin
  FCompiler:=FileSearch('fpc'+ExeExt,GetEnvironmentVariable('PATH'));
  if FCompiler='' then
    Raise EPackagerError.Create(SErrMissingFPC);
  // Detect compiler version/target from -i option
  infosl:=TStringList.Create;
  infosl.Delimiter:=' ';
  infosl.DelimitedText:=GetCompilerInfo(FCompiler,'-iVTPTO');
  if infosl.Count<>3 then
    Raise EPackagerError.Create(SErrInvalidFPCInfo);
  FCompilerVersion:=infosl[0];
  FCompilerCPU:=StringToCPU(infosl[1]);
  FCompilerOS:=StringToOS(infosl[2]);
  Log(vDebug,SLogDetectedCompiler,[FCompiler,FCompilerVersion,MakeTargetString(FCompilerCPU,FCompilerOS)]);
  // Use the same algorithm as the compiler, see options.pas
{$ifdef Unix}
  FInstallDir:=FixPath(GetEnvironmentVariable('FPCDIR'));
  if FInstallDir='' then
    begin
      FInstallDir:='/usr/local/lib/fpc/'+FCompilerVersion+'/';
      if not DirectoryExists(FInstallDir) and
         DirectoryExists('/usr/lib/fpc/'+FCompilerVersion) then
        FInstallDir:='/usr/lib/fpc/'+FCompilerVersion+'/';
    end;
{$else unix}
  FInstallDir:=FixPath(GetEnvironmentVariable('FPCDIR'));
  if FInstallDir='' then
    begin
      FInstallDir:=ExtractFilePath(FCompiler)+'../';
      if not(DirectoryExists(FInstallDir+'/units')) and
         not(DirectoryExists(FInstallDir+'/rtl')) then
        FInstallDir:=FInstallDir+'../';
    end;
{$endif unix}
  Log(vDebug,SLogDetectedFPCDIR,[FInstallDir]);
  // Detect directory where fpmake units are located
  FFPMakeCompiler:=FCompiler;
  FFPMakeUnitDir:=FInstallDir+'units'+PathDelim+CompilerTarget+PathDelim;
  for i:=low(FPMKUnitDeps) to high(FPMKUnitDeps) do
    begin
      DepDir:=FFPMakeUnitDir+FPMKUnitDeps[i]+PathDelim;
      if not DirectoryExists(DepDir) then
        Log(vWarning,SWarnFPMKUnitNotFound,[DepDir]);
    end;
end;


procedure TPackagerOptions.LoadGlobalFromIni(Ini: TCustomIniFile);
begin
 With Ini do
   begin
     FLocalMirrorsLocation:=ReadString(SDefaults,KeyLocalMirrorsLocation,FLocalMirrorsLocation);
     FRemoteMirrorsLocation:=ReadString(SDefaults,KeyRemoteMirrorsLocation,FRemoteMirrorsLocation);
     FRemoteRepository:=ReadString(SDefaults,KeyRemoteRepository,FRemoteRepository);
     FLocalRepository:=ReadString(SDefaults,KeyLocalRepository,FLocalRepository);
     FBuildDir:=FixPath(ReadString(SDefaults,KeyBuildDir,FBuildDir));
     FPackagesDir:=FixPath(ReadString(SDefaults,KeyPackagesDir,FPackagesDir));
     FCompilerConfigDir:=FixPath(ReadString(SDefaults,KeyCompilerConfigDir,FCompilerConfigDir));
     FDefaultCompilerConfig:=ReadString(SDefaults,KeyCompilerConfig,FDefaultCompilerConfig);
     FDefaultVerbosity:=ReadString(SDefaults,KeyVerbosity,FDefaultVerbosity);
   end;
end;


procedure TPackagerOptions.SaveGlobalToIni(Ini: TCustomIniFile);
begin
 With Ini do
   begin
     WriteString(SDefaults,KeyBuildDir,FBuildDir);
     WriteString(SDefaults,KeyPackagesDir,FPackagesDir);
     WriteString(SDefaults,KeyCompilerConfigDir,FCompilerConfigDir);
     WriteString(SDefaults,KeyLocalRepository,FLocalRepository);
     WriteString(SDefaults,KeyLocalMirrorsLocation,FLocalMirrorsLocation);
     WriteString(SDefaults,KeyRemoteMirrorsLocation,FRemoteMirrorsLocation);
     WriteString(SDefaults,KeyRemoteRepository,FRemoteRepository);
     WriteString(SDefaults,KeyCompilerConfig,FDefaultCompilerConfig);
     WriteString(SDefaults,KeyVerbosity,FDefaultVerbosity);
   end;
end;


procedure TPackagerOptions.LoadGlobalFromFile(FileName: String);
Var
  Ini : TMemIniFile;
begin
  Ini:=TMemIniFile.Create(FileName);
  try
    LoadGlobalFromIni(Ini);
  finally
    Ini.Free;
  end;
end;


procedure TPackagerOptions.SaveGlobalToFile(FileName: String);
Var
  Ini : TIniFile;
begin
  Ini:=TIniFile.Create(FileName);
  try
    SaveGlobalToIni(Ini);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;


procedure TPackagerOptions.LoadCompilerFromIni(Ini: TCustomIniFile);
begin
 With Ini do
   begin
     FInstallDir:=FixPath(ReadString(SDefaults,KeyInstallDir,FInstallDir));
     FCompiler:=ReadString(SDefaults,KeyCompiler,FCompiler);
     FCompilerOS:=StringToOS(ReadString(SDefaults,KeyCompilerOS,OSToString(CompilerOS)));
     FCompilerCPU:=StringToCPU(ReadString(SDefaults,KeyCompilerCPU,CPUtoString(CompilerCPU)));
     FCompilerVersion:=ReadString(SDefaults,KeyCompilerVersion,FCompilerVersion);
     FFPMakeCompiler:=ReadString(SDefaults,KeyFPMakeCompiler,FFPMakeCompiler);
     FFPMakeUnitDir:=FixPath(ReadString(SDefaults,KeyFPMakeUnitDir,FFPMakeUnitDir));
   end;
end;


procedure TPackagerOptions.SaveCompilerToIni(Ini: TCustomIniFile);
begin
 With Ini do
   begin
     WriteString(SDefaults,KeyInstallDir,FInstallDir);
     WriteString(SDefaults,KeyCompiler,FCompiler);
     WriteString(SDefaults,KeyCompilerOS,OSToString(CompilerOS));
     WriteString(SDefaults,KeyCompilerCPU,CPUtoString(CompilerCPU));
     WriteString(SDefaults,KeyCompilerVersion,FCompilerVersion);
     WriteString(SDefaults,KeyFPMakeCompiler,FFPMakeCompiler);
     WriteString(SDefaults,KeyFPMakeUnitDir,FFPMakeUnitDir);
   end;
end;


procedure TPackagerOptions.LoadCompilerFromFile(FileName: String);
Var
  Ini : TMemIniFile;
begin
  Ini:=TMemIniFile.Create(FileName);
  try
    LoadCompilerFromIni(Ini);
  finally
    Ini.Free;
  end;
end;


procedure TPackagerOptions.SaveCompilerToFile(FileName: String);
Var
  Ini : TIniFile;
begin
  Ini:=TIniFile.Create(FileName);
  try
    SaveCompilerToIni(Ini);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;


initialization
  Options:=TPackagerOptions.Create;
finalization
  FreeAndNil(Options);
end.
