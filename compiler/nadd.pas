{
    $Id$
    Copyright (c) 1998-2000 by Florian Klaempfl

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

{$i defines.inc}

interface

    uses
      node;

    type
       taddnode = class(tbinopnode)
          constructor create(tt : tnodetype;l,r : tnode);override;
          function pass_1 : tnode;override;
          function det_resulttype:tnode;override;
       end;

    var
       { caddnode is used to create nodes of the add type }
       { the virtual constructor allows to assign         }
       { another class type to caddnode => processor      }
       { specific node types can be created               }
       caddnode : class of taddnode;

implementation

    uses
      globtype,systems,
      cutils,verbose,globals,widestr,
      symconst,symtype,symdef,types,
      cpuinfo,
{$ifdef newcg}
      cgbase,
{$else newcg}
      hcodegen,
{$endif newcg}
      htypechk,pass_1,
      nmat,ncnv,nld,ncon,nset,nopt,
      cpubase;


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
         resultset : pconstset;
         i       : longint;
         b       : boolean;
         s1,s2   : pchar;
         ws1,ws2,
         ws3     : tcompilerwidestring;
         l1,l2   : longint;
         rv,lv   : tconstexprint;
         rvd,lvd : bestreal;

      begin
         result:=nil;

         { first do the two subtrees }
         resulttypepass(left);
         resulttypepass(right);
         { both left and right need to be valid }
         set_varstate(left,true);
         set_varstate(right,true);
         if codegenerror then
           exit;

         { convert array constructors to sets, because there is no other operator
           possible for array constructors }
         if is_array_constructor(left.resulttype.def) then
          begin
            arrayconstructor_to_set(tarrayconstructornode(left));
            resulttypepass(left);
          end;
         if is_array_constructor(right.resulttype.def) then
          begin
            arrayconstructor_to_set(tarrayconstructornode(right));
            resulttypepass(right);
          end;

         { allow operator overloading }
         hp:=self;
         if isbinaryoverloaded(hp) then
           begin
              resulttypepass(hp);
              result:=hp;
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
               { insert explicit typecast to s32bit }
               left:=ctypeconvnode.create(left,s32bittype);
               include(left.flags,nf_explizit);
               resulttypepass(left);
             end
            else
             if (left.resulttype.def.deftype=orddef) and
                (right.resulttype.def.deftype=enumdef) then
              begin
                { insert explicit typecast to s32bit }
                right:=ctypeconvnode.create(right,s32bittype);
                include(right.flags,nf_explizit);
                resulttypepass(right);
              end;
          end;

         { is one a real float, then both need to be floats, this
           need to be done before the constant folding so constant
           operation on a float and int are also handled }
         if (right.resulttype.def.deftype=floatdef) or (left.resulttype.def.deftype=floatdef) then
          begin
            inserttypeconv(right,pbestrealtype^);
            inserttypeconv(left,pbestrealtype^);
          end;

         { if one operand is a widechar or a widestring, both operands    }
         { are converted to widestring. This must be done before constant }
         { folding to allow char+widechar etc.                            }
         if is_widestring(right.resulttype.def) or
           is_widestring(left.resulttype.def) or
           is_widechar(right.resulttype.def) or
           is_widechar(left.resulttype.def) then
           begin
              inserttypeconv(right,cwidestringtype);
              inserttypeconv(left,cwidestringtype);
           end;

         { load easier access variables }
         rd:=right.resulttype.def;
         ld:=left.resulttype.def;
         rt:=right.nodetype;
         lt:=left.nodetype;

         { both are int constants }
         if (((is_constintnode(left) and is_constintnode(right)) or
              (is_constboolnode(left) and is_constboolnode(right) and
               (nodetype in [ltn,lten,gtn,gten,equaln,unequaln,andn,xorn,orn])))) or
            { support pointer arithmetics on constants (JM) }
            ((lt = pointerconstn) and is_constintnode(right) and
             (nodetype in [addn,subn])) or
            ((lt = pointerconstn) and (rt = pointerconstn) and
             (nodetype in [ltn,lten,gtn,gten,equaln,unequaln,subn])) then
           begin
              { when comparing/substracting  pointers, make sure they are }
              { of the same  type (JM)                                    }
              if (lt = pointerconstn) and (rt = pointerconstn) then
               begin
                 if not(cs_extsyntax in aktmoduleswitches) and
                    not(nodetype in [equaln,unequaln]) then
                   CGMessage(type_e_mismatch)
                 else
                   if (nodetype <> subn) and
                      is_voidpointer(rd) then
                     inserttypeconv(right,left.resulttype)
                   else if (nodetype <> subn) and
                           is_voidpointer(ld) then
                     inserttypeconv(left,right.resulttype)
                   else if not(is_equal(ld,rd)) then
                     CGMessage(type_e_mismatch);
                end
              else if (lt=ordconstn) and (rt=ordconstn) then
                begin
                  { make left const type the biggest, this type will be used
                    for orn,andn,xorn }
                  if rd.size>ld.size then
                    inserttypeconv(left,right.resulttype);
                end;

              { load values }
              if (lt = ordconstn) then
                lv:=tordconstnode(left).value
              else
                lv:=tpointerconstnode(left).value;
              if (rt = ordconstn) then
                rv:=tordconstnode(right).value
              else
                rv:=tpointerconstnode(right).value;
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
                  if (lt <> pointerconstn) or (rt = pointerconstn) then
                    t := genintconstnode(lv-rv)
                  else
                    t := cpointerconstnode.create(lv-rv,left.resulttype);
                muln :
                  t:=genintconstnode(lv*rv);
                xorn :
                  t:=cordconstnode.create(lv xor rv,left.resulttype);
                orn :
                  t:=cordconstnode.create(lv or rv,left.resulttype);
                andn :
                  t:=cordconstnode.create(lv and rv,left.resulttype);
                ltn :
                  t:=cordconstnode.create(ord(lv<rv),booltype);
                lten :
                  t:=cordconstnode.create(ord(lv<=rv),booltype);
                gtn :
                  t:=cordconstnode.create(ord(lv>rv),booltype);
                gten :
                  t:=cordconstnode.create(ord(lv>=rv),booltype);
                equaln :
                  t:=cordconstnode.create(ord(lv=rv),booltype);
                unequaln :
                  t:=cordconstnode.create(ord(lv<>rv),booltype);
                slashn :
                  begin
                    { int/int becomes a real }
                    if int(rv)=0 then
                     begin
                       Message(parser_e_invalid_float_operation);
                       t:=crealconstnode.create(0,pbestrealtype^);
                     end
                    else
                     t:=crealconstnode.create(int(lv)/int(rv),pbestrealtype^);
                  end;
                else
                  CGMessage(type_e_mismatch);
              end;
              resulttypepass(t);
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
                   t:=crealconstnode.create(lvd+rvd,pbestrealtype^);
                 subn :
                   t:=crealconstnode.create(lvd-rvd,pbestrealtype^);
                 muln :
                   t:=crealconstnode.create(lvd*rvd,pbestrealtype^);
                 starstarn,
                 caretn :
                   begin
                     if lvd<0 then
                      begin
                        Message(parser_e_invalid_float_operation);
                        t:=crealconstnode.create(0,pbestrealtype^);
                      end
                     else if lvd=0 then
                       t:=crealconstnode.create(1.0,pbestrealtype^)
                     else
                       t:=crealconstnode.create(exp(ln(lvd)*rvd),pbestrealtype^);
                   end;
                 slashn :
                   begin
                     if rvd=0 then
                      begin
                        Message(parser_e_invalid_float_operation);
                        t:=crealconstnode.create(0,pbestrealtype^);
                      end
                     else
                      t:=crealconstnode.create(lvd/rvd,pbestrealtype^);
                   end;
                 ltn :
                   t:=cordconstnode.create(ord(lvd<rvd),booltype);
                 lten :
                   t:=cordconstnode.create(ord(lvd<=rvd),booltype);
                 gtn :
                   t:=cordconstnode.create(ord(lvd>rvd),booltype);
                 gten :
                   t:=cordconstnode.create(ord(lvd>=rvd),booltype);
                 equaln :
                   t:=cordconstnode.create(ord(lvd=rvd),booltype);
                 unequaln :
                   t:=cordconstnode.create(ord(lvd<>rvd),booltype);
                 else
                   CGMessage(type_e_mismatch);
              end;
              resulttypepass(t);
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
              copywidestring(pcompilerwidestring(tstringconstnode(left).value_str)^,ws1);
              copywidestring(pcompilerwidestring(tstringconstnode(right).value_str)^,ws2);
              case nodetype of
                 addn :
                   begin
                      initwidestring(ws3);
                      concatwidestrings(ws1,ws2,ws3);
                      t:=cstringconstnode.createwstr(ws3);
                      donewidestring(ws3);
                   end;
                 ltn :
                   t:=cordconstnode.create(byte(comparewidestrings(ws1,ws2)<0),booltype);
                 lten :
                   t:=cordconstnode.create(byte(comparewidestrings(ws1,ws2)<=0),booltype);
                 gtn :
                   t:=cordconstnode.create(byte(comparewidestrings(ws1,ws2)>0),booltype);
                 gten :
                   t:=cordconstnode.create(byte(comparewidestrings(ws1,ws2)>=0),booltype);
                 equaln :
                   t:=cordconstnode.create(byte(comparewidestrings(ws1,ws2)=0),booltype);
                 unequaln :
                   t:=cordconstnode.create(byte(comparewidestrings(ws1,ws2)<>0),booltype);
              end;
              donewidestring(ws1);
              donewidestring(ws2);
              resulttypepass(t);
              result:=t;
              exit;
           end;

         { concating strings ? }
         concatstrings:=false;
         s1:=nil;
         s2:=nil;

         if (lt=ordconstn) and (rt=ordconstn) and
            is_char(ld) and is_char(rd) then
           begin
              s1:=strpnew(char(byte(tordconstnode(left).value)));
              s2:=strpnew(char(byte(tordconstnode(right).value)));
              l1:=1;
              l2:=1;
              concatstrings:=true;
           end
         else
           if (lt=stringconstn) and (rt=ordconstn) and is_char(rd) then
           begin
              s1:=tstringconstnode(left).getpcharcopy;
              l1:=tstringconstnode(left).len;
              s2:=strpnew(char(byte(tordconstnode(right).value)));
              l2:=1;
              concatstrings:=true;
           end
         else
           if (lt=ordconstn) and (rt=stringconstn) and is_char(ld) then
           begin
              s1:=strpnew(char(byte(tordconstnode(left).value)));
              l1:=1;
              s2:=tstringconstnode(right).getpcharcopy;
              l2:=tstringconstnode(right).len;
              concatstrings:=true;
           end
         else if (lt=stringconstn) and (rt=stringconstn) then
           begin
              s1:=tstringconstnode(left).getpcharcopy;
              l1:=tstringconstnode(left).len;
              s2:=tstringconstnode(right).getpcharcopy;
              l2:=tstringconstnode(right).len;
              concatstrings:=true;
           end;
         if concatstrings then
           begin
              case nodetype of
                 addn :
                   t:=cstringconstnode.createpchar(concatansistrings(s1,s2,l1,l2),l1+l2);
                 ltn :
                   t:=cordconstnode.create(byte(compareansistrings(s1,s2,l1,l2)<0),booltype);
                 lten :
                   t:=cordconstnode.create(byte(compareansistrings(s1,s2,l1,l2)<=0),booltype);
                 gtn :
                   t:=cordconstnode.create(byte(compareansistrings(s1,s2,l1,l2)>0),booltype);
                 gten :
                   t:=cordconstnode.create(byte(compareansistrings(s1,s2,l1,l2)>=0),booltype);
                 equaln :
                   t:=cordconstnode.create(byte(compareansistrings(s1,s2,l1,l2)=0),booltype);
                 unequaln :
                   t:=cordconstnode.create(byte(compareansistrings(s1,s2,l1,l2)<>0),booltype);
              end;
              ansistringdispose(s1,l1);
              ansistringdispose(s2,l2);
              resulttypepass(t);
              result:=t;
              exit;
           end;

         { set constant evaluation }
         if (right.nodetype=setconstn) and
            not assigned(tsetconstnode(right).left) and
            (left.nodetype=setconstn) and
            not assigned(tsetconstnode(left).left) then
           begin
              { check types }
              inserttypeconv(left,right.resulttype);
              if codegenerror then
               begin
                 { recover by only returning the left part }
                 result:=left;
                 left:=nil;
                 exit;
               end;
              new(resultset);
              case nodetype of
                 addn :
                   begin
                      for i:=0 to 31 do
                        resultset^[i]:=tsetconstnode(right).value_set^[i] or tsetconstnode(left).value_set^[i];
                      t:=csetconstnode.create(resultset,left.resulttype);
                   end;
                 muln :
                   begin
                      for i:=0 to 31 do
                        resultset^[i]:=tsetconstnode(right).value_set^[i] and tsetconstnode(left).value_set^[i];
                      t:=csetconstnode.create(resultset,left.resulttype);
                   end;
                 subn :
                   begin
                      for i:=0 to 31 do
                        resultset^[i]:=tsetconstnode(left).value_set^[i] and not(tsetconstnode(right).value_set^[i]);
                      t:=csetconstnode.create(resultset,left.resulttype);
                   end;
                 symdifn :
                   begin
                      for i:=0 to 31 do
                        resultset^[i]:=tsetconstnode(left).value_set^[i] xor tsetconstnode(right).value_set^[i];
                      t:=csetconstnode.create(resultset,left.resulttype);
                   end;
                 unequaln :
                   begin
                      b:=true;
                      for i:=0 to 31 do
                       if tsetconstnode(right).value_set^[i]=tsetconstnode(left).value_set^[i] then
                        begin
                          b:=false;
                          break;
                        end;
                      t:=cordconstnode.create(ord(b),booltype);
                   end;
                 equaln :
                   begin
                      b:=true;
                      for i:=0 to 31 do
                       if tsetconstnode(right).value_set^[i]<>tsetconstnode(left).value_set^[i] then
                        begin
                          b:=false;
                          break;
                        end;
                      t:=cordconstnode.create(ord(b),booltype);
                   end;
                 lten :
                   begin
                     b := true;
                     For i := 0 to 31 Do
                       If (tsetconstnode(right).value_set^[i] And tsetconstnode(left).value_set^[i]) <>
                           tsetconstnode(left).value_set^[i] Then
                         Begin
                           b := false;
                           Break
                         End;
                     t := cordconstnode.create(ord(b),booltype);
                   End;
                 gten :
                   Begin
                     b := true;
                     For i := 0 to 31 Do
                       If (tsetconstnode(left).value_set^[i] And tsetconstnode(right).value_set^[i]) <>
                           tsetconstnode(right).value_set^[i] Then
                         Begin
                           b := false;
                           Break
                         End;
                     t := cordconstnode.create(ord(b),booltype);
                   End;
              end;
              dispose(resultset);
              resulttypepass(t);
              result:=t;
              exit;
           end;

         { but an int/int gives real/real! }
         if nodetype=slashn then
          begin
            CGMessage(type_h_use_div_for_int);
            inserttypeconv(right,pbestrealtype^);
            inserttypeconv(left,pbestrealtype^);
          end

         { if both are orddefs then check sub types }
         else if (ld.deftype=orddef) and (rd.deftype=orddef) then
           begin
             { 2 booleans? Make them equal to the largest boolean }
             if is_boolean(ld) and is_boolean(rd) then
              begin
                if torddef(left.resulttype.def).size>torddef(right.resulttype.def).size then
                 begin
                   inserttypeconv(right,left.resulttype);
                   ttypeconvnode(right).convtype:=tc_bool_2_int;
                   include(right.flags,nf_explizit);
                 end
                else if torddef(left.resulttype.def).size<torddef(right.resulttype.def).size then
                 begin
                   inserttypeconv(left,right.resulttype);
                   ttypeconvnode(left).convtype:=tc_bool_2_int;
                   include(left.flags,nf_explizit);
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
                               resulttypepass(hp);
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
                               resulttypepass(hp);
                             end;
                            result:=hp;
                            exit;
                          end;
                       end;
                    end;
                  else
                    CGMessage(type_e_mismatch);
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
                       hp := genaddsstringcharoptnode(self);
                       resulttypepass(hp);
                       result := hp;
                       exit;
                     end;
                  end;
               end
             { is there a signed 64 bit type ? }
             else if ((torddef(rd).typ=s64bit) or (torddef(ld).typ=s64bit)) then
               begin
                  if (torddef(ld).typ<>s64bit) then
                   inserttypeconv(left,cs64bittype);
                  if (torddef(rd).typ<>s64bit) then
                   inserttypeconv(right,cs64bittype);
               end
             { is there a unsigned 64 bit type ? }
             else if ((torddef(rd).typ=u64bit) or (torddef(ld).typ=u64bit)) then
               begin
                  if (torddef(ld).typ<>u64bit) then
                   inserttypeconv(left,cu64bittype);
                  if (torddef(rd).typ<>u64bit) then
                   inserttypeconv(right,cu64bittype);
               end
             { is there a cardinal? }
             else if ((torddef(rd).typ=u32bit) or (torddef(ld).typ=u32bit)) then
               begin
                 if is_signed(ld) and
                    { then rd = u32bit }
                    { convert positive constants to u32bit }
                    not(is_constintnode(left) and
                        (tordconstnode(left).value >= 0)) and
                    { range/overflow checking on mixed signed/cardinal expressions }
                    { is only possible if you convert everything to 64bit (JM)     }
                    ((aktlocalswitches * [cs_check_overflow,cs_check_range] <> []) and
                     (nodetype in [addn,subn,muln])) then
                   begin
                     { perform the operation in 64bit }
                     CGMessage(type_w_mixed_signed_unsigned);
                     inserttypeconv(left,cs64bittype);
                     inserttypeconv(right,cs64bittype);
                   end
                 else
                   begin
                     if is_signed(ld) and
                        not(is_constintnode(left) and
                            (tordconstnode(left).value >= 0)) and
                        (cs_check_range in aktlocalswitches) then
                       CGMessage(type_w_mixed_signed_unsigned2);
                     inserttypeconv(left,u32bittype);

                     if is_signed(rd) and
                        { then ld = u32bit }
                        { convert positive constants to u32bit }
                        not(is_constintnode(right) and
                            (tordconstnode(right).value >= 0)) and
                        ((aktlocalswitches * [cs_check_overflow,cs_check_range] <> []) and
                         (nodetype in [addn,subn,muln])) then
                       begin
                         { perform the operation in 64bit }
                         CGMessage(type_w_mixed_signed_unsigned);
                         inserttypeconv(left,cs64bittype);
                         inserttypeconv(right,cs64bittype);
                       end
                     else
                       begin
                         if is_signed(rd) and
                            not(is_constintnode(right) and
                                (tordconstnode(right).value >= 0)) and
                            (cs_check_range in aktlocalswitches) then
                           CGMessage(type_w_mixed_signed_unsigned2);
                         inserttypeconv(right,u32bittype);
                       end;
                   end;
               end
             { generic ord conversion is s32bit }
             else
               begin
                 inserttypeconv(right,s32bittype);
                 inserttypeconv(left,s32bittype);
               end;
           end

         { if both are floatdefs, conversion is already done before constant folding }
           else if (ld.deftype=floatdef) then
            begin
              { already converted }
            end

         else if (right.resulttype.def.deftype=floatdef) or (left.resulttype.def.deftype=floatdef) then
          begin
            inserttypeconv(right,pbestrealtype^);
            inserttypeconv(left,pbestrealtype^);
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
                  if not(is_equal(tsetdef(ld).elementtype.def,rd)) then
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
               if (rd.deftype<>setdef) or not(is_equal(rd,ld)) then
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
          end

         { compare pchar to char arrays by addresses like BP/Delphi }
         else if (is_pchar(ld) and is_chararray(rd)) or
                 (is_pchar(rd) and is_chararray(ld)) then
           begin
             if is_chararray(rd) then
              inserttypeconv(right,left.resulttype)
             else
              inserttypeconv(left,right.resulttype);
           end

         { is one of the operands a string?,
           chararrays are also handled as strings (after conversion), also take
           care of chararray+chararray and chararray+char }
         else if (rd.deftype=stringdef) or (ld.deftype=stringdef) or
                 ((is_chararray(rd) or is_char(rd)) and
                  (is_chararray(ld) or is_char(ld))) then
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
                   inserttypeconv(right,cansistringtype);
                 if not(is_ansistring(ld)) then
                   inserttypeconv(left,cansistringtype);
              end
            else if is_longstring(rd) or is_longstring(ld) then
              begin
                 if not(is_longstring(rd)) then
                   inserttypeconv(right,clongstringtype);
                 if not(is_longstring(ld)) then
                   inserttypeconv(left,clongstringtype);
                 location.loc:=LOC_MEM;
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
                    else if not(is_equal(ld,rd)) then
                      CGMessage(type_e_mismatch);
                 end;
               ltn,lten,gtn,gten:
                 begin
                    if (cs_extsyntax in aktmoduleswitches) then
                     begin
                       if is_voidpointer(right.resulttype.def) then
                        inserttypeconv(right,left.resulttype)
                       else if is_voidpointer(left.resulttype.def) then
                        inserttypeconv(left,right.resulttype)
                       else if not(is_equal(ld,rd)) then
                        CGMessage(type_e_mismatch);
                     end
                    else
                     CGMessage(type_e_mismatch);
                 end;
               subn:
                 begin
                    if (cs_extsyntax in aktmoduleswitches) then
                     begin
                       if is_voidpointer(right.resulttype.def) then
                        inserttypeconv(right,left.resulttype)
                       else if is_voidpointer(left.resulttype.def) then
                        inserttypeconv(left,right.resulttype)
                       else if not(is_equal(ld,rd)) then
                        CGMessage(type_e_mismatch);
                     end
                    else
                     CGMessage(type_e_mismatch);
                    resulttype:=s32bittype;
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
                       else if not(is_equal(ld,rd)) then
                        CGMessage(type_e_mismatch);
                     end
                    else
                     CGMessage(type_e_mismatch);
                    resulttype:=s32bittype;
                    exit;
                 end;
               else
                 CGMessage(type_e_mismatch);
            end;
          end

         { class or interface equation }
         else if is_class_or_interface(rd) or is_class_or_interface(ld) then
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

            if not(nodetype in [equaln,unequaln]) then
             CGMessage(type_e_mismatch);
          end

         else if (rd.deftype=classrefdef) and (ld.deftype=classrefdef) then
          begin
            if tobjectdef(tclassrefdef(rd).pointertype.def).is_related(
                    tobjectdef(tclassrefdef(ld).pointertype.def)) then
              inserttypeconv(right,left.resulttype)
            else
              inserttypeconv(left,right.resulttype);

            if not(nodetype in [equaln,unequaln]) then
             CGMessage(type_e_mismatch);
          end

         { allows comperasion with nil pointer }
         else if is_class_or_interface(rd) or (rd.deftype=classrefdef) then
          begin
            inserttypeconv(left,right.resulttype);
            if not(nodetype in [equaln,unequaln]) then
             CGMessage(type_e_mismatch);
          end

         else if is_class_or_interface(ld) or (ld.deftype=classrefdef) then
          begin
            inserttypeconv(right,left.resulttype);
            if not(nodetype in [equaln,unequaln]) then
             CGMessage(type_e_mismatch);
          end

       { support procvar=nil,procvar<>nil }
         else if ((ld.deftype=procvardef) and (rt=niln)) or
                 ((rd.deftype=procvardef) and (lt=niln)) then
          begin
            if not(nodetype in [equaln,unequaln]) then
             CGMessage(type_e_mismatch);
          end

{$ifdef SUPPORT_MMX}
       { mmx support, this must be before the zero based array
         check }
         else if (cs_mmx in aktlocalswitches) and
                 is_mmx_able_array(ld) and
                 is_mmx_able_array(rd) and
                 is_equal(ld,rd) then
            begin
              case nodetype of
                addn,subn,xorn,orn,andn:
                  ;
                { mul is a little bit restricted }
                muln:
                  if not(mmx_type(ld) in [mmxu16bit,mmxs16bit,mmxfixed16]) then
                    CGMessage(type_e_mismatch);
                else
                  CGMessage(type_e_mismatch);
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
              end;
            inserttypeconv(left,s32bittype);
            if nodetype=addn then
              begin
                if not(cs_extsyntax in aktmoduleswitches) or
                   (not(is_pchar(ld)) and not(m_add_pointer in aktmodeswitches)) then
                  CGMessage(type_e_mismatch);
                if (rd.deftype=pointerdef) and
                   (tpointerdef(rd).pointertype.def.size>1) then
                  left:=caddnode.create(muln,left,cordconstnode.create(tpointerdef(rd).pointertype.def.size,s32bittype));
              end
            else
              CGMessage(type_e_mismatch);
          end

         else if (ld.deftype=pointerdef) or is_zero_based_array(ld) then
          begin
            if is_zero_based_array(ld) then
              begin
                 resulttype.setdef(tpointerdef.create(tarraydef(ld).elementtype));
                 inserttypeconv(left,resulttype);
              end;
            inserttypeconv(right,s32bittype);
            if nodetype in [addn,subn] then
              begin
                if not(cs_extsyntax in aktmoduleswitches) or
                   (not(is_pchar(ld)) and not(m_add_pointer in aktmodeswitches)) then
                  CGMessage(type_e_mismatch);
                if (ld.deftype=pointerdef) and
                   (tpointerdef(ld).pointertype.def.size>1) then
                  right:=caddnode.create(muln,right,cordconstnode.create(tpointerdef(ld).pointertype.def.size,s32bittype));
              end
            else
              CGMessage(type_e_mismatch);
         end

         else if (rd.deftype=procvardef) and (ld.deftype=procvardef) and is_equal(rd,ld) then
          begin
            if not (nodetype in [equaln,unequaln]) then
             CGMessage(type_e_mismatch);
          end

         { enums }
         else if (ld.deftype=enumdef) and (rd.deftype=enumdef) then
          begin
            if not(is_equal(ld,rd)) then
             inserttypeconv(right,left.resulttype);
            if not(nodetype in [equaln,unequaln,ltn,lten,gtn,gten]) then
             CGMessage(type_e_mismatch);
          end

         { generic conversion, this is for error recovery }
         else
          begin
            inserttypeconv(left,s32bittype);
            inserttypeconv(right,s32bittype);
          end;

         { set resulttype if not already done }
         if not assigned(resulttype.def) then
          begin
             case nodetype of
                ltn,lten,gtn,gten,equaln,unequaln :
                  resulttype:=booltype;
                slashn :
                  resulttype:=pbestrealtype^;
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
      end;


    function taddnode.pass_1 : tnode;
      var
         hp      : tnode;
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
             { maybe we need an integer register to save }
             { a reference                               }
             if ((left.location.loc<>LOC_FPU) or
                 (right.location.loc<>LOC_FPU)) and
                (left.registers32=right.registers32) then
               calcregisters(self,1,1,0)
             else
               calcregisters(self,0,1,0);
             location.loc:=LOC_FPU;
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
                   calcregisters(self,0,0,0);
                   location.loc:=LOC_JUMP;
                 end
                else
                 begin
                   if (left.location.loc in [LOC_JUMP,LOC_FLAGS]) and
                      (left.location.loc in [LOC_JUMP,LOC_FLAGS]) then
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
                 calcregisters(self,1,0,0);
               end
              { is there a 64 bit type ? }
             else if (torddef(ld).typ in [s64bit,u64bit]) then
               calcregisters(self,2,0,0)
             { is there a cardinal? }
             else if (torddef(ld).typ=u32bit) then
               begin
                 calcregisters(self,1,0,0);
                 { for unsigned mul we need an extra register }
                 if nodetype=muln then
                  inc(registers32);
               end
             { generic s32bit conversion }
             else
               calcregisters(self,1,0,0);
           end

         { left side a setdef, must be before string processing,
           else array constructor can be seen as array of char (PFV) }
         else if (ld.deftype=setdef) then
           begin
             if tsetdef(ld).settype=smallset then
              begin
                 { are we adding set elements ? }
                 if right.nodetype=setelementn then
                   calcregisters(self,2,0,0)
                 else
                   calcregisters(self,1,0,0);
                 location.loc:=LOC_REGISTER;
              end
             else
              begin
                 calcregisters(self,0,0,0);
                 { here we call SET... }
                 procinfo^.flags:=procinfo^.flags or pi_do_call;
                 location.loc:=LOC_MEM;
              end;
           end

         { compare pchar by addresses like BP/Delphi }
         else if is_pchar(ld) then
           begin
             location.loc:=LOC_REGISTER;
             calcregisters(self,1,0,0);
           end

         { is one of the operands a string }
         else if (ld.deftype=stringdef) then
            begin
              if is_widestring(ld) then
                begin
                   { we use reference counted widestrings so no fast exit here }
                   procinfo^.no_fast_exit:=true;
                   { this is only for add, the comparisaion is handled later }
                   location.loc:=LOC_REGISTER;
                end
              else if is_ansistring(ld) then
                begin
                   { we use ansistrings so no fast exit here }
                   procinfo^.no_fast_exit:=true;
                   { this is only for add, the comparisaion is handled later }
                   location.loc:=LOC_REGISTER;
                end
              else if is_longstring(ld) then
                begin
                   { this is only for add, the comparisaion is handled later }
                   location.loc:=LOC_MEM;
                end
              else
                begin
                   if canbeaddsstringcharoptnode(self) then
                     begin
                       hp := genaddsstringcharoptnode(self);
                       firstpass(hp);
                       pass_1 := hp;
                       exit;
                     end
                   else
                     begin
                       { Fix right to be shortstring }
                       if is_char(right.resulttype.def) then
                        begin
                          inserttypeconv(right,cshortstringtype);
                          firstpass(right);
                        end;
                     end;
                   if canbeaddsstringcsstringoptnode(self) then
                     begin
                       hp := genaddsstringcsstringoptnode(self);
                       firstpass(hp);
                       pass_1 := hp;
                       exit;
                     end;
                   { this is only for add, the comparisaion is handled later }
                   location.loc:=LOC_MEM;
                end;
              { here we call STRCONCAT or STRCMP or STRCOPY }
              procinfo^.flags:=procinfo^.flags or pi_do_call;
              if location.loc=LOC_MEM then
                calcregisters(self,0,0,0)
              else
                calcregisters(self,1,0,0);
           end

         { is one a real float ? }
         else if (rd.deftype=floatdef) or (ld.deftype=floatdef) then
            begin
              calcregisters(self,0,1,0);
              location.loc:=LOC_FPU;
            end

         { pointer comperation and subtraction }
         else if (ld.deftype=pointerdef) then
            begin
              location.loc:=LOC_REGISTER;
              calcregisters(self,1,0,0);
           end

         else if is_class_or_interface(ld) then
            begin
              location.loc:=LOC_REGISTER;
              calcregisters(self,1,0,0);
            end

         else if (ld.deftype=classrefdef) then
            begin
              location.loc:=LOC_REGISTER;
              calcregisters(self,1,0,0);
            end

         { support procvar=nil,procvar<>nil }
         else if ((ld.deftype=procvardef) and (rt=niln)) or
                 ((rd.deftype=procvardef) and (lt=niln)) then
            begin
              calcregisters(self,1,0,0);
              location.loc:=LOC_REGISTER;
            end

{$ifdef SUPPORT_MMX}
       { mmx support, this must be before the zero based array
         check }
         else if (cs_mmx in aktlocalswitches) and is_mmx_able_array(ld) and
                 is_mmx_able_array(rd) then
            begin
              location.loc:=LOC_MMXREGISTER;
              calcregisters(self,0,0,1);
            end
{$endif SUPPORT_MMX}

         else if (rd.deftype=pointerdef) or (ld.deftype=pointerdef) then
            begin
              location.loc:=LOC_REGISTER;
              calcregisters(self,1,0,0);
            end

         else  if (rd.deftype=procvardef) and (ld.deftype=procvardef) and is_equal(rd,ld) then
           begin
             calcregisters(self,1,0,0);
             location.loc:=LOC_REGISTER;
           end

         else if (ld.deftype=enumdef) then
           begin
              calcregisters(self,1,0,0);
           end

{$ifdef SUPPORT_MMX}
         else if (cs_mmx in aktlocalswitches) and
                 is_mmx_able_array(ld) and
                 is_mmx_able_array(rd) then
            begin
              location.loc:=LOC_MMXREGISTER;
              calcregisters(self,0,0,1);
            end
{$endif SUPPORT_MMX}

         { the general solution is to convert to 32 bit int }
         else
           begin
             calcregisters(self,1,0,0);
             location.loc:=LOC_REGISTER;
           end;

         case nodetype of
            ltn,lten,gtn,gten,equaln,unequaln:
              begin
                 if is_64bitint(left.resulttype.def) then
                   location.loc:=LOC_JUMP
                 else
                   location.loc:=LOC_FLAGS;
              end;
            xorn:
              begin
                location.loc:=LOC_REGISTER;
              end;
         end;
      end;

begin
   caddnode:=taddnode;
end.
{
  $Log$
  Revision 1.30  2001-06-04 21:41:26  peter
    * readded generic conversion to s32bit that i removed yesterday. It
      is still used for error recovery, added a small note about that

  Revision 1.29  2001/06/04 18:13:53  peter
    * Support kylix hack of having enum+integer in a enum declaration.

  Revision 1.28  2001/05/27 14:30:55  florian
    + some widestring stuff added

  Revision 1.27  2001/05/19 21:11:50  peter
    * first check for overloaded operator before doing inserting any
      typeconvs

  Revision 1.26  2001/05/19 12:53:52  peter
    * check set types when doing constant set evaluation

  Revision 1.25  2001/04/13 01:22:08  peter
    * symtable change to classes
    * range check generation and errors fixed, make cycle DEBUG=1 works
    * memory leaks fixed

  Revision 1.24  2001/04/04 22:42:39  peter
    * move constant folding into det_resulttype

  Revision 1.23  2001/04/02 21:20:30  peter
    * resulttype rewrite

  Revision 1.22  2001/02/04 11:12:17  jonas
    * fixed web bug 1377 & const pointer arithmtic

  Revision 1.21  2001/01/14 22:13:13  peter
    * constant calculation fixed. The type of the new constant is now
      defined after the calculation is done. This should remove a lot
      of wrong warnings (and errors with -Cr).

  Revision 1.20  2000/12/31 11:14:10  jonas
    + implemented/fixed docompare() mathods for all nodes (not tested)
    + nopt.pas, nadd.pas, i386/n386opt.pas: optimized nodes for adding strings
      and constant strings/chars together
    * n386add.pas: don't copy temp strings (of size 256) to another temp string
      when adding

  Revision 1.19  2000/12/16 15:55:32  jonas
    + warning when there is a chance to get a range check error because of
      automatic type conversion to u32bit
    * arithmetic operations with a cardinal and a signed operand are carried
      out in 64bit when range checking is on ("merged" from fixes branch)

  Revision 1.18  2000/11/29 00:30:31  florian
    * unused units removed from uses clause
    * some changes for widestrings

  Revision 1.17  2000/11/20 15:30:42  jonas
    * changed types of values used for constant expression evaluation to
      tconstexprint

  Revision 1.16  2000/11/13 11:30:55  florian
    * some bugs with interfaces and NIL fixed

  Revision 1.15  2000/11/04 14:25:20  florian
    + merged Attila's changes for interfaces, not tested yet

  Revision 1.14  2000/10/31 22:02:47  peter
    * symtable splitted, no real code changes

  Revision 1.13  2000/10/14 10:14:50  peter
    * moehrendorf oct 2000 rewrite

  Revision 1.12  2000/10/01 19:48:23  peter
    * lot of compile updates for cg11

  Revision 1.11  2000/09/30 16:08:45  peter
    * more cg11 updates

  Revision 1.10  2000/09/28 19:49:52  florian
  *** empty log message ***

  Revision 1.9  2000/09/27 21:33:22  florian
    * finally nadd.pas compiles

  Revision 1.8  2000/09/27 20:25:44  florian
    * more stuff fixed

  Revision 1.7  2000/09/27 18:14:31  florian
    * fixed a lot of syntax errors in the n*.pas stuff

  Revision 1.6  2000/09/24 15:06:19  peter
    * use defines.inc

  Revision 1.5  2000/09/22 22:42:52  florian
    * more fixes

  Revision 1.4  2000/09/21 12:22:42  jonas
    * put piece of code between -dnewoptimizations2 since it wasn't
      necessary otherwise
    + support for full boolean evaluation (from tcadd)

  Revision 1.3  2000/09/20 21:50:59  florian
    * updated

  Revision 1.2  2000/08/29 08:24:45  jonas
    * some modifications to -dcardinalmulfix code

  Revision 1.1  2000/08/26 12:24:20  florian
    * initial release
}
