{
    $Id$
    Copyright (c) 1999 by Peter Vreman

    List files needed by PPU

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

 ****************************************************************************}
Program ppufiles;

{$ifndef TP}
  {$H+}
{$endif}

uses
  dos,
  ppu;

const
  Version   = 'Version 0.99.13';
  Title     = 'PPU-Files';
  Copyright = 'Copyright (c) 1999 by the Free Pascal Development Team';

  PPUExt = 'ppu';

var
  skipdup,
  showstatic,
  showshared,
  showobjects : boolean;

  OutFiles    : String;


{*****************************************************************************
                                 Helpers
*****************************************************************************}

Procedure Error(const s:string;stop:boolean);
{
  Write an error message to stderr
}
begin
{$ifdef FPC}
  writeln(stderr,s);
{$else}
  writeln(s);
{$endif}
  if stop then
   halt(1);
end;


Function AddExtension(Const HStr,ext:String):String;
{
  Return a filename which will have extension ext added if no
  extension is found
}
var
  j : longint;
begin
  j:=length(Hstr);
  while (j>0) and (Hstr[j]<>'.') do
   dec(j);
  if j=0 then
   AddExtension:=Hstr+'.'+Ext
  else
   AddExtension:=HStr;
end;


const
{$IFDEF LINUX}
  PathCh='/';
{$ELSE}
  PathCh='\';
{$ENDIF}

Function SplitPath(Const HStr:String):String;
var
  i : byte;
begin
  i:=Length(Hstr);
  while (i>0) and (Hstr[i]<>PathCh) do
   dec(i);
  SplitPath:=Copy(Hstr,1,i);
end;


Procedure AddFile(const s:string);
begin
  if skipdup then
   begin
     if pos(' '+s,OutFiles)=0 then
      OutFiles:=OutFiles+' '+s;
   end
  else
   OutFiles:=OutFiles+' '+s;
end;


Function DoPPU(const PPUFn:String):Boolean;
{
  Convert one file (in Filename) to library format.
  Return true if successful, false otherwise.
}
Var
  inppu  : pppufile;
  b      : byte;

  procedure showfiles;
  begin
    while not inppu^.endofentry do
     begin
       AddFile(inppu^.getstring);
       inppu^.getlongint;
     end;
  end;

begin
  DoPPU:=false;
  inppu:=new(pppufile,init(PPUFn));
  if not inppu^.open then
   begin
     dispose(inppu,done);
     Error('Error: Could not open : '+PPUFn,false);
     Exit;
   end;
{ Check the ppufile }
  if not inppu^.CheckPPUId then
   begin
     dispose(inppu,done);
     Error('Error: Not a PPU File : '+PPUFn,false);
     Exit;
   end;
  if inppu^.GetPPUVersion<CurrentPPUVersion then
   begin
     dispose(inppu,done);
     Error('Error: Wrong PPU Version : '+PPUFn,false);
     Exit;
   end;
{ read until the object files are found }
  repeat
    b:=inppu^.readentry;
    case b of
      ibendinterface,
      ibend :
        break;
      iblinkunitstaticlibs :
        if showstatic then
         showfiles;
      iblinkunitsharedlibs :
        if showshared then
         showfiles;
      iblinkunitofiles :
        if showobjects then
         showfiles;
    end;
  until false;
  dispose(inppu,done);
  DoPPU:=True;
end;



var
  i,parafile : longint;
  dir        : SearchRec;
  s,InFile   : String;
begin
{ defaults }
  skipdup:=true;
{ options }
  i:=1;
  while (i<=paramcount) do
   begin
     s:=paramstr(i);
     if s[1]<>'-' then
      break;
     case upcase(s[2]) of
      'L' : showshared:=true;
      'S' : showstatic:=true;
      'O' : showobjects:=true;
      'A' : skipdup:=false;
      '?','H' :
        begin
          writeln('usage: ppufiles [options] <files>');
          writeln('options:');
          writeln('  -A  Show all files (don''t remove duplicates)');
          writeln('  -L  Show only shared libraries');
          writeln('  -S  Show only static libraries');
          writeln('  -O  Show only object files');
          writeln('  -H  This helpscreen');
        end;
     end;
     inc(i);
   end;
  { default shows everything }
  if i=1 then
   begin
     showshared:=true;
     showstatic:=true;
     showobjects:=true;
   end;
{ files }
  parafile:=i;
  for i:=parafile to ParamCount do
   begin
     InFile:=AddExtension(ParamStr(i),PPUExt);
     FindFirst(InFile,$20,Dir);
     while (DosError=0) do
      begin
        DoPPU(SplitPath(InFile)+Dir.Name);
        FindNext(Dir);
      end;
     FindClose(Dir);
   end;
{ Display the files }
  if (OutFiles<>'') and (OutFiles[1]=' ') then
   Delete(OutFiles,1,1);
  Write(OutFiles);
end.
{
  $Log$
  Revision 1.1  1999-11-23 09:44:41  peter
    * initial version

}
