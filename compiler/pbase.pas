{
    $Id$
    Copyright (c) 1998-2000 by Florian Klaempfl

    Contains some helper routines for the parser

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
unit pbase;

{$i defines.inc}

interface

    uses
       cutils,cclasses,
       tokens,globals,
       symconst,symbase,symtype,symdef,symsym,symtable
{$ifdef fixLeaksOnError}
       ,comphook
{$endif fixLeaksOnError}
       ;

    const
       { true, if we are after an assignement }
       afterassignment : boolean = false;

       { sspecial for handling procedure vars }
       getprocvar : boolean = false;
       getprocvardef : tprocvardef = nil;

    type
       { listitem }
       tidstringlistitem = class(tlinkedlistitem)
          data : pstring;
          file_info : tfileposinfo;
          constructor Create(const s:string;const pos:tfileposinfo);
          destructor  Destroy;override;
       end;

       tidstringlist=class(tlinkedlist)
          procedure add(const s : string;const file_info : tfileposinfo);
          function  get(var file_info : tfileposinfo) : string;
          function  find(const s:string):boolean;
       end;

    var
       { size of data segment, set by proc_unit or proc_program }
       datasize : longint;

       { for operators }
       optoken : ttoken;
       otsym : tvarsym;

       { symtable were unit references are stored }
       refsymtable : tsymtable;

       { true, if only routine headers should be parsed }
       parse_only : boolean;

       { true, if we should ignore an equal in const x : 1..2=2 }
       ignore_equal : boolean;

{$ifdef fixLeaksOnError}
    { not worth it to make a pstack, there's only one data field (a pointer). }
    { in the interface, because pmodules and psub also use it for their names }
    var strContStack: TStack;
        pbase_old_do_stop: tstopprocedure;
{$endif fixLeaksOnError}

    procedure identifier_not_found(const s:string);

    function tokenstring(i : ttoken):string;

    { consumes token i, if the current token is unequal i }
    { a syntax error is written                           }
    procedure consume(i : ttoken);

    {Tries to consume the token i, and returns true if it was consumed:
     if token=i.}
    function try_to_consume(i:Ttoken):boolean;

    { consumes all tokens til atoken (for error recovering }
    procedure consume_all_until(atoken : ttoken);

    { consumes tokens while they are semicolons }
    procedure emptystats;

    { consume a symbol, if not found give an error and
      and return an errorsym }
    function consume_sym(var srsym:tsym;var srsymtable:tsymtable):boolean;

    { reads a list of identifiers into a string list }
    function idlist : tidstringlist;

    { just for an accurate position of the end of a procedure (PM) }
    var
       last_endtoken_filepos: tfileposinfo;


implementation

    uses
       globtype,scanner,systems,verbose;

{****************************************************************************
                           TIdStringlistItem
****************************************************************************}

    constructor TIDStringlistItem.Create(const s:string;const pos:tfileposinfo);
      begin
        data:=stringdup(s);
        file_info:=pos;
      end;


    destructor  TIDStringlistItem.Destroy;
      begin
        stringdispose(data);
      end;


{****************************************************************************
                             TIdStringlist
****************************************************************************}

    procedure tidstringlist.add(const s : string; const file_info : tfileposinfo);
      begin
         if find(s) then
          exit;
         inherited concat(tidstringlistitem.create(s,file_info));
      end;


    function tidstringlist.get(var file_info : tfileposinfo) : string;
      var
         p : tidstringlistitem;
      begin
         p:=tidstringlistitem(inherited getfirst);
         if p=nil then
          begin
            get:='';
            file_info.fileindex:=0;
            file_info.line:=0;
            file_info.column:=0;
          end
         else
          begin
            get:=p.data^;
            file_info:=p.file_info;
            p.free;
          end;
      end;

    function tidstringlist.find(const s:string):boolean;
      var
        newnode : tidstringlistitem;
      begin
        find:=false;
        newnode:=tidstringlistitem(First);
        while assigned(newnode) do
         begin
           if newnode.data^=s then
            begin
              find:=true;
              exit;
            end;
           newnode:=tidstringlistitem(newnode.next);
         end;
      end;


{****************************************************************************
                               Token Parsing
****************************************************************************}

     procedure identifier_not_found(const s:string);
       begin
         Message1(sym_e_id_not_found,s);
         { show a fatal that you need -S2 or -Sd, but only
           if we just parsed the a token that has m_class }
         if not(m_class in aktmodeswitches) and
            (Upper(s)=pattern) and
            (tokeninfo^[idtoken].keyword=m_class) then
           Message(parser_f_need_objfpc_or_delphi_mode);
       end;


    function tokenstring(i : ttoken):string;
      begin
        tokenstring:=tokeninfo^[i].str;
      end;


    { consumes token i, write error if token is different }
    procedure consume(i : ttoken);
      begin
        if (token<>i) and (idtoken<>i) then
          if token=_id then
            Message2(scan_f_syn_expected,tokeninfo^[i].str,'identifier '+pattern)
          else
            Message2(scan_f_syn_expected,tokeninfo^[i].str,tokeninfo^[token].str)
        else
          begin
            if token=_END then
              last_endtoken_filepos:=akttokenpos;
            current_scanner.readtoken;
          end;
      end;


    function try_to_consume(i:Ttoken):boolean;
      begin
        try_to_consume:=false;
        if (token=i) or (idtoken=i) then
         begin
           try_to_consume:=true;
           if token=_END then
            last_endtoken_filepos:=akttokenpos;
           current_scanner.readtoken;
         end;
      end;


    procedure consume_all_until(atoken : ttoken);
      begin
         while (token<>atoken) and (idtoken<>atoken) do
          begin
            Consume(token);
            if token=_EOF then
             begin
               Consume(atoken);
               Message(scan_f_end_of_file);
               exit;
             end;
          end;
      end;


    procedure emptystats;
      begin
         repeat
         until not try_to_consume(_SEMICOLON);
      end;



    function consume_sym(var srsym:tsym;var srsymtable:tsymtable):boolean;
      begin
        { first check for identifier }
        if token<>_ID then
         begin
           consume(_ID);
           srsym:=generrorsym;
           srsymtable:=nil;
           consume_sym:=false;
           exit;
         end;
        searchsym(pattern,srsym,srsymtable);
        if assigned(srsym) then
         begin
           if (srsym.typ=unitsym) then
            begin
              { only allow unit.symbol access if the name was
                found in the current module }
              if srsym.owner.unitid=0 then
               begin
                 consume(_ID);
                 consume(_POINT);
                 srsymtable:=tunitsym(srsym).unitsymtable;
                 srsym:=searchsymonlyin(srsymtable,pattern);
               end
              else
               srsym:=nil;
            end;
         end;
        { if nothing found give error and return errorsym }
        if srsym=nil then
         begin
           identifier_not_found(orgpattern);
           srsym:=generrorsym;
           srsymtable:=nil;
         end;
        consume(_ID);
        consume_sym:=assigned(srsym);
      end;


    { reads a list of identifiers into a string list }
    function idlist : tidstringlist;
      var
        sc : tIdstringlist;
      begin
         sc:=TIdStringlist.Create;
         repeat
           sc.add(orgpattern,akttokenpos);
           consume(_ID);
         until not try_to_consume(_COMMA);
         idlist:=sc;
      end;

{$ifdef fixLeaksOnError}
procedure pbase_do_stop;
var names: PStringlist;
begin
  names := PStringlist(strContStack.pop);
  while names <> nil do
    begin
      dispose(names,done);
      names := PStringlist(strContStack.pop);
    end;
  strContStack.done;
  do_stop := pbase_old_do_stop;
  do_stop{$ifdef FPCPROCVAR}(){$endif};
end;

begin
  strContStack.init;
  pbase_old_do_stop := do_stop;
  do_stop := {$ifdef FPCPROCVAR}(){$endif}pbase_do_stop;
{$endif fixLeaksOnError}
end.

{
  $Log$
  Revision 1.12  2001-05-06 14:49:17  peter
    * ppu object to class rewrite
    * move ppu read and write stuff to fppu

  Revision 1.11  2001/04/13 18:08:37  peter
    * scanner object to class

  Revision 1.10  2001/04/13 01:22:11  peter
    * symtable change to classes
    * range check generation and errors fixed, make cycle DEBUG=1 works
    * memory leaks fixed

  Revision 1.9  2001/04/02 21:20:31  peter
    * resulttype rewrite

  Revision 1.8  2001/03/11 22:58:49  peter
    * getsym redesign, removed the globals srsym,srsymtable

  Revision 1.7  2000/12/25 00:07:27  peter
    + new tlinkedlist class (merge of old tstringqueue,tcontainer and
      tlinkedlist objects)

  Revision 1.6  2000/10/31 22:02:49  peter
    * symtable splitted, no real code changes

  Revision 1.5  2000/09/24 15:06:21  peter
    * use defines.inc

  Revision 1.4  2000/08/27 20:19:39  peter
    * store strings with case in ppu, when an internal symbol is created
      a '$' is prefixed so it's not automatic uppercased

  Revision 1.3  2000/08/27 16:11:51  peter
    * moved some util functions from globals,cobjects to cutils
    * splitted files into finput,fmodule

  Revision 1.2  2000/07/13 11:32:44  michael
  + removed logs

}
