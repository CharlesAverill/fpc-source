{
    $Id$
    Copyright (c) 1996,97 by Florian Klaempfl

    This unit implements an asmoutput class for Intel syntax with Intel i386+

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
{$ifdef TP}
  {$N+,E+}
{$endif}
unit ag386int;

    interface

    uses aasm,assemble;

    type
      pi386intasmlist=^ti386intasmlist;
      ti386intasmlist = object(tasmlist)
        procedure WriteTree(p:paasmoutput);virtual;
        procedure WriteAsmList;virtual;
      end;

  implementation

    uses
      dos,globals,systems,cobjects,
{$ifdef AG386BIN}
      i386base,i386asm,
{$else}
      i386,
{$endif}
      strings,files,verbose
{$ifdef GDB}
      ,gdb
{$endif GDB}
      ;

    const
      line_length = 70;

      extstr : array[EXT_NEAR..EXT_ABS] of String[8] =
             ('NEAR','FAR','PROC','BYTE','WORD','DWORD',
              'CODEPTR','DATAPTR','FWORD','PWORD','QWORD','TBYTE','ABS');


    function double2str(d : double) : string;
      var
         hs : string;
         p : byte;
      begin
         str(d,hs);
      { nasm expects a lowercase e }
         p:=pos('E',hs);
         if p>0 then
          hs[p]:='e';
         p:=pos('+',hs);
         if p>0 then
          delete(hs,p,1);
         double2str:=lower(hs);
      end;

    function extended2str(e : extended) : string;
      var
         hs : string;
         p : byte;
      begin
         str(e,hs);
      { nasm expects a lowercase e }
         p:=pos('E',hs);
         if p>0 then
          hs[p]:='e';
         p:=pos('+',hs);
         if p>0 then
          delete(hs,p,1);
         extended2str:=lower(hs);
      end;


    function comp2str(d : bestreal) : string;
      type
        pdouble = ^double;
      var
        c  : comp;
        dd : pdouble;
      begin
      {$ifdef TP}
         c:=d;
      {$else}
         c:=comp(d);
       {$endif}
         dd:=pdouble(@c); { this makes a bitwise copy of c into a double }
         comp2str:=double2str(dd^);
      end;

    function getreferencestring(const ref : treference) : string;
    var
      s     : string;
      first : boolean;
    begin
      if ref.is_immediate then
       begin
         getreferencestring:=tostr(ref.offset);
         exit;
       end
      else
      with ref do
        begin
          first:=true;
          if ref.segment<>R_DEFAULT_SEG then
           s:=int_reg2str[segment]+':['
          else
           s:='[';
         if assigned(symbol) then
          begin
            s:=s+symbol^.name;
            first:=false;
          end;
         if (base<>R_NO) then
          begin
            if not(first) then
             s:=s+'+'
            else
             first:=false;
             s:=s+int_reg2str[base];
          end;
         if (index<>R_NO) then
           begin
             if not(first) then
               s:=s+'+'
             else
               first:=false;
             s:=s+int_reg2str[index];
             if scalefactor<>0 then
               s:=s+'*'+tostr(scalefactor);
           end;
         if offset<0 then
           s:=s+tostr(offset)
         else if (offset>0) then
           s:=s+'+'+tostr(offset);
         s:=s+']';
        end;
       getreferencestring:=s;
     end;

{$ifdef AG386BIN}

    function getopstr(const o:toper;s : topsize; opcode: tasmop;dest : boolean) : string;
    var
      hs : string;
    begin
      case o.typ of
        top_reg :
          getopstr:=int_reg2str[o.reg];
        top_const :
          getopstr:=tostr(o.val);
        top_symbol :
          begin
            hs:='offset '+o.sym^.name;
            if o.symofs>0 then
             hs:=hs+'+'+tostr(o.symofs)
            else
             if o.symofs<0 then
              hs:=hs+tostr(o.symofs);
            getopstr:=hs;
          end;
        top_ref :
          begin
            hs:=getreferencestring(o.ref^);
            if ((opcode <> A_LGS) and (opcode <> A_LSS) and
                (opcode <> A_LFS) and (opcode <> A_LDS) and
                (opcode <> A_LES)) then
             Begin
               case s of
                S_B : hs:='byte ptr '+hs;
                S_W : hs:='word ptr '+hs;
                S_L : hs:='dword ptr '+hs;
               S_IS : hs:='word ptr '+hs;
               S_IL : hs:='dword ptr '+hs;
               S_IQ : hs:='qword ptr '+hs;
               S_FS : hs:='dword ptr '+hs;
               S_FL : hs:='qword ptr '+hs;
               S_FX : hs:='tbyte ptr '+hs;
               S_BW : if dest then
                       hs:='word ptr '+hs
                      else
                       hs:='byte ptr '+hs;
               S_BL : if dest then
                       hs:='dword ptr '+hs
                      else
                       hs:='byte ptr '+hs;
               S_WL : if dest then
                       hs:='dword ptr '+hs
                      else
                       hs:='word ptr '+hs;
               end;
             end;
            getopstr:=hs;
          end;
        else
          internalerror(10001);
      end;
    end;

    function getopstr_jmp(const o:toper) : string;
    var
      hs : string;
    begin
      case o.typ of
        top_reg :
          getopstr_jmp:=int_reg2str[o.reg];
        top_const :
          getopstr_jmp:=tostr(o.val);
        top_symbol :
          begin
            hs:=o.sym^.name;
            if o.symofs>0 then
             hs:=hs+'+'+tostr(o.symofs)
            else
             if o.symofs<0 then
              hs:=hs+tostr(o.symofs);
            getopstr_jmp:=hs;
          end;
        top_ref :
          getopstr_jmp:=getreferencestring(o.ref^);
        else
          internalerror(10001);
      end;
    end;

{$else}

    function getopstr(t : byte;o : pointer;opofs:longint;s : topsize; _operator: tasmop;dest : boolean) : string;
    var
      hs : string;
    begin
      case t of
       top_reg : getopstr:=int_reg2str[tregister(o)];
     top_const,
       top_ref : begin
                   if t=top_const then
                     hs := tostr(longint(o))
                   else
                     hs:=getreferencestring(preference(o)^);
                   { can possibly give a range check error under tp }
                   { if using in...                                 }
                   if ((_operator <> A_LGS) and (_operator <> A_LSS) and
                       (_operator <> A_LFS) and (_operator <> A_LDS) and
                       (_operator <> A_LES)) then
                    Begin
                      case s of
                       S_B : hs:='byte ptr '+hs;
                       S_W : hs:='word ptr '+hs;
                       S_L : hs:='dword ptr '+hs;
                      S_IS : hs:='word ptr '+hs;
                      S_IL : hs:='dword ptr '+hs;
                      S_IQ : hs:='qword ptr '+hs;
                      S_FS : hs:='dword ptr '+hs;
                      S_FL : hs:='qword ptr '+hs;
                      S_FX : hs:='tbyte ptr '+hs;
                      S_BW : if dest then
                              hs:='word ptr '+hs
                             else
                              hs:='byte ptr '+hs;
                      S_BL : if dest then
                              hs:='dword ptr '+hs
                             else
                              hs:='byte ptr '+hs;
                      S_WL : if dest then
                              hs:='dword ptr '+hs
                             else
                              hs:='word ptr '+hs;
                      end;
                    end;
                   getopstr:=hs;
                 end;
    top_symbol : begin
                   hs:='offset '+pasmsymbol(o)^.name;
                   if opofs>0 then
                    hs:=hs+'+'+tostr(opofs)
                   else
                    if opofs<0 then
                     hs:=hs+tostr(opofs);
                   getopstr:=hs;
                 end;
      else
       internalerror(10001);
      end;
    end;

    function getopstr_jmp(t : byte;o : pointer;opofs:longint) : string;
    var
      hs : string;
    begin
      case t of
         top_reg : getopstr_jmp:=int_reg2str[tregister(o)];
         top_ref : getopstr_jmp:=getreferencestring(preference(o)^);
       top_const : getopstr_jmp:=tostr(longint(o));
       top_symbol : begin
                      hs:=pasmsymbol(o)^.name;
                      if opofs>0 then
                       hs:=hs+'+'+tostr(opofs)
                      else
                       if opofs<0 then
                        hs:=hs+tostr(opofs);
                      getopstr_jmp:=hs;
                    end;
      else
       internalerror(10001);
      end;
    end;
{$endif}


{****************************************************************************
                               TI386INTASMLIST
 ****************************************************************************}

    var
      LastSec : tsection;

    const
      ait_const2str:array[ait_const_32bit..ait_const_8bit] of string[8]=
        (#9'DD'#9,#9'DW'#9,#9'DB'#9);

      ait_section2masmstr : array[tsection] of string[6]=
       ('','CODE','DATA','BSS','','','','','','','','','');

    Function PadTabs(const p:string;addch:char):string;
    var
      s : string;
      i : longint;
    begin
      i:=length(p);
      if addch<>#0 then
       begin
         inc(i);
         s:=p+addch;
       end
      else
       s:=p;
      if i<8 then
       PadTabs:=s+#9#9
      else
       PadTabs:=s+#9;
    end;

    procedure ti386intasmlist.WriteTree(p:paasmoutput);
    type
      twowords=record
        word1,word2:word;
      end;
    var
      s,
      prefix,
      suffix   : string;
      hp       : pai;
      counter,
      lines,
      i,j,l    : longint;
      consttyp : tait;
      found,
      quoted   : boolean;
{$ifdef AG386Bin}
      sep      : char;
{$endif}
    begin
      if not assigned(p) then
       exit;
      hp:=pai(p^.first);
      while assigned(hp) do
       begin
         case hp^.typ of
       ait_comment : Begin
                       AsmWrite(target_asm.comment);
                       AsmWritePChar(pai_asm_comment(hp)^.str);
                       AsmLn;
                     End;
     ait_regalloc,
    ait_regdealloc :;
       ait_section : begin
                       if LastSec<>sec_none then
                        AsmWriteLn('_'+ait_section2masmstr[LastSec]+#9#9'ENDS');
                       if pai_section(hp)^.sec<>sec_none then
                        begin
                          AsmLn;
                          AsmWriteLn('_'+ait_section2masmstr[pai_section(hp)^.sec]+#9#9+
                                     'SEGMENT'#9'PARA PUBLIC USE32 '''+
                                     ait_section2masmstr[pai_section(hp)^.sec]+'''');
                        end;
                       LastSec:=pai_section(hp)^.sec;
                     end;
         ait_align : begin
                     { CAUSES PROBLEMS WITH THE SEGMENT DEFINITION   }
                     { SEGMENT DEFINITION SHOULD MATCH TYPE OF ALIGN }
                     { HERE UNDER TASM!                              }
                       AsmWriteLn(#9'ALIGN '+tostr(pai_align(hp)^.aligntype));
                     end;
      ait_external : AsmWriteLn(#9'EXTRN'#9+pai_external(hp)^.sym^.name+
                                ' :'+extstr[pai_external(hp)^.exttyp]);
     ait_datablock : begin
                       if pai_datablock(hp)^.is_global then
                         AsmWriteLn(#9'PUBLIC'#9+pai_datablock(hp)^.sym^.name);
                       AsmWriteLn(PadTabs(pai_datablock(hp)^.sym^.name,#0)+'DB'#9+tostr(pai_datablock(hp)^.size)+' DUP(?)');
                     end;
   ait_const_32bit,
    ait_const_8bit,
   ait_const_16bit : begin
                       AsmWrite(ait_const2str[hp^.typ]+tostr(pai_const(hp)^.value));
                       consttyp:=hp^.typ;
                       l:=0;
                       repeat
                         found:=(not (Pai(hp^.next)=nil)) and (Pai(hp^.next)^.typ=consttyp);
                         if found then
                          begin
                            hp:=Pai(hp^.next);
                            s:=','+tostr(pai_const(hp)^.value);
                            AsmWrite(s);
                            inc(l,length(s));
                          end;
                       until (not found) or (l>line_length);
                       AsmLn;
                     end;
  ait_const_symbol : begin
                       AsmWriteLn(#9#9'DD'#9'offset '+pai_const_symbol(hp)^.sym^.name);
                       if pai_const_symbol(hp)^.offset>0 then
                         AsmWrite('+'+tostr(pai_const_symbol(hp)^.offset))
                       else if pai_const_symbol(hp)^.offset<0 then
                         AsmWrite(tostr(pai_const_symbol(hp)^.offset));
                       AsmLn;
                     end;
     ait_const_rva : begin
                       AsmWriteLn(#9#9'RVA'#9+pai_const_symbol(hp)^.sym^.name);
                     end;
    ait_real_32bit : AsmWriteLn(#9#9'DD'#9+double2str(pai_single(hp)^.value));
    ait_real_64bit : AsmWriteLn(#9#9'DQ'#9+double2str(pai_double(hp)^.value));
 ait_real_extended : AsmWriteLn(#9#9'DT'#9+extended2str(pai_extended(hp)^.value));
          ait_comp : AsmWriteLn(#9#9'DQ'#9+comp2str(pai_extended(hp)^.value));
        ait_string : begin
                       counter := 0;
                       lines := pai_string(hp)^.len div line_length;
                     { separate lines in different parts }
                       if pai_string(hp)^.len > 0 then
                        Begin
                          for j := 0 to lines-1 do
                           begin
                             AsmWrite(#9#9'DB'#9);
                             quoted:=false;
                             for i:=counter to counter+line_length do
                                begin
                                  { it is an ascii character. }
                                  if (ord(pai_string(hp)^.str[i])>31) and
                                     (ord(pai_string(hp)^.str[i])<128) and
                                     (pai_string(hp)^.str[i]<>'"') then
                                      begin
                                        if not(quoted) then
                                            begin
                                              if i>counter then
                                                AsmWrite(',');
                                              AsmWrite('"');
                                            end;
                                        AsmWrite(pai_string(hp)^.str[i]);
                                        quoted:=true;
                                      end { if > 31 and < 128 and ord('"') }
                                  else
                                      begin
                                          if quoted then
                                              AsmWrite('"');
                                          if i>counter then
                                              AsmWrite(',');
                                          quoted:=false;
                                          AsmWrite(tostr(ord(pai_string(hp)^.str[i])));
                                      end;
                               end; { end for i:=0 to... }
                             if quoted then AsmWrite('"');
                               AsmWrite(target_os.newline);
                             counter := counter+line_length;
                          end; { end for j:=0 ... }
                        { do last line of lines }
                        AsmWrite(#9#9'DB'#9);
                        quoted:=false;
                        for i:=counter to pai_string(hp)^.len-1 do
                          begin
                            { it is an ascii character. }
                            if (ord(pai_string(hp)^.str[i])>31) and
                               (ord(pai_string(hp)^.str[i])<128) and
                               (pai_string(hp)^.str[i]<>'"') then
                                begin
                                  if not(quoted) then
                                      begin
                                        if i>counter then
                                          AsmWrite(',');
                                        AsmWrite('"');
                                      end;
                                  AsmWrite(pai_string(hp)^.str[i]);
                                  quoted:=true;
                                end { if > 31 and < 128 and " }
                            else
                                begin
                                  if quoted then
                                    AsmWrite('"');
                                  if i>counter then
                                      AsmWrite(',');
                                  quoted:=false;
                                  AsmWrite(tostr(ord(pai_string(hp)^.str[i])));
                                end;
                          end; { end for i:=0 to... }
                        if quoted then
                          AsmWrite('"');
                        end;
                       AsmLn;
                     end;
         ait_label : begin
                       if pai_label(hp)^.l^.is_used then
                        begin
                          AsmWrite(lab2str(pai_label(hp)^.l));
                          if (assigned(hp^.next) and not(pai(hp^.next)^.typ in
                             [ait_const_32bit,ait_const_16bit,ait_const_8bit,
                              ait_const_symbol,ait_const_rva,
                              ait_real_32bit,ait_real_64bit,ait_real_extended,ait_string])) then
                           AsmWriteLn(':');
                        end;
                     end;
        ait_direct : begin
                       AsmWritePChar(pai_direct(hp)^.str);
                       AsmLn;
                     end;
ait_labeled_instruction : AsmWriteLn(#9#9+int_op2str[pai386_labeled(hp)^.opcode]+#9+lab2str(pai386_labeled(hp)^.lab));
        ait_symbol : begin
                       if pai_symbol(hp)^.is_global then
                         AsmWriteLn(#9'PUBLIC'#9+pai_symbol(hp)^.sym^.name);
                       AsmWrite(pai_symbol(hp)^.sym^.name);
                       if assigned(hp^.next) and not(pai(hp^.next)^.typ in
                          [ait_const_32bit,ait_const_16bit,ait_const_8bit,
                           ait_const_symbol,ait_const_rva,
                           ait_real_64bit,ait_real_extended,ait_string]) then
                        AsmWriteLn(':')
                     end;
   ait_instruction : begin
                       suffix:='';
                       prefix:= '';
{$ifdef AG386BIN}
                     { added prefix instructions, must be on same line as opcode }
                       if (pai386(hp)^.ops = 0) and
                          ((pai386(hp)^.opcode = A_REP) or
                           (pai386(hp)^.opcode = A_LOCK) or
                           (pai386(hp)^.opcode =  A_REPE) or
                           (pai386(hp)^.opcode =  A_REPNZ) or
                           (pai386(hp)^.opcode =  A_REPZ) or
                           (pai386(hp)^.opcode = A_REPNE)) then
                        Begin
                          prefix:=int_op2str[pai386(hp)^.opcode]+#9;
                          hp:=Pai(hp^.next);
                        { this is theorically impossible... }
                          if hp=nil then
                           begin
                             s:=#9#9+prefix;
                             AsmWriteLn(s);
                             break;
                           end;
                          { nasm prefers prefix on a line alone }
                          AsmWriteln(#9#9+prefix);
                          prefix:='';
                        end
                       else
                        prefix:= '';
                       if pai386(hp)^.ops<>0 then
                        begin
                          if pai386(hp)^.opcode=A_CALL then
                           s:='dword ptr '+getopstr_jmp(pai386(hp)^.oper[0])
                          else
                           begin
                             for i:=0to pai386(hp)^.ops-1 do
                              begin
                                if i=0 then
                                 sep:=#9
                                else
                                 sep:=',';
                                s:=s+sep+getopstr(pai386(hp)^.oper[i],pai386(hp)^.opsize,pai386(hp)^.opcode,(i=1));
                              end;
                           end;
                        end
                       else
                        begin
                          { check if string instruction }
                          { long form, otherwise may give range check errors }
                          { in turbo pascal...                               }
{                          if ((pai386(hp)^.opcode = A_CMPS) or
                             (pai386(hp)^.opcode = A_INS) or
                             (pai386(hp)^.opcode = A_OUTS) or
                             (pai386(hp)^.opcode = A_SCAS) or
                             (pai386(hp)^.opcode = A_STOS) or
                             (pai386(hp)^.opcode = A_MOVS) or
                             (pai386(hp)^.opcode = A_LODS) or
                             (pai386(hp)^.opcode = A_XLAT)) then
                           Begin
                             case pai386(hp)^.opsize of
                              S_B: suffix:='b';
                              S_W: suffix:='w';
                              S_L: suffix:='d';
                             else
                              Message(assem_f_invalid_suffix_intel);
                             end;
                           end; }
                          s:='';
                        end;
                       AsmWriteLn(#9#9+prefix+int_op2str[pai386(hp)^.opcode]+cond2str[pai386_labeled(hp)^.condition]+suffix+s);
{$else}
                     { added prefix instructions, must be on same line as opcode }
                       if (pai386(hp)^.op1t = top_none) and
                          ((pai386(hp)^.opcode = A_REP) or
                           (pai386(hp)^.opcode = A_LOCK) or
                           (pai386(hp)^.opcode =  A_REPE) or
                           (pai386(hp)^.opcode = A_REPNE)) then
                        Begin
                          prefix:=int_op2str[pai386(hp)^.opcode]+#9;
                          hp:=Pai(hp^.next);
                        { this is theorically impossible... }
                          if hp=nil then
                           begin
                             s:=#9#9+prefix;
                             AsmWriteLn(s);
                             break;
                           end;
                        end
                       else
                        prefix:= '';
                       if pai386(hp)^.op1t<>top_none then
                        begin
                          if pai386(hp)^.opcode=A_CALL then
                           begin
                           { with tasm call near ptr [edi+12] does not
                             work but call near [edi+12] works ?? (PM)

                             It works with call dword ptr [], but you
                             need /m2 (2 passes) with tasm (PFV)
                           }
{                                    if pai386(hp)^.op1t=top_ref then
                              s:='near '+getopstr_jmp(pai386(hp)^.op1t,pai386(hp)^.op1)
                             else
                              s:='near ptr '+getopstr_jmp(pai386(hp)^.op1t,pai386(hp)^.op1);}
                             s:='dword ptr '+getopstr_jmp(pai386(hp)^.op1t,pai386(hp)^.op1,pai386(hp)^.op1ofs);
                           end
                          else
                           begin
                             s:=getopstr(pai386(hp)^.op1t,pai386(hp)^.op1,pai386(hp)^.op1ofs,pai386(hp)^.opsize,
                               pai386(hp)^.opcode,false);
                             if pai386(hp)^.op3t<>top_none then
                              begin
                                if pai386(hp)^.op2t<>top_none then
                                 s:=getopstr(pai386(hp)^.op2t,pointer(longint(twowords(pai386(hp)^.op2).word1)),0,
                                             pai386(hp)^.opsize,pai386(hp)^.opcode,true)+','+s;
                                s:=getopstr(pai386(hp)^.op3t,pointer(longint(twowords(pai386(hp)^.op2).word2)),0,
                                            pai386(hp)^.opsize,pai386(hp)^.opcode,false)+','+s;
                              end
                             else
                              if pai386(hp)^.op2t<>top_none then
                               s:=getopstr(pai386(hp)^.op2t,pai386(hp)^.op2,0,pai386(hp)^.opsize,
                                           pai386(hp)^.opcode,true)+','+s;
                           end;
                          s:=#9+s;
                        end
                       else
                        begin
                          { check if string instruction }
                          { long form, otherwise may give range check errors }
                          { in turbo pascal...                               }
                          if ((pai386(hp)^.opcode = A_CMPS) or
                             (pai386(hp)^.opcode = A_INS) or
                             (pai386(hp)^.opcode = A_OUTS) or
                             (pai386(hp)^.opcode = A_SCAS) or
                             (pai386(hp)^.opcode = A_STOS) or
                             (pai386(hp)^.opcode = A_MOVS) or
                             (pai386(hp)^.opcode = A_LODS) or
                             (pai386(hp)^.opcode = A_XLAT)) then
                           Begin
                             case pai386(hp)^.opsize of
                              S_B: suffix:='b';
                              S_W: suffix:='w';
                              S_L: suffix:='d';
                             else
                              Message(assem_f_invalid_suffix_intel);
                             end;
                           end;
                          s:='';
                        end;
                       AsmWriteLn(#9#9+prefix+int_op2str[pai386(hp)^.opcode]+suffix+s);
{$endif AG386BIN}
                     end;
{$ifdef GDB}
             ait_stabn,
             ait_stabs,
        ait_force_line,
ait_stab_function_name : ;
{$endif GDB}
           ait_cut : begin
                     { only reset buffer if nothing has changed }
                       if AsmSize=AsmStartSize then
                        AsmClear
                       else
                        begin
                          if LastSec<>sec_none then
                           AsmWriteLn('_'+ait_section2masmstr[LastSec]+#9#9'ENDS');
                          AsmLn;
                          AsmWriteLn(#9'END');
                          AsmClose;
                          DoAssemble;
                          if pai_cut(hp)^.EndName then
                           IsEndFile:=true;
                          AsmCreate;
                        end;
                     { avoid empty files }
                       while assigned(hp^.next) and (pai(hp^.next)^.typ in [ait_cut,ait_section,ait_comment]) do
                        begin
                          if pai(hp^.next)^.typ=ait_section then
                           begin
                             lastsec:=pai_section(hp^.next)^.sec;
                           end;
                          hp:=pai(hp^.next);
                        end;
                       AsmWriteLn(#9'.386p');
                       AsmWriteLn(#9'LOCALS '+target_asm.labelprefix);
                       if lastsec<>sec_none then
                          AsmWriteLn('_'+ait_section2masmstr[lastsec]+#9#9+
                                     'SEGMENT'#9'PARA PUBLIC USE32 '''+
                                     ait_section2masmstr[lastsec]+'''');
                       AsmStartSize:=AsmSize;
                     end;
             ait_marker: ;
         else
          internalerror(10000);
         end;
         hp:=pai(hp^.next);
       end;
    end;


    procedure ti386intasmlist.WriteAsmList;

    begin
{$ifdef EXTDEBUG}
      if assigned(current_module^.mainsource) then
       comment(v_info,'Start writing intel-styled assembler output for '+current_module^.mainsource^);
{$endif}
      LastSec:=sec_none;
      AsmWriteLn(#9'.386p');
      AsmWriteLn(#9'LOCALS '+target_asm.labelprefix);
      AsmWriteLn('DGROUP'#9'GROUP'#9'_BSS,_DATA');
      AsmWriteLn(#9'ASSUME'#9'CS:_CODE,ES:DGROUP,DS:DGROUP,SS:DGROUP');
      AsmLn;

      countlabelref:=false;
      WriteTree(externals);
    { INTEL ASM doesn't support stabs
      WriteTree(debuglist);}

      WriteTree(codesegment);
      WriteTree(datasegment);
      WriteTree(consts);
      WriteTree(rttilist);
      WriteTree(bsssegment);
      countlabelref:=true;

      AsmWriteLn(#9'END');
      AsmLn;

{$ifdef EXTDEBUG}
      if assigned(current_module^.mainsource) then
       comment(v_info,'Done writing intel-styled assembler output for '+current_module^.mainsource^);
{$endif EXTDEBUG}
   end;

end.
{
  $Log$
  Revision 1.30  1999-03-29 16:05:43  peter
    * optimizer working for ag386bin

  Revision 1.29  1999/03/02 02:56:10  peter
    + stabs support for binary writers
    * more fixes and missing updates from the previous commit :(

  Revision 1.28  1999/03/01 15:46:16  peter
    * ag386bin finally make cycles correct
    * prefixes are now also normal opcodes

  Revision 1.27  1999/02/26 00:48:13  peter
    * assembler writers fixed for ag386bin

  Revision 1.26  1999/02/25 21:02:18  peter
    * ag386bin updates
    + coff writer

  Revision 1.25  1999/02/22 02:14:59  peter
    * updates for ag386bin

  Revision 1.24  1998/12/20 16:21:22  peter
    * smartlinking doesn't crash anymore

  Revision 1.23  1998/12/16 00:27:17  peter
    * removed some obsolete version checks

  Revision 1.22  1998/12/01 11:19:38  peter
    * fixed range problem with in [tasmop]

  Revision 1.21  1998/11/30 09:42:55  pierre
    * some range check bugs fixed (still not working !)
    + added DLL writing support for win32 (also accepts variables)
    + TempAnsi for code that could be used for Temporary ansi strings
      handling

  Revision 1.20  1998/11/17 00:26:09  peter
    * fixed for $H+

  Revision 1.19  1998/11/16 12:38:05  jonas
    + readded ait_marker support

  Revision 1.18  1998/11/12 11:19:33  pierre
   * fix for first line of function break

  Revision 1.17  1998/10/12 12:20:40  pierre
    + added tai_const_symbol_offset
      for r : pointer = @var.field;
    * better message for different arg names on implementation
      of function

  Revision 1.16  1998/10/06 17:16:33  pierre
    * some memory leaks fixed (thanks to Peter for heaptrc !)

  Revision 1.15  1998/10/01 20:19:06  jonas
    + ait_marker support

  Revision 1.14  1998/09/20 17:11:21  jonas
    * released REGALLOC

  Revision 1.13  1998/08/10 15:49:38  peter
    * small fixes for 0.99.5

  Revision 1.12  1998/08/08 10:19:17  florian
    * small fixes to write the extended type correct

  Revision 1.11  1998/06/05 17:46:02  peter
    * tp doesn't like comp() typecast

  Revision 1.10  1998/05/25 17:11:36  pierre
    * firstpasscount bug fixed
      now all is already set correctly the first time
      under EXTDEBUG try -gp to skip all other firstpasses
      it works !!
    * small bug fixes
      - for smallsets with -dTESTSMALLSET
      - some warnings removed (by correcting code !)

  Revision 1.9  1998/05/23 01:20:55  peter
    + aktasmmode, aktoptprocessor, aktoutputformat
    + smartlink per module $SMARTLINK-/+ (like MMX) and moved to aktswitches
    + $LIBNAME to set the library name where the unit will be put in
    * splitted cgi386 a bit (codeseg to large for bp7)
    * nasm, tasm works again. nasm moved to ag386nsm.pas

  Revision 1.8  1998/05/06 18:36:53  peter
    * tai_section extended with code,data,bss sections and enumerated type
    * ident 'compiled by FPC' moved to pmodules
    * small fix for smartlink

  Revision 1.7  1998/05/06 08:38:32  pierre
    * better position info with UseTokenInfo
      UseTokenInfo greatly simplified
    + added check for changed tree after first time firstpass
      (if we could remove all the cases were it happen
      we could skip all firstpass if firstpasscount > 1)
      Only with ExtDebug

  Revision 1.6  1998/05/04 17:54:24  peter
    + smartlinking works (only case jumptable left todo)
    * redesign of systems.pas to support assemblers and linkers
    + Unitname is now also in the PPU-file, increased version to 14

  Revision 1.5  1998/05/01 07:43:52  florian
    + basics for rtti implemented
    + switch $m (generate rtti for published sections)

  Revision 1.4  1998/04/29 10:33:41  pierre
    + added some code for ansistring (not complete nor working yet)
    * corrected operator overloading
    * corrected nasm output
    + started inline procedures
    + added starstarn : use ** for exponentiation (^ gave problems)
    + started UseTokenInfo cond to get accurate positions

  Revision 1.3  1998/04/08 16:58:01  pierre
    * several bugfixes
      ADD ADC and AND are also sign extended
      nasm output OK (program still crashes at end
      and creates wrong assembler files !!)
      procsym types sym in tdef removed !!

  Revision 1.2  1998/04/08 11:34:17  peter
    * nasm works (linux only tested)
}
