{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    Contains the base types for the m68k

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
{ This Unit contains the base types for the m68k
}
unit cpubase;

{$i fpcdefs.inc}

interface

uses
  strings,cutils,cclasses,aasmbase,cpuinfo,cgbase;


{*****************************************************************************
                                Assembler Opcodes
*****************************************************************************}

    type
    {  warning: CPU32 opcodes are not fully compatible with the MC68020. }
       { 68000 only opcodes }
       tasmop = (a_abcd,
         a_add,a_adda,a_addi,a_addq,a_addx,a_and,a_andi,
         a_asl,a_asr,a_bcc,a_bcs,a_beq,a_bge,a_bgt,a_bhi,
         a_ble,a_bls,a_blt,a_bmi,a_bne,a_bpl,a_bvc,a_bvs,
         a_bchg,a_bclr,a_bra,a_bset,a_bsr,a_btst,a_chk,
         a_clr,a_cmp,a_cmpa,a_cmpi,a_cmpm,a_dbcc,a_dbcs,a_dbeq,a_dbge,
         a_dbgt,a_dbhi,a_dble,a_dbls,a_dblt,a_dbmi,a_dbne,a_dbra,
         a_dbpl,a_dbt,a_dbvc,a_dbvs,a_dbf,a_divs,a_divu,
         a_eor,a_eori,a_exg,a_illegal,a_ext,a_jmp,a_jsr,
         a_lea,a_link,a_lsl,a_lsr,a_move,a_movea,a_movei,a_moveq,
         a_movem,a_movep,a_muls,a_mulu,a_nbcd,a_neg,a_negx,
         a_nop,a_not,a_or,a_ori,a_pea,a_rol,a_ror,a_roxl,
         a_roxr,a_rtr,a_rts,a_sbcd,a_scc,a_scs,a_seq,a_sge,
         a_sgt,a_shi,a_sle,a_sls,a_slt,a_smi,a_sne,
         a_spl,a_st,a_svc,a_svs,a_sf,a_sub,a_suba,a_subi,a_subq,
         a_subx,a_swap,a_tas,a_trap,a_trapv,a_tst,a_unlk,
         a_rte,a_reset,a_stop,
         { mc68010 instructions }
         a_bkpt,a_movec,a_moves,a_rtd,
         { mc68020 instructions }
         a_bfchg,a_bfclr,a_bfexts,a_bfextu,a_bfffo,
         a_bfins,a_bfset,a_bftst,a_callm,a_cas,a_cas2,
         a_chk2,a_cmp2,a_divsl,a_divul,a_extb,a_pack,a_rtm,
         a_trapcc,a_tracs,a_trapeq,a_trapf,a_trapge,a_trapgt,
         a_traphi,a_traple,a_trapls,a_traplt,a_trapmi,a_trapne,
         a_trappl,a_trapt,a_trapvc,a_trapvs,a_unpk,
         { fpu processor instructions - directly supported only. }
         { ieee aware and misc. condition codes not supported   }
         a_fabs,a_fadd,
         a_fbeq,a_fbne,a_fbngt,a_fbgt,a_fbge,a_fbnge,
         a_fblt,a_fbnlt,a_fble,a_fbgl,a_fbngl,a_fbgle,a_fbngle,
         a_fdbeq,a_fdbne,a_fdbgt,a_fdbngt,a_fdbge,a_fdbnge,
         a_fdblt,a_fdbnlt,a_fdble,a_fdbgl,a_fdbngl,a_fdbgle,a_fdbngle,
         a_fseq,a_fsne,a_fsgt,a_fsngt,a_fsge,a_fsnge,
         a_fslt,a_fsnlt,a_fsle,a_fsgl,a_fsngl,a_fsgle,a_fsngle,
         a_fcmp,a_fdiv,a_fmove,a_fmovem,
         a_fmul,a_fneg,a_fnop,a_fsqrt,a_fsub,a_fsgldiv,
         a_fsflmul,a_ftst,
         a_ftrapeq,a_ftrapne,a_ftrapgt,a_ftrapngt,a_ftrapge,a_ftrapnge,
         a_ftraplt,a_ftrapnlt,a_ftraple,a_ftrapgl,a_ftrapngl,a_ftrapgle,a_ftrapngle,
         { protected instructions }
         a_cprestore,a_cpsave,
         { fpu unit protected instructions                    }
         { and 68030/68851 common mmu instructions            }
         { (this may include 68040 mmu instructions)          }
         a_frestore,a_fsave,a_pflush,a_pflusha,a_pload,a_pmove,a_ptest,
         { useful for assembly language output }
         a_label,a_none,a_dbxx,a_sxx,a_bxx,a_fbxx);

      {# This should define the array of instructions as string }
      op2strtable=array[tasmop] of string[11];

    Const
      {# First value of opcode enumeration }
      firstop = low(tasmop);
      {# Last value of opcode enumeration  }
      lastop  = high(tasmop);

{*****************************************************************************
                                  Registers
*****************************************************************************}

    type
      { Number of registers used for indexing in tables }
      tregisterindex=0..{$i r68knor.inc}-1;

    const
      { Available Superregisters }
      {$i r68ksup.inc}

      { No Subregisters }
      R_SUBWHOLE = R_SUBNONE;

      { Available Registers }
      {$i r68kcon.inc}

      { Integer Super registers first and last }
      first_int_supreg = RS_SP;
      first_int_imreg = RS_SP+1;

      { Float Super register first and last }
      first_fpu_supreg    = RS_FP7;
      first_fpu_imreg     = RS_FP7+1;

      { MM Super register first and last }
      first_mm_supreg    = 0;
      first_mm_imreg     = 0;

      regnumber_count_bsstart = 64;

      regnumber_table : array[tregisterindex] of tregister = (
        {$i r68knum.inc}
      );

      regstabs_table : array[tregisterindex] of shortint = (
        {$i r68ksta.inc}
      );

      { registers which may be destroyed by calls }
      VOLATILE_INTREGISTERS = [];
      VOLATILE_FPUREGISTERS = [];

    type
      totherregisterset = set of tregisterindex;


{*****************************************************************************
                                Conditions
*****************************************************************************}

    type
      TAsmCond=(C_None,
         C_CC,C_LS,C_CS,C_LT,C_EQ,C_MI,C_F,C_NE,
         C_GE,C_PL,C_GT,C_T,C_HI,C_VC,C_LE,C_VS
      );


    const
      cond2str:array[TAsmCond] of string[3]=('',
        'cc','ls','cs','lt','eq','mi','f','ne',
        'ge','pl','gt','t','hi','vc','le','vs'
      );


{*****************************************************************************
                                   Flags
*****************************************************************************}

    type
      TResFlags = (
          F_E,F_NE,
          F_G,F_L,F_GE,F_LE,F_C,F_NC,F_A,F_AE,F_B,F_BE);

{*****************************************************************************
                                Reference
*****************************************************************************}

    type
      trefoptions=(ref_none,ref_parafixup,ref_localfixup,ref_selffixup);

      { direction of address register :      }
      {              (An)     (An)+   -(An)  }
      tdirection = (dir_none,dir_inc,dir_dec);

      { reference record }
      preference = ^treference;
      treference = packed record
         base,
         index       : tregister;
         scalefactor : byte;
         offset      : longint;
         symbol      : tasmsymbol;
         { symbol the symbol of this reference is relative to, nil if none }
         relsymbol      : tasmsymbol;
         { reference type addr or symbol itself }
         refaddr : trefaddr;
         options     : trefoptions;
         { indexed increment and decrement mode }
         { (An)+ and -(An)                      }
         direction : tdirection;
      end;

      { reference record }
      pparareference = ^tparareference;
      tparareference = record
         offset      : longint;
         index       : tregister;
      end;


{*****************************************************************************
                               Generic Location
*****************************************************************************}

    type
      { tparamlocation describes where a parameter for a procedure is stored.
        References are given from the caller's point of view. The usual
        TLocation isn't used, because contains a lot of unnessary fields.
      }
      tparalocation = record
         size : TCGSize;
         loc  : TCGLoc;
         lochigh : TCGLoc;
         alignment : byte;
         case TCGLoc of
            LOC_REFERENCE : (reference : tparareference);
            { segment in reference at the same place as in loc_register }
            LOC_REGISTER,LOC_CREGISTER : (
              case longint of
                1 : (register,registerhigh : tregister);
                { overlay a registerlow }
                2 : (registerlow : tregister);
                { overlay a 64 Bit register type }
                3 : (reg64 : tregister64);
                4 : (register64 : tregister64);
              );
      end;

      tlocation = record
         loc  : TCGLoc;
         size : TCGSize;
         case TCGLoc of
            LOC_FLAGS : (resflags : tresflags);
            LOC_CONSTANT : (
              case longint of
                1 : (value : AWord);
                { can't do this, this layout depends on the host cpu. Use }
                { lo(valueqword)/hi(valueqword) instead (JM)              }
                { 2 : (valuelow, valuehigh:AWord);                        }
                { overlay a complete 64 Bit value }
                3 : (valueqword : qword);
              );
            LOC_CREFERENCE,
            LOC_REFERENCE : (reference : treference);
            { segment in reference at the same place as in loc_register }
            LOC_REGISTER,LOC_CREGISTER : (
              case longint of
                1 : (register,registerhigh,segment : tregister);
                { overlay a registerlow }
                2 : (registerlow : tregister);
                { overlay a 64 Bit register type }
                3 : (reg64 : tregister64);
                4 : (register64 : tregister64);
              );
      end;


{*****************************************************************************
                                Operand Sizes
*****************************************************************************}

       { S_NO = No Size of operand   }
       { S_B  = 8-bit size operand   }
       { S_W  = 16-bit size operand  }
       { S_L  = 32-bit size operand  }
       { Floating point types        }
       { S_FS  = single type (32 bit) }
       { S_FD  = double/64bit integer }
       { S_FX  = Extended type      }
       topsize = (S_NO,S_B,S_W,S_L,S_FS,S_FD,S_FX,S_IQ);

{*****************************************************************************
                                 Constants
*****************************************************************************}

    const
      {# maximum number of operands in assembler instruction }
      max_operands = 4;

{*****************************************************************************
                          Default generic sizes
*****************************************************************************}

      {# Defines the default address size for a processor, }
      OS_ADDR = OS_32;
      {# the natural int size for a processor,             }
      OS_INT = OS_32;
      {# the maximum float size for a processor,           }
      OS_FLOAT = OS_F64;
      {# the size of a vector register for a processor     }
      OS_VECTOR = OS_M128;


{*****************************************************************************
                               GDB Information
*****************************************************************************}

      {# Register indexes for stabs information, when some
         parameters or variables are stored in registers.

         Taken from m68kelf.h (DBX_REGISTER_NUMBER)
         from GCC 3.x source code.

         This is not compatible with the m68k-sun
         implementation.
      }
          stab_regindex : array[tregisterindex] of shortint =
        (
          {$i r68ksta.inc}
        );

{*****************************************************************************
                          Generic Register names
*****************************************************************************}

      {# Stack pointer register }
      NR_STACK_POINTER_REG = NR_SP;
      RS_STACK_POINTER_REG = RS_SP;
      {# Frame pointer register }
      NR_FRAME_POINTER_REG = NR_A6;
      RS_FRAME_POINTER_REG = RS_A6;
      {# Register for addressing absolute data in a position independant way,
         such as in PIC code. The exact meaning is ABI specific. For
         further information look at GCC source : PIC_OFFSET_TABLE_REGNUM
      }
      NR_PIC_OFFSET_REG = NR_A5;
      { Results are returned in this register (32-bit values) }
      NR_FUNCTION_RETURN_REG = NR_D0;
      RS_FUNCTION_RETURN_REG = NR_D0;
      { Low part of 64bit return value }
      NR_FUNCTION_RETURN64_LOW_REG = NR_D0;
      RS_FUNCTION_RETURN64_LOW_REG = RS_D0;
      { High part of 64bit return value }
      NR_FUNCTION_RETURN64_HIGH_REG = NR_D1;
      RS_FUNCTION_RETURN64_HIGH_REG = RS_D1;
      { The value returned from a function is available in this register }
      NR_FUNCTION_RESULT_REG = NR_FUNCTION_RETURN_REG;
      RS_FUNCTION_RESULT_REG = RS_FUNCTION_RETURN_REG;
      { The lowh part of 64bit value returned from a function }
      NR_FUNCTION_RESULT64_LOW_REG = NR_FUNCTION_RETURN64_LOW_REG;
      RS_FUNCTION_RESULT64_LOW_REG = RS_FUNCTION_RETURN64_LOW_REG;
      { The high part of 64bit value returned from a function }
      NR_FUNCTION_RESULT64_HIGH_REG = NR_FUNCTION_RETURN64_HIGH_REG;
      RS_FUNCTION_RESULT64_HIGH_REG = RS_FUNCTION_RETURN64_HIGH_REG;

      {# Floating point results will be placed into this register }
      NR_FPU_RESULT_REG = NR_FP0;

{*****************************************************************************
                       GCC /ABI linking information
*****************************************************************************}

      {# Registers which must be saved when calling a routine declared as
         cppdecl, cdecl, stdcall, safecall, palmossyscall. The registers
         saved should be the ones as defined in the target ABI and / or GCC.

         This value can be deduced from CALLED_USED_REGISTERS array in the
         GCC source.
      }
      std_saved_registers = [RS_D2..RS_D7,RS_A2..RS_A5];
      {# Required parameter alignment when calling a routine declared as
         stdcall and cdecl. The alignment value should be the one defined
         by GCC or the target ABI.

         The value of this constant is equal to the constant
         PARM_BOUNDARY / BITS_PER_UNIT in the GCC source.
      }
      std_param_align = 4;  { for 32-bit version only }

{*****************************************************************************
                            CPU Dependent Constants
*****************************************************************************}


{*****************************************************************************
                                  Helpers
*****************************************************************************}

    function  is_calljmp(o:tasmop):boolean;

    procedure inverse_flags(var r : TResFlags);
    function  flags_to_cond(const f: TResFlags) : TAsmCond;
    function cgsize2subreg(s:Tcgsize):Tsubregister;

    function findreg_by_number(r:Tregister):tregisterindex;
    function std_regnum_search(const s:string):Tregister;
    function std_regname(r:Tregister):string;

    function isaddressregister(reg : tregister) : boolean;

implementation

    uses
      verbose,
      rgbase;


    const
      std_regname_table : array[tregisterindex] of string[7] = (
        {$i r68kstd.inc}
      );

      regnumber_index : array[tregisterindex] of tregisterindex = (
        {$i r68krni.inc}
      );

      std_regname_index : array[tregisterindex] of tregisterindex = (
        {$i r68ksri.inc}
      );


{*****************************************************************************
                                  Helpers
*****************************************************************************}

    function is_calljmp(o:tasmop):boolean;
      begin
        is_calljmp := false;
        if o in [A_BXX,A_FBXX,A_DBXX,A_BCC..A_BVS,A_DBCC..A_DBVS,A_FBEQ..A_FSNGLE,
          A_JSR,A_BSR,A_JMP] then
           is_calljmp := true;
      end;


    procedure inverse_flags(var r: TResFlags);
      const flagsinvers : array[F_E..F_BE] of tresflags =
            (F_NE,F_E,
             F_LE,F_GE,
             F_L,F_G,
             F_NC,F_C,
             F_BE,F_B,
             F_AE,F_A);
      begin
         r:=flagsinvers[r];
      end;



    function flags_to_cond(const f: TResFlags) : TAsmCond;
      const flags2cond: array[tresflags] of tasmcond = (
          C_EQ,{F_E     equal}
          C_NE,{F_NE    not equal}
          C_GT,{F_G     gt signed}
          C_LT,{F_L     lt signed}
          C_GE,{F_GE    ge signed}
          C_LE,{F_LE    le signed}
          C_CS,{F_C     carry set}
          C_CC,{F_NC    carry clear}
          C_HI,{F_A     gt unsigned}
          C_CC,{F_AE    ge unsigned}
          C_CS,{F_B     lt unsigned}
          C_LS);{F_BE    le unsigned}
      begin
        flags_to_cond := flags2cond[f];
      end;

    function cgsize2subreg(s:Tcgsize):Tsubregister;
      begin
        case s of
          OS_8,OS_S8:
            cgsize2subreg:=R_SUBL;
          OS_16,OS_S16:
            cgsize2subreg:=R_SUBW;
          OS_32,OS_S32:
            cgsize2subreg:=R_SUBD;
          else
            internalerror(200301231);
        end;
      end;


    function findreg_by_number(r:Tregister):tregisterindex;
      begin
        result:=findreg_by_number_table(r,regnumber_index);
      end;


    function std_regnum_search(const s:string):Tregister;
      begin
        result:=regnumber_table[findreg_by_name_table(s,std_regname_table,std_regname_index)];
      end;


    function std_regname(r:Tregister):string;
      var
        p : tregisterindex;
      begin
        p:=findreg_by_number_table(r,regnumber_index);
        if p<>0 then
          result:=std_regname_table[p]
        else
          result:=generic_regname(r);
      end;


    function isaddressregister(reg : tregister) : boolean;
      begin
        result:=getregtype(reg)=R_ADDRESSREGISTER;
      end;


end.
{
  $Log$
  Revision 1.25  2004-04-18 21:13:59  florian
    * more adaptions for m68k

  Revision 1.24  2004/01/30 12:17:18  florian
    * fixed some m68k compilation problems

  Revision 1.23  2003/08/17 16:59:20  jonas
    * fixed regvars so they work with newra (at least for ppc)
    * fixed some volatile register bugs
    + -dnotranslation option for -dnewra, which causes the registers not to
      be translated from virtual to normal registers. Requires support in
      the assembler writer as well, which is only implemented in aggas/
      agppcgas currently

  Revision 1.22  2003/06/17 16:34:44  jonas
    * lots of newra fixes (need getfuncretparaloc implementation for i386)!
    * renamed all_intregisters to volatile_intregisters and made it
      processor dependent

  Revision 1.21  2003/06/03 13:01:59  daniel
    * Register allocator finished

  Revision 1.20  2003/04/23 13:40:33  peter
    * fix m68k compile

  Revision 1.19  2003/04/23 12:35:35  florian
    * fixed several issues with powerpc
    + applied a patch from Jonas for nested function calls (PowerPC only)
    * ...

  Revision 1.18  2003/02/19 22:00:16  daniel
    * Code generator converted to new register notation
    - Horribily outdated todo.txt removed

  Revision 1.17  2003/02/02 19:25:54  carl
    * Several bugfixes for m68k target (register alloc., opcode emission)
    + VIS target
    + Generic add more complete (still not verified)

  Revision 1.16  2003/01/09 15:49:56  daniel
    * Added register conversion

  Revision 1.15  2003/01/08 18:43:57  daniel
   * Tregister changed into a record

  Revision 1.14  2002/11/30 23:33:03  carl
    * merges from Pierre's fixes in m68k fixes branch

  Revision 1.13  2002/11/17 18:26:16  mazen
  * fixed a compilation bug accmulator-->accumulator, in definition of return_result_reg

  Revision 1.12  2002/11/17 17:49:09  mazen
  + return_result_reg and function_result_reg are now used, in all plateforms, to pass functions result between called function and its caller. See the explanation of each one

  Revision 1.11  2002/10/14 16:32:36  carl
    + flag_2_cond implemented

  Revision 1.10  2002/08/18 09:02:12  florian
    * fixed compilation problems

  Revision 1.9  2002/08/15 08:13:54  carl
    - a_load_sym_ofs_reg removed
    * loadvmt now calls loadaddr_ref_reg instead

  Revision 1.8  2002/08/14 18:41:47  jonas
    - remove valuelow/valuehigh fields from tlocation, because they depend
      on the endianess of the host operating system -> difficult to get
      right. Use lo/hi(location.valueqword) instead (remember to use
      valueqword and not value!!)

  Revision 1.7  2002/08/13 21:40:58  florian
    * more fixes for ppc calling conventions

  Revision 1.6  2002/08/13 18:58:54  carl
    + m68k problems with cvs fixed?()!

  Revision 1.4  2002/08/12 15:08:44  carl
    + stab register indexes for powerpc (moved from gdb to cpubase)
    + tprocessor enumeration moved to cpuinfo
    + linker in target_info is now a class
    * many many updates for m68k (will soon start to compile)
    - removed some ifdef or correct them for correct cpu

  Revision 1.3  2002/07/29 17:51:32  carl
    + restart m68k support
}
