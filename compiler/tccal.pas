{
    $Id$
    Copyright (c) 1993-98 by Florian Klaempfl

    Type checking and register allocation for call nodes

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
unit tccal;
interface

    uses
      symtable,tree;


    procedure gen_high_tree(p:ptree;openstring:boolean);

    procedure firstcallparan(var p : ptree;defcoll : pdefcoll);
    procedure firstcalln(var p : ptree);
    procedure firstprocinline(var p : ptree);


implementation

    uses
      globtype,systems,
      cobjects,verbose,globals,
      aasm,types,
      hcodegen,htypechk,pass_1
{$ifdef i386}
{$ifdef ag386bin}
      ,i386base
{$else}
      ,i386
{$endif}
      ,tgeni386
{$endif}
{$ifdef m68k}
      ,m68k,tgen68k
{$endif}
      ;

{*****************************************************************************
                             FirstCallParaN
*****************************************************************************}

    procedure gen_high_tree(p:ptree;openstring:boolean);
      var
        len : longint;
        st  : psymtable;
      begin
        if assigned(p^.hightree) then
         exit;
        len:=-1;
        case p^.left^.resulttype^.deftype of
          arraydef :
            begin
              if is_open_array(p^.left^.resulttype) then
               begin
                 st:=p^.left^.symtable;
                 getsymonlyin(st,'high'+pvarsym(p^.left^.symtableentry)^.name);
                 p^.hightree:=genloadnode(pvarsym(srsym),st);
               end
              else
               len:=parraydef(p^.left^.resulttype)^.highrange-
                    parraydef(p^.left^.resulttype)^.lowrange;
            end;
          stringdef :
            begin
              if openstring then
               begin
                 if is_open_string(p^.left^.resulttype) then
                  begin
                    st:=p^.left^.symtable;
                    getsymonlyin(st,'high'+pvarsym(p^.left^.symtableentry)^.name);
                    p^.hightree:=genloadnode(pvarsym(srsym),st);
                  end
                 else
                  len:=pstringdef(p^.left^.resulttype)^.len;
               end
              else
             { passing a string to an array of char }
               begin
                 if (p^.left^.treetype=stringconstn) then
                   begin
                     len:=str_length(p^.left);
                     if len>0 then
                      dec(len);
                   end
                 else
                   begin
                     p^.hightree:=gennode(subn,geninlinenode(in_length_string,false,getcopy(p^.left)),
                                               genordinalconstnode(1,s32bitdef));
                     firstpass(p^.hightree);
                     p^.hightree:=gentypeconvnode(p^.hightree,s32bitdef);
                   end;
               end;
           end;
        else
          len:=0;
        end;
        if len>=0 then
          p^.hightree:=genordinalconstnode(len,s32bitdef);
        firstpass(p^.hightree);
      end;


    procedure firstcallparan(var p : ptree;defcoll : pdefcoll);
      var
        old_get_para_resulttype : boolean;
        old_array_constructor : boolean;
        store_valid : boolean;
        oldtype     : pdef;
        {convtyp     : tconverttype;}
      begin
         inc(parsing_para_level);
         if assigned(p^.right) then
           begin
              if defcoll=nil then
                firstcallparan(p^.right,nil)
              else
                firstcallparan(p^.right,defcoll^.next);
              p^.registers32:=p^.right^.registers32;
              p^.registersfpu:=p^.right^.registersfpu;
{$ifdef SUPPORT_MMX}
              p^.registersmmx:=p^.right^.registersmmx;
{$endif}
           end;
         if defcoll=nil then
           begin
              old_array_constructor:=allow_array_constructor;
              old_get_para_resulttype:=get_para_resulttype;
              get_para_resulttype:=true;
              allow_array_constructor:=true;
              if not(assigned(p^.resulttype)) or
                 (p^.left^.treetype=typeconvn) then
                firstpass(p^.left);
              get_para_resulttype:=old_get_para_resulttype;
              allow_array_constructor:=old_array_constructor;
              if codegenerror then
                begin
                   dec(parsing_para_level);
                   exit;
                end;
              p^.resulttype:=p^.left^.resulttype;
           end
         { if we know the routine which is called, then the type }
         { conversions are inserted                              }
         else
           begin
              if count_ref then
               begin
                 { not completly proper, but avoids some warnings }
                 if (p^.left^.treetype=funcretn) and (defcoll^.paratyp=vs_var) then
                   procinfo.funcret_is_valid:=true;

                 store_valid:=must_be_valid;
                 { protected has nothing to do with read/write
                 if (defcoll^.paratyp=vs_var) then
                   test_protected(p^.left);
                 }
                 must_be_valid:=(defcoll^.paratyp<>vs_var);
                 { only process typeconvn and arrayconstructn, else it will
                   break other trees }
                 old_array_constructor:=allow_array_constructor;
                 old_get_para_resulttype:=get_para_resulttype;
                 allow_array_constructor:=true;
                 get_para_resulttype:=false;
                 if (p^.left^.treetype in [arrayconstructn,typeconvn]) then
                   firstpass(p^.left);
                 get_para_resulttype:=old_get_para_resulttype;
                 allow_array_constructor:=old_array_constructor;
                 must_be_valid:=store_valid;
               end;
              { generate the high() value tree }
              if push_high_param(defcoll^.data) then
                gen_high_tree(p,is_open_string(defcoll^.data));
              if not(is_shortstring(p^.left^.resulttype) and
                     is_shortstring(defcoll^.data)) and
                     (defcoll^.data^.deftype<>formaldef) then
                begin
                   if (defcoll^.paratyp=vs_var) and
                   { allows conversion from word to integer and
                     byte to shortint }
                     (not(
                        (p^.left^.resulttype^.deftype=orddef) and
                        (defcoll^.data^.deftype=orddef) and
                        (p^.left^.resulttype^.size=defcoll^.data^.size)
                         ) and
                   { an implicit pointer conversion is allowed }
                     not(
                        (p^.left^.resulttype^.deftype=pointerdef) and
                        (defcoll^.data^.deftype=pointerdef)
                         ) and
                   { child classes can be also passed }
                     not(
                        (p^.left^.resulttype^.deftype=objectdef) and
                        (defcoll^.data^.deftype=objectdef) and
                        pobjectdef(p^.left^.resulttype)^.isrelated(pobjectdef(defcoll^.data))
                        ) and
                   { passing a single element to a openarray of the same type }
                     not(
                        (is_open_array(defcoll^.data) and
                        is_equal(parraydef(defcoll^.data)^.definition,p^.left^.resulttype))
                        ) and
                   { an implicit file conversion is also allowed }
                   { from a typed file to an untyped one           }
                     not(
                        (p^.left^.resulttype^.deftype=filedef) and
                        (defcoll^.data^.deftype=filedef) and
                        (pfiledef(defcoll^.data)^.filetype = ft_untyped) and
                        (pfiledef(p^.left^.resulttype)^.filetype = ft_typed)
                         ) and
                     not(is_equal(p^.left^.resulttype,defcoll^.data))) then
                       CGMessage(parser_e_call_by_ref_without_typeconv);
                   { process cargs arrayconstructor }
                   if is_array_constructor(p^.left^.resulttype) and
                      assigned(aktcallprocsym) and
                      (aktcallprocsym^.definition^.options and pocdecl<>0) and
                      (aktcallprocsym^.definition^.options and poexternal<>0) then
                    begin
                      p^.left^.cargs:=true;
                      old_array_constructor:=allow_array_constructor;
                      allow_array_constructor:=true;
                      firstpass(p^.left);
                      allow_array_constructor:=old_array_constructor;
                    end;
                   { process open parameters }
                   if push_high_param(defcoll^.data) then
                    begin
                      { insert type conv but hold the ranges of the array }
                      oldtype:=p^.left^.resulttype;
                      p^.left:=gentypeconvnode(p^.left,defcoll^.data);
                      firstpass(p^.left);
                      p^.left^.resulttype:=oldtype;
                    end
                   else
                    begin
                      p^.left:=gentypeconvnode(p^.left,defcoll^.data);
                      firstpass(p^.left);
                      { this is necessary if an arrayconstruct -> set is done
                        first, then the set generation tree needs to be passed
                        to get the end resulttype (PFV) }
                      if not assigned(p^.left^.resulttype) then
                       firstpass(p^.left);
                    end;
                   if codegenerror then
                     begin
                        dec(parsing_para_level);
                        exit;
                     end;
                end;
              { check var strings }
              if (cs_strict_var_strings in aktlocalswitches) and
                 is_shortstring(p^.left^.resulttype) and
                 is_shortstring(defcoll^.data) and
                 (defcoll^.paratyp=vs_var) and
                 not(is_open_string(defcoll^.data)) and
                 not(is_equal(p^.left^.resulttype,defcoll^.data)) then
                 CGMessage(type_e_strict_var_string_violation);

              { Variablen for call by reference may not be copied }
              { into a register }
              { is this usefull here ? }
              { this was missing in formal parameter list   }
              if defcoll^.paratyp=vs_var then
                begin
                   set_unique(p^.left);
                   make_not_regable(p^.left);
                end;

              p^.resulttype:=defcoll^.data;
           end;
         if p^.left^.registers32>p^.registers32 then
           p^.registers32:=p^.left^.registers32;
         if p^.left^.registersfpu>p^.registersfpu then
           p^.registersfpu:=p^.left^.registersfpu;
{$ifdef SUPPORT_MMX}
         if p^.left^.registersmmx>p^.registersmmx then
           p^.registersmmx:=p^.left^.registersmmx;
{$endif SUPPORT_MMX}
         dec(parsing_para_level);
      end;


{*****************************************************************************
                             FirstCallN
*****************************************************************************}

    procedure firstcalln(var p : ptree);
      type
         pprocdefcoll = ^tprocdefcoll;
         tprocdefcoll = record
            data      : pprocdef;
            nextpara  : pdefcoll;
            firstpara : pdefcoll;
            next      : pprocdefcoll;
         end;
      var
         hp,procs,hp2 : pprocdefcoll;
         pd : pprocdef;
         oldcallprocsym : pprocsym;
         nextprocsym : pprocsym;
         def_from,def_to,conv_to : pdef;
         pt,inlinecode : ptree;
         exactmatch,inlined : boolean;
         paralength,l,lastpara : longint;
         lastparatype : pdef;
         pdc : pdefcoll;
{$ifdef TEST_PROCSYMS}
         symt : psymtable;
{$endif TEST_PROCSYMS}

         { only Dummy }
         hcvt : tconverttype;
         regi : tregister;
         store_valid, old_count_ref : boolean;
      label
        errorexit;

      { check if the resulttype from tree p is equal with def, needed
        for stringconstn and formaldef }
      function is_equal(p:ptree;def:pdef) : boolean;

        begin
           { safety check }
           if not (assigned(def) or assigned(p^.resulttype)) then
            begin
              is_equal:=false;
              exit;
            end;
           { all types can be passed to a formaldef }
           is_equal:=(def^.deftype=formaldef) or
             (types.is_equal(p^.resulttype,def))
           { to support ansi/long/wide strings in a proper way }
           { string and string[10] are assumed as equal        }
           { when searching the correct overloaded procedure   }
             or
             (
              (def^.deftype=stringdef) and (p^.resulttype^.deftype=stringdef) and
              (pstringdef(def)^.string_typ=pstringdef(p^.resulttype)^.string_typ)
             )
             or
             (
              (p^.left^.treetype=stringconstn) and
              (is_ansistring(p^.resulttype) and is_pchar(def))
             )
             or
             (
              (p^.left^.treetype=ordconstn) and
              (is_char(p^.resulttype) and (is_shortstring(def) or is_ansistring(def)))
             )
           { set can also be a not yet converted array constructor }
             or
             (
              (def^.deftype=setdef) and (p^.resulttype^.deftype=arraydef) and
              (parraydef(p^.resulttype)^.IsConstructor) and not(parraydef(p^.resulttype)^.IsVariant)
             )
           { in tp7 mode proc -> procvar is allowed }
             or
             (
              (m_tp_procvar in aktmodeswitches) and
              (def^.deftype=procvardef) and (p^.left^.treetype=calln) and
              (proc_to_procvar_equal(p^.left^.procdefinition,pprocvardef(def)))
             )
             ;
        end;

      function is_in_limit(def_from,def_to : pdef) : boolean;

        begin
           is_in_limit:=(def_from^.deftype = orddef) and
                        (def_to^.deftype = orddef) and
                        (porddef(def_from)^.low>porddef(def_to)^.low) and
                        (porddef(def_from)^.high<porddef(def_to)^.high);
        end;

      var
        is_const : boolean;
      begin
         { release registers! }
         { if procdefinition<>nil then we called firstpass already }
         { it seems to be bad because of the registers }
         { at least we can avoid the overloaded search !! }
         procs:=nil;
         { made this global for disposing !! }
         store_valid:=must_be_valid;
         must_be_valid:=false;

         oldcallprocsym:=aktcallprocsym;
         aktcallprocsym:=nil;

         inlined:=false;
         if assigned(p^.procdefinition) and
            ((p^.procdefinition^.options and poinline)<>0) then
           begin
              inlinecode:=p^.right;
              if assigned(inlinecode) then
                begin
                   inlined:=true;
                   p^.procdefinition^.options:=p^.procdefinition^.options and (not poinline);
                end;
              p^.right:=nil;
           end;
         { procedure variable ? }
         if assigned(p^.right) then
           begin
              { procedure does a call }
              procinfo.flags:=procinfo.flags or pi_do_call;

              { calc the correture value for the register }
{$ifdef i386}
              for regi:=R_EAX to R_EDI do
                inc(reg_pushes[regi],t_times*2);
{$endif}
{$ifdef m68k}
              for regi:=R_D0 to R_A6 do
                inc(reg_pushes[regi],t_times*2);
{$endif}
              { calculate the type of the parameters }
              if assigned(p^.left) then
                begin
                   old_count_ref:=count_ref;
                   count_ref:=false;
                   firstcallparan(p^.left,nil);
                   count_ref:=old_count_ref;
                   if codegenerror then
                     goto errorexit;
                end;
              firstpass(p^.right);

              { check the parameters }
              pdc:=pprocvardef(p^.right^.resulttype)^.para1;
              pt:=p^.left;
              while assigned(pdc) and assigned(pt) do
                begin
                   pt:=pt^.right;
                   pdc:=pdc^.next;
                end;
              if assigned(pt) or assigned(pdc) then
                CGMessage(parser_e_illegal_parameter_list);
              { insert type conversions }
              if assigned(p^.left) then
                begin
                   old_count_ref:=count_ref;
                   count_ref:=true;
                   firstcallparan(p^.left,pprocvardef(p^.right^.resulttype)^.para1);
                   count_ref:=old_count_ref;
                   if codegenerror then
                     goto errorexit;
                end;
              p^.resulttype:=pprocvardef(p^.right^.resulttype)^.retdef;
              { this was missing, leads to a bug below if
                the procvar is a function }
              p^.procdefinition:=pprocdef(p^.right^.resulttype);
           end
         else
         { not a procedure variable }
           begin
              { determine the type of the parameters }
              if assigned(p^.left) then
                begin
                   old_count_ref:=count_ref;
                   count_ref:=false;
                   store_valid:=must_be_valid;
                   must_be_valid:=false;
                   firstcallparan(p^.left,nil);
                   count_ref:=old_count_ref;
                   must_be_valid:=store_valid;
                   if codegenerror then
                     goto errorexit;
                end;

              aktcallprocsym:=pprocsym(p^.symtableprocentry);

              { do we know the procedure to call ? }
              if not(assigned(p^.procdefinition)) then
                begin
{$ifdef TEST_PROCSYMS}
                 if (p^.unit_specific) or
                    assigned(p^.methodpointer) then
                   nextprocsym:=nil
                 else while not assigned(procs) do
                  begin
                     symt:=p^.symtableproc;
                     srsym:=nil;
                     while assigned(symt^.next) and not assigned(srsym) do
                       begin
                          symt:=symt^.next;
                          getsymonlyin(symt,actprocsym^.name);
                          if assigned(srsym) then
                            if srsym^.typ<>procsym then
                              begin
                                 { reject all that is not a procedure }
                                 srsym:=nil;
                                 { don't search elsewhere }
                                 while assigned(symt^.next) do
                                   symt:=symt^.next;
                              end;
                       end;
                     nextprocsym:=srsym;
                  end;
{$else TEST_PROCSYMS}
                nextprocsym:=nil;
{$endif TEST_PROCSYMS}
                   { determine length of parameter list }
                   pt:=p^.left;
                   paralength:=0;
                   while assigned(pt) do
                     begin
                        inc(paralength);
                        pt:=pt^.right;
                     end;

                   { link all procedures which have the same # of parameters }
                   pd:=aktcallprocsym^.definition;
                   while assigned(pd) do
                     begin
                        pdc:=pd^.para1;
                        l:=0;
                        while assigned(pdc) do
                          begin
                             inc(l);
                             pdc:=pdc^.next;
                          end;
                        { only when the # of parameter are equal }
                        if (l=paralength) then
                          begin
                             new(hp);
                             hp^.data:=pd;
                             hp^.next:=procs;
                             hp^.nextpara:=pd^.para1;
                             hp^.firstpara:=pd^.para1;
                             procs:=hp;
                          end;
                        pd:=pd^.nextoverloaded;
                     end;

                   { no procedures found? then there is something wrong
                     with the parameter size }
                   if not assigned(procs) and
                      ((parsing_para_level=0) or assigned(p^.left)) and
                      (nextprocsym=nil) then
                    begin
                       CGMessage(parser_e_wrong_parameter_size);
                       aktcallprocsym^.write_parameter_lists;
                       goto errorexit;
                    end;

                { now we can compare parameter after parameter }
                   pt:=p^.left;
                   { we start with the last parameter }
                   lastpara:=paralength+1;
                   lastparatype:=nil;
                   while assigned(pt) do
                     begin
                        dec(lastpara);
                        { walk all procedures and determine how this parameter matches and set:
                           1. pt^.exact_match_found if one parameter has an exact match
                           2. exactmatch if an equal or exact match is found

                           3. para^.argconvtyp to exact,equal or convertable
                                (when convertable then also convertlevel is set)
                           4. pt^.convlevel1found if there is a convertlevel=1
                           5. pt^.convlevel2found if there is a convertlevel=2
                        }
                        exactmatch:=false;
                        hp:=procs;
                        while assigned(hp) do
                          begin
                             if is_equal(pt,hp^.nextpara^.data) then
                               begin
                                  if hp^.nextpara^.data=pt^.resulttype then
                                    begin
                                       pt^.exact_match_found:=true;
                                       hp^.nextpara^.argconvtyp:=act_exact;
                                    end
                                  else
                                    hp^.nextpara^.argconvtyp:=act_equal;
                                  exactmatch:=true;
                               end
                             else
                               begin
                                 hp^.nextpara^.argconvtyp:=act_convertable;
                                 hp^.nextpara^.convertlevel:=isconvertable(pt^.resulttype,hp^.nextpara^.data,
                                     hcvt,pt^.left^.treetype,false);
                                 case hp^.nextpara^.convertlevel of
                                  1 : pt^.convlevel1found:=true;
                                  2 : pt^.convlevel2found:=true;
                                 end;
                               end;

                             hp:=hp^.next;
                          end;

                        { If there was an exactmatch then delete all convertables }
                        if exactmatch then
                          begin
                            hp:=procs;
                            procs:=nil;
                            while assigned(hp) do
                              begin
                                 hp2:=hp^.next;
                                 { keep if not convertable }
                                 if (hp^.nextpara^.argconvtyp<>act_convertable) then
                                  begin
                                    hp^.next:=procs;
                                    procs:=hp;
                                  end
                                 else
                                  dispose(hp);
                                 hp:=hp2;
                              end;
                          end
                        else
                        { No exact match was found, remove all procedures that are
                          not convertable (convertlevel=0) }
                          begin
                            hp:=procs;
                            procs:=nil;
                            while assigned(hp) do
                              begin
                                 hp2:=hp^.next;
                                 { keep if not convertable }
                                 if (hp^.nextpara^.convertlevel<>0) then
                                  begin
                                    hp^.next:=procs;
                                    procs:=hp;
                                  end
                                 else
                                  begin
                                    { save the type for nice error message }
                                    lastparatype:=hp^.nextpara^.data;
                                    dispose(hp);
                                  end;
                                 hp:=hp2;
                              end;
                          end;
                        { update nextpara for all procedures }
                        hp:=procs;
                        while assigned(hp) do
                          begin
                             hp^.nextpara:=hp^.nextpara^.next;
                             hp:=hp^.next;
                          end;
                        { load next parameter or quit loop if no procs left }
                        if assigned(procs) then
                          pt:=pt^.right
                        else
                          break;
                     end;

                 { All parameters are checked, check if there are any
                   procedures left }
                   if not assigned(procs) then
                    begin
                      { there is an error, must be wrong type, because
                        wrong size is already checked (PFV) }
                      if ((parsing_para_level=0) or (p^.left<>nil)) and
                         (nextprocsym=nil) then
                       begin
{$ifdef STORENUMBER}
                         if (not assigned(lastparatype)) and (not assigned(pt^.resulttype)) then
                          internalerror(39393)
                         else
                          CGMessage3(type_e_wrong_parameter_type,tostr(lastpara),
                             lastparatype^.typename,pt^.resulttype^.typename);
{$else}
                          CGMessage1(parser_e_wrong_parameter_type,tostr(lastpara));
{$endif}
                          aktcallprocsym^.write_parameter_lists;
                          goto errorexit;
                       end
                      else
                       begin
                         { try to convert to procvar }
                         p^.treetype:=loadn;
                         p^.resulttype:=pprocsym(p^.symtableprocentry)^.definition;
                         p^.symtableentry:=p^.symtableprocentry;
                         p^.is_first:=false;
                         p^.disposetyp:=dt_nothing;
                         firstpass(p);
                         goto errorexit;
                       end;
                     end;

                   { if there are several choices left then for orddef }
                   { if a type is totally included in the other        }
                   { we don't fear an overflow ,                       }
                   { so we can do as if it is an exact match           }
                   { this will convert integer to longint              }
                   { rather than to words                              }
                   { conversion of byte to integer or longint          }
                   {would still not be solved                          }
                   if assigned(procs) and assigned(procs^.next) then
                     begin
                        hp:=procs;
                        while assigned(hp) do
                          begin
                            hp^.nextpara:=hp^.firstpara;
                            hp:=hp^.next;
                          end;
                        pt:=p^.left;
                        while assigned(pt) do
                          begin
                             { matches a parameter of one procedure exact ? }
                             exactmatch:=false;
                             def_from:=pt^.resulttype;
                             hp:=procs;
                             while assigned(hp) do
                               begin
                                  if not is_equal(pt,hp^.nextpara^.data) then
                                    begin
                                       def_to:=hp^.nextpara^.data;
                                       if ((def_from^.deftype=orddef) and (def_to^.deftype=orddef)) and
                                         (is_in_limit(def_from,def_to) or
                                         ((hp^.nextpara^.paratyp=vs_var) and
                                         (def_from^.size=def_to^.size))) then
                                         begin
                                            exactmatch:=true;
                                            conv_to:=def_to;
                                         end;
                                    end;
                                  hp:=hp^.next;
                               end;

                             { .... if yes, del all the other procedures }
                             if exactmatch then
                               begin
                                  { the first .... }
                                  while (assigned(procs)) and not(is_in_limit(def_from,procs^.nextpara^.data)) do
                                    begin
                                       hp:=procs^.next;
                                       dispose(procs);
                                       procs:=hp;
                                    end;
                                  { and the others }
                                  hp:=procs;
                                  while (assigned(hp)) and assigned(hp^.next) do
                                    begin
                                       if not(is_in_limit(def_from,hp^.next^.nextpara^.data)) then
                                         begin
                                            hp2:=hp^.next^.next;
                                            dispose(hp^.next);
                                            hp^.next:=hp2;
                                         end
                                       else
                                         begin
                                           def_to:=hp^.next^.nextpara^.data;
                                           if (conv_to^.size>def_to^.size) or
                                              ((porddef(conv_to)^.low<porddef(def_to)^.low) and
                                              (porddef(conv_to)^.high>porddef(def_to)^.high)) then
                                             begin
                                                hp2:=procs;
                                                procs:=hp;
                                                conv_to:=def_to;
                                                dispose(hp2);
                                             end
                                           else
                                             hp:=hp^.next;
                                         end;
                                    end;
                               end;
                             { update nextpara for all procedures }
                             hp:=procs;
                             while assigned(hp) do
                               begin
                                  hp^.nextpara:=hp^.nextpara^.next;
                                  hp:=hp^.next;
                               end;
                             pt:=pt^.right;
                          end;
                     end;

                   { let's try to eliminate equal if there is an exact match
                     is there }
                   if assigned(procs) and assigned(procs^.next) then
                     begin
                        { reset nextpara for all procs left }
                        hp:=procs;
                        while assigned(hp) do
                         begin
                           hp^.nextpara:=hp^.firstpara;
                           hp:=hp^.next;
                         end;

                        pt:=p^.left;
                        while assigned(pt) do
                          begin
                             if pt^.exact_match_found then
                               begin
                                 hp:=procs;
                                 procs:=nil;
                                 while assigned(hp) do
                                   begin
                                      hp2:=hp^.next;
                                      { keep the exact matches, dispose the others }
                                      if (hp^.nextpara^.argconvtyp=act_exact) then
                                       begin
                                         hp^.next:=procs;
                                         procs:=hp;
                                       end
                                      else
                                       dispose(hp);
                                      hp:=hp2;
                                   end;
                               end;
                             { update nextpara for all procedures }
                             hp:=procs;
                             while assigned(hp) do
                               begin
                                  hp^.nextpara:=hp^.nextpara^.next;
                                  hp:=hp^.next;
                               end;
                             pt:=pt^.right;
                          end;
                     end;

                   { Check if there are convertlevel 1 and 2 differences
                     left for the parameters, then discard all convertlevel
                     2 procedures. The value of convlevelXfound can still
                     be used, because all convertables are still here or
                     not }
                   if assigned(procs) and assigned(procs^.next) then
                     begin
                        { reset nextpara for all procs left }
                        hp:=procs;
                        while assigned(hp) do
                         begin
                           hp^.nextpara:=hp^.firstpara;
                           hp:=hp^.next;
                         end;

                        pt:=p^.left;
                        while assigned(pt) do
                          begin
                             if pt^.convlevel1found and pt^.convlevel2found then
                               begin
                                 hp:=procs;
                                 procs:=nil;
                                 while assigned(hp) do
                                   begin
                                      hp2:=hp^.next;
                                      { keep all not act_convertable and all convertlevels=1 }
                                      if (hp^.nextpara^.argconvtyp<>act_convertable) or
                                         (hp^.nextpara^.convertlevel=1) then
                                       begin
                                         hp^.next:=procs;
                                         procs:=hp;
                                       end
                                      else
                                       dispose(hp);
                                      hp:=hp2;
                                   end;
                               end;
                             { update nextpara for all procedures }
                             hp:=procs;
                             while assigned(hp) do
                               begin
                                  hp^.nextpara:=hp^.nextpara^.next;
                                  hp:=hp^.next;
                               end;
                             pt:=pt^.right;
                          end;
                     end;

                   if not(assigned(procs)) or assigned(procs^.next) then
                     begin
                        CGMessage(cg_e_cant_choose_overload_function);
                        aktcallprocsym^.write_parameter_lists;
                        goto errorexit;
                     end;
{$ifdef TEST_PROCSYMS}
                   if (procs=nil) and assigned(nextprocsym) then
                     begin
                        p^.symtableprocentry:=nextprocsym;
                        p^.symtableproc:=symt;
                     end;
                 end ; { of while assigned(p^.symtableprocentry) do }
{$endif TEST_PROCSYMS}
                   if make_ref then
                     begin
                        procs^.data^.lastref:=new(pref,init(procs^.data^.lastref,@p^.fileinfo));
                        inc(procs^.data^.refcount);
                        if procs^.data^.defref=nil then
                          procs^.data^.defref:=procs^.data^.lastref;
                     end;

                   p^.procdefinition:=procs^.data;
                   p^.resulttype:=procs^.data^.retdef;
                   { big error for with statements
                   p^.symtableproc:=p^.procdefinition^.owner;
                   but neede for overloaded operators !! }
                   if p^.symtableproc=nil then
                     p^.symtableproc:=p^.procdefinition^.owner;

                   p^.location.loc:=LOC_MEM;
{$ifdef CHAINPROCSYMS}
                   { object with method read;
                     call to read(x) will be a usual procedure call }
                   if assigned(p^.methodpointer) and
                     (p^.procdefinition^._class=nil) then
                     begin
                        { not ok for extended }
                        case p^.methodpointer^.treetype of
                           typen,hnewn : fatalerror(no_para_match);
                        end;
                        disposetree(p^.methodpointer);
                        p^.methodpointer:=nil;
                     end;
{$endif CHAINPROCSYMS}
               end; { end of procedure to call determination }

              is_const:=((p^.procdefinition^.options and pointernconst)<>0) and
                        ((block_type=bt_const) or
                         (assigned(p^.left) and (p^.left^.left^.treetype in [realconstn,ordconstn])));
              { handle predefined procedures }
              if ((p^.procdefinition^.options and pointernproc)<>0) or is_const then
                begin
                   if assigned(p^.left) then
                     begin
                     { settextbuf needs two args }
                       if assigned(p^.left^.right) then
                         pt:=geninlinenode(pprocdef(p^.procdefinition)^.extnumber,is_const,p^.left)
                       else
                         begin
                           pt:=geninlinenode(pprocdef(p^.procdefinition)^.extnumber,is_const,p^.left^.left);
                           putnode(p^.left);
                         end;
                     end
                   else
                     begin
                       pt:=geninlinenode(pprocdef(p^.procdefinition)^.extnumber,is_const,nil);
                     end;
                   putnode(p);
                   firstpass(pt);
                   p:=pt;
                   goto errorexit;
                end
              else
                { no intern procedure => we do a call }
              { calc the correture value for the register }
              { handle predefined procedures }
              if (p^.procdefinition^.options and poinline)<>0 then
                begin
                   if assigned(p^.methodpointer) then
                     CGMessage(cg_e_unable_inline_object_methods);
                   if assigned(p^.right) and (p^.right^.treetype<>procinlinen) then
                     CGMessage(cg_e_unable_inline_procvar);
                   { p^.treetype:=procinlinen; }
                   if not assigned(p^.right) then
                     begin
                        if assigned(p^.procdefinition^.code) then
                          inlinecode:=genprocinlinenode(p,ptree(p^.procdefinition^.code))
                        else
                          CGMessage(cg_e_no_code_for_inline_stored);
                        if assigned(inlinecode) then
                          begin
                             { consider it has not inlined if called
                               again inside the args }
                             p^.procdefinition^.options:=p^.procdefinition^.options and (not poinline);
                             firstpass(inlinecode);
                             inlined:=true;
                          end;
                     end;
                end
              else
                procinfo.flags:=procinfo.flags or pi_do_call;

              { work trough all parameters to insert the type conversions }
              { !!! done now after internproc !! (PM) }
              if assigned(p^.left) then
                begin
                   old_count_ref:=count_ref;
                   count_ref:=true;
                   firstcallparan(p^.left,p^.procdefinition^.para1);
                   count_ref:=old_count_ref;
                end;
{$ifdef i386}
              for regi:=R_EAX to R_EDI do
                begin
                   if (p^.procdefinition^.usedregisters and ($80 shr word(regi)))<>0 then
                     inc(reg_pushes[regi],t_times*2);
                end;
{$endif}
{$ifdef m68k}
             for regi:=R_D0 to R_A6 do
               begin
                  if (p^.procdefinition^.usedregisters and ($800 shr word(regi)))<>0 then
                    inc(reg_pushes[regi],t_times*2);
               end;
{$endif}
           end;
         { ensure that the result type is set }
         p^.resulttype:=p^.procdefinition^.retdef;
         { get a register for the return value }
         if (p^.resulttype<>pdef(voiddef)) then
           begin
              if (p^.procdefinition^.options and poconstructor)<>0 then
                begin
                   { extra handling of classes }
                   { p^.methodpointer should be assigned! }
                   if assigned(p^.methodpointer) and assigned(p^.methodpointer^.resulttype) and
                     (p^.methodpointer^.resulttype^.deftype=classrefdef) then
                     begin
                        p^.location.loc:=LOC_REGISTER;
                        p^.registers32:=1;
                        { the result type depends on the classref }
                        p^.resulttype:=pclassrefdef(p^.methodpointer^.resulttype)^.definition;
                     end
                  { a object constructor returns the result with the flags }
                   else
                     p^.location.loc:=LOC_FLAGS;
                end
              else
                begin
{$ifdef SUPPORT_MMX}
                   if (cs_mmx in aktlocalswitches) and
                     is_mmx_able_array(p^.resulttype) then
                     begin
                        p^.location.loc:=LOC_MMXREGISTER;
                        p^.registersmmx:=1;
                     end
                   else
{$endif SUPPORT_MMX}
                   if ret_in_acc(p^.resulttype) then
                     begin
                        p^.location.loc:=LOC_REGISTER;
                        if is_64bitint(p^.resulttype) then
                          p^.registers32:=2
                        else
                          p^.registers32:=1;
                     end
                   else if (p^.resulttype^.deftype=floatdef) then
                     begin
                        p^.location.loc:=LOC_FPU;
                        p^.registersfpu:=1;
                     end
                end;
           end;

         { a fpu can be used in any procedure !! }
         p^.registersfpu:=p^.procdefinition^.fpu_used;
         { if this is a call to a method calc the registers }
         if (p^.methodpointer<>nil) then
           begin
              case p^.methodpointer^.treetype of
                { but only, if this is not a supporting node }
                typen,hnewn : ;
                else
                  begin
{$ifndef NODIRECTWITH}
                     if ((p^.procdefinition^.options and (poconstructor or podestructor)) <> 0) and
                        assigned(p^.symtable) and (p^.symtable^.symtabletype=withsymtable) and
                        not pwithsymtable(p^.symtable)^.direct_with then
                       begin
                          CGmessage(cg_e_cannot_call_cons_dest_inside_with);
                       end; { Is accepted by Delphi !! }
                     { this is not a good reason to accept it in FPC if we produce
                       wrong code for it !!! (PM) }
{$endif ndef NODIRECTWITH}

                     { R.Assign is not a constructor !!! }
                     { but for R^.Assign, R must be valid !! }
                     if ((p^.procdefinition^.options and poconstructor) <> 0) or
                        ((p^.methodpointer^.treetype=loadn) and
                        ((pobjectdef(p^.methodpointer^.resulttype)^.options and oo_hasvirtual) = 0)) then
                       must_be_valid:=false
                     else
                       must_be_valid:=true;
                     firstpass(p^.methodpointer);
                     p^.registersfpu:=max(p^.methodpointer^.registersfpu,p^.registersfpu);
                     p^.registers32:=max(p^.methodpointer^.registers32,p^.registers32);
{$ifdef SUPPORT_MMX}
                     p^.registersmmx:=max(p^.methodpointer^.registersmmx,p^.registersmmx);
{$endif SUPPORT_MMX}
                  end;
              end;
           end;

         if inlined then
           p^.right:=inlinecode;
         { determine the registers of the procedure variable }
         { is this OK for inlined procs also ?? (PM)         }
         if assigned(p^.right) then
           begin
              p^.registersfpu:=max(p^.right^.registersfpu,p^.registersfpu);
              p^.registers32:=max(p^.right^.registers32,p^.registers32);
{$ifdef SUPPORT_MMX}
              p^.registersmmx:=max(p^.right^.registersmmx,p^.registersmmx);
{$endif SUPPORT_MMX}
           end;
         { determine the registers of the procedure }
         if assigned(p^.left) then
           begin
              p^.registersfpu:=max(p^.left^.registersfpu,p^.registersfpu);
              p^.registers32:=max(p^.left^.registers32,p^.registers32);
{$ifdef SUPPORT_MMX}
              p^.registersmmx:=max(p^.left^.registersmmx,p^.registersmmx);
{$endif SUPPORT_MMX}
           end;
      errorexit:
         { Reset some settings back }
         if assigned(procs) then
           dispose(procs);
         if inlined then
           p^.procdefinition^.options:=p^.procdefinition^.options or poinline;
         aktcallprocsym:=oldcallprocsym;
         must_be_valid:=store_valid;
      end;


{*****************************************************************************
                             FirstProcInlineN
*****************************************************************************}

    procedure firstprocinline(var p : ptree);
      begin
        { left contains the code in tree form }
        { but it has already been firstpassed }
        { so firstpass(p^.left); does not seem required }
        { might be required later if we change the arg handling !! }
      end;

end.
{
  $Log$
  Revision 1.33  1999-04-21 09:44:00  peter
    * storenumber works
    * fixed some typos in double_checksum
    + incompatible types type1 and type2 message (with storenumber)

  Revision 1.32  1999/04/14 09:11:22  peter
    * fixed tp proc -> procvar

  Revision 1.31  1999/04/01 21:59:56  peter
    * type error for array constructor with array,record as argument

  Revision 1.30  1999/03/31 13:55:27  peter
    * assembler inlining working for ag386bin

  Revision 1.29  1999/03/24 23:17:34  peter
    * fixed bugs 212,222,225,227,229,231,233

  Revision 1.28  1999/03/23 14:43:03  peter
    * fixed crash with array of const in procvar

  Revision 1.27  1999/03/19 17:31:54  pierre
   * lost reference because refcount not increased fixed

  Revision 1.26  1999/03/02 18:24:22  peter
    * fixed overloading of array of char

  Revision 1.25  1999/02/22 15:09:44  florian
    * behaviaor of PROTECTED and PRIVATE fixed, works now like TP/Delphi

  Revision 1.24  1999/02/22 02:15:45  peter
    * updates for ag386bin

  Revision 1.23  1999/02/09 17:15:52  florian
    * some false warnings "function result doesn't seems to be set" are
      avoided

  Revision 1.22  1999/01/29 11:34:55  pierre
   + better info for impossible type conversion in calln

  Revision 1.21  1999/01/21 22:10:49  peter
    * fixed array of const
    * generic platform independent high() support

  Revision 1.20  1999/01/21 16:41:06  pierre
   * fix for constructor inside with statements

  Revision 1.19  1999/01/19 14:20:16  peter
    * fixed [char] crash

  Revision 1.18  1999/01/12 14:25:40  peter
    + BrowserLog for browser.log generation
    + BrowserCol for browser info in TCollections
    * released all other UseBrowser

  Revision 1.17  1998/12/11 00:03:52  peter
    + globtype,tokens,version unit splitted from globals

  Revision 1.16  1998/12/10 14:57:52  pierre
   * fix for operators

  Revision 1.15  1998/12/10 09:47:32  florian
    + basic operations with int64/qord (compiler with -dint64)
    + rtti of enumerations extended: names are now written

  Revision 1.14  1998/11/27 14:50:52  peter
    + open strings, $P switch support

  Revision 1.13  1998/11/24 17:03:51  peter
    * fixed exactmatch removings

  Revision 1.12  1998/11/16 10:18:10  peter
    * fixes for ansistrings

  Revision 1.11  1998/11/10 10:09:17  peter
    * va_list -> array of const

  Revision 1.10  1998/11/09 11:44:41  peter
    + va_list for printf support

  Revision 1.9  1998/10/28 18:26:22  pierre
   * removed some erros after other errors (introduced by useexcept)
   * stabs works again correctly (for how long !)

  Revision 1.8  1998/10/09 16:36:09  pierre
    * some memory leaks specific to usebrowser define fixed
    * removed tmodule.implsymtable (was like tmodule.localsymtable)

  Revision 1.7  1998/10/06 20:49:09  peter
    * m68k compiler compiles again

  Revision 1.6  1998/10/02 09:24:22  peter
    * more constant expression evaluators

  Revision 1.5  1998/09/28 11:22:17  pierre
   * did not compile for browser
   * merge from fixes

  Revision 1.4  1998/09/27 10:16:24  florian
    * type casts pchar<->ansistring fixed
    * ansistring[..] calls does now an unique call

  Revision 1.3  1998/09/24 14:27:40  peter
    * some better support for openarray

  Revision 1.2  1998/09/24 09:02:16  peter
    * rewritten isconvertable to use case
    * array of .. and single variable are compatible

  Revision 1.1  1998/09/23 20:42:24  peter
    * splitted pass_1

}

