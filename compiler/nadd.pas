{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl

    Type checking and register allocation for add nodes

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
unit nadd;

{$i fpcdefs.inc}

{ define addstringopt}

interface

    uses
      node;

    type
       taddnode = class(tbinopnode)
          constructor create(tt : tnodetype;l,r : tnode);override;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
    {$ifdef state_tracking}
      function track_state_pass(exec_known:boolean):boolean;override;
    {$endif}
         protected
          { override the following if you want to implement }
          { parts explicitely in the code generator (JM)    }
          function first_addstring: tnode; virtual;
          function first_addset: tnode; virtual;
          { only implements "muln" nodes, the rest always has to be done in }
          { the code generator for performance reasons (JM)                 }
          function first_add64bitint: tnode; virtual;
{$ifdef cpufpemu}
          { This routine calls internal runtime library helpers
            for all floating point arithmetic in the case
            where the emulation switches is on. Otherwise
            returns nil, and everything must be done in
            the code generation phase.
          }
          function first_addfloat : tnode; virtual;
{$endif cpufpemu}
       end;
       taddnodeclass = class of taddnode;

    var
       { caddnode is used to create nodes of the add type }
       { the virtual constructor allows to assign         }
       { another class type to caddnode => processor      }
       { specific node types can be created               }
       caddnode : taddnodeclass;

implementation

    uses
      globtype,systems,
      cutils,verbose,globals,widestr,
      symconst,symtype,symdef,symsym,symtable,defutil,defcmp,
      cgbase,
      htypechk,pass_1,
      nbas,nmat,ncnv,ncon,nset,nopt,ncal,ninl,nmem,nutils,
      {$ifdef state_tracking}
      nstate,
      {$endif}
      cpuinfo,procinfo;


{*****************************************************************************
                                TADDNODE
*****************************************************************************}

{$ifdef fpc}
{$maxfpuregisters 0}
{$endif fpc}

    constructor taddnode.create(tt : tnodetype;l,r : tnode);
      begin
         inherited create(tt,l,r);
      end;


    function taddnode.det_resulttype:tnode;
      var
         hp,t    : tnode;
         lt,rt   : tnodetype;
         rd,ld   : tdef;
         htype   : ttype;
         ot      : tnodetype;
         concatstrings : boolean;
         resultset : Tconstset;
         i       : longint;
         b       : boolean;
         c1,c2   :char;
         s1,s2   : pchar;
         ws1,ws2 : pcompilerwidestring;
         l1,l2   : longint;
         rv,lv   : tconstexprint;
         rvd,lvd : bestreal;
         resultrealtype : ttype;
{$ifdef state_tracking}
     factval : Tnode;
     change  : boolean;
{$endif}

      begin
         result:=nil;
         { first do the two subtrees }
         resulttypepass(left);
         resulttypepass(right);
         { both left and right need to be valid }
         set_varstate(left,vs_used,true);
         set_varstate(right,vs_used,true);
         if codegenerror then
           exit;

         { tp procvar support }
         maybe_call_procvar(left,true);
         maybe_call_procvar(right,true);

         { convert array constructors to sets, because there is no other operator
           possible for array constructors }
         if is_array_constructor(left.resulttype.def) then
          begin
            arrayconstructor_to_set(left);
            resulttypepass(left);
          end;
         if is_array_constructor(right.resulttype.def) then
          begin
            arrayconstructor_to_set(right);
            resulttypepass(right);
          end;

         { allow operator overloading }
         hp:=self;
         if isbinaryoverloaded(hp) then
           begin
              result:=hp;
              exit;
           end;
         { Stop checking when an error was found in the operator checking }
         if codegenerror then
           begin
             result:=cerrornode.create;
             exit;
           end;


         { Kylix allows enum+ordconstn in an enum declaration (blocktype
           is bt_type), we need to do the conversion here before the
           constant folding }
         if (m_delphi in aktmodeswitches) and
            (blocktype=bt_type) then
          begin
            if (left.resulttype.def.deftype=enumdef) and
               (right.resulttype.def.deftype=orddef) then
             begin
               { insert explicit typecast to default signed int }
               left:=ctypeconvnode.create_explicit(left,sinttype);
               resulttypepass(left);
             end
            else
             if (left.resulttype.def.deftype=orddef) and
                (right.resulttype.def.deftype=enumdef) then
              begin
                { insert explicit typecast to default signed int }
                right:=ctypeconvnode.create_explicit(right,sinttype);
                resulttypepass(right);
              end;
          end;

         { is one a real float, then both need to be floats, this
           need to be done before the constant folding so constant
           operation on a float and int are also handled }
         resultrealtype:=pbestrealtype^;
         if (right.resulttype.def.deftype=floatdef) or (left.resulttype.def.deftype=floatdef) then
          begin
            { when both floattypes are already equal then use that
              floattype for results }
            if (right.resulttype.def.deftype=floatdef) and
               (left.resulttype.def.deftype=floatdef) and
               (tfloatdef(left.resulttype.def).typ=tfloatdef(right.resulttype.def).typ) then
              resultrealtype:=left.resulttype
            { when there is a currency type then use currency, but
              only when currency is defined as float }
            else
             if (is_currency(right.resulttype.def) or
                 is_currency(left.resulttype.def)) and
                ((s64currencytype.def.deftype = floatdef) or
                 (nodetype <> slashn)) then
              begin
                resultrealtype:=s64currencytype;
                inserttypeconv(right,resultrealtype);
                inserttypeconv(left,resultrealtype);
              end
            else
             begin
               inserttypeconv(right,resultrealtype);
               inserttypeconv(left,resultrealtype);
             end;
          end;

         { If both operands are constant and there is a widechar
           or widestring then convert everything to widestring. This
           allows constant folding like char+widechar }
         if is_constnode(right) and is_constnode(left) and
            (is_widestring(right.resulttype.def) or
             is_widestring(left.resulttype.def) or
             is_widechar(right.resulttype.def) or
             is_widechar(left.resulttype.def)) then
           begin
             inserttypeconv(right,cwidestringtype);
             inserttypeconv(left,cwidestringtype);
           end;

         { load easier access variables }
         rd:=right.resulttype.def;
         ld:=left.resulttype.def;
         rt:=right.nodetype;
         lt:=left.nodetype;

         if (nodetype = slashn) and
            (((rt = ordconstn) and
              (tordconstnode(right).value = 0)) or
             ((rt = realconstn) and
              (trealconstnode(right).value_real = 0.0))) then
           begin
             if (cs_check_range in aktlocalswitches) or
                (cs_check_overflow in aktlocalswitches) then
                begin
                  result:=crealconstnode.create(1,pbestrealtype^);
                  Message(parser_e_division_by_zero);
                  exit;
                end;
           end;


         { both are int constants }
         if ((is_constintnode(left) and is_constintnode(right)) or
              (is_constboolnode(left) and is_constboolnode(right) and
               (nodetype in [slashn,ltn,lten,gtn,gten,equaln,unequaln,andn,xorn,orn])) or
              (is_constenumnode(left) and is_constenumnode(right) and
               (nodetype in [equaln,unequaln,ltn,lten,gtn,gten]))) or
            { support pointer arithmetics on constants (JM) }
            ((lt = pointerconstn) and is_constintnode(right) and
             (nodetype in [addn,subn])) or
            (((lt = pointerconstn) or (lt = niln)) and
             ((rt = pointerconstn) or (rt = niln)) and
             (nodetype in [ltn,lten,gtn,gten,equaln,unequaln,subn])) then
           begin
              { when comparing/substracting  pointers, make sure they are }
              { of the same  type (JM)                                    }
              if (lt = pointerconstn) and (rt = pointerconstn) then
               begin
                 if not(cs_extsyntax in aktmoduleswitches) and
                    not(nodetype in [equaln,unequaln]) then
                   CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename)
                 else
                   if (nodetype <> subn) and
                      is_voidpointer(rd) then
                     inserttypeconv(right,left.resulttype)
                   else if (nodetype <> subn) and
                           is_voidpointer(ld) then
                     inserttypeconv(left,right.resulttype)
                   else if not(equal_defs(ld,rd)) then
                     IncompatibleTypes(ld,rd);
                end
              else if (ld.deftype=enumdef) and (rd.deftype=enumdef) then
               begin
                 if not(equal_defs(ld,rd)) then
                   inserttypeconv(right,left.resulttype);
                end;

              { load values }
              case lt of
                ordconstn:
                  lv:=tordconstnode(left).value;
                pointerconstn:
                  lv:=tpointerconstnode(left).value;
                niln:
                  lv:=0;
                else
                  internalerror(2002080202);
              end;
              case rt of
                ordconstn:
                  rv:=tordconstnode(right).value;
                pointerconstn:
                  rv:=tpointerconstnode(right).value;
                niln:
                  rv:=0;
                else
                  internalerror(2002080203);
              end;
              if (lt = pointerconstn) and
                 (rt <> pointerconstn) then
                rv := rv * tpointerdef(left.resulttype.def).pointertype.def.size;
              if (rt = pointerconstn) and
                 (lt <> pointerconstn) then
                lv := lv * tpointerdef(right.resulttype.def).pointertype.def.size;
              case nodetype of
                addn :
                  if (lt <> pointerconstn) then
                    t := genintconstnode(lv+rv)
                  else
                    t := cpointerconstnode.create(lv+rv,left.resulttype);
                subn :
                  if (lt=pointerconstn) and (rt=pointerconstn) and
                    (tpointerdef(rd).pointertype.def.size>1) then
                    t := genintconstnode((lv-rv) div tpointerdef(left.resulttype.def).pointertype.def.size)
                  else if (lt <> pointerconstn) or (rt = pointerconstn) then
                    t := genintconstnode(lv-rv)
                  else
                    t := cpointerconstnode.create(lv-rv,left.resulttype);
                muln :
                  if (torddef(ld).typ <> u64bit) or
                     (torddef(rd).typ <> u64bit) then
                    t:=genintconstnode(lv*rv)
                  else
                    t:=genintconstnode(int64(qword(lv)*qword(rv)));
                xorn :
                  if is_integer(ld) then
                    t:=genintconstnode(lv xor rv)
                  else
                    t:=cordconstnode.create(lv xor rv,left.resulttype,true);
                orn :
                  if is_integer(ld) then
                    t:=genintconstnode(lv or rv)
                  else
                    t:=cordconstnode.create(lv or rv,left.resulttype,true);
                andn :
                  if is_integer(ld) then
                    t:=genintconstnode(lv and rv)
                  else
                    t:=cordconstnode.create(lv and rv,left.resulttype,true);
                ltn :
                  t:=cordconstnode.create(ord(lv<rv),booltype,true);
                lten :
                  t:=cordconstnode.create(ord(lv<=rv),booltype,true);
                gtn :
                  t:=cordconstnode.create(ord(lv>rv),booltype,true);
                gten :
                  t:=cordconstnode.create(ord(lv>=rv),booltype,true);
                equaln :
                  t:=cordconstnode.create(ord(lv=rv),booltype,true);
                unequaln :
                  t:=cordconstnode.create(ord(lv<>rv),booltype,true);
                slashn :
                  begin
                    { int/int becomes a real }
                    rvd:=rv;
                    lvd:=lv;
                    t:=crealconstnode.create(lvd/rvd,resultrealtype);
                  end;
                else
                  begin
                    CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
                    t:=cnothingnode.create;
                  end;
              end;
              result:=t;
              exit;
           end;

       { both real constants ? }
         if (lt=realconstn) and (rt=realconstn) then
           begin
              lvd:=trealconstnode(left).value_real;
              rvd:=trealconstnode(right).value_real;
              case nodetype of
                 addn :
                   t:=crealconstnode.create(lvd+rvd,resultrealtype);
                 subn :
                   t:=crealconstnode.create(lvd-rvd,resultrealtype);
                 muln :
                   t:=crealconstnode.create(lvd*rvd,resultrealtype);
                 starstarn,
                 caretn :
                   begin
                     if lvd<0 then
                      begin
                        Message(parser_e_invalid_float_operation);
                        t:=crealconstnode.create(0,resultrealtype);
                      end
                     else if lvd=0 then
                       t:=crealconstnode.create(1.0,resultrealtype)
                     else
                       t:=crealconstnode.create(exp(ln(lvd)*rvd),resultrealtype);
                   end;
                 slashn :
                   t:=crealconstnode.create(lvd/rvd,resultrealtype);
                 ltn :
                   t:=cordconstnode.create(ord(lvd<rvd),booltype,true);
                 lten :
                   t:=cordconstnode.create(ord(lvd<=rvd),booltype,true);
                 gtn :
                   t:=cordconstnode.create(ord(lvd>rvd),booltype,true);
                 gten :
                   t:=cordconstnode.create(ord(lvd>=rvd),booltype,true);
                 equaln :
                   t:=cordconstnode.create(ord(lvd=rvd),booltype,true);
                 unequaln :
                   t:=cordconstnode.create(ord(lvd<>rvd),booltype,true);
                 else
                   begin
                     CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
                     t:=cnothingnode.create;
                   end;
              end;
              result:=t;
              exit;
           end;

         { first, we handle widestrings, so we can check later for }
         { stringconstn only                                       }

         { widechars are converted above to widestrings too }
         { this isn't veryy efficient, but I don't think    }
         { that it does matter that much (FK)               }
         if (lt=stringconstn) and (rt=stringconstn) and
           (tstringconstnode(left).st_type=st_widestring) and
           (tstringconstnode(right).st_type=st_widestring) then
           begin
              initwidestring(ws1);
              initwidestring(ws2);
              copywidestring(pcompilerwidestring(tstringconstnode(left).value_str),ws1);
              copywidestring(pcompilerwidestring(tstringconstnode(right).value_str),ws2);
              case nodetype of
                 addn :
                   begin
                      concatwidestrings(ws1,ws2);
                      t:=cstringconstnode.createwstr(ws1);
                   end;
                 ltn :
                   t:=cordconstnode.create(byte(comparewidestrings(ws1,ws2)<0),booltype,true);
                 lten :
                   t:=cordconstnode.create(byte(comparewidestrings(ws1,ws2)<=0),booltype,true);
                 gtn :
                   t:=cordconstnode.create(byte(comparewidestrings(ws1,ws2)>0),booltype,true);
                 gten :
                   t:=cordconstnode.create(byte(comparewidestrings(ws1,ws2)>=0),booltype,true);
                 equaln :
                   t:=cordconstnode.create(byte(comparewidestrings(ws1,ws2)=0),booltype,true);
                 unequaln :
                   t:=cordconstnode.create(byte(comparewidestrings(ws1,ws2)<>0),booltype,true);
                 else
                   begin
                     CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
                     t:=cnothingnode.create;
                   end;
              end;
              donewidestring(ws1);
              donewidestring(ws2);
              result:=t;
              exit;
           end;

         { concating strings ? }
         concatstrings:=false;

         if (lt=ordconstn) and (rt=ordconstn) and
            is_char(ld) and is_char(rd) then
           begin
              c1:=char(byte(tordconstnode(left).value));
              l1:=1;
              c2:=char(byte(tordconstnode(right).value));
              l2:=1;
              s1:=@c1;
              s2:=@c2;
              concatstrings:=true;
           end
         else if (lt=stringconstn) and (rt=ordconstn) and is_char(rd) then
           begin
              s1:=tstringconstnode(left).value_str;
              l1:=tstringconstnode(left).len;
              c2:=char(byte(tordconstnode(right).value));
              s2:=@c2;
              l2:=1;
              concatstrings:=true;
           end
         else if (lt=ordconstn) and (rt=stringconstn) and is_char(ld) then
           begin
              c1:=char(byte(tordconstnode(left).value));
              l1:=1;
              s1:=@c1;
              s2:=tstringconstnode(right).value_str;
              l2:=tstringconstnode(right).len;
              concatstrings:=true;
           end
         else if (lt=stringconstn) and (rt=stringconstn) then
           begin
              s1:=tstringconstnode(left).value_str;
              l1:=tstringconstnode(left).len;
              s2:=tstringconstnode(right).value_str;
              l2:=tstringconstnode(right).len;
              concatstrings:=true;
           end;
         if concatstrings then
           begin
              case nodetype of
                 addn :
                   t:=cstringconstnode.createpchar(concatansistrings(s1,s2,l1,l2),l1+l2);
                 ltn :
                   t:=cordconstnode.create(byte(compareansistrings(s1,s2,l1,l2)<0),booltype,true);
                 lten :
                   t:=cordconstnode.create(byte(compareansistrings(s1,s2,l1,l2)<=0),booltype,true);
                 gtn :
                   t:=cordconstnode.create(byte(compareansistrings(s1,s2,l1,l2)>0),booltype,true);
                 gten :
                   t:=cordconstnode.create(byte(compareansistrings(s1,s2,l1,l2)>=0),booltype,true);
                 equaln :
                   t:=cordconstnode.create(byte(compareansistrings(s1,s2,l1,l2)=0),booltype,true);
                 unequaln :
                   t:=cordconstnode.create(byte(compareansistrings(s1,s2,l1,l2)<>0),booltype,true);
              end;
              result:=t;
              exit;
           end;

         { set constant evaluation }
         if (right.nodetype=setconstn) and
            not assigned(tsetconstnode(right).left) and
            (left.nodetype=setconstn) and
            not assigned(tsetconstnode(left).left) then
           begin
              { check if size adjusting is needed, only for left
                to right as the other way is checked in the typeconv }
              if (tsetdef(right.resulttype.def).settype=smallset) and
                 (tsetdef(left.resulttype.def).settype<>smallset) then
                right.resulttype.setdef(tsetdef.create(tsetdef(right.resulttype.def).elementtype,255));
              { check base types }
              inserttypeconv(left,right.resulttype);

              if codegenerror then
               begin
                 { recover by only returning the left part }
                 result:=left;
                 left:=nil;
                 exit;
               end;
              case nodetype of
                addn :
                  begin
                    resultset:=tsetconstnode(right).value_set^ + tsetconstnode(left).value_set^;
                    t:=csetconstnode.create(@resultset,left.resulttype);
                  end;
                 muln :
                   begin
                     resultset:=tsetconstnode(right).value_set^ * tsetconstnode(left).value_set^;
                     t:=csetconstnode.create(@resultset,left.resulttype);
                   end;
                subn :
                   begin
                     resultset:=tsetconstnode(left).value_set^ - tsetconstnode(right).value_set^;
                             t:=csetconstnode.create(@resultset,left.resulttype);
                   end;
                symdifn :
                   begin
                     resultset:=tsetconstnode(right).value_set^ >< tsetconstnode(left).value_set^;
                         t:=csetconstnode.create(@resultset,left.resulttype);
                   end;
                unequaln :
                   begin
                     b:=tsetconstnode(right).value_set^ <> tsetconstnode(left).value_set^;
                     t:=cordconstnode.create(byte(b),booltype,true);
                   end;
                equaln :
                   begin
                     b:=tsetconstnode(right).value_set^ = tsetconstnode(left).value_set^;
                     t:=cordconstnode.create(byte(b),booltype,true);
                   end;
                lten :
                   begin
                     b:=tsetconstnode(left).value_set^ <= tsetconstnode(right).value_set^;
                     t:=cordconstnode.create(byte(b),booltype,true);
                   end;
                gten :
                   begin
                     b:=tsetconstnode(left).value_set^ >= tsetconstnode(right).value_set^;
                     t:=cordconstnode.create(byte(b),booltype,true);
                   end;
              end;
              result:=t;
              exit;
           end;

         { but an int/int gives real/real! }
         if nodetype=slashn then
          begin
            if is_currency(left.resulttype.def) and
               is_currency(right.resulttype.def) then
              { In case of currency, converting to float means dividing by 10000 }
              { However, since this is already a division, both divisions by     }
              { 10000 are eliminated when we divide the results -> we can skip   }
              { them.                                                            }
              if s64currencytype.def.deftype = floatdef then
                begin
                  { there's no s64comptype or so, how do we avoid the type conversion?
                  left.resulttype := s64comptype;
                  right.resulttype := s64comptype; }
                end
              else
                begin
                  left.resulttype := s64inttype;
                  right.resulttype := s64inttype;
                end
            else if (left.resulttype.def.deftype <> floatdef) and
               (right.resulttype.def.deftype <> floatdef) then
              CGMessage(type_h_use_div_for_int);
            inserttypeconv(right,resultrealtype);
            inserttypeconv(left,resultrealtype);
          end

         { if both are orddefs then check sub types }
         else if (ld.deftype=orddef) and (rd.deftype=orddef) then
           begin
             { optimize multiplacation by a power of 2 }
             if not(cs_check_overflow in aktlocalswitches) and
                (nodetype = muln) and
                (((left.nodetype = ordconstn) and
                  ispowerof2(tordconstnode(left).value,i)) or
                 ((right.nodetype = ordconstn) and
                  ispowerof2(tordconstnode(right).value,i))) then
               begin
                 if left.nodetype = ordconstn then
                   begin
                     tordconstnode(left).value := i;
                     result := cshlshrnode.create(shln,right,left);
                   end
                 else
                   begin
                     tordconstnode(right).value := i;
                     result := cshlshrnode.create(shln,left,right);
                   end;
                 left := nil;
                 right := nil;
                 exit;
               end;

             { 2 booleans? Make them equal to the largest boolean }
             if is_boolean(ld) and is_boolean(rd) then
              begin
                if torddef(left.resulttype.def).size>torddef(right.resulttype.def).size then
                 begin
                   right:=ctypeconvnode.create_explicit(right,left.resulttype);
                   ttypeconvnode(right).convtype:=tc_bool_2_int;
                   resulttypepass(right);
                 end
                else if torddef(left.resulttype.def).size<torddef(right.resulttype.def).size then
                 begin
                   left:=ctypeconvnode.create_explicit(left,right.resulttype);
                   ttypeconvnode(left).convtype:=tc_bool_2_int;
                   resulttypepass(left);
                 end;
                case nodetype of
                  xorn,
                  ltn,
                  lten,
                  gtn,
                  gten,
                  andn,
                  orn:
                    begin
                    end;
                  unequaln,
                  equaln:
                    begin
                      if not(cs_full_boolean_eval in aktlocalswitches) then
                       begin
                         { Remove any compares with constants }
                         if (left.nodetype=ordconstn) then
                          begin
                            hp:=right;
                            b:=(tordconstnode(left).value<>0);
                            ot:=nodetype;
                            left.free;
                            left:=nil;
                            right:=nil;
                            if (not(b) and (ot=equaln)) or
                               (b and (ot=unequaln)) then
                             begin
                               hp:=cnotnode.create(hp);
                             end;
                            result:=hp;
                            exit;
                          end;
                         if (right.nodetype=ordconstn) then
                          begin
                            hp:=left;
                            b:=(tordconstnode(right).value<>0);
                            ot:=nodetype;
                            right.free;
                            right:=nil;
                            left:=nil;
                            if (not(b) and (ot=equaln)) or
                               (b and (ot=unequaln)) then
                             begin
                               hp:=cnotnode.create(hp);
                             end;
                            result:=hp;
                            exit;
                          end;
                       end;
                    end;
                  else
                    CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
                end;
              end
             { Both are chars? }
             else if is_char(rd) and is_char(ld) then
               begin
                 if nodetype=addn then
                  begin
                    resulttype:=cshortstringtype;
                    if not(is_constcharnode(left) and is_constcharnode(right)) then
                     begin
                       inserttypeconv(left,cshortstringtype);
{$ifdef addstringopt}
                       hp := genaddsstringcharoptnode(self);
                       result := hp;
                       exit;
{$endif addstringopt}
                     end;
                  end;
               end
             { There is a widechar? }
             else if is_widechar(rd) or is_widechar(ld) then
               begin
                 { widechar+widechar gives widestring }
                 if nodetype=addn then
                   begin
                     inserttypeconv(left,cwidestringtype);
                     if (torddef(rd).typ<>uwidechar) then
                       inserttypeconv(right,cwidechartype);
                     resulttype:=cwidestringtype;
                   end
                 else
                   begin
                     if (torddef(ld).typ<>uwidechar) then
                       inserttypeconv(left,cwidechartype);
                     if (torddef(rd).typ<>uwidechar) then
                       inserttypeconv(right,cwidechartype);
                   end;
               end
             { is there a currency type ? }
             else if ((torddef(rd).typ=scurrency) or (torddef(ld).typ=scurrency)) then
               begin
                  if (torddef(ld).typ<>scurrency) then
                   inserttypeconv(left,s64currencytype);
                  if (torddef(rd).typ<>scurrency) then
                   inserttypeconv(right,s64currencytype);
               end
             { is there a signed 64 bit type ? }
             else if ((torddef(rd).typ=s64bit) or (torddef(ld).typ=s64bit)) then
               begin
                  if (torddef(ld).typ<>s64bit) then
                   inserttypeconv(left,s64inttype);
                  if (torddef(rd).typ<>s64bit) then
                   inserttypeconv(right,s64inttype);
               end
             { is there a unsigned 64 bit type ? }
             else if ((torddef(rd).typ=u64bit) or (torddef(ld).typ=u64bit)) then
               begin
                  if (torddef(ld).typ<>u64bit) then
                   inserttypeconv(left,u64inttype);
                  if (torddef(rd).typ<>u64bit) then
                   inserttypeconv(right,u64inttype);
               end
             { 64 bit cpus do calculations always in 64 bit }
{$ifndef cpu64bit}
             { is there a cardinal? }
             else if ((torddef(rd).typ=u32bit) or (torddef(ld).typ=u32bit)) then
               begin
                 { and,or,xor work on bit patterns and don't care
                   about the sign }
                 if nodetype in [andn,orn,xorn] then
                   begin
                     inserttypeconv_explicit(left,u32inttype);
                     inserttypeconv_explicit(right,u32inttype);
                   end
                 else
                   begin
                     { convert positive constants to u32bit }
                     if (torddef(ld).typ<>u32bit) and
                        is_constintnode(left) and
                        (tordconstnode(left).value >= 0) then
                       inserttypeconv(left,u32inttype);
                     if (torddef(rd).typ<>u32bit) and
                        is_constintnode(right) and
                        (tordconstnode(right).value >= 0) then
                       inserttypeconv(right,u32inttype);
                     { when one of the operand is signed perform
                       the operation in 64bit }
                     if is_signed(ld) or is_signed(rd) then
                       begin
                         CGMessage(type_w_mixed_signed_unsigned);
                         inserttypeconv(left,s64inttype);
                         inserttypeconv(right,s64inttype);
                       end
                     else
                       begin
                         if (torddef(ld).typ<>u32bit) then
                           inserttypeconv(left,u32inttype);
                         if (torddef(rd).typ<>u32bit) then
                           inserttypeconv(right,u32inttype);
                       end;
                   end;
               end
{$endif cpu64bit}
             { generic ord conversion is sinttype }
             else
               begin
                 { if the left or right value is smaller than the normal
                   type s32inttype and is unsigned, and the other value
                   is a constant < 0, the result will always be false/true
                   for equal / unequal nodes.
                 }
                 if (
                      { left : unsigned ordinal var, right : < 0 constant }
                      (
                       ((is_signed(ld)=false) and (is_constintnode(left) =false)) and
                       ((is_constintnode(right)) and (tordconstnode(right).value < 0))
                      ) or
                      { right : unsigned ordinal var, left : < 0 constant }
                      (
                       ((is_signed(rd)=false) and (is_constintnode(right) =false)) and
                       ((is_constintnode(left)) and (tordconstnode(left).value < 0))
                      )
                    )  then
                    begin
                      if nodetype = equaln then
                         CGMessage(type_w_signed_unsigned_always_false)
                      else
                      if nodetype = unequaln then
                         CGMessage(type_w_signed_unsigned_always_true)
                      else
                      if (is_constintnode(left) and (nodetype in [ltn,lten])) or
                         (is_constintnode(right) and (nodetype in [gtn,gten])) then
                         CGMessage(type_w_signed_unsigned_always_true)
                      else
                      if (is_constintnode(right) and (nodetype in [ltn,lten])) or
                         (is_constintnode(left) and (nodetype in [gtn,gten])) then
                         CGMessage(type_w_signed_unsigned_always_false);
                    end;

                 inserttypeconv(right,sinttype);
                 inserttypeconv(left,sinttype);
               end;
           end

         { if both are floatdefs, conversion is already done before constant folding }
         else if (ld.deftype=floatdef) then
           begin
             { already converted }
           end

         { left side a setdef, must be before string processing,
           else array constructor can be seen as array of char (PFV) }
         else if (ld.deftype=setdef) then
          begin
            { trying to add a set element? }
            if (nodetype=addn) and (rd.deftype<>setdef) then
             begin
               if (rt=setelementn) then
                begin
                  if not(equal_defs(tsetdef(ld).elementtype.def,rd)) then
                   CGMessage(type_e_set_element_are_not_comp);
                end
               else
                CGMessage(type_e_mismatch)
             end
            else
             begin
               if not(nodetype in [addn,subn,symdifn,muln,equaln,unequaln,lten,gten]) then
                CGMessage(type_e_set_operation_unknown);
               { right def must be a also be set }
               if (rd.deftype<>setdef) or not(equal_defs(rd,ld)) then
                CGMessage(type_e_set_element_are_not_comp);
             end;

            { ranges require normsets }
            if (tsetdef(ld).settype=smallset) and
               (rt=setelementn) and
               assigned(tsetelementnode(right).right) then
             begin
               { generate a temporary normset def, it'll be destroyed
                 when the symtable is unloaded }
               htype.setdef(tsetdef.create(tsetdef(ld).elementtype,255));
               inserttypeconv(left,htype);
             end;

            { if the right side is also a setdef then the settype must
              be the same as the left setdef }
            if (rd.deftype=setdef) and
               (tsetdef(ld).settype<>tsetdef(rd).settype) then
             begin
               { when right is a normset we need to typecast both
                 to normsets }
               if (tsetdef(rd).settype=normset) then
                inserttypeconv(left,right.resulttype)
               else
                inserttypeconv(right,left.resulttype);
             end;
          end

         { compare pchar to char arrays by addresses like BP/Delphi }
         else if ((is_pchar(ld) or (lt=niln)) and is_chararray(rd)) or
                 ((is_pchar(rd) or (rt=niln)) and is_chararray(ld)) then
           begin
             if is_chararray(rd) then
              inserttypeconv(right,charpointertype)
             else
              inserttypeconv(left,charpointertype);
           end

         { pointer comparision and subtraction }
         else if (rd.deftype=pointerdef) and (ld.deftype=pointerdef) then
          begin
            case nodetype of
               equaln,unequaln :
                 begin
                    if is_voidpointer(right.resulttype.def) then
                      inserttypeconv(right,left.resulttype)
                    else if is_voidpointer(left.resulttype.def) then
                      inserttypeconv(left,right.resulttype)
                    else if not(equal_defs(ld,rd)) then
                      IncompatibleTypes(ld,rd);
                 end;
               ltn,lten,gtn,gten:
                 begin
                    if (cs_extsyntax in aktmoduleswitches) then
                     begin
                       if is_voidpointer(right.resulttype.def) then
                        inserttypeconv(right,left.resulttype)
                       else if is_voidpointer(left.resulttype.def) then
                        inserttypeconv(left,right.resulttype)
                       else if not(equal_defs(ld,rd)) then
                        IncompatibleTypes(ld,rd);
                     end
                    else
                     CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
                 end;
               subn:
                 begin
                    if (cs_extsyntax in aktmoduleswitches) then
                      begin
                        if is_voidpointer(right.resulttype.def) then
                          inserttypeconv(right,left.resulttype)
                        else if is_voidpointer(left.resulttype.def) then
                          inserttypeconv(left,right.resulttype)
                        else if not(equal_defs(ld,rd)) then
                          IncompatibleTypes(ld,rd);
                      end
                    else
                      CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);

                    if not(nf_has_pointerdiv in flags) and
                      (tpointerdef(rd).pointertype.def.size>1) then
                      begin
                        hp:=getcopy;
                        include(hp.flags,nf_has_pointerdiv);
                        result:=cmoddivnode.create(divn,hp,cordconstnode.create(tpointerdef(rd).pointertype.def.size,sinttype,false));
                      end;
                    resulttype:=sinttype;
                    exit;
                 end;
               addn:
                 begin
                    if (cs_extsyntax in aktmoduleswitches) then
                     begin
                       if is_voidpointer(right.resulttype.def) then
                         inserttypeconv(right,left.resulttype)
                       else if is_voidpointer(left.resulttype.def) then
                         inserttypeconv(left,right.resulttype)
                       else if not(equal_defs(ld,rd)) then
                         IncompatibleTypes(ld,rd);
                     end
                    else
                      CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
                    resulttype:=sinttype;
                    exit;
                 end;
               else
                 CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
            end;
          end

         { is one of the operands a string?,
           chararrays are also handled as strings (after conversion), also take
           care of chararray+chararray and chararray+char.
           Note: Must be done after pointerdef+pointerdef has been checked, else
           pchar is converted to string }
         else if (rd.deftype=stringdef) or (ld.deftype=stringdef) or
                 ((is_pchar(rd) or is_chararray(rd) or is_char(rd)) and
                  (is_pchar(ld) or is_chararray(ld) or is_char(ld))) then
          begin
            if (nodetype in [addn,equaln,unequaln,lten,gten,ltn,gtn]) then
              begin
                if is_widestring(rd) or is_widestring(ld) then
                  begin
                     if not(is_widestring(rd)) then
                       inserttypeconv(right,cwidestringtype);
                     if not(is_widestring(ld)) then
                       inserttypeconv(left,cwidestringtype);
                  end
                else if is_ansistring(rd) or is_ansistring(ld) then
                  begin
                     if not(is_ansistring(rd)) then
                       begin
                       {$ifdef ansistring_bits}
                         case Tstringdef(ld).string_typ of
                           st_ansistring16:
                             inserttypeconv(right,cansistringtype16);
                           st_ansistring32:
                             inserttypeconv(right,cansistringtype32);
                           st_ansistring64:
                             inserttypeconv(right,cansistringtype64);
                         end;
                       {$else}
                         inserttypeconv(right,cansistringtype);
                       {$endif}
                       end;
                     if not(is_ansistring(ld)) then
                       begin
                       {$ifdef ansistring_bits}
                         case Tstringdef(rd).string_typ of
                           st_ansistring16:
                             inserttypeconv(left,cansistringtype16);
                           st_ansistring32:
                             inserttypeconv(left,cansistringtype32);
                           st_ansistring64:
                             inserttypeconv(left,cansistringtype64);
                         end;
                       {$else}
                         inserttypeconv(left,cansistringtype);
                       {$endif}
                       end;
                  end
                else if is_longstring(rd) or is_longstring(ld) then
                  begin
                     if not(is_longstring(rd)) then
                       inserttypeconv(right,clongstringtype);
                     if not(is_longstring(ld)) then
                       inserttypeconv(left,clongstringtype);
                  end
                else
                  begin
                     if not(is_shortstring(ld)) then
                       inserttypeconv(left,cshortstringtype);
                     { don't convert char, that can be handled by the optimized node }
                     if not(is_shortstring(rd) or is_char(rd)) then
                       inserttypeconv(right,cshortstringtype);
                  end;
              end
            else
              CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
          end

         { class or interface equation }
         else if is_class_or_interface(rd) or is_class_or_interface(ld) then
          begin
            if (nodetype in [equaln,unequaln]) then
              begin
                if is_class_or_interface(rd) and is_class_or_interface(ld) then
                 begin
                   if tobjectdef(rd).is_related(tobjectdef(ld)) then
                    inserttypeconv(right,left.resulttype)
                   else
                    inserttypeconv(left,right.resulttype);
                 end
                else if is_class_or_interface(rd) then
                  inserttypeconv(left,right.resulttype)
                else
                  inserttypeconv(right,left.resulttype);
              end
            else
              CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
          end

         else if (rd.deftype=classrefdef) and (ld.deftype=classrefdef) then
          begin
            if (nodetype in [equaln,unequaln]) then
              begin
                if tobjectdef(tclassrefdef(rd).pointertype.def).is_related(
                        tobjectdef(tclassrefdef(ld).pointertype.def)) then
                  inserttypeconv(right,left.resulttype)
                else
                  inserttypeconv(left,right.resulttype);
              end
            else
              CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
          end

         { allows comperasion with nil pointer }
         else if is_class_or_interface(rd) or (rd.deftype=classrefdef) then
          begin
            if (nodetype in [equaln,unequaln]) then
              inserttypeconv(left,right.resulttype)
            else
              CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
          end

         else if is_class_or_interface(ld) or (ld.deftype=classrefdef) then
          begin
            if (nodetype in [equaln,unequaln]) then
              inserttypeconv(right,left.resulttype)
            else
              CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
          end

       { support procvar=nil,procvar<>nil }
         else if ((ld.deftype=procvardef) and (rt=niln)) or
                 ((rd.deftype=procvardef) and (lt=niln)) then
          begin
            if not(nodetype in [equaln,unequaln]) then
              CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
          end

       { support dynamicarray=nil,dynamicarray<>nil }
         else if (is_dynamic_array(ld) and (rt=niln)) or
                 (is_dynamic_array(rd) and (lt=niln)) or
                 (is_dynamic_array(ld) and is_dynamic_array(rd)) then
          begin
            if not(nodetype in [equaln,unequaln]) then
              CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
          end

{$ifdef SUPPORT_MMX}
       { mmx support, this must be before the zero based array
         check }
         else if (cs_mmx in aktlocalswitches) and
                 is_mmx_able_array(ld) and
                 is_mmx_able_array(rd) and
                 equal_defs(ld,rd) then
            begin
              case nodetype of
                addn,subn,xorn,orn,andn:
                  ;
                { mul is a little bit restricted }
                muln:
                  if not(mmx_type(ld) in [mmxu16bit,mmxs16bit,mmxfixed16]) then
                    CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
                else
                  CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
              end;
            end
{$endif SUPPORT_MMX}

         { this is a little bit dangerous, also the left type }
         { pointer to should be checked! This broke the mmx support      }
         else if (rd.deftype=pointerdef) or is_zero_based_array(rd) then
          begin
            if is_zero_based_array(rd) then
              begin
                resulttype.setdef(tpointerdef.create(tarraydef(rd).elementtype));
                inserttypeconv(right,resulttype);
              end
            else
              resulttype:=right.resulttype;
            inserttypeconv(left,sinttype);
            if nodetype=addn then
              begin
                if not(cs_extsyntax in aktmoduleswitches) or
                   (not(is_pchar(ld)) and not(m_add_pointer in aktmodeswitches)) then
                  CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
                if (rd.deftype=pointerdef) and
                   (tpointerdef(rd).pointertype.def.size>1) then
                   begin
                     left:=caddnode.create(muln,left,
                       cordconstnode.create(tpointerdef(rd).pointertype.def.size,sinttype,true));
                   end;
              end
            else
              CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
          end

         else if (ld.deftype=pointerdef) or is_zero_based_array(ld) then
           begin
             if is_zero_based_array(ld) then
               begin
                  resulttype.setdef(tpointerdef.create(tarraydef(ld).elementtype));
                  inserttypeconv(left,resulttype);
               end
             else
               resulttype:=left.resulttype;

             inserttypeconv(right,sinttype);
             if nodetype in [addn,subn] then
               begin
                 if not(cs_extsyntax in aktmoduleswitches) or
                    (not(is_pchar(ld)) and not(m_add_pointer in aktmodeswitches)) then
                   CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
                 if (ld.deftype=pointerdef) and
                    (tpointerdef(ld).pointertype.def.size>1) then
                   begin
                     right:=caddnode.create(muln,right,
                       cordconstnode.create(tpointerdef(ld).pointertype.def.size,sinttype,true));
                   end;
               end
             else
               CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
           end

         else if (rd.deftype=procvardef) and
                 (ld.deftype=procvardef) and
                 equal_defs(rd,ld) then
          begin
            if (nodetype in [equaln,unequaln]) then
              begin
                { convert both to voidpointer, because methodpointers are 8 bytes }
                { even though only the first 4 bytes must be compared (JM)        }
                inserttypeconv_explicit(left,voidpointertype);
                inserttypeconv_explicit(right,voidpointertype);
              end
            else
              CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
          end

         { enums }
         else if (ld.deftype=enumdef) and (rd.deftype=enumdef) then
          begin
            if (nodetype in [equaln,unequaln,ltn,lten,gtn,gten]) then
              inserttypeconv(right,left.resulttype)
            else
              CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),ld.typename,rd.typename);
          end

         { generic conversion, this is for error recovery }
         else
          begin
            inserttypeconv(left,sinttype);
            inserttypeconv(right,sinttype);
          end;

         { set resulttype if not already done }
         if not assigned(resulttype.def) then
          begin
             case nodetype of
                ltn,lten,gtn,gten,equaln,unequaln :
                  resulttype:=booltype;
                slashn :
                  resulttype:=resultrealtype;
                addn:
                  begin
                    { for strings, return is always a 255 char string }
                    if is_shortstring(left.resulttype.def) then
                     resulttype:=cshortstringtype
                    else
                     resulttype:=left.resulttype;
                  end;
                else
                  resulttype:=left.resulttype;
             end;
          end;

         { when the result is currency we need some extra code for
           multiplication and division. this should not be done when
           the muln or slashn node is created internally }
         if not(nf_is_currency in flags) and
            is_currency(resulttype.def) then
          begin
            case nodetype of
              slashn :
                begin
                  { slashn will only work with floats }
                  hp:=caddnode.create(muln,getcopy,crealconstnode.create(10000.0,s64currencytype));
                  include(hp.flags,nf_is_currency);
                  result:=hp;
                end;
              muln :
                begin
                  if s64currencytype.def.deftype=floatdef then
                    hp:=caddnode.create(slashn,getcopy,crealconstnode.create(10000.0,s64currencytype))
                  else
                    hp:=cmoddivnode.create(divn,getcopy,cordconstnode.create(10000,s64currencytype,false));
                  include(hp.flags,nf_is_currency);
                  result:=hp
                end;
            end;
          end;
      end;


    function taddnode.first_addstring: tnode;
      var
        p: tnode;
      begin
        { when we get here, we are sure that both the left and the right }
        { node are both strings of the same stringtype (JM)              }
        case nodetype of
          addn:
            begin
              { create the call to the concat routine both strings as arguments }
              result := ccallnode.createintern('fpc_'+
                tstringdef(resulttype.def).stringtypname+'_concat',
                ccallparanode.create(right,ccallparanode.create(left,nil)));
              { we reused the arguments }
              left := nil;
              right := nil;
            end;
          ltn,lten,gtn,gten,equaln,unequaln :
            begin
              { generate better code for s='' and s<>'' }
              if (nodetype in [equaln,unequaln]) and
                 (((left.nodetype=stringconstn) and (str_length(left)=0)) or
                  ((right.nodetype=stringconstn) and (str_length(right)=0))) then
                begin
                  { switch so that the constant is always on the right }
                  if left.nodetype = stringconstn then
                    begin
                      p := left;
                      left := right;
                      right := p;
                    end;
                  if is_shortstring(left.resulttype.def) then
                    { compare the length with 0 }
                    result := caddnode.create(nodetype,
                      cinlinenode.create(in_length_x,false,left),
                      cordconstnode.create(0,s32inttype,false))
                  else
                    begin
                      { compare the pointer with nil (for ansistrings etc), }
                      { faster than getting the length (JM)                 }
                      result:= caddnode.create(nodetype,
                        ctypeconvnode.create_explicit(left,voidpointertype),
                        cpointerconstnode.create(0,voidpointertype));
                    end;
                  { left is reused }
                  left := nil;
                  { right isn't }
                  right.free;
                  right := nil;
                  exit;
                end;
              { no string constant -> call compare routine }
              result := ccallnode.createintern('fpc_'+
                tstringdef(left.resulttype.def).stringtypname+'_compare',
                ccallparanode.create(right,ccallparanode.create(left,nil)));
              { and compare its result with 0 according to the original operator }
              result := caddnode.create(nodetype,result,
                cordconstnode.create(0,s32inttype,false));
              left := nil;
              right := nil;
            end;
        end;
      end;


    function taddnode.first_addset: tnode;
      var
        procname: string[31];
        tempn: tnode;
        paras: tcallparanode;
        srsym: ttypesym;
      begin
        { get the sym that represents the fpc_normal_set type }
        if not searchsystype('FPC_NORMAL_SET',srsym) then
          internalerror(200108313);

        case nodetype of
          equaln,unequaln,lten,gten:
            begin
              case nodetype of
                equaln,unequaln:
                  procname := 'fpc_set_comp_sets';
                lten,gten:
                  begin
                    procname := 'fpc_set_contains_sets';
                    { (left >= right) = (right <= left) }
                    if nodetype = gten then
                      begin
                        tempn := left;
                        left := right;
                        right := tempn;
                      end;
                   end;
               end;
               { convert the arguments (explicitely) to fpc_normal_set's }
               left := ctypeconvnode.create_explicit(left,srsym.restype);
               right := ctypeconvnode.create_explicit(right,srsym.restype);
               result := ccallnode.createintern(procname,ccallparanode.create(right,
                 ccallparanode.create(left,nil)));
               { left and right are reused as parameters }
               left := nil;
               right := nil;
               { for an unequaln, we have to negate the result of comp_sets }
               if nodetype = unequaln then
                 result := cnotnode.create(result);
            end;
          addn:
            begin
              { optimize first loading of a set }
              if (right.nodetype=setelementn) and
                 not(assigned(tsetelementnode(right).right)) and
                 is_emptyset(left) then
                begin
                  { type cast the value to pass as argument to a byte, }
                  { since that's what the helper expects               }
                  tsetelementnode(right).left :=
                    ctypeconvnode.create_explicit(tsetelementnode(right).left,u8inttype);
                  { set the resulttype to the actual one (otherwise it's }
                  { "fpc_normal_set")                                    }
                  result := ccallnode.createinternres('fpc_set_create_element',
                    ccallparanode.create(tsetelementnode(right).left,nil),
                    resulttype);
                  { reused }
                  tsetelementnode(right).left := nil;
                end
              else
                begin
                  if right.nodetype=setelementn then
                   begin
                     { convert the arguments to bytes, since that's what }
                     { the helper expects                               }
                     tsetelementnode(right).left :=
                       ctypeconvnode.create_explicit(tsetelementnode(right).left,
                       u8inttype);

                     { convert the original set (explicitely) to an   }
                     { fpc_normal_set so we can pass it to the helper }
                     left := ctypeconvnode.create_explicit(left,srsym.restype);

                     { add a range or a single element? }
                     if assigned(tsetelementnode(right).right) then
                       begin
                         tsetelementnode(right).right :=
                           ctypeconvnode.create_explicit(tsetelementnode(right).right,
                           u8inttype);

                         { create the call }
                         result := ccallnode.createinternres('fpc_set_set_range',
                           ccallparanode.create(tsetelementnode(right).right,
                           ccallparanode.create(tsetelementnode(right).left,
                           ccallparanode.create(left,nil))),resulttype);
                       end
                     else
                       begin
                         result := ccallnode.createinternres('fpc_set_set_byte',
                           ccallparanode.create(tsetelementnode(right).left,
                           ccallparanode.create(left,nil)),resulttype);
                       end;
                     { remove reused parts from original node }
                     tsetelementnode(right).right := nil;
                     tsetelementnode(right).left := nil;
                     left := nil;
                   end
                  else
                   begin
                     { add two sets }

                     { convert the sets to fpc_normal_set's }
                     result := ccallnode.createinternres('fpc_set_add_sets',
                       ccallparanode.create(
                         ctypeconvnode.create_explicit(right,srsym.restype),
                       ccallparanode.create(
                         ctypeconvnode.create_explicit(left,srsym.restype),nil)),resulttype);
                     { remove reused parts from original node }
                     left := nil;
                     right := nil;
                   end;
                end
            end;
          subn,symdifn,muln:
            begin
              { convert the sets to fpc_normal_set's }
              paras := ccallparanode.create(ctypeconvnode.create_explicit(right,srsym.restype),
                ccallparanode.create(ctypeconvnode.create_explicit(left,srsym.restype),nil));
              case nodetype of
                subn:
                  result := ccallnode.createinternres('fpc_set_sub_sets',
                    paras,resulttype);
                symdifn:
                  result := ccallnode.createinternres('fpc_set_symdif_sets',
                    paras,resulttype);
                muln:
                  result := ccallnode.createinternres('fpc_set_mul_sets',
                    paras,resulttype);
              end;
              { remove reused parts from original node }
              left := nil;
              right := nil;
            end;
          else
            internalerror(200108311);
        end;
      end;


    function taddnode.first_add64bitint: tnode;
      var
        procname: string[31];
        temp: tnode;
        power: longint;
      begin
        result := nil;
        { create helper calls mul }
        if nodetype <> muln then
          exit;

        { make sure that if there is a constant, that it's on the right }
        if left.nodetype = ordconstn then
          begin
            temp := right;
            right := left;
            left := temp;
          end;

        { can we use a shift instead of a mul? }
        if not (cs_check_overflow in aktlocalswitches) and
           (right.nodetype = ordconstn) and
           ispowerof2(tordconstnode(right).value,power) then
          begin
            tordconstnode(right).value := power;
            result := cshlshrnode.create(shln,left,right);
            { left and right are reused }
            left := nil;
            right := nil;
            { return firstpassed new node }
            exit;
          end;

        { when currency is used set the result of the
          parameters to s64bit, so they are not converted }
        if is_currency(resulttype.def) then
          begin
            left.resulttype:=s64inttype;
            right.resulttype:=s64inttype;
          end;

        { otherwise, create the parameters for the helper }
        right := ccallparanode.create(
          cordconstnode.create(ord(cs_check_overflow in aktlocalswitches),booltype,true),
          ccallparanode.create(right,ccallparanode.create(left,nil)));
        left := nil;
        { only qword needs the unsigned code, the
          signed code is also used for currency }
        if is_signed(resulttype.def) then
          procname := 'fpc_mul_int64'
        else
          procname := 'fpc_mul_qword';
        result := ccallnode.createintern(procname,right);
        right := nil;
      end;


{$ifdef cpufpemu}
    function taddnode.first_addfloat: tnode;
      var
        procname: string[31];
        temp: tnode;
        power: longint;
        { do we need to reverse the result ? }
        notnode : boolean;
      begin
        result := nil;
        notnode := false;
        { In non-emulation mode, real opcodes are
          emitted for floating point values.
        }
        if not (cs_fp_emulation in aktmoduleswitches) then
          exit;

        case nodetype of
          addn : procname := 'fpc_single_add';
          muln : procname := 'fpc_single_mul';
          subn : procname := 'fpc_single_sub';
          slashn : procname := 'fpc_single_div';
          ltn : procname := 'fpc_single_lt';
          lten: procname := 'fpc_single_le';
          gtn:
            begin
             procname := 'fpc_single_le';
             notnode := true;
            end;
          gten:
            begin
              procname := 'fpc_single_lt';
              notnode := true;
            end;
          equaln: procname := 'fpc_single_eq';
          unequaln :
            begin
              procname := 'fpc_single_eq';
              notnode := true;
            end;
          else
            CGMessage3(type_e_operator_not_supported_for_types,node2opstr(nodetype),left.resulttype.def.typename,right.resulttype.def.typename);
        end;
        { convert the arguments (explicitely) to fpc_normal_set's }
        result := ccallnode.createintern(procname,ccallparanode.create(right,
           ccallparanode.create(left,nil)));
        left:=nil;
        right:=nil;

        { do we need to reverse the result }
        if notnode then
           result := cnotnode.create(result);
      end;
{$endif cpufpemu}


    function taddnode.pass_1 : tnode;
      var
{$ifdef addstringopt}
         hp      : tnode;
{$endif addstringopt}
         lt,rt   : tnodetype;
         rd,ld   : tdef;
      begin
         result:=nil;
         { first do the two subtrees }
         firstpass(left);
         firstpass(right);

         if codegenerror then
           exit;

         { load easier access variables }
         rd:=right.resulttype.def;
         ld:=left.resulttype.def;
         rt:=right.nodetype;
         lt:=left.nodetype;

         { int/int gives real/real! }
         if nodetype=slashn then
           begin
{$ifdef cpufpemu}
             result := first_addfloat;
             if assigned(result) then
               exit;
{$endif cpufpemu}
             expectloc:=LOC_FPUREGISTER;
             { maybe we need an integer register to save }
             { a reference                               }
             if ((left.expectloc<>LOC_FPUREGISTER) or
                 (right.expectloc<>LOC_FPUREGISTER)) and
                (left.registersint=right.registersint) then
               calcregisters(self,1,1,0)
             else
               calcregisters(self,0,1,0);
              { an add node always first loads both the left and the    }
              { right in the fpu before doing the calculation. However, }
              { calcregisters(0,2,0) will overestimate the number of    }
              { necessary registers (it will make it 3 in case one of   }
              { the operands is already in the fpu) (JM)                }
              if ((left.expectloc<>LOC_FPUREGISTER) or
                  (right.expectloc<>LOC_FPUREGISTER)) and
                 (registersfpu < 2) then
                inc(registersfpu);
           end

         { if both are orddefs then check sub types }
         else if (ld.deftype=orddef) and (rd.deftype=orddef) then
           begin
           { 2 booleans ? }
             if is_boolean(ld) and is_boolean(rd) then
              begin
                if not(cs_full_boolean_eval in aktlocalswitches) and
                   (nodetype in [andn,orn]) then
                 begin
                   expectloc:=LOC_JUMP;
                   calcregisters(self,0,0,0);
                 end
                else
                 begin
                   expectloc:=LOC_FLAGS;
                   if (left.expectloc in [LOC_JUMP,LOC_FLAGS]) and
                      (left.expectloc in [LOC_JUMP,LOC_FLAGS]) then
                     calcregisters(self,2,0,0)
                   else
                     calcregisters(self,1,0,0);
                 end;
              end
             else
             { Both are chars? only convert to shortstrings for addn }
              if is_char(ld) then
               begin
                 if nodetype=addn then
                  internalerror(200103291);
                 expectloc:=LOC_FLAGS;
                 calcregisters(self,1,0,0);
               end
{$ifndef cpu64bit}
              { is there a 64 bit type ? }
             else if (torddef(ld).typ in [s64bit,u64bit,scurrency]) then
               begin
                 result := first_add64bitint;
                 if assigned(result) then
                   exit;
                  if nodetype in [addn,subn,muln,andn,orn,xorn] then
                    expectloc:=LOC_REGISTER
                  else
                    expectloc:=LOC_JUMP;
                  calcregisters(self,2,0,0)
               end
{$endif cpu64bit}
             { is there a cardinal? }
             else if (torddef(ld).typ=u32bit) then
               begin
                  if nodetype in [addn,subn,muln,andn,orn,xorn] then
                    expectloc:=LOC_REGISTER
                  else
                    expectloc:=LOC_FLAGS;
                 calcregisters(self,1,0,0);
                 { for unsigned mul we need an extra register }
                 if nodetype=muln then
                  inc(registersint);
               end
             { generic s32bit conversion }
             else
               begin
                  if nodetype in [addn,subn,muln,andn,orn,xorn] then
                    expectloc:=LOC_REGISTER
                  else
                    expectloc:=LOC_FLAGS;
                 calcregisters(self,1,0,0);
               end;
           end

         { left side a setdef, must be before string processing,
           else array constructor can be seen as array of char (PFV) }
         else if (ld.deftype=setdef) then
           begin
             if tsetdef(ld).settype=smallset then
               begin
                 if nodetype in [ltn,lten,gtn,gten,equaln,unequaln] then
                   expectloc:=LOC_FLAGS
                 else
                   expectloc:=LOC_REGISTER;
                 { are we adding set elements ? }
                 if right.nodetype=setelementn then
                   calcregisters(self,2,0,0)
                 else
                   calcregisters(self,1,0,0);
               end
             else
{$ifdef MMXSET}
{$ifdef i386}
               if cs_mmx in aktlocalswitches then
                 begin
                   expectloc:=LOC_MMXREGISTER;
                   calcregisters(self,0,0,4);
                 end
               else
{$endif}
{$endif MMXSET}
                 begin
                   result := first_addset;
                   if assigned(result) then
                     exit;
                   expectloc:=LOC_CREFERENCE;
                   calcregisters(self,0,0,0);
                   { here we call SET... }
                   include(current_procinfo.flags,pi_do_call);
                 end;
           end

         { compare pchar by addresses like BP/Delphi }
         else if is_pchar(ld) then
           begin
             if nodetype in [addn,subn,muln,andn,orn,xorn] then
               expectloc:=LOC_REGISTER
             else
               expectloc:=LOC_FLAGS;
             calcregisters(self,1,0,0);
           end

         { is one of the operands a string }
         else if (ld.deftype=stringdef) then
            begin
              if is_widestring(ld) then
                begin
                   { this is only for add, the comparisaion is handled later }
                   expectloc:=LOC_REGISTER;
                end
              else if is_ansistring(ld) then
                begin
                   { this is only for add, the comparisaion is handled later }
                   expectloc:=LOC_REGISTER;
                end
              else if is_longstring(ld) then
                begin
                   { this is only for add, the comparisaion is handled later }
                   expectloc:=LOC_REFERENCE;
                end
              else
                begin
{$ifdef addstringopt}
                   { can create a call which isn't handled by callparatemp }
                   if canbeaddsstringcharoptnode(self) then
                     begin
                       hp := genaddsstringcharoptnode(self);
                       pass_1 := hp;
                       exit;
                     end
                   else
{$endif addstringopt}
                     begin
                       { Fix right to be shortstring }
                       if is_char(right.resulttype.def) then
                        begin
                          inserttypeconv(right,cshortstringtype);
                          firstpass(right);
                        end;
                     end;
{$ifdef addstringopt}
                   { can create a call which isn't handled by callparatemp }
                   if canbeaddsstringcsstringoptnode(self) then
                     begin
                       hp := genaddsstringcsstringoptnode(self);
                       pass_1 := hp;
                       exit;
                     end;
{$endif addstringopt}
                end;
             { otherwise, let addstring convert everything }
              result := first_addstring;
              exit;
           end

         { is one a real float ? }
         else if (rd.deftype=floatdef) or (ld.deftype=floatdef) then
            begin
{$ifdef cpufpemu}
              result := first_addfloat;
              if assigned(result) then
                exit;
{$endif cpufpemu}
              if nodetype in [addn,subn,muln,andn,orn,xorn] then
                expectloc:=LOC_FPUREGISTER
              else
                expectloc:=LOC_FLAGS;
              calcregisters(self,0,1,0);
              { an add node always first loads both the left and the    }
              { right in the fpu before doing the calculation. However, }
              { calcregisters(0,2,0) will overestimate the number of    }
              { necessary registers (it will make it 3 in case one of   }
              { the operands is already in the fpu) (JM)                }
              if ((left.expectloc<>LOC_FPUREGISTER) or
                  (right.expectloc<>LOC_FPUREGISTER)) and
                 (registersfpu < 2) then
                inc(registersfpu);
            end

         { pointer comperation and subtraction }
         else if (ld.deftype=pointerdef) then
            begin
              if nodetype in [addn,subn,muln,andn,orn,xorn] then
                expectloc:=LOC_REGISTER
              else
                expectloc:=LOC_FLAGS;
              calcregisters(self,1,0,0);
           end

         else if is_class_or_interface(ld) then
            begin
              expectloc:=LOC_FLAGS;
              calcregisters(self,1,0,0);
            end

         else if (ld.deftype=classrefdef) then
            begin
              expectloc:=LOC_FLAGS;
              calcregisters(self,1,0,0);
            end

         { support procvar=nil,procvar<>nil }
         else if ((ld.deftype=procvardef) and (rt=niln)) or
                 ((rd.deftype=procvardef) and (lt=niln)) then
            begin
              expectloc:=LOC_FLAGS;
              calcregisters(self,1,0,0);
            end

{$ifdef SUPPORT_MMX}
       { mmx support, this must be before the zero based array
         check }
         else if (cs_mmx in aktlocalswitches) and is_mmx_able_array(ld) and
                 is_mmx_able_array(rd) then
            begin
              expectloc:=LOC_MMXREGISTER;
              calcregisters(self,0,0,1);
            end
{$endif SUPPORT_MMX}

         else if (rd.deftype=pointerdef) or (ld.deftype=pointerdef) then
            begin
              expectloc:=LOC_REGISTER;
              calcregisters(self,1,0,0);
            end

         else  if (rd.deftype=procvardef) and
                  (ld.deftype=procvardef) and
                  equal_defs(rd,ld) then
           begin
             expectloc:=LOC_FLAGS;
             calcregisters(self,1,0,0);
           end

         else if (ld.deftype=enumdef) then
           begin
              expectloc:=LOC_FLAGS;
              calcregisters(self,1,0,0);
           end

{$ifdef SUPPORT_MMX}
         else if (cs_mmx in aktlocalswitches) and
                 is_mmx_able_array(ld) and
                 is_mmx_able_array(rd) then
            begin
              expectloc:=LOC_MMXREGISTER;
              calcregisters(self,0,0,1);
            end
{$endif SUPPORT_MMX}

         { the general solution is to convert to 32 bit int }
         else
           begin
             expectloc:=LOC_REGISTER;
             calcregisters(self,1,0,0);
           end;
      end;

{$ifdef state_tracking}
    function Taddnode.track_state_pass(exec_known:boolean):boolean;

    var factval:Tnode;

    begin
    track_state_pass:=false;
    if left.track_state_pass(exec_known) then
      begin
        track_state_pass:=true;
        left.resulttype.def:=nil;
        do_resulttypepass(left);
      end;
    factval:=aktstate.find_fact(left);
    if factval<>nil then
        begin
        track_state_pass:=true;
            left.destroy;
            left:=factval.getcopy;
        end;
    if right.track_state_pass(exec_known) then
        begin
        track_state_pass:=true;
        right.resulttype.def:=nil;
        do_resulttypepass(right);
        end;
    factval:=aktstate.find_fact(right);
    if factval<>nil then
        begin
        track_state_pass:=true;
            right.destroy;
            right:=factval.getcopy;
        end;
    end;
{$endif}

begin
   caddnode:=taddnode;
end.
{
  $Log$
  Revision 1.122  2004-05-23 14:14:18  florian
    + added set of widechar support (limited to 256 chars, is delphi compatible)

  Revision 1.121  2004/05/23 14:08:39  peter
    * only convert widechar to widestring when both operands are
      constant
    * support widechar-widechar operations in orddef part

  Revision 1.120  2004/05/21 13:08:14  florian
    * fixed <ordinal>+<pointer>

  Revision 1.119  2004/05/20 21:54:33  florian
    + <pointer> - <pointer> result is divided by the pointer element size now
      this is delphi compatible as well as resulting in the expected result for p1+(p2-p1)

  Revision 1.118  2004/05/19 23:29:26  peter
    * don't change sign for unsigned shl/shr operations
    * cleanup for u32bit

  Revision 1.117  2004/04/29 19:56:37  daniel
    * Prepare compiler infrastructure for multiple ansistring types

  Revision 1.116  2004/04/18 07:52:43  florian
    * fixed web bug 3048: comparision of dyn. arrays

  Revision 1.115  2004/03/29 14:44:10  peter
    * fixes to previous constant integer commit

  Revision 1.114  2004/03/23 22:34:49  peter
    * constants ordinals now always have a type assigned
    * integer constants have the smallest type, unsigned prefered over
      signed

  Revision 1.113  2004/03/18 16:19:03  peter
    * fixed operator overload allowing for pointer-string
    * replaced some type_e_mismatch with more informational messages

  Revision 1.112  2004/02/21 22:08:46  daniel
    * Avoid memory allocation and string copying

  Revision 1.111  2004/02/20 21:55:59  peter
    * procvar cleanup

  Revision 1.110  2004/02/05 01:24:08  florian
    * several fixes to compile x86-64 system

  Revision 1.109  2004/02/03 22:32:54  peter
    * renamed xNNbittype to xNNinttype
    * renamed registers32 to registersint
    * replace some s32bit,u32bit with torddef([su]inttype).def.typ

  Revision 1.108  2004/02/02 20:41:59  florian
    + added prefetch(const mem) support

  Revision 1.107  2004/01/20 12:59:36  florian
    * common addnode code for x86-64 and i386

  Revision 1.106  2004/01/14 17:19:04  peter
    * disable addmmxset

  Revision 1.105  2004/01/02 17:19:04  jonas
    * if currency = int64, FPC_CURRENCY_IS_INT64 is defined
    + round and trunc for currency and comp if FPC_CURRENCY_IS_INT64 is
      defined
    * if currency = orddef, prefer currency -> int64/qword conversion over
      currency -> float conversions
    * optimized currency/currency if currency = orddef
    * TODO: write FPC_DIV_CURRENCY and FPC_MUL_CURRENCY routines to prevent
        precision loss if currency=int64 and bestreal = double

  Revision 1.104  2003/12/31 20:47:02  jonas
    * properly fixed assigned() mess (by handling it separately in ncginl)
      -> all assigned()-related tests in the test suite work again

  Revision 1.103  2003/12/30 16:30:50  jonas
    * fixed previous commit for tp and delphi modes

  Revision 1.102  2003/12/29 22:33:08  jonas
    * fixed methodpointer comparing in a generic way (typecast both left and
      right explicitly to voidpointer), instead of relying on strange
      behvaiour or n386addnode.pass_2 (if size of def = 8, only use the first
      4 bytes instead of internalerror-ing or so)

  Revision 1.101  2003/12/21 11:28:41  daniel
    * Some work to allow mmx instructions to be used for 32 byte sets

  Revision 1.100  2003/12/09 21:17:04  jonas
    + support for evaluating qword constant expressions (both arguments have
      to be a qword, constants have to be explicitly typecasted to qword)

  Revision 1.99  2003/10/28 15:35:18  peter
    * compare longint-cardinal also makes types wider

  Revision 1.98  2003/10/21 18:16:13  peter
    * IncompatibleTypes() added that will include unit names when
      the typenames are the same

  Revision 1.97  2003/10/08 19:19:45  peter
    * set_varstate cleanup

  Revision 1.96  2003/10/01 20:34:48  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.95  2003/09/06 16:47:24  florian
    + support of NaN and Inf in the compiler as values of real constants

  Revision 1.94  2003/09/03 15:55:00  peter
    * NEWRA branch merged

  Revision 1.93.2.1  2003/08/31 21:07:44  daniel
    * callparatemp ripped

  Revision 1.93  2003/06/05 20:05:55  peter
    * removed changesettype because that will change the definition
      of the setdef forever and can result in a different between
      original interface and current implementation definition

  Revision 1.92  2003/06/03 21:04:43  peter
    * widen cardinal+signed operations

  Revision 1.91  2003/05/26 21:15:18  peter
    * disable string node optimizations for the moment

  Revision 1.90  2003/05/26 19:38:28  peter
    * generic fpc_shorstr_concat
    + fpc_shortstr_append_shortstr optimization

  Revision 1.89  2003/05/24 21:12:57  florian
    * if something doesn't work with callparatemp, the define callparatemp
      should be used because other processors with reigster calling conventions
      depend on this as well

  Revision 1.88  2003/05/23 22:57:38  jonas
    - disable addoptnodes for powerpc, because they can generate calls in
      pass_2, so -dcallparatemp can't detect them as nested calls

  Revision 1.87  2003/04/27 11:21:32  peter
    * aktprocdef renamed to current_procdef
    * procinfo renamed to current_procinfo
    * procinfo will now be stored in current_module so it can be
      cleaned up properly
    * gen_main_procsym changed to create_main_proc and release_main_proc
      to also generate a tprocinfo structure
    * fixed unit implicit initfinal

  Revision 1.86  2003/04/26 09:12:55  peter
    * add string returns in LOC_REFERENCE

  Revision 1.85  2003/04/24 22:29:57  florian
    * fixed a lot of PowerPC related stuff

  Revision 1.84  2003/04/23 20:16:04  peter
    + added currency support based on int64
    + is_64bit for use in cg units instead of is_64bitint
    * removed cgmessage from n386add, replace with internalerrors

  Revision 1.83  2003/04/23 10:10:07  peter
    * expectloc fixes

  Revision 1.82  2003/04/22 23:50:22  peter
    * firstpass uses expectloc
    * checks if there are differences between the expectloc and
      location.loc from secondpass in EXTDEBUG

  Revision 1.81  2003/02/15 22:20:14  carl
   * bugfix for generic calls to FPU emulation code

  Revision 1.80  2003/02/12 22:10:07  carl
    * load_frame_pointer is now generic
    * change fpu emulation routine names

  Revision 1.79  2003/01/02 22:19:54  peter
    * support pchar-char operations converting to string first
    * support chararray-nil

  Revision 1.78  2002/12/11 22:41:03  peter
    * stop processing assignment node when the binaryoverload generates
      a codegenerror

  Revision 1.77  2002/12/06 16:56:57  peter
    * only compile cs_fp_emulation support when cpufpuemu is defined
    * define cpufpuemu for m68k only

  Revision 1.76  2002/11/30 21:32:24  carl
    + Add loading of softfpu in emulation mode
    + Correct routine call for softfpu
    * Extended type must also be defined even with softfpu

  Revision 1.75  2002/11/27 13:11:38  peter
    * more currency fixes, taddcurr runs now successfull

  Revision 1.74  2002/11/27 11:28:40  peter
    * when both flaottypes are the same then handle the addnode using
      that floattype instead of bestrealtype

  Revision 1.73  2002/11/25 18:43:32  carl
   - removed the invalid if <> checking (Delphi is strange on this)
   + implemented abstract warning on instance creation of class with
      abstract methods.
   * some error message cleanups

  Revision 1.72  2002/11/25 17:43:17  peter
    * splitted defbase in defutil,symutil,defcmp
    * merged isconvertable and is_equal into compare_defs(_ext)
    * made operator search faster by walking the list only once

  Revision 1.71  2002/11/23 22:50:06  carl
    * some small speed optimizations
    + added several new warnings/hints

  Revision 1.70  2002/11/16 14:20:22  peter
    * fix tbs0417

  Revision 1.69  2002/11/15 01:58:50  peter
    * merged changes from 1.0.7 up to 04-11
      - -V option for generating bug report tracing
      - more tracing for option parsing
      - errors for cdecl and high()
      - win32 import stabs
      - win32 records<=8 are returned in eax:edx (turned off by default)
      - heaptrc update
      - more info for temp management in .s file with EXTDEBUG

  Revision 1.68  2002/10/08 16:50:43  jonas
    * fixed web bug 2136

  Revision 1.67  2002/10/05 00:47:03  peter
    * support dynamicarray<>nil

  Revision 1.66  2002/10/04 21:19:28  jonas
    * fixed web bug 2139: checking for division by zero fixed

  Revision 1.65  2002/09/07 15:25:02  peter
    * old logs removed and tabs fixed

  Revision 1.64  2002/09/07 12:16:05  carl
    * second part bug report 1996 fix, testrange in cordconstnode
      only called if option is set (also make parsing a tiny faster)

  Revision 1.63  2002/09/04 19:32:56  jonas
    * changed some ctypeconvnode/toggleflag(nf_explizit) combo's to
      ctypeconvnode.create_explicit() statements

  Revision 1.62  2002/08/17 09:23:34  florian
    * first part of current_procinfo rewrite

  Revision 1.61  2002/08/15 15:15:55  carl
    * jmpbuf size allocation for exceptions is now cpu specific (as it should)
    * more generic nodes for maths
    * several fixes for better m68k support

  Revision 1.60  2002/08/12 15:08:39  carl
    + stab register indexes for powerpc (moved from gdb to cpubase)
    + tprocessor enumeration moved to cpuinfo
    + linker in target_info is now a class
    * many many updates for m68k (will soon start to compile)
    - removed some ifdef or correct them for correct cpu

  Revision 1.59  2002/08/02 07:44:30  jonas
    * made assigned() handling generic
    * add nodes now can also evaluate constant expressions at compile time
      that contain nil nodes

  Revision 1.58  2002/07/26 11:17:52  jonas
    * the optimization of converting a multiplication with a power of two to
      a shl is moved from n386add/secondpass to nadd/resulttypepass

  Revision 1.57  2002/07/23 13:08:16  jonas
    * fixed constant set evaluation of new set handling for non-commutative
      operators

  Revision 1.56  2002/07/23 12:34:29  daniel
  * Readded old set code. To use it define 'oldset'. Activated by default
    for ppc.

  Revision 1.55  2002/07/22 11:48:04  daniel
  * Sets are now internally sets.

  Revision 1.54  2002/07/20 11:57:53  florian
    * types.pas renamed to defbase.pas because D6 contains a types
      unit so this would conflicts if D6 programms are compiled
    + Willamette/SSE2 instructions to assembler added

  Revision 1.53  2002/07/19 11:41:34  daniel
  * State tracker work
  * The whilen and repeatn are now completely unified into whilerepeatn. This
    allows the state tracker to change while nodes automatically into
    repeat nodes.
  * Resulttypepass improvements to the notn. 'not not a' is optimized away and
    'not(a>b)' is optimized into 'a<=b'.
  * Resulttypepass improvements to the whilerepeatn. 'while not a' is optimized
    by removing the notn and later switchting the true and falselabels. The
    same is done with 'repeat until not a'.

  Revision 1.52  2002/07/14 18:00:43  daniel
  + Added the beginning of a state tracker. This will track the values of
    variables through procedures and optimize things away.

  Revision 1.51  2002/05/18 13:34:08  peter
    * readded missing revisions

  Revision 1.50  2002/05/16 19:46:37  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.48  2002/05/13 19:54:36  peter
    * removed n386ld and n386util units
    * maybe_save/maybe_restore added instead of the old maybe_push

  Revision 1.47  2002/05/12 16:53:06  peter
    * moved entry and exitcode to ncgutil and cgobj
    * foreach gets extra argument for passing local data to the
      iterator function
    * -CR checks also class typecasts at runtime by changing them
      into as
    * fixed compiler to cycle with the -CR option
    * fixed stabs with elf writer, finally the global variables can
      be watched
    * removed a lot of routines from cga unit and replaced them by
      calls to cgobj
    * u32bit-s32bit updates for and,or,xor nodes. When one element is
      u32bit then the other is typecasted also to u32bit without giving
      a rangecheck warning/error.
    * fixed pascal calling method with reversing also the high tree in
      the parast, detected by tcalcst3 test

  Revision 1.46  2002/04/23 19:16:34  peter
    * add pinline unit that inserts compiler supported functions using
      one or more statements
    * moved finalize and setlength from ninl to pinline

  Revision 1.45  2002/04/04 19:05:56  peter
    * removed unused units
    * use tlocation.size in cg.a_*loc*() routines

  Revision 1.44  2002/04/02 17:11:28  peter
    * tlocation,treference update
    * LOC_CONSTANT added for better constant handling
    * secondadd splitted in multiple routines
    * location_force_reg added for loading a location to a register
      of a specified size
    * secondassignment parses now first the right and then the left node
      (this is compatible with Kylix). This saves a lot of push/pop especially
      with string operations
    * adapted some routines to use the new cg methods

}
