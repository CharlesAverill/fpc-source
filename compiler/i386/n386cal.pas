{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    Generate i386 assembler for in call nodes

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
unit n386cal;

{$i fpcdefs.inc}

interface

{ $define AnsiStrRef}

    uses
      ncgcal;

    type
       ti386callnode = class(tcgcallnode)
       protected
          function  align_parasize:longint;override;
          procedure pop_parasize(pop_size:longint);override;
          procedure extra_interrupt_code;override;
       end;


implementation

    uses
      globtype,systems,
      cutils,verbose,globals,
{$ifdef GDB}
      gdb,
{$endif GDB}
      cgbase,
      cpubase,paramgr,
      aasmtai,aasmcpu,
      ncal,nbas,nmem,nld,ncnv,
      cga,cgobj,cpuinfo;


{*****************************************************************************
                             TI386CALLNODE
*****************************************************************************}


    procedure ti386callnode.extra_interrupt_code;
      begin
        emit_none(A_PUSHF,S_L);
        emit_reg(A_PUSH,S_L,NR_CS);
      end;


    function ti386callnode.align_parasize:longint;
      var
         pop_size : longint;
{$ifdef OPTALIGN}
         pop_esp : boolean;
         push_size : longint;
{$endif OPTALIGN}
         i : integer;
      begin
        pop_size:=0;
        { This parasize aligned on 4 ? }
        i:=pushedparasize and 3;
        if i>0 then
         inc(pop_size,4-i);
        { insert the opcode and update pushedparasize }
        { never push 4 or more !! }
        pop_size:=pop_size mod 4;
        if pop_size>0 then
         begin
           inc(pushedparasize,pop_size);
           exprasmlist.concat(taicpu.op_const_reg(A_SUB,S_L,pop_size,NR_ESP));
{$ifdef GDB}
           if (cs_debuginfo in aktmoduleswitches) and
              (exprasmList.first=exprasmList.last) then
             exprasmList.concat(Tai_force_line.Create);
{$endif GDB}
         end;
{$ifdef OPTALIGN}
         if pop_allowed and (cs_align in aktglobalswitches) then
           begin
              pop_esp:=true;
              push_size:=pushedparasize;
              { !!!! here we have to take care of return type, self
                and nested procedures
              }
              inc(push_size,12);
              emit_reg_reg(A_MOV,S_L,rsp,R_EDI);
              if (push_size mod 8)=0 then
                emit_const_reg(A_AND,S_L,$fffffff8,rsp)
              else
                begin
                   emit_const_reg(A_SUB,S_L,push_size,rsp);
                   emit_const_reg(A_AND,S_L,$fffffff8,rsp);
                   emit_const_reg(A_SUB,S_L,push_size,rsp);
                end;
              r.enum:=R_INTREGISTER;
              r.number:=R_EDI;
              emit_reg(A_PUSH,S_L,r);
           end
         else
           pop_esp:=false;
{$endif OPTALIGN}
        align_parasize:=pop_size;
      end;


    procedure ti386callnode.pop_parasize(pop_size:longint);
      var
        hreg : tregister;
      begin
        { better than an add on all processors }
        if pop_size=4 then
          begin
            hreg:=cg.getintregister(exprasmlist,OS_INT);
            exprasmlist.concat(taicpu.op_reg(A_POP,S_L,hreg));
            cg.ungetregister(exprasmlist,hreg);
          end
        { the pentium has two pipes and pop reg is pairable }
        { but the registers must be different!        }
        else
          if (pop_size=8) and
             not(cs_littlesize in aktglobalswitches) and
             (aktoptprocessor=ClassPentium) then
            begin
               hreg:=cg.getintregister(exprasmlist,OS_INT);
               exprasmlist.concat(taicpu.op_reg(A_POP,S_L,hreg));
               cg.ungetregister(exprasmlist,hreg);
               hreg:=cg.getintregister(exprasmlist,OS_INT);
               exprasmlist.concat(taicpu.op_reg(A_POP,S_L,hreg));
               cg.ungetregister(exprasmlist,hreg);
            end
        else
          if pop_size<>0 then
            exprasmlist.concat(taicpu.op_const_reg(A_ADD,S_L,pop_size,NR_ESP));

{$ifdef OPTALIGN}
        if pop_esp then
          emit_reg(A_POP,S_L,NR_ESP);
{$endif OPTALIGN}
      end;


begin
   ccallnode:=ti386callnode;
end.
{
  $Log$
  Revision 1.99  2003-11-07 15:58:32  florian
    * Florian's culmutative nr. 1; contains:
      - invalid calling conventions for a certain cpu are rejected
      - arm softfloat calling conventions
      - -Sp for cpu dependend code generation
      - several arm fixes
      - remaining code for value open array paras on heap

  Revision 1.98  2003/10/10 17:48:14  peter
    * old trgobj moved to x86/rgcpu and renamed to trgx86fpu
    * tregisteralloctor renamed to trgobj
    * removed rgobj from a lot of units
    * moved location_* and reference_* to cgobj
    * first things for mmx register allocation

  Revision 1.97  2003/10/09 21:31:37  daniel
    * Register allocator splitted, ans abstract now

  Revision 1.96  2003/10/01 20:34:49  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.95  2003/09/23 17:56:06  peter
    * locals and paras are allocated in the code generation
    * tvarsym.localloc contains the location of para/local when
      generating code for the current procedure

  Revision 1.94  2003/09/03 15:55:01  peter
    * NEWRA branch merged

  Revision 1.93.2.1  2003/08/29 17:29:00  peter
    * next batch of updates

  Revision 1.93  2003/05/30 23:57:08  peter
    * more sparc cleanup
    * accumulator removed, splitted in function_return_reg (called) and
      function_result_reg (caller)

  Revision 1.92  2003/05/26 21:17:18  peter
    * procinlinenode removed
    * aktexit2label removed, fast exit removed
    + tcallnode.inlined_pass_2 added

  Revision 1.91  2003/05/22 21:32:29  peter
    * removed some unit dependencies

  Revision 1.90  2003/04/23 14:42:08  daniel
    * Further register allocator work. Compiler now smaller with new
      allocator than without.
    * Somebody forgot to adjust ppu version number

  Revision 1.89  2003/04/22 14:33:38  peter
    * removed some notes/hints

  Revision 1.88  2003/04/22 10:09:35  daniel
    + Implemented the actual register allocator
    + Scratch registers unavailable when new register allocator used
    + maybe_save/maybe_restore unavailable when new register allocator used

  Revision 1.87  2003/04/04 15:38:56  peter
    * moved generic code from n386cal to ncgcal, i386 now also
      uses the generic ncgcal

  Revision 1.86  2003/03/30 20:59:07  peter
    * fix classmethod from classmethod call
    * move BeforeDestruction/AfterConstruction calls to
      genentrycode/genexitcode instead of generating them on the fly
      after a call to a constructor

  Revision 1.85  2003/03/28 19:16:57  peter
    * generic constructor working for i386
    * remove fixed self register
    * esi added as address register for i386

  Revision 1.84  2003/03/13 19:52:23  jonas
    * and more new register allocator fixes (in the i386 code generator this
      time). At least now the ppc cross compiler can compile the linux
      system unit again, but I haven't tested it.

  Revision 1.83  2003/03/06 11:35:50  daniel
    * Fixed internalerror 7843 issue

  Revision 1.82  2003/02/19 22:00:15  daniel
    * Code generator converted to new register notation
    - Horribily outdated todo.txt removed

  Revision 1.81  2003/01/30 21:46:57  peter
    * self fixes for static methods (merged)

  Revision 1.80  2003/01/13 18:37:44  daniel
    * Work on register conversion

  Revision 1.79  2003/01/08 18:43:57  daniel
   * Tregister changed into a record

  Revision 1.78  2002/12/15 21:30:12  florian
    * tcallnode.paraitem introduced, all references to defcoll removed

  Revision 1.77  2002/11/27 20:05:06  peter
    * cdecl array of const fixes

  Revision 1.76  2002/11/25 17:43:26  peter
    * splitted defbase in defutil,symutil,defcmp
    * merged isconvertable and is_equal into compare_defs(_ext)
    * made operator search faster by walking the list only once

  Revision 1.75  2002/11/18 17:32:00  peter
    * pass proccalloption to ret_in_xxx and push_xxx functions

  Revision 1.74  2002/11/15 01:58:57  peter
    * merged changes from 1.0.7 up to 04-11
      - -V option for generating bug report tracing
      - more tracing for option parsing
      - errors for cdecl and high()
      - win32 import stabs
      - win32 records<=8 are returned in eax:edx (turned off by default)
      - heaptrc update
      - more info for temp management in .s file with EXTDEBUG

  Revision 1.73  2002/10/05 12:43:29  carl
    * fixes for Delphi 6 compilation
     (warning : Some features do not work under Delphi)

  Revision 1.72  2002/09/17 18:54:03  jonas
    * a_load_reg_reg() now has two size parameters: source and dest. This
      allows some optimizations on architectures that don't encode the
      register size in the register name.

  Revision 1.71  2002/09/16 19:07:37  peter
    * push 0 instead of VMT when calling a constructor from a member

  Revision 1.70  2002/09/07 15:25:10  peter
    * old logs removed and tabs fixed

  Revision 1.69  2002/09/01 18:43:27  peter
    * include FUNCTION_RETURN_REG in regs_to_push list

  Revision 1.68  2002/09/01 12:13:00  peter
    * use a_call_reg
    * ungetiftemp for procvar of object temp

  Revision 1.67  2002/08/25 19:25:21  peter
    * sym.insert_in_data removed
    * symtable.insertvardata/insertconstdata added
    * removed insert_in_data call from symtable.insert, it needs to be
      called separatly. This allows to deref the address calculation
    * procedures now calculate the parast addresses after the procedure
      directives are parsed. This fixes the cdecl parast problem
    * push_addr_param has an extra argument that specifies if cdecl is used
      or not

  Revision 1.66  2002/08/23 16:14:49  peter
    * tempgen cleanup
    * tt_noreuse temp type added that will be used in genentrycode

  Revision 1.65  2002/08/18 20:06:30  peter
    * inlining is now also allowed in interface
    * renamed write/load to ppuwrite/ppuload
    * tnode storing in ppu
    * nld,ncon,nbas are already updated for storing in ppu

  Revision 1.64  2002/08/17 09:23:45  florian
    * first part of procinfo rewrite

  Revision 1.63  2002/08/12 15:08:42  carl
    + stab register indexes for powerpc (moved from gdb to cpubase)
    + tprocessor enumeration moved to cpuinfo
    + linker in target_info is now a class
    * many many updates for m68k (will soon start to compile)
    - removed some ifdef or correct them for correct cpu

  Revision 1.62  2002/08/11 14:32:30  peter
    * renamed current_library to objectlibrary

  Revision 1.61  2002/08/11 13:24:16  peter
    * saving of asmsymbols in ppu supported
    * asmsymbollist global is removed and moved into a new class
      tasmlibrarydata that will hold the info of a .a file which
      corresponds with a single module. Added librarydata to tmodule
      to keep the library info stored for the module. In the future the
      objectfiles will also be stored to the tasmlibrarydata class
    * all getlabel/newasmsymbol and friends are moved to the new class

  Revision 1.60  2002/07/20 11:58:01  florian
    * types.pas renamed to defbase.pas because D6 contains a types
      unit so this would conflicts if D6 programms are compiled
    + Willamette/SSE2 instructions to assembler added

  Revision 1.59  2002/07/11 14:41:33  florian
    * start of the new generic parameter handling

  Revision 1.58  2002/07/07 09:52:34  florian
    * powerpc target fixed, very simple units can be compiled
    * some basic stuff for better callparanode handling, far from being finished

  Revision 1.57  2002/07/06 20:27:26  carl
  + generic set handling

  Revision 1.56  2002/07/01 18:46:31  peter
    * internal linker
    * reorganized aasm layer

  Revision 1.55  2002/07/01 16:23:56  peter
    * cg64 patch
    * basics for currency
    * asnode updates for class and interface (not finished)

  Revision 1.54  2002/05/20 13:30:40  carl
  * bugfix of hdisponen (base must be set, not index)
  * more portability fixes

  Revision 1.53  2002/05/18 13:34:23  peter
    * readded missing revisions

  Revision 1.52  2002/05/16 19:46:51  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.50  2002/05/13 19:54:38  peter
    * removed n386ld and n386util units
    * maybe_save/maybe_restore added instead of the old maybe_push

  Revision 1.49  2002/05/12 16:53:17  peter
    * moved entry and exitcode to ncgutil and cgobj
    * foreach gets extra argument for passing local data to the
      iterator function
    * -CR checks also class typecasts at runtime by changing them
      into as
    * fixed compiler to cycle with the -CR option
    * fixed stabs with elf writer, finally the global variables can
      be watched
    * removed a lot of routines from cga unit and replaced them by
      calls to cgobj
    * u32bit-s32bit updates for and,or,xor nodes. When one element is
      u32bit then the other is typecasted also to u32bit without giving
      a rangecheck warning/error.
    * fixed pascal calling method with reversing also the high tree in
      the parast, detected by tcalcst3 test

}
