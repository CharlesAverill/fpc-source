{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    This unit implements the code generator for the PowerPC

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
unit cgcpu;

{$i fpcdefs.inc}

  interface

    uses
       symtype,
       cgbase,cgobj,
       aasmbase,aasmcpu,aasmtai,
       cpubase,cpuinfo,node,cg64f32,rgcpu;

    type
      tcgppc = class(tcg)
        procedure init_register_allocators;override;
        procedure done_register_allocators;override;

        procedure ungetreference(list:Taasmoutput;const r:Treference);override;

        { passing parameters, per default the parameter is pushed }
        { nr gives the number of the parameter (enumerated from   }
        { left to right), this allows to move the parameter to    }
        { register, if the cpu supports register calling          }
        { conventions                                             }
        procedure a_param_const(list : taasmoutput;size : tcgsize;a : aword;const locpara : tparalocation);override;
        procedure a_param_ref(list : taasmoutput;size : tcgsize;const r : treference;const locpara : tparalocation);override;
        procedure a_paramaddr_ref(list : taasmoutput;const r : treference;const locpara : tparalocation);override;


        procedure a_call_name(list : taasmoutput;const s : string);override;
        procedure a_call_reg(list : taasmoutput;reg: tregister); override;

        procedure a_op_const_reg(list : taasmoutput; Op: TOpCG; size: TCGSize; a: AWord; reg: TRegister); override;
        procedure a_op_reg_reg(list : taasmoutput; Op: TOpCG; size: TCGSize; src, dst: TRegister); override;

        procedure a_op_const_reg_reg(list: taasmoutput; op: TOpCg;
          size: tcgsize; a: aword; src, dst: tregister); override;
        procedure a_op_reg_reg_reg(list: taasmoutput; op: TOpCg;
          size: tcgsize; src1, src2, dst: tregister); override;

        { move instructions }
        procedure a_load_const_reg(list : taasmoutput; size: tcgsize; a : aword;reg : tregister);override;
        procedure a_load_reg_ref(list : taasmoutput; fromsize, tosize: tcgsize; reg : tregister;const ref : treference);override;
        procedure a_load_ref_reg(list : taasmoutput; fromsize, tosize : tcgsize;const Ref : treference;reg : tregister);override;
        procedure a_load_reg_reg(list : taasmoutput; fromsize, tosize : tcgsize;reg1,reg2 : tregister);override;

        { fpu move instructions }
        procedure a_loadfpu_reg_reg(list: taasmoutput; size: tcgsize; reg1, reg2: tregister); override;
        procedure a_loadfpu_ref_reg(list: taasmoutput; size: tcgsize; const ref: treference; reg: tregister); override;
        procedure a_loadfpu_reg_ref(list: taasmoutput; size: tcgsize; reg: tregister; const ref: treference); override;

        {  comparison operations }
        procedure a_cmp_const_reg_label(list : taasmoutput;size : tcgsize;cmp_op : topcmp;a : aword;reg : tregister;
          l : tasmlabel);override;
        procedure a_cmp_reg_reg_label(list : taasmoutput;size : tcgsize;cmp_op : topcmp;reg1,reg2 : tregister;l : tasmlabel); override;

        procedure a_jmp_always(list : taasmoutput;l: tasmlabel); override;
        procedure a_jmp_flags(list : taasmoutput;const f : TResFlags;l: tasmlabel); override;

        procedure g_flags2reg(list: taasmoutput; size: TCgSize; const f: TResFlags; reg: TRegister); override;

        procedure g_stackframe_entry(list : taasmoutput;localsize : longint);override;
        procedure g_return_from_proc(list : taasmoutput;parasize : aword); override;
        procedure g_restore_frame_pointer(list : taasmoutput);override;

        procedure a_loadaddr_ref_reg(list : taasmoutput;const ref : treference;r : tregister);override;

        procedure g_concatcopy(list : taasmoutput;const source,dest : treference;len : aword; delsource,loadref : boolean);override;

        procedure g_overflowcheck(list: taasmoutput; const l: tlocation; def: tdef); override;
        { find out whether a is of the form 11..00..11b or 00..11...00. If }
        { that's the case, we can use rlwinm to do an AND operation        }
        function get_rlwi_const(a: aword; var l1, l2: longint): boolean;

        procedure g_save_standard_registers(list:Taasmoutput);override;
        procedure g_restore_standard_registers(list:Taasmoutput);override;
        procedure g_save_all_registers(list : taasmoutput);override;
        procedure g_restore_all_registers(list : taasmoutput;const funcretparaloc:tparalocation);override;

        procedure a_jmp_cond(list : taasmoutput;cond : TOpCmp;l: tasmlabel);

      private

        (* NOT IN USE: *)
        procedure g_stackframe_entry_mac(list : taasmoutput;localsize : longint);
        (* NOT IN USE: *)
        procedure g_return_from_proc_mac(list : taasmoutput;parasize : aword);


        { Make sure ref is a valid reference for the PowerPC and sets the }
        { base to the value of the index if (base = R_NO).                }
        { Returns true if the reference contained a base, index and an    }
        { offset or symbol, in which case the base will have been changed }
        { to a tempreg (which has to be freed by the caller) containing   }
        { the sum of part of the original reference                       }
        function fixref(list: taasmoutput; var ref: treference): boolean;

        { returns whether a reference can be used immediately in a powerpc }
        { instruction                                                      }
        function issimpleref(const ref: treference): boolean;

        { contains the common code of a_load_reg_ref and a_load_ref_reg }
        procedure a_load_store(list:taasmoutput;op: tasmop;reg:tregister;
                    ref: treference);

        { creates the correct branch instruction for a given combination }
        { of asmcondflags and destination addressing mode                }
        procedure a_jmp(list: taasmoutput; op: tasmop;
                        c: tasmcondflag; crval: longint; l: tasmlabel);

        function save_regs(list : taasmoutput):longint;
        procedure restore_regs(list : taasmoutput);
     end;

     tcg64fppc = class(tcg64f32)
       procedure a_op64_reg_reg(list : taasmoutput;op:TOpCG;regsrc,regdst : tregister64);override;
       procedure a_op64_const_reg(list : taasmoutput;op:TOpCG;value : qword;reg : tregister64);override;
       procedure a_op64_const_reg_reg(list: taasmoutput;op:TOpCG;value : qword;regsrc,regdst : tregister64);override;
       procedure a_op64_reg_reg_reg(list: taasmoutput;op:TOpCG;regsrc1,regsrc2,regdst : tregister64);override;
     end;


const
  TOpCG2AsmOpConstLo: Array[topcg] of TAsmOp = (A_NONE,A_ADDI,A_ANDI_,A_DIVWU,
                        A_DIVW,A_MULLW, A_MULLW, A_NONE,A_NONE,A_ORI,
                        A_SRAWI,A_SLWI,A_SRWI,A_SUBI,A_XORI);
  TOpCG2AsmOpConstHi: Array[topcg] of TAsmOp = (A_NONE,A_ADDIS,A_ANDIS_,
                        A_DIVWU,A_DIVW, A_MULLW,A_MULLW,A_NONE,A_NONE,
                        A_ORIS,A_NONE, A_NONE,A_NONE,A_SUBIS,A_XORIS);

  TOpCmp2AsmCond: Array[topcmp] of TAsmCondFlag = (C_NONE,C_EQ,C_GT,
                       C_LT,C_GE,C_LE,C_NE,C_LE,C_LT,C_GE,C_GT);

  implementation

    uses
       globtype,globals,verbose,systems,cutils,
       symconst,symdef,symsym,
       rgobj,tgobj,cpupi,procinfo,paramgr,
       cgutils;


    procedure tcgppc.init_register_allocators;
      begin
        inherited init_register_allocators;
        if target_info.system=system_powerpc_darwin then
          begin
            if pi_needs_got in current_procinfo.flags then
              begin
                current_procinfo.got:=NR_R31;
                rg[R_INTREGISTER]:=trgcpu.create(R_INTREGISTER,R_SUBWHOLE,
                  [RS_R3,RS_R4,RS_R5,RS_R6,RS_R7,RS_R8,
                   RS_R9,RS_R10,RS_R11,RS_R12,RS_R30,RS_R29,
                   RS_R28,RS_R27,RS_R26,RS_R25,RS_R24,RS_R23,RS_R22,
                   RS_R21,RS_R20,RS_R19,RS_R18,RS_R17,RS_R16,RS_R15,
                   RS_R14,RS_R13],first_int_imreg,[]);
              end
            else
              rg[R_INTREGISTER]:=trgcpu.create(R_INTREGISTER,R_SUBWHOLE,
                [RS_R3,RS_R4,RS_R5,RS_R6,RS_R7,RS_R8,
                 RS_R9,RS_R10,RS_R11,RS_R12,RS_R31,RS_R30,RS_R29,
                 RS_R28,RS_R27,RS_R26,RS_R25,RS_R24,RS_R23,RS_R22,
                 RS_R21,RS_R20,RS_R19,RS_R18,RS_R17,RS_R16,RS_R15,
                 RS_R14,RS_R13],first_int_imreg,[]);
          end
        else
          rg[R_INTREGISTER]:=trgcpu.create(R_INTREGISTER,R_SUBWHOLE,
            [RS_R3,RS_R4,RS_R5,RS_R6,RS_R7,RS_R8,
             RS_R9,RS_R10,RS_R11,RS_R12,RS_R31,RS_R30,RS_R29,
             RS_R28,RS_R27,RS_R26,RS_R25,RS_R24,RS_R23,RS_R22,
             RS_R21,RS_R20,RS_R19,RS_R18,RS_R17,RS_R16,RS_R15,
             RS_R14,RS_R13],first_int_imreg,[]);
        case target_info.abi of
          abi_powerpc_aix:
            rg[R_FPUREGISTER]:=trgcpu.create(R_FPUREGISTER,R_SUBNONE,
                [RS_F0,RS_F1,RS_F2,RS_F3,RS_F4,RS_F5,RS_F6,RS_F7,RS_F8,RS_F9,
                 RS_F10,RS_F11,RS_F12,RS_F13,RS_F31,RS_F30,RS_F29,RS_F28,RS_F27,
                 RS_F26,RS_F25,RS_F24,RS_F23,RS_F22,RS_F21,RS_F20,RS_F19,RS_F18,
                 RS_F17,RS_F16,RS_F15,RS_F14],first_fpu_imreg,[]);
          abi_powerpc_sysv:
            rg[R_FPUREGISTER]:=trgcpu.create(R_FPUREGISTER,R_SUBNONE,
                [RS_F0,RS_F1,RS_F2,RS_F3,RS_F4,RS_F5,RS_F6,RS_F7,RS_F8,RS_F9,
                 RS_F31,RS_F30,RS_F29,RS_F28,RS_F27,RS_F26,RS_F25,RS_F24,RS_F23,
                 RS_F22,RS_F21,RS_F20,RS_F19,RS_F18,RS_F17,RS_F16,RS_F15,RS_F14,
                 RS_F13,RS_F12,RS_F11,RS_F10],first_fpu_imreg,[]);
          else
            internalerror(2003122903);
        end;
        {$warning FIX ME}
        rg[R_MMREGISTER]:=trgcpu.create(R_MMREGISTER,R_SUBNONE,
            [RS_M0,RS_M1,RS_M2],first_mm_imreg,[]);
      end;


    procedure tcgppc.done_register_allocators;
      begin
        rg[R_INTREGISTER].free;
        rg[R_FPUREGISTER].free;
        rg[R_MMREGISTER].free;
        inherited done_register_allocators;
      end;


    procedure tcgppc.ungetreference(list:Taasmoutput;const r:Treference);
      begin
        if r.base<>NR_NO then
          ungetregister(list,r.base);
        if r.index<>NR_NO then
          ungetregister(list,r.index);
      end;


    procedure tcgppc.a_param_const(list : taasmoutput;size : tcgsize;a : aword;const locpara : tparalocation);
      var
        ref: treference;
      begin
        case locpara.loc of
          LOC_REGISTER,LOC_CREGISTER:
            a_load_const_reg(list,size,a,locpara.register);
          LOC_REFERENCE:
            begin
               reference_reset(ref);
               ref.base:=locpara.reference.index;
               ref.offset:=locpara.reference.offset;
               a_load_const_ref(list,size,a,ref);
            end;
          else
            internalerror(2002081101);
        end;
      end;


    procedure tcgppc.a_param_ref(list : taasmoutput;size : tcgsize;const r : treference;const locpara : tparalocation);

      var
        ref: treference;
        tmpreg: tregister;

      begin
        case locpara.loc of
          LOC_REGISTER,LOC_CREGISTER:
            a_load_ref_reg(list,size,size,r,locpara.register);
          LOC_REFERENCE:
            begin
               reference_reset(ref);
               ref.base:=locpara.reference.index;
               ref.offset:=locpara.reference.offset;
               tmpreg := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
               a_load_ref_reg(list,size,size,r,tmpreg);
               a_load_reg_ref(list,size,size,tmpreg,ref);
               rg[R_INTREGISTER].ungetregister(list,tmpreg);
            end;
          LOC_FPUREGISTER,LOC_CFPUREGISTER:
            case size of
               OS_F32, OS_F64:
                 a_loadfpu_ref_reg(list,size,r,locpara.register);
               else
                 internalerror(2002072801);
            end;
          else
            internalerror(2002081103);
        end;
      end;


    procedure tcgppc.a_paramaddr_ref(list : taasmoutput;const r : treference;const locpara : tparalocation);
      var
        ref: treference;
        tmpreg: tregister;

      begin
         case locpara.loc of
            LOC_REGISTER,LOC_CREGISTER:
              a_loadaddr_ref_reg(list,r,locpara.register);
            LOC_REFERENCE:
              begin
                reference_reset(ref);
                ref.base := locpara.reference.index;
                ref.offset := locpara.reference.offset;
                tmpreg := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
                a_loadaddr_ref_reg(list,r,tmpreg);
                a_load_reg_ref(list,OS_ADDR,OS_ADDR,tmpreg,ref);
                rg[R_INTREGISTER].ungetregister(list,tmpreg);
              end;
            else
              internalerror(2002080701);
         end;
      end;


    { calling a procedure by name }
    procedure tcgppc.a_call_name(list : taasmoutput;const s : string);
      var
        href : treference;
      begin
         { MacOS: The linker on MacOS (PPCLink) inserts a call to glue code,
           if it is a cross-TOC call. If so, it also replaces the NOP
           with some restore code.}
         list.concat(taicpu.op_sym(A_BL,objectlibrary.newasmsymbol(s,AB_EXTERNAL,AT_FUNCTION)));
         if target_info.system=system_powerpc_macos then
           list.concat(taicpu.op_none(A_NOP));
         if not(pi_do_call in current_procinfo.flags) then
           internalerror(2003060703);
      end;

    { calling a procedure by address }
    procedure tcgppc.a_call_reg(list : taasmoutput;reg: tregister);

      var
        tmpreg : tregister;
        tmpref : treference;

      begin
        if target_info.system=system_powerpc_macos then
          begin
            {Generate instruction to load the procedure address from
            the transition vector.}
            //TODO: Support cross-TOC calls.
            tmpreg := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
            reference_reset(tmpref);
            tmpref.offset := 0;
            //tmpref.symaddr := refs_full;
            tmpref.base:= reg;
            list.concat(taicpu.op_reg_ref(A_LWZ,tmpreg,tmpref));
            list.concat(taicpu.op_reg(A_MTCTR,tmpreg));
            rg[R_INTREGISTER].ungetregister(list,tmpreg);
          end
        else
          list.concat(taicpu.op_reg(A_MTCTR,reg));
        list.concat(taicpu.op_none(A_BCTRL));
        //if target_info.system=system_powerpc_macos then
        //  //NOP is not needed here.
        //  list.concat(taicpu.op_none(A_NOP));
        if not(pi_do_call in current_procinfo.flags) then
          internalerror(2003060704);
        //list.concat(tai_comment.create(strpnew('***** a_call_reg')));
      end;


{********************** load instructions ********************}

     procedure tcgppc.a_load_const_reg(list : taasmoutput; size: TCGSize; a : aword; reg : TRegister);

       begin
          if not(size in [OS_8,OS_S8,OS_16,OS_S16,OS_32,OS_S32]) then
            internalerror(2002090902);
          if (longint(a) >= low(smallint)) and
             (longint(a) <= high(smallint)) then
            list.concat(taicpu.op_reg_const(A_LI,reg,smallint(a)))
          else if ((a and $ffff) <> 0) then
            begin
              list.concat(taicpu.op_reg_const(A_LI,reg,smallint(a and $ffff)));
              if ((a shr 16) <> 0) or
                 (smallint(a and $ffff) < 0) then
                list.concat(taicpu.op_reg_reg_const(A_ADDIS,reg,reg,
                  smallint((a shr 16)+ord(smallint(a and $ffff) < 0))))
            end
          else
            list.concat(taicpu.op_reg_const(A_LIS,reg,smallint(a shr 16)));
       end;


     procedure tcgppc.a_load_reg_ref(list : taasmoutput; fromsize, tosize: TCGSize; reg : tregister;const ref : treference);

       const
         StoreInstr: Array[OS_8..OS_32,boolean, boolean] of TAsmOp =
                                 { indexed? updating?}
                    (((A_STB,A_STBU),(A_STBX,A_STBUX)),
                     ((A_STH,A_STHU),(A_STHX,A_STHUX)),
                     ((A_STW,A_STWU),(A_STWX,A_STWUX)));
       var
         op: TAsmOp;
         ref2: TReference;
         freereg: boolean;
       begin
         ref2 := ref;
         freereg := fixref(list,ref2);
         if tosize in [OS_S8..OS_S16] then
           { storing is the same for signed and unsigned values }
           tosize := tcgsize(ord(tosize)-(ord(OS_S8)-ord(OS_8)));
         { 64 bit stuff should be handled separately }
         if tosize in [OS_64,OS_S64] then
           internalerror(200109236);
         op := storeinstr[tcgsize2unsigned[tosize],ref2.index<>NR_NO,false];
         a_load_store(list,op,reg,ref2);
         if freereg then
           rg[R_INTREGISTER].ungetregister(list,ref2.base);
       End;


     procedure tcgppc.a_load_ref_reg(list : taasmoutput; fromsize,tosize : tcgsize;const ref: treference;reg : tregister);

       const
         LoadInstr: Array[OS_8..OS_S32,boolean, boolean] of TAsmOp =
                                { indexed? updating?}
                    (((A_LBZ,A_LBZU),(A_LBZX,A_LBZUX)),
                     ((A_LHZ,A_LHZU),(A_LHZX,A_LHZUX)),
                     ((A_LWZ,A_LWZU),(A_LWZX,A_LWZUX)),
                     { 64bit stuff should be handled separately }
                     ((A_NONE,A_NONE),(A_NONE,A_NONE)),
                     { 128bit stuff too }
                     ((A_NONE,A_NONE),(A_NONE,A_NONE)),
                     { there's no load-byte-with-sign-extend :( }
                     ((A_LBZ,A_LBZU),(A_LBZX,A_LBZUX)),
                     ((A_LHA,A_LHAU),(A_LHAX,A_LHAUX)),
                     ((A_LWZ,A_LWZU),(A_LWZX,A_LWZUX)));
       var
         op: tasmop;
         tmpreg: tregister;
         ref2, tmpref: treference;
         freereg: boolean;

       begin
          { TODO: optimize/take into consideration fromsize/tosize. Will }
          { probably only matter for OS_S8 loads though                  }
          if not(fromsize in [OS_8,OS_S8,OS_16,OS_S16,OS_32,OS_S32]) then
            internalerror(2002090902);
          ref2 := ref;
          freereg := fixref(list,ref2);
          { the caller is expected to have adjusted the reference already }
          { in this case                                                  }
          if (TCGSize2Size[fromsize] >= TCGSize2Size[tosize]) then
            fromsize := tosize;
          op := loadinstr[fromsize,ref2.index<>NR_NO,false];
          a_load_store(list,op,reg,ref2);
          if freereg then
            rg[R_INTREGISTER].ungetregister(list,ref2.base);
          { sign extend shortint if necessary, since there is no }
          { load instruction that does that automatically (JM)   }
          if fromsize = OS_S8 then
            list.concat(taicpu.op_reg_reg(A_EXTSB,reg,reg));
       end;


     procedure tcgppc.a_load_reg_reg(list : taasmoutput;fromsize, tosize : tcgsize;reg1,reg2 : tregister);

       var
         instr: taicpu;
       begin
         case tosize of
           OS_8:
             instr := taicpu.op_reg_reg_const_const_const(A_RLWINM,
               reg2,reg1,0,31-8+1,31);
           OS_S8:
             instr := taicpu.op_reg_reg(A_EXTSB,reg2,reg1);
           OS_16:
             instr := taicpu.op_reg_reg_const_const_const(A_RLWINM,
               reg2,reg1,0,31-16+1,31);
           OS_S16:
             instr := taicpu.op_reg_reg(A_EXTSH,reg2,reg1);
           OS_32,OS_S32:
             instr := taicpu.op_reg_reg(A_MR,reg2,reg1);
           else internalerror(2002090901);
         end;
         list.concat(instr);
         rg[R_INTREGISTER].add_move_instruction(instr);
       end;


     procedure tcgppc.a_loadfpu_reg_reg(list: taasmoutput; size: tcgsize; reg1, reg2: tregister);

       var
         instr: taicpu;
       begin
         instr :=  taicpu.op_reg_reg(A_FMR,reg2,reg1);
         list.concat(instr);
         rg[R_FPUREGISTER].add_move_instruction(instr);
       end;


     procedure tcgppc.a_loadfpu_ref_reg(list: taasmoutput; size: tcgsize; const ref: treference; reg: tregister);

       const
         FpuLoadInstr: Array[OS_F32..OS_F64,boolean, boolean] of TAsmOp =
                          { indexed? updating?}
                    (((A_LFS,A_LFSU),(A_LFSX,A_LFSUX)),
                     ((A_LFD,A_LFDU),(A_LFDX,A_LFDUX)));
       var
         op: tasmop;
         ref2: treference;
         freereg: boolean;

       begin
          { several functions call this procedure with OS_32 or OS_64 }
          { so this makes life easier (FK)                            }
          case size of
             OS_32,OS_F32:
               size:=OS_F32;
             OS_64,OS_F64,OS_C64:
               size:=OS_F64;
             else
               internalerror(200201121);
          end;
         ref2 := ref;
         freereg := fixref(list,ref2);
         op := fpuloadinstr[size,ref2.index <> NR_NO,false];
         a_load_store(list,op,reg,ref2);
         if freereg then
           rg[R_INTREGISTER].ungetregister(list,ref2.base);
       end;


     procedure tcgppc.a_loadfpu_reg_ref(list: taasmoutput; size: tcgsize; reg: tregister; const ref: treference);

       const
         FpuStoreInstr: Array[OS_F32..OS_F64,boolean, boolean] of TAsmOp =
                            { indexed? updating?}
                    (((A_STFS,A_STFSU),(A_STFSX,A_STFSUX)),
                     ((A_STFD,A_STFDU),(A_STFDX,A_STFDUX)));
       var
         op: tasmop;
         ref2: treference;
         freereg: boolean;

       begin
         if not(size in [OS_F32,OS_F64]) then
           internalerror(200201122);
         ref2 := ref;
         freereg := fixref(list,ref2);
         op := fpustoreinstr[size,ref2.index <> NR_NO,false];
         a_load_store(list,op,reg,ref2);
         if freereg then
           rg[R_INTREGISTER].ungetregister(list,ref2.base);
       end;


     procedure tcgppc.a_op_const_reg(list : taasmoutput; Op: TOpCG; size: TCGSize; a: AWord; reg: TRegister);

       begin
         a_op_const_reg_reg(list,op,size,a,reg,reg);
       end;


      procedure tcgppc.a_op_reg_reg(list : taasmoutput; Op: TOpCG; size: TCGSize; src, dst: TRegister);

         begin
           a_op_reg_reg_reg(list,op,size,src,dst,dst);
         end;


    procedure tcgppc.a_op_const_reg_reg(list: taasmoutput; op: TOpCg;
                       size: tcgsize; a: aword; src, dst: tregister);
      var
        l1,l2: longint;
        oplo, ophi: tasmop;
        scratchreg: tregister;
        useReg, gotrlwi: boolean;


        procedure do_lo_hi;
          begin
            list.concat(taicpu.op_reg_reg_const(oplo,dst,src,word(a)));
            list.concat(taicpu.op_reg_reg_const(ophi,dst,dst,word(a shr 16)));
          end;

      begin
        if op = OP_SUB then
          begin
{$ifopt q+}
{$q-}
{$define overflowon}
{$endif}
            a_op_const_reg_reg(list,OP_ADD,size,aword(-longint(a)),src,dst);
{$ifdef overflowon}
{$q+}
{$undef overflowon}
{$endif}
            exit;
          end;
        ophi := TOpCG2AsmOpConstHi[op];
        oplo := TOpCG2AsmOpConstLo[op];
        gotrlwi := get_rlwi_const(a,l1,l2);
        if (op in [OP_AND,OP_OR,OP_XOR]) then
          begin
            if (a = 0) then
              begin
                if op = OP_AND then
                  list.concat(taicpu.op_reg_const(A_LI,dst,0))
                else
                  a_load_reg_reg(list,size,size,src,dst);
                exit;
              end
            else if (a = high(aword)) then
              begin
                case op of
                  OP_OR:
                    list.concat(taicpu.op_reg_const(A_LI,dst,-1));
                  OP_XOR:
                    list.concat(taicpu.op_reg_reg(A_NOT,dst,src));
                  OP_AND:
                    a_load_reg_reg(list,size,size,src,dst);
                end;
                exit;
              end
            else if (a <= high(word)) and
               ((op <> OP_AND) or
                not gotrlwi) then
              begin
                list.concat(taicpu.op_reg_reg_const(oplo,dst,src,word(a)));
                exit;
              end;
            { all basic constant instructions also have a shifted form that }
            { works only on the highest 16bits, so if lo(a) is 0, we can    }
            { use that one                                                  }
            if (word(a) = 0) and
               (not(op = OP_AND) or
                not gotrlwi) then
              begin
                list.concat(taicpu.op_reg_reg_const(ophi,dst,src,word(a shr 16)));
                exit;
              end;
          end
        else if (op = OP_ADD) then
          if a = 0 then
            exit
          else if (longint(a) >= low(smallint)) and
              (longint(a) <= high(smallint)) then
             begin
               list.concat(taicpu.op_reg_reg_const(A_ADDI,dst,src,smallint(a)));
               exit;
             end;

        { otherwise, the instructions we can generate depend on the }
        { operation                                                 }
        useReg := false;
        case op of
          OP_DIV,OP_IDIV:
             if (a = 0) then
               internalerror(200208103)
             else if (a = 1) then
               begin
                 a_load_reg_reg(list,OS_INT,OS_INT,src,dst);
                 exit
               end
            else if ispowerof2(a,l1) then
              begin
                case op of
                  OP_DIV:
                    list.concat(taicpu.op_reg_reg_const(A_SRWI,dst,src,l1));
                  OP_IDIV:
                    begin
                       list.concat(taicpu.op_reg_reg_const(A_SRAWI,dst,src,l1));
                       list.concat(taicpu.op_reg_reg(A_ADDZE,dst,dst));
                    end;
                end;
                exit;
              end
            else
              usereg := true;
           OP_IMUL, OP_MUL:
             if (a = 0) then
               begin
                 list.concat(taicpu.op_reg_const(A_LI,dst,0));
                 exit
               end
             else if (a = 1) then
               begin
                 a_load_reg_reg(list,OS_INT,OS_INT,src,dst);
                 exit
               end
             else if ispowerof2(a,l1) then
               list.concat(taicpu.op_reg_reg_const(A_SLWI,dst,src,l1))
             else if (longint(a) >= low(smallint)) and
                (longint(a) <= high(smallint)) then
               list.concat(taicpu.op_reg_reg_const(A_MULLI,dst,src,smallint(a)))
             else
               usereg := true;
          OP_ADD:
            begin
              list.concat(taicpu.op_reg_reg_const(oplo,dst,src,smallint(a)));
              list.concat(taicpu.op_reg_reg_const(ophi,dst,dst,
                smallint((a shr 16) + ord(smallint(a) < 0))));
            end;
          OP_OR:
            { try to use rlwimi }
            if gotrlwi and
               (src = dst) then
              begin
                scratchreg := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
                list.concat(taicpu.op_reg_const(A_LI,scratchreg,-1));
                list.concat(taicpu.op_reg_reg_const_const_const(A_RLWIMI,dst,
                  scratchreg,0,l1,l2));
                rg[R_INTREGISTER].ungetregister(list,scratchreg);
              end
            else
              do_lo_hi;
          OP_AND:
            { try to use rlwinm }
            if gotrlwi then
              list.concat(taicpu.op_reg_reg_const_const_const(A_RLWINM,dst,
                src,0,l1,l2))
            else
              useReg := true;
          OP_XOR:
            do_lo_hi;
          OP_SHL,OP_SHR,OP_SAR:
            begin
              if (a and 31) <> 0 Then
                list.concat(taicpu.op_reg_reg_const(
                  TOpCG2AsmOpConstLo[Op],dst,src,a and 31))
              else
                a_load_reg_reg(list,size,size,src,dst);
              if (a shr 5) <> 0 then
                internalError(68991);
            end
          else
            internalerror(200109091);
        end;
        { if all else failed, load the constant in a register and then }
        { perform the operation                                        }
        if useReg then
          begin
            scratchreg := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
            a_load_const_reg(list,OS_32,a,scratchreg);
            a_op_reg_reg_reg(list,op,OS_32,scratchreg,src,dst);
            rg[R_INTREGISTER].ungetregister(list,scratchreg);
          end;
      end;


    procedure tcgppc.a_op_reg_reg_reg(list: taasmoutput; op: TOpCg;
      size: tcgsize; src1, src2, dst: tregister);

      const
        op_reg_reg_opcg2asmop: array[TOpCG] of tasmop =
          (A_NONE,A_ADD,A_AND,A_DIVWU,A_DIVW,A_MULLW,A_MULLW,A_NEG,A_NOT,A_OR,
           A_SRAW,A_SLW,A_SRW,A_SUB,A_XOR);

       begin
         case op of
           OP_NEG,OP_NOT:
             begin
               list.concat(taicpu.op_reg_reg(op_reg_reg_opcg2asmop[op],dst,src1));
               if (op = OP_NOT) and
                  not(size in [OS_32,OS_S32]) then
                 { zero/sign extend result again }
                 a_load_reg_reg(list,OS_32,size,dst,dst);
              end;
           else
             list.concat(taicpu.op_reg_reg_reg(op_reg_reg_opcg2asmop[op],dst,src2,src1));
         end;
       end;


{*************** compare instructructions ****************}

      procedure tcgppc.a_cmp_const_reg_label(list : taasmoutput;size : tcgsize;cmp_op : topcmp;a : aword;reg : tregister;
        l : tasmlabel);

        var
          p: taicpu;
          scratch_register: TRegister;
          signed: boolean;

        begin
          signed := cmp_op in [OC_GT,OC_LT,OC_GTE,OC_LTE];
          { in the following case, we generate more efficient code when }
          { signed is true                                              }
          if (cmp_op in [OC_EQ,OC_NE]) and
             (a > $ffff) then
            signed := true;
          if signed then
            if (longint(a) >= low(smallint)) and (longint(a) <= high(smallint)) Then
              list.concat(taicpu.op_reg_reg_const(A_CMPWI,NR_CR0,reg,longint(a)))
            else
              begin
                scratch_register := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
                a_load_const_reg(list,OS_32,a,scratch_register);
                list.concat(taicpu.op_reg_reg_reg(A_CMPW,NR_CR0,reg,scratch_register));
                rg[R_INTREGISTER].ungetregister(list,scratch_register);
              end
          else
            if (a <= $ffff) then
              list.concat(taicpu.op_reg_reg_const(A_CMPLWI,NR_CR0,reg,a))
            else
              begin
                scratch_register := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
                a_load_const_reg(list,OS_32,a,scratch_register);
                list.concat(taicpu.op_reg_reg_reg(A_CMPLW,NR_CR0,reg,scratch_register));
                rg[R_INTREGISTER].ungetregister(list,scratch_register);
              end;
          a_jmp(list,A_BC,TOpCmp2AsmCond[cmp_op],0,l);
        end;


      procedure tcgppc.a_cmp_reg_reg_label(list : taasmoutput;size : tcgsize;cmp_op : topcmp;
        reg1,reg2 : tregister;l : tasmlabel);

        var
          p: taicpu;
          op: tasmop;

        begin
          if cmp_op in [OC_GT,OC_LT,OC_GTE,OC_LTE] then
            op := A_CMPW
          else
            op := A_CMPLW;
          list.concat(taicpu.op_reg_reg_reg(op,NR_CR0,reg2,reg1));
          a_jmp(list,A_BC,TOpCmp2AsmCond[cmp_op],0,l);
        end;


     procedure tcgppc.g_save_standard_registers(list:Taasmoutput);
       begin
         {$warning FIX ME}
       end;

     procedure tcgppc.g_restore_standard_registers(list:Taasmoutput);
       begin
         {$warning FIX ME}
       end;

     procedure tcgppc.g_save_all_registers(list : taasmoutput);
       begin
         {$warning FIX ME}
       end;

     procedure tcgppc.g_restore_all_registers(list : taasmoutput;const funcretparaloc:tparalocation);
       begin
         {$warning FIX ME}
       end;

     procedure tcgppc.a_jmp_cond(list : taasmoutput;cond : TOpCmp;l: tasmlabel);

       begin
         a_jmp(list,A_BC,TOpCmp2AsmCond[cond],0,l);
       end;

     procedure tcgppc.a_jmp_always(list : taasmoutput;l: tasmlabel);

       begin
         a_jmp(list,A_B,C_None,0,l);
       end;

     procedure tcgppc.a_jmp_flags(list : taasmoutput;const f : TResFlags;l: tasmlabel);

       var
         c: tasmcond;
       begin
         c := flags_to_cond(f);
         a_jmp(list,A_BC,c.cond,c.cr-RS_CR0,l);
       end;

     procedure tcgppc.g_flags2reg(list: taasmoutput; size: TCgSize; const f: TResFlags; reg: TRegister);

       var
         testbit: byte;
         bitvalue: boolean;

       begin
         { get the bit to extract from the conditional register + its }
         { requested value (0 or 1)                                   }
         testbit := ((f.cr-RS_CR0) * 4);
         case f.flag of
           F_EQ,F_NE:
             begin
               inc(testbit,2);
               bitvalue := f.flag = F_EQ;
             end;
           F_LT,F_GE:
             begin
               bitvalue := f.flag = F_LT;
             end;
           F_GT,F_LE:
             begin
               inc(testbit);
               bitvalue := f.flag = F_GT;
             end;
           else
             internalerror(200112261);
         end;
         { load the conditional register in the destination reg }
         list.concat(taicpu.op_reg(A_MFCR,reg));
         { we will move the bit that has to be tested to bit 0 by rotating }
         { left                                                            }
         testbit := (testbit + 1) and 31;
         { extract bit }
         list.concat(taicpu.op_reg_reg_const_const_const(
           A_RLWINM,reg,reg,testbit,31,31));
         { if we need the inverse, xor with 1 }
         if not bitvalue then
           list.concat(taicpu.op_reg_reg_const(A_XORI,reg,reg,1));
       end;

(*
     procedure tcgppc.g_cond2reg(list: taasmoutput; const f: TAsmCond; reg: TRegister);

       var
         testbit: byte;
         bitvalue: boolean;

       begin
         { get the bit to extract from the conditional register + its }
         { requested value (0 or 1)                                   }
         case f.simple of
           false:
             begin
               { we don't generate this in the compiler }
               internalerror(200109062);
             end;
           true:
             case f.cond of
               C_None:
                 internalerror(200109063);
               C_LT..C_NU:
                 begin
                   testbit := (ord(f.cr) - ord(R_CR0))*4;
                   inc(testbit,AsmCondFlag2BI[f.cond]);
                   bitvalue := AsmCondFlagTF[f.cond];
                 end;
               C_T,C_F,C_DNZT,C_DNZF,C_DZT,C_DZF:
                 begin
                   testbit := f.crbit
                   bitvalue := AsmCondFlagTF[f.cond];
                 end;
               else
                 internalerror(200109064);
             end;
         end;
         { load the conditional register in the destination reg }
         list.concat(taicpu.op_reg_reg(A_MFCR,reg));
         { we will move the bit that has to be tested to bit 31 -> rotate }
         { left by bitpos+1 (remember, this is big-endian!)               }
         if bitpos <> 31 then
           inc(bitpos)
         else
           bitpos := 0;
         { extract bit }
         list.concat(taicpu.op_reg_reg_const_const_const(
           A_RLWINM,reg,reg,bitpos,31,31));
         { if we need the inverse, xor with 1 }
         if not bitvalue then
           list.concat(taicpu.op_reg_reg_const(A_XORI,reg,reg,1));
       end;
*)

{ *********** entry/exit code and address loading ************ }

    procedure tcgppc.g_stackframe_entry(list : taasmoutput;localsize : longint);
     { generated the entry code of a procedure/function. Note: localsize is the }
     { sum of the size necessary for local variables and the maximum possible   }
     { combined size of ALL the parameters of a procedure called by the current }
     { one.                                                                     }
     { This procedure may be called before, as well as after g_return_from_proc }
     { is called. NOTE registers are not to be allocated through the register   }
     { allocator here, because the register colouring has already occured !!    }


     var regcounter,firstregfpu,firstreggpr: TSuperRegister;
         href,href2 : treference;
         usesfpr,usesgpr,gotgot : boolean;
         parastart : aword;
//         r,r2,rsp:Tregister;
         l : tasmlabel;
         regcounter2, firstfpureg: Tsuperregister;
         hp: tparaitem;
         cond : tasmcond;
         instr : taicpu;

      begin
        { CR and LR only have to be saved in case they are modified by the current }
        { procedure, but currently this isn't checked, so save them always         }
        { following is the entry code as described in "Altivec Programming }
        { Interface Manual", bar the saving of AltiVec registers           }
        a_reg_alloc(list,NR_STACK_POINTER_REG);
        a_reg_alloc(list,NR_R0);

        if current_procinfo.procdef.parast.symtablelevel>1 then
          a_reg_alloc(list,NR_R11);

        usesfpr:=false;
        if not (po_assembler in current_procinfo.procdef.procoptions) then
          { FIXME: has to be R_F14 instad of R_F8 for SYSV-64bit }
          case target_info.abi of
            abi_powerpc_aix:
              firstfpureg := RS_F14;
            abi_powerpc_sysv:
              firstfpureg := RS_F9;
            else
              internalerror(2003122903);
          end;
          for regcounter:=firstfpureg to RS_F31 do
           begin
             if regcounter in rg[R_FPUREGISTER].used_in_proc then
              begin
                usesfpr:= true;
                firstregfpu:=regcounter;
                break;
              end;
           end;

        usesgpr:=false;
        if not (po_assembler in current_procinfo.procdef.procoptions) then
          for regcounter2:=RS_R13 to RS_R31 do
            begin
              if regcounter2 in rg[R_INTREGISTER].used_in_proc then
                begin
                   usesgpr:=true;
                   firstreggpr:=regcounter2;
                   break;
                end;
            end;

        { save link register? }
        if not (po_assembler in current_procinfo.procdef.procoptions) then
          if (pi_do_call in current_procinfo.flags) then
            begin
               { save return address... }
               list.concat(taicpu.op_reg(A_MFLR,NR_R0));
               { ... in caller's frame }
               case target_info.abi of
                 abi_powerpc_aix:
                   reference_reset_base(href,NR_STACK_POINTER_REG,LA_LR_AIX);
                 abi_powerpc_sysv:
                   reference_reset_base(href,NR_STACK_POINTER_REG,LA_LR_SYSV);
               end;
               list.concat(taicpu.op_reg_ref(A_STW,NR_R0,href));
               a_reg_dealloc(list,NR_R0);
            end;

        { save the CR if necessary in callers frame. }
        if not (po_assembler in current_procinfo.procdef.procoptions) then
          if target_info.abi = abi_powerpc_aix then
            if false then { Not needed at the moment. }
              begin
                a_reg_alloc(list,NR_R0);
                list.concat(taicpu.op_reg_reg(A_MFSPR,NR_R0,NR_CR));
                reference_reset_base(href,NR_STACK_POINTER_REG,LA_CR_AIX);
                list.concat(taicpu.op_reg_ref(A_STW,NR_R0,href));
                a_reg_dealloc(list,NR_R0);
              end;

        { !!! always allocate space for all registers for now !!! }
        if not (po_assembler in current_procinfo.procdef.procoptions) then
{        if usesfpr or usesgpr then }
          begin
             a_reg_alloc(list,NR_R12);
             { save end of fpr save area }
             list.concat(taicpu.op_reg_reg(A_MR,NR_R12,NR_STACK_POINTER_REG));
          end;


        if (localsize <> 0) then
          begin
            if (localsize <= high(smallint)) then
              begin
                reference_reset_base(href,NR_STACK_POINTER_REG,-localsize);
                a_load_store(list,A_STWU,NR_STACK_POINTER_REG,href);
              end
            else
              begin
                reference_reset_base(href,NR_STACK_POINTER_REG,0);
                { can't use getregisterint here, the register colouring }
                { is already done when we get here                      }
                href.index := NR_R11;
                a_reg_alloc(list,href.index);
                a_load_const_reg(list,OS_S32,-localsize,href.index);
                a_load_store(list,A_STWUX,NR_STACK_POINTER_REG,href);
                a_reg_dealloc(list,href.index);
              end;
          end;

        { no GOT pointer loaded yet }
        gotgot:=false;
        if usesfpr then
          begin
             { save floating-point registers
             if (cs_create_pic in aktmoduleswitches) and not(usesgpr) then
               begin
                  a_call_name(objectlibrary.newasmsymbol('_savefpr_'+tostr(ord(firstregfpu)-ord(R_F14)+14)+'_g',AB_EXTERNAL,AT_FUNCTION));
                  gotgot:=true;
               end
             else
               a_call_name(objectlibrary.newasmsymbol('_savefpr_'+tostr(ord(firstregfpu)-ord(R_F14)+14),AB_EXTERNAL,AT_FUNCTION));
             }
             reference_reset_base(href,NR_R12,-8);
             for regcounter:=firstregfpu to RS_F31 do
              begin
                if regcounter in rg[R_FPUREGISTER].used_in_proc then
                 begin
                    a_loadfpu_reg_ref(list,OS_F64,newreg(R_FPUREGISTER,regcounter,R_SUBNONE),href);
                    dec(href.offset,8);
                 end;
               end;

             { compute end of gpr save area }
             a_op_const_reg(list,OP_ADD,OS_ADDR,aword(href.offset+8),NR_R12);
          end;

        { save gprs and fetch GOT pointer }
        if usesgpr then
          begin
             {
             if cs_create_pic in aktmoduleswitches then
               begin
                  a_call_name(objectlibrary.newasmsymbol('_savegpr_'+tostr(ord(firstreggpr)-ord(R_14)+14)+'_g',AB_EXTERNAL,AT_FUNCTION));
                  gotgot:=true;
               end
             else
               a_call_name(objectlibrary.newasmsymbol('_savegpr_'+tostr(ord(firstreggpr)-ord(R_14)+14),AB_EXTERNAL,AT_FUNCTION))
             }
            reference_reset_base(href,NR_R12,-4);
            for regcounter2:=RS_R13 to RS_R31 do
              begin
                if regcounter2 in rg[R_INTREGISTER].used_in_proc then
                  begin
                     usesgpr:=true;
                     a_load_reg_ref(list,OS_INT,OS_INT,newreg(R_INTREGISTER,regcounter2,R_SUBNONE),href);
                     dec(href.offset,4);
                  end;
              end;
{
            r.enum:=R_INTREGISTER;
            r.:=;
            reference_reset_base(href,NR_R12,-((NR_R31-firstreggpr) shr 8+1)*4);
            list.concat(taicpu.op_reg_ref(A_STMW,firstreggpr,href));
}
          end;

        if assigned(current_procinfo.procdef.parast) then
          begin
            if not (po_assembler in current_procinfo.procdef.procoptions) then
              begin
                { copy memory parameters to local parast }
                hp:=tparaitem(current_procinfo.procdef.para.first);
                while assigned(hp) do
                  begin
                    if (hp.paraloc[calleeside].loc in [LOC_REFERENCE,LOC_CREFERENCE]) then
                      begin
                        if tvarsym(hp.parasym).localloc.loc<>LOC_REFERENCE then
                          internalerror(200310011);
                        reference_reset_base(href,tvarsym(hp.parasym).localloc.reference.index,tvarsym(hp.parasym).localloc.reference.offset);
                        reference_reset_base(href2,NR_R12,hp.paraloc[callerside].reference.offset);
                        { we can't use functions here which allocate registers (FK)
                          cg.a_load_ref_ref(list,hp.paraloc[calleeside].size,hp.paraloc[calleeside].size,href2,href);
                        }
                        cg.a_load_ref_reg(list,hp.paraloc[calleeside].size,hp.paraloc[calleeside].size,href2,NR_R0);
                        cg.a_load_reg_ref(list,hp.paraloc[calleeside].size,hp.paraloc[calleeside].size,NR_R0,href);
                      end
{$ifdef dummy}
                    else if (hp.calleeparaloc.loc in [LOC_REGISTER,LOC_CREGISTER]) then
                      begin
                        rg.getexplicitregisterint(list,hp.calleeparaloc.register);
                      end
{$endif dummy}
                      ;
                    hp := tparaitem(hp.next);
                  end;
              end;
          end;

        if usesfpr or usesgpr then
          a_reg_dealloc(list,NR_R12);

        { if we didn't get the GOT pointer till now, we've to calculate it now }
        if not(gotgot) and (pi_needs_got in current_procinfo.flags) then
          case target_info.system of
            system_powerpc_darwin:
              begin
                list.concat(taicpu.op_reg_reg(A_MFSPR,NR_R0,NR_LR));
                fillchar(cond,sizeof(cond),0);
                cond.simple:=false;
                cond.bo:=20;
                cond.bi:=31;
                instr:=taicpu.op_sym(A_BCL,current_procinfo.gotlabel);
                instr.setcondition(cond);
                list.concat(instr);
                a_label(list,current_procinfo.gotlabel);
                list.concat(taicpu.op_reg_reg(A_MFSPR,current_procinfo.got,NR_LR));
                list.concat(taicpu.op_reg_reg(A_MTSPR,NR_LR,NR_R0));
              end;
            else
              begin
                a_reg_alloc(list,NR_R31);
                { place GOT ptr in r31 }
                list.concat(taicpu.op_reg_reg(A_MFSPR,NR_R31,NR_LR));
              end;
          end;
        { save the CR if necessary ( !!! always done currently ) }
        { still need to find out where this has to be done for SystemV
        a_reg_alloc(list,R_0);
        list.concat(taicpu.op_reg_reg(A_MFSPR,R_0,R_CR);
        list.concat(taicpu.op_reg_ref(A_STW,scratch_register,
          new_reference(STACK_POINTER_REG,LA_CR)));
        a_reg_dealloc(list,R_0); }
        { now comes the AltiVec context save, not yet implemented !!! }

        { if we're in a nested procedure, we've to save R11 }
        if current_procinfo.procdef.parast.symtablelevel>2 then
          begin
             reference_reset_base(href,NR_STACK_POINTER_REG,PARENT_FRAMEPOINTER_OFFSET);
             list.concat(taicpu.op_reg_ref(A_STW,NR_R11,href));
          end;

      end;

    procedure tcgppc.g_return_from_proc(list : taasmoutput;parasize : aword);
     { This procedure may be called before, as well as after g_stackframe_entry }
     { is called. NOTE registers are not to be allocated through the register   }
     { allocator here, because the register colouring has already occured !!    }

      var
         regcounter,firstregfpu,firstreggpr: TsuperRegister;
         href : treference;
         usesfpr,usesgpr,genret : boolean;
         regcounter2, firstfpureg:Tsuperregister;
         localsize: aword;
      begin
        { AltiVec context restore, not yet implemented !!! }

        usesfpr:=false;
        if not (po_assembler in current_procinfo.procdef.procoptions) then
          begin
            { FIXME: has to be R_F14 instad of R_F8 for SYSV-64bit }
            case target_info.abi of
              abi_powerpc_aix:
                firstfpureg := RS_F14;
              abi_powerpc_sysv:
                firstfpureg := RS_F9;
              else
                internalerror(2003122903);
            end;
            for regcounter:=firstfpureg to RS_F31 do
             begin
               if regcounter in rg[R_FPUREGISTER].used_in_proc then
                begin
                   usesfpr:=true;
                   firstregfpu:=regcounter;
                   break;
                end;
             end;
          end;

        usesgpr:=false;
        if not (po_assembler in current_procinfo.procdef.procoptions) then
          for regcounter2:=RS_R13 to RS_R31 do
            begin
              if regcounter2 in rg[R_INTREGISTER].used_in_proc then
                begin
                  usesgpr:=true;
                  firstreggpr:=regcounter2;
                  break;
                end;
            end;

        localsize:= tppcprocinfo(current_procinfo).calc_stackframe_size;

        { no return (blr) generated yet }
        genret:=true;
        if usesgpr or usesfpr then
          begin
             { address of gpr save area to r11 }
             a_op_const_reg_reg(list,OP_ADD,OS_ADDR,localsize,NR_STACK_POINTER_REG,NR_R12);
             if usesfpr then
               begin
                 reference_reset_base(href,NR_R12,-8);
                 for regcounter := firstregfpu to RS_F31 do
                  begin
                    if regcounter in rg[R_FPUREGISTER].used_in_proc then
                     begin
                       a_loadfpu_ref_reg(list,OS_F64,href,newreg(R_FPUREGISTER,regcounter,R_SUBNONE));
                       dec(href.offset,8);
                     end;
                  end;
                 inc(href.offset,4);
               end
             else
               reference_reset_base(href,NR_R12,-4);

            for regcounter2:=RS_R13 to RS_R31 do
              begin
                if regcounter2 in rg[R_INTREGISTER].used_in_proc then
                  begin
                     usesgpr:=true;
                     a_load_ref_reg(list,OS_INT,OS_INT,href,newreg(R_INTREGISTER,regcounter2,R_SUBNONE));
                     dec(href.offset,4);
                  end;
              end;

(*
             reference_reset_base(href,r2,-((NR_R31-ord(firstreggpr)) shr 8+1)*4);
             list.concat(taicpu.op_reg_ref(A_LMW,firstreggpr,href));
*)
          end;

(*
        { restore fprs and return }
        if usesfpr then
          begin
             { address of fpr save area to r11 }
             r:=NR_R12;
             list.concat(taicpu.op_reg_reg_const(A_ADDI,r,r,(ord(R_F31)-ord(firstregfpu.enum)+1)*8));
             {
             if (pi_do_call in current_procinfo.flags) then
               a_call_name(objectlibrary.newasmsymbol('_restfpr_'+tostr(ord(firstregfpu)-ord(R_F14)+14)+
                 '_x',AB_EXTERNAL,AT_FUNCTION))
             else
               { leaf node => lr haven't to be restored }
               a_call_name('_restfpr_'+tostr(ord(firstregfpu.enum)-ord(R_F14)+14)+
                 '_l');
             genret:=false;
             }
          end;
*)


        { if we didn't generate the return code, we've to do it now }
        if genret then
          begin
             { adjust r1 }
             a_op_const_reg(list,OP_ADD,OS_ADDR,localsize,NR_R1);
             { load link register? }
             if not (po_assembler in current_procinfo.procdef.procoptions) then
               begin
                 if (pi_do_call in current_procinfo.flags) then
                   begin
                      case target_info.abi of
                        abi_powerpc_aix:
                          reference_reset_base(href,NR_STACK_POINTER_REG,LA_LR_AIX);
                        abi_powerpc_sysv:
                          reference_reset_base(href,NR_STACK_POINTER_REG,LA_LR_SYSV);
                      end;
                      list.concat(taicpu.op_reg_ref(A_LWZ,NR_R0,href));
                      list.concat(taicpu.op_reg(A_MTLR,NR_R0));
                   end;

                 { restore the CR if necessary from callers frame}
                 if target_info.abi = abi_powerpc_aix then
                   if false then { Not needed at the moment. }
                     begin
                      reference_reset_base(href,NR_STACK_POINTER_REG,LA_CR_AIX);
                      list.concat(taicpu.op_reg_ref(A_LWZ,NR_R0,href));
                      list.concat(taicpu.op_reg_reg(A_MTSPR,NR_R0,NR_CR));
                      a_reg_dealloc(list,NR_R0);
                     end;
               end;

             list.concat(taicpu.op_none(A_BLR));
          end;
      end;

    function tcgppc.save_regs(list : taasmoutput):longint;
    {Generates code which saves used non-volatile registers in
     the save area right below the address the stackpointer point to.
     Returns the actual used save area size.}

     var regcounter,firstregfpu,firstreggpr: TSuperRegister;
         usesfpr,usesgpr: boolean;
         href : treference;
         offset: aint;
         regcounter2, firstfpureg: Tsuperregister;
    begin
      usesfpr:=false;
      if not (po_assembler in current_procinfo.procdef.procoptions) then
        begin
            { FIXME: has to be R_F14 instad of R_F8 for SYSV-64bit }
            case target_info.abi of
              abi_powerpc_aix:
                firstfpureg := RS_F14;
              abi_powerpc_sysv:
                firstfpureg := RS_F9;
              else
                internalerror(2003122903);
            end;
          for regcounter:=firstfpureg to RS_F31 do
           begin
             if regcounter in rg[R_FPUREGISTER].used_in_proc then
              begin
                 usesfpr:=true;
                 firstregfpu:=regcounter;
                 break;
              end;
           end;
        end;
      usesgpr:=false;
      if not (po_assembler in current_procinfo.procdef.procoptions) then
        for regcounter2:=RS_R13 to RS_R31 do
          begin
            if regcounter2 in rg[R_INTREGISTER].used_in_proc then
              begin
                 usesgpr:=true;
                 firstreggpr:=regcounter2;
                 break;
              end;
          end;
      offset:= 0;

      { save floating-point registers }
      if usesfpr then
        for regcounter := firstregfpu to RS_F31 do
          begin
            offset:= offset - 8;
            reference_reset_base(href, NR_STACK_POINTER_REG, offset);
            list.concat(taicpu.op_reg_ref(A_STFD, tregister(regcounter), href));
          end;
        (* Optimiztion in the future:  a_call_name(list,'_savefXX'); *)

      { save gprs in gpr save area }
      if usesgpr then
        if firstreggpr < RS_R30 then
          begin
            offset:= offset - 4 * (RS_R31 - firstreggpr + 1);
            reference_reset_base(href,NR_STACK_POINTER_REG,offset);
            list.concat(taicpu.op_reg_ref(A_STMW,tregister(firstreggpr),href));
              {STMW stores multiple registers}
          end
        else
          begin
            for regcounter := firstreggpr to RS_R31 do
              begin
                offset:= offset - 4;
                reference_reset_base(href, NR_STACK_POINTER_REG, offset);
                list.concat(taicpu.op_reg_ref(A_STW, newreg(R_INTREGISTER,regcounter,R_SUBWHOLE), href));
              end;
          end;

      { now comes the AltiVec context save, not yet implemented !!! }

      save_regs:= -offset;
    end;

    procedure tcgppc.restore_regs(list : taasmoutput);
    {Generates code which restores used non-volatile registers from
    the save area right below the address the stackpointer point to.}

     var regcounter,firstregfpu,firstreggpr: TSuperRegister;
         usesfpr,usesgpr: boolean;
         href : treference;
         offset: integer;
         regcounter2, firstfpureg: Tsuperregister;

    begin
      usesfpr:=false;
      if not (po_assembler in current_procinfo.procdef.procoptions) then
        begin
          { FIXME: has to be R_F14 instad of R_F8 for SYSV-64bit }
          case target_info.abi of
            abi_powerpc_aix:
              firstfpureg := RS_F14;
            abi_powerpc_sysv:
              firstfpureg := RS_F9;
            else
              internalerror(2003122903);
          end;
          for regcounter:=firstfpureg to RS_F31 do
           begin
             if regcounter in rg[R_FPUREGISTER].used_in_proc then
              begin
                 usesfpr:=true;
                 firstregfpu:=regcounter;
                 break;
              end;
           end;
        end;

      usesgpr:=false;
      if not (po_assembler in current_procinfo.procdef.procoptions) then
        for regcounter2:=RS_R13 to RS_R31 do
          begin
            if regcounter2 in rg[R_INTREGISTER].used_in_proc then
              begin
                 usesgpr:=true;
                 firstreggpr:=regcounter2;
                 break;
              end;
          end;

      offset:= 0;

      { restore fp registers }
      if usesfpr then
        for regcounter := firstregfpu to RS_F31 do
          begin
            offset:= offset - 8;
            reference_reset_base(href, NR_STACK_POINTER_REG, offset);
            list.concat(taicpu.op_reg_ref(A_LFD, newreg(R_FPUREGISTER,regcounter,R_SUBWHOLE), href));
          end;
        (* Optimiztion in the future: a_call_name(list,'_restfXX'); *)

      { restore gprs }
      if usesgpr then
        if firstreggpr < RS_R30 then
          begin
            offset:= offset - 4 * (RS_R31 - firstreggpr + 1);
            reference_reset_base(href,NR_STACK_POINTER_REG,offset); //-220
            list.concat(taicpu.op_reg_ref(A_LMW,tregister(firstreggpr),href));
              {LMW loads multiple registers}
          end
        else
          begin
            for regcounter := firstreggpr to RS_R31 do
              begin
                offset:= offset - 4;
                reference_reset_base(href, NR_STACK_POINTER_REG, offset);
                list.concat(taicpu.op_reg_ref(A_LWZ, newreg(R_INTREGISTER,regcounter,R_SUBWHOLE), href));
              end;
          end;

      { now comes the AltiVec context restore, not yet implemented !!! }
    end;


    procedure tcgppc.g_stackframe_entry_mac(list : taasmoutput;localsize : longint);
 (* NOT IN USE *)

 { generated the entry code of a procedure/function. Note: localsize is the }
 { sum of the size necessary for local variables and the maximum possible   }
 { combined size of ALL the parameters of a procedure called by the current }
 { one                                                                     }

     const
         macosLinkageAreaSize = 24;

     var regcounter: TRegister;
         href : treference;
         registerSaveAreaSize : longint;

      begin
        if (localsize mod 8) <> 0 then
          internalerror(58991);
        { CR and LR only have to be saved in case they are modified by the current }
        { procedure, but currently this isn't checked, so save them always         }
        { following is the entry code as described in "Altivec Programming }
        { Interface Manual", bar the saving of AltiVec registers           }
        a_reg_alloc(list,NR_STACK_POINTER_REG);
        a_reg_alloc(list,NR_R0);

        { save return address in callers frame}
        list.concat(taicpu.op_reg_reg(A_MFSPR,NR_R0,NR_LR));
        { ... in caller's frame }
        reference_reset_base(href,NR_STACK_POINTER_REG,8);
        list.concat(taicpu.op_reg_ref(A_STW,NR_R0,href));
        a_reg_dealloc(list,NR_R0);

        { save non-volatile registers in callers frame}
        registerSaveAreaSize:= save_regs(list);

        { save the CR if necessary in callers frame ( !!! always done currently ) }
        a_reg_alloc(list,NR_R0);
        list.concat(taicpu.op_reg_reg(A_MFSPR,NR_R0,NR_CR));
        reference_reset_base(href,NR_STACK_POINTER_REG,LA_CR_AIX);
        list.concat(taicpu.op_reg_ref(A_STW,NR_R0,href));
        a_reg_dealloc(list,NR_R0);

        (*
        { save pointer to incoming arguments }
        list.concat(taicpu.op_reg_reg_const(A_ORI,R_31,STACK_POINTER_REG,0));
        *)

        (*
        a_reg_alloc(list,R_12);

        { 0 or 8 based on SP alignment }
        list.concat(taicpu.op_reg_reg_const_const_const(A_RLWINM,
          R_12,STACK_POINTER_REG,0,28,28));
        { add in stack length }
        list.concat(taicpu.op_reg_reg_const(A_SUBFIC,R_12,R_12,
          -localsize));
        { establish new alignment }
        list.concat(taicpu.op_reg_reg_reg(A_STWUX,STACK_POINTER_REG,STACK_POINTER_REG,R_12));

        a_reg_dealloc(list,R_12);
        *)

        { allocate stack frame }
        localsize:= align(localsize + macosLinkageAreaSize + registerSaveAreaSize, 16);
        inc(localsize,tg.lasttemp);
        localsize:=align(localsize,16);
        //tppcprocinfo(current_procinfo).localsize:=localsize;

        if (localsize <> 0) then
          begin
            if (localsize <= high(smallint)) then
              begin
                reference_reset_base(href,NR_STACK_POINTER_REG,-localsize);
                a_load_store(list,A_STWU,NR_STACK_POINTER_REG,href);
              end
            else
              begin
                reference_reset_base(href,NR_STACK_POINTER_REG,0);
                href.index := NR_R11;
                a_reg_alloc(list,href.index);
                a_load_const_reg(list,OS_S32,-localsize,href.index);
                a_load_store(list,A_STWUX,NR_STACK_POINTER_REG,href);
                a_reg_dealloc(list,href.index);
              end;
          end;
      end;

    procedure tcgppc.g_return_from_proc_mac(list : taasmoutput;parasize : aword);
 (* NOT IN USE *)

      var
        href : treference;
      begin
        a_reg_alloc(list,NR_R0);

        { restore stack pointer }
        reference_reset_base(href,NR_STACK_POINTER_REG,LA_SP);
        list.concat(taicpu.op_reg_ref(A_LWZ,NR_STACK_POINTER_REG,href));
        (*
        list.concat(taicpu.op_reg_reg_const(A_ORI,NR_STACK_POINTER_REG,R_31,0));
        *)

        { restore the CR if necessary from callers frame
            ( !!! always done currently ) }
        reference_reset_base(href,NR_STACK_POINTER_REG,LA_CR_AIX);
        list.concat(taicpu.op_reg_ref(A_LWZ,NR_R0,href));
        list.concat(taicpu.op_reg_reg(A_MTSPR,NR_R0,NR_CR));
        a_reg_dealloc(list,NR_R0);

        (*
        { restore return address from callers frame }
        reference_reset_base(href,STACK_POINTER_REG,8);
        list.concat(taicpu.op_reg_ref(A_LWZ,R_0,href));
        *)

        { restore non-volatile registers from callers frame }
        restore_regs(list);

        (*
        { return to caller }
        list.concat(taicpu.op_reg_reg(A_MTSPR,R_0,R_LR));
        list.concat(taicpu.op_none(A_BLR));
        *)

        { restore return address from callers frame }
        reference_reset_base(href,NR_STACK_POINTER_REG,8);
        list.concat(taicpu.op_reg_ref(A_LWZ,NR_R0,href));

        { return to caller }
        list.concat(taicpu.op_reg_reg(A_MTSPR,NR_R0,NR_LR));
        list.concat(taicpu.op_none(A_BLR));
      end;


    procedure tcgppc.g_restore_frame_pointer(list : taasmoutput);

      begin
         { no frame pointer on the PowerPC (maybe there is one in the SystemV ABI?)}
      end;


     procedure tcgppc.a_loadaddr_ref_reg(list : taasmoutput;const ref : treference;r : tregister);

       var
         ref2, tmpref: treference;
         freereg: boolean;
         tmpreg:Tregister;

       begin
         ref2 := ref;
         freereg := fixref(list,ref2);
         if assigned(ref2.symbol) then
           begin
             if target_info.system = system_powerpc_macos then
               begin
                 if macos_direct_globals then
                   begin
                     reference_reset(tmpref);
                     tmpref.offset := ref2.offset;
                     tmpref.symbol := ref2.symbol;
                     tmpref.base := NR_NO;
                     list.concat(taicpu.op_reg_reg_ref(A_ADDI,r,NR_RTOC,tmpref));
                   end
                 else
                   begin
                     reference_reset(tmpref);
                     tmpref.symbol := ref2.symbol;
                     tmpref.offset := 0;
                     tmpref.base := NR_RTOC;
                     list.concat(taicpu.op_reg_ref(A_LWZ,r,tmpref));

                     if ref2.offset <> 0 then
                       begin
                         reference_reset(tmpref);
                         tmpref.offset := ref2.offset;
                         tmpref.base:= r;
                         list.concat(taicpu.op_reg_ref(A_LA,r,tmpref));
                       end;
                   end;

                 if ref2.base <> NR_NO then
                   list.concat(taicpu.op_reg_reg_reg(A_ADD,r,r,ref2.base));

                 //list.concat(tai_comment.create(strpnew('*** a_loadaddr_ref_reg')));
               end
             else
               begin

                 { add the symbol's value to the base of the reference, and if the }
                 { reference doesn't have a base, create one                       }
                 reference_reset(tmpref);
                 tmpref.offset := ref2.offset;
                 tmpref.symbol := ref2.symbol;
                 tmpref.relsymbol := ref2.relsymbol;
                 tmpref.refaddr := addr_hi;
                 if ref2.base<> NR_NO then
                   begin
                     list.concat(taicpu.op_reg_reg_ref(A_ADDIS,r,
                       ref2.base,tmpref));
                     if freereg then
                       begin
                         rg[R_INTREGISTER].ungetregister(list,ref2.base);
                         freereg := false;
                       end;
                   end
                 else
                   list.concat(taicpu.op_reg_ref(A_LIS,r,tmpref));
                 tmpref.base := NR_NO;
                 tmpref.refaddr := addr_lo;
                 { can be folded with one of the next instructions by the }
                 { optimizer probably                                     }
                 list.concat(taicpu.op_reg_reg_ref(A_ADDI,r,r,tmpref));
               end
           end
         else if ref2.offset <> 0 Then
           if ref2.base <> NR_NO then
             a_op_const_reg_reg(list,OP_ADD,OS_32,aword(ref2.offset),ref2.base,r)
           { FixRef makes sure that "(ref.index <> R_NO) and (ref.offset <> 0)" never}
           { occurs, so now only ref.offset has to be loaded                         }
           else
             a_load_const_reg(list,OS_32,ref2.offset,r)
         else if ref.index <> NR_NO Then
           list.concat(taicpu.op_reg_reg_reg(A_ADD,r,ref2.base,ref2.index))
         else if (ref2.base <> NR_NO) and
                 (r <> ref2.base) then
           a_load_reg_reg(list,OS_ADDR,OS_ADDR,ref2.base,r)
         else
           list.concat(taicpu.op_reg_const(A_LI,r,0));
         if freereg then
           rg[R_INTREGISTER].ungetregister(list,ref2.base);
       end;

{ ************* concatcopy ************ }

{$ifndef ppc603}
  const
    maxmoveunit = 8;
{$else ppc603}
  const
    maxmoveunit = 4;
{$endif ppc603}

    procedure tcgppc.g_concatcopy(list : taasmoutput;const source,dest : treference;len : aword; delsource,loadref : boolean);

      var
        countreg: TRegister;
        src, dst: TReference;
        lab: tasmlabel;
        count, count2: aword;
        orgsrc, orgdst: boolean;
        size: tcgsize;

      begin
{$ifdef extdebug}
        if len > high(longint) then
          internalerror(2002072704);
{$endif extdebug}

        { make sure short loads are handled as optimally as possible }
        if not loadref then
          if (len <= maxmoveunit) and
             (byte(len) in [1,2,4,8]) then
            begin
              if len < 8 then
                begin
                  size := int_cgsize(len);
                  a_load_ref_ref(list,size,size,source,dest);
                  if delsource then
                    begin
                      reference_release(list,source);
                      tg.ungetiftemp(list,source);
                    end;
                end
              else
                begin
                  a_reg_alloc(list,NR_F0);
                  a_loadfpu_ref_reg(list,OS_F64,source,NR_F0);
                  if delsource then
                    begin
                      reference_release(list,source);
                      tg.ungetiftemp(list,source);
                    end;
                  a_loadfpu_reg_ref(list,OS_F64,NR_F0,dest);
                  a_reg_dealloc(list,NR_F0);
                end;
              exit;
            end;

        count := len div maxmoveunit;

        reference_reset(src);
        reference_reset(dst);
        { load the address of source into src.base }
        if loadref then
          begin
            src.base := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
            a_load_ref_reg(list,OS_32,OS_32,source,src.base);
            orgsrc := false;
          end
        else if (count > 4) or
                not issimpleref(source) or
                ((source.index <> NR_NO) and
                 ((source.offset + longint(len)) > high(smallint))) then
          begin
            src.base := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
            a_loadaddr_ref_reg(list,source,src.base);
            orgsrc := false;
          end
        else
          begin
            src := source;
            orgsrc := true;
          end;
        if not orgsrc and delsource then
          reference_release(list,source);
        { load the address of dest into dst.base }
        if (count > 4) or
           not issimpleref(dest) or
           ((dest.index <> NR_NO) and
            ((dest.offset + longint(len)) > high(smallint))) then
          begin
            dst.base := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
            a_loadaddr_ref_reg(list,dest,dst.base);
            orgdst := false;
          end
        else
          begin
            dst := dest;
            orgdst := true;
          end;

{$ifndef ppc603}
        if count > 4 then
          { generate a loop }
          begin
            { the offsets are zero after the a_loadaddress_ref_reg and just }
            { have to be set to 8. I put an Inc there so debugging may be   }
            { easier (should offset be different from zero here, it will be }
            { easy to notice in the generated assembler                     }
            inc(dst.offset,8);
            inc(src.offset,8);
            list.concat(taicpu.op_reg_reg_const(A_SUBI,src.base,src.base,8));
            list.concat(taicpu.op_reg_reg_const(A_SUBI,dst.base,dst.base,8));
            countreg := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
            a_load_const_reg(list,OS_32,count,countreg);
            { explicitely allocate R_0 since it can be used safely here }
            { (for holding date that's being copied)                    }
            a_reg_alloc(list,NR_F0);
            objectlibrary.getlabel(lab);
            a_label(list, lab);
            list.concat(taicpu.op_reg_reg_const(A_SUBIC_,countreg,countreg,1));
            list.concat(taicpu.op_reg_ref(A_LFDU,NR_F0,src));
            list.concat(taicpu.op_reg_ref(A_STFDU,NR_F0,dst));
            a_jmp(list,A_BC,C_NE,0,lab);
            rg[R_INTREGISTER].ungetregister(list,countreg);
            a_reg_dealloc(list,NR_F0);
            len := len mod 8;
          end;

        count := len div 8;
        if count > 0 then
          { unrolled loop }
          begin
            a_reg_alloc(list,NR_F0);
            for count2 := 1 to count do
              begin
                a_loadfpu_ref_reg(list,OS_F64,src,NR_F0);
                a_loadfpu_reg_ref(list,OS_F64,NR_F0,dst);
                inc(src.offset,8);
                inc(dst.offset,8);
              end;
            a_reg_dealloc(list,NR_F0);
            len := len mod 8;
          end;

        if (len and 4) <> 0 then
          begin
            a_reg_alloc(list,NR_R0);
            a_load_ref_reg(list,OS_32,OS_32,src,NR_R0);
            a_load_reg_ref(list,OS_32,OS_32,NR_R0,dst);
            inc(src.offset,4);
            inc(dst.offset,4);
            a_reg_dealloc(list,NR_R0);
          end;
{$else not ppc603}
        if count > 4 then
          { generate a loop }
          begin
            { the offsets are zero after the a_loadaddress_ref_reg and just }
            { have to be set to 4. I put an Inc there so debugging may be   }
            { easier (should offset be different from zero here, it will be }
            { easy to notice in the generated assembler                     }
            inc(dst.offset,4);
            inc(src.offset,4);
            list.concat(taicpu.op_reg_reg_const(A_SUBI,src.base,src.base,4));
            list.concat(taicpu.op_reg_reg_const(A_SUBI,dst.base,dst.base,4));
            countreg := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
            a_load_const_reg(list,OS_32,count,countreg);
            { explicitely allocate R_0 since it can be used safely here }
            { (for holding date that's being copied)                    }
            a_reg_alloc(list,NR_R0);
            objectlibrary.getlabel(lab);
            a_label(list, lab);
            list.concat(taicpu.op_reg_reg_const(A_SUBIC_,countreg,countreg,1));
            list.concat(taicpu.op_reg_ref(A_LWZU,NR_R0,src));
            list.concat(taicpu.op_reg_ref(A_STWU,NR_R0,dst));
            a_jmp(list,A_BC,C_NE,0,lab);
            rg[R_INTREGISTER].ungetregister(list,countreg);
            a_reg_dealloc(list,NR_R0);
            len := len mod 4;
          end;

        count := len div 4;
        if count > 0 then
          { unrolled loop }
          begin
            a_reg_alloc(list,NR_R0);
            for count2 := 1 to count do
              begin
                a_load_ref_reg(list,OS_32,OS_32,src,NR_R0);
                a_load_reg_ref(list,OS_32,OS_32,NR_R0,dst);
                inc(src.offset,4);
                inc(dst.offset,4);
              end;
            a_reg_dealloc(list,NR_R0);
            len := len mod 4;
          end;
{$endif not ppc603}
       { copy the leftovers }
       if (len and 2) <> 0 then
         begin
           a_reg_alloc(list,NR_R0);
           a_load_ref_reg(list,OS_16,OS_16,src,NR_R0);
           a_load_reg_ref(list,OS_16,OS_16,NR_R0,dst);
           inc(src.offset,2);
           inc(dst.offset,2);
           a_reg_dealloc(list,NR_R0);
         end;
       if (len and 1) <> 0 then
         begin
           a_reg_alloc(list,NR_R0);
           a_load_ref_reg(list,OS_8,OS_8,src,NR_R0);
           a_load_reg_ref(list,OS_8,OS_8,NR_R0,dst);
           a_reg_dealloc(list,NR_R0);
         end;
       if orgsrc then
         begin
           if delsource then
             reference_release(list,source);
         end
       else
         rg[R_INTREGISTER].ungetregister(list,src.base);
       if not orgdst then
         rg[R_INTREGISTER].ungetregister(list,dst.base);
       if delsource then
         tg.ungetiftemp(list,source);
      end;


    procedure tcgppc.g_overflowcheck(list: taasmoutput; const l: tlocation; def: tdef);
      var
         hl : tasmlabel;
      begin
         if not(cs_check_overflow in aktlocalswitches) then
          exit;
         objectlibrary.getlabel(hl);
         if not ((def.deftype=pointerdef) or
                ((def.deftype=orddef) and
                 (torddef(def).typ in [u64bit,u16bit,u32bit,u8bit,uchar,
                                                  bool8bit,bool16bit,bool32bit]))) then
           begin
             list.concat(taicpu.op_reg(A_MCRXR,NR_CR7));
             a_jmp(list,A_BC,C_NO,7,hl)
           end
         else
           a_jmp_cond(list,OC_AE,hl);
         a_call_name(list,'FPC_OVERFLOW');
         a_label(list,hl);
      end;


{***************** This is private property, keep out! :) *****************}

    function tcgppc.issimpleref(const ref: treference): boolean;

      begin
        if (ref.base = NR_NO) and
           (ref.index <> NR_NO) then
          internalerror(200208101);
        result :=
          not(assigned(ref.symbol)) and
          (((ref.index = NR_NO) and
            (ref.offset >= low(smallint)) and
            (ref.offset <= high(smallint))) or
           ((ref.index <> NR_NO) and
            (ref.offset = 0)));
      end;


    function tcgppc.fixref(list: taasmoutput; var ref: treference): boolean;

       var
         tmpreg: tregister;
         orgindex: tregister;
       begin
         result := false;
         if (ref.base = NR_NO) then
           begin
             ref.base := ref.index;
             ref.base := NR_NO;
           end;
         if (ref.base <> NR_NO) then
           begin
             if (ref.index <> NR_NO) and
                ((ref.offset <> 0) or assigned(ref.symbol)) then
               begin
                 result := true;
                 tmpreg := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
                 list.concat(taicpu.op_reg_reg_reg(
                   A_ADD,tmpreg,ref.base,ref.index));
                 ref.index := NR_NO;
                 ref.base := tmpreg;
               end
           end
         else
           if ref.index <> NR_NO then
             internalerror(200208102);
       end;


    { find out whether a is of the form 11..00..11b or 00..11...00. If }
    { that's the case, we can use rlwinm to do an AND operation        }
    function tcgppc.get_rlwi_const(a: aword; var l1, l2: longint): boolean;

      var
        temp : longint;
        testbit : aword;
        compare: boolean;

      begin
        get_rlwi_const := false;
        if (a = 0) or (a = $ffffffff) then
          exit;
        { start with the lowest bit }
        testbit := 1;
        { check its value }
        compare := boolean(a and testbit);
        { find out how long the run of bits with this value is            }
        { (it's impossible that all bits are 1 or 0, because in that case }
        { this function wouldn't have been called)                        }
        l1 := 31;
        while (((a and testbit) <> 0) = compare) do
          begin
            testbit := testbit shl 1;
            dec(l1);
          end;

        { check the length of the run of bits that comes next }
        compare := not compare;
        l2 := l1;
        while (((a and testbit) <> 0) = compare) and
               (l2 >= 0) do
          begin
            testbit := testbit shl 1;
            dec(l2);
          end;

        { and finally the check whether the rest of the bits all have the }
        { same value                                                      }
        compare := not compare;
        temp := l2;
        if temp >= 0 then
          if (a shr (31-temp)) <> ((-ord(compare)) shr (31-temp)) then
            exit;

        { we have done "not(not(compare))", so compare is back to its   }
        { initial value. If the lowest bit was 0, a is of the form      }
        { 00..11..00 and we need "rlwinm reg,reg,0,l2+1,l1", (+1        }
        { because l2 now contains the position of the last zero of the  }
        { first run instead of that of the first 1) so switch l1 and l2 }
        { in that case (we will generate "rlwinm reg,reg,0,l1,l2")      }
        if not compare then
          begin
            temp := l1;
            l1 := l2+1;
            l2 := temp;
          end
        else
          { otherwise, l1 currently contains the position of the last   }
          { zero instead of that of the first 1 of the second run -> +1 }
          inc(l1);
        { the following is the same as "if l1 = -1 then l1 := 31;" }
        l1 := l1 and 31;
        l2 := l2 and 31;
        get_rlwi_const := true;
      end;


    procedure tcgppc.a_load_store(list:taasmoutput;op: tasmop;reg:tregister;
       ref: treference);

      var
        tmpreg: tregister;
        tmpref: treference;
        largeOffset: Boolean;

      begin
        tmpreg := NR_NO;

        if target_info.system = system_powerpc_macos then
          begin
            largeOffset:= (cardinal(ref.offset-low(smallint)) >
                  high(smallint)-low(smallint));

            if assigned(ref.symbol) then
              begin {Load symbol's value}
                tmpreg := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);

                reference_reset(tmpref);
                tmpref.symbol := ref.symbol;
                tmpref.base := NR_RTOC;

                if macos_direct_globals then
                  list.concat(taicpu.op_reg_ref(A_LA,tmpreg,tmpref))
                else
                  list.concat(taicpu.op_reg_ref(A_LWZ,tmpreg,tmpref));
              end;

            if largeOffset then
              begin {Add hi part of offset}
                reference_reset(tmpref);
                tmpref.offset := Hi(ref.offset);

                if (tmpreg <> NR_NO) then
                  list.concat(taicpu.op_reg_reg_ref(A_ADDIS,tmpreg, tmpreg,tmpref))
                else
                  begin
                    tmpreg := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
                    list.concat(taicpu.op_reg_ref(A_LIS,tmpreg,tmpref));
                  end;
              end;

            if (tmpreg <> NR_NO) then
              begin
                {Add content of base register}
                if ref.base <> NR_NO then
                  list.concat(taicpu.op_reg_reg_reg(A_ADD,tmpreg,
                    ref.base,tmpreg));

                {Make ref ready to be used by op}
                ref.symbol:= nil;
                ref.base:= tmpreg;
                if largeOffset then
                  ref.offset := Lo(ref.offset);
                list.concat(taicpu.op_reg_ref(op,reg,ref));
                //list.concat(tai_comment.create(strpnew('*** a_load_store indirect global')));
              end
            else
              list.concat(taicpu.op_reg_ref(op,reg,ref));
          end
        else {if target_info.system <> system_powerpc_macos}
          begin
            if assigned(ref.symbol) or
               (cardinal(ref.offset-low(smallint)) >
                high(smallint)-low(smallint)) then
              begin
                tmpreg := rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
                reference_reset(tmpref);
                tmpref.symbol := ref.symbol;
                tmpref.relsymbol := ref.relsymbol;
                tmpref.offset := ref.offset;
                tmpref.refaddr := addr_hi;
                if ref.base <> NR_NO then
                  list.concat(taicpu.op_reg_reg_ref(A_ADDIS,tmpreg,
                    ref.base,tmpref))
                else
                  list.concat(taicpu.op_reg_ref(A_LIS,tmpreg,tmpref));
                ref.base := tmpreg;
                ref.refaddr := addr_lo;
                list.concat(taicpu.op_reg_ref(op,reg,ref));
              end
            else
              list.concat(taicpu.op_reg_ref(op,reg,ref));
          end;

        if (tmpreg <> NR_NO) then
          rg[R_INTREGISTER].ungetregister(list,tmpreg);
      end;


    procedure tcgppc.a_jmp(list: taasmoutput; op: tasmop; c: tasmcondflag;
                crval: longint; l: tasmlabel);
      var
        p: taicpu;

      begin
        p := taicpu.op_sym(op,objectlibrary.newasmsymbol(l.name,AB_EXTERNAL,AT_FUNCTION));
        if op <> A_B then
          create_cond_norm(c,crval,p.condition);
        p.is_jmp := true;
        list.concat(p)
      end;


    procedure tcg64fppc.a_op64_reg_reg(list : taasmoutput;op:TOpCG;regsrc,regdst : tregister64);
      begin
        a_op64_reg_reg_reg(list,op,regsrc,regdst,regdst);
      end;


    procedure tcg64fppc.a_op64_const_reg(list : taasmoutput;op:TOpCG;value : qword;reg : tregister64);
      begin
        a_op64_const_reg_reg(list,op,value,reg,reg);
      end;


    procedure tcg64fppc.a_op64_reg_reg_reg(list: taasmoutput;op:TOpCG;regsrc1,regsrc2,regdst : tregister64);
      begin
        case op of
          OP_AND,OP_OR,OP_XOR:
            begin
              cg.a_op_reg_reg_reg(list,op,OS_32,regsrc1.reglo,regsrc2.reglo,regdst.reglo);
              cg.a_op_reg_reg_reg(list,op,OS_32,regsrc1.reghi,regsrc2.reghi,regdst.reghi);
            end;
          OP_ADD:
            begin
              list.concat(taicpu.op_reg_reg_reg(A_ADDC,regdst.reglo,regsrc1.reglo,regsrc2.reglo));
              list.concat(taicpu.op_reg_reg_reg(A_ADDE,regdst.reghi,regsrc1.reghi,regsrc2.reghi));
            end;
          OP_SUB:
            begin
              list.concat(taicpu.op_reg_reg_reg(A_SUBC,regdst.reglo,regsrc2.reglo,regsrc1.reglo));
              list.concat(taicpu.op_reg_reg_reg(A_SUBFE,regdst.reghi,regsrc1.reghi,regsrc2.reghi));
            end;
          else
            internalerror(2002072801);
        end;
      end;


    procedure tcg64fppc.a_op64_const_reg_reg(list: taasmoutput;op:TOpCG;value : qword;regsrc,regdst : tregister64);

      const
        ops: array[boolean,1..3] of tasmop = ((A_ADDIC,A_ADDC,A_ADDZE),
                                              (A_SUBIC,A_SUBC,A_ADDME));
      var
        tmpreg: tregister;
        tmpreg64: tregister64;
        issub: boolean;
      begin
        case op of
          OP_AND,OP_OR,OP_XOR:
            begin
              cg.a_op_const_reg_reg(list,op,OS_32,aword(value),regsrc.reglo,regdst.reglo);
              cg.a_op_const_reg_reg(list,op,OS_32,aword(value shr 32),regsrc.reghi,
                regdst.reghi);
            end;
          OP_ADD, OP_SUB:
            begin
              if (int64(value) < 0) then
                begin
                  if op = OP_ADD then
                    op := OP_SUB
                  else
                    op := OP_ADD;
                  int64(value) := -int64(value);
                end;
              if (longint(value) <> 0) then
                begin
                  issub := op = OP_SUB;
                  if (int64(value) > 0) and
                     (int64(value)-ord(issub) <= 32767) then
                    begin
                      list.concat(taicpu.op_reg_reg_const(ops[issub,1],
                        regdst.reglo,regsrc.reglo,longint(value)));
                      list.concat(taicpu.op_reg_reg(ops[issub,3],
                        regdst.reghi,regsrc.reghi));
                    end
                  else if ((value shr 32) = 0) then
                    begin
                      tmpreg := tcgppc(cg).rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
                      cg.a_load_const_reg(list,OS_32,cardinal(value),tmpreg);
                      list.concat(taicpu.op_reg_reg_reg(ops[issub,2],
                        regdst.reglo,regsrc.reglo,tmpreg));
                      tcgppc(cg).rg[R_INTREGISTER].ungetregister(list,tmpreg);
                      list.concat(taicpu.op_reg_reg(ops[issub,3],
                        regdst.reghi,regsrc.reghi));
                    end
                  else
                    begin
                      tmpreg64.reglo := tcgppc(cg).rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
                      tmpreg64.reghi := tcgppc(cg).rg[R_INTREGISTER].getregister(list,R_SUBWHOLE);
                      a_load64_const_reg(list,value,tmpreg64);
                      a_op64_reg_reg_reg(list,op,tmpreg64,regsrc,regdst);
                      tcgppc(cg).rg[R_INTREGISTER].ungetregister(list,tmpreg64.reglo);
                      tcgppc(cg).rg[R_INTREGISTER].ungetregister(list,tmpreg64.reghi);
                    end
                end
              else
                begin
                  cg.a_load_reg_reg(list,OS_INT,OS_INT,regsrc.reglo,regdst.reglo);
                  cg.a_op_const_reg_reg(list,op,OS_32,aword(value shr 32),regsrc.reghi,
                    regdst.reghi);
                end;
            end;
          else
            internalerror(2002072802);
        end;
      end;


begin
  cg := tcgppc.create;
  cg64 :=tcg64fppc.create;
end.
{
  $Log$
  Revision 1.167  2004-03-02 17:48:32  florian
    * got entry code fixed

  Revision 1.166  2004/03/02 17:32:12  florian
    * make cycle fixed
    + pic support for darwin
    + support of importing vars from shared libs on darwin implemented

  Revision 1.165  2004/03/02 00:36:33  olle
    * big transformation of Tai_[const_]Symbol.Create[data]name*

  Revision 1.164  2004/02/27 10:21:05  florian
    * top_symbol killed
    + refaddr to treference added
    + refsymbol to treference added
    * top_local stuff moved to an extra record to save memory
    + aint introduced
    * tppufile.get/putint64/aint implemented

  Revision 1.163  2004/02/09 22:45:49  florian
    * compilation fixed

  Revision 1.162  2004/02/09 20:44:40  olle
    * macos: a_load_store fixed to only allocat temp reg if needed, side effect is compiler work for macos again.

  Revision 1.161  2004/02/08 20:15:42  jonas
    - removed taicpu.is_reg_move because it's not used anymore
    + support tracking fpu register moves by rgobj for the ppc

  Revision 1.160  2004/02/08 14:50:13  jonas
    * fixed previous commit

  Revision 1.159  2004/02/07 15:01:05  jonas
    * changed an explicit mr to a_load_reg_reg so it's registered with the
      register allocator as move

  Revision 1.158  2004/02/04 22:01:13  peter
    * first try to get cpupara working for x86_64

  Revision 1.157  2004/02/03 19:49:24  jonas
    - removed mov "reg, reg" optimizations, as they are removed by the
      register allocator and may be necessary to indicate a register may not
      be reused before some point

  Revision 1.156  2004/01/25 16:36:34  jonas
    - removed double construction of fpu register allocator

  Revision 1.155  2004/01/12 22:11:38  peter
    * use localalign info for alignment for locals and temps
    * sparc fpu flags branching added
    * moved powerpc copy_valye_openarray to generic

  Revision 1.154  2003/12/29 14:17:50  jonas
    * fixed saving/restoring of volatile fpu registers under sysv
    + better provisions for abi differences regarding fpu registers that have
      to be saved

  Revision 1.153  2003/12/29 11:13:53  jonas
    * fixed tb0350 (support loading address of reference containing the
      address 0)

  Revision 1.152  2003/12/28 23:49:30  jonas
    * fixed tnotnode for < 32 bit quantities

  Revision 1.151  2003/12/28 19:22:27  florian
    * handling of open array value parameters fixed

  Revision 1.150  2003/12/26 14:02:30  peter
    * sparc updates
    * use registertype in spill_register

  Revision 1.149  2003/12/18 01:03:52  florian
    + register allocators are set to nil now after they are freed

  Revision 1.148  2003/12/16 21:49:47  florian
    * fixed ppc compilation

  Revision 1.147  2003/12/15 21:37:09  jonas
    * fixed compilation and simplified fixref, so it never has to reallocate
      already freed registers anymore

  Revision 1.146  2003/12/12 17:16:18  peter
    * rg[tregistertype] added in tcg

  Revision 1.145  2003/12/10 00:09:57  karoly
   * fixed compilation with -dppc603

  Revision 1.144  2003/12/09 20:39:43  jonas
    * forgot call to cg.g_overflowcheck() in nppcadd
    * fixed overflow flag definition
    * fixed cg.g_overflowcheck() for signed numbers (jump over call to
      FPC_OVERFLOW if *no* overflow instead of if overflow :)

  Revision 1.143  2003/12/07 21:59:21  florian
    * a_load_ref_ref isn't allowed to be used in g_stackframe_entry

  Revision 1.142  2003/12/06 22:13:53  jonas
    * another fix to a_load_ref_reg()
    + implemented uses_registers() method

  Revision 1.141  2003/12/05 22:53:28  jonas
    * fixed load_ref_reg for source > dest size

  Revision 1.140  2003/12/04 20:37:02  jonas
    * fixed some int<->boolean type conversion issues

  Revision 1.139  2003/11/30 11:32:12  jonas
    * fixded fixref() regarding the reallocation of already freed registers
      used in references

  Revision 1.138  2003/11/30 10:16:05  jonas
    * fixed fpu regallocator initialisation

  Revision 1.137  2003/11/21 16:29:26  florian
    * fixed reading of reg. sets in the arm assembler reader

  Revision 1.136  2003/11/02 17:19:33  florian
    + copying of open array value parameters to the heap implemented

  Revision 1.135  2003/11/02 15:20:06  jonas
    * fixed releasing of references (ppc also has a base and an index, not
      just a base)

  Revision 1.134  2003/10/19 01:34:30  florian
    * some ppc stuff fixed
    * memory leak fixed

  Revision 1.133  2003/10/17 15:25:18  florian
    * fixed more ppc stuff

  Revision 1.132  2003/10/17 15:08:34  peter
    * commented out more obsolete constants

  Revision 1.131  2003/10/17 14:52:07  peter
    * fixed ppc build

  Revision 1.130  2003/10/17 01:22:08  florian
    * compilation of the powerpc compiler fixed

  Revision 1.129  2003/10/13 01:58:04  florian
    * some ideas for mm support implemented

  Revision 1.128  2003/10/11 16:06:42  florian
    * fixed some MMX<->SSE
    * started to fix ppc, needs an overhaul
    + stabs info improve for spilling, not sure if it works correctly/completly
    - MMX_SUPPORT removed from Makefile.fpc

  Revision 1.127  2003/10/01 20:34:49  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.126  2003/09/14 16:37:20  jonas
    * fixed some ppc problems

  Revision 1.125  2003/09/03 21:04:14  peter
    * some fixes for ppc

  Revision 1.124  2003/09/03 19:35:24  peter
    * powerpc compiles again

  Revision 1.123  2003/09/03 15:55:01  peter
    * NEWRA branch merged

  Revision 1.122.2.1  2003/08/31 21:08:16  peter
    * first batch of sparc fixes

  Revision 1.122  2003/08/18 21:27:00  jonas
    * some newra optimizations (eliminate lots of moves between registers)

  Revision 1.121  2003/08/18 11:50:55  olle
    + cleaning up in proc entry and exit, now calc_stack_frame always is used.

  Revision 1.120  2003/08/17 16:59:20  jonas
    * fixed regvars so they work with newra (at least for ppc)
    * fixed some volatile register bugs
    + -dnotranslation option for -dnewra, which causes the registers not to
      be translated from virtual to normal registers. Requires support in
      the assembler writer as well, which is only implemented in aggas/
      agppcgas currently

  Revision 1.119  2003/08/11 21:18:20  peter
    * start of sparc support for newra

  Revision 1.118  2003/08/08 15:50:45  olle
    * merged macos entry/exit code generation into the general one.

  Revision 1.117  2002/10/01 05:24:28  olle
    * made a_load_store more robust and to accept large offsets and cleaned up code

  Revision 1.116  2003/07/23 11:02:23  jonas
    * don't use rg.getregisterint() anymore in g_stackframe_entry_*, because
      the register colouring has already occurred then, use a hard-coded
      register instead

  Revision 1.115  2003/07/20 20:39:20  jonas
    * fixed newra bug due to the fact that we sometimes need a temp reg
      when loading/storing to memory (base+index+offset is not possible)
      and because a reference is often freed before it is last used, this
      temp register was soemtimes the same as one of the reference regs

  Revision 1.114  2003/07/20 16:15:58  jonas
    * fixed bug in g_concatcopy with -dnewra

  Revision 1.113  2003/07/06 20:25:03  jonas
    * fixed ppc compiler

  Revision 1.112  2003/07/05 20:11:42  jonas
    * create_paraloc_info() is now called separately for the caller and
      callee info
    * fixed ppc cycle

  Revision 1.111  2003/07/02 22:18:04  peter
    * paraloc splitted in callerparaloc,calleeparaloc
    * sparc calling convention updates

  Revision 1.110  2003/06/18 10:12:36  olle
    * macos: fixes of loading-code

  Revision 1.109  2003/06/14 22:32:43  jonas
    * ppc compiles with -dnewra, haven't tried to compile anything with it
      yet though

  Revision 1.108  2003/06/13 21:19:31  peter
    * current_procdef removed, use current_procinfo.procdef instead

  Revision 1.107  2003/06/09 14:54:26  jonas
    * (de)allocation of registers for parameters is now performed properly
      (and checked on the ppc)
    - removed obsolete allocation of all parameter registers at the start
      of a procedure (and deallocation at the end)

  Revision 1.106  2003/06/08 18:19:27  jonas
    - removed duplicate identifier

  Revision 1.105  2003/06/07 18:57:04  jonas
    + added freeintparaloc
    * ppc get/freeintparaloc now check whether the parameter regs are
      properly allocated/deallocated (and get an extra list para)
    * ppc a_call_* now internalerrors if pi_do_call is not yet set
    * fixed lot of missing pi_do_call's

  Revision 1.104  2003/06/04 11:58:58  jonas
    * calculate localsize also in g_return_from_proc since it's now called
      before g_stackframe_entry (still have to fix macos)
    * compilation fixes (cycle doesn't work yet though)

  Revision 1.103  2003/06/01 21:38:06  peter
    * getregisterfpu size parameter added
    * op_const_reg size parameter added
    * sparc updates

  Revision 1.102  2003/06/01 13:42:18  jonas
    * fix for bug in fixref that Peter found during the Sparc conversion

  Revision 1.101  2003/05/30 18:52:10  jonas
    * fixed bug with intregvars
    * locapara.loc can also be LOC_CFPUREGISTER -> also fixed
      rcgppc.a_param_ref, which previously got bogus size values

  Revision 1.100  2003/05/29 21:17:27  jonas
    * compile with -dppc603 to not use unaligned float loads in move() and
      g_concatcopy, because the 603 and 604 take an exception for those
      (and netbsd doesn't even handle those in the kernel). There are
      still some of those left that could cause problems though (e.g.
      in the set helpers)

  Revision 1.99  2003/05/29 10:06:09  jonas
    * also free temps in g_concatcopy if delsource is true

  Revision 1.98  2003/05/28 23:58:18  jonas
    * added missing initialization of rg.usedintin,byproc
    * ppc now also saves/restores used fpu registers
    * ncgcal doesn't add used registers to usedby/inproc anymore, except for
      i386

  Revision 1.97  2003/05/28 23:18:31  florian
    * started to fix and clean up the sparc port

  Revision 1.96  2003/05/24 11:59:42  jonas
    * fixed integer typeconversion problems

  Revision 1.95  2003/05/23 18:51:26  jonas
    * fixed support for nested procedures and more parameters than those
      which fit in registers (untested/probably not working: calling a
      nested procedure from a deeper nested procedure)

  Revision 1.94  2003/05/20 23:54:00  florian
    + basic darwin support added

  Revision 1.93  2003/05/15 22:14:42  florian
    * fixed last commit, changing lastsaveintreg to r31 caused some strange problems

  Revision 1.92  2003/05/15 21:37:00  florian
    * sysv entry code saves r13 now as well

  Revision 1.91  2003/05/15 19:39:09  florian
    * fixed ppc compiler which was broken by Peter's changes

  Revision 1.90  2003/05/12 18:43:50  jonas
    * fixed g_concatcopy

  Revision 1.89  2003/05/11 20:59:23  jonas
    * fixed bug with large offsets in entrycode

  Revision 1.88  2003/05/11 11:45:08  jonas
    * fixed shifts

  Revision 1.87  2003/05/11 11:07:33  jonas
    * fixed optimizations in a_op_const_reg_reg()

  Revision 1.86  2003/04/27 11:21:36  peter
    * aktprocdef renamed to current_procinfo.procdef
    * procinfo renamed to current_procinfo
    * procinfo will now be stored in current_module so it can be
      cleaned up properly
    * gen_main_procsym changed to create_main_proc and release_main_proc
      to also generate a tprocinfo structure
    * fixed unit implicit initfinal

  Revision 1.85  2003/04/26 22:56:11  jonas
    * fix to a_op64_const_reg_reg

  Revision 1.84  2003/04/26 16:08:41  jonas
    * fixed g_flags2reg

  Revision 1.83  2003/04/26 15:25:29  florian
    * fixed cmp_reg_reg_reg, cmp operands were emitted in the wrong order

  Revision 1.82  2003/04/25 20:55:34  florian
    * stack frame calculations are now completly done using the code generator
      routines instead of generating directly assembler so also large stack frames
      are handle properly

  Revision 1.81  2003/04/24 11:24:00  florian
    * fixed several issues with nested procedures

  Revision 1.80  2003/04/23 22:18:01  peter
    * fixes to get rtl compiled

  Revision 1.79  2003/04/23 12:35:35  florian
    * fixed several issues with powerpc
    + applied a patch from Jonas for nested function calls (PowerPC only)
    * ...

  Revision 1.78  2003/04/16 09:26:55  jonas
    * assembler procedures now again get a stackframe if they have local
      variables. No space is reserved for a function result however.
      Also, the register parameters aren't automatically saved on the stack
      anymore in assembler procedures.

  Revision 1.77  2003/04/06 16:39:11  jonas
    * don't generate entry/exit code for assembler procedures

  Revision 1.76  2003/03/22 18:01:13  jonas
    * fixed linux entry/exit code generation

  Revision 1.75  2003/03/19 14:26:26  jonas
    * fixed R_TOC bugs introduced by new register allocator conversion

  Revision 1.74  2003/03/13 22:57:45  olle
    * change in a_loadaddr_ref_reg

  Revision 1.73  2003/03/12 22:43:38  jonas
    * more powerpc and generic fixes related to the new register allocator

  Revision 1.72  2003/03/11 21:46:24  jonas
    * lots of new regallocator fixes, both in generic and ppc-specific code
      (ppc compiler still can't compile the linux system unit though)

  Revision 1.71  2003/02/19 22:00:16  daniel
    * Code generator converted to new register notation
    - Horribily outdated todo.txt removed

  Revision 1.70  2003/01/13 17:17:50  olle
    * changed global var access, TOC now contain pointers to globals
    * fixed handling of function pointers

  Revision 1.69  2003/01/09 22:00:53  florian
    * fixed some PowerPC issues

  Revision 1.68  2003/01/08 18:43:58  daniel
   * Tregister changed into a record

  Revision 1.67  2002/12/15 19:22:01  florian
    * fixed some crashes and a rte 201

  Revision 1.66  2002/11/28 10:55:16  olle
    * macos: changing code gen for references to globals

  Revision 1.65  2002/11/07 15:50:23  jonas
    * fixed bctr(l) problems

  Revision 1.64  2002/11/04 18:24:19  olle
    * macos: globals are located in TOC and relative r2, instead of absolute

  Revision 1.63  2002/10/28 22:24:28  olle
    * macos entry/exit: only used registers are saved
    - macos entry/exit: stackptr not saved in r31 anymore
    * macos entry/exit: misc fixes

  Revision 1.62  2002/10/19 23:51:48  olle
    * macos stack frame size computing updated
    + macos epilogue: control register now restored
    * macos prologue and epilogue: fp reg now saved and restored

  Revision 1.61  2002/10/19 12:50:36  olle
    * reorganized prologue and epilogue routines

  Revision 1.60  2002/10/02 21:49:51  florian
    * all A_BL instructions replaced by calls to a_call_name

  Revision 1.59  2002/10/02 13:24:58  jonas
    * changed a_call_* so that no superfluous code is generated anymore

  Revision 1.58  2002/09/17 18:54:06  jonas
    * a_load_reg_reg() now has two size parameters: source and dest. This
      allows some optimizations on architectures that don't encode the
      register size in the register name.

  Revision 1.57  2002/09/10 21:22:25  jonas
    + added some internal errors
    * fixed bug in sysv exit code

  Revision 1.56  2002/09/08 20:11:56  jonas
    * fixed TOpCmp2AsmCond array (some unsigned equivalents were wrong)

  Revision 1.55  2002/09/08 13:03:26  jonas
    * several large offset-related fixes

  Revision 1.54  2002/09/07 17:54:58  florian
    * first part of PowerPC fixes

  Revision 1.53  2002/09/07 15:25:14  peter
    * old logs removed and tabs fixed

  Revision 1.52  2002/09/02 10:14:51  jonas
    + a_call_reg()
    * small fix in a_call_ref()

  Revision 1.51  2002/09/02 06:09:02  jonas
    * fixed range error

  Revision 1.50  2002/09/01 21:04:49  florian
    * several powerpc related stuff fixed

  Revision 1.49  2002/09/01 12:09:27  peter
    + a_call_reg, a_call_loc added
    * removed exprasmlist references

  Revision 1.48  2002/08/31 21:38:02  jonas
    * fixed a_call_ref (it should load ctr, not lr)

  Revision 1.47  2002/08/31 21:30:45  florian
    * fixed several problems caused by Jonas' commit :)

  Revision 1.46  2002/08/31 19:25:50  jonas
    + implemented a_call_ref()

  Revision 1.45  2002/08/18 22:16:14  florian
    + the ppc gas assembler writer adds now registers aliases
      to the assembler file

  Revision 1.44  2002/08/17 18:23:53  florian
    * some assembler writer bugs fixed

  Revision 1.43  2002/08/17 09:23:49  florian
    * first part of procinfo rewrite

  Revision 1.42  2002/08/16 14:24:59  carl
    * issameref() to test if two references are the same (then emit no opcodes)
    + ret_in_reg to replace ret_in_acc
      (fix some register allocation bugs at the same time)
    + save_std_register now has an extra parameter which is the
      usedinproc registers

  Revision 1.41  2002/08/15 08:13:54  carl
    - a_load_sym_ofs_reg removed
    * loadvmt now calls loadaddr_ref_reg instead

  Revision 1.40  2002/08/11 14:32:32  peter
    * renamed current_library to objectlibrary

  Revision 1.39  2002/08/11 13:24:18  peter
    * saving of asmsymbols in ppu supported
    * asmsymbollist global is removed and moved into a new class
      tasmlibrarydata that will hold the info of a .a file which
      corresponds with a single module. Added librarydata to tmodule
      to keep the library info stored for the module. In the future the
      objectfiles will also be stored to the tasmlibrarydata class
    * all getlabel/newasmsymbol and friends are moved to the new class

  Revision 1.38  2002/08/11 11:39:31  jonas
    + powerpc-specific genlinearlist

  Revision 1.37  2002/08/10 17:15:31  jonas
    * various fixes and optimizations

  Revision 1.36  2002/08/06 20:55:23  florian
    * first part of ppc calling conventions fix

  Revision 1.35  2002/08/06 07:12:05  jonas
    * fixed bug in g_flags2reg()
    * and yet more constant operation fixes :)

  Revision 1.34  2002/08/05 08:58:53  jonas
    * fixed compilation problems

  Revision 1.33  2002/08/04 12:57:55  jonas
    * more misc. fixes, mostly constant-related

}
