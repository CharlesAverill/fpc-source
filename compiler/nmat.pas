{
    $Id$
    Copyright (c) 2000-2002 by Florian Klaempfl

    Type checking and register allocation for math nodes

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
unit nmat;

{$i fpcdefs.inc}

interface

    uses
       node;

    type
       tmoddivnode = class(tbinopnode)
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
         protected
{$ifndef cpu64bit}
          { override the following if you want to implement }
          { parts explicitely in the code generator (JM)    }
          function first_moddiv64bitint: tnode; virtual;
{$endif cpu64bit}
          function firstoptimize: tnode; virtual;
          function first_moddivint: tnode; virtual;
       end;
       tmoddivnodeclass = class of tmoddivnode;

       tshlshrnode = class(tbinopnode)
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
{$ifndef cpu64bit}
          { override the following if you want to implement }
          { parts explicitely in the code generator (CEC)
            Should return nil, if everything will be handled
            in the code generator
          }
          function first_shlshr64bitint: tnode; virtual;
{$endif cpu64bit}
       end;
       tshlshrnodeclass = class of tshlshrnode;

       tunaryminusnode = class(tunarynode)
          constructor create(expr : tnode);virtual;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
       end;
       tunaryminusnodeclass = class of tunaryminusnode;

       tnotnode = class(tunarynode)
          constructor create(expr : tnode);virtual;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
       {$ifdef state_tracking}
          function track_state_pass(exec_known:boolean):boolean;override;
       {$endif}
       end;
       tnotnodeclass = class of tnotnode;

    var
       cmoddivnode : tmoddivnodeclass;
       cshlshrnode : tshlshrnodeclass;
       cunaryminusnode : tunaryminusnodeclass;
       cnotnode : tnotnodeclass;


implementation

    uses
      systems,tokens,
      verbose,globals,cutils,
      globtype,
      symconst,symtype,symtable,symdef,symsym,defutil,
      htypechk,pass_1,cpubase,
      cgbase,procinfo,
      ncon,ncnv,ncal,nadd;

{****************************************************************************
                              TMODDIVNODE
 ****************************************************************************}

    function tmoddivnode.det_resulttype:tnode;
      var
         hp,t : tnode;
         rd,ld : torddef;
         rv,lv : tconstexprint;
      begin
         result:=nil;
         resulttypepass(left);
         resulttypepass(right);
         set_varstate(left,vs_used,true);
         set_varstate(right,vs_used,true);
         if codegenerror then
           exit;

         { we need 2 orddefs always }
         if (left.resulttype.def.deftype<>orddef) then
           inserttypeconv(right,sinttype);
         if (right.resulttype.def.deftype<>orddef) then
           inserttypeconv(right,sinttype);
         if codegenerror then
           exit;

         rd:=torddef(right.resulttype.def);
         ld:=torddef(left.resulttype.def);

         { check for division by zero }
         if is_constintnode(right) then
           begin
             rv:=tordconstnode(right).value;
             if (rv=0) then
               begin
                 Message(parser_e_division_by_zero);
                 { recover }
                 rv:=1;
               end;
             if is_constintnode(left) then
               begin
                 lv:=tordconstnode(left).value;

                 case nodetype of
                   modn:
                     if (torddef(ld).typ <> u64bit) or
                        (torddef(rd).typ <> u64bit) then
                       t:=genintconstnode(lv mod rv)
                     else
                       t:=genintconstnode(int64(qword(lv) mod qword(rv)));
                   divn:
                     if (torddef(ld).typ <> u64bit) or
                        (torddef(rd).typ <> u64bit) then
                       t:=genintconstnode(lv div rv)
                     else
                       t:=genintconstnode(int64(qword(lv) div qword(rv)));
                 end;
                 result:=t;
                 exit;
              end;
            end;

         { allow operator overloading }
         t:=self;
         if isbinaryoverloaded(t) then
           begin
              result:=t;
              exit;
           end;

         { if one operand is a cardinal and the other is a positive constant, convert the }
         { constant to a cardinal as well so we don't have to do a 64bit division (JM)    }
         { Do the same for qwords and positive constants as well, otherwise things like   }
         { "qword mod 10" are evaluated with int64 as result, which is wrong if the       }
         { "qword" was > high(int64) (JM)                                                 }
         if (rd.typ in [u32bit,u64bit]) and
            is_constintnode(left) and
            (tordconstnode(left).value >= 0) then
           inserttypeconv(left,right.resulttype)
         else
          if (ld.typ in [u32bit,u64bit]) and
             is_constintnode(right) and
             (tordconstnode(right).value >= 0) then
           inserttypeconv(right,left.resulttype);

         { when there is one currency value, everything is done
           using currency }
         if (ld.typ=scurrency) or
            (rd.typ=scurrency) then
           begin
             if (ld.typ<>scurrency) then
              inserttypeconv(left,s64currencytype);
             if (rd.typ<>scurrency) then
              inserttypeconv(right,s64currencytype);
             resulttype:=left.resulttype;
           end
         else
{$ifndef cpu64bit}
          { when there is one 64bit value, everything is done
            in 64bit }
          if (is_64bitint(left.resulttype.def) or
              is_64bitint(right.resulttype.def)) then
           begin
             if is_signed(rd) or is_signed(ld) then
               begin
                  if (torddef(ld).typ<>s64bit) then
                    inserttypeconv(left,s64inttype);
                  if (torddef(rd).typ<>s64bit) then
                    inserttypeconv(right,s64inttype);
               end
             else
               begin
                  if (torddef(ld).typ<>u64bit) then
                    inserttypeconv(left,u64inttype);
                  if (torddef(rd).typ<>u64bit) then
                    inserttypeconv(right,u64inttype);
               end;
             resulttype:=left.resulttype;
           end
         else
          { when mixing cardinals and signed numbers, convert everythign to 64bit (JM) }
          if ((rd.typ = u32bit) and
              is_signed(left.resulttype.def)) or
             ((ld.typ = u32bit) and
              is_signed(right.resulttype.def)) then
           begin
              CGMessage(type_w_mixed_signed_unsigned);
              if (torddef(ld).typ<>s64bit) then
                inserttypeconv(left,s64inttype);
              if (torddef(rd).typ<>s64bit) then
                inserttypeconv(right,s64inttype);
              resulttype:=left.resulttype;
           end
         else
{$endif cpu64bit}
           begin
              { Make everything always default singed int }
              if not(torddef(right.resulttype.def).typ in [torddef(sinttype.def).typ,torddef(uinttype.def).typ]) then
                inserttypeconv(right,sinttype);
              if not(torddef(left.resulttype.def).typ in [torddef(sinttype.def).typ,torddef(uinttype.def).typ]) then
                inserttypeconv(left,sinttype);
              resulttype:=right.resulttype;
           end;

         { when the result is currency we need some extra code for
           division. this should not be done when the divn node is
           created internally }
         if (nodetype=divn) and
            not(nf_is_currency in flags) and
            is_currency(resulttype.def) then
          begin
            hp:=caddnode.create(muln,getcopy,cordconstnode.create(10000,s64currencytype,false));
            include(hp.flags,nf_is_currency);
            result:=hp;
          end;
      end;


    function tmoddivnode.first_moddivint: tnode;
{$ifdef cpuneedsdiv32helper}
      var
        procname: string[31];
      begin
        result := nil;

        { otherwise create a call to a helper }
        if nodetype = divn then
          procname := 'fpc_div_'
        else
          procname := 'fpc_mod_';
        { only qword needs the unsigned code, the
          signed code is also used for currency }
        if is_signed(resulttype.def) then
          procname := procname + 'longint'
        else
          procname := procname + 'dword';

        result := ccallnode.createintern(procname,ccallparanode.create(left,
          ccallparanode.create(right,nil)));
        left := nil;
        right := nil;
        firstpass(result);
      end;
{$else cpuneedsdiv32helper}
      begin
        result:=nil;
      end;
{$endif cpuneedsdiv32helper}


{$ifndef cpu64bit}
    function tmoddivnode.first_moddiv64bitint: tnode;
      var
        procname: string[31];
      begin
        result := nil;

        { when currency is used set the result of the
          parameters to s64bit, so they are not converted }
        if is_currency(resulttype.def) then
          begin
            left.resulttype:=s64inttype;
            right.resulttype:=s64inttype;
          end;

        { otherwise create a call to a helper }
        if nodetype = divn then
          procname := 'fpc_div_'
        else
          procname := 'fpc_mod_';
        { only qword needs the unsigned code, the
          signed code is also used for currency }
        if is_signed(resulttype.def) then
          procname := procname + 'int64'
        else
          procname := procname + 'qword';

        result := ccallnode.createintern(procname,ccallparanode.create(left,
          ccallparanode.create(right,nil)));
        left := nil;
        right := nil;
        firstpass(result);
      end;
{$endif cpu64bit}


    function tmoddivnode.firstoptimize: tnode;
      var
        power{,shiftval} : longint;
        newtype: tnodetype;
      begin
        result := nil;
        { divide/mod a number by a constant which is a power of 2? }
        if (cs_optimize in aktglobalswitches) and
           (right.nodetype = ordconstn) and
{           ((nodetype = divn) or
            not is_signed(resulttype.def)) and}
           (not is_signed(resulttype.def)) and
           ispowerof2(tordconstnode(right).value,power) then
          begin
            if nodetype = divn then
              begin
(*
                if is_signed(resulttype.def) then
                  begin
                    if is_64bitint(left.resulttype.def) then
                      if not (cs_littlesize in aktglobalswitches) then
                        shiftval := 63
                      else
                        { the shift code is a lot bigger than the call to }
                        { the divide helper                               }
                        exit
                    else
                      shiftval := 31;
                    { we reuse left twice, so create once a copy of it     }
                    { !!! if left is a call is -> call gets executed twice }
                    left := caddnode.create(addn,left,
                      caddnode.create(andn,
                        cshlshrnode.create(sarn,left.getcopy,
                          cordconstnode.create(shiftval,sinttype,false)),
                        cordconstnode.create(tordconstnode(right).value-1,
                          right.resulttype,false)));
                    newtype := sarn;
                  end
                else
*)
                  newtype := shrn;
                tordconstnode(right).value := power;
                result := cshlshrnode.create(newtype,left,right)
              end
            else
              begin
                dec(tordconstnode(right).value);
                result := caddnode.create(andn,left,right);
              end;
            { left and right are reused }
            left := nil;
            right := nil;
            firstpass(result);
            exit;
          end;
      end;


    function tmoddivnode.pass_1 : tnode;
      begin
         result:=nil;
         firstpass(left);
         firstpass(right);
         if codegenerror then
           exit;

         { Try to optimize mod/div }
         result := firstoptimize;
         if assigned(result) then
           exit;

{$ifndef cpu64bit}
         { 64bit }
         if (left.resulttype.def.deftype=orddef) and
            (right.resulttype.def.deftype=orddef) and
            (is_64bitint(left.resulttype.def) or is_64bitint(right.resulttype.def)) then
           begin
             result := first_moddiv64bitint;
             if assigned(result) then
               exit;
             expectloc:=LOC_REGISTER;
             calcregisters(self,2,0,0);
           end
         else
{$endif cpu64bit}
           begin
             result := first_moddivint;
             if assigned(result) then
               exit;
             left_right_max;
             if left.registersint<=right.registersint then
              inc(registersint);
           end;
         expectloc:=LOC_REGISTER;
      end;



{****************************************************************************
                              TSHLSHRNODE
 ****************************************************************************}

    function tshlshrnode.det_resulttype:tnode;
      var
         t : tnode;
      begin
         result:=nil;
         resulttypepass(left);
         resulttypepass(right);
         set_varstate(right,vs_used,true);
         set_varstate(left,vs_used,true);
         if codegenerror then
           exit;

         { constant folding }
         if is_constintnode(left) and is_constintnode(right) then
           begin
              case nodetype of
                 shrn:
                   t:=genintconstnode(tordconstnode(left).value shr tordconstnode(right).value);
                 shln:
                   t:=genintconstnode(tordconstnode(left).value shl tordconstnode(right).value);
              end;
              result:=t;
              exit;
           end;

         { allow operator overloading }
         t:=self;
         if isbinaryoverloaded(t) then
           begin
              result:=t;
              exit;
           end;

{$ifndef cpu64bit}
         { 64 bit ints have their own shift handling }
         if not is_64bit(left.resulttype.def) then
{$endif cpu64bit}
           begin
             if torddef(left.resulttype.def).typ<>torddef(uinttype.def).typ then
               inserttypeconv(left,sinttype);
           end;

         inserttypeconv(right,sinttype);

         resulttype:=left.resulttype;
      end;


{$ifndef cpu64bit}
    function tshlshrnode.first_shlshr64bitint: tnode;
      var
        procname: string[31];
      begin
        result := nil;
        { otherwise create a call to a helper }
        if nodetype = shln then
          procname := 'fpc_shl_int64'
        else
          procname := 'fpc_shr_int64';
        { this order of parameters works at least for the arm,
          however it should work for any calling conventions (FK) }
        result := ccallnode.createintern(procname,ccallparanode.create(right,
          ccallparanode.create(left,nil)));
        left := nil;
        right := nil;
        firstpass(result);
      end;
{$endif cpu64bit}


    function tshlshrnode.pass_1 : tnode;
      var
         regs : longint;
      begin
         result:=nil;
         firstpass(left);
         firstpass(right);
         if codegenerror then
           exit;

{$ifndef cpu64bit}
         { 64 bit ints have their own shift handling }
         if is_64bit(left.resulttype.def) then
           begin
             result := first_shlshr64bitint;
             if assigned(result) then
               exit;
             regs:=2;
           end
         else
{$endif cpu64bit}
           begin
             regs:=1
           end;

         if (right.nodetype<>ordconstn) then
           inc(regs);
         expectloc:=LOC_REGISTER;
         calcregisters(self,regs,0,0);
      end;


{****************************************************************************
                            TUNARYMINUSNODE
 ****************************************************************************}

    constructor tunaryminusnode.create(expr : tnode);
      begin
         inherited create(unaryminusn,expr);
      end;


    function tunaryminusnode.det_resulttype : tnode;
      var
         t : tnode;
      begin
         result:=nil;
         resulttypepass(left);
         set_varstate(left,vs_used,true);
         if codegenerror then
           exit;

         { constant folding }
         if is_constintnode(left) then
           begin
              result:=genintconstnode(-tordconstnode(left).value);
              exit;
           end;
         if is_constrealnode(left) then
           begin
              trealconstnode(left).value_real:=-trealconstnode(left).value_real;
              result:=left;
              left:=nil;
              exit;
           end;

         resulttype:=left.resulttype;
         if (left.resulttype.def.deftype=floatdef) then
           begin
           end
{$ifdef SUPPORT_MMX}
         else if (cs_mmx in aktlocalswitches) and
           is_mmx_able_array(left.resulttype.def) then
             begin
               { if saturation is on, left.resulttype.def isn't
                 "mmx able" (FK)
               if (cs_mmx_saturation in aktlocalswitches^) and
                 (torddef(tarraydef(resulttype.def).definition).typ in
                 [s32bit,u32bit]) then
                 CGMessage(type_e_mismatch);
               }
             end
{$endif SUPPORT_MMX}
{$ifndef cpu64bit}
         else if is_64bitint(left.resulttype.def) then
           begin
           end
{$endif cpu64bit}
         else if (left.resulttype.def.deftype=orddef) then
           begin
              inserttypeconv(left,sinttype);
              resulttype:=left.resulttype;
           end
         else
           begin
             { allow operator overloading }
             t:=self;
             if isunaryoverloaded(t) then
               begin
                  result:=t;
                  exit;
               end;

             CGMessage(type_e_mismatch);
           end;
      end;

    { generic code     }
    { overridden by:   }
    {   i386           }
    function tunaryminusnode.pass_1 : tnode;
      begin
         result:=nil;
         firstpass(left);
         if codegenerror then
           exit;

         registersint:=left.registersint;
         registersfpu:=left.registersfpu;
{$ifdef SUPPORT_MMX}
         registersmmx:=left.registersmmx;
{$endif SUPPORT_MMX}

         if (left.resulttype.def.deftype=floatdef) then
           begin
              if (left.expectloc<>LOC_REGISTER) and
                 (registersfpu<1) then
                registersfpu:=1;
              expectloc:=LOC_FPUREGISTER;
           end
{$ifdef SUPPORT_MMX}
         else if (cs_mmx in aktlocalswitches) and
           is_mmx_able_array(left.resulttype.def) then
             begin
               if (left.expectloc<>LOC_MMXREGISTER) and
                  (registersmmx<1) then
                 registersmmx:=1;
             end
{$endif SUPPORT_MMX}
{$ifndef cpu64bit}
         else if is_64bit(left.resulttype.def) then
           begin
              if (left.expectloc<>LOC_REGISTER) and
                 (registersint<2) then
                registersint:=2;
              expectloc:=LOC_REGISTER;
           end
{$endif cpu64bit}
         else if (left.resulttype.def.deftype=orddef) then
           begin
              if (left.expectloc<>LOC_REGISTER) and
                 (registersint<1) then
                registersint:=1;
              expectloc:=LOC_REGISTER;
           end;
      end;


{****************************************************************************
                               TNOTNODE
 ****************************************************************************}

    const
      boolean_reverse:array[ltn..unequaln] of Tnodetype=(
        gten,gtn,lten,ltn,unequaln,equaln
      );

    constructor tnotnode.create(expr : tnode);
      begin
         inherited create(notn,expr);
      end;


    function tnotnode.det_resulttype : tnode;
      var
         t : tnode;
         tt : ttype;
         v : tconstexprint;
      begin
         result:=nil;
         resulttypepass(left);
         set_varstate(left,vs_used,true);
         if codegenerror then
           exit;

         resulttype:=left.resulttype;

         { Try optmimizing ourself away }
         if left.nodetype=notn then
           begin
             { Double not. Remove both }
             result:=Tnotnode(left).left;
             Tnotnode(left).left:=nil;
             exit;
           end;

         if (left.nodetype in [ltn,lten,equaln,unequaln,gtn,gten]) then
          begin
            { Not of boolean expression. Turn around the operator and remove
              the not. This is not allowed for sets with the gten/lten,
              because there is no ltn/gtn support }
            if (taddnode(left).left.resulttype.def.deftype<>setdef) or
               (left.nodetype in [equaln,unequaln]) then
             begin
               result:=left;
               left.nodetype:=boolean_reverse[left.nodetype];
               left:=nil;
               exit;
             end;
          end;

         { constant folding }
         if (left.nodetype=ordconstn) then
           begin
              v:=tordconstnode(left).value;
              tt:=left.resulttype;
              case torddef(left.resulttype.def).typ of
                bool8bit,
                bool16bit,
                bool32bit :
                  begin
                    { here we do a boolean(byte(..)) type cast because }
                    { boolean(<int64>) is buggy in 1.00                }
                    v:=byte(not(boolean(byte(v))));
                  end;
                uchar,
                uwidechar,
                u8bit,
                s8bit,
                u16bit,
                s16bit,
                u32bit,
                s32bit,
                s64bit,
                u64bit :
                  begin
                    v:=int64(not int64(v)); { maybe qword is required }
                    int_to_type(v,tt);
                  end;
                else
                  CGMessage(type_e_mismatch);
              end;
              t:=cordconstnode.create(v,tt,true);
              result:=t;
              exit;
           end;

         if is_boolean(resulttype.def) then
           begin
           end
         else
{$ifdef SUPPORT_MMX}
           if (cs_mmx in aktlocalswitches) and
             is_mmx_able_array(left.resulttype.def) then
             begin
             end
         else
{$endif SUPPORT_MMX}
{$ifndef cpu64bit}
           if is_64bitint(left.resulttype.def) then
             begin
             end
         else
{$endif cpu64bit}
           if is_integer(left.resulttype.def) then
             begin
             end
         else
           begin
             { allow operator overloading }
             t:=self;
             if isunaryoverloaded(t) then
               begin
                  result:=t;
                  exit;
               end;

             CGMessage(type_e_mismatch);
           end;
      end;


    function tnotnode.pass_1 : tnode;
      begin
         result:=nil;
         firstpass(left);
         if codegenerror then
           exit;

         expectloc:=left.expectloc;
         registersint:=left.registersint;
{$ifdef SUPPORT_MMX}
         registersmmx:=left.registersmmx;
{$endif SUPPORT_MMX}
         if is_boolean(resulttype.def) then
           begin
             if (expectloc in [LOC_REFERENCE,LOC_CREFERENCE,LOC_CREGISTER]) then
              begin
                expectloc:=LOC_REGISTER;
                if (registersint<1) then
                 registersint:=1;
              end;
            { before loading it into flags we need to load it into
              a register thus 1 register is need PM }
{$ifdef cpuflags}
             if left.expectloc<>LOC_JUMP then
               expectloc:=LOC_FLAGS;
{$endif def cpuflags}
           end
         else
{$ifdef SUPPORT_MMX}
           if (cs_mmx in aktlocalswitches) and
             is_mmx_able_array(left.resulttype.def) then
             begin
               if (left.expectloc<>LOC_MMXREGISTER) and
                 (registersmmx<1) then
                 registersmmx:=1;
             end
         else
{$endif SUPPORT_MMX}
{$ifndef cpu64bit}
           if is_64bit(left.resulttype.def) then
             begin
                if (expectloc in [LOC_REFERENCE,LOC_CREFERENCE,LOC_CREGISTER]) then
                 begin
                   expectloc:=LOC_REGISTER;
                   if (registersint<2) then
                    registersint:=2;
                 end;
             end
         else
{$endif cpu64bit}
           if is_integer(left.resulttype.def) then
             begin
               if (left.expectloc<>LOC_REGISTER) and
                  (registersint<1) then
                 registersint:=1;
               expectloc:=LOC_REGISTER;
             end;
      end;

{$ifdef state_tracking}
    function Tnotnode.track_state_pass(exec_known:boolean):boolean;
      begin
        track_state_pass:=true;
        if left.track_state_pass(exec_known) then
          begin
            left.resulttype.def:=nil;
            do_resulttypepass(left);
          end;
      end;
{$endif}

begin
   cmoddivnode:=tmoddivnode;
   cshlshrnode:=tshlshrnode;
   cunaryminusnode:=tunaryminusnode;
   cnotnode:=tnotnode;
end.
{
  $Log$
  Revision 1.61  2004-03-29 14:44:10  peter
    * fixes to previous constant integer commit

  Revision 1.60  2004/03/23 22:34:49  peter
    * constants ordinals now always have a type assigned
    * integer constants have the smallest type, unsigned prefered over
      signed

  Revision 1.59  2004/02/24 16:12:39  peter
    * operator overload chooses rewrite
    * overload choosing is now generic and moved to htypechk

  Revision 1.58  2004/02/04 22:15:15  daniel
    * Rtti generation moved to ncgutil
    * Assmtai usage of symsym removed
    * operator overloading cleanup up

  Revision 1.57  2004/02/04 19:22:27  peter
  *** empty log message ***

  Revision 1.56  2004/02/03 22:32:54  peter
    * renamed xNNbittype to xNNinttype
    * renamed registers32 to registersint
    * replace some s32bit,u32bit with torddef([su]inttype).def.typ

  Revision 1.55  2004/01/23 15:12:49  florian
    * fixed generic shl/shr operations
    + added register allocation hook calls for arm specific operand types:
      register set and shifter op

  Revision 1.54  2003/12/09 21:17:04  jonas
    + support for evaluating qword constant expressions (both arguments have
      to be a qword, constants have to be explicitly typecasted to qword)

  Revision 1.53  2003/10/08 19:19:45  peter
    * set_varstate cleanup

  Revision 1.52  2003/10/01 20:34:49  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.51  2003/09/07 22:09:35  peter
    * preparations for different default calling conventions
    * various RA fixes

  Revision 1.50  2003/09/03 11:18:37  florian
    * fixed arm concatcopy
    + arm support in the common compiler sources added
    * moved some generic cg code around
    + tfputype added
    * ...

  Revision 1.49  2003/05/24 16:32:34  jonas
    * fixed expectloc of notnode for all processors that have flags

  Revision 1.48  2003/05/09 17:47:02  peter
    * self moved to hidden parameter
    * removed hdisposen,hnewn,selfn

  Revision 1.47  2003/04/25 20:59:33  peter
    * removed funcretn,funcretsym, function result is now in varsym
      and aliases for result and function name are added using absolutesym
    * vs_hidden parameter for funcret passed in parameter
    * vs_hidden fixes
    * writenode changed to printnode and released from extdebug
    * -vp option added to generate a tree.log with the nodetree
    * nicer printnode for statements, callnode

  Revision 1.46  2003/04/23 20:16:04  peter
    + added currency support based on int64
    + is_64bit for use in cg units instead of is_64bitint
    * removed cgmessage from n386add, replace with internalerrors

  Revision 1.45  2003/04/22 23:50:23  peter
    * firstpass uses expectloc
    * checks if there are differences between the expectloc and
      location.loc from secondpass in EXTDEBUG

  Revision 1.44  2002/11/25 17:43:20  peter
    * splitted defbase in defutil,symutil,defcmp
    * merged isconvertable and is_equal into compare_defs(_ext)
    * made operator search faster by walking the list only once

  Revision 1.43  2002/10/04 21:19:28  jonas
    * fixed web bug 2139: checking for division by zero fixed

  Revision 1.42  2002/09/07 12:16:04  carl
    * second part bug report 1996 fix, testrange in cordconstnode
      only called if option is set (also make parsing a tiny faster)

  Revision 1.41  2002/09/03 16:26:26  daniel
    * Make Tprocdef.defs protected

  Revision 1.40  2002/08/25 11:32:33  peter
    * don't optimize not([lten,gten]) for setdefs

  Revision 1.39  2002/08/25 09:10:58  peter
    * fixed not(not()) removal

  Revision 1.38  2002/08/15 15:09:42  carl
    + fpu emulation helpers (ppu checking also)

  Revision 1.37  2002/08/14 19:26:55  carl
    + generic int_to_real type conversion
    + generic unaryminus node

  Revision 1.36  2002/07/20 11:57:54  florian
    * types.pas renamed to defbase.pas because D6 contains a types
      unit so this would conflicts if D6 programms are compiled
    + Willamette/SSE2 instructions to assembler added

  Revision 1.35  2002/07/19 11:41:36  daniel
  * State tracker work
  * The whilen and repeatn are now completely unified into whilerepeatn. This
    allows the state tracker to change while nodes automatically into
    repeat nodes.
  * Resulttypepass improvements to the notn. 'not not a' is optimized away and
    'not(a>b)' is optimized into 'a<=b'.
  * Resulttypepass improvements to the whilerepeatn. 'while not a' is optimized
    by removing the notn and later switchting the true and falselabels. The
    same is done with 'repeat until not a'.

  Revision 1.34  2002/05/18 13:34:10  peter
    * readded missing revisions

  Revision 1.33  2002/05/16 19:46:39  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.31  2002/04/07 13:26:10  carl
  + change unit use

  Revision 1.30  2002/04/02 17:11:29  peter
    * tlocation,treference update
    * LOC_CONSTANT added for better constant handling
    * secondadd splitted in multiple routines
    * location_force_reg added for loading a location to a register
      of a specified size
    * secondassignment parses now first the right and then the left node
      (this is compatible with Kylix). This saves a lot of push/pop especially
      with string operations
    * adapted some routines to use the new cg methods

  Revision 1.29  2002/03/04 19:10:11  peter
    * removed compiler warnings

  Revision 1.28  2002/02/11 11:45:51  michael
  * Compilation without mmx support fixed from Peter

}
