{
    $Id$
    Copyright (c) 1998-2000 by Peter Vreman

    This unit handles the verbose management

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
unit verbose;

{$i defines.inc}

{ Don't include messages in the executable }
{.$define EXTERN_MSG}

interface

uses
  cutils,cobjects,
  finput,
  messages;

{$ifndef EXTERN_MSG}
  {$i msgtxt.inc}
{$endif}

{$i msgidx.inc}

Const
{ <$10000 will show file and line }
  V_None         = $0;
  V_Fatal        = $1;
  V_Error        = $2;
  V_Normal       = $4; { doesn't show a text like Error: }
  V_Warning      = $8;
  V_Note         = $10;
  V_Hint         = $20;
  V_Macro        = $100;
  V_Procedure    = $200;
  V_Conditional  = $400;
  V_Assem        = $800;
  V_Declarations = $1000;
  V_Info         = $10000;
  V_Status       = $20000;
  V_Used         = $40000;
  V_Tried        = $80000;
  V_Debug        = $100000;
  V_Executable   = $200000;
  V_ShowFile     = $ffff;
  V_All          = longint($ffffffff);
  V_Default      = V_Fatal + V_Error + V_Normal;

var
  msg : pmessage;

procedure SetRedirectFile(const fn:string);
function  SetVerbosity(const s:string):boolean;

procedure LoadMsgFile(const fn:string);

procedure SetCompileModule(p:pmodulebase);
procedure Stop;
procedure ShowStatus;
function  ErrorCount:longint;
procedure SetErrorFlags(const s:string);
procedure GenerateError;
procedure Internalerror(i:longint);
procedure Comment(l:longint;s:string);
function  MessagePchar(w:longint):pchar;
procedure Message(w:longint);
procedure Message1(w:longint;const s1:string);
procedure Message2(w:longint;const s1,s2:string);
procedure Message3(w:longint;const s1,s2,s3:string);
procedure MessagePos(const pos:tfileposinfo;w:longint);
procedure MessagePos1(const pos:tfileposinfo;w:longint;const s1:string);
procedure MessagePos2(const pos:tfileposinfo;w:longint;const s1,s2:string);
procedure MessagePos3(const pos:tfileposinfo;w:longint;const s1,s2,s3:string);

procedure InitVerbose;
procedure DoneVerbose;


implementation
uses
  comphook,
  globals;

var
  redirexitsave  : pointer;
  current_module : pmodulebase;

{****************************************************************************
                       Extra Handlers for default compiler
****************************************************************************}

procedure DoneRedirectFile;
begin
  exitproc:=redirexitsave;
  if status.use_redir then
   close(status.redirfile);
end;


procedure SetRedirectFile(const fn:string);
begin
  assign(status.redirfile,fn);
  {$I-}
   append(status.redirfile);
   if ioresult <> 0 then
    rewrite(status.redirfile);
  {$I+}
  status.use_redir:=(ioresult=0);
  if status.use_redir then
   begin
     redirexitsave:=exitproc;
     exitproc:=@DoneRedirectFile;
   end;
end;


function SetVerbosity(const s:string):boolean;
var
  m : Longint;
  i : Integer;
  inverse : boolean;
  c : char;
begin
  Setverbosity:=false;
  val(s,m,i);
  if (i=0) and (s<>'') then
   status.verbosity:=m
  else
   begin
     i:=1;
     while i<=length(s) do
       begin
          c:=upcase(s[i]);
          inverse:=false;
          { on/off ? }
          if (i<length(s)) then
           case s[i+1] of
            '-' : begin
                    inc(i);
                    inverse:=true;
                  end;
            '+' : inc(i);
           end;
          { handle switch }
          case c of
          { Special cases }
           'A' : status.verbosity:=V_All;
           '0' : status.verbosity:=V_Default;
           'R' : begin
                    if inverse then
                      begin
                         status.use_gccoutput:=false;
                         status.use_stderr:=false;
                      end
                    else
                      begin
                         status.use_gccoutput:=true;
                         status.use_stderr:=true;
                      end;
                 end;
          { Normal cases - do an or }
           'E' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Error)
                 else
                   status.verbosity:=status.verbosity or V_Error;
           'I' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Info)
                 else
                   status.verbosity:=status.verbosity or V_Info;
           'W' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Warning)
                 else
                   status.verbosity:=status.verbosity or V_Warning;
           'N' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Note)
                 else
                   status.verbosity:=status.verbosity or V_Note;
           'H' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Hint)
                 else
                   status.verbosity:=status.verbosity or V_Hint;
           'L' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Status)
                 else
                   status.verbosity:=status.verbosity or V_Status;
           'U' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Used)
                 else
                   status.verbosity:=status.verbosity or V_Used;
           'T' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Tried)
                 else
                   status.verbosity:=status.verbosity or V_Tried;
           'M' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Macro)
                 else
                   status.verbosity:=status.verbosity or V_Macro;
           'P' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Procedure)
                 else
                   status.verbosity:=status.verbosity or V_Procedure;
           'C' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Conditional)
                 else
                   status.verbosity:=status.verbosity or V_Conditional;
           'D' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Debug)
                 else
                   status.verbosity:=status.verbosity or V_Debug;
           'B' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Declarations)
                 else
                   status.verbosity:=status.verbosity or V_Declarations;
           'X' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Executable)
                 else
                   status.verbosity:=status.verbosity or V_Executable;
           'Z' : if inverse then
                   status.verbosity:=status.verbosity and (not V_Assem)
                 else
                   status.verbosity:=status.verbosity or V_Assem;
           end;
          inc(i);
       end;
     end;
  if status.verbosity=0 then
   status.verbosity:=V_Default;
  setverbosity:=true;
end;


procedure LoadPrefixes;

  function loadprefix(w:longint):string;
  var
    s : string;
    idx : longint;
  begin
    s:=msg^.get(w);
    idx:=pos('_',s);
    if idx>0 then
     LoadPrefix:=Copy(s,idx+1,255)
    else
     LoadPrefix:=s;
  end;

begin
{ Load the prefixes }
  fatalstr:=LoadPrefix(general_i_fatal);
  errorstr:=LoadPrefix(general_i_error);
  warningstr:=LoadPrefix(general_i_warning);
  notestr:=LoadPrefix(general_i_note);
  hintstr:=LoadPrefix(general_i_hint);
end;


procedure LoadMsgFile(const fn:string);
begin
  { reload the internal messages if not already loaded }
{$ifndef EXTERN_MSG}
  if not msg^.msgintern then
   msg^.LoadIntern(@msgtxt,msgtxtsize);
{$endif}
  if not msg^.LoadExtern(fn) then
   begin
{$ifdef EXTERN_MSG}
     writeln('Fatal: Cannot find error message file.');
     halt(3);
{$else}
     msg^.LoadIntern(@msgtxt,msgtxtsize);
{$endif}
   end;
  { reload the prefixes using the new messages }
  LoadPrefixes;
end;


procedure SetCompileModule(p:pmodulebase);
begin
  current_module:=p;
end;


var
  lastfileidx,
  lastmoduleidx : longint;
Procedure UpdateStatus;
begin
{ fix status }
  status.currentline:=aktfilepos.line;
  status.currentcolumn:=aktfilepos.column;
  if assigned(current_module) and
     assigned(current_module^.sourcefiles) and
     ((current_module^.unit_index<>lastmoduleidx) or
      (aktfilepos.fileindex<>lastfileidx)) then
   begin
     { update status record }
     status.currentmodule:=current_module^.modulename^;
     status.currentsource:=current_module^.sourcefiles^.get_file_name(aktfilepos.fileindex);
     status.currentsourcepath:=current_module^.sourcefiles^.get_file_path(aktfilepos.fileindex);
     { update lastfileidx only if name known PM }
     if status.currentsource<>'' then
       lastfileidx:=aktfilepos.fileindex
     else
       lastfileidx:=0;
     lastmoduleidx:=current_module^.unit_index;
   end;
end;


procedure stop;
begin
  do_stop{$ifdef FPCPROCVAR}(){$endif};
end;


procedure ShowStatus;
begin
  UpdateStatus;
  if do_status{$ifdef FPCPROCVAR}(){$endif} then
   stop;
end;


function ErrorCount:longint;
begin
  ErrorCount:=status.errorcount;
end;


procedure SetErrorFlags(const s:string);
var
  code : integer;
  i,j,l : longint;
begin
{ empty string means error count = 1 for backward compatibility (PFV) }
  if s='' then
   begin
     status.maxerrorcount:=1;
     exit;
   end;
  i:=0;
  while (i<length(s)) do
   begin
     inc(i);
     case s[i] of
       '0'..'9' :
          begin
            j:=i;
            while (j<=length(s)) and (s[j] in ['0'..'9']) do
             inc(j);
            val(copy(s,i,j-i),l,code);
            if code<>0 then
             l:=1;
            status.maxerrorcount:=l;
            i:=j;
          end;
        'w','W' :
          status.errorwarning:=true;
        'n','N' :
          status.errornote:=true;
        'h','H' :
          status.errorhint:=true;
     end;
   end;
end;


procedure GenerateError;
begin
  inc(status.errorcount);
end;


procedure internalerror(i : longint);
begin
  UpdateStatus;
  do_internalerror(i);
  inc(status.errorcount);
  stop;
end;


procedure Comment(l:longint;s:string);
var
  dostop : boolean;
begin
  dostop:=((l and V_Fatal)<>0);
  if ((l and V_Error)<>0) or
     (status.errorwarning and ((l and V_Warning)<>0)) or
     (status.errornote and ((l and V_Note)<>0)) or
     (status.errorhint and ((l and V_Hint)<>0)) then
   inc(status.errorcount);
{ Create status info }
  UpdateStatus;
{ Fix replacements }
  DefaultReplacements(s);
{ show comment }
  if do_comment(l,s) or dostop then
   stop;
  if (status.errorcount>=status.maxerrorcount) and not status.skip_error then
   begin
     Message1(unit_f_errors_in_unit,tostr(status.errorcount));
     status.skip_error:=true;
     stop;
   end;
end;


Procedure Msg2Comment(s:string);
var
  idx,i,v : longint;
  dostop  : boolean;
begin
{Reset}
  dostop:=false;
  v:=0;
{Parse options}
  idx:=pos('_',s);
  if idx=0 then
   v:=V_Normal
  else
   if (idx >= 1) And (idx <= 5) then
    begin
      for i:=1 to idx do
       begin
         case upcase(s[i]) of
          'F' :
            begin
              v:=v or V_Fatal;
              inc(status.errorcount);
              dostop:=true;
            end;
          'E' :
            begin
              v:=v or V_Error;
              inc(status.errorcount);
            end;
          'O' :
            v:=v or V_Normal;
          'W':
            begin
              v:=v or V_Warning;
              if status.errorwarning then
               inc(status.errorcount);
            end;
          'N' :
            begin
              v:=v or V_Note;
              if status.errornote then
               inc(status.errorcount);
            end;
          'H' :
            begin
              v:=v or V_Hint;
              if status.errorhint then
               inc(status.errorcount);
            end;
          'I' :
            v:=v or V_Info;
          'L' :
            v:=v or V_Status;
          'U' :
            v:=v or V_Used;
          'T' :
            v:=v or V_Tried;
          'M' :
            v:=v or V_Macro;
          'P' :
            v:=v or V_Procedure;
          'C' :
            v:=v or V_Conditional;
          'D' :
            v:=v or V_Debug;
          'B' :
            v:=v or V_Declarations;
          'X' :
            v:=v or V_Executable;
          'Z' :
            v:=v or V_Assem;
          'S' :
            dostop:=true;
          '_' : ;
         end;
       end;
    end;
  Delete(s,1,idx);
{ fix status }
  UpdateStatus;
{ Fix replacements }
  DefaultReplacements(s);
{ show comment }
  if do_comment(v,s) or dostop then
   stop;
  if (status.errorcount>=status.maxerrorcount) and not status.skip_error then
   begin
     Message1(unit_f_errors_in_unit,tostr(status.errorcount));
     status.skip_error:=true;
     stop;
   end;
end;


function  MessagePchar(w:longint):pchar;
begin
  MessagePchar:=msg^.GetPchar(w)
end;


procedure Message(w:longint);
begin
  Msg2Comment(msg^.Get(w));
end;


procedure Message1(w:longint;const s1:string);
begin
  Msg2Comment(msg^.Get1(w,s1));
end;


procedure Message2(w:longint;const s1,s2:string);
begin
  Msg2Comment(msg^.Get2(w,s1,s2));
end;


procedure Message3(w:longint;const s1,s2,s3:string);
begin
  Msg2Comment(msg^.Get3(w,s1,s2,s3));
end;


procedure MessagePos(const pos:tfileposinfo;w:longint);
var
  oldpos : tfileposinfo;
begin
  oldpos:=aktfilepos;
  aktfilepos:=pos;
  Msg2Comment(msg^.Get(w));
  aktfilepos:=oldpos;
end;


procedure MessagePos1(const pos:tfileposinfo;w:longint;const s1:string);
var
  oldpos : tfileposinfo;
begin
  oldpos:=aktfilepos;
  aktfilepos:=pos;
  Msg2Comment(msg^.Get1(w,s1));
  aktfilepos:=oldpos;
end;


procedure MessagePos2(const pos:tfileposinfo;w:longint;const s1,s2:string);
var
  oldpos : tfileposinfo;
begin
  oldpos:=aktfilepos;
  aktfilepos:=pos;
  Msg2Comment(msg^.Get2(w,s1,s2));
  aktfilepos:=oldpos;
end;


procedure MessagePos3(const pos:tfileposinfo;w:longint;const s1,s2,s3:string);
var
  oldpos : tfileposinfo;
begin
  oldpos:=aktfilepos;
  aktfilepos:=pos;
  Msg2Comment(msg^.Get3(w,s1,s2,s3));
  aktfilepos:=oldpos;
end;


procedure InitVerbose;
begin
{ Init }
  msg:=new(pmessage,Init(20,msgidxmax));
  if msg=nil then
   begin
     writeln('Fatal: MsgIdx Wrong');
     halt(3);
   end;
{$ifndef EXTERN_MSG}
  msg^.LoadIntern(@msgtxt,msgtxtsize);
{$else}
  LoadMsgFile(exepath+'errore.msg');
{$endif}
  FillChar(Status,sizeof(TCompilerStatus),0);
  status.verbosity:=V_Default;
  Status.MaxErrorCount:=50;
  LoadPrefixes;
end;


procedure DoneVerbose;
begin
  if assigned(msg) then
   begin
     dispose(msg,Done);
     msg:=nil;
   end;
end;

end.
{
  $Log$
  Revision 1.9  2000-12-07 17:19:45  jonas
    * new constant handling: from now on, hex constants >$7fffffff are
      parsed as unsigned constants (otherwise, $80000000 got sign extended
      and became $ffffffff80000000), all constants in the longint range
      become longints, all constants >$7fffffff and <=cardinal($ffffffff)
      are cardinals and the rest are int64's.
    * added lots of longint typecast to prevent range check errors in the
      compiler and rtl
    * type casts of symbolic ordinal constants are now preserved
    * fixed bug where the original resulttype wasn't restored correctly
      after doing a 64bit rangecheck

  Revision 1.8  2000/11/29 00:30:43  florian
    * unused units removed from uses clause
    * some changes for widestrings

  Revision 1.7  2000/10/31 22:02:55  peter
    * symtable splitted, no real code changes

  Revision 1.6  2000/09/24 21:33:48  peter
    * message updates merges

  Revision 1.5  2000/09/24 15:06:33  peter
    * use defines.inc

  Revision 1.4  2000/08/27 16:11:55  peter
    * moved some util functions from globals,cobjects to cutils
    * splitted files into finput,fmodule

  Revision 1.3  2000/08/13 12:54:55  peter
    * class member decl wrong then no other error after it
    * -vb has now also line numbering
    * -vb is also used for interface/implementation different decls and
      doesn't list the current function (merged)

  Revision 1.2  2000/07/13 11:32:54  michael
  + removed logs

}
