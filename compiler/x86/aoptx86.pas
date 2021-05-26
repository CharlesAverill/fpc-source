{
    Copyright (c) 1998-2002 by Florian Klaempfl and Jonas Maebe

    This unit contains the peephole optimizer.

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
unit aoptx86;

{$i fpcdefs.inc}

{$define DEBUG_AOPTCPU}

  interface

    uses
      globtype,
      cpubase,
      aasmtai,aasmcpu,
      cgbase,cgutils,
      aopt,aoptobj;

    type
      TOptsToCheck = (
        aoc_MovAnd2Mov_3
      );

      TX86AsmOptimizer = class(TAsmOptimizer)
        { some optimizations are very expensive to check, so the
          pre opt pass can be used to set some flags, depending on the found
          instructions if it is worth to check a certain optimization }
        OptsToCheck : set of TOptsToCheck;
        function RegLoadedWithNewValue(reg : tregister; hp : tai) : boolean; override;
        function InstructionLoadsFromReg(const reg : TRegister; const hp : tai) : boolean; override;
        function RegReadByInstruction(reg : TRegister; hp : tai) : boolean;
        function RegInInstruction(Reg: TRegister; p1: tai): Boolean;override;
        function GetNextInstructionUsingReg(Current: tai; out Next: tai; reg: TRegister): Boolean;

        { This version of GetNextInstructionUsingReg will look across conditional jumps,
          potentially allowing further optimisation (although it might need to know if
          it crossed a conditional jump. }
        function GetNextInstructionUsingRegCond(Current: tai; out Next: tai; reg: TRegister; var CrossJump: Boolean): Boolean;

        {
          In comparison with GetNextInstructionUsingReg, GetNextInstructionUsingRegTrackingUse tracks
          the use of a register by allocs/dealloc, so it can ignore calls.

          In the following example, GetNextInstructionUsingReg will return the second movq,
          GetNextInstructionUsingRegTrackingUse won't.

          movq	%rdi,%rax
          # Register rdi released

          # Register rdi allocated
          movq	%rax,%rdi

          While in this example:

          movq	%rdi,%rax
          call  proc
          movq	%rdi,%rax

          GetNextInstructionUsingRegTrackingUse will return the second instruction while GetNextInstructionUsingReg
          won't.
        }
        function GetNextInstructionUsingRegTrackingUse(Current: tai; out Next: tai; reg: TRegister): Boolean;
        function RegModifiedByInstruction(Reg: TRegister; p1: tai): boolean; override;
      private
        function SkipSimpleInstructions(var hp1: tai): Boolean;
      protected
        class function IsMOVZXAcceptable: Boolean; static; inline;

        { checks whether loading a new value in reg1 overwrites the entirety of reg2 }
        function Reg1WriteOverwritesReg2Entirely(reg1, reg2: tregister): boolean;
        { checks whether reading the value in reg1 depends on the value of reg2. This
          is very similar to SuperRegisterEquals, except it takes into account that
          R_SUBH and R_SUBL are independendent (e.g. reading from AL does not
          depend on the value in AH). }
        function Reg1ReadDependsOnReg2(reg1, reg2: tregister): boolean;

        { Replaces all references to AOldReg in a memory reference to ANewReg }
        class function ReplaceRegisterInRef(var ref: TReference; const AOldReg, ANewReg: TRegister): Boolean; static;

        { Replaces all references to AOldReg in an operand to ANewReg }
        class function ReplaceRegisterInOper(const p: taicpu; const OperIdx: Integer; const AOldReg, ANewReg: TRegister): Boolean; static;

        { Replaces all references to AOldReg in an instruction to ANewReg,
          except where the register is being written }
        function ReplaceRegisterInInstruction(const p: taicpu; const AOldReg, ANewReg: TRegister): Boolean;

        { Returns true if the reference only refers to ESP or EBP (or their 64-bit equivalents),
          or writes to a global symbol }
        class function IsRefSafe(const ref: PReference): Boolean; static; inline;


        { Returns true if the given MOV instruction can be safely converted to CMOV }
        class function CanBeCMOV(p : tai) : boolean; static;


        { Converts the LEA instruction to ADD/INC/SUB/DEC. Returns True if the
          conversion was successful }
        function ConvertLEA(const p : taicpu): Boolean;

        function DeepMOVOpt(const p_mov: taicpu; const hp: taicpu): Boolean;

        procedure DebugMsg(const s : string; p : tai);inline;

        class function IsExitCode(p : tai) : boolean; static;
        class function isFoldableArithOp(hp1 : taicpu; reg : tregister) : boolean; static;
        procedure RemoveLastDeallocForFuncRes(p : tai);

        function DoSubAddOpt(var p : tai) : Boolean;

        function PrePeepholeOptSxx(var p : tai) : boolean;
        function PrePeepholeOptIMUL(var p : tai) : boolean;

        function OptPass1Test(var p: tai): boolean;
        function OptPass1Add(var p: tai): boolean;
        function OptPass1AND(var p : tai) : boolean;
        function OptPass1_V_MOVAP(var p : tai) : boolean;
        function OptPass1VOP(var p : tai) : boolean;
        function OptPass1MOV(var p : tai) : boolean;
        function OptPass1Movx(var p : tai) : boolean;
        function OptPass1MOVXX(var p : tai) : boolean;
        function OptPass1OP(var p : tai) : boolean;
        function OptPass1LEA(var p : tai) : boolean;
        function OptPass1Sub(var p : tai) : boolean;
        function OptPass1SHLSAL(var p : tai) : boolean;
        function OptPass1FSTP(var p : tai) : boolean;
        function OptPass1FLD(var p : tai) : boolean;
        function OptPass1Cmp(var p : tai) : boolean;
        function OptPass1PXor(var p : tai) : boolean;
        function OptPass1VPXor(var p: tai): boolean;
        function OptPass1Imul(var p : tai) : boolean;
        function OptPass1Jcc(var p : tai) : boolean;

        function OptPass2Movx(var p : tai): Boolean;
        function OptPass2MOV(var p : tai) : boolean;
        function OptPass2Imul(var p : tai) : boolean;
        function OptPass2Jmp(var p : tai) : boolean;
        function OptPass2Jcc(var p : tai) : boolean;
        function OptPass2Lea(var p: tai): Boolean;
        function OptPass2SUB(var p: tai): Boolean;
        function OptPass2ADD(var p : tai): Boolean;
        function OptPass2SETcc(var p : tai) : boolean;

        function CheckMemoryWrite(var first_mov, second_mov: taicpu): Boolean;

        function PostPeepholeOptMov(var p : tai) : Boolean;
        function PostPeepholeOptMovzx(var p : tai) : Boolean;
{$ifdef x86_64} { These post-peephole optimisations only affect 64-bit registers. [Kit] }
        function PostPeepholeOptXor(var p : tai) : Boolean;
{$endif}
        function PostPeepholeOptAnd(var p : tai) : boolean;
        function PostPeepholeOptMOVSX(var p : tai) : boolean;
        function PostPeepholeOptCmp(var p : tai) : Boolean;
        function PostPeepholeOptTestOr(var p : tai) : Boolean;
        function PostPeepholeOptCall(var p : tai) : Boolean;
        function PostPeepholeOptLea(var p : tai) : Boolean;
        function PostPeepholeOptPush(var p: tai): Boolean;
        function PostPeepholeOptShr(var p : tai) : boolean;

        procedure ConvertJumpToRET(const p: tai; const ret_p: tai);

        function CheckJumpMovTransferOpt(var p: tai; hp1: tai; LoopCount: Integer; out Count: Integer): Boolean;
        procedure SwapMovCmp(var p, hp1: tai);

        { Processor-dependent reference optimisation }
        class procedure OptimizeRefs(var p: taicpu); static;
      end;

    function MatchInstruction(const instr: tai; const op: TAsmOp; const opsize: topsizes): boolean;
    function MatchInstruction(const instr: tai; const op1,op2: TAsmOp; const opsize: topsizes): boolean;
    function MatchInstruction(const instr: tai; const op1,op2,op3: TAsmOp; const opsize: topsizes): boolean;
    function MatchInstruction(const instr: tai; const ops: array of TAsmOp; const opsize: topsizes): boolean;

    function MatchOperand(const oper: TOper; const reg: TRegister): boolean; inline;
    function MatchOperand(const oper: TOper; const a: tcgint): boolean; inline;
    function MatchOperand(const oper1: TOper; const oper2: TOper): boolean;
{$if max_operands>2}
    function MatchOperand(const oper1: TOper; const oper2: TOper; const oper3: TOper): boolean;
{$endif max_operands>2}

    function RefsEqual(const r1, r2: treference): boolean;

    function MatchReference(const ref : treference;base,index : TRegister) : Boolean;

    { returns true, if ref is a reference using only the registers passed as base and index
      and having an offset }
    function MatchReferenceWithOffset(const ref : treference;base,index : TRegister) : Boolean;

  implementation

    uses
      cutils,verbose,
      systems,
      globals,
      cpuinfo,
      procinfo,
      paramgr,
      aasmbase,
      aoptbase,aoptutils,
      symconst,symsym,
      cgx86,
      itcpugas;

{$ifdef DEBUG_AOPTCPU}
    const
      SPeepholeOptimization: shortstring = 'Peephole Optimization: ';
{$else DEBUG_AOPTCPU}
    { Empty strings help the optimizer to remove string concatenations that won't
      ever appear to the user on release builds. [Kit] }
    const
      SPeepholeOptimization = '';
{$endif DEBUG_AOPTCPU}
      LIST_STEP_SIZE = 4;

    function MatchInstruction(const instr: tai; const op: TAsmOp; const opsize: topsizes): boolean;
      begin
        result :=
          (instr.typ = ait_instruction) and
          (taicpu(instr).opcode = op) and
          ((opsize = []) or (taicpu(instr).opsize in opsize));
      end;


    function MatchInstruction(const instr: tai; const op1,op2: TAsmOp; const opsize: topsizes): boolean;
      begin
        result :=
          (instr.typ = ait_instruction) and
          ((taicpu(instr).opcode = op1) or
           (taicpu(instr).opcode = op2)
          ) and
          ((opsize = []) or (taicpu(instr).opsize in opsize));
      end;


    function MatchInstruction(const instr: tai; const op1,op2,op3: TAsmOp; const opsize: topsizes): boolean;
      begin
        result :=
          (instr.typ = ait_instruction) and
          ((taicpu(instr).opcode = op1) or
           (taicpu(instr).opcode = op2) or
           (taicpu(instr).opcode = op3)
          ) and
          ((opsize = []) or (taicpu(instr).opsize in opsize));
      end;


    function MatchInstruction(const instr : tai;const ops : array of TAsmOp;
     const opsize : topsizes) : boolean;
      var
        op : TAsmOp;
      begin
        result:=false;
        for op in ops do
          begin
            if (instr.typ = ait_instruction) and
               (taicpu(instr).opcode = op) and
               ((opsize = []) or (taicpu(instr).opsize in opsize)) then
               begin
                 result:=true;
                 exit;
               end;
          end;
      end;


    function MatchOperand(const oper: TOper; const reg: TRegister): boolean; inline;
      begin
        result := (oper.typ = top_reg) and (oper.reg = reg);
      end;


    function MatchOperand(const oper: TOper; const a: tcgint): boolean; inline;
      begin
        result := (oper.typ = top_const) and (oper.val = a);
      end;


    function MatchOperand(const oper1: TOper; const oper2: TOper): boolean;
      begin
        result := oper1.typ = oper2.typ;

        if result then
          case oper1.typ of
            top_const:
              Result:=oper1.val = oper2.val;
            top_reg:
              Result:=oper1.reg = oper2.reg;
            top_ref:
              Result:=RefsEqual(oper1.ref^, oper2.ref^);
            else
              internalerror(2013102801);
          end
      end;


    function MatchOperand(const oper1: TOper; const oper2: TOper; const oper3: TOper): boolean;
      begin
        result := (oper1.typ = oper2.typ) and (oper1.typ = oper3.typ);

        if result then
          case oper1.typ of
            top_const:
              Result:=(oper1.val = oper2.val) and (oper1.val = oper3.val);
            top_reg:
              Result:=(oper1.reg = oper2.reg) and (oper1.reg = oper3.reg);
            top_ref:
              Result:=RefsEqual(oper1.ref^, oper2.ref^) and RefsEqual(oper1.ref^, oper3.ref^);
            else
              internalerror(2020052401);
          end
      end;


    function RefsEqual(const r1, r2: treference): boolean;
      begin
        RefsEqual :=
          (r1.offset = r2.offset) and
          (r1.segment = r2.segment) and (r1.base = r2.base) and
          (r1.index = r2.index) and (r1.scalefactor = r2.scalefactor) and
          (r1.symbol=r2.symbol) and (r1.refaddr = r2.refaddr) and
          (r1.relsymbol = r2.relsymbol) and
          (r1.volatility=[]) and
          (r2.volatility=[]);
      end;


    function MatchReference(const ref : treference;base,index : TRegister) : Boolean;
      begin
       Result:=(ref.offset=0) and
         (ref.scalefactor in [0,1]) and
         (ref.segment=NR_NO) and
         (ref.symbol=nil) and
         (ref.relsymbol=nil) and
         ((base=NR_INVALID) or
          (ref.base=base)) and
         ((index=NR_INVALID) or
          (ref.index=index)) and
         (ref.volatility=[]);
      end;


    function MatchReferenceWithOffset(const ref : treference;base,index : TRegister) : Boolean;
      begin
       Result:=(ref.scalefactor in [0,1]) and
         (ref.segment=NR_NO) and
         (ref.symbol=nil) and
         (ref.relsymbol=nil) and
         ((base=NR_INVALID) or
          (ref.base=base)) and
         ((index=NR_INVALID) or
          (ref.index=index)) and
         (ref.volatility=[]);
      end;


    function InstrReadsFlags(p: tai): boolean;
      begin
        InstrReadsFlags := true;
        case p.typ of
          ait_instruction:
            if InsProp[taicpu(p).opcode].Ch*
               [Ch_RCarryFlag,Ch_RParityFlag,Ch_RAuxiliaryFlag,Ch_RZeroFlag,Ch_RSignFlag,Ch_ROverflowFlag,
                Ch_RWCarryFlag,Ch_RWParityFlag,Ch_RWAuxiliaryFlag,Ch_RWZeroFlag,Ch_RWSignFlag,Ch_RWOverflowFlag,
                Ch_RFlags,Ch_RWFlags,Ch_RFLAGScc,Ch_All]<>[] then
              exit;
          ait_label:
            exit;
          else
            ;
        end;
        InstrReadsFlags := false;
      end;


  function TX86AsmOptimizer.GetNextInstructionUsingReg(Current: tai; out Next: tai; reg: TRegister): Boolean;
    begin
      Next:=Current;
      repeat
        Result:=GetNextInstruction(Next,Next);
      until not (Result) or
            not(cs_opt_level3 in current_settings.optimizerswitches) or
            (Next.typ<>ait_instruction) or
            RegInInstruction(reg,Next) or
            is_calljmp(taicpu(Next).opcode);
    end;


  function TX86AsmOptimizer.GetNextInstructionUsingRegCond(Current: tai; out Next: tai; reg: TRegister; var CrossJump: Boolean): Boolean;
    begin
      { Note, CrossJump keeps its input value if a conditional jump is not found - it doesn't get set to False }
      Next := Current;
      repeat
        Result := GetNextInstruction(Next,Next);
        if Result and (Next.typ=ait_instruction) and is_calljmp(taicpu(Next).opcode) then
          if is_calljmpuncond(taicpu(Next).opcode) then
            begin
              Result := False;
              Exit;
            end
          else
            CrossJump := True;
      until not Result or
            not (cs_opt_level3 in current_settings.optimizerswitches) or
            (Next.typ <> ait_instruction) or
            RegInInstruction(reg,Next);
    end;


  function TX86AsmOptimizer.GetNextInstructionUsingRegTrackingUse(Current: tai; out Next: tai; reg: TRegister): Boolean;
    begin
      if not(cs_opt_level3 in current_settings.optimizerswitches) then
        begin
          Result:=GetNextInstruction(Current,Next);
          exit;
        end;
      Next:=tai(Current.Next);
      Result:=false;
      while assigned(Next) do
        begin
          if ((Next.typ=ait_instruction) and is_calljmp(taicpu(Next).opcode) and not(taicpu(Next).opcode=A_CALL)) or
            ((Next.typ=ait_regalloc) and (getsupreg(tai_regalloc(Next).reg)=getsupreg(reg))) or
            ((Next.typ=ait_label) and not(labelCanBeSkipped(Tai_Label(Next)))) then
            exit
          else if (Next.typ=ait_instruction) and RegInInstruction(reg,Next) and not(taicpu(Next).opcode=A_CALL) then
            begin
              Result:=true;
              exit;
            end;
          Next:=tai(Next.Next);
        end;
    end;


  function TX86AsmOptimizer.InstructionLoadsFromReg(const reg: TRegister;const hp: tai): boolean;
    begin
      Result:=RegReadByInstruction(reg,hp);
    end;


  function TX86AsmOptimizer.RegReadByInstruction(reg: TRegister; hp: tai): boolean;
    var
      p: taicpu;
      opcount: longint;
    begin
      RegReadByInstruction := false;
      if hp.typ <> ait_instruction then
        exit;
      p := taicpu(hp);
      case p.opcode of
        A_CALL:
          regreadbyinstruction := true;
        A_IMUL:
          case p.ops of
            1:
              regReadByInstruction := RegInOp(reg,p.oper[0]^) or
                 (
                  ((getregtype(reg)=R_INTREGISTER) and (getsupreg(reg)=RS_EAX)) and
                  ((getsubreg(reg)<>R_SUBH) or (p.opsize<>S_B))
                 );
            2,3:
              regReadByInstruction :=
                reginop(reg,p.oper[0]^) or
                reginop(reg,p.oper[1]^);
            else
              InternalError(2019112801);
          end;
        A_MUL:
          begin
            regReadByInstruction := RegInOp(reg,p.oper[0]^) or
               (
                ((getregtype(reg)=R_INTREGISTER) and (getsupreg(reg)=RS_EAX)) and
                ((getsubreg(reg)<>R_SUBH) or (p.opsize<>S_B))
               );
          end;
        A_IDIV,A_DIV:
          begin
            regReadByInstruction := RegInOp(reg,p.oper[0]^) or
               (
                 (getregtype(reg)=R_INTREGISTER) and
                 (
                   (getsupreg(reg)=RS_EAX) or ((getsupreg(reg)=RS_EDX) and (p.opsize<>S_B))
                 )
               );
          end;
        else
          begin
            if (p.opcode=A_LEA) and is_segment_reg(reg) then
              begin
                RegReadByInstruction := false;
                exit;
              end;
            for opcount := 0 to p.ops-1 do
              if (p.oper[opCount]^.typ = top_ref) and
                 RegInRef(reg,p.oper[opcount]^.ref^) then
                begin
                  RegReadByInstruction := true;
                  exit
                end;
            { special handling for SSE MOVSD }
            if (p.opcode=A_MOVSD) and (p.ops>0) then
              begin
                if p.ops<>2 then
                  internalerror(2017042702);
                regReadByInstruction := reginop(reg,p.oper[0]^) or
                  (
                   (p.oper[1]^.typ=top_reg) and (p.oper[0]^.typ=top_reg) and reginop(reg, p.oper[1]^)
                  );
                exit;
              end;
            with insprop[p.opcode] do
              begin
                if getregtype(reg)=R_INTREGISTER then
                  begin
                    case getsupreg(reg) of
                      RS_EAX:
                        if [Ch_REAX,Ch_RWEAX,Ch_MEAX]*Ch<>[] then
                          begin
                            RegReadByInstruction := true;
                            exit
                          end;
                      RS_ECX:
                        if [Ch_RECX,Ch_RWECX,Ch_MECX]*Ch<>[] then
                          begin
                            RegReadByInstruction := true;
                            exit
                          end;
                      RS_EDX:
                        if [Ch_REDX,Ch_RWEDX,Ch_MEDX]*Ch<>[] then
                          begin
                            RegReadByInstruction := true;
                            exit
                          end;
                      RS_EBX:
                        if [Ch_REBX,Ch_RWEBX,Ch_MEBX]*Ch<>[] then
                          begin
                            RegReadByInstruction := true;
                            exit
                          end;
                      RS_ESP:
                        if [Ch_RESP,Ch_RWESP,Ch_MESP]*Ch<>[] then
                          begin
                            RegReadByInstruction := true;
                            exit
                          end;
                      RS_EBP:
                        if [Ch_REBP,Ch_RWEBP,Ch_MEBP]*Ch<>[] then
                          begin
                            RegReadByInstruction := true;
                            exit
                          end;
                      RS_ESI:
                        if [Ch_RESI,Ch_RWESI,Ch_MESI]*Ch<>[] then
                          begin
                            RegReadByInstruction := true;
                            exit
                          end;
                      RS_EDI:
                        if [Ch_REDI,Ch_RWEDI,Ch_MEDI]*Ch<>[] then
                          begin
                            RegReadByInstruction := true;
                            exit
                          end;
                    end;
                  end;
                if SuperRegistersEqual(reg,NR_DEFAULTFLAGS) then
                  begin
                    if (Ch_RFLAGScc in Ch) and not(getsubreg(reg) in [R_SUBW,R_SUBD,R_SUBQ]) then
                      begin
                        case p.condition of
                          C_A,C_NBE,       { CF=0 and ZF=0  }
                          C_BE,C_NA:       { CF=1 or ZF=1   }
                            RegReadByInstruction:=getsubreg(reg) in [R_SUBFLAGCARRY,R_SUBFLAGZERO];
                          C_AE,C_NB,C_NC,  { CF=0           }
                          C_B,C_NAE,C_C:   { CF=1           }
                            RegReadByInstruction:=getsubreg(reg) in [R_SUBFLAGCARRY];
                          C_NE,C_NZ,       { ZF=0           }
                          C_E,C_Z:         { ZF=1           }
                            RegReadByInstruction:=getsubreg(reg) in [R_SUBFLAGZERO];
                          C_G,C_NLE,       { ZF=0 and SF=OF }
                          C_LE,C_NG:       { ZF=1 or SF<>OF }
                            RegReadByInstruction:=getsubreg(reg) in [R_SUBFLAGZERO,R_SUBFLAGSIGN,R_SUBFLAGOVERFLOW];
                          C_GE,C_NL,       { SF=OF          }
                          C_L,C_NGE:       { SF<>OF         }
                            RegReadByInstruction:=getsubreg(reg) in [R_SUBFLAGSIGN,R_SUBFLAGOVERFLOW];
                          C_NO,            { OF=0           }
                          C_O:             { OF=1           }
                            RegReadByInstruction:=getsubreg(reg) in [R_SUBFLAGOVERFLOW];
                          C_NP,C_PO,       { PF=0           }
                          C_P,C_PE:        { PF=1           }
                            RegReadByInstruction:=getsubreg(reg) in [R_SUBFLAGPARITY];
                          C_NS,            { SF=0           }
                          C_S:             { SF=1           }
                            RegReadByInstruction:=getsubreg(reg) in [R_SUBFLAGSIGN];
                          else
                            internalerror(2017042701);
                        end;
                        if RegReadByInstruction then
                          exit;
                      end;
                    case getsubreg(reg) of
                      R_SUBW,R_SUBD,R_SUBQ:
                        RegReadByInstruction :=
                          [Ch_RCarryFlag,Ch_RParityFlag,Ch_RAuxiliaryFlag,Ch_RZeroFlag,Ch_RSignFlag,Ch_ROverflowFlag,
                           Ch_RWCarryFlag,Ch_RWParityFlag,Ch_RWAuxiliaryFlag,Ch_RWZeroFlag,Ch_RWSignFlag,Ch_RWOverflowFlag,
                           Ch_RDirFlag,Ch_RFlags,Ch_RWFlags,Ch_RFLAGScc]*Ch<>[];
                      R_SUBFLAGCARRY:
                        RegReadByInstruction:=[Ch_RCarryFlag,Ch_RWCarryFlag,Ch_RFlags,Ch_RWFlags]*Ch<>[];
                      R_SUBFLAGPARITY:
                        RegReadByInstruction:=[Ch_RParityFlag,Ch_RWParityFlag,Ch_RFlags,Ch_RWFlags]*Ch<>[];
                      R_SUBFLAGAUXILIARY:
                        RegReadByInstruction:=[Ch_RAuxiliaryFlag,Ch_RWAuxiliaryFlag,Ch_RFlags,Ch_RWFlags]*Ch<>[];
                      R_SUBFLAGZERO:
                        RegReadByInstruction:=[Ch_RZeroFlag,Ch_RWZeroFlag,Ch_RFlags,Ch_RWFlags]*Ch<>[];
                      R_SUBFLAGSIGN:
                        RegReadByInstruction:=[Ch_RSignFlag,Ch_RWSignFlag,Ch_RFlags,Ch_RWFlags]*Ch<>[];
                      R_SUBFLAGOVERFLOW:
                        RegReadByInstruction:=[Ch_ROverflowFlag,Ch_RWOverflowFlag,Ch_RFlags,Ch_RWFlags]*Ch<>[];
                      R_SUBFLAGINTERRUPT:
                        RegReadByInstruction:=[Ch_RFlags,Ch_RWFlags]*Ch<>[];
                      R_SUBFLAGDIRECTION:
                        RegReadByInstruction:=[Ch_RDirFlag,Ch_RFlags,Ch_RWFlags]*Ch<>[];
                      else
                        internalerror(2017042601);
                    end;
                    exit;
                  end;
                if (Ch_NoReadIfEqualRegs in Ch) and (p.ops=2) and
                   (p.oper[0]^.typ=top_reg) and (p.oper[1]^.typ=top_reg) and
                   (p.oper[0]^.reg=p.oper[1]^.reg) then
                  exit;
                if ([CH_RWOP1,CH_ROP1,CH_MOP1]*Ch<>[]) and reginop(reg,p.oper[0]^) then
                  begin
                    RegReadByInstruction := true;
                    exit
                  end;
                if ([Ch_RWOP2,Ch_ROP2,Ch_MOP2]*Ch<>[]) and reginop(reg,p.oper[1]^) then
                  begin
                    RegReadByInstruction := true;
                    exit
                  end;
                if ([Ch_RWOP3,Ch_ROP3,Ch_MOP3]*Ch<>[]) and reginop(reg,p.oper[2]^) then
                  begin
                    RegReadByInstruction := true;
                    exit
                  end;
                if ([Ch_RWOP4,Ch_ROP4,Ch_MOP4]*Ch<>[]) and reginop(reg,p.oper[3]^) then
                  begin
                    RegReadByInstruction := true;
                    exit
                  end;
              end;
          end;
      end;
    end;


  function TX86AsmOptimizer.RegInInstruction(Reg: TRegister; p1: tai): Boolean;
    begin
      result:=false;
      if p1.typ<>ait_instruction then
        exit;

      if (Ch_All in insprop[taicpu(p1).opcode].Ch) then
        exit(true);

      if (getregtype(reg)=R_INTREGISTER) and
        { change information for xmm movsd are not correct }
        ((taicpu(p1).opcode<>A_MOVSD) or (taicpu(p1).ops=0)) then
        begin
          case getsupreg(reg) of
            { RS_EAX = RS_RAX on x86-64 }
            RS_EAX:
              result:=([Ch_REAX,Ch_RRAX,Ch_WEAX,Ch_WRAX,Ch_RWEAX,Ch_RWRAX,Ch_MEAX,Ch_MRAX]*insprop[taicpu(p1).opcode].Ch)<>[];
            RS_ECX:
              result:=([Ch_RECX,Ch_RRCX,Ch_WECX,Ch_WRCX,Ch_RWECX,Ch_RWRCX,Ch_MECX,Ch_MRCX]*insprop[taicpu(p1).opcode].Ch)<>[];
            RS_EDX:
              result:=([Ch_REDX,Ch_RRDX,Ch_WEDX,Ch_WRDX,Ch_RWEDX,Ch_RWRDX,Ch_MEDX,Ch_MRDX]*insprop[taicpu(p1).opcode].Ch)<>[];
            RS_EBX:
              result:=([Ch_REBX,Ch_RRBX,Ch_WEBX,Ch_WRBX,Ch_RWEBX,Ch_RWRBX,Ch_MEBX,Ch_MRBX]*insprop[taicpu(p1).opcode].Ch)<>[];
            RS_ESP:
              result:=([Ch_RESP,Ch_RRSP,Ch_WESP,Ch_WRSP,Ch_RWESP,Ch_RWRSP,Ch_MESP,Ch_MRSP]*insprop[taicpu(p1).opcode].Ch)<>[];
            RS_EBP:
              result:=([Ch_REBP,Ch_RRBP,Ch_WEBP,Ch_WRBP,Ch_RWEBP,Ch_RWRBP,Ch_MEBP,Ch_MRBP]*insprop[taicpu(p1).opcode].Ch)<>[];
            RS_ESI:
              result:=([Ch_RESI,Ch_RRSI,Ch_WESI,Ch_WRSI,Ch_RWESI,Ch_RWRSI,Ch_MESI,Ch_MRSI,Ch_RMemEDI]*insprop[taicpu(p1).opcode].Ch)<>[];
            RS_EDI:
              result:=([Ch_REDI,Ch_RRDI,Ch_WEDI,Ch_WRDI,Ch_RWEDI,Ch_RWRDI,Ch_MEDI,Ch_MRDI,Ch_WMemEDI]*insprop[taicpu(p1).opcode].Ch)<>[];
            else
              ;
          end;
          if result then
            exit;
        end
      else if SuperRegistersEqual(reg,NR_DEFAULTFLAGS) then
        begin
          if ([Ch_RFlags,Ch_WFlags,Ch_RWFlags,Ch_RFLAGScc]*insprop[taicpu(p1).opcode].Ch)<>[] then
            exit(true);
          case getsubreg(reg) of
            R_SUBFLAGCARRY:
              Result:=([Ch_RCarryFlag,Ch_RWCarryFlag,Ch_W0CarryFlag,Ch_W1CarryFlag,Ch_WCarryFlag,Ch_WUCarryFlag]*insprop[taicpu(p1).opcode].Ch)<>[];
            R_SUBFLAGPARITY:
              Result:=([Ch_RParityFlag,Ch_RWParityFlag,Ch_W0ParityFlag,Ch_W1ParityFlag,Ch_WParityFlag,Ch_WUParityFlag]*insprop[taicpu(p1).opcode].Ch)<>[];
            R_SUBFLAGAUXILIARY:
              Result:=([Ch_RAuxiliaryFlag,Ch_RWAuxiliaryFlag,Ch_W0AuxiliaryFlag,Ch_W1AuxiliaryFlag,Ch_WAuxiliaryFlag,Ch_WUAuxiliaryFlag]*insprop[taicpu(p1).opcode].Ch)<>[];
            R_SUBFLAGZERO:
              Result:=([Ch_RZeroFlag,Ch_RWZeroFlag,Ch_W0ZeroFlag,Ch_W1ZeroFlag,Ch_WZeroFlag,Ch_WUZeroFlag]*insprop[taicpu(p1).opcode].Ch)<>[];
            R_SUBFLAGSIGN:
              Result:=([Ch_RSignFlag,Ch_RWSignFlag,Ch_W0SignFlag,Ch_W1SignFlag,Ch_WSignFlag,Ch_WUSignFlag]*insprop[taicpu(p1).opcode].Ch)<>[];
            R_SUBFLAGOVERFLOW:
              Result:=([Ch_ROverflowFlag,Ch_RWOverflowFlag,Ch_W0OverflowFlag,Ch_W1OverflowFlag,Ch_WOverflowFlag,Ch_WUOverflowFlag]*insprop[taicpu(p1).opcode].Ch)<>[];
            R_SUBFLAGINTERRUPT:
              Result:=([Ch_W0IntFlag,Ch_W1IntFlag,Ch_WFlags]*insprop[taicpu(p1).opcode].Ch)<>[];
            R_SUBFLAGDIRECTION:
              Result:=([Ch_RDirFlag,Ch_W0DirFlag,Ch_W1DirFlag,Ch_WFlags]*insprop[taicpu(p1).opcode].Ch)<>[];
            else
              ;
          end;
          if result then
            exit;
        end
      else if (getregtype(reg)=R_FPUREGISTER) and (Ch_FPU in insprop[taicpu(p1).opcode].Ch) then
        exit(true);
      Result:=inherited RegInInstruction(Reg, p1);
    end;


    function TX86AsmOptimizer.RegModifiedByInstruction(Reg: TRegister; p1: tai): boolean;
      begin
        Result := False;
        if p1.typ <> ait_instruction then
          exit;

        with insprop[taicpu(p1).opcode] do
          if SuperRegistersEqual(reg,NR_DEFAULTFLAGS) then
            begin
              case getsubreg(reg) of
                R_SUBW,R_SUBD,R_SUBQ:
                  Result :=
                    [Ch_WCarryFlag,Ch_WParityFlag,Ch_WAuxiliaryFlag,Ch_WZeroFlag,Ch_WSignFlag,Ch_WOverflowFlag,
                     Ch_RWCarryFlag,Ch_RWParityFlag,Ch_RWAuxiliaryFlag,Ch_RWZeroFlag,Ch_RWSignFlag,Ch_RWOverflowFlag,
                     Ch_W0DirFlag,Ch_W1DirFlag,Ch_W0IntFlag,Ch_W1IntFlag,Ch_WFlags,Ch_RWFlags]*Ch<>[];
                R_SUBFLAGCARRY:
                  Result:=[Ch_WCarryFlag,Ch_RWCarryFlag,Ch_WFlags,Ch_RWFlags]*Ch<>[];
                R_SUBFLAGPARITY:
                  Result:=[Ch_WParityFlag,Ch_RWParityFlag,Ch_WFlags,Ch_RWFlags]*Ch<>[];
                R_SUBFLAGAUXILIARY:
                  Result:=[Ch_WAuxiliaryFlag,Ch_RWAuxiliaryFlag,Ch_WFlags,Ch_RWFlags]*Ch<>[];
                R_SUBFLAGZERO:
                  Result:=[Ch_WZeroFlag,Ch_RWZeroFlag,Ch_WFlags,Ch_RWFlags]*Ch<>[];
                R_SUBFLAGSIGN:
                  Result:=[Ch_WSignFlag,Ch_RWSignFlag,Ch_WFlags,Ch_RWFlags]*Ch<>[];
                R_SUBFLAGOVERFLOW:
                  Result:=[Ch_WOverflowFlag,Ch_RWOverflowFlag,Ch_WFlags,Ch_RWFlags]*Ch<>[];
                R_SUBFLAGINTERRUPT:
                  Result:=[Ch_W0IntFlag,Ch_W1IntFlag,Ch_WFlags,Ch_RWFlags]*Ch<>[];
                R_SUBFLAGDIRECTION:
                  Result:=[Ch_W0DirFlag,Ch_W1DirFlag,Ch_WFlags,Ch_RWFlags]*Ch<>[];
                else
                  internalerror(2017042602);
              end;
              exit;
            end;

        case taicpu(p1).opcode of
          A_CALL:
            { We could potentially set Result to False if the register in
              question is non-volatile for the subroutine's calling convention,
              but this would require detecting the calling convention in use and
              also assuming that the routine doesn't contain malformed assembly
              language, for example... so it could only be done under -O4 as it
              would be considered a side-effect. [Kit] }
            Result := True;
          A_MOVSD:
            { special handling for SSE MOVSD }
            if (taicpu(p1).ops>0) then
              begin
                if taicpu(p1).ops<>2 then
                  internalerror(2017042703);
                Result := (taicpu(p1).oper[1]^.typ=top_reg) and RegInOp(reg,taicpu(p1).oper[1]^);
              end;
          {  VMOVSS and VMOVSD has two and three operand flavours, this cannot modelled by x86ins.dat
             so fix it here (FK)
          }
          A_VMOVSS,
          A_VMOVSD:
            begin
              Result := (taicpu(p1).ops=3) and (taicpu(p1).oper[2]^.typ=top_reg) and RegInOp(reg,taicpu(p1).oper[2]^);
              exit;
            end;
          A_IMUL:
            Result := (taicpu(p1).oper[taicpu(p1).ops-1]^.typ=top_reg) and RegInOp(reg,taicpu(p1).oper[taicpu(p1).ops-1]^);
          else
            ;
        end;
        if Result then
          exit;
        with insprop[taicpu(p1).opcode] do
          begin
            if getregtype(reg)=R_INTREGISTER then
              begin
                case getsupreg(reg) of
                  RS_EAX:
                    if [Ch_WEAX,Ch_RWEAX,Ch_MEAX]*Ch<>[] then
                      begin
                        Result := True;
                        exit
                      end;
                  RS_ECX:
                    if [Ch_WECX,Ch_RWECX,Ch_MECX]*Ch<>[] then
                      begin
                        Result := True;
                        exit
                      end;
                  RS_EDX:
                    if [Ch_WEDX,Ch_RWEDX,Ch_MEDX]*Ch<>[] then
                      begin
                        Result := True;
                        exit
                      end;
                  RS_EBX:
                    if [Ch_WEBX,Ch_RWEBX,Ch_MEBX]*Ch<>[] then
                      begin
                        Result := True;
                        exit
                      end;
                  RS_ESP:
                    if [Ch_WESP,Ch_RWESP,Ch_MESP]*Ch<>[] then
                      begin
                        Result := True;
                        exit
                      end;
                  RS_EBP:
                    if [Ch_WEBP,Ch_RWEBP,Ch_MEBP]*Ch<>[] then
                      begin
                        Result := True;
                        exit
                      end;
                  RS_ESI:
                    if [Ch_WESI,Ch_RWESI,Ch_MESI]*Ch<>[] then
                      begin
                        Result := True;
                        exit
                      end;
                  RS_EDI:
                    if [Ch_WEDI,Ch_RWEDI,Ch_MEDI]*Ch<>[] then
                      begin
                        Result := True;
                        exit
                      end;
                end;
              end;
            if ([CH_RWOP1,CH_WOP1,CH_MOP1]*Ch<>[]) and reginop(reg,taicpu(p1).oper[0]^) then
              begin
                Result := true;
                exit
              end;
            if ([Ch_RWOP2,Ch_WOP2,Ch_MOP2]*Ch<>[]) and reginop(reg,taicpu(p1).oper[1]^) then
              begin
                Result := true;
                exit
              end;
            if ([Ch_RWOP3,Ch_WOP3,Ch_MOP3]*Ch<>[]) and reginop(reg,taicpu(p1).oper[2]^) then
              begin
                Result := true;
                exit
              end;
            if ([Ch_RWOP4,Ch_WOP4,Ch_MOP4]*Ch<>[]) and reginop(reg,taicpu(p1).oper[3]^) then
              begin
                Result := true;
                exit
              end;
          end;
      end;


{$ifdef DEBUG_AOPTCPU}
    procedure TX86AsmOptimizer.DebugMsg(const s: string;p : tai);
      begin
        asml.insertbefore(tai_comment.Create(strpnew(s)), p);
      end;

    function debug_tostr(i: tcgint): string; inline;
      begin
        Result := tostr(i);
      end;

    function debug_regname(r: TRegister): string; inline;
      begin
        Result := '%' + std_regname(r);
      end;

    { Debug output function - creates a string representation of an operator }
    function debug_operstr(oper: TOper): string;
      begin
        case oper.typ of
          top_const:
            Result := '$' + debug_tostr(oper.val);
          top_reg:
            Result := debug_regname(oper.reg);
          top_ref:
            begin
              if oper.ref^.offset <> 0 then
                Result := debug_tostr(oper.ref^.offset) + '('
              else
                Result := '(';

              if (oper.ref^.base <> NR_INVALID) and (oper.ref^.base <> NR_NO) then
                begin
                  Result := Result + debug_regname(oper.ref^.base);
                  if (oper.ref^.index <> NR_INVALID) and (oper.ref^.index <> NR_NO) then
                    Result := Result + ',' + debug_regname(oper.ref^.index);
                end
              else
                if (oper.ref^.index <> NR_INVALID) and (oper.ref^.index <> NR_NO) then
                  Result := Result + debug_regname(oper.ref^.index);

              if (oper.ref^.scalefactor > 1) then
                Result := Result + ',' + debug_tostr(oper.ref^.scalefactor) + ')'
              else
                Result := Result + ')';
            end;
          else
            Result := '[UNKNOWN]';
        end;
      end;

    function debug_op2str(opcode: tasmop): string; inline;
      begin
        Result := std_op2str[opcode];
      end;

    function debug_opsize2str(opsize: topsize): string; inline;
      begin
        Result := gas_opsize2str[opsize];
      end;

{$else DEBUG_AOPTCPU}
    procedure TX86AsmOptimizer.DebugMsg(const s: string;p : tai);inline;
      begin
      end;

    function debug_tostr(i: tcgint): string; inline;
      begin
        Result := '';
      end;

    function debug_regname(r: TRegister): string; inline;
      begin
        Result := '';
      end;

    function debug_operstr(oper: TOper): string; inline;
      begin
        Result := '';
      end;

    function debug_op2str(opcode: tasmop): string; inline;
      begin
        Result := '';
      end;

    function debug_opsize2str(opsize: topsize): string; inline;
      begin
        Result := '';
      end;
{$endif DEBUG_AOPTCPU}

    class function TX86AsmOptimizer.IsMOVZXAcceptable: Boolean; inline;
      begin
{$ifdef x86_64}
        { Always fine on x86-64 }
        Result := True;
{$else x86_64}
        Result :=
{$ifdef i8086}
          (current_settings.cputype >= cpu_386) and
{$endif i8086}
          (
            { Always accept if optimising for size }
            (cs_opt_size in current_settings.optimizerswitches) or
            { From the Pentium II onwards, MOVZX only takes 1 cycle. [Kit] }
            (current_settings.optimizecputype >= cpu_Pentium2)
          );
{$endif x86_64}
      end;

    function TX86AsmOptimizer.Reg1WriteOverwritesReg2Entirely(reg1, reg2: tregister): boolean;
      begin
        if not SuperRegistersEqual(reg1,reg2) then
          exit(false);
        if getregtype(reg1)<>R_INTREGISTER then
          exit(true);  {because SuperRegisterEqual is true}
        case getsubreg(reg1) of
          { A write to R_SUBL doesn't change R_SUBH and if reg2 is R_SUBW or
            higher, it preserves the high bits, so the new value depends on
            reg2's previous value. In other words, it is equivalent to doing:

            reg2 := (reg2 and $ffffff00) or byte(reg1); }
          R_SUBL:
            exit(getsubreg(reg2)=R_SUBL);
          { A write to R_SUBH doesn't change R_SUBL and if reg2 is R_SUBW or
            higher, it actually does a:

            reg2 := (reg2 and $ffff00ff) or (reg1 and $ff00); }
          R_SUBH:
            exit(getsubreg(reg2)=R_SUBH);
          { If reg2 is R_SUBD or larger, a write to R_SUBW preserves the high 16
            bits of reg2:

            reg2 := (reg2 and $ffff0000) or word(reg1); }
          R_SUBW:
            exit(getsubreg(reg2) in [R_SUBL,R_SUBH,R_SUBW]);
          { a write to R_SUBD always overwrites every other subregister,
            because it clears the high 32 bits of R_SUBQ on x86_64 }
          R_SUBD,
          R_SUBQ:
            exit(true);
          else
            internalerror(2017042801);
        end;
      end;


    function TX86AsmOptimizer.Reg1ReadDependsOnReg2(reg1, reg2: tregister): boolean;
      begin
        if not SuperRegistersEqual(reg1,reg2) then
          exit(false);
        if getregtype(reg1)<>R_INTREGISTER then
          exit(true);  {because SuperRegisterEqual is true}
        case getsubreg(reg1) of
          R_SUBL:
            exit(getsubreg(reg2)<>R_SUBH);
          R_SUBH:
            exit(getsubreg(reg2)<>R_SUBL);
          R_SUBW,
          R_SUBD,
          R_SUBQ:
            exit(true);
          else
            internalerror(2017042802);
        end;
      end;


    function TX86AsmOptimizer.PrePeepholeOptSxx(var p : tai) : boolean;
      var
        hp1 : tai;
        l : TCGInt;
      begin
        result:=false;
        { changes the code sequence
          shr/sar const1, x
          shl     const2, x

          to

          either "sar/and", "shl/and" or just "and" depending on const1 and const2 }
        if GetNextInstruction(p, hp1) and
          MatchInstruction(hp1,A_SHL,[]) and
          (taicpu(p).oper[0]^.typ = top_const) and
          (taicpu(hp1).oper[0]^.typ = top_const) and
          (taicpu(hp1).opsize = taicpu(p).opsize) and
          (taicpu(hp1).oper[1]^.typ = taicpu(p).oper[1]^.typ) and
          OpsEqual(taicpu(hp1).oper[1]^, taicpu(p).oper[1]^) then
          begin
            if (taicpu(p).oper[0]^.val > taicpu(hp1).oper[0]^.val) and
              not(cs_opt_size in current_settings.optimizerswitches) then
              begin
                { shr/sar const1, %reg
                  shl     const2, %reg
                  with const1 > const2 }
                taicpu(p).loadConst(0,taicpu(p).oper[0]^.val-taicpu(hp1).oper[0]^.val);
                taicpu(hp1).opcode := A_AND;
                l := (1 shl (taicpu(hp1).oper[0]^.val)) - 1;
                case taicpu(p).opsize Of
                  S_B: taicpu(hp1).loadConst(0,l Xor $ff);
                  S_W: taicpu(hp1).loadConst(0,l Xor $ffff);
                  S_L: taicpu(hp1).loadConst(0,l Xor tcgint($ffffffff));
                  S_Q: taicpu(hp1).loadConst(0,l Xor tcgint($ffffffffffffffff));
                  else
                    Internalerror(2017050703)
                end;
              end
            else if (taicpu(p).oper[0]^.val<taicpu(hp1).oper[0]^.val) and
              not(cs_opt_size in current_settings.optimizerswitches) then
              begin
                { shr/sar const1, %reg
                  shl     const2, %reg
                  with const1 < const2 }
                taicpu(hp1).loadConst(0,taicpu(hp1).oper[0]^.val-taicpu(p).oper[0]^.val);
                taicpu(p).opcode := A_AND;
                l := (1 shl (taicpu(p).oper[0]^.val))-1;
                case taicpu(p).opsize Of
                  S_B: taicpu(p).loadConst(0,l Xor $ff);
                  S_W: taicpu(p).loadConst(0,l Xor $ffff);
                  S_L: taicpu(p).loadConst(0,l Xor tcgint($ffffffff));
                  S_Q: taicpu(p).loadConst(0,l Xor tcgint($ffffffffffffffff));
                  else
                    Internalerror(2017050702)
                end;
              end
            else if (taicpu(p).oper[0]^.val = taicpu(hp1).oper[0]^.val) then
              begin
                { shr/sar const1, %reg
                  shl     const2, %reg
                  with const1 = const2 }
                taicpu(p).opcode := A_AND;
                l := (1 shl (taicpu(p).oper[0]^.val))-1;
                case taicpu(p).opsize Of
                  S_B: taicpu(p).loadConst(0,l Xor $ff);
                  S_W: taicpu(p).loadConst(0,l Xor $ffff);
                  S_L: taicpu(p).loadConst(0,l Xor tcgint($ffffffff));
                  S_Q: taicpu(p).loadConst(0,l Xor tcgint($ffffffffffffffff));
                  else
                    Internalerror(2017050701)
                end;
                RemoveInstruction(hp1);
              end;
          end;
      end;


    function TX86AsmOptimizer.PrePeepholeOptIMUL(var p : tai) : boolean;
      var
        opsize : topsize;
        hp1 : tai;
        tmpref : treference;
        ShiftValue : Cardinal;
        BaseValue : TCGInt;
      begin
        result:=false;
        opsize:=taicpu(p).opsize;
        { changes certain "imul const, %reg"'s to lea sequences }
        if (MatchOpType(taicpu(p),top_const,top_reg) or
            MatchOpType(taicpu(p),top_const,top_reg,top_reg)) and
           (opsize in [S_L{$ifdef x86_64},S_Q{$endif x86_64}]) then
          if (taicpu(p).oper[0]^.val = 1) then
            if (taicpu(p).ops = 2) then
             { remove "imul $1, reg" }
              begin
                DebugMsg(SPeepholeOptimization + 'Imul2Nop done',p);
                Result := RemoveCurrentP(p);
              end
            else
             { change "imul $1, reg1, reg2" to "mov reg1, reg2" }
              begin
                hp1 := taicpu.Op_Reg_Reg(A_MOV, opsize, taicpu(p).oper[1]^.reg,taicpu(p).oper[2]^.reg);
                InsertLLItem(p.previous, p.next, hp1);
                DebugMsg(SPeepholeOptimization + 'Imul2Mov done',p);
                p.free;
                p := hp1;
              end
          else if ((taicpu(p).ops <= 2) or
              (taicpu(p).oper[2]^.typ = Top_Reg)) and
           not(cs_opt_size in current_settings.optimizerswitches) and
           (not(GetNextInstruction(p, hp1)) or
             not((tai(hp1).typ = ait_instruction) and
                 ((taicpu(hp1).opcode=A_Jcc) and
                  (taicpu(hp1).condition in [C_O,C_NO])))) then
            begin
              {
                imul X, reg1, reg2 to
                  lea (reg1,reg1,Y), reg2
                  shl ZZ,reg2
                imul XX, reg1 to
                  lea (reg1,reg1,YY), reg1
                  shl ZZ,reg2

                This optimziation makes sense for pretty much every x86, except the VIA Nano3000: it has IMUL latency 2, lea/shl pair as well,
                it does not exist as a separate optimization target in FPC though.

                This optimziation can be applied as long as only two bits are set in the constant and those two bits are separated by
                at most two zeros
              }
              reference_reset(tmpref,1,[]);
              if (PopCnt(QWord(taicpu(p).oper[0]^.val))=2) and (BsrQWord(taicpu(p).oper[0]^.val)-BsfQWord(taicpu(p).oper[0]^.val)<=3) then
                begin
                  ShiftValue:=BsfQWord(taicpu(p).oper[0]^.val);
                  BaseValue:=taicpu(p).oper[0]^.val shr ShiftValue;
                  TmpRef.base := taicpu(p).oper[1]^.reg;
                  TmpRef.index := taicpu(p).oper[1]^.reg;
                  if not(BaseValue in [3,5,9]) then
                    Internalerror(2018110101);
                  TmpRef.ScaleFactor := BaseValue-1;
                  if (taicpu(p).ops = 2) then
                    hp1 := taicpu.op_ref_reg(A_LEA, opsize, TmpRef, taicpu(p).oper[1]^.reg)
                  else
                    hp1 := taicpu.op_ref_reg(A_LEA, opsize, TmpRef, taicpu(p).oper[2]^.reg);
                  AsmL.InsertAfter(hp1,p);
                  DebugMsg(SPeepholeOptimization + 'Imul2LeaShl done',p);
                  taicpu(hp1).fileinfo:=taicpu(p).fileinfo;
                  RemoveCurrentP(p, hp1);
                  if ShiftValue>0 then
                    AsmL.InsertAfter(taicpu.op_const_reg(A_SHL, opsize, ShiftValue, taicpu(hp1).oper[1]^.reg),hp1);
              end;
            end;
      end;


    function TX86AsmOptimizer.RegLoadedWithNewValue(reg: tregister; hp: tai): boolean;
      var
        p: taicpu;
      begin
        if not assigned(hp) or
           (hp.typ <> ait_instruction) then
         begin
           Result := false;
           exit;
         end;
        p := taicpu(hp);
        if SuperRegistersEqual(reg,NR_DEFAULTFLAGS) then
          with insprop[p.opcode] do
            begin
              case getsubreg(reg) of
                R_SUBW,R_SUBD,R_SUBQ:
                  Result:=
                    RegLoadedWithNewValue(NR_CARRYFLAG,hp) and
                    RegLoadedWithNewValue(NR_PARITYFLAG,hp) and
                    RegLoadedWithNewValue(NR_AUXILIARYFLAG,hp) and
                    RegLoadedWithNewValue(NR_ZEROFLAG,hp) and
                    RegLoadedWithNewValue(NR_SIGNFLAG,hp) and
                    RegLoadedWithNewValue(NR_OVERFLOWFLAG,hp);
                R_SUBFLAGCARRY:
                  Result:=[Ch_W0CarryFlag,Ch_W1CarryFlag,Ch_WCarryFlag,Ch_WUCarryFlag,Ch_WFlags]*Ch<>[];
                R_SUBFLAGPARITY:
                  Result:=[Ch_W0ParityFlag,Ch_W1ParityFlag,Ch_WParityFlag,Ch_WUParityFlag,Ch_WFlags]*Ch<>[];
                R_SUBFLAGAUXILIARY:
                  Result:=[Ch_W0AuxiliaryFlag,Ch_W1AuxiliaryFlag,Ch_WAuxiliaryFlag,Ch_WUAuxiliaryFlag,Ch_WFlags]*Ch<>[];
                R_SUBFLAGZERO:
                  Result:=[Ch_W0ZeroFlag,Ch_W1ZeroFlag,Ch_WZeroFlag,Ch_WUZeroFlag,Ch_WFlags]*Ch<>[];
                R_SUBFLAGSIGN:
                  Result:=[Ch_W0SignFlag,Ch_W1SignFlag,Ch_WSignFlag,Ch_WUSignFlag,Ch_WFlags]*Ch<>[];
                R_SUBFLAGOVERFLOW:
                  Result:=[Ch_W0OverflowFlag,Ch_W1OverflowFlag,Ch_WOverflowFlag,Ch_WUOverflowFlag,Ch_WFlags]*Ch<>[];
                R_SUBFLAGINTERRUPT:
                  Result:=[Ch_W0IntFlag,Ch_W1IntFlag,Ch_WFlags]*Ch<>[];
                R_SUBFLAGDIRECTION:
                  Result:=[Ch_W0DirFlag,Ch_W1DirFlag,Ch_WFlags]*Ch<>[];
                else
                  begin
                  writeln(getsubreg(reg));
                  internalerror(2017050501);
                  end;
              end;
              exit;
            end;
        Result :=
          (((p.opcode = A_MOV) or
            (p.opcode = A_MOVZX) or
            (p.opcode = A_MOVSX) or
            (p.opcode = A_LEA) or
            (p.opcode = A_VMOVSS) or
            (p.opcode = A_VMOVSD) or
            (p.opcode = A_VMOVAPD) or
            (p.opcode = A_VMOVAPS) or
            (p.opcode = A_VMOVQ) or
            (p.opcode = A_MOVSS) or
            (p.opcode = A_MOVSD) or
            (p.opcode = A_MOVQ) or
            (p.opcode = A_MOVAPD) or
            (p.opcode = A_MOVAPS) or
{$ifndef x86_64}
            (p.opcode = A_LDS) or
            (p.opcode = A_LES) or
{$endif not x86_64}
            (p.opcode = A_LFS) or
            (p.opcode = A_LGS) or
            (p.opcode = A_LSS)) and
           (p.ops=2) and  { A_MOVSD can have zero operands, so this check is needed }
           (p.oper[1]^.typ = top_reg) and
           (Reg1WriteOverwritesReg2Entirely(p.oper[1]^.reg,reg)) and
           ((p.oper[0]^.typ = top_const) or
            ((p.oper[0]^.typ = top_reg) and
             not(Reg1ReadDependsOnReg2(p.oper[0]^.reg,reg))) or
            ((p.oper[0]^.typ = top_ref) and
             not RegInRef(reg,p.oper[0]^.ref^)))) or
          ((p.opcode = A_POP) and
           (Reg1WriteOverwritesReg2Entirely(p.oper[0]^.reg,reg))) or
          ((p.opcode = A_IMUL) and
           (p.ops=3) and
           (Reg1WriteOverwritesReg2Entirely(p.oper[2]^.reg,reg)) and
           (((p.oper[1]^.typ=top_reg) and not(Reg1ReadDependsOnReg2(p.oper[1]^.reg,reg))) or
            ((p.oper[1]^.typ=top_ref) and not(RegInRef(reg,p.oper[1]^.ref^))))) or
          ((((p.opcode = A_IMUL) or
             (p.opcode = A_MUL)) and
            (p.ops=1)) and
           (((p.oper[0]^.typ=top_reg) and not(Reg1ReadDependsOnReg2(p.oper[0]^.reg,reg))) or
            ((p.oper[0]^.typ=top_ref) and not(RegInRef(reg,p.oper[0]^.ref^)))) and
           (((p.opsize=S_B) and Reg1WriteOverwritesReg2Entirely(NR_AX,reg) and not(Reg1ReadDependsOnReg2(NR_AL,reg))) or
            ((p.opsize=S_W) and Reg1WriteOverwritesReg2Entirely(NR_DX,reg)) or
            ((p.opsize=S_L) and Reg1WriteOverwritesReg2Entirely(NR_EDX,reg))
{$ifdef x86_64}
         or ((p.opsize=S_Q) and Reg1WriteOverwritesReg2Entirely(NR_RDX,reg))
{$endif x86_64}
           )) or
          ((p.opcode = A_CWD) and Reg1WriteOverwritesReg2Entirely(NR_DX,reg)) or
          ((p.opcode = A_CDQ) and Reg1WriteOverwritesReg2Entirely(NR_EDX,reg)) or
{$ifdef x86_64}
          ((p.opcode = A_CQO) and Reg1WriteOverwritesReg2Entirely(NR_RDX,reg)) or
{$endif x86_64}
          ((p.opcode = A_CBW) and Reg1WriteOverwritesReg2Entirely(NR_AX,reg) and not(Reg1ReadDependsOnReg2(NR_AL,reg))) or
{$ifndef x86_64}
          ((p.opcode = A_LDS) and (reg=NR_DS) and not(RegInRef(reg,p.oper[0]^.ref^))) or
          ((p.opcode = A_LES) and (reg=NR_ES) and not(RegInRef(reg,p.oper[0]^.ref^))) or
{$endif not x86_64}
          ((p.opcode = A_LFS) and (reg=NR_FS) and not(RegInRef(reg,p.oper[0]^.ref^))) or
          ((p.opcode = A_LGS) and (reg=NR_GS) and not(RegInRef(reg,p.oper[0]^.ref^))) or
          ((p.opcode = A_LSS) and (reg=NR_SS) and not(RegInRef(reg,p.oper[0]^.ref^))) or
{$ifndef x86_64}
          ((p.opcode = A_AAM) and Reg1WriteOverwritesReg2Entirely(NR_AH,reg)) or
{$endif not x86_64}
          ((p.opcode = A_LAHF) and Reg1WriteOverwritesReg2Entirely(NR_AH,reg)) or
          ((p.opcode = A_LODSB) and Reg1WriteOverwritesReg2Entirely(NR_AL,reg)) or
          ((p.opcode = A_LODSW) and Reg1WriteOverwritesReg2Entirely(NR_AX,reg)) or
          ((p.opcode = A_LODSD) and Reg1WriteOverwritesReg2Entirely(NR_EAX,reg)) or
{$ifdef x86_64}
          ((p.opcode = A_LODSQ) and Reg1WriteOverwritesReg2Entirely(NR_RAX,reg)) or
{$endif x86_64}
          ((p.opcode = A_SETcc) and (p.oper[0]^.typ=top_reg) and Reg1WriteOverwritesReg2Entirely(p.oper[0]^.reg,reg)) or
          (((p.opcode = A_FSTSW) or
            (p.opcode = A_FNSTSW)) and
           (p.oper[0]^.typ=top_reg) and
           Reg1WriteOverwritesReg2Entirely(p.oper[0]^.reg,reg)) or
          (((p.opcode = A_XOR) or (p.opcode = A_SUB) or (p.opcode = A_SBB)) and
           (p.oper[0]^.typ=top_reg) and (p.oper[1]^.typ=top_reg) and
           (p.oper[0]^.reg=p.oper[1]^.reg) and
           Reg1WriteOverwritesReg2Entirely(p.oper[1]^.reg,reg));
      end;


    class function TX86AsmOptimizer.IsExitCode(p : tai) : boolean;
      var
        hp2,hp3 : tai;
      begin
        { some x86-64 issue a NOP before the real exit code }
        if MatchInstruction(p,A_NOP,[]) then
          GetNextInstruction(p,p);
        result:=assigned(p) and (p.typ=ait_instruction) and
        ((taicpu(p).opcode = A_RET) or
         ((taicpu(p).opcode=A_LEAVE) and
          GetNextInstruction(p,hp2) and
          MatchInstruction(hp2,A_RET,[S_NO])
         ) or
         (((taicpu(p).opcode=A_LEA) and
           MatchOpType(taicpu(p),top_ref,top_reg) and
           (taicpu(p).oper[0]^.ref^.base=NR_STACK_POINTER_REG) and
           (taicpu(p).oper[1]^.reg=NR_STACK_POINTER_REG)
           ) and
          GetNextInstruction(p,hp2) and
          MatchInstruction(hp2,A_RET,[S_NO])
         ) or
         ((((taicpu(p).opcode=A_MOV) and
           MatchOpType(taicpu(p),top_reg,top_reg) and
           (taicpu(p).oper[0]^.reg=current_procinfo.framepointer) and
           (taicpu(p).oper[1]^.reg=NR_STACK_POINTER_REG)) or
           ((taicpu(p).opcode=A_LEA) and
           MatchOpType(taicpu(p),top_ref,top_reg) and
           (taicpu(p).oper[0]^.ref^.base=current_procinfo.framepointer) and
           (taicpu(p).oper[1]^.reg=NR_STACK_POINTER_REG)
           )
          ) and
          GetNextInstruction(p,hp2) and
          MatchInstruction(hp2,A_POP,[reg2opsize(current_procinfo.framepointer)]) and
          MatchOpType(taicpu(hp2),top_reg) and
          (taicpu(hp2).oper[0]^.reg=current_procinfo.framepointer) and
          GetNextInstruction(hp2,hp3) and
          MatchInstruction(hp3,A_RET,[S_NO])
         )
        );
      end;


    class function TX86AsmOptimizer.isFoldableArithOp(hp1: taicpu; reg: tregister): boolean;
      begin
        isFoldableArithOp := False;
        case hp1.opcode of
          A_ADD,A_SUB,A_OR,A_XOR,A_AND,A_SHL,A_SHR,A_SAR:
            isFoldableArithOp :=
              ((taicpu(hp1).oper[0]^.typ = top_const) or
               ((taicpu(hp1).oper[0]^.typ = top_reg) and
                (taicpu(hp1).oper[0]^.reg <> reg))) and
              (taicpu(hp1).oper[1]^.typ = top_reg) and
              (taicpu(hp1).oper[1]^.reg = reg);
          A_INC,A_DEC,A_NEG,A_NOT:
            isFoldableArithOp :=
              (taicpu(hp1).oper[0]^.typ = top_reg) and
              (taicpu(hp1).oper[0]^.reg = reg);
          else
            ;
        end;
      end;


    procedure TX86AsmOptimizer.RemoveLastDeallocForFuncRes(p: tai);

      procedure DoRemoveLastDeallocForFuncRes( supreg: tsuperregister);
        var
          hp2: tai;
        begin
          hp2 := p;
          repeat
            hp2 := tai(hp2.previous);
            if assigned(hp2) and
               (hp2.typ = ait_regalloc) and
               (tai_regalloc(hp2).ratype=ra_dealloc) and
               (getregtype(tai_regalloc(hp2).reg) = R_INTREGISTER) and
               (getsupreg(tai_regalloc(hp2).reg) = supreg) then
              begin
                RemoveInstruction(hp2);
                break;
              end;
          until not(assigned(hp2)) or regInInstruction(newreg(R_INTREGISTER,supreg,R_SUBWHOLE),hp2);
        end;

      begin
          case current_procinfo.procdef.returndef.typ of
            arraydef,recorddef,pointerdef,
               stringdef,enumdef,procdef,objectdef,errordef,
               filedef,setdef,procvardef,
               classrefdef,forwarddef:
              DoRemoveLastDeallocForFuncRes(RS_EAX);
            orddef:
              if current_procinfo.procdef.returndef.size <> 0 then
                begin
                  DoRemoveLastDeallocForFuncRes(RS_EAX);
                  { for int64/qword }
                  if current_procinfo.procdef.returndef.size = 8 then
                    DoRemoveLastDeallocForFuncRes(RS_EDX);
                end;
            else
              ;
          end;
      end;


    function TX86AsmOptimizer.OptPass1_V_MOVAP(var p : tai) : boolean;
      var
        hp1,hp2 : tai;
      begin
        result:=false;
        if MatchOpType(taicpu(p),top_reg,top_reg) then
          begin
            { vmova* reg1,reg1
              =>
              <nop> }
            if MatchOperand(taicpu(p).oper[0]^,taicpu(p).oper[1]^) then
              begin
                RemoveCurrentP(p);
                result:=true;
                exit;
              end
            else if GetNextInstruction(p,hp1) then
              begin
                if MatchInstruction(hp1,[taicpu(p).opcode],[S_NO]) and
                  MatchOperand(taicpu(p).oper[1]^,taicpu(hp1).oper[0]^) then
                  begin
                    { vmova* reg1,reg2
                      vmova* reg2,reg3
                      dealloc reg2
                      =>
                      vmova* reg1,reg3 }
                    TransferUsedRegs(TmpUsedRegs);
                    UpdateUsedRegs(TmpUsedRegs, tai(p.next));
                    if MatchOpType(taicpu(hp1),top_reg,top_reg) and
                      not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp1,TmpUsedRegs)) then
                      begin
                        DebugMsg(SPeepholeOptimization + '(V)MOVA*(V)MOVA*2(V)MOVA* 1',p);
                        taicpu(p).loadoper(1,taicpu(hp1).oper[1]^);
                        RemoveInstruction(hp1);
                        result:=true;
                        exit;
                      end
                    { special case:
                      vmova* reg1,<op>
                      vmova* <op>,reg1
                      =>
                      vmova* reg1,<op> }
                    else if MatchOperand(taicpu(p).oper[0]^,taicpu(hp1).oper[1]^) and
                      ((taicpu(p).oper[0]^.typ<>top_ref) or
                       (not(vol_read in taicpu(p).oper[0]^.ref^.volatility))
                      ) then
                      begin
                        DebugMsg(SPeepholeOptimization + '(V)MOVA*(V)MOVA*2(V)MOVA* 2',p);
                        RemoveInstruction(hp1);
                        result:=true;
                        exit;
                      end
                  end
                else if ((MatchInstruction(p,[A_MOVAPS,A_VMOVAPS],[S_NO]) and
                  MatchInstruction(hp1,[A_MOVSS,A_VMOVSS],[S_NO])) or
                  ((MatchInstruction(p,[A_MOVAPD,A_VMOVAPD],[S_NO]) and
                    MatchInstruction(hp1,[A_MOVSD,A_VMOVSD],[S_NO])))
                  ) and
                  MatchOperand(taicpu(p).oper[1]^,taicpu(hp1).oper[0]^) then
                  begin
                    { vmova* reg1,reg2
                      vmovs* reg2,<op>
                      dealloc reg2
                      =>
                      vmovs* reg1,reg3 }
                    TransferUsedRegs(TmpUsedRegs);
                    UpdateUsedRegs(TmpUsedRegs, tai(p.next));
                    if not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp1,TmpUsedRegs)) then
                      begin
                        DebugMsg(SPeepholeOptimization + '(V)MOVA*(V)MOVS*2(V)MOVS* 1',p);
                        taicpu(p).opcode:=taicpu(hp1).opcode;
                        taicpu(p).loadoper(1,taicpu(hp1).oper[1]^);
                        RemoveInstruction(hp1);
                        result:=true;
                        exit;
                      end
                  end;
            end;
          if GetNextInstructionUsingReg(p,hp1,taicpu(p).oper[1]^.reg) then
            begin
              if MatchInstruction(hp1,[A_VFMADDPD,
                                              A_VFMADD132PD,
                                              A_VFMADD132PS,
                                              A_VFMADD132SD,
                                              A_VFMADD132SS,
                                              A_VFMADD213PD,
                                              A_VFMADD213PS,
                                              A_VFMADD213SD,
                                              A_VFMADD213SS,
                                              A_VFMADD231PD,
                                              A_VFMADD231PS,
                                              A_VFMADD231SD,
                                              A_VFMADD231SS,
                                              A_VFMADDSUB132PD,
                                              A_VFMADDSUB132PS,
                                              A_VFMADDSUB213PD,
                                              A_VFMADDSUB213PS,
                                              A_VFMADDSUB231PD,
                                              A_VFMADDSUB231PS,
                                              A_VFMSUB132PD,
                                              A_VFMSUB132PS,
                                              A_VFMSUB132SD,
                                              A_VFMSUB132SS,
                                              A_VFMSUB213PD,
                                              A_VFMSUB213PS,
                                              A_VFMSUB213SD,
                                              A_VFMSUB213SS,
                                              A_VFMSUB231PD,
                                              A_VFMSUB231PS,
                                              A_VFMSUB231SD,
                                              A_VFMSUB231SS,
                                              A_VFMSUBADD132PD,
                                              A_VFMSUBADD132PS,
                                              A_VFMSUBADD213PD,
                                              A_VFMSUBADD213PS,
                                              A_VFMSUBADD231PD,
                                              A_VFMSUBADD231PS,
                                              A_VFNMADD132PD,
                                              A_VFNMADD132PS,
                                              A_VFNMADD132SD,
                                              A_VFNMADD132SS,
                                              A_VFNMADD213PD,
                                              A_VFNMADD213PS,
                                              A_VFNMADD213SD,
                                              A_VFNMADD213SS,
                                              A_VFNMADD231PD,
                                              A_VFNMADD231PS,
                                              A_VFNMADD231SD,
                                              A_VFNMADD231SS,
                                              A_VFNMSUB132PD,
                                              A_VFNMSUB132PS,
                                              A_VFNMSUB132SD,
                                              A_VFNMSUB132SS,
                                              A_VFNMSUB213PD,
                                              A_VFNMSUB213PS,
                                              A_VFNMSUB213SD,
                                              A_VFNMSUB213SS,
                                              A_VFNMSUB231PD,
                                              A_VFNMSUB231PS,
                                              A_VFNMSUB231SD,
                                              A_VFNMSUB231SS],[S_NO]) and
                  { we mix single and double opperations here because we assume that the compiler
                    generates vmovapd only after double operations and vmovaps only after single operations }
                  MatchOperand(taicpu(p).oper[1]^,taicpu(hp1).oper[2]^) and
                  GetNextInstruction(hp1,hp2) and
                  MatchInstruction(hp2,[A_VMOVAPD,A_VMOVAPS,A_MOVAPD,A_MOVAPS],[S_NO]) and
                  MatchOperand(taicpu(p).oper[0]^,taicpu(hp2).oper[1]^) then
                  begin
                    TransferUsedRegs(TmpUsedRegs);
                    UpdateUsedRegs(TmpUsedRegs, tai(p.next));
                    UpdateUsedRegs(TmpUsedRegs, tai(hp1.next));
                    if not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp2,TmpUsedRegs)) then
                      begin
                        taicpu(hp1).loadoper(2,taicpu(p).oper[0]^);
                        RemoveCurrentP(p, hp1); // <-- Is this actually safe? hp1 is not necessarily the next instruction. [Kit]
                        RemoveInstruction(hp2);
                      end;
                  end
                else if (hp1.typ = ait_instruction) and
                  GetNextInstruction(hp1, hp2) and
                  MatchInstruction(hp2,taicpu(p).opcode,[]) and
                  OpsEqual(taicpu(hp2).oper[1]^, taicpu(p).oper[0]^) and
                  MatchOpType(taicpu(hp2),top_reg,top_reg) and
                  MatchOperand(taicpu(hp2).oper[0]^,taicpu(p).oper[1]^) and
                  (((taicpu(p).opcode=A_MOVAPS) and
                    ((taicpu(hp1).opcode=A_ADDSS) or (taicpu(hp1).opcode=A_SUBSS) or
                     (taicpu(hp1).opcode=A_MULSS) or (taicpu(hp1).opcode=A_DIVSS))) or
                   ((taicpu(p).opcode=A_MOVAPD) and
                    ((taicpu(hp1).opcode=A_ADDSD) or (taicpu(hp1).opcode=A_SUBSD) or
                     (taicpu(hp1).opcode=A_MULSD) or (taicpu(hp1).opcode=A_DIVSD)))
                  ) then
                  { change
                             movapX    reg,reg2
                             addsX/subsX/... reg3, reg2
                             movapX    reg2,reg
                    to
                             addsX/subsX/... reg3,reg
                  }
                  begin
                    TransferUsedRegs(TmpUsedRegs);
                    UpdateUsedRegs(TmpUsedRegs, tai(p.next));
                    UpdateUsedRegs(TmpUsedRegs, tai(hp1.next));
                    If not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp2,TmpUsedRegs)) then
                      begin
                        DebugMsg(SPeepholeOptimization + 'MovapXOpMovapX2Op ('+
                              debug_op2str(taicpu(p).opcode)+' '+
                              debug_op2str(taicpu(hp1).opcode)+' '+
                              debug_op2str(taicpu(hp2).opcode)+') done',p);
                        { we cannot eliminate the first move if
                          the operations uses the same register for source and dest }
                        if not(OpsEqual(taicpu(hp1).oper[1]^,taicpu(hp1).oper[0]^)) then
                          RemoveCurrentP(p, nil);
                        p:=hp1;
                        taicpu(hp1).loadoper(1, taicpu(hp2).oper[1]^);
                        RemoveInstruction(hp2);
                        result:=true;
                      end;
                  end;
              end;
          end;
      end;


    function TX86AsmOptimizer.OptPass1VOP(var p : tai) : boolean;
      var
        hp1 : tai;
      begin
        result:=false;
        { replace
            V<Op>X   %mreg1,%mreg2,%mreg3
            VMovX    %mreg3,%mreg4
            dealloc  %mreg3

            by
            V<Op>X   %mreg1,%mreg2,%mreg4
          ?
        }
        if GetNextInstruction(p,hp1) and
          { we mix single and double operations here because we assume that the compiler
            generates vmovapd only after double operations and vmovaps only after single operations }
          MatchInstruction(hp1,A_VMOVAPD,A_VMOVAPS,[S_NO]) and
          MatchOperand(taicpu(p).oper[2]^,taicpu(hp1).oper[0]^) and
          (taicpu(hp1).oper[1]^.typ=top_reg) then
          begin
            TransferUsedRegs(TmpUsedRegs);
            UpdateUsedRegs(TmpUsedRegs, tai(p.next));
            if not(RegUsedAfterInstruction(taicpu(hp1).oper[0]^.reg,hp1,TmpUsedRegs)) then
              begin
                taicpu(p).loadoper(2,taicpu(hp1).oper[1]^);
                DebugMsg(SPeepholeOptimization + 'VOpVmov2VOp done',p);
                RemoveInstruction(hp1);
                result:=true;
              end;
          end;
      end;


    { Replaces all references to AOldReg in a memory reference to ANewReg }
    class function TX86AsmOptimizer.ReplaceRegisterInRef(var ref: TReference; const AOldReg, ANewReg: TRegister): Boolean;
      begin
        Result := False;
        { For safety reasons, only check for exact register matches }

        { Check base register }
        if (ref.base = AOldReg) then
          begin
            ref.base := ANewReg;
            Result := True;
          end;

        { Check index register }
        if (ref.index = AOldReg) then
          begin
            ref.index := ANewReg;
            Result := True;
          end;
      end;


    { Replaces all references to AOldReg in an operand to ANewReg }
    class function TX86AsmOptimizer.ReplaceRegisterInOper(const p: taicpu; const OperIdx: Integer; const AOldReg, ANewReg: TRegister): Boolean;
      var
        OldSupReg, NewSupReg: TSuperRegister;
        OldSubReg, NewSubReg: TSubRegister;
        OldRegType: TRegisterType;
        ThisOper: POper;
      begin
        ThisOper := p.oper[OperIdx]; { Faster to access overall }
        Result := False;

        if (AOldReg = NR_NO) or (ANewReg = NR_NO) then
          InternalError(2020011801);

        OldSupReg := getsupreg(AOldReg);
        OldSubReg := getsubreg(AOldReg);
        OldRegType := getregtype(AOldReg);
        NewSupReg := getsupreg(ANewReg);
        NewSubReg := getsubreg(ANewReg);

        if OldRegType <> getregtype(ANewReg) then
          InternalError(2020011802);

        if OldSubReg <> NewSubReg then
          InternalError(2020011803);

        case ThisOper^.typ of
          top_reg:
            if (
              (ThisOper^.reg = AOldReg) or
                (
                  (OldRegType = R_INTREGISTER) and
                  (getsupreg(ThisOper^.reg) = OldSupReg) and
                  (getregtype(ThisOper^.reg) = R_INTREGISTER) and
                  (
                    (getsubreg(ThisOper^.reg) <= OldSubReg)
{$ifndef x86_64}
                    and (
                    { Under i386 and i8086, ESI, EDI, EBP and ESP
                      don't have an 8-bit representation }
                      (getsubreg(ThisOper^.reg) >= R_SUBW) or
                      not (NewSupReg in [RS_ESI, RS_EDI, RS_EBP, RS_ESP])
                    )
{$endif x86_64}
                  )
                )
              ) then
              begin
                ThisOper^.reg := newreg(getregtype(ANewReg), NewSupReg, getsubreg(p.oper[OperIdx]^.reg));
                Result := True;
              end;
          top_ref:
            if ReplaceRegisterInRef(ThisOper^.ref^, AOldReg, ANewReg) then
              Result := True;

          else
            ;
        end;
      end;


    { Replaces all references to AOldReg in an instruction to ANewReg }
    function TX86AsmOptimizer.ReplaceRegisterInInstruction(const p: taicpu; const AOldReg, ANewReg: TRegister): Boolean;
      const
        ReadFlag: array[0..3] of TInsChange = (Ch_Rop1, Ch_Rop2, Ch_Rop3, Ch_Rop4);
      var
        OperIdx: Integer;
      begin
        Result := False;

        for OperIdx := 0 to p.ops - 1 do
          if (ReadFlag[OperIdx] in InsProp[p.Opcode].Ch) and
          { The shift and rotate instructions can only use CL }
          not (
            (OperIdx = 0) and
            { This second condition just helps to avoid unnecessarily
              calling MatchInstruction for 10 different opcodes }
            (p.oper[0]^.reg = NR_CL) and
            MatchInstruction(p, [A_RCL, A_RCR, A_ROL, A_ROR, A_SAL, A_SAR, A_SHL, A_SHLD, A_SHR, A_SHRD], [])
          ) then
            Result := ReplaceRegisterInOper(p, OperIdx, AOldReg, ANewReg) or Result;
      end;


    class function TX86AsmOptimizer.IsRefSafe(const ref: PReference): Boolean; inline;
      begin
        Result :=
          (ref^.index = NR_NO) and
          (
{$ifdef x86_64}
            (
              (ref^.base = NR_RIP) and
              (ref^.refaddr in [addr_pic, addr_pic_no_got])
            ) or
{$endif x86_64}
            (ref^.base = NR_STACK_POINTER_REG) or
            (ref^.base = current_procinfo.framepointer)
          );
      end;


    function TX86AsmOptimizer.ConvertLEA(const p: taicpu): Boolean;
      var
        l: asizeint;
      begin
        Result := False;

        { Should have been checked previously }
        if p.opcode <> A_LEA then
          InternalError(2020072501);

        { do not mess with the stack point as adjusting it by lea is recommend, except if we optimize for size }
         if (p.oper[1]^.reg=NR_STACK_POINTER_REG) and
           not(cs_opt_size in current_settings.optimizerswitches) then
           exit;

         with p.oper[0]^.ref^ do
          begin
            if (base <> p.oper[1]^.reg) or
               (index <> NR_NO) or
               assigned(symbol) then
              exit;

            l:=offset;
            if (l=1) and UseIncDec then
              begin
                p.opcode:=A_INC;
                p.loadreg(0,p.oper[1]^.reg);
                p.ops:=1;
                DebugMsg(SPeepholeOptimization + 'Lea2Inc done',p);
              end
            else if (l=-1) and UseIncDec then
              begin
                p.opcode:=A_DEC;
                p.loadreg(0,p.oper[1]^.reg);
                p.ops:=1;
                DebugMsg(SPeepholeOptimization + 'Lea2Dec done',p);
              end
            else
              begin
                if (l<0) and (l<>-2147483648) then
                  begin
                    p.opcode:=A_SUB;
                    p.loadConst(0,-l);
                    DebugMsg(SPeepholeOptimization + 'Lea2Sub done',p);
                  end
                else
                  begin
                    p.opcode:=A_ADD;
                    p.loadConst(0,l);
                    DebugMsg(SPeepholeOptimization + 'Lea2Add done',p);
                  end;
              end;
          end;

        Result := True;
      end;


    function TX86AsmOptimizer.DeepMOVOpt(const p_mov: taicpu; const hp: taicpu): Boolean;
      var
        CurrentReg, ReplaceReg: TRegister;
      begin
        Result := False;

        ReplaceReg := taicpu(p_mov).oper[0]^.reg;
        CurrentReg := taicpu(p_mov).oper[1]^.reg;

        case hp.opcode of
          A_FSTSW, A_FNSTSW,
          A_IN,   A_INS,  A_OUT,  A_OUTS,
          A_CMPS, A_LODS, A_MOVS, A_SCAS, A_STOS:
            { These routines have explicit operands, but they are restricted in
              what they can be (e.g. IN and OUT can only read from AL, AX or
              EAX. }
            Exit;

          A_IMUL:
            begin
                { The 1-operand version writes to implicit registers
                  The 2-operand version reads from the first operator, and reads
                  from and writes to the second (equivalent to Ch_ROp1, ChRWOp2).
                  the 3-operand version reads from a register that it doesn't write to
                }
              case hp.ops of
                1:
                  if (
                    (
                      (hp.opsize = S_B) and (getsupreg(CurrentReg) <> RS_EAX)
                    ) or
                      not (getsupreg(CurrentReg) in [RS_EAX, RS_EDX])
                  ) and ReplaceRegisterInOper(hp, 0, CurrentReg, ReplaceReg) then
                    begin
                      Result := True;
                      DebugMsg(SPeepholeOptimization + debug_regname(CurrentReg) + ' = ' + debug_regname(ReplaceReg) + '; changed to minimise pipeline stall (MovIMul2MovIMul 1)', hp);
                      AllocRegBetween(ReplaceReg, p_mov, hp, UsedRegs);
                    end;
                2:
                  { Only modify the first parameter }
                  if ReplaceRegisterInOper(hp, 0, CurrentReg, ReplaceReg) then
                    begin
                      Result := True;
                      DebugMsg(SPeepholeOptimization + debug_regname(CurrentReg) + ' = ' + debug_regname(ReplaceReg) + '; changed to minimise pipeline stall (MovIMul2MovIMul 2)', hp);
                      AllocRegBetween(ReplaceReg, p_mov, hp, UsedRegs);
                    end;
                3:
                  { Only modify the second parameter }
                  if ReplaceRegisterInOper(hp, 1, CurrentReg, ReplaceReg) then
                    begin
                      Result := True;
                      DebugMsg(SPeepholeOptimization + debug_regname(CurrentReg) + ' = ' + debug_regname(ReplaceReg) + '; changed to minimise pipeline stall (MovIMul2MovIMul 3)', hp);
                      AllocRegBetween(ReplaceReg, p_mov, hp, UsedRegs);
                    end;
                else
                  InternalError(2020012901);
              end;
            end;

          else
            if (hp.ops > 0) and
              ReplaceRegisterInInstruction(hp, CurrentReg, ReplaceReg) then
              begin
                Result := True;
                DebugMsg(SPeepholeOptimization + debug_regname(CurrentReg) + ' = ' + debug_regname(ReplaceReg) + '; changed to minimise pipeline stall (MovXXX2MovXXX)', hp);

                AllocRegBetween(ReplaceReg, p_mov, hp, UsedRegs);
              end;
          end;
      end;


    function TX86AsmOptimizer.OptPass1MOV(var p : tai) : boolean;
    var
      hp1, hp2, hp3: tai;

      procedure convert_mov_value(signed_movop: tasmop; max_value: tcgint); inline;
        begin
          if taicpu(hp1).opcode = signed_movop then
            begin
              if taicpu(p).oper[0]^.val > max_value shr 1 then
                taicpu(p).oper[0]^.val:=taicpu(p).oper[0]^.val - max_value - 1 { Convert to signed }
            end
          else
            taicpu(p).oper[0]^.val:=taicpu(p).oper[0]^.val and max_value; { Trim to unsigned }
        end;

      var
        GetNextInstruction_p, TempRegUsed, CrossJump: Boolean;
        PreMessage, RegName1, RegName2, InputVal, MaskNum: string;
        NewSize: topsize;
        CurrentReg: TRegister;
      begin
        Result:=false;

        GetNextInstruction_p:=GetNextInstruction(p, hp1);

        {  remove mov reg1,reg1? }
        if MatchOperand(taicpu(p).oper[0]^,taicpu(p).oper[1]^)
        then
          begin
            DebugMsg(SPeepholeOptimization + 'Mov2Nop 1 done',p);
            { take care of the register (de)allocs following p }
            RemoveCurrentP(p, hp1);
            Result:=true;
            exit;
          end;

        { All the next optimisations require a next instruction }
        if not GetNextInstruction_p or (hp1.typ <> ait_instruction) then
          Exit;

        { Look for:
            mov %reg1,%reg2
            ??? %reg2,r/m
          Change to:
            mov %reg1,%reg2
            ??? %reg1,r/m
        }
        if MatchOpType(taicpu(p), top_reg, top_reg) then
          begin
            CurrentReg := taicpu(p).oper[1]^.reg;

            if RegReadByInstruction(CurrentReg, hp1) and
              DeepMOVOpt(taicpu(p), taicpu(hp1)) then
              begin
                TransferUsedRegs(TmpUsedRegs);
                UpdateUsedRegs(TmpUsedRegs, tai(p.Next));

                if not RegUsedAfterInstruction(CurrentReg, hp1, TmpUsedRegs) and
                  { Just in case something didn't get modified (e.g. an
                    implicit register) }
                  not RegReadByInstruction(CurrentReg, hp1) then
                  begin
                    { We can remove the original MOV }
                    DebugMsg(SPeepholeOptimization + 'Mov2Nop 3 done',p);
                    RemoveCurrentp(p, hp1);

                    { UsedRegs got updated by RemoveCurrentp }
                    Result := True;
                    Exit;
                  end;

                { If we know a MOV instruction has become a null operation, we might as well
                  get rid of it now to save time. }
                if (taicpu(hp1).opcode = A_MOV) and
                  (taicpu(hp1).oper[1]^.typ = top_reg) and
                  SuperRegistersEqual(taicpu(hp1).oper[1]^.reg, taicpu(p).oper[0]^.reg) and
                  { Just being a register is enough to confirm it's a null operation }
                  (taicpu(hp1).oper[0]^.typ = top_reg) then
                  begin

                    Result := True;

                    { Speed-up to reduce a pipeline stall... if we had something like...

                        movl %eax,%edx
                        movw %dx,%ax

                      ... the second instruction would change to movw %ax,%ax, but
                      given that it is now %ax that's active rather than %eax,
                      penalties might occur due to a partial register write, so instead,
                      change it to a MOVZX instruction when optimising for speed.
                    }
                    if not (cs_opt_size in current_settings.optimizerswitches) and
                      IsMOVZXAcceptable and
                      (taicpu(hp1).opsize < taicpu(p).opsize)
{$ifdef x86_64}
                      { operations already implicitly set the upper 64 bits to zero }
                      and not ((taicpu(hp1).opsize = S_L) and (taicpu(p).opsize = S_Q))
{$endif x86_64}
                      then
                      begin
                        CurrentReg := taicpu(hp1).oper[1]^.reg;

                        DebugMsg(SPeepholeOptimization + 'Zero-extension to minimise pipeline stall (Mov2Movz)',hp1);
                        case taicpu(p).opsize of
                          S_W:
                            if taicpu(hp1).opsize = S_B then
                              taicpu(hp1).opsize := S_BL
                            else
                              InternalError(2020012911);
                          S_L{$ifdef x86_64}, S_Q{$endif x86_64}:
                            case taicpu(hp1).opsize of
                              S_B:
                                taicpu(hp1).opsize := S_BL;
                              S_W:
                                taicpu(hp1).opsize := S_WL;
                              else
                                InternalError(2020012912);
                            end;
                          else
                            InternalError(2020012910);
                        end;

                        taicpu(hp1).opcode := A_MOVZX;
                        taicpu(hp1).oper[1]^.reg := newreg(getregtype(CurrentReg), getsupreg(CurrentReg), R_SUBD)
                      end
                    else
                      begin
                        GetNextInstruction_p := GetNextInstruction(hp1, hp2);
                        DebugMsg(SPeepholeOptimization + 'Mov2Nop 4 done',hp1);
                        RemoveInstruction(hp1);

                        { The instruction after what was hp1 is now the immediate next instruction,
                          so we can continue to make optimisations if it's present }
                        if not GetNextInstruction_p or (hp2.typ <> ait_instruction) then
                          Exit;

                        hp1 := hp2;
                      end;
                  end;

              end;
          end;

        { Depending on the DeepMOVOpt above, it may turn out that hp1 completely
          overwrites the original destination register.  e.g.

          movl   ###,%reg2d
          movslq ###,%reg2q (### doesn't have to be the same as the first one)

          In this case, we can remove the MOV (Go to "Mov2Nop 5" below)
        }
        if (taicpu(p).oper[1]^.typ = top_reg) and
          MatchInstruction(hp1, [A_LEA, A_MOV, A_MOVSX, A_MOVZX{$ifdef x86_64}, A_MOVSXD{$endif x86_64}], []) and
          (taicpu(hp1).oper[1]^.typ = top_reg) and
          Reg1WriteOverwritesReg2Entirely(taicpu(hp1).oper[1]^.reg, taicpu(p).oper[1]^.reg) then
            begin
              if RegInOp(taicpu(p).oper[1]^.reg, taicpu(hp1).oper[0]^) then
                begin
                  if (taicpu(hp1).oper[0]^.typ = top_reg) then
                    case taicpu(p).oper[0]^.typ of
                      top_const:
                        { We have something like:

                          movb   $x,   %regb
                          movzbl %regb,%regd

                          Change to:

                          movl   $x,   %regd
                        }
                        begin
                          case taicpu(hp1).opsize of
                            S_BW:
                              begin
                                convert_mov_value(A_MOVSX, $FF);
                                setsubreg(taicpu(p).oper[1]^.reg, R_SUBW);
                                taicpu(p).opsize := S_W;
                              end;
                            S_BL:
                              begin
                                convert_mov_value(A_MOVSX, $FF);
                                setsubreg(taicpu(p).oper[1]^.reg, R_SUBD);
                                taicpu(p).opsize := S_L;
                              end;
                            S_WL:
                              begin
                                convert_mov_value(A_MOVSX, $FFFF);
                                setsubreg(taicpu(p).oper[1]^.reg, R_SUBD);
                                taicpu(p).opsize := S_L;
                              end;
{$ifdef x86_64}
                            S_BQ:
                              begin
                                convert_mov_value(A_MOVSX, $FF);
                                setsubreg(taicpu(p).oper[1]^.reg, R_SUBQ);
                                taicpu(p).opsize := S_Q;
                              end;
                            S_WQ:
                              begin
                                convert_mov_value(A_MOVSX, $FFFF);
                                setsubreg(taicpu(p).oper[1]^.reg, R_SUBQ);
                                taicpu(p).opsize := S_Q;
                              end;
                            S_LQ:
                              begin
                                convert_mov_value(A_MOVSXD, $FFFFFFFF);  { Note it's MOVSXD, not MOVSX }
                                setsubreg(taicpu(p).oper[1]^.reg, R_SUBQ);
                                taicpu(p).opsize := S_Q;
                              end;
{$endif x86_64}
                            else
                              { If hp1 was a MOV instruction, it should have been
                                optimised already }
                              InternalError(2020021001);
                          end;
                          DebugMsg(SPeepholeOptimization + 'MovMovXX2MovXX 2 done',p);
                          RemoveInstruction(hp1);
                          Result := True;
                          Exit;
                        end;
                      top_ref:
                        { We have something like:

                          movb   mem,  %regb
                          movzbl %regb,%regd

                          Change to:

                          movzbl mem,  %regd
                        }
                        if (taicpu(p).oper[0]^.ref^.refaddr<>addr_full) and (IsMOVZXAcceptable or (taicpu(hp1).opcode<>A_MOVZX)) then
                          begin
                            DebugMsg(SPeepholeOptimization + 'MovMovXX2MovXX 1 done',p);
                            taicpu(hp1).loadref(0,taicpu(p).oper[0]^.ref^);
                            RemoveCurrentP(p, hp1);
                            Result:=True;
                            Exit;
                          end;
                      else
                        if (taicpu(hp1).opcode <> A_MOV) and (taicpu(hp1).opcode <> A_LEA) then
                          { Just to make a saving, since there are no more optimisations with MOVZX and MOVSX/D }
                          Exit;
                  end;
                end
             { The RegInOp check makes sure that movl r/m,%reg1l; movzbl (%reg1l),%reg1l"
               and "movl r/m,%reg1; leal $1(%reg1,%reg2),%reg1" etc. are not incorrectly
               optimised }
              else
                begin
                  DebugMsg(SPeepholeOptimization + 'Mov2Nop 5 done',p);
                  RemoveCurrentP(p, hp1);
                  Result := True;
                  Exit;
                end;
            end;

        if (taicpu(hp1).opcode = A_AND) and
          (taicpu(p).oper[1]^.typ = top_reg) and
          MatchOpType(taicpu(hp1),top_const,top_reg) then
          begin
            if MatchOperand(taicpu(p).oper[1]^,taicpu(hp1).oper[1]^) then
              begin
                case taicpu(p).opsize of
                  S_L:
                    if (taicpu(hp1).oper[0]^.val = $ffffffff) then
                      begin
                        { Optimize out:
                            mov x, %reg
                            and ffffffffh, %reg
                        }
                        DebugMsg(SPeepholeOptimization + 'MovAnd2Mov 1 done',p);
                        RemoveInstruction(hp1);
                        Result:=true;
                        exit;
                      end;
                  S_Q: { TODO: Confirm if this is even possible }
                    if (taicpu(hp1).oper[0]^.val = $ffffffffffffffff) then
                      begin
                        { Optimize out:
                            mov x, %reg
                            and ffffffffffffffffh, %reg
                        }
                        DebugMsg(SPeepholeOptimization + 'MovAnd2Mov 2 done',p);
                        RemoveInstruction(hp1);
                        Result:=true;
                        exit;
                      end;
                  else
                    ;
                end;
                if ((taicpu(p).oper[0]^.typ=top_reg) or
                  ((taicpu(p).oper[0]^.typ=top_ref) and (taicpu(p).oper[0]^.ref^.refaddr<>addr_full))) and
                  GetNextInstruction(hp1,hp2) and
                  MatchInstruction(hp2,A_TEST,[taicpu(p).opsize]) and
                  MatchOperand(taicpu(hp1).oper[1]^,taicpu(hp2).oper[1]^) and
                  MatchOperand(taicpu(hp2).oper[0]^,taicpu(hp2).oper[1]^) and
                  GetNextInstruction(hp2,hp3) and
                  MatchInstruction(hp3,A_Jcc,A_Setcc,[S_NO]) and
                  (taicpu(hp3).condition in [C_E,C_NE]) then
                  begin
                    TransferUsedRegs(TmpUsedRegs);
                    UpdateUsedRegs(TmpUsedRegs, tai(p.Next));
                    UpdateUsedRegs(TmpUsedRegs, tai(hp1.Next));
                    if not(RegUsedAfterInstruction(taicpu(hp2).oper[1]^.reg, hp2, TmpUsedRegs)) then
                      begin
                        DebugMsg(SPeepholeOptimization + 'MovAndTest2Test done',p);
                        taicpu(hp1).loadoper(1,taicpu(p).oper[0]^);
                        taicpu(hp1).opcode:=A_TEST;
                        RemoveInstruction(hp2);
                        RemoveCurrentP(p, hp1);
                        Result:=true;
                        exit;
                      end;
                  end;
              end
            else if IsMOVZXAcceptable and
              (taicpu(p).oper[1]^.typ = top_reg) and (taicpu(hp1).oper[1]^.typ = top_reg) and
              (taicpu(p).oper[0]^.typ <> top_const) and { MOVZX only supports registers and memory, not immediates (use MOV for that!) }
              (getsupreg(taicpu(p).oper[1]^.reg) = getsupreg(taicpu(hp1).oper[1]^.reg))
              then
              begin
                InputVal := debug_operstr(taicpu(p).oper[0]^);
                MaskNum := debug_tostr(taicpu(hp1).oper[0]^.val);

                case taicpu(p).opsize of
                  S_B:
                    if (taicpu(hp1).oper[0]^.val = $ff) then
                      begin
                        { Convert:
                            movb x, %regl        movb x, %regl
                            andw ffh, %regw      andl ffh, %regd
                          To:
                            movzbw x, %regd      movzbl x, %regd

                          (Identical registers, just different sizes)
                        }
                        RegName1 := debug_regname(taicpu(p).oper[1]^.reg); { 8-bit register name }
                        RegName2 := debug_regname(taicpu(hp1).oper[1]^.reg); { 16/32-bit register name }

                        case taicpu(hp1).opsize of
                          S_W: NewSize := S_BW;
                          S_L: NewSize := S_BL;
{$ifdef x86_64}
                          S_Q: NewSize := S_BQ;
{$endif x86_64}
                          else
                            InternalError(2018011510);
                        end;
                      end
                    else
                      NewSize := S_NO;
                  S_W:
                    if (taicpu(hp1).oper[0]^.val = $ffff) then
                      begin
                        { Convert:
                            movw x, %regw
                            andl ffffh, %regd
                          To:
                            movzwl x, %regd

                          (Identical registers, just different sizes)
                        }
                        RegName1 := debug_regname(taicpu(p).oper[1]^.reg); { 16-bit register name }
                        RegName2 := debug_regname(taicpu(hp1).oper[1]^.reg); { 32-bit register name }

                        case taicpu(hp1).opsize of
                          S_L: NewSize := S_WL;
{$ifdef x86_64}
                          S_Q: NewSize := S_WQ;
{$endif x86_64}
                          else
                            InternalError(2018011511);
                        end;
                      end
                    else
                      NewSize := S_NO;
                  else
                    NewSize := S_NO;
                end;

                if NewSize <> S_NO then
                  begin
                    PreMessage := 'mov' + debug_opsize2str(taicpu(p).opsize) + ' ' + InputVal + ',' + RegName1;

                    { The actual optimization }
                    taicpu(p).opcode := A_MOVZX;
                    taicpu(p).changeopsize(NewSize);
                    taicpu(p).oper[1]^ := taicpu(hp1).oper[1]^;

                    { Safeguard if "and" is followed by a conditional command }
                    TransferUsedRegs(TmpUsedRegs);
                    UpdateUsedRegs(TmpUsedRegs,tai(p.next));

                    if (RegUsedAfterInstruction(NR_DEFAULTFLAGS, hp1, TmpUsedRegs)) then
                      begin
                        { At this point, the "and" command is effectively equivalent to
                          "test %reg,%reg". This will be handled separately by the
                          Peephole Optimizer. [Kit] }

                        DebugMsg(SPeepholeOptimization + PreMessage +
                          ' -> movz' + debug_opsize2str(NewSize) + ' ' + InputVal + ',' + RegName2, p);
                      end
                    else
                      begin
                        DebugMsg(SPeepholeOptimization + PreMessage + '; and' + debug_opsize2str(taicpu(hp1).opsize) + ' $' + MaskNum + ',' + RegName2 +
                          ' -> movz' + debug_opsize2str(NewSize) + ' ' + InputVal + ',' + RegName2, p);

                        RemoveInstruction(hp1);
                      end;

                    Result := True;
                    Exit;

                  end;
              end;
          end;
        { Next instruction is also a MOV ? }
        if MatchInstruction(hp1,A_MOV,[taicpu(p).opsize]) then
          begin
            if (taicpu(p).oper[1]^.typ = top_reg) and
              MatchOperand(taicpu(p).oper[1]^,taicpu(hp1).oper[0]^) then
              begin
                CurrentReg := taicpu(p).oper[1]^.reg;
                TransferUsedRegs(TmpUsedRegs);
                UpdateUsedRegs(TmpUsedRegs, tai(p.Next));
                { we have
                    mov x, %treg
                    mov %treg, y
                }
                if not(RegInOp(CurrentReg, taicpu(hp1).oper[1]^)) then
                  if not(RegUsedAfterInstruction(CurrentReg, hp1, TmpUsedRegs)) then
                    { we've got

                      mov x, %treg
                      mov %treg, y

                      with %treg is not used after }
                    case taicpu(p).oper[0]^.typ Of
                      { top_reg is covered by DeepMOVOpt }
                      top_const:
                        begin
                          { change
                              mov const, %treg
                              mov %treg, y

                              to

                              mov const, y
                          }
                          if (taicpu(hp1).oper[1]^.typ=top_reg) or
                            ((taicpu(p).oper[0]^.val>=low(longint)) and (taicpu(p).oper[0]^.val<=high(longint))) then
                            begin
                              if taicpu(hp1).oper[1]^.typ=top_reg then
                                AllocRegBetween(taicpu(hp1).oper[1]^.reg,p,hp1,usedregs);
                              taicpu(p).loadOper(1,taicpu(hp1).oper[1]^);
                              DebugMsg(SPeepholeOptimization + 'MovMov2Mov 5 done',p);
                              RemoveInstruction(hp1);
                              Result:=true;
                              Exit;
                            end;
                        end;
                      top_ref:
                        if (taicpu(hp1).oper[1]^.typ = top_reg) then
                          begin
                            { change
                                 mov mem, %treg
                                 mov %treg, %reg

                                 to

                                 mov mem, %reg"
                            }
                            AllocRegBetween(taicpu(hp1).oper[1]^.reg,p,hp1,usedregs);
                            taicpu(p).loadreg(1, taicpu(hp1).oper[1]^.reg);
                            DebugMsg(SPeepholeOptimization + 'MovMov2Mov 3 done',p);
                            RemoveInstruction(hp1);
                            Result:=true;
                            Exit;
                          end;
                      else
                        ;
                    end
                  else
                    { %treg is used afterwards, but all eventualities
                      other than the first MOV instruction being a constant
                      are covered by DeepMOVOpt, so only check for that }
                    if (taicpu(p).oper[0]^.typ = top_const) and
                      (
                        { For MOV operations, a size saving is only made if the register/const is byte-sized }
                        not (cs_opt_size in current_settings.optimizerswitches) or
                        (taicpu(hp1).opsize = S_B)
                      ) and
                      (
                        (taicpu(hp1).oper[1]^.typ = top_reg) or
                        ((taicpu(p).oper[0]^.val >= low(longint)) and (taicpu(p).oper[0]^.val <= high(longint)))
                      ) then
                      begin
                        DebugMsg(SPeepholeOptimization + debug_operstr(taicpu(hp1).oper[0]^) + ' = $' + debug_tostr(taicpu(p).oper[0]^.val) + '; changed to minimise pipeline stall (MovMov2Mov 6b)',hp1);
                        taicpu(hp1).loadconst(0, taicpu(p).oper[0]^.val);
                      end;
              end;
            if (taicpu(hp1).oper[0]^.typ = taicpu(p).oper[1]^.typ) and
               (taicpu(hp1).oper[1]^.typ = taicpu(p).oper[0]^.typ) then
                {  mov reg1, mem1     or     mov mem1, reg1
                   mov mem2, reg2            mov reg2, mem2}
              begin
                if OpsEqual(taicpu(hp1).oper[1]^,taicpu(p).oper[0]^) then
                  { mov reg1, mem1     or     mov mem1, reg1
                    mov mem2, reg1            mov reg2, mem1}
                  begin
                    if OpsEqual(taicpu(hp1).oper[0]^,taicpu(p).oper[1]^) then
                      { Removes the second statement from
                        mov reg1, mem1/reg2
                        mov mem1/reg2, reg1 }
                      begin
                        if taicpu(p).oper[0]^.typ=top_reg then
                          AllocRegBetween(taicpu(p).oper[0]^.reg,p,hp1,usedregs);
                        DebugMsg(SPeepholeOptimization + 'MovMov2Mov 1',p);
                        RemoveInstruction(hp1);
                        Result:=true;
                        exit;
                      end
                    else
                      begin
                        TransferUsedRegs(TmpUsedRegs);
                        UpdateUsedRegs(TmpUsedRegs, tai(hp1.next));
                        if (taicpu(p).oper[1]^.typ = top_ref) and
                          { mov reg1, mem1
                            mov mem2, reg1 }
                           (taicpu(hp1).oper[0]^.ref^.refaddr = addr_no) and
                           GetNextInstruction(hp1, hp2) and
                           MatchInstruction(hp2,A_CMP,[taicpu(p).opsize]) and
                           OpsEqual(taicpu(p).oper[1]^,taicpu(hp2).oper[0]^) and
                           OpsEqual(taicpu(p).oper[0]^,taicpu(hp2).oper[1]^) and
                           not(RegUsedAfterInstruction(taicpu(p).oper[0]^.reg, hp2, TmpUsedRegs)) then
                           { change                   to
                             mov reg1, mem1           mov reg1, mem1
                             mov mem2, reg1           cmp reg1, mem2
                             cmp mem1, reg1
                           }
                          begin
                            RemoveInstruction(hp2);
                            taicpu(hp1).opcode := A_CMP;
                            taicpu(hp1).loadref(1,taicpu(hp1).oper[0]^.ref^);
                            taicpu(hp1).loadreg(0,taicpu(p).oper[0]^.reg);
                            AllocRegBetween(taicpu(p).oper[0]^.reg,p,hp1,UsedRegs);
                            DebugMsg(SPeepholeOptimization + 'MovMovCmp2MovCmp done',hp1);
                          end;
                      end;
                  end
                else if (taicpu(p).oper[1]^.typ=top_ref) and
                  OpsEqual(taicpu(hp1).oper[0]^,taicpu(p).oper[1]^) then
                  begin
                    AllocRegBetween(taicpu(p).oper[0]^.reg,p,hp1,UsedRegs);
                    taicpu(hp1).loadreg(0,taicpu(p).oper[0]^.reg);
                    DebugMsg(SPeepholeOptimization + 'MovMov2MovMov1 done',p);
                  end
                else
                  begin
                    TransferUsedRegs(TmpUsedRegs);
                    if GetNextInstruction(hp1, hp2) and
                      MatchOpType(taicpu(p),top_ref,top_reg) and
                      MatchOperand(taicpu(p).oper[1]^,taicpu(hp1).oper[0]^) and
                      (taicpu(hp1).oper[1]^.typ = top_ref) and
                      MatchInstruction(hp2,A_MOV,[taicpu(p).opsize]) and
                      MatchOpType(taicpu(hp2),top_ref,top_reg) and
                      RefsEqual(taicpu(hp2).oper[0]^.ref^, taicpu(hp1).oper[1]^.ref^)  then
                      if not RegInRef(taicpu(hp2).oper[1]^.reg,taicpu(hp2).oper[0]^.ref^) and
                         not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp1,tmpUsedRegs)) then
                        {   mov mem1, %reg1
                            mov %reg1, mem2
                            mov mem2, reg2
                         to:
                            mov mem1, reg2
                            mov reg2, mem2}
                        begin
                          AllocRegBetween(taicpu(hp2).oper[1]^.reg,p,hp2,usedregs);
                          DebugMsg(SPeepholeOptimization + 'MovMovMov2MovMov 1 done',p);
                          taicpu(p).loadoper(1,taicpu(hp2).oper[1]^);
                          taicpu(hp1).loadoper(0,taicpu(hp2).oper[1]^);
                          RemoveInstruction(hp2);
                        end
{$ifdef i386}
                      { this is enabled for i386 only, as the rules to create the reg sets below
                        are too complicated for x86-64, so this makes this code too error prone
                        on x86-64
                      }
                      else if (taicpu(p).oper[1]^.reg <> taicpu(hp2).oper[1]^.reg) and
                        not(RegInRef(taicpu(p).oper[1]^.reg,taicpu(p).oper[0]^.ref^)) and
                        not(RegInRef(taicpu(hp2).oper[1]^.reg,taicpu(hp2).oper[0]^.ref^)) then
                        {   mov mem1, reg1         mov mem1, reg1
                            mov reg1, mem2         mov reg1, mem2
                            mov mem2, reg2         mov mem2, reg1
                         to:                    to:
                            mov mem1, reg1         mov mem1, reg1
                            mov mem1, reg2         mov reg1, mem2
                            mov reg1, mem2

                         or (if mem1 depends on reg1
                      and/or if mem2 depends on reg2)
                         to:
                             mov mem1, reg1
                             mov reg1, mem2
                             mov reg1, reg2
                        }
                        begin
                          taicpu(hp1).loadRef(0,taicpu(p).oper[0]^.ref^);
                          taicpu(hp1).loadReg(1,taicpu(hp2).oper[1]^.reg);
                          taicpu(hp2).loadRef(1,taicpu(hp2).oper[0]^.ref^);
                          taicpu(hp2).loadReg(0,taicpu(p).oper[1]^.reg);
                          AllocRegBetween(taicpu(p).oper[1]^.reg,p,hp2,usedregs);
                          if (taicpu(p).oper[0]^.ref^.base <> NR_NO) and
                             (getsupreg(taicpu(p).oper[0]^.ref^.base) in [RS_EAX,RS_EBX,RS_ECX,RS_EDX,RS_ESI,RS_EDI]) then
                            AllocRegBetween(taicpu(p).oper[0]^.ref^.base,p,hp2,usedregs);
                          if (taicpu(p).oper[0]^.ref^.index <> NR_NO) and
                             (getsupreg(taicpu(p).oper[0]^.ref^.index) in [RS_EAX,RS_EBX,RS_ECX,RS_EDX,RS_ESI,RS_EDI]) then
                            AllocRegBetween(taicpu(p).oper[0]^.ref^.index,p,hp2,usedregs);
                        end
                      else if (taicpu(hp1).Oper[0]^.reg <> taicpu(hp2).Oper[1]^.reg) then
                        begin
                          taicpu(hp2).loadReg(0,taicpu(hp1).Oper[0]^.reg);
                          AllocRegBetween(taicpu(p).oper[1]^.reg,p,hp2,usedregs);
                        end
                      else
                        begin
                          RemoveInstruction(hp2);
                        end
{$endif i386}
                        ;
                  end;
              end
            { movl [mem1],reg1
              movl [mem1],reg2

              to

              movl [mem1],reg1
              movl reg1,reg2
             }
             else if MatchOpType(taicpu(p),top_ref,top_reg) and
               MatchOpType(taicpu(hp1),top_ref,top_reg) and
               (taicpu(p).opsize = taicpu(hp1).opsize) and
               RefsEqual(taicpu(p).oper[0]^.ref^,taicpu(hp1).oper[0]^.ref^) and
               (taicpu(p).oper[0]^.ref^.volatility=[]) and
               (taicpu(hp1).oper[0]^.ref^.volatility=[]) and
               not(SuperRegistersEqual(taicpu(p).oper[1]^.reg,taicpu(hp1).oper[0]^.ref^.base)) and
               not(SuperRegistersEqual(taicpu(p).oper[1]^.reg,taicpu(hp1).oper[0]^.ref^.index)) then
               begin
                 DebugMsg(SPeepholeOptimization + 'MovMov2MovMov 2',p);
                 taicpu(hp1).loadReg(0,taicpu(p).oper[1]^.reg);
               end;

            {   movl const1,[mem1]
                movl [mem1],reg1

                to

                movl const1,reg1
                movl reg1,[mem1]
            }
            if MatchOpType(Taicpu(p),top_const,top_ref) and
                 MatchOpType(Taicpu(hp1),top_ref,top_reg) and
                 (taicpu(p).opsize = taicpu(hp1).opsize) and
                 RefsEqual(taicpu(hp1).oper[0]^.ref^,taicpu(p).oper[1]^.ref^) and
                 not(RegInRef(taicpu(hp1).oper[1]^.reg,taicpu(hp1).oper[0]^.ref^)) then
              begin
                AllocRegBetween(taicpu(hp1).oper[1]^.reg,p,hp1,usedregs);
                taicpu(hp1).loadReg(0,taicpu(hp1).oper[1]^.reg);
                taicpu(hp1).loadRef(1,taicpu(p).oper[1]^.ref^);
                taicpu(p).loadReg(1,taicpu(hp1).oper[0]^.reg);
                taicpu(hp1).fileinfo := taicpu(p).fileinfo;
                DebugMsg(SPeepholeOptimization + 'MovMov2MovMov 1',p);
                Result:=true;
                exit;
              end;

              { mov x,reg1; mov y,reg1 -> mov y,reg1 is handled by the Mov2Nop 5 optimisation }
          end;

        { search further than the next instruction for a mov }
        if
          { check as much as possible before the expensive GetNextInstructionUsingRegCond call }
          (taicpu(p).oper[1]^.typ = top_reg) and
          (taicpu(p).oper[0]^.typ in [top_reg,top_const]) and
          not RegModifiedByInstruction(taicpu(p).oper[1]^.reg, hp1) then
          begin
            { we work with hp2 here, so hp1 can be still used later on when
              checking for GetNextInstruction_p }
            hp3 := hp1;

            { Initialise CrossJump (if it becomes True at any point, it will remain True) }
            CrossJump := False;

            while GetNextInstructionUsingRegCond(hp3,hp2,taicpu(p).oper[1]^.reg,CrossJump) and
              { GetNextInstructionUsingRegCond only searches one instruction ahead unless -O3 is specified }
              (hp2.typ=ait_instruction) do
              begin
                case taicpu(hp2).opcode of
                  A_MOV:
                    if MatchOperand(taicpu(hp2).oper[0]^,taicpu(p).oper[1]^.reg) and
                      ((taicpu(p).oper[0]^.typ=top_const) or
                       ((taicpu(p).oper[0]^.typ=top_reg) and
                        not(RegModifiedBetween(taicpu(p).oper[0]^.reg, p, hp2))
                       )
                      ) then
                      begin
                        { we have
                            mov x, %treg
                            mov %treg, y
                        }

                        TransferUsedRegs(TmpUsedRegs);
                        TmpUsedRegs[R_INTREGISTER].Update(tai(p.Next));

                        { We don't need to call UpdateUsedRegs for every instruction between
                          p and hp2 because the register we're concerned about will not
                          become deallocated (otherwise GetNextInstructionUsingReg would
                          have stopped at an earlier instruction). [Kit] }

                        TempRegUsed :=
                          CrossJump { Assume the register is in use if it crossed a conditional jump } or
                          RegUsedAfterInstruction(taicpu(p).oper[1]^.reg, hp2, TmpUsedRegs) or
                          RegReadByInstruction(taicpu(p).oper[1]^.reg, hp1);

                        case taicpu(p).oper[0]^.typ Of
                          top_reg:
                            begin
                              { change
                                  mov %reg, %treg
                                  mov %treg, y

                                  to

                                  mov %reg, y
                              }
                              CurrentReg := taicpu(p).oper[0]^.reg; { Saves on a handful of pointer dereferences }
                              RegName1 := debug_regname(taicpu(hp2).oper[0]^.reg);
                              if taicpu(hp2).oper[1]^.reg = CurrentReg then
                                begin
                                  { %reg = y - remove hp2 completely (doing it here instead of relying on
                                    the "mov %reg,%reg" optimisation might cut down on a pass iteration) }

                                  if TempRegUsed then
                                    begin
                                      DebugMsg(SPeepholeOptimization + debug_regname(CurrentReg) + ' = ' + RegName1 + '; removed unnecessary instruction (MovMov2MovNop 6b}',hp2);
                                      AllocRegBetween(CurrentReg, p, hp2, UsedRegs);
                                      { Set the start of the next GetNextInstructionUsingRegCond search
                                        to start at the entry right before hp2 (which is about to be removed) }
                                      hp3 := tai(hp2.Previous);
                                      RemoveInstruction(hp2);

                                      { See if there's more we can optimise }
                                      Continue;
                                    end
                                  else
                                    begin
                                      RemoveInstruction(hp2);

                                      { We can remove the original MOV too }
                                      DebugMsg(SPeepholeOptimization + 'MovMov2NopNop 6b done',p);
                                      RemoveCurrentP(p, hp1);
                                      Result:=true;
                                      Exit;
                                    end;
                                end
                              else
                                begin
                                  AllocRegBetween(CurrentReg, p, hp2, UsedRegs);
                                  taicpu(hp2).loadReg(0, CurrentReg);
                                  if TempRegUsed then
                                    begin
                                      { Don't remove the first instruction if the temporary register is in use }
                                      DebugMsg(SPeepholeOptimization + RegName1 + ' = ' + debug_regname(CurrentReg) + '; changed to minimise pipeline stall (MovMov2Mov 6a}',hp2);

                                      { No need to set Result to True. If there's another instruction later on
                                        that can be optimised, it will be detected when the main Pass 1 loop
                                        reaches what is now hp2 and passes it through OptPass1MOV. [Kit] };
                                    end
                                  else
                                    begin
                                      DebugMsg(SPeepholeOptimization + 'MovMov2Mov 6 done',p);
                                      RemoveCurrentP(p, hp1);
                                      Result:=true;
                                      Exit;
                                    end;
                                end;
                            end;
                          top_const:
                            if not (cs_opt_size in current_settings.optimizerswitches) or (taicpu(hp2).opsize = S_B) then
                              begin
                                { change
                                    mov const, %treg
                                    mov %treg, y

                                    to

                                    mov const, y
                                }
                                if (taicpu(hp2).oper[1]^.typ=top_reg) or
                                  ((taicpu(p).oper[0]^.val>=low(longint)) and (taicpu(p).oper[0]^.val<=high(longint))) then
                                  begin
                                    RegName1 := debug_regname(taicpu(hp2).oper[0]^.reg);
                                    taicpu(hp2).loadOper(0,taicpu(p).oper[0]^);

                                    if TempRegUsed then
                                      begin
                                        { Don't remove the first instruction if the temporary register is in use }
                                        DebugMsg(SPeepholeOptimization + RegName1 + ' = ' + debug_tostr(taicpu(p).oper[0]^.val) + '; changed to minimise pipeline stall (MovMov2Mov 7a)',hp2);

                                        { No need to set Result to True. If there's another instruction later on
                                          that can be optimised, it will be detected when the main Pass 1 loop
                                          reaches what is now hp2 and passes it through OptPass1MOV. [Kit] };
                                      end
                                    else
                                      begin
                                        DebugMsg(SPeepholeOptimization + 'MovMov2Mov 7 done',p);
                                        RemoveCurrentP(p, hp1);
                                        Result:=true;
                                        Exit;
                                      end;
                                  end;
                              end;
                            else
                              Internalerror(2019103001);
                          end;
                      end;
                  A_MOVZX, A_MOVSX{$ifdef x86_64}, A_MOVSXD{$endif x86_64}:
                    if MatchOpType(taicpu(hp2), top_reg, top_reg) and
                      MatchOperand(taicpu(hp2).oper[0]^, taicpu(p).oper[1]^.reg) and
                      SuperRegistersEqual(taicpu(hp2).oper[1]^.reg, taicpu(p).oper[1]^.reg) then
                      begin
                        {
                          Change from:
                            mov    ###, %reg
                            ...
                            movs/z %reg,%reg  (Same register, just different sizes)

                          To:
                            movs/z ###, %reg  (Longer version)
                            ...
                            (remove)
                        }
                        DebugMsg(SPeepholeOptimization + 'MovMovs/z2Mov/s/z done', p);
                        taicpu(p).oper[1]^.reg := taicpu(hp2).oper[1]^.reg;

                        { Keep the first instruction as mov if ### is a constant }
                        if taicpu(p).oper[0]^.typ = top_const then
                          taicpu(p).opsize := reg2opsize(taicpu(hp2).oper[1]^.reg)
                        else
                          begin
                            taicpu(p).opcode := taicpu(hp2).opcode;
                            taicpu(p).opsize := taicpu(hp2).opsize;
                          end;

                        DebugMsg(SPeepholeOptimization + 'Removed movs/z instruction and extended earlier write (MovMovs/z2Mov/s/z)', hp2);
                        AllocRegBetween(taicpu(hp2).oper[1]^.reg, p, hp2, UsedRegs);
                        RemoveInstruction(hp2);

                        Result := True;
                        Exit;
                      end;
                  else
                    if MatchOpType(taicpu(p), top_reg, top_reg) then
                      begin
                        CurrentReg := taicpu(p).oper[1]^.reg;
                        TransferUsedRegs(TmpUsedRegs);
                        TmpUsedRegs[R_INTREGISTER].Update(tai(p.Next));
                        if
                          not RegModifiedByInstruction(taicpu(p).oper[0]^.reg, hp1) and
                          not RegModifiedBetween(taicpu(p).oper[0]^.reg, hp1, hp2) and
                          DeepMovOpt(taicpu(p), taicpu(hp2)) then
                          begin
                            { Just in case something didn't get modified (e.g. an
                              implicit register) }
                            if not RegReadByInstruction(CurrentReg, hp2) and
                              { If a conditional jump was crossed, do not delete
                                the original MOV no matter what }
                              not CrossJump then
                              begin
                                TransferUsedRegs(TmpUsedRegs);
                                UpdateUsedRegs(TmpUsedRegs, tai(p.Next));
                                UpdateUsedRegs(TmpUsedRegs, tai(hp1.Next));

                                if not RegUsedAfterInstruction(CurrentReg, hp2, TmpUsedRegs) then
                                  begin
                                    { We can remove the original MOV }
                                    DebugMsg(SPeepholeOptimization + 'Mov2Nop 3b done',p);
                                    RemoveCurrentp(p, hp1);
                                    Result := True;
                                    Exit;
                                  end
                                else
                                  begin
                                    { See if there's more we can optimise }
                                    hp3 := hp2;
                                    Continue;
                                  end;

                                end;
                          end;
                      end;
                end;

                { Break out of the while loop under normal circumstances }
                Break;
              end;

          end;

        if (aoc_MovAnd2Mov_3 in OptsToCheck) and
          (taicpu(p).oper[1]^.typ = top_reg) and
          (taicpu(p).opsize = S_L) and
          GetNextInstructionUsingRegTrackingUse(p,hp2,taicpu(p).oper[1]^.reg) and
          (taicpu(hp2).opcode = A_AND) and
          (MatchOpType(taicpu(hp2),top_const,top_reg) or
           (MatchOpType(taicpu(hp2),top_reg,top_reg) and
            MatchOperand(taicpu(hp2).oper[0]^,taicpu(hp2).oper[1]^))
           ) then
          begin
            if SuperRegistersEqual(taicpu(p).oper[1]^.reg,taicpu(hp2).oper[1]^.reg) then
              begin
                if ((taicpu(hp2).oper[0]^.typ=top_const) and (taicpu(hp2).oper[0]^.val = $ffffffff)) or
                  ((taicpu(hp2).oper[0]^.typ=top_reg) and (taicpu(hp2).opsize=S_L)) then
                  begin
                    { Optimize out:
                        mov x, %reg
                        and ffffffffh, %reg
                    }
                    DebugMsg(SPeepholeOptimization + 'MovAnd2Mov 3 done',p);
                    RemoveInstruction(hp2);
                    Result:=true;
                    exit;
                  end;
              end;
          end;

        { leave out the mov from "mov reg, x(%frame_pointer); leave/ret" (with
          x >= RetOffset) as it doesn't do anything (it writes either to a
          parameter or to the temporary storage room for the function
          result)
        }
        if IsExitCode(hp1) and
          (taicpu(p).oper[1]^.typ = top_ref) and
          (taicpu(p).oper[1]^.ref^.index = NR_NO) and
          (
            (
              (taicpu(p).oper[1]^.ref^.base = current_procinfo.FramePointer) and
              not (
                assigned(current_procinfo.procdef.funcretsym) and
                (taicpu(p).oper[1]^.ref^.offset <= tabstractnormalvarsym(current_procinfo.procdef.funcretsym).localloc.reference.offset)
              )
            ) or
            { Also discard writes to the stack that are below the base pointer,
              as this is temporary storage rather than a function result on the
              stack, say. }
            (
              (taicpu(p).oper[1]^.ref^.base = NR_STACK_POINTER_REG) and
              (taicpu(p).oper[1]^.ref^.offset < current_procinfo.final_localsize)
            )
          ) then
          begin
            RemoveCurrentp(p, hp1);
            DebugMsg(SPeepholeOptimization + 'removed deadstore before leave/ret',p);
            RemoveLastDeallocForFuncRes(p);
            Result:=true;
            exit;
          end;
        if MatchInstruction(hp1,A_CMP,A_TEST,[taicpu(p).opsize]) then
          begin
            if MatchOpType(taicpu(p),top_reg,top_ref) and
              (taicpu(hp1).oper[1]^.typ = top_ref) and
              RefsEqual(taicpu(p).oper[1]^.ref^, taicpu(hp1).oper[1]^.ref^) then
              begin
                { change
                    mov reg1, mem1
                    test/cmp x, mem1

                    to

                    mov reg1, mem1
                    test/cmp x, reg1
                }
                taicpu(hp1).loadreg(1,taicpu(p).oper[0]^.reg);
                DebugMsg(SPeepholeOptimization + 'MovTestCmp2MovTestCmp 1',hp1);
                AllocRegBetween(taicpu(p).oper[0]^.reg,p,hp1,usedregs);
                Result := True;
                Exit;
              end;

            if MatchOpType(taicpu(p),top_ref,top_reg) and
              { The x86 assemblers have difficulty comparing values against absolute addresses }
              (taicpu(p).oper[0]^.ref^.refaddr in [addr_no, addr_pic, addr_pic_no_got]) and
              (taicpu(hp1).oper[0]^.typ <> top_ref) and
              MatchOperand(taicpu(hp1).oper[1]^, taicpu(p).oper[1]^.reg) and
              (
                (
                  (taicpu(hp1).opcode = A_TEST)
                ) or (
                  (taicpu(hp1).opcode = A_CMP) and
                  { A sanity check more than anything }
                  not MatchOperand(taicpu(hp1).oper[0]^, taicpu(p).oper[1]^.reg)
                )
              ) then
              begin
                { change
                    mov      mem, %reg
                    cmp/test x,   %reg / test %reg,%reg
                    (reg deallocated)

                    to

                    cmp/test x,   mem  / cmp  0,   mem
                }
                TransferUsedRegs(TmpUsedRegs);
                UpdateUsedRegs(TmpUsedRegs, tai(p.Next));
                if not RegUsedAfterInstruction(taicpu(p).oper[1]^.reg, hp1, TmpUsedRegs) then
                  begin
                    { Convert test %reg,%reg or test $-1,%reg to cmp $0,mem }
                    if (taicpu(hp1).opcode = A_TEST) and
                      (
                        MatchOperand(taicpu(hp1).oper[0]^, taicpu(p).oper[1]^.reg) or
                        MatchOperand(taicpu(hp1).oper[0]^, -1)
                      ) then
                      begin
                        taicpu(hp1).opcode := A_CMP;
                        taicpu(hp1).loadconst(0, 0);
                      end;
                    taicpu(hp1).loadref(1, taicpu(p).oper[0]^.ref^);
                    DebugMsg(SPeepholeOptimization + 'MOV/CMP -> CMP (memory check)', p);
                    RemoveCurrentP(p, hp1);
                    Result := True;
                    Exit;
                  end;
              end;
          end;

        if MatchInstruction(hp1,A_LEA,[S_L{$ifdef x86_64},S_Q{$endif x86_64}]) and
          { If the flags register is in use, don't change the instruction to an
            ADD otherwise this will scramble the flags. [Kit] }
          not RegInUsedRegs(NR_DEFAULTFLAGS, UsedRegs) then
          begin
            if MatchOpType(Taicpu(p),top_ref,top_reg) and
               ((MatchReference(Taicpu(hp1).oper[0]^.ref^,Taicpu(hp1).oper[1]^.reg,Taicpu(p).oper[1]^.reg) and
                 (Taicpu(hp1).oper[0]^.ref^.base<>Taicpu(p).oper[1]^.reg)
                ) or
                (MatchReference(Taicpu(hp1).oper[0]^.ref^,Taicpu(p).oper[1]^.reg,Taicpu(hp1).oper[1]^.reg) and
                 (Taicpu(hp1).oper[0]^.ref^.index<>Taicpu(p).oper[1]^.reg)
                )
               ) then
               { mov reg1,ref
                 lea reg2,[reg1,reg2]

                 to

                 add reg2,ref}
              begin
                TransferUsedRegs(TmpUsedRegs);
                { reg1 may not be used afterwards }
                if not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg, hp1, TmpUsedRegs)) then
                  begin
                    Taicpu(hp1).opcode:=A_ADD;
                    Taicpu(hp1).oper[0]^.ref^:=Taicpu(p).oper[0]^.ref^;
                    DebugMsg(SPeepholeOptimization + 'MovLea2Add done',hp1);
                    RemoveCurrentp(p, hp1);
                    result:=true;
                    exit;
                  end;
              end;

            { If the LEA instruction can be converted into an arithmetic instruction,
              it may be possible to then fold it in the next optimisation, otherwise
              there's nothing more that can be optimised here. }
            if not ConvertLEA(taicpu(hp1)) then
              Exit;

          end;

        if (taicpu(p).oper[1]^.typ = top_reg) and
          (hp1.typ = ait_instruction) and
          GetNextInstruction(hp1, hp2) and
          MatchInstruction(hp2,A_MOV,[]) and
          (SuperRegistersEqual(taicpu(hp2).oper[0]^.reg,taicpu(p).oper[1]^.reg)) and
          (
            IsFoldableArithOp(taicpu(hp1), taicpu(p).oper[1]^.reg)
{$ifdef x86_64}
            or
            (
              (taicpu(p).opsize=S_L) and (taicpu(hp1).opsize=S_Q) and (taicpu(hp2).opsize=S_L) and
              IsFoldableArithOp(taicpu(hp1), newreg(R_INTREGISTER,getsupreg(taicpu(p).oper[1]^.reg),R_SUBQ))
            )
{$endif x86_64}
          ) then
          begin
            if OpsEqual(taicpu(hp2).oper[1]^, taicpu(p).oper[0]^) and
              (taicpu(hp2).oper[0]^.typ=top_reg) then
              { change   movsX/movzX    reg/ref, reg2
                         add/sub/or/... reg3/$const, reg2
                         mov            reg2 reg/ref
                         dealloc        reg2
                to
                         add/sub/or/... reg3/$const, reg/ref      }
              begin
                TransferUsedRegs(TmpUsedRegs);
                UpdateUsedRegs(TmpUsedRegs, tai(p.next));
                UpdateUsedRegs(TmpUsedRegs, tai(hp1.next));
                If not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp2,TmpUsedRegs)) then
                  begin
                    { by example:
                        movswl  %si,%eax        movswl  %si,%eax      p
                        decl    %eax            addl    %edx,%eax     hp1
                        movw    %ax,%si         movw    %ax,%si       hp2
                      ->
                        movswl  %si,%eax        movswl  %si,%eax      p
                        decw    %eax            addw    %edx,%eax     hp1
                        movw    %ax,%si         movw    %ax,%si       hp2
                    }
                    DebugMsg(SPeepholeOptimization + 'MovOpMov2Op ('+
                          debug_op2str(taicpu(p).opcode)+debug_opsize2str(taicpu(p).opsize)+' '+
                          debug_op2str(taicpu(hp1).opcode)+debug_opsize2str(taicpu(hp1).opsize)+' '+
                          debug_op2str(taicpu(hp2).opcode)+debug_opsize2str(taicpu(hp2).opsize)+')',p);
                    taicpu(hp1).changeopsize(taicpu(hp2).opsize);
                    {
                      ->
                        movswl  %si,%eax        movswl  %si,%eax      p
                        decw    %si             addw    %dx,%si       hp1
                        movw    %ax,%si         movw    %ax,%si       hp2
                    }
                    case taicpu(hp1).ops of
                      1:
                        begin
                          taicpu(hp1).loadoper(0, taicpu(hp2).oper[1]^);
                          if taicpu(hp1).oper[0]^.typ=top_reg then
                            setsubreg(taicpu(hp1).oper[0]^.reg,getsubreg(taicpu(hp2).oper[0]^.reg));
                        end;
                      2:
                        begin
                          taicpu(hp1).loadoper(1, taicpu(hp2).oper[1]^);
                          if (taicpu(hp1).oper[0]^.typ=top_reg) and
                            (taicpu(hp1).opcode<>A_SHL) and
                            (taicpu(hp1).opcode<>A_SHR) and
                            (taicpu(hp1).opcode<>A_SAR) then
                            setsubreg(taicpu(hp1).oper[0]^.reg,getsubreg(taicpu(hp2).oper[0]^.reg));
                        end;
                      else
                        internalerror(2008042701);
                    end;
                    {
                      ->
                        decw    %si             addw    %dx,%si       p
                    }
                    RemoveInstruction(hp2);
                    RemoveCurrentP(p, hp1);
                    Result:=True;
                    Exit;
                  end;
              end;
            if MatchOpType(taicpu(hp2),top_reg,top_reg) and
              not(SuperRegistersEqual(taicpu(hp1).oper[0]^.reg,taicpu(hp2).oper[1]^.reg)) and
              ((topsize2memsize[taicpu(hp1).opsize]<= topsize2memsize[taicpu(hp2).opsize]) or
               { opsize matters for these opcodes, we could probably work around this, but it is not worth the effort }
               ((taicpu(hp1).opcode<>A_SHL) and (taicpu(hp1).opcode<>A_SHR) and (taicpu(hp1).opcode<>A_SAR))
              )
{$ifdef i386}
              { byte registers of esi, edi, ebp, esp are not available on i386 }
              and ((taicpu(hp2).opsize<>S_B) or not(getsupreg(taicpu(hp1).oper[0]^.reg) in [RS_ESI,RS_EDI,RS_EBP,RS_ESP]))
              and ((taicpu(hp2).opsize<>S_B) or not(getsupreg(taicpu(p).oper[0]^.reg) in [RS_ESI,RS_EDI,RS_EBP,RS_ESP]))
{$endif i386}
              then
              { change   movsX/movzX    reg/ref, reg2
                         add/sub/or/... regX/$const, reg2
                         mov            reg2, reg3
                         dealloc        reg2
                to
                         movsX/movzX    reg/ref, reg3
                         add/sub/or/... reg3/$const, reg3
              }
              begin
                TransferUsedRegs(TmpUsedRegs);
                UpdateUsedRegs(TmpUsedRegs, tai(p.next));
                UpdateUsedRegs(TmpUsedRegs, tai(hp1.next));
                If not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp2,TmpUsedRegs)) then
                  begin
                    { by example:
                        movswl  %si,%eax        movswl  %si,%eax      p
                        decl    %eax            addl    %edx,%eax     hp1
                        movw    %ax,%si         movw    %ax,%si       hp2
                      ->
                        movswl  %si,%eax        movswl  %si,%eax      p
                        decw    %eax            addw    %edx,%eax     hp1
                        movw    %ax,%si         movw    %ax,%si       hp2
                    }
                    DebugMsg(SPeepholeOptimization + 'MovOpMov2MovOp ('+
                          debug_op2str(taicpu(p).opcode)+debug_opsize2str(taicpu(p).opsize)+' '+
                          debug_op2str(taicpu(hp1).opcode)+debug_opsize2str(taicpu(hp1).opsize)+' '+
                          debug_op2str(taicpu(hp2).opcode)+debug_opsize2str(taicpu(hp2).opsize)+')',p);
                    { limit size of constants as well to avoid assembler errors, but
                      check opsize to avoid overflow when left shifting the 1 }
                    if (taicpu(p).oper[0]^.typ=top_const) and (topsize2memsize[taicpu(hp2).opsize]<=63) then
                      taicpu(p).oper[0]^.val:=taicpu(p).oper[0]^.val and ((qword(1) shl topsize2memsize[taicpu(hp2).opsize])-1);

{$ifdef x86_64}
                    { Be careful of, for example:
                        movl %reg1,%reg2
                        addl %reg3,%reg2
                        movq %reg2,%reg4

                      This will cause problems if the upper 32-bits of %reg3 or %reg4 are non-zero
                    }
                    if (taicpu(hp1).opsize = S_L) and (taicpu(hp2).opsize = S_Q) then
                      begin
                        taicpu(hp2).changeopsize(S_L);
                        setsubreg(taicpu(hp2).oper[0]^.reg, R_SUBD);
                        setsubreg(taicpu(hp2).oper[1]^.reg, R_SUBD);
                      end;
{$endif x86_64}

                    taicpu(hp1).changeopsize(taicpu(hp2).opsize);
                    taicpu(p).changeopsize(taicpu(hp2).opsize);
                    if taicpu(p).oper[0]^.typ=top_reg then
                      setsubreg(taicpu(p).oper[0]^.reg,getsubreg(taicpu(hp2).oper[0]^.reg));
                    taicpu(p).loadoper(1, taicpu(hp2).oper[1]^);
                    AllocRegBetween(taicpu(p).oper[1]^.reg,p,hp1,usedregs);
                    {
                      ->
                        movswl  %si,%eax        movswl  %si,%eax      p
                        decw    %si             addw    %dx,%si       hp1
                        movw    %ax,%si         movw    %ax,%si       hp2
                    }
                    case taicpu(hp1).ops of
                      1:
                        begin
                          taicpu(hp1).loadoper(0, taicpu(hp2).oper[1]^);
                          if taicpu(hp1).oper[0]^.typ=top_reg then
                            setsubreg(taicpu(hp1).oper[0]^.reg,getsubreg(taicpu(hp2).oper[0]^.reg));
                        end;
                      2:
                        begin
                          taicpu(hp1).loadoper(1, taicpu(hp2).oper[1]^);
                          if (taicpu(hp1).oper[0]^.typ=top_reg) and
                            (taicpu(hp1).opcode<>A_SHL) and
                            (taicpu(hp1).opcode<>A_SHR) and
                            (taicpu(hp1).opcode<>A_SAR) then
                            setsubreg(taicpu(hp1).oper[0]^.reg,getsubreg(taicpu(hp2).oper[0]^.reg));
                        end;
                      else
                        internalerror(2018111801);
                    end;
                    {
                      ->
                        decw    %si             addw    %dx,%si       p
                    }
                    RemoveInstruction(hp2);
                  end;
              end;

          end;
        if MatchInstruction(hp1,A_BTS,A_BTR,[Taicpu(p).opsize]) and
          GetNextInstruction(hp1, hp2) and
          MatchInstruction(hp2,A_OR,[Taicpu(p).opsize]) and
          MatchOperand(Taicpu(p).oper[0]^,0) and
          (Taicpu(p).oper[1]^.typ = top_reg) and
          MatchOperand(Taicpu(p).oper[1]^,Taicpu(hp1).oper[1]^) and
          MatchOperand(Taicpu(p).oper[1]^,Taicpu(hp2).oper[1]^) then
          { mov reg1,0
            bts reg1,operand1             -->      mov reg1,operand2
            or  reg1,operand2                      bts reg1,operand1}
          begin
            Taicpu(hp2).opcode:=A_MOV;
            asml.remove(hp1);
            insertllitem(hp2,hp2.next,hp1);
            RemoveCurrentp(p, hp1);
            Result:=true;
            exit;
          end;

{$ifdef x86_64}
        { Convert:
            movq x(ref),%reg64
            shrq y,%reg64
          To:
            movq x+4(ref),%reg32
            shrq y-32,%reg32 (Remove if y = 32)
        }
        if (taicpu(p).opsize = S_Q) and
          (taicpu(p).oper[0]^.typ = top_ref) and { Second operand will be a register }
          (taicpu(p).oper[0]^.ref^.offset <= $7FFFFFFB) and
          MatchInstruction(hp1, A_SHR, [taicpu(p).opsize]) and
          MatchOpType(taicpu(hp1), top_const, top_reg) and
          (taicpu(hp1).oper[0]^.val >= 32) and
          (taicpu(hp1).oper[1]^.reg = taicpu(p).oper[1]^.reg) then
          begin
            RegName1 := debug_regname(taicpu(hp1).oper[1]^.reg);
            PreMessage := 'movq ' + debug_operstr(taicpu(p).oper[0]^) + ',' + RegName1 + '; ' +
              'shrq $' + debug_tostr(taicpu(hp1).oper[0]^.val) + ',' + RegName1 + ' -> movl ';

            { Convert to 32-bit }
            setsubreg(taicpu(p).oper[1]^.reg, R_SUBD);
            taicpu(p).opsize := S_L;

            Inc(taicpu(p).oper[0]^.ref^.offset, 4);

            PreMessage := PreMessage + debug_operstr(taicpu(p).oper[0]^) + ',' + debug_regname(taicpu(p).oper[1]^.reg);
            if (taicpu(hp1).oper[0]^.val = 32) then
              begin
                DebugMsg(SPeepholeOptimization + PreMessage + ' (MovShr2Mov)', p);
                RemoveInstruction(hp1);
              end
            else
              begin
                { This will potentially open up more arithmetic operations since
                  the peephole optimizer now has a big hint that only the lower
                  32 bits are currently in use (and opcodes are smaller in size) }
                setsubreg(taicpu(hp1).oper[1]^.reg, R_SUBD);
                taicpu(hp1).opsize := S_L;

                Dec(taicpu(hp1).oper[0]^.val, 32);
                DebugMsg(SPeepholeOptimization + PreMessage +
                  '; shrl $' + debug_tostr(taicpu(hp1).oper[0]^.val) + ',' + debug_regname(taicpu(hp1).oper[1]^.reg) + ' (MovShr2MovShr)', p);
              end;
            Result := True;
            Exit;
          end;
{$endif x86_64}
      end;


   function TX86AsmOptimizer.OptPass1MOVXX(var p : tai) : boolean;
      var
        hp1 : tai;
      begin
        Result:=false;
        if taicpu(p).ops <> 2 then
          exit;
        if GetNextInstruction(p,hp1) and
          MatchInstruction(hp1,taicpu(p).opcode,[taicpu(p).opsize]) and
          (taicpu(hp1).ops = 2) then
          begin
            if (taicpu(hp1).oper[0]^.typ = taicpu(p).oper[1]^.typ) and
               (taicpu(hp1).oper[1]^.typ = taicpu(p).oper[0]^.typ) then
                {  movXX reg1, mem1     or     movXX mem1, reg1
                   movXX mem2, reg2            movXX reg2, mem2}
              begin
                if OpsEqual(taicpu(hp1).oper[1]^,taicpu(p).oper[0]^) then
                  { movXX reg1, mem1     or     movXX mem1, reg1
                    movXX mem2, reg1            movXX reg2, mem1}
                  begin
                    if OpsEqual(taicpu(hp1).oper[0]^,taicpu(p).oper[1]^) then
                      begin
                        { Removes the second statement from
                          movXX reg1, mem1/reg2
                          movXX mem1/reg2, reg1
                        }
                        if taicpu(p).oper[0]^.typ=top_reg then
                          AllocRegBetween(taicpu(p).oper[0]^.reg,p,hp1,usedregs);
                        { Removes the second statement from
                          movXX mem1/reg1, reg2
                          movXX reg2, mem1/reg1
                        }
                        if (taicpu(p).oper[1]^.typ=top_reg) and
                          not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp1,UsedRegs)) then
                          begin
                            DebugMsg(SPeepholeOptimization + 'MovXXMovXX2Nop 1 done',p);
                            RemoveInstruction(hp1);
                            RemoveCurrentp(p); { p will now be equal to the instruction that follows what was hp1 }
                          end
                        else
                          begin
                            DebugMsg(SPeepholeOptimization + 'MovXXMovXX2MoVXX 1 done',p);
                            RemoveInstruction(hp1);
                          end;
                        Result:=true;
                        exit;
                      end
                end;
            end;
        end;
      end;


    function TX86AsmOptimizer.OptPass1OP(var p : tai) : boolean;
      var
        hp1 : tai;
      begin
        result:=false;
        { replace
            <Op>X    %mreg1,%mreg2  // Op in [ADD,MUL]
            MovX     %mreg2,%mreg1
            dealloc  %mreg2

            by
            <Op>X    %mreg2,%mreg1
          ?
        }
        if GetNextInstruction(p,hp1) and
          { we mix single and double opperations here because we assume that the compiler
            generates vmovapd only after double operations and vmovaps only after single operations }
          MatchInstruction(hp1,A_MOVAPD,A_MOVAPS,[S_NO]) and
          MatchOperand(taicpu(p).oper[1]^,taicpu(hp1).oper[0]^) and
          MatchOperand(taicpu(p).oper[0]^,taicpu(hp1).oper[1]^) and
          (taicpu(p).oper[0]^.typ=top_reg) then
          begin
            TransferUsedRegs(TmpUsedRegs);
            UpdateUsedRegs(TmpUsedRegs, tai(p.next));
            if not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp1,TmpUsedRegs)) then
              begin
                taicpu(p).loadoper(0,taicpu(hp1).oper[0]^);
                taicpu(p).loadoper(1,taicpu(hp1).oper[1]^);
                DebugMsg(SPeepholeOptimization + 'OpMov2Op done',p);
                RemoveInstruction(hp1);
                result:=true;
              end;
          end;
      end;


    function TX86AsmOptimizer.OptPass1Test(var p: tai) : boolean;
      var
        hp1, p_label, p_dist, hp1_dist: tai;
        JumpLabel, JumpLabel_dist: TAsmLabel;
      begin
        Result := False;

        if (taicpu(p).oper[1]^.typ = top_reg) then
          begin
            if GetNextInstruction(p, hp1) and
              MatchInstruction(hp1,A_MOV,[]) and
              not RegInInstruction(taicpu(p).oper[1]^.reg, hp1) and
              (
                (taicpu(p).oper[0]^.typ <> top_reg) or
                not RegInInstruction(taicpu(p).oper[0]^.reg, hp1)
              ) then
              begin
                { If we have something like:
                    test %reg1,%reg1
                    mov  0,%reg2

                  And no registers are shared (the two %reg1's can be different, as
                  long as neither of them are also %reg2), move the MOV command to
                  before the comparison as this means it can be optimised without
                  worrying about the FLAGS register. (This combination is generated
                  by "J(c)Mov1JmpMov0 -> Set(~c)", among other things).
                }
                SwapMovCmp(p, hp1);
                Result := True;
                Exit;
              end;

            { Search for:
                test  %reg,%reg
                j(c1) @lbl1
                ...
              @lbl:
                test %reg,%reg (same register)
                j(c2) @lbl2

              If c2 is a subset of c1, change to:
                test  %reg,%reg
                j(c1) @lbl2
                (@lbl1 may become a dead label as a result)
            }

            if (taicpu(p).oper[0]^.typ = top_reg) and
              (taicpu(p).oper[0]^.reg = taicpu(p).oper[1]^.reg) and
              MatchInstruction(hp1, A_JCC, []) and
              (taicpu(hp1).oper[0]^.typ = top_ref) then
              begin
                JumpLabel := TAsmLabel(taicpu(hp1).oper[0]^.ref^.symbol);
                p_label := nil;
                if Assigned(JumpLabel) then
                  p_label := getlabelwithsym(JumpLabel);

                if Assigned(p_label) and
                  GetNextInstruction(p_label, p_dist) and
                  MatchInstruction(p_dist, A_TEST, []) and
                  { It's fine if the second test uses smaller sub-registers }
                  (taicpu(p_dist).opsize <= taicpu(p).opsize) and
                  MatchOpType(taicpu(p_dist), top_reg, top_reg) and
                  SuperRegistersEqual(taicpu(p_dist).oper[0]^.reg, taicpu(p).oper[0]^.reg) and
                  SuperRegistersEqual(taicpu(p_dist).oper[1]^.reg, taicpu(p).oper[1]^.reg) and
                  GetNextInstruction(p_dist, hp1_dist) and
                  MatchInstruction(hp1_dist, A_JCC, []) then
                  begin
                    JumpLabel_dist := TAsmLabel(taicpu(hp1_dist).oper[0]^.ref^.symbol);

                    if JumpLabel = JumpLabel_dist then
                      { This is an infinite loop }
                      Exit;

                    { Best optimisation when the second condition is a subset (or equal) to the first }
                    if condition_in(taicpu(hp1_dist).condition, taicpu(hp1).condition) then
                      begin
                        if Assigned(JumpLabel_dist) then
                          JumpLabel_dist.IncRefs;

                        if Assigned(JumpLabel) then
                          JumpLabel.DecRefs;

                        DebugMsg(SPeepholeOptimization + 'TEST/Jcc/@Lbl/TEST/Jcc -> TEST/Jcc, redirecting first jump', hp1);
                        taicpu(hp1).loadref(0, taicpu(hp1_dist).oper[0]^.ref^);
                        Result := True;
                        Exit;
                      end;
                  end;
              end;
          end;
      end;


    function TX86AsmOptimizer.OptPass1Add(var p : tai) : boolean;
      var
        hp1 : tai;
      begin
        result:=false;
        { replace
            addX     const,%reg1
            leaX     (%reg1,%reg1,Y),%reg2   // Base or index might not be equal to reg1
            dealloc  %reg1

            by

            leaX     const+const*Y(%reg1,%reg1,Y),%reg2
        }
        if MatchOpType(taicpu(p),top_const,top_reg) and
          GetNextInstruction(p,hp1) and
          MatchInstruction(hp1,A_LEA,[taicpu(p).opsize]) and
          ((taicpu(p).oper[1]^.reg=taicpu(hp1).oper[0]^.ref^.base) or
           (taicpu(p).oper[1]^.reg=taicpu(hp1).oper[0]^.ref^.index)) then
          begin
            TransferUsedRegs(TmpUsedRegs);
            UpdateUsedRegs(TmpUsedRegs, tai(p.next));
            if not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp1,TmpUsedRegs)) then
              begin
                DebugMsg(SPeepholeOptimization + 'AddLea2Lea done',p);
                if taicpu(p).oper[1]^.reg=taicpu(hp1).oper[0]^.ref^.base then
                  inc(taicpu(hp1).oper[0]^.ref^.offset,taicpu(p).oper[0]^.val);
                if taicpu(p).oper[1]^.reg=taicpu(hp1).oper[0]^.ref^.index then
                  inc(taicpu(hp1).oper[0]^.ref^.offset,taicpu(p).oper[0]^.val*max(taicpu(hp1).oper[0]^.ref^.scalefactor,1));
                RemoveCurrentP(p);
                result:=true;
              end;
          end;
      end;


    function TX86AsmOptimizer.OptPass1LEA(var p : tai) : boolean;
      var
        hp1: tai;
        ref: Integer;
        saveref: treference;
        TempReg: TRegister;
        Multiple: TCGInt;
      begin
        Result:=false;
        { removes seg register prefixes from LEA operations, as they
          don't do anything}
        taicpu(p).oper[0]^.ref^.Segment:=NR_NO;
        { changes "lea (%reg1), %reg2" into "mov %reg1, %reg2" }
        if (taicpu(p).oper[0]^.ref^.base <> NR_NO) and
           (taicpu(p).oper[0]^.ref^.index = NR_NO) and
           { do not mess with leas acessing the stack pointer }
           (taicpu(p).oper[1]^.reg <> NR_STACK_POINTER_REG) and
           (not(Assigned(taicpu(p).oper[0]^.ref^.Symbol))) then
          begin
            if (taicpu(p).oper[0]^.ref^.offset = 0) then
              begin
                if (taicpu(p).oper[0]^.ref^.base <> taicpu(p).oper[1]^.reg) then
                  begin
                    hp1:=taicpu.op_reg_reg(A_MOV,taicpu(p).opsize,taicpu(p).oper[0]^.ref^.base,
                      taicpu(p).oper[1]^.reg);
                    InsertLLItem(p.previous,p.next, hp1);
                    DebugMsg(SPeepholeOptimization + 'Lea2Mov done',hp1);
                    p.free;
                    p:=hp1;
                  end
                else
                  begin
                    DebugMsg(SPeepholeOptimization + 'Lea2Nop done',p);
                    RemoveCurrentP(p);
                  end;
                Result:=true;
                exit;
              end
            else if (
              { continue to use lea to adjust the stack pointer,
                it is the recommended way, but only if not optimizing for size }
                (taicpu(p).oper[1]^.reg<>NR_STACK_POINTER_REG) or
                (cs_opt_size in current_settings.optimizerswitches)
              ) and
              { If the flags register is in use, don't change the instruction
                to an ADD otherwise this will scramble the flags. [Kit] }
              not RegInUsedRegs(NR_DEFAULTFLAGS, UsedRegs) and
              ConvertLEA(taicpu(p)) then
              begin
                Result:=true;
                exit;
              end;
          end;

        if GetNextInstruction(p,hp1) and
          (hp1.typ=ait_instruction) then
          begin
            if MatchInstruction(hp1,A_MOV,[taicpu(p).opsize]) and
              MatchOperand(taicpu(p).oper[1]^,taicpu(hp1).oper[0]^) and
              MatchOpType(Taicpu(hp1),top_reg,top_reg) and
              (taicpu(p).oper[1]^.reg<>NR_STACK_POINTER_REG) then
              begin
                TransferUsedRegs(TmpUsedRegs);
                UpdateUsedRegs(TmpUsedRegs, tai(p.next));
                if not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp1,TmpUsedRegs)) then
                  begin
                    taicpu(p).loadoper(1,taicpu(hp1).oper[1]^);
                    DebugMsg(SPeepholeOptimization + 'LeaMov2Lea done',p);
                    RemoveInstruction(hp1);
                    result:=true;
                    exit;
                  end;
              end;

            { changes
                lea <ref1>, reg1
                <op> ...,<ref. with reg1>,...
                to
                <op> ...,<ref1>,... }
            if (taicpu(p).oper[1]^.reg<>current_procinfo.framepointer) and
              (taicpu(p).oper[1]^.reg<>NR_STACK_POINTER_REG) and
              not(MatchInstruction(hp1,A_LEA,[])) then
              begin
                { find a reference which uses reg1 }
                if (taicpu(hp1).ops>=1) and (taicpu(hp1).oper[0]^.typ=top_ref) and RegInOp(taicpu(p).oper[1]^.reg,taicpu(hp1).oper[0]^) then
                  ref:=0
                else if (taicpu(hp1).ops>=2) and (taicpu(hp1).oper[1]^.typ=top_ref) and RegInOp(taicpu(p).oper[1]^.reg,taicpu(hp1).oper[1]^) then
                  ref:=1
                else
                  ref:=-1;
                if (ref<>-1) and
                  { reg1 must be either the base or the index }
                  ((taicpu(hp1).oper[ref]^.ref^.base=taicpu(p).oper[1]^.reg) xor (taicpu(hp1).oper[ref]^.ref^.index=taicpu(p).oper[1]^.reg)) then
                  begin
                    { reg1 can be removed from the reference }
                    saveref:=taicpu(hp1).oper[ref]^.ref^;
                    if taicpu(hp1).oper[ref]^.ref^.base=taicpu(p).oper[1]^.reg then
                      taicpu(hp1).oper[ref]^.ref^.base:=NR_NO
                    else if taicpu(hp1).oper[ref]^.ref^.index=taicpu(p).oper[1]^.reg then
                      taicpu(hp1).oper[ref]^.ref^.index:=NR_NO
                    else
                      Internalerror(2019111201);
                    { check if the can insert all data of the lea into the second instruction }
                    if ((taicpu(hp1).oper[ref]^.ref^.base=taicpu(p).oper[1]^.reg) or (taicpu(hp1).oper[ref]^.ref^.scalefactor <= 1)) and
                      ((taicpu(p).oper[0]^.ref^.base=NR_NO) or (taicpu(hp1).oper[ref]^.ref^.base=NR_NO)) and
                      ((taicpu(p).oper[0]^.ref^.index=NR_NO) or (taicpu(hp1).oper[ref]^.ref^.index=NR_NO)) and
                      ((taicpu(p).oper[0]^.ref^.symbol=nil) or (taicpu(hp1).oper[ref]^.ref^.symbol=nil)) and
                      ((taicpu(p).oper[0]^.ref^.relsymbol=nil) or (taicpu(hp1).oper[ref]^.ref^.relsymbol=nil)) and
                      ((taicpu(p).oper[0]^.ref^.scalefactor <= 1) or (taicpu(hp1).oper[ref]^.ref^.scalefactor <= 1)) and
                      (taicpu(p).oper[0]^.ref^.segment=NR_NO) and (taicpu(hp1).oper[ref]^.ref^.segment=NR_NO)
{$ifdef x86_64}
                      and (abs(taicpu(hp1).oper[ref]^.ref^.offset+taicpu(p).oper[0]^.ref^.offset)<=$7fffffff)
                      and (((taicpu(p).oper[0]^.ref^.base<>NR_RIP) and (taicpu(p).oper[0]^.ref^.index<>NR_RIP)) or
                           ((taicpu(hp1).oper[ref]^.ref^.base=NR_NO) and (taicpu(hp1).oper[ref]^.ref^.index=NR_NO))
                          )
{$endif x86_64}
                      then
                      begin
                        { reg1 might not used by the second instruction after it is remove from the reference }
                        if not(RegInInstruction(taicpu(p).oper[1]^.reg,taicpu(hp1))) then
                          begin
                            TransferUsedRegs(TmpUsedRegs);
                            UpdateUsedRegs(TmpUsedRegs, tai(p.next));
                            { reg1 is not updated so it might not be used afterwards }
                            if not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp1,TmpUsedRegs)) then
                              begin
                                DebugMsg(SPeepholeOptimization + 'LeaOp2Op done',p);
                                if taicpu(p).oper[0]^.ref^.base<>NR_NO then
                                  taicpu(hp1).oper[ref]^.ref^.base:=taicpu(p).oper[0]^.ref^.base;
                                if taicpu(p).oper[0]^.ref^.index<>NR_NO then
                                  taicpu(hp1).oper[ref]^.ref^.index:=taicpu(p).oper[0]^.ref^.index;
                                if taicpu(p).oper[0]^.ref^.symbol<>nil then
                                  taicpu(hp1).oper[ref]^.ref^.symbol:=taicpu(p).oper[0]^.ref^.symbol;
                                if taicpu(p).oper[0]^.ref^.relsymbol<>nil then
                                  taicpu(hp1).oper[ref]^.ref^.relsymbol:=taicpu(p).oper[0]^.ref^.relsymbol;
                                if taicpu(p).oper[0]^.ref^.scalefactor > 1 then
                                  taicpu(hp1).oper[ref]^.ref^.scalefactor:=taicpu(p).oper[0]^.ref^.scalefactor;
                                inc(taicpu(hp1).oper[ref]^.ref^.offset,taicpu(p).oper[0]^.ref^.offset);
                                RemoveCurrentP(p, hp1);
                                result:=true;
                                exit;
                              end
                          end;
                      end;
                    { recover }
                    taicpu(hp1).oper[ref]^.ref^:=saveref;
                  end;
              end;

          end;

        { for now, we do not mess with the stack pointer, thought it might be usefull to remove
          unneeded lea sequences on the stack pointer, it needs to be tested in detail }
        if (taicpu(p).oper[1]^.reg <> NR_STACK_POINTER_REG) and
          GetNextInstructionUsingReg(p,hp1,taicpu(p).oper[1]^.reg) then
          begin
            { Check common LEA/LEA conditions }
            if MatchInstruction(hp1,A_LEA,[taicpu(p).opsize]) and
              (taicpu(p).oper[1]^.reg = taicpu(hp1).oper[1]^.reg) and
              (taicpu(p).oper[0]^.ref^.relsymbol = nil) and
              (taicpu(p).oper[0]^.ref^.segment = NR_NO) and
              (taicpu(p).oper[0]^.ref^.symbol = nil) and
              (taicpu(hp1).oper[0]^.ref^.relsymbol = nil) and
              (taicpu(hp1).oper[0]^.ref^.segment = NR_NO) and
              (taicpu(hp1).oper[0]^.ref^.symbol = nil) and
              (
                (taicpu(p).oper[0]^.ref^.base = NR_NO) or { Don't call RegModifiedBetween unnecessarily }
                not(RegModifiedBetween(taicpu(p).oper[0]^.ref^.base,p,hp1))
              ) and (
                (taicpu(p).oper[0]^.ref^.index = taicpu(p).oper[0]^.ref^.base) or { Don't call RegModifiedBetween unnecessarily }
                (taicpu(p).oper[0]^.ref^.index = NR_NO) or
                not(RegModifiedBetween(taicpu(p).oper[0]^.ref^.index,p,hp1))
              ) then
              begin
                { changes
                    lea (regX,scale), reg1
                    lea offset(reg1,reg1), reg1
                    to
                    lea offset(regX,scale*2), reg1

                  and
                    lea (regX,scale1), reg1
                    lea offset(reg1,scale2), reg1
                    to
                    lea offset(regX,scale1*scale2), reg1

                  ... so long as the final scale does not exceed 8

                  (Similarly, allow the first instruction to be "lea (regX,regX),reg1")
                  }
                if (taicpu(p).oper[0]^.ref^.offset = 0) and
                  (taicpu(hp1).oper[0]^.ref^.index = taicpu(p).oper[1]^.reg) and
                  (
                    (
                      (taicpu(p).oper[0]^.ref^.base = NR_NO)
                    ) or (
                      (taicpu(p).oper[0]^.ref^.scalefactor <= 1) and
                      (
                        (taicpu(p).oper[0]^.ref^.base = taicpu(p).oper[0]^.ref^.index) and
                        not(RegUsedBetween(taicpu(p).oper[0]^.ref^.index, p, hp1))
                      )
                    )
                  ) and (
                    (
                      { lea (reg1,scale2), reg1 variant }
                      (taicpu(hp1).oper[0]^.ref^.base = NR_NO) and
                      (
                        (
                          (taicpu(p).oper[0]^.ref^.base = NR_NO) and
                          (taicpu(hp1).oper[0]^.ref^.scalefactor * taicpu(p).oper[0]^.ref^.scalefactor <= 8)
                        ) or (
                          { lea (regX,regX), reg1 variant }
                          (taicpu(p).oper[0]^.ref^.base <> NR_NO) and
                          (taicpu(hp1).oper[0]^.ref^.scalefactor <= 4)
                        )
                      )
                    ) or (
                      { lea (reg1,reg1), reg1 variant }
                      (taicpu(hp1).oper[0]^.ref^.base = taicpu(p).oper[1]^.reg) and
                      (taicpu(hp1).oper[0]^.ref^.scalefactor <= 1)
                    )
                  ) then
                  begin
                    DebugMsg(SPeepholeOptimization + 'LeaLea2Lea 2 done',p);

                    { Make everything homogeneous to make calculations easier }
                    if (taicpu(p).oper[0]^.ref^.base <> NR_NO) then
                      begin
                        if taicpu(p).oper[0]^.ref^.index <> NR_NO then
                          { Convert lea (regX,regX),reg1 to lea (regX,2),reg1 }
                          taicpu(p).oper[0]^.ref^.scalefactor := 2
                        else
                          taicpu(p).oper[0]^.ref^.index := taicpu(p).oper[0]^.ref^.base;

                        taicpu(p).oper[0]^.ref^.base := NR_NO;
                      end;

                    if (taicpu(hp1).oper[0]^.ref^.base = NR_NO) then
                      begin
                        { Just to prevent miscalculations }
                        if (taicpu(hp1).oper[0]^.ref^.scalefactor = 0) then
                          taicpu(hp1).oper[0]^.ref^.scalefactor := taicpu(p).oper[0]^.ref^.scalefactor
                        else
                          taicpu(hp1).oper[0]^.ref^.scalefactor := taicpu(hp1).oper[0]^.ref^.scalefactor * taicpu(p).oper[0]^.ref^.scalefactor;
                      end
                    else
                      begin
                        taicpu(hp1).oper[0]^.ref^.base := NR_NO;
                        taicpu(hp1).oper[0]^.ref^.scalefactor := taicpu(p).oper[0]^.ref^.scalefactor * 2;
                      end;

                    taicpu(hp1).oper[0]^.ref^.index := taicpu(p).oper[0]^.ref^.index;
                    RemoveCurrentP(p);
                    result:=true;
                    exit;
                  end

                { changes
                    lea offset1(regX), reg1
                    lea offset2(reg1), reg1
                    to
                    lea offset1+offset2(regX), reg1 }
                else if
                  (
                    (taicpu(hp1).oper[0]^.ref^.index = taicpu(p).oper[1]^.reg) and
                    (taicpu(p).oper[0]^.ref^.index = NR_NO)
                  ) or (
                    (taicpu(hp1).oper[0]^.ref^.base = taicpu(p).oper[1]^.reg) and
                    (taicpu(hp1).oper[0]^.ref^.scalefactor <= 1) and
                    (
                      (
                        (taicpu(p).oper[0]^.ref^.index = NR_NO) or
                        (taicpu(p).oper[0]^.ref^.base = NR_NO)
                      ) or (
                        (taicpu(p).oper[0]^.ref^.scalefactor <= 1) and
                        (
                          (taicpu(p).oper[0]^.ref^.index = NR_NO) or
                          (
                            (taicpu(p).oper[0]^.ref^.index = taicpu(p).oper[0]^.ref^.base) and
                            (
                              (taicpu(hp1).oper[0]^.ref^.index = NR_NO) or
                              (taicpu(hp1).oper[0]^.ref^.base = NR_NO)
                            )
                          )
                        )
                      )
                    )
                  ) then
                  begin
                    DebugMsg(SPeepholeOptimization + 'LeaLea2Lea 1 done',p);

                    if taicpu(hp1).oper[0]^.ref^.index=taicpu(p).oper[1]^.reg then
                      begin
                        taicpu(hp1).oper[0]^.ref^.index:=taicpu(p).oper[0]^.ref^.base;
                        inc(taicpu(hp1).oper[0]^.ref^.offset,taicpu(p).oper[0]^.ref^.offset*max(taicpu(hp1).oper[0]^.ref^.scalefactor,1));
                        { if the register is used as index and base, we have to increase for base as well
                          and adapt base }
                        if taicpu(hp1).oper[0]^.ref^.base=taicpu(p).oper[1]^.reg then
                          begin
                            taicpu(hp1).oper[0]^.ref^.base:=taicpu(p).oper[0]^.ref^.base;
                            inc(taicpu(hp1).oper[0]^.ref^.offset,taicpu(p).oper[0]^.ref^.offset);
                          end;
                      end
                    else
                      begin
                        inc(taicpu(hp1).oper[0]^.ref^.offset,taicpu(p).oper[0]^.ref^.offset);
                        taicpu(hp1).oper[0]^.ref^.base:=taicpu(p).oper[0]^.ref^.base;
                      end;
                    if taicpu(p).oper[0]^.ref^.index<>NR_NO then
                      begin
                        taicpu(hp1).oper[0]^.ref^.base:=taicpu(hp1).oper[0]^.ref^.index;
                        taicpu(hp1).oper[0]^.ref^.index:=taicpu(p).oper[0]^.ref^.index;
                        taicpu(hp1).oper[0]^.ref^.scalefactor:=taicpu(p).oper[0]^.ref^.scalefactor;
                      end;
                    RemoveCurrentP(p);
                    result:=true;
                    exit;
                  end;
              end;

            { Change:
                leal/q $x(%reg1),%reg2
                ...
                shll/q $y,%reg2
              To:
                leal/q $(x+2^y)(%reg1,2^y),%reg2 (if y <= 3)
            }
            if MatchInstruction(hp1, A_SHL, [taicpu(p).opsize]) and
              MatchOpType(taicpu(hp1), top_const, top_reg) and
              (taicpu(hp1).oper[0]^.val <= 3) then
              begin
                Multiple := 1 shl taicpu(hp1).oper[0]^.val;
                TransferUsedRegs(TmpUsedRegs);
                UpdateUsedRegs(TmpUsedRegs, tai(hp1.Next));

                TempReg := taicpu(hp1).oper[1]^.reg; { Store locally to reduce the number of dereferences }
                if
                  { This allows the optimisation in some circumstances even if the lea instruction already has a scale factor
                    (this works even if scalefactor is zero) }
                  ((Multiple * taicpu(p).oper[0]^.ref^.scalefactor) <= 8) and

                  { Ensure offset doesn't go out of bounds }
                  (abs(taicpu(p).oper[0]^.ref^.offset * Multiple) <= $7FFFFFFF) and

                  not (RegInUsedRegs(NR_DEFAULTFLAGS,TmpUsedRegs)) and
                  MatchOperand(taicpu(p).oper[1]^, TempReg) and
                  (
                    (
                      not SuperRegistersEqual(taicpu(p).oper[0]^.ref^.base, TempReg) and
                      (
                        (taicpu(p).oper[0]^.ref^.index = NR_NO) or
                        (taicpu(p).oper[0]^.ref^.index = NR_INVALID) or
                        (
                          { Check for lea $x(%reg1,%reg1),%reg2 and treat as it it were lea $x(%reg1,2),%reg2 }
                          (taicpu(p).oper[0]^.ref^.index = taicpu(p).oper[0]^.ref^.base) and
                          (taicpu(p).oper[0]^.ref^.scalefactor <= 1)
                        )
                      )
                    ) or (
                      (
                        (taicpu(p).oper[0]^.ref^.base = NR_NO) or
                        (taicpu(p).oper[0]^.ref^.base = NR_INVALID)
                      ) and
                      not SuperRegistersEqual(taicpu(p).oper[0]^.ref^.index, TempReg)
                    )
                  ) then
                  begin
                    repeat
                      with taicpu(p).oper[0]^.ref^ do
                        begin
                          { Convert lea $x(%reg1,%reg1),%reg2 to lea $x(%reg1,2),%reg2 }
                          if index = base then
                            begin
                              if Multiple > 4 then
                                { Optimisation will no longer work because resultant
                                  scale factor will exceed 8 }
                                Break;

                              base := NR_NO;
                              scalefactor := 2;
                              DebugMsg(SPeepholeOptimization + 'lea $x(%reg1,%reg1),%reg2 -> lea $x(%reg1,2),%reg2 for following optimisation', p);
                            end
                          else if (base <> NR_NO) and (base <> NR_INVALID) then
                            begin
                              { Scale factor only works on the index register }
                              index := base;
                              base := NR_NO;
                            end;

                          { For safety }
                          if scalefactor <= 1 then
                            begin
                              DebugMsg(SPeepholeOptimization + 'LeaShl2Lea 1', p);
                              scalefactor := Multiple;
                            end
                          else
                            begin
                              DebugMsg(SPeepholeOptimization + 'LeaShl2Lea 2', p);
                              scalefactor := scalefactor * Multiple;
                            end;

                          offset := offset * Multiple;
                        end;
                      RemoveInstruction(hp1);
                      Result := True;
                      Exit;
                    { This repeat..until loop exists for the benefit of Break }
                    until True;
                  end;
              end;
          end;
      end;


    function TX86AsmOptimizer.DoSubAddOpt(var p: tai): Boolean;
      var
        hp1 : tai;
      begin
        DoSubAddOpt := False;
        if GetLastInstruction(p, hp1) and
           (hp1.typ = ait_instruction) and
           (taicpu(hp1).opsize = taicpu(p).opsize) then
          case taicpu(hp1).opcode Of
            A_DEC:
              if (taicpu(hp1).oper[0]^.typ = top_reg) and
                MatchOperand(taicpu(hp1).oper[0]^,taicpu(p).oper[1]^) then
                begin
                  taicpu(p).loadConst(0,taicpu(p).oper[0]^.val+1);
                  RemoveInstruction(hp1);
                end;
             A_SUB:
               if MatchOpType(taicpu(hp1),top_const,top_reg) and
                 MatchOperand(taicpu(hp1).oper[1]^,taicpu(p).oper[1]^) then
                 begin
                   taicpu(p).loadConst(0,taicpu(p).oper[0]^.val+taicpu(hp1).oper[0]^.val);
                   RemoveInstruction(hp1);
                 end;
             A_ADD:
               begin
                 if MatchOpType(taicpu(hp1),top_const,top_reg) and
                   MatchOperand(taicpu(hp1).oper[1]^,taicpu(p).oper[1]^) then
                   begin
                     taicpu(p).loadConst(0,taicpu(p).oper[0]^.val-taicpu(hp1).oper[0]^.val);
                     RemoveInstruction(hp1);
                     if (taicpu(p).oper[0]^.val = 0) then
                       begin
                         hp1 := tai(p.next);
                         RemoveInstruction(p); { Note, the choice to not use RemoveCurrentp is deliberate }
                         if not GetLastInstruction(hp1, p) then
                           p := hp1;
                         DoSubAddOpt := True;
                       end
                   end;
               end;
             else
               ;
           end;
      end;


    function TX86AsmOptimizer.OptPass1Sub(var p : tai) : boolean;
{$ifdef i386}
      var
        hp1 : tai;
{$endif i386}
      begin
        Result:=false;
        { * change "subl $2, %esp; pushw x" to "pushl x"}
        { * change "sub/add const1, reg" or "dec reg" followed by
            "sub const2, reg" to one "sub ..., reg" }
        if MatchOpType(taicpu(p),top_const,top_reg) then
          begin
{$ifdef i386}
            if (taicpu(p).oper[0]^.val = 2) and
               (taicpu(p).oper[1]^.reg = NR_ESP) and
               { Don't do the sub/push optimization if the sub }
               { comes from setting up the stack frame (JM)    }
               (not(GetLastInstruction(p,hp1)) or
               not(MatchInstruction(hp1,A_MOV,[S_L]) and
                 MatchOperand(taicpu(hp1).oper[0]^,NR_ESP) and
                 MatchOperand(taicpu(hp1).oper[0]^,NR_EBP))) then
              begin
                hp1 := tai(p.next);
                while Assigned(hp1) and
                      (tai(hp1).typ in [ait_instruction]+SkipInstr) and
                      not RegReadByInstruction(NR_ESP,hp1) and
                      not RegModifiedByInstruction(NR_ESP,hp1) do
                  hp1 := tai(hp1.next);
                if Assigned(hp1) and
                  MatchInstruction(hp1,A_PUSH,[S_W]) then
                  begin
                    taicpu(hp1).changeopsize(S_L);
                    if taicpu(hp1).oper[0]^.typ=top_reg then
                      setsubreg(taicpu(hp1).oper[0]^.reg,R_SUBWHOLE);
                    hp1 := tai(p.next);
                    RemoveCurrentp(p, hp1);
                    Result:=true;
                    exit;
                  end;
              end;
{$endif i386}
            if DoSubAddOpt(p) then
              Result:=true;
          end;
      end;


    function TX86AsmOptimizer.OptPass1SHLSAL(var p : tai) : boolean;
      var
        TmpBool1,TmpBool2 : Boolean;
        tmpref : treference;
        hp1,hp2: tai;
        mask:    tcgint;
      begin
        Result:=false;

        { All these optimisations work on "shl/sal const,%reg" }
        if not MatchOpType(taicpu(p),top_const,top_reg) then
          Exit;

        if (taicpu(p).opsize in [S_L{$ifdef x86_64},S_Q{$endif x86_64}]) and
           (taicpu(p).oper[0]^.val <= 3) then
          { Changes "shl const, %reg32; add const/reg, %reg32" to one lea statement }
          begin
            { should we check the next instruction? }
            TmpBool1 := True;
            { have we found an add/sub which could be
              integrated in the lea? }
            TmpBool2 := False;
            reference_reset(tmpref,2,[]);
            TmpRef.index := taicpu(p).oper[1]^.reg;
            TmpRef.scalefactor := 1 shl taicpu(p).oper[0]^.val;
            while TmpBool1 and
                  GetNextInstruction(p, hp1) and
                  (tai(hp1).typ = ait_instruction) and
                  ((((taicpu(hp1).opcode = A_ADD) or
                     (taicpu(hp1).opcode = A_SUB)) and
                    (taicpu(hp1).oper[1]^.typ = Top_Reg) and
                    (taicpu(hp1).oper[1]^.reg = taicpu(p).oper[1]^.reg)) or
                   (((taicpu(hp1).opcode = A_INC) or
                     (taicpu(hp1).opcode = A_DEC)) and
                    (taicpu(hp1).oper[0]^.typ = Top_Reg) and
                    (taicpu(hp1).oper[0]^.reg = taicpu(p).oper[1]^.reg)) or
                    ((taicpu(hp1).opcode = A_LEA) and
                    (taicpu(hp1).oper[0]^.ref^.index = taicpu(p).oper[1]^.reg) and
                    (taicpu(hp1).oper[1]^.reg = taicpu(p).oper[1]^.reg))) and
                  (not GetNextInstruction(hp1,hp2) or
                   not instrReadsFlags(hp2)) Do
              begin
                TmpBool1 := False;
                if taicpu(hp1).opcode=A_LEA then
                  begin
                    if (TmpRef.base = NR_NO) and
                       (taicpu(hp1).oper[0]^.ref^.symbol=nil) and
                       (taicpu(hp1).oper[0]^.ref^.relsymbol=nil) and
                       (taicpu(hp1).oper[0]^.ref^.segment=NR_NO) and
                       ((taicpu(hp1).oper[0]^.ref^.scalefactor=0) or
                       (taicpu(hp1).oper[0]^.ref^.scalefactor*tmpref.scalefactor<=8)) then
                      begin
                        TmpBool1 := True;
                        TmpBool2 := True;
                        inc(TmpRef.offset, taicpu(hp1).oper[0]^.ref^.offset);
                        if taicpu(hp1).oper[0]^.ref^.scalefactor<>0 then
                          tmpref.scalefactor:=tmpref.scalefactor*taicpu(hp1).oper[0]^.ref^.scalefactor;
                        TmpRef.base := taicpu(hp1).oper[0]^.ref^.base;
                        RemoveInstruction(hp1);
                      end
                  end
                else if (taicpu(hp1).oper[0]^.typ = Top_Const) then
                  begin
                    TmpBool1 := True;
                    TmpBool2 := True;
                    case taicpu(hp1).opcode of
                      A_ADD:
                        inc(TmpRef.offset, longint(taicpu(hp1).oper[0]^.val));
                      A_SUB:
                        dec(TmpRef.offset, longint(taicpu(hp1).oper[0]^.val));
                      else
                        internalerror(2019050536);
                    end;
                    RemoveInstruction(hp1);
                  end
                else
                  if (taicpu(hp1).oper[0]^.typ = Top_Reg) and
                     (((taicpu(hp1).opcode = A_ADD) and
                       (TmpRef.base = NR_NO)) or
                      (taicpu(hp1).opcode = A_INC) or
                      (taicpu(hp1).opcode = A_DEC)) then
                    begin
                      TmpBool1 := True;
                      TmpBool2 := True;
                      case taicpu(hp1).opcode of
                        A_ADD:
                          TmpRef.base := taicpu(hp1).oper[0]^.reg;
                        A_INC:
                          inc(TmpRef.offset);
                        A_DEC:
                          dec(TmpRef.offset);
                        else
                          internalerror(2019050535);
                      end;
                      RemoveInstruction(hp1);
                    end;
              end;
            if TmpBool2
{$ifndef x86_64}
               or
               ((current_settings.optimizecputype < cpu_Pentium2) and
               (taicpu(p).oper[0]^.val <= 3) and
               not(cs_opt_size in current_settings.optimizerswitches))
{$endif x86_64}
              then
              begin
                if not(TmpBool2) and
                    (taicpu(p).oper[0]^.val=1) then
                  begin
                    hp1:=taicpu.Op_reg_reg(A_ADD,taicpu(p).opsize,
                      taicpu(p).oper[1]^.reg, taicpu(p).oper[1]^.reg)
                  end
                else
                  hp1:=taicpu.op_ref_reg(A_LEA, taicpu(p).opsize, TmpRef,
                              taicpu(p).oper[1]^.reg);
                DebugMsg(SPeepholeOptimization + 'ShlAddLeaSubIncDec2Lea',p);
                InsertLLItem(p.previous, p.next, hp1);
                p.free;
                p := hp1;
              end;
          end
{$ifndef x86_64}
        else if (current_settings.optimizecputype < cpu_Pentium2) then
          begin
            { changes "shl $1, %reg" to "add %reg, %reg", which is the same on a 386,
              but faster on a 486, and Tairable in both U and V pipes on the Pentium
              (unlike shl, which is only Tairable in the U pipe) }
            if taicpu(p).oper[0]^.val=1 then
                begin
                  hp1 := taicpu.Op_reg_reg(A_ADD,taicpu(p).opsize,
                            taicpu(p).oper[1]^.reg, taicpu(p).oper[1]^.reg);
                  InsertLLItem(p.previous, p.next, hp1);
                  p.free;
                  p := hp1;
                end
           { changes "shl $2, %reg" to "lea (,%reg,4), %reg"
             "shl $3, %reg" to "lea (,%reg,8), %reg }
           else if (taicpu(p).opsize = S_L) and
                   (taicpu(p).oper[0]^.val<= 3) then
             begin
               reference_reset(tmpref,2,[]);
               TmpRef.index := taicpu(p).oper[1]^.reg;
               TmpRef.scalefactor := 1 shl taicpu(p).oper[0]^.val;
               hp1 := taicpu.Op_ref_reg(A_LEA,S_L,TmpRef, taicpu(p).oper[1]^.reg);
               InsertLLItem(p.previous, p.next, hp1);
               p.free;
               p := hp1;
             end;
          end
{$endif x86_64}
        else if
          GetNextInstruction(p, hp1) and (hp1.typ = ait_instruction) and MatchOpType(taicpu(hp1), top_const, top_reg) and
          (
            (
              MatchInstruction(hp1, A_AND, [taicpu(p).opsize]) and
              SetAndTest(hp1, hp2)
{$ifdef x86_64}
            ) or
            (
              MatchInstruction(hp1, A_MOV, [taicpu(p).opsize]) and
              GetNextInstruction(hp1, hp2) and
              MatchInstruction(hp2, A_AND, [taicpu(p).opsize]) and
              MatchOpType(taicpu(hp2), top_reg, top_reg) and
              (taicpu(hp1).oper[1]^.reg = taicpu(hp2).oper[0]^.reg)
{$endif x86_64}
            )
          ) and
          (taicpu(p).oper[1]^.reg = taicpu(hp2).oper[1]^.reg) then
          begin
            { Change:
                shl x, %reg1
                mov -(1<<x), %reg2
                and %reg2, %reg1

              Or:
                shl x, %reg1
                and -(1<<x), %reg1

              To just:
                shl x, %reg1

              Since the and operation only zeroes bits that are already zero from the shl operation
            }
            case taicpu(p).oper[0]^.val of
               8:
                 mask:=$FFFFFFFFFFFFFF00;
               16:
                 mask:=$FFFFFFFFFFFF0000;
               32:
                 mask:=$FFFFFFFF00000000;
               63:
                 { Constant pre-calculated to prevent overflow errors with Int64 }
                 mask:=$8000000000000000;
               else
                 begin
                   if taicpu(p).oper[0]^.val >= 64 then
                     { Shouldn't happen realistically, since the register
                       is guaranteed to be set to zero at this point }
                     mask := 0
                   else
                     mask := -(Int64(1 shl taicpu(p).oper[0]^.val));
                 end;
            end;

            if taicpu(hp1).oper[0]^.val = mask then
              begin
                { Everything checks out, perform the optimisation, as long as
                  the FLAGS register isn't being used}
                TransferUsedRegs(TmpUsedRegs);
                UpdateUsedRegs(TmpUsedRegs, tai(p.next));

{$ifdef x86_64}
                if (hp1 <> hp2) then
                  begin
                    { "shl/mov/and" version }
                    UpdateUsedRegs(TmpUsedRegs, tai(hp1.next));

                    { Don't do the optimisation if the FLAGS register is in use }
                    if not(RegUsedAfterInstruction(NR_DEFAULTFLAGS, hp2, TmpUsedRegs)) then
                      begin
                        DebugMsg(SPeepholeOptimization + 'ShlMovAnd2Shl', p);
                        { Don't remove the 'mov' instruction if its register is used elsewhere }
                        if not(RegUsedAfterInstruction(taicpu(hp1).oper[1]^.reg, hp2, TmpUsedRegs)) then
                          begin
                            RemoveInstruction(hp1);
                            Result := True;
                          end;

                        { Only set Result to True if the 'mov' instruction was removed }
                        RemoveInstruction(hp2);
                      end;
                  end
                else
{$endif x86_64}
                  begin
                    { "shl/and" version }

                    { Don't do the optimisation if the FLAGS register is in use }
                    if not(RegUsedAfterInstruction(NR_DEFAULTFLAGS, hp1, TmpUsedRegs)) then
                      begin
                        DebugMsg(SPeepholeOptimization + 'ShlAnd2Shl', p);
                        RemoveInstruction(hp1);
                        Result := True;
                      end;
                  end;

                Exit;
              end
            else {$ifdef x86_64}if (hp1 = hp2) then{$endif x86_64}
              begin
                { Even if the mask doesn't allow for its removal, we might be
                  able to optimise the mask for the "shl/and" version, which
                  may permit other peephole optimisations }
{$ifdef DEBUG_AOPTCPU}
                mask := taicpu(hp1).oper[0]^.val and mask;
                if taicpu(hp1).oper[0]^.val <> mask then
                  begin
                    DebugMsg(
                      SPeepholeOptimization +
                      'Changed mask from $' + debug_tostr(taicpu(hp1).oper[0]^.val) +
                      ' to $' + debug_tostr(mask) +
                      'based on previous instruction (ShlAnd2ShlAnd)', hp1);
                    taicpu(hp1).oper[0]^.val := mask;
                  end;
{$else DEBUG_AOPTCPU}
                { If debugging is off, just set the operand even if it's the same }
                taicpu(hp1).oper[0]^.val := taicpu(hp1).oper[0]^.val and mask;
{$endif DEBUG_AOPTCPU}
              end;

          end;
      end;


    function TX86AsmOptimizer.CheckMemoryWrite(var first_mov, second_mov: taicpu): Boolean;
      var
        CurrentRef: TReference;
        FullReg: TRegister;
        hp1, hp2: tai;
      begin
        Result := False;
        if (first_mov.opsize <> S_B) or (second_mov.opsize <> S_B) then
          Exit;

        { We assume you've checked if the operand is actually a reference by
          this point. If it isn't, you'll most likely get an access violation }
        CurrentRef := first_mov.oper[1]^.ref^;

        { Memory must be aligned }
        if (CurrentRef.offset mod 4) <> 0 then
          Exit;

        Inc(CurrentRef.offset);
        CurrentRef.alignment := 1; { Otherwise references_equal will return False }

        if MatchOperand(second_mov.oper[0]^, 0) and
          references_equal(second_mov.oper[1]^.ref^, CurrentRef) and
          GetNextInstruction(second_mov, hp1) and
          (hp1.typ = ait_instruction) and
          (taicpu(hp1).opcode = A_MOV) and
          MatchOpType(taicpu(hp1), top_const, top_ref) and
          (taicpu(hp1).oper[0]^.val = 0) then
          begin
            Inc(CurrentRef.offset);
            CurrentRef.alignment := taicpu(hp1).oper[1]^.ref^.alignment; { Otherwise references_equal might return False }

            FullReg := newreg(R_INTREGISTER,getsupreg(first_mov.oper[0]^.reg), R_SUBD);

            if references_equal(taicpu(hp1).oper[1]^.ref^, CurrentRef) then
              begin
                case taicpu(hp1).opsize of
                  S_B:
                    if GetNextInstruction(hp1, hp2) and
                      MatchInstruction(taicpu(hp2), A_MOV, [S_B]) and
                      MatchOpType(taicpu(hp2), top_const, top_ref) and
                      (taicpu(hp2).oper[0]^.val = 0) then
                      begin
                        Inc(CurrentRef.offset);
                        CurrentRef.alignment := 1; { Otherwise references_equal will return False }

                        if references_equal(taicpu(hp2).oper[1]^.ref^, CurrentRef) and
                          (taicpu(hp2).opsize = S_B) then
                          begin
                            RemoveInstruction(hp1);
                            RemoveInstruction(hp2);

                            first_mov.opsize := S_L;

                            if first_mov.oper[0]^.typ = top_reg then
                              begin
                                DebugMsg(SPeepholeOptimization + 'MOVb/MOVb/MOVb/MOVb -> MOVZX/MOVl', first_mov);

                                { Reuse second_mov as a MOVZX instruction }
                                second_mov.opcode := A_MOVZX;
                                second_mov.opsize := S_BL;
                                second_mov.loadreg(0, first_mov.oper[0]^.reg);
                                second_mov.loadreg(1, FullReg);

                                first_mov.oper[0]^.reg := FullReg;

                                asml.Remove(second_mov);
                                asml.InsertBefore(second_mov, first_mov);
                              end
                            else
                              { It's a value }
                              begin
                                DebugMsg(SPeepholeOptimization + 'MOVb/MOVb/MOVb/MOVb -> MOVl', first_mov);
                                RemoveInstruction(second_mov);
                              end;

                            Result := True;
                            Exit;
                          end;
                      end;
                  S_W:
                    begin
                      RemoveInstruction(hp1);

                      first_mov.opsize := S_L;

                      if first_mov.oper[0]^.typ = top_reg then
                        begin
                          DebugMsg(SPeepholeOptimization + 'MOVb/MOVb/MOVw -> MOVZX/MOVl', first_mov);

                          { Reuse second_mov as a MOVZX instruction }
                          second_mov.opcode := A_MOVZX;
                          second_mov.opsize := S_BL;
                          second_mov.loadreg(0, first_mov.oper[0]^.reg);
                          second_mov.loadreg(1, FullReg);

                          first_mov.oper[0]^.reg := FullReg;

                          asml.Remove(second_mov);
                          asml.InsertBefore(second_mov, first_mov);
                        end
                      else
                        { It's a value }
                        begin
                          DebugMsg(SPeepholeOptimization + 'MOVb/MOVb/MOVw -> MOVl', first_mov);
                          RemoveInstruction(second_mov);
                        end;

                      Result := True;
                      Exit;
                    end;
                  else
                    ;
                end;
              end;
          end;
      end;


    function TX86AsmOptimizer.OptPass1FSTP(var p: tai): boolean;
      { returns true if a "continue" should be done after this optimization }
      var
        hp1, hp2: tai;
      begin
        Result := false;
        if MatchOpType(taicpu(p),top_ref) and
           GetNextInstruction(p, hp1) and
           (hp1.typ = ait_instruction) and
           (((taicpu(hp1).opcode = A_FLD) and
             (taicpu(p).opcode = A_FSTP)) or
            ((taicpu(p).opcode = A_FISTP) and
             (taicpu(hp1).opcode = A_FILD))) and
           MatchOpType(taicpu(hp1),top_ref) and
           (taicpu(hp1).opsize = taicpu(p).opsize) and
           RefsEqual(taicpu(p).oper[0]^.ref^, taicpu(hp1).oper[0]^.ref^) then
          begin
            { replacing fstp f;fld f by fst f is only valid for extended because of rounding or if fastmath is on }
            if ((taicpu(p).opsize=S_FX) or (cs_opt_fastmath in current_settings.optimizerswitches)) and
               GetNextInstruction(hp1, hp2) and
               (hp2.typ = ait_instruction) and
               IsExitCode(hp2) and
               (taicpu(p).oper[0]^.ref^.base = current_procinfo.FramePointer) and
               not(assigned(current_procinfo.procdef.funcretsym) and
                   (taicpu(p).oper[0]^.ref^.offset < tabstractnormalvarsym(current_procinfo.procdef.funcretsym).localloc.reference.offset)) and
               (taicpu(p).oper[0]^.ref^.index = NR_NO) then
              begin
                RemoveInstruction(hp1);
                RemoveCurrentP(p, hp2);
                RemoveLastDeallocForFuncRes(p);
                Result := true;
              end
            else
              { we can do this only in fast math mode as fstp is rounding ...
                ... still disabled as it breaks the compiler and/or rtl }
              if ({ (cs_opt_fastmath in current_settings.optimizerswitches) or }
                { ... or if another fstp equal to the first one follows }
                (GetNextInstruction(hp1,hp2) and
                (hp2.typ = ait_instruction) and
                (taicpu(p).opcode=taicpu(hp2).opcode) and
                (taicpu(p).opsize=taicpu(hp2).opsize))
                ) and
                { fst can't store an extended/comp value }
                (taicpu(p).opsize <> S_FX) and
                (taicpu(p).opsize <> S_IQ) then
                begin
                  if (taicpu(p).opcode = A_FSTP) then
                    taicpu(p).opcode := A_FST
                  else
                    taicpu(p).opcode := A_FIST;
                  DebugMsg(SPeepholeOptimization + 'FstpFld2Fst',p);
                  RemoveInstruction(hp1);
                end;
          end;
      end;


     function TX86AsmOptimizer.OptPass1FLD(var p : tai) : boolean;
      var
       hp1, hp2: tai;
      begin
        result:=false;
        if MatchOpType(taicpu(p),top_reg) and
           GetNextInstruction(p, hp1) and
           (hp1.typ = Ait_Instruction) and
           MatchOpType(taicpu(hp1),top_reg,top_reg) and
           (taicpu(hp1).oper[0]^.reg = NR_ST) and
           (taicpu(hp1).oper[1]^.reg = NR_ST1) then
           { change                        to
               fld      reg               fxxx reg,st
               fxxxp    st, st1 (hp1)
             Remark: non commutative operations must be reversed!
           }
          begin
              case taicpu(hp1).opcode Of
                A_FMULP,A_FADDP,
                A_FSUBP,A_FDIVP,A_FSUBRP,A_FDIVRP:
                  begin
                    case taicpu(hp1).opcode Of
                      A_FADDP: taicpu(hp1).opcode := A_FADD;
                      A_FMULP: taicpu(hp1).opcode := A_FMUL;
                      A_FSUBP: taicpu(hp1).opcode := A_FSUBR;
                      A_FSUBRP: taicpu(hp1).opcode := A_FSUB;
                      A_FDIVP: taicpu(hp1).opcode := A_FDIVR;
                      A_FDIVRP: taicpu(hp1).opcode := A_FDIV;
                      else
                        internalerror(2019050534);
                    end;
                    taicpu(hp1).oper[0]^.reg := taicpu(p).oper[0]^.reg;
                    taicpu(hp1).oper[1]^.reg := NR_ST;
                    RemoveCurrentP(p, hp1);
                    Result:=true;
                    exit;
                  end;
                else
                  ;
              end;
          end
        else
          if MatchOpType(taicpu(p),top_ref) and
             GetNextInstruction(p, hp2) and
             (hp2.typ = Ait_Instruction) and
             MatchOpType(taicpu(hp2),top_reg,top_reg) and
             (taicpu(p).opsize in [S_FS, S_FL]) and
             (taicpu(hp2).oper[0]^.reg = NR_ST) and
             (taicpu(hp2).oper[1]^.reg = NR_ST1) then
            if GetLastInstruction(p, hp1) and
              MatchInstruction(hp1,A_FLD,A_FST,[taicpu(p).opsize]) and
              MatchOpType(taicpu(hp1),top_ref) and
              RefsEqual(taicpu(p).oper[0]^.ref^, taicpu(hp1).oper[0]^.ref^) then
              if ((taicpu(hp2).opcode = A_FMULP) or
                  (taicpu(hp2).opcode = A_FADDP)) then
              { change                      to
                  fld/fst   mem1  (hp1)       fld/fst   mem1
                  fld       mem1  (p)         fadd/
                  faddp/                       fmul     st, st
                  fmulp  st, st1 (hp2) }
                begin
                  RemoveCurrentP(p, hp1);
                  if (taicpu(hp2).opcode = A_FADDP) then
                    taicpu(hp2).opcode := A_FADD
                  else
                    taicpu(hp2).opcode := A_FMUL;
                  taicpu(hp2).oper[1]^.reg := NR_ST;
                end
              else
              { change              to
                  fld/fst mem1 (hp1)   fld/fst mem1
                  fld     mem1 (p)     fld      st}
                begin
                  taicpu(p).changeopsize(S_FL);
                  taicpu(p).loadreg(0,NR_ST);
                end
            else
              begin
                case taicpu(hp2).opcode Of
                  A_FMULP,A_FADDP,A_FSUBP,A_FDIVP,A_FSUBRP,A_FDIVRP:
            { change                        to
                fld/fst  mem1    (hp1)      fld/fst    mem1
                fld      mem2    (p)        fxxx       mem2
                fxxxp    st, st1 (hp2)                      }

                    begin
                      case taicpu(hp2).opcode Of
                        A_FADDP: taicpu(p).opcode := A_FADD;
                        A_FMULP: taicpu(p).opcode := A_FMUL;
                        A_FSUBP: taicpu(p).opcode := A_FSUBR;
                        A_FSUBRP: taicpu(p).opcode := A_FSUB;
                        A_FDIVP: taicpu(p).opcode := A_FDIVR;
                        A_FDIVRP: taicpu(p).opcode := A_FDIV;
                        else
                          internalerror(2019050533);
                      end;
                      RemoveInstruction(hp2);
                    end
                  else
                    ;
                end
              end
      end;


     function TX86AsmOptimizer.OptPass1Cmp(var p: tai): boolean;
       var
         v: TCGInt;
         hp1, hp2: tai;
         FirstMatch: Boolean;
       begin
         Result:=false;

         if taicpu(p).oper[0]^.typ = top_const then
           begin
             { Though GetNextInstruction can be factored out, it is an expensive
               call, so delay calling it until we have first checked cheaper
               conditions that are independent of it. }

             if (taicpu(p).oper[0]^.val = 0) and
               (taicpu(p).oper[1]^.typ = top_reg) and
               GetNextInstruction(p, hp1) and
               MatchInstruction(hp1,A_Jcc,A_SETcc,[]) then
               begin
                 hp2 := p;
                 FirstMatch := True;
                 { When dealing with "cmp $0,%reg", only ZF and SF contain
                   anything meaningful once it's converted to "test %reg,%reg";
                   additionally, some jumps will always (or never) branch, so
                   evaluate every jump immediately following the
                   comparison, optimising the conditions if possible.
                   Similarly with SETcc... those that are always set to 0 or 1
                   are changed to MOV instructions }
                 while FirstMatch or { Saves calling GetNextInstruction unnecessarily }
                   (
                     GetNextInstruction(hp2, hp1) and
                     MatchInstruction(hp1,A_Jcc,A_SETcc,[])
                   ) do
                   begin
                     FirstMatch := False;
                     case taicpu(hp1).condition of
                       C_B, C_C, C_NAE, C_O:
                         { For B/NAE:
                             Will never branch since an unsigned integer can never be below zero
                           For C/O:
                             Result cannot overflow because 0 is being subtracted
                         }
                         begin
                           if taicpu(hp1).opcode = A_Jcc then
                             begin
                               DebugMsg(SPeepholeOptimization + 'Cmpcc2Testcc - condition B/C/NAE/O --> Never (jump removed)', hp1);
                               TAsmLabel(taicpu(hp1).oper[0]^.ref^.symbol).decrefs;
                               RemoveInstruction(hp1);
                               { Since hp1 was deleted, hp2 must not be updated }
                               Continue;
                             end
                           else
                             begin
                               DebugMsg(SPeepholeOptimization + 'Cmpcc2Testcc - condition B/C/NAE/O --> Never (set -> mov 0)', hp1);
                               { Convert "set(c) %reg" instruction to "movb 0,%reg" }
                               taicpu(hp1).opcode := A_MOV;
                               taicpu(hp1).ops := 2;
                               taicpu(hp1).condition := C_None;
                               taicpu(hp1).opsize := S_B;
                               taicpu(hp1).loadreg(1,taicpu(hp1).oper[0]^.reg);
                               taicpu(hp1).loadconst(0, 0);
                             end;
                         end;
                       C_BE, C_NA:
                         begin
                           { Will only branch if equal to zero }
                           DebugMsg(SPeepholeOptimization + 'Cmpcc2Testcc - condition BE/NA --> E', hp1);
                           taicpu(hp1).condition := C_E;
                         end;
                       C_A, C_NBE:
                         begin
                           { Will only branch if not equal to zero }
                           DebugMsg(SPeepholeOptimization + 'Cmpcc2Testcc - condition A/NBE --> NE', hp1);
                           taicpu(hp1).condition := C_NE;
                         end;
                       C_AE, C_NB, C_NC, C_NO:
                         begin
                           { Will always branch }
                           DebugMsg(SPeepholeOptimization + 'Cmpcc2Testcc - condition AE/NB/NC/NO --> Always', hp1);
                           if taicpu(hp1).opcode = A_Jcc then
                             begin
                               MakeUnconditional(taicpu(hp1));
                               { Any jumps/set that follow will now be dead code }
                               RemoveDeadCodeAfterJump(taicpu(hp1));
                               Break;
                             end
                           else
                             begin
                               { Convert "set(c) %reg" instruction to "movb 1,%reg" }
                               taicpu(hp1).opcode := A_MOV;
                               taicpu(hp1).ops := 2;
                               taicpu(hp1).condition := C_None;
                               taicpu(hp1).opsize := S_B;
                               taicpu(hp1).loadreg(1,taicpu(hp1).oper[0]^.reg);
                               taicpu(hp1).loadconst(0, 1);
                             end;
                         end;
                       C_None:
                         InternalError(2020012201);
                       C_P, C_PE, C_NP, C_PO:
                         { We can't handle parity checks and they should never be generated
                           after a general-purpose CMP (it's used in some floating-point
                           comparisons that don't use CMP) }
                         InternalError(2020012202);
                       else
                         { Zero/Equality, Sign, their complements and all of the
                           signed comparisons do not need to be converted };
                     end;
                     hp2 := hp1;
                   end;

                 { Convert the instruction to a TEST }

                 taicpu(p).opcode := A_TEST;
                 taicpu(p).loadreg(0,taicpu(p).oper[1]^.reg);
                 Result := True;
                 Exit;
               end
             else if (taicpu(p).oper[0]^.val = 1) and
               GetNextInstruction(p, hp1) and
               MatchInstruction(hp1,A_Jcc,A_SETcc,[]) and
               (taicpu(hp1).condition in [C_L, C_NGE]) then
               begin
                 { Convert;       To:
                     cmp $1,r/m     cmp $0,r/m
                     jl  @lbl       jle @lbl
                 }
                 DebugMsg(SPeepholeOptimization + 'Cmp1Jl2Cmp0Jle', p);
                 taicpu(p).oper[0]^.val := 0;
                 taicpu(hp1).condition := C_LE;

                 { If the instruction is now "cmp $0,%reg", convert it to a
                   TEST (and effectively do the work of the "cmp $0,%reg" in
                   the block above)

                   If it's a reference, we can get away with not setting
                   Result to True because he haven't evaluated the jump
                   in this pass yet.
                 }
                 if (taicpu(p).oper[1]^.typ = top_reg) then
                   begin
                     taicpu(p).opcode := A_TEST;
                     taicpu(p).loadreg(0,taicpu(p).oper[1]^.reg);
                     Result := True;
                   end;

                 Exit;
               end
             else if (taicpu(p).oper[1]^.typ = top_reg) then
               begin
                 { cmp register,$8000                neg register
                   je target                 -->     jo target

                   .... only if register is deallocated before jump.}
                 case Taicpu(p).opsize of
                   S_B: v:=$80;
                   S_W: v:=$8000;
                   S_L: v:=qword($80000000);
                   { S_Q will never happen: cmp with 64 bit constants is not possible }
                   S_Q:
                     Exit;
                   else
                     internalerror(2013112905);
                 end;

                 if (taicpu(p).oper[0]^.val=v) and
                    GetNextInstruction(p, hp1) and
                    MatchInstruction(hp1,A_Jcc,A_SETcc,[]) and
                    (Taicpu(hp1).condition in [C_E,C_NE]) then
                   begin
                     TransferUsedRegs(TmpUsedRegs);
                     UpdateUsedRegs(TmpUsedRegs,tai(p.next));
                     if not(RegInUsedRegs(Taicpu(p).oper[1]^.reg, TmpUsedRegs)) then
                       begin
                         DebugMsg(SPeepholeOptimization + 'CmpJe2NegJo done',p);
                         Taicpu(p).opcode:=A_NEG;
                         Taicpu(p).loadoper(0,Taicpu(p).oper[1]^);
                         Taicpu(p).clearop(1);
                         Taicpu(p).ops:=1;
                         if Taicpu(hp1).condition=C_E then
                           Taicpu(hp1).condition:=C_O
                         else
                           Taicpu(hp1).condition:=C_NO;
                         Result:=true;
                         exit;
                       end;
                   end;
               end;
           end;

         if (taicpu(p).oper[1]^.typ = top_reg) and
           GetNextInstruction(p, hp1) and
           MatchInstruction(hp1,A_MOV,[]) and
           not RegInInstruction(taicpu(p).oper[1]^.reg, hp1) and
           (
             (taicpu(p).oper[0]^.typ <> top_reg) or
             not RegInInstruction(taicpu(p).oper[0]^.reg, hp1)
           ) then
           begin
             { If we have something like:
                 cmp ###,%reg1
                 mov 0,%reg2

               And no registers are shared, move the MOV command to before the
               comparison as this means it can be optimised without worrying
               about the FLAGS register. (This combination is generated by
               "J(c)Mov1JmpMov0 -> Set(~c)", among other things).
             }
             SwapMovCmp(p, hp1);
             Result := True;
             Exit;
           end;
     end;


   function TX86AsmOptimizer.OptPass1PXor(var p: tai): boolean;
     var
       hp1: tai;
     begin
       {
         remove the second (v)pxor from

           pxor reg,reg
           ...
           pxor reg,reg
       }
       Result:=false;
       if MatchOperand(taicpu(p).oper[0]^,taicpu(p).oper[1]^) and
         MatchOpType(taicpu(p),top_reg,top_reg) and
         GetNextInstructionUsingReg(p,hp1,taicpu(p).oper[0]^.reg) and
         MatchInstruction(hp1,taicpu(p).opcode,[taicpu(p).opsize]) and
         MatchOperand(taicpu(p).oper[0]^,taicpu(hp1).oper[0]^) and
         MatchOperand(taicpu(hp1).oper[0]^,taicpu(hp1).oper[1]^) then
         begin
           DebugMsg(SPeepholeOptimization + 'PXorPXor2PXor done',hp1);
           RemoveInstruction(hp1);
           Result:=true;
           Exit;
         end
        {
           replace
             pxor reg1,reg1
             movapd/s reg1,reg2
             dealloc reg1

             by

             pxor reg2,reg2
        }
        else if GetNextInstruction(p,hp1) and
          { we mix single and double opperations here because we assume that the compiler
            generates vmovapd only after double operations and vmovaps only after single operations }
          MatchInstruction(hp1,A_MOVAPD,A_MOVAPS,[S_NO]) and
          MatchOperand(taicpu(p).oper[0]^,taicpu(p).oper[1]^) and
          MatchOperand(taicpu(p).oper[1]^,taicpu(hp1).oper[0]^) and
          (taicpu(p).oper[0]^.typ=top_reg) then
          begin
            TransferUsedRegs(TmpUsedRegs);
            UpdateUsedRegs(TmpUsedRegs, tai(p.next));
            if not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp1,TmpUsedRegs)) then
              begin
                taicpu(p).loadoper(0,taicpu(hp1).oper[1]^);
                taicpu(p).loadoper(1,taicpu(hp1).oper[1]^);
                DebugMsg(SPeepholeOptimization + 'PXorMovapd2PXor done',p);
                RemoveInstruction(hp1);
                result:=true;
              end;
          end;

     end;


   function TX86AsmOptimizer.OptPass1VPXor(var p: tai): boolean;
     var
       hp1: tai;
     begin
       {
         remove the second (v)pxor from

           (v)pxor reg,reg
           ...
           (v)pxor reg,reg
       }
       Result:=false;
       if MatchOperand(taicpu(p).oper[0]^,taicpu(p).oper[1]^,taicpu(p).oper[2]^) and
         MatchOpType(taicpu(p),top_reg,top_reg,top_reg) and
         GetNextInstructionUsingReg(p,hp1,taicpu(p).oper[0]^.reg) and
         MatchInstruction(hp1,taicpu(p).opcode,[taicpu(p).opsize]) and
         MatchOperand(taicpu(p).oper[0]^,taicpu(hp1).oper[0]^) and
         MatchOperand(taicpu(hp1).oper[0]^,taicpu(hp1).oper[1]^,taicpu(hp1).oper[2]^) then
         begin
           DebugMsg(SPeepholeOptimization + 'VPXorVPXor2PXor done',hp1);
           RemoveInstruction(hp1);
           Result:=true;
           Exit;
         end
       else
         Result:=OptPass1VOP(p);
     end;


   function TX86AsmOptimizer.OptPass1Imul(var p: tai): boolean;
     var
       hp1 : tai;
     begin
       result:=false;
       { replace
           IMul   const,%mreg1,%mreg2
           Mov    %reg2,%mreg3
           dealloc  %mreg3

           by
           Imul   const,%mreg1,%mreg23
       }
       if (taicpu(p).ops=3) and
         GetNextInstruction(p,hp1) and
         MatchInstruction(hp1,A_MOV,[taicpu(p).opsize]) and
         MatchOperand(taicpu(p).oper[2]^,taicpu(hp1).oper[0]^) and
         (taicpu(hp1).oper[1]^.typ=top_reg) then
         begin
           TransferUsedRegs(TmpUsedRegs);
           UpdateUsedRegs(TmpUsedRegs, tai(p.next));
           if not(RegUsedAfterInstruction(taicpu(hp1).oper[0]^.reg,hp1,TmpUsedRegs)) then
             begin
               taicpu(p).loadoper(2,taicpu(hp1).oper[1]^);
               DebugMsg(SPeepholeOptimization + 'ImulMov2Imul done',p);
               RemoveInstruction(hp1);
               result:=true;
             end;
         end;
     end;


   function TX86AsmOptimizer.OptPass1Jcc(var p : tai) : boolean;
     var
       hp1, hp2, hp3, hp4, hp5: tai;
       ThisReg: TRegister;
     begin
       Result := False;
       if not GetNextInstruction(p,hp1) or (hp1.typ <> ait_instruction) then
         Exit;

       {
           convert
           j<c>  .L1
           mov   1,reg
           jmp   .L2
         .L1
           mov   0,reg
         .L2

         into
           mov   0,reg
           set<not(c)> reg

         take care of alignment and that the mov 0,reg is not converted into a xor as this
         would destroy the flag contents

         Use MOVZX if size is preferred, since while mov 0,reg is bigger, it can be
         executed at the same time as a previous comparison.
           set<not(c)> reg
           movzx       reg, reg
       }

       if MatchInstruction(hp1,A_MOV,[]) and
         (taicpu(hp1).oper[0]^.typ = top_const) and
         (
           (
             (taicpu(hp1).oper[1]^.typ = top_reg)
{$ifdef i386}
             { Under i386, ESI, EDI, EBP and ESP
               don't have an 8-bit representation }
              and not (getsupreg(taicpu(hp1).oper[1]^.reg) in [RS_ESI, RS_EDI, RS_EBP, RS_ESP])

{$endif i386}
           ) or (
{$ifdef i386}
             (taicpu(hp1).oper[1]^.typ <> top_reg) and
{$endif i386}
             (taicpu(hp1).opsize = S_B)
           )
         ) and
         GetNextInstruction(hp1,hp2) and
         MatchInstruction(hp2,A_JMP,[]) and (taicpu(hp2).oper[0]^.ref^.refaddr=addr_full) and
         GetNextInstruction(hp2,hp3) and
         SkipAligns(hp3, hp3) and
         (hp3.typ=ait_label) and
         (tasmlabel(taicpu(p).oper[0]^.ref^.symbol)=tai_label(hp3).labsym) and
         GetNextInstruction(hp3,hp4) and
         MatchInstruction(hp4,A_MOV,[taicpu(hp1).opsize]) and
         (taicpu(hp4).oper[0]^.typ = top_const) and
         (
           ((taicpu(hp1).oper[0]^.val = 0) and (taicpu(hp4).oper[0]^.val = 1)) or
           ((taicpu(hp1).oper[0]^.val = 1) and (taicpu(hp4).oper[0]^.val = 0))
         ) and
         MatchOperand(taicpu(hp1).oper[1]^,taicpu(hp4).oper[1]^) and
         GetNextInstruction(hp4,hp5) and
         SkipAligns(hp5, hp5) and
         (hp5.typ=ait_label) and
         (tasmlabel(taicpu(hp2).oper[0]^.ref^.symbol)=tai_label(hp5).labsym) then
         begin
           if (taicpu(hp1).oper[0]^.val = 1) and (taicpu(hp4).oper[0]^.val = 0) then
             taicpu(p).condition := inverse_cond(taicpu(p).condition);

           tai_label(hp3).labsym.DecRefs;

           { If this isn't the only reference to the middle label, we can
             still make a saving - only that the first jump and everything
             that follows will remain. }
           if (tai_label(hp3).labsym.getrefs = 0) then
             begin
               if (taicpu(hp1).oper[0]^.val = 1) and (taicpu(hp4).oper[0]^.val = 0) then
                 DebugMsg(SPeepholeOptimization + 'J(c)Mov1JmpMov0 -> Set(~c)',p)
               else
                 DebugMsg(SPeepholeOptimization + 'J(c)Mov0JmpMov1 -> Set(c)',p);

               { remove jump, first label and second MOV (also catching any aligns) }
               repeat
                 if not GetNextInstruction(hp2, hp3) then
                   InternalError(2021040810);

                 RemoveInstruction(hp2);

                 hp2 := hp3;
               until hp2 = hp5;

               { Don't decrement reference count before the removal loop
                 above, otherwise GetNextInstruction won't stop on the
                 the label }
               tai_label(hp5).labsym.DecRefs;
             end
           else
             begin
               if (taicpu(hp1).oper[0]^.val = 1) and (taicpu(hp4).oper[0]^.val = 0) then
                 DebugMsg(SPeepholeOptimization + 'J(c)Mov1JmpMov0 -> Set(~c) (partial)',p)
               else
                 DebugMsg(SPeepholeOptimization + 'J(c)Mov0JmpMov1 -> Set(c) (partial)',p);
             end;

           taicpu(p).opcode:=A_SETcc;
           taicpu(p).opsize:=S_B;
           taicpu(p).is_jmp:=False;

           if taicpu(hp1).opsize=S_B then
             begin
               taicpu(p).loadoper(0, taicpu(hp1).oper[1]^);
               RemoveInstruction(hp1);
             end
           else
             begin
               { Will be a register because the size can't be S_B otherwise }
               ThisReg := newreg(R_INTREGISTER,getsupreg(taicpu(hp1).oper[1]^.reg), R_SUBL);
               taicpu(p).loadreg(0, ThisReg);

               if (cs_opt_size in current_settings.optimizerswitches) and IsMOVZXAcceptable then
                 begin
                   case taicpu(hp1).opsize of
                     S_W:
                       taicpu(hp1).opsize := S_BW;
                     S_L:
                       taicpu(hp1).opsize := S_BL;
{$ifdef x86_64}
                     S_Q:
                       begin
                         taicpu(hp1).opsize := S_BL;
                         { Change the destination register to 32-bit }
                         taicpu(hp1).loadreg(1, newreg(R_INTREGISTER,getsupreg(ThisReg), R_SUBD));
                       end;
{$endif x86_64}
                     else
                       InternalError(2021040820);
                   end;

                   taicpu(hp1).opcode := A_MOVZX;
                   taicpu(hp1).loadreg(0, ThisReg);
                 end
               else
                 begin
                   AllocRegBetween(NR_FLAGS,p,hp1,UsedRegs);

                   { hp1 is already a MOV instruction with the correct register }
                   taicpu(hp1).loadconst(0, 0);

                   { Inserting it right before p will guarantee that the flags are also tracked }
                   asml.Remove(hp1);
                   asml.InsertBefore(hp1, p);
                 end;
             end;

           Result:=true;
           exit;
         end
     end;


  function TX86AsmOptimizer.CheckJumpMovTransferOpt(var p: tai; hp1: tai; LoopCount: Integer; out Count: Integer): Boolean;
    var
      hp2, hp3, first_assignment: tai;
      IncCount, OperIdx: Integer;
      OrigLabel: TAsmLabel;
    begin
      Count := 0;
      Result := False;
      first_assignment := nil;
      if (LoopCount >= 20) then
        begin
          { Guard against infinite loops }
          Exit;
        end;
      if (taicpu(p).oper[0]^.typ <> top_ref) or
        (taicpu(p).oper[0]^.ref^.refaddr <> addr_full) or
        (taicpu(p).oper[0]^.ref^.base <> NR_NO) or
        (taicpu(p).oper[0]^.ref^.index <> NR_NO) or
        not (taicpu(p).oper[0]^.ref^.symbol is TAsmLabel) then
        Exit;

      OrigLabel := TAsmLabel(taicpu(p).oper[0]^.ref^.symbol);

      {
        change
               jmp .L1
               ...
           .L1:
               mov ##, ## ( multiple movs possible )
               jmp/ret
        into
               mov ##, ##
               jmp/ret
      }

      if not Assigned(hp1) then
        begin
          hp1 := GetLabelWithSym(OrigLabel);
          if not Assigned(hp1) or not SkipLabels(hp1, hp1) then
            Exit;

        end;

      hp2 := hp1;

      while Assigned(hp2) do
        begin
          if Assigned(hp2) and (hp2.typ in [ait_label, ait_align]) then
            SkipLabels(hp2,hp2);

          if not Assigned(hp2) or (hp2.typ <> ait_instruction) then
            Break;

          case taicpu(hp2).opcode of
            A_MOVSS:
              begin
                if taicpu(hp2).ops = 0 then
                  { Wrong MOVSS }
                  Break;
                Inc(Count);
                if Count >= 5 then
                  { Too many to be worthwhile }
                  Break;
                GetNextInstruction(hp2, hp2);
                Continue;
              end;
            A_MOV,
            A_MOVD,
            A_MOVQ,
            A_MOVSX,
{$ifdef x86_64}
            A_MOVSXD,
{$endif x86_64}
            A_MOVZX,
            A_MOVAPS,
            A_MOVUPS,
            A_MOVSD,
            A_MOVAPD,
            A_MOVUPD,
            A_MOVDQA,
            A_MOVDQU,
            A_VMOVSS,
            A_VMOVAPS,
            A_VMOVUPS,
            A_VMOVSD,
            A_VMOVAPD,
            A_VMOVUPD,
            A_VMOVDQA,
            A_VMOVDQU:
              begin
                Inc(Count);
                if Count >= 5 then
                  { Too many to be worthwhile }
                  Break;
                GetNextInstruction(hp2, hp2);
                Continue;
              end;
            A_JMP:
              begin
                { Guard against infinite loops }
                if taicpu(hp2).oper[0]^.ref^.symbol = OrigLabel then
                  Exit;

                { Analyse this jump first in case it also duplicates assignments }
                if CheckJumpMovTransferOpt(hp2, nil, LoopCount + 1, IncCount) then
                  begin
                    { Something did change! }
                    Result := True;

                    Inc(Count, IncCount);
                    if Count >= 5 then
                      begin
                        { Too many to be worthwhile }
                        Exit;
                      end;

                    if MatchInstruction(hp2, [A_JMP, A_RET], []) then
                      Break;
                  end;

                Result := True;
                Break;
              end;
            A_RET:
              begin
                Result := True;
                Break;
              end;
            else
              Break;
          end;
        end;

      if Result then
        begin
          { A count of zero can happen when CheckJumpMovTransferOpt is called recursively }
          if Count = 0 then
            begin
              Result := False;
              Exit;
            end;

          hp3 := p;
          DebugMsg(SPeepholeOptimization + 'Duplicated ' + debug_tostr(Count) + ' assignment(s) and redirected jump', p);
          while True do
            begin
              if Assigned(hp1) and (hp1.typ in [ait_label, ait_align]) then
                SkipLabels(hp1,hp1);

              if (hp1.typ <> ait_instruction) then
                InternalError(2021040720);

              case taicpu(hp1).opcode of
                A_JMP:
                  begin
                    { Change the original jump to the new destination }
                    OrigLabel.decrefs;
                    taicpu(hp1).oper[0]^.ref^.symbol.increfs;
                    taicpu(p).loadref(0, taicpu(hp1).oper[0]^.ref^);

                    { Set p to the first duplicated assignment so it can get optimised if needs be }
                    if not Assigned(first_assignment) then
                      InternalError(2021040810)
                    else
                      p := first_assignment;

                    Exit;
                  end;
                A_RET:
                  begin
                    { Now change the jump into a RET instruction }
                    ConvertJumpToRET(p, hp1);

                    { Set p to the first duplicated assignment so it can get optimised if needs be }
                    if not Assigned(first_assignment) then
                      InternalError(2021040811)
                    else
                      p := first_assignment;

                    Exit;
                  end;
                else
                  begin
                    { Duplicate the MOV instruction }
                    hp3:=tai(hp1.getcopy);
                    if first_assignment = nil then
                      first_assignment := hp3;

                    asml.InsertBefore(hp3, p);

                    { Make sure the compiler knows about any final registers written here }
                    for OperIdx := 0 to taicpu(hp3).ops - 1 do
                      with taicpu(hp3).oper[OperIdx]^ do
                        begin
                          case typ of
                            top_ref:
                              begin
                                if (ref^.base <> NR_NO) and
                                  (getsupreg(ref^.base) <> RS_ESP) and
                                  (getsupreg(ref^.base) <> RS_EBP)
                                  {$ifdef x86_64} and (ref^.base <> NR_RIP) {$endif x86_64}
                                  then
                                  AllocRegBetween(ref^.base, hp3, tai(p.Next), UsedRegs);
                                if (ref^.index <> NR_NO) and
                                  (getsupreg(ref^.index) <> RS_ESP) and
                                  (getsupreg(ref^.index) <> RS_EBP)
                                  {$ifdef x86_64} and (ref^.index <> NR_RIP) {$endif x86_64} and
                                  (ref^.index <> ref^.base) then
                                  AllocRegBetween(ref^.index, hp3, tai(p.Next), UsedRegs);
                              end;
                            top_reg:
                              AllocRegBetween(reg, hp3, tai(p.Next), UsedRegs);
                            else
                              ;
                          end;
                        end;
                  end;
              end;

              if not GetNextInstruction(hp1, hp1) then
                { Should have dropped out earlier }
                InternalError(2021040710);
            end;
        end;
    end;


  procedure TX86AsmOptimizer.SwapMovCmp(var p, hp1: tai);
    var
      hp2: tai;
      X: Integer;
    begin
      asml.Remove(hp1);

      { Try to insert after the last instructions where the FLAGS register is not yet in use }
      if not GetLastInstruction(p, hp2) then
        asml.InsertBefore(hp1, p)
      else
        asml.InsertAfter(hp1, hp2);

      DebugMsg(SPeepholeOptimization + 'Swapped ' + debug_op2str(taicpu(p).opcode) + ' and mov instructions to improve optimisation potential', hp1);

      for X := 0 to 1 do
        case taicpu(hp1).oper[X]^.typ of
          top_reg:
            AllocRegBetween(taicpu(hp1).oper[X]^.reg, hp1, p, UsedRegs);
          top_ref:
            begin
              if taicpu(hp1).oper[X]^.ref^.base <> NR_NO then
                AllocRegBetween(taicpu(hp1).oper[X]^.ref^.base, hp1, p, UsedRegs);
              if taicpu(hp1).oper[X]^.ref^.index <> NR_NO then
                AllocRegBetween(taicpu(hp1).oper[X]^.ref^.index, hp1, p, UsedRegs);
            end;
          else
            ;
        end;
    end;


  function TX86AsmOptimizer.OptPass2MOV(var p : tai) : boolean;

     function IsXCHGAcceptable: Boolean; inline;
       begin
         { Always accept if optimising for size }
         Result := (cs_opt_size in current_settings.optimizerswitches) or
           (
{$ifdef x86_64}
             { XCHG takes 3 cycles on AMD Athlon64 }
             (current_settings.optimizecputype >= cpu_core_i)
{$else x86_64}
             { From the Pentium M onwards, XCHG only has a latency of 2 rather
             than 3, so it becomes a saving compared to three MOVs with two of
             them able to execute simultaneously. [Kit] }
             (current_settings.optimizecputype >= cpu_PentiumM)
{$endif x86_64}
           );
       end;

      var
        NewRef: TReference;
        hp1, hp2, hp3, hp4: Tai;
{$ifndef x86_64}
        OperIdx: Integer;
{$endif x86_64}
        NewInstr : Taicpu;
        NewAligh : Tai_align;
        DestLabel: TAsmLabel;
     begin
        Result:=false;

        { This optimisation adds an instruction, so only do it for speed }
        if not (cs_opt_size in current_settings.optimizerswitches) and
          MatchOpType(taicpu(p), top_const, top_reg) and
          (taicpu(p).oper[0]^.val = 0) then
          begin

            { To avoid compiler warning }
            DestLabel := nil;

            if (p.typ <> ait_instruction) or (taicpu(p).oper[1]^.typ <> top_reg) then
              InternalError(2021040750);

            if not GetNextInstructionUsingReg(p, hp1, taicpu(p).oper[1]^.reg) then
              Exit;

            case hp1.typ of
              ait_label:
                begin
                  { Change:
                      mov  $0,%reg                    mov  $0,%reg
                    @Lbl1:                          @Lbl1:
                      test %reg,%reg / cmp $0,%reg    test %reg,%reg / mov $0,%reg
                      je   @Lbl2                      jne  @Lbl2

                    To:                             To:
                      mov  $0,%reg                    mov  $0,%reg
                      jmp  @Lbl2                      jmp  @Lbl3
                      (align)                         (align)
                    @Lbl1:                          @Lbl1:
                      test %reg,%reg / cmp $0,%reg    test %reg,%reg / cmp $0,%reg
                      je   @Lbl2                      je   @Lbl2
                                                    @Lbl3:   <-- Only if label exists

                    (Not if it's optimised for size)
                  }
                  if not GetNextInstruction(hp1, hp2) then
                    Exit;

                  if not (cs_opt_size in current_settings.optimizerswitches) and
                    (hp2.typ = ait_instruction) and
                    (
                      { Register sizes must exactly match }
                      (
                        (taicpu(hp2).opcode = A_CMP) and
                        MatchOperand(taicpu(hp2).oper[0]^, 0) and
                        MatchOperand(taicpu(hp2).oper[1]^, taicpu(p).oper[1]^.reg)
                      ) or (
                        (taicpu(hp2).opcode = A_TEST) and
                        MatchOperand(taicpu(hp2).oper[0]^, taicpu(p).oper[1]^.reg) and
                        MatchOperand(taicpu(hp2).oper[1]^, taicpu(p).oper[1]^.reg)
                      )
                    ) and GetNextInstruction(hp2, hp3) and
                    (hp3.typ = ait_instruction) and
                    (taicpu(hp3).opcode = A_JCC) and
                    (taicpu(hp3).oper[0]^.typ=top_ref) and (taicpu(hp3).oper[0]^.ref^.refaddr=addr_full) and (taicpu(hp3).oper[0]^.ref^.base=NR_NO) and
                    (taicpu(hp3).oper[0]^.ref^.index=NR_NO) and (taicpu(hp3).oper[0]^.ref^.symbol is tasmlabel) then
                    begin
                      { Check condition of jump }

                      { Always true? }
                      if condition_in(C_E, taicpu(hp3).condition) then
                        begin
                          { Copy label symbol and obtain matching label entry for the
                            conditional jump, as this will be our destination}
                          DestLabel := tasmlabel(taicpu(hp3).oper[0]^.ref^.symbol);
                          DebugMsg(SPeepholeOptimization + 'Mov0LblCmp0Je -> Mov0JmpLblCmp0Je', p);
                          Result := True;
                        end

                      { Always false? }
                      else if condition_in(C_NE, taicpu(hp3).condition) and GetNextInstruction(hp3, hp2) then
                        begin
                          { This is only worth it if there's a jump to take }

                          case hp2.typ of
                            ait_instruction:
                              begin
                                if taicpu(hp2).opcode = A_JMP then
                                  begin
                                    DestLabel := tasmlabel(taicpu(hp2).oper[0]^.ref^.symbol);
                                    { An unconditional jump follows the conditional jump which will always be false,
                                      so use this jump's destination for the new jump }
                                    DebugMsg(SPeepholeOptimization + 'Mov0LblCmp0Jne -> Mov0JmpLblCmp0Jne (with JMP)', p);
                                    Result := True;
                                  end
                                else if taicpu(hp2).opcode = A_JCC then
                                  begin
                                    DestLabel := tasmlabel(taicpu(hp2).oper[0]^.ref^.symbol);
                                    if condition_in(C_E, taicpu(hp2).condition) then
                                      begin
                                        { A second conditional jump follows the conditional jump which will always be false,
                                          while the second jump is always True, so use this jump's destination for the new jump }
                                        DebugMsg(SPeepholeOptimization + 'Mov0LblCmp0Jne -> Mov0JmpLblCmp0Jne (with second Jcc)', p);
                                        Result := True;
                                      end;

                                    { Don't risk it if the jump isn't always true (Result remains False) }
                                  end;
                              end;
                            else
                              { If anything else don't optimise };
                          end;
                        end;

                      if Result then
                        begin
                          { Just so we have something to insert as a paremeter}
                          reference_reset(NewRef, 1, []);
                          NewInstr := taicpu.op_ref(A_JMP, S_NO, NewRef);

                          { Now actually load the correct parameter }
                          NewInstr.loadsymbol(0, DestLabel, 0);

                          { Get instruction before original label (may not be p under -O3) }
                          if not GetLastInstruction(hp1, hp2) then
                            { Shouldn't fail here }
                            InternalError(2021040701);

                          DestLabel.increfs;

                          AsmL.InsertAfter(NewInstr, hp2);
                          { Add new alignment field }
      (*                    AsmL.InsertAfter(
                            cai_align.create_max(
                              current_settings.alignment.jumpalign,
                              current_settings.alignment.jumpalignskipmax
                            ),
                            NewInstr
                          ); *)
                        end;

                      Exit;
                    end;
                end;
              else
                ;
            end;

          end;

        if not GetNextInstruction(p, hp1) then
          Exit;

        if MatchInstruction(hp1, A_JMP, [S_NO]) then
          begin
            { Sometimes the MOVs that OptPass2JMP produces can be improved
              further, but we can't just put this jump optimisation in pass 1
              because it tends to perform worse when conditional jumps are
              nearby (e.g. when converting CMOV instructions). [Kit] }
            if OptPass2JMP(hp1) then
              { call OptPass1MOV once to potentially merge any MOVs that were created }
              Result := OptPass1MOV(p)
              { OptPass2MOV will now exit but will be called again if OptPass1MOV
                returned True and the instruction is still a MOV, thus checking
                the optimisations below }

            { If OptPass2JMP returned False, no optimisations were done to
              the jump and there are no further optimisations that can be done
              to the MOV instruction on this pass }
          end
        else if MatchOpType(taicpu(p),top_reg,top_reg) and
          (taicpu(p).opsize in [S_L{$ifdef x86_64}, S_Q{$endif x86_64}]) and
          MatchInstruction(hp1,A_ADD,A_SUB,[taicpu(p).opsize]) and
          MatchOpType(taicpu(hp1),top_const,top_reg) and
          (taicpu(hp1).oper[1]^.reg = taicpu(p).oper[1]^.reg) and
          { be lazy, checking separately for sub would be slightly better }
          (abs(taicpu(hp1).oper[0]^.val)<=$7fffffff) then
          begin
            { Change:
                movl/q %reg1,%reg2      movl/q %reg1,%reg2
                addl/q $x,%reg2         subl/q $x,%reg2
              To:
                leal/q x(%reg1),%reg2   leal/q -x(%reg1),%reg2
            }
            TransferUsedRegs(TmpUsedRegs);
            UpdateUsedRegs(TmpUsedRegs, tai(p.Next));
            UpdateUsedRegs(TmpUsedRegs, tai(hp1.Next));
            if not GetNextInstruction(hp1, hp2) or
              (
              { The FLAGS register isn't always tracked properly, so do not
                perform this optimisation if a conditional statement follows }
                not RegReadByInstruction(NR_DEFAULTFLAGS, hp2) and
                not RegUsedAfterInstruction(NR_DEFAULTFLAGS, hp2, TmpUsedRegs)
              ) then
              begin
                reference_reset(NewRef, 1, []);
                NewRef.base := taicpu(p).oper[0]^.reg;
                NewRef.scalefactor := 1;

                if taicpu(hp1).opcode = A_ADD then
                  begin
                    DebugMsg(SPeepholeOptimization + 'MovAdd2Lea', p);
                    NewRef.offset := taicpu(hp1).oper[0]^.val;
                  end
                else
                  begin
                    DebugMsg(SPeepholeOptimization + 'MovSub2Lea', p);
                    NewRef.offset := -taicpu(hp1).oper[0]^.val;
                  end;

                taicpu(p).opcode := A_LEA;
                taicpu(p).loadref(0, NewRef);

                RemoveInstruction(hp1);

                Result := True;
                Exit;
              end;
          end
        else if MatchOpType(taicpu(p),top_reg,top_reg) and
{$ifdef x86_64}
          MatchInstruction(hp1,A_MOVZX,A_MOVSX,A_MOVSXD,[]) and
{$else x86_64}
          MatchInstruction(hp1,A_MOVZX,A_MOVSX,[]) and
{$endif x86_64}
          MatchOpType(taicpu(hp1),top_reg,top_reg) and
          (taicpu(hp1).oper[0]^.reg = taicpu(p).oper[1]^.reg) then
          { mov reg1, reg2                mov reg1, reg2
            movzx/sx reg2, reg3      to   movzx/sx reg1, reg3}
          begin
            taicpu(hp1).oper[0]^.reg := taicpu(p).oper[0]^.reg;
            DebugMsg(SPeepholeOptimization + 'mov %reg1,%reg2; movzx/sx %reg2,%reg3 -> mov %reg1,%reg2;movzx/sx %reg1,%reg3',p);

            { Don't remove the MOV command without first checking that reg2 isn't used afterwards,
              or unless supreg(reg3) = supreg(reg2)). [Kit] }

            TransferUsedRegs(TmpUsedRegs);
            UpdateUsedRegs(TmpUsedRegs, tai(p.next));

            if (getsupreg(taicpu(p).oper[1]^.reg) = getsupreg(taicpu(hp1).oper[1]^.reg)) or
              not RegUsedAfterInstruction(taicpu(p).oper[1]^.reg, hp1, TmpUsedRegs)
            then
              begin
                RemoveCurrentP(p, hp1);
                Result:=true;
              end;

            exit;
          end
        else if MatchOpType(taicpu(p),top_reg,top_reg) and
          IsXCHGAcceptable and
          { XCHG doesn't support 8-byte registers }
          (taicpu(p).opsize <> S_B) and
          MatchInstruction(hp1, A_MOV, []) and
          MatchOpType(taicpu(hp1),top_reg,top_reg) and
          (taicpu(hp1).oper[1]^.reg = taicpu(p).oper[0]^.reg) and
          GetNextInstruction(hp1, hp2) and
          MatchInstruction(hp2, A_MOV, []) and
          { Don't need to call MatchOpType for hp2 because the operand matches below cover for it }
          MatchOperand(taicpu(hp2).oper[0]^, taicpu(p).oper[1]^.reg) and
          MatchOperand(taicpu(hp2).oper[1]^, taicpu(hp1).oper[0]^.reg) then
          begin
            { mov %reg1,%reg2
              mov %reg3,%reg1        ->  xchg %reg3,%reg1
              mov %reg2,%reg3
              (%reg2 not used afterwards)

              Note that xchg takes 3 cycles to execute, and generally mov's take
              only one cycle apiece, but the first two mov's can be executed in
              parallel, only taking 2 cycles overall.  Older processors should
              therefore only optimise for size. [Kit]
            }
            TransferUsedRegs(TmpUsedRegs);
            UpdateUsedRegs(TmpUsedRegs, tai(p.Next));
            UpdateUsedRegs(TmpUsedRegs, tai(hp1.Next));

            if not RegUsedAfterInstruction(taicpu(p).oper[1]^.reg, hp2, TmpUsedRegs) then
              begin
                DebugMsg(SPeepholeOptimization + 'MovMovMov2XChg', p);
                AllocRegBetween(taicpu(hp2).oper[1]^.reg, p, hp1, UsedRegs);
                taicpu(hp1).opcode := A_XCHG;

                RemoveCurrentP(p, hp1);
                RemoveInstruction(hp2);

                Result := True;
                Exit;
              end;
          end
        else if MatchOpType(taicpu(p),top_reg,top_reg) and
          MatchInstruction(hp1, A_SAR, []) then
          begin
            if MatchOperand(taicpu(hp1).oper[0]^, 31) then
              begin
                { the use of %edx also covers the opsize being S_L }
                if MatchOperand(taicpu(hp1).oper[1]^, NR_EDX) then
                  begin
                    { Note it has to be specifically "movl %eax,%edx", and those specific sub-registers }
                    if (taicpu(p).oper[0]^.reg = NR_EAX) and
                      (taicpu(p).oper[1]^.reg = NR_EDX) then
                      begin
                        { Change:
                            movl %eax,%edx
                            sarl $31,%edx
                          To:
                            cltd
                        }
                        DebugMsg(SPeepholeOptimization + 'MovSar2Cltd', p);
                        RemoveInstruction(hp1);
                        taicpu(p).opcode := A_CDQ;
                        taicpu(p).opsize := S_NO;
                        taicpu(p).clearop(1);
                        taicpu(p).clearop(0);
                        taicpu(p).ops:=0;
                        Result := True;
                      end
                    else if (cs_opt_size in current_settings.optimizerswitches) and
                      (taicpu(p).oper[0]^.reg = NR_EDX) and
                      (taicpu(p).oper[1]^.reg = NR_EAX) then
                      begin
                        { Change:
                            movl %edx,%eax
                            sarl $31,%edx
                          To:
                            movl %edx,%eax
                            cltd

                          Note that this creates a dependency between the two instructions,
                            so only perform if optimising for size.
                        }
                        DebugMsg(SPeepholeOptimization + 'MovSar2MovCltd', p);
                        taicpu(hp1).opcode := A_CDQ;
                        taicpu(hp1).opsize := S_NO;
                        taicpu(hp1).clearop(1);
                        taicpu(hp1).clearop(0);
                        taicpu(hp1).ops:=0;
                      end;
{$ifndef x86_64}
                  end
                { Don't bother if CMOV is supported, because a more optimal
                  sequence would have been generated for the Abs() intrinsic }
                else if not(CPUX86_HAS_CMOV in cpu_capabilities[current_settings.cputype]) and
                  { the use of %eax also covers the opsize being S_L }
                  MatchOperand(taicpu(hp1).oper[1]^, NR_EAX) and
                  (taicpu(p).oper[0]^.reg = NR_EAX) and
                  (taicpu(p).oper[1]^.reg = NR_EDX) and
                  GetNextInstruction(hp1, hp2) and
                  MatchInstruction(hp2, A_XOR, [S_L]) and
                  MatchOperand(taicpu(hp2).oper[0]^, NR_EAX) and
                  MatchOperand(taicpu(hp2).oper[1]^, NR_EDX) and

                  GetNextInstruction(hp2, hp3) and
                  MatchInstruction(hp3, A_SUB, [S_L]) and
                  MatchOperand(taicpu(hp3).oper[0]^, NR_EAX) and
                  MatchOperand(taicpu(hp3).oper[1]^, NR_EDX) then
                  begin
                    { Change:
                        movl %eax,%edx
                        sarl $31,%eax
                        xorl %eax,%edx
                        subl %eax,%edx
                        (Instruction that uses %edx)
                        (%eax deallocated)
                        (%edx deallocated)
                      To:
                        cltd
                        xorl %edx,%eax  <-- Note the registers have swapped
                        subl %edx,%eax
                        (Instruction that uses %eax) <-- %eax rather than %edx
                    }

                    TransferUsedRegs(TmpUsedRegs);
                    UpdateUsedRegs(TmpUsedRegs, tai(p.Next));
                    UpdateUsedRegs(TmpUsedRegs, tai(hp1.Next));
                    UpdateUsedRegs(TmpUsedRegs, tai(hp2.Next));

                    if not RegUsedAfterInstruction(NR_EAX, hp3, TmpUsedRegs) then
                      begin
                        if GetNextInstruction(hp3, hp4) and
                          not RegModifiedByInstruction(NR_EDX, hp4) and
                          not RegUsedAfterInstruction(NR_EDX, hp4, TmpUsedRegs) then
                          begin
                            DebugMsg(SPeepholeOptimization + 'abs() intrinsic optimisation', p);

                            taicpu(p).opcode := A_CDQ;
                            taicpu(p).clearop(1);
                            taicpu(p).clearop(0);
                            taicpu(p).ops:=0;

                            RemoveInstruction(hp1);

                            taicpu(hp2).loadreg(0, NR_EDX);
                            taicpu(hp2).loadreg(1, NR_EAX);

                            taicpu(hp3).loadreg(0, NR_EDX);
                            taicpu(hp3).loadreg(1, NR_EAX);

                            AllocRegBetween(NR_EAX, hp3, hp4, TmpUsedRegs);
                            { Convert references in the following instruction (hp4) from %edx to %eax }
                            for OperIdx := 0 to taicpu(hp4).ops - 1 do
                              with taicpu(hp4).oper[OperIdx]^ do
                                case typ of
                                  top_reg:
                                    if getsupreg(reg) = RS_EDX then
                                      reg := newreg(R_INTREGISTER,RS_EAX,getsubreg(reg));
                                  top_ref:
                                    begin
                                      if getsupreg(reg) = RS_EDX then
                                        ref^.base := newreg(R_INTREGISTER,RS_EAX,getsubreg(reg));
                                      if getsupreg(reg) = RS_EDX then
                                        ref^.index := newreg(R_INTREGISTER,RS_EAX,getsubreg(reg));
                                    end;
                                  else
                                    ;
                                end;
                          end;
                      end;
{$else x86_64}
                  end;
              end
            else if MatchOperand(taicpu(hp1).oper[0]^, 63) and
              { the use of %rdx also covers the opsize being S_Q }
              MatchOperand(taicpu(hp1).oper[1]^, NR_RDX) then
              begin
                { Note it has to be specifically "movq %rax,%rdx", and those specific sub-registers }
                if (taicpu(p).oper[0]^.reg = NR_RAX) and
                  (taicpu(p).oper[1]^.reg = NR_RDX) then
                  begin
                    { Change:
                        movq %rax,%rdx
                        sarq $63,%rdx
                      To:
                        cqto
                    }
                    DebugMsg(SPeepholeOptimization + 'MovSar2Cqto', p);
                    RemoveInstruction(hp1);
                    taicpu(p).opcode := A_CQO;
                    taicpu(p).opsize := S_NO;
                    taicpu(p).clearop(1);
                    taicpu(p).clearop(0);
                    taicpu(p).ops:=0;
                    Result := True;
                  end
                else if (cs_opt_size in current_settings.optimizerswitches) and
                  (taicpu(p).oper[0]^.reg = NR_RDX) and
                  (taicpu(p).oper[1]^.reg = NR_RAX) then
                  begin
                    { Change:
                        movq %rdx,%rax
                        sarq $63,%rdx
                      To:
                        movq %rdx,%rax
                        cqto

                      Note that this creates a dependency between the two instructions,
                        so only perform if optimising for size.
                    }
                    DebugMsg(SPeepholeOptimization + 'MovSar2MovCqto', p);
                    taicpu(hp1).opcode := A_CQO;
                    taicpu(hp1).opsize := S_NO;
                    taicpu(hp1).clearop(1);
                    taicpu(hp1).clearop(0);
                    taicpu(hp1).ops:=0;
{$endif x86_64}
                  end;
              end;
          end
        else if MatchInstruction(hp1, A_MOV, []) and
          (taicpu(hp1).oper[1]^.typ = top_reg) then
          { Though "GetNextInstruction" could be factored out, along with
            the instructions that depend on hp2, it is an expensive call that
            should be delayed for as long as possible, hence we do cheaper
            checks first that are likely to be False. [Kit] }
          begin

            if MatchOperand(taicpu(p).oper[1]^, NR_EDX) and
              (
                (
                  (taicpu(hp1).oper[1]^.reg = NR_EAX) and
                  (
                    MatchOperand(taicpu(hp1).oper[0]^, taicpu(p).oper[0]^) or
                    MatchOperand(taicpu(hp1).oper[0]^, NR_EDX)
                  )
                ) or
                (
                  (taicpu(hp1).oper[1]^.reg = NR_EDX) and
                  (
                    MatchOperand(taicpu(hp1).oper[0]^, taicpu(p).oper[0]^) or
                    MatchOperand(taicpu(hp1).oper[0]^, NR_EAX)
                  )
                )
              ) and
              GetNextInstruction(hp1, hp2) and
              MatchInstruction(hp2, A_SAR, []) and
              MatchOperand(taicpu(hp2).oper[0]^, 31) then
              begin
                if MatchOperand(taicpu(hp2).oper[1]^, NR_EDX) then
                  begin
                    { Change:
                        movl r/m,%edx         movl r/m,%eax         movl r/m,%edx         movl r/m,%eax
                        movl %edx,%eax   or   movl %eax,%edx   or   movl r/m,%eax    or   movl r/m,%edx
                        sarl $31,%edx         sarl $31,%edx         sarl $31,%edx         sarl $31,%edx
                      To:
                        movl r/m,%eax    <- Note the change in register
                        cltd
                    }
                    DebugMsg(SPeepholeOptimization + 'MovMovSar2MovCltd', p);

                    AllocRegBetween(NR_EAX, p, hp1, UsedRegs);
                    taicpu(p).loadreg(1, NR_EAX);

                    taicpu(hp1).opcode := A_CDQ;
                    taicpu(hp1).clearop(1);
                    taicpu(hp1).clearop(0);
                    taicpu(hp1).ops:=0;

                    RemoveInstruction(hp2);
(*
{$ifdef x86_64}
                  end
                else if MatchOperand(taicpu(hp2).oper[1]^, NR_RDX) and
                  { This code sequence does not get generated - however it might become useful
                    if and when 128-bit signed integer types make an appearance, so the code
                    is kept here for when it is eventually needed. [Kit] }
                  (
                    (
                      (taicpu(hp1).oper[1]^.reg = NR_RAX) and
                      (
                        MatchOperand(taicpu(hp1).oper[0]^, taicpu(p).oper[0]^) or
                        MatchOperand(taicpu(hp1).oper[0]^, NR_RDX)
                      )
                    ) or
                    (
                      (taicpu(hp1).oper[1]^.reg = NR_RDX) and
                      (
                        MatchOperand(taicpu(hp1).oper[0]^, taicpu(p).oper[0]^) or
                        MatchOperand(taicpu(hp1).oper[0]^, NR_RAX)
                      )
                    )
                  ) and
                  GetNextInstruction(hp1, hp2) and
                  MatchInstruction(hp2, A_SAR, [S_Q]) and
                  MatchOperand(taicpu(hp2).oper[0]^, 63) and
                  MatchOperand(taicpu(hp2).oper[1]^, NR_RDX) then
                  begin
                    { Change:
                        movq r/m,%rdx         movq r/m,%rax         movq r/m,%rdx         movq r/m,%rax
                        movq %rdx,%rax   or   movq %rax,%rdx   or   movq r/m,%rax    or   movq r/m,%rdx
                        sarq $63,%rdx         sarq $63,%rdx         sarq $63,%rdx         sarq $63,%rdx
                      To:
                        movq r/m,%rax    <- Note the change in register
                        cqto
                    }
                    DebugMsg(SPeepholeOptimization + 'MovMovSar2MovCqto', p);

                    AllocRegBetween(NR_RAX, p, hp1, UsedRegs);
                    taicpu(p).loadreg(1, NR_RAX);

                    taicpu(hp1).opcode := A_CQO;
                    taicpu(hp1).clearop(1);
                    taicpu(hp1).clearop(0);
                    taicpu(hp1).ops:=0;

                    RemoveInstruction(hp2);
{$endif x86_64}
*)
                  end;
              end;
{$ifdef x86_64}
          end
        else if (taicpu(p).opsize = S_L) and
          (taicpu(p).oper[1]^.typ = top_reg) and
          (
            MatchInstruction(hp1, A_MOV,[]) and
            (taicpu(hp1).opsize = S_L) and
            (taicpu(hp1).oper[1]^.typ = top_reg)
          ) and (
            GetNextInstruction(hp1, hp2) and
            (tai(hp2).typ=ait_instruction) and
            (taicpu(hp2).opsize = S_Q) and
            (
              (
                MatchInstruction(hp2, A_ADD,[]) and
                (taicpu(hp2).opsize = S_Q) and
                (taicpu(hp2).oper[0]^.typ = top_reg) and (taicpu(hp2).oper[1]^.typ = top_reg) and
                (
                  (
                    (getsupreg(taicpu(hp2).oper[0]^.reg) = getsupreg(taicpu(p).oper[1]^.reg)) and
                    (getsupreg(taicpu(hp2).oper[1]^.reg) = getsupreg(taicpu(hp1).oper[1]^.reg))
                  ) or (
                    (getsupreg(taicpu(hp2).oper[0]^.reg) = getsupreg(taicpu(hp1).oper[1]^.reg)) and
                    (getsupreg(taicpu(hp2).oper[1]^.reg) = getsupreg(taicpu(p).oper[1]^.reg))
                  )
                )
              ) or (
                MatchInstruction(hp2, A_LEA,[]) and
                (taicpu(hp2).oper[0]^.ref^.offset = 0) and
                (taicpu(hp2).oper[0]^.ref^.scalefactor <= 1) and
                (
                  (
                    (getsupreg(taicpu(hp2).oper[0]^.ref^.base) = getsupreg(taicpu(p).oper[1]^.reg)) and
                    (getsupreg(taicpu(hp2).oper[0]^.ref^.index) = getsupreg(taicpu(hp1).oper[1]^.reg))
                  ) or (
                    (getsupreg(taicpu(hp2).oper[0]^.ref^.base) = getsupreg(taicpu(hp1).oper[1]^.reg)) and
                    (getsupreg(taicpu(hp2).oper[0]^.ref^.index) = getsupreg(taicpu(p).oper[1]^.reg))
                  )
                ) and (
                  (
                    (getsupreg(taicpu(hp2).oper[1]^.reg) = getsupreg(taicpu(hp1).oper[1]^.reg))
                  ) or (
                    (getsupreg(taicpu(hp2).oper[1]^.reg) = getsupreg(taicpu(p).oper[1]^.reg))
                  )
                )
              )
            )
          ) and (
            GetNextInstruction(hp2, hp3) and
            MatchInstruction(hp3, A_SHR,[]) and
            (taicpu(hp3).opsize = S_Q) and
            (taicpu(hp3).oper[0]^.typ = top_const) and (taicpu(hp2).oper[1]^.typ = top_reg) and
            (taicpu(hp3).oper[0]^.val = 1) and
            (taicpu(hp3).oper[1]^.reg = taicpu(hp2).oper[1]^.reg)
          ) then
          begin
            { Change   movl    x,    reg1d         movl    x,    reg1d
                       movl    y,    reg2d         movl    y,    reg2d
                       addq    reg2q,reg1q   or    leaq    (reg1q,reg2q),reg1q
                       shrq    $1,   reg1q         shrq    $1,   reg1q

            ( reg1d and reg2d can be switched around in the first two instructions )

              To       movl    x,    reg1d
                       addl    y,    reg1d
                       rcrl    $1,   reg1d

              This corresponds to the common expression (x + y) shr 1, where
              x and y are Cardinals (replacing "shr 1" with "div 2" produces
              smaller code, but won't account for x + y causing an overflow). [Kit]
            }

            if (getsupreg(taicpu(hp2).oper[1]^.reg) = getsupreg(taicpu(hp1).oper[1]^.reg)) then
              { Change first MOV command to have the same register as the final output }
              taicpu(p).oper[1]^.reg := taicpu(hp1).oper[1]^.reg
            else
              taicpu(hp1).oper[1]^.reg := taicpu(p).oper[1]^.reg;

            { Change second MOV command to an ADD command. This is easier than
              converting the existing command because it means we don't have to
              touch 'y', which might be a complicated reference, and also the
              fact that the third command might either be ADD or LEA. [Kit] }
            taicpu(hp1).opcode := A_ADD;

            { Delete old ADD/LEA instruction }
            RemoveInstruction(hp2);

            { Convert "shrq $1, reg1q" to "rcr $1, reg1d" }
            taicpu(hp3).opcode := A_RCR;
            taicpu(hp3).changeopsize(S_L);
            setsubreg(taicpu(hp3).oper[1]^.reg, R_SUBD);
{$endif x86_64}
          end;
      end;


    function TX86AsmOptimizer.OptPass2Movx(var p : tai) : boolean;
      var
        ThisReg: TRegister;
        MinSize, MaxSize, TrySmaller, TargetSize: TOpSize;
        TargetSubReg: TSubRegister;
        hp1, hp2: tai;
        RegInUse, RegChanged, p_removed: Boolean;

        { Store list of found instructions so we don't have to call
          GetNextInstructionUsingReg multiple times }
        InstrList: array of taicpu;
        InstrMax, Index: Integer;
        UpperLimit, TrySmallerLimit: TCgInt;

        PreMessage: string;

        { Data flow analysis }
        TestValMin, TestValMax: TCgInt;
        SmallerOverflow: Boolean;

      begin
        Result := False;
        p_removed := False;

        { This is anything but quick! }
        if not(cs_opt_level2 in current_settings.optimizerswitches) then
          Exit;

        SetLength(InstrList, 0);
        InstrMax := -1;
        ThisReg := taicpu(p).oper[1]^.reg;

        case taicpu(p).opsize of
          S_BW, S_BL:
            begin
{$if defined(i386) or defined(i8086)}
              { If the target size is 8-bit, make sure we can actually encode it }
              if not (GetSupReg(ThisReg) in [RS_EAX,RS_EBX,RS_ECX,RS_EDX]) then
                Exit;
{$endif i386 or i8086}

              UpperLimit := $FF;
              MinSize := S_B;
              if taicpu(p).opsize = S_BW then
                MaxSize := S_W
              else
                MaxSize := S_L;
            end;
          S_WL:
            begin
              UpperLimit := $FFFF;
              MinSize := S_W;
              MaxSize := S_L;
            end
          else
            InternalError(2020112301);
        end;

        TestValMin := 0;
        TestValMax := UpperLimit;
        TrySmallerLimit := UpperLimit;
        TrySmaller := S_NO;
        SmallerOverflow := False;
        RegChanged := False;

        hp1 := p;

        while GetNextInstructionUsingReg(hp1, hp1, ThisReg) and
          (hp1.typ = ait_instruction) and
          (
            { Under -O1 and -O2, GetNextInstructionUsingReg may return an
              instruction that doesn't actually contain ThisReg }
            (cs_opt_level3 in current_settings.optimizerswitches) or
            RegInInstruction(ThisReg, hp1)
          ) do
          begin

            case taicpu(hp1).opcode of
              A_INC,A_DEC:
                begin
                  { Has to be an exact match on the register }
                  if not MatchOperand(taicpu(hp1).oper[0]^, ThisReg) then
                    Break;

                  if taicpu(hp1).opcode = A_INC then
                    begin
                      Inc(TestValMin);
                      Inc(TestValMax);
                    end
                  else
                    begin
                      Dec(TestValMin);
                      Dec(TestValMax);
                    end;
                end;

              A_CMP:
                begin
                  if (taicpu(hp1).oper[1]^.typ <> top_reg) or
                    { Has to be an exact match on the register }
                    (taicpu(hp1).oper[1]^.reg <> ThisReg) or
                    (taicpu(hp1).oper[0]^.typ <> top_const) or
                    { Make sure the comparison value is not smaller than the
                      smallest allowed signed value for the minimum size (e.g.
                      -128 for 8-bit) }
                    not (
                      ((taicpu(hp1).oper[0]^.val and UpperLimit) = taicpu(hp1).oper[0]^.val) or
                      { Is it in the negative range? }
                      (((not taicpu(hp1).oper[0]^.val) and (UpperLimit shr 1)) = (not taicpu(hp1).oper[0]^.val))
                    ) then
                    Break;

                  TestValMin := TestValMin - taicpu(hp1).oper[0]^.val;
                  TestValMax := TestValMax - taicpu(hp1).oper[0]^.val;

                  if (TestValMin < TrySmallerLimit) or (TestValMax < TrySmallerLimit) or
                    (TestValMin > UpperLimit) or (TestValMax > UpperLimit) then
                    { Overflow }
                    Break;

                  { Check to see if the active register is used afterwards }
                  TransferUsedRegs(TmpUsedRegs);
                  IncludeRegInUsedRegs(ThisReg, TmpUsedRegs);
                  if not RegUsedAfterInstruction(ThisReg, hp1, TmpUsedRegs) then
                    begin
                      case MinSize of
                        S_B:
                          TargetSubReg := R_SUBL;
                        S_W:
                          TargetSubReg := R_SUBW;
                        else
                          InternalError(2021051002);
                      end;

                      { Update the register to its new size }
                      setsubreg(ThisReg, TargetSubReg);

                      taicpu(hp1).oper[1]^.reg := ThisReg;
                      taicpu(hp1).opsize := MinSize;

                      { Convert the input MOVZX to a MOV }
                      if (taicpu(p).oper[0]^.typ = top_reg) and
                        SuperRegistersEqual(taicpu(p).oper[0]^.reg, ThisReg) then
                        begin
                          { Or remove it completely! }
                          DebugMsg(SPeepholeOptimization + 'Movzx2Nop 1a', p);
                          RemoveCurrentP(p);
                          p_removed := True;
                        end
                      else
                        begin
                          DebugMsg(SPeepholeOptimization + 'Movzx2Mov 1a', p);
                          taicpu(p).opcode := A_MOV;
                          taicpu(p).oper[1]^.reg := ThisReg;
                          taicpu(p).opsize := MinSize;
                        end;

                      if (InstrMax >= 0) then
                        begin
                          for Index := 0 to InstrMax do
                            begin

                              { If p_removed is true, then the original MOV/Z was removed
                                and removing the AND instruction may not be safe if it
                                appears first }
                              if (InstrList[Index].oper[InstrList[Index].ops - 1]^.typ <> top_reg) then
                                InternalError(2020112311);

                              if InstrList[Index].oper[0]^.typ = top_reg then
                                InstrList[Index].oper[0]^.reg := ThisReg;

                              InstrList[Index].oper[InstrList[Index].ops - 1]^.reg := ThisReg;
                              InstrList[Index].opsize := MinSize;
                            end;

                        end;

                      Result := True;
                      Exit;
                    end;
                end;

              { OR and XOR are not included because they can too easily fool
                the data flow analysis (they can cause non-linear behaviour) }
              A_ADD,A_SUB,A_AND,A_SHL,A_SHR:
                begin
                  if
                    (taicpu(hp1).oper[1]^.typ <> top_reg) or
                    { Has to be an exact match on the register }
                    (taicpu(hp1).oper[1]^.reg <> ThisReg) or not
                    (
                      (
                        (taicpu(hp1).oper[0]^.typ = top_const) and
                        (
                          (
                            (taicpu(hp1).opcode = A_SHL) and
                            (
                              ((MinSize = S_B) and (taicpu(hp1).oper[0]^.val < 8)) or
                              ((MinSize = S_W) and (taicpu(hp1).oper[0]^.val < 16)) or
                              ((MinSize = S_L) and (taicpu(hp1).oper[0]^.val < 32))
                            )
                          ) or (
                            (taicpu(hp1).opcode <> A_SHL) and
                            (
                              ((taicpu(hp1).oper[0]^.val and UpperLimit) = taicpu(hp1).oper[0]^.val) or
                              { Is it in the negative range? }
                              (((not taicpu(hp1).oper[0]^.val) and (UpperLimit shr 1)) = (not taicpu(hp1).oper[0]^.val))
                            )
                          )
                        )
                      ) or (
                        MatchOperand(taicpu(hp1).oper[0]^, taicpu(hp1).oper[1]^.reg) and
                        ((taicpu(hp1).opcode = A_ADD) or (taicpu(hp1).opcode = A_AND) or (taicpu(hp1).opcode = A_SUB))
                      )
                    ) then
                    Break;

                  case taicpu(hp1).opcode of
                    A_ADD:
                      if (taicpu(hp1).oper[0]^.typ = top_reg) then
                        begin
                          TestValMin := TestValMin * 2;
                          TestValMax := TestValMax * 2;
                        end
                      else
                        begin
                          TestValMin := TestValMin + taicpu(hp1).oper[0]^.val;
                          TestValMax := TestValMax + taicpu(hp1).oper[0]^.val;
                        end;
                    A_SUB:
                      if (taicpu(hp1).oper[0]^.typ = top_reg) then
                        begin
                          TestValMin := 0;
                          TestValMax := 0;
                        end
                      else
                        begin
                          TestValMin := TestValMin - taicpu(hp1).oper[0]^.val;
                          TestValMax := TestValMax - taicpu(hp1).oper[0]^.val;
                        end;
                    A_AND:
                      if (taicpu(hp1).oper[0]^.typ = top_const) then
                        begin
                          { we might be able to go smaller if AND appears first }
                          if InstrMax = -1 then
                            case MinSize of
                              S_B:
                                ;
                              S_W:
                                if ((taicpu(hp1).oper[0]^.val and $FF) = taicpu(hp1).oper[0]^.val) or
                                  ((not(taicpu(hp1).oper[0]^.val) and $7F) = (not taicpu(hp1).oper[0]^.val)) then
                                  begin
                                    TrySmaller := S_B;
                                    TrySmallerLimit := $FF;
                                  end;
                              S_L:
                                if ((taicpu(hp1).oper[0]^.val and $FF) = taicpu(hp1).oper[0]^.val) or
                                  ((not(taicpu(hp1).oper[0]^.val) and $7F) = (not taicpu(hp1).oper[0]^.val)) then
                                  begin
                                    TrySmaller := S_B;
                                    TrySmallerLimit := $FF;
                                  end
                                else if ((taicpu(hp1).oper[0]^.val and $FFFF) = taicpu(hp1).oper[0]^.val) or
                                  ((not(taicpu(hp1).oper[0]^.val) and $7FFF) = (not taicpu(hp1).oper[0]^.val)) then
                                  begin
                                    TrySmaller := S_W;
                                    TrySmallerLimit := $FFFF;
                                  end;
                              else
                                InternalError(2020112320);
                            end;

                          TestValMin := TestValMin and taicpu(hp1).oper[0]^.val;
                          TestValMax := TestValMax and taicpu(hp1).oper[0]^.val;
                        end;
                    A_SHL:
                      begin
                        TestValMin := TestValMin shl taicpu(hp1).oper[0]^.val;
                        TestValMax := TestValMax shl taicpu(hp1).oper[0]^.val;
                      end;
                    A_SHR:
                      begin
                        { we might be able to go smaller if SHR appears first }
                        if InstrMax = -1 then
                          case MinSize of
                            S_B:
                              ;
                            S_W:
                              if (taicpu(hp1).oper[0]^.val >= 8) then
                                begin
                                  TrySmaller := S_B;
                                  TrySmallerLimit := $FF;
                                end;
                            S_L:
                              if (taicpu(hp1).oper[0]^.val >= 24) then
                                begin
                                  TrySmaller := S_B;
                                  TrySmallerLimit := $FF;
                                end
                              else if (taicpu(hp1).oper[0]^.val >= 16) then
                                begin
                                  TrySmaller := S_W;
                                  TrySmallerLimit := $FFFF;
                                end;
                            else
                              InternalError(2020112321);
                          end;

                        TestValMin := TestValMin shr taicpu(hp1).oper[0]^.val;
                        TestValMax := TestValMax shr taicpu(hp1).oper[0]^.val;
                      end;
                    else
                      InternalError(2020112303);
                  end;
                end;
(*
              A_IMUL:
                case taicpu(hp1).ops of
                  2:
                    begin
                      if not MatchOpType(hp1, top_reg, top_reg) or
                        { Has to be an exact match on the register }
                        (taicpu(hp1).oper[0]^.reg <> ThisReg) or
                        (taicpu(hp1).oper[1]^.reg <> ThisReg) then
                        Break;

                      TestValMin := TestValMin * TestValMin;
                      TestValMax := TestValMax * TestValMax;
                    end;
                  3:
                    begin
                      if not MatchOpType(hp1, top_const, top_reg, top_reg) or
                        { Has to be an exact match on the register }
                        (taicpu(hp1).oper[1]^.reg <> ThisReg) or
                        (taicpu(hp1).oper[2]^.reg <> ThisReg) or
                        ((taicpu(hp1).oper[0]^.val and UpperLimit) = taicpu(hp1).oper[0]^.val) or
                        { Is it in the negative range? }
                        (((not taicpu(hp1).oper[0]^.val) and (UpperLimit shr 1)) = (not taicpu(hp1).oper[0]^.val)) then
                        Break;

                      TestValMin := TestValMin * taicpu(hp1).oper[0]^.val;
                      TestValMax := TestValMax * taicpu(hp1).oper[0]^.val;
                    end;
                  else
                    Break;
                end;

              A_IDIV:
                case taicpu(hp1).ops of
                  3:
                    begin
                      if not MatchOpType(hp1, top_const, top_reg, top_reg) or
                        { Has to be an exact match on the register }
                        (taicpu(hp1).oper[1]^.reg <> ThisReg) or
                        (taicpu(hp1).oper[2]^.reg <> ThisReg) or
                        ((taicpu(hp1).oper[0]^.val and UpperLimit) = taicpu(hp1).oper[0]^.val) or
                        { Is it in the negative range? }
                        (((not taicpu(hp1).oper[0]^.val) and (UpperLimit shr 1)) = (not taicpu(hp1).oper[0]^.val)) then
                        Break;

                      TestValMin := TestValMin div taicpu(hp1).oper[0]^.val;
                      TestValMax := TestValMax div taicpu(hp1).oper[0]^.val;
                    end;
                  else
                    Break;
                end;
*)
              A_MOVZX:
                begin
                  if not MatchOpType(taicpu(hp1), top_reg, top_reg) then
                    Break;

                  if not SuperRegistersEqual(taicpu(hp1).oper[0]^.reg, ThisReg) then
                    begin
                      { Because hp1 was obtained via GetNextInstructionUsingReg
                        and ThisReg doesn't appear in the first operand, it
                        must appear in the second operand and hence gets
                        overwritten }
                      if (InstrMax = -1) and
                        Reg1WriteOverwritesReg2Entirely(taicpu(hp1).oper[1]^.reg, ThisReg) then
                        begin
                          { The two MOVZX instructions are adjacent, so remove the first one }
                          DebugMsg(SPeepholeOptimization + 'Movzx2Nop 5', p);
                          RemoveCurrentP(p);
                          Result := True;
                          Exit;
                        end;

                      Break;
                    end;

                  { The objective here is to try to find a combination that
                    removes one of the MOV/Z instructions. }
                  case taicpu(hp1).opsize of
                    S_WL:
                      if (MinSize in [S_B, S_W]) then
                        begin
                          TargetSize := S_L;
                          TargetSubReg := R_SUBD;
                        end
                      else if ((TrySmaller in [S_B, S_W]) and not SmallerOverflow) then
                        begin
                          TargetSize := TrySmaller;
                          if TrySmaller = S_B then
                            TargetSubReg := R_SUBL
                          else
                            TargetSubReg := R_SUBW;
                        end
                      else
                        Break;

                    S_BW:
                      if (MinSize in [S_B, S_W]) then
                        begin
                          TargetSize := S_W;
                          TargetSubReg := R_SUBW;
                        end
                      else if ((TrySmaller = S_B) and not SmallerOverflow) then
                        begin
                          TargetSize := S_B;
                          TargetSubReg := R_SUBL;
                        end
                      else
                        Break;

                    S_BL:
                      if (MinSize in [S_B, S_W]) then
                        begin
                          TargetSize := S_L;
                          TargetSubReg := R_SUBD;
                        end
                      else if ((TrySmaller = S_B) and not SmallerOverflow) then
                        begin
                          TargetSize := S_B;
                          TargetSubReg := R_SUBL;
                        end
                      else
                        Break;

                    else
                      InternalError(2020112302);
                  end;

                  { Update the register to its new size }
                  setsubreg(ThisReg, TargetSubReg);

                  if TargetSize = MinSize then
                    begin
                      { Convert the input MOVZX to a MOV }
                      if (taicpu(p).oper[0]^.typ = top_reg) and
                        SuperRegistersEqual(taicpu(p).oper[0]^.reg, ThisReg) then
                        begin
                          { Or remove it completely! }
                          DebugMsg(SPeepholeOptimization + 'Movzx2Nop 1', p);
                          RemoveCurrentP(p);
                          p_removed := True;
                        end
                      else
                        begin
                          DebugMsg(SPeepholeOptimization + 'Movzx2Mov 1', p);
                          taicpu(p).opcode := A_MOV;
                          taicpu(p).oper[1]^.reg := ThisReg;
                          taicpu(p).opsize := TargetSize;
                        end;

                      Result := True;
                    end
                  else if TargetSize <> MaxSize then
                    begin

                      case MaxSize of
                        S_L:
                          if TargetSize = S_W then
                            begin
                              DebugMsg(SPeepholeOptimization + 'movzbl2movzbw', p);
                              taicpu(p).opsize := S_BW;
                              taicpu(p).oper[1]^.reg := ThisReg;
                              Result := True;
                            end
                          else
                            InternalError(2020112341);

                        S_W:
                          if TargetSize = S_L then
                            begin
                              DebugMsg(SPeepholeOptimization + 'movzbw2movzbl', p);
                              taicpu(p).opsize := S_BL;
                              taicpu(p).oper[1]^.reg := ThisReg;
                              Result := True;
                            end
                          else
                            InternalError(2020112342);
                        else
                          ;
                      end;
                    end;


                  if (MaxSize = TargetSize) or
                    ((TargetSize = S_L) and (taicpu(hp1).opsize in [S_L, S_BL, S_WL])) or
                    ((TargetSize = S_W) and (taicpu(hp1).opsize in [S_W, S_BW])) then
                    begin
                      { Convert the output MOVZX to a MOV }
                      if SuperRegistersEqual(taicpu(hp1).oper[1]^.reg, ThisReg) then
                        begin
                          { Or remove it completely! }
                          DebugMsg(SPeepholeOptimization + 'Movzx2Nop 2', hp1);

                          { Be careful; if p = hp1 and p was also removed, p
                            will become a dangling pointer }
                          if p = hp1 then
                            RemoveCurrentp(p) { p = hp1 and will then become the next instruction }
                          else
                            RemoveInstruction(hp1);
                        end
                      else
                        begin
                          taicpu(hp1).opcode := A_MOV;
                          taicpu(hp1).oper[0]^.reg := ThisReg;
                          taicpu(hp1).opsize := TargetSize;

                          { Check to see if the active register is used afterwards;
                            if not, we can change it and make a saving. }
                          RegInUse := False;
                          TransferUsedRegs(TmpUsedRegs);

                          { The target register may be marked as in use to cross
                            a jump to a distant label, so exclude it }
                          ExcludeRegFromUsedRegs(taicpu(hp1).oper[1]^.reg, TmpUsedRegs);

                          hp2 := p;
                          repeat

                            UpdateUsedRegs(TmpUsedRegs, tai(hp2.next));

                            { Explicitly check for the excluded register (don't include the first
                              instruction as it may be reading from here }
                            if ((p <> hp2) and (RegInInstruction(taicpu(hp1).oper[1]^.reg, hp2))) or
                              RegInUsedRegs(taicpu(hp1).oper[1]^.reg, TmpUsedRegs) then
                              begin
                                RegInUse := True;
                                Break;
                              end;

                            if not GetNextInstruction(hp2, hp2) then
                              InternalError(2020112340);

                          until (hp2 = hp1);

                          if not RegInUse and not RegUsedAfterInstruction(ThisReg, hp1, TmpUsedRegs) then
                            begin
                              DebugMsg(SPeepholeOptimization + 'Simplified register usage so ' + debug_regname(taicpu(hp1).oper[1]^.reg) + ' = ' + debug_regname(taicpu(p).oper[1]^.reg), p);
                              ThisReg := taicpu(hp1).oper[1]^.reg;
                              RegChanged := True;

                              TransferUsedRegs(TmpUsedRegs);
                              AllocRegBetween(ThisReg, p, hp1, TmpUsedRegs);

                              DebugMsg(SPeepholeOptimization + 'Movzx2Nop 3', hp1);
                              if p = hp1 then
                                RemoveCurrentp(p) { p = hp1 and will then become the next instruction }
                              else
                                RemoveInstruction(hp1);

                              { Instruction will become "mov %reg,%reg" }
                              if not p_removed and (taicpu(p).opcode = A_MOV) and
                                MatchOperand(taicpu(p).oper[0]^, ThisReg) then
                                begin
                                  DebugMsg(SPeepholeOptimization + 'Movzx2Nop 6', p);
                                  RemoveCurrentP(p);
                                  p_removed := True;
                                end
                              else
                                taicpu(p).oper[1]^.reg := ThisReg;

                              Result := True;
                            end
                          else
                            DebugMsg(SPeepholeOptimization + 'Movzx2Mov 2', hp1);

                        end;
                    end
                  else
                    InternalError(2020112330);

                  { Now go through every instruction we found and change the
                    size. If TargetSize = MaxSize, then almost no changes are
                    needed and Result can remain False if it hasn't been set
                    yet.

                    If RegChanged is True, then the register requires changing
                    and so the point about TargetSize = MaxSize doesn't apply. }

                  if ((TargetSize <> MaxSize) or RegChanged) and (InstrMax >= 0) then
                    begin
                      for Index := 0 to InstrMax do
                        begin

                          { If p_removed is true, then the original MOV/Z was removed
                            and removing the AND instruction may not be safe if it
                            appears first }
                          if (InstrList[Index].oper[InstrList[Index].ops - 1]^.typ <> top_reg) then
                            InternalError(2020112310);

                          if InstrList[Index].oper[0]^.typ = top_reg then
                            InstrList[Index].oper[0]^.reg := ThisReg;

                          InstrList[Index].oper[InstrList[Index].ops - 1]^.reg := ThisReg;
                          InstrList[Index].opsize := TargetSize;
                        end;

                      Result := True;
                    end;

                  Exit;
                end;

              else
                { This includes ADC, SBB, IDIV and SAR }
                Break;
            end;

            if (TestValMin < 0) or (TestValMax < 0) or
              (TestValMin > UpperLimit) or (TestValMax > UpperLimit) then
              { Overflow }
              Break
            else if not SmallerOverflow and (TrySmaller <> S_NO) and
              ((TestValMin > TrySmallerLimit) or (TestValMax > TrySmallerLimit)) then
              SmallerOverflow := True;

            { Contains highest index (so instruction count - 1) }
            Inc(InstrMax);
            if InstrMax > High(InstrList) then
              SetLength(InstrList, InstrMax + LIST_STEP_SIZE);

            InstrList[InstrMax] := taicpu(hp1);
          end;
      end;


    function TX86AsmOptimizer.OptPass2Imul(var p : tai) : boolean;
      var
        hp1 : tai;
      begin
        Result:=false;
        if (taicpu(p).ops >= 2) and
           ((taicpu(p).oper[0]^.typ = top_const) or
            ((taicpu(p).oper[0]^.typ = top_ref) and (taicpu(p).oper[0]^.ref^.refaddr=addr_full))) and
           (taicpu(p).oper[1]^.typ = top_reg) and
           ((taicpu(p).ops = 2) or
            ((taicpu(p).oper[2]^.typ = top_reg) and
             (taicpu(p).oper[2]^.reg = taicpu(p).oper[1]^.reg))) and
           GetLastInstruction(p,hp1) and
           MatchInstruction(hp1,A_MOV,[]) and
           MatchOpType(taicpu(hp1),top_reg,top_reg) and
           (taicpu(hp1).oper[1]^.reg = taicpu(p).oper[1]^.reg) then
          begin
            TransferUsedRegs(TmpUsedRegs);
            if not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,p,TmpUsedRegs)) or
              ((taicpu(p).ops = 3) and (taicpu(p).oper[1]^.reg=taicpu(p).oper[2]^.reg)) then
              { change
                  mov reg1,reg2
                  imul y,reg2 to imul y,reg1,reg2 }
              begin
                taicpu(p).ops := 3;
                taicpu(p).loadreg(2,taicpu(p).oper[1]^.reg);
                taicpu(p).loadreg(1,taicpu(hp1).oper[0]^.reg);
                DebugMsg(SPeepholeOptimization + 'MovImul2Imul done',p);
                RemoveInstruction(hp1);
                result:=true;
              end;
          end;
      end;


    procedure TX86AsmOptimizer.ConvertJumpToRET(const p: tai; const ret_p: tai);
      var
        ThisLabel: TAsmLabel;
      begin
        ThisLabel := tasmlabel(taicpu(p).oper[0]^.ref^.symbol);
        ThisLabel.decrefs;
        taicpu(p).opcode := A_RET;
        taicpu(p).is_jmp := false;
        taicpu(p).ops := taicpu(ret_p).ops;
        case taicpu(ret_p).ops of
          0:
            taicpu(p).clearop(0);
          1:
            taicpu(p).loadconst(0,taicpu(ret_p).oper[0]^.val);
          else
            internalerror(2016041301);
        end;

        { If the original label is now dead, it might turn out that the label
          immediately follows p.  As a result, everything beyond it, which will
          be just some final register configuration and a RET instruction, is
          now dead code. [Kit] }

        { NOTE: This is much faster than introducing a OptPass2RET routine and
          running RemoveDeadCodeAfterJump for each RET instruction, because
          this optimisation rarely happens and most RETs appear at the end of
          routines where there is nothing that can be stripped. [Kit] }
        if not ThisLabel.is_used then
          RemoveDeadCodeAfterJump(p);
      end;


    function TX86AsmOptimizer.OptPass2SETcc(var p: tai): boolean;
      var
        hp1,hp2,next: tai; SetC, JumpC: TAsmCond;
        Unconditional, PotentialModified: Boolean;
        OperPtr: POper;

        NewRef: TReference;

        InstrList: array of taicpu;
        InstrMax, Index: Integer;
      const
{$ifdef DEBUG_AOPTCPU}
        SNoFlags: shortstring = ' so the flags aren''t modified';
{$else DEBUG_AOPTCPU}
        SNoFlags = '';
{$endif DEBUG_AOPTCPU}
      begin
        Result:=false;

        if MatchOpType(taicpu(p),top_reg) and GetNextInstructionUsingReg(p, hp1, taicpu(p).oper[0]^.reg) then
          begin
            if MatchInstruction(hp1, A_TEST, [S_B]) and
              MatchOpType(taicpu(hp1),top_reg,top_reg) and
              (taicpu(hp1).oper[0]^.reg = taicpu(hp1).oper[1]^.reg) and
              (taicpu(p).oper[0]^.reg = taicpu(hp1).oper[1]^.reg) and
              GetNextInstruction(hp1, hp2) and
              MatchInstruction(hp2, A_Jcc, []) then
              { Change from:             To:

                set(C) %reg              j(~C) label
                test   %reg,%reg/cmp $0,%reg
                je     label


                set(C) %reg              j(C)  label
                test   %reg,%reg/cmp $0,%reg
                jne    label
              }
              begin
                { Before we do anything else, we need to check the instructions
                  in between SETcc and TEST to make sure they don't modify the
                  FLAGS register - if -O2 or under, there won't be any
                  instructions between SET and TEST }

                TransferUsedRegs(TmpUsedRegs);
                UpdateUsedRegs(TmpUsedRegs, tai(p.next));

                if (cs_opt_level3 in current_settings.optimizerswitches) then
                  begin
                    next := p;
                    SetLength(InstrList, 0);
                    InstrMax := -1;
                    PotentialModified := False;

                    { Make a note of every instruction that modifies the FLAGS
                      register }
                    while GetNextInstruction(next, next) and (next <> hp1) do
                      begin
                        if next.typ <> ait_instruction then
                          { GetNextInstructionUsingReg should have returned False }
                          InternalError(2021051701);

                        if RegModifiedByInstruction(NR_DEFAULTFLAGS, next) then
                          begin
                            case taicpu(next).opcode of
                              A_SETcc,
                              A_CMOVcc,
                              A_Jcc:
                                begin
                                  if PotentialModified then
                                    { Not safe because the flags were modified earlier }
                                    Exit
                                  else
                                    { Condition is the same as the initial SETcc, so this is safe
                                      (don't add to instruction list though) }
                                    Continue;
                                end;
                              A_ADD:
                                begin
                                  if (taicpu(next).opsize = S_B) or
                                    { LEA doesn't support 8-bit operands }
                                    (taicpu(next).oper[1]^.typ <> top_reg) or
                                    { Must write to a register }
                                    (taicpu(next).oper[0]^.typ = top_ref) then
                                    { Require a constant or a register }
                                    Exit;

                                  PotentialModified := True;
                                end;
                              A_SUB:
                                begin
                                  if (taicpu(next).opsize = S_B) or
                                    { LEA doesn't support 8-bit operands }
                                    (taicpu(next).oper[1]^.typ <> top_reg) or
                                    { Must write to a register }
                                    (taicpu(next).oper[0]^.typ <> top_const) or
                                    (taicpu(next).oper[0]^.val = $80000000) then
                                    { Can't subtract a register with LEA - also
                                      check that the value isn't -2^31, as this
                                      can't be negated }
                                    Exit;

                                  PotentialModified := True;
                                end;
                              A_SAL,
                              A_SHL:
                                begin
                                  if (taicpu(next).opsize = S_B) or
                                    { LEA doesn't support 8-bit operands }
                                    (taicpu(next).oper[1]^.typ <> top_reg) or
                                    { Must write to a register }
                                    (taicpu(next).oper[0]^.typ <> top_const) or
                                    (taicpu(next).oper[0]^.val < 0) or
                                    (taicpu(next).oper[0]^.val > 3) then
                                      Exit;

                                  PotentialModified := True;
                                end;
                              A_IMUL:
                                begin
                                  if (taicpu(next).ops <> 3) or
                                    (taicpu(next).oper[1]^.typ <> top_reg) or
                                    { Must write to a register }
                                    (taicpu(next).oper[2]^.val in [2,3,4,5,8,9]) then
                                    { We can convert "imul x,%reg1,%reg2" (where x = 2, 4 or 8)
                                      to "lea (%reg1,x),%reg2".  If x = 3, 5  or 9, we can
                                      change this to "lea (%reg1,%reg1,(x-1)),%reg2" }
                                    Exit
                                  else
                                    PotentialModified := True;
                                end;
                              else
                                { Don't know how to change this, so abort }
                                Exit;
                            end;

                            { Contains highest index (so instruction count - 1) }
                            Inc(InstrMax);
                            if InstrMax > High(InstrList) then
                              SetLength(InstrList, InstrMax + LIST_STEP_SIZE);

                            InstrList[InstrMax] := taicpu(next);
                          end;
                        UpdateUsedRegs(TmpUsedRegs, tai(next.next));
                      end;

                    if not Assigned(next) or (next <> hp1) then
                      { It should be equal to hp1 }
                      InternalError(2021051702);

                    { Cycle through each instruction and check to see if we can
                      change them to versions that don't modify the flags }
                    if (InstrMax >= 0) then
                      begin
                        for Index := 0 to InstrMax do
                          case InstrList[Index].opcode of
                            A_ADD:
                              begin
                                DebugMsg(SPeepholeOptimization + 'ADD -> LEA' + SNoFlags, InstrList[Index]);
                                InstrList[Index].opcode := A_LEA;
                                reference_reset(NewRef, 1, []);
                                NewRef.base := InstrList[Index].oper[1]^.reg;

                                if InstrList[Index].oper[0]^.typ = top_reg then
                                  begin
                                    NewRef.index := InstrList[Index].oper[0]^.reg;
                                    NewRef.scalefactor := 1;
                                  end
                                else
                                  NewRef.offset := InstrList[Index].oper[0]^.val;

                                InstrList[Index].loadref(0, NewRef);
                              end;
                            A_SUB:
                              begin
                                DebugMsg(SPeepholeOptimization + 'SUB -> LEA' + SNoFlags, InstrList[Index]);
                                InstrList[Index].opcode := A_LEA;
                                reference_reset(NewRef, 1, []);
                                NewRef.base := InstrList[Index].oper[1]^.reg;
                                NewRef.offset := -InstrList[Index].oper[0]^.val;

                                InstrList[Index].loadref(0, NewRef);
                              end;
                            A_SHL,
                            A_SAL:
                              begin
                                DebugMsg(SPeepholeOptimization + 'SHL -> LEA' + SNoFlags, InstrList[Index]);
                                InstrList[Index].opcode := A_LEA;
                                reference_reset(NewRef, 1, []);
                                NewRef.index := InstrList[Index].oper[1]^.reg;
                                NewRef.scalefactor := 1 shl (InstrList[Index].oper[0]^.val);

                                InstrList[Index].loadref(0, NewRef);
                              end;
                            A_IMUL:
                              begin
                                DebugMsg(SPeepholeOptimization + 'IMUL -> LEA' + SNoFlags, InstrList[Index]);
                                InstrList[Index].opcode := A_LEA;
                                reference_reset(NewRef, 1, []);
                                NewRef.index := InstrList[Index].oper[1]^.reg;
                                case InstrList[Index].oper[0]^.val of
                                  2, 4, 8:
                                    NewRef.scalefactor := InstrList[Index].oper[0]^.val;
                                  else {3, 5 and 9}
                                    begin
                                      NewRef.scalefactor := InstrList[Index].oper[0]^.val - 1;
                                      NewRef.base := InstrList[Index].oper[1]^.reg;
                                    end;
                                end;

                                InstrList[Index].loadref(0, NewRef);
                              end;
                            else
                              InternalError(2021051710);
                          end;

                      end;

                    { Mark the FLAGS register as used across this whole block }
                    AllocRegBetween(NR_DEFAULTFLAGS, p, hp1, UsedRegs);
                  end;

                UpdateUsedRegs(TmpUsedRegs, tai(hp1.next));

                JumpC := taicpu(hp2).condition;
                Unconditional := False;

                if conditions_equal(JumpC, C_E) then
                  SetC := inverse_cond(taicpu(p).condition)
                else if conditions_equal(JumpC, C_NE) then
                  SetC := taicpu(p).condition
                else
                  { We've got something weird here (and inefficent) }
                  begin
                    DebugMsg('DEBUG: Inefficient jump - check code generation', p);
                    SetC := C_NONE;

                    { JAE/JNB will always branch (use 'condition_in', since C_AE <> C_NB normally) }
                    if condition_in(C_AE, JumpC) then
                      Unconditional := True
                    else
                      { Not sure what to do with this jump - drop out }
                      Exit;
                  end;

                RemoveInstruction(hp1);

                if Unconditional then
                  MakeUnconditional(taicpu(hp2))
                else
                  begin
                    if SetC = C_NONE then
                      InternalError(2018061402);

                    taicpu(hp2).SetCondition(SetC);
                  end;

                if not RegUsedAfterInstruction(taicpu(p).oper[0]^.reg, hp2, TmpUsedRegs) then
                  begin
                    RemoveCurrentp(p, hp2);
                    DebugMsg(SPeepholeOptimization + 'SETcc/TEST/Jcc -> Jcc',p);
                  end
                else
                  DebugMsg(SPeepholeOptimization + 'SETcc/TEST/Jcc -> SETcc/Jcc',p);

                Result := True;
              end
            else if
              { Make sure the instructions are adjacent }
              (
                not (cs_opt_level3 in current_settings.optimizerswitches) or
                GetNextInstruction(p, hp1)
              ) and
              MatchInstruction(hp1, A_MOV, [S_B]) and
              { Writing to memory is allowed }
              MatchOperand(taicpu(p).oper[0]^, taicpu(hp1).oper[0]^.reg) then
              begin
                {
                  Watch out for sequences such as:

                  set(c)b %regb
                  movb    %regb,(ref)
                  movb    $0,1(ref)
                  movb    $0,2(ref)
                  movb    $0,3(ref)

                  Much more efficient to turn it into:
                    movl    $0,%regl
                    set(c)b %regb
                    movl    %regl,(ref)

                  Or:
                    set(c)b %regb
                    movzbl  %regb,%regl
                    movl    %regl,(ref)
                }
                if (taicpu(hp1).oper[1]^.typ = top_ref) and
                  GetNextInstruction(hp1, hp2) and
                  MatchInstruction(hp2, A_MOV, [S_B]) and
                  (taicpu(hp2).oper[1]^.typ = top_ref) and
                  CheckMemoryWrite(taicpu(hp1), taicpu(hp2)) then
                  begin
                    { Don't do anything else except set Result to True }
                  end
                else
                  begin
                    if taicpu(p).oper[0]^.typ = top_reg then
                      begin
                        TransferUsedRegs(TmpUsedRegs);
                        UpdateUsedRegs(TmpUsedRegs, tai(p.Next));
                      end;

                    { If it's not a register, it's a memory address }
                    if (taicpu(p).oper[0]^.typ <> top_reg) or RegUsedAfterInstruction(taicpu(p).oper[0]^.reg, hp1, TmpUsedRegs) then
                      begin
                        { Even if the register is still in use, we can minimise the
                          pipeline stall by changing the MOV into another SETcc. }
                        taicpu(hp1).opcode := A_SETcc;
                        taicpu(hp1).condition := taicpu(p).condition;
                        if taicpu(hp1).oper[1]^.typ = top_ref then
                          begin
                            { Swapping the operand pointers like this is probably a
                              bit naughty, but it is far faster than using loadoper
                              to transfer the reference from oper[1] to oper[0] if
                              you take into account the extra procedure calls and
                              the memory allocation and deallocation required }
                            OperPtr := taicpu(hp1).oper[1];
                            taicpu(hp1).oper[1] := taicpu(hp1).oper[0];
                            taicpu(hp1).oper[0] := OperPtr;
                          end
                        else
                          taicpu(hp1).oper[0]^.reg := taicpu(hp1).oper[1]^.reg;

                        taicpu(hp1).clearop(1);
                        taicpu(hp1).ops := 1;
                        DebugMsg(SPeepholeOptimization + 'SETcc/Mov -> SETcc/SETcc',p);
                      end
                    else
                      begin
                        if taicpu(hp1).oper[1]^.typ = top_reg then
                          AllocRegBetween(taicpu(hp1).oper[1]^.reg,p,hp1,UsedRegs);

                        taicpu(p).loadoper(0, taicpu(hp1).oper[1]^);
                        RemoveInstruction(hp1);
                        DebugMsg(SPeepholeOptimization + 'SETcc/Mov -> SETcc',p);
                      end
                  end;
                Result := True;
              end;
          end;
      end;


    function TX86AsmOptimizer.OptPass2Jmp(var p : tai) : boolean;
      var
        hp1: tai;
        Count: Integer;
        OrigLabel: TAsmLabel;
      begin
        result := False;

        { Sometimes, the optimisations below can permit this }
        RemoveDeadCodeAfterJump(p);

        if (taicpu(p).oper[0]^.typ=top_ref) and (taicpu(p).oper[0]^.ref^.refaddr=addr_full) and (taicpu(p).oper[0]^.ref^.base=NR_NO) and
          (taicpu(p).oper[0]^.ref^.index=NR_NO) and (taicpu(p).oper[0]^.ref^.symbol is tasmlabel) then
          begin
            OrigLabel := TAsmLabel(taicpu(p).oper[0]^.ref^.symbol);

            { Also a side-effect of optimisations }
            if CollapseZeroDistJump(p, OrigLabel) then
              begin
                Result := True;
                Exit;
              end;

            hp1 := GetLabelWithSym(OrigLabel);
            if (taicpu(p).condition=C_None) and assigned(hp1) and SkipLabels(hp1,hp1) and (hp1.typ = ait_instruction) then
              begin
                case taicpu(hp1).opcode of
                  A_RET:
                    {
                      change
                             jmp .L1
                             ...
                         .L1:
                             ret
                      into
                             ret
                    }
                    begin
                      ConvertJumpToRET(p, hp1);
                      result:=true;
                    end;
                  { Check any kind of direct assignment instruction }
                  A_MOV,
                  A_MOVD,
                  A_MOVQ,
                  A_MOVSX,
{$ifdef x86_64}
                  A_MOVSXD,
{$endif x86_64}
                  A_MOVZX,
                  A_MOVAPS,
                  A_MOVUPS,
                  A_MOVSD,
                  A_MOVAPD,
                  A_MOVUPD,
                  A_MOVDQA,
                  A_MOVDQU,
                  A_VMOVSS,
                  A_VMOVAPS,
                  A_VMOVUPS,
                  A_VMOVSD,
                  A_VMOVAPD,
                  A_VMOVUPD,
                  A_VMOVDQA,
                  A_VMOVDQU:
                    if ((current_settings.optimizerswitches * [cs_opt_level3, cs_opt_size]) <> [cs_opt_size]) and
                      CheckJumpMovTransferOpt(p, hp1, 0, Count) then
                      begin
                        Result := True;
                        Exit;
                      end;
                  else
                    ;
                end;
              end;
          end;
      end;


    class function TX86AsmOptimizer.CanBeCMOV(p : tai) : boolean;
      begin
         CanBeCMOV:=assigned(p) and
           MatchInstruction(p,A_MOV,[S_W,S_L,S_Q]) and
           { we can't use cmov ref,reg because
             ref could be nil and cmov still throws an exception
             if ref=nil but the mov isn't done (FK)
            or ((taicpu(p).oper[0]^.typ = top_ref) and
             (taicpu(p).oper[0]^.ref^.refaddr = addr_no))
           }
           (taicpu(p).oper[1]^.typ = top_reg) and
           (
             (taicpu(p).oper[0]^.typ = top_reg) or
             { allow references, but only pure symbols or got rel. addressing with RIP as based,
               it is not expected that this can cause a seg. violation }
             (
               (taicpu(p).oper[0]^.typ = top_ref) and
               IsRefSafe(taicpu(p).oper[0]^.ref)
             )
           );
      end;


    function TX86AsmOptimizer.OptPass2Jcc(var p : tai) : boolean;
      var
        hp1,hp2: tai;
{$ifndef i8086}
        hp3,hp4,hpmov2, hp5: tai;
        l : Longint;
        condition : TAsmCond;
{$endif i8086}
        carryadd_opcode : TAsmOp;
        symbol: TAsmSymbol;
        reg: tsuperregister;
        increg, tmpreg: TRegister;
      begin
        result:=false;
        if GetNextInstruction(p,hp1) and (hp1.typ=ait_instruction) then
          begin
            symbol := TAsmLabel(taicpu(p).oper[0]^.ref^.symbol);
            if (
                (
                  ((Taicpu(hp1).opcode=A_ADD) or (Taicpu(hp1).opcode=A_SUB)) and
                  MatchOptype(Taicpu(hp1),top_const,top_reg) and
                  (Taicpu(hp1).oper[0]^.val=1)
                ) or
                ((Taicpu(hp1).opcode=A_INC) or (Taicpu(hp1).opcode=A_DEC))
              ) and
              GetNextInstruction(hp1,hp2) and
              SkipAligns(hp2, hp2) and
              (hp2.typ = ait_label) and
              (Tasmlabel(symbol) = Tai_label(hp2).labsym) then
             { jb @@1                            cmc
               inc/dec operand           -->     adc/sbb operand,0
               @@1:

               ... and ...

               jnb @@1
               inc/dec operand           -->     adc/sbb operand,0
               @@1: }
              begin
                if Taicpu(p).condition in [C_NAE,C_B,C_C] then
                  begin
                    case taicpu(hp1).opcode of
                      A_INC,
                      A_ADD:
                        carryadd_opcode:=A_ADC;
                      A_DEC,
                      A_SUB:
                        carryadd_opcode:=A_SBB;
                      else
                        InternalError(2021011001);
                    end;

                    Taicpu(p).clearop(0);
                    Taicpu(p).ops:=0;
                    Taicpu(p).is_jmp:=false;
                    Taicpu(p).opcode:=A_CMC;
                    Taicpu(p).condition:=C_NONE;
                    DebugMsg(SPeepholeOptimization+'JccAdd/Inc/Dec2CmcAdc/Sbb',p);
                    Taicpu(hp1).ops:=2;
                    if (Taicpu(hp1).opcode=A_ADD) or (Taicpu(hp1).opcode=A_SUB) then
                      Taicpu(hp1).loadoper(1,Taicpu(hp1).oper[1]^)
                    else
                      Taicpu(hp1).loadoper(1,Taicpu(hp1).oper[0]^);
                    Taicpu(hp1).loadconst(0,0);
                    Taicpu(hp1).opcode:=carryadd_opcode;
                    result:=true;
                    exit;
                  end
                else if Taicpu(p).condition in [C_AE,C_NB,C_NC] then
                  begin
                    case taicpu(hp1).opcode of
                      A_INC,
                      A_ADD:
                        carryadd_opcode:=A_ADC;
                      A_DEC,
                      A_SUB:
                        carryadd_opcode:=A_SBB;
                      else
                        InternalError(2021011002);
                    end;

                    Taicpu(hp1).ops:=2;
                    DebugMsg(SPeepholeOptimization+'JccAdd/Inc/Dec2Adc/Sbb',p);
                    if (Taicpu(hp1).opcode=A_ADD) or (Taicpu(hp1).opcode=A_SUB) then
                      Taicpu(hp1).loadoper(1,Taicpu(hp1).oper[1]^)
                    else
                      Taicpu(hp1).loadoper(1,Taicpu(hp1).oper[0]^);
                    Taicpu(hp1).loadconst(0,0);
                    Taicpu(hp1).opcode:=carryadd_opcode;
                    RemoveCurrentP(p, hp1);
                    result:=true;
                    exit;
                  end
                 {
                   jcc @@1                            setcc tmpreg
                   inc/dec/add/sub operand    ->      (movzx tmpreg)
                   @@1:                               add/sub tmpreg,operand

                   While this increases code size slightly, it makes the code much faster if the
                   jump is unpredictable
                 }
                 else if not(cs_opt_size in current_settings.optimizerswitches) then
                   begin
                     { search for an available register which is volatile }
                     for reg in tcpuregisterset do
                       begin
                         if
 {$if defined(i386) or defined(i8086)}
                           { Only use registers whose lowest 8-bits can Be accessed }
                           (reg in [RS_EAX,RS_EBX,RS_ECX,RS_EDX]) and
 {$endif i386 or i8086}
                           (reg in paramanager.get_volatile_registers_int(current_procinfo.procdef.proccalloption)) and
                           not(reg in UsedRegs[R_INTREGISTER].GetUsedRegs)
                           { We don't need to check if tmpreg is in hp1 or not, because
                             it will be marked as in use at p (if not, this is
                             indictive of a compiler bug). }
                           then
                           begin
                             TAsmLabel(symbol).decrefs;
                             increg := newreg(R_INTREGISTER,reg,R_SUBL);
                             Taicpu(p).clearop(0);
                             Taicpu(p).ops:=1;
                             Taicpu(p).is_jmp:=false;
                             Taicpu(p).opcode:=A_SETcc;
                             DebugMsg(SPeepholeOptimization+'JccAdd2SetccAdd',p);
                             Taicpu(p).condition:=inverse_cond(Taicpu(p).condition);
                             Taicpu(p).loadreg(0,increg);

                             if getsubreg(Taicpu(hp1).oper[1]^.reg)<>R_SUBL then
                               begin
                                 case getsubreg(Taicpu(hp1).oper[1]^.reg) of
                                   R_SUBW:
                                     begin
                                       tmpreg := newreg(R_INTREGISTER,reg,R_SUBW);
                                       hp2:=Taicpu.op_reg_reg(A_MOVZX,S_BW,increg,tmpreg);
                                     end;
                                   R_SUBD:
                                     begin
                                       tmpreg := newreg(R_INTREGISTER,reg,R_SUBD);
                                       hp2:=Taicpu.op_reg_reg(A_MOVZX,S_BL,increg,tmpreg);
                                     end;
 {$ifdef x86_64}
                                   R_SUBQ:
                                     begin
                                       { MOVZX doesn't have a 64-bit variant, because
                                         the 32-bit version implicitly zeroes the
                                         upper 32-bits of the destination register }
                                       hp2:=Taicpu.op_reg_reg(A_MOVZX,S_BL,increg,
                                         newreg(R_INTREGISTER,reg,R_SUBD));
                                       tmpreg := newreg(R_INTREGISTER,reg,R_SUBQ);
                                     end;
 {$endif x86_64}
                                   else
                                     Internalerror(2020030601);
                                 end;
                                 taicpu(hp2).fileinfo:=taicpu(hp1).fileinfo;
                                 asml.InsertAfter(hp2,p);
                               end
                             else
                               tmpreg := increg;

                             if (Taicpu(hp1).opcode=A_INC) or (Taicpu(hp1).opcode=A_DEC) then
                               begin
                                 Taicpu(hp1).ops:=2;
                                 Taicpu(hp1).loadoper(1,Taicpu(hp1).oper[0]^)
                               end;
                             Taicpu(hp1).loadreg(0,tmpreg);
                             AllocRegBetween(tmpreg,p,hp1,UsedRegs);

                             Result := True;

                             { p is no longer a Jcc instruction, so exit }
                             Exit;
                           end;
                       end;
                   end;
               end;

              { Detect the following:
                  jmp<cond>     @Lbl1
                  jmp           @Lbl2
                  ...
                @Lbl1:
                  ret

                Change to:

                  jmp<inv_cond> @Lbl2
                  ret
              }
              if MatchInstruction(hp1,A_JMP,[]) and (taicpu(hp1).oper[0]^.ref^.refaddr=addr_full) then
                begin
                  hp2:=getlabelwithsym(TAsmLabel(symbol));
                  if Assigned(hp2) and SkipLabels(hp2,hp2) and
                    MatchInstruction(hp2,A_RET,[S_NO]) then
                    begin
                      taicpu(p).condition := inverse_cond(taicpu(p).condition);

                      { Change label address to that of the unconditional jump }
                      taicpu(p).loadoper(0, taicpu(hp1).oper[0]^);

                      TAsmLabel(symbol).DecRefs;
                      taicpu(hp1).opcode := A_RET;
                      taicpu(hp1).is_jmp := false;
                      taicpu(hp1).ops := taicpu(hp2).ops;
                      DebugMsg(SPeepholeOptimization+'JccJmpRet2J!ccRet',p);
                      case taicpu(hp2).ops of
                        0:
                          taicpu(hp1).clearop(0);
                        1:
                          taicpu(hp1).loadconst(0,taicpu(hp2).oper[0]^.val);
                        else
                          internalerror(2016041302);
                      end;
                    end;
{$ifndef i8086}
                end
              {
                  convert
                  j<c>  .L1
                  mov   1,reg
                  jmp   .L2
                .L1
                  mov   0,reg
                .L2

                into
                  mov   0,reg
                  set<not(c)> reg

                take care of alignment and that the mov 0,reg is not converted into a xor as this
                would destroy the flag contents
              }
              else if MatchInstruction(hp1,A_MOV,[]) and
                MatchOpType(taicpu(hp1),top_const,top_reg) and
{$ifdef i386}
                (
                { Under i386, ESI, EDI, EBP and ESP
                  don't have an 8-bit representation }
                  not (getsupreg(taicpu(hp1).oper[1]^.reg) in [RS_ESI, RS_EDI, RS_EBP, RS_ESP])
                ) and
{$endif i386}
                (taicpu(hp1).oper[0]^.val=1) and
                GetNextInstruction(hp1,hp2) and
                MatchInstruction(hp2,A_JMP,[]) and (taicpu(hp2).oper[0]^.ref^.refaddr=addr_full) and
                GetNextInstruction(hp2,hp3) and
                { skip align }
                ((hp3.typ<>ait_align) or GetNextInstruction(hp3,hp3)) and
                (hp3.typ=ait_label) and
                (tasmlabel(taicpu(p).oper[0]^.ref^.symbol)=tai_label(hp3).labsym) and
                (tai_label(hp3).labsym.getrefs=1) and
                GetNextInstruction(hp3,hp4) and
                MatchInstruction(hp4,A_MOV,[]) and
                MatchOpType(taicpu(hp4),top_const,top_reg) and
                (taicpu(hp4).oper[0]^.val=0) and
                MatchOperand(taicpu(hp1).oper[1]^,taicpu(hp4).oper[1]^) and
                GetNextInstruction(hp4,hp5) and
                (hp5.typ=ait_label) and
                (tasmlabel(taicpu(hp2).oper[0]^.ref^.symbol)=tai_label(hp5).labsym) and
                (tai_label(hp5).labsym.getrefs=1) then
                begin
                  AllocRegBetween(NR_FLAGS,p,hp4,UsedRegs);
                  DebugMsg(SPeepholeOptimization+'JccMovJmpMov2MovSetcc',p);
                  { remove last label }
                  RemoveInstruction(hp5);
                  { remove second label }
                  RemoveInstruction(hp3);
                  { if align is present remove it }
                  if GetNextInstruction(hp2,hp3) and (hp3.typ=ait_align) then
                    RemoveInstruction(hp3);
                  { remove jmp }
                  RemoveInstruction(hp2);
                  if taicpu(hp1).opsize=S_B then
                    RemoveInstruction(hp1)
                  else
                    taicpu(hp1).loadconst(0,0);
                  taicpu(hp4).opcode:=A_SETcc;
                  taicpu(hp4).opsize:=S_B;
                  taicpu(hp4).condition:=inverse_cond(taicpu(p).condition);
                  taicpu(hp4).loadreg(0,newreg(R_INTREGISTER,getsupreg(taicpu(hp4).oper[1]^.reg),R_SUBL));
                  taicpu(hp4).opercnt:=1;
                  taicpu(hp4).ops:=1;
                  taicpu(hp4).freeop(1);
                  RemoveCurrentP(p);
                  Result:=true;
                  exit;
                end
              else if CPUX86_HAS_CMOV in cpu_capabilities[current_settings.cputype] then
                begin
                 { check for
                        jCC   xxx
                        <several movs>
                     xxx:
                 }
                 l:=0;
                 while assigned(hp1) and
                   CanBeCMOV(hp1) and
                   { stop on labels }
                   not(hp1.typ=ait_label) do
                   begin
                      inc(l);
                      GetNextInstruction(hp1,hp1);
                   end;
                 if assigned(hp1) then
                   begin
                      if FindLabel(tasmlabel(symbol),hp1) then
                        begin
                          if (l<=4) and (l>0) then
                            begin
                              condition:=inverse_cond(taicpu(p).condition);
                              GetNextInstruction(p,hp1);
                              repeat
                                if not Assigned(hp1) then
                                  InternalError(2018062900);

                                taicpu(hp1).opcode:=A_CMOVcc;
                                taicpu(hp1).condition:=condition;
                                UpdateUsedRegs(hp1);
                                GetNextInstruction(hp1,hp1);
                              until not(CanBeCMOV(hp1));

                              { Remember what hp1 is in case there's multiple aligns to get rid of }
                              hp2 := hp1;
                              repeat
                                if not Assigned(hp2) then
                                  InternalError(2018062910);

                                case hp2.typ of
                                  ait_label:
                                    { What we expected - break out of the loop (it won't be a dead label at the top of
                                      a cluster because that was optimised at an earlier stage) }
                                    Break;
                                  ait_align:
                                    { Go to the next entry until a label is found (may be multiple aligns before it) }
                                    begin
                                      hp2 := tai(hp2.Next);
                                      Continue;
                                    end;
                                  else
                                    begin
                                      { Might be a comment or temporary allocation entry }
                                      if not (hp2.typ in SkipInstr) then
                                        InternalError(2018062911);

                                      hp2 := tai(hp2.Next);
                                      Continue;
                                    end;
                                end;

                              until False;

                              { Now we can safely decrement the reference count }
                              tasmlabel(symbol).decrefs;

                              DebugMsg(SPeepholeOptimization+'JccMov2CMov',p);

                              { Remove the original jump }
                              RemoveInstruction(p); { Note, the choice to not use RemoveCurrentp is deliberate }

                              GetNextInstruction(hp2, p); { Instruction after the label }

                              { Remove the label if this is its final reference }
                              if (tasmlabel(symbol).getrefs=0) then
                                StripLabelFast(hp1);

                              if Assigned(p) then
                                begin
                                  UpdateUsedRegs(p);
                                  result:=true;
                                end;
                              exit;
                            end;
                        end
                      else
                        begin
                           { check further for
                                  jCC   xxx
                                  <several movs 1>
                                  jmp   yyy
                          xxx:
                                  <several movs 2>
                          yyy:
                           }
                          { hp2 points to jmp yyy }
                          hp2:=hp1;
                          { skip hp1 to xxx (or an align right before it) }
                          GetNextInstruction(hp1, hp1);

                          if assigned(hp2) and
                            assigned(hp1) and
                            (l<=3) and
                            (hp2.typ=ait_instruction) and
                            (taicpu(hp2).is_jmp) and
                            (taicpu(hp2).condition=C_None) and
                            { real label and jump, no further references to the
                              label are allowed }
                            (tasmlabel(symbol).getrefs=1) and
                            FindLabel(tasmlabel(symbol),hp1) then
                             begin
                               l:=0;
                               { skip hp1 to <several moves 2> }
                               if (hp1.typ = ait_align) then
                                 GetNextInstruction(hp1, hp1);

                               GetNextInstruction(hp1, hpmov2);

                               hp1 := hpmov2;
                               while assigned(hp1) and
                                 CanBeCMOV(hp1) do
                                 begin
                                   inc(l);
                                   GetNextInstruction(hp1, hp1);
                                 end;
                               { hp1 points to yyy (or an align right before it) }
                               hp3 := hp1;
                               if assigned(hp1) and
                                 FindLabel(tasmlabel(taicpu(hp2).oper[0]^.ref^.symbol),hp1) then
                                 begin
                                    condition:=inverse_cond(taicpu(p).condition);
                                    GetNextInstruction(p,hp1);
                                    repeat
                                      taicpu(hp1).opcode:=A_CMOVcc;
                                      taicpu(hp1).condition:=condition;
                                      UpdateUsedRegs(hp1);
                                      GetNextInstruction(hp1,hp1);
                                    until not(assigned(hp1)) or
                                      not(CanBeCMOV(hp1));

                                    condition:=inverse_cond(condition);
                                    hp1 := hpmov2;
                                    { hp1 is now at <several movs 2> }
                                    while Assigned(hp1) and CanBeCMOV(hp1) do
                                      begin
                                        taicpu(hp1).opcode:=A_CMOVcc;
                                        taicpu(hp1).condition:=condition;
                                        UpdateUsedRegs(hp1);
                                        GetNextInstruction(hp1,hp1);
                                      end;

                                    hp1 := p;

                                    { Get first instruction after label }
                                    GetNextInstruction(hp3, p);

                                    if assigned(p) and (hp3.typ = ait_align) then
                                      GetNextInstruction(p, p);

                                    { Don't dereference yet, as doing so will cause
                                      GetNextInstruction to skip the label and
                                      optional align marker. [Kit] }
                                    GetNextInstruction(hp2, hp4);

                                    DebugMsg(SPeepholeOptimization+'JccMovJmpMov2CMovCMov',hp1);

                                    { remove jCC }
                                    RemoveInstruction(hp1);

                                    { Now we can safely decrement it }
                                    tasmlabel(symbol).decrefs;

                                    { Remove label xxx (it will have a ref of zero due to the initial check }
                                    StripLabelFast(hp4);

                                    { remove jmp }
                                    symbol := taicpu(hp2).oper[0]^.ref^.symbol;

                                    RemoveInstruction(hp2);

                                    { As before, now we can safely decrement it }
                                    tasmlabel(symbol).decrefs;

                                    { Remove label yyy (and the optional alignment) if its reference falls to zero }
                                    if tasmlabel(symbol).getrefs = 0 then
                                      StripLabelFast(hp3);

                                    if Assigned(p) then
                                      begin
                                        UpdateUsedRegs(p);
                                        result:=true;
                                      end;
                                    exit;
                                 end;
                             end;
                        end;
                   end;
{$endif i8086}
              end;
          end;
      end;


    function TX86AsmOptimizer.OptPass1Movx(var p : tai) : boolean;
      var
        hp1,hp2: tai;
        reg_and_hp1_is_instr: Boolean;
      begin
        result:=false;
        reg_and_hp1_is_instr:=(taicpu(p).oper[1]^.typ = top_reg) and
          GetNextInstruction(p,hp1) and
          (hp1.typ = ait_instruction);

        if reg_and_hp1_is_instr and
          (
            (taicpu(hp1).opcode <> A_LEA) or
            { If the LEA instruction can be converted into an arithmetic instruction,
              it may be possible to then fold it. }
            (
              { If the flags register is in use, don't change the instruction
                to an ADD otherwise this will scramble the flags. [Kit] }
              not RegInUsedRegs(NR_DEFAULTFLAGS, UsedRegs) and
              ConvertLEA(taicpu(hp1))
            )
          ) and
          IsFoldableArithOp(taicpu(hp1),taicpu(p).oper[1]^.reg) and
          GetNextInstruction(hp1,hp2) and
          MatchInstruction(hp2,A_MOV,[]) and
          (taicpu(hp2).oper[0]^.typ = top_reg) and
          OpsEqual(taicpu(hp2).oper[1]^,taicpu(p).oper[0]^) and
          ((taicpu(p).opsize in [S_BW,S_BL]) and (taicpu(hp2).opsize=S_B) or
           (taicpu(p).opsize in [S_WL]) and (taicpu(hp2).opsize=S_W)) and
{$ifdef i386}
           { not all registers have byte size sub registers on i386 }
           ((taicpu(hp2).opsize<>S_B) or (getsupreg(taicpu(hp1).oper[0]^.reg) in [RS_EAX, RS_EBX, RS_ECX, RS_EDX])) and
{$endif i386}
           (((taicpu(hp1).ops=2) and
             (getsupreg(taicpu(hp2).oper[0]^.reg)=getsupreg(taicpu(hp1).oper[1]^.reg))) or
             ((taicpu(hp1).ops=1) and
             (getsupreg(taicpu(hp2).oper[0]^.reg)=getsupreg(taicpu(hp1).oper[0]^.reg)))) and
           not(RegUsedAfterInstruction(taicpu(hp2).oper[0]^.reg,hp2,UsedRegs)) then
          begin
            { change   movsX/movzX    reg/ref, reg2
                       add/sub/or/... reg3/$const, reg2
                       mov            reg2 reg/ref
              to       add/sub/or/... reg3/$const, reg/ref      }

            { by example:
                movswl  %si,%eax        movswl  %si,%eax      p
                decl    %eax            addl    %edx,%eax     hp1
                movw    %ax,%si         movw    %ax,%si       hp2
              ->
                movswl  %si,%eax        movswl  %si,%eax      p
                decw    %eax            addw    %edx,%eax     hp1
                movw    %ax,%si         movw    %ax,%si       hp2
            }
            taicpu(hp1).changeopsize(taicpu(hp2).opsize);
            {
              ->
                movswl  %si,%eax        movswl  %si,%eax      p
                decw    %si             addw    %dx,%si       hp1
                movw    %ax,%si         movw    %ax,%si       hp2
            }
            case taicpu(hp1).ops of
              1:
               taicpu(hp1).loadoper(0,taicpu(hp2).oper[1]^);
              2:
                begin
                  taicpu(hp1).loadoper(1,taicpu(hp2).oper[1]^);
                  if (taicpu(hp1).oper[0]^.typ = top_reg) then
                    setsubreg(taicpu(hp1).oper[0]^.reg,getsubreg(taicpu(hp2).oper[0]^.reg));
                end;
              else
                internalerror(2008042702);
            end;
            {
              ->
                decw    %si             addw    %dx,%si       p
            }
            DebugMsg(SPeepholeOptimization + 'var3',p);
            RemoveCurrentP(p, hp1);
            RemoveInstruction(hp2);
          end
        else if reg_and_hp1_is_instr and
          (taicpu(hp1).opcode = A_MOV) and
          MatchOpType(taicpu(hp1),top_reg,top_reg) and
          (MatchOperand(taicpu(p).oper[1]^,taicpu(hp1).oper[0]^)
{$ifdef x86_64}
           { check for implicit extension to 64 bit }
           or
           ((taicpu(p).opsize in [S_BL,S_WL]) and
            (taicpu(hp1).opsize=S_Q) and
            SuperRegistersEqual(taicpu(p).oper[1]^.reg,taicpu(hp1).oper[0]^.reg)
           )
{$endif x86_64}
          )
          then
          begin
            { change
              movx   %reg1,%reg2
              mov    %reg2,%reg3
              dealloc %reg2

              into

              movx   %reg,%reg3
            }
            TransferUsedRegs(TmpUsedRegs);
            UpdateUsedRegs(TmpUsedRegs, tai(p.next));
            if not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp1,TmpUsedRegs)) then
              begin
                DebugMsg(SPeepholeOptimization + 'MovxMov2Movx',p);
{$ifdef x86_64}
                if (taicpu(p).opsize in [S_BL,S_WL]) and
                  (taicpu(hp1).opsize=S_Q) then
                  taicpu(p).loadreg(1,newreg(R_INTREGISTER,getsupreg(taicpu(hp1).oper[1]^.reg),R_SUBD))
                else
{$endif x86_64}
                  taicpu(p).loadreg(1,taicpu(hp1).oper[1]^.reg);
                RemoveInstruction(hp1);
              end;
          end
        else if reg_and_hp1_is_instr and
          (taicpu(hp1).opcode = A_MOV) and
          MatchOpType(taicpu(hp1),top_reg,top_reg) and
          (((taicpu(p).opsize in [S_BW,S_BL,S_WL{$ifdef x86_64},S_BQ,S_WQ,S_LQ{$endif x86_64}]) and
           (taicpu(hp1).opsize=S_B)) or
           ((taicpu(p).opsize in [S_WL{$ifdef x86_64},S_WQ,S_LQ{$endif x86_64}]) and
           (taicpu(hp1).opsize=S_W))
{$ifdef x86_64}
           or ((taicpu(p).opsize=S_LQ) and
            (taicpu(hp1).opsize=S_L))
{$endif x86_64}
          ) and
          SuperRegistersEqual(taicpu(p).oper[1]^.reg,taicpu(hp1).oper[0]^.reg) then
          begin
            { change
              movx   %reg1,%reg2
              mov    %reg2,%reg3
              dealloc %reg2

              into

              mov   %reg1,%reg3

              if the second mov accesses only the bits stored in reg1
            }
            TransferUsedRegs(TmpUsedRegs);
            UpdateUsedRegs(TmpUsedRegs, tai(p.next));
            if not(RegUsedAfterInstruction(taicpu(p).oper[1]^.reg,hp1,TmpUsedRegs)) then
              begin
                DebugMsg(SPeepholeOptimization + 'MovxMov2Mov',p);
                if taicpu(p).oper[0]^.typ=top_reg then
                  begin
                    case taicpu(hp1).opsize of
                      S_B:
                        taicpu(hp1).loadreg(0,newreg(R_INTREGISTER,getsupreg(taicpu(p).oper[0]^.reg),R_SUBL));
                      S_W:
                        taicpu(hp1).loadreg(0,newreg(R_INTREGISTER,getsupreg(taicpu(p).oper[0]^.reg),R_SUBW));
                      S_L:
                        taicpu(hp1).loadreg(0,newreg(R_INTREGISTER,getsupreg(taicpu(p).oper[0]^.reg),R_SUBD));
                      else
                        Internalerror(2020102301);
                    end;
                    AllocRegBetween(taicpu(hp1).oper[0]^.reg,p,hp1,UsedRegs);
                  end
                else
                  taicpu(hp1).loadref(0,taicpu(p).oper[0]^.ref^);
                RemoveCurrentP(p);
                result:=true;
                exit;
              end;
          end
        else if reg_and_hp1_is_instr and
          (taicpu(p).oper[0]^.typ = top_reg) and
          (
            (taicpu(hp1).opcode = A_SHL) or (taicpu(hp1).opcode = A_SAL)
          ) and
          (taicpu(hp1).oper[0]^.typ = top_const) and
          SuperRegistersEqual(taicpu(p).oper[0]^.reg, taicpu(p).oper[1]^.reg) and
          MatchOperand(taicpu(hp1).oper[1]^, taicpu(p).oper[1]^.reg) and
          { Minimum shift value allowed is the bit difference between the sizes }
          (taicpu(hp1).oper[0]^.val >=
            { Multiply by 8 because tcgsize2size returns bytes, not bits }
            8 * (
              tcgsize2size[reg_cgsize(taicpu(p).oper[1]^.reg)] -
              tcgsize2size[reg_cgsize(taicpu(p).oper[0]^.reg)]
            )
          ) then
          begin
            { For:
                movsx/movzx %reg1,%reg1 (same register, just different sizes)
                shl/sal     ##,   %reg1

              Remove the movsx/movzx instruction if the shift overwrites the
              extended bits of the register (e.g. movslq %eax,%rax; shlq $32,%rax
            }
            DebugMsg(SPeepholeOptimization + 'MovxShl2Shl',p);
            RemoveCurrentP(p, hp1);
            Result := True;
            Exit;
          end
        else if reg_and_hp1_is_instr and
          (taicpu(p).oper[0]^.typ = top_reg) and
          (
            ((taicpu(hp1).opcode = A_SHR) and (taicpu(p).opcode = A_MOVZX)) or
            ((taicpu(hp1).opcode = A_SAR) and (taicpu(p).opcode <> A_MOVZX))
          ) and
          (taicpu(hp1).oper[0]^.typ = top_const) and
          SuperRegistersEqual(taicpu(p).oper[0]^.reg, taicpu(p).oper[1]^.reg) and
          MatchOperand(taicpu(hp1).oper[1]^, taicpu(p).oper[1]^.reg) and
          { Minimum shift value allowed is the bit size of the smallest register - 1 }
          (taicpu(hp1).oper[0]^.val <
            { Multiply by 8 because tcgsize2size returns bytes, not bits }
            8 * (
              tcgsize2size[reg_cgsize(taicpu(p).oper[0]^.reg)]
            )
          ) then
          begin
            { For:
                movsx   %reg1,%reg1     movzx   %reg1,%reg1   (same register, just different sizes)
                sar     ##,   %reg1     shr     ##,   %reg1

              Move the shift to before the movx instruction if the shift value
              is not too large.
            }
            asml.Remove(hp1);
            asml.InsertBefore(hp1, p);

            taicpu(hp1).oper[1]^.reg := taicpu(p).oper[0]^.reg;

            case taicpu(p).opsize of
              s_BW, S_BL{$ifdef x86_64}, S_BQ{$endif}:
                taicpu(hp1).opsize := S_B;
              S_WL{$ifdef x86_64}, S_WQ{$endif}:
                taicpu(hp1).opsize := S_W;
              {$ifdef x86_64}
              S_LQ:
                taicpu(hp1).opsize := S_L;
              {$endif}
              else
                InternalError(2020112401);
            end;

            if (taicpu(hp1).opcode = A_SHR) then
              DebugMsg(SPeepholeOptimization + 'MovzShr2ShrMovz', hp1)
            else
              DebugMsg(SPeepholeOptimization + 'MovsSar2SarMovs', hp1);

            Result := True;
          end
        else if taicpu(p).opcode=A_MOVZX then
          begin
            { removes superfluous And's after movzx's }
            if reg_and_hp1_is_instr and
              (taicpu(hp1).opcode = A_AND) and
              MatchOpType(taicpu(hp1),top_const,top_reg) and
              ((taicpu(hp1).oper[1]^.reg = taicpu(p).oper[1]^.reg)
{$ifdef x86_64}
               { check for implicit extension to 64 bit }
               or
               ((taicpu(p).opsize in [S_BL,S_WL]) and
                (taicpu(hp1).opsize=S_Q) and
                SuperRegistersEqual(taicpu(p).oper[1]^.reg,taicpu(hp1).oper[1]^.reg)
               )
{$endif x86_64}
              )
              then
              begin
                case taicpu(p).opsize Of
                  S_BL, S_BW{$ifdef x86_64}, S_BQ{$endif x86_64}:
                    if (taicpu(hp1).oper[0]^.val = $ff) then
                      begin
                        DebugMsg(SPeepholeOptimization + 'MovzAnd2Movz1',p);
                        RemoveInstruction(hp1);
                        Result:=true;
                        exit;
                      end;
                    S_WL{$ifdef x86_64}, S_WQ{$endif x86_64}:
                      if (taicpu(hp1).oper[0]^.val = $ffff) then
                        begin
                          DebugMsg(SPeepholeOptimization + 'MovzAnd2Movz2',p);
                          RemoveInstruction(hp1);
                          Result:=true;
                          exit;
                        end;
{$ifdef x86_64}
                    S_LQ:
                      if (taicpu(hp1).oper[0]^.val = $ffffffff) then
                        begin
                          DebugMsg(SPeepholeOptimization + 'MovzAnd2Movz3',p);
                          RemoveInstruction(hp1);
                          Result:=true;
                          exit;
                        end;
{$endif x86_64}
                    else
                      ;
                end;
                { we cannot get rid of the and, but can we get rid of the movz ?}
                if SuperRegistersEqual(taicpu(p).oper[0]^.reg,taicpu(p).oper[1]^.reg) then
                  begin
                    case taicpu(p).opsize Of
                      S_BL, S_BW{$ifdef x86_64}, S_BQ{$endif x86_64}:
                        if (taicpu(hp1).oper[0]^.val and $ff)=taicpu(hp1).oper[0]^.val then
                          begin
                            DebugMsg(SPeepholeOptimization + 'MovzAnd2And1',p);
                            RemoveCurrentP(p,hp1);
                            Result:=true;
                            exit;
                          end;
                        S_WL{$ifdef x86_64}, S_WQ{$endif x86_64}:
                          if (taicpu(hp1).oper[0]^.val and $ffff)=taicpu(hp1).oper[0]^.val then
                            begin
                              DebugMsg(SPeepholeOptimization + 'MovzAnd2And2',p);
                              RemoveCurrentP(p,hp1);
                              Result:=true;
                              exit;
                            end;
{$ifdef x86_64}
                        S_LQ:
                          if (taicpu(hp1).oper[0]^.val and $ffffffff)=taicpu(hp1).oper[0]^.val then
                            begin
                              DebugMsg(SPeepholeOptimization + 'MovzAnd2And3',p);
                              RemoveCurrentP(p,hp1);
                              Result:=true;
                              exit;
                            end;
{$endif x86_64}
                        else
                          ;
                    end;
                end;
              end;
            { changes some movzx constructs to faster synonyms (all examples
              are given with eax/ax, but are also valid for other registers)}
            if MatchOpType(taicpu(p),top_reg,top_reg) then
                begin
                  case taicpu(p).opsize of
                    { Technically, movzbw %al,%ax cannot be encoded in 32/64-bit mode
                      (the machine code is equivalent to movzbl %al,%eax), but the
                      code generator still generates that assembler instruction and
                      it is silently converted.  This should probably be checked.
                      [Kit] }
                    S_BW:
                      begin
                        if (getsupreg(taicpu(p).oper[0]^.reg)=getsupreg(taicpu(p).oper[1]^.reg)) and
                          (
                            not IsMOVZXAcceptable
                            { and $0xff,%ax has a smaller encoding but risks a partial write penalty }
                            or (
                              (cs_opt_size in current_settings.optimizerswitches) and
                              (taicpu(p).oper[1]^.reg = NR_AX)
                            )
                          ) then
                          {Change "movzbw %al, %ax" to "andw $0x0ffh, %ax"}
                          begin
                            DebugMsg(SPeepholeOptimization + 'var7',p);
                            taicpu(p).opcode := A_AND;
                            taicpu(p).changeopsize(S_W);
                            taicpu(p).loadConst(0,$ff);
                            Result := True;
                          end
                        else if not IsMOVZXAcceptable and
                          GetNextInstruction(p, hp1) and
                          (tai(hp1).typ = ait_instruction) and
                          (taicpu(hp1).opcode = A_AND) and
                          MatchOpType(taicpu(hp1),top_const,top_reg) and
                          (taicpu(hp1).oper[1]^.reg = taicpu(p).oper[1]^.reg) then
                        { Change "movzbw %reg1, %reg2; andw $const, %reg2"
                          to "movw %reg1, reg2; andw $(const1 and $ff), %reg2"}
                          begin
                            DebugMsg(SPeepholeOptimization + 'var8',p);
                            taicpu(p).opcode := A_MOV;
                            taicpu(p).changeopsize(S_W);
                            setsubreg(taicpu(p).oper[0]^.reg,R_SUBW);
                            taicpu(hp1).loadConst(0,taicpu(hp1).oper[0]^.val and $ff);
                            Result := True;
                          end;
                      end;
{$ifndef i8086} { movzbl %al,%eax cannot be encoded in 16-bit mode (the machine code is equivalent to movzbw %al,%ax }
                    S_BL:
                      begin
                        if (getsupreg(taicpu(p).oper[0]^.reg)=getsupreg(taicpu(p).oper[1]^.reg)) and
                          (
                            not IsMOVZXAcceptable
                            { and $0xff,%eax has a smaller encoding but risks a partial write penalty }
                            or (
                              (cs_opt_size in current_settings.optimizerswitches) and
                              (taicpu(p).oper[1]^.reg = NR_EAX)
                            )
                          ) then
                          { Change "movzbl %al, %eax" to "andl $0x0ffh, %eax" }
                          begin
                            DebugMsg(SPeepholeOptimization + 'var9',p);
                            taicpu(p).opcode := A_AND;
                            taicpu(p).changeopsize(S_L);
                            taicpu(p).loadConst(0,$ff);
                            Result := True;
                          end
                        else if not IsMOVZXAcceptable and
                          GetNextInstruction(p, hp1) and
                          (tai(hp1).typ = ait_instruction) and
                          (taicpu(hp1).opcode = A_AND) and
                          MatchOpType(taicpu(hp1),top_const,top_reg) and
                          (taicpu(hp1).oper[1]^.reg = taicpu(p).oper[1]^.reg) then
                          { Change "movzbl %reg1, %reg2; andl $const, %reg2"
                            to "movl %reg1, reg2; andl $(const1 and $ff), %reg2"}
                          begin
                            DebugMsg(SPeepholeOptimization + 'var10',p);
                            taicpu(p).opcode := A_MOV;
                            taicpu(p).changeopsize(S_L);
                            { do not use R_SUBWHOLE
                              as movl %rdx,%eax
                              is invalid in assembler PM }
                            setsubreg(taicpu(p).oper[0]^.reg, R_SUBD);
                            taicpu(hp1).loadConst(0,taicpu(hp1).oper[0]^.val and $ff);
                            Result := True;
                          end;
                      end;
{$endif i8086}
                    S_WL:
                      if not IsMOVZXAcceptable then
                        begin
                          if (getsupreg(taicpu(p).oper[0]^.reg)=getsupreg(taicpu(p).oper[1]^.reg)) then
                            { Change "movzwl %ax, %eax" to "andl $0x0ffffh, %eax" }
                            begin
                              DebugMsg(SPeepholeOptimization + 'var11',p);
                              taicpu(p).opcode := A_AND;
                              taicpu(p).changeopsize(S_L);
                              taicpu(p).loadConst(0,$ffff);
                              Result := True;
                            end
                          else if GetNextInstruction(p, hp1) and
                            (tai(hp1).typ = ait_instruction) and
                            (taicpu(hp1).opcode = A_AND) and
                            (taicpu(hp1).oper[0]^.typ = top_const) and
                            (taicpu(hp1).oper[1]^.typ = top_reg) and
                            (taicpu(hp1).oper[1]^.reg = taicpu(p).oper[1]^.reg) then
                            { Change "movzwl %reg1, %reg2; andl $const, %reg2"
                              to "movl %reg1, reg2; andl $(const1 and $ffff), %reg2"}
                            begin
                              DebugMsg(SPeepholeOptimization + 'var12',p);
                              taicpu(p).opcode := A_MOV;
                              taicpu(p).changeopsize(S_L);
                              { do not use R_SUBWHOLE
                                as movl %rdx,%eax
                                is invalid in assembler PM }
                              setsubreg(taicpu(p).oper[0]^.reg, R_SUBD);
                              taicpu(hp1).loadConst(0,taicpu(hp1).oper[0]^.val and $ffff);
                              Result := True;
                            end;
                        end;
                    else
                      InternalError(2017050705);
                  end;
                end
              else if not IsMOVZXAcceptable and (taicpu(p).oper[0]^.typ = top_ref) then
                  begin
                    if GetNextInstruction(p, hp1) and
                      (tai(hp1).typ = ait_instruction) and
                      (taicpu(hp1).opcode = A_AND) and
                      MatchOpType(taicpu(hp1),top_const,top_reg) and
                      (taicpu(hp1).oper[1]^.reg = taicpu(p).oper[1]^.reg) then
                      begin
                        //taicpu(p).opcode := A_MOV;
                        case taicpu(p).opsize Of
                          S_BL:
                            begin
                              DebugMsg(SPeepholeOptimization + 'var13',p);
                              taicpu(hp1).changeopsize(S_L);
                              taicpu(hp1).loadConst(0,taicpu(hp1).oper[0]^.val and $ff);
                            end;
                          S_WL:
                            begin
                              DebugMsg(SPeepholeOptimization + 'var14',p);
                              taicpu(hp1).changeopsize(S_L);
                              taicpu(hp1).loadConst(0,taicpu(hp1).oper[0]^.val and $ffff);
                            end;
                          S_BW:
                            begin
                              DebugMsg(SPeepholeOptimization + 'var15',p);
                              taicpu(hp1).changeopsize(S_W);
                              taicpu(hp1).loadConst(0,taicpu(hp1).oper[0]^.val and $ff);
                            end;
                          else
                            Internalerror(2017050704)
                        end;
                        Result := True;
                      end;
                  end;
          end;
      end;


    function TX86AsmOptimizer.OptPass1AND(var p : tai) : boolean;
      var
        hp1, hp2 : tai;
        MaskLength : Cardinal;
        MaskedBits : TCgInt;
      begin
        Result:=false;

        { There are no optimisations for reference targets }
        if (taicpu(p).oper[1]^.typ <> top_reg) then
          Exit;

        while GetNextInstruction(p, hp1) and
          (hp1.typ = ait_instruction) do
          begin
            if (taicpu(p).oper[0]^.typ = top_const) then
              begin
                if (taicpu(hp1).opcode = A_AND) and
                  MatchOpType(taicpu(hp1),top_const,top_reg) and
                  (getsupreg(taicpu(p).oper[1]^.reg) = getsupreg(taicpu(hp1).oper[1]^.reg)) and
                  { the second register must contain the first one, so compare their subreg types }
                  (getsubreg(taicpu(p).oper[1]^.reg)<=getsubreg(taicpu(hp1).oper[1]^.reg)) and
                  (abs(taicpu(p).oper[0]^.val and taicpu(hp1).oper[0]^.val)<$80000000) then
                  { change
                      and const1, reg
                      and const2, reg
                    to
                      and (const1 and const2), reg
                  }
                  begin
                    taicpu(hp1).loadConst(0, taicpu(p).oper[0]^.val and taicpu(hp1).oper[0]^.val);
                    DebugMsg(SPeepholeOptimization + 'AndAnd2And done',hp1);
                    RemoveCurrentP(p, hp1);
                    Result:=true;
                    exit;
                  end
                else if (taicpu(hp1).opcode = A_MOVZX) and
                  MatchOpType(taicpu(hp1),top_reg,top_reg) and
                  SuperRegistersEqual(taicpu(p).oper[1]^.reg,taicpu(hp1).oper[1]^.reg) and
                  (getsupreg(taicpu(hp1).oper[0]^.reg)=getsupreg(taicpu(hp1).oper[1]^.reg)) and
                   (((taicpu(p).opsize=S_W) and
                     (taicpu(hp1).opsize=S_BW)) or
                    ((taicpu(p).opsize=S_L) and
                     (taicpu(hp1).opsize in [S_WL,S_BL{$ifdef x86_64},S_BQ,S_WQ{$endif x86_64}]))
{$ifdef x86_64}
                      or
                     ((taicpu(p).opsize=S_Q) and
                      (taicpu(hp1).opsize in [S_BQ,S_WQ,S_BL,S_WL]))
{$endif x86_64}
                    ) then
                      begin
                        if (((taicpu(hp1).opsize) in [S_BW,S_BL{$ifdef x86_64},S_BQ{$endif x86_64}]) and
                            ((taicpu(p).oper[0]^.val and $ff)=taicpu(p).oper[0]^.val)
                             ) or
                           (((taicpu(hp1).opsize) in [S_WL{$ifdef x86_64},S_WQ{$endif x86_64}]) and
                            ((taicpu(p).oper[0]^.val and $ffff)=taicpu(p).oper[0]^.val))
                        then
                          begin
                            { Unlike MOVSX, MOVZX doesn't actually have a version that zero-extends a
                              32-bit register to a 64-bit register, or even a version called MOVZXD, so
                              code that tests for the presence of AND 0xffffffff followed by MOVZX is
                              wasted, and is indictive of a compiler bug if it were triggered. [Kit]

                              NOTE: To zero-extend from 32 bits to 64 bits, simply use the standard MOV.
                            }
                            DebugMsg(SPeepholeOptimization + 'AndMovzToAnd done',p);

                            RemoveInstruction(hp1);

                            { See if there are other optimisations possible }
                            Continue;
                          end;
                      end
                else if (taicpu(hp1).opcode = A_SHL) and
                  MatchOpType(taicpu(hp1),top_const,top_reg) and
                  (getsupreg(taicpu(p).oper[1]^.reg)=getsupreg(taicpu(hp1).oper[1]^.reg)) then
                  begin
{$ifopt R+}
{$define RANGE_WAS_ON}
{$R-}
{$endif}
                    { get length of potential and mask }
                    MaskLength:=SizeOf(taicpu(p).oper[0]^.val)*8-BsrQWord(taicpu(p).oper[0]^.val)-1;

                    { really a mask? }
{$ifdef RANGE_WAS_ON}
{$R+}
{$endif}
                    if (((QWord(1) shl MaskLength)-1)=taicpu(p).oper[0]^.val) and
                      { unmasked part shifted out? }
                      ((MaskLength+taicpu(hp1).oper[0]^.val)>=topsize2memsize[taicpu(hp1).opsize]) then
                      begin
                        DebugMsg(SPeepholeOptimization + 'AndShlToShl done',p);
                        RemoveCurrentP(p, hp1);
                        Result:=true;
                        exit;
                      end;
                  end
                else if (taicpu(hp1).opcode = A_SHR) and
                  MatchOpType(taicpu(hp1),top_const,top_reg) and
                  (taicpu(p).oper[1]^.reg = taicpu(hp1).oper[1]^.reg) and
                  (taicpu(hp1).oper[0]^.val <= 63) then
                  begin
                    { Does SHR combined with the AND cover all the bits?

                      e.g. for "andb $252,%reg; shrb $2,%reg" - the "and" can be removed }

                    MaskedBits := taicpu(p).oper[0]^.val or ((TCgInt(1) shl taicpu(hp1).oper[0]^.val) - 1);

                    if ((taicpu(p).opsize = S_B) and ((MaskedBits and $FF) = $FF)) or
                      ((taicpu(p).opsize = S_W) and ((MaskedBits and $FFFF) = $FFFF)) or
                      ((taicpu(p).opsize = S_L) and ((MaskedBits and $FFFFFFFF) = $FFFFFFFF)) then
                      begin
                        DebugMsg(SPeepholeOptimization + 'AndShrToShr done', p);
                        RemoveCurrentP(p, hp1);
                        Result := True;
                        Exit;
                      end;
                  end
                else if ((taicpu(hp1).opcode = A_MOVSX){$ifdef x86_64} or (taicpu(hp1).opcode = A_MOVSXD){$endif x86_64}) and
                  (taicpu(hp1).oper[0]^.typ = top_reg) and
                  SuperRegistersEqual(taicpu(hp1).oper[0]^.reg, taicpu(hp1).oper[1]^.reg) then
                    begin
                      if SuperRegistersEqual(taicpu(p).oper[1]^.reg, taicpu(hp1).oper[1]^.reg) and
                        (
                          (
                            (taicpu(hp1).opsize in [S_BW,S_BL{$ifdef x86_64},S_BQ{$endif x86_64}]) and
                            ((taicpu(p).oper[0]^.val and $7F) = taicpu(p).oper[0]^.val)
                          ) or (
                            (taicpu(hp1).opsize in [S_WL{$ifdef x86_64},S_WQ{$endif x86_64}]) and
                            ((taicpu(p).oper[0]^.val and $7FFF) = taicpu(p).oper[0]^.val)
{$ifdef x86_64}
                          ) or (
                            (taicpu(hp1).opsize = S_LQ) and
                            ((taicpu(p).oper[0]^.val and $7fffffff) = taicpu(p).oper[0]^.val)
{$endif x86_64}
                          )
                        ) then
                        begin
                          if (taicpu(p).oper[1]^.reg = taicpu(hp1).oper[1]^.reg){$ifdef x86_64} or (taicpu(hp1).opsize = S_LQ){$endif x86_64} then
                            begin
                              DebugMsg(SPeepholeOptimization + 'AndMovsxToAnd',p);
                              RemoveInstruction(hp1);
                              { See if there are other optimisations possible }
                              Continue;
                            end;

                          { The super-registers are the same though.

                            Note that this change by itself doesn't improve
                            code speed, but it opens up other optimisations. }
{$ifdef x86_64}
                          { Convert 64-bit register to 32-bit }
                          case taicpu(hp1).opsize of
                            S_BQ:
                              begin
                                taicpu(hp1).opsize := S_BL;
                                taicpu(hp1).oper[1]^.reg := newreg(R_INTREGISTER, getsupreg(taicpu(hp1).oper[1]^.reg), R_SUBD);
                              end;
                            S_WQ:
                              begin
                                taicpu(hp1).opsize := S_WL;
                                taicpu(hp1).oper[1]^.reg := newreg(R_INTREGISTER, getsupreg(taicpu(hp1).oper[1]^.reg), R_SUBD);
                              end
                            else
                              ;
                          end;
{$endif x86_64}
                          DebugMsg(SPeepholeOptimization + 'AndMovsxToAndMovzx', hp1);
                          taicpu(hp1).opcode := A_MOVZX;
                          { See if there are other optimisations possible }
                          Continue;
                        end;
                    end;
              end;

            if (taicpu(hp1).is_jmp) and
              (taicpu(hp1).opcode<>A_JMP) and
              not(RegInUsedRegs(taicpu(p).oper[1]^.reg,UsedRegs)) then
              begin
                { change
                    and x, reg
                    jxx
                  to
                    test x, reg
                    jxx
                  if reg is deallocated before the
                  jump, but only if it's a conditional jump (PFV)
                }
                taicpu(p).opcode := A_TEST;
                Exit;
              end;

            Break;
          end;

        { Lone AND tests }
        if (taicpu(p).oper[0]^.typ = top_const) then
          begin
            {
              - Convert and $0xFF,reg to and reg,reg if reg is 8-bit
              - Convert and $0xFFFF,reg to and reg,reg if reg is 16-bit
              - Convert and $0xFFFFFFFF,reg to and reg,reg if reg is 32-bit
            }
            if ((taicpu(p).oper[0]^.val = $FF) and (taicpu(p).opsize = S_B)) or
              ((taicpu(p).oper[0]^.val = $FFFF) and (taicpu(p).opsize = S_W)) or
              ((taicpu(p).oper[0]^.val = $FFFFFFFF) and (taicpu(p).opsize = S_L)) then
              begin
                taicpu(p).loadreg(0, taicpu(p).oper[1]^.reg);
                if taicpu(p).opsize = S_L then
                  begin
                    Include(OptsToCheck,aoc_MovAnd2Mov_3);
                    Result := True;
                  end;
              end;
          end;

        { Backward check to determine necessity of and %reg,%reg }
        if (taicpu(p).oper[0]^.typ = top_reg) and
          (taicpu(p).oper[0]^.reg = taicpu(p).oper[1]^.reg) and
          not RegInUsedRegs(NR_DEFAULTFLAGS, UsedRegs) and
          GetLastInstruction(p, hp2) and
          RegModifiedByInstruction(taicpu(p).oper[1]^.reg, hp2) and
          { Check size of adjacent instruction to determine if the AND is
            effectively a null operation }
          (
            (taicpu(p).opsize = taicpu(hp2).opsize) or
            { Note: Don't include S_Q }
            ((taicpu(p).opsize = S_L) and (taicpu(hp2).opsize in [S_BL, S_WL])) or
            ((taicpu(p).opsize = S_W) and (taicpu(hp2).opsize in [S_BW, S_BL, S_WL, S_L])) or
            ((taicpu(p).opsize = S_B) and (taicpu(hp2).opsize in [S_BW, S_BL, S_WL, S_W, S_L]))
          ) then
          begin
            DebugMsg(SPeepholeOptimization + 'And2Nop', p);
            { If GetNextInstruction returned False, hp1 will be nil }
            RemoveCurrentP(p, hp1);
            Result := True;
            Exit;
          end;

      end;


    function TX86AsmOptimizer.OptPass2ADD(var p : tai) : boolean;
      var
        hp1: tai; NewRef: TReference;

        { This entire nested function is used in an if-statement below, but we
          want to avoid all the used reg transfers and GetNextInstruction calls
          until we really have to check }
        function MemRegisterNotUsedLater: Boolean; inline;
          var
            hp2: tai;
          begin
            TransferUsedRegs(TmpUsedRegs);
            hp2 := p;
            repeat
              UpdateUsedRegs(TmpUsedRegs, tai(hp2.Next));
            until not GetNextInstruction(hp2, hp2) or (hp2 = hp1);

            Result := not RegUsedAfterInstruction(taicpu(p).oper[1]^.reg, hp1, TmpUsedRegs);
          end;

      begin
        Result := False;
        if not GetNextInstruction(p, hp1) or (hp1.typ <> ait_instruction) then
          Exit;

        if (taicpu(p).opsize in [S_L{$ifdef x86_64}, S_Q{$endif}]) then
          begin
            { Change:
                add     %reg2,%reg1
                mov/s/z #(%reg1),%reg1  (%reg1 superregisters must be the same)

              To:
                mov/s/z #(%reg1,%reg2),%reg1
            }
            if MatchOpType(taicpu(p), top_reg, top_reg) and
              MatchInstruction(hp1, [A_MOV, A_MOVZX, A_MOVSX{$ifdef x86_64}, A_MOVSXD{$endif}], []) and
              MatchOpType(taicpu(hp1), top_ref, top_reg) and
              (taicpu(hp1).oper[0]^.ref^.scalefactor <= 1) and
              (
                (
                  (taicpu(hp1).oper[0]^.ref^.base = taicpu(p).oper[1]^.reg) and
                  (taicpu(hp1).oper[0]^.ref^.index = NR_NO)
                ) or (
                  (taicpu(hp1).oper[0]^.ref^.index = taicpu(p).oper[1]^.reg) and
                  (taicpu(hp1).oper[0]^.ref^.base = NR_NO)
                )
              ) and (
                Reg1WriteOverwritesReg2Entirely(taicpu(p).oper[1]^.reg, taicpu(hp1).oper[1]^.reg) or
                (
                  { If the super registers ARE equal, then this MOV/S/Z does a partial write }
                  not SuperRegistersEqual(taicpu(p).oper[1]^.reg, taicpu(hp1).oper[1]^.reg) and
                  MemRegisterNotUsedLater
                )
              ) then
              begin
                taicpu(hp1).oper[0]^.ref^.base := taicpu(p).oper[1]^.reg;
                taicpu(hp1).oper[0]^.ref^.index := taicpu(p).oper[0]^.reg;

                DebugMsg(SPeepholeOptimization + 'AddMov2Mov done', p);
                RemoveCurrentp(p, hp1);
                Result := True;
                Exit;
              end;

            { Change:
                addl/q $x,%reg1
                movl/q %reg1,%reg2
              To:
                leal/q $x(%reg1),%reg2
                addl/q $x,%reg1 (can be removed if %reg1 or the flags are not used afterwards)

              Breaks the dependency chain.
            }
            if MatchOpType(taicpu(p),top_const,top_reg) and
              MatchInstruction(hp1, A_MOV, [taicpu(p).opsize]) and
              (taicpu(hp1).oper[1]^.typ = top_reg) and
              MatchOperand(taicpu(hp1).oper[0]^, taicpu(p).oper[1]^.reg) and
              (
                { Don't do AddMov2LeaAdd under -Os, but do allow AddMov2Lea }
                not (cs_opt_size in current_settings.optimizerswitches) or
                (
                  not RegUsedAfterInstruction(taicpu(p).oper[1]^.reg, hp1, TmpUsedRegs) and
                  RegUsedAfterInstruction(NR_DEFAULTFLAGS, hp1, TmpUsedRegs)
                )
              ) then
              begin
                { Change the MOV instruction to a LEA instruction, and update the
                  first operand }

                reference_reset(NewRef, 1, []);
                NewRef.base := taicpu(p).oper[1]^.reg;
                NewRef.scalefactor := 1;
                NewRef.offset := taicpu(p).oper[0]^.val;

                taicpu(hp1).opcode := A_LEA;
                taicpu(hp1).loadref(0, NewRef);

                TransferUsedRegs(TmpUsedRegs);
                UpdateUsedRegs(TmpUsedRegs, tai(p.Next));
                if RegUsedAfterInstruction(NewRef.base, hp1, TmpUsedRegs) or
                  RegUsedAfterInstruction(NR_DEFAULTFLAGS, hp1, TmpUsedRegs) then
                  begin
                    { Move what is now the LEA instruction to before the SUB instruction }
                    Asml.Remove(hp1);
                    Asml.InsertBefore(hp1, p);
                    AllocRegBetween(taicpu(hp1).oper[1]^.reg, hp1, p, UsedRegs);

                    DebugMsg(SPeepholeOptimization + 'AddMov2LeaAdd', p);
                    p := hp1;
                  end
                else
                  begin
                    { Since %reg1 or the flags aren't used afterwards, we can delete p completely }
                    RemoveCurrentP(p, hp1);
                    DebugMsg(SPeepholeOptimization + 'AddMov2Lea', p);
                  end;

                Result := True;
              end;
          end;
      end;


    function TX86AsmOptimizer.OptPass2Lea(var p : tai) : Boolean;
      begin
        Result:=false;
        if not (RegInUsedRegs(NR_DEFAULTFLAGS,UsedRegs)) then
          begin
            if MatchReference(taicpu(p).oper[0]^.ref^,taicpu(p).oper[1]^.reg,NR_INVALID) and
              (taicpu(p).oper[0]^.ref^.index<>NR_NO) then
              begin
                taicpu(p).loadreg(1,taicpu(p).oper[0]^.ref^.base);
                taicpu(p).loadreg(0,taicpu(p).oper[0]^.ref^.index);
                taicpu(p).opcode:=A_ADD;
                DebugMsg(SPeepholeOptimization + 'Lea2AddBase done',p);
                result:=true;
              end

            else if MatchReference(taicpu(p).oper[0]^.ref^,NR_INVALID,taicpu(p).oper[1]^.reg) and
              (taicpu(p).oper[0]^.ref^.base<>NR_NO) then
              begin
                taicpu(p).loadreg(1,taicpu(p).oper[0]^.ref^.index);
                taicpu(p).loadreg(0,taicpu(p).oper[0]^.ref^.base);
                taicpu(p).opcode:=A_ADD;
                DebugMsg(SPeepholeOptimization + 'Lea2AddIndex done',p);
                result:=true;
              end;
          end;
      end;


    function TX86AsmOptimizer.OptPass2SUB(var p: tai): Boolean;
      var
        hp1: tai; NewRef: TReference;
      begin
        { Change:
            subl/q $x,%reg1
            movl/q %reg1,%reg2
          To:
            leal/q $-x(%reg1),%reg2
            subl/q $x,%reg1 (can be removed if %reg1 or the flags are not used afterwards)

          Breaks the dependency chain and potentially permits the removal of
          a CMP instruction if one follows.
        }
        Result := False;
        if (taicpu(p).opsize in [S_L{$ifdef x86_64}, S_Q{$endif x86_64}]) and
          MatchOpType(taicpu(p),top_const,top_reg) and
          GetNextInstruction(p, hp1) and
          MatchInstruction(hp1, A_MOV, [taicpu(p).opsize]) and
          (taicpu(hp1).oper[1]^.typ = top_reg) and
          MatchOperand(taicpu(hp1).oper[0]^, taicpu(p).oper[1]^.reg) and
          (
            { Don't do SubMov2LeaSub under -Os, but do allow SubMov2Lea }
            not (cs_opt_size in current_settings.optimizerswitches) or
            (
              not RegUsedAfterInstruction(taicpu(p).oper[1]^.reg, hp1, TmpUsedRegs) and
              RegUsedAfterInstruction(NR_DEFAULTFLAGS, hp1, TmpUsedRegs)
            )
          ) then
          begin
            { Change the MOV instruction to a LEA instruction, and update the
              first operand }
            reference_reset(NewRef, 1, []);
            NewRef.base := taicpu(p).oper[1]^.reg;
            NewRef.scalefactor := 1;
            NewRef.offset := -taicpu(p).oper[0]^.val;

            taicpu(hp1).opcode := A_LEA;
            taicpu(hp1).loadref(0, NewRef);

            TransferUsedRegs(TmpUsedRegs);
            UpdateUsedRegs(TmpUsedRegs, tai(p.Next));
            if RegUsedAfterInstruction(NewRef.base, hp1, TmpUsedRegs) or
              RegUsedAfterInstruction(NR_DEFAULTFLAGS, hp1, TmpUsedRegs) then
              begin
                { Move what is now the LEA instruction to before the SUB instruction }
                Asml.Remove(hp1);
                Asml.InsertBefore(hp1, p);
                AllocRegBetween(taicpu(hp1).oper[1]^.reg, hp1, p, UsedRegs);

                DebugMsg(SPeepholeOptimization + 'SubMov2LeaSub', p);
                p := hp1;
              end
            else
              begin
                { Since %reg1 or the flags aren't used afterwards, we can delete p completely }
                RemoveCurrentP(p, hp1);
                DebugMsg(SPeepholeOptimization + 'SubMov2Lea', p);
              end;

            Result := True;
          end;
      end;


    function TX86AsmOptimizer.SkipSimpleInstructions(var hp1 : tai) : Boolean;
      begin
        { we can skip all instructions not messing with the stack pointer }
        while assigned(hp1) and {MatchInstruction(hp1,[A_LEA,A_MOV,A_MOVQ,A_MOVSQ,A_MOVSX,A_MOVSXD,A_MOVZX,
          A_AND,A_OR,A_XOR,A_ADD,A_SHR,A_SHL,A_IMUL,A_SETcc,A_SAR,A_SUB,A_TEST,A_CMOVcc,
          A_MOVSS,A_MOVSD,A_MOVAPS,A_MOVUPD,A_MOVAPD,A_MOVUPS,
          A_VMOVSS,A_VMOVSD,A_VMOVAPS,A_VMOVUPD,A_VMOVAPD,A_VMOVUPS],[]) and}
          ({(taicpu(hp1).ops=0) or }
           ({(MatchOpType(taicpu(hp1),top_reg,top_reg) or MatchOpType(taicpu(hp1),top_const,top_reg) or
             (MatchOpType(taicpu(hp1),top_ref,top_reg))
            ) and }
            not(RegInInstruction(NR_STACK_POINTER_REG,hp1)) { and not(RegInInstruction(NR_FRAME_POINTER_REG,hp1))}
           )
          ) do
          GetNextInstruction(hp1,hp1);
        Result:=assigned(hp1);
      end;


    function TX86AsmOptimizer.PostPeepholeOptLea(var p : tai) : Boolean;
      var
        hp1, hp2, hp3, hp4, hp5: tai;
      begin
        Result:=false;
        hp5:=nil;
        { replace
            leal(q) x(<stackpointer>),<stackpointer>
            call   procname
            leal(q) -x(<stackpointer>),<stackpointer>
            ret
          by
            jmp    procname

          but do it only on level 4 because it destroys stack back traces
        }
        if (cs_opt_level4 in current_settings.optimizerswitches) and
          MatchOpType(taicpu(p),top_ref,top_reg) and
          (taicpu(p).oper[0]^.ref^.base=NR_STACK_POINTER_REG) and
          (taicpu(p).oper[0]^.ref^.index=NR_NO) and
          { the -8 or -24 are not required, but bail out early if possible,
            higher values are unlikely }
          ((taicpu(p).oper[0]^.ref^.offset=-8) or
           (taicpu(p).oper[0]^.ref^.offset=-24))  and
          (taicpu(p).oper[0]^.ref^.symbol=nil) and
          (taicpu(p).oper[0]^.ref^.relsymbol=nil) and
          (taicpu(p).oper[0]^.ref^.segment=NR_NO) and
          (taicpu(p).oper[1]^.reg=NR_STACK_POINTER_REG) and
          GetNextInstruction(p, hp1) and
          { Take a copy of hp1 }
          SetAndTest(hp1, hp4) and
          { trick to skip label }
          ((hp1.typ=ait_instruction) or GetNextInstruction(hp1, hp1)) and
          SkipSimpleInstructions(hp1) and
          MatchInstruction(hp1,A_CALL,[S_NO]) and
          GetNextInstruction(hp1, hp2) and
          MatchInstruction(hp2,A_LEA,[taicpu(p).opsize]) and
          MatchOpType(taicpu(hp2),top_ref,top_reg) and
          (taicpu(hp2).oper[0]^.ref^.offset=-taicpu(p).oper[0]^.ref^.offset) and
          (taicpu(hp2).oper[0]^.ref^.base=NR_STACK_POINTER_REG) and
          (taicpu(hp2).oper[0]^.ref^.index=NR_NO) and
          (taicpu(hp2).oper[0]^.ref^.symbol=nil) and
          (taicpu(hp2).oper[0]^.ref^.relsymbol=nil) and
          (taicpu(hp2).oper[0]^.ref^.segment=NR_NO) and
          (taicpu(hp2).oper[1]^.reg=NR_STACK_POINTER_REG) and
          GetNextInstruction(hp2, hp3) and
          { trick to skip label }
          ((hp3.typ=ait_instruction) or GetNextInstruction(hp3, hp3)) and
          (MatchInstruction(hp3,A_RET,[S_NO]) or
           (MatchInstruction(hp3,A_VZEROUPPER,[S_NO]) and
            SetAndTest(hp3,hp5) and
            GetNextInstruction(hp3,hp3) and
            MatchInstruction(hp3,A_RET,[S_NO])
           )
          ) and
          (taicpu(hp3).ops=0) then
          begin
            taicpu(hp1).opcode := A_JMP;
            taicpu(hp1).is_jmp := true;
            DebugMsg(SPeepholeOptimization + 'LeaCallLeaRet2Jmp done',p);
            RemoveCurrentP(p, hp4);
            RemoveInstruction(hp2);
            RemoveInstruction(hp3);
            if Assigned(hp5) then
              begin
                AsmL.Remove(hp5);
                ASmL.InsertBefore(hp5,hp1)
              end;
            Result:=true;
          end;
      end;


    function TX86AsmOptimizer.PostPeepholeOptPush(var p : tai) : Boolean;
{$ifdef x86_64}
      var
        hp1, hp2, hp3, hp4, hp5: tai;
{$endif x86_64}
      begin
        Result:=false;
{$ifdef x86_64}
        hp5:=nil;
        { replace
            push %rax
            call   procname
            pop %rcx
            ret
          by
            jmp    procname

          but do it only on level 4 because it destroys stack back traces

          It depends on the fact, that the sequence push rax/pop rcx is used for stack alignment as rcx is volatile
          for all supported calling conventions
        }
        if (cs_opt_level4 in current_settings.optimizerswitches) and
          MatchOpType(taicpu(p),top_reg) and
          (taicpu(p).oper[0]^.reg=NR_RAX) and
          GetNextInstruction(p, hp1) and
          { Take a copy of hp1 }
          SetAndTest(hp1, hp4) and
          { trick to skip label }
          ((hp1.typ=ait_instruction) or GetNextInstruction(hp1, hp1)) and
          SkipSimpleInstructions(hp1) and
          MatchInstruction(hp1,A_CALL,[S_NO]) and
          GetNextInstruction(hp1, hp2) and
          MatchInstruction(hp2,A_POP,[taicpu(p).opsize]) and
          MatchOpType(taicpu(hp2),top_reg) and
          (taicpu(hp2).oper[0]^.reg=NR_RCX) and
          GetNextInstruction(hp2, hp3) and
          { trick to skip label }
          ((hp3.typ=ait_instruction) or GetNextInstruction(hp3, hp3)) and
          (MatchInstruction(hp3,A_RET,[S_NO]) or
           (MatchInstruction(hp3,A_VZEROUPPER,[S_NO]) and
            SetAndTest(hp3,hp5) and
            GetNextInstruction(hp3,hp3) and
            MatchInstruction(hp3,A_RET,[S_NO])
           )
          ) and
          (taicpu(hp3).ops=0) then
          begin
            taicpu(hp1).opcode := A_JMP;
            taicpu(hp1).is_jmp := true;
            DebugMsg(SPeepholeOptimization + 'PushCallPushRet2Jmp done',p);
            RemoveCurrentP(p, hp4);
            RemoveInstruction(hp2);
            RemoveInstruction(hp3);
            if Assigned(hp5) then
              begin
                AsmL.Remove(hp5);
                ASmL.InsertBefore(hp5,hp1)
              end;
            Result:=true;
          end;
{$endif x86_64}
      end;


    function TX86AsmOptimizer.PostPeepholeOptMov(var p : tai) : Boolean;
      var
        Value, RegName: string;
      begin
        Result:=false;
        if (taicpu(p).oper[1]^.typ = top_reg) and (taicpu(p).oper[0]^.typ = top_const) then
          begin

            case taicpu(p).oper[0]^.val of
            0:
              { Don't make this optimisation if the CPU flags are required, since XOR scrambles them }
              if not (RegInUsedRegs(NR_DEFAULTFLAGS,UsedRegs)) then
                begin
                  { change "mov $0,%reg" into "xor %reg,%reg" }
                  taicpu(p).opcode := A_XOR;
                  taicpu(p).loadReg(0,taicpu(p).oper[1]^.reg);
                  Result := True;
                end;
            $1..$FFFFFFFF:
              begin
                { Code size reduction by J. Gareth "Kit" Moreton }
                { change 64-bit register to 32-bit register to reduce code size (upper 32 bits will be set to zero) }
                case taicpu(p).opsize of
                  S_Q:
                    begin
                      RegName := debug_regname(taicpu(p).oper[1]^.reg); { 64-bit register name }
                      Value := debug_tostr(taicpu(p).oper[0]^.val);

                      { The actual optimization }
                      setsubreg(taicpu(p).oper[1]^.reg, R_SUBD);
                      taicpu(p).changeopsize(S_L);

                      DebugMsg(SPeepholeOptimization + 'movq $' + Value + ',' + RegName + ' -> movl $' + Value + ',' + debug_regname(taicpu(p).oper[1]^.reg) + ' (immediate can be represented with just 32 bits)', p);
                      Result := True;
                    end;
                  else
                    { Do nothing };
                end;
              end;
            -1:
              { Don't make this optimisation if the CPU flags are required, since OR scrambles them }
              if (cs_opt_size in current_settings.optimizerswitches) and
                (taicpu(p).opsize <> S_B) and
                not (RegInUsedRegs(NR_DEFAULTFLAGS,UsedRegs)) then
                begin
                  { change "mov $-1,%reg" into "or $-1,%reg" }
                  { NOTES:
                    - No size saving is made when changing a Word-sized assignment unless the register is AX (smaller encoding)
                    - This operation creates a false dependency on the register, so only do it when optimising for size
                    - It is possible to set memory operands using this method, but this creates an even greater false dependency, so don't do this at all
                  }
                  taicpu(p).opcode := A_OR;
                  Result := True;
                end;
            end;
          end;
      end;


    function TX86AsmOptimizer.PostPeepholeOptAnd(var p : tai) : boolean;
      var
        hp1: tai;
      begin
        { Detect:
            andw   x,  %ax (0 <= x < $8000)
            ...
            movzwl %ax,%eax

          Change movzwl %ax,%eax to cwtl (shorter encoding for movswl %ax,%eax)
        }

        Result := False;        if MatchOpType(taicpu(p), top_const, top_reg) and
          (taicpu(p).oper[1]^.reg = NR_AX) and { This is also enough to determine that opsize = S_W }
          ((taicpu(p).oper[0]^.val and $7FFF) = taicpu(p).oper[0]^.val) and
          GetNextInstructionUsingReg(p, hp1, NR_EAX) and
          MatchInstruction(hp1, A_MOVZX, [S_WL]) and
          MatchOperand(taicpu(hp1).oper[0]^, NR_AX) and
          MatchOperand(taicpu(hp1).oper[1]^, NR_EAX) then
          begin
            DebugMsg(SPeepholeOptimization + 'Converted movzwl %ax,%eax to cwtl (via AndMovz2AndCwtl)', hp1);
            taicpu(hp1).opcode := A_CWDE;
            taicpu(hp1).clearop(0);
            taicpu(hp1).clearop(1);
            taicpu(hp1).ops := 0;

            { A change was made, but not with p, so move forward 1 }
            p := tai(p.Next);
            Result := True;
          end;

      end;


    function TX86AsmOptimizer.PostPeepholeOptMOVSX(var p : tai) : boolean;
      begin
        Result := False;
        if not MatchOpType(taicpu(p), top_reg, top_reg) then
          Exit;

        { Convert:
            movswl %ax,%eax  -> cwtl
            movslq %eax,%rax -> cdqe

            NOTE: Don't convert movswl %al,%ax to cbw, because cbw and cwde
              refer to the same opcode and depends only on the assembler's
              current operand-size attribute. [Kit]
        }
        with taicpu(p) do
          case opsize of
            S_WL:
              if (oper[0]^.reg = NR_AX) and (oper[1]^.reg = NR_EAX) then
                begin
                  DebugMsg(SPeepholeOptimization + 'Converted movswl %ax,%eax to cwtl', p);
                  opcode := A_CWDE;
                  clearop(0);
                  clearop(1);
                  ops := 0;
                  Result := True;
                end;
{$ifdef x86_64}
            S_LQ:
              if (oper[0]^.reg = NR_EAX) and (oper[1]^.reg = NR_RAX) then
                begin
                  DebugMsg(SPeepholeOptimization + 'Converted movslq %eax,%rax to cltq', p);
                  opcode := A_CDQE;
                  clearop(0);
                  clearop(1);
                  ops := 0;
                  Result := True;
                end;
{$endif x86_64}
            else
              ;
          end;
      end;


    function TX86AsmOptimizer.PostPeepholeOptShr(var p : tai) : boolean;
      var
        hp1: tai;
      begin
        { Detect:
            shr    x,  %ax (x > 0)
            ...
            movzwl %ax,%eax

          Change movzwl %ax,%eax to cwtl (shorter encoding for movswl %ax,%eax)
        }

        Result := False;
        if MatchOpType(taicpu(p), top_const, top_reg) and
          (taicpu(p).oper[1]^.reg = NR_AX) and { This is also enough to determine that opsize = S_W }
          (taicpu(p).oper[0]^.val > 0) and
          GetNextInstructionUsingReg(p, hp1, NR_EAX) and
          MatchInstruction(hp1, A_MOVZX, [S_WL]) and
          MatchOperand(taicpu(hp1).oper[0]^, NR_AX) and
          MatchOperand(taicpu(hp1).oper[1]^, NR_EAX) then
          begin
            DebugMsg(SPeepholeOptimization + 'Converted movzwl %ax,%eax to cwtl (via ShrMovz2ShrCwtl)', hp1);
            taicpu(hp1).opcode := A_CWDE;
            taicpu(hp1).clearop(0);
            taicpu(hp1).clearop(1);
            taicpu(hp1).ops := 0;

            { A change was made, but not with p, so move forward 1 }
            p := tai(p.Next);
            Result := True;
          end;

      end;


    function TX86AsmOptimizer.PostPeepholeOptCmp(var p : tai) : Boolean;
      begin
        Result:=false;
        { change "cmp $0, %reg" to "test %reg, %reg" }
        if MatchOpType(taicpu(p),top_const,top_reg) and
           (taicpu(p).oper[0]^.val = 0) then
          begin
            taicpu(p).opcode := A_TEST;
            taicpu(p).loadreg(0,taicpu(p).oper[1]^.reg);
            Result:=true;
          end;
      end;


    function TX86AsmOptimizer.PostPeepholeOptTestOr(var p : tai) : Boolean;
      var
        IsTestConstX : Boolean;
        hp1,hp2 : tai;
      begin
        Result:=false;
        { removes the line marked with (x) from the sequence
          and/or/xor/add/sub/... $x, %y
          test/or %y, %y  | test $-1, %y    (x)
          j(n)z _Label
             as the first instruction already adjusts the ZF
             %y operand may also be a reference }
        IsTestConstX:=(taicpu(p).opcode=A_TEST) and
          MatchOperand(taicpu(p).oper[0]^,-1);
        if (OpsEqual(taicpu(p).oper[0]^,taicpu(p).oper[1]^) or IsTestConstX) and
           GetLastInstruction(p, hp1) and
           (tai(hp1).typ = ait_instruction) and
           GetNextInstruction(p,hp2) and
           MatchInstruction(hp2,A_SETcc,A_Jcc,A_CMOVcc,[]) then
          case taicpu(hp1).opcode Of
            A_ADD, A_SUB, A_OR, A_XOR, A_AND:
              begin
                if OpsEqual(taicpu(hp1).oper[1]^,taicpu(p).oper[1]^) and
                  { does not work in case of overflow for G(E)/L(E)/C_O/C_NO }
                  { and in case of carry for A(E)/B(E)/C/NC                  }
                   ((taicpu(hp2).condition in [C_Z,C_NZ,C_E,C_NE]) or
                    ((taicpu(hp1).opcode <> A_ADD) and
                     (taicpu(hp1).opcode <> A_SUB))) then
                  begin
                    RemoveCurrentP(p, hp2);
                    Result:=true;
                    Exit;
                  end;
              end;
            A_SHL, A_SAL, A_SHR, A_SAR:
              begin
                if OpsEqual(taicpu(hp1).oper[1]^,taicpu(p).oper[1]^) and
                  { SHL/SAL/SHR/SAR with a value of 0 do not change the flags }
                  { therefore, it's only safe to do this optimization for     }
                  { shifts by a (nonzero) constant                            }
                   (taicpu(hp1).oper[0]^.typ = top_const) and
                   (taicpu(hp1).oper[0]^.val <> 0) and
                  { does not work in case of overflow for G(E)/L(E)/C_O/C_NO }
                  { and in case of carry for A(E)/B(E)/C/NC                  }
                   (taicpu(hp2).condition in [C_Z,C_NZ,C_E,C_NE]) then
                  begin
                    RemoveCurrentP(p, hp2);
                    Result:=true;
                    Exit;
                  end;
              end;
            A_DEC, A_INC, A_NEG:
              begin
                if OpsEqual(taicpu(hp1).oper[0]^,taicpu(p).oper[1]^) and
                  { does not work in case of overflow for G(E)/L(E)/C_O/C_NO }
                  { and in case of carry for A(E)/B(E)/C/NC                  }
                  (taicpu(hp2).condition in [C_Z,C_NZ,C_E,C_NE]) then
                  begin
                    case taicpu(hp1).opcode of
                      A_DEC, A_INC:
                        { replace inc/dec with add/sub 1, because inc/dec doesn't set the carry flag }
                        begin
                          case taicpu(hp1).opcode Of
                            A_DEC: taicpu(hp1).opcode := A_SUB;
                            A_INC: taicpu(hp1).opcode := A_ADD;
                            else
                              ;
                          end;
                          taicpu(hp1).loadoper(1,taicpu(hp1).oper[0]^);
                          taicpu(hp1).loadConst(0,1);
                          taicpu(hp1).ops:=2;
                        end;
                      else
                        ;
                    end;
                    RemoveCurrentP(p, hp2);
                    Result:=true;
                    Exit;
                  end;
              end
          else
            ;
          end; { case }

        { change "test  $-1,%reg" into "test %reg,%reg" }
        if IsTestConstX and (taicpu(p).oper[1]^.typ=top_reg) then
          taicpu(p).loadoper(0,taicpu(p).oper[1]^);

        { Change "or %reg,%reg" to "test %reg,%reg" as OR generates a false dependency }
        if MatchInstruction(p, A_OR, []) and
          { Can only match if they're both registers }
          MatchOperand(taicpu(p).oper[0]^, taicpu(p).oper[1]^) then
          begin
            DebugMsg(SPeepholeOptimization + 'or %reg,%reg -> test %reg,%reg to remove false dependency (Or2Test)', p);
            taicpu(p).opcode := A_TEST;
            { No need to set Result to True, as we've done all the optimisations we can }
          end;
      end;


    function TX86AsmOptimizer.PostPeepholeOptCall(var p : tai) : Boolean;
      var
        hp1,hp3 : tai;
{$ifndef x86_64}
        hp2 : taicpu;
{$endif x86_64}
      begin
        Result:=false;
        hp3:=nil;
{$ifndef x86_64}
        { don't do this on modern CPUs, this really hurts them due to
          broken call/ret pairing }
        if (current_settings.optimizecputype < cpu_Pentium2) and
           not(cs_create_pic in current_settings.moduleswitches) and
           GetNextInstruction(p, hp1) and
           MatchInstruction(hp1,A_JMP,[S_NO]) and
           MatchOpType(taicpu(hp1),top_ref) and
           (taicpu(hp1).oper[0]^.ref^.refaddr=addr_full) then
          begin
            hp2 := taicpu.Op_sym(A_PUSH,S_L,taicpu(hp1).oper[0]^.ref^.symbol);
            InsertLLItem(p.previous, p, hp2);
            taicpu(p).opcode := A_JMP;
            taicpu(p).is_jmp := true;
            RemoveInstruction(hp1);
            Result:=true;
          end
        else
{$endif x86_64}
        { replace
            call   procname
            ret
          by
            jmp    procname

          but do it only on level 4 because it destroys stack back traces

          else if the subroutine is marked as no return, remove the ret
        }
        if ((cs_opt_level4 in current_settings.optimizerswitches) or
          (po_noreturn in current_procinfo.procdef.procoptions)) and
          GetNextInstruction(p, hp1) and
          (MatchInstruction(hp1,A_RET,[S_NO]) or
           (MatchInstruction(hp1,A_VZEROUPPER,[S_NO]) and
            SetAndTest(hp1,hp3) and
            GetNextInstruction(hp1,hp1) and
            MatchInstruction(hp1,A_RET,[S_NO])
           )
          ) and
          (taicpu(hp1).ops=0) then
          begin
            if (cs_opt_level4 in current_settings.optimizerswitches) and
              { we might destroy stack alignment here if we do not do a call }
              (target_info.stackalign<=sizeof(SizeUInt)) then
              begin
                taicpu(p).opcode := A_JMP;
                taicpu(p).is_jmp := true;
                DebugMsg(SPeepholeOptimization + 'CallRet2Jmp done',p);
              end
            else
              DebugMsg(SPeepholeOptimization + 'CallRet2Call done',p);
            RemoveInstruction(hp1);
            if Assigned(hp3) then
              begin
                AsmL.Remove(hp3);
                AsmL.InsertBefore(hp3,p)
              end;
            Result:=true;
          end;
      end;


    function TX86AsmOptimizer.PostPeepholeOptMovzx(var p : tai) : Boolean;

      function ConstInRange(const Val: TCGInt; const OpSize: TOpSize): Boolean;
        begin
          case OpSize of
            S_B, S_BW, S_BL{$ifdef x86_64}, S_BQ{$endif x86_64}:
              Result := (Val <= $FF) and (Val >= -128);
            S_W, S_WL{$ifdef x86_64}, S_WQ{$endif x86_64}:
              Result := (Val <= $FFFF) and (Val >= -32768);
            S_L{$ifdef x86_64}, S_LQ{$endif x86_64}:
              Result := (Val <= $FFFFFFFF) and (Val >= -2147483648);
            else
              Result := True;
          end;
        end;

      var
        hp1, hp2 : tai;
        SizeChange: Boolean;
        PreMessage: string;
      begin
        Result := False;

        if (taicpu(p).oper[0]^.typ = top_reg) and
          SuperRegistersEqual(taicpu(p).oper[0]^.reg, taicpu(p).oper[1]^.reg) and
          GetNextInstruction(p, hp1) and (hp1.typ = ait_instruction) then
          begin
            { Change (using movzbl %al,%eax as an example):

                movzbl %al, %eax    movzbl %al, %eax
                cmpl   x,   %eax    testl  %eax,%eax

              To:
                cmpb   x,   %al     testb  %al, %al  (Move one back to avoid a false dependency)
                movzbl %al, %eax    movzbl %al, %eax

              Smaller instruction and minimises pipeline stall as the CPU
              doesn't have to wait for the register to get zero-extended. [Kit]

              Also allow if the smaller of the two registers is being checked,
              as this still removes the false dependency.
            }
            if
              (
                (
                  (taicpu(hp1).opcode = A_CMP) and MatchOpType(taicpu(hp1), top_const, top_reg) and
                  ConstInRange(taicpu(hp1).oper[0]^.val, taicpu(p).opsize)
                ) or (
                  { If MatchOperand returns True, they must both be registers }
                  (taicpu(hp1).opcode = A_TEST) and MatchOperand(taicpu(hp1).oper[0]^, taicpu(hp1).oper[1]^)
                )
              ) and
              (reg2opsize(taicpu(hp1).oper[1]^.reg) <= reg2opsize(taicpu(p).oper[1]^.reg)) and
              SuperRegistersEqual(taicpu(p).oper[1]^.reg, taicpu(hp1).oper[1]^.reg) then
              begin
                PreMessage := debug_op2str(taicpu(hp1).opcode) + debug_opsize2str(taicpu(hp1).opsize) + ' ' + debug_operstr(taicpu(hp1).oper[0]^) + ',' + debug_regname(taicpu(hp1).oper[1]^.reg) + ' -> ' + debug_op2str(taicpu(hp1).opcode);

                asml.Remove(hp1);
                asml.InsertBefore(hp1, p);

                { Swap instructions in the case of cmp 0,%reg or test %reg,%reg }
                if (taicpu(hp1).opcode = A_TEST) or (taicpu(hp1).oper[0]^.val = 0) then
                  begin
                    taicpu(hp1).opcode := A_TEST;
                    taicpu(hp1).loadreg(0, taicpu(p).oper[0]^.reg);
                  end;

                taicpu(hp1).oper[1]^.reg := taicpu(p).oper[0]^.reg;

                case taicpu(p).opsize of
                  S_BW, S_BL:
                    begin
                      SizeChange := taicpu(hp1).opsize <> S_B;
                      taicpu(hp1).changeopsize(S_B);
                    end;
                  S_WL:
                    begin
                      SizeChange := taicpu(hp1).opsize <> S_W;
                      taicpu(hp1).changeopsize(S_W);
                    end
                  else
                    InternalError(2020112701);
                end;

                UpdateUsedRegs(tai(p.Next));

                { Check if the register is used aferwards - if not, we can
                  remove the movzx instruction completely }
                if not RegUsedAfterInstruction(taicpu(hp1).oper[1]^.reg, p, UsedRegs) then
                  begin
                    { Hp1 is a better position than p for debugging purposes }
                    DebugMsg(SPeepholeOptimization + 'Movzx2Nop 4a', hp1);
                    RemoveCurrentp(p, hp1);
                    Result := True;
                  end;

                if SizeChange then
                  DebugMsg(SPeepholeOptimization + PreMessage +
                    debug_opsize2str(taicpu(hp1).opsize) + ' ' + debug_operstr(taicpu(hp1).oper[0]^) + ',' + debug_regname(taicpu(hp1).oper[1]^.reg) + ' (smaller and minimises pipeline stall - MovzxCmp2CmpMovzx)', hp1)
                else
                  DebugMsg(SPeepholeOptimization + 'MovzxCmp2CmpMovzx', hp1);

                Exit;
              end;

            { Change (using movzwl %ax,%eax as an example):

                movzwl %ax, %eax
                movb   %al, (dest)  (Register is smaller than read register in movz)

              To:
                movb   %al, (dest)  (Move one back to avoid a false dependency)
                movzwl %ax, %eax
            }
            if (taicpu(hp1).opcode = A_MOV) and
              (taicpu(hp1).oper[0]^.typ = top_reg) and
              not RegInOp(taicpu(hp1).oper[0]^.reg, taicpu(hp1).oper[1]^) and
              SuperRegistersEqual(taicpu(hp1).oper[0]^.reg, taicpu(p).oper[0]^.reg) and
              (reg2opsize(taicpu(hp1).oper[0]^.reg) <= reg2opsize(taicpu(p).oper[0]^.reg)) then
              begin
                DebugMsg(SPeepholeOptimization + 'MovzxMov2MovMovzx', hp1);

                hp2 := tai(hp1.Previous); { Effectively the old position of hp1 }
                asml.Remove(hp1);
                asml.InsertBefore(hp1, p);
                if taicpu(hp1).oper[1]^.typ = top_reg then
                  AllocRegBetween(taicpu(hp1).oper[1]^.reg, hp1, hp2, UsedRegs);

                { Check if the register is used aferwards - if not, we can
                  remove the movzx instruction completely }

                if not RegUsedAfterInstruction(taicpu(hp1).oper[0]^.reg, p, UsedRegs) then
                  begin
                    { Hp1 is a better position than p for debugging purposes }
                    DebugMsg(SPeepholeOptimization + 'Movzx2Nop 4b', hp1);
                    RemoveCurrentp(p, hp1);
                    Result := True;
                  end;

                Exit;
              end;

          end;

{$ifdef x86_64}
        { Code size reduction by J. Gareth "Kit" Moreton }
        { Convert MOVZBQ and MOVZWQ to MOVZBL and MOVZWL respectively if it removes the REX prefix }
        if (taicpu(p).opsize in [S_BQ, S_WQ]) and
          (getsupreg(taicpu(p).oper[1]^.reg) in [RS_RAX, RS_RCX, RS_RDX, RS_RBX, RS_RSI, RS_RDI, RS_RBP, RS_RSP])
        then
          begin
            { Has 64-bit register name and opcode suffix }
            PreMessage := 'movz' + debug_opsize2str(taicpu(p).opsize) + ' ' + debug_operstr(taicpu(p).oper[0]^) + ',' + debug_regname(taicpu(p).oper[1]^.reg) + ' -> movz';

            { The actual optimization }
            setsubreg(taicpu(p).oper[1]^.reg, R_SUBD);
            if taicpu(p).opsize = S_BQ then
              taicpu(p).changeopsize(S_BL)
            else
              taicpu(p).changeopsize(S_WL);

            DebugMsg(SPeepholeOptimization + PreMessage +
              debug_opsize2str(taicpu(p).opsize) + ' ' + debug_operstr(taicpu(p).oper[0]^) + ',' + debug_regname(taicpu(p).oper[1]^.reg) + ' (removes REX prefix)', p);
          end;
{$endif}
      end;


{$ifdef x86_64}
    function TX86AsmOptimizer.PostPeepholeOptXor(var p : tai) : Boolean;
      var
        PreMessage, RegName: string;
      begin
        { Code size reduction by J. Gareth "Kit" Moreton }
        { change "xorq %reg,%reg" to "xorl %reg,%reg" for %rax, %rcx, %rdx, %rbx, %rsi, %rdi, %rbp and %rsp,
          as this removes the REX prefix }

        Result := False;
        if not OpsEqual(taicpu(p).oper[0]^,taicpu(p).oper[1]^) then
          Exit;

        if taicpu(p).oper[0]^.typ <> top_reg then
          { Should be impossible if both operands were equal, since one of XOR's operands must be a register }
          InternalError(2018011500);

        case taicpu(p).opsize of
          S_Q:
            begin
              if (getsupreg(taicpu(p).oper[0]^.reg) in [RS_RAX, RS_RCX, RS_RDX, RS_RBX, RS_RSI, RS_RDI, RS_RBP, RS_RSP]) then
                begin
                  RegName := debug_regname(taicpu(p).oper[0]^.reg); { 64-bit register name }
                  PreMessage := 'xorq ' + RegName + ',' + RegName + ' -> xorl ';

                  { The actual optimization }
                  setsubreg(taicpu(p).oper[0]^.reg, R_SUBD);
                  setsubreg(taicpu(p).oper[1]^.reg, R_SUBD);
                  taicpu(p).changeopsize(S_L);

                  RegName := debug_regname(taicpu(p).oper[0]^.reg); { 32-bit register name }

                  DebugMsg(SPeepholeOptimization + PreMessage + RegName + ',' + RegName + ' (removes REX prefix)', p);
                end;
            end;
          else
            ;
        end;
      end;
{$endif}


    class procedure TX86AsmOptimizer.OptimizeRefs(var p: taicpu);
      var
        OperIdx: Integer;
      begin
        for OperIdx := 0 to p.ops - 1 do
          if p.oper[OperIdx]^.typ = top_ref then
            optimize_ref(p.oper[OperIdx]^.ref^, False);
      end;

end.

