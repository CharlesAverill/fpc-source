{
    $Id$
    Copyright (c) 1998-2002 by the Free Pascal team

    This unit implements generic GNU assembler (v2.8 or later)

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
{ Base unit for writing GNU assembler output.
}
unit aggas;

{$i fpcdefs.inc}

interface

    uses
      cclasses,
      globals,
      aasmbase,aasmtai,aasmcpu,
      assemble;


    type
      {# This is a derived class which is used to write
         GAS styled assembler.

         The WriteInstruction() method must be overriden
         to write a single instruction to the assembler
         file.
      }
      TGNUAssembler=class(texternalassembler)
      public
        procedure WriteTree(p:TAAsmoutput);override;
        procedure WriteAsmList;override;
        procedure WriteExtraHeader;virtual;
{$ifdef GDB}
        procedure WriteFileLineInfo(var fileinfo : tfileposinfo);
        procedure WriteFileEndInfo;
{$endif}
        procedure WriteInstruction(hp: tai);  virtual; abstract;
      end;

    const
      regname_count=45;
      regname_count_bsstart=32;   {Largest power of 2 out of regname_count.}


implementation

    uses
{$ifdef Delphi}
      dmisc,
{$else Delphi}
      dos,
{$endif Delphi}
      cutils,globtype,systems,
      fmodule,finput,verbose,cpubase,
      itcpugas
{$ifdef GDB}
  {$ifdef delphi}
      ,sysutils
  {$else}
      ,strings
  {$endif}
      ,gdb
{$endif GDB}
      ;

    const
      line_length = 70;

var
{$ifdef GDB}
      n_line       : byte;     { different types of source lines }
      linecount,
      includecount : longint;
      funcname     : pchar;
      stabslastfileinfo : tfileposinfo;
{$endif}
      lasTSec      : TSection; { last section type written }
      lastfileinfo : tfileposinfo;
      infile,
      lastinfile   : tinputfile;
      symendcount  : longint;

    type
      t80bitarray = array[0..9] of byte;
      t64bitarray = array[0..7] of byte;
      t32bitarray = array[0..3] of byte;

{****************************************************************************}
{                          Support routines                                  }
{****************************************************************************}

   function fixline(s:string):string;
   {
     return s with all leading and ending spaces and tabs removed
   }
     var
       i,j,k : integer;
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

    function single2str(d : single) : string;
      var
         hs : string;
      begin
         str(d,hs);
      { replace space with + }
         if hs[1]=' ' then
          hs[1]:='+';
         single2str:='0d'+hs
      end;

    function double2str(d : double) : string;
      var
         hs : string;
      begin
         str(d,hs);
      { replace space with + }
         if hs[1]=' ' then
          hs[1]:='+';
         double2str:='0d'+hs
      end;

    function extended2str(e : extended) : string;
      var
         hs : string;
      begin
         str(e,hs);
      { replace space with + }
         if hs[1]=' ' then
          hs[1]:='+';
         extended2str:='0d'+hs
      end;


  { convert floating point values }
  { to correct endian             }
  procedure swap64bitarray(var t: t64bitarray);
    var
     b: byte;
    begin
      b:= t[7];
      t[7] := t[0];
      t[0] := b;

      b := t[6];
      t[6] := t[1];
      t[1] := b;

      b:= t[5];
      t[5] := t[2];
      t[2] := b;

      b:= t[4];
      t[4] := t[3];
      t[3] := b;
   end;


   procedure swap32bitarray(var t: t32bitarray);
    var
     b: byte;
    begin
      b:= t[1];
      t[1]:= t[2];
      t[2]:= b;

      b:= t[0];
      t[0]:= t[3];
      t[3]:= b;
    end;


    const
      ait_const2str : array[ait_const_32bit..ait_const_8bit] of string[8]=
       (#9'.long'#9,#9'.short'#9,#9'.byte'#9);


    function ait_section2str(s:TSection):string;
    begin
       ait_section2str:=target_asm.secnames[s];
{$ifdef GDB}
       { this is needed for line info in data }
       funcname:=nil;
       case s of
         sec_code : n_line:=n_textline;
         sec_data : n_line:=n_dataline;
         sec_bss  : n_line:=n_bssline;
         else       n_line:=n_dataline;
      end;
{$endif GDB}
      LasTSec:=s;
    end;

{****************************************************************************}
{                          GNU Assembler writer                              }
{****************************************************************************}

{$ifdef GDB}
      procedure TGNUAssembler.WriteFileLineInfo(var fileinfo : tfileposinfo);
        var
          curr_n : byte;
        begin
          if not ((cs_debuginfo in aktmoduleswitches) or
             (cs_gdb_lineinfo in aktglobalswitches)) then
           exit;
        { file changed ? (must be before line info) }
          if (fileinfo.fileindex<>0) and
             (stabslastfileinfo.fileindex<>fileinfo.fileindex) then
           begin
             infile:=current_module.sourcefiles.get_file(fileinfo.fileindex);
             if assigned(infile) then
              begin
                if includecount=0 then
                 curr_n:=n_sourcefile
                else
                 curr_n:=n_includefile;
                if (infile.path^<>'') then
                 begin
                   AsmWriteLn(#9'.stabs "'+lower(BsToSlash(FixPath(infile.path^,false)))+'",'+
                     tostr(curr_n)+',0,0,'+target_asm.labelprefix+'text'+ToStr(IncludeCount));
                 end;
                AsmWriteLn(#9'.stabs "'+lower(FixFileName(infile.name^))+'",'+
                  tostr(curr_n)+',0,0,'+target_asm.labelprefix+'text'+ToStr(IncludeCount));
                AsmWriteLn(target_asm.labelprefix+'text'+ToStr(IncludeCount)+':');
                inc(includecount);
                { force new line info }
                stabslastfileinfo.line:=-1;
              end;
           end;
        { line changed ? }
          if (stabslastfileinfo.line<>fileinfo.line) and (fileinfo.line<>0) then
           begin
             if (n_line=n_textline) and assigned(funcname) and
                (target_info.use_function_relative_addresses) then
              begin
                AsmWriteLn(target_asm.labelprefix+'l'+tostr(linecount)+':');
                AsmWrite(#9'.stabn '+tostr(n_line)+',0,'+tostr(fileinfo.line)+','+
                           target_asm.labelprefix+'l'+tostr(linecount)+' - ');
                AsmWritePChar(FuncName);
                AsmLn;
                inc(linecount);
              end
             else
              AsmWriteLn(#9'.stabd'#9+tostr(n_line)+',0,'+tostr(fileinfo.line));
           end;
          stabslastfileinfo:=fileinfo;
        end;

      procedure TGNUAssembler.WriteFileEndInfo;

        begin
          if not ((cs_debuginfo in aktmoduleswitches) or
             (cs_gdb_lineinfo in aktglobalswitches)) then
           exit;
          AsmLn;
          AsmWriteLn(ait_section2str(sec_code));
          AsmWriteLn(#9'.stabs "",'+tostr(n_sourcefile)+',0,0,'+target_asm.labelprefix+'etext');
          AsmWriteLn(target_asm.labelprefix+'etext:');
        end;

{$endif GDB}


    procedure TGNUAssembler.WriteTree(p:TAAsmoutput);
    const
      allocstr : array[boolean] of string[10]=(' released',' allocated');
    var
      ch       : char;
      hp       : tai;
      hp1      : tailineinfo;
      consttyp : taitype;
      s        : string;
      found    : boolean;
      i,pos,l  : longint;
      InlineLevel : longint;
      last_align : longint;
      co       : comp;
      sin      : single;
      d        : double;
{$ifdef cpuextended}
      e        : extended;
{$endif cpuextended}
      do_line  : boolean;
    begin
      if not assigned(p) then
       exit;
      last_align := 2;
      InlineLevel:=0;
      { lineinfo is only needed for codesegment (PFV) }
      do_line:=(cs_asm_source in aktglobalswitches) or
               ((cs_lineinfo in aktmoduleswitches)
                 and (p=codesegment));
      hp:=tai(p.first);
      while assigned(hp) do
       begin

         if not(hp.typ in SkipLineInfo) then
          begin
            hp1 := hp as tailineinfo;
            aktfilepos:=hp1.fileinfo;
{$ifdef GDB}
             { write stabs }
             if (cs_debuginfo in aktmoduleswitches) or
                (cs_gdb_lineinfo in aktglobalswitches) then
               WriteFileLineInfo(hp1.fileinfo);
{$endif GDB}
             { no line info for inlined code }
             if do_line and (inlinelevel=0) then
              begin
                { load infile }
                if lastfileinfo.fileindex<>hp1.fileinfo.fileindex then
                 begin
                   infile:=current_module.sourcefiles.get_file(hp1.fileinfo.fileindex);
                   if assigned(infile) then
                    begin
                      { open only if needed !! }
                      if (cs_asm_source in aktglobalswitches) then
                       infile.open;
                    end;
                   { avoid unnecessary reopens of the same file !! }
                   lastfileinfo.fileindex:=hp1.fileinfo.fileindex;
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
                   if (hp1.fileinfo.line<>lastfileinfo.line) and
                      ((hp1.fileinfo.line<infile.maxlinebuf) or (InlineLevel>0)) then
                     begin
                       if (hp1.fileinfo.line<>0) and
                          ((infile.linebuf^[hp1.fileinfo.line]>=0) or (InlineLevel>0)) then
                         AsmWriteLn(target_asm.comment+'['+tostr(hp1.fileinfo.line)+'] '+
                           fixline(infile.GetLineStr(hp1.fileinfo.line)));
                       { set it to a negative value !
                       to make that is has been read already !! PM }
                       if (infile.linebuf^[hp1.fileinfo.line]>=0) then
                         infile.linebuf^[hp1.fileinfo.line]:=-infile.linebuf^[hp1.fileinfo.line]-1;
                     end;
                 end;
                lastfileinfo:=hp1.fileinfo;
                lastinfile:=infile;
              end;
          end;

         case hp.typ of

           ait_comment :
             Begin
               AsmWrite(target_asm.comment);
               AsmWritePChar(tai_comment(hp).str);
               AsmLn;
             End;

           ait_regalloc :
             begin
               if (cs_asm_regalloc in aktglobalswitches) then
                 AsmWriteLn(#9+target_asm.comment+'Register '+gas_regname(Tai_regalloc(hp).reg)+
                            allocstr[tai_regalloc(hp).allocation]);
             end;

           ait_tempalloc :
             begin
               if (cs_asm_tempalloc in aktglobalswitches) then
                 begin
{$ifdef EXTDEBUG}
                   if assigned(tai_tempalloc(hp).problem) then
                     AsmWriteLn(target_asm.comment+'Temp '+tostr(tai_tempalloc(hp).temppos)+','+
                       tostr(tai_tempalloc(hp).tempsize)+' '+tai_tempalloc(hp).problem^)
                   else
{$endif EXTDEBUG}
                     AsmWriteLn(target_asm.comment+'Temp '+tostr(tai_tempalloc(hp).temppos)+','+
                       tostr(tai_tempalloc(hp).tempsize)+allocstr[tai_tempalloc(hp).allocation]);
                 end;
             end;

           ait_align :
             begin
               if target_info.system <> system_powerpc_darwin then
                 begin
                   AsmWrite(#9'.balign '+tostr(tai_align(hp).aligntype));
                   if tai_align(hp).use_op then
                    AsmWrite(','+tostr(tai_align(hp).fillop))
                 end
               else
                 begin
                   { darwin as only supports .align }
                   if not ispowerof2(tai_align(hp).aligntype,i) then
                     internalerror(2003010305);
                   AsmWrite(#9'.align '+tostr(i));
                   last_align := i;
                 end;
               AsmLn;
             end;

           ait_section :
             begin
               if tai_section(hp).sec<>sec_none then
                begin
                  AsmLn;
                  AsmWriteLn(ait_section2str(tai_section(hp).sec));
{$ifdef GDB}
                  lastfileinfo.line:=-1;
{$endif GDB}
                end
               else
                begin
{$ifdef EXTDEBUG}
                  AsmWrite(target_asm.comment);
                  AsmWriteln(' sec_none');
{$endif EXTDEBUG}
                end;
             end;

           ait_datablock :
             begin
               if tai_datablock(hp).is_global then
                AsmWrite(#9'.comm'#9)
               else
                AsmWrite(#9'.lcomm'#9);
               AsmWrite(tai_datablock(hp).sym.name);
               AsmWrite(','+tostr(tai_datablock(hp).size));
               if (target_info.system = system_powerpc_darwin) and
                  not(tai_datablock(hp).is_global) then
                 AsmWrite(','+tostr(last_align));
               AsmWriteln('');
             end;

           ait_const_32bit,
           ait_const_16bit,
           ait_const_8bit :
             begin
               AsmWrite(ait_const2str[hp.typ]+tostru(tai_const(hp).value));
               consttyp:=hp.typ;
               l:=0;
               repeat
                 found:=(not (tai(hp.next)=nil)) and (tai(hp.next).typ=consttyp);
                 if found then
                  begin
                    hp:=tai(hp.next);
                    s:=','+tostru(tai_const(hp).value);
                    AsmWrite(s);
                    inc(l,length(s));
                  end;
               until (not found) or (l>line_length);
               AsmLn;
             end;

           ait_const_symbol :
             begin
               AsmWrite(#9'.long'#9);
               AsmWrite(tai_const_symbol(hp).sym.name);
               if tai_const_symbol(hp).offset>0 then
                 AsmWrite('+'+tostr(tai_const_symbol(hp).offset))
               else if tai_const_symbol(hp).offset<0 then
                 AsmWrite(tostr(tai_const_symbol(hp).offset));
               AsmLn;
             end;

           ait_const_rva :
             begin
               AsmWrite(#9'.rva'#9);
               AsmWriteLn(tai_const_symbol(hp).sym.name);
             end;

{$ifdef cpuextended}
           ait_real_80bit :
             begin
               if do_line then
                AsmWriteLn(target_asm.comment+'value: '+extended2str(tai_real_80bit(hp).value));
             { Make sure e is a extended type, bestreal could be
               a different type (bestreal) !! (PFV) }
               e:=tai_real_80bit(hp).value;
               AsmWrite(#9'.byte'#9);
               for i:=0 to 9 do
                begin
                  if i<>0 then
                   AsmWrite(',');
                  AsmWrite(tostr(t80bitarray(e)[i]));
                end;
               AsmLn;
             end;
{$endif cpuextended}

           ait_real_64bit :
             begin
               if do_line then
                AsmWriteLn(target_asm.comment+'value: '+double2str(tai_real_64bit(hp).value));
               d:=tai_real_64bit(hp).value;
               { swap the values to correct endian if required }
               if source_info.endian <> target_info.endian then
                 swap64bitarray(t64bitarray(d));
               AsmWrite(#9'.byte'#9);
               for i:=0 to 7 do
                begin
                  if i<>0 then
                   AsmWrite(',');
                  AsmWrite(tostr(t64bitarray(d)[i]));
                end;
               AsmLn;
             end;

           ait_real_32bit :
             begin
               if do_line then
                AsmWriteLn(target_asm.comment+'value: '+single2str(tai_real_32bit(hp).value));
               sin:=tai_real_32bit(hp).value;
               { swap the values to correct endian if required }
               if source_info.endian <> target_info.endian then
                 swap32bitarray(t32bitarray(sin));
               AsmWrite(#9'.byte'#9);
               for i:=0 to 3 do
                begin
                  if i<>0 then
                   AsmWrite(',');
                  AsmWrite(tostr(t32bitarray(sin)[i]));
                end;
               AsmLn;
             end;

           ait_comp_64bit :
             begin
               if do_line then
                AsmWriteLn(target_asm.comment+'value: '+extended2str(tai_comp_64bit(hp).value));
               AsmWrite(#9'.byte'#9);
{$ifdef FPC}
               co:=comp(tai_comp_64bit(hp).value);
{$else}
               co:=tai_comp_64bit(hp).value;
{$endif}
               { swap the values to correct endian if required }
               if source_info.endian <> target_info.endian then
                 swap64bitarray(t64bitarray(co));
               for i:=0 to 7 do
                begin
                  if i<>0 then
                   AsmWrite(',');
                  AsmWrite(tostr(t64bitarray(co)[i]));
                end;
               AsmLn;
             end;

           ait_direct :
             begin
               AsmWritePChar(tai_direct(hp).str);
               AsmLn;
{$IfDef GDB}
               if strpos(tai_direct(hp).str,'.data')<>nil then
                 n_line:=n_dataline
               else if strpos(tai_direct(hp).str,'.text')<>nil then
                 n_line:=n_textline
               else if strpos(tai_direct(hp).str,'.bss')<>nil then
                 n_line:=n_bssline;
{$endif GDB}
             end;

           ait_string :
             begin
               pos:=0;
               for i:=1 to tai_string(hp).len do
                begin
                  if pos=0 then
                   begin
                     AsmWrite(#9'.ascii'#9'"');
                     pos:=20;
                   end;
                  ch:=tai_string(hp).str[i-1];
                  case ch of
                     #0, {This can't be done by range, because a bug in FPC}
                #1..#31,
             #128..#255 : s:='\'+tostr(ord(ch) shr 6)+tostr((ord(ch) and 63) shr 3)+tostr(ord(ch) and 7);
                    '"' : s:='\"';
                    '\' : s:='\\';
                  else
                   s:=ch;
                  end;
                  AsmWrite(s);
                  inc(pos,length(s));
                  if (pos>line_length) or (i=tai_string(hp).len) then
                   begin
                     AsmWriteLn('"');
                     pos:=0;
                   end;
                end;
             end;

           ait_label :
             begin
               if (tai_label(hp).l.is_used) then
                begin
                  if tai_label(hp).l.defbind=AB_GLOBAL then
                   begin
                     AsmWrite('.globl'#9);
                     AsmWriteLn(tai_label(hp).l.name);
                   end;
                  AsmWrite(tai_label(hp).l.name);
                  AsmWriteLn(':');
                end;
             end;

           ait_symbol :
             begin
               if tai_symbol(hp).is_global then
                begin
                  AsmWrite('.globl'#9);
                  AsmWriteLn(tai_symbol(hp).sym.name);
                end;
               if target_info.system in [system_i386_linux,system_i386_beos,
                                         system_powerpc_linux,system_m68k_linux,
                                         system_sparc_linux,system_alpha_linux,
                                         system_x86_64_linux,system_arm_linux] then
                begin
                   AsmWrite(#9'.type'#9);
                   AsmWrite(tai_symbol(hp).sym.name);
                   if assigned(tai(hp.next)) and
                      (tai(hp.next).typ in [ait_const_symbol,ait_const_rva,
                         ait_const_32bit,ait_const_16bit,ait_const_8bit,ait_datablock,
                         ait_real_32bit,ait_real_64bit,ait_real_80bit,ait_comp_64bit]) then
                    AsmWriteLn(',@object')
                   else
                    AsmWriteLn(',@function');
                   if tai_symbol(hp).sym.size>0 then
                    begin
                      AsmWrite(#9'.size'#9);
                      AsmWrite(tai_symbol(hp).sym.name);
                      AsmWrite(', ');
                      AsmWriteLn(tostr(tai_symbol(hp).sym.size));
                    end;
                end;
               AsmWrite(tai_symbol(hp).sym.name);
               AsmWriteLn(':');
             end;

           ait_symbol_end :
             begin
               if target_info.system in [system_i386_linux,system_i386_beos] then
                begin
                  s:=target_asm.labelprefix+'e'+tostr(symendcount);
                  inc(symendcount);
                  AsmWriteLn(s+':');
                  AsmWrite(#9'.size'#9);
                  AsmWrite(tai_symbol_end(hp).sym.name);
                  AsmWrite(', '+s+' - ');
                  AsmWriteLn(tai_symbol_end(hp).sym.name);
                end;
             end;

           ait_instruction :
             begin
               WriteInstruction(hp);
             end;

{$ifdef GDB}
           ait_stabs :
             begin
               if assigned(tai_stabs(hp).str) then
                 begin
                   AsmWrite(#9'.stabs ');
                   AsmWritePChar(tai_stabs(hp).str);
                   AsmLn;
                 end;
             end;

           ait_stabn :
             begin
               if assigned(tai_stabn(hp).str) then
                 begin
                   AsmWrite(#9'.stabn ');
                   AsmWritePChar(tai_stabn(hp).str);
                   AsmLn;
                 end;
             end;

           ait_force_line :
             stabslastfileinfo.line:=0;

           ait_stab_function_name:
             funcname:=tai_stab_function_name(hp).str;
{$endif GDB}

           ait_cut :
             begin
               if SmartAsm then
                begin
                { only reset buffer if nothing has changed }
                  if AsmSize=AsmStartSize then
                   AsmClear
                  else
                   begin
                     AsmClose;
                     DoAssemble;
                     AsmCreate(tai_cut(hp).place);
                   end;
                { avoid empty files }
                  while assigned(hp.next) and (tai(hp.next).typ in [ait_cut,ait_section,ait_comment]) do
                   begin
                     if tai(hp.next).typ=ait_section then
                       lasTSec:=tai_section(hp.next).sec;
                     hp:=tai(hp.next);
                   end;
{$ifdef GDB}
                  { force write of filename }
                  FillChar(stabslastfileinfo,sizeof(stabslastfileinfo),0);
                  includecount:=0;
                  funcname:=nil;
                  WriteFileLineInfo(aktfilepos);
{$endif GDB}
                  if lasTSec<>sec_none then
                    AsmWriteLn(ait_section2str(lasTSec));
                  AsmStartSize:=AsmSize;
                end;
             end;

           ait_marker :
             if tai_marker(hp).kind=InlineStart then
               inc(InlineLevel)
             else if tai_marker(hp).kind=InlineEnd then
               dec(InlineLevel);

           else
             internalerror(10000);
         end;
         hp:=tai(hp.next);
       end;
    end;


    procedure TGNUAssembler.WriteExtraHeader;

      begin
      end;

    procedure TGNUAssembler.WriteAsmList;
    var
      p:dirstr;
      n:namestr;
      e:extstr;
{$ifdef GDB}
      fileinfo : tfileposinfo;
{$endif GDB}

    begin
{$ifdef EXTDEBUG}
      if assigned(current_module.mainsource) then
       Comment(V_Debug,'Start writing gas-styled assembler output for '+current_module.mainsource^);
{$endif}

      LasTSec:=sec_none;
{$ifdef GDB}
      FillChar(stabslastfileinfo,sizeof(stabslastfileinfo),0);
{$endif GDB}
      FillChar(lastfileinfo,sizeof(lastfileinfo),0);
      LastInfile:=nil;

      if assigned(current_module.mainsource) then
       fsplit(current_module.mainsource^,p,n,e)
      else
       begin
         p:=inputdir;
         n:=inputfile;
         e:=inputextension;
       end;
    { to get symify to work }
      AsmWriteLn(#9'.file "'+FixFileName(n+e)+'"');
      WriteExtraHeader;
{$ifdef GDB}
      n_line:=n_bssline;
      funcname:=nil;
      linecount:=1;
      includecount:=0;
      fileinfo.fileindex:=1;
      fileinfo.line:=1;
      { Write main file }
      WriteFileLineInfo(fileinfo);
{$endif GDB}
      AsmStartSize:=AsmSize;
      symendcount:=0;

      If (cs_debuginfo in aktmoduleswitches) then
        WriteTree(debuglist);
      WriteTree(codesegment);
      WriteTree(datasegment);
      WriteTree(consts);
      WriteTree(rttilist);
      Writetree(resourcestringlist);
      WriteTree(bsssegment);
      Writetree(importssection);
      { exports are written by DLLTOOL
        if we use it so don't insert it twice (PM) }
      if not UseDeffileForExport and assigned(exportssection) then
        Writetree(exportssection);
      Writetree(resourcesection);
      {$ifdef GDB}
      WriteFileEndInfo;
      {$ENDIF}

      AsmLn;
{$ifdef EXTDEBUG}
      if assigned(current_module.mainsource) then
       Comment(V_Debug,'Done writing gas-styled assembler output for '+current_module.mainsource^);
{$endif EXTDEBUG}
    end;

end.
{
  $Log$
  Revision 1.43  2004-01-12 16:39:40  peter
    * sparc updates, mostly float related

  Revision 1.42  2004/01/07 17:40:06  jonas
    * darwin requires the alginment of .lcomm symbols to be specified
      together with the symbol itself, instead of in a .align directive

  Revision 1.41  2004/01/04 21:08:59  jonas
    * darwin only supports .align, no .balign

  Revision 1.40  2004/01/03 13:51:05  jonas
    + support exported procedures for linuxppc
    * refuse to compile systems/t_linux.pas if processor-specific  support
      for exported procedures is absent
    + generate .type and .size info for all currently defined linux-variants
      in aggas.pas

  Revision 1.39  2003/12/14 22:42:54  peter
    * fixed range check error

  Revision 1.38  2003/12/10 17:13:22  peter
    * fix range error with tai_const

  Revision 1.37  2003/11/12 16:05:39  florian
    * assembler readers OOPed
    + typed currency constants
    + typed 128 bit float constants if the CPU supports it

  Revision 1.36  2003/10/01 20:34:48  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.35  2003/09/23 17:56:05  peter
    * locals and paras are allocated in the code generation
    * tvarsym.localloc contains the location of para/local when
      generating code for the current procedure

  Revision 1.34  2003/09/06 16:47:24  florian
    + support of NaN and Inf in the compiler as values of real constants

  Revision 1.33  2003/09/04 00:15:29  florian
    * first bunch of adaptions of arm compiler for new register type

  Revision 1.32  2003/09/03 19:35:24  peter
    * powerpc compiles again

  Revision 1.31  2003/09/03 15:55:00  peter
    * NEWRA branch merged

  Revision 1.30  2003/09/03 11:18:36  florian
    * fixed arm concatcopy
    + arm support in the common compiler sources added
    * moved some generic cg code around
    + tfputype added
    * ...

  Revision 1.29.2.2  2003/09/01 21:02:55  peter
    * sparc updates for new tregister

  Revision 1.29.2.1  2003/08/31 15:46:26  peter
    * more updates for tregister

  Revision 1.29  2003/08/19 11:53:03  daniel
    * Fixed PowerPC compilation

  Revision 1.28  2003/08/18 11:49:47  daniel
    * Made ATT asm writer work with -sr

  Revision 1.27  2003/08/17 21:11:00  daniel
    * Now -sr works...

  Revision 1.26  2003/08/17 20:47:47  daniel
    * Notranslation changed into -sr functionality

  Revision 1.25  2003/08/17 16:59:20  jonas
    * fixed regvars so they work with newra (at least for ppc)
    * fixed some volatile register bugs
    + -dnotranslation option for -dnewra, which causes the registers not to
      be translated from virtual to normal registers. Requires support in
      the assembler writer as well, which is only implemented in aggas/
      agppcgas currently

  Revision 1.24  2003/04/28 21:17:53  peter
    * write sec_none info in extdebug

  Revision 1.23  2003/04/25 20:59:33  peter
    * removed funcretn,funcretsym, function result is now in varsym
      and aliases for result and function name are added using absolutesym
    * vs_hidden parameter for funcret passed in parameter
    * vs_hidden fixes
    * writenode changed to printnode and released from extdebug
    * -vp option added to generate a tree.log with the nodetree
    * nicer printnode for statements, callnode

  Revision 1.22  2003/04/24 22:29:57  florian
    * fixed a lot of PowerPC related stuff

  Revision 1.21  2003/04/22 14:33:38  peter
    * removed some notes/hints

  Revision 1.20  2003/01/09 21:52:37  peter
    * merged some verbosity options.
    * V_LineInfo is a verbosity flag to include line info

  Revision 1.19  2003/01/08 18:43:56  daniel
   * Tregister changed into a record

  Revision 1.18  2002/12/07 14:03:25  carl
    - remove some duplicates and unused vars

  Revision 1.17  2002/12/06 17:50:39  peter
    * long symbol name fix merged

  Revision 1.16  2002/11/17 16:31:55  carl
    * memory optimization (3-4%) : cleanup of tai fields,
       cleanup of tdef and tsym fields.
    * make it work for m68k

  Revision 1.15  2002/11/15 01:58:45  peter
    * merged changes from 1.0.7 up to 04-11
      - -V option for generating bug report tracing
      - more tracing for option parsing
      - errors for cdecl and high()
      - win32 import stabs
      - win32 records<=8 are returned in eax:edx (turned off by default)
      - heaptrc update
      - more info for temp management in .s file with EXTDEBUG

  Revision 1.14  2002/10/30 21:01:14  peter
    * always include lineno after fileswitch. valgrind requires this

  Revision 1.13  2002/10/05 12:43:23  carl
    * fixes for Delphi 6 compilation
     (warning : Some features do not work under Delphi)

  Revision 1.12  2002/08/31 16:05:17  florian
    * write double # before float constants when -al is turned on
      else some gas versions interpret it as line number

  Revision 1.11  2002/08/20 16:55:38  peter
    * don't write (stabs)line info when inlining a procedure

  Revision 1.10  2002/08/18 22:16:14  florian
    + the ppc gas assembler writer adds now registers aliases
      to the assembler file

  Revision 1.9  2002/08/18 20:06:23  peter
    * inlining is now also allowed in interface
    * renamed write/load to ppuwrite/ppuload
    * tnode storing in ppu
    * nld,ncon,nbas are already updated for storing in ppu

  Revision 1.8  2002/07/26 21:15:37  florian
    * rewrote the system handling

  Revision 1.7  2002/07/07 09:52:32  florian
    * powerpc target fixed, very simple units can be compiled
    * some basic stuff for better callparanode handling, far from being finished

  Revision 1.6  2002/07/01 18:46:20  peter
    * internal linker
    * reorganized aasm layer

  Revision 1.5  2002/05/18 13:34:05  peter
    * readded missing revisions

  Revision 1.4  2002/05/16 19:46:34  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.2  2002/04/15 18:53:48  carl
  + comments in register allocator uses std_Reg2str

  Revision 1.1  2002/04/14 16:51:54  carl
  + basic GNU assembler writer class

}
