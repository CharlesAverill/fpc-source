{
    $Id$
    Copyright (c) 1997-98 by Jonas Maebe

    This unit contains the common subexpression elimination procedure.

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
Unit CSOpt386;

Interface

Uses aasm;

{Procedure CSOpt386(First, Last: Pai);}
Procedure CSE(AsmL: PAasmOutput; First, Last: Pai);

Implementation

Uses
  CObjects, verbose, hcodegen, globals,cpubase,cpuasm,DAOpt386;

{
Function PaiInSequence(P: Pai; Const Seq: TContent): Boolean;
Var P1: Pai;
    Counter: Byte;
    TmpResult: Boolean;
Begin
  TmpResult := False;
  P1 := Seq.StartMod;
  Counter := 1;
  While Not(TmpResult) And
        (Counter <= Seq.NrOfMods) Do
    Begin
      If (P = P1) Then TmpResult := True;
      Inc(Counter);
      p1 := Pai(p1^.Next);
    End;
  PaiInSequence := TmpResult;
End;
}

Function CheckSequence(p: Pai; Reg: TRegister; Var Found: Longint; Var RegInfo: TRegInfo): Boolean;
{checks whether the current instruction sequence (starting with p) and the
 one between StartMod and EndMod of Reg are the same. If so, the number of
 instructions that match is stored in Found and true is returned, otherwise
 Found holds the number of instructions between StartMod and EndMod and false
 is returned}
Var hp2, hp3{, EndMod}: Pai;
    PrevNonRemovablePai: Pai;
    Cnt, OldNrOfMods: Longint;
    OrgRegInfo, HighRegInfo: TRegInfo;
    HighFound, OrgRegFound: Byte;
    RegCounter: TRegister;
    OrgRegResult: Boolean;
    TmpResult: Boolean;
    TmpState: Byte;
Begin {CheckSequence}
  Reg := Reg32(Reg);
  TmpResult := False;
  FillChar(OrgRegInfo, SizeOf(OrgRegInfo), 0);
  OrgRegFound := 0;
  HighFound := 0;
  OrgRegResult := False;
  RegCounter := R_EAX;
  GetLastInstruction(p, PrevNonRemovablePai);
  While (RegCounter <= R_EDI) And
        (PPaiProp(PrevNonRemovablePai^.OptInfo)^.Regs[RegCounter].Typ <> Con_Ref) Do
    Inc(RegCounter);
  While (RegCounter <= R_EDI) Do
    Begin
      FillChar(RegInfo, SizeOf(RegInfo), 0);
      RegInfo.NewRegsEncountered := [procinfo^.FramePointer, R_ESP];
      RegInfo.OldRegsEncountered := RegInfo.NewRegsEncountered;
      RegInfo.New2OldReg[procinfo^.FramePointer] := procinfo^.FramePointer;
      RegInfo.New2OldReg[R_ESP] := R_ESP;
      Found := 0;
      hp2 := PPaiProp(PrevNonRemovablePai^.OptInfo)^.Regs[RegCounter].StartMod;
      If (PrevNonRemovablePai <> PPaiProp(PrevNonRemovablePai^.OptInfo)^.Regs[RegCounter].StartMod)
        Then OldNrOfMods := PPaiProp(PrevNonRemovablePai^.OptInfo)^.Regs[RegCounter].NrOfMods
        Else OldNrOfMods := 1;
      hp3 := p;
      While (Found <> OldNrOfMods) And
                                  { old  new }
             InstructionsEquivalent(hp2, hp3, RegInfo) Do
        Begin
          GetNextInstruction(hp2, hp2);
          GetNextInstruction(hp3, hp3);
          Inc(Found)
        End;
      If (Found <> OldNrOfMods) Then
        Begin
          TmpResult := False;
          If (found > 0) then
{this is correct because we only need to turn off the CanBeRemoved flag
 when an instruction has already been processed by CheckSequence
 (otherwise CanBeRemoved can't be true and thus can't have to be turned off).
 If it has already been processed by CheckSequence and flagged to be
 removed, it means that it has been checked against a previous sequence
 and that it was equal (otherwise CheckSequence would have returned false
 and the instruction wouldn't have been removed). If this "If found > 0"
 check is left out, incorrect optimizations are performed.}
            Found := PPaiProp(Pai(p)^.OptInfo)^.Regs[Reg].NrOfMods
        End
      Else TmpResult := True;
      If TmpResult And
         (Found > HighFound)
        Then
          Begin
            HighFound := Found;
            HighRegInfo := RegInfo;
          End;
      If (RegCounter = Reg) Then
        Begin
          OrgRegFound := Found;
          OrgRegResult := TmpResult;
          OrgRegInfo := RegInfo
        End;
      Repeat
        Inc(RegCounter);
      Until (RegCounter > R_EDI) or
            ((PPaiProp(PrevNonRemovablePai^.OptInfo)^.Regs[RegCounter].Typ = Con_Ref) {And
             ((Regcounter = Reg) Or
              Not(PaiInSequence(p, PPaiProp(PrevNonRemovablePai^.OptInfo)^.Regs[RegCounter]))) }
            );
    End;
  If (HighFound > 0) And
     (Not(OrgRegResult) Or
      (HighFound > OrgRegFound))
    Then
      Begin
{$ifndef fpc}
        TmpResult := True;
{$else fpc}
        CheckSequence := True;
{$endif fpc}
        RegInfo := HighRegInfo;
        Found := HighFound
      End
    Else
      Begin
{$ifndef fpc}
        TmpResult := OrgRegResult;
{$else fpc}
        CheckSequence := OrgRegResult;
{$endif fpc}
        Found := OrgRegFound;
        RegInfo := OrgRegInfo;
      End;
{ sometimes, registers in RegsLoadedForRef (which normally aren't/shouldn't }
{ be used anymore after the sequence, are still used nevertheless (when     }
{ range checking is on for instance, because this is not "normal" generated }
{ code, but more or less manually inserted)                                 }
{$ifndef fpc}
  If TmpResult Then
{$else fpc}
  If CheckSequence And (Found > 0) Then
{$endif fpc}
    For RegCounter := R_EAX to R_EDI Do
      If (RegCounter in RegInfo.RegsLoadedForRef) And
         (RegInfo.New2OldReg[RegCounter] <> RegCounter) Then
        Begin
          OldNrOfMods := PPaiProp(PrevNonRemovablePai^.OptInfo)^.
            Regs[RegInfo.New2OldReg[RegCounter]].NrOfMods;
          hp2 := p;
          For Cnt := 1 to Pred(OldNrOfMods) Do
            GetNextInstruction(hp2, hp2);
{ hp2 now containts the last instruction of the sequence }
{ get the writestate at this point of the register in TmpState }
          TmpState := PPaiProp(hp2^.OptInfo)^.Regs[RegCounter].WState;
{ hp3 := first instruction after the sequence }
          GetNextInstruction(hp2, hp2);
{ now, even though reg is in RegsLoadedForRef, sometimes it's still used  }
{ afterwards. It is not if either it is not in usedregs anymore after the }
{ sequence, or if it is loaded with a new value right after the sequence  }
          If (TmpState = PPaiProp(hp2^.OptInfo)^.Regs[RegCounter].WState) And
             (RegCounter in PPaiProp(hp2^.OptInfo)^.UsedRegs) Then
{ it is still used, so remove it from RegsLoadedForRef }
            Begin
{$ifdef regrefdebug}
              hp3 := new(pai_asm_comment,init(strpnew(att_reg2str[regcounter]+
                         ' removed from regsloadedforref')));
              hp3^.fileinfo := hp2^.fileinfo;
              hp3^.next := hp2^.next;
              hp3^.previous := hp2;
              hp2^.next := hp3;
              If assigned(hp3^.next) then
                Pai(hp3^.next)^.previous := hp3;
{$endif regrefdebug}
              Exclude(RegInfo.RegsLoadedForRef,RegCounter);
            End;
        End;
{$ifndef fpc}
  CheckSequence := TmpResult;
{$endif fpc}
End; {CheckSequence}

Procedure AllocRegBetween(AsmL: PAasmOutput; Reg: TRegister; p1, p2: Pai);
{ allocates register Reg between (and including) instructions p1 and p2 }
{ the type of p1 and p2 must not be in SkipInstr                        }
var hp: pai;
Begin
  If not(assigned(p1)) Then
    { this happens with registers which are loaded implicitely, outside the }
    { current block (e.g. esi with self)                                    }
    exit;
  Repeat
    If Assigned(p1^.OptInfo) Then
      Include(PPaiProp(p1^.OptInfo)^.UsedRegs,Reg);
    p1 := Pai(p1^.next);
    Repeat
      While (p1^.typ in (SkipInstr-[ait_regalloc])) Do
        p1 := Pai(p1^.next);
{ remove all allocation/deallocation info about the register in between }
      If (p1^.typ = ait_regalloc) Then
        If (PaiRegAlloc(p1)^.Reg = Reg) Then
          Begin
            hp := Pai(p1^.Next);
            AsmL^.Remove(p1);
            Dispose(p1, Done);
            p1 := hp;
          End
        Else p1 := Pai(p1^.next);
    Until Not(p1^.typ in SkipInstr);
  Until p1 = p2;
End;

{$ifdef alignreg}
Procedure SetAlignReg(p: Pai);
Const alignSearch = 12;
var regsUsable: TRegSet;
    prevInstrCount, nextInstrCount: Longint;
    prevState, nextWState,nextRState: Array[R_EAX..R_EDI] of byte;
    regCounter, lastRemoved: TRegister;
    prev, next: Pai;
{$ifdef alignregdebug}
    temp: Pai;
{$endif alignregdebug}
begin
  regsUsable := [R_EAX,R_ECX,R_EDX,R_EBX,{R_ESP,R_EBP,}R_ESI,R_EDI];
  for regCounter := R_EAX to R_EDI do
    begin
      prevState[regCounter] := PPaiProp(p^.optInfo)^.Regs[regCounter].wState;
      nextWState[regCounter] := PPaiProp(p^.optInfo)^.Regs[regCounter].wState;
      nextRState[regCounter] := PPaiProp(p^.optInfo)^.Regs[regCounter].rState;
    end;
  getLastInstruction(p,prev);
  getNextInstruction(p,next);
  lastRemoved := pai_align(p)^.reg;
  nextInstrCount := 0;
  prevInstrCount := 0;
  while ((assigned(prev) and
          assigned(prev^.optInfo) and
          (prevInstrCount < alignSearch)) or
         (assigned(next) and
          assigned(next^.optInfo) and
          (nextInstrCount < alignSearch))) And
        (regsUsable <> []) do
    begin
{$ifdef alignregdebug}
      if assigned(prev) then
        begin
          temp := new(pai_asm_comment,init(strpnew('got here')));
          temp^.next := prev^.next;
          temp^.previous := prev;
          prev^.next := temp;
          if assigned(temp^.next) then
            temp^.next^.previous := temp;
        end;
{$endif alignregdebug}
      if assigned(prev) and assigned(prev^.optinfo) and
         (prevInstrCount < alignSearch) then
        begin
          if (prev^.typ = ait_instruction) And
             (insProp[PaiCpu(prev)^.opcode].ch[1] <> Ch_ALL) and
             (PaiCpu(prev)^.opcode <> A_JMP) then
            begin
              inc(prevInstrCount);
              for regCounter := R_EAX to R_EDI do
                begin
                  if (regCounter in regsUsable) And
                     (PPaiProp(prev^.optInfo)^.Regs[regCounter].wState <>
                       prevState[regCounter]) then
                    begin
                      lastRemoved := regCounter;
                      exclude(regsUsable,regCounter);
{$ifdef alignregdebug}
                      temp := new(pai_asm_comment,init(strpnew(
                                att_reg2str[regCounter]+' removed')));
                      temp^.next := prev^.next;
                      temp^.previous := prev;
                      prev^.next := temp;
                      if assigned(temp^.next) then
                        temp^.next^.previous := temp;
                      if regsUsable = [] then
                        begin
                          temp := new(pai_asm_comment,init(strpnew(
                                    'regsUsable empty here')));
                          temp^.next := prev^.next;
                          temp^.previous := prev;
                          prev^.next := temp;
                          if assigned(temp^.next) then
                            temp^.next^.previous := temp;
                        end;
{$endif alignregdebug}
                    end;
                  prevState[regCounter] :=
                    PPaiProp(prev^.optInfo)^.Regs[regCounter].wState;
                end;
              getLastInstruction(prev,prev);
            end
          else
            If GetLastInstruction(prev,prev) and
               assigned(prev^.optinfo) then
              for regCounter := R_EAX to R_EDI do
                prevState[regCounter] :=
                  PPaiProp(prev^.optInfo)^.Regs[regCounter].wState
        end;
      if assigned(next) and assigned(next^.optInfo) and
         (nextInstrCount < alignSearch) then
        begin
          if (next^.typ = ait_instruction) and
             (insProp[PaiCpu(next)^.opcode].ch[1] <> Ch_ALL) and
             (PaiCpu(next)^.opcode <> A_JMP) then
            begin
              inc(nextInstrCount);
              for regCounter := R_EAX to R_EDI do
                begin
                  if (regCounter in regsUsable) And
                     ((PPaiProp(next^.optInfo)^.Regs[regCounter].wState <>
                       nextWState[regCounter]) or
                      (PPaiProp(next^.optInfo)^.Regs[regCounter].rState <>
                       nextRState[regCounter])) Then
                    begin
                      lastRemoved := regCounter;
                      exclude(regsUsable,regCounter);
{$ifdef alignregdebug}
                      temp := new(pai_asm_comment,init(strpnew(
                                att_reg2str[regCounter]+' removed')));
                      temp^.next := next^.next;
                      temp^.previous := next;
                      next^.next := temp;
                      if assigned(temp^.next) then
                        temp^.next^.previous := temp;
                      if regsUsable = [] then
                        begin
                          temp := new(pai_asm_comment,init(strpnew(
                                    'regsUsable empty here')));
                          temp^.next := next^.next;
                          temp^.previous := next;
                          next^.next := temp;
                          if assigned(temp^.next) then
                            temp^.next^.previous := temp;
                        end;
{$endif alignregdebug}
                    end;
                  nextWState[regCounter] :=
                    PPaiProp(next^.optInfo)^.Regs[regCounter].wState;
                  nextRState[regCounter] :=
                    PPaiProp(next^.optInfo)^.Regs[regCounter].rState;
                end
            end
          else
            for regCounter := R_EAX to R_EDI do
              begin
                nextWState[regCounter] :=
                  PPaiProp(next^.optInfo)^.Regs[regCounter].wState;
                nextRState[regCounter] :=
                  PPaiProp(next^.optInfo)^.Regs[regCounter].rState;
              end;
          getNextInstruction(next,next);
        end;
    end;
  if regsUsable <> [] then
    for regCounter := R_EAX to R_EDI do
      if regCounter in regsUsable then
        begin
          lastRemoved := regCounter;
          break
        end;
{$ifdef alignregdebug}
  next := new(pai_asm_comment,init(strpnew(att_reg2str[lastRemoved]+
               ' chosen as alignment register')));
  next^.next := p^.next;
  next^.previous := p;
  p^.next := next;
  if assigned(next^.next) then
    next^.next^.previous := next;
{$endif alignregdebug}
  pai_align(p)^.reg := lastRemoved;
End;
{$endif alignreg}

{$ifdef replacereg}
function FindRegDealloc(reg: tregister; p: pai): boolean;
begin
  findregdealloc := false;
  while assigned(p^.previous) and
        ((Pai(p^.previous)^.typ in (skipinstr+[ait_align])) or
         ((Pai(p^.previous)^.typ = ait_label) and
          not(Pai_Label(p^.previous)^.l^.is_used))) do
    begin
      p := pai(p^.previous);
      if (p^.typ = ait_regalloc) and
         (pairegalloc(p)^.reg = reg) then
        begin
          findregdealloc := not(pairegalloc(p)^.allocation);
          break;
        end;
    end
end;

function regLoadedWithNewValue(reg: tregister; hp: pai): boolean;
var p: paicpu;
begin
  p := paicpu(hp);
  regLoadedWithNewValue :=
    assigned(hp) and
    ((hp^.typ = ait_instruction) and
     (((p^.opcode = A_MOV) or
       (p^.opcode = A_MOVZX) or
       (p^.opcode = A_MOVSX) or
       (p^.opcode = A_LEA)) and
      (p^.oper[1].typ = top_reg) and
      (p^.oper[1].reg = reg) {and
      (not(p^.oper[0].typ = top_ref) or
       not RegInRef(p^.oper[1].reg,p^.oper[0].ref^))}) or
     ((p^.opcode = A_POP) and
      (p^.oper[0].reg = reg))) {or
    findRegDealloc(reg,hp)};
end;

Procedure RestoreRegContentsTo(reg: TRegister; const c: TContent; p: pai);
var hp: pai;
    tmpState: byte;
begin
  tmpState := PPaiProp(p^.optInfo)^.Regs[reg].wState;
  PPaiProp(p^.optInfo)^.Regs[reg] := c;
  while getNextInstruction(p,p) and
        (PPaiProp(p^.optInfo)^.Regs[reg].wState = tmpState) do
    PPaiProp(p^.optInfo)^.Regs[reg] := c;
{$ifdef replaceregdebug}
  if assigned(p) then
    begin
      hp := new(pai_asm_comment,init(strpnew(
        'restored '+att_reg2str[reg]+' till here...')));
      hp^.next := p;
      hp^.previous := p^.previous;
      p^.previous := hp;
      if assigned(hp^.previous) then
        hp^.previous^.next := hp;
    end;
{$endif replaceregdebug}
end;

Procedure ClearRegContentsFrom(reg: TRegister; p: pai);
var hp: pai;
    tmpState: byte;
begin
  tmpState := PPaiProp(p^.optInfo)^.Regs[reg].wState;
  PPaiProp(p^.optInfo)^.Regs[reg].typ := con_unknown;
  while getNextInstruction(p,p) and
        (PPaiProp(p^.optInfo)^.Regs[reg].wState = tmpState) do
    PPaiProp(p^.optInfo)^.Regs[reg].typ := con_unknown;
{$ifdef replaceregdebug}
  if assigned(p) then
    begin
      hp := new(pai_asm_comment,init(strpnew(
        'cleared '+att_reg2str[reg]+' till here...')));
      hp^.next := p;
      hp^.previous := p^.previous;
      p^.previous := hp;
      if assigned(hp^.previous) then
        hp^.previous^.next := hp;
    end;
{$endif replaceregdebug}
end;

function NoHardCodedRegs(p: paicpu): boolean;
var chCount: byte;
begin
  NoHardCodedRegs := true;
  with InsProp[p^.opcode] do
    for chCount := 1 to MaxCh do
      if Ch[chCount] in ([Ch_REAX..Ch_MEDI]-[Ch_RESP,Ch_WESP,Ch_RWESP]) then
        begin
          NoHardCodedRegs := false;
          break
        end;
end;

Procedure ChangeReg(var Reg: TRegister; orgReg, newReg: TRegister);
begin
  if reg = newReg then
    reg := orgReg
  else if reg = regtoreg8(newReg) then
         reg := regtoreg8(orgReg)
  else if reg = regtoreg16(newReg) then
         reg := regtoreg16(orgReg);
end;

Procedure DoReplaceReg(orgReg,newReg: tregister; hp: paicpu);
var opCount: byte;
begin
  for opCount := 0 to 2 do
    with hp^.oper[opCount] Do
      case typ of
        top_reg: ChangeReg(reg,orgReg,newReg);
        top_ref:
          begin
            ChangeReg(ref^.base,orgReg,newReg);
            ChangeReg(ref^.index,orgReg,newReg);
          end;
      end;
end;

function RegSizesOK(oldReg,newReg: TRegister; p: paicpu): boolean;
{ oldreg and newreg must be 32bit components }
var opCount: byte;
begin
  RegSizesOK := true;
  if not(IsGP32reg(oldReg) and IsGP32Reg(newReg)) then
    begin
      for opCount := 0 to 2 do
        if (p^.oper[opCount].typ = top_reg) and
           (p^.oper[opCount].reg in [R_AL..R_DH]) then
          begin
            RegSizesOK := false;
            break
          end
    end;
end;

function RegReadByInstruction(reg: TRegister; hp: pai): boolean;
{ assumes p doesn't modify registers implicitely (like div) }
var p: paicpu;
    opCount: byte;
begin
  RegReadByInstruction := false;
  p := paicpu(hp);
  if hp^.typ <> ait_instruction then
    exit;
  for opCount := 0 to 2 do
    if (p^.oper[opCount].typ = top_ref) and
       RegInRef(reg,p^.oper[opCount].ref^) then
      begin
        RegReadByInstruction := true;
        exit
      end;
  for opCount := 1 to MaxCh do
    case InsProp[p^.opcode].Ch[opCount] of
      Ch_RWOp1,Ch_ROp1{$ifdef arithopt},Ch_MOp1{$endif}:
        if (p^.oper[0].typ = top_reg) and
           (p^.oper[0].reg = reg) then
          begin
            RegReadByInstruction := true;
            exit
          end;
      Ch_RWOp2,Ch_ROp2{$ifdef arithopt},Ch_MOp2{$endif}:
        if (p^.oper[1].typ = top_reg) and
           (p^.oper[1].reg = reg) then
          begin
            RegReadByInstruction := true;
            exit
          end;
      Ch_RWOp3,Ch_ROp3{$ifdef arithopt},Ch_MOp3{$endif}:
        if (p^.oper[2].typ = top_reg) and
           (p^.oper[2].reg = reg) then
          begin
            RegReadByInstruction := true;
            exit
          end;
    end;
end;

procedure DoReplaceReadReg(orgReg,newReg: tregister; p: paicpu);
var opCount: byte;
begin
  for opCount := 0 to 2 do
    if p^.oper[opCount].typ = top_ref then
      begin
        ChangeReg(p^.oper[opCount].ref^.base,orgReg,newReg);
        ChangeReg(p^.oper[opCount].ref^.index,orgReg,newReg);
      end;
  for opCount := 1 to MaxCh do
    case InsProp[p^.opcode].Ch[opCount] of
      Ch_RWOp1,Ch_ROp1{$ifdef arithopt},Ch_MOp1{$endif}:
        if p^.oper[0].typ = top_reg then
          ChangeReg(p^.oper[0].reg,orgReg,newReg);
      Ch_RWOp2,Ch_ROp2{$ifdef arithopt},Ch_MOp2{$endif}:
        if p^.oper[1].typ = top_reg then
          ChangeReg(p^.oper[1].reg,orgReg,newReg);
      Ch_RWOp3,Ch_ROp3{$ifdef arithopt},Ch_MOp3{$endif}:
        if p^.oper[2].typ = top_reg then
          ChangeReg(p^.oper[2].reg,orgReg,newReg);
    end;
end;

function ReplaceReg(orgReg, newReg: TRegister; p: pai;
           const c: TContent): Boolean;
{ Tries to replace orgreg with newreg in all instructions coming after p }
{ until orgreg gets loaded with a new value. Returns true if successful, }
{ false otherwise. If successful, the contents of newReg are set to c,   }
{ which should hold the contents of newReg before the current sequence   }
{ started                                                                }
var endP, hp: Pai;
    sequenceEnd, tmpResult, newRegModified, orgRegRead, orgRegModified: Boolean;
begin
  ReplaceReg := False;
  tmpResult := true;
  sequenceEnd := false;
  newRegModified := false;
  orgRegRead := false;
  endP := pai(p^.previous);
  while tmpResult and not sequenceEnd Do
    begin
      tmpResult :=
        getNextInstruction(endP,endP);
      If tmpResult then
        begin
          sequenceEnd :=
            RegLoadedWithNewValue(newReg,paicpu(endP)) or
{             FindRegDealloc(newReg,endP) or}
            (GetNextInstruction(endp,hp) and
             FindRegDealloc(newReg,hp));
          newRegModified :=
            newRegModified or
            (not(sequenceEnd) and
             RegModifiedByInstruction(newReg,endP));
          orgRegRead := newRegModified and RegReadByInstruction(orgReg,endP);
          sequenceEnd := SequenceEnd and not(newRegModified and orgRegRead);
          tmpResult :=
            not(newRegModified and orgRegRead) and
            (endP^.typ = ait_instruction) and
            not(paicpu(endP)^.is_jmp) and
            NoHardCodedRegs(paicpu(endP)) and
            RegSizesOk(orgReg,newReg,paicpu(endP)) and
            not RegModifiedByInstruction(orgReg,endP);
        end;
    end;
  if SequenceEnd then
    begin
{$ifdef replaceregdebug}
      hp := new(pai_asm_comment,init(strpnew(
        'replacing '+att_reg2str[newreg]+' with '+att_reg2str[orgreg]+
        ' from here...')));
      hp^.next := p;
      hp^.previous := p^.previous;
      p^.previous := hp;
      if assigned(hp^.previous) then
        hp^.previous^.next := hp;

      hp := new(pai_asm_comment,init(strpnew(
        'replaced '+att_reg2str[newreg]+' with '+att_reg2str[orgreg]+
        ' till here')));
      hp^.next := endp^.next;
      hp^.previous := endp;
      endp^.next := hp;
      if assigned(hp^.next) then
        hp^.next^.previous := hp;
{$endif replaceregdebug}
      ReplaceReg := true;
      hp := p;
      while hp <> endP do
        begin
          if hp^.typ = ait_instruction then
            DoReplaceReg(orgReg,newReg,paicpu(hp));
          GetNextInstruction(hp,hp)
        end;
      if assigned(endp) and (endp^.typ = ait_instruction) then
        DoReplaceReadReg(orgReg,newReg,paicpu(endP));
      if (p <> endp) then
        if not RegModifiedByInstruction(newReg,endP) then
          RestoreRegContentsTo(newReg, c ,p)
        else
          ClearRegContentsFrom(orgReg,p);
    end
{$ifdef replaceregdebug}
     else
       begin
         hp := new(pai_asm_comment,init(strpnew(
           'replacing '+att_reg2str[newreg]+' with '+att_reg2str[orgreg]+
           ' from here...')));
         hp^.previous := p^.previous;
         hp^.next := p;
         p^.previous := hp;
        if assigned(hp^.previous) then
          hp^.previous^.next := hp;

      hp := new(pai_asm_comment,init(strpnew(
        'replacing '+att_reg2str[newreg]+' with '+att_reg2str[orgreg]+
        ' failed here')));
      hp^.next := endp^.next;
      hp^.previous := endp;
      endp^.next := hp;
      if assigned(hp^.next) then
        hp^.next^.previous := hp;
       end;
{$endif replaceregdebug}
End;
{$endif replacereg}

Procedure DoCSE(AsmL: PAasmOutput; First, Last: Pai);
{marks the instructions that can be removed by RemoveInstructs. They're not
 removed immediately because sometimes an instruction needs to be checked in
 two different sequences}
Var Cnt, Cnt2: Longint;
    p, hp1, hp2: Pai;
    hp3, hp4: Pai;
{$ifdef csdebug}
    hp5: pai;
{$endif csdebug}
    RegInfo: TRegInfo;
    RegCounter: TRegister;
    TmpState: Byte;
Begin
  p := First;
  SkipHead(p);
  First := p;
  While (p <> Last) Do
    Begin
      Case p^.typ Of
{$ifdef alignreg}
        ait_align:
          SetAlignReg(p);
{$endif alignreg}
        ait_instruction:
          Begin
            Case Paicpu(p)^.opcode Of
              A_CLD: If GetLastInstruction(p, hp1) And
                        (PPaiProp(hp1^.OptInfo)^.DirFlag = F_NotSet) Then
                       PPaiProp(Pai(p)^.OptInfo)^.CanBeRemoved := True;
              A_MOV, A_MOVZX, A_MOVSX:
                Begin
                  Case Paicpu(p)^.oper[0].typ Of
                    Top_Ref:
                      Begin {destination is always a register in this case}
                        With PPaiProp(p^.OptInfo)^.Regs[Reg32(Paicpu(p)^.oper[1].reg)] Do
                          Begin
                            If (p = StartMod) And
                               GetLastInstruction (p, hp1) And
                               (hp1^.typ <> ait_marker)
                              Then
{so we don't try to check a sequence when p is the first instruction of the block}
                               If CheckSequence(p, Paicpu(p)^.oper[1].reg, Cnt, RegInfo) And
                                  (Cnt > 0) Then
                                 Begin
                                   hp1 := nil;
{ although it's perfectly ok to remove an instruction which doesn't contain }
{ the register that we've just checked (CheckSequence takes care of that),  }
{ the sequence containing this other register should also be completely     }
{ checked and removed, otherwise we may get situations like this:           }
{                                                                           }
{   movl 12(%ebp), %edx                       movl 12(%ebp), %edx           }
{   movl 16(%ebp), %eax                       movl 16(%ebp), %eax           }
{   movl 8(%edx), %edx                        movl 8(%edx), %edx            }
{   movl (%eax), eax                          movl (%eax), eax              }
{   cmpl %eax, %edx                           cmpl %eax, %edx               }
{   jnz  l123           getting converted to  jnz  l123                     }
{   movl 12(%ebp), %edx                       movl 4(%eax), eax             }
{   movl 16(%ebp), %eax                                                     }
{   movl 8(%edx), %edx                                                      }
{   movl 4(%eax), eax                                                       }
                                   hp2 := p;
                                   Cnt2 := 1;
                                   While Cnt2 <= Cnt Do
                                     Begin
                                       If (hp1 = nil) And
                                          Not(RegInInstruction(Paicpu(hp2)^.oper[1].reg, p) Or
                                              RegInInstruction(Reg32(Paicpu(hp2)^.oper[1].reg), p)) And
                                          Not((p^.typ = ait_instruction) And
                                              (paicpu(p)^.OpCode = A_MOV) And
                                              (paicpu(p)^.Oper[0].typ = top_ref) And
                                              (PPaiProp(p^.OptInfo)^.Regs[Reg32(paicpu(p)^.Oper[1].reg)].NrOfMods
                                                 <= (Cnt - Cnt2 + 1)))
                                         Then hp1 := p;
{$ifndef noremove}
                                       PPaiProp(p^.OptInfo)^.CanBeRemoved := True;
{$endif noremove}
                                       Inc(Cnt2);
                                       GetNextInstruction(p, p);
                                     End;
                                   hp3 := New(Pai_Marker,Init(NoPropInfoStart));
                                   InsertLLItem(AsmL, Pai(hp2^.Previous), hp2, hp3);
 {hp4 is used to get the contents of the registers before the sequence}
                                   GetLastInstruction(hp2, hp4);
{$IfDef CSDebug}
              For RegCounter := R_EAX To R_EDI Do
                If (RegCounter in RegInfo.RegsLoadedForRef) Then
                  Begin
           hp5 := new(pai_asm_comment,init(strpnew('New: '+att_reg2str[RegCounter]+', Old: '+
                                                  att_reg2str[RegInfo.New2OldReg[RegCounter]])));
           InsertLLItem(AsmL, Pai(hp2^.previous), hp2, hp5);
                  End;
{$EndIf CSDebug}
 { If some registers were different in the old and the new sequence, move }
 { the contents of those old registers to the new ones                    }
                                   For RegCounter := R_EAX To R_EDI Do
                                     If Not(RegCounter in [R_ESP,procinfo^.framepointer]) And
                                        (RegInfo.New2OldReg[RegCounter] <> R_NO) Then
                                       Begin
                                         AllocRegBetween(AsmL,RegInfo.New2OldReg[RegCounter],
                                           PPaiProp(hp4^.OptInfo)^.Regs[RegInfo.New2OldReg[RegCounter]].StartMod,hp2);
                                         If Not(RegCounter In RegInfo.RegsLoadedForRef) And
                                                        {old reg                new reg}
                                            (RegInfo.New2OldReg[RegCounter] <> RegCounter) Then
                                           Begin
{$ifdef replacereg}
                                             If not ReplaceReg(RegInfo.New2OldReg[RegCounter],
                                                      regCounter,p,
                                                      PPaiProp(hp4^.optInfo)^.Regs[regCounter]) then
                                               begin
{$endif replacereg}
                                                 hp3 := New(Paicpu,Op_Reg_Reg(A_MOV, S_L,
                                                                         {old reg          new reg}
                                                       RegInfo.New2OldReg[RegCounter], RegCounter));
                                                 InsertLLItem(AsmL, Pai(hp2^.previous), hp2, hp3);
{$ifdef replacereg}
                                               end
{$ifdef replaceregdebug}
                                                else
                                                  begin
                                                    hp3 := new(pai_asm_comment,init(strpnew(
                                                               'restored '+att_reg2str[regCounter]+' with data from here...')));
                                                    insertllitem(asml,hp4,hp4^.next,hp3);
                                                  end;
{$endif replaceregdebug}
{$endif replacereg}
                                           End
                                         Else
{   imagine the following code:                                            }
{        normal                    wrong optimized                         }
{    movl 8(%ebp), %eax           movl 8(%ebp), %eax                       }
{    movl (%eax), %eax            movl (%eax), %eax                        }
{    cmpl 8(%ebp), %eax           cmpl 8(%ebp), %eax                       }
{    jne l1                       jne l1                                   }
{    movl 8(%ebp), %eax                                                    }
{    movl (%eax), %edi            movl %eax, %edi                          }
{     movl %edi, -4(%ebp)          movl %edi, -4(%ebp)                      }
{    movl 8(%ebp), %eax                                                    }
{    pushl 70(%eax)               pushl 70(%eax)                           }
{                                                                          }
{   The error is that at the moment that the last instruction is executed, }
{   %eax doesn't contain 8(%ebp) anymore. Solution: the contents of        }
{   registers that are completely removed from a sequence (= registers in  }
{   RegLoadedForRef, have to be changed to their contents from before the  }
{   sequence.                                                              }
                                         If RegCounter in RegInfo.RegsLoadedForRef Then
                                          Begin
{load Cnt2 with the total number of instructions of this sequence}
                                           Cnt2 := PPaiProp(hp4^.OptInfo)^.
                                                   Regs[RegInfo.New2OldReg[RegCounter]].NrOfMods;

                                           hp3 := hp2;
                                           For Cnt := 1 to Pred(Cnt2) Do
                                             GetNextInstruction(hp3, hp3);
                                           TmpState := PPaiProp(hp3^.OptInfo)^.Regs[RegCounter].WState;
                                           GetNextInstruction(hp3, hp3);
{$ifdef csdebug}
         Writeln('Cnt2: ',Cnt2);
         hp5 := new(pai_asm_comment,init(strpnew('starting here...')));
         InsertLLItem(AsmL, Pai(hp2^.previous), hp2, hp5);
{$endif csdebug}
                                               hp3 := hp2;
{first change the contents of the register inside the sequence}
                                               For Cnt := 1 to Cnt2 Do
                                                 Begin
{save the WState of the last pai object of the sequence for later use}
                                                   TmpState := PPaiProp(hp3^.OptInfo)^.Regs[RegCounter].WState;
{$ifdef csdebug}
         hp5 := new(pai_asm_comment,init(strpnew('WState for '+att_reg2str[Regcounter]+': '
                                                  +tostr(tmpstate))));
         InsertLLItem(AsmL, hp3, pai(hp3^.next), hp5);
{$endif csdebug}
                                                   PPaiProp(hp3^.OptInfo)^.Regs[RegCounter] :=
                                                     PPaiProp(hp4^.OptInfo)^.Regs[RegCounter];
                                                   GetNextInstruction(hp3, hp3);
                                                 End;
{here, hp3 = p = Pai object right after the sequence, TmpState = WState of
 RegCounter at the last Pai object of the sequence}
                                               GetLastInstruction(hp3, hp3);
                                               While GetNextInstruction(hp3, hp3) And
                                                     (PPaiProp(hp3^.OptInfo)^.Regs[RegCounter].WState
                                                      = TmpState) Do
{$ifdef csdebug}
    begin
         hp5 := new(pai_asm_comment,init(strpnew('WState for '+att_reg2str[Regcounter]+': '+
                                                  tostr(PPaiProp(hp3^.OptInfo)^.Regs[RegCounter].WState))));
         InsertLLItem(AsmL, hp3, pai(hp3^.next), hp5);
{$endif csdebug}
                                                 PPaiProp(hp3^.OptInfo)^.Regs[RegCounter] :=
                                                   PPaiProp(hp4^.OptInfo)^.Regs[RegCounter];
{$ifdef csdebug}
    end;
{$endif csdebug}
{$ifdef csdebug}
         hp5 := new(pai_asm_comment,init(strpnew('stopping here...')));
         InsertLLItem(AsmL, hp3, pai(hp3^.next), hp5);
{$endif csdebug}
                                          End;
                                       End;
                                   hp3 := New(Pai_Marker,Init(NoPropInfoEnd));
                                   InsertLLItem(AsmL, Pai(hp2^.Previous), hp2, hp3);
                                   If hp1 <> nil Then p := hp1;
                                   Continue;
                                 End
                               Else
                                 If (Cnt > 0) And
                                    (PPaiProp(p^.OptInfo)^.
                                      Regs[Reg32(Paicpu(p)^.oper[1].reg)].Typ = Con_Ref) And
                                    (PPaiProp(p^.OptInfo)^.CanBeRemoved) Then
                                   Begin
                                     hp2 := p;
                                     Cnt2 := 1;
                                     While Cnt2 <= Cnt Do
                                       Begin
                                         If RegInInstruction(Paicpu(hp2)^.oper[1].reg, p) Or
                                            RegInInstruction(Reg32(Paicpu(hp2)^.oper[1].reg), p) Then
                                           PPaiProp(p^.OptInfo)^.CanBeRemoved := False;
                                         Inc(Cnt2);
                                         GetNextInstruction(p, p);
                                       End;
                                     Continue;
                                   End;
                          End;
                      End;
                    Top_Const:
                      Begin
                        Case Paicpu(p)^.oper[1].typ Of
                          Top_Reg:
                            Begin
                              If GetLastInstruction(p, hp1) Then
                                With PPaiProp(hp1^.OptInfo)^.Regs[Reg32(Paicpu(p)^.oper[1].reg)] Do
                                  If (Typ = Con_Const) And
                                     (StartMod = p) Then
                                    PPaiProp(p^.OptInfo)^.CanBeRemoved := True;
                            End;
{                          Top_Ref:;}
                        End;
                      End;
                  End;
                End;
              A_STD: If GetLastInstruction(p, hp1) And
                        (PPaiProp(hp1^.OptInfo)^.DirFlag = F_Set) Then
                        PPaiProp(Pai(p)^.OptInfo)^.CanBeRemoved := True;
              A_XOR:
                Begin
                  If (Paicpu(p)^.oper[0].typ = top_reg) And
                     (Paicpu(p)^.oper[0].typ = top_reg) And
                     (Paicpu(p)^.oper[1].reg = Paicpu(p)^.oper[1].reg) And
                     GetLastInstruction(p, hp1) And
                     (PPaiProp(hp1^.OptInfo)^.Regs[Reg32(Paicpu(p)^.oper[1].reg)].typ = con_const) And
                     (PPaiProp(hp1^.OptInfo)^.Regs[Reg32(Paicpu(p)^.oper[1].reg)].StartMod = nil)
                    Then PPaiProp(p^.OptInfo)^.CanBeRemoved := True
                End
            End
          End;
      End;
      GetNextInstruction(p, p);
    End;
End;

Procedure RemoveInstructs(AsmL: PAasmOutput; First, Last: Pai);
{Removes the marked instructions and disposes the PPaiProps of the other
 instructions, restoring their line number}
Var p, hp1: Pai;
{$IfDef TP}
    TmpLine: Longint;
{$EndIf TP}
    InstrCnt: Longint;
Begin
  p := First;
  SkipHead(P);
  InstrCnt := 1;
  While (p <> Last) Do
    Begin
{$ifndef noinstremove}
      If PPaiProp(p^.OptInfo)^.CanBeRemoved
        Then
          Begin
{$IfDef TP}
            Dispose(PPaiProp(p^.OptInfo));
{$EndIf}
            GetNextInstruction(p, hp1);
            AsmL^.Remove(p);
            Dispose(p, Done);
            p := hp1;
            Inc(InstrCnt);
          End
        Else
{$endif noinstremove}
          Begin
{$IfDef TP}
            Dispose(PPaiProp(p^.OptInfo));
{$EndIf TP}
            p^.OptInfo := nil;
            GetNextInstruction(p, p);
            Inc(InstrCnt);
          End;
    End;
{$IfNDef TP}
    FreeMem(PaiPropBlock, NrOfPaiObjs*(((SizeOf(TPaiProp)+3)div 4)*4))
{$EndIf TP}
End;

Procedure CSE(AsmL: PAasmOutput; First, Last: Pai);
Begin
  DoCSE(AsmL, First, Last);
  RemoveInstructs(AsmL, First, Last);
End;

End.

{
 $Log$
 Revision 1.32  1999-11-14 11:26:53  jonas
   + basic register renaming (not yet working completely, between
     -dreplacereg/-dreplaceregdebug)

 Revision 1.31  1999/11/06 16:21:57  jonas
   + search optimial register to use in alignment code (compile with
     -dalignreg, -dalignregdebug to see chosen register in
     assembler code). Still needs support in ag386bin.

 Revision 1.30  1999/11/06 14:34:20  peter
   * truncated log to 20 revs

 Revision 1.29  1999/11/05 16:01:46  jonas
   + first implementation of choosing least used register for alignment code
      (not yet working, between ifdef alignreg)

 Revision 1.28  1999/10/11 11:11:31  jonas
   * fixed bug which sometimes caused a crash when optimizing blocks of code with
     assembler blocks (didn't notice before because of lack of zero page protection
     under Win9x :( )

 Revision 1.27  1999/10/01 13:51:40  jonas
   * CSE now updates the RegAlloc's

 Revision 1.26  1999/09/30 14:43:13  jonas
   * fixed small efficiency which caused some missed optimizations (saves 1
     assembler instruction on the whole compiler/RTL source tree! :)

 Revision 1.25  1999/09/27 23:44:50  peter
   * procinfo is now a pointer
   * support for result setting in sub procedure

 Revision 1.24  1999/08/25 11:59:58  jonas
   * changed pai386, paippc and paiapha (same for tai*) to paicpu (taicpu)

 Revision 1.23  1999/08/04 00:22:58  florian
   * renamed i386asm and i386base to cpuasm and cpubase

 Revision 1.22  1999/06/03 15:45:08  jonas
   * sequences are now checked only once (previously, some long ones were
     checked once completely and then several times partially)

 Revision 1.21  1999/05/08 20:38:03  jonas
   * seperate OPTimizer INFO pointer field in tai object

 Revision 1.20  1999/05/01 13:24:19  peter
   * merged nasm compiler
   * old asm moved to oldasm/

 Revision 1.2  1999/03/29 16:05:45  peter
   * optimizer working for ag386bin

 Revision 1.1  1999/03/26 00:01:09  peter
   * first things for optimizer (compiles but cycle crashes)

 Revision 1.19  1999/02/26 00:48:17  peter
   * assembler writers fixed for ag386bin

 Revision 1.18  1998/12/29 18:48:22  jonas
   + optimize pascal code surrounding assembler blocks

 Revision 1.17  1998/12/17 16:37:39  jonas
   + extra checks in RegsEquivalent so some more optimizations can be done (which
     where disabled by the second fix from revision 1.22)

 Revision 1.16  1998/12/02 16:23:31  jonas
   * changed "if longintvar in set" to case or "if () or () .." statements
   * tree.pas: changed inlinenumber (and associated constructor/vars) to a byte

 Revision 1.15  1998/11/24 19:47:24  jonas
   * fixed problems posiible with 3 operand instructions

 Revision 1.14  1998/11/09 19:40:48  jonas
   * fixed comments from last commit (apparently there's still a 255 char limit :( )

 Revision 1.13  1998/11/09 19:33:39  jonas
   * changed specific bugfix (which was actually wrong implemented, but
     did the right thing in most cases nevertheless) to general bugfix
   * fixed bug that caused
     mov (ebp), edx                                    mov (ebp), edx
     mov (edx), edx                                    mov (edx), edx
     ...                   being changed to            ...
     mov (ebp), edx                                    mov edx, eax
     mov (eax), eax
     but this disabled another small correct optimization...

 Revision 1.12  1998/10/20 09:32:54  peter
   * removed some unused vars

}
