{
    $Id$
    Copyright (c) 1998-2000 by Peter Vreman

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

{$i defines.inc}

interface

uses
  cclasses;

type
  TScript=class
    fn   : string[80];
    data : TStringList;
    executable : boolean;
    constructor Create(const s:string);
    constructor CreateExec(const s:string);
    destructor Destroy;override;
    procedure AddStart(const s:string);
    procedure Add(const s:string);
    Function  Empty:boolean;
    procedure WriteToDisk;virtual;
  end;

  TAsmScript = class (TScript)
    Constructor Create(Const ScriptName : String); virtual;
    Procedure AddAsmCommand (Const Command, Options,FileName : String);virtual;abstract;
    Procedure AddLinkCommand (Const Command, Options, FileName : String);virtual;abstract;
    Procedure AddDeleteCommand (Const FileName : String);virtual;abstract;
    Procedure AddDeleteDirCommand (Const FileName : String);virtual;abstract;
  end;

  TAsmScriptDos = class (TAsmScript)
    Constructor Create (Const ScriptName : String); override;
    Procedure AddAsmCommand (Const Command, Options,FileName : String);override;
    Procedure AddLinkCommand (Const Command, Options, FileName : String);override;
    Procedure AddDeleteCommand (Const FileName : String);override;
    Procedure AddDeleteDirCommand (Const FileName : String);override;
    Procedure WriteToDisk;override;
  end;

  TAsmScriptAmiga = class (TAsmScript)
    Constructor Create (Const ScriptName : String); override;
    Procedure AddAsmCommand (Const Command, Options,FileName : String);override;
    Procedure AddLinkCommand (Const Command, Options, FileName : String);override;
    Procedure AddDeleteCommand (Const FileName : String);override;
    Procedure AddDeleteDirCommand (Const FileName : String);override;
    Procedure WriteToDisk;override;
  end;

  TAsmScriptUnix = class (TAsmScript)
    Constructor Create (Const ScriptName : String);override;
    Procedure AddAsmCommand (Const Command, Options,FileName : String);override;
    Procedure AddLinkCommand (Const Command, Options, FileName : String);override;
    Procedure AddDeleteCommand (Const FileName : String);override;
    Procedure AddDeleteDirCommand (Const FileName : String);override;
    Procedure WriteToDisk;override;
  end;

  TLinkRes = Class (TScript)
    procedure Add(const s:string);
    procedure AddFileName(const s:string);
  end;

var
  AsmRes : TAsmScript;

Procedure GenerateAsmRes(const st : string);


implementation

uses
{$ifdef Unix}
  {$ifdef ver1_0}
    Linux,
  {$else}
    Unix,
  {$endif}
{$endif}
  globals,systems;


{****************************************************************************
                                  TScript
****************************************************************************}

constructor TScript.Create(const s:string);
begin
  fn:=FixFileName(s);
  executable:=false;
  data:=TStringList.Create;
end;


constructor TScript.CreateExec(const s:string);
begin
  fn:=FixFileName(s)+target_info.scriptext;
  executable:=true;
  data:=TStringList.Create;
end;


destructor TScript.Destroy;
begin
  data.Free;
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
   Writeln(t,data.GetFirst);
  Close(t);
{$ifdef Unix}
  if executable then
   ChMod(fn,493);
{$endif}
end;


{****************************************************************************
                                  Asm Response
****************************************************************************}

Constructor TAsmScript.Create (Const ScriptName : String);
begin
  Inherited CreateExec(ScriptName);
end;


{****************************************************************************
                                  Asm Response
****************************************************************************}

Constructor TAsmScriptDos.Create (Const ScriptName : String);
begin
  Inherited Create(ScriptName);
end;


Procedure TAsmScriptDos.AddAsmCommand (Const Command, Options,FileName : String);
begin
  if FileName<>'' then
   begin
     Add('SET THEFILE='+FileName);
     Add('echo Assembling %THEFILE%');
   end;
  Add(command+' '+Options);
  Add('if errorlevel 1 goto asmend');
end;


Procedure TAsmScriptDos.AddLinkCommand (Const Command, Options, FileName : String);
begin
  if FileName<>'' then
   begin
     Add('SET THEFILE='+FileName);
     Add('echo Linking %THEFILE%');
   end;
  Add (Command+' '+Options);
  Add('if errorlevel 1 goto linkend');
end;


Procedure TAsmScriptDos.AddDeleteCommand (Const FileName : String);
begin
 Add('Del '+FileName);
end;


Procedure TAsmScriptDos.AddDeleteDirCommand (Const FileName : String);
begin
 Add('Rmdir '+FileName);
end;


Procedure TAsmScriptDos.WriteToDisk;
Begin
  AddStart('@echo off');
  Add('goto end');
  Add(':asmend');
  Add('echo An error occured while assembling %THEFILE%');
  Add('goto end');
  Add(':linkend');
  Add('echo An error occured while linking %THEFILE%');
  Add(':end');
  inherited WriteToDisk;
end;

{****************************************************************************
                                  Amiga Asm Response
****************************************************************************}

Constructor TAsmScriptAmiga.Create (Const ScriptName : String);
begin
  Inherited Create(ScriptName);
end;


Procedure TAsmScriptAmiga.AddAsmCommand (Const Command, Options,FileName : String);
begin
  if FileName<>'' then
   begin
     Add('SET THEFILE '+FileName);
     Add('echo Assembling $THEFILE');
   end;
  Add(command+' '+Options);
  Add('if error');
  Add('skip asmend');
  Add('endif');
end;


Procedure TAsmScriptAmiga.AddLinkCommand (Const Command, Options, FileName : String);
begin
  if FileName<>'' then
   begin
     Add('SET THEFILE '+FileName);
     Add('echo Linking $THEFILE');
   end;
  Add (Command+' '+Options);
  Add('if error');
  Add('skip linkend');
  Add('endif');
end;


Procedure TAsmScriptAmiga.AddDeleteCommand (Const FileName : String);
begin
 Add('Delete '+FileName);
end;


Procedure TAsmScriptAmiga.AddDeleteDirCommand (Const FileName : String);
begin
 Add('Delete '+FileName);
end;


Procedure TAsmScriptAmiga.WriteToDisk;
Begin
  Add('skip end');
  Add('lab asmend');
  Add('echo An error occured while assembling $THEFILE');
  Add('skip end');
  Add('lab linkend');
  Add('echo An error occured while linking $THEFILE');
  Add('lab end');
  inherited WriteToDisk;
end;


{****************************************************************************
                              Unix Asm Response
****************************************************************************}

Constructor TAsmScriptUnix.Create (Const ScriptName : String);
begin
  Inherited Create(ScriptName);
end;


Procedure TAsmScriptUnix.AddAsmCommand (Const Command, Options,FileName : String);
begin
  if FileName<>'' then
   Add('echo Assembling '+FileName);
  Add (Command+' '+Options);
  Add('if [ $? != 0 ]; then DoExitAsm '+FileName+'; fi');
end;


Procedure TAsmScriptUnix.AddLinkCommand (Const Command, Options, FileName : String);
begin
  if FileName<>'' then
   Add('echo Linking '+FileName);
  Add (Command+' '+Options);
  Add('if [ $? != 0 ]; then DoExitLink '+FileName+'; fi');
end;


Procedure TAsmScriptUnix.AddDeleteCommand (Const FileName : String);
begin
 Add('rm '+FileName);
end;


Procedure TAsmScriptUnix.AddDeleteDirCommand (Const FileName : String);
begin
 Add('rmdir '+FileName);
end;


Procedure TAsmScriptUnix.WriteToDisk;
Begin
  AddStart('{ echo "An error occurred while linking $1"; exit 1; }');
  AddStart('DoExitLink ()');
  AddStart('{ echo "An error occurred while assembling $1"; exit 1; }');
  AddStart('DoExitAsm ()');
  AddStart('#!/bin/sh');
  inherited WriteToDisk;
end;


Procedure GenerateAsmRes(const st : string);
begin
  case target_info.script of
    script_unix :
      AsmRes:=TAsmScriptUnix.Create(st);
    script_dos :
      AsmRes:=TAsmScriptDos.Create(st);
    script_amiga :
      AsmRes:=TAsmScriptAmiga.Create(st);
  end;
end;


{****************************************************************************
                                  Link Response
****************************************************************************}

procedure TLinkRes.Add(const s:string);
begin
  if s<>'' then
   inherited Add(s);
end;

procedure TLinkRes.AddFileName(const s:string);
begin
  if s<>'' then
   begin
     if not(s[1] in ['a'..'z','A'..'Z','/','\','.']) then
      inherited Add('.'+DirSep+s)
     else
      inherited Add(s);
   end;
end;

end.
{
  $Log$
  Revision 1.12  2001-08-07 18:44:09  peter
    * made script target indepedent

  Revision 1.11  2001/07/30 20:59:27  peter
    * m68k updates from v10 merged

  Revision 1.10  2001/07/10 21:01:35  peter
    * fixed crash with writing of the linker script

  Revision 1.9  2001/04/18 22:01:58  peter
    * registration of targets and assemblers

  Revision 1.8  2001/04/13 01:22:14  peter
    * symtable change to classes
    * range check generation and errors fixed, make cycle DEBUG=1 works
    * memory leaks fixed

  Revision 1.7  2001/02/05 20:47:00  peter
    * support linux unit for ver1_0 compilers

  Revision 1.6  2001/01/21 20:32:45  marco
   * Renamefest. Compiler part. Not that hard.

  Revision 1.5  2000/12/25 00:07:29  peter
    + new tlinkedlist class (merge of old tstringqueue,tcontainer and
      tlinkedlist objects)

  Revision 1.4  2000/11/13 15:43:07  marco
   * Renamefest

  Revision 1.3  2000/09/24 15:06:28  peter
    * use defines.inc

  Revision 1.2  2000/07/13 11:32:49  michael
  + removed logs

}
