{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    Type checking and register allocation for inline nodes

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
unit nutils;

{$i fpcdefs.inc}

interface

  uses
    node;

  type
    { resulttype of functions that process on all nodes in a (sub)tree }
    foreachnoderesult = (
      { false, continue recursion }
      fen_false,
      { false, stop recursion }
      fen_norecurse_false,
      { true, continue recursion }
      fen_true,
      { true, stop recursion }
      fen_norecurse_true
    );


  foreachnodefunction = function(var n: tnode): foreachnoderesult of object;
  staticforeachnodefunction = function(var n: tnode): foreachnoderesult;


    function foreachnode(var n: tnode; f: foreachnodefunction): boolean;
    function foreachnodestatic(var n: tnode; f: staticforeachnodefunction): boolean;

    function call_fail_node:tnode;
    function initialize_data_node(p:tnode):tnode;
    function finalize_data_node(p:tnode):tnode;


implementation

    uses
      verbose,
      symconst,symsym,symtype,symdef,symtable,
      nbas,ncon,ncnv,nld,nflw,nset,ncal,nadd,nmem,
      cgbase,procinfo,
      pass_1;

  function foreachnode(var n: tnode; f: foreachnodefunction): boolean;
    begin
      result := false;
      if not assigned(n) then
        exit;
      case f(n) of
        fen_norecurse_false:
          exit;
        fen_norecurse_true:
          begin
            result := true;
            exit;
          end;
        fen_true:
          result := true;
       { result is already false
        fen_false:
          result := false; }
      end;
      case n.nodetype of
        calln:
          begin
            { not in one statement, won't work because of b- }
            result := foreachnode(tcallnode(n).methodpointer,f) or result;
            result := foreachnode(tcallnode(n).inlinecode,f) or result;
          end;
        ifn, whilerepeatn, forn:
          begin
            { not in one statement, won't work because of b- }
            result := foreachnode(tloopnode(n).t1,f) or result;
            result := foreachnode(tloopnode(n).t2,f) or result;
          end;
        raisen:
          result := foreachnode(traisenode(n).frametree,f) or result;
        casen:
          result := foreachnode(tcasenode(n). elseblock,f) or result;
      end;
      if n.inheritsfrom(tbinarynode) then
        begin
          result := foreachnode(tbinarynode(n).right,f) or result;
          result := foreachnode(tbinarynode(n).left,f) or result;
        end
      else if n.inheritsfrom(tunarynode) then
        result := foreachnode(tunarynode(n).left,f) or result;
    end;


  function foreachnodestatic(var n: tnode; f: staticforeachnodefunction): boolean;
    begin
      result := false;
      if not assigned(n) then
        exit;
      case f(n) of
        fen_norecurse_false:
          exit;
        fen_norecurse_true:
          begin
            result := true;
            exit;
          end;
        fen_true:
          result := true;
       { result is already false
        fen_false:
          result := false; }
      end;
      case n.nodetype of
        calln:
          begin
            result := foreachnodestatic(tcallnode(n).methodpointer,f) or result;
            result := foreachnodestatic(tcallnode(n).inlinecode,f) or result;
          end;
        ifn, whilerepeatn, forn:
          begin
            { not in one statement, won't work because of b- }
            result := foreachnodestatic(tloopnode(n).t1,f) or result;
            result := foreachnodestatic(tloopnode(n).t2,f) or result;
          end;
        raisen:
          result := foreachnodestatic(traisenode(n).frametree,f) or result;
        casen:
          result := foreachnodestatic(tcasenode(n). elseblock,f) or result;
      end;
      if n.inheritsfrom(tbinarynode) then
        begin
          result := foreachnodestatic(tbinarynode(n).right,f) or result;
          result := foreachnodestatic(tbinarynode(n).left,f) or result;
        end
      else if n.inheritsfrom(tunarynode) then
        result := foreachnodestatic(tunarynode(n).left,f) or result;
    end;


    function call_fail_node:tnode;
      var
        para : tcallparanode;
        newstatement : tstatementnode;
        srsym : tsym;
      begin
        result:=internalstatements(newstatement);

        { call fail helper and exit normal }
        if is_class(current_procinfo.procdef._class) then
          begin
            srsym:=search_class_member(current_procinfo.procdef._class,'FREEINSTANCE');
            if assigned(srsym) and
               (srsym.typ=procsym) then
              begin
                { if self<>0 and vmt=1 then freeinstance }
                addstatement(newstatement,cifnode.create(
                    caddnode.create(andn,
                        caddnode.create(unequaln,
                            load_self_pointer_node,
                            cnilnode.create),
                        caddnode.create(equaln,
                            ctypeconvnode.create(
                                load_vmt_pointer_node,
                                voidpointertype),
                            cpointerconstnode.create(1,voidpointertype))),
                    ccallnode.create(nil,tprocsym(srsym),srsym.owner,load_self_node),
                    nil));
              end
            else
              internalerror(200305108);
          end
        else
          if is_object(current_procinfo.procdef._class) then
            begin
              { parameter 3 : vmt_offset }
              { parameter 2 : pointer to vmt }
              { parameter 1 : self pointer }
              para:=ccallparanode.create(
                        cordconstnode.create(current_procinfo.procdef._class.vmt_offset,s32inttype,false),
                    ccallparanode.create(
                        ctypeconvnode.create_explicit(
                            load_vmt_pointer_node,
                            voidpointertype),
                    ccallparanode.create(
                        ctypeconvnode.create_explicit(
                            load_self_pointer_node,
                            voidpointertype),
                    nil)));
              addstatement(newstatement,
                  ccallnode.createintern('fpc_help_fail',para));
            end
        else
          internalerror(200305132);
        { self:=nil }
        addstatement(newstatement,cassignmentnode.create(
            load_self_pointer_node,
            cnilnode.create));
        { exit }
        addstatement(newstatement,cexitnode.create(nil));
      end;


    function initialize_data_node(p:tnode):tnode;
      begin
        if not assigned(p.resulttype.def) then
          resulttypepass(p);
        result:=ccallnode.createintern('fpc_initialize',
              ccallparanode.create(
                  caddrnode.create(
                      crttinode.create(
                          tstoreddef(p.resulttype.def),initrtti)),
              ccallparanode.create(
                  caddrnode.create(p),
              nil)));
      end;


    function finalize_data_node(p:tnode):tnode;
      begin
        if not assigned(p.resulttype.def) then
          resulttypepass(p);
        result:=ccallnode.createintern('fpc_finalize',
              ccallparanode.create(
                  caddrnode.create(
                      crttinode.create(
                          tstoreddef(p.resulttype.def),initrtti)),
              ccallparanode.create(
                  caddrnode.create(p),
              nil)));
      end;


end.

{
  $Log$
  Revision 1.9  2004-02-03 22:32:54  peter
    * renamed xNNbittype to xNNinttype
    * renamed registers32 to registersint
    * replace some s32bit,u32bit with torddef([su]inttype).def.typ

  Revision 1.8  2003/11/10 22:02:52  peter
    * cross unit inlining fixed

  Revision 1.7  2003/10/01 20:34:49  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.6  2003/06/13 21:19:30  peter
    * current_procdef removed, use current_procinfo.procdef instead

  Revision 1.5  2003/05/26 21:17:17  peter
    * procinlinenode removed
    * aktexit2label removed, fast exit removed
    + tcallnode.inlined_pass_2 added

  Revision 1.4  2003/05/16 14:33:31  peter
    * regvar fixes

  Revision 1.3  2003/05/13 20:54:06  peter
    * fail checks vmt value before calling dispose

  Revision 1.2  2003/05/13 19:14:41  peter
    * failn removed
    * inherited result code check moven to pexpr

  Revision 1.1  2003/04/23 12:35:34  florian
    * fixed several issues with powerpc
    + applied a patch from Jonas for nested function calls (PowerPC only)
    * ...

}
