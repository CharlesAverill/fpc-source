{
    $Id$
    Copyright (C) 1997 by Florian Klaempfl

    this unit implements an asmlistitem class for the DEC Alpha

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
unit cpubase;

  interface

    uses
       strings,systems,cobjects,globals,aasm,cpuinfo;

type
  tasmop = (A_ADDF,A_ADDG,A_ADDL,A_ADDQ,
            A_ADDS,A_ADDT,A_AMASK,A_AND,A_BEQ,A_BGE,
            A_BGT,A_BIC,A_BIS,A_BLBC,A_BLBS,A_BLE,
            A_BLT,A_BNE,A_BR,A_BSR,A_CALL_PAL,A_CMOVEQ,
            A_CMOVGE,A_CMOVGT,A_CMOVLBC,A_CMOVLBS,A_CMOVLE,A_CMOVLT,
            A_CMOVNE,A_CMPBGE,A_CMPEQ,A_CMPGEQ,A_CMPGLE,A_CMPGLT,
            A_CMPLE,A_CMPLT,A_CMPTEQ,A_CMPTLE,A_CMPTLT,A_CMPTUN,
            A_CMPULE,A_CMPULT,A_CPYS,A_CPYSE,A_CPYSN,A_CTLZ,
            A_CTPOP,A_CTTZ,A_CVTDG,A_CVTGD,A_CVTGF,A_CVTGQ,
            A_CVTLQ,A_CVTQF,A_CVTQG,A_CVTQL,A_CVTQS,A_CVTQT,
            A_CVTST,A_CVTTQ,A_CVTTS,A_DIVF,A_DIVG,A_DIVS,
            A_DIVT,A_ECB,A_EQV,A_EXCB,A_EXTBL,A_EXTLH,
            A_EXTLL,A_EXTQH,A_EXTQL,A_EXTWH,A_EXTWL,A_FBEQ,
            A_FBGE,A_FBGT,A_FBLE,A_FBLT,A_FBNE,A_FCMOVEQ,
            A_FCMOVGE,A_FCMOVGT,A_FCMOVLE,A_FCMOVLT,A_FCMOVNE,A_FETCH,
            A_FETCH_M,A_FTOIS,A_FTOIT,A_IMPLVER,A_INSBL,A_INSLH,
            A_INSLL,A_INSQH,A_INSQL,A_INSWH,A_INSWL,A_ITOFF,
            A_ITOFS,A_ITOFT,A_JMP,A_JSR,A_JSR_COROUTINE,A_LDA,
            A_LDAH,A_LDBU,A_LDWU,A_LDF,A_LDG,A_LDL,
            A_LDL_L,A_LDQ,A_LDQ_L,A_LDQ_U,A_LDS,A_LDT,
            A_MAXSB8,A_MAXSW4,A_MAXUB8,A_MAXUW4,A_MB,A_MF_FPCR,
            A_MINSB8,A_MINSW4,A_MINUB8,A_MINUW4,A_MSKBL,A_MSKLH,
            A_MSKLL,A_MSKQH,A_MSKQL,A_MSKWH,A_MSKWL,A_MT_FPCR,
            A_MULF,A_MULG,A_MULL,A_MULQ,
            A_MULS,A_MULT,A_ORNOT,A_PERR,A_PKLB,A_PKWB,
            A_RC,A_RET,A_RPCC,A_RS,A_S4ADDL,A_S4ADDQ,
            A_S4SUBL,A_S4SUBQ,A_S8ADDL,A_S8ADDQ,A_S8SUBL,A_S8SUBQ,
            A_SEXTB,A_SEXTW,A_SLL,A_SQRTF,A_SQRTG,A_SQRTS,
            A_SQRTT,A_SRA,A_SRL,A_STB,A_STF,A_STG,
            A_STS,A_STL,A_STL_C,A_STQ,A_STQ_C,A_STQ_U,
            A_STT,A_STW,A_SUBF,A_SUBG,A_SUBL,
            A_SUBQ,A_SUBS,A_SUBT,A_TRAPB,A_UMULH,
            A_UNPKBL,A_UNPKBW,A_WH64,A_WMB,A_XOR,A_ZAP,
            A_ZAPNOT);

Const
  firstop = low(tasmop);
  lastop  = high(tasmop);

type
  TAsmCond = 
   (
    C_None,C_A,C_AE,C_B,C_BE,C_C,C_E,C_G,C_GE,C_L,C_LE,C_NA,C_NAE,
    C_NB,C_NBE,C_NC,C_NE,C_NG,C_NGE,C_NL,C_NLE,C_NO,C_NP,C_NS,C_NZ,C_O,C_P,
    C_PE,C_PO,C_S,C_Z
   );


Type

 { ALL registers }
 TRegister = (R_NO,  { R_NO is Mandatory, signifies no register }
              R_0,R_1,R_2,R_3,R_4,R_5,R_6,R_7,R_8,R_9,
              R_10,R_11,R_12,R_13,R_14,R_15,R_16,R_17,R_18,R_19,
              R_20,R_21,R_22,R_23,R_24,R_25,R_26,R_27,R_28,R_29,
              R_30,R_31,
              R_F0,R_F1,R_F2,R_F3,R_F4,R_F5,R_F6,R_F7,R_F8,R_F9,
              R_F10,R_F11,R_F12,R_F13,R_F14,R_F15,R_F16,R_F17,R_F18,R_F19,
              R_F20,R_F21,R_F22,R_F23,R_F24,R_F25,R_F26,R_F27,R_F28,R_F29,
              R_F30,R_F31);

  TRegisterset = Set of TRegister;
  
{ Constants describing the registers }

Const  
  Firstreg = R_0;
  LastReg = R_F31;
  
  stack_pointer = R_30;
  frame_pointer = R_15;
  self_pointer  = R_16;
  accumulator   = R_0;

  { sizes }
  pointersize   = 8;
  extended_size = 16;
  
  intregs = [R_0..R_31];
  fpuregs = [R_F0..R_F31];
  mmregs = [];
 
  availabletempregsint = [R_0..R_14,R_16..R_25,R_28];     
  availabletempregsfpu = [R_F0..R_F30];
  availabletempregsmm  = [];

  c_countusableregsint = 26;
  c_countusableregsfpu = 31;
  c_countusableregsmm  = 0;

  registers_saved_on_cdecl = [R_9..R_14,R_F2..R_F9];
  maxvarregs = 6;

  varregs : Array [1..maxvarregs] of Tregister = 
            (R_9,R_10,R_11,R_12,R_13,R_14);
  
Type 
 TReference = record
   offset : aword;
   symbol : pasmsymbol;
   base : tregister;
   is_immediate : boolean;
   { the boundary to which the reference is surely aligned }
   alignment : byte;
   end;
 PReference = ^TReference;

 tloc = (LOC_INVALID,
         LOC_REGISTER,
         LOC_MEM,
         LOC_REFERENCE,
         LOC_JUMP,
         LOC_CREGISTER,
         LOC_CONST);

 tlocation = record
   case loc : tloc of
     LOC_REFERENCE,LOC_MEM : (reference : treference);
     LOC_REGISTER : (register : tregister);
   end;

{*****************************************************************************
                                Operands
*****************************************************************************}


       { Types of operand }
        toptype=(top_none,top_reg,top_ref,top_const,top_symbol);

        toper=record
          ot  : longint;
          case typ : toptype of
           top_none   : ();
           top_reg    : (reg:tregister);
           top_ref    : (ref:preference);
           top_const  : (val:longint);
           top_symbol : (sym:pasmsymbol;symofs:longint);
        end;



Const
  { offsets for the integer and floating point registers }
  INT_REG = 0;
  FLOAT_REG = 32;

  { operator qualifiers }
  OQ_CHOPPED_ROUNDING            = $01;  { /C }
  OQ_ROUNDING_MODE_DYNAMIC       = $02;  { /D }
  OQ_ROUND_TOWARD_MINUS_INFINITY = $04;  { /M }
  OQ_INEXACT_RSULT_ENABLE        = $08;  { /I }
  OQ_SOFTWARE_COMPLETION_ENABLE  = $10;  { /S }
  OQ_FLOATING_UNDERFLOW_ENABLE   = $20;  { /U }
  OQ_INTEGER_OVERFLOW_ENABLE     = $40;  { /V }

{ resets all values of ref to defaults }
procedure reset_reference(var ref : treference);
{ set mostly used values of a new reference }
function new_reference(base : tregister;offset : longint) : preference;
procedure disposereference(var r : preference);


implementation

procedure reset_reference(var ref : treference);
begin
  FillChar(ref,sizeof(treference),0);
end;


function new_reference(base : tregister;offset : longint) : preference;
var
  r : preference;
begin
  new(r);
  FillChar(r^,sizeof(treference),0);
  r^.offset:=offset;
  r^.alignment:=8;
  new_reference:=r;
end;

procedure disposereference(var r : preference);

begin
  dispose(r);
  r:=Nil;
end;

end.
{
  $Log$
  Revision 1.4  1999-08-03 15:52:40  michael
  * Additional changes

  Revision 1.3  1999/08/03 00:35:54  michael
  + Added varregs

  Revision 1.2  1999/08/02 17:16:44  michael
  + Changes for alpha

  Revision 1.1  1999/08/01 23:18:36  michael
  + Fixes for new code generator

  Revision 1.2  1998/09/09 20:14:00  peter
    - dup files already used elsewhere

}
