{
    $Id$
    Copyright (c) 1998 by Jonas Maebe

    This unit calls the optimization procedures to optimize the assembler
    code for i386+

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
{$ifdef newOptimizations}
{$define foropt}
{$define replacereg}
{$define arithopt}
{$define foldarithops}
{$endif newOptimizations}

Unit aopt386;

Interface

Uses
  aasm;

Procedure Optimize(AsmL: PAasmOutput);

Implementation

Uses
  globtype,
  globals,
  DAOpt386,POpt386,CSOpt386;


Procedure Optimize(AsmL: PAasmOutput);
Var BlockStart, BlockEnd, HP: Pai;
Begin
{setup labeltable, always necessary}
  BlockStart := Pai(AsmL^.First);
  BlockEnd := DFAPass1(AsmL, BlockStart);
{Blockend now either contains an ait_marker with Kind = AsmBlockStart, or nil}
  While Assigned(BlockStart) Do
    Begin
{peephole optimizations}
      PeepHoleOptPass1(AsmL, BlockStart, BlockEnd);
      PeepHoleOptPass1(AsmL, BlockStart, BlockEnd);
{data flow analyzer}
      If (cs_slowoptimize in aktglobalswitches) Then
        Begin
          If DFAPass2(
{$ifdef statedebug}
                      AsmL,
{$endif statedebug}
                            BlockStart, BlockEnd) Then
{common subexpression elimination}
            CSE(AsmL, BlockStart, BlockEnd);
        End;
{more peephole optimizations}
      PeepHoleOptPass2(AsmL, BlockStart, BlockEnd);
{dispose labeltabel}
      ShutDownDFA;
{continue where we left off, BlockEnd is either the start of an assembler
 block or nil}
      BlockStart := BlockEnd;
      While Assigned(BlockStart) And
            (BlockStart^.typ = ait_Marker) And
            (Pai_Marker(BlockStart)^.Kind = AsmBlockStart) Do
        Begin
         {we stopped at an assembler block, so skip it}
         Repeat
           BlockStart := Pai(BlockStart^.Next);
         Until (BlockStart^.Typ = Ait_Marker) And
               (Pai_Marker(Blockstart)^.Kind = AsmBlockEnd);
         {blockstart now contains a pai_marker(asmblockend)}
          If GetNextInstruction(BlockStart, HP) And
             ((HP^.typ <> ait_Marker) Or
              (Pai_Marker(HP)^.Kind <> AsmBlockStart)) Then
           {there is no assembler block anymore after the current one, so
            optimize the next block of "normal" instructions}
            BlockEnd := DFAPass1(AsmL, BlockStart)
           {otherwise, skip the next assembler block}
          Else BlockStart := HP;
        End
   End;
End;

End.

{
 $Log$
 Revision 1.30  1999-11-27 23:50:22  jonas
   + if you define "newOptimizations", all extra optimizations that
     require conditional defines will be activated (ie., it's equivalent
     to "-dreplacereg -darithopt -dforopt -dfoldarithops")

 Revision 1.29  1999/10/23 14:44:24  jonas
   * finally got around making GetNextInstruction return false when
     the current pai object is a AsmBlockStart marker
   * changed a loop in aopt386 which was incompatible with this change

 Revision 1.28  1999/05/08 20:39:02  jonas
   + some comments

 Revision 1.27  1999/04/18 17:57:17  jonas
   * fix for crash when the first instruction of a sequence that gets
     optimized is removed (this situation can't occur aymore now)

 Revision 1.26  1999/03/31 13:55:03  peter
   * assembler inlining working for ag386bin

 Revision 1.25  1998/12/29 19:58:27  jonas
   * fixed crash when there are two asm blocks right after each other

 Revision 1.24  1998/12/29 18:48:23  jonas
   + optimize pascal code surrounding assembler blocks

 Revision 1.23  1998/12/11 00:02:43  peter
   + globtype,tokens,version unit splitted from globals

 Revision 1.22  1998/08/19 16:07:57  jonas
   * changed optimizer switches + cleanup of DestroyRefs in daopt386.pas

 Revision 1.21  1998/08/06 19:40:29  jonas
   * removed $ before and after Log in comment

 Revision 1.20  1998/08/05 16:00:08  florian
   * some fixes for ansi strings
   * log to Log changed

}
