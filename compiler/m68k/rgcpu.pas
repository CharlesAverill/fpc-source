{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    This unit implements the register allocator for m68k

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

{$i fpcdefs.inc}
unit rgcpu;

{$i fpcdefs.inc}

  interface

     uses
       aasmbase,aasmtai,
       cpubase,
       rgobj;

     type
       trgcpu = class(trgobj)
          unusedregsaddr,usableregsaddr : tregisterset;
          countunusedregsaddr,
          countusableregsaddr : byte;
          function isaddressregister(reg: tregister): boolean; override;
          function getaddressregister(list: taasmoutput): tregister; override;
          procedure ungetaddressregister(list: taasmoutput; r: tregister); override;
          procedure resetusableregisters;override;
          procedure restoreusedregisters(list : taasmoutput;
             const saved : tpushedsaved);override;
          procedure saveusedregisters(list: taasmoutput;
        var saved : tpushedsaved; const s: tregisterset);override;
             
       end;

  implementation

    uses
      cgobj;

     procedure trgcpu.ungetaddressregister(list: taasmoutput; r: tregister);
       begin
         ungetregistergen(list,r,usableregsaddr,unusedregsaddr,
           countunusedregsaddr);
       end;
       
       
     function trgcpu.getaddressregister(list: taasmoutput): tregister; 
       begin
         result := getregistergen(list,firstsaveaddrreg,lastsaveaddrreg,
                   unusedregsaddr,countunusedregsaddr);
       end;
       

     function trgcpu.isaddressregister(reg: tregister): boolean;
       begin
         isaddressregister := reg in addrregs;
       end;
       
       
    procedure trgobj.resetusableregisters;

      begin
        inherited resetusableregisters;
        { initialize fields with constant values from cpubase }
        countusableregsaddr := cpubase.c_countusableregsaddr;
        usableregsaddr := cpubase.usableregsaddr;
      end;
       
       
    procedure trgobj.restoreusedregisters(list : taasmoutput;
        const saved : tpushedsaved);
      var
         r : tregister;
         hr : treference;
     begin
        inherited restoreusedregister(list, saved, s);

        for r:=lastsaveaddrreg downto firstsaveaddrreg do
          begin
            if saved[r].ofs <> reg_not_saved then
              begin
                reference_reset_base(hr,FRAME_POINTER_REG,saved[r].ofs);
                cg.a_reg_alloc(list,r);
                cg.a_load_ref_reg(list,OS_ADDR,hr,r);
                if not (r in unusedregsaddr) then
                  { internalerror(10)
                    in n386cal we always save/restore the reg *state*
                    using save/restoreunusedstate -> the current state
                    may not be real (JM) }
                else
                  begin
                    dec(countunusedregsint);
                    exclude(unusedregsint,r);
                  end;
                tg.ungetpersistanttemp(list,hr.offset);
              end;
        
     end;


     procedure trgobj.saveusedregisters(list: taasmoutput;
        var saved : tpushedsaved; const s: tregisterset);
      var
         r : tregister;
         hr : treference;
      begin
        inherited saveusedregisters(list, saved, s);
        for r:=firstsaveaddrreg to lastsaveaddrreg do
          begin
            saved[r].ofs:=reg_not_saved;
            { if the register is used by the calling subroutine and if }
            { it's not a regvar (those are handled separately)         }
            if not is_reg_var[r] and
               (r in s) and
               { and is present in use }
               not(r in unusedregsaddr) then
              begin
                { then save it }
                tg.gettempofsizereferencepersistant(list,pointer_size,hr);
                saved[r].ofs:=hr.offset;
                cg.a_load_reg_ref(list,OS_ADDR,r,hr);
                cg.a_reg_dealloc(list,r);
                include(unusedregsint,r);
                inc(countunusedregsint);
              end;
          end;
        
      end;
         

initialization
  rg := trgcpu.create;
end.

{
  $Log$
  Revision 1.1  2002-08-05 17:26:09  carl
    + updated m68k

}
