{
    $Id$
    Copyright (c) 1998 by Peter Vreman

    This unit handles the writing of script files

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

 ****************************************************************************
}
unit Script;
interface

uses
  CObjects;

type
  PScript=^TScript;
  TScript=object
    fn   : string[80];
    data : TStringQueue;
    constructor Init(const s:string);
    destructor Done;
    procedure AddStart(const s:string);
    procedure Add(const s:string);
    Function  Empty:boolean;
    procedure WriteToDisk;virtual;
  end;

  TAsmScript = Object (TScript)
    Constructor Init (Const ScriptName : String);
    Procedure AddAsmCommand (Const Command, Options,FileName : String);
    Procedure AddLinkCommand (Const Command, Options, FileName : String);
    Procedure AddDeleteCommand (Const FileName : String);
    Procedure WriteToDisk;virtual;
    end;
  PAsmScript = ^TAsmScript;

{ Asm response file }
var
  AsmRes : TAsmScript;


implementation

uses
{$ifdef linux}
  linux,
{$endif}
  globals,systems;


{****************************************************************************
                                  TScript
****************************************************************************}

constructor TScript.Init(const s:string);
begin
  fn:=FixFileName(s)+source_os.scriptext;
  data.Init;
end;


destructor TScript.Done;
begin
  data.done;
end;


procedure TScript.AddStart(const s:string);
begin
  data.Insert(s);
end;


procedure TScript.Add(const s:string);
begin
  data.Concat(s);
end;


Function TScript.Empty:boolean;
begin
  Empty:=Data.Empty;
end;


procedure TScript.WriteToDisk;
var
  t : Text;
begin
  Assign(t,fn);
  Rewrite(t);
  while not data.Empty do
   Writeln(t,data.Get);
  Close(t);
{$ifdef linux}
  ChMod(fn,493);
{$endif}
end;


{****************************************************************************
                                  Asm Response
****************************************************************************}

Constructor TAsmScript.Init (Const ScriptName : String);
begin
  Inherited Init(ScriptName);
end;


Procedure TAsmScript.AddAsmCommand (Const Command, Options,FileName : String);
begin
  {$ifdef linux}
  if FileName<>'' then
   Add('echo Assembling '+FileName);
  Add (Command+' '+Options);
  Add('if [ $? != 0 ]; then DoExitAsm '+FileName+'; fi');
  {$else}
  if FileName<>'' then
   begin
     Add('SET THEFILE='+FileName);
     Add('echo Assembling %THEFILE%');
   end;
  Add(command+' '+Options);
  Add('if errorlevel 1 goto asmend');
  {$endif}
end;


Procedure TasmScript.AddLinkCommand (Const Command, Options, FileName : String);
begin
  {$ifdef linux}
  if FileName<>'' then
   Add('echo Linking '+FileName);
  Add (Command+' '+Options);
  Add('if [ $? != 0 ]; then DoExitLink '+FileName+'; fi');
  {$else}
  if FileName<>'' then
   begin
     Add('SET THEFILE='+FileName);
     Add('echo Linking %THEFILE%');
   end;
  Add (Command+' '+Options);
  Add('if errorlevel 1 goto linkend');
  {$endif}
end;


Procedure TAsmScript.AddDeleteCommand (Const FileName : String);
begin
 {$ifdef linux}
 Add('rm '+FileName);
 {$else}
 Add('Del '+FileName);
 {$endif}
end;


Procedure TAsmScript.WriteToDisk;
Begin
{$ifdef linux}
  AddStart('{ echo "An error occurred while linking $1"; exit 1; }');
  AddStart('DoExitLink ()');
  AddStart('{ echo "An error occurred while assembling $1"; exit 1; }');
  AddStart('DoExitAsm ()');
  AddStart('#!/bin/bash');
{$else}
  AddStart('@echo off');
  Add('goto end');
  Add(':asmend');
  Add('echo An error occured while assembling %THEFILE%');
  Add('goto end');
  Add(':linkend');
  Add('echo An error occured while linking %THEFILE%');
  Add(':end');
{$endif}
  TScript.WriteToDisk;
end;


end.
{
  $Log$
  Revision 1.2  1998-05-04 17:54:29  peter
    + smartlinking works (only case jumptable left todo)
    * redesign of systems.pas to support assemblers and linkers
    + Unitname is now also in the PPU-file, increased version to 14

}
