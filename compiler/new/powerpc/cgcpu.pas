{
    $Id$
    Copyright (c) 1993-98 by Florian Klaempfl

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

  interface

    uses
       cgbase,cgobj,aasm,cpuasm,cpubase,cpuinfo;

    type
       pcgppc = ^tcgppc;

       tcgppc = object(tcg)
          { passing parameters, per default the parameter is pushed }
          { nr gives the number of the parameter (enumerated from   }
          { left to right), this allows to move the parameter to    }
          { register, if the cpu supports register calling          }
          { conventions                                             }
          procedure a_param_reg(list : paasmoutput;size : tcgsize;r : tregister;nr : longint);virtual;
          procedure a_param_const(list : paasmoutput;size : tcgsize;a : aword;nr : longint);virtual;
          procedure a_param_ref(list : paasmoutput;size : tcgsize;const r : treference;nr : longint);virtual;
          procedure a_paramaddr_ref(list : paasmoutput;const r : treference;nr : longint);virtual;


          procedure a_call_name(list : paasmoutput;const s : string;
            offset : longint);virtual;

          procedure a_op_reg_const(list : paasmoutput; Op: TOpCG; size: TCGSize; reg: TRegister; a: AWord); virtual;

          { move instructions }
          procedure a_load_const_reg(list : paasmoutput; size: tcgsize; a : aword;reg : tregister);virtual;
          procedure a_load_reg_ref(list : paasmoutput; size: tcgsize; reg : tregister;const ref2 : treference);virtual;
          procedure a_load_ref_reg(list : paasmoutput;size : tcgsize;const Ref2 : treference;reg : tregister);virtual;
          procedure a_load_reg_reg(list : paasmoutput;size : tcgsize;reg1,reg2 : tregister);virtual;

          {  comparison operations }
          procedure a_cmp_reg_const_label(list : paasmoutput;size : tcgsize;cmp_op : topcmp;a : aword;reg : tregister;
            l : pasmlabel);virtual;
          procedure a_cmp_reg_reg_label(list : paasmoutput;size : tcgsize;cmp_op : topcmp;reg1,reg2 : tregister;l : pasmlabel);


          procedure g_stackframe_entry(list : paasmoutput;localsize : longint);virtual;
          procedure g_restore_frame_pointer(list : paasmoutput);virtual;
          procedure g_return_from_proc(list : paasmoutput;parasize : aword); virtual;

          procedure a_loadaddress_ref_reg(list : paasmoutput;const ref2 : treference;r : tregister);virtual;

          procedure g_concatcopy(list : paasmoutput;const source,dest : treference;len : aword;loadref : boolean);virtual;


          private

          { Generates                                                                }
          {   OpLo reg1, reg2, (a and $ffff) and/or }
          {   OpHi reg1, reg2, (a shr 16)           }
          { depending on the value of a             }
          procedure a_op_reg_reg_const32(list: paasmOutPut; oplo, ophi: tasmop;
                                          reg1, reg2: tregister; a: aword);
          { Make sure ref is a valid reference for the PowerPC and sets the }
          { base to the value of the index if (base = R_NO).                }
          procedure fixref(var ref: treference);

          { contains the common code of a_load_reg_ref and a_load_ref_reg }
          procedure a_load_store(list:paasmoutput;op: tasmop;reg:tregister;
                      var ref: treference);

          { creates the correct branch instruction for a given combination }
          { of asmcondflags and destination addressing mode                }
          procedure a_jmp(list: paasmoutput; op: tasmop;
                          c: tasmcondflags; l: pasmlabel);

       end;

const
  TOpCG2AsmOpLo: Array[topcg] of TAsmOp = (A_ADDI,A_ANDI_,A_DIVWU,
                      A_DIVW,A_MULLW, A_MULLW, A_NONE,A_NONE,A_ORI,
                      A_SRAWI,A_SLWI,A_SRWI,A_SUBI,A_XORI);
  TOpCG2AsmOpHi: Array[topcg] of TAsmOp = (A_ADDIS,A_ANDIS_,
                      A_DIVWU,A_DIVW, A_MULLW,A_MULLW,A_NONE,A_NONE,
                      A_ORIS,A_NONE, A_NONE,A_NONE,A_SUBIS,A_XORIS);

  TOpCmp2AsmCond: Array[topcmp] of TAsmCondFlags = (CF_EQ,CF_GT,CF_LT,CF_GE,
                       CF_LE,CF_NE,CF_LE,CF_NG,CF_GE,CF_NL);

  LoadInstr: Array[OS_8..OS_32,boolean, boolean] of TAsmOp =
                         { indexed? updating?}
             (((A_LBZ,A_LBZU),(A_LBZX,A_LBZUX)),
              ((A_LHZ,A_LHZU),(A_LHZX,A_LHZUX)),
              ((A_LWZ,A_LWZU),(A_LWZX,A_LWZUX)));

  StoreInstr: Array[OS_8..OS_32,boolean, boolean] of TAsmOp =
                          { indexed? updating?}
             (((A_STB,A_STBU),(A_STBX,A_STBUX)),
              ((A_STH,A_STHU),(A_STHX,A_STHUX)),
              ((A_STW,A_STWU),(A_STWX,A_STWUX)));


  implementation

    uses
       globtype,globals,verbose;

{ parameter passing... Still needs extra support from the processor }
{ independent code generator                                        }

    procedure tcgppc.a_param_reg(list : paasmoutput;size : tcgsize;r : tregister;nr : longint);

    var ref: treference;

    begin
{$ifdef para_sizes_known}
      if (nr <= max_param_regs_int) then
        a_load_reg_reg(list,size,r,param_regs_int[nr])
      else
        begin
          reset_reference(ref);
          ref.base := stack_pointer;
          ref.offset := LinkageAreaSize+para_size_till_now;
          a_load_reg_ref(list,size,reg,ref);
        end;
{$endif para_sizes_known}
    end;


    procedure tcgppc.a_param_const(list : paasmoutput;size : tcgsize;a : aword;nr : longint);

    var ref: treference;

    begin
{$ifdef para_sizes_known}
      if (nr <= max_param_regs_int) then
        a_load_const_reg(list,size,a,param_regs_int[nr])
      else
        begin
          reset_reference(ref);
          ref.base := stack_pointer;
          ref.offset := LinkageAreaSize+para_size_till_now;
          a_load_const_ref(list,size,a,ref);
        end;
{$endif para_sizes_known}
    end;


    procedure tcgppc.a_param_ref(list : paasmoutput;size : tcgsize;const r : treference;nr : longint);

    var ref: treference;
        tmpreg: tregister;

    begin
{$ifdef para_sizes_known}
      if (nr <= max_param_regs_int) then
        a_load_ref_reg(list,size,r,param_regs_int[nr])
      else
        begin
          reset_reference(ref);
          ref.base := stack_pointer;
          ref.offset := LinkageAreaSize+para_size_till_now;
          tmpreg := get_scratch_reg(list);
          a_load_ref_reg(list,size,r,tmpreg);
          a_load_reg_ref(list,size,tmpreg,ref);
          free_scratch_reg(list,tmpreg);
        end;
{$endif para_sizes_known}
    end;


    procedure tcgppc.a_paramaddr_ref(list : paasmoutput;const r : treference;nr : longint);

    var ref: treference;
        tmpreg: tregister;

    begin
{$ifdef para_sizes_known}
      if (nr <= max_param_regs_int) then
        a_loadaddress_ref_reg(list,size,r,param_regs_int[nr])
      else
        begin
          reset_reference(ref);
          ref.base := stack_pointer;
          ref.offset := LinkageAreaSize+para_size_till_now;
          tmpreg := get_scratch_reg(list);
          a_loadaddress_ref_reg(list,size,r,tmpreg);
          a_load_reg_ref(list,size,tmpreg,ref);
          free_scratch_reg(list,tmpreg);
        end;
{$endif para_sizes_known}
    end;

{ calling a code fragment by name }

    procedure tcgppc.a_call_name(list : paasmoutput;const s : string;
      offset : longint);

      begin
 { save our RTOC register value. Only necessary when doing pointer based    }
 { calls or cross TOC calls, but currently done always                      }
         list^.concat(new(paicpu,op_reg_ref(A_STW,R_RTOC,
           new_reference(stack_pointer,LA_RTOC))));
         list^.concat(new(paicpu,op_sym(A_BL,newasmsymbol(s))));
         list^.concat(new(paicpu,op_reg_ref(A_LWZ,R_RTOC,
           new_reference(stack_pointer,LA_RTOC))));
      end;

{********************** load instructions ********************}

     procedure tcgppc.a_load_const_reg(list : paasmoutput; size: TCGSize; a : aword; reg : TRegister);

       begin
          If (a and $ffff) <> 0 Then
            Begin
              list^.concat(new(paicpu,op_reg_const(A_LI,reg,a and $ffff)));
              If (a shr 16) <> 0 Then
                list^.concat(new(paicpu,op_reg_const(A_ORIS,reg,a shr 16)))
            End
          Else
            list^.concat(new(paicpu,op_reg_const(A_LIS,reg,a shr 16)));
       end;

     procedure tcgppc.a_load_reg_ref(list : paasmoutput; size: TCGSize; reg : tregister;const ref2 : treference);

     Var
       op: TAsmOp;
       ref: TReference;

       begin
         ref := ref2;
         FixRef(ref);
         op := storeinstr[size,ref.index<>R_NO,false];
         a_load_store(list,op,reg,ref);
       End;

     procedure tcgppc.a_load_ref_reg(list : paasmoutput;size : tcgsize;const ref2: treference;reg : tregister);

     Var
       op: TAsmOp;
       tmpreg: tregister;
       ref, tmpref: TReference;

       begin
         ref := ref2;
         FixRef(ref);
         op := loadinstr[size,ref.index<>R_NO,false];
         a_load_store(list,op,reg,ref);
       end;

     procedure tcgppc.a_load_reg_reg(list : paasmoutput;size : tcgsize;reg1,reg2 : tregister);

       begin
         list^.concat(new(paicpu,op_reg_reg(A_MR,reg2,reg1)));
       end;

     procedure tcgppc.a_op_reg_const(list : paasmoutput; Op: TOpCG; size: TCGSize; reg: TRegister; a: AWord);

     var scratch_register: TRegister;

       begin
         Case Op of
           OP_DIV, OP_IDIV, OP_IMUL, OP_MUL:
             If (Op = OP_IMUL) And (longint(a) >= -32768) And
                (longint(a) <= 32767) Then
               list^.concat(new(paicpu,op_reg_reg_const(A_MULLI,reg,reg,a)))
             Else
               Begin
                 scratch_register := get_scratch_reg(list);
                 a_load_const_reg(list, OS_32, a, scratch_register);
                 list^.concat(new(paicpu,op_reg_reg_reg(TOpCG2AsmOpLo[Op],
                   reg,reg,scratch_register)));
                 free_scratch_reg(list,scratch_register);
               End;
           OP_ADD, OP_AND, OP_OR, OP_SUB,OP_XOR:
             a_op_reg_reg_const32(list,TOpCG2AsmOpLo[Op],
               TOpCG2AsmOpHi[Op],reg,reg,a);
           OP_SHL,OP_SHR,OP_SAR:
             Begin
               if (a and 31) <> 0 Then
                 list^.concat(new(paicpu,op_reg_reg_const(
                   TOpCG2AsmOpLo[Op],reg,reg,a and 31)));
               If (a shr 5) <> 0 Then
                 InternalError(68991);
             End
           Else InternalError(68992);
         end;
       end;


{*************** compare instructructions ****************}

      procedure tcgppc.a_cmp_reg_const_label(list : paasmoutput;size : tcgsize;cmp_op : topcmp;a : aword;reg : tregister;
        l : pasmlabel);

      var p: paicpu;
          scratch_register: TRegister;
          signed: boolean;

        begin
          signed := cmp_op in [OC_GT,OC_LT,OC_GTE,OC_LTE];
          If signed Then
            If (longint(a) >= -32768) and (longint(a) <= 32767) Then
              list^.concat(new(paicpu,op_const_reg_const(A_CMPI,0,reg,a)))
            else
              begin
                scratch_register := get_scratch_reg(list);
                a_load_const_reg(list,OS_32,a,scratch_register);
                list^.concat(new(paicpu,op_const_reg_reg(A_CMP,0,reg,scratch_register)));
                free_scratch_reg(list,scratch_register);
             end
           else
             if (a <= $ffff) then
              list^.concat(new(paicpu,op_const_reg_const(A_CMPLI,0,reg,a)))
            else
              begin
                scratch_register := get_scratch_reg(list);
                a_load_const_reg(list,OS_32,a,scratch_register);
                list^.concat(new(paicpu,op_const_reg_reg(A_CMPL,0,reg,scratch_register)));
                free_scratch_reg(list,scratch_register);
             end;
           a_jmp(list,A_BC,TOpCmp2AsmCond[cmp_op],l);
        end;


      procedure tcgppc.a_cmp_reg_reg_label(list : paasmoutput;size : tcgsize;cmp_op : topcmp;
        reg1,reg2 : tregister;l : pasmlabel);

      var p: paicpu;
          AsmCond: TAsmCondFlags;

      begin
        list^.concat(new(paicpu,op_const_reg_reg(A_CMPL,0,reg1,reg2)));
        a_jmp(list,A_BC,TOpCmp2AsmCond[cmp_op],l);
      end;


{ *********** entry/exit code and address loading ************ }

    procedure tcgppc.g_stackframe_entry(list : paasmoutput;localsize : longint);
 { generated the entry code of a procedure/function. Note: localsize is the }
 { sum of the size necessary for local variables and the maximum possible   }
 { combined size of ALL the parameters of a procedure called by the current }
 { one                                                                      }
     var scratch_register: TRegister;

      begin
        if (localsize mod 8) <> 0 then internalerror(58991);
 { CR and LR only have to be saved in case they are modified by the current }
 { procedure, but currently this isn't checked, so save them always         }
        scratch_register := get_scratch_reg(list);
        list^.concat(new(paicpu,op_reg(A_MFCR,scratch_register)));
        list^.concat(new(paicpu,op_reg_ref(A_STW,scratch_register,
          new_reference(stack_pointer,LA_CR))));
        free_scratch_reg(list,scratch_register);
        scratch_register := get_scratch_reg(list);
        list^.concat(new(paicpu,op_reg_reg(A_MFSPR,scratch_register,
          R_LR)));
        list^.concat(new(paicpu,op_reg_ref(A_STW,scratch_register,
          new_reference(stack_pointer,LA_LR))));
        free_scratch_reg(list,scratch_register);
{ if the current procedure is a leaf procedure, we can use the Red Zone,    }
{ but this is not yet implemented                                           }
{        if ((procinfo.flags and pi_do_call) <> 0) And                      }
{           (localsize <= (256 - LinkageAreaSize)) Then                     }
           Begin
             if localsize<>0 then
               begin
 { allocate space for the local variable, parameter and linkage area and   }
 { save the stack pointer at the end of the linkage area                   }
                 if localsize <= $ffff Then
                   list^.concat(new(paicpu,op_reg_ref
                     (A_STWU,stack_pointer, new_reference(stack_pointer,localsize+
                      LinkageAreaSize))))
                 else
                   Begin
                     scratch_register := get_scratch_reg(list);
                     a_load_const_reg(list,OS_32,localsize,scratch_register);
                     list^.concat(new(paicpu,op_reg_reg_reg(A_STWUX,stack_pointer,
                       stack_pointer,scratch_register)));
                     free_scratch_reg(list,scratch_register);
                  End;
               End
           End;
       end;

    procedure tcgppc.g_restore_frame_pointer(list : paasmoutput);

      begin
 { no frame pointer on the PowerPC                                          }
      end;

     procedure tcgppc.g_return_from_proc(list : paasmoutput;parasize : aword);

     begin
       abstract;
     end;

     procedure tcgppc.a_loadaddress_ref_reg(list : paasmoutput;const ref2 : treference;r : tregister);

     Var
       ref: TReference;

       begin
         ref := ref2;
         FixRef(ref);
         If ref.offset <> 0 Then
           If ref.base <> R_NO then
             a_op_reg_reg_const32(list,A_ADDI,A_ADDIS,r,r,ref.offset)
  { FixRef makes sure that "(ref.index <> R_NO) and (ref.offset <> 0)" never}
  { occurs, so now only ref.offset has to be loaded                         }
           else a_load_const_reg(list, OS_32, ref.offset, r)
         else
           if ref.index <> R_NO Then
             list^.concat(new(paicpu,op_reg_reg_reg(A_ADD,r,ref.base,ref.index)))
           else list^.concat(new(paicpu,op_reg_reg(A_MR,r,ref.base)))
       end;

{ ************* concatcopy ************ }

    procedure tcgppc.g_concatcopy(list : paasmoutput;const source,dest : treference;len : aword;loadref : boolean);

    var
      p: paicpu;
      countreg, tempreg: TRegister;
      src, dst: TReference;
      lab: PAsmLabel;
      count, count2: aword;
      begin
        { make sure source and dest are valid }
        src := source;
        fixref(src);
        dst := dest;
        fixref(dst);
        reset_reference(src);
        reset_reference(dst);
        { load the address of source into src.base }
        src.base := get_scratch_reg(list);
        if loadref then
          a_load_ref_reg(list,OS_32,source,src.base)
        else a_loadaddress_ref_reg(list,source,src.base);
        { load the address of dest into dst.base }
        dst.base := get_scratch_reg(list);
        a_loadaddress_ref_reg(list,dest,dst.base);
        count := len div 4;
        if count > 3 then
          { generate a loop }
          begin
            Inc(dst.offset,4);
            Inc(src.offset,4);
            a_op_reg_reg_const32(list,A_SUBI,A_NONE,src.base,src.base,4);
            a_op_reg_reg_const32(list,A_SUBI,A_NONE,dst.base,dst.base,4);
            countreg := get_scratch_reg(list);
            a_load_const_reg(list,OS_32,count-1,countreg);
            tempreg := get_scratch_reg(list);
            getlabel(lab);
            a_label(list, lab);
            list^.concat(new(paicpu,op_reg_ref(A_LWZU,tempreg,
              newreference(src))));
            a_op_reg_reg_const32(list,A_CMPI,A_NONE,R_CR0,countreg,0);
            list^.concat(new(paicpu,op_reg_ref(A_STWU,tempreg,
              newreference(dst))));
            a_op_reg_reg_const32(list,A_SUBI,A_NONE,countreg,countreg,1);
            a_jmp(list,A_BC,CF_NE,lab);
            free_scratch_reg(list,countreg);
          end
        else
          { unrolled loop }
          begin
            tempreg := get_scratch_reg(list);
            for count2 := 1 to count do
              begin
                a_load_ref_reg(list,OS_32,src,tempreg);
                a_load_reg_ref(list,OS_32,tempreg,dst);
                inc(src.offset,4);
                inc(dst.offset,4);
              end
          end;
       { copy the leftovers }
       if (len and 2) <> 0 then
         begin
           a_load_ref_reg(list,OS_16,src,tempreg);
           a_load_reg_ref(list,OS_16,tempreg,dst);
           inc(src.offset,2);
           inc(dst.offset,2);
         end;
       if (len and 1) <> 0 then
         begin
           a_load_ref_reg(list,OS_8,src,tempreg);
           a_load_reg_ref(list,OS_8,tempreg,dst);
         end;
       free_scratch_reg(list,tempreg);
       free_scratch_reg(list,src.base);
       free_scratch_reg(list,dst.base);
      end;

{***************** This is private property, keep out! :) *****************}

    procedure tcgppc.fixref(var ref: treference);

       begin
         If (ref.base <> R_NO) then
           begin
             if (ref.index <> R_NO) and
                ((ref.offset <> 0) or assigned(ref.symbol)) Then
               Internalerror(58992)
           end
         else
           begin
             ref.base := ref.index;
             ref.index := R_NO
           end
       end;

    procedure tcgppc.a_op_reg_reg_const32(list: paasmoutput; oplo, ophi:
                       tasmop; reg1, reg2: tregister; a: aword);

      begin
        if (a and $ffff) <> 0 Then
          list^.concat(new(paicpu,op_reg_reg_const(OpLo,reg1,reg2,a and $ffff)));
        If (a shr 16) <> 0 Then
          list^.concat(new(paicpu,op_reg_reg_const(OpHi,reg1,reg2,a shr 16)))
      end;

    procedure tcgppc.a_load_store(list:paasmoutput;op: tasmop;reg:tregister;
                       var ref: treference);

    var tmpreg: tregister;
        tmpref: treference;

      begin
        if assigned(ref.symbol) then
          begin
            tmpreg := get_scratch_reg(list);
            reset_reference(tmpref);
            tmpref.symbol := ref.symbol;
            tmpref.symaddr := refs_ha;
            tmpref.is_immediate := true;
            if ref.base <> R_NO then
              list^.concat(new(paicpu,op_reg_reg_ref(A_ADDIS,tmpreg,
                ref.base,newreference(tmpref))))
            else
              list^.concat(new(paicpu,op_reg_ref(A_LIS,tmpreg,
                 newreference(tmpref))));
            ref.base := tmpreg
          end;
        list^.concat(new(paicpu,op_reg_ref(op,reg,newreference(ref))));
        if assigned(ref.symbol) then
          free_scratch_reg(list,tmpreg);
      end;

    procedure tcgppc.a_jmp(list: paasmoutput; op: tasmop; c: tasmcondflags;
                l: pasmlabel);
    var p: paicpu;
    begin
      p := new(paicpu,op_sym(op,newasmsymbol(l^.name)));
      create_cond_norm(c,0,p^.condition);
      list^.concat(p)
    end;
end.
{
  $Log$
  Revision 1.6  1999-09-15 20:35:47  florian
    * small fix to operator overloading when in MMX mode
    + the compiler uses now fldz and fld1 if possible
    + some fixes to floating point registers
    + some math. functions (arctan, ln, sin, cos, sqrt, sqr, pi) are now inlined
    * .... ???

  Revision 1.5  1999/09/03 13:14:11  jonas
    + implemented some parameter passing methods, but they require\n    some more helper routines\n  * fix for loading symbol addresses (still needs to be done in a_loadaddress)\n  * several changes to the way conditional branches are handled

  Revision 1.4  1999/08/26 14:53:41  jonas
    * first implementation of concatcopy (requires 4 scratch regs)

  Revision 1.3  1999/08/25 12:00:23  jonas
    * changed pai386, paippc and paiapha (same for tai*) to paicpu (taicpu)

  Revision 1.2  1999/08/18 17:05:57  florian
    + implemented initilizing of data for the new code generator
      so it should compile now simple programs

  Revision 1.1  1999/08/06 16:41:11  jonas
    * PowerPC compiles again, several routines implemented in cgcpu.pas
    * added constant to cpubase of alpha and powerpc for maximum
      number of operands


}
