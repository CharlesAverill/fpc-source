{
    $Id$
    Copyright (c) 1998-2000 by Jonas Maebe, member of the Free Pascal
    Development Team

    This unit contains the data flow analyzer object of the assembler
    optimizer.

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
Unit aoptda;

Interface

uses aasm, cpubase, aoptcpub, aoptbase, aoptcpu;

Type
  TAOptDFA = Object(TAoptCpu)
    { uses the same constructor as TAoptCpu = constructor from TAoptObj }

    { gathers the information regarding the contents of every register }
    { at the end of every instruction                                  }
    Procedure DoDFA;

    { handles the processor dependent dataflow analizing               }
    Procedure CpuDFA(p: PInstr); Virtual;

    { How many instructions are between the current instruction and the }
    { last one that modified the register                               }
    InstrSinceLastMod: TInstrSinceLastMod;

    { convert a TInsChange value into the corresponding register }
    Function TCh2Reg(Ch: TInsChange): TRegister; Virtual;
    { returns whether the instruction P reads from register Reg }
    Function RegReadByInstr(Reg: TRegister; p: Pai): Boolean; Virtual;
  End;

Implementation

uses globals, aoptobj;

Procedure TAOptDFA.DoDFA;
{ Analyzes the Data Flow of an assembler list. Analyses the reg contents     }
{ for the instructions between blockstart and blockend. Returns the last pai }
{ which has been processed                                                   }
Var
    CurProp: PPaiProp;
    UsedRegs: TUsedRegs;
    p, hp, NewBlockStart : Pai;
    TmpReg: TRegister;
Begin
  p := BlockStart;
  UsedRegs.init;
  UsedRegs.Update(p);
  NewBlockStart := SkipHead(p);
  { done implicitely by the constructor
  FillChar(InstrSinceLastMod, SizeOf(InstrSinceLastMod), 0); }
  While (P <> BlockEnd) Do
    Begin
      CurProp := New(PPaiProp, init);
      If (p <> NewBlockStart) Then
        Begin
          GetLastInstruction(p, hp);
          CurProp^.Regs := PPaiProp(hp^.OptInfo)^.Regs;
{ !!!!!!!!!!!! }
{$ifdef i386}
          CurProp^.CondRegs.Flags :=
            PPaiProp(hp^.OptInfo)^.CondRegs.Flags;
{$endif}
        End;
      CurProp^.UsedRegs.InitWithValue(UsedRegs.GetUsedRegs);
      UsedRegs.Update(Pai(p^.Next));
      PPaiProp(p^.OptInfo) := CurProp;
      For TmpReg := LoGPReg To HiGPReg Do
        Inc(InstrSinceLastMod[TmpReg]);
      Case p^.typ Of
        ait_label:
          If (Pai_label(p)^.l^.is_used) Then
            CurProp^.DestroyAllRegs(InstrSinceLastMod);
{$ifdef GDB}
        ait_stabs, ait_stabn, ait_stab_function_name:;
{$endif GDB}
        ait_instruction:
          if not(PInstr(p)^.is_jmp) then
            begin
              If IsLoadMemReg(p) Then
                Begin
                  CurProp^.ReadRef(PInstr(p)^.oper[LoadSrc].ref);
                  TmpReg := RegMaxSize(PInstr(p)^.oper[LoadDst].reg);
                  If RegInRef(TmpReg, PInstr(p)^.oper[LoadSrc].ref^) And
                     (CurProp^.GetRegContentType(TmpReg) = Con_Ref) Then
                    Begin
                      { a load based on the value this register already }
                      { contained                                       }
                      With CurProp^.Regs[TmpReg] Do
                        Begin
                          CurProp^.IncWState(TmpReg);
                           {also store how many instructions are part of the  }
                           { sequence in the first instruction's PPaiProp, so }
                           { it can be easily accessed from within            }
                           { CheckSequence                                    }
                          Inc(NrOfMods, InstrSinceLastMod[TmpReg]);
                          PPaiProp(Pai(StartMod)^.OptInfo)^.Regs[TmpReg].NrOfMods := NrOfMods;
                          InstrSinceLastMod[TmpReg] := 0
                        End
                    End
                  Else
                    Begin
                      { load of a register with a completely new value }
                      CurProp^.DestroyReg(TmpReg, InstrSinceLastMod);
                      If Not(RegInRef(TmpReg, PInstr(p)^.oper[LoadSrc].ref^)) Then
                        With CurProp^.Regs[TmpReg] Do
                          Begin
                            Typ := Con_Ref;
                            StartMod := p;
                            NrOfMods := 1;
                          End
                    End;
  {$ifdef StateDebug}
                    hp := new(pai_asm_comment,init(strpnew(gas_reg2str[TmpReg]+': '+tostr(CurProp^.Regs[TmpReg].WState))));
                    InsertLLItem(AsmL, p, p^.next, hp);
  {$endif StateDebug}

                End
              Else if IsLoadConstReg(p) Then
                Begin
                  TmpReg := RegMaxSize(PInstr(p)^.oper[LoadDst].reg);
                  With CurProp^.Regs[TmpReg] Do
                    Begin
                      CurProp^.DestroyReg(TmpReg, InstrSinceLastMod);
                      typ := Con_Const;
                      StartMod := Pointer(PInstr(p)^.oper[LoadSrc].val);
                    End
                End
              Else CpuDFA(Pinstr(p));
            End;
        Else CurProp^.DestroyAllRegs(InstrSinceLastMod);
      End;
{      Inc(InstrCnt);}
      GetNextInstruction(p, p);
    End;
End;

Procedure TAoptDFA.CpuDFA(p: PInstr);
Begin
  Abstract;
End;

Function TAOptDFA.TCh2Reg(Ch: TInsChange): TRegister;
Begin
  TCh2Reg:=R_NO;
  Abstract;
End;

Function TAOptDFA.RegReadByInstr(Reg: TRegister; p: Pai): Boolean;
Begin
  RegReadByInstr:=false;
  Abstract;
End;


End.

{
  $Log$
  Revision 1.2  2002-04-14 16:49:30  carl
  + att_reg2str -> gas_reg2str

  Revision 1.1  2001/08/26 13:36:35  florian
    * some cg reorganisation
    * some PPC updates

  Revision 1.1  2000/07/13 06:30:07  michael
  + Initial import

  Revision 1.6  2000/01/07 01:14:52  peter
    * updated copyright to 2000

  Revision 1.5  1999/11/09 22:57:08  peter
    * compiles again both i386,alpha both with optimizer

  Revision 1.4  1999/08/18 14:32:21  jonas
    + compilable!
    + dataflow analyzer finished
    + start of CSE units
    + aoptbase which contains a base object for all optimizer objects
    * some constants and type definitions moved around to avoid circular
      dependencies
    * moved some methods from base objects to specialized objects because
      they're not used anywhere else

}