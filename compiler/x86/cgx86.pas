{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    This unit implements the common parts of the code generator for the i386 and the x86-64.

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
{ This unit implements the common parts of the code generator for the i386 and the x86-64.
}
unit cgx86;

{$i fpcdefs.inc}

  interface

    uses
       cgbase,cgobj,
       aasmbase,aasmtai,aasmcpu,
       cpubase,cpuinfo,rgobj,rgx86,rgcpu,
       symconst,symtype;

    type
      tcgx86 = class(tcg)
        rgfpu   : Trgx86fpu;
        procedure done_register_allocators;override;

        function getfpuregister(list:Taasmoutput;size:Tcgsize):Tregister;override;
        function getmmxregister(list:Taasmoutput):Tregister;

        procedure getexplicitregister(list:Taasmoutput;r:Tregister);override;
        procedure ungetregister(list:Taasmoutput;r:Tregister);override;
        procedure allocexplicitregisters(list:Taasmoutput;rt:Tregistertype;r:Tcpuregisterset);override;
        procedure deallocexplicitregisters(list:Taasmoutput;rt:Tregistertype;r:Tcpuregisterset);override;
        function  uses_registers(rt:Tregistertype):boolean;override;
        procedure add_reg_instruction(instr:Tai;r:tregister);override;
        procedure dec_fpu_stack;
        procedure inc_fpu_stack;

        { passing parameters, per default the parameter is pushed }
        { nr gives the number of the parameter (enumerated from   }
        { left to right), this allows to move the parameter to    }
        { register, if the cpu supports register calling          }
        { conventions                                             }
        procedure a_param_reg(list : taasmoutput;size : tcgsize;r : tregister;const locpara : tparalocation);override;
        procedure a_param_const(list : taasmoutput;size : tcgsize;a : aword;const locpara : tparalocation);override;
        procedure a_param_ref(list : taasmoutput;size : tcgsize;const r : treference;const locpara : tparalocation);override;
        procedure a_paramaddr_ref(list : taasmoutput;const r : treference;const locpara : tparalocation);override;

        procedure a_call_name(list : taasmoutput;const s : string);override;
        procedure a_call_reg(list : taasmoutput;reg : tregister);override;

        procedure a_op_const_reg(list : taasmoutput; Op: TOpCG; size: TCGSize; a: AWord; reg: TRegister); override;
        procedure a_op_const_ref(list : taasmoutput; Op: TOpCG; size: TCGSize; a: AWord; const ref: TReference); override;
        procedure a_op_reg_reg(list : taasmoutput; Op: TOpCG; size: TCGSize; src, dst: TRegister); override;
        procedure a_op_ref_reg(list : taasmoutput; Op: TOpCG; size: TCGSize; const ref: TReference; reg: TRegister); override;
        procedure a_op_reg_ref(list : taasmoutput; Op: TOpCG; size: TCGSize;reg: TRegister; const ref: TReference); override;

        procedure a_op_const_reg_reg(list: taasmoutput; op: TOpCg;
          size: tcgsize; a: aword; src, dst: tregister); override;
        procedure a_op_reg_reg_reg(list: taasmoutput; op: TOpCg;
          size: tcgsize; src1, src2, dst: tregister); override;

        { move instructions }
        procedure a_load_const_reg(list : taasmoutput; tosize: tcgsize; a : aword;reg : tregister);override;
        procedure a_load_const_ref(list : taasmoutput; tosize: tcgsize; a : aword;const ref : treference);override;
        procedure a_load_reg_ref(list : taasmoutput;fromsize,tosize: tcgsize; reg : tregister;const ref : treference);override;
        procedure a_load_ref_reg(list : taasmoutput;fromsize,tosize: tcgsize;const ref : treference;reg : tregister);override;
        procedure a_load_reg_reg(list : taasmoutput;fromsize,tosize: tcgsize;reg1,reg2 : tregister);override;
        procedure a_loadaddr_ref_reg(list : taasmoutput;const ref : treference;r : tregister);override;

        { fpu move instructions }
        procedure a_loadfpu_reg_reg(list: taasmoutput; size: tcgsize; reg1, reg2: tregister); override;
        procedure a_loadfpu_ref_reg(list: taasmoutput; size: tcgsize; const ref: treference; reg: tregister); override;
        procedure a_loadfpu_reg_ref(list: taasmoutput; size: tcgsize; reg: tregister; const ref: treference); override;

        { vector register move instructions }
        procedure a_loadmm_reg_reg(list: taasmoutput; fromsize, tosize : tcgsize;reg1, reg2: tregister;shuffle : pmmshuffle); override;
        procedure a_loadmm_ref_reg(list: taasmoutput; fromsize, tosize : tcgsize;const ref: treference; reg: tregister;shuffle : pmmshuffle); override;
        procedure a_loadmm_reg_ref(list: taasmoutput; fromsize, tosize : tcgsize;reg: tregister; const ref: treference;shuffle : pmmshuffle); override;
        procedure a_opmm_ref_reg(list: taasmoutput; Op: TOpCG; size : tcgsize;const ref: treference; reg: tregister;shuffle : pmmshuffle); override;
        procedure a_opmm_reg_reg(list: taasmoutput; Op: TOpCG; size : tcgsize;src,dst: tregister;shuffle : pmmshuffle);override;

        {  comparison operations }
        procedure a_cmp_const_reg_label(list : taasmoutput;size : tcgsize;cmp_op : topcmp;a : aword;reg : tregister;
          l : tasmlabel);override;
        procedure a_cmp_const_ref_label(list : taasmoutput;size : tcgsize;cmp_op : topcmp;a : aword;const ref : treference;
          l : tasmlabel);override;
        procedure a_cmp_reg_reg_label(list : taasmoutput;size : tcgsize;cmp_op : topcmp;reg1,reg2 : tregister;l : tasmlabel); override;
        procedure a_cmp_ref_reg_label(list : taasmoutput;size : tcgsize;cmp_op : topcmp;const ref: treference; reg : tregister; l : tasmlabel); override;

        procedure a_jmp_name(list : taasmoutput;const s : string);override;
        procedure a_jmp_always(list : taasmoutput;l: tasmlabel); override;
        procedure a_jmp_flags(list : taasmoutput;const f : TResFlags;l: tasmlabel); override;

        procedure g_flags2reg(list: taasmoutput; size: TCgSize; const f: tresflags; reg: TRegister); override;
        procedure g_flags2ref(list: taasmoutput; size: TCgSize; const f: tresflags; const ref: TReference); override;

        procedure g_concatcopy(list : taasmoutput;const source,dest : treference;len : aword; delsource,loadref : boolean);override;

        procedure g_exception_reason_save(list : taasmoutput; const href : treference);override;
        procedure g_exception_reason_save_const(list : taasmoutput; const href : treference; a: aword);override;
        procedure g_exception_reason_load(list : taasmoutput; const href : treference);override;

        { entry/exit code helpers }
        procedure g_releasevaluepara_openarray(list : taasmoutput;const ref:treference);override;
        procedure g_interrupt_stackframe_entry(list : taasmoutput);override;
        procedure g_interrupt_stackframe_exit(list : taasmoutput;accused,acchiused:boolean);override;
        procedure g_profilecode(list : taasmoutput);override;
        procedure g_stackpointer_alloc(list : taasmoutput;localsize : longint);override;
        procedure g_stackframe_entry(list : taasmoutput;localsize : longint);override;
        procedure g_restore_frame_pointer(list : taasmoutput);override;
        procedure g_return_from_proc(list : taasmoutput;parasize : aword);override;
        procedure g_save_standard_registers(list:Taasmoutput);override;
        procedure g_restore_standard_registers(list:Taasmoutput);override;

        procedure g_overflowcheck(list: taasmoutput; const l:tlocation;def:tdef);override;

      protected
        procedure a_jmp_cond(list : taasmoutput;cond : TOpCmp;l: tasmlabel);
        procedure check_register_size(size:tcgsize;reg:tregister);

        procedure opmm_loc_reg(list: taasmoutput; Op: TOpCG; size : tcgsize;loc : tlocation;dst: tregister; shuffle : pmmshuffle);
      private
        procedure sizes2load(s1,s2 : tcgsize;var op: tasmop; var s3: topsize);

        procedure floatload(list: taasmoutput; t : tcgsize;const ref : treference);
        procedure floatstore(list: taasmoutput; t : tcgsize;const ref : treference);
        procedure floatloadops(t : tcgsize;var op : tasmop;var s : topsize);
        procedure floatstoreops(t : tcgsize;var op : tasmop;var s : topsize);
      end;

    function use_sse(def : tdef) : boolean;

   const
{$ifdef x86_64}
      TCGSize2OpSize: Array[tcgsize] of topsize =
        (S_NO,S_B,S_W,S_L,S_Q,S_Q,S_B,S_W,S_L,S_Q,S_Q,
         S_FS,S_FL,S_FX,S_IQ,S_FXX,
         S_NO,S_NO,S_NO,S_MD,S_NO,S_NO,S_NO,S_NO,S_NO,S_NO);
{$else x86_64}
      TCGSize2OpSize: Array[tcgsize] of topsize =
        (S_NO,S_B,S_W,S_L,S_L,S_L,S_B,S_W,S_L,S_L,S_L,
         S_FS,S_FL,S_FX,S_IQ,S_FXX,
         S_NO,S_NO,S_NO,S_MD,S_NO,S_NO,S_NO,S_NO,S_NO,S_NO);
{$endif x86_64}

{$ifndef NOTARGETWIN32}
      winstackpagesize = 4096;
{$endif NOTARGETWIN32}


  implementation

    uses
       globtype,globals,verbose,systems,cutils,
       cgutils,
       symdef,defutil,paramgr,tgobj,procinfo;

    const
      TOpCG2AsmOp: Array[topcg] of TAsmOp = (A_NONE,A_ADD,A_AND,A_DIV,
                            A_IDIV,A_MUL, A_IMUL, A_NEG,A_NOT,A_OR,
                            A_SAR,A_SHL,A_SHR,A_SUB,A_XOR);

      TOpCmp2AsmCond: Array[topcmp] of TAsmCond = (C_NONE,
          C_E,C_G,C_L,C_GE,C_LE,C_NE,C_BE,C_B,C_AE,C_A);

    function use_sse(def : tdef) : boolean;
      begin
        use_sse:=(is_single(def) and (aktfputype in sse_singlescalar)) or
          (is_double(def) and (aktfputype in sse_doublescalar));
      end;


    procedure Tcgx86.done_register_allocators;
      begin
        rg[R_INTREGISTER].free;
        rg[R_MMREGISTER].free;
        rg[R_MMXREGISTER].free;
        rgfpu.free;
        inherited done_register_allocators;
      end;


    function Tcgx86.getfpuregister(list:Taasmoutput;size:Tcgsize):Tregister;
      begin
        result:=rgfpu.getregisterfpu(list);
      end;

    function Tcgx86.getmmxregister(list:Taasmoutput):Tregister;

    begin
      if not assigned(rg[R_MMXREGISTER]) then
        internalerror(200312124);
      result:=rg[R_MMXREGISTER].getregister(list,R_SUBNONE);
    end;

    procedure Tcgx86.getexplicitregister(list:Taasmoutput;r:Tregister);
      begin
        if getregtype(r)=R_FPUREGISTER then
          internalerror(2003121210)
        else
          inherited getexplicitregister(list,r);
      end;


    procedure tcgx86.ungetregister(list:Taasmoutput;r:Tregister);
      begin
        if getregtype(r)=R_FPUREGISTER then
          rgfpu.ungetregisterfpu(list,r)
        else
          inherited ungetregister(list,r);
      end;


    procedure Tcgx86.allocexplicitregisters(list:Taasmoutput;rt:Tregistertype;r:Tcpuregisterset);
      begin
        if rt<>R_FPUREGISTER then
          inherited allocexplicitregisters(list,rt,r);
      end;


    procedure Tcgx86.deallocexplicitregisters(list:Taasmoutput;rt:Tregistertype;r:Tcpuregisterset);
      begin
        if rt<>R_FPUREGISTER then
          inherited deallocexplicitregisters(list,rt,r);
      end;


    function  Tcgx86.uses_registers(rt:Tregistertype):boolean;
      begin
        if rt=R_FPUREGISTER then
          result:=false
        else
          result:=inherited uses_registers(rt);
      end;


    procedure tcgx86.add_reg_instruction(instr:Tai;r:tregister);
      begin
        if getregtype(r)<>R_FPUREGISTER then
          inherited add_reg_instruction(instr,r);
      end;


    procedure tcgx86.dec_fpu_stack;
      begin
        dec(rgfpu.fpuvaroffset);
      end;


    procedure tcgx86.inc_fpu_stack;
      begin
        inc(rgfpu.fpuvaroffset);
      end;


{****************************************************************************
                       This is private property, keep out! :)
****************************************************************************}

    procedure tcgx86.sizes2load(s1,s2 : tcgsize; var op: tasmop; var s3: topsize);

       begin
         case s2 of
           OS_8,OS_S8 :
             if S1 in [OS_8,OS_S8] then
               s3 := S_B
             else
               internalerror(200109221);
           OS_16,OS_S16:
             case s1 of
               OS_8,OS_S8:
                 s3 := S_BW;
               OS_16,OS_S16:
                 s3 := S_W;
               else
                 internalerror(200109222);
             end;
           OS_32,OS_S32:
             case s1 of
               OS_8,OS_S8:
                 s3 := S_BL;
               OS_16,OS_S16:
                 s3 := S_WL;
               OS_32,OS_S32:
                 s3 := S_L;
               else
                 internalerror(200109223);
             end;
{$ifdef x86_64}
           OS_64,OS_S64:
             case s1 of
               OS_8,OS_S8:
                 s3 := S_BL;
               OS_16,OS_S16:
                 s3 := S_WL;
               OS_32,OS_S32:
                 s3 := S_L;
               OS_64,OS_S64:
                 s3 := S_Q;
               else
                 internalerror(200304302);
             end;
{$endif x86_64}
           else
             internalerror(200109227);
         end;
         if s3 in [S_B,S_W,S_L,S_Q] then
           op := A_MOV
         else if s1 in [OS_8,OS_16,OS_32,OS_64] then
           op := A_MOVZX
         else
           op := A_MOVSX;
       end;


    procedure tcgx86.floatloadops(t : tcgsize;var op : tasmop;var s : topsize);

      begin
         case t of
            OS_F32 :
              begin
                 op:=A_FLD;
                 s:=S_FS;
              end;
            OS_F64 :
              begin
                 op:=A_FLD;
                 { ???? }
                 s:=S_FL;
              end;
            OS_F80 :
              begin
                 op:=A_FLD;
                 s:=S_FX;
              end;
            OS_C64 :
              begin
                 op:=A_FILD;
                 s:=S_IQ;
              end;
            else
              internalerror(200204041);
         end;
      end;


    procedure tcgx86.floatload(list: taasmoutput; t : tcgsize;const ref : treference);

      var
         op : tasmop;
         s : topsize;

      begin
         floatloadops(t,op,s);
         list.concat(Taicpu.Op_ref(op,s,ref));
         inc_fpu_stack;
      end;


    procedure tcgx86.floatstoreops(t : tcgsize;var op : tasmop;var s : topsize);

      begin
         case t of
            OS_F32 :
              begin
                 op:=A_FSTP;
                 s:=S_FS;
              end;
            OS_F64 :
              begin
                 op:=A_FSTP;
                 s:=S_FL;
              end;
            OS_F80 :
              begin
                  op:=A_FSTP;
                  s:=S_FX;
               end;
            OS_C64 :
               begin
                  op:=A_FISTP;
                  s:=S_IQ;
               end;
            else
               internalerror(200204042);
         end;
      end;


    procedure tcgx86.floatstore(list: taasmoutput; t : tcgsize;const ref : treference);

      var
         op : tasmop;
         s : topsize;

      begin
         floatstoreops(t,op,s);
         list.concat(Taicpu.Op_ref(op,s,ref));
         dec_fpu_stack;
      end;


    procedure tcgx86.check_register_size(size:tcgsize;reg:tregister);
      begin
        if TCGSize2OpSize[size]<>TCGSize2OpSize[reg_cgsize(reg)] then
          internalerror(200306031);
      end;


{****************************************************************************
                              Assembler code
****************************************************************************}

    procedure tcgx86.a_jmp_name(list : taasmoutput;const s : string);
      begin
        list.concat(taicpu.op_sym(A_JMP,S_NO,objectlibrary.newasmsymbol(s,AB_EXTERNAL,AT_FUNCTION)));
      end;


    { currently does nothing }
    procedure tcgx86.a_jmp_always(list : taasmoutput;l: tasmlabel);
     begin
       a_jmp_cond(list, OC_NONE, l);
     end;

    { we implement the following routines because otherwise we can't }
    { instantiate the class since it's abstract                      }

    procedure tcgx86.a_param_reg(list : taasmoutput;size : tcgsize;r : tregister;const locpara : tparalocation);
      var
        pushsize : tcgsize;
      begin
        check_register_size(size,r);
        with locpara do
          if (loc=LOC_REFERENCE) and
             (reference.index=NR_STACK_POINTER_REG) then
            begin
              pushsize:=int_cgsize(alignment);
              list.concat(taicpu.op_reg(A_PUSH,tcgsize2opsize[pushsize],makeregsize(r,pushsize)));
            end
          else
            inherited a_param_reg(list,size,r,locpara);
      end;


    procedure tcgx86.a_param_const(list : taasmoutput;size : tcgsize;a : aword;const locpara : tparalocation);
      var
        pushsize : tcgsize;
      begin
        with locpara do
          if (loc=LOC_REFERENCE) and
             (reference.index=NR_STACK_POINTER_REG) then
            begin
              pushsize:=int_cgsize(alignment);
              list.concat(taicpu.op_const(A_PUSH,tcgsize2opsize[pushsize],a));
            end
          else
            inherited a_param_const(list,size,a,locpara);
      end;


    procedure tcgx86.a_param_ref(list : taasmoutput;size : tcgsize;const r : treference;const locpara : tparalocation);
      var
        pushsize : tcgsize;
        tmpreg : tregister;
      begin
        with locpara do
          if (loc=LOC_REFERENCE) and
             (reference.index=NR_STACK_POINTER_REG) then
            begin
              pushsize:=int_cgsize(alignment);
              if tcgsize2size[size]<alignment then
                begin
                  tmpreg:=getintregister(list,pushsize);
                  a_load_ref_reg(list,size,pushsize,r,tmpreg);
                  list.concat(taicpu.op_reg(A_PUSH,TCgsize2opsize[pushsize],tmpreg));
                  ungetregister(list,tmpreg);
                end
              else
                list.concat(taicpu.op_ref(A_PUSH,TCgsize2opsize[pushsize],r));
            end
          else
            inherited a_param_ref(list,size,r,locpara);
      end;


    procedure tcgx86.a_paramaddr_ref(list : taasmoutput;const r : treference;const locpara : tparalocation);
      var
        tmpreg : tregister;
        opsize : topsize;
      begin
        with r do
          begin
            if (segment<>NR_NO) then
              cgmessage(cg_e_cant_use_far_pointer_there);
            with locpara do
              if (locpara.loc=LOC_REFERENCE) and
                 (locpara.reference.index=NR_STACK_POINTER_REG) then
                begin
                  opsize:=tcgsize2opsize[OS_ADDR];
                  if (base=NR_NO) and (index=NR_NO) then
                    begin
                      if assigned(symbol) then
                        list.concat(Taicpu.Op_sym_ofs(A_PUSH,opsize,symbol,offset))
                      else
                        list.concat(Taicpu.Op_const(A_PUSH,opsize,offset));
                    end
                  else if (base=NR_NO) and (index<>NR_NO) and
                          (offset=0) and (scalefactor=0) and (symbol=nil) then
                    list.concat(Taicpu.Op_reg(A_PUSH,opsize,index))
                  else if (base<>NR_NO) and (index=NR_NO) and
                          (offset=0) and (symbol=nil) then
                    list.concat(Taicpu.Op_reg(A_PUSH,opsize,base))
                  else
                    begin
                      tmpreg:=getaddressregister(list);
                      a_loadaddr_ref_reg(list,r,tmpreg);
                      ungetregister(list,tmpreg);
                      list.concat(taicpu.op_reg(A_PUSH,opsize,tmpreg));
                    end;
                end
              else
                inherited a_paramaddr_ref(list,r,locpara);
        end;
      end;


    procedure tcgx86.a_call_name(list : taasmoutput;const s : string);
      begin
        list.concat(taicpu.op_sym(A_CALL,S_NO,objectlibrary.newasmsymbol(s,AB_EXTERNAL,AT_FUNCTION)));
      end;


    procedure tcgx86.a_call_reg(list : taasmoutput;reg : tregister);
      begin
        list.concat(taicpu.op_reg(A_CALL,S_NO,reg));
      end;


{********************** load instructions ********************}

    procedure tcgx86.a_load_const_reg(list : taasmoutput; tosize: TCGSize; a : aword; reg : TRegister);

      begin
        check_register_size(tosize,reg);
        { the optimizer will change it to "xor reg,reg" when loading zero, }
        { no need to do it here too (JM)                                   }
        list.concat(taicpu.op_const_reg(A_MOV,TCGSize2OpSize[tosize],a,reg))
      end;


    procedure tcgx86.a_load_const_ref(list : taasmoutput; tosize: tcgsize; a : aword;const ref : treference);

      begin
          list.concat(taicpu.op_const_ref(A_MOV,TCGSize2OpSize[tosize],a,ref));
      end;


    procedure tcgx86.a_load_reg_ref(list : taasmoutput; fromsize,tosize: TCGSize; reg : tregister;const ref : treference);
      var
        op: tasmop;
        s: topsize;
        tmpreg : tregister;
      begin
        check_register_size(fromsize,reg);
        sizes2load(fromsize,tosize,op,s);
        case s of
{$ifdef x86_64}
          S_BQ,S_WQ,S_LQ,
{$endif x86_64}
          S_BW,S_BL,S_WL :
            begin
              tmpreg:=getintregister(list,tosize);
{$ifdef x86_64}
              { zero extensions to 64 bit on the x86_64 are simply done by writting to the lower 32 bit
                which clears the upper 64 bit too, so it could be that s is S_L while the reg is
                64 bit (FK) }
              if s in [S_BL,S_WL,S_L] then
                tmpreg:=makeregsize(tmpreg,OS_32);
{$endif x86_64}
              list.concat(taicpu.op_reg_reg(op,s,reg,tmpreg));
              a_load_reg_ref(list,tosize,tosize,tmpreg,ref);
              ungetregister(list,tmpreg);
            end;
        else
          list.concat(taicpu.op_reg_ref(op,s,reg,ref));
        end;
      end;


    procedure tcgx86.a_load_ref_reg(list : taasmoutput;fromsize,tosize : tcgsize;const ref: treference;reg : tregister);
      var
        op: tasmop;
        s: topsize;
      begin
        check_register_size(tosize,reg);
        sizes2load(fromsize,tosize,op,s);
 {$ifdef x86_64}
        { zero extensions to 64 bit on the x86_64 are simply done by writting to the lower 32 bit
          which clears the upper 64 bit too, so it could be that s is S_L while the reg is
          64 bit (FK) }
        if s in [S_BL,S_WL,S_L] then
          reg:=makeregsize(reg,OS_32);
{$endif x86_64}
        list.concat(taicpu.op_ref_reg(op,s,ref,reg));
      end;


    procedure tcgx86.a_load_reg_reg(list : taasmoutput;fromsize,tosize : tcgsize;reg1,reg2 : tregister);
      var
        op: tasmop;
        s: topsize;
        instr:Taicpu;
      begin
        check_register_size(fromsize,reg1);
        check_register_size(tosize,reg2);
        if tcgsize2size[fromsize]>tcgsize2size[tosize] then
          begin
            reg1:=makeregsize(reg1,tosize);
            s:=tcgsize2opsize[tosize];
            op:=A_MOV;
          end
        else
          sizes2load(fromsize,tosize,op,s);
{$ifdef x86_64}
        { zero extensions to 64 bit on the x86_64 are simply done by writting to the lower 32 bit
          which clears the upper 64 bit too, so it could be that s is S_L while the reg is
          64 bit (FK) }
        if s in [S_BL,S_WL,S_L] then
          reg2:=makeregsize(reg2,OS_32);
{$endif x86_64}
        instr:=taicpu.op_reg_reg(op,s,reg1,reg2);
        { Notify the register allocator that we have written a move instruction so
          it can try to eliminate it. }
        add_move_instruction(instr);
        list.concat(instr);
      end;


    procedure tcgx86.a_loadaddr_ref_reg(list : taasmoutput;const ref : treference;r : tregister);
      begin
        with ref do
          if (base=NR_NO) and (index=NR_NO) then
            begin
              if assigned(ref.symbol) then
                list.concat(Taicpu.op_sym_ofs_reg(A_MOV,tcgsize2opsize[OS_ADDR],symbol,offset,r))
              else
                a_load_const_reg(list,OS_ADDR,offset,r);
            end
          else if (base=NR_NO) and (index<>NR_NO) and
                  (offset=0) and (scalefactor=0) and (symbol=nil) then
            a_load_reg_reg(list,OS_ADDR,OS_ADDR,index,r)
          else if (base<>NR_NO) and (index=NR_NO) and
                  (offset=0) and (symbol=nil) then
            a_load_reg_reg(list,OS_ADDR,OS_ADDR,base,r)
          else
            list.concat(taicpu.op_ref_reg(A_LEA,tcgsize2opsize[OS_ADDR],ref,r));
      end;


    { all fpu load routines expect that R_ST[0-7] means an fpu regvar and }
    { R_ST means "the current value at the top of the fpu stack" (JM)     }
    procedure tcgx86.a_loadfpu_reg_reg(list: taasmoutput; size: tcgsize; reg1, reg2: tregister);

       begin
         if (reg1<>NR_ST) then
           begin
             list.concat(taicpu.op_reg(A_FLD,S_NO,rgfpu.correct_fpuregister(reg1,rgfpu.fpuvaroffset)));
             inc_fpu_stack;
           end;
         if (reg2<>NR_ST) then
           begin
             list.concat(taicpu.op_reg(A_FSTP,S_NO,rgfpu.correct_fpuregister(reg2,rgfpu.fpuvaroffset)));
             dec_fpu_stack;
           end;
       end;


    procedure tcgx86.a_loadfpu_ref_reg(list: taasmoutput; size: tcgsize; const ref: treference; reg: tregister);
       begin
         floatload(list,size,ref);
         if (reg<>NR_ST) then
           a_loadfpu_reg_reg(list,size,NR_ST,reg);
       end;


    procedure tcgx86.a_loadfpu_reg_ref(list: taasmoutput; size: tcgsize; reg: tregister; const ref: treference);
       begin
         if reg<>NR_ST then
           a_loadfpu_reg_reg(list,size,reg,NR_ST);
         floatstore(list,size,ref);
       end;


    function get_scalar_mm_op(fromsize,tosize : tcgsize) : tasmop;
      begin
        case fromsize of
          OS_F32:
            case tosize of
              OS_F64:
                result:=A_CVTSS2SD;
              OS_F32:
                result:=A_MOVSS;
              else
                internalerror(200312205);
            end;
          OS_F64:
            case tosize of
              OS_F64:
                result:=A_MOVSD;
              OS_F32:
                result:=A_CVTSD2SS;
              else
                internalerror(200312204);
            end;
          else
            internalerror(200312203);
        end;
      end;


    procedure tcgx86.a_loadmm_reg_reg(list: taasmoutput; fromsize, tosize : tcgsize;reg1, reg2: tregister;shuffle : pmmshuffle);
       begin
         if shuffle=nil then
           begin
             if fromsize=tosize then
               list.concat(taicpu.op_reg_reg(A_MOVAPS,S_NO,reg1,reg2))
             else
               internalerror(200312202);
           end
         else if shufflescalar(shuffle) then
           list.concat(taicpu.op_reg_reg(get_scalar_mm_op(fromsize,tosize),S_NO,reg1,reg2))
         else
           internalerror(200312201);
       end;


    procedure tcgx86.a_loadmm_ref_reg(list: taasmoutput; fromsize, tosize : tcgsize;const ref: treference; reg: tregister;shuffle : pmmshuffle);
       begin
         if shuffle=nil then
           begin
             list.concat(taicpu.op_ref_reg(A_MOVQ,S_NO,ref,reg));
           end
         else if shufflescalar(shuffle) then
           list.concat(taicpu.op_ref_reg(get_scalar_mm_op(fromsize,tosize),S_NO,ref,reg))
         else
           internalerror(200312252);
       end;


    procedure tcgx86.a_loadmm_reg_ref(list: taasmoutput; fromsize, tosize : tcgsize;reg: tregister; const ref: treference;shuffle : pmmshuffle);
       begin
         if shuffle=nil then
           begin
             list.concat(taicpu.op_ref_reg(A_MOVQ,S_NO,ref,reg));
           end
         else if shufflescalar(shuffle) then
           list.concat(taicpu.op_reg_ref(get_scalar_mm_op(fromsize,tosize),S_NO,reg,ref))
         else
           internalerror(200312252);
       end;


    procedure tcgx86.a_opmm_ref_reg(list: taasmoutput; Op: TOpCG; size : tcgsize;const ref: treference; reg: tregister;shuffle : pmmshuffle);
      var
        l : tlocation;
      begin
        l.loc:=LOC_REFERENCE;
        l.reference:=ref;
        l.size:=size;
        opmm_loc_reg(list,op,size,l,reg,shuffle);
      end;


    procedure tcgx86.a_opmm_reg_reg(list: taasmoutput; Op: TOpCG; size : tcgsize;src,dst: tregister;shuffle : pmmshuffle);
     var
       l : tlocation;
     begin
       l.loc:=LOC_MMREGISTER;
       l.register:=src;
       l.size:=size;
       opmm_loc_reg(list,op,size,l,dst,shuffle);
     end;


    procedure tcgx86.opmm_loc_reg(list: taasmoutput; Op: TOpCG; size : tcgsize;loc : tlocation;dst: tregister; shuffle : pmmshuffle);
      const
        opmm2asmop : array[0..1,OS_F32..OS_F64,topcg] of tasmop = (
          ( { scalar }
            ( { OS_F32 }
              A_NOP,A_ADDSS,A_NOP,A_DIVSS,A_NOP,A_NOP,A_MULSS,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_SUBSS,A_NOP
            ),
            ( { OS_F64 }
              A_NOP,A_ADDSD,A_NOP,A_DIVSD,A_NOP,A_NOP,A_MULSD,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_SUBSD,A_NOP
            )
          ),
          ( { vectorized/packed }
            { because the logical packed single instructions have shorter op codes, we use always
              these
            }
            ( { OS_F32 }
              A_NOP,A_ADDPS,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_XORPS
            ),
            ( { OS_F64 }
              A_NOP,A_ADDPD,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_NOP,A_XORPS
            )
          )
        );

      var
        resultreg : tregister;
        asmop : tasmop;
      begin
        { this is an internally used procedure so the parameters have
          some constrains
        }
        if loc.size<>size then
          internalerror(200312213);
        resultreg:=dst;
        { deshuffle }
        //!!!
        if (shuffle<>nil) and not(shufflescalar(shuffle)) then
          begin
          end
        else if (shuffle=nil) then
          asmop:=opmm2asmop[1,size,op]
        else if shufflescalar(shuffle) then
          begin
            asmop:=opmm2asmop[0,size,op];
            { no scalar operation available? }
            if asmop=A_NOP then
              begin
                { do vectorized and shuffle finally }
                //!!!
              end;
          end
        else
          internalerror(200312211);
        if asmop=A_NOP then
          internalerror(200312215);
        case loc.loc of
          LOC_CREFERENCE,LOC_REFERENCE:
            list.concat(taicpu.op_ref_reg(asmop,S_NO,loc.reference,resultreg));
          LOC_CMMREGISTER,LOC_MMREGISTER:
            list.concat(taicpu.op_reg_reg(asmop,S_NO,loc.register,resultreg));
          else
            internalerror(200312214);
        end;
        { shuffle }
        if resultreg<>dst then
          begin
            internalerror(200312212);
          end;
      end;


    procedure tcgx86.a_op_const_reg(list : taasmoutput; Op: TOpCG; size: TCGSize; a: AWord; reg: TRegister);

      var
        opcode: tasmop;
        power: longint;

      begin
        check_register_size(size,reg);
        case op of
          OP_DIV, OP_IDIV:
            begin
              if ispowerof2(a,power) then
                begin
                  case op of
                    OP_DIV:
                      opcode := A_SHR;
                    OP_IDIV:
                      opcode := A_SAR;
                  end;
                  list.concat(taicpu.op_const_reg(opcode,TCgSize2OpSize[size],power,reg));
                  exit;
                end;
              { the rest should be handled specifically in the code      }
              { generator because of the silly register usage restraints }
              internalerror(200109224);
            end;
          OP_MUL,OP_IMUL:
            begin
              if not(cs_check_overflow in aktlocalswitches) and
                 ispowerof2(a,power) then
                begin
                  list.concat(taicpu.op_const_reg(A_SHL,TCgSize2OpSize[size],power,reg));
                  exit;
                end;
              if op = OP_IMUL then
                list.concat(taicpu.op_const_reg(A_IMUL,TCgSize2OpSize[size],a,reg))
              else
                { OP_MUL should be handled specifically in the code        }
                { generator because of the silly register usage restraints }
                internalerror(200109225);
            end;
          OP_ADD, OP_AND, OP_OR, OP_SUB, OP_XOR:
            if not(cs_check_overflow in aktlocalswitches) and
               (a = 1) and
               (op in [OP_ADD,OP_SUB]) then
              if op = OP_ADD then
                list.concat(taicpu.op_reg(A_INC,TCgSize2OpSize[size],reg))
              else
                list.concat(taicpu.op_reg(A_DEC,TCgSize2OpSize[size],reg))
            else if (a = 0) then
              if (op <> OP_AND) then
                exit
              else
                list.concat(taicpu.op_const_reg(A_MOV,TCgSize2OpSize[size],0,reg))
            else if (a = high(aword)) and
                    (op in [OP_AND,OP_OR,OP_XOR]) then
                   begin
                     case op of
                       OP_AND:
                         exit;
                       OP_OR:
                         list.concat(taicpu.op_const_reg(A_MOV,TCgSize2OpSize[size],high(aword),reg));
                       OP_XOR:
                         list.concat(taicpu.op_reg(A_NOT,TCgSize2OpSize[size],reg));
                     end
                   end
            else
              list.concat(taicpu.op_const_reg(TOpCG2AsmOp[op],TCgSize2OpSize[size],a,reg));
          OP_SHL,OP_SHR,OP_SAR:
            begin
              if (a and 31) <> 0 Then
                list.concat(taicpu.op_const_reg(TOpCG2AsmOp[op],TCgSize2OpSize[size],a and 31,reg));
              if (a shr 5) <> 0 Then
                internalerror(68991);
            end
          else internalerror(68992);
        end;
      end;


    procedure tcgx86.a_op_const_ref(list : taasmoutput; Op: TOpCG; size: TCGSize; a: AWord; const ref: TReference);
      var
        opcode: tasmop;
        power: longint;
      begin
        Case Op of
          OP_DIV, OP_IDIV:
            Begin
              if ispowerof2(a,power) then
                begin
                  case op of
                    OP_DIV:
                      opcode := A_SHR;
                    OP_IDIV:
                      opcode := A_SAR;
                  end;
                  list.concat(taicpu.op_const_ref(opcode,
                    TCgSize2OpSize[size],power,ref));
                  exit;
                end;
              { the rest should be handled specifically in the code      }
              { generator because of the silly register usage restraints }
              internalerror(200109231);
            End;
          OP_MUL,OP_IMUL:
            begin
              if not(cs_check_overflow in aktlocalswitches) and
                 ispowerof2(a,power) then
                begin
                  list.concat(taicpu.op_const_ref(A_SHL,TCgSize2OpSize[size],
                    power,ref));
                  exit;
                end;
              { can't multiply a memory location directly with a constant }
              if op = OP_IMUL then
                inherited a_op_const_ref(list,op,size,a,ref)
              else
                { OP_MUL should be handled specifically in the code        }
                { generator because of the silly register usage restraints }
                internalerror(200109232);
            end;
          OP_ADD, OP_AND, OP_OR, OP_SUB, OP_XOR:
            if not(cs_check_overflow in aktlocalswitches) and
               (a = 1) and
               (op in [OP_ADD,OP_SUB]) then
              if op = OP_ADD then
                list.concat(taicpu.op_ref(A_INC,TCgSize2OpSize[size],ref))
              else
                list.concat(taicpu.op_ref(A_DEC,TCgSize2OpSize[size],ref))
            else if (a = 0) then
              if (op <> OP_AND) then
                exit
              else
                a_load_const_ref(list,size,0,ref)
            else if (a = high(aword)) and
                    (op in [OP_AND,OP_OR,OP_XOR]) then
                   begin
                     case op of
                       OP_AND:
                         exit;
                       OP_OR:
                         list.concat(taicpu.op_const_ref(A_MOV,TCgSize2OpSize[size],high(aword),ref));
                       OP_XOR:
                         list.concat(taicpu.op_ref(A_NOT,TCgSize2OpSize[size],ref));
                     end
                   end
            else
              list.concat(taicpu.op_const_ref(TOpCG2AsmOp[op],
                TCgSize2OpSize[size],a,ref));
          OP_SHL,OP_SHR,OP_SAR:
            begin
              if (a and 31) <> 0 then
                list.concat(taicpu.op_const_ref(
                  TOpCG2AsmOp[op],TCgSize2OpSize[size],a and 31,ref));
              if (a shr 5) <> 0 Then
                internalerror(68991);
            end
          else internalerror(68992);
        end;
      end;


    procedure tcgx86.a_op_reg_reg(list : taasmoutput; Op: TOpCG; size: TCGSize; src, dst: TRegister);
      var
        dstsize: topsize;
        instr:Taicpu;
      begin
        check_register_size(size,src);
        check_register_size(size,dst);
        dstsize := tcgsize2opsize[size];
        case op of
          OP_NEG,OP_NOT:
            begin
              if src<>dst then
                a_load_reg_reg(list,size,size,src,dst);
              list.concat(taicpu.op_reg(TOpCG2AsmOp[op],dstsize,dst));
            end;
          OP_MUL,OP_DIV,OP_IDIV:
            { special stuff, needs separate handling inside code }
            { generator                                          }
            internalerror(200109233);
          OP_SHR,OP_SHL,OP_SAR:
            begin
              getexplicitregister(list,NR_CL);
              a_load_reg_reg(list,OS_8,OS_8,makeregsize(src,OS_8),NR_CL);
              list.concat(taicpu.op_reg_reg(Topcg2asmop[op],tcgsize2opsize[size],NR_CL,src));
              ungetregister(list,NR_CL);
            end;
          else
            begin
              if reg2opsize(src) <> dstsize then
                internalerror(200109226);
              instr:=taicpu.op_reg_reg(TOpCG2AsmOp[op],dstsize,src,dst);
              list.concat(instr);
            end;
        end;
      end;


    procedure tcgx86.a_op_ref_reg(list : taasmoutput; Op: TOpCG; size: TCGSize; const ref: TReference; reg: TRegister);
      begin
        check_register_size(size,reg);
        case op of
          OP_NEG,OP_NOT,OP_IMUL:
            begin
              inherited a_op_ref_reg(list,op,size,ref,reg);
            end;
          OP_MUL,OP_DIV,OP_IDIV:
            { special stuff, needs separate handling inside code }
            { generator                                          }
            internalerror(200109239);
          else
            begin
              reg := makeregsize(reg,size);
              list.concat(taicpu.op_ref_reg(TOpCG2AsmOp[op],tcgsize2opsize[size],ref,reg));
            end;
        end;
      end;


    procedure tcgx86.a_op_reg_ref(list : taasmoutput; Op: TOpCG; size: TCGSize;reg: TRegister; const ref: TReference);
      begin
        check_register_size(size,reg);
        case op of
          OP_NEG,OP_NOT:
            begin
              if reg<>NR_NO then
                internalerror(200109237);
              list.concat(taicpu.op_ref(TOpCG2AsmOp[op],tcgsize2opsize[size],ref));
            end;
          OP_IMUL:
            begin
              { this one needs a load/imul/store, which is the default }
              inherited a_op_ref_reg(list,op,size,ref,reg);
            end;
          OP_MUL,OP_DIV,OP_IDIV:
            { special stuff, needs separate handling inside code }
            { generator                                          }
            internalerror(200109238);
          else
            begin
              list.concat(taicpu.op_reg_ref(TOpCG2AsmOp[op],tcgsize2opsize[size],reg,ref));
            end;
        end;
      end;


    procedure tcgx86.a_op_const_reg_reg(list: taasmoutput; op: TOpCg; size: tcgsize; a: aword; src, dst: tregister);
      var
        tmpref: treference;
        power: longint;
      begin
        check_register_size(size,src);
        check_register_size(size,dst);
        if tcgsize2size[size]<>tcgsize2size[OS_INT] then
          begin
            inherited a_op_const_reg_reg(list,op,size,a,src,dst);
            exit;
          end;
        { if we get here, we have to do a 32 bit calculation, guaranteed }
        case op of
          OP_DIV, OP_IDIV, OP_MUL, OP_AND, OP_OR, OP_XOR, OP_SHL, OP_SHR,
          OP_SAR:
            { can't do anything special for these }
            inherited a_op_const_reg_reg(list,op,size,a,src,dst);
          OP_IMUL:
            begin
              if not(cs_check_overflow in aktlocalswitches) and
                 ispowerof2(a,power) then
                { can be done with a shift }
                begin
                  inherited a_op_const_reg_reg(list,op,size,a,src,dst);
                  exit;
                end;
              list.concat(taicpu.op_const_reg_reg(A_IMUL,tcgsize2opsize[size],a,src,dst));
            end;
          OP_ADD, OP_SUB:
            if (a = 0) then
              a_load_reg_reg(list,size,size,src,dst)
            else
              begin
                reference_reset(tmpref);
                tmpref.base := src;
                tmpref.offset := longint(a);
                if op = OP_SUB then
                  tmpref.offset := -tmpref.offset;
                list.concat(taicpu.op_ref_reg(A_LEA,tcgsize2opsize[size],tmpref,dst));
              end
          else internalerror(200112302);
        end;
      end;


    procedure tcgx86.a_op_reg_reg_reg(list: taasmoutput; op: TOpCg;size: tcgsize; src1, src2, dst: tregister);
      var
        tmpref: treference;
      begin
        check_register_size(size,src1);
        check_register_size(size,src2);
        check_register_size(size,dst);
        if tcgsize2size[size]<>tcgsize2size[OS_INT] then
          begin
            inherited a_op_reg_reg_reg(list,op,size,src1,src2,dst);
            exit;
          end;
        { if we get here, we have to do a 32 bit calculation, guaranteed }
        Case Op of
          OP_DIV, OP_IDIV, OP_MUL, OP_AND, OP_OR, OP_XOR, OP_SHL, OP_SHR,
          OP_SAR,OP_SUB,OP_NOT,OP_NEG:
            { can't do anything special for these }
            inherited a_op_reg_reg_reg(list,op,size,src1,src2,dst);
          OP_IMUL:
            list.concat(taicpu.op_reg_reg_reg(A_IMUL,tcgsize2opsize[size],src1,src2,dst));
          OP_ADD:
            begin
              reference_reset(tmpref);
              tmpref.base := src1;
              tmpref.index := src2;
              tmpref.scalefactor := 1;
              list.concat(taicpu.op_ref_reg(A_LEA,tcgsize2opsize[size],tmpref,dst));
            end
          else internalerror(200112303);
        end;
      end;

{*************** compare instructructions ****************}

    procedure tcgx86.a_cmp_const_reg_label(list : taasmoutput;size : tcgsize;cmp_op : topcmp;a : aword;reg : tregister;
      l : tasmlabel);

      begin
        if (a = 0) then
          list.concat(taicpu.op_reg_reg(A_TEST,tcgsize2opsize[size],reg,reg))
        else
          list.concat(taicpu.op_const_reg(A_CMP,tcgsize2opsize[size],a,reg));
        a_jmp_cond(list,cmp_op,l);
      end;


    procedure tcgx86.a_cmp_const_ref_label(list : taasmoutput;size : tcgsize;cmp_op : topcmp;a : aword;const ref : treference;
      l : tasmlabel);

      begin
        list.concat(taicpu.op_const_ref(A_CMP,TCgSize2OpSize[size],a,ref));
        a_jmp_cond(list,cmp_op,l);
      end;


    procedure tcgx86.a_cmp_reg_reg_label(list : taasmoutput;size : tcgsize;cmp_op : topcmp;
      reg1,reg2 : tregister;l : tasmlabel);

      begin
        check_register_size(size,reg1);
        check_register_size(size,reg2);
        list.concat(taicpu.op_reg_reg(A_CMP,TCgSize2OpSize[size],reg1,reg2));
        a_jmp_cond(list,cmp_op,l);
      end;


    procedure tcgx86.a_cmp_ref_reg_label(list : taasmoutput;size : tcgsize;cmp_op : topcmp;const ref: treference; reg : tregister;l : tasmlabel);
      begin
        check_register_size(size,reg);
        list.concat(taicpu.op_ref_reg(A_CMP,TCgSize2OpSize[size],ref,reg));
        a_jmp_cond(list,cmp_op,l);
      end;


    procedure tcgx86.a_jmp_cond(list : taasmoutput;cond : TOpCmp;l: tasmlabel);
      var
        ai : taicpu;
      begin
        if cond=OC_None then
          ai := Taicpu.Op_sym(A_JMP,S_NO,l)
        else
          begin
            ai:=Taicpu.Op_sym(A_Jcc,S_NO,l);
            ai.SetCondition(TOpCmp2AsmCond[cond]);
          end;
        ai.is_jmp:=true;
        list.concat(ai);
      end;


     procedure tcgx86.a_jmp_flags(list : taasmoutput;const f : TResFlags;l: tasmlabel);
       var
         ai : taicpu;
       begin
         ai := Taicpu.op_sym(A_Jcc,S_NO,l);
         ai.SetCondition(flags_to_cond(f));
         ai.is_jmp := true;
         list.concat(ai);
       end;


    procedure tcgx86.g_flags2reg(list: taasmoutput; size: TCgSize; const f: tresflags; reg: TRegister);
      var
        ai : taicpu;
        hreg : tregister;
      begin
        hreg:=makeregsize(reg,OS_8);
        ai:=Taicpu.op_reg(A_SETcc,S_B,hreg);
        ai.setcondition(flags_to_cond(f));
        list.concat(ai);
        if (reg<>hreg) then
          a_load_reg_reg(list,OS_8,size,hreg,reg);
      end;


     procedure tcgx86.g_flags2ref(list: taasmoutput; size: TCgSize; const f: tresflags; const ref: TReference);
       var
         ai : taicpu;
       begin
          if not(size in [OS_8,OS_S8]) then
            a_load_const_ref(list,size,0,ref);
          ai:=Taicpu.op_ref(A_SETcc,S_B,ref);
          ai.setcondition(flags_to_cond(f));
          list.concat(ai);
       end;


{ ************* concatcopy ************ }

    procedure Tcgx86.g_concatcopy(list:Taasmoutput;const source,dest:Treference;
                                  len:aword;delsource,loadref:boolean);

    const
{$ifdef cpu64bit}
        REGCX=NR_RCX;
        REGSI=NR_RSI;
        REGDI=NR_RDI;
{$else cpu64bit}
        REGCX=NR_ECX;
        REGSI=NR_ESI;
        REGDI=NR_EDI;
{$endif cpu64bit}

    type  copymode=(copy_move,copy_mmx,copy_string);

    var srcref,dstref:Treference;
        r,r0,r1,r2,r3:Tregister;
        helpsize:aword;
        copysize:byte;
        cgsize:Tcgsize;
        cm:copymode;

    begin
      cm:=copy_move;
      helpsize:=12;
      if cs_littlesize in aktglobalswitches then
        helpsize:=8;
      if (cs_mmx in aktlocalswitches) and
         not(pi_uses_fpu in current_procinfo.flags) and
         ((len=8) or (len=16) or (len=24) or (len=32)) then
        cm:=copy_mmx;
      if (len>helpsize) then
        cm:=copy_string;
      if (cs_littlesize in aktglobalswitches) and
         not((len<=16) and (cm=copy_mmx)) then
        cm:=copy_string;
      if loadref then
        cm:=copy_string;
      case cm of
        copy_move:
          begin
            dstref:=dest;
            srcref:=source;
            copysize:=sizeof(aword);
            cgsize:=int_cgsize(copysize);
            while len<>0 do
              begin
                if len<2 then
                  begin
                    copysize:=1;
                    cgsize:=OS_8;
                  end
                else if len<4 then
                  begin
                    copysize:=2;
                    cgsize:=OS_16;
                  end
                else if len<8 then
                  begin
                    copysize:=4;
                    cgsize:=OS_32;
                  end;
                dec(len,copysize);
                if (len=0) and delsource then
                  reference_release(list,source);
                r:=getintregister(list,cgsize);
                a_load_ref_reg(list,cgsize,cgsize,srcref,r);
                ungetregister(list,r);
                a_load_reg_ref(list,cgsize,cgsize,r,dstref);
                inc(srcref.offset,copysize);
                inc(dstref.offset,copysize);
              end;
          end;
        copy_mmx:
          begin
            dstref:=dest;
            srcref:=source;
            r0:=getmmxregister(list);
            a_loadmm_ref_reg(list,OS_M64,OS_M64,srcref,r0,nil);
            if len>=16 then
              begin
                inc(srcref.offset,8);
                r1:=getmmxregister(list);
                a_loadmm_ref_reg(list,OS_M64,OS_M64,srcref,r1,nil);
              end;
            if len>=24 then
              begin
                inc(srcref.offset,8);
                r2:=getmmxregister(list);
                a_loadmm_ref_reg(list,OS_M64,OS_M64,srcref,r2,nil);
              end;
            if len>=32 then
              begin
                inc(srcref.offset,8);
                r3:=getmmxregister(list);
                a_loadmm_ref_reg(list,OS_M64,OS_M64,srcref,r3,nil);
              end;
            a_loadmm_reg_ref(list,OS_M64,OS_M64,r0,dstref,nil);
            ungetregister(list,r0);
            if len>=16 then
              begin
                inc(dstref.offset,8);
                a_loadmm_reg_ref(list,OS_M64,OS_M64,r1,dstref,nil);
                ungetregister(list,r1);
              end;
            if len>=24 then
              begin
                inc(dstref.offset,8);
                a_loadmm_reg_ref(list,OS_M64,OS_M64,r2,dstref,nil);
                ungetregister(list,r2);
              end;
            if len>=32 then
              begin
                inc(dstref.offset,8);
                a_loadmm_reg_ref(list,OS_M64,OS_M64,r3,dstref,nil);
                ungetregister(list,r3);
              end;
          end
        else {copy_string, should be a good fallback in case of unhandled}
          begin
            getexplicitregister(list,REGDI);
            a_loadaddr_ref_reg(list,dest,REGDI);
            getexplicitregister(list,REGSI);
            if loadref then
              a_load_ref_reg(list,OS_ADDR,OS_ADDR,source,REGSI)
            else
              begin
                a_loadaddr_ref_reg(list,source,REGSI);
                if delsource then
                  begin
                    srcref:=source;
                    { Don't release ESI register yet, it's needed
                      by the movsl }
                    if (srcref.base=REGSI) then
                      srcref.base:=NR_NO
                    else if (srcref.index=REGSI) then
                      srcref.index:=NR_NO;
                    reference_release(list,srcref);
                  end;
              end;

            getexplicitregister(list,REGCX);

            list.concat(Taicpu.op_none(A_CLD,S_NO));
            if cs_littlesize in aktglobalswitches  then
              begin
                a_load_const_reg(list,OS_INT,len,REGCX);
                list.concat(Taicpu.op_none(A_REP,S_NO));
                list.concat(Taicpu.op_none(A_MOVSB,S_NO));
              end
            else
              begin
                helpsize:=len div sizeof(aword);
                len:=len mod sizeof(aword);
                if helpsize>1 then
                  begin
                    a_load_const_reg(list,OS_INT,helpsize,REGCX);
                    list.concat(Taicpu.op_none(A_REP,S_NO));
                  end;
                if helpsize>0 then
                  begin
{$ifdef cpu64bit}
                    if sizeof(aword)=8 then
                      list.concat(Taicpu.op_none(A_MOVSQ,S_NO))
                    else
{$endif cpu64bit}
                      list.concat(Taicpu.op_none(A_MOVSD,S_NO));
                  end;
                if len>=4 then
                  begin
                    dec(len,4);
                    list.concat(Taicpu.op_none(A_MOVSD,S_NO));
                  end;
                if len>=2 then
                  begin
                    dec(len,2);
                    list.concat(Taicpu.op_none(A_MOVSW,S_NO));
                  end;
                if len=1 then
                  list.concat(Taicpu.op_none(A_MOVSB,S_NO));
              end;
            ungetregister(list,REGCX);
            ungetregister(list,REGSI);
            ungetregister(list,REGDI);
          end;
        end;
      if delsource then
        tg.ungetiftemp(list,source);
    end;


    procedure tcgx86.g_exception_reason_save(list : taasmoutput; const href : treference);
      begin
        list.concat(Taicpu.op_reg(A_PUSH,tcgsize2opsize[OS_INT],NR_FUNCTION_RESULT_REG));
      end;


    procedure tcgx86.g_exception_reason_save_const(list : taasmoutput;const href : treference; a: aword);
      begin
        list.concat(Taicpu.op_const(A_PUSH,tcgsize2opsize[OS_INT],a));
      end;


    procedure tcgx86.g_exception_reason_load(list : taasmoutput; const href : treference);
      begin
        list.concat(Taicpu.op_reg(A_POP,tcgsize2opsize[OS_INT],NR_FUNCTION_RESULT_REG));
      end;


{****************************************************************************
                              Entry/Exit Code Helpers
****************************************************************************}

    procedure tcgx86.g_releasevaluepara_openarray(list : taasmoutput;const ref:treference);
      begin
        { Nothing to release }
      end;


    procedure tcgx86.g_interrupt_stackframe_entry(list : taasmoutput);

    begin
{$ifdef i386}
        { .... also the segment registers }
        list.concat(Taicpu.Op_reg(A_PUSH,S_W,NR_GS));
        list.concat(Taicpu.Op_reg(A_PUSH,S_W,NR_FS));
        list.concat(Taicpu.Op_reg(A_PUSH,S_W,NR_ES));
        list.concat(Taicpu.Op_reg(A_PUSH,S_W,NR_DS));
        { save the registers of an interrupt procedure }
        list.concat(Taicpu.Op_reg(A_PUSH,S_L,NR_EDI));
        list.concat(Taicpu.Op_reg(A_PUSH,S_L,NR_ESI));
        list.concat(Taicpu.Op_reg(A_PUSH,S_L,NR_EDX));
        list.concat(Taicpu.Op_reg(A_PUSH,S_L,NR_ECX));
        list.concat(Taicpu.Op_reg(A_PUSH,S_L,NR_EBX));
        list.concat(Taicpu.Op_reg(A_PUSH,S_L,NR_EAX));
{$endif i386}
    end;


    procedure tcgx86.g_interrupt_stackframe_exit(list : taasmoutput;accused,acchiused:boolean);

      begin
{$ifdef i386}
        if accused then
          list.concat(Taicpu.Op_const_reg(A_ADD,S_L,4,NR_ESP))
        else
          list.concat(Taicpu.Op_reg(A_POP,S_L,NR_EAX));
        list.concat(Taicpu.Op_reg(A_POP,S_L,NR_EBX));
        list.concat(Taicpu.Op_reg(A_POP,S_L,NR_ECX));
        if acchiused then
          list.concat(Taicpu.Op_const_reg(A_ADD,S_L,4,NR_ESP))
        else
          list.concat(Taicpu.Op_reg(A_POP,S_L,NR_EDX));
        list.concat(Taicpu.Op_reg(A_POP,S_L,NR_ESI));
        list.concat(Taicpu.Op_reg(A_POP,S_L,NR_EDI));
        { .... also the segment registers }
        list.concat(Taicpu.Op_reg(A_POP,S_W,NR_DS));
        list.concat(Taicpu.Op_reg(A_POP,S_W,NR_ES));
        list.concat(Taicpu.Op_reg(A_POP,S_W,NR_FS));
        list.concat(Taicpu.Op_reg(A_POP,S_W,NR_GS));
        { this restores the flags }
        list.concat(Taicpu.Op_none(A_IRET,S_NO));
{$endif i386}
      end;


    procedure tcgx86.g_profilecode(list : taasmoutput);

      var
        pl           : tasmlabel;
        mcountprefix : String[4];

      begin
        case target_info.system of
        {$ifndef NOTARGETWIN32}
           system_i386_win32,
        {$endif}
           system_i386_freebsd,
           system_i386_netbsd,
//         system_i386_openbsd,
           system_i386_wdosx :
             begin
                Case target_info.system Of
                 system_i386_freebsd : mcountprefix:='.';
                 system_i386_netbsd : mcountprefix:='__';
//               system_i386_openbsd : mcountprefix:='.';
                else
                 mcountPrefix:='';
                end;
                objectlibrary.getaddrlabel(pl);
                list.concat(Tai_section.Create(sec_data));
                list.concat(Tai_align.Create(4));
                list.concat(Tai_label.Create(pl));
                list.concat(Tai_const.Create_32bit(0));
                list.concat(Tai_section.Create(sec_code));
                list.concat(Taicpu.Op_reg(A_PUSH,S_L,NR_EDX));
                list.concat(Taicpu.Op_sym_ofs_reg(A_MOV,S_L,pl,0,NR_EDX));
                a_call_name(list,target_info.Cprefix+mcountprefix+'mcount');
                list.concat(Taicpu.Op_reg(A_POP,S_L,NR_EDX));
             end;

           system_i386_linux:
             a_call_name(list,target_info.Cprefix+'mcount');

           system_i386_go32v2,system_i386_watcom:
             begin
               a_call_name(list,'MCOUNT');
             end;
        end;
      end;


    procedure tcgx86.g_stackpointer_alloc(list : taasmoutput;localsize : longint);
{$ifdef i386}
{$ifndef NOTARGETWIN32}
      var
        href : treference;
        i : integer;
        again : tasmlabel;
{$endif NOTARGETWIN32}
{$endif i386}
      begin
        if localsize>0 then
         begin
{$ifdef i386}
{$ifndef NOTARGETWIN32}
           { windows guards only a few pages for stack growing, }
           { so we have to access every page first              }
           if (target_info.system=system_i386_win32) and
              (localsize>=winstackpagesize) then
             begin
               if localsize div winstackpagesize<=5 then
                 begin
                    list.concat(Taicpu.Op_const_reg(A_SUB,S_L,localsize-4,NR_ESP));
                    for i:=1 to localsize div winstackpagesize do
                      begin
                         reference_reset_base(href,NR_ESP,localsize-i*winstackpagesize);
                         list.concat(Taicpu.op_const_ref(A_MOV,S_L,0,href));
                      end;
                    list.concat(Taicpu.op_reg(A_PUSH,S_L,NR_EAX));
                 end
               else
                 begin
                    objectlibrary.getlabel(again);
                    getexplicitregister(list,NR_EDI);
                    list.concat(Taicpu.op_const_reg(A_MOV,S_L,localsize div winstackpagesize,NR_EDI));
                    a_label(list,again);
                    list.concat(Taicpu.op_const_reg(A_SUB,S_L,winstackpagesize-4,NR_ESP));
                    list.concat(Taicpu.op_reg(A_PUSH,S_L,NR_EAX));
                    list.concat(Taicpu.op_reg(A_DEC,S_L,NR_EDI));
                    a_jmp_cond(list,OC_NE,again);
                    ungetregister(list,NR_EDI);
                    list.concat(Taicpu.op_const_reg(A_SUB,S_L,localsize mod winstackpagesize,NR_ESP));
                 end
             end
           else
{$endif NOTARGETWIN32}
{$endif i386}
            list.concat(Taicpu.Op_const_reg(A_SUB,tcgsize2opsize[OS_ADDR],localsize,NR_STACK_POINTER_REG));
         end;
      end;


    procedure tcgx86.g_stackframe_entry(list : taasmoutput;localsize : longint);

    begin
      list.concat(tai_regalloc.alloc(NR_FRAME_POINTER_REG));
      include(rg[R_INTREGISTER].preserved_by_proc,RS_FRAME_POINTER_REG);
      list.concat(Taicpu.op_reg(A_PUSH,tcgsize2opsize[OS_ADDR],NR_FRAME_POINTER_REG));
      list.concat(Taicpu.op_reg_reg(A_MOV,tcgsize2opsize[OS_ADDR],NR_STACK_POINTER_REG,NR_FRAME_POINTER_REG));
      if localsize>0 then
        g_stackpointer_alloc(list,localsize);

      if cs_create_pic in aktmoduleswitches then
        begin
          a_call_name(list,'FPC_GETEIPINEBX');
          list.concat(taicpu.op_sym_ofs_reg(A_ADD,tcgsize2opsize[OS_ADDR],objectlibrary.newasmsymbol('_GLOBAL_OFFSET_TABLE_',AB_EXTERNAL,AT_DATA),0,NR_PIC_OFFSET_REG));
          list.concat(tai_regalloc.alloc(NR_PIC_OFFSET_REG));
        end;
    end;


    procedure tcgx86.g_restore_frame_pointer(list : taasmoutput);

    begin
      if cs_create_pic in aktmoduleswitches then
        list.concat(tai_regalloc.dealloc(NR_PIC_OFFSET_REG));
      list.concat(tai_regalloc.dealloc(NR_FRAME_POINTER_REG));
      list.concat(Taicpu.op_none(A_LEAVE,S_NO));
      if assigned(rg[R_MMXREGISTER]) and
         (rg[R_MMXREGISTER].uses_registers) then
        list.concat(Taicpu.op_none(A_EMMS,S_NO));
    end;


    procedure tcgx86.g_return_from_proc(list : taasmoutput;parasize : aword);
      begin
        { Routines with the poclearstack flag set use only a ret }
        { also routines with parasize=0     }
        if current_procinfo.procdef.proccalloption in clearstack_pocalls then
         begin
           { complex return values are removed from stack in C code PM }
           if paramanager.ret_in_param(current_procinfo.procdef.rettype.def,
                                       current_procinfo.procdef.proccalloption) then
             list.concat(Taicpu.Op_const(A_RET,S_NO,4))
           else
             list.concat(Taicpu.Op_none(A_RET,S_NO));
         end
        else if (parasize=0) then
         list.concat(Taicpu.Op_none(A_RET,S_NO))
        else
         begin
           { parameters are limited to 65535 bytes because }
           { ret allows only imm16                    }
           if (parasize>65535) then
             CGMessage(cg_e_parasize_too_big);
           list.concat(Taicpu.Op_const(A_RET,S_NO,parasize));
         end;
      end;


    procedure tcgx86.g_save_standard_registers(list:Taasmoutput);
      var
        href : treference;
        size : longint;
        r : integer;
      begin
        { Get temp }
        size:=0;
        for r:=low(saved_standard_registers) to high(saved_standard_registers) do
          if saved_standard_registers[r] in rg[R_INTREGISTER].used_in_proc then
            inc(size,POINTER_SIZE);
        if size>0 then
          begin
            tg.GetTemp(list,size,tt_noreuse,current_procinfo.save_regs_ref);
            { Copy registers to temp }
            href:=current_procinfo.save_regs_ref;

            for r:=low(saved_standard_registers) to high(saved_standard_registers) do
              begin
                if saved_standard_registers[r] in rg[R_INTREGISTER].used_in_proc then
                  begin
                    a_load_reg_ref(list,OS_ADDR,OS_ADDR,newreg(R_INTREGISTER,saved_standard_registers[r],R_SUBWHOLE),href);
                    inc(href.offset,POINTER_SIZE);
                  end;
                include(rg[R_INTREGISTER].preserved_by_proc,saved_standard_registers[r]);
              end;
          end;
      end;


    procedure tcgx86.g_restore_standard_registers(list:Taasmoutput);
      var
        href : treference;
        r : integer;
      begin
        { Copy registers from temp }
        href:=current_procinfo.save_regs_ref;
        for r:=low(saved_standard_registers) to high(saved_standard_registers) do
          if saved_standard_registers[r] in rg[R_INTREGISTER].used_in_proc then
            begin
              a_load_ref_reg(list,OS_ADDR,OS_ADDR,href,newreg(R_INTREGISTER,saved_standard_registers[r],R_SUBWHOLE));
              inc(href.offset,POINTER_SIZE);
            end;
        tg.UnGetTemp(list,current_procinfo.save_regs_ref);
      end;


    { produces if necessary overflowcode }
    procedure tcgx86.g_overflowcheck(list: taasmoutput; const l:tlocation;def:tdef);
      var
         hl : tasmlabel;
         ai : taicpu;
         cond : TAsmCond;
      begin
         if not(cs_check_overflow in aktlocalswitches) then
          exit;
         objectlibrary.getlabel(hl);
         if not ((def.deftype=pointerdef) or
                ((def.deftype=orddef) and
                 (torddef(def).typ in [u64bit,u16bit,u32bit,u8bit,uchar,
                                       bool8bit,bool16bit,bool32bit]))) then
           cond:=C_NO
         else
           cond:=C_NB;
         ai:=Taicpu.Op_Sym(A_Jcc,S_NO,hl);
         ai.SetCondition(cond);
         ai.is_jmp:=true;
         list.concat(ai);

         a_call_name(list,'FPC_OVERFLOW');
         a_label(list,hl);
      end;


end.
{
  $Log$
  Revision 1.120  2004-04-09 14:36:05  peter
    * A_MOVSL renamed to A_MOVSD

  Revision 1.119  2004/03/11 19:35:05  peter
    * fixed concatcopy end bytes copy broken by 64bits patch

  Revision 1.118  2004/03/10 22:52:03  peter
    * mcount for linux fixed
    * push/pop edx for mcount

  Revision 1.117  2004/03/06 20:35:20  florian
    * fixed arm compilation
    * cleaned up code generation for exported linux procedures

  Revision 1.116  2004/03/02 00:36:33  olle
    * big transformation of Tai_[const_]Symbol.Create[data]name*

  Revision 1.115  2004/02/27 10:21:06  florian
    * top_symbol killed
    + refaddr to treference added
    + refsymbol to treference added
    * top_local stuff moved to an extra record to save memory
    + aint introduced
    * tppufile.get/putint64/aint implemented

  Revision 1.114  2004/02/22 18:27:21  florian
    * fixed exception reason size for 64 bit systems

  Revision 1.113  2004/02/22 16:48:10  florian
    * x86_64 uses generic concatcopy_valueopenarray for now

  Revision 1.112  2004/02/21 19:46:37  florian
    * OP_SH* code generation fixed

  Revision 1.111  2004/02/20 16:01:49  peter
    * allow mov to smaller sizes

  Revision 1.110  2004/02/09 22:14:17  peter
    * more x86_64 parameter fixes
    * tparalocation.lochigh is now used to indicate if registerhigh
      is used and what the type is

  Revision 1.109  2004/02/07 23:28:34  daniel
    * Take advantage of our new with statement optimization

  Revision 1.108  2004/02/06 14:37:48  florian
    * movz*q fixed

  Revision 1.107  2004/02/05 18:28:37  peter
    * x86_64 fixes for opsize

  Revision 1.106  2004/02/04 22:01:13  peter
    * first try to get cpupara working for x86_64

  Revision 1.105  2004/02/04 19:22:27  peter
  *** empty log message ***

  Revision 1.104  2004/02/03 19:46:48  jonas
    - removed "mov reg,reg" optimization (those instructions are removed by
      the register allocator, and may be necessary to indicate a register
      may not be released before some point)

  Revision 1.103  2004/01/15 23:16:33  daniel
    + Cleanup of stabstring generation code. Cleaner, faster, and compiler
      executable reduced by 50 kb,

  Revision 1.102  2004/01/14 23:39:05  florian
    * another bunch of x86-64 fixes mainly calling convention and
      assembler reader related

  Revision 1.101  2004/01/14 21:43:54  peter
    * add release_openarrayvalue

  Revision 1.100  2003/12/26 14:02:30  peter
    * sparc updates
    * use registertype in spill_register

  Revision 1.99  2003/12/26 13:19:16  florian
    * rtl and compiler compile with -Cfsse2

  Revision 1.98  2003/12/26 00:32:22  florian
    + fpu<->mm register conversion

  Revision 1.97  2003/12/25 12:01:35  florian
    + possible sse2 unit usage for double calculations
    * some sse2 assembler issues fixed

  Revision 1.96  2003/12/25 01:07:09  florian
    + $fputype directive support
    + single data type operations with sse unit
    * fixed more x86-64 stuff

  Revision 1.95  2003/12/24 01:47:23  florian
    * first fixes to compile the x86-64 system unit

  Revision 1.94  2003/12/24 00:10:03  florian
    - delete parameter in cg64 methods removed

  Revision 1.93  2003/12/21 19:42:43  florian
    * fixed ppc inlining stuff
    * fixed wrong unit writing
    + added some sse stuff

  Revision 1.92  2003/12/19 22:08:44  daniel
    * Some work to restore the MMX capabilities

  Revision 1.91  2003/12/15 21:25:49  peter
    * reg allocations for imaginary register are now inserted just
      before reg allocation
    * tregister changed to enum to allow compile time check
    * fixed several tregister-tsuperregister errors

  Revision 1.90  2003/12/12 17:16:18  peter
    * rg[tregistertype] added in tcg

  Revision 1.89  2003/12/06 01:15:23  florian
    * reverted Peter's alloctemp patch; hopefully properly

  Revision 1.88  2003/12/03 23:13:20  peter
    * delayed paraloc allocation, a_param_*() gets extra parameter
      if it needs to allocate temp or real paralocation
    * optimized/simplified int-real loading

  Revision 1.87  2003/11/05 23:06:03  florian
    * elesize of g_copyvaluepara_openarray changed

  Revision 1.86  2003/10/30 18:53:53  marco
   * profiling fix

  Revision 1.85  2003/10/30 16:22:40  peter
    * call firstpass before allocation and codegeneration is started
    * move leftover code from pass_2.generatecode() to psub

  Revision 1.84  2003/10/29 21:24:14  jonas
    + support for fpu temp parameters
    + saving/restoring of fpu register before/after a procedure call

  Revision 1.83  2003/10/20 19:30:08  peter
    * remove memdebug code for rg

  Revision 1.82  2003/10/18 15:41:26  peter
    * made worklists dynamic in size

  Revision 1.81  2003/10/17 15:25:18  florian
    * fixed more ppc stuff

  Revision 1.80  2003/10/17 14:38:32  peter
    * 64k registers supported
    * fixed some memory leaks

  Revision 1.79  2003/10/14 00:30:48  florian
    + some code for PIC support added

  Revision 1.78  2003/10/13 01:23:13  florian
    * some ideas for mm support implemented

  Revision 1.77  2003/10/11 16:06:42  florian
    * fixed some MMX<->SSE
    * started to fix ppc, needs an overhaul
    + stabs info improve for spilling, not sure if it works correctly/completly
    - MMX_SUPPORT removed from Makefile.fpc

  Revision 1.76  2003/10/10 17:48:14  peter
    * old trgobj moved to x86/rgcpu and renamed to trgx86fpu
    * tregisteralloctor renamed to trgobj
    * removed rgobj from a lot of units
    * moved location_* and reference_* to cgobj
    * first things for mmx register allocation

  Revision 1.75  2003/10/09 21:31:37  daniel
    * Register allocator splitted, ans abstract now

  Revision 1.74  2003/10/07 16:09:03  florian
    * x86 supports only mem/reg to reg for movsx and movzx

  Revision 1.73  2003/10/07 15:17:07  peter
    * inline supported again, LOC_REFERENCEs are used to pass the
      parameters
    * inlineparasymtable,inlinelocalsymtable removed
    * exitlabel inserting fixed

  Revision 1.72  2003/10/03 22:00:33  peter
    * parameter alignment fixes

  Revision 1.71  2003/10/03 14:45:37  peter
    * save ESP after pusha and restore before popa for save all registers

  Revision 1.70  2003/10/01 20:34:51  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.69  2003/09/30 19:53:47  peter
    * fix pushw reg

  Revision 1.68  2003/09/29 20:58:56  peter
    * optimized releasing of registers

  Revision 1.67  2003/09/28 13:37:19  peter
    * a_call_ref removed

  Revision 1.66  2003/09/25 21:29:16  peter
    * change push/pop in getreg/ungetreg

  Revision 1.65  2003/09/25 13:13:32  florian
    * more x86-64 fixes

  Revision 1.64  2003/09/11 11:55:00  florian
    * improved arm code generation
    * move some protected and private field around
    * the temp. register for register parameters/arguments are now released
      before the move to the parameter register is done. This improves
      the code in a lot of cases.

  Revision 1.63  2003/09/09 21:03:17  peter
    * basics for x86 register calling

  Revision 1.62  2003/09/09 20:59:27  daniel
    * Adding register allocation order

  Revision 1.61  2003/09/07 22:09:35  peter
    * preparations for different default calling conventions
    * various RA fixes

  Revision 1.60  2003/09/05 17:41:13  florian
    * merged Wiktor's Watcom patches in 1.1

  Revision 1.59  2003/09/03 15:55:02  peter
    * NEWRA branch merged

  Revision 1.58.2.5  2003/08/31 20:40:50  daniel
    * Fixed add_edges_used

  Revision 1.58.2.4  2003/08/31 15:46:26  peter
    * more updates for tregister

  Revision 1.58.2.3  2003/08/29 17:29:00  peter
    * next batch of updates

  Revision 1.58.2.2  2003/08/28 18:35:08  peter
    * tregister changed to cardinal

  Revision 1.58.2.1  2003/08/27 21:06:34  peter
    * more updates

  Revision 1.58  2003/08/20 19:28:21  daniel
    * Small NOTARGETWIN32 conditional tweak

  Revision 1.57  2003/07/03 18:59:25  peter
    * loadfpu_reg_reg size specifier

  Revision 1.56  2003/06/14 14:53:50  jonas
    * fixed newra cycle for x86
    * added constants for indicating source and destination operands of the
      "move reg,reg" instruction to aasmcpu (and use those in rgobj)

  Revision 1.55  2003/06/13 21:19:32  peter
    * current_procdef removed, use current_procinfo.procdef instead

  Revision 1.54  2003/06/12 18:31:18  peter
    * fix newra cycle for i386

  Revision 1.53  2003/06/07 10:24:10  peter
    * fixed copyvaluepara for left-to-right pushing

  Revision 1.52  2003/06/07 10:06:55  jonas
    * fixed cycling problem

  Revision 1.51  2003/06/03 21:11:09  peter
    * cg.a_load_* get a from and to size specifier
    * makeregsize only accepts newregister
    * i386 uses generic tcgnotnode,tcgunaryminus

  Revision 1.50  2003/06/03 13:01:59  daniel
    * Register allocator finished

  Revision 1.49  2003/06/01 21:38:07  peter
    * getregisterfpu size parameter added
    * op_const_reg size parameter added
    * sparc updates

  Revision 1.48  2003/05/30 23:57:08  peter
    * more sparc cleanup
    * accumulator removed, splitted in function_return_reg (called) and
      function_result_reg (caller)

  Revision 1.47  2003/05/22 21:33:31  peter
    * removed some unit dependencies

  Revision 1.46  2003/05/16 14:33:31  peter
    * regvar fixes

  Revision 1.45  2003/05/15 18:58:54  peter
    * removed selfpointer_offset, vmtpointer_offset
    * tvarsym.adjusted_address
    * address in localsymtable is now in the real direction
    * removed some obsolete globals

  Revision 1.44  2003/04/30 20:53:32  florian
    * error when address of an abstract method is taken
    * fixed some x86-64 problems
    * merged some more x86-64 and i386 code

  Revision 1.43  2003/04/27 11:21:36  peter
    * aktprocdef renamed to current_procinfo.procdef
    * procinfo renamed to current_procinfo
    * procinfo will now be stored in current_module so it can be
      cleaned up properly
    * gen_main_procsym changed to create_main_proc and release_main_proc
      to also generate a tprocinfo structure
    * fixed unit implicit initfinal

  Revision 1.42  2003/04/23 14:42:08  daniel
    * Further register allocator work. Compiler now smaller with new
      allocator than without.
    * Somebody forgot to adjust ppu version number

  Revision 1.41  2003/04/23 09:51:16  daniel
    * Removed usage of edi in a lot of places when new register allocator used
    + Added newra versions of g_concatcopy and secondadd_float

  Revision 1.40  2003/04/22 13:47:08  peter
    * fixed C style array of const
    * fixed C array passing
    * fixed left to right with high parameters

  Revision 1.39  2003/04/22 10:09:35  daniel
    + Implemented the actual register allocator
    + Scratch registers unavailable when new register allocator used
    + maybe_save/maybe_restore unavailable when new register allocator used

  Revision 1.38  2003/04/17 16:48:21  daniel
    * Added some code to keep track of move instructions in register
      allocator

  Revision 1.37  2003/03/28 19:16:57  peter
    * generic constructor working for i386
    * remove fixed self register
    * esi added as address register for i386

  Revision 1.36  2003/03/18 18:17:46  peter
    * reg2opsize()

  Revision 1.35  2003/03/13 19:52:23  jonas
    * and more new register allocator fixes (in the i386 code generator this
      time). At least now the ppc cross compiler can compile the linux
      system unit again, but I haven't tested it.

  Revision 1.34  2003/02/27 16:40:32  daniel
    * Fixed ie 200301234 problem on Win32 target

  Revision 1.33  2003/02/26 21:15:43  daniel
    * Fixed the optimizer

  Revision 1.32  2003/02/19 22:00:17  daniel
    * Code generator converted to new register notation
    - Horribily outdated todo.txt removed

  Revision 1.31  2003/01/21 10:41:13  daniel
    * Fixed another 200301081

  Revision 1.30  2003/01/13 23:00:18  daniel
    * Fixed internalerror

  Revision 1.29  2003/01/13 14:54:34  daniel
    * Further work to convert codegenerator register convention;
      internalerror bug fixed.

  Revision 1.28  2003/01/09 20:41:00  daniel
    * Converted some code in cgx86.pas to new register numbering

  Revision 1.27  2003/01/08 18:43:58  daniel
   * Tregister changed into a record

  Revision 1.26  2003/01/05 13:36:53  florian
    * x86-64 compiles
    + very basic support for float128 type (x86-64 only)

  Revision 1.25  2003/01/02 16:17:50  peter
    * align stack on 4 bytes in copyvalueopenarray

  Revision 1.24  2002/12/24 15:56:50  peter
    * stackpointer_alloc added for adjusting ESP. Win32 needs
      this for the pageprotection

  Revision 1.23  2002/11/25 18:43:34  carl
   - removed the invalid if <> checking (Delphi is strange on this)
   + implemented abstract warning on instance creation of class with
      abstract methods.
   * some error message cleanups

  Revision 1.22  2002/11/25 17:43:29  peter
    * splitted defbase in defutil,symutil,defcmp
    * merged isconvertable and is_equal into compare_defs(_ext)
    * made operator search faster by walking the list only once

  Revision 1.21  2002/11/18 17:32:01  peter
    * pass proccalloption to ret_in_xxx and push_xxx functions

  Revision 1.20  2002/11/09 21:18:31  carl
    * flags2reg() was not extending the byte register to the correct result size

  Revision 1.19  2002/10/16 19:01:43  peter
    + $IMPLICITEXCEPTIONS switch to turn on/off generation of the
      implicit exception frames for procedures with initialized variables
      and for constructors. The default is on for compatibility

  Revision 1.18  2002/10/05 12:43:30  carl
    * fixes for Delphi 6 compilation
     (warning : Some features do not work under Delphi)

  Revision 1.17  2002/09/17 18:54:06  jonas
    * a_load_reg_reg() now has two size parameters: source and dest. This
      allows some optimizations on architectures that don't encode the
      register size in the register name.

  Revision 1.16  2002/09/16 19:08:47  peter
    * support references without registers and symbol in paramref_addr. It
      pushes only the offset

  Revision 1.15  2002/09/16 18:06:29  peter
    * move CGSize2Opsize to interface

  Revision 1.14  2002/09/01 14:42:41  peter
    * removevaluepara added to fix the stackpointer so restoring of
      saved registers works

  Revision 1.13  2002/09/01 12:09:27  peter
    + a_call_reg, a_call_loc added
    * removed exprasmlist references

  Revision 1.12  2002/08/17 09:23:50  florian
    * first part of procinfo rewrite

  Revision 1.11  2002/08/16 14:25:00  carl
    * issameref() to test if two references are the same (then emit no opcodes)
    + ret_in_reg to replace ret_in_acc
      (fix some register allocation bugs at the same time)
    + save_std_register now has an extra parameter which is the
      usedinproc registers

  Revision 1.10  2002/08/15 08:13:54  carl
    - a_load_sym_ofs_reg removed
    * loadvmt now calls loadaddr_ref_reg instead

  Revision 1.9  2002/08/11 14:32:33  peter
    * renamed current_library to objectlibrary

  Revision 1.8  2002/08/11 13:24:20  peter
    * saving of asmsymbols in ppu supported
    * asmsymbollist global is removed and moved into a new class
      tasmlibrarydata that will hold the info of a .a file which
      corresponds with a single module. Added librarydata to tmodule
      to keep the library info stored for the module. In the future the
      objectfiles will also be stored to the tasmlibrarydata class
    * all getlabel/newasmsymbol and friends are moved to the new class

  Revision 1.7  2002/08/10 10:06:04  jonas
    * fixed stupid bug of mine in g_flags2reg() when optimizations are on

  Revision 1.6  2002/08/09 19:18:27  carl
    * fix generic exception handling

  Revision 1.5  2002/08/04 19:52:04  carl
    + updated exception routines

  Revision 1.4  2002/07/27 19:53:51  jonas
    + generic implementation of tcg.g_flags2ref()
    * tcg.flags2xxx() now also needs a size parameter

  Revision 1.3  2002/07/26 21:15:46  florian
    * rewrote the system handling

  Revision 1.2  2002/07/21 16:55:34  jonas
    * fixed bug in op_const_reg_reg() for imul

  Revision 1.1  2002/07/20 19:28:47  florian
    * splitting of i386\cgcpu.pas into x86\cgx86.pas and i386\cgcpu.pas
      cgx86.pas will contain the common code for i386 and x86_64

}
