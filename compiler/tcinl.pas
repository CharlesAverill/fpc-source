{
    $Id$
    Copyright (c) 1993-98 by Florian Klaempfl

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
unit tcinl;
interface

    uses
      tree;

    procedure firstinline(var p : ptree);


implementation

    uses
      cobjects,verbose,globals,systems,
      globtype,
      symconst,symtable,aasm,types,
      hcodegen,htypechk,pass_1,
      tccal,cpubase
{$ifdef i386}
      ,tgeni386
{$endif}
      ;

{*****************************************************************************
                             FirstInLine
*****************************************************************************}

    procedure firstinline(var p : ptree);
      var
         vl,vl2  : longint;
         vr      : bestreal;
         p1,hp,hpp  : ptree;
{$ifndef NOCOLONCHECK}
         frac_para,length_para : ptree;
{$endif ndef NOCOLONCHECK}
         store_count_ref,
         isreal,
         dowrite,
         store_valid,
         file_is_typed : boolean;

      procedure do_lowhigh(adef : pdef);

        var
           v : longint;
           enum : penumsym;

        begin
           case Adef^.deftype of
             orddef:
               begin
                  if p^.inlinenumber=in_low_x then
                    v:=porddef(Adef)^.low
                  else
                    v:=porddef(Adef)^.high;
                  hp:=genordinalconstnode(v,adef);
                  firstpass(hp);
                  disposetree(p);
                  p:=hp;
               end;
             enumdef:
               begin
                  enum:=Penumdef(Adef)^.firstenum;
                  if p^.inlinenumber=in_high_x then
                    while enum^.nextenum<>nil do
                      enum:=enum^.nextenum;
                  hp:=genenumnode(enum);
                  disposetree(p);
                  p:=hp;
               end;
           else
             internalerror(87);
           end;
        end;

      function getconstrealvalue : bestreal;

        begin
           case p^.left^.treetype of
              ordconstn:
                getconstrealvalue:=p^.left^.value;
              realconstn:
                getconstrealvalue:=p^.left^.value_real;
              else
                internalerror(309992);
           end;
        end;

      procedure setconstrealvalue(r : bestreal);

        var
           hp : ptree;

        begin
           hp:=genrealconstnode(r,bestrealdef^);
           disposetree(p);
           p:=hp;
           firstpass(p);
        end;

      procedure handleextendedfunction;

        begin
           p^.location.loc:=LOC_FPU;
           p^.resulttype:=s80floatdef;
           if (p^.left^.resulttype^.deftype<>floatdef) or
             (pfloatdef(p^.left^.resulttype)^.typ<>s80real) then
             begin
                p^.left:=gentypeconvnode(p^.left,s80floatdef);
                firstpass(p^.left);
             end;
           p^.registers32:=p^.left^.registers32;
           p^.registersfpu:=p^.left^.registersfpu;
{$ifdef SUPPORT_MMX}
           p^.registersmmx:=p^.left^.registersmmx;
{$endif SUPPORT_MMX}
        end;

      begin
         store_valid:=must_be_valid;
         store_count_ref:=count_ref;
         count_ref:=false;
         if not (p^.inlinenumber in [in_read_x,in_readln_x,in_sizeof_x,
            in_typeof_x,in_ord_x,in_str_x_string,in_val_x,
            in_reset_typedfile,in_rewrite_typedfile]) then
           must_be_valid:=true
         else
           must_be_valid:=false;
         { if we handle writeln; p^.left contains no valid address }
         if assigned(p^.left) then
           begin
              if p^.left^.treetype=callparan then
                firstcallparan(p^.left,nil)
              else
                firstpass(p^.left);
              left_right_max(p);
              set_location(p^.location,p^.left^.location);
           end;
         { handle intern constant functions in separate case }
         if p^.inlineconst then
          begin
            hp:=nil;
            { no parameters? }
            if not assigned(p^.left) then
             begin
               case p^.inlinenumber of
                 in_const_pi :
                   hp:=genrealconstnode(pi,bestrealdef^);
                 else
                   internalerror(89);
               end;
             end
            else
            { process constant expression with parameter }
             begin
               vl:=0;
               vl2:=0; { second parameter Ex: ptr(vl,vl2) }
               vr:=0;
               isreal:=false;
               case p^.left^.treetype of
                 realconstn :
                   begin
                     isreal:=true;
                     vr:=p^.left^.value_real;
                   end;
                 ordconstn :
                   vl:=p^.left^.value;
                 callparan :
                   begin
                     { both exists, else it was not generated }
                     vl:=p^.left^.left^.value;
                     vl2:=p^.left^.right^.left^.value;
                   end;
                 else
                   CGMessage(cg_e_illegal_expression);
               end;
               case p^.inlinenumber of
                 in_const_trunc :
                   begin
                     if isreal then
                       begin
                          if (vr>=2147483648.0) or (vr<=-2147483649.0) then
                            begin
                               CGMessage(parser_e_range_check_error);
                               hp:=genordinalconstnode(1,s32bitdef)
                            end
                          else
                            hp:=genordinalconstnode(trunc(vr),s32bitdef)
                       end
                     else
                      hp:=genordinalconstnode(trunc(vl),s32bitdef);
                   end;
                 in_const_round :
                   begin
                     if isreal then
                       begin
                          if (vr>=2147483647.5) or (vr<=-2147483648.5) then
                            begin
                               CGMessage(parser_e_range_check_error);
                               hp:=genordinalconstnode(1,s32bitdef)
                            end
                          else
                            hp:=genordinalconstnode(round(vr),s32bitdef)
                       end
                     else
                      hp:=genordinalconstnode(round(vl),s32bitdef);
                   end;
                 in_const_frac :
                   begin
                     if isreal then
                      hp:=genrealconstnode(frac(vr),bestrealdef^)
                     else
                      hp:=genrealconstnode(frac(vl),bestrealdef^);
                   end;
                 in_const_int :
                   begin
                     if isreal then
                      hp:=genrealconstnode(int(vr),bestrealdef^)
                     else
                      hp:=genrealconstnode(int(vl),bestrealdef^);
                   end;
                 in_const_abs :
                   begin
                     if isreal then
                      hp:=genrealconstnode(abs(vr),bestrealdef^)
                     else
                      hp:=genordinalconstnode(abs(vl),p^.left^.resulttype);
                   end;
                 in_const_sqr :
                   begin
                     if isreal then
                      hp:=genrealconstnode(sqr(vr),bestrealdef^)
                     else
                      hp:=genordinalconstnode(sqr(vl),p^.left^.resulttype);
                   end;
                 in_const_odd :
                   begin
                     if isreal then
                      CGMessage1(type_e_integer_expr_expected,p^.left^.resulttype^.typename)
                     else
                      hp:=genordinalconstnode(byte(odd(vl)),booldef);
                   end;
                 in_const_swap_word :
                   begin
                     if isreal then
                      CGMessage1(type_e_integer_expr_expected,p^.left^.resulttype^.typename)
                     else
                      hp:=genordinalconstnode((vl and $ff) shl 8+(vl shr 8),p^.left^.resulttype);
                   end;
                 in_const_swap_long :
                   begin
                     if isreal then
                      CGMessage(type_e_mismatch)
                     else
                      hp:=genordinalconstnode((vl and $ffff) shl 16+(vl shr 16),p^.left^.resulttype);
                   end;
                 in_const_ptr :
                   begin
                     if isreal then
                      CGMessage(type_e_mismatch)
                     else
                      hp:=genordinalconstnode((vl2 shl 16) or vl,voidpointerdef);
                   end;
                 in_const_sqrt :
                   begin
                     if isreal then
                       begin
                          if vr<0.0 then
                           CGMessage(type_e_wrong_math_argument)
                          else
                           hp:=genrealconstnode(sqrt(vr),bestrealdef^)
                       end
                     else
                       begin
                          if vl<0 then
                           CGMessage(type_e_wrong_math_argument)
                          else
                           hp:=genrealconstnode(sqrt(vl),bestrealdef^);
                       end;
                   end;
                 in_const_arctan :
                   begin
                     if isreal then
                      hp:=genrealconstnode(arctan(vr),bestrealdef^)
                     else
                      hp:=genrealconstnode(arctan(vl),bestrealdef^);
                   end;
                 in_const_cos :
                   begin
                     if isreal then
                      hp:=genrealconstnode(cos(vr),bestrealdef^)
                     else
                      hp:=genrealconstnode(cos(vl),bestrealdef^);
                   end;
                 in_const_sin :
                   begin
                     if isreal then
                      hp:=genrealconstnode(sin(vr),bestrealdef^)
                     else
                      hp:=genrealconstnode(sin(vl),bestrealdef^);
                   end;
                 in_const_exp :
                   begin
                     if isreal then
                      hp:=genrealconstnode(exp(vr),bestrealdef^)
                     else
                      hp:=genrealconstnode(exp(vl),bestrealdef^);
                   end;
                 in_const_ln :
                   begin
                     if isreal then
                       begin
                          if vr<=0.0 then
                           CGMessage(type_e_wrong_math_argument)
                          else
                           hp:=genrealconstnode(ln(vr),bestrealdef^)
                       end
                     else
                       begin
                          if vl<=0 then
                           CGMessage(type_e_wrong_math_argument)
                          else
                           hp:=genrealconstnode(ln(vl),bestrealdef^);
                       end;
                   end;
                 else
                   internalerror(88);
               end;
             end;
            disposetree(p);
            if hp=nil then
             hp:=genzeronode(errorn);
            firstpass(hp);
            p:=hp;
          end
         else
          begin
            case p^.inlinenumber of
             in_lo_qword,
             in_hi_qword,
             in_lo_long,
             in_hi_long,
             in_lo_word,
             in_hi_word:

               begin
                  if p^.registers32<1 then
                    p^.registers32:=1;
                  if p^.inlinenumber in [in_lo_word,in_hi_word] then
                    p^.resulttype:=u8bitdef
                  else if p^.inlinenumber in [in_lo_qword,in_hi_qword] then
                    begin
                       p^.resulttype:=u32bitdef;
                       if (m_tp in aktmodeswitches) or
                          (m_delphi in aktmodeswitches) then
                         CGMessage(type_w_maybe_wrong_hi_lo);
                    end
                  else
                    begin
                       p^.resulttype:=u16bitdef;
                       if (m_tp in aktmodeswitches) or
                          (m_delphi in aktmodeswitches) then
                         CGMessage(type_w_maybe_wrong_hi_lo);
                    end;
                  p^.location.loc:=LOC_REGISTER;
                  if not is_integer(p^.left^.resulttype) then
                    CGMessage(type_e_mismatch)
                  else
                    begin
                      if p^.left^.treetype=ordconstn then
                       begin
                         case p^.inlinenumber of
                          in_lo_word : hp:=genordinalconstnode(p^.left^.value and $ff,p^.left^.resulttype);
                          in_hi_word : hp:=genordinalconstnode(p^.left^.value shr 8,p^.left^.resulttype);
                          in_lo_long : hp:=genordinalconstnode(p^.left^.value and $ffff,p^.left^.resulttype);
                          in_hi_long : hp:=genordinalconstnode(p^.left^.value shr 16,p^.left^.resulttype);
                          in_lo_qword : hp:=genordinalconstnode(p^.left^.value and $ffffffff,p^.left^.resulttype);
                          in_hi_qword : hp:=genordinalconstnode(p^.left^.value shr 32,p^.left^.resulttype);
                         end;
                         disposetree(p);
                         firstpass(hp);
                         p:=hp;
                       end;
                    end;
               end;

             in_sizeof_x:
               begin
                 if push_high_param(p^.left^.resulttype) then
                  begin
                    getsymonlyin(p^.left^.symtable,'high'+pvarsym(p^.left^.symtableentry)^.name);
                    hp:=gennode(addn,genloadnode(pvarsym(srsym),p^.left^.symtable),
                                     genordinalconstnode(1,s32bitdef));
                    if (p^.left^.resulttype^.deftype=arraydef) and
                       (parraydef(p^.left^.resulttype)^.elesize<>1) then
                      hp:=gennode(muln,hp,genordinalconstnode(parraydef(p^.left^.resulttype)^.elesize,s32bitdef));
                    disposetree(p);
                    p:=hp;
                    firstpass(p);
                  end;
                 if p^.registers32<1 then
                    p^.registers32:=1;
                 p^.resulttype:=s32bitdef;
                 p^.location.loc:=LOC_REGISTER;
               end;

             in_typeof_x:
               begin
                  if p^.registers32<1 then
                    p^.registers32:=1;
                  p^.location.loc:=LOC_REGISTER;
                  p^.resulttype:=voidpointerdef;
               end;

             in_ord_x:
               begin
                  if (p^.left^.treetype=ordconstn) then
                    begin
                       hp:=genordinalconstnode(p^.left^.value,s32bitdef);
                       disposetree(p);
                       p:=hp;
                       firstpass(p);
                    end
                  else
                    begin
                       if (p^.left^.resulttype^.deftype=orddef) then
                         if (porddef(p^.left^.resulttype)^.typ in [uchar,bool8bit]) then
                           begin
                              if porddef(p^.left^.resulttype)^.typ=bool8bit then
                                begin
                                   hp:=gentypeconvnode(p^.left,u8bitdef);
                                   putnode(p);
                                   p:=hp;
                                   p^.convtyp:=tc_bool_2_int;
                                   p^.explizit:=true;
                                   firstpass(p);
                                end
                              else
                                begin
                                   hp:=gentypeconvnode(p^.left,u8bitdef);
                                   putnode(p);
                                   p:=hp;
                                   p^.explizit:=true;
                                   firstpass(p);
                                end;
                           end
                         { can this happen ? }
                         else if (porddef(p^.left^.resulttype)^.typ=uvoid) then
                           CGMessage(type_e_mismatch)
                         else
                           { all other orddef need no transformation }
                           begin
                              hp:=p^.left;
                              putnode(p);
                              p:=hp;
                           end
                       else if (p^.left^.resulttype^.deftype=enumdef) then
                         begin
                            hp:=gentypeconvnode(p^.left,s32bitdef);
                            putnode(p);
                            p:=hp;
                            p^.explizit:=true;
                            firstpass(p);
                         end
                       else
                         begin
                            { can anything else be ord() ?}
                            CGMessage(type_e_mismatch);
                         end;
                    end;
               end;

             in_chr_byte:
               begin
                  hp:=gentypeconvnode(p^.left,cchardef);
                  putnode(p);
                  p:=hp;
                  p^.explizit:=true;
                  firstpass(p);
               end;

             in_length_string:
               begin
                  if is_ansistring(p^.left^.resulttype) then
                    p^.resulttype:=s32bitdef
                  else
                    p^.resulttype:=u8bitdef;
                  { we don't need string conversations here }
                  if (p^.left^.treetype=typeconvn) and
                     (p^.left^.left^.resulttype^.deftype=stringdef) then
                    begin
                       hp:=p^.left^.left;
                       putnode(p^.left);
                       p^.left:=hp;
                    end;

                  { check the type, must be string or char }
                  if (p^.left^.resulttype^.deftype<>stringdef) and
                     (not is_char(p^.left^.resulttype)) then
                    CGMessage(type_e_mismatch);

                  { evaluates length of constant strings direct }
                  if (p^.left^.treetype=stringconstn) then
                    begin
                       hp:=genordinalconstnode(p^.left^.length,s32bitdef);
                       disposetree(p);
                       firstpass(hp);
                       p:=hp;
                    end
                  { length of char is one allways }
                  else if is_constcharnode(p^.left) then
                    begin
                       hp:=genordinalconstnode(1,s32bitdef);
                       disposetree(p);
                       firstpass(hp);
                       p:=hp;
                    end;
               end;

             in_assigned_x:
               begin
                  p^.resulttype:=booldef;
                  p^.location.loc:=LOC_FLAGS;
               end;

             in_pred_x,
             in_succ_x:
               begin
                  inc(p^.registers32);
                  p^.resulttype:=p^.left^.resulttype;
                  p^.location.loc:=LOC_REGISTER;
                  if not is_ordinal(p^.resulttype) then
                    CGMessage(type_e_ordinal_expr_expected)
                  else
                    begin
                      if (p^.resulttype^.deftype=enumdef) and
                         (penumdef(p^.resulttype)^.has_jumps) then
                        CGMessage(type_e_succ_and_pred_enums_with_assign_not_possible)
                      else
                        if p^.left^.treetype=ordconstn then
                         begin
                           if p^.inlinenumber=in_succ_x then
                             hp:=genordinalconstnode(p^.left^.value+1,p^.left^.resulttype)
                           else
                             hp:=genordinalconstnode(p^.left^.value-1,p^.left^.resulttype);
                           disposetree(p);
                           firstpass(hp);
                           p:=hp;
                         end;
                    end;
               end;

             in_inc_x,
             in_dec_x:
               begin
                 p^.resulttype:=voiddef;
                 if assigned(p^.left) then
                   begin
                      firstcallparan(p^.left,nil);
                      if codegenerror then
                       exit;
                      { first param must be var }
                      if p^.left^.left^.location.loc<>LOC_REFERENCE then
                        CGMessage(type_e_argument_must_be_lvalue);
                      { check type }
                      if (p^.left^.resulttype^.deftype in [enumdef,pointerdef]) or
                         is_ordinal(p^.left^.resulttype) then
                        begin
                           { two paras ? }
                           if assigned(p^.left^.right) then
                             begin
                                { insert a type conversion       }
                                { the second param is always longint }
                                p^.left^.right^.left:=gentypeconvnode(p^.left^.right^.left,s32bitdef);
                                { check the type conversion }
                                firstpass(p^.left^.right^.left);

                                { need we an additional register ? }
                                if not(is_constintnode(p^.left^.right^.left)) and
                                  (p^.left^.right^.left^.location.loc in [LOC_MEM,LOC_REFERENCE]) and
                                  (p^.left^.right^.left^.registers32<=1) then
                                  inc(p^.registers32);

                                if assigned(p^.left^.right^.right) then
                                  CGMessage(cg_e_illegal_expression);
                             end;
                        end
                      else
                        CGMessage(type_e_ordinal_expr_expected);
                   end
                 else
                   CGMessage(type_e_mismatch);
               end;

             in_read_x,
             in_readln_x,
             in_write_x,
             in_writeln_x :
               begin
                  { needs a call }
                  procinfo.flags:=procinfo.flags or pi_do_call;
                  p^.resulttype:=voiddef;
                  { we must know if it is a typed file or not }
                  { but we must first do the firstpass for it }
                  file_is_typed:=false;
                  if assigned(p^.left) then
                    begin
                       dowrite:=(p^.inlinenumber in [in_write_x,in_writeln_x]);
                       firstcallparan(p^.left,nil);
                       { now we can check }
                       hp:=p^.left;
                       while assigned(hp^.right) do
                         hp:=hp^.right;
                       { if resulttype is not assigned, then automatically }
                       { file is not typed.                             }
                       if assigned(hp) and assigned(hp^.resulttype) then
                         Begin
                           if (hp^.resulttype^.deftype=filedef) and
                              (pfiledef(hp^.resulttype)^.filetype=ft_typed) then
                            begin
                              file_is_typed:=true;
                              { test the type }
                              hpp:=p^.left;
                              while (hpp<>hp) do
                               begin
                                 if (hpp^.left^.treetype=typen) then
                                   CGMessage(type_e_cant_read_write_type);
                                 if not is_equal(hpp^.resulttype,pfiledef(hp^.resulttype)^.typed_as) then
                                   CGMessage(type_e_mismatch);
                                 { generate the high() value for the shortstring }
                                 if ((not dowrite) and is_shortstring(hpp^.left^.resulttype)) or
                                    (is_chararray(hpp^.left^.resulttype)) then
                                   gen_high_tree(hpp,true);
                                 hpp:=hpp^.right;
                               end;
                            end;
                         end; { endif assigned(hp) }

                       { insert type conversions for write(ln) }
                       if (not file_is_typed) then
                         begin
                            hp:=p^.left;
                            while assigned(hp) do
                              begin
                                if (hp^.left^.treetype=typen) then
                                  CGMessage(type_e_cant_read_write_type);
                                if assigned(hp^.left^.resulttype) then
                                  begin
                                    isreal:=false;
                                    { support writeln(procvar) }
                                    if (hp^.left^.resulttype^.deftype=procvardef) then
                                     begin
                                       p1:=gencallnode(nil,nil);
                                       p1^.right:=hp^.left;
                                       p1^.resulttype:=pprocvardef(hp^.left^.resulttype)^.retdef;
                                       firstpass(p1);
                                       hp^.left:=p1;
                                     end;
                                    case hp^.left^.resulttype^.deftype of
                                      filedef :
                                        begin
                                          { only allowed as first parameter }
                                          if assigned(hp^.right) then
                                            CGMessage(type_e_cant_read_write_type);
                                        end;
                                      stringdef :
                                        begin
                                          { generate the high() value for the shortstring }
                                          if (not dowrite) and
                                             is_shortstring(hp^.left^.resulttype) then
                                            gen_high_tree(hp,true);
                                        end;
                                      pointerdef :
                                        begin
                                          if not is_pchar(hp^.left^.resulttype) then
                                            CGMessage(type_e_cant_read_write_type);
                                        end;
                                      floatdef :
                                        begin
                                          isreal:=true;
                                        end;
                                      orddef :
                                        begin
                                          case porddef(hp^.left^.resulttype)^.typ of
                                            uchar,
                                            u32bit,s32bit,
                                            u64bit,s64bit:
                                              ;
                                            u8bit,s8bit,
                                            u16bit,s16bit :
                                              if dowrite then
                                                hp^.left:=gentypeconvnode(hp^.left,s32bitdef);
                                            bool8bit,
                                            bool16bit,
                                            bool32bit :
                                              if dowrite then
                                                hp^.left:=gentypeconvnode(hp^.left,booldef)
                                              else
                                                CGMessage(type_e_cant_read_write_type);
                                            else
                                              CGMessage(type_e_cant_read_write_type);
                                          end;
                                        end;
                                      arraydef :
                                        begin
                                          if is_chararray(hp^.left^.resulttype) then
                                            gen_high_tree(hp,true)
                                          else
                                            CGMessage(type_e_cant_read_write_type);
                                        end;
                                      else
                                        CGMessage(type_e_cant_read_write_type);
                                    end;

                                    { some format options ? }
                                    if hp^.is_colon_para then
                                      begin
                                         if hp^.right^.is_colon_para then
                                           begin
                                              frac_para:=hp;
                                              length_para:=hp^.right;
                                              hp:=hp^.right;
                                              hpp:=hp^.right;
                                           end
                                         else
                                           begin
                                              length_para:=hp;
                                              frac_para:=nil;
                                              hpp:=hp^.right;
                                           end;
                                         isreal:=(hpp^.left^.resulttype^.deftype=floatdef);
                                         if (not is_integer(length_para^.left^.resulttype)) then
                                          CGMessage1(type_e_integer_expr_expected,length_para^.left^.resulttype^.typename)
                                        else
                                          length_para^.left:=gentypeconvnode(length_para^.left,s32bitdef);
                                        if assigned(frac_para) then
                                          begin
                                            if isreal then
                                             begin
                                               if (not is_integer(frac_para^.left^.resulttype)) then
                                                 CGMessage1(type_e_integer_expr_expected,frac_para^.left^.resulttype^.typename)
                                               else
                                                 frac_para^.left:=gentypeconvnode(frac_para^.left,s32bitdef);
                                             end
                                            else
                                             CGMessage(parser_e_illegal_colon_qualifier);
                                          end;
                                        { do the checking for the colon'd arg }
                                        hp:=length_para;
                                      end;
                                  end;
                                 hp:=hp^.right;
                              end;
                         end;
                       { pass all parameters again for the typeconversions }
                       if codegenerror then
                         exit;
                       must_be_valid:=true;
                       firstcallparan(p^.left,nil);
                       { calc registers }
                       left_right_max(p);
                    end;
               end;

            in_settextbuf_file_x :
              begin
                 { warning here p^.left is the callparannode
                   not the argument directly }
                 { p^.left^.left is text var }
                 { p^.left^.right^.left is the buffer var }
                 { firstcallparan(p^.left,nil);
                   already done in firstcalln }
                 { now we know the type of buffer }
                 getsymonlyin(systemunit,'SETTEXTBUF');
                 hp:=gencallnode(pprocsym(srsym),systemunit);
                 hp^.left:=gencallparanode(
                   genordinalconstnode(p^.left^.left^.resulttype^.size,s32bitdef),p^.left);
                 putnode(p);
                 p:=hp;
                 firstpass(p);
              end;

             { the firstpass of the arg has been done in firstcalln ? }
             in_reset_typedfile,
             in_rewrite_typedfile :
               begin
                  procinfo.flags:=procinfo.flags or pi_do_call;
                  { to be sure the right definition is loaded }
                  p^.left^.resulttype:=nil;
                  firstpass(p^.left);
                  p^.resulttype:=voiddef;
               end;

             in_str_x_string :
               begin
                  procinfo.flags:=procinfo.flags or pi_do_call;
                  p^.resulttype:=voiddef;
                  { check the amount of parameters }
                  if not(assigned(p^.left)) or
                     not(assigned(p^.left^.right)) then
                   begin
                     CGMessage(parser_e_wrong_parameter_size);
                     exit;
                   end;
                  { first pass just the string for first local use }
                  hp:=p^.left^.right;
                  must_be_valid:=false;
                  count_ref:=true;
                  p^.left^.right:=nil;
                  firstcallparan(p^.left,nil);
                  { remove warning when result is passed }
                  if (p^.left^.left^.treetype=funcretn) then
                   procinfo.funcret_is_valid:=true;
                  must_be_valid:=true;
                  p^.left^.right:=hp;
                  firstcallparan(p^.left^.right,nil);
                  hp:=p^.left;
                  { valid string ? }
                  if not assigned(hp) or
                     (hp^.left^.resulttype^.deftype<>stringdef) or
                     (hp^.right=nil) or
                     (hp^.left^.location.loc<>LOC_REFERENCE) then
                    CGMessage(cg_e_illegal_expression);
                  { generate the high() value for the shortstring }
                  if is_shortstring(hp^.left^.resulttype) then
                    gen_high_tree(hp,true);

                  { !!!! check length of string }

                  while assigned(hp^.right) do
                    hp:=hp^.right;
                  { check and convert the first param }
                  if hp^.is_colon_para then
                    CGMessage(cg_e_illegal_expression);

                  isreal:=false;
                  case hp^.resulttype^.deftype of
                    orddef :
                      begin
                        case porddef(hp^.left^.resulttype)^.typ of
                          u32bit,s32bit,
                          s64bit,u64bit:
                            ;
                          u8bit,s8bit,
                          u16bit,s16bit:
                            hp^.left:=gentypeconvnode(hp^.left,s32bitdef);
                          else
                            CGMessage(type_e_integer_or_real_expr_expected);
                        end;
                      end;
                    floatdef :
                      begin
                        isreal:=true;
                      end;
                    else
                      CGMessage(type_e_integer_or_real_expr_expected);
                  end;

                  { some format options ? }
                  hpp:=p^.left^.right;
                  if assigned(hpp) and hpp^.is_colon_para then
                    begin
                      if (not is_integer(hpp^.resulttype)) then
                        CGMessage1(type_e_integer_expr_expected,hpp^.resulttype^.typename)
                      else
                        hpp^.left:=gentypeconvnode(hpp^.left,s32bitdef);
                      hpp:=hpp^.right;
                      if assigned(hpp) and hpp^.is_colon_para then
                        begin
                          if isreal then
                           begin
                             if (not is_integer(hpp^.resulttype)) then
                               CGMessage1(type_e_integer_expr_expected,hpp^.resulttype^.typename)
                             else
                               hpp^.left:=gentypeconvnode(hpp^.left,s32bitdef);
                           end
                          else
                           CGMessage(parser_e_illegal_colon_qualifier);
                        end;
                    end;

                  { for first local use }
                  must_be_valid:=false;
                  count_ref:=true;
                  { pass all parameters again for the typeconversions }
                  if codegenerror then
                    exit;
                  must_be_valid:=true;
                  firstcallparan(p^.left,nil);
                  { calc registers }
                  left_right_max(p);
               end;

             in_val_x :
               begin
                  procinfo.flags:=procinfo.flags or pi_do_call;
                  p^.resulttype:=voiddef;
                  { check the amount of parameters }
                  if not(assigned(p^.left)) or
                     not(assigned(p^.left^.right)) then
                   begin
                     CGMessage(parser_e_wrong_parameter_size);
                     exit;
                   end;
                  If Assigned(p^.left^.right^.right) Then
                   {there is a "code" parameter}
                     Begin
                  { first pass just the code parameter for first local use}
                       hp := p^.left^.right;
                       p^.left^.right := nil;
                       must_be_valid := false;
                       count_ref := true;
                       make_not_regable(p^.left^.left);
                       firstcallparan(p^.left, nil);
                       if codegenerror then exit;
                       p^.left^.right := hp;
                     {code has to be a var parameter}
                       if (p^.left^.left^.location.loc<>LOC_REFERENCE) then
                         CGMessage(type_e_variable_id_expected)
                       else
                         if (p^.left^.left^.resulttype^.deftype <> orddef) or
                            not(porddef(p^.left^.left^.resulttype)^.typ in
                                [u16bit,s16bit,u32bit,s32bit]) then
                           CGMessage(type_e_mismatch);
                       hpp := p^.left^.right
                     End
                  Else hpp := p^.left;
                  {now hpp = the destination value tree}
                  { first pass just the destination parameter for first local use}
                  hp:=hpp^.right;
                  must_be_valid:=false;
                  count_ref:=true;
                  hpp^.right:=nil;
                  {hpp = destination}
                  make_not_regable(hpp^.left);
                  firstcallparan(hpp,nil);
                  if codegenerror then
                    exit;
                  { remove warning when result is passed }
                  if (hpp^.left^.treetype=funcretn) then
                   procinfo.funcret_is_valid:=true;
                  hpp^.right := hp;
                  if (hpp^.left^.location.loc<>LOC_REFERENCE) then
                    CGMessage(type_e_variable_id_expected)
                  else
                    If Not((hpp^.left^.resulttype^.deftype = floatdef) or
                           ((hpp^.left^.resulttype^.deftype = orddef) And
                            (POrdDef(hpp^.left^.resulttype)^.typ in
                              [u32bit,s32bit,
                               u8bit,s8bit,u16bit,s16bit,s64bit,u64bit])))
                        Then CGMessage(type_e_mismatch);
                  must_be_valid:=true;
                 {hp = source (String)}
                  count_ref := false;
                  must_be_valid := true;
                  firstcallparan(hp,nil);
                  if codegenerror then
                    exit;
                  { if not a stringdef then insert a type conv which
                    does the other type checking }
                  If (hp^.left^.resulttype^.deftype<>stringdef) then
                   begin
                     hp^.left:=gentypeconvnode(hp^.left,cshortstringdef);
                     firstpass(hp);
                   end;
                  { calc registers }
                  left_right_max(p);

                  { val doesn't calculate the registers really }
                  { correct, we need one register extra   (FK) }
                  if is_64bitint(hpp^.left^.resulttype) then
                    inc(p^.registers32,2)
                  else
                    inc(p^.registers32,1);
               end;

             in_include_x_y,
             in_exclude_x_y:
               begin
                 p^.resulttype:=voiddef;
                 if assigned(p^.left) then
                   begin
                      firstcallparan(p^.left,nil);
                      p^.registers32:=p^.left^.registers32;
                      p^.registersfpu:=p^.left^.registersfpu;
{$ifdef SUPPORT_MMX}
                      p^.registersmmx:=p^.left^.registersmmx;
{$endif SUPPORT_MMX}
                      { remove warning when result is passed }
                      if (p^.left^.left^.treetype=funcretn) then
                       procinfo.funcret_is_valid:=true;
                      { first param must be var }
                      if (p^.left^.left^.location.loc<>LOC_REFERENCE) and
                         (p^.left^.left^.location.loc<>LOC_CREGISTER) then
                        CGMessage(cg_e_illegal_expression);
                      { check type }
                      if (p^.left^.resulttype^.deftype=setdef) then
                        begin
                           { two paras ? }
                           if assigned(p^.left^.right) then
                             begin
                                { insert a type conversion       }
                                { to the type of the set elements  }
                                p^.left^.right^.left:=gentypeconvnode(
                                  p^.left^.right^.left,
                                  psetdef(p^.left^.resulttype)^.setof);
                                { check the type conversion }
                                firstpass(p^.left^.right^.left);
                                { only three parameters are allowed }
                                if assigned(p^.left^.right^.right) then
                                  CGMessage(cg_e_illegal_expression);
                             end;
                        end
                      else
                        CGMessage(type_e_mismatch);
                   end
                 else
                   CGMessage(type_e_mismatch);
               end;

             in_low_x,
             in_high_x:
               begin
                  if p^.left^.treetype in [typen,loadn,subscriptn] then
                    begin
                       case p^.left^.resulttype^.deftype of
                          orddef,enumdef:
                            begin
                               do_lowhigh(p^.left^.resulttype);
                               firstpass(p);
                            end;
                          setdef:
                            begin
                               do_lowhigh(Psetdef(p^.left^.resulttype)^.setof);
                               firstpass(p);
                            end;
                         arraydef:
                            begin
                              if p^.inlinenumber=in_low_x then
                               begin
                                 hp:=genordinalconstnode(Parraydef(p^.left^.resulttype)^.lowrange,
                                   Parraydef(p^.left^.resulttype)^.rangedef);
                                 disposetree(p);
                                 p:=hp;
                                 firstpass(p);
                               end
                              else
                               begin
                                 if is_open_array(p^.left^.resulttype) or
                                   is_array_of_const(p^.left^.resulttype) then
                                  begin
                                    getsymonlyin(p^.left^.symtable,'high'+pvarsym(p^.left^.symtableentry)^.name);
                                    hp:=genloadnode(pvarsym(srsym),p^.left^.symtable);
                                    disposetree(p);
                                    p:=hp;
                                    firstpass(p);
                                  end
                                 else
                                  begin
                                    hp:=genordinalconstnode(Parraydef(p^.left^.resulttype)^.highrange,
                                      Parraydef(p^.left^.resulttype)^.rangedef);
                                    disposetree(p);
                                    p:=hp;
                                    firstpass(p);
                                  end;
                               end;
                           end;
                         stringdef:
                           begin
                              if p^.inlinenumber=in_low_x then
                               begin
                                 hp:=genordinalconstnode(0,u8bitdef);
                                 disposetree(p);
                                 p:=hp;
                                 firstpass(p);
                               end
                              else
                               begin
                                 if is_open_string(p^.left^.resulttype) then
                                  begin
                                    getsymonlyin(p^.left^.symtable,'high'+pvarsym(p^.left^.symtableentry)^.name);
                                    hp:=genloadnode(pvarsym(srsym),p^.left^.symtable);
                                    disposetree(p);
                                    p:=hp;
                                    firstpass(p);
                                  end
                                 else
                                  begin
                                    hp:=genordinalconstnode(Pstringdef(p^.left^.resulttype)^.len,u8bitdef);
                                    disposetree(p);
                                    p:=hp;
                                    firstpass(p);
                                  end;
                               end;
                           end;
                         else
                           CGMessage(type_e_mismatch);
                         end;
                    end
                  else
                    CGMessage(type_e_varid_or_typeid_expected);
               end;

             in_cos_extended:
               begin
                  if p^.left^.treetype in [ordconstn,realconstn] then
                    setconstrealvalue(cos(getconstrealvalue))
                  else
                    handleextendedfunction;
               end;

             in_sin_extended:
               begin
                  if p^.left^.treetype in [ordconstn,realconstn] then
                    setconstrealvalue(sin(getconstrealvalue))
                  else
                    handleextendedfunction;
               end;

             in_arctan_extended:
               begin
                  if p^.left^.treetype in [ordconstn,realconstn] then
                    setconstrealvalue(arctan(getconstrealvalue))
                  else
                    handleextendedfunction;
               end;

             in_pi:
               if block_type=bt_const then
                 setconstrealvalue(pi)
               else
                 begin
                    p^.location.loc:=LOC_FPU;
                    p^.resulttype:=s80floatdef;
                 end;

             in_abs_extended:
               begin
                  if p^.left^.treetype in [ordconstn,realconstn] then
                    setconstrealvalue(abs(getconstrealvalue))
                  else
                    handleextendedfunction;
               end;

             in_sqr_extended:
               begin
                  if p^.left^.treetype in [ordconstn,realconstn] then
                    setconstrealvalue(sqr(getconstrealvalue))
                  else
                    handleextendedfunction;
               end;

             in_sqrt_extended:
               begin
                  if p^.left^.treetype in [ordconstn,realconstn] then
                    begin
                       vr:=getconstrealvalue;
                       if vr<0.0 then
                         begin
                            CGMessage(type_e_wrong_math_argument);
                            setconstrealvalue(0);
                         end
                       else
                         setconstrealvalue(sqrt(vr));
                    end
                  else
                    handleextendedfunction;
               end;

             in_ln_extended:
               begin
                  if p^.left^.treetype in [ordconstn,realconstn] then
                    begin
                       vr:=getconstrealvalue;
                       if vr<=0.0 then
                         begin
                            CGMessage(type_e_wrong_math_argument);
                            setconstrealvalue(0);
                         end
                       else
                         setconstrealvalue(ln(vr));
                    end
                  else
                    handleextendedfunction;
               end;

{$ifdef SUPPORT_MMX}
            in_mmx_pcmpeqb..in_mmx_pcmpgtw:
              begin
              end;
{$endif SUPPORT_MMX}
            in_assert_x_y :
               begin
                 p^.resulttype:=voiddef;
                 if assigned(p^.left) then
                   begin
                      firstcallparan(p^.left,nil);
                      p^.registers32:=p^.left^.registers32;
                      p^.registersfpu:=p^.left^.registersfpu;
{$ifdef SUPPORT_MMX}
                      p^.registersmmx:=p^.left^.registersmmx;
{$endif SUPPORT_MMX}
                      { check type }
                      if is_boolean(p^.left^.resulttype) then
                        begin
                           { must always be a string }
                           p^.left^.right^.left:=gentypeconvnode(p^.left^.right^.left,cshortstringdef);
                           firstpass(p^.left^.right^.left);
                        end
                      else
                        CGMessage(type_e_mismatch);
                   end
                 else
                   CGMessage(type_e_mismatch);
               end;

              else
               internalerror(8);
             end;
            end;
           { generate an error if no resulttype is set }
           if not assigned(p^.resulttype) then
             p^.resulttype:=generrordef;
           must_be_valid:=store_valid;
           count_ref:=store_count_ref;
       end;


end.
{
  $Log$
  Revision 1.51  1999-09-15 20:35:46  florian
    * small fix to operator overloading when in MMX mode
    + the compiler uses now fldz and fld1 if possible
    + some fixes to floating point registers
    + some math. functions (arctan, ln, sin, cos, sqrt, sqr, pi) are now inlined
    * .... ???

  Revision 1.50  1999/09/07 14:05:11  pierre
   * halt removed in do_lowhigh

  Revision 1.49  1999/08/28 15:34:21  florian
    * bug 519 fixed

  Revision 1.48  1999/08/23 23:41:04  pierre
   * in_inc_x register allocation corrected

  Revision 1.47  1999/08/06 12:43:13  jonas
    * fix for regvars with the val code

  Revision 1.46  1999/08/05 16:53:23  peter
    * V_Fatal=1, all other V_ are also increased
    * Check for local procedure when assigning procvar
    * fixed comment parsing because directives
    * oldtp mode directives better supported
    * added some messages to errore.msg

  Revision 1.45  1999/08/04 00:23:40  florian
    * renamed i386asm and i386base to cpuasm and cpubase

  Revision 1.44  1999/08/03 22:03:32  peter
    * moved bitmask constants to sets
    * some other type/const renamings

  Revision 1.43  1999/07/30 12:28:43  peter
    * fixed crash with unknown id and colon parameter in write

  Revision 1.42  1999/07/18 14:47:35  florian
    * bug 487 fixed, (inc(<property>) isn't allowed)
    * more fixes to compile with Delphi

  Revision 1.41  1999/07/05 20:25:40  peter
    * merged

  Revision 1.40  1999/07/05 20:13:18  peter
    * removed temp defines

  Revision 1.39  1999/07/03 14:14:31  florian
    + start of val(int64/qword)
    * longbool, wordbool constants weren't written, fixed

  Revision 1.38  1999/07/01 15:49:22  florian
    * int64/qword type release
    + lo/hi for int64/qword

  Revision 1.37  1999/06/25 10:02:56  florian
    * bug 459 fixed

  Revision 1.36  1999/06/15 18:58:36  peter
    * merged

  Revision 1.35.2.2  1999/07/05 20:06:46  peter
    * give error instead of warning for ln(0) and sqrt(0)

  Revision 1.35.2.1  1999/06/15 18:54:54  peter
    * more procvar fixes

  Revision 1.35  1999/05/27 19:45:19  peter
    * removed oldasm
    * plabel -> pasmlabel
    * -a switches to source writing automaticly
    * assembler readers OOPed
    * asmsymbol automaticly external
    * jumptables and other label fixes for asm readers

  Revision 1.34  1999/05/23 18:42:20  florian
    * better error recovering in typed constants
    * some problems with arrays of const fixed, some problems
      due my previous
       - the location type of array constructor is now LOC_MEM
       - the pushing of high fixed
       - parameter copying fixed
       - zero temp. allocation removed
    * small problem in the assembler writers fixed:
      ref to nil wasn't written correctly

  Revision 1.33  1999/05/06 09:05:35  peter
    * generic write_float and str_float
    * fixed constant float conversions

  Revision 1.32  1999/05/05 22:25:21  florian
    * fixed register allocation for val

  Revision 1.31  1999/05/02 21:33:57  florian
    * several bugs regarding -Or fixed

  Revision 1.30  1999/05/01 13:24:53  peter
    * merged nasm compiler
    * old asm moved to oldasm/

  Revision 1.29  1999/04/28 06:02:15  florian
    * changes of Bruessel:
       + message handler can now take an explicit self
       * typinfo fixed: sometimes the type names weren't written
       * the type checking for pointer comparisations and subtraction
         and are now more strict (was also buggy)
       * small bug fix to link.pas to support compiling on another
         drive
       * probable bug in popt386 fixed: call/jmp => push/jmp
         transformation didn't count correctly the jmp references
       + threadvar support
       * warning if ln/sqrt gets an invalid constant argument

  Revision 1.28  1999/04/26 18:28:12  peter
    * better read/write array

  Revision 1.27  1999/04/26 09:32:22  peter
    * try to convert to string for val()

  Revision 1.26  1999/04/15 14:10:51  pierre
   * fix for bug0238.pp

  Revision 1.25  1999/04/15 10:00:35  peter
    * writeln(procvar) support for tp7 mode

  Revision 1.24  1999/04/14 09:15:07  peter
    * first things to store the symbol/def number in the ppu

  Revision 1.23  1999/04/08 10:16:48  peter
    * funcret_valid flag is set for inline functions

  Revision 1.22  1999/03/26 00:05:48  peter
    * released valintern
    + deffile is now removed when compiling is finished
    * ^( compiles now correct
    + static directive
    * shrd fixed

  Revision 1.21  1999/03/24 23:17:37  peter
    * fixed bugs 212,222,225,227,229,231,233

  Revision 1.20  1999/03/16 17:52:55  jonas
    * changes for internal Val code (do a "make cycle OPT=-dvalintern" to test)
    * in cgi386inl: also range checking for subrange types (compile with "-dreadrangecheck")
    * in cgai386: also small fixes to emitrangecheck

  Revision 1.19  1999/02/22 12:36:34  florian
    + warning for lo/hi(longint/dword) in -So and -Sd mode added

  Revision 1.18  1999/02/22 02:15:49  peter
    * updates for ag386bin

  Revision 1.17  1999/02/01 00:00:50  florian
    * compiler crash fixed when constant arguments passed to round/trunc
      exceeds the longint range

  Revision 1.16  1999/01/28 19:43:43  peter
    * fixed high generation for ansistrings with str,writeln

  Revision 1.15  1999/01/27 16:28:22  pierre
   * bug0157 solved : write(x:5.3) is rejected now

  Revision 1.14  1999/01/21 22:10:50  peter
    * fixed array of const
    * generic platform independent high() support

  Revision 1.13  1998/12/30 22:13:13  peter
    * check the amount of paras for Str()

  Revision 1.12  1998/12/15 10:23:31  peter
    + -iSO, -iSP, -iTO, -iTP

  Revision 1.11  1998/12/11 23:36:08  florian
    + again more stuff for int64/qword:
         - comparision operators
         - code generation for: str, read(ln), write(ln)

  Revision 1.10  1998/11/27 14:50:53  peter
    + open strings, $P switch support

  Revision 1.9  1998/11/24 17:04:28  peter
    * fixed length(char) when char is a variable

  Revision 1.8  1998/11/14 10:51:33  peter
    * fixed low/high for record.field

  Revision 1.7  1998/11/13 10:15:52  peter
    * fixed ptr() with constants

  Revision 1.6  1998/11/05 12:03:05  peter
    * released useansistring
    * removed -Sv, its now available in fpc modes

  Revision 1.5  1998/10/20 11:16:47  pierre
   + length(c) where C is a char is allways 1

  Revision 1.4  1998/10/06 20:49:11  peter
    * m68k compiler compiles again

  Revision 1.3  1998/10/05 12:32:49  peter
    + assert() support

  Revision 1.2  1998/10/02 09:24:23  peter
    * more constant expression evaluators

  Revision 1.1  1998/09/23 20:42:24  peter
    * splitted pass_1

}
