{
    $Id$
    Copyright (c) 1993-98 by Florian Klaempfl, Pierre Muller

    Global types

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
unit globtype;
interface

    const
       maxidlen = 64;

    type
       { System independent float names }
{$ifdef i386}
       bestreal = extended;
       ts32real = single;
       ts64real = double;
       ts80real = extended;
       ts64comp = extended;
{$endif}
{$ifdef m68k}
       bestreal = real;
       ts32real = single;
       ts64real = double;
       ts80real = extended;
       ts64comp = comp;
{$endif}
{$ifdef alpha}
       bestreal = extended;
       ts32real = single;
       ts64real = double;
       ts80real = extended;
       ts64comp = comp;
{$endif}
{$ifdef powerpc}
       bestreal = double;
       ts32real = single;
       ts64real = double;
       ts80real = extended;
       ts64comp = comp;
{$endif powerpc}
       pbestreal=^bestreal;

       { Switches which can be changed locally }
       tlocalswitch = (cs_localnone,
         { codegen }
         cs_check_overflow,cs_check_range,cs_check_io,cs_check_stack,
         cs_omitstackframe,cs_do_assertion,cs_generate_rtti,
         { mmx }
         cs_mmx,cs_mmx_saturation,
         { parser }
         cs_typed_addresses,cs_strict_var_strings,cs_ansistrings
       );
       tlocalswitches = set of tlocalswitch;

       { Switches which can be changed only at the beginning of a new module }
       tmoduleswitch = (cs_modulenone,
         { parser }
         cs_fp_emulation,cs_extsyntax,cs_openstring,
         { support }
         cs_support_inline,cs_support_goto,cs_support_macro,
         cs_support_c_operators,cs_static_keyword,
         cs_typed_const_not_changeable,
         { generation }
         cs_profile,cs_debuginfo,cs_browser,cs_local_browser,cs_compilesystem,
         cs_lineinfo,
         { linking }
         cs_smartlink
       );
       tmoduleswitches = set of tmoduleswitch;

       { Switches which can be changed only for a whole program/compilation,
         mostly set with commandline }
       tglobalswitch = (cs_globalnone,
         { parameter switches }
         cs_check_unit_name,cs_constructor_name,
         { units }
         cs_load_objpas_unit,
         cs_load_gpc_unit,
         { optimizer }
         cs_regalloc,cs_uncertainopts,cs_littlesize,cs_optimize,
         cs_fastoptimize, cs_slowoptimize,
         { browser }
         cs_browser_log,
         { debugger }
         cs_gdb_dbx,cs_gdb_gsym,cs_gdb_heaptrc,cs_checkpointer,
         { assembling }
         cs_asm_leave,cs_asm_extern,cs_asm_pipe,cs_asm_source,
         cs_asm_regalloc,cs_asm_tempalloc,
         { linking }
         cs_link_extern,cs_link_static,cs_link_smart,cs_link_shared,cs_link_deffile,
         cs_link_strip,cs_link_toc
       );
       tglobalswitches = set of tglobalswitch;

       { Switches which can be changed by a mode (fpc,tp7,delphi) }
       tmodeswitch = (m_none,m_all, { needed for keyword }
         { generic }
         m_fpc,m_delphi,m_tp,m_gpc,
         { more specific }
         m_class,               { delphi class model }
         m_objpas,              { load objpas unit }
         m_result,              { result in functions }
         m_string_pchar,        { pchar 2 string conversion }
         m_cvar_support,        { cvar variable directive }
         m_nested_comment,      { nested comments }
         m_tp_procvar,          { tp style procvars (no @ needed) }
         m_repeat_forward,      { repeating forward declarations is needed }
         m_pointer_2_procedure, { allows the assignement of pointers to
                                  procedure variables                     }
         m_autoderef,           { does auto dereferencing of struct. vars }
         m_initfinal,           { initialization/finalization for units }
         m_add_pointer          { allow pointer add/sub operations }
       );
       tmodeswitches = set of tmodeswitch;

       { win32 sub system }
       tapptype = (at_none,
         at_gui,at_cui
       );

       { currently parsed block type }
       tblock_type = (bt_none,
         bt_general,bt_type,bt_const
       );

       { packrecords types }
       tpackrecords = (packrecord_none,
         packrecord_1,packrecord_2,packrecord_4,
         packrecord_8,packrecord_16,packrecord_32,
         packrecord_C
       );

    const
       packrecordalignment : array[tpackrecords] of byte=(0,
         1,2,4,8,16,32,1
       );

    type
       stringid = string[maxidlen];

       tnormalset = set of byte; { 256 elements set }
       pnormalset = ^tnormalset;

       pdouble    = ^double;
       pbyte      = ^byte;
       pword      = ^word;
       plongint   = ^longint;

    const
       { link options }
       link_none    = $0;
       link_allways = $1;
       link_static  = $2;
       link_smart   = $4;
       link_shared  = $8;


implementation


begin
end.
{
  $Log$
  Revision 1.18  1999-09-08 16:05:32  peter
    * pointer add/sub is now as expected and the same results as inc/dec

  Revision 1.17  1999/08/13 15:44:58  peter
    * first things to include lineinfo in the executable

  Revision 1.16  1999/08/11 17:26:33  peter
    * tlinker object is now inherited for win32 and dos
    * postprocessexecutable is now a method of tlinker

  Revision 1.15  1999/08/04 13:02:42  jonas
    * all tokens now start with an underscore
    * PowerPC compiles!!

  Revision 1.14  1999/08/01 23:04:48  michael
  + Changes for Alpha

  Revision 1.13  1999/07/23 16:05:21  peter
    * alignment is now saved in the symtable
    * C alignment added for records
    * PPU version increased to solve .12 <-> .13 probs

  Revision 1.12  1999/07/10 10:26:19  peter
    * merged

  Revision 1.11  1999/07/03 00:29:49  peter
    * new link writing to the ppu, one .ppu is needed for all link types,
      static (.o) is now always created also when smartlinking is used

  Revision 1.10.2.1  1999/07/10 10:03:06  peter
    * fixed initialization/finalization in fpc mode
    * allow $TARGET also in search paths

  Revision 1.10  1999/05/17 14:30:39  pierre
   + cs_checkpointer

  Revision 1.9  1999/05/12 00:19:49  peter
    * removed R_DEFAULT_SEG
    * uniform float names

  Revision 1.8  1999/04/26 13:31:33  peter
    * release storenumber,double_checksum

  Revision 1.7  1999/04/25 22:34:58  pierre
   + cs_typed_const_not_changeable added but not implemented yet !

  Revision 1.6  1999/04/16 11:49:42  peter
    + tempalloc
    + -at to show temp alloc info in .s file

  Revision 1.5  1999/04/10 16:15:01  peter
    * fixed browcol
    + -ar to show regalloc info in .s file

  Revision 1.4  1999/03/26 00:05:30  peter
    * released valintern
    + deffile is now removed when compiling is finished
    * ^( compiles now correct
    + static directive
    * shrd fixed

  Revision 1.3  1999/01/27 13:51:44  pierre
   * dos end of line problem

  Revision 1.2  1998/12/23 12:40:48  daniel
  * Added begin to globtype and version to avoid empty object files.
  * Fileexists no longer finds volume labels.

  Revision 1.1  1998/12/11 00:05:27  peter
    * splitted from globals.pas

}

