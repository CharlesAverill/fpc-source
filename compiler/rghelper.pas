{*****************************************************************************}
{
    $Id$
    This file is part of the Free Pascal's "Free Components Library".
    Copyright (c) 2003 by Mazen NEIFER of the Free Pascal development team

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
{*****************************************************************************}
unit rgHelper;

{$i fpcdefs.inc}

interface

    uses
      cpuBase,cgBase;

    type
      TRegNameTable = array[tregisterindex] of string[7];
      TRegisterIndexTable = array[tregisterindex] of tregisterindex;

    function findreg_by_number(r:Tregister;const regnumber_index:TRegisterIndexTable):tregisterindex;
    function findreg_by_name(const s:string;const regname_table:TRegNameTable;const regname_index:TRegisterIndexTable):byte;

implementation

    function findreg_by_name(const s:string;const regname_table:TRegNameTable;const regname_index:TRegisterIndexTable):byte;
      var
        i,p,q : tregisterindex;
      begin
        p:=Low(tregisterindex);
        q:=high(tregisterindex);
        repeat
          i:=(p+q)shr 1;
          if regname_table[regname_index[i]]<=s then
            p:=i+1
          else
            q:=i;
        until i=0;
        if regname_table[regname_index[p]]=s then
          result:=regname_index[p]
        else
          result:=0;
      end;


    function findreg_by_number(r:Tregister;const regnumber_index:TRegisterIndexTable):tregisterindex;
      var
        i,p,q : tregisterindex;
      begin
        p:=Low(tregisterindex);
        q:=high(tregisterindex);
        repeat
          i:=(p+q)shr 1;
          if r>regnumber_table[regnumber_index[i]] then
            p:=i+1
          else
            q:=i;
        until p=q;
        if regnumber_table[regnumber_index[p]]=r then
          result:=regnumber_index[p]
        else
          result:=0;
      end;
end.
