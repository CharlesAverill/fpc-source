{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    This unit implements the code generator for the SPARC

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
       globtype,
       cgbase,cgobj,cg64f32,
       aasmbase,aasmtai,aasmcpu,
       cpubase,cpuinfo,
       node,symconst,SymType,
       rgcpu;

    type
      TCgSparc=class(tcg)
      protected
        function IsSimpleRef(const ref:treference):boolean;
     public
        procedure init_register_allocators;override;
        procedure done_register_allocators;override;
        function  getfpuregister(list:Taasmoutput;size:Tcgsize):Tregister;override;
        { sparc special, needed by cg64 }
        procedure handle_load_store(list:taasmoutput;isstore:boolean;op: tasmop;reg:tregister;ref: treference);
        procedure handle_reg_const_reg(list:taasmoutput;op:Tasmop;src:tregister;a:aint;dst:tregister);
        { parameter }
        procedure a_param_const(list:TAasmOutput;size:tcgsize;a:aint;const LocPara:TParaLocation);override;
        procedure a_param_ref(list:TAasmOutput;sz:tcgsize;const r:TReference;const LocPara:TParaLocation);override;
        procedure a_paramaddr_ref(list:TAasmOutput;const r:TReference;const LocPara:TParaLocation);override;
        procedure a_paramfpu_reg(list : taasmoutput;size : tcgsize;const r : tregister;const locpara : tparalocation);override;
        procedure a_paramfpu_ref(list : taasmoutput;size : tcgsize;const ref : treference;const locpara : tparalocation);override;
        procedure a_loadany_param_ref(list : taasmoutput;const locpara : tparalocation;const ref:treference;shuffle : pmmshuffle);override;
        procedure a_loadany_param_reg(list : taasmoutput;const locpara : tparalocation;const reg:tregister;shuffle : pmmshuffle);override;
        procedure a_call_name(list:TAasmOutput;const s:string);override;
        procedure a_call_reg(list:TAasmOutput;Reg:TRegister);override;
        { General purpose instructions }
        procedure a_op_const_reg(list:TAasmOutput;Op:TOpCG;size:tcgsize;a:aint;reg:TRegister);override;
        procedure a_op_reg_reg(list:TAasmOutput;Op:TOpCG;size:TCGSize;src, dst:TRegister);override;
        procedure a_op_const_reg_reg(list:TAasmOutput;op:TOpCg;size:tcgsize;a:aint;src, dst:tregister);override;
        procedure a_op_reg_reg_reg(list:TAasmOutput;op:TOpCg;size:tcgsize;src1, src2, dst:tregister);override;
        { move instructions }
        procedure a_load_const_reg(list:TAasmOutput;size:tcgsize;a:aint;reg:tregister);override;
        procedure a_load_const_ref(list:TAasmOutput;size:tcgsize;a:aint;const ref:TReference);override;
        procedure a_load_reg_ref(list:TAasmOutput;FromSize,ToSize:TCgSize;reg:TRegister;const ref:TReference);override;
        procedure a_load_ref_reg(list:TAasmOutput;FromSize,ToSize:TCgSize;const ref:TReference;reg:tregister);override;
        procedure a_load_reg_reg(list:TAasmOutput;FromSize,ToSize:TCgSize;reg1,reg2:tregister);override;
        procedure a_loadaddr_ref_reg(list:TAasmOutput;const ref:TReference;r:tregister);override;
        { fpu move instructions }
        procedure a_loadfpu_reg_reg(list:TAasmOutput;size:tcgsize;reg1, reg2:tregister);override;
        procedure a_loadfpu_ref_reg(list:TAasmOutput;size:tcgsize;const ref:TReference;reg:tregister);override;
        procedure a_loadfpu_reg_ref(list:TAasmOutput;size:tcgsize;reg:tregister;const ref:TReference);override;
        { comparison operations }
        procedure a_cmp_const_reg_label(list:TAasmOutput;size:tcgsize;cmp_op:topcmp;a:aint;reg:tregister;l:tasmlabel);override;
        procedure a_cmp_reg_reg_label(list:TAasmOutput;size:tcgsize;cmp_op:topcmp;reg1,reg2:tregister;l:tasmlabel);override;
        procedure a_jmp_always(List:TAasmOutput;l:TAsmLabel);override;
        procedure a_jmp_cond(list:TAasmOutput;cond:TOpCmp;l:tasmlabel);{ override;}
        procedure a_jmp_flags(list:TAasmOutput;const f:TResFlags;l:tasmlabel);override;
        procedure g_flags2reg(list:TAasmOutput;Size:TCgSize;const f:tresflags;reg:TRegister);override;
        procedure g_overflowCheck(List:TAasmOutput;const Loc:TLocation;def:TDef);override;
        procedure g_proc_entry(list : taasmoutput;localsize : longint;nostackframe:boolean);override;
        procedure g_proc_exit(list : taasmoutput;parasize:longint;nostackframe:boolean);override;
        procedure g_restore_all_registers(list:TAasmOutput;const funcretparaloc:tparalocation);override;
        procedure g_restore_standard_registers(list:taasmoutput);override;
        procedure g_save_all_registers(list : taasmoutput);override;
        procedure g_save_standard_registers(list : taasmoutput);override;
        procedure g_concatcopy(list:TAasmOutput;const source,dest:TReference;len:aint;delsource,loadref:boolean);override;
      end;

      TCg64Sparc=class(tcg64f32)
      private
        procedure get_64bit_ops(op:TOpCG;var op1,op2:TAsmOp);
      public
        procedure a_op64_reg_reg(list:TAasmOutput;op:TOpCG;regsrc,regdst:TRegister64);override;
        procedure a_op64_const_reg(list:TAasmOutput;op:TOpCG;value:int64;regdst:TRegister64);override;
        procedure a_op64_const_reg_reg(list: taasmoutput;op:TOpCG;value : int64;regsrc,regdst : tregister64);override;
        procedure a_op64_reg_reg_reg(list: taasmoutput;op:TOpCG;regsrc1,regsrc2,regdst : tregister64);override;
      end;

    const
      TOpCG2AsmOp : array[topcg] of TAsmOp=(
        A_NONE,A_ADD,A_AND,A_UDIV,A_SDIV,A_UMUL,A_SMUL,A_NEG,A_NOT,A_OR,A_SRA,A_SLL,A_SRL,A_SUB,A_XOR
      );
      TOpCmp2AsmCond : array[topcmp] of TAsmCond=(C_NONE,
        C_E,C_G,C_L,C_GE,C_LE,C_NE,C_BE,C_B,C_AE,C_A
      );


implementation

  uses
    globals,verbose,systems,cutils,
    symdef,paramgr,
    tgobj,cpupi,cgutils;


{****************************************************************************
                       This is private property, keep out! :)
****************************************************************************}

    function TCgSparc.IsSimpleRef(const ref:treference):boolean;
      begin
        if (ref.base=NR_NO) and (ref.index<>NR_NO) then
          InternalError(2002100804);
        result :=not(assigned(ref.symbol))and
                  (((ref.index = NR_NO) and
                   (ref.offset >= simm13lo) and
                    (ref.offset <= simm13hi)) or
                  ((ref.index <> NR_NO) and
                  (ref.offset = 0)));
      end;


    procedure tcgsparc.handle_load_store(list:taasmoutput;isstore:boolean;op: tasmop;reg:tregister;ref: treference);
      var
        tmpreg : tregister;
        tmpref : treference;
      begin
        tmpreg:=NR_NO;
        { Be sure to have a base register }
        if (ref.base=NR_NO) then
          begin
            ref.base:=ref.index;
            ref.index:=NR_NO;
          end;
        { When need to use SETHI, do it first }
        if assigned(ref.symbol) or
           (ref.offset<simm13lo) or
           (ref.offset>simm13hi) then
          begin
            tmpreg:=GetIntRegister(list,OS_INT);
            reference_reset(tmpref);
            tmpref.symbol:=ref.symbol;
            tmpref.offset:=ref.offset;
            tmpref.refaddr:=addr_hi;
            list.concat(taicpu.op_ref_reg(A_SETHI,tmpref,tmpreg));
            { Load the low part is left }
{$warning TODO Maybe not needed to load symbol}
            tmpref.refaddr:=addr_lo;
            list.concat(taicpu.op_reg_ref_reg(A_OR,tmpreg,tmpref,tmpreg));
            { The offset and symbol are loaded, reset in reference }
            ref.offset:=0;
            ref.symbol:=nil;
            { Only an index register or offset is allowed }
            if tmpreg<>NR_NO then
              begin
                if (ref.index<>NR_NO) then
                  begin
                    list.concat(taicpu.op_reg_reg_reg(A_ADD,tmpreg,ref.index,tmpreg));
                    ref.index:=tmpreg;
                  end
                else
                  begin
                    if ref.base<>NR_NO then
                      ref.index:=tmpreg
                    else
                      ref.base:=tmpreg;
                  end;
              end;
          end;
        if (ref.base<>NR_NO) then
          begin
            if (ref.index<>NR_NO) and
               ((ref.offset<>0) or assigned(ref.symbol)) then
              begin
                if tmpreg=NR_NO then
                  tmpreg:=GetIntRegister(list,OS_INT);
                list.concat(taicpu.op_reg_reg_reg(A_ADD,ref.base,ref.index,tmpreg));
                ref.base:=tmpreg;
                ref.index:=NR_NO;
              end;
          end;
        if isstore then
          list.concat(taicpu.op_reg_ref(op,reg,ref))
        else
          list.concat(taicpu.op_ref_reg(op,ref,reg));
        if (tmpreg<>NR_NO) then
          UnGetRegister(list,tmpreg);
      end;


    procedure tcgsparc.handle_reg_const_reg(list:taasmoutput;op:Tasmop;src:tregister;a:aint;dst:tregister);
      var
        tmpreg : tregister;
      begin
        if (a<simm13lo) or
           (a>simm13hi) then
          begin
            tmpreg:=GetIntRegister(list,OS_INT);
            a_load_const_reg(list,OS_INT,a,tmpreg);
            list.concat(taicpu.op_reg_reg_reg(op,src,tmpreg,dst));
            UnGetRegister(list,tmpreg);
          end
        else
          list.concat(taicpu.op_reg_const_reg(op,src,a,dst));
      end;


{****************************************************************************
                              Assembler code
****************************************************************************}

    procedure Tcgsparc.init_register_allocators;
      begin
        inherited init_register_allocators;
        rg[R_INTREGISTER]:=Trgcpu.create(R_INTREGISTER,R_SUBD,
            [RS_O0,RS_O1,RS_O2,RS_O3,RS_O4,RS_O5,
             RS_L0,RS_L1,RS_L2,RS_L3,RS_L4,RS_L5,RS_L6,RS_L7],
            first_int_imreg,[]);
        rg[R_FPUREGISTER]:=trgcpu.create(R_FPUREGISTER,R_SUBFS,
            [RS_F0,RS_F1,RS_F2,RS_F3,RS_F4,RS_F5,RS_F6,RS_F7,
             RS_F8,RS_F9,RS_F10,RS_F11,RS_F12,RS_F13,RS_F14,RS_F15,
             RS_F16,RS_F17,RS_F18,RS_F19,RS_F20,RS_F21,RS_F22,RS_F23,
             RS_F24,RS_F25,RS_F26,RS_F27,RS_F28,RS_F29,RS_F30,RS_F31],
            first_fpu_imreg,[]);
      end;


    procedure Tcgsparc.done_register_allocators;
      begin
        rg[R_INTREGISTER].free;
        rg[R_FPUREGISTER].free;
        inherited done_register_allocators;
      end;


    function tcgsparc.getfpuregister(list:Taasmoutput;size:Tcgsize):Tregister;
      begin
        if size=OS_F64 then
          result:=rg[R_FPUREGISTER].getregister(list,R_SUBFD)
        else
          result:=rg[R_FPUREGISTER].getregister(list,R_SUBFS);
      end;


    procedure TCgSparc.a_param_const(list:TAasmOutput;size:tcgsize;a:aint;const LocPara:TParaLocation);
      var
        Ref:TReference;
      begin
        case locpara.loc of
          LOC_REGISTER,LOC_CREGISTER:
            a_load_const_reg(list,size,a,locpara.register);
          LOC_REFERENCE:
            begin
              { Code conventions need the parameters being allocated in %o6+92 }
              with LocPara.Reference do
                if(Index=NR_SP)and(Offset<Target_info.first_parm_offset) then
                InternalError(2002081104);
              reference_reset_base(ref,locpara.reference.index,locpara.reference.offset);
              a_load_const_ref(list,size,a,ref);
            end;
          else
            InternalError(2002122200);
        end;
      end;


    procedure TCgSparc.a_param_ref(list:TAasmOutput;sz:TCgSize;const r:TReference;const LocPara:TParaLocation);
      var
        ref: treference;
        tmpreg:TRegister;
      begin
        with LocPara do
          case loc of
            LOC_REGISTER,LOC_CREGISTER :
              a_load_ref_reg(list,sz,sz,r,Register);
            LOC_REFERENCE:
              begin
                { Code conventions need the parameters being allocated in %o6+92 }
                with LocPara.Reference do
                  if(Index=NR_SP)and(Offset<Target_info.first_parm_offset) then
                  InternalError(2002081104);
                reference_reset_base(ref,locpara.reference.index,locpara.reference.offset);
                tmpreg:=GetIntRegister(list,OS_INT);
                a_load_ref_reg(list,sz,sz,r,tmpreg);
                a_load_reg_ref(list,sz,sz,tmpreg,ref);
                UnGetRegister(list,tmpreg);
              end;
            else
              internalerror(2002081103);
          end;
      end;


    procedure TCgSparc.a_paramaddr_ref(list:TAasmOutput;const r:TReference;const LocPara:TParaLocation);
      var
        Ref:TReference;
        TmpReg:TRegister;
      begin
        case locpara.loc of
          LOC_REGISTER,LOC_CREGISTER:
            a_loadaddr_ref_reg(list,r,locpara.register);
          LOC_REFERENCE:
            begin
              reference_reset(ref);
              ref.base := locpara.reference.index;
              ref.offset := locpara.reference.offset;
              tmpreg:=GetAddressRegister(list);
              a_loadaddr_ref_reg(list,r,tmpreg);
              a_load_reg_ref(list,OS_ADDR,OS_ADDR,tmpreg,ref);
              UnGetRegister(list,tmpreg);
            end;
          else
            internalerror(2002080701);
        end;
      end;


    procedure tcgsparc.a_paramfpu_reg(list : taasmoutput;size : tcgsize;const r : tregister;const locpara : tparalocation);
      var
        href : treference;
      begin
        tg.GetTemp(list,TCGSize2Size[size],tt_normal,href);
        a_loadfpu_reg_ref(list,size,r,href);
        a_paramfpu_ref(list,size,href,locpara);
        tg.Ungettemp(list,href);
      end;


    procedure tcgsparc.a_paramfpu_ref(list : taasmoutput;size : tcgsize;const ref : treference;const locpara : tparalocation);
      var
        templocpara : tparalocation;
      begin
        { floats are pushed in the int registers }
        templocpara:=locpara;
        case locpara.size of
          OS_F32,OS_32 :
            begin
              templocpara.size:=OS_32;
              a_param_ref(list,OS_32,ref,templocpara);
            end;
          OS_F64,OS_64 :
            begin
              templocpara.size:=OS_64;
              cg64.a_param64_ref(list,ref,templocpara);
            end;
          else
            internalerror(200307021);
        end;
      end;


    procedure tcgsparc.a_loadany_param_ref(list : taasmoutput;const locpara : tparalocation;const ref:treference;shuffle : pmmshuffle);
      var
        href,
        tempref : treference;
        templocpara : tparalocation;
      begin
        { Load floats like ints }
        templocpara:=locpara;
        case locpara.size of
          OS_F32 :
            templocpara.size:=OS_32;
          OS_F64 :
            templocpara.size:=OS_64;
        end;
        { Word 0 is in register, word 1 is in reference }
        if (templocpara.loc=LOC_REFERENCE) and (templocpara.low_in_reg) then
          begin
            tempref:=ref;
            cg.a_load_reg_ref(list,OS_INT,OS_INT,templocpara.register,tempref);
            inc(tempref.offset,4);
            reference_reset_base(href,templocpara.reference.index,templocpara.reference.offset);
            cg.a_load_ref_ref(list,OS_INT,OS_INT,href,tempref);
          end
        else
          inherited a_loadany_param_ref(list,templocpara,ref,shuffle);
      end;


    procedure tcgsparc.a_loadany_param_reg(list : taasmoutput;const locpara : tparalocation;const reg:tregister;shuffle : pmmshuffle);
      var
        href : treference;
      begin
        { Word 0 is in register, word 1 is in reference, not
          possible to load it in 1 register }
        if (locpara.loc=LOC_REFERENCE) and (locpara.low_in_reg) then
          internalerror(200307011);
        { Float load use a temp reference }
        if locpara.size in [OS_F32,OS_F64] then
          begin
            tg.GetTemp(list,TCGSize2Size[locpara.size],tt_normal,href);
            a_loadany_param_ref(list,locpara,href,shuffle);
            a_loadfpu_ref_reg(list,locpara.size,href,reg);
            tg.Ungettemp(list,href);
          end
        else
          inherited a_loadany_param_reg(list,locpara,reg,shuffle);
      end;


    procedure TCgSparc.a_call_name(list:TAasmOutput;const s:string);
      begin
        list.concat(taicpu.op_sym(A_CALL,objectlibrary.newasmsymbol(s,AB_EXTERNAL,AT_FUNCTION)));
        { Delay slot }
        list.concat(taicpu.op_none(A_NOP));
      end;


    procedure TCgSparc.a_call_reg(list:TAasmOutput;Reg:TRegister);
      begin
        list.concat(taicpu.op_reg(A_CALL,reg));
        { Delay slot }
        list.concat(taicpu.op_none(A_NOP));
     end;


    {********************** load instructions ********************}

    procedure TCgSparc.a_load_const_reg(list : TAasmOutput;size : TCGSize;a : aint;reg : TRegister);
      begin
        { we don't use the set instruction here because it could be evalutated to two
          instructions which would cause problems with the delay slot (FK) }
        if (a=0) then
          list.concat(taicpu.op_reg(A_CLR,reg))
        { sethi allows to set the upper 22 bit, so we'll take full advantage of it }
        else if (a and aint($1fff))=0 then
          list.concat(taicpu.op_const_reg(A_SETHI,a shr 10,reg))
        else if (a>=simm13lo) and (a<=simm13hi) then
          list.concat(taicpu.op_const_reg(A_MOV,a,reg))
        else
          begin
            list.concat(taicpu.op_const_reg(A_SETHI,a shr 10,reg));
            list.concat(taicpu.op_reg_const_reg(A_OR,reg,a and aint($3ff),reg));
          end;
      end;


    procedure TCgSparc.a_load_const_ref(list : TAasmOutput;size : tcgsize;a : aint;const ref : TReference);
      begin
        if a=0 then
          a_load_reg_ref(list,size,size,NR_G0,ref)
        else
          inherited a_load_const_ref(list,size,a,ref);
      end;


    procedure TCgSparc.a_load_reg_ref(list:TAasmOutput;FromSize,ToSize:TCGSize;reg:tregister;const Ref:TReference);
      var
        op:tasmop;
      begin
        case ToSize of
          { signed integer registers }
          OS_8,
          OS_S8:
            Op:=A_STB;
          OS_16,
          OS_S16:
            Op:=A_STH;
          OS_32,
          OS_S32:
            Op:=A_ST;
          else
            InternalError(2002122100);
        end;
        handle_load_store(list,true,op,reg,ref);
      end;


    procedure TCgSparc.a_load_ref_reg(list:TAasmOutput;FromSize,ToSize:TCgSize;const ref:TReference;reg:tregister);
      var
        op:tasmop;
      begin
        case Fromsize of
          { signed integer registers }
          OS_S8:
            Op:=A_LDSB;{Load Signed Byte}
          OS_8:
            Op:=A_LDUB;{Load Unsigned Byte}
          OS_S16:
            Op:=A_LDSH;{Load Signed Halfword}
          OS_16:
            Op:=A_LDUH;{Load Unsigned Halfword}
          OS_S32,
          OS_32:
            Op:=A_LD;{Load Word}
          OS_S64,
          OS_64:
            Op:=A_LDD;{Load a Long Word}
          else
            InternalError(2002122101);
        end;
        handle_load_store(list,false,op,reg,ref);
      end;


    procedure TCgSparc.a_load_reg_reg(list:TAasmOutput;fromsize,tosize:tcgsize;reg1,reg2:tregister);
      begin
        if (tcgsize2size[tosize]<tcgsize2size[fromsize]) or
           (
            (tcgsize2size[tosize] = tcgsize2size[fromsize]) and
            (tosize <> fromsize) and
            not(fromsize in [OS_32,OS_S32])
           ) then
          begin
{$warning TODO Sign extension}
            case tosize of
              OS_8,OS_S8:
                a_op_const_reg_reg(list,OP_AND,tosize,$ff,reg1,reg2);
              OS_16,OS_S16:
                a_op_const_reg_reg(list,OP_AND,tosize,$ffff,reg1,reg2);
              OS_32,OS_S32:
                begin
                  if reg1<>reg2 then
                    list.Concat(taicpu.op_reg_reg(A_MOV,reg1,reg2));
                end;
              else
                internalerror(2002090901);
            end;
          end
        else
          begin
            { same size, only a register mov required }
            if reg1<>reg2 then
              list.Concat(taicpu.op_reg_reg(A_MOV,reg1,reg2));
          end;
      end;


    procedure TCgSparc.a_loadaddr_ref_reg(list : TAasmOutput;const ref : TReference;r : tregister);
      var
         tmpref : treference;
         hreg : tregister;
      begin
        if (ref.base=NR_NO) and (ref.index<>NR_NO) then
          internalerror(200306171);
        { At least big offset (need SETHI), maybe base and maybe index }
        if assigned(ref.symbol) or
           (ref.offset<simm13lo) or
           (ref.offset>simm13hi) then
          begin
            if (ref.base<>r) and (ref.index<>r) then
              hreg:=r
            else
              hreg:=GetAddressRegister(list);
            reference_reset(tmpref);
            tmpref.symbol := ref.symbol;
            tmpref.offset := ref.offset;
            tmpref.refaddr := addr_hi;
            list.concat(taicpu.op_ref_reg(A_SETHI,tmpref,hreg));
            { Only the low part is left }
            tmpref.refaddr:=addr_lo;
            list.concat(taicpu.op_reg_ref_reg(A_OR,hreg,tmpref,hreg));
            if ref.base<>NR_NO then
              begin
                if ref.index<>NR_NO then
                  begin
                    list.concat(taicpu.op_reg_reg_reg(A_ADD,hreg,ref.base,hreg));
                    list.concat(taicpu.op_reg_reg_reg(A_ADD,hreg,ref.index,r));
                  end
                else
                  list.concat(taicpu.op_reg_reg_reg(A_ADD,hreg,ref.base,r));
              end
            else
              begin
                if hreg<>r then
                  list.Concat(taicpu.op_reg_reg(A_MOV,hreg,r));
              end;
            if hreg<>r then
              UnGetRegister(list,hreg);
          end
        else
        { At least small offset, maybe base and maybe index }
          if ref.offset<>0 then
            begin
              if ref.base<>NR_NO then
                begin
                  if ref.index<>NR_NO then
                    begin
                      if (ref.base<>r) and (ref.index<>r) then
                        hreg:=r
                      else
                        hreg:=GetAddressRegister(list);
                      list.concat(taicpu.op_reg_const_reg(A_ADD,ref.base,ref.offset,hreg));
                      list.concat(taicpu.op_reg_reg_reg(A_ADD,hreg,ref.index,r));
                      if hreg<>r then
                        UnGetRegister(list,hreg);
                    end
                  else
                    list.concat(taicpu.op_reg_const_reg(A_ADD,ref.base,ref.offset,r));
                end
              else
                list.concat(taicpu.op_const_reg(A_MOV,ref.offset,r));
            end
        else
        { Both base and index }
          if ref.index<>NR_NO then
            list.concat(taicpu.op_reg_reg_reg(A_ADD,ref.base,ref.index,r))
        else
        { Only base }
          if ref.base<>NR_NO then
            a_load_reg_reg(list,OS_ADDR,OS_ADDR,ref.base,r)
        else
          { only offset, can be generated by absolute }
          a_load_const_reg(list,OS_ADDR,ref.offset,r);
      end;


    procedure TCgSparc.a_loadfpu_reg_reg(list:TAasmOutput;size:tcgsize;reg1, reg2:tregister);
      const
         FpuMovInstr : Array[OS_F32..OS_F64] of TAsmOp =
           (A_FMOVS,A_FMOVD);
      begin
        if reg1<>reg2 then
          list.concat(taicpu.op_reg_reg(fpumovinstr[size],reg1,reg2));
      end;


    procedure TCgSparc.a_loadfpu_ref_reg(list:TAasmOutput;size:tcgsize;const ref:TReference;reg:tregister);
       const
         FpuLoadInstr : Array[OS_F32..OS_F64] of TAsmOp =
           (A_LDF,A_LDDF);
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
         handle_load_store(list,false,fpuloadinstr[size],reg,ref);
       end;


     procedure TCgSparc.a_loadfpu_reg_ref(list:TAasmOutput;size:tcgsize;reg:tregister;const ref:TReference);
       const
         FpuLoadInstr : Array[OS_F32..OS_F64] of TAsmOp =
           (A_STF,A_STDF);
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
         handle_load_store(list,true,fpuloadinstr[size],reg,ref);
       end;


    procedure TCgSparc.a_op_const_reg(list:TAasmOutput;Op:TOpCG;size:tcgsize;a:aint;reg:TRegister);
      begin
        if Op in [OP_NEG,OP_NOT] then
          internalerror(200306011);
        if (a=0) then
          list.concat(taicpu.op_reg_reg_reg(TOpCG2AsmOp[op],reg,NR_G0,reg))
        else
          handle_reg_const_reg(list,TOpCG2AsmOp[op],reg,a,reg);
      end;


    procedure TCgSparc.a_op_reg_reg(list:TAasmOutput;Op:TOpCG;size:TCGSize;src, dst:TRegister);
      begin
        Case Op of
          OP_NEG,
          OP_NOT:
            list.concat(taicpu.op_reg_reg(TOpCG2AsmOp[op],src,dst));
          else
            list.concat(taicpu.op_reg_reg_reg(TOpCG2AsmOp[op],dst,src,dst));
        end;
      end;


    procedure TCgSparc.a_op_const_reg_reg(list:TAasmOutput;op:TOpCg;size:tcgsize;a:aint;src, dst:tregister);
      var
        power : longInt;
      begin
        case op of
          OP_IMUL :
            begin
              if not(cs_check_overflow in aktlocalswitches) and
                 ispowerof2(a,power) then
                begin
                  { can be done with a shift }
                  inherited a_op_const_reg_reg(list,op,size,a,src,dst);
                  exit;
                end;
            end;
          OP_SUB,
          OP_ADD :
            begin
              if (a=0) then
                begin
                  a_load_reg_reg(list,size,size,src,dst);
                  exit;
                end;
            end;
        end;
        handle_reg_const_reg(list,TOpCG2AsmOp[op],src,a,dst);
      end;


    procedure TCgSparc.a_op_reg_reg_reg(list:TAasmOutput;op:TOpCg;size:tcgsize;src1, src2, dst:tregister);
      begin
        list.concat(taicpu.op_reg_reg_reg(TOpCG2AsmOp[op],src2,src1,dst));
      end;


  {*************** compare instructructions ****************}

    procedure TCgSparc.a_cmp_const_reg_label(list:TAasmOutput;size:tcgsize;cmp_op:topcmp;a:aint;reg:tregister;l:tasmlabel);
      begin
        if (a=0) then
          list.concat(taicpu.op_reg_reg_reg(A_SUBcc,reg,NR_G0,NR_G0))
        else
          handle_reg_const_reg(list,A_SUBcc,reg,a,NR_G0);
        a_jmp_cond(list,cmp_op,l);
      end;


    procedure TCgSparc.a_cmp_reg_reg_label(list:TAasmOutput;size:tcgsize;cmp_op:topcmp;reg1,reg2:tregister;l:tasmlabel);
      begin
        list.concat(taicpu.op_reg_reg_reg(A_SUBcc,reg2,reg1,NR_G0));
        a_jmp_cond(list,cmp_op,l);
      end;


    procedure TCgSparc.a_jmp_always(List:TAasmOutput;l:TAsmLabel);
      begin
        List.Concat(TAiCpu.op_sym(A_BA,objectlibrary.newasmsymbol(l.name,AB_EXTERNAL,AT_FUNCTION)));
        { Delay slot }
        list.Concat(TAiCpu.Op_none(A_NOP));
      end;


    procedure TCgSparc.a_jmp_cond(list:TAasmOutput;cond:TOpCmp;l:TAsmLabel);
      var
        ai:TAiCpu;
      begin
        ai:=TAiCpu.Op_sym(A_Bxx,l);
        ai.SetCondition(TOpCmp2AsmCond[cond]);
        list.Concat(ai);
        { Delay slot }
        list.Concat(TAiCpu.Op_none(A_NOP));
      end;


    procedure TCgSparc.a_jmp_flags(list:TAasmOutput;const f:TResFlags;l:tasmlabel);
      var
        ai : taicpu;
        op : tasmop;
      begin
        if f in [F_FE,F_FNE,F_FG,F_FL,F_FGE,F_FLE] then
          op:=A_FBxx
        else
          op:=A_Bxx;
        ai := Taicpu.op_sym(op,l);
        ai.SetCondition(flags_to_cond(f));
        list.Concat(ai);
        { Delay slot }
        list.Concat(TAiCpu.Op_none(A_NOP));
      end;


    procedure TCgSparc.g_flags2reg(list:TAasmOutput;Size:TCgSize;const f:tresflags;reg:TRegister);
      var
        hl : tasmlabel;
      begin
        objectlibrary.getlabel(hl);
        a_load_const_reg(list,size,1,reg);
        a_jmp_flags(list,f,hl);
        a_load_const_reg(list,size,0,reg);
        a_label(list,hl);
      end;


    procedure TCgSparc.g_overflowCheck(List:TAasmOutput;const Loc:TLocation;def:TDef);
      var
        hl : tasmlabel;
      begin
        if not(cs_check_overflow in aktlocalswitches) then
          exit;
        objectlibrary.getlabel(hl);
        if not((def.deftype=pointerdef)or
              ((def.deftype=orddef)and
               (torddef(def).typ in [u64bit,u16bit,u32bit,u8bit,uchar,bool8bit,bool16bit,bool32bit]))) then
          begin
            //r.enum:=R_CR7;
            //list.concat(taicpu.op_reg(A_MCRXR,r));
            //a_jmp_cond(list,A_Bxx,C_OV,hl)
            a_jmp_always(list,hl)
          end
        else
          a_jmp_cond(list,OC_AE,hl);
        a_call_name(list,'FPC_OVERFLOW');
        a_label(list,hl);
      end;

  { *********** entry/exit code and address loading ************ }

    procedure TCgSparc.g_proc_entry(list : taasmoutput;localsize : longint;nostackframe:boolean);
      begin
        if nostackframe then
          exit;
        { Althogh the SPARC architecture require only word alignment, software
          convention and the operating system require every stack frame to be double word
          aligned }
        LocalSize:=align(LocalSize,8);
        { Execute the SAVE instruction to get a new register window and create a new
          stack frame. In the "SAVE %i6,size,%i6" the first %i6 is related to the state
          before execution of the SAVE instrucion so it is the caller %i6, when the %i6
          after execution of that instruction is the called function stack pointer}
        { constant can be 13 bit signed, since it's negative, size can be max. 4096 }
        if LocalSize>4096 then
          begin
            a_load_const_reg(list,OS_ADDR,-LocalSize,NR_G1);
            list.concat(Taicpu.Op_reg_reg_reg(A_SAVE,NR_STACK_POINTER_REG,NR_G1,NR_STACK_POINTER_REG));
          end
        else
          list.concat(Taicpu.Op_reg_const_reg(A_SAVE,NR_STACK_POINTER_REG,-LocalSize,NR_STACK_POINTER_REG));
      end;


    procedure TCgSparc.g_restore_all_registers(list:TaasmOutput;const funcretparaloc:tparalocation);
      begin
        { The sparc port uses the sparc standard calling convetions so this function has no used }
      end;


    procedure TCgSparc.g_restore_standard_registers(list:taasmoutput);
      begin
        { The sparc port uses the sparc standard calling convetions so this function has no used }
      end;


    procedure TCgSparc.g_proc_exit(list : taasmoutput;parasize:longint;nostackframe:boolean);
      begin
        if nostackframe then
          begin
            { Here we need to use RETL instead of RET so it uses %o7 }
            list.concat(Taicpu.op_none(A_RETL));
            list.concat(Taicpu.op_none(A_NOP))
          end
        else
          begin
            { We use trivial restore in the delay slot of the JMPL instruction, as we
              already set result onto %i0 }
            list.concat(Taicpu.op_none(A_RET));
            list.concat(Taicpu.op_none(A_RESTORE));
          end;
      end;


    procedure TCgSparc.g_save_all_registers(list : taasmoutput);
      begin
        { The sparc port uses the sparc standard calling convetions so this function has no used }
      end;


    procedure TCgSparc.g_save_standard_registers(list : taasmoutput);
      begin
        { The sparc port uses the sparc standard calling convetions so this function has no used }
      end;


    { ************* concatcopy ************ }

    procedure TCgSparc.g_concatcopy(list:taasmoutput;const source,dest:treference;len:aint;delsource,loadref:boolean);
      var
        tmpreg1,
        hreg,
        countreg: TRegister;
        src, dst: TReference;
        lab: tasmlabel;
        count, count2: aint;
        orgsrc, orgdst: boolean;
      begin
        if len>high(longint) then
          internalerror(2002072704);
        reference_reset(src);
        reference_reset(dst);
        { load the address of source into src.base }
        if loadref then
          begin
            src.base:=GetAddressRegister(list);
            a_load_ref_reg(list,OS_32,OS_32,source,src.base);
            orgsrc := false;
          end
        else
          begin
            src.base:=GetAddressRegister(list);
            a_loadaddr_ref_reg(list,source,src.base);
            orgsrc := false;
          end;
        if not orgsrc and delsource then
          reference_release(list,source);
          { load the address of dest into dst.base }
        dst.base:=GetAddressRegister(list);
        a_loadaddr_ref_reg(list,dest,dst.base);
        orgdst := false;
        { generate a loop }
        count:=len div 4;
        if count>4 then
          begin
            { the offsets are zero after the a_loadaddress_ref_reg and just }
            { have to be set to 8. I put an Inc there so debugging may be   }
            { easier (should offset be different from zero here, it will be }
            { easy to notice in the generated assembler                     }
            countreg:=GetIntRegister(list,OS_INT);
            tmpreg1:=GetIntRegister(list,OS_INT);
            a_load_const_reg(list,OS_INT,count,countreg);
            { explicitely allocate R_O0 since it can be used safely here }
            { (for holding date that's being copied)                    }
            objectlibrary.getlabel(lab);
            a_label(list, lab);
            list.concat(taicpu.op_ref_reg(A_LD,src,tmpreg1));
            list.concat(taicpu.op_reg_ref(A_ST,tmpreg1,dst));
            list.concat(taicpu.op_reg_const_reg(A_ADD,src.base,4,src.base));
            list.concat(taicpu.op_reg_const_reg(A_ADD,dst.base,4,dst.base));
            list.concat(taicpu.op_reg_const_reg(A_SUBcc,countreg,1,countreg));
            a_jmp_cond(list,OC_NE,lab);
            list.concat(taicpu.op_none(A_NOP));
            { keep the registers alive }
            list.concat(taicpu.op_reg_reg(A_MOV,countreg,countreg));
            list.concat(taicpu.op_reg_reg(A_MOV,src.base,src.base));
            list.concat(taicpu.op_reg_reg(A_MOV,dst.base,dst.base));
            UnGetRegister(list,countreg);
            len := len mod 4;
          end;
        { unrolled loop }
        count:=len div 4;
        if count>0 then
          begin
            tmpreg1:=GetIntRegister(list,OS_INT);
            for count2 := 1 to count do
              begin
                list.concat(taicpu.op_ref_reg(A_LD,src,tmpreg1));
                list.concat(taicpu.op_reg_ref(A_ST,tmpreg1,dst));
                inc(src.offset,4);
                inc(dst.offset,4);
              end;
            len := len mod 4;
          end;
        if (len and 4) <> 0 then
          begin
            hreg:=GetIntRegister(list,OS_INT);
            a_load_ref_reg(list,OS_32,OS_32,src,hreg);
            a_load_reg_ref(list,OS_32,OS_32,hreg,dst);
            inc(src.offset,4);
            inc(dst.offset,4);
            UnGetRegister(list,hreg);
          end;
        { copy the leftovers }
        if (len and 2) <> 0 then
          begin
            hreg:=GetIntRegister(list,OS_INT);
            a_load_ref_reg(list,OS_16,OS_16,src,hreg);
            a_load_reg_ref(list,OS_16,OS_16,hreg,dst);
            inc(src.offset,2);
            inc(dst.offset,2);
            UnGetRegister(list,hreg);
          end;
        if (len and 1) <> 0 then
          begin
            hreg:=GetIntRegister(list,OS_INT);
            a_load_ref_reg(list,OS_8,OS_8,src,hreg);
            a_load_reg_ref(list,OS_8,OS_8,hreg,dst);
            UnGetRegister(list,hreg);
          end;
        if orgsrc then
          begin
            if delsource then
              reference_release(list,source);
          end
        else
          UnGetRegister(list,src.base);
        if not orgdst then
          UnGetRegister(list,dst.base);
      end;

{****************************************************************************
                               TCG64Sparc
****************************************************************************}

    procedure TCg64Sparc.get_64bit_ops(op:TOpCG;var op1,op2:TAsmOp);
      begin
        case op of
          OP_ADD :
            begin
              op1:=A_ADDCC;
              op2:=A_ADDX;
            end;
          OP_SUB :
            begin
              op1:=A_SUBCC;
              op2:=A_SUBX;
            end;
          OP_XOR :
            begin
              op1:=A_XOR;
              op2:=A_XOR;
            end;
          OP_OR :
            begin
              op1:=A_OR;
              op2:=A_OR;
            end;
          OP_AND :
            begin
              op1:=A_AND;
              op2:=A_AND;
            end;
          else
            internalerror(200203241);
        end;
      end;


    procedure TCg64Sparc.a_op64_reg_reg(list:TAasmOutput;op:TOpCG;regsrc,regdst:TRegister64);
      var
        op1,op2 : TAsmOp;
      begin
        case op of
          OP_NEG :
            begin
              list.concat(taicpu.op_reg_reg_reg(A_XNOR,NR_G0,regsrc.reghi,regdst.reghi));
              list.concat(taicpu.op_reg_reg_reg(A_SUBcc,NR_G0,regsrc.reglo,regdst.reglo));
              list.concat(taicpu.op_reg_const_reg(A_ADDX,regdst.reglo,-1,regdst.reglo));
              exit;
            end;
          OP_NOT :
            begin
              list.concat(taicpu.op_reg_reg_reg(A_XNOR,regsrc.reglo,NR_G0,regdst.reglo));
              list.concat(taicpu.op_reg_reg_reg(A_XNOR,regsrc.reghi,NR_G0,regdst.reghi));
              exit;
            end;
        end;
        get_64bit_ops(op,op1,op2);
        list.concat(taicpu.op_reg_reg_reg(op1,regdst.reglo,regsrc.reglo,regdst.reglo));
        list.concat(taicpu.op_reg_reg_reg(op2,regdst.reghi,regsrc.reghi,regdst.reghi));
      end;


    procedure TCg64Sparc.a_op64_const_reg(list:TAasmOutput;op:TOpCG;value:int64;regdst:TRegister64);
      var
        op1,op2:TAsmOp;
      begin
        case op of
          OP_NEG,
          OP_NOT :
            internalerror(200306017);
        end;
        get_64bit_ops(op,op1,op2);
        tcgsparc(cg).handle_reg_const_reg(list,op1,regdst.reglo,aint(lo(value)),regdst.reglo);
        tcgsparc(cg).handle_reg_const_reg(list,op1,regdst.reghi,aint(hi(value)),regdst.reghi);
      end;


    procedure tcg64sparc.a_op64_const_reg_reg(list: taasmoutput;op:TOpCG;value : int64; regsrc,regdst : tregister64);
      var
        op1,op2:TAsmOp;
      begin
        case op of
          OP_NEG,
          OP_NOT :
            internalerror(200306017);
        end;
        get_64bit_ops(op,op1,op2);
        tcgsparc(cg).handle_reg_const_reg(list,op1,regsrc.reglo,aint(lo(value)),regdst.reglo);
        tcgsparc(cg).handle_reg_const_reg(list,op1,regsrc.reghi,aint(hi(value)),regdst.reghi);
      end;


    procedure tcg64sparc.a_op64_reg_reg_reg(list: taasmoutput;op:TOpCG;regsrc1,regsrc2,regdst : tregister64);
      var
        op1,op2:TAsmOp;
      begin
        case op of
          OP_NEG,
          OP_NOT :
            internalerror(200306017);
        end;
        get_64bit_ops(op,op1,op2);
        list.concat(taicpu.op_reg_reg_reg(op1,regsrc2.reglo,regsrc1.reglo,regdst.reglo));
        list.concat(taicpu.op_reg_reg_reg(op2,regsrc2.reghi,regsrc1.reghi,regdst.reghi));
      end;


begin
  cg:=TCgSparc.Create;
  cg64:=TCg64Sparc.Create;
end.
{
  $Log$
  Revision 1.86  2004-08-25 20:40:04  florian
    * fixed absolute on sparc

  Revision 1.85  2004/08/24 21:02:32  florian
    * fixed longbool(<int64>) on sparc

  Revision 1.84  2004/06/20 08:55:32  florian
    * logs truncated

  Revision 1.83  2004/06/16 20:07:10  florian
    * dwarf branch merged

  Revision 1.82.2.9  2004/06/02 19:05:16  peter
    * use a_load_const_reg to load const

  Revision 1.82.2.8  2004/06/02 16:07:40  peter
    * implement op64_reg_reg_reg

  Revision 1.82.2.7  2004/05/31 22:07:54  peter
    * don't use float in concatcopy

  Revision 1.82.2.6  2004/05/30 17:54:14  florian
    + implemented cmp64bit
    * started to fix spilling
    * fixed int64 sub partially

}
