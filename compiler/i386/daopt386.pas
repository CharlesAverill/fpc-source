{
    $Id$
    Copyright (c) 1998-2000 by Jonas Maebe, member of the Freepascal
      development team

    This unit contains the data flow analyzer and several helper procedures
    and functions.

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
Unit DAOpt386;

{$i defines.inc}

Interface

Uses
  GlobType,
  CObjects,Aasm,
  cpubase,cpuasm;

{******************************* Constants *******************************}

Const

{Possible register content types}
  con_Unknown = 0;
  con_ref = 1;
  con_const = 2;
  { The contents aren't usable anymore for CSE, but they may still be   }
  { usefull for detecting whether the result of a load is actually used }
  con_invalid = 3;
  { the reverse of the above (in case a (conditional) jump is encountered): }
  { CSE is still possible, but the original instruction can't be removed    }
  con_noRemoveRef = 4;
  { same, but for constants }
  con_noRemoveConst = 5;

{********************************* Types *********************************}

type
  TRegArray = Array[R_EAX..R_BL] of TRegister;
  TRegSet = Set of R_EAX..R_BL;
  TRegInfo = Record
                NewRegsEncountered, OldRegsEncountered: TRegSet;
                RegsLoadedForRef: TRegSet;
                regsStillUsedAfterSeq: TRegSet;
                lastReload: array[R_EAX..R_EDI] of pai;
                New2OldReg: TRegArray;
              End;

{possible actions on an operand: read, write or modify (= read & write)}
  TOpAction = (OpAct_Read, OpAct_Write, OpAct_Modify, OpAct_Unknown);

{the possible states of a flag}
  TFlagContents = (F_Unknown, F_NotSet, F_Set);

  TContent = Packed Record
      {start and end of block instructions that defines the
       content of this register.}
               StartMod: pai;
      {how many instructions starting with StarMod does the block consist of}
               NrOfMods: Byte;
      {the type of the content of the register: unknown, memory, constant}
               Typ: Byte;
               case byte of
      {starts at 0, gets increased everytime the register is written to}
                 1: (WState: Byte;
      {starts at 0, gets increased everytime the register is read from}
                       RState: Byte);
      { to compare both states in one operation }
                 2: (state: word);
             End;

{Contents of the integer registers}
  TRegContent = Array[R_EAX..R_EDI] Of TContent;

{contents of the FPU registers}
  TRegFPUContent = Array[R_ST..R_ST7] Of TContent;

{$ifdef tempOpts}
{ linked list which allows searching/deleting based on value, no extra frills}
  PSearchLinkedListItem = ^TSearchLinkedListItem;
  TSearchLinkedListItem = object(TLinkedList_Item)
    constructor init;
    function equals(p: PSearchLinkedListItem): boolean; virtual;
  end;

  PSearchDoubleIntItem = ^TSearchDoubleInttem;
  TSearchDoubleIntItem = object(TLinkedList_Item)
    constructor init(_int1,_int2: longint);
    function equals(p: PSearchLinkedListItem): boolean; virtual;
   private
    int1, int2: longint;
  end;

  PSearchLinkedList = ^TSearchLinkedList;
  TSearchLinkedList = object(TLinkedList)
    function searchByValue(p: PSearchLinkedListItem): boolean;
    procedure removeByValue(p: PSearchLinkedListItem);
  end;
{$endif tempOpts}

{information record with the contents of every register. Every Pai object
 gets one of these assigned: a pointer to it is stored in the OptInfo field}
  TPaiProp = Record
               Regs: TRegContent;
{               FPURegs: TRegFPUContent;} {currently not yet used}
    { allocated Registers }
               UsedRegs: TRegSet;
    { status of the direction flag }
               DirFlag: TFlagContents;
{$ifdef tempOpts}
    { currently used temps }
               tempAllocs: PSearchLinkedList;
{$endif tempOpts}
    { can this instruction be removed? }
               CanBeRemoved: Boolean;
             End;

  PPaiProp = ^TPaiProp;

  TPaiPropBlock = Array[1..250000] Of TPaiProp;
  PPaiPropBlock = ^TPaiPropBlock;

  TInstrSinceLastMod = Array[R_EAX..R_EDI] Of Byte;

  TLabelTableItem = Record
                      PaiObj: Pai;
{$IfDef JumpAnal}
                      InstrNr: Longint;
                      RefsFound: Word;
                      JmpsProcessed: Word
{$EndIf JumpAnal}
                    End;
  TLabelTable = Array[0..2500000] Of TLabelTableItem;
  PLabelTable = ^TLabelTable;


{*********************** Procedures and Functions ************************}

Procedure InsertLLItem(AsmL: PAasmOutput; prev, foll, new_one: PLinkedList_Item);

Function Reg32(Reg: TRegister): TRegister;
Function RefsEquivalent(Const R1, R2: TReference; Var RegInfo: TRegInfo; OpAct: TOpAction): Boolean;
Function RefsEqual(Const R1, R2: TReference): Boolean;
Function IsGP32Reg(Reg: TRegister): Boolean;
Function RegInRef(Reg: TRegister; Const Ref: TReference): Boolean;
function RegReadByInstruction(reg: TRegister; hp: pai): boolean;
function RegModifiedByInstruction(Reg: TRegister; p1: Pai): Boolean;
function RegInInstruction(Reg: TRegister; p1: Pai): Boolean;
function RegInOp(Reg: TRegister; const o:toper): Boolean;

function writeToMemDestroysContents(regWritten: tregister; const ref: treference;
  reg: tregister; const c: tcontent): boolean;
function writeToRegDestroysContents(destReg: tregister; reg: tregister;
  const c: tcontent): boolean;
function writeDestroysContents(const op: toper; reg: tregister;
  const c: tcontent): boolean;


Function GetNextInstruction(Current: Pai; Var Next: Pai): Boolean;
Function GetLastInstruction(Current: Pai; Var Last: Pai): Boolean;
Procedure SkipHead(var P: Pai);
function labelCanBeSkipped(p: pai_label): boolean;

Procedure RemoveLastDeallocForFuncRes(asmL: PAasmOutput; p: pai);
Function regLoadedWithNewValue(reg: tregister; canDependOnPrevValue: boolean;
           hp: pai): boolean;
Procedure UpdateUsedRegs(Var UsedRegs: TRegSet; p: Pai);
Procedure AllocRegBetween(AsmL: PAasmOutput; Reg: TRegister; p1, p2: Pai);
function FindRegDealloc(reg: tregister; p: pai): boolean;

Function RegsEquivalent(OldReg, NewReg: TRegister; Var RegInfo: TRegInfo; OpAct: TopAction): Boolean;
Function InstructionsEquivalent(p1, p2: Pai; Var RegInfo: TRegInfo): Boolean;
Function OpsEqual(const o1,o2:toper): Boolean;

Function DFAPass1(AsmL: PAasmOutput; BlockStart: Pai): Pai;
Function DFAPass2(
{$ifdef statedebug}
                   AsmL: PAasmOutPut;
{$endif statedebug}
                                      BlockStart, BlockEnd: Pai): Boolean;
Procedure ShutDownDFA;

Function FindLabel(L: PasmLabel; Var hp: Pai): Boolean;

Procedure IncState(Var S: Byte; amount: longint);

{******************************* Variables *******************************}

Var
{the amount of PaiObjects in the current assembler list}
  NrOfPaiObjs: Longint;

{Array which holds all TPaiProps}
  PaiPropBlock: PPaiPropBlock;

  LoLab, HiLab, LabDif: Longint;

  LTable: PLabelTable;

{*********************** End of Interface section ************************}


Implementation

Uses
  globals, systems, verbose, hcodegen, symconst, tgeni386;

Type
  TRefCompare = function(const r1, r2: TReference): Boolean;

Var
 {How many instructions are between the current instruction and the last one
  that modified the register}
  NrOfInstrSinceLastMod: TInstrSinceLastMod;

{$ifdef tempOpts}
  constructor TSearchLinkedListItem.init;
  begin
  end;

  function TSearchLinkedListItem.equals(p: PSearchLinkedListItem): boolean;
  begin
    equals := false;
  end;

  constructor TSearchDoubleIntItem.init(_int1,_int2: longint);
  begin
    int1 := _int1;
    int2 := _int2;
  end;

  function TSearchDoubleIntItem.equals(p: PSearchLinkedListItem): boolean;
  begin
    equals := (TSearchDoubleIntItem(p).int1 = int1) and
              (TSearchDoubleIntItem(p).int2 = int2);
  end;

  function TSearchLinkedList.searchByValue(p: PSearchLinkedListItem): boolean;
  var temp: PSearchLinkedListItem;
  begin
    temp := first;
    while (temp <> last^.next) and
          not(temp^.equals(p)) do
      temp := temp^.next;
    searchByValue := temp <> last^.next;
  end;

  procedure TSearchLinkedList.removeByValue(p: PSearchLinkedListItem);
  begin
    temp := first;
    while (temp <> last^.next) and
          not(temp^.equals(p)) do
      temp := temp^.next;
    if temp <> last^.next then
      begin
        remove(temp);
        dispose(temp,done);
      end;
  end;

Procedure updateTempAllocs(Var UsedRegs: TRegSet; p: Pai);
{updates UsedRegs with the RegAlloc Information coming after P}
Begin
  Repeat
    While Assigned(p) And
          ((p^.typ in (SkipInstr - [ait_RegAlloc])) or
           ((p^.typ = ait_label) And
            labelCanBeSkipped(pai_label(current)))) Do
         p := Pai(p^.next);
    While Assigned(p) And
          (p^.typ=ait_RegAlloc) Do
      Begin
        if pairegalloc(p)^.allocation then
          UsedRegs := UsedRegs + [PaiRegAlloc(p)^.Reg]
        else
          UsedRegs := UsedRegs - [PaiRegAlloc(p)^.Reg];
        p := pai(p^.next);
      End;
  Until Not(Assigned(p)) Or
        (Not(p^.typ in SkipInstr) And
         Not((p^.typ = ait_label) And
             labelCanBeSkipped(pai_label(current))));
End;

{$endif tempOpts}

{************************ Create the Label table ************************}

Function FindLoHiLabels(Var LowLabel, HighLabel, LabelDif: Longint; BlockStart: Pai): Pai;
{Walks through the paasmlist to find the lowest and highest label number}
Var LabelFound: Boolean;
    P, lastP: Pai;
Begin
  LabelFound := False;
  LowLabel := MaxLongint;
  HighLabel := 0;
  P := BlockStart;
  lastP := p;
  While Assigned(P) Do
    Begin
      If (Pai(p)^.typ = ait_label) Then
        If not labelCanBeSkipped(pai_label(p))
          Then
            Begin
              LabelFound := True;
              If (Pai_Label(p)^.l^.labelnr < LowLabel) Then
                LowLabel := Pai_Label(p)^.l^.labelnr;
              If (Pai_Label(p)^.l^.labelnr > HighLabel) Then
                HighLabel := Pai_Label(p)^.l^.labelnr;
            End;
      lastP := p;
      GetNextInstruction(p, p);
    End;
  if (lastP^.typ = ait_marker) and
     (pai_marker(lastP)^.kind = asmBlockStart) then
    FindLoHiLabels := lastP
  else FindLoHiLabels := nil;
  If LabelFound
    Then LabelDif := HighLabel+1-LowLabel
    Else LabelDif := 0;
End;

Function FindRegAlloc(Reg: TRegister; StartPai: Pai; alloc: boolean): Boolean;
{ Returns true if a ait_alloc object for Reg is found in the block of Pai's }
{ starting with StartPai and ending with the next "real" instruction        }
Begin
  FindRegAlloc := false;
  Repeat
    While Assigned(StartPai) And
          ((StartPai^.typ in (SkipInstr - [ait_regAlloc])) Or
           ((StartPai^.typ = ait_label) and
            labelCanBeSkipped(pai_label(startPai)))) Do
      StartPai := Pai(StartPai^.Next);
    If Assigned(StartPai) and
       (StartPai^.typ = ait_regAlloc) then
      begin
        if (PairegAlloc(StartPai)^.allocation = alloc) and
           (PairegAlloc(StartPai)^.Reg = Reg) then
          begin
            FindRegAlloc:=true;
            break;
          end;
        StartPai := Pai(StartPai^.Next);
      end
    else
      break;
  Until false;
End;

Procedure RemoveLastDeallocForFuncRes(asmL: PAasmOutput; p: pai);

  Procedure DoRemoveLastDeallocForFuncRes(asmL: PAasmOutput; reg: TRegister);
  var
    hp2: pai;
  begin
    hp2 := p;
    repeat
      hp2 := pai(hp2^.previous);
      if assigned(hp2) and
         (hp2^.typ = ait_regalloc) and
         not(pairegalloc(hp2)^.allocation) and
         (pairegalloc(hp2)^.reg = reg) then
        begin
          asml^.remove(hp2);
          dispose(hp2,done);
          break;
        end;
    until not(assigned(hp2)) or
          regInInstruction(reg,hp2);
  end;

begin
  if assigned(procinfo^.returntype.def) then
    case procinfo^.returntype.def^.deftype of
      arraydef,recorddef,pointerdef,
         stringdef,enumdef,procdef,objectdef,errordef,
         filedef,setdef,procvardef,
         classrefdef,forwarddef:
        DoRemoveLastDeallocForFuncRes(asmL,R_EAX);
      orddef:
        if procinfo^.returntype.def^.size <> 0 then
          begin
            DoRemoveLastDeallocForFuncRes(asmL,R_EAX);
            { for int64/qword }
            if procinfo^.returntype.def^.size = 8 then
              DoRemoveLastDeallocForFuncRes(asmL,R_EDX);
          end;
    end;
end;

procedure getNoDeallocRegs(var regs: TRegSet);
var regCounter: TRegister;
begin
  regs := [];
  if assigned(procinfo^.returntype.def) then
    case procinfo^.returntype.def^.deftype of
      arraydef,recorddef,pointerdef,
         stringdef,enumdef,procdef,objectdef,errordef,
         filedef,setdef,procvardef,
         classrefdef,forwarddef:
       regs := [R_EAX];
      orddef:
        if procinfo^.returntype.def^.size <> 0 then
          begin
            regs := [R_EAX];
            { for int64/qword }
            if procinfo^.returntype.def^.size = 8 then
              regs := regs + [R_EDX];
          end;
    end;
  for regCounter := R_EAX to R_EBX do
    if not(regCounter in usableregs) then
      regs := regs + [regCounter];
end;

Procedure AddRegDeallocFor(asmL: paasmOutput; reg: TRegister; p: pai);
var hp1: pai;
    funcResRegs: TRegset;
    funcResReg: boolean;
begin
  if not(reg in usableregs) then
    exit;
  getNoDeallocRegs(funcResRegs);
  funcResRegs := funcResRegs - usableregs;
  funcResReg := reg in funcResRegs;
  hp1 := p;
  while not(funcResReg and
            (p^.typ = ait_instruction) and
            (paicpu(p)^.opcode = A_JMP) and
            (pasmlabel(paicpu(p)^.oper[0].sym) = aktexit2label)) and
        getLastInstruction(p, p) And
        not(regInInstruction(reg, p)) Do
    hp1 := p;
  { don't insert a dealloc for registers which contain the function result }
  { if they are followed by a jump to the exit label (for exit(...))       }
  if not(funcResReg) or
     not((hp1^.typ = ait_instruction) and
         (paicpu(hp1)^.opcode = A_JMP) and
         (pasmlabel(paicpu(hp1)^.oper[0].sym) = aktexit2label)) then
    begin
      p := new(paiRegAlloc, deAlloc(reg));
      insertLLItem(AsmL, hp1^.previous, hp1, p);
    end;
end;

Procedure BuildLabelTableAndFixRegAlloc(asmL: PAasmOutput; Var LabelTable: PLabelTable; LowLabel: Longint;
            Var LabelDif: Longint; BlockStart, BlockEnd: Pai);
{Builds a table with the locations of the labels in the paasmoutput.
 Also fixes some RegDeallocs like "# %eax released; push (%eax)"}
Var p, hp1, hp2, lastP: Pai;
    regCounter: TRegister;
    UsedRegs, noDeallocRegs: TRegSet;
Begin
  UsedRegs := [];
  If (LabelDif <> 0) Then
    Begin
      GetMem(LabelTable, LabelDif*SizeOf(TLabelTableItem));
      FillChar(LabelTable^, LabelDif*SizeOf(TLabelTableItem), 0);
    End;
  p := BlockStart;
  lastP := p;
  While (P <> BlockEnd) Do
    Begin
      Case p^.typ Of
        ait_Label:
          If not labelCanBeSkipped(pai_label(p)) Then
            LabelTable^[Pai_Label(p)^.l^.labelnr-LowLabel].PaiObj := p;
        ait_regAlloc:
          { ESI and EDI are (de)allocated manually, don't mess with them }
          if not(paiRegAlloc(p)^.Reg in [R_EDI,R_ESI]) then
            begin
              if PairegAlloc(p)^.Allocation then
                Begin
                  If Not(paiRegAlloc(p)^.Reg in UsedRegs) Then
                    UsedRegs := UsedRegs + [paiRegAlloc(p)^.Reg]
                  Else
                    addRegDeallocFor(asmL, paiRegAlloc(p)^.reg, p);
                End
              else
                begin
                  UsedRegs := UsedRegs - [paiRegAlloc(p)^.Reg];
                  hp1 := p;
                  hp2 := nil;
                  While Not(FindRegAlloc(paiRegAlloc(p)^.Reg, Pai(hp1^.Next),true)) And
                        GetNextInstruction(hp1, hp1) And
                        RegInInstruction(paiRegAlloc(p)^.Reg, hp1) Do
                    hp2 := hp1;
                  If hp2 <> nil Then
                    Begin
                      hp1 := Pai(p^.previous);
                      AsmL^.Remove(p);
                      InsertLLItem(AsmL, hp2, Pai(hp2^.Next), p);
                      p := hp1;
                    end;
                end;
            end;
      end;
      repeat
        lastP := p;
        P := Pai(P^.Next);
      until not(Assigned(p)) or
            not(p^.typ in (SkipInstr - [ait_regalloc]));
    End;
  { don't add deallocation for function result variable or for regvars}
  getNoDeallocRegs(noDeallocRegs);
  usedRegs := usedRegs - noDeallocRegs;
  for regCounter := R_EAX to R_EDI do
    if regCounter in usedRegs then
      addRegDeallocFor(asmL,regCounter,lastP);
End;

{************************ Search the Label table ************************}

Function FindLabel(L: PasmLabel; Var hp: Pai): Boolean;

{searches for the specified label starting from hp as long as the
 encountered instructions are labels, to be able to optimize constructs like

 jne l2              jmp l2
 jmp l3     and      l1:
 l1:                 l2:
 l2:}

Var TempP: Pai;

Begin
  TempP := hp;
  While Assigned(TempP) and
       (TempP^.typ In SkipInstr + [ait_label,ait_align]) Do
    If (TempP^.typ <> ait_Label) Or
       (pai_label(TempP)^.l <> L)
      Then GetNextInstruction(TempP, TempP)
      Else
        Begin
          hp := TempP;
          FindLabel := True;
          exit
        End;
  FindLabel := False;
End;

{************************ Some general functions ************************}

Function TCh2Reg(Ch: TInsChange): TRegister;
{converts a TChange variable to a TRegister}
Begin
  If (Ch <= Ch_REDI) Then
    TCh2Reg := TRegister(Byte(Ch))
  Else
    If (Ch <= Ch_WEDI) Then
      TCh2Reg := TRegister(Byte(Ch) - Byte(Ch_REDI))
    Else
      If (Ch <= Ch_RWEDI) Then
        TCh2Reg := TRegister(Byte(Ch) - Byte(Ch_WEDI))
      Else
        If (Ch <= Ch_MEDI) Then
          TCh2Reg := TRegister(Byte(Ch) - Byte(Ch_RWEDI))
        Else InternalError($db)
End;

Function Reg32(Reg: TRegister): TRegister;
{Returns the 32 bit component of Reg if it exists, otherwise Reg is returned}
Begin
  Reg32 := Reg;
  If (Reg >= R_AX)
    Then
      If (Reg <= R_DI)
        Then Reg32 := Reg16ToReg32(Reg)
        Else
          If (Reg <= R_BL)
            Then Reg32 := Reg8toReg32(Reg);
End;

{ inserts new_one between prev and foll }
Procedure InsertLLItem(AsmL: PAasmOutput; prev, foll, new_one: PLinkedList_Item);
Begin
  If Assigned(prev) Then
    If Assigned(foll) Then
      Begin
        If Assigned(new_one) Then
          Begin
            new_one^.previous := prev;
            new_one^.next := foll;
            prev^.next := new_one;
            foll^.previous := new_one;
            Pai(new_one)^.fileinfo := Pai(foll)^.fileinfo;
          End;
      End
    Else AsmL^.Concat(new_one)
  Else If Assigned(Foll) Then AsmL^.Insert(new_one)
End;

{********************* Compare parts of Pai objects *********************}

Function RegsSameSize(Reg1, Reg2: TRegister): Boolean;
{returns true if Reg1 and Reg2 are of the same size (so if they're both
 8bit, 16bit or 32bit)}
Begin
  If (Reg1 <= R_EDI)
    Then RegsSameSize := (Reg2 <= R_EDI)
    Else
      If (Reg1 <= R_DI)
        Then RegsSameSize := (Reg2 in [R_AX..R_DI])
        Else
          If (Reg1 <= R_BL)
            Then RegsSameSize := (Reg2 in [R_AL..R_BL])
            Else RegsSameSize := False
End;

Procedure AddReg2RegInfo(OldReg, NewReg: TRegister; Var RegInfo: TRegInfo);
{updates the ???RegsEncountered and ???2???Reg fields of RegInfo. Assumes that
 OldReg and NewReg have the same size (has to be chcked in advance with
 RegsSameSize) and that neither equals R_NO}
Begin
  With RegInfo Do
    Begin
      NewRegsEncountered := NewRegsEncountered + [NewReg];
      OldRegsEncountered := OldRegsEncountered + [OldReg];
      New2OldReg[NewReg] := OldReg;
      Case OldReg Of
        R_EAX..R_EDI:
          Begin
            NewRegsEncountered := NewRegsEncountered + [Reg32toReg16(NewReg)];
            OldRegsEncountered := OldRegsEncountered + [Reg32toReg16(OldReg)];
            New2OldReg[Reg32toReg16(NewReg)] := Reg32toReg16(OldReg);
            If (NewReg in [R_EAX..R_EBX]) And
               (OldReg in [R_EAX..R_EBX]) Then
              Begin
                NewRegsEncountered := NewRegsEncountered + [Reg32toReg8(NewReg)];
                OldRegsEncountered := OldRegsEncountered + [Reg32toReg8(OldReg)];
                New2OldReg[Reg32toReg8(NewReg)] := Reg32toReg8(OldReg);
              End;
          End;
        R_AX..R_DI:
          Begin
            NewRegsEncountered := NewRegsEncountered + [Reg16toReg32(NewReg)];
            OldRegsEncountered := OldRegsEncountered + [Reg16toReg32(OldReg)];
            New2OldReg[Reg16toReg32(NewReg)] := Reg16toReg32(OldReg);
            If (NewReg in [R_AX..R_BX]) And
               (OldReg in [R_AX..R_BX]) Then
              Begin
                NewRegsEncountered := NewRegsEncountered + [Reg16toReg8(NewReg)];
                OldRegsEncountered := OldRegsEncountered + [Reg16toReg8(OldReg)];
                New2OldReg[Reg16toReg8(NewReg)] := Reg16toReg8(OldReg);
              End;
          End;
        R_AL..R_BL:
          Begin
            NewRegsEncountered := NewRegsEncountered + [Reg8toReg32(NewReg)]
                               + [Reg8toReg16(NewReg)];
            OldRegsEncountered := OldRegsEncountered + [Reg8toReg32(OldReg)]
                               + [Reg8toReg16(OldReg)];
            New2OldReg[Reg8toReg32(NewReg)] := Reg8toReg32(OldReg);
          End;
      End;
    End;
End;

Procedure AddOp2RegInfo(const o:Toper; Var RegInfo: TRegInfo);
Begin
  Case o.typ Of
    Top_Reg:
      If (o.reg <> R_NO) Then
        AddReg2RegInfo(o.reg, o.reg, RegInfo);
    Top_Ref:
      Begin
        If o.ref^.base <> R_NO Then
          AddReg2RegInfo(o.ref^.base, o.ref^.base, RegInfo);
        If o.ref^.index <> R_NO Then
          AddReg2RegInfo(o.ref^.index, o.ref^.index, RegInfo);
      End;
  End;
End;


Function RegsEquivalent(OldReg, NewReg: TRegister; Var RegInfo: TRegInfo; OPAct: TOpAction): Boolean;
Begin
  If Not((OldReg = R_NO) Or (NewReg = R_NO)) Then
    If RegsSameSize(OldReg, NewReg) Then
      With RegInfo Do
{here we always check for the 32 bit component, because it is possible that
 the 8 bit component has not been set, event though NewReg already has been
 processed. This happens if it has been compared with a register that doesn't
 have an 8 bit component (such as EDI). In that case the 8 bit component is
 still set to R_NO and the comparison in the Else-part will fail}
        If (Reg32(OldReg) in OldRegsEncountered) Then
          If (Reg32(NewReg) in NewRegsEncountered) Then
            RegsEquivalent := (OldReg = New2OldReg[NewReg])

 { If we haven't encountered the new register yet, but we have encountered the
   old one already, the new one can only be correct if it's being written to
   (and consequently the old one is also being written to), otherwise

   movl -8(%ebp), %eax        and         movl -8(%ebp), %eax
   movl (%eax), %eax                      movl (%edx), %edx

   are considered equivalent}

          Else
            If (OpAct = OpAct_Write) Then
              Begin
                AddReg2RegInfo(OldReg, NewReg, RegInfo);
                RegsEquivalent := True
              End
            Else Regsequivalent := False
        Else
           If Not(Reg32(NewReg) in NewRegsEncountered) and
              ((OpAct = OpAct_Write) or
               (newReg = oldReg)) Then
             Begin
               AddReg2RegInfo(OldReg, NewReg, RegInfo);
               RegsEquivalent := True
             End
           Else RegsEquivalent := False
    Else RegsEquivalent := False
  Else RegsEquivalent := OldReg = NewReg
End;

Function RefsEquivalent(Const R1, R2: TReference; var RegInfo: TRegInfo; OpAct: TOpAction): Boolean;
Begin
  If R1.is_immediate Then
    RefsEquivalent := R2.is_immediate and (R1.Offset = R2.Offset)
  Else
    RefsEquivalent := (R1.Offset+R1.OffsetFixup = R2.Offset+R2.OffsetFixup) And
                      RegsEquivalent(R1.Base, R2.Base, RegInfo, OpAct) And
                      RegsEquivalent(R1.Index, R2.Index, RegInfo, OpAct) And
                      (R1.Segment = R2.Segment) And (R1.ScaleFactor = R2.ScaleFactor) And
                      (R1.Symbol = R2.Symbol);
End;


Function RefsEqual(Const R1, R2: TReference): Boolean;
Begin
  If R1.is_immediate Then
    RefsEqual := R2.is_immediate and (R1.Offset = R2.Offset)
  Else
    RefsEqual := (R1.Offset+R1.OffsetFixup = R2.Offset+R2.OffsetFixup) And
                 (R1.Segment = R2.Segment) And (R1.Base = R2.Base) And
                 (R1.Index = R2.Index) And (R1.ScaleFactor = R2.ScaleFactor) And
                 (R1.Symbol=R2.Symbol);
End;

Function IsGP32Reg(Reg: TRegister): Boolean;
{Checks if the register is a 32 bit general purpose register}
Begin
  If (Reg >= R_EAX) and (Reg <= R_EBX)
    Then IsGP32Reg := True
    Else IsGP32reg := False
End;

Function RegInRef(Reg: TRegister; Const Ref: TReference): Boolean;
Begin {checks whether Ref contains a reference to Reg}
  Reg := Reg32(Reg);
  RegInRef := (Ref.Base = Reg) Or (Ref.Index = Reg)
End;

function RegReadByInstruction(reg: TRegister; hp: pai): boolean;
var p: paicpu;
    opCount: byte;
begin
  RegReadByInstruction := false;
  reg := reg32(reg);
  p := paicpu(hp);
  if hp^.typ <> ait_instruction then
    exit;
  case p^.opcode of
    A_IMUL:
      case p^.ops of
        1: regReadByInstruction := (reg = R_EAX) or reginOp(reg,p^.oper[0]);
        2,3:
          regReadByInstruction := regInOp(reg,p^.oper[0]) or
            regInOp(reg,p^.oper[1]);
      end;
    A_IDIV,A_DIV,A_MUL:
      begin
        regReadByInstruction :=
          regInOp(reg,p^.oper[0]) or (reg = R_EAX);
      end;
    else
      begin
        for opCount := 0 to 2 do
          if (p^.oper[opCount].typ = top_ref) and
             RegInRef(reg,p^.oper[opCount].ref^) then
            begin
              RegReadByInstruction := true;
              exit
            end;
        for opCount := 1 to MaxCh do
          case InsProp[p^.opcode].Ch[opCount] of
            Ch_REAX..CH_REDI,CH_RWEAX..Ch_MEDI:
              if reg = TCh2Reg(InsProp[p^.opcode].Ch[opCount]) then
                begin
                  RegReadByInstruction := true;
                  exit
                end;
            Ch_RWOp1,Ch_ROp1,Ch_MOp1:
              if (p^.oper[0].typ = top_reg) and
                 (reg32(p^.oper[0].reg) = reg) then
                begin
                  RegReadByInstruction := true;
                  exit
                end;
            Ch_RWOp2,Ch_ROp2,Ch_MOp2:
              if (p^.oper[1].typ = top_reg) and
                 (reg32(p^.oper[1].reg) = reg) then
                begin
                  RegReadByInstruction := true;
                  exit
                end;
            Ch_RWOp3,Ch_ROp3,Ch_MOp3:
              if (p^.oper[2].typ = top_reg) and
                 (reg32(p^.oper[2].reg) = reg) then
                begin
                  RegReadByInstruction := true;
                  exit
                end;
          end;
      end;
  end;
end;

function regInInstruction(Reg: TRegister; p1: Pai): Boolean;
{ Checks if Reg is used by the instruction p1                              }
{ Difference with "regReadBysinstruction() or regModifiedByInstruction()": }
{ this one ignores CH_ALL opcodes, while regModifiedByInstruction doesn't  }
var p: paicpu;
    opCount: byte;
begin
  reg := reg32(reg);
  regInInstruction := false;
  p := paicpu(p1);
  if p1^.typ <> ait_instruction then
    exit;
  case p^.opcode of
    A_IMUL:
      case p^.ops of
        1: regInInstruction := (reg = R_EAX) or reginOp(reg,p^.oper[0]);
        2,3:
          regInInstruction := regInOp(reg,p^.oper[0]) or
            regInOp(reg,p^.oper[1]) or regInOp(reg,p^.oper[2]);
      end;
    A_IDIV,A_DIV,A_MUL:
      regInInstruction :=
        regInOp(reg,p^.oper[0]) or
         (reg = R_EAX) or (reg = R_EDX)
    else
      begin
        for opCount := 1 to MaxCh do
          case InsProp[p^.opcode].Ch[opCount] of
            CH_REAX..CH_MEDI:
              if tch2reg(InsProp[p^.opcode].Ch[opCount]) = reg then
                begin
                  regInInstruction := true;
                  exit;
                end;
            Ch_ROp1..Ch_MOp1:
              if regInOp(reg,p^.oper[0]) then
                begin
                  regInInstruction := true;
                  exit
                end;
            Ch_ROp2..Ch_MOp2:
              if regInOp(reg,p^.oper[1]) then
                begin
                  regInInstruction := true;
                  exit
                end;
            Ch_ROp3..Ch_MOp3:
              if regInOp(reg,p^.oper[2]) then
                begin
                  regInInstruction := true;
                  exit
                end;
          end;
      end;
  end;
end;

Function RegInOp(Reg: TRegister; const o:toper): Boolean;
Begin
  RegInOp := False;
  reg := reg32(reg);
  Case o.typ Of
    top_reg: RegInOp := Reg = reg32(o.reg);
    top_ref: RegInOp := (Reg = o.ref^.Base) Or
                        (Reg = o.ref^.Index);
  End;
End;

Function RegModifiedByInstruction(Reg: TRegister; p1: Pai): Boolean;
Var InstrProp: TInsProp;
    TmpResult: Boolean;
    Cnt: Byte;
Begin
  TmpResult := False;
  Reg := Reg32(Reg);
  If (p1^.typ = ait_instruction) Then
    Case paicpu(p1)^.opcode of
      A_IMUL:
        With paicpu(p1)^ Do
          TmpResult :=
            ((ops = 1) and (reg in [R_EAX,R_EDX])) or
            ((ops = 2) and (Reg32(oper[1].reg) = reg)) or
            ((ops = 3) and (Reg32(oper[2].reg) = reg));
      A_DIV, A_IDIV, A_MUL:
        With paicpu(p1)^ Do
          TmpResult :=
            (Reg = R_EAX) or
            (Reg = R_EDX);
      Else
        Begin
          Cnt := 1;
          InstrProp := InsProp[paicpu(p1)^.OpCode];
          While (Cnt <= MaxCh) And
                (InstrProp.Ch[Cnt] <> Ch_None) And
                Not(TmpResult) Do
            Begin
              Case InstrProp.Ch[Cnt] Of
                Ch_WEAX..Ch_MEDI:
                  TmpResult := Reg = TCh2Reg(InstrProp.Ch[Cnt]);
                Ch_RWOp1,Ch_WOp1,Ch_Mop1:
                  TmpResult := (paicpu(p1)^.oper[0].typ = top_reg) and
                               (Reg32(paicpu(p1)^.oper[0].reg) = reg);
                Ch_RWOp2,Ch_WOp2,Ch_Mop2:
                  TmpResult := (paicpu(p1)^.oper[1].typ = top_reg) and
                               (Reg32(paicpu(p1)^.oper[1].reg) = reg);
                Ch_RWOp3,Ch_WOp3,Ch_Mop3:
                  TmpResult := (paicpu(p1)^.oper[2].typ = top_reg) and
                               (Reg32(paicpu(p1)^.oper[2].reg) = reg);
                Ch_FPU: TmpResult := Reg in [R_ST..R_ST7,R_MM0..R_MM7];
                Ch_ALL: TmpResult := true;
              End;
              Inc(Cnt)
            End
        End
    End;
  RegModifiedByInstruction := TmpResult
End;

{********************* GetNext and GetLastInstruction *********************}
Function GetNextInstruction(Current: Pai; Var Next: Pai): Boolean;
{ skips ait_regalloc, ait_regdealloc and ait_stab* objects and puts the }
{ next pai object in Next. Returns false if there isn't any             }
Begin
  Repeat
    If (Current^.typ = ait_marker) And
       (Pai_Marker(Current)^.Kind = AsmBlockStart) Then
      Begin
        GetNextInstruction := False;
        Next := Nil;
        Exit
      End;
    Current := Pai(Current^.Next);
    While Assigned(Current) And
          ((current^.typ In skipInstr) or
           ((current^.typ = ait_label) and
            labelCanBeSkipped(pai_label(current)))) do
      Current := Pai(Current^.Next);
{    If Assigned(Current) And
       (Current^.typ = ait_Marker) And
       (Pai_Marker(Current)^.Kind = NoPropInfoStart) Then
      Begin
        While Assigned(Current) And
              ((Current^.typ <> ait_Marker) Or
               (Pai_Marker(Current)^.Kind <> NoPropInfoEnd)) Do
          Current := Pai(Current^.Next);
      End;}
  Until Not(Assigned(Current)) Or
        (Current^.typ <> ait_Marker) Or
        not(Pai_Marker(Current)^.Kind in [NoPropInfoStart,NoPropInfoEnd]);
  Next := Current;
  If Assigned(Current) And
     Not((Current^.typ In SkipInstr) or
         ((Current^.typ = ait_label) And
          labelCanBeSkipped(pai_label(current))))
    Then
      GetNextInstruction :=
         not((current^.typ = ait_marker) and
             (pai_marker(current)^.kind = asmBlockStart))
    Else
      Begin
        GetNextInstruction := False;
        Next := nil;
      End;
End;

Function GetLastInstruction(Current: Pai; Var Last: Pai): Boolean;
{skips the ait-types in SkipInstr puts the previous pai object in
 Last. Returns false if there isn't any}
Begin
  Repeat
    Current := Pai(Current^.previous);
    While Assigned(Current) And
          (((Current^.typ = ait_Marker) And
            Not(Pai_Marker(Current)^.Kind in [AsmBlockEnd{,NoPropInfoEnd}])) or
           (Current^.typ In SkipInstr) or
           ((Current^.typ = ait_label) And
            labelCanBeSkipped(pai_label(current)))) Do
      Current := Pai(Current^.previous);
{    If Assigned(Current) And
       (Current^.typ = ait_Marker) And
       (Pai_Marker(Current)^.Kind = NoPropInfoEnd) Then
      Begin
        While Assigned(Current) And
              ((Current^.typ <> ait_Marker) Or
               (Pai_Marker(Current)^.Kind <> NoPropInfoStart)) Do
          Current := Pai(Current^.previous);
      End;}
  Until Not(Assigned(Current)) Or
        (Current^.typ <> ait_Marker) Or
        not(Pai_Marker(Current)^.Kind in [NoPropInfoStart,NoPropInfoEnd]);
  If Not(Assigned(Current)) or
     (Current^.typ In SkipInstr) or
     ((Current^.typ = ait_label) And
      labelCanBeSkipped(pai_label(current))) or
     ((Current^.typ = ait_Marker) And
      (Pai_Marker(Current)^.Kind = AsmBlockEnd))
    Then
      Begin
        Last := nil;
        GetLastInstruction := False
      End
    Else
      Begin
        Last := Current;
        GetLastInstruction := True;
      End;
End;

Procedure SkipHead(var P: Pai);
Var OldP: Pai;
Begin
  Repeat
    OldP := P;
    If (P^.typ in SkipInstr) Or
       ((P^.typ = ait_marker) And
        (Pai_Marker(P)^.Kind in [AsmBlockEnd,inlinestart,inlineend])) Then
      GetNextInstruction(P, P)
    Else If ((P^.Typ = Ait_Marker) And
        (Pai_Marker(P)^.Kind = nopropinfostart)) Then
   {a marker of the NoPropInfoStart can't be the first instruction of a
    paasmoutput list}
      GetNextInstruction(Pai(P^.Previous),P);
    Until P = OldP
End;

function labelCanBeSkipped(p: pai_label): boolean;
begin
  labelCanBeSkipped := not(p^.l^.is_used) or p^.l^.is_addr;
end;

{******************* The Data Flow Analyzer functions ********************}

function regLoadedWithNewValue(reg: tregister; canDependOnPrevValue: boolean;
           hp: pai): boolean;
{ assumes reg is a 32bit register }
var p: paicpu;
begin
  p := paicpu(hp);
  regLoadedWithNewValue :=
    assigned(hp) and
    (hp^.typ = ait_instruction) and
    (((p^.opcode = A_MOV) or
      (p^.opcode = A_MOVZX) or
      (p^.opcode = A_MOVSX) or
      (p^.opcode = A_LEA)) and
     (p^.oper[1].typ = top_reg) and
     (Reg32(p^.oper[1].reg) = reg) and
     (canDependOnPrevValue or
      (p^.oper[0].typ <> top_ref) or
      not regInRef(reg,p^.oper[0].ref^)) or
     ((p^.opcode = A_POP) and
      (Reg32(p^.oper[0].reg) = reg)));
end;

Procedure UpdateUsedRegs(Var UsedRegs: TRegSet; p: Pai);
{updates UsedRegs with the RegAlloc Information coming after P}
Begin
  Repeat
    While Assigned(p) And
          ((p^.typ in (SkipInstr - [ait_RegAlloc])) or
           ((p^.typ = ait_label) And
            labelCanBeSkipped(pai_label(p)))) Do
         p := Pai(p^.next);
    While Assigned(p) And
          (p^.typ=ait_RegAlloc) Do
      Begin
        if pairegalloc(p)^.allocation then
          UsedRegs := UsedRegs + [PaiRegAlloc(p)^.Reg]
        else
          UsedRegs := UsedRegs - [PaiRegAlloc(p)^.Reg];
        p := pai(p^.next);
      End;
  Until Not(Assigned(p)) Or
        (Not(p^.typ in SkipInstr) And
         Not((p^.typ = ait_label) And
             labelCanBeSkipped(pai_label(p))));
End;

Procedure AllocRegBetween(AsmL: PAasmOutput; Reg: TRegister; p1, p2: Pai);
{ allocates register Reg between (and including) instructions p1 and p2 }
{ the type of p1 and p2 must not be in SkipInstr                        }
var
  hp, start: pai;
  lastRemovedWasDealloc, firstRemovedWasAlloc, first: boolean;
Begin
  If not(reg in usableregs+[R_EDI,R_ESI]) or
     not(assigned(p1)) Then
    { this happens with registers which are loaded implicitely, outside the }
    { current block (e.g. esi with self)                                    }
    exit;
  lastRemovedWasDealloc := false;
  firstRemovedWasAlloc := false;
  first := true;
{$ifdef allocregdebug}
  hp := new(pai_asm_comment,init(strpnew('allocating '+att_reg2str[reg]+
    ' from here...')));
  insertllitem(asml,p1^.previous,p1,hp);
  hp := new(pai_asm_comment,init(strpnew('allocated '+att_reg2str[reg]+
    ' till here...')));
  insertllitem(asml,p2,p1^.next,hp);
{$endif allocregdebug}
  start := p1;
  Repeat
    If Assigned(p1^.OptInfo) Then
      Include(PPaiProp(p1^.OptInfo)^.UsedRegs,Reg);
    p1 := Pai(p1^.next);
    Repeat
      While assigned(p1) and
            (p1^.typ in (SkipInstr-[ait_regalloc])) Do
        p1 := Pai(p1^.next);
{ remove all allocation/deallocation info about the register in between }
      If assigned(p1) and
         (p1^.typ = ait_regalloc) Then
        If (PaiRegAlloc(p1)^.Reg = Reg) Then
          Begin
            if first then
              begin
                firstRemovedWasAlloc := PaiRegAlloc(p1)^.allocation;
                first := false;
              end;
            lastRemovedWasDealloc := not PaiRegAlloc(p1)^.allocation;
            hp := Pai(p1^.Next);
            AsmL^.Remove(p1);
            Dispose(p1, Done);
            p1 := hp;
          End
        Else p1 := Pai(p1^.next);
    Until not(assigned(p1)) or
          Not(p1^.typ in SkipInstr);
  Until not(assigned(p1)) or
        (p1 = p2);
  if assigned(p1) then
    begin
      if assigned(p1^.optinfo) then
        include(PPaiProp(p1^.OptInfo)^.UsedRegs,Reg);
      if lastRemovedWasDealloc then
        begin
          hp := new(paiRegalloc,dealloc(reg));
          insertLLItem(asmL,p1,p1^.next,hp);
        end;
    end;
  if firstRemovedWasAlloc then
    begin
      hp := new(paiRegalloc,alloc(reg));
      insertLLItem(asmL,start^.previous,start,hp);
    end;     
End;

function FindRegDealloc(reg: tregister; p: pai): boolean;
{ assumes reg is a 32bit register }
var
  hp: pai;
  first: boolean;
begin
  findregdealloc := false;
  first := true;
  while assigned(p^.previous) and
        ((Pai(p^.previous)^.typ in (skipinstr+[ait_align])) or
         ((Pai(p^.previous)^.typ = ait_label) and
          labelCanBeSkipped(pai_label(p^.previous)))) do
    begin
      p := pai(p^.previous);
      if (p^.typ = ait_regalloc) and
         (pairegalloc(p)^.reg = reg) then
        if not(pairegalloc(p)^.allocation) then
          if first then
            begin
              findregdealloc := true;
              break;
            end
          else
            begin
              findRegDealloc :=
                getNextInstruction(p,hp) and
                 regLoadedWithNewValue(reg,false,hp);
              break
            end
        else
          first := false;
    end
end;



Procedure IncState(Var S: Byte; amount: longint);
{Increases S by 1, wraps around at $ffff to 0 (so we won't get overflow
 errors}
Begin
  if (s <= $ff - amount) then
    inc(s, amount)
  else s := longint(s) + amount - $ff;
End;

Function sequenceDependsonReg(Const Content: TContent; seqReg, Reg: TRegister): Boolean;
{ Content is the sequence of instructions that describes the contents of   }
{ seqReg. Reg is being overwritten by the current instruction. If the      }
{ content of seqReg depends on reg (ie. because of a                       }
{ "movl (seqreg,reg), seqReg" instruction), this function returns true     }
Var p: Pai;
    Counter: Byte;
    TmpResult: Boolean;
    RegsChecked: TRegSet;
Begin
  RegsChecked := [];
  p := Content.StartMod;
  TmpResult := False;
  Counter := 1;
  While Not(TmpResult) And
        (Counter <= Content.NrOfMods) Do
    Begin
      If (p^.typ = ait_instruction) and
         ((Paicpu(p)^.opcode = A_MOV) or
          (Paicpu(p)^.opcode = A_MOVZX) or
          (Paicpu(p)^.opcode = A_MOVSX) or
          (paicpu(p)^.opcode = A_LEA)) and
         (Paicpu(p)^.oper[0].typ = top_ref) Then
        With Paicpu(p)^.oper[0].ref^ Do
          If ((Base = procinfo^.FramePointer) or
              (assigned(symbol) and (base = R_NO))) And
             (Index = R_NO) Then
            Begin
              RegsChecked := RegsChecked + [Reg32(Paicpu(p)^.oper[1].reg)];
              If Reg = Reg32(Paicpu(p)^.oper[1].reg) Then
                Break;
            End
          Else
            tmpResult :=
              regReadByInstruction(reg,p) and
              regModifiedByInstruction(seqReg,p)
      Else
        tmpResult :=
          regReadByInstruction(reg,p) and
          regModifiedByInstruction(seqReg,p);
      Inc(Counter);
      GetNextInstruction(p,p)
    End;
  sequenceDependsonReg := TmpResult
End;

procedure invalidateDependingRegs(p1: ppaiProp; reg: tregister);
var
  counter: tregister;
begin
  for counter := R_EAX to R_EDI Do
    if counter <> reg then
      with p1^.regs[counter] Do
        if (typ in [con_ref,con_noRemoveRef]) and
           sequenceDependsOnReg(p1^.Regs[counter],counter,reg) then
          if typ in [con_ref,con_invalid] then
            typ := con_invalid
          { con_invalid and con_noRemoveRef = con_unknown }
          else typ := con_unknown;
end;

Procedure DestroyReg(p1: PPaiProp; Reg: TRegister; doIncState:Boolean);
{Destroys the contents of the register Reg in the PPaiProp p1, as well as the
 contents of registers are loaded with a memory location based on Reg.
 doIncState is false when this register has to be destroyed not because
 it's contents are directly modified/overwritten, but because of an indirect
 action (e.g. this register holds the contents of a variable and the value
 of the variable in memory is changed) }
Begin
  Reg := Reg32(Reg);
  { the following happens for fpu registers }
  if (reg < low(NrOfInstrSinceLastMod)) or
     (reg > high(NrOfInstrSinceLastMod)) then
    exit;
  NrOfInstrSinceLastMod[Reg] := 0;
  if (reg >= R_EAX) and (reg <= R_EDI) then
    begin
      with p1^.regs[reg] do
        begin
          if doIncState then
            begin
              incState(wstate,1);
              typ := con_unknown;
            end
          else
            if typ in [con_ref,con_invalid] then
              typ := con_invalid
            { con_invalid and con_noRemoveRef = con_unknown }
            else typ := con_unknown;
        end;
      invalidateDependingRegs(p1,reg);
    end;
End;

{Procedure AddRegsToSet(p: Pai; Var RegSet: TRegSet);
Begin
  If (p^.typ = ait_instruction) Then
    Begin
      Case Paicpu(p)^.oper[0].typ Of
        top_reg:
          If Not(Paicpu(p)^.oper[0].reg in [R_NO,R_ESP,procinfo^.FramePointer]) Then
            RegSet := RegSet + [Paicpu(p)^.oper[0].reg];
        top_ref:
          With TReference(Paicpu(p)^.oper[0]^) Do
            Begin
              If Not(Base in [procinfo^.FramePointer,R_NO,R_ESP])
                Then RegSet := RegSet + [Base];
              If Not(Index in [procinfo^.FramePointer,R_NO,R_ESP])
                Then RegSet := RegSet + [Index];
            End;
      End;
      Case Paicpu(p)^.oper[1].typ Of
        top_reg:
          If Not(Paicpu(p)^.oper[1].reg in [R_NO,R_ESP,procinfo^.FramePointer]) Then
            If RegSet := RegSet + [TRegister(TwoWords(Paicpu(p)^.oper[1]).Word1];
        top_ref:
          With TReference(Paicpu(p)^.oper[1]^) Do
            Begin
              If Not(Base in [procinfo^.FramePointer,R_NO,R_ESP])
                Then RegSet := RegSet + [Base];
              If Not(Index in [procinfo^.FramePointer,R_NO,R_ESP])
                Then RegSet := RegSet + [Index];
            End;
      End;
    End;
End;}

Function OpsEquivalent(const o1, o2: toper; Var RegInfo: TRegInfo; OpAct: TopAction): Boolean;
Begin {checks whether the two ops are equivalent}
  OpsEquivalent := False;
  if o1.typ=o2.typ then
    Case o1.typ Of
      Top_Reg:
        OpsEquivalent :=RegsEquivalent(o1.reg,o2.reg, RegInfo, OpAct);
      Top_Ref:
        OpsEquivalent := RefsEquivalent(o1.ref^, o2.ref^, RegInfo, OpAct);
      Top_Const:
        OpsEquivalent := o1.val = o2.val;
      Top_None:
        OpsEquivalent := True
    End;
End;


Function OpsEqual(const o1,o2:toper): Boolean;
Begin {checks whether the two ops are equal}
  OpsEqual := False;
  if o1.typ=o2.typ then
    Case o1.typ Of
      Top_Reg :
        OpsEqual:=o1.reg=o2.reg;
      Top_Ref :
        OpsEqual := RefsEqual(o1.ref^, o2.ref^);
      Top_Const :
        OpsEqual:=o1.val=o2.val;
      Top_Symbol :
        OpsEqual:=(o1.sym=o2.sym) and (o1.symofs=o2.symofs);
      Top_None :
        OpsEqual := True
    End;
End;

Function InstructionsEquivalent(p1, p2: Pai; Var RegInfo: TRegInfo): Boolean;
{$ifdef csdebug}
var
  hp: pai;
{$endif csdebug}
Begin {checks whether two Paicpu instructions are equal}
  If Assigned(p1) And Assigned(p2) And
     (Pai(p1)^.typ = ait_instruction) And
     (Pai(p1)^.typ = ait_instruction) And
     (Paicpu(p1)^.opcode = Paicpu(p2)^.opcode) And
     (Paicpu(p1)^.oper[0].typ = Paicpu(p2)^.oper[0].typ) And
     (Paicpu(p1)^.oper[1].typ = Paicpu(p2)^.oper[1].typ) And
     (Paicpu(p1)^.oper[2].typ = Paicpu(p2)^.oper[2].typ)
    Then
 {both instructions have the same structure:
  "<operator> <operand of type1>, <operand of type 2>"}
      If ((Paicpu(p1)^.opcode = A_MOV) or
          (Paicpu(p1)^.opcode = A_MOVZX) or
          (Paicpu(p1)^.opcode = A_MOVSX)) And
         (Paicpu(p1)^.oper[0].typ = top_ref) {then .oper[1]t = top_reg} Then
        If Not(RegInRef(Paicpu(p1)^.oper[1].reg, Paicpu(p1)^.oper[0].ref^)) Then
 {the "old" instruction is a load of a register with a new value, not with
  a value based on the contents of this register (so no "mov (reg), reg")}
          If Not(RegInRef(Paicpu(p2)^.oper[1].reg, Paicpu(p2)^.oper[0].ref^)) And
             RefsEqual(Paicpu(p1)^.oper[0].ref^, Paicpu(p2)^.oper[0].ref^)
            Then
 {the "new" instruction is also a load of a register with a new value, and
  this value is fetched from the same memory location}
              Begin
                With Paicpu(p2)^.oper[0].ref^ Do
                  Begin
                    If Not(Base in [procinfo^.FramePointer, R_NO, R_ESP]) Then
                      RegInfo.RegsLoadedForRef := RegInfo.RegsLoadedForRef + [Base];
                    If Not(Index in [procinfo^.FramePointer, R_NO, R_ESP]) Then
                      RegInfo.RegsLoadedForRef := RegInfo.RegsLoadedForRef + [Index];
                  End;
 {add the registers from the reference (.oper[0]) to the RegInfo, all registers
  from the reference are the same in the old and in the new instruction
  sequence}
                AddOp2RegInfo(Paicpu(p1)^.oper[0], RegInfo);
 {the registers from .oper[1] have to be equivalent, but not necessarily equal}
                InstructionsEquivalent :=
                  RegsEquivalent(Paicpu(p1)^.oper[1].reg, Paicpu(p2)^.oper[1].reg, RegInfo, OpAct_Write);
              End
 {the registers are loaded with values from different memory locations. If
  this was allowed, the instructions "mov -4(esi),eax" and "mov -4(ebp),eax"
  would be considered equivalent}
            Else InstructionsEquivalent := False
        Else
 {load register with a value based on the current value of this register}
          Begin
            With Paicpu(p2)^.oper[0].ref^ Do
              Begin
                If Not(Base in [procinfo^.FramePointer,
                     Reg32(Paicpu(p2)^.oper[1].reg),R_NO,R_ESP]) Then
 {it won't do any harm if the register is already in RegsLoadedForRef}
                  Begin
                    RegInfo.RegsLoadedForRef := RegInfo.RegsLoadedForRef + [Base];
{$ifdef csdebug}
                    Writeln(att_reg2str[base], ' added');
{$endif csdebug}
                  end;
                If Not(Index in [procinfo^.FramePointer,
                     Reg32(Paicpu(p2)^.oper[1].reg),R_NO,R_ESP]) Then
                  Begin
                    RegInfo.RegsLoadedForRef := RegInfo.RegsLoadedForRef + [Index];
{$ifdef csdebug}
                    Writeln(att_reg2str[index], ' added');
{$endif csdebug}
                  end;

              End;
            If Not(Reg32(Paicpu(p2)^.oper[1].reg) In [procinfo^.FramePointer,R_NO,R_ESP])
              Then
                Begin
                  RegInfo.RegsLoadedForRef := RegInfo.RegsLoadedForRef -
                                                 [Reg32(Paicpu(p2)^.oper[1].reg)];
{$ifdef csdebug}
                  Writeln(att_reg2str[Reg32(Paicpu(p2)^.oper[1].reg)], ' removed');
{$endif csdebug}
                end;
            InstructionsEquivalent :=
               OpsEquivalent(Paicpu(p1)^.oper[0], Paicpu(p2)^.oper[0], RegInfo, OpAct_Read) And
               OpsEquivalent(Paicpu(p1)^.oper[1], Paicpu(p2)^.oper[1], RegInfo, OpAct_Write)
          End
      Else
 {an instruction <> mov, movzx, movsx}
       begin
  {$ifdef csdebug}
         hp := new(pai_asm_comment,init(strpnew('checking if equivalent')));
         hp^.previous := p2;
         hp^.next := p2^.next;
         p2^.next^.previous := hp;
         p2^.next := hp;
  {$endif csdebug}
         InstructionsEquivalent :=
           OpsEquivalent(Paicpu(p1)^.oper[0], Paicpu(p2)^.oper[0], RegInfo, OpAct_Unknown) And
           OpsEquivalent(Paicpu(p1)^.oper[1], Paicpu(p2)^.oper[1], RegInfo, OpAct_Unknown) And
           OpsEquivalent(Paicpu(p1)^.oper[2], Paicpu(p2)^.oper[2], RegInfo, OpAct_Unknown)
       end
 {the instructions haven't even got the same structure, so they're certainly
  not equivalent}
    Else
      begin
  {$ifdef csdebug}
        hp := new(pai_asm_comment,init(strpnew('different opcodes/format')));
        hp^.previous := p2;
        hp^.next := p2^.next;
        p2^.next^.previous := hp;
        p2^.next := hp;
  {$endif csdebug}
        InstructionsEquivalent := False;
      end;
  {$ifdef csdebug}
    hp := new(pai_asm_comment,init(strpnew('instreq: '+tostr(byte(instructionsequivalent)))));
    hp^.previous := p2;
    hp^.next := p2^.next;
    p2^.next^.previous := hp;
    p2^.next := hp;
  {$endif csdebug}
End;

(*
Function InstructionsEqual(p1, p2: Pai): Boolean;
Begin {checks whether two Paicpu instructions are equal}
  InstructionsEqual :=
    Assigned(p1) And Assigned(p2) And
    ((Pai(p1)^.typ = ait_instruction) And
     (Pai(p1)^.typ = ait_instruction) And
     (Paicpu(p1)^.opcode = Paicpu(p2)^.opcode) And
     (Paicpu(p1)^.oper[0].typ = Paicpu(p2)^.oper[0].typ) And
     (Paicpu(p1)^.oper[1].typ = Paicpu(p2)^.oper[1].typ) And
     OpsEqual(Paicpu(p1)^.oper[0].typ, Paicpu(p1)^.oper[0], Paicpu(p2)^.oper[0]) And
     OpsEqual(Paicpu(p1)^.oper[1].typ, Paicpu(p1)^.oper[1], Paicpu(p2)^.oper[1]))
End;
*)

Procedure ReadReg(p: PPaiProp; Reg: TRegister);
Begin
  Reg := Reg32(Reg);
  If Reg in [R_EAX..R_EDI] Then
    incState(p^.regs[Reg].rstate,1)
End;


Procedure ReadRef(p: PPaiProp; Ref: PReference);
Begin
  If Ref^.Base <> R_NO Then
    ReadReg(p, Ref^.Base);
  If Ref^.Index <> R_NO Then
    ReadReg(p, Ref^.Index);
End;

Procedure ReadOp(P: PPaiProp;const o:toper);
Begin
  Case o.typ Of
    top_reg: ReadReg(P, o.reg);
    top_ref: ReadRef(P, o.ref);
    top_symbol : ;
  End;
End;


Function RefInInstruction(Const Ref: TReference; p: Pai;
           RefsEq: TRefCompare): Boolean;
{checks whehter Ref is used in P}
Var TmpResult: Boolean;
Begin
  TmpResult := False;
  If (p^.typ = ait_instruction) Then
    Begin
      If (Paicpu(p)^.oper[0].typ = Top_Ref) Then
        TmpResult := RefsEq(Ref, Paicpu(p)^.oper[0].ref^);
      If Not(TmpResult) And (Paicpu(p)^.oper[1].typ = Top_Ref) Then
        TmpResult := RefsEq(Ref, Paicpu(p)^.oper[1].ref^);
      If Not(TmpResult) And (Paicpu(p)^.oper[2].typ = Top_Ref) Then
        TmpResult := RefsEq(Ref, Paicpu(p)^.oper[2].ref^);
    End;
  RefInInstruction := TmpResult;
End;

Function RefInSequence(Const Ref: TReference; Content: TContent;
           RefsEq: TRefCompare): Boolean;
{checks the whole sequence of Content (so StartMod and and the next NrOfMods
 Pai objects) to see whether Ref is used somewhere}
Var p: Pai;
    Counter: Byte;
    TmpResult: Boolean;
Begin
  p := Content.StartMod;
  TmpResult := False;
  Counter := 1;
  While Not(TmpResult) And
        (Counter <= Content.NrOfMods) Do
    Begin
      If (p^.typ = ait_instruction) And
         RefInInstruction(Ref, p, RefsEq)
        Then TmpResult := True;
      Inc(Counter);
      GetNextInstruction(p,p)
    End;
  RefInSequence := TmpResult
End;

Function ArrayRefsEq(const r1, r2: TReference): Boolean;
Begin
  ArrayRefsEq := (R1.Offset+R1.OffsetFixup = R2.Offset+R2.OffsetFixup) And
                 (R1.Segment = R2.Segment) And
                 (R1.Symbol=R2.Symbol) And
                 (R1.Base = R2.Base)
End;

function isSimpleRef(const ref: treference): boolean;
{ returns true if ref is reference to a local or global variable, to a  }
{ parameter or to an object field (this includes arrays). Returns false }
{ otherwise.                                                            }
begin
  isSimpleRef :=
    assigned(ref.symbol) or
    (ref.base = procinfo^.framepointer) or
    (assigned(procinfo^._class) and
     (ref.base = R_ESI));
end;

function containsPointerRef(p: pai): boolean;
{ checks if an instruction contains a reference which is a pointer location }
var
  hp: paicpu;
  count: longint;
begin
  containsPointerRef := false;
  if p^.typ <> ait_instruction then
    exit;
  hp := paicpu(p);
  for count := low(hp^.oper) to high(hp^.oper) do
    begin
      case hp^.oper[count].typ of
        top_ref:
          if not isSimpleRef(hp^.oper[count].ref^) then
            begin
              containsPointerRef := true;
              exit;
            end;
        top_none:
          exit;
      end;
    end;
end;


function containsPointerLoad(c: tcontent): boolean;
{ checks whether the contents of a register contain a pointer reference }
var
  p: pai;
  count: longint;
begin
  containsPointerLoad := false;
  p := c.startmod;
  for count := c.nrOfMods downto 1 do
    begin
      if containsPointerRef(p) then
        begin
          containsPointerLoad := true;
          exit;
        end;
      getnextinstruction(p,p);
    end;
end;

function writeToMemDestroysContents(regWritten: tregister; const ref: treference;
  reg: tregister; const c: tcontent): boolean;
{ returns whether the contents c of reg are invalid after regWritten is }
{ is written to ref                                                     }
var
  refsEq: trefCompare;
begin
  if not(c.typ in [con_ref,con_noRemoveRef,con_invalid]) then
    begin
      writeToMemDestroysContents := false;
      exit;
    end;
  reg := reg32(reg);
  regWritten := reg32(regWritten);
  if isSimpleRef(ref) then
    begin
      if (ref.index <> R_NO) or
         (assigned(ref.symbol) and
          (ref.base <> R_NO)) then
        { local/global variable or parameter which is an array }
        refsEq := {$ifdef fpc}@{$endif}arrayRefsEq
      else
        { local/global variable or parameter which is not an array }
        refsEq := {$ifdef fpc}@{$endif}refsEqual;

     { write something to a parameter, a local or global variable, so          }
     {  * with uncertain optimizations on:                                     }
     {    - destroy the contents of registers whose contents have somewhere a  }
     {      "mov?? (Ref), %reg". WhichReg (this is the register whose contents }
     {      are being written to memory) is not destroyed if it's StartMod is  }
     {      of that form and NrOfMods = 1 (so if it holds ref, but is not a    }
     {      expression based on Ref)                                           }
     {  * with uncertain optimizations off:                                    }
     {    - also destroy registers that contain any pointer                    }
      with c do
        writeToMemDestroysContents :=
          (typ in [con_ref,con_noRemoveRef]) and
          ((not(cs_uncertainOpts in aktglobalswitches) and
            containsPointerLoad(c)
           ) or
           (refInSequence(ref,c,refsEq) and
            ((reg <> regWritten) or
             ((nrOfMods <> 1) and
              {StarMod is always of the type ait_instruction}
              (paicpu(StartMod)^.oper[0].typ = top_ref) and
              refsEq(Paicpu(StartMod)^.oper[0].ref^, ref)
             )
            )
           )
          )
    end
  else
    { write something to a pointer location, so                               }
    {   * with uncertain optimzations on:                                     }
    {     - do not destroy registers which contain a local/global variable or }
    {       a parameter, except if DestroyRefs is called because of a "movsl" }
    {   * with uncertain optimzations off:                                    }
    {     - destroy every register which contains a memory location           }
    with c do
      writeToMemDestroysContents :=
        (typ in [con_ref,con_noRemoveRef]) and
        (not(cs_UncertainOpts in aktglobalswitches) or
       { for movsl }
         ((ref.base = R_EDI) and (ref.index = R_EDI)) or
       { don't destroy if reg contains a parameter, local or global variable }
         containsPointerLoad(c)
        )
end;

function writeToRegDestroysContents(destReg: tregister; reg: tregister;
  const c: tcontent): boolean;
{ returns whether the contents c of reg are invalid after destReg is }
{ modified                                                           }
begin
  writeToRegDestroysContents :=
    (c.typ in [con_ref,con_noRemoveRef,con_invalid]) and
    sequenceDependsOnReg(c,reg,reg32(destReg));
end;

function writeDestroysContents(const op: toper; reg: tregister;
  const c: tcontent): boolean;
{ returns whether the contents c of reg are invalid after regWritten is }
{ is written to op                                                      }
begin
  reg := reg32(reg);
  case op.typ of
    top_reg:
      writeDestroysContents :=
        writeToRegDestroysContents(op.reg,reg,c);
    top_ref:
      writeDestroysContents :=
        writeToMemDestroysContents(R_NO,op.ref^,reg,c);
  else
    writeDestroysContents := false;
  end;
end;

procedure destroyRefs(p: pai; const ref: treference; regWritten: tregister);
{ destroys all registers which possibly contain a reference to Ref, regWritten }
{ is the register whose contents are being written to memory (if this proc     }
{ is called because of a "mov?? %reg, (mem)" instruction)                      }
var
  counter: TRegister;
begin
  for counter := R_EAX to R_EDI Do
    if writeToMemDestroysContents(regWritten,ref,counter,
         ppaiProp(p^.optInfo)^.regs[counter]) then
      destroyReg(ppaiProp(p^.optInfo), counter, false)
End;

Procedure DestroyAllRegs(p: PPaiProp);
Var Counter: TRegister;
Begin {initializes/desrtoys all registers}
  For Counter := R_EAX To R_EDI Do
    Begin
      ReadReg(p, Counter);
      DestroyReg(p, Counter, true);
    End;
  p^.DirFlag := F_Unknown;
End;

Procedure DestroyOp(PaiObj: Pai; const o:Toper);
{$ifdef statedebug}
var hp: pai;
{$endif statedebug}

Begin
  Case o.typ Of
    top_reg:
      begin
{$ifdef statedebug}
        hp := new(pai_asm_comment,init(strpnew('destroying '+att_reg2str[o.reg])));
        hp^.next := paiobj^.next;
        hp^.previous := paiobj;
        paiobj^.next := hp;
        if assigned(hp^.next) then
          hp^.next^.previous := hp;
{$endif statedebug}
        DestroyReg(PPaiProp(PaiObj^.OptInfo), reg32(o.reg), true);
      end;
    top_ref:
      Begin
        ReadRef(PPaiProp(PaiObj^.OptInfo), o.ref);
        DestroyRefs(PaiObj, o.ref^, R_NO);
      End;
    top_symbol:;
  End;
End;

Function DFAPass1(AsmL: PAasmOutput; BlockStart: Pai): Pai;
{gathers the RegAlloc data... still need to think about where to store it to
 avoid global vars}
Var BlockEnd: Pai;
Begin
  BlockEnd := FindLoHiLabels(LoLab, HiLab, LabDif, BlockStart);
  BuildLabelTableAndFixRegAlloc(AsmL, LTable, LoLab, LabDif, BlockStart, BlockEnd);
  DFAPass1 := BlockEnd;
End;

Procedure AddInstr2RegContents({$ifdef statedebug} asml: paasmoutput; {$endif}
p: paicpu; reg: TRegister);
{$ifdef statedebug}
var hp: pai;
{$endif statedebug}
Begin
  Reg := Reg32(Reg);
  With PPaiProp(p^.optinfo)^.Regs[reg] Do
    if (typ in [con_ref,con_noRemoveRef])
      Then
        Begin
          incState(wstate,1);
 {also store how many instructions are part of the sequence in the first
  instructions PPaiProp, so it can be easily accessed from within
  CheckSequence}
          Inc(NrOfMods, NrOfInstrSinceLastMod[Reg]);
          PPaiProp(Pai(StartMod)^.OptInfo)^.Regs[Reg].NrOfMods := NrOfMods;
          NrOfInstrSinceLastMod[Reg] := 0;
{$ifdef StateDebug}
          hp := new(pai_asm_comment,init(strpnew(att_reg2str[reg]+': '+tostr(PPaiProp(p^.optinfo)^.Regs[reg].WState)
                + ' -- ' + tostr(PPaiProp(p^.optinfo)^.Regs[reg].nrofmods))));
          InsertLLItem(AsmL, p, p^.next, hp);
{$endif StateDebug}
        End
      Else
        Begin
{$ifdef statedebug}
          hp := new(pai_asm_comment,init(strpnew('destroying '+att_reg2str[reg])));
          insertllitem(asml,p,p^.next,hp);
{$endif statedebug}
          DestroyReg(PPaiProp(p^.optinfo), Reg, true);
{$ifdef StateDebug}
          hp := new(pai_asm_comment,init(strpnew(att_reg2str[reg]+': '+tostr(PPaiProp(p^.optinfo)^.Regs[reg].WState))));
          InsertLLItem(AsmL, p, p^.next, hp);
{$endif StateDebug}
        End
End;

Procedure AddInstr2OpContents({$ifdef statedebug} asml: paasmoutput; {$endif}
p: paicpu; const oper: TOper);
Begin
  If oper.typ = top_reg Then
    AddInstr2RegContents({$ifdef statedebug} asml, {$endif}p, oper.reg)
  Else
    Begin
      ReadOp(PPaiProp(p^.optinfo), oper);
      DestroyOp(p, oper);
    End
End;

Procedure DoDFAPass2(
{$Ifdef StateDebug}
AsmL: PAasmOutput;
{$endif statedebug}
BlockStart, BlockEnd: Pai);
{Analyzes the Data Flow of an assembler list. Starts creating the reg
 contents for the instructions starting with p. Returns the last pai which has
 been processed}
Var
    CurProp: PPaiProp;
    Cnt, InstrCnt : Longint;
    InstrProp: TInsProp;
    UsedRegs: TRegSet;
    p, hp : Pai;
    TmpRef: TReference;
    TmpReg: TRegister;
{$ifdef AnalyzeLoops}
    TmpState: Byte;
{$endif AnalyzeLoops}
Begin
  p := BlockStart;
  UsedRegs := [];
  UpdateUsedregs(UsedRegs, p);
  SkipHead(P);
  BlockStart := p;
  InstrCnt := 1;
  FillChar(NrOfInstrSinceLastMod, SizeOf(NrOfInstrSinceLastMod), 0);
  While (P <> BlockEnd) Do
    Begin
      CurProp := @PaiPropBlock^[InstrCnt];
      If (p <> BlockStart)
        Then
          Begin
{$ifdef JumpAnal}
            If (p^.Typ <> ait_label) Then
{$endif JumpAnal}
              Begin
                GetLastInstruction(p, hp);
                CurProp^.Regs := PPaiProp(hp^.OptInfo)^.Regs;
                CurProp^.DirFlag := PPaiProp(hp^.OptInfo)^.DirFlag;
              End
          End
        Else
          Begin
            FillChar(CurProp^, SizeOf(CurProp^), 0);
{            For TmpReg := R_EAX to R_EDI Do
              CurProp^.Regs[TmpReg].WState := 1;}
          End;
      CurProp^.UsedRegs := UsedRegs;
      CurProp^.CanBeRemoved := False;
      UpdateUsedRegs(UsedRegs, Pai(p^.Next));
      For TmpReg := R_EAX To R_EDI Do
        Inc(NrOfInstrSinceLastMod[TmpReg]);
      Case p^.typ Of
        ait_marker:;
        ait_label:
{$Ifndef JumpAnal}
          If not labelCanBeSkipped(pai_label(p)) Then
            DestroyAllRegs(CurProp);
{$Else JumpAnal}
          Begin
           If not labelCanBeSkipped(pai_label(p)) Then
             With LTable^[Pai_Label(p)^.l^.labelnr-LoLab] Do
{$IfDef AnalyzeLoops}
              If (RefsFound = Pai_Label(p)^.l^.RefCount)
{$Else AnalyzeLoops}
              If (JmpsProcessed = Pai_Label(p)^.l^.RefCount)
{$EndIf AnalyzeLoops}
                Then
{all jumps to this label have been found}
{$IfDef AnalyzeLoops}
                  If (JmpsProcessed > 0)
                    Then
{$EndIf AnalyzeLoops}
 {we've processed at least one jump to this label}
                      Begin
                        If (GetLastInstruction(p, hp) And
                           Not(((hp^.typ = ait_instruction)) And
                                (paicpu_labeled(hp)^.is_jmp))
                          Then
  {previous instruction not a JMP -> the contents of the registers after the
   previous intruction has been executed have to be taken into account as well}
                            For TmpReg := R_EAX to R_EDI Do
                              Begin
                                If (CurProp^.Regs[TmpReg].WState <>
                                    PPaiProp(hp^.OptInfo)^.Regs[TmpReg].WState)
                                  Then DestroyReg(CurProp, TmpReg, true)
                              End
                      End
{$IfDef AnalyzeLoops}
                    Else
 {a label from a backward jump (e.g. a loop), no jump to this label has
  already been processed}
                      If GetLastInstruction(p, hp) And
                         Not(hp^.typ = ait_instruction) And
                            (paicpu_labeled(hp)^.opcode = A_JMP))
                        Then
  {previous instruction not a jmp, so keep all the registers' contents from the
   previous instruction}
                          Begin
                            CurProp^.Regs := PPaiProp(hp^.OptInfo)^.Regs;
                            CurProp^.DirFlag := PPaiProp(hp^.OptInfo)^.DirFlag;
                          End
                        Else
  {previous instruction a jmp and no jump to this label processed yet}
                          Begin
                            hp := p;
                            Cnt := InstrCnt;
     {continue until we find a jump to the label or a label which has already
      been processed}
                            While GetNextInstruction(hp, hp) And
                                  Not((hp^.typ = ait_instruction) And
                                      (paicpu(hp)^.is_jmp) and
                                      (pasmlabel(paicpu(hp)^.oper[0].sym)^.labelnr = Pai_Label(p)^.l^.labelnr)) And
                                  Not((hp^.typ = ait_label) And
                                      (LTable^[Pai_Label(hp)^.l^.labelnr-LoLab].RefsFound
                                       = Pai_Label(hp)^.l^.RefCount) And
                                      (LTable^[Pai_Label(hp)^.l^.labelnr-LoLab].JmpsProcessed > 0)) Do
                              Inc(Cnt);
                            If (hp^.typ = ait_label)
                              Then
   {there's a processed label after the current one}
                                Begin
                                  CurProp^.Regs := PaiPropBlock^[Cnt].Regs;
                                  CurProp^.DirFlag := PaiPropBlock^[Cnt].DirFlag;
                                End
                              Else
   {there's no label anymore after the current one, or they haven't been
    processed yet}
                                Begin
                                  GetLastInstruction(p, hp);
                                  CurProp^.Regs := PPaiProp(hp^.OptInfo)^.Regs;
                                  CurProp^.DirFlag := PPaiProp(hp^.OptInfo)^.DirFlag;
                                  DestroyAllRegs(PPaiProp(hp^.OptInfo))
                                End
                          End
{$EndIf AnalyzeLoops}
                Else
{not all references to this label have been found, so destroy all registers}
                  Begin
                    GetLastInstruction(p, hp);
                    CurProp^.Regs := PPaiProp(hp^.OptInfo)^.Regs;
                    CurProp^.DirFlag := PPaiProp(hp^.OptInfo)^.DirFlag;
                    DestroyAllRegs(CurProp)
                  End;
          End;
{$EndIf JumpAnal}

{$ifdef GDB}
        ait_stabs, ait_stabn, ait_stab_function_name:;
{$endif GDB}
        ait_align: ; { may destroy flags !!! }
        ait_instruction:
          Begin
            if paicpu(p)^.is_jmp then
             begin
{$IfNDef JumpAnal}
                for tmpReg := R_EAX to R_EDI do
                  with curProp^.regs[tmpReg] do
                    case typ of
                      con_ref: typ := con_noRemoveRef;
                      con_const: typ := con_noRemoveConst;
                      con_invalid: typ := con_unknown;
                    end;
{$Else JumpAnal}
          With LTable^[pasmlabel(paicpu(p)^.oper[0].sym)^.labelnr-LoLab] Do
            If (RefsFound = pasmlabel(paicpu(p)^.oper[0].sym)^.RefCount) Then
              Begin
                If (InstrCnt < InstrNr)
                  Then
                {forward jump}
                    If (JmpsProcessed = 0) Then
                {no jump to this label has been processed yet}
                      Begin
                        PaiPropBlock^[InstrNr].Regs := CurProp^.Regs;
                        PaiPropBlock^[InstrNr].DirFlag := CurProp^.DirFlag;
                        Inc(JmpsProcessed);
                      End
                    Else
                      Begin
                        For TmpReg := R_EAX to R_EDI Do
                          If (PaiPropBlock^[InstrNr].Regs[TmpReg].WState <>
                             CurProp^.Regs[TmpReg].WState) Then
                            DestroyReg(@PaiPropBlock^[InstrNr], TmpReg, true);
                        Inc(JmpsProcessed);
                      End
{$ifdef AnalyzeLoops}
                  Else
{                backward jump, a loop for example}
{                    If (JmpsProcessed > 0) Or
                       Not(GetLastInstruction(PaiObj, hp) And
                           (hp^.typ = ait_labeled_instruction) And
                           (paicpu_labeled(hp)^.opcode = A_JMP))
                      Then}
{instruction prior to label is not a jmp, or at least one jump to the label
 has yet been processed}
                        Begin
                          Inc(JmpsProcessed);
                          For TmpReg := R_EAX to R_EDI Do
                            If (PaiPropBlock^[InstrNr].Regs[TmpReg].WState <>
                                CurProp^.Regs[TmpReg].WState)
                              Then
                                Begin
                                  TmpState := PaiPropBlock^[InstrNr].Regs[TmpReg].WState;
                                  Cnt := InstrNr;
                                  While (TmpState = PaiPropBlock^[Cnt].Regs[TmpReg].WState) Do
                                    Begin
                                      DestroyReg(@PaiPropBlock^[Cnt], TmpReg, true);
                                      Inc(Cnt);
                                    End;
                                  While (Cnt <= InstrCnt) Do
                                    Begin
                                      Inc(PaiPropBlock^[Cnt].Regs[TmpReg].WState);
                                      Inc(Cnt)
                                    End
                                End;
                        End
{                      Else }
{instruction prior to label is a jmp and no jumps to the label have yet been
 processed}
{                        Begin
                          Inc(JmpsProcessed);
                          For TmpReg := R_EAX to R_EDI Do
                            Begin
                              TmpState := PaiPropBlock^[InstrNr].Regs[TmpReg].WState;
                              Cnt := InstrNr;
                              While (TmpState = PaiPropBlock^[Cnt].Regs[TmpReg].WState) Do
                                Begin
                                  PaiPropBlock^[Cnt].Regs[TmpReg] := CurProp^.Regs[TmpReg];
                                  Inc(Cnt);
                                End;
                              TmpState := PaiPropBlock^[InstrNr].Regs[TmpReg].WState;
                              While (TmpState = PaiPropBlock^[Cnt].Regs[TmpReg].WState) Do
                                Begin
                                  DestroyReg(@PaiPropBlock^[Cnt], TmpReg, true);
                                  Inc(Cnt);
                                End;
                              While (Cnt <= InstrCnt) Do
                                Begin
                                  Inc(PaiPropBlock^[Cnt].Regs[TmpReg].WState);
                                  Inc(Cnt)
                                End
                            End
                        End}
{$endif AnalyzeLoops}
          End;
{$EndIf JumpAnal}
          end
          else
           begin
            InstrProp := InsProp[Paicpu(p)^.opcode];
            Case Paicpu(p)^.opcode Of
              A_MOV, A_MOVZX, A_MOVSX:
                Begin
                  Case Paicpu(p)^.oper[0].typ Of
                    top_ref, top_reg:
                      case paicpu(p)^.oper[1].typ Of
                        top_reg:
                          Begin
{$ifdef statedebug}
                            hp := new(pai_asm_comment,init(strpnew('destroying '+
                              att_reg2str[Paicpu(p)^.oper[1].reg])));
                            insertllitem(asml,p,p^.next,hp);
{$endif statedebug}

                            readOp(curprop, paicpu(p)^.oper[0]);
                            tmpreg := reg32(paicpu(p)^.oper[1].reg);
                            if regInOp(tmpreg, paicpu(p)^.oper[0]) and
                               (curProp^.regs[tmpReg].typ in [con_ref,con_noRemoveRef]) then
                              begin
                                with curprop^.regs[tmpreg] Do
                                  begin
                                    incState(wstate,1);
 { also store how many instructions are part of the sequence in the first }
 { instruction's PPaiProp, so it can be easily accessed from within       }
 { CheckSequence                                                          }
                                    inc(nrOfMods, nrOfInstrSinceLastMod[tmpreg]);
                                    ppaiprop(startmod^.optinfo)^.regs[tmpreg].nrOfMods := nrOfMods;
                                    nrOfInstrSinceLastMod[tmpreg] := 0;
                                   { Destroy the contents of the registers  }
                                   { that depended on the previous value of }
                                   { this register                          }
                                    invalidateDependingRegs(curprop,tmpreg);
                                end;
                            end
                          else
                            begin
{$ifdef statedebug}
                              hp := new(pai_asm_comment,init(strpnew('destroying & initing '+att_reg2str[tmpreg])));
                              insertllitem(asml,p,p^.next,hp);
{$endif statedebug}
                              destroyReg(curprop, tmpreg, true);
                              if not(reginop(tmpreg, paicpu(p)^.oper[0])) then
                                with curprop^.regs[tmpreg] Do
                                  begin
                                    typ := con_ref;
                                    startmod := p;
                                    nrOfMods := 1;
                                  end
                            end;
{$ifdef StateDebug}
                  hp := new(pai_asm_comment,init(strpnew(att_reg2str[TmpReg]+': '+tostr(CurProp^.Regs[TmpReg].WState))));
                  InsertLLItem(AsmL, p, p^.next, hp);
{$endif StateDebug}
                          End;
                        Top_Ref:
                          { can only be if oper[0] = top_reg }
                          Begin
                            ReadReg(CurProp, Paicpu(p)^.oper[0].reg);
                            ReadRef(CurProp, Paicpu(p)^.oper[1].ref);
                            DestroyRefs(p, Paicpu(p)^.oper[1].ref^, Paicpu(p)^.oper[0].reg);
                          End;
                      End;
                    top_symbol,Top_Const:
                      Begin
                        Case Paicpu(p)^.oper[1].typ Of
                          Top_Reg:
                            Begin
                              TmpReg := Reg32(Paicpu(p)^.oper[1].reg);
{$ifdef statedebug}
          hp := new(pai_asm_comment,init(strpnew('destroying '+att_reg2str[tmpreg])));
          insertllitem(asml,p,p^.next,hp);
{$endif statedebug}
                              With CurProp^.Regs[TmpReg] Do
                                Begin
                                  DestroyReg(CurProp, TmpReg, true);
                                  typ := Con_Const;
                                  StartMod := p;
                                End
                            End;
                          Top_Ref:
                            Begin
                              ReadRef(CurProp, Paicpu(p)^.oper[1].ref);
                              DestroyRefs(P, Paicpu(p)^.oper[1].ref^, R_NO);
                            End;
                        End;
                      End;
                  End;
                End;
              A_DIV, A_IDIV, A_MUL:
                Begin
                  ReadOp(Curprop, Paicpu(p)^.oper[0]);
                  ReadReg(CurProp,R_EAX);
                  If (Paicpu(p)^.OpCode = A_IDIV) or
                     (Paicpu(p)^.OpCode = A_DIV) Then
                    ReadReg(CurProp,R_EDX);
{$ifdef statedebug}
                  hp := new(pai_asm_comment,init(strpnew('destroying eax and edx')));
                  insertllitem(asml,p,p^.next,hp);
{$endif statedebug}
{                  DestroyReg(CurProp, R_EAX, true);}
                  AddInstr2RegContents({$ifdef statedebug}asml,{$endif}
                    paicpu(p), R_EAX);
                  DestroyReg(CurProp, R_EDX, true)
                End;
              A_IMUL:
                Begin
                  ReadOp(CurProp,Paicpu(p)^.oper[0]);
                  ReadOp(CurProp,Paicpu(p)^.oper[1]);
                  If (Paicpu(p)^.oper[2].typ = top_none) Then
                    If (Paicpu(p)^.oper[1].typ = top_none) Then
                      Begin
                        ReadReg(CurProp,R_EAX);
{$ifdef statedebug}
                        hp := new(pai_asm_comment,init(strpnew('destroying eax and edx')));
                        insertllitem(asml,p,p^.next,hp);
{$endif statedebug}
{                        DestroyReg(CurProp, R_EAX, true); }
                        AddInstr2RegContents({$ifdef statedebug}asml,{$endif}
                          paicpu(p), R_EAX);
                        DestroyReg(CurProp, R_EDX, true)
                      End
                    Else
                      AddInstr2OpContents(
                        {$ifdef statedebug}asml,{$endif}
                          Paicpu(p), Paicpu(p)^.oper[1])
                  Else
                    AddInstr2OpContents({$ifdef statedebug}asml,{$endif}
                      Paicpu(p), Paicpu(p)^.oper[2]);
                End;
              A_LEA:
                begin
                  readop(curprop,paicpu(p)^.oper[0]);
                  if reginref(paicpu(p)^.oper[1].reg,paicpu(p)^.oper[0].ref^) then
                    AddInstr2RegContents({$ifdef statedebug}asml,{$endif}
                      paicpu(p), paicpu(p)^.oper[1].reg)
                  else
                    begin
{$ifdef statedebug}
                      hp := new(pai_asm_comment,init(strpnew('destroying '+
                        att_reg2str[paicpu(p)^.oper[1].reg])));
                      insertllitem(asml,p,p^.next,hp);
{$endif statedebug}
                      destroyreg(curprop,paicpu(p)^.oper[1].reg,true);
                    end;
                end;
              Else
                Begin
                  Cnt := 1;
                  While (Cnt <= MaxCh) And
                        (InstrProp.Ch[Cnt] <> Ch_None) Do
                    Begin
                      Case InstrProp.Ch[Cnt] Of
                        Ch_REAX..Ch_REDI: ReadReg(CurProp,TCh2Reg(InstrProp.Ch[Cnt]));
                        Ch_WEAX..Ch_RWEDI:
                          Begin
                            If (InstrProp.Ch[Cnt] >= Ch_RWEAX) Then
                              ReadReg(CurProp, TCh2Reg(InstrProp.Ch[Cnt]));
{$ifdef statedebug}
                            hp := new(pai_asm_comment,init(strpnew('destroying '+
                              att_reg2str[TCh2Reg(InstrProp.Ch[Cnt])])));
                            insertllitem(asml,p,p^.next,hp);
{$endif statedebug}
                            DestroyReg(CurProp, TCh2Reg(InstrProp.Ch[Cnt]), true);
                          End;
                        Ch_MEAX..Ch_MEDI:
                          AddInstr2RegContents({$ifdef statedebug} asml,{$endif}
                                               Paicpu(p),TCh2Reg(InstrProp.Ch[Cnt]));
                        Ch_CDirFlag: CurProp^.DirFlag := F_NotSet;
                        Ch_SDirFlag: CurProp^.DirFlag := F_Set;
                        Ch_Rop1: ReadOp(CurProp, Paicpu(p)^.oper[0]);
                        Ch_Rop2: ReadOp(CurProp, Paicpu(p)^.oper[1]);
                        Ch_ROp3: ReadOp(CurProp, Paicpu(p)^.oper[2]);
                        Ch_Wop1..Ch_RWop1:
                          Begin
                            If (InstrProp.Ch[Cnt] in [Ch_RWop1]) Then
                              ReadOp(CurProp, Paicpu(p)^.oper[0]);
                            DestroyOp(p, Paicpu(p)^.oper[0]);
                          End;
                        Ch_Mop1:
                          AddInstr2OpContents({$ifdef statedebug} asml, {$endif}
                          Paicpu(p), Paicpu(p)^.oper[0]);
                        Ch_Wop2..Ch_RWop2:
                          Begin
                            If (InstrProp.Ch[Cnt] = Ch_RWop2) Then
                              ReadOp(CurProp, Paicpu(p)^.oper[1]);
                            DestroyOp(p, Paicpu(p)^.oper[1]);
                          End;
                        Ch_Mop2:
                          AddInstr2OpContents({$ifdef statedebug} asml, {$endif}
                          Paicpu(p), Paicpu(p)^.oper[1]);
                        Ch_WOp3..Ch_RWOp3:
                          Begin
                            If (InstrProp.Ch[Cnt] = Ch_RWOp3) Then
                              ReadOp(CurProp, Paicpu(p)^.oper[2]);
                            DestroyOp(p, Paicpu(p)^.oper[2]);
                          End;
                        Ch_Mop3:
                          AddInstr2OpContents({$ifdef statedebug} asml, {$endif}
                          Paicpu(p), Paicpu(p)^.oper[2]);
                        Ch_WMemEDI:
                          Begin
                            ReadReg(CurProp, R_EDI);
                            FillChar(TmpRef, SizeOf(TmpRef), 0);
                            TmpRef.Base := R_EDI;
                            tmpRef.index := R_EDI;
                            DestroyRefs(p, TmpRef, R_NO)
                          End;
                        Ch_RFlags, Ch_WFlags, Ch_RWFlags, Ch_FPU:
                        Else
                          Begin
{$ifdef statedebug}
                            hp := new(pai_asm_comment,init(strpnew(
                              'destroying all regs for prev instruction')));
                            insertllitem(asml,p, p^.next,hp);
{$endif statedebug}
                            DestroyAllRegs(CurProp);
                          End;
                      End;
                      Inc(Cnt);
                    End
                End;
              end;
            End;
          End
        Else
          Begin
{$ifdef statedebug}
            hp := new(pai_asm_comment,init(strpnew(
              'destroying all regs: unknown pai: '+tostr(ord(p^.typ)))));
            insertllitem(asml,p, p^.next,hp);
{$endif statedebug}
            DestroyAllRegs(CurProp);
          End;
      End;
      Inc(InstrCnt);
      GetNextInstruction(p, p);
    End;
End;

Function InitDFAPass2(BlockStart, BlockEnd: Pai): Boolean;
{reserves memory for the PPaiProps in one big memory block when not using
 TP, returns False if not enough memory is available for the optimizer in all
 cases}
Var p: Pai;
    Count: Longint;
{    TmpStr: String; }
Begin
  P := BlockStart;
  SkipHead(P);
  NrOfPaiObjs := 0;
  While (P <> BlockEnd) Do
    Begin
{$IfDef JumpAnal}
      Case P^.Typ Of
        ait_label:
          Begin
            If not labelCanBeSkipped(pai_label(p)) Then
              LTable^[Pai_Label(P)^.l^.labelnr-LoLab].InstrNr := NrOfPaiObjs
          End;
        ait_instruction:
          begin
            if paicpu(p)^.is_jmp then
             begin
               If (pasmlabel(paicpu(P)^.oper[0].sym)^.labelnr >= LoLab) And
                  (pasmlabel(paicpu(P)^.oper[0].sym)^.labelnr <= HiLab) Then
                 Inc(LTable^[pasmlabel(paicpu(P)^.oper[0].sym)^.labelnr-LoLab].RefsFound);
             end;
          end;
{        ait_instruction:
          Begin
           If (Paicpu(p)^.opcode = A_PUSH) And
              (Paicpu(p)^.oper[0].typ = top_symbol) And
              (PCSymbol(Paicpu(p)^.oper[0])^.offset = 0) Then
             Begin
               TmpStr := StrPas(PCSymbol(Paicpu(p)^.oper[0])^.symbol);
               If}
      End;
{$EndIf JumpAnal}
      Inc(NrOfPaiObjs);
      GetNextInstruction(p, p);
    End;
{Uncomment the next line to see how much memory the reloading optimizer needs}
{  Writeln(NrOfPaiObjs*SizeOf(TPaiProp));}
{no need to check mem/maxavail, we've got as much virtual memory as we want}
  If NrOfPaiObjs <> 0 Then
    Begin
      InitDFAPass2 := True;
      GetMem(PaiPropBlock, NrOfPaiObjs*SizeOf(TPaiProp));
      p := BlockStart;
      SkipHead(p);
      For Count := 1 To NrOfPaiObjs Do
        Begin
          PPaiProp(p^.OptInfo) := @PaiPropBlock^[Count];
          GetNextInstruction(p, p);
        End;
    End
  Else InitDFAPass2 := False;
End;

Function DFAPass2(
{$ifdef statedebug}
                   AsmL: PAasmOutPut;
{$endif statedebug}
                                      BlockStart, BlockEnd: Pai): Boolean;
Begin
  If InitDFAPass2(BlockStart, BlockEnd) Then
    Begin
      DoDFAPass2(
{$ifdef statedebug}
         asml,
{$endif statedebug}
         BlockStart, BlockEnd);
      DFAPass2 := True
    End
  Else DFAPass2 := False;
End;

Procedure ShutDownDFA;
Begin
  If LabDif <> 0 Then
    FreeMem(LTable, LabDif*SizeOf(TLabelTableItem));
End;

End.

{
  $Log$
  Revision 1.10  2000-11-28 16:32:11  jonas
    + support for optimizing simple sequences with div/idiv/mul opcodes

  Revision 1.9  2000/11/23 14:20:18  jonas
    * fixed stupid bug in previous commit

  Revision 1.8  2000/11/23 13:26:33  jonas
    * fix for webbug 1066/1126

  Revision 1.7  2000/11/17 15:22:04  jonas
    * fixed another bug in allocregbetween (introduced by the previous fix)
      ("merged")

  Revision 1.6  2000/11/14 13:26:10  jonas
    * fixed bug in allocregbetween

  Revision 1.5  2000/11/08 16:04:34  sg
  * Fix for containsPointerRef: Loop now runs in the correct range

  Revision 1.4  2000/11/03 18:06:26  jonas
    * fixed bug in arrayRefsEq
    * object/class fields are now handled the same as local/global vars and
      parameters (ie. a write to a local var can now never destroy a class
      field)

  Revision 1.3  2000/10/24 10:40:53  jonas
    + register renaming ("fixes" bug1088)
    * changed command line options meanings for optimizer:
        O2 now means peepholopts, CSE and register renaming in 1 pass
        O3 is the same, but repeated until no further optimizations are
          possible or until 5 passes have been done (to avoid endless loops)
    * changed aopt386 so it does this looping
    * added some procedures from csopt386 to the interface because they're
      used by rropt386 as well
    * some changes to csopt386 and daopt386 so that newly added instructions
      by the CSE get optimizer info (they were simply skipped previously),
      this fixes some bugs

  Revision 1.2  2000/10/19 15:59:40  jonas
    * fixed bug in allocregbetween (the register wasn't added to the
      usedregs set of the last instruction of the chain) ("merged")

  Revision 1.1  2000/10/15 09:47:43  peter
    * moved to i386/

  Revision 1.16  2000/10/14 10:14:47  peter
    * moehrendorf oct 2000 rewrite

  Revision 1.15  2000/09/30 13:07:23  jonas
    * fixed support for -Or with new features of CSE

  Revision 1.14  2000/09/29 23:14:11  jonas
    + writeToMemDestroysContents() and writeDestroysContents() to support the
      new features of the CSE

  Revision 1.13  2000/09/25 09:50:30  jonas
    - removed TP conditional code

  Revision 1.12  2000/09/24 21:19:50  peter
    * delphi compile fixes

  Revision 1.11  2000/09/24 15:06:15  peter
    * use defines.inc

  Revision 1.10  2000/09/22 15:00:20  jonas
    * fixed bug in regsEquivalent (in some rare cases, registers with
      completely unrelated content were considered equivalent) (merged
      from fixes branch)

  Revision 1.9  2000/09/20 15:00:58  jonas
    + much improved CSE: the CSE now searches further back for sequences it
      can reuse. After I've also implemented register renaming, the effect
      should be even better (afaik web bug 1088 will then even be optimized
      properly). I don't know about the slow down factor this adds. Maybe
      a new optimization level should be introduced?

  Revision 1.8  2000/08/25 19:39:18  jonas
    * bugfix to FindRegAlloc function (caused wrong regalloc info in
      some cases) (merged from fixes branch)

  Revision 1.7  2000/08/23 12:55:10  jonas
    * fix for web bug 1112 and a bit of clean up in csopt386 (merged from
      fixes branch)

  Revision 1.6  2000/08/19 17:53:29  jonas
    * fixed a potential bug in destroyregs regarding the removal of
      unused loads
    * added destroyDependingRegs() procedure and use it for the fix in
      the previous commit (safer/more complete than what was done before)

  Revision 1.5  2000/08/19 09:08:59  jonas
    * fixed bug where the contents of a register would not be destroyed
      if another register on which these contents depend is modified
      (not really merged, but same idea as fix in fixes branch,
      LAST_MERGE tag is updated)

  Revision 1.4  2000/07/21 15:19:54  jonas
    * daopt386: changes to getnextinstruction/getlastinstruction so they
      ignore labels who have is_addr set
    + daopt386/csopt386: remove loads of registers which are overwritten
       before their contents are used (especially usefull for removing superfluous
      maybe_loadesi outputs and push/pops transformed by below optimization
    + popt386: transform pop/pop/pop/.../push/push/push to sequences of
      'movl x(%esp),%reg' (only active when compiling a go32v2 compiler
      currently because I don't know whether it's safe to do this under Win32/
      Linux (because of problems we had when using esp as frame pointer on
      those os'es)

  Revision 1.3  2000/07/14 05:11:48  michael
  + Patch to 1.1

  Revision 1.2  2000/07/13 11:32:40  michael
  + removed logs

}