{
    $Id$
    Copyright (C) 1998-2000 by Florian Klaempfl

    This unit handles the temporary variables stuff for PowerPC

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
unit tgcpu;

  interface

    uses
       globals,
       cgbase,verbose,aasm,
       node,
       cpuinfo,cpubase,cpuasm;

    const
       { this value is used in tsaved, if the register isn't saved }
       reg_not_saved = $7fffffff;

    type
       tpushed = array[R_NO..R_NO] of boolean;
       tsaved = array[R_NO..R_NO] of longint;

    var
       { tries to hold the amount of times which the current tree is processed  }
       t_times : longint;

    function getregisterint : tregister;
    procedure ungetregisterint(r : tregister);
    { tries to allocate the passed register, if possible }
    function getexplicitregisterint(r : tregister) : tregister;

    procedure ungetregister(r : tregister);

    procedure cleartempgen;
    procedure del_reference(const ref : treference);
    procedure del_locref(const location : tlocation);
    procedure del_location(const l : tlocation);

    { pushs and restores registers }
    procedure pushusedregisters(var pushed : tpushed;b : byte);
    procedure popusedregisters(const pushed : tpushed);

    { saves and restores used registers to temp. values }
    procedure saveusedregisters(var saved : tsaved;b : byte);
    procedure restoreusedregisters(const saved : tsaved);

    { increments the push count of all registers in b}
    procedure incrementregisterpushed(regs : tregisterset);

    procedure clearregistercount;
    procedure resetusableregisters;

    type
       regvar_longintarray = array[0..32+32-1] of longint;
       regvar_booleanarray = array[0..32+32-1] of boolean;
       regvar_ptreearray = array[0..32+32-1] of tnode;

    var
       unused,usableregs : tregisterset;

       { uses only 1 byte while a set uses in FPC 32 bytes }
       usedinproc : byte;

       { count, how much a register must be pushed if it is used as register }
       { variable                                                           }
       reg_pushes : regvar_longintarray;
       is_reg_var : regvar_booleanarray;


implementation

    uses
      globtype,temp_gen;


    function getregisterint : tregister;
      begin
      end;

    procedure ungetregisterint(r : tregister);
      begin
      end;

    { tries to allocate the passed register, if possible }
    function getexplicitregisterint(r : tregister) : tregister;
      begin
      end;

    procedure ungetregister(r : tregister);
      begin
      end;

    procedure cleartempgen;
      begin
      end;

    procedure del_reference(const ref : treference);
      begin
      end;

    procedure del_locref(const location : tlocation);
      begin
      end;

    procedure del_location(const l : tlocation);
      begin
      end;

    { pushs and restores registers }
    procedure pushusedregisters(var pushed : tpushed;b : byte);
      begin
      end;

    procedure popusedregisters(const pushed : tpushed);
      begin
      end;

    { saves and restores used registers to temp. values }
    procedure saveusedregisters(var saved : tsaved;b : byte);
      begin
      end;

    procedure restoreusedregisters(const saved : tsaved);
      begin
      end;

    { increments the push count of all registers in b}
    procedure incrementregisterpushed(regs : tregisterset);
      begin
      end;

    procedure clearregistercount;
      begin
      end;

    procedure resetusableregisters;
      begin
      end;

begin
   resetusableregisters;
end.
{
  $Log$
  Revision 1.2  2001-08-26 13:23:23  florian
    * some cg reorganisation
    * some PPC updates

  Revision 1.1  2000/07/13 06:30:13  michael
    + Initial import

  Revision 1.3  2000/01/07 01:14:58  peter
    * updated copyright to 2000

  Revision 1.2  1999/08/04 12:59:26  jonas
    * all tokes now start with an underscore
    * PowerPC compiles!!

  Revision 1.1  1999/08/03 23:37:53  jonas
    + initial implementation for PowerPC based on the Alpha stuff
}
