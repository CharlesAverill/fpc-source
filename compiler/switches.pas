{
    $Id$
    Copyright (c) 1998-2000 by Peter Vreman

    This unit implements the parsing of the switches like $I-

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
unit switches;

{$i defines.inc}

interface

procedure HandleSwitch(switch,state:char);
function CheckSwitch(switch,state:char):boolean;


implementation
uses
  globtype,systems,
  globals,verbose,fmodule;

{****************************************************************************
                          Main Switches Parsing
****************************************************************************}

type
  TSwitchType=(ignoredsw,localsw,modulesw,globalsw,illegalsw,unsupportedsw);
  SwitchRec=record
    typesw : TSwitchType;
    setsw  : byte;
  end;
const
  SwitchTable:array['A'..'Z'] of SwitchRec=(
   {A} (typesw:unsupportedsw; setsw:ord(cs_localnone)),
   {B} (typesw:localsw; setsw:ord(cs_full_boolean_eval)),
   {C} (typesw:localsw; setsw:ord(cs_do_assertion)),
   {D} (typesw:modulesw; setsw:ord(cs_debuginfo)),
   {E} (typesw:globalsw; setsw:ord(cs_fp_emulation)),
   {F} (typesw:ignoredsw; setsw:ord(cs_localnone)),
   {G} (typesw:ignoredsw; setsw:ord(cs_localnone)),
   {H} (typesw:localsw; setsw:ord(cs_ansistrings)),
   {I} (typesw:localsw; setsw:ord(cs_check_io)),
   {J} (typesw:unsupportedsw; setsw:ord(cs_typed_const_not_changeable)),
   {K} (typesw:unsupportedsw; setsw:ord(cs_localnone)),
   {L} (typesw:modulesw; setsw:ord(cs_local_browser)),
   {M} (typesw:localsw; setsw:ord(cs_generate_rtti)),
   {N} (typesw:unsupportedsw; setsw:ord(cs_localnone)),
   {O} (typesw:unsupportedsw; setsw:ord(cs_localnone)),
   {P} (typesw:modulesw; setsw:ord(cs_openstring)),
   {Q} (typesw:localsw; setsw:ord(cs_check_overflow)),
   {R} (typesw:localsw; setsw:ord(cs_check_range)),
   {S} (typesw:localsw; setsw:ord(cs_check_stack)),
   {T} (typesw:localsw; setsw:ord(cs_typed_addresses)),
   {U} (typesw:illegalsw; setsw:ord(cs_localnone)),
   {V} (typesw:localsw; setsw:ord(cs_strict_var_strings)),
   {W} (typesw:unsupportedsw; setsw:ord(cs_localnone)),
   {X} (typesw:modulesw; setsw:ord(cs_extsyntax)),
   {Y} (typesw:modulesw; setsw:ord(cs_browser)),
   {Z} (typesw:illegalsw; setsw:ord(cs_localnone))
    );

procedure HandleSwitch(switch,state:char);
begin
  switch:=upcase(switch);
{ Is the Switch in the letters ? }
  if not ((switch in ['A'..'Z']) and (state in ['-','+'])) then
   begin
     Message(scan_w_illegal_switch);
     exit;
   end;
{ Handle the switch }
  with SwitchTable[switch] do
   begin
     case typesw of
     ignoredsw : Message1(scan_n_ignored_switch,'$'+switch);
     illegalsw : Message1(scan_w_illegal_switch,'$'+switch);
 unsupportedsw : Message1(scan_w_unsupported_switch,'$'+switch);
       localsw : begin
                   if not localswitcheschanged then
                     nextaktlocalswitches:=aktlocalswitches;
                   if state='+' then
                    nextaktlocalswitches:=nextaktlocalswitches+[tlocalswitch(setsw)]
                   else
                    nextaktlocalswitches:=nextaktlocalswitches-[tlocalswitch(setsw)];
                   localswitcheschanged:=true;
                 { Message for linux which has global checking only }
                   if (switch='S') and (
{$ifdef i386}
                      (target_info.target = target_i386_linux)
{$else}
{$ifdef m68k}
                      (target_info.target = target_m68k_linux)
{$else}
                       True
{$endif m68k}
{$endif i386}
                       ) then
                       Message(scan_n_stack_check_global_under_linux);
                 end;
      modulesw : begin
                   if current_module^.in_global then
                    begin
                      if state='+' then
                        aktmoduleswitches:=aktmoduleswitches+[tmoduleswitch(setsw)]
                      else
                        aktmoduleswitches:=aktmoduleswitches-[tmoduleswitch(setsw)];
                      { can't have local browser when no global browser
                        moved to end of global section
                      if (cs_local_browser in aktmoduleswitches) and
                         not(cs_browser in aktmoduleswitches) then
                        aktmoduleswitches:=aktmoduleswitches-[cs_local_browser];}
                    end
                   else
                    Message(scan_w_switch_is_global);
                 end;
      globalsw : begin
                   if current_module^.in_global and (current_module=main_module) then
                    begin
                      if state='+' then
                       aktglobalswitches:=aktglobalswitches+[tglobalswitch(setsw)]
                      else
                       aktglobalswitches:=aktglobalswitches-[tglobalswitch(setsw)];
                    end
                   else
                    Message(scan_w_switch_is_global);
                 end;
      end;
   end;
end;


function CheckSwitch(switch,state:char):boolean;
var
  found : boolean;
begin
  switch:=upcase(switch);
{ Is the Switch in the letters ? }
  if not ((switch in ['A'..'Z']) and (state in ['-','+'])) then
   begin
     Message(scan_w_illegal_switch);
     CheckSwitch:=false;
     exit;
   end;
{ Check the switch }
  with SwitchTable[switch] do
   begin
     case typesw of
      localsw : found:=(tlocalswitch(setsw) in aktlocalswitches);
     modulesw : found:=(tmoduleswitch(setsw) in aktmoduleswitches);
     globalsw : found:=(tglobalswitch(setsw) in aktglobalswitches);
     else
      found:=false;
     end;
     if state='-' then
      found:=not found;
     CheckSwitch:=found;
   end;
end;


end.
{
  $Log$
  Revision 1.5  2000-09-24 15:06:28  peter
    * use defines.inc

  Revision 1.4  2000/09/21 11:30:49  jonas
    + support for full boolean evaluation (b+/b-), default remains short
      circuit boolean evaluation

  Revision 1.3  2000/08/27 16:11:53  peter
    * moved some util functions from globals,cobjects to cutils
    * splitted files into finput,fmodule

  Revision 1.2  2000/07/13 11:32:49  michael
  + removed logs

}
