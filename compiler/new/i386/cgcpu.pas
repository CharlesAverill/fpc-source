{
    $Id$
    Copyright (c) 1993-98 by Florian Klaempfl

    This unit implements the code generator for the i386

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
       cgobj,aasm
{$i cpuunit.inc}
       ;

    type
       pcg386 = ^tcg386;

       tcg386 = object(tcg)
          procedure a_push_reg(list : paasmoutput;r : tregister);virtual;
          procedure a_call_name(list : paasmoutput;const s : string;
            offset : longint);virtual;

          procedure a_load_const8_ref(list : paasmoutput;b : byte;const ref : treference);virtual;
          procedure a_load_const16_ref(list : paasmoutput;w : word;const ref : treference);virtual;
          procedure a_load_const32_ref(list : paasmoutput;l : longint;const ref : treference);virtual;
          procedure a_load_const64_ref(list : paasmoutput;q : qword;const ref : treference);virtual;

          procedure g_stackframe_entry(list : paasmoutput;localsize : longint);virtual;
          procedure g_restore_frame_pointer(list : paasmoutput);virtual;
          procedure tcg386.g_ret_from_proc(list : paasmoutput;para size : aword);
          constructor init;
       end;

  implementation

    uses
       globtype,globals;

    constructor tcg386.init;

      begin
         inherited init;
      end;

    procedure tcg386.g_stackframe_entry(list : paasmoutput;localsize : longint);

      begin
         if localsize<>0 then
           begin
              if (cs_littlesize in aktglobalswitches) and (localsize<=65535) then
                list^.insert(new(pai386,op_const_const(A_ENTER,S_NO,localsize,0)))
              else
                begin
                   list^.concat(new(pai386,op_reg(A_PUSH,S_L,R_EBP)));
                   list^.concat(new(pai386,op_reg_reg(A_MOV,S_L,R_ESP,R_EBP)));
                   list^.concat(new(pai386,op_const_reg(A_SUB,S_L,localsize,R_ESP)));
                end;
             end
         else
           begin
              list^.concat(new(pai386,op_reg(A_PUSH,S_L,R_EBP)));
              list^.concat(new(pai386,op_reg_reg(A_MOV,S_L,R_ESP,R_EBP)));
           end;
       end;

     procedure tcg386.a_call_name(list : paasmoutput;const s : string;
       offset : longint);

       begin
          list^.concat(new(pai386,op_sym(A_CALL,S_NO,newasmsymbol(s))));
          {!!!!!!!!!1 offset is ignored }
       end;

     procedure tcg386.a_push_reg(list : paasmoutput;r : tregister);

       begin
          list^.concat(new(pai386,op_reg(A_PUSH,regsize(r),r)));
       end;

     procedure tcg386.a_load_const8_ref(list : paasmoutput;b : byte;const ref : treference);

       begin
          abstract;
       end;

     procedure tcg386.a_load_const16_ref(list : paasmoutput;w : word;const ref : treference);

       begin
          abstract;
       end;

     procedure tcg386.a_load_const32_ref(list : paasmoutput;l : longint;const ref : treference);

       begin
          abstract;
       end;

     procedure tcg386.a_load_const64_ref(list : paasmoutput;q : qword;const ref : treference);

       begin
          abstract;
       end;

     procedure tcg386.g_restore_frame_pointer(list : paasmoutput);

       begin
          list^.concat(new(pai386,op_none(A_LEAVE,S_NO)));
       end;

     procedure tcg386.g_ret_from_proc(list : paasmoutput;para size : aword);

       begin
          { parameters are limited to 65535 bytes because }
          { ret allows only imm16                    }
          if (parasize>65535) and not(pocall_clearstack in aktprocsym^.definition^.proccalloptions) then
            CGMessage(cg_e_parasize_too_big);
          { Routines with the poclearstack flag set use only a ret.}
          { also routines with parasize=0     }
          if (parasize=0) or (pocall_clearstack in aktprocsym^.definition^.proccalloptions) then
            list^.concat(new(pai386,op_none(A_RET,S_NO)))
          else
            list^.concat(new(pai386,op_const(A_RET,S_NO,parasize)));
       end;

end.
{
  $Log$
  Revision 1.4  1999-08-06 14:15:56  florian
    * made the alpha version compilable

  Revision 1.3  1999/08/06 13:26:54  florian
    * more changes ...

  Revision 1.2  1999/08/01 23:19:59  florian
    + make a new makefile using the old compiler makefile

  Revision 1.1  1999/08/01 23:11:24  florian
    + renamed ot tp cgcpu.pas

  Revision 1.1  1999/08/01 22:08:26  florian
    * reorganisation of directory structure

  Revision 1.3  1999/08/01 18:22:31  florian
   * made it again compilable

  Revision 1.2  1999/01/23 23:29:43  florian
    * first running version of the new code generator
    * when compiling exceptions under Linux fixed

  Revision 1.1  1998/12/15 22:17:02  florian
    * first version

}
