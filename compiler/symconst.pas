{
    $Id$
    Copyright (c) 1993-98 by Florian Klaempfl, Pierre Muller

    Symbol table constants

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
unit symconst;
interface

const
  def_alignment = 4;

type
  { symbol options }
  tsymoption=(sp_none,
    sp_public,
    sp_private,
    sp_published,
    sp_protected,
    sp_forwarddef,
    sp_static,
    sp_primary_typesym    { this is for typesym, to know who is the primary symbol of a def }
  );
  tsymoptions=set of tsymoption;

  { flags for a definition }
  tdefoption=(df_none,
    df_need_rtti,          { the definitions needs rtti }
    df_has_rtti            { the rtti is generated      }
  );
  tdefoptions=set of tdefoption;

  { base types for orddef }
  tbasetype = (
    uauto,uvoid,uchar,
    u8bit,u16bit,u32bit,
    s8bit,s16bit,s32bit,
    bool8bit,bool16bit,bool32bit,
    u64bit,s64bit
  );

  { float types }
  tfloattype = (
    s32real,s64real,s80real,
    s64comp,
    f16bit,f32bit
  );

  { string types }
  tstringtype = (
    st_shortstring, st_longstring, st_ansistring, st_widestring
  );

  { set types }
  tsettype = (
    normset,smallset,varset
  );

  { calling convention for tprocdef and tprocvardef }
  tproccalloption=(pocall_none,
    pocall_clearstack,    { Use IBM flat calling convention. (Used by GCC.) }
    pocall_leftright,     { Push parameters from left to right }
    pocall_cdecl,         { procedure uses C styled calling }
    pocall_register,      { procedure uses register (fastcall) calling }
    pocall_stdcall,       { procedure uses stdcall call }
    pocall_safecall,      { safe call calling conventions }
    pocall_palmossyscall, { procedure is a PalmOS system call }
    pocall_system,
    pocall_inline,        { Procedure is an assembler macro }
    pocall_internproc,    { Procedure has compiler magic}
    pocall_internconst    { procedure has constant evaluator intern }
  );
  tproccalloptions=set of tproccalloption;

  { basic type for tprocdef and tprocvardef }
  tproctypeoption=(potype_none,
    potype_proginit,     { Program initialization }
    potype_unitinit,     { unit initialization }
    potype_unitfinalize, { unit finalization }
    potype_constructor,  { Procedure is a constructor }
    potype_destructor,   { Procedure is a destructor }
    potype_operator      { Procedure defines an operator }
  );
  tproctypeoptions=set of tproctypeoption;

  { other options for tprocdef and tprocvardef }
  tprocoption=(po_none,
    po_classmethod,       { class method }
    po_virtualmethod,     { Procedure is a virtual method }
    po_abstractmethod,    { Procedure is an abstract method }
    po_staticmethod,      { static method }
    po_overridingmethod,  { method with override directive }
    po_methodpointer,     { method pointer, only in procvardef, also used for 'with object do' }
    po_containsself,      { self is passed explicit to the compiler }
    po_interrupt,         { Procedure is an interrupt handler }
    po_iocheck,           { IO checking should be done after a call to the procedure }
    po_assembler,         { Procedure is written in assembler }
    po_msgstr,            { method for string message handling }
    po_msgint,            { method for int message handling }
    po_exports,           { Procedure has export directive (needed for OS/2) }
    po_external,          { Procedure is external (in other object or lib)}
    po_savestdregs,       { save std regs cdecl and stdcall need that ! }
    po_saveregisters      { save all registers }
  );
  tprocoptions=set of tprocoption;

  { options for objects and classes }
  tobjectoption=(oo_none,
    oo_is_class,
    oo_is_forward,         { the class is only a forward declared yet }
    oo_has_virtual,        { the object/class has virtual methods }
    oo_has_private,
    oo_has_protected,
    oo_has_constructor,    { the object/class has a constructor }
    oo_has_destructor,     { the object/class has a destructor }
    oo_has_vmt,            { the object/class has a vmt }
    oo_has_msgstr,
    oo_has_msgint,
    oo_has_abstract,       { the object/class has an abstract method => no instances can be created }
    oo_can_have_published, { the class has rtti, i.e. you can publish properties }
    oo_cppvmt              { the object/class uses an C++ compatible }
                           { vmt, all members of the same class tree }
                           { must use then a C++ compatible vmt      }
  );
  tobjectoptions=set of tobjectoption;

  { options for properties }
  tpropertyoption=(ppo_none,
    ppo_indexed,
    ppo_defaultproperty,
    ppo_stored
  );
  tpropertyoptions=set of tpropertyoption;

  { options for variables }
  tvaroption=(vo_none,
    vo_regable,
    vo_is_C_var,
    vo_is_external,
    vo_is_dll_var,
    vo_is_thread_var,
    vo_fpuregable
  );
  tvaroptions=set of tvaroption;

  { State of the variable, if it's declared, assigned or used }
  tvarstate=(vs_none,
    vs_declared,vs_declared2,vs_assigned,vs_used
  );

const
  { relevant options for assigning a proc or a procvar to a procvar }
  po_compatibility_options = [
    po_classmethod,
    po_staticmethod,
    po_methodpointer,
    po_containsself,
    po_interrupt,
    po_iocheck,
    po_exports
  ];

implementation

end.
{
  $Log$
  Revision 1.2  1999-08-04 13:45:29  florian
    + floating point register variables !!
    * pairegalloc is now generated for register variables

  Revision 1.1  1999/08/03 22:03:14  peter
    * moved bitmask constants to sets
    * some other type/const renamings

}

