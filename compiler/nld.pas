{
    $Id$
    Copyright (c) 2000 by Florian Klaempfl

    Type checking and register allocation for load/assignment nodes

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
unit nld;

{$i defines.inc}

interface

    uses
       node,
       symbase,symtype,symsym;

    type
       tloadnode = class(tunarynode)
          symtableentry : tsym;
          symtable : tsymtable;
          constructor create(v : tsym;st : tsymtable);virtual;
          procedure set_mp(p:tnode);
          function  getcopy : tnode;override;
          function  pass_1 : tnode;override;
          function  det_resulttype:tnode;override;
          function  docompare(p: tnode): boolean; override;
       end;
       tloadnodeclass = class of tloadnode;

       { different assignment types }
       tassigntype = (at_normal,at_plus,at_minus,at_star,at_slash);

       tassignmentnode = class(tbinarynode)
          assigntype : tassigntype;
          constructor create(l,r : tnode);virtual;
          function getcopy : tnode;override;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
          function docompare(p: tnode): boolean; override;
       end;
       tassignmentnodeclass = class of tassignmentnode;

       tfuncretnode = class(tnode)
          funcretsym : tfuncretsym;
          constructor create(v:tsym);virtual;
          function getcopy : tnode;override;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
          function docompare(p: tnode): boolean; override;
       end;
       tfuncretnodeclass = class of tfuncretnode;

       tarrayconstructorrangenode = class(tbinarynode)
          constructor create(l,r : tnode);virtual;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
       end;
       tarrayconstructorrangenodeclass = class of tarrayconstructorrangenode;

       tarrayconstructornode = class(tbinarynode)
          constructor create(l,r : tnode);virtual;
          function getcopy : tnode;override;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
          function docompare(p: tnode): boolean; override;
          procedure force_type(tt:ttype);
       end;
       tarrayconstructornodeclass = class of tarrayconstructornode;

       ttypenode = class(tnode)
          allowed : boolean;
          restype : ttype;
          constructor create(t : ttype);virtual;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
          function docompare(p: tnode): boolean; override;
       end;
       ttypenodeclass = class of ttypenode;

    var
       cloadnode : tloadnodeclass;
       cassignmentnode : tassignmentnodeclass;
       cfuncretnode : tfuncretnodeclass;
       carrayconstructorrangenode : tarrayconstructorrangenodeclass;
       carrayconstructornode : tarrayconstructornodeclass;
       ctypenode : ttypenodeclass;


implementation

    uses
      cutils,verbose,globtype,globals,systems,
      symconst,symdef,symtable,types,
      htypechk,pass_1,
      ncnv,nmem,cpubase,tgcpu,cgbase
      ;


{*****************************************************************************
                             TLOADNODE
*****************************************************************************}

    constructor tloadnode.create(v : tsym;st : tsymtable);

      begin
         inherited create(loadn,nil);
         if not assigned(v) then
          internalerror(200108121);
         symtableentry:=v;
         symtable:=st;
      end;


    procedure tloadnode.set_mp(p:tnode);
      begin
        left:=p;
      end;


    function tloadnode.getcopy : tnode;
      var
         n : tloadnode;

      begin
         n:=tloadnode(inherited getcopy);
         n.symtable:=symtable;
         n.symtableentry:=symtableentry;
         result:=n;
      end;


    function tloadnode.det_resulttype:tnode;
      var
        p1 : tnode;
        p  : pprocinfo;
      begin
         result:=nil;
         { optimize simple with loadings }
         if (symtable.symtabletype=withsymtable) and
            (twithsymtable(symtable).direct_with) and
            (symtableentry.typ=varsym) then
           begin
              p1:=tnode(twithsymtable(symtable).withrefnode).getcopy;
              p1:=csubscriptnode.create(tvarsym(symtableentry),p1);
              left:=nil;
              result:=p1;
              exit;
           end;
         { handle first absolute as it will replace the symtableentry }
         if symtableentry.typ=absolutesym then
           begin
             { force the resulttype to the type of the absolute }
             resulttype:=tabsolutesym(symtableentry).vartype;
             { replace the symtableentry when it points to a var, else
               we are finished }
             if tabsolutesym(symtableentry).abstyp=tovar then
              begin
                symtableentry:=tabsolutesym(symtableentry).ref;
                symtable:=symtableentry.owner;
                include(flags,nf_absolute);
              end
             else
              exit;
           end;
         case symtableentry.typ of
            funcretsym :
              begin
                { find the main funcret for the function }
                p:=procinfo;
                while assigned(p) do
                 begin
                   if assigned(p^.procdef.funcretsym) and
                      ((tfuncretsym(symtableentry)=p^.procdef.resultfuncretsym) or
                       (tfuncretsym(symtableentry)=p^.procdef.funcretsym)) then
                     begin
                       symtableentry:=p^.procdef.funcretsym;
                       break;
                     end;
                    p:=p^.parent;
                  end;
                { generate funcretnode }
                p1:=cfuncretnode.create(symtableentry);
                resulttypepass(p1);
                { if it's refered as absolute then we need to have the
                  type of the absolute instead of the function return,
                  the function return is then also assigned }
                if nf_absolute in flags then
                 begin
                   tfuncretsym(symtableentry).funcretstate:=vs_assigned;
                   p1.resulttype:=resulttype;
                 end;
                left:=nil;
                result:=p1;
              end;
            constsym:
              begin
                 if tconstsym(symtableentry).consttyp=constresourcestring then
                   resulttype:=cansistringtype
                 else
                   internalerror(22799);
              end;
            varsym :
                begin
                  { if it's refered by absolute then it's used }
                  if nf_absolute in flags then
                   tvarsym(symtableentry).varstate:=vs_used
                  else
                   resulttype:=tvarsym(symtableentry).vartype;
                end;
            typedconstsym :
                if not(nf_absolute in flags) then
                  resulttype:=ttypedconstsym(symtableentry).typedconsttype;
            procsym :
                begin
                   if assigned(tprocsym(symtableentry).definition.nextoverloaded) then
                     CGMessage(parser_e_no_overloaded_procvars);
                   resulttype.setdef(tprocsym(symtableentry).definition);
                   { if the owner of the procsym is a object,  }
                   { left must be set, if left isn't set       }
                   { it can be only self                       }
                   { this code is only used in TP procvar mode }
                   if (m_tp_procvar in aktmodeswitches) and
                      not(assigned(left)) and
                      (tprocsym(symtableentry).owner.symtabletype=objectsymtable) then
                    begin
                      left:=cselfnode.create(tobjectdef(symtableentry.owner.defowner));
                    end;

                   { process methodpointer }
                   if assigned(left) then
                    begin
                      { if only typenode then remove }
                      if left.nodetype=typen then
                       begin
                         left.free;
                         left:=nil;
                       end
                      else
                       resulttypepass(left);
                    end;
                end;
           else
             internalerror(200104141);
         end;
      end;


    function tloadnode.pass_1 : tnode;
      begin
         result:=nil;
         location.loc:=LOC_REFERENCE;
         registers32:=0;
         registersfpu:=0;
{$ifdef SUPPORT_MMX}
         registersmmx:=0;
{$endif SUPPORT_MMX}
         case symtableentry.typ of
            absolutesym :
              ;
            funcretsym :
              internalerror(200104142);
            constsym:
              begin
                 if tconstsym(symtableentry).consttyp=constresourcestring then
                   begin
                      { we use ansistrings so no fast exit here }
                      if assigned(procinfo) then
                        procinfo^.no_fast_exit:=true;
                      location.loc:=LOC_MEM;
                   end;
              end;
            varsym :
                begin
                  if (symtable.symtabletype in [parasymtable,localsymtable]) and
                      (lexlevel>symtable.symtablelevel) then
                     begin
                       { if the variable is in an other stackframe then we need
                         a register to dereference }
                       if (symtable.symtablelevel)>0 then
                        begin
                          registers32:=1;
                          { further, the variable can't be put into a register }
                          tvarsym(symtableentry).varoptions:=
                            tvarsym(symtableentry).varoptions-[vo_fpuregable,vo_regable];
                        end;
                     end;
                   if (tvarsym(symtableentry).varspez=vs_const) then
                     location.loc:=LOC_MEM;
                   { we need a register for call by reference parameters }
                   if (tvarsym(symtableentry).varspez in [vs_var,vs_out]) or
                      ((tvarsym(symtableentry).varspez=vs_const) and
                      push_addr_param(tvarsym(symtableentry).vartype.def)) or
                      { call by value open arrays are also indirect addressed }
                      is_open_array(tvarsym(symtableentry).vartype.def) then
                     registers32:=1;
                   if symtable.symtabletype=withsymtable then
                     inc(registers32);

                   if ([vo_is_thread_var,vo_is_dll_var]*tvarsym(symtableentry).varoptions)<>[] then
                     registers32:=1;
                   { count variable references }

                     { this will create problem with local var set by
                     under_procedures
                     if (assigned(tvarsym(symtableentry).owner) and assigned(aktprocsym)
                       and ((tvarsym(symtableentry).owner = aktprocsym.definition.localst)
                       or (tvarsym(symtableentry).owner = aktprocsym.definition.localst))) then }
                   if t_times<1 then
                     inc(tvarsym(symtableentry).refs)
                   else
                     inc(tvarsym(symtableentry).refs,t_times);
                end;
            typedconstsym :
                ;
            procsym :
                begin
                   { method pointer ? }
                   if assigned(left) then
                     begin
                        firstpass(left);
                        registers32:=max(registers32,left.registers32);
                        registersfpu:=max(registersfpu,left.registersfpu);
 {$ifdef SUPPORT_MMX}
                        registersmmx:=max(registersmmx,left.registersmmx);
 {$endif SUPPORT_MMX}
                     end;
                end;
           else
             internalerror(200104143);
         end;
      end;


    function tloadnode.docompare(p: tnode): boolean;
      begin
        docompare :=
          inherited docompare(p) and
          (symtableentry = tloadnode(p).symtableentry) and
          (symtable = tloadnode(p).symtable);
      end;


{*****************************************************************************
                             TASSIGNMENTNODE
*****************************************************************************}

    constructor tassignmentnode.create(l,r : tnode);

      begin
         inherited create(assignn,l,r);
         assigntype:=at_normal;
      end;

    function tassignmentnode.getcopy : tnode;

      var
         n : tassignmentnode;

      begin
         n:=tassignmentnode(inherited getcopy);
         n.assigntype:=assigntype;
         getcopy:=n;
      end;


    function tassignmentnode.det_resulttype:tnode;
      begin
        result:=nil;
        resulttype:=voidtype;

        { must be made unique }
        if assigned(left) then
          begin
             set_unique(left);

             { set we the function result? }
             set_funcret_is_valid(left);
          end;

        resulttypepass(left);
        resulttypepass(right);
        set_varstate(left,false);
        set_varstate(right,true);
        if codegenerror then
          exit;

        { assignments to open arrays aren't allowed }
        if is_open_array(left.resulttype.def) then
          CGMessage(type_e_mismatch);

        { some string functions don't need conversion, so treat them separatly }
        if not (
                is_shortstring(left.resulttype.def) and
                (
                 is_shortstring(right.resulttype.def) or
                 is_ansistring(right.resulttype.def) or
                 is_char(right.resulttype.def)
                )
               ) then
         inserttypeconv(right,left.resulttype);

        { test if node can be assigned, properties are allowed }
        valid_for_assignment(left);

        { check if local proc/func is assigned to procvar }
        if right.resulttype.def.deftype=procvardef then
          test_local_to_procvar(tprocvardef(right.resulttype.def),left.resulttype.def);
      end;


    function tassignmentnode.pass_1 : tnode;
      begin
         result:=nil;

         firstpass(left);
         firstpass(right);
         if codegenerror then
           exit;

         { some string functions don't need conversion, so treat them separatly }
         if is_shortstring(left.resulttype.def) and
            (
             is_shortstring(right.resulttype.def) or
             is_ansistring(right.resulttype.def) or
             is_char(right.resulttype.def)
            ) then
          begin
            { we call STRCOPY }
            procinfo^.flags:=procinfo^.flags or pi_do_call;
            { test for s:=s+anything ... }
            { the problem is for
              s:=s+s+s;
              this is broken here !! }
{$ifdef newoptimizations2}
            { the above is fixed now, but still problem with s := s + f(); if }
            { f modifies s (bad programming, so only enable if uncertain      }
            { optimizations are on) (JM)                                      }
            if (cs_UncertainOpts in aktglobalswitches) then
              begin
                hp := right;
                while hp.treetype=addn do hp:=hp.left;
                if equal_trees(left,hp) and
                   not multiple_uses(left,right) then
                  begin
                    concat_string:=true;
                    hp:=right;
                    while hp.treetype=addn do
                      begin
                        hp.use_strconcat:=true;
                        hp:=hp.left;
                      end;
                  end;
              end;
{$endif newoptimizations2}
          end;

         registers32:=left.registers32+right.registers32;
         registersfpu:=max(left.registersfpu,right.registersfpu);
{$ifdef SUPPORT_MMX}
         registersmmx:=max(left.registersmmx,right.registersmmx);
{$endif SUPPORT_MMX}
      end;

    function tassignmentnode.docompare(p: tnode): boolean;
      begin
        docompare :=
          inherited docompare(p) and
          (assigntype = tassignmentnode(p).assigntype);
      end;


{*****************************************************************************
                                 TFUNCRETNODE
*****************************************************************************}

    constructor tfuncretnode.create(v:tsym);

      begin
         inherited create(funcretn);
         funcretsym:=tfuncretsym(v);
      end;


    function tfuncretnode.getcopy : tnode;
      var
         n : tfuncretnode;
      begin
         n:=tfuncretnode(inherited getcopy);
         n.funcretsym:=funcretsym;
         getcopy:=n;
      end;


    function tfuncretnode.det_resulttype:tnode;
      begin
        result:=nil;
        resulttype:=funcretsym.returntype;
      end;


    function tfuncretnode.pass_1 : tnode;
      begin
         result:=nil;
         location.loc:=LOC_REFERENCE;
         if ret_in_param(resulttype.def) or
            (lexlevel<>funcretsym.owner.symtablelevel) then
           registers32:=1;
      end;


    function tfuncretnode.docompare(p: tnode): boolean;
      begin
        docompare :=
          inherited docompare(p) and
          (funcretsym = tfuncretnode(p).funcretsym);
      end;


{*****************************************************************************
                           TARRAYCONSTRUCTORRANGENODE
*****************************************************************************}

    constructor tarrayconstructorrangenode.create(l,r : tnode);

      begin
         inherited create(arrayconstructorrangen,l,r);
      end;

    function tarrayconstructorrangenode.det_resulttype:tnode;
      begin
        result:=nil;
        resulttypepass(left);
        resulttypepass(right);
        set_varstate(left,true);
        set_varstate(right,true);
        if codegenerror then
         exit;
        resulttype:=left.resulttype;
      end;


    function tarrayconstructorrangenode.pass_1 : tnode;
      begin
        firstpass(left);
        firstpass(right);
        calcregisters(self,0,0,0);
        result:=nil;
      end;


{****************************************************************************
                            TARRAYCONSTRUCTORNODE
*****************************************************************************}

    constructor tarrayconstructornode.create(l,r : tnode);
      begin
         inherited create(arrayconstructorn,l,r);
      end;


    function tarrayconstructornode.getcopy : tnode;
      var
         n : tarrayconstructornode;
      begin
         n:=tarrayconstructornode(inherited getcopy);
         result:=n;
      end;


    function tarrayconstructornode.det_resulttype:tnode;
      var
        htype : ttype;
        hp    : tarrayconstructornode;
        len   : longint;
        varia : boolean;
      begin
        result:=nil;

      { are we allowing array constructor? Then convert it to a set }
        if not allow_array_constructor then
         begin
           hp:=tarrayconstructornode(getcopy);
           arrayconstructor_to_set(hp);
           result:=hp;
           exit;
         end;

      { only pass left tree, right tree contains next construct if any }
        htype.reset;
        len:=0;
        varia:=false;
        if assigned(left) then
         begin
           hp:=self;
           while assigned(hp) do
            begin
              resulttypepass(hp.left);
              set_varstate(hp.left,true);
              if (htype.def=nil) then
               htype:=hp.left.resulttype
              else
               begin
                 if ((nf_novariaallowed in flags) or (not varia)) and
                    (not is_equal(htype.def,hp.left.resulttype.def)) then
                  begin
                    varia:=true;
                  end;
               end;
              inc(len);
              hp:=tarrayconstructornode(hp.right);
            end;
         end;
         if not assigned(htype.def) then
          htype:=voidtype;
         resulttype.setdef(tarraydef.create(0,len-1,s32bittype));
         tarraydef(resulttype.def).elementtype:=htype;
         tarraydef(resulttype.def).IsConstructor:=true;
         tarraydef(resulttype.def).IsVariant:=varia;
      end;


    procedure tarrayconstructornode.force_type(tt:ttype);
      var
        hp : tarrayconstructornode;
      begin
        tarraydef(resulttype.def).elementtype:=tt;
        tarraydef(resulttype.def).IsConstructor:=true;
        tarraydef(resulttype.def).IsVariant:=false;
        if assigned(left) then
         begin
           hp:=self;
           while assigned(hp) do
            begin
              inserttypeconv(hp.left,tt);
              hp:=tarrayconstructornode(hp.right);
            end;
         end;
      end;


    function tarrayconstructornode.pass_1 : tnode;
      var
        thp,
        chp,
        hp        : tarrayconstructornode;
        dovariant : boolean;
        htype     : ttype;
      begin
        dovariant:=(nf_forcevaria in flags) or tarraydef(resulttype.def).isvariant;
        result:=nil;
      { only pass left tree, right tree contains next construct if any }
        if assigned(left) then
         begin
           hp:=self;
           while assigned(hp) do
            begin
              firstpass(hp.left);
              { Insert typeconvs for array of const }
              if dovariant then
               begin
                 case hp.left.resulttype.def.deftype of
                   enumdef :
                     begin
                       hp.left:=ctypeconvnode.create(hp.left,s32bittype);
                       firstpass(hp.left);
                     end;
                   orddef :
                     begin
                       if is_integer(hp.left.resulttype.def) and
                         not(is_64bitint(hp.left.resulttype.def)) then
                        begin
                          hp.left:=ctypeconvnode.create(hp.left,s32bittype);
                          firstpass(hp.left);
                        end;
                     end;
                   floatdef :
                     begin
                       hp.left:=ctypeconvnode.create(hp.left,pbestrealtype^);
                       firstpass(hp.left);
                     end;
                   stringdef :
                     begin
                       if nf_cargs in flags then
                        begin
                          hp.left:=ctypeconvnode.create(hp.left,charpointertype);
                          firstpass(hp.left);
                        end;
                     end;
                   procvardef :
                     begin
                       hp.left:=ctypeconvnode.create(hp.left,voidpointertype);
                       firstpass(hp.left);
                     end;
                   pointerdef,
                   classrefdef,
                   objectdef : ;
                   else
                     CGMessagePos1(hp.left.fileinfo,type_e_wrong_type_in_array_constructor,hp.left.resulttype.def.typename);
                 end;
               end;
              hp:=tarrayconstructornode(hp.right);
            end;
         { swap the tree for cargs }
           if (nf_cargs in flags) and (not(nf_cargswap in flags)) then
            begin
              chp:=nil;
              { save resulttype }
              htype:=resulttype;
              { we need a copy here, because self is destroyed }
              { by firstpass later                             }
              hp:=tarrayconstructornode(getcopy);
              while assigned(hp) do
               begin
                 thp:=tarrayconstructornode(hp.right);
                 hp.right:=chp;
                 chp:=hp;
                 hp:=thp;
               end;
              include(chp.flags,nf_cargs);
              include(chp.flags,nf_cargswap);
              calcregisters(chp,0,0,0);
              chp.location.loc:=LOC_MEM;
              chp.resulttype:=htype;
              result:=chp;
              exit;
            end;
         end;
        calcregisters(self,0,0,0);
        location.loc:=LOC_MEM;
      end;


    function tarrayconstructornode.docompare(p: tnode): boolean;
      begin
        docompare :=
          inherited docompare(p);
      end;


{*****************************************************************************
                              TTYPENODE
*****************************************************************************}

    constructor ttypenode.create(t : ttype);
      begin
         inherited create(typen);
         restype:=t;
         allowed:=false;
      end;


    function ttypenode.det_resulttype:tnode;
      begin
        result:=nil;
        resulttype:=restype;
      end;


    function ttypenode.pass_1 : tnode;
      begin
         result:=nil;
         { a typenode can't generate code, so we give here
           an error. Else it'll be an abstract error in pass_2.
           Only when the allowed flag is set we don't generate
           an error }
         if not allowed then
          Message(parser_e_no_type_not_allowed_here);
      end;


    function ttypenode.docompare(p: tnode): boolean;
      begin
        docompare :=
          inherited docompare(p);
      end;

begin
   cloadnode:=tloadnode;
   cassignmentnode:=tassignmentnode;
   cfuncretnode:=tfuncretnode;
   carrayconstructorrangenode:=tarrayconstructorrangenode;
   carrayconstructornode:=tarrayconstructornode;
   ctypenode:=ttypenode;
end.
{
  $Log$
  Revision 1.25  2001-09-02 21:12:07  peter
    * move class of definitions into type section for delphi

  Revision 1.24  2001/08/30 15:48:34  jonas
    * fix from Peter for getting correct symtableentry for funcret loads

  Revision 1.23  2001/08/26 13:36:41  florian
    * some cg reorganisation
    * some PPC updates

  Revision 1.22  2001/08/12 22:11:52  peter
    * errordef.typesym is not updated anymore

  Revision 1.21  2001/08/06 21:40:47  peter
    * funcret moved from tprocinfo to tprocdef

  Revision 1.20  2001/07/30 20:52:25  peter
    * fixed array constructor passing with type conversions

  Revision 1.19  2001/06/04 18:07:47  peter
    * remove unused typenode for procvar load. Don't know what happened why
      this code was not there already with revision 1.17.

  Revision 1.18  2001/06/04 11:48:01  peter
    * better const to var checking

  Revision 1.17  2001/05/19 21:19:57  peter
    * remove unused typenode for procvars to prevent error
    * typenode.allowed flag to allow a typenode

  Revision 1.16  2001/05/09 19:57:51  peter
    * typenode doesn't generate code, give error in pass_1 instead of
      getting an abstract methode runtime error

  Revision 1.15  2001/04/14 14:06:31  peter
    * move more code from loadnode.pass_1 to det_resulttype

  Revision 1.14  2001/04/13 01:22:10  peter
    * symtable change to classes
    * range check generation and errors fixed, make cycle DEBUG=1 works
    * memory leaks fixed

  Revision 1.13  2001/04/05 21:03:08  peter
    * array constructor fix

  Revision 1.12  2001/04/04 22:42:40  peter
    * move constant folding into det_resulttype

  Revision 1.11  2001/04/02 21:20:31  peter
    * resulttype rewrite

  Revision 1.10  2000/12/31 11:14:10  jonas
    + implemented/fixed docompare() mathods for all nodes (not tested)
    + nopt.pas, nadd.pas, i386/n386opt.pas: optimized nodes for adding strings
      and constant strings/chars together
    * n386add.pas: don't copy temp strings (of size 256) to another temp string
      when adding

  Revision 1.9  2000/11/29 00:30:33  florian
    * unused units removed from uses clause
    * some changes for widestrings

  Revision 1.8  2000/11/04 14:25:20  florian
    + merged Attila's changes for interfaces, not tested yet

  Revision 1.7  2000/10/31 22:02:49  peter
    * symtable splitted, no real code changes

  Revision 1.6  2000/10/14 10:14:50  peter
    * moehrendorf oct 2000 rewrite

  Revision 1.5  2000/10/01 19:48:24  peter
    * lot of compile updates for cg11

  Revision 1.4  2000/09/28 19:49:52  florian
  *** empty log message ***

  Revision 1.3  2000/09/27 18:14:31  florian
    * fixed a lot of syntax errors in the n*.pas stuff

  Revision 1.2  2000/09/25 15:37:14  florian
    * more fixes

  Revision 1.1  2000/09/25 14:55:05  florian
    * initial revision
}
