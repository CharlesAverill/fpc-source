{
    $Id$
    Copyright (c) 1999-2000 by Peter Vreman

    Deletes all files generated for Pascal (*.exe,units,objects,libs)

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
program Delp;
uses
  dos,getopts;

const
  version='v1.01';

function DStr(l:longint):string;
var
  TmpStr : string[32];
  i : byte;
begin
  Str(l,tmpstr);
  i:=Length(TmpStr);
  while (i>3) do
   begin
     i:=i-3;
     if TmpStr[i]<>'-' then
      Insert('.',TmpStr,i+1);
   end;
  DStr:=TmpStr;
end;


Procedure EraseFile(Const HStr:String);
var
  f : file;
begin
  Assign(f,Hstr);
  {$I-}
   Erase(f);
  {$I+}
  if ioresult<>0 then;
end;


function MatchesMask(What, Mask: string): boolean;

  function upper(const s : string) : string;
  var
    i  : longint;
  begin
     for i:=1 to length(s) do
      if s[i] in ['a'..'z'] then
       upper[i]:=char(byte(s[i])-32)
      else
       upper[i]:=s[i];
     upper[0]:=s[0];
  end;

  Function CmpStr(const hstr1,hstr2:string):boolean;
  var
    found : boolean;
    i1,i2 : longint;
  begin
    i1:=0;
    i2:=0;
    found:=true;
    while found and (i1<length(hstr1)) and (i2<length(hstr2)) do
     begin
       inc(i2);
       inc(i1);
       case hstr1[i1] of
         '?' :
           found:=true;
         '*' :
           begin
             found:=true;
             if (i1=length(hstr1)) then
              i2:=length(hstr2)
             else
              if (i1<length(hstr1)) and (hstr1[i1+1]<>hstr2[i2]) then
               begin
                 if i2<length(hstr2) then
                  dec(i1)
               end
             else
              if i2>1 then
               dec(i2);
           end;
         else
           found:=(hstr1[i1]=hstr2[i2]) or (hstr2[i2]='?');
       end;
     end;
    if found then
     begin
       { allow 'p*' matching 'p' }
       if (i1<length(hstr1)) and (hstr1[i1+1]='*') then
        inc(i1);
       found:=(i1>=length(hstr1)) and (i2>=length(hstr2));
     end;
    CmpStr:=found;
  end;

var
  D1,D2 : DirStr;
  N1,N2 : NameStr;
  E1,E2 : Extstr;
begin
{$ifdef linux}
  FSplit(What,D1,N1,E1);
  FSplit(Mask,D2,N2,E2);
{$else}
  FSplit(Upper(What),D1,N1,E1);
  FSplit(Upper(Mask),D2,N2,E2);
{$endif}
  MatchesMask:=CmpStr(N2,N1) and CmpStr(E2,E1);
end;

type
  PMaskItem=^TMaskItem;
  TMaskItem=record
    Mask  : string[15];
    Files : longint;
    Size  : longint;
    Next  : PMaskItem;
  end;

var
  masklist : pmaskitem;

procedure AddMask(s:string);
var
  maskitem : PMaskItem;
  i : longint;
begin
  repeat
    i:=pos(' ',s);
    if i=0 then
     i:=length(s)+1;
    New(maskitem);
    fillchar(maskitem^,sizeof(tmaskitem),0);
    maskitem^.mask:=Copy(s,1,i-1);
    maskitem^.next:=masklist;
    masklist:=maskitem;
    Delete(s,1,i);
  until s='';
end;

Var quiet: boolean;

procedure usage;

begin
  Writeln('Delp [options]');
  Writeln('Where options is one of:');
  writeln('  -e    Delete executables also (Not on linux)');
  writeln('  -h    Display (this) help message.');
  writeln('  -q    Quietly perfoms deleting.');
  Halt(1);
end;

procedure processoptions;

Var c : char;
    
begin
  quiet:=false;
  Repeat
    C:=Getopt('chq');
    Case C of 
      'e' : AddMAsk('*.exe');
      'h' : Usage;
      'q' : Quiet:=True;
      EndOfOptions : ;
    end;
  Until C=EndOfOptions;
end;


var
  Dir    : Searchrec;
  Total  : longint;
  hp     : pmaskitem;
  found  : boolean;
begin
  ProcessOptions;
  AddMask('*.ppw *.ow *.aw *.sw');
  AddMask('*.so *.dll');
  AddMask('ppas.bat ppas.sh link.res fpcmaked fpcmade fpcmade.*');
  AddMask('*.tpu *.tpp *.tpw *.tr');
  AddMask('*.log *.bak');
  AddMask('*.ppu *.o *.a *.s');
  AddMask('*.pp1 *.o1 *.a1 *.s1');
  AddMask('*.ppo *.oo *.ao *.so');
  if not quiet then
    begin
    WriteLn('DelPascal ',version,' (C) 1999 Peter Vreman');
    Writeln;
    end;
  FindFirst('*.*',$20,Dir);
  Total:=0;
  while (doserror=0) do
   begin
     hp:=masklist;
     while assigned(hp) do
      begin
        if MatchesMask(Dir.Name,hp^.mask) then
         begin
           EraseFile(Dir.Name);
           inc(hp^.Files);
           inc(hp^.Size,Dir.Size);
           break;
         end;
        hp:=hp^.next;
      end;
     FindNext(Dir);
   end;
{Write Results}
  found:=false;
  hp:=masklist;
  while assigned(hp) do
   begin
     if hp^.Files>0 then
      begin
        if not quiet then
          WriteLn(' - Removed ',hp^.Files:2,' ',hp^.Mask,' (',DStr(hp^.Size)+' Bytes)');
        inc(Total,hp^.Size);
        found:=true;
      end;
     hp:=hp^.next;
   end;
  if not quiet then
    if not found then
      WriteLn(' - No Redundant Files Found!')
    else
      WriteLn(' - Total ',DStr(Total),' Bytes Freed');
end.
{
  $Log$
  Revision 1.7  2000-01-23 14:23:48  michael
  + Typos fixed, version updated

  Revision 1.6  2000/01/23 14:20:44  michael
  + Added option to delete executables, plus help and quiet

  Revision 1.5  2000/01/12 10:40:59  peter
    * fixed bug which sometimes matched .ppw with .pp

  Revision 1.4  2000/01/07 16:46:02  daniel
    * copyright 2000

  Revision 1.3  1999/12/19 17:12:10  peter
    * added fpcmade

  Revision 1.2  1999/12/02 11:31:11  peter
    * removed temp comment

  Revision 1.1  1999/12/01 22:45:04  peter
    + delp tool which deletes all generated pascal files

}

