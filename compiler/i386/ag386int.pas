{
    $Id$
    Copyright (c) 1998-2000 by Florian Klaempfl

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
unit ag386int;

{$i defines.inc}

interface

    uses aasm,assemble;

    type
      pi386intasmlist=^ti386intasmlist;
      ti386intasmlist = object(tasmlist)
        procedure WriteTree(p:TAAsmoutput);virtual;
        procedure WriteAsmList;virtual;
        procedure WriteExternals;
      end;

  implementation

    uses
{$ifdef delphi}
      sysutils,
{$endif}
      cutils,globtype,globals,systems,cobjects,
      verbose,cpubase,cpuasm,finput,fmodule
      ;

    const
      line_length = 70;

    function single2str(d : single) : string;
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
         single2str:=lower(hs);
      end;

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
{$ifdef FPC}
         c:=comp(d);
{$else}
         c:=d;
{$endif}
         dd:=pdouble(@c); { this makes a bitwise copy of c into a double }
         comp2str:=double2str(dd^);
      end;

    function getreferencestring(var ref : treference) : string;
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
          inc(offset,offsetfixup);
          offsetfixup:=0;
          if ref.segment<>R_NO then
           s:=int_reg2str[segment]+':['
          else
           s:='[';
         if assigned(symbol) then
          begin
            if (aktoutputformat = as_i386_tasm) then
              s:=s+'dword ptr ';
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
            if assigned(o.sym) then
              hs:='offset '+o.sym^.name
            else
              hs:='offset ';
            if o.symofs>0 then
             hs:=hs+'+'+tostr(o.symofs)
            else
             if o.symofs<0 then
              hs:=hs+tostr(o.symofs)
            else
             if not(assigned(o.sym)) then
               hs:=hs+'0';
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

    function getopstr_jmp(const o:toper;s : topsize) : string;
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
          { what about lcall or ljmp ??? }
          begin
            if (aktoutputformat = as_i386_tasm) then
              hs:=''
            else
              begin
                if s=S_FAR then
                  hs:='far ptr '
                else
                  hs:='near ptr ';
              end;
            getopstr_jmp:=hs+getreferencestring(o.ref^);
          end;
        else
          internalerror(10001);
      end;
    end;

   function fixline(s:string):string;
   {
     return s with all leading and ending spaces and tabs removed
   }
     var
       i,j,k : longint;
     begin
       i:=length(s);
       while (i>0) and (s[i] in [#9,' ']) do
        dec(i);
       j:=1;
       while (j<i) and (s[j] in [#9,' ']) do
        inc(j);
       for k:=j to i do
        if s[k] in [#0..#31,#127..#255] then
         s[k]:='.';
       fixline:=Copy(s,j,i-j+1);
     end;


{****************************************************************************
                               TI386INTASMLIST
 ****************************************************************************}

    var
      LastSec : tsection;
      lastfileinfo : tfileposinfo;
      infile,
      lastinfile   : tinputfile;

    const
      ait_const2str:array[ait_const_32bit..ait_const_8bit] of string[8]=
        (#9'DD'#9,#9'DW'#9,#9'DB'#9);

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

    procedure ti386intasmlist.WriteTree(p:TAAsmoutput);
    const
      allocstr : array[boolean] of string[10]=(' released',' allocated');
    var
      s,
      prefix,
      suffix   : string;
      hp       : tai;
      counter,
      lines,
      InlineLevel : longint;
      i,j,l    : longint;
      consttyp : tait;
      found,
      do_line,
      quoted   : boolean;
      sep      : char;
    begin
      if not assigned(p) then
       exit;
      { lineinfo is only needed for codesegment (PFV) }
      do_line:=((cs_asm_source in aktglobalswitches) or
                (cs_lineinfo in aktmoduleswitches))
                 and (p=codesegment);
      InlineLevel:=0;
      hp:=tai(p.first);
      while assigned(hp) do
       begin
         if do_line then
           begin
           { load infile }
             if lastfileinfo.fileindex<>hp.fileinfo.fileindex then
              begin
                infile:=current_module.sourcefiles.get_file(hp.fileinfo.fileindex);
                if assigned(infile) then
                 begin
                   { open only if needed !! }
                   if (cs_asm_source in aktglobalswitches) then
                    infile.open;
                 end;
                { avoid unnecessary reopens of the same file !! }
                lastfileinfo.fileindex:=hp.fileinfo.fileindex;
                { be sure to change line !! }
                lastfileinfo.line:=-1;
              end;
           { write source }
             if (cs_asm_source in aktglobalswitches) and
                assigned(infile) then
              begin
                if (infile<>lastinfile) then
                  begin
                    AsmWriteLn(target_asm.comment+'['+infile.name^+']');
                    if assigned(lastinfile) then
                      lastinfile.close;
                  end;
                if (hp.fileinfo.line<>lastfileinfo.line) and
                   ((hp.fileinfo.line<infile.maxlinebuf) or (InlineLevel>0)) then
                  begin
                    if (hp.fileinfo.line<>0) and
                       ((infile.linebuf^[hp.fileinfo.line]>=0) or (InlineLevel>0)) then
                      AsmWriteLn(target_asm.comment+'['+tostr(hp.fileinfo.line)+'] '+
                        fixline(infile.GetLineStr(hp.fileinfo.line)));
                    { set it to a negative value !
                    to make that is has been read already !! PM }
                    if (infile.linebuf^[hp.fileinfo.line]>=0) then
                      infile.linebuf^[hp.fileinfo.line]:=-infile.linebuf^[hp.fileinfo.line]-1;
                  end;
              end;
             lastfileinfo:=hp.fileinfo;
             lastinfile:=infile;
           end;
         case hp.typ of
       ait_comment : Begin
                       AsmWrite(target_asm.comment);
                       AsmWritePChar(tai_asm_comment(hp).str);
                       AsmLn;
                     End;
       ait_regalloc,
       ait_tempalloc : ;
       ait_section : begin
                       if LastSec<>sec_none then
                        AsmWriteLn('_'+target_asm.secnames[LastSec]+#9#9'ENDS');
                       if tai_section(hp).sec<>sec_none then
                        begin
                          AsmLn;
                          AsmWriteLn('_'+target_asm.secnames[tai_section(hp).sec]+#9#9+
                                     'SEGMENT'#9'PARA PUBLIC USE32 '''+
                                     target_asm.secnames[tai_section(hp).sec]+'''');
                        end;
                       LastSec:=tai_section(hp).sec;
                     end;
         ait_align : begin
                     { CAUSES PROBLEMS WITH THE SEGMENT DEFINITION   }
                     { SEGMENT DEFINITION SHOULD MATCH TYPE OF ALIGN }
                     { HERE UNDER TASM!                              }
                       AsmWriteLn(#9'ALIGN '+tostr(tai_align(hp).aligntype));
                     end;
     ait_datablock : begin
                       if tai_datablock(hp).is_global then
                         AsmWriteLn(#9'PUBLIC'#9+tai_datablock(hp).sym^.name);
                       AsmWriteLn(PadTabs(tai_datablock(hp).sym^.name,#0)+'DB'#9+tostr(tai_datablock(hp).size)+' DUP(?)');
                     end;
   ait_const_32bit,
    ait_const_8bit,
   ait_const_16bit : begin
                       AsmWrite(ait_const2str[hp.typ]+tostr(tai_const(hp).value));
                       consttyp:=hp.typ;
                       l:=0;
                       repeat
                         found:=(not (tai(hp.next)=nil)) and (tai(hp.next).typ=consttyp);
                         if found then
                          begin
                            hp:=tai(hp.next);
                            s:=','+tostr(tai_const(hp).value);
                            AsmWrite(s);
                            inc(l,length(s));
                          end;
                       until (not found) or (l>line_length);
                       AsmLn;
                     end;
  ait_const_symbol : begin
                       AsmWriteLn(#9#9'DD'#9'offset '+tai_const_symbol(hp).sym^.name);
                       if tai_const_symbol(hp).offset>0 then
                         AsmWrite('+'+tostr(tai_const_symbol(hp).offset))
                       else if tai_const_symbol(hp).offset<0 then
                         AsmWrite(tostr(tai_const_symbol(hp).offset));
                       AsmLn;
                     end;
     ait_const_rva : begin
                       AsmWriteLn(#9#9'RVA'#9+tai_const_symbol(hp).sym^.name);
                     end;
        ait_real_32bit : AsmWriteLn(#9#9'DD'#9+single2str(tai_real_32bit(hp).value));
        ait_real_64bit : AsmWriteLn(#9#9'DQ'#9+double2str(tai_real_64bit(hp).value));
      ait_real_80bit : AsmWriteLn(#9#9'DT'#9+extended2str(tai_real_80bit(hp).value));
          ait_comp_64bit : AsmWriteLn(#9#9'DQ'#9+comp2str(tai_real_80bit(hp).value));
        ait_string : begin
                       counter := 0;
                       lines := tai_string(hp).len div line_length;
                     { separate lines in different parts }
                       if tai_string(hp).len > 0 then
                        Begin
                          for j := 0 to lines-1 do
                           begin
                             AsmWrite(#9#9'DB'#9);
                             quoted:=false;
                             for i:=counter to counter+line_length do
                                begin
                                  { it is an ascii character. }
                                  if (ord(tai_string(hp).str[i])>31) and
                                     (ord(tai_string(hp).str[i])<128) and
                                     (tai_string(hp).str[i]<>'"') then
                                      begin
                                        if not(quoted) then
                                            begin
                                              if i>counter then
                                                AsmWrite(',');
                                              AsmWrite('"');
                                            end;
                                        AsmWrite(tai_string(hp).str[i]);
                                        quoted:=true;
                                      end { if > 31 and < 128 and ord('"') }
                                  else
                                      begin
                                          if quoted then
                                              AsmWrite('"');
                                          if i>counter then
                                              AsmWrite(',');
                                          quoted:=false;
                                          AsmWrite(tostr(ord(tai_string(hp).str[i])));
                                      end;
                               end; { end for i:=0 to... }
                             if quoted then AsmWrite('"');
                               AsmWrite(target_os.newline);
                             counter := counter+line_length;
                          end; { end for j:=0 ... }
                        { do last line of lines }
                        AsmWrite(#9#9'DB'#9);
                        quoted:=false;
                        for i:=counter to tai_string(hp).len-1 do
                          begin
                            { it is an ascii character. }
                            if (ord(tai_string(hp).str[i])>31) and
                               (ord(tai_string(hp).str[i])<128) and
                               (tai_string(hp).str[i]<>'"') then
                                begin
                                  if not(quoted) then
                                      begin
                                        if i>counter then
                                          AsmWrite(',');
                                        AsmWrite('"');
                                      end;
                                  AsmWrite(tai_string(hp).str[i]);
                                  quoted:=true;
                                end { if > 31 and < 128 and " }
                            else
                                begin
                                  if quoted then
                                    AsmWrite('"');
                                  if i>counter then
                                      AsmWrite(',');
                                  quoted:=false;
                                  AsmWrite(tostr(ord(tai_string(hp).str[i])));
                                end;
                          end; { end for i:=0 to... }
                        if quoted then
                          AsmWrite('"');
                        end;
                       AsmLn;
                     end;
         ait_label : begin
                       if tai_label(hp).l^.is_used then
                        begin
                          AsmWrite(tai_label(hp).l^.name);
                          if assigned(hp.next) and not(tai(hp.next).typ in
                             [ait_const_32bit,ait_const_16bit,ait_const_8bit,
                              ait_const_symbol,ait_const_rva,
                              ait_real_32bit,ait_real_64bit,ait_real_80bit,ait_comp_64bit,ait_string]) then
                           AsmWriteLn(':');
                        end;
                     end;
        ait_direct : begin
                       AsmWritePChar(tai_direct(hp).str);
                       AsmLn;
                     end;
        ait_symbol : begin
                       if tai_symbol(hp).is_global then
                         AsmWriteLn(#9'PUBLIC'#9+tai_symbol(hp).sym^.name);
                       AsmWrite(tai_symbol(hp).sym^.name);
                       if assigned(hp.next) and not(tai(hp.next).typ in
                          [ait_const_32bit,ait_const_16bit,ait_const_8bit,
                           ait_const_symbol,ait_const_rva,
                           ait_real_32bit,ait_real_64bit,ait_real_80bit,ait_comp_64bit,ait_string]) then
                        AsmWriteLn(':')
                     end;
    ait_symbol_end : begin
                     end;
   ait_instruction : begin
                     { Must be done with args in ATT order }
                       taicpu(hp).SetOperandOrder(op_att);
                       taicpu(hp).CheckNonCommutativeOpcodes;
                     { We need intel order, no At&t }
                       taicpu(hp).SetOperandOrder(op_intel);
                     { Reset }
                       suffix:='';
                       prefix:= '';
                       s:='';
                      { We need to explicitely set
                        word prefix to get selectors
                        to be pushed in 2 bytes  PM }
                      if (taicpu(hp).opsize=S_W) and
                         ((taicpu(hp).opcode=A_PUSH) or
                          (taicpu(hp).opcode=A_POP)) and
                          (taicpu(hp).oper[0].typ=top_reg) and
                          ((taicpu(hp).oper[0].reg>=firstsreg) and
                           (taicpu(hp).oper[0].reg<=lastsreg)) then
                        AsmWriteln(#9#9'DB'#9'066h');
                     { added prefix instructions, must be on same line as opcode }
                       if (taicpu(hp).ops = 0) and
                          ((taicpu(hp).opcode = A_REP) or
                           (taicpu(hp).opcode = A_LOCK) or
                           (taicpu(hp).opcode =  A_REPE) or
                           (taicpu(hp).opcode =  A_REPNZ) or
                           (taicpu(hp).opcode =  A_REPZ) or
                           (taicpu(hp).opcode = A_REPNE)) then
                        Begin
                          prefix:=int_op2str[taicpu(hp).opcode]+#9;
                          hp:=tai(hp.next);
                        { this is theorically impossible... }
                          if hp=nil then
                           begin
                             s:=#9#9+prefix;
                             AsmWriteLn(s);
                             break;
                           end;
                          { nasm prefers prefix on a line alone
                          AsmWriteln(#9#9+prefix); but not masm PM
                          prefix:=''; }
                        end
                       else
                        prefix:= '';
                       if taicpu(hp).ops<>0 then
                        begin
                          if is_calljmp(taicpu(hp).opcode) then
                           s:=#9+getopstr_jmp(taicpu(hp).oper[0],taicpu(hp).opsize)
                          else
                           begin
                             for i:=0to taicpu(hp).ops-1 do
                              begin
                                if i=0 then
                                 sep:=#9
                                else
                                 sep:=',';
                                s:=s+sep+getopstr(taicpu(hp).oper[i],taicpu(hp).opsize,taicpu(hp).opcode,(i=2));
                              end;
                           end;
                        end;
                       AsmWriteLn(#9#9+prefix+int_op2str[taicpu(hp).opcode]+cond2str[taicpu(hp).condition]+suffix+s);
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
                           AsmWriteLn('_'+target_asm.secnames[LastSec]+#9#9'ENDS');
                          AsmLn;
                          AsmWriteLn(#9'END');
                          AsmClose;
                          DoAssemble;
                          AsmCreate(tai_cut(hp).place);
                        end;
                     { avoid empty files }
                       while assigned(hp.next) and (tai(hp.next).typ in [ait_cut,ait_section,ait_comment]) do
                        begin
                          if tai(hp.next).typ=ait_section then
                           begin
                             lastsec:=tai_section(hp.next).sec;
                           end;
                          hp:=tai(hp.next);
                        end;
                       AsmWriteLn(#9'.386p');
                       { I was told that this isn't necesarry because }
                       { the labels generated by FPC are unique (FK)  }
                       { AsmWriteLn(#9'LOCALS '+target_asm.labelprefix); }
                       if lastsec<>sec_none then
                          AsmWriteLn('_'+target_asm.secnames[lastsec]+#9#9+
                                     'SEGMENT'#9'PARA PUBLIC USE32 '''+
                                     target_asm.secnames[lastsec]+'''');
                       AsmStartSize:=AsmSize;
                     end;
           ait_marker :
             begin
               if tai_marker(hp).kind=InlineStart then
                 inc(InlineLevel)
               else if tai_marker(hp).kind=InlineEnd then
                 dec(InlineLevel);
             end;
         else
          internalerror(10000);
         end;
         hp:=tai(hp.next);
       end;
    end;

    var
      currentasmlist : PAsmList;

    procedure writeexternal(p:pnamedindexobject);
      begin
        if pasmsymbol(p)^.defbind=AB_EXTERNAL then
          begin
            if (aktoutputformat = as_i386_masm) then
              currentasmlist^.AsmWriteln(#9'EXTRN'#9+p^.name
                +': NEAR')
            else
              currentasmlist^.AsmWriteln(#9'EXTRN'#9+p^.name);
          end;
      end;

    procedure ti386intasmlist.WriteExternals;
      begin
        currentasmlist:=@self;
        AsmSymbolList^.foreach({$ifdef fpcprocvar}@{$endif}writeexternal);
      end;


    procedure ti386intasmlist.WriteAsmList;
    begin
{$ifdef EXTDEBUG}
      if assigned(current_module.mainsource) then
       comment(v_info,'Start writing intel-styled assembler output for '+current_module.mainsource^);
{$endif}
      LastSec:=sec_none;
      AsmWriteLn(#9'.386p');
      { masm 6.11 does not seem to like LOCALS PM }
      if (aktoutputformat = as_i386_tasm) then
        begin
          AsmWriteLn(#9'LOCALS '+target_asm.labelprefix);
        end;
      AsmWriteLn('DGROUP'#9'GROUP'#9'_BSS,_DATA');
      AsmWriteLn(#9'ASSUME'#9'CS:_CODE,ES:DGROUP,DS:DGROUP,SS:DGROUP');
      AsmLn;

      countlabelref:=false;

      WriteExternals;

    { INTEL ASM doesn't support stabs
      WriteTree(debuglist);}

      WriteTree(codesegment);
      WriteTree(datasegment);
      WriteTree(consts);
      WriteTree(rttilist);
      WriteTree(resourcestringlist);
      WriteTree(bsssegment);
      countlabelref:=true;

      AsmWriteLn(#9'END');
      AsmLn;

{$ifdef EXTDEBUG}
      if assigned(current_module.mainsource) then
       comment(v_info,'Done writing intel-styled assembler output for '+current_module.mainsource^);
{$endif EXTDEBUG}
   end;

end.
{
  $Log$
  Revision 1.6  2001-02-20 21:36:39  peter
    * tasm/masm fixes merged

  Revision 1.5  2001/01/13 20:24:24  peter
    * fixed operand order that got mixed up for external writers after
      my previous assembler block valid instruction check

  Revision 1.4  2000/12/25 00:07:31  peter
    + new tlinkedlist class (merge of old tstringqueue,tcontainer and
      tlinkedlist objects)

  Revision 1.3  2000/12/18 21:56:52  peter
    * extdebug fixes

  Revision 1.2  2000/11/29 00:30:43  florian
    * unused units removed from uses clause
    * some changes for widestrings

  Revision 1.1  2000/10/15 09:47:42  peter
    * moved to i386/

  Revision 1.6  2000/09/24 15:06:10  peter
    * use defines.inc

  Revision 1.5  2000/08/27 16:11:49  peter
    * moved some util functions from globals,cobjects to cutils
    * splitted files into finput,fmodule

  Revision 1.4  2000/08/20 17:38:21  peter
    * smartlinking fixed for linux (merged)

  Revision 1.3  2000/07/13 12:08:24  michael
  + patched to 1.1.0 with former 1.09patch from peter

  Revision 1.2  2000/07/13 11:32:30  michael
  + removed logs

}
