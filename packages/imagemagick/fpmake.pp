{$ifndef ALLPACKAGES}
{$mode objfpc}{$H+}
program fpmake;

uses {$ifdef unix}cthreads,{$endif} fpmkunit;

Var
  P : TPackage;
  T : TTarget;
begin
  With Installer do
    begin
{$endif ALLPACKAGES}

    P:=AddPackage('imagemagick');
    P.ShortName := 'imgm';
{$ifdef ALLPACKAGES}
    P.Directory:=ADirectory;
{$endif ALLPACKAGES}
    P.Version:='3.3.1';

    P.Author := 'Library: ImageMagick Studio LLC , header: Felipe Monteiro de Carvalho';
    P.License := 'Library: Imagemagick license, header: LGPL with modification, ';
    P.HomepageURL := 'www.freepascal.org';
    P.Email := '';
    P.Description := 'Header to Imagemagick, a graphics manipulation program .';
    P.NeedLibC:= true;  // true for headers that indirectly link to libc?
    P.OSes := AllUnixOSes+[win32,win64]-[qnx];
    if Defaults.CPU=jvm then
      P.OSes := P.OSes - [java,android];

    P.SourcePath.Add('src');
    P.IncludePath.Add('src');

    T:=P.Targets.AddUnit('buildim.pp');
      with T.Dependencies do
        begin
          AddUnit('imagemagick');
          AddUnit('magick_wand');
        end;
    T.Install := False;
    T:=P.Targets.AddUnit('imagemagick.pas');
      with T.Dependencies do
        begin
          AddInclude('magick_type.inc');
          AddInclude('type.inc');
          AddInclude('cache_view.inc');
          AddInclude('cache.inc');
          AddInclude('compare.inc');
          AddInclude('constitute.inc');
          AddInclude('draw.inc');
          AddInclude('effect.inc');
          AddInclude('fx.inc');
          AddInclude('pixel.inc');
          AddInclude('quantize.inc');
          AddInclude('statistic.inc');
        end;
    T:=P.Targets.AddUnit('magick_wand.pas');
      with T.Dependencies do
        begin
          AddInclude('pixel_wand.inc');
          AddInclude('drawing_wand.inc');
          AddInclude('magick_attribute.inc');
          AddInclude('magick_image.inc');
          AddInclude('pixel_iterator.inc');
          AddUnit('imagemagick');
        end;

    P.ExamplePath.Add('examples');
    P.Targets.AddExampleProgram('screenshot.lpr');
    P.Targets.AddExampleProgram('wanddemo.lpr');
    P.Targets.AddExampleProgram('wanddemo.dpr');
    // 'image.png


    P.NamespaceMap:='namespaces.lst';

    {$ifndef ALLPACKAGES}
        Run;
        end;
    end.
    {$endif ALLPACKAGES}
