{
    $Id$
    Copyright (c) 1998 by Florian Klaempfl

    This unit implements an uniform export object

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
unit export;

interface

uses
  cobjects,symtable;

type
   pexported_procedure = ^texported_procedure;
   texported_procedure = object(tlinkedlist_item)
      sym : psym;
      index : longint;
      name : pstring;
      options : word;
      constructor init;
      destructor done;virtual;
   end;

   pexportlib=^texportlib;
   texportlib=object
      constructor Init;
      destructor Done;
      procedure preparelib(const s : string);virtual;
      procedure exportprocedure(hp : pexported_procedure);virtual;
      procedure generatelib;virtual;
   end;

var
   exportlib : pexportlib;

procedure InitExport;
procedure DoneExport;

implementation

uses
  systems,verbose,globals,files
{$ifdef i386}
  ,os2_targ
  ,win_targ
{$endif}
  ,lin_targ
  ;

{****************************************************************************
                           TImported_procedure
****************************************************************************}

constructor texported_procedure.init;
begin
  inherited init;
  sym:=nil;
  index:=-1;
  name:=nil;
  options:=0;
end;


destructor texported_procedure.done;
begin
  stringdispose(name);
  inherited done;
end;


{****************************************************************************
                              TImportLib
****************************************************************************}

constructor texportlib.Init;
begin
end;


destructor texportlib.Done;
begin
end;


procedure texportlib.preparelib(const s:string);
begin
  Message(exec_e_dll_not_supported);
end;


procedure texportlib.exportprocedure(hp : pexported_procedure);
begin
    current_module^._exports^.concat(hp);
end;


procedure texportlib.generatelib;
begin
  Message(exec_e_dll_not_supported);
end;


procedure DoneExport;
begin
  if assigned(exportlib) then
    dispose(exportlib,done);
end;


procedure InitExport;
begin
  case target_info.target of
{$ifdef i386}
{    target_i386_Linux :
      importlib:=new(pimportliblinux,Init);
}
    target_i386_Win32 :
      exportlib:=new(pexportlibwin32,Init);
{
    target_i386_OS2 :
      exportlib:=new(pexportlibos2,Init);
}
{$endif i386}
{$ifdef m68k}
    target_m68k_Linux :
      exportlib:=new(pexportlib,Init);
{$endif m68k}
    else
      exportlib:=new(pexportlib,Init);
  end;
end;


end.
{
  $Log$
  Revision 1.3  1998-11-16 11:28:57  pierre
    * stackcheck removed for i386_win32
    * exportlist does not crash at least !!
      (was need for tests dir !)z

  Revision 1.2  1998/10/29 11:35:43  florian
    * some dll support for win32
    * fixed assembler writing for PalmOS

  Revision 1.1  1998/10/27 10:22:34  florian
    + First things for win32 export sections

}