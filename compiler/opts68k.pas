{
    $Id$
    Copyright (c) 1998-2000 by Florian Klaempfl, Pierre Muller

    interprets the commandline options which are m68k specific

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
    }

unit opts68k;
interface

uses
  options;

type
  poption68k=^toption68k;
  toption68k=object(toption)
    procedure interpret_proc_specific_options(const opt:string);virtual;
  end;

implementation

uses
  globtype,systems,globals;

procedure toption68k.interpret_proc_specific_options(const opt:string);
var
  j : longint;
  More : string;
begin
  More:=Upper(copy(opt,3,length(opt)-2));
  case opt[2] of
   'O' : begin
           for j:=3 to length(opt) do
            case opt[j] of
             '-' : initglobalswitches:=initglobalswitches-[cs_optimize,cs_regalloc,cs_littlesize];
             'a' : initglobalswitches:=initglobalswitches+[cs_optimize];
             'g' : initglobalswitches:=initglobalswitches+[cs_littlesize];
             'G' : initglobalswitches:=initglobalswitches-[cs_littlesize];
             'x' : initglobalswitches:=initglobalswitches+[cs_optimize,cs_regalloc];
             '2' : initoptprocessor:=MC68020;
             else
              IllegalPara(opt);
             end;
         end;
   'R' : begin
           if More='MOT' then
            initasmmode:=asmmode_m68k_mot
           else
            IllegalPara(opt);
         end;

  else
    IllegalPara(opt);
  end;
end;

end.
{
  $Log$
  Revision 1.2  2000-07-13 11:32:44  michael
  + removed logs

}
