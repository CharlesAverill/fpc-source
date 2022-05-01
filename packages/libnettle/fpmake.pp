{$ifndef ALLPACKAGES}
{$mode objfpc}{$H+}
program fpmake;

uses fpmkunit;

Var
  T : TTarget;
  P : TPackage;
begin
  With Installer do
    begin
{$endif ALLPACKAGES}

    P:=AddPackage('libnettle');
{$ifdef ALLPACKAGES}
    P.Directory:=ADirectory;
{$endif ALLPACKAGES}
    P.Version:='3.3.1';

    P.Dependencies.Add('gmp');

    P.Author := 'FreePascal development team';
    P.License := 'LGPL with modification, ';
    P.HomepageURL := 'www.freepascal.org';
    P.Email := '';
    P.Description := 'LibNettle is the interface to GNU nettle, a C library that implements gryptography';
    P.NeedLibC:= false;
    P.OSes := [freebsd,darwin,iphonesim,ios,linux,win32,aix];

    P.SourcePath.Add('src');

    T:=P.Targets.AddUnit('libnettle.pp');

    P.Sources.AddExampleFiles('examples/*.lpr',P.Directory,false,'.');

{$ifndef ALLPACKAGES}
    Run;
    end;
end.
{$endif ALLPACKAGES}
