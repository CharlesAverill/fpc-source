{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 1998 by Florian Klaempfl

    This unit contains some routines to get informations about the
    processor
    
    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit cpu;
  interface

    { returns true, if the processor supports the cpuid instruction }
    function cpuid_support : boolean;

    { returns true, if floating point is done by an emulator }
    function floating_point_emulation : boolean;

    { returns the contents of the cr0 register }
    function cr0 : longint;


  implementation

{$ifdef VER0_99_5}
  {$I386_INTEL}
{$endif}

{$ASMMODE INTEL}
  

    function cpuid_support : boolean;assembler;
      {
        Check if the ID-flag can be changed, if changed then CpuID is supported.
        Tested under go32v1 and Linux on c6x86 with CpuID enabled and disabled (PFV)
      }
      asm
         pushf
         pushf
         pop     eax
         mov     ebx,eax
         xor     eax,200000h
         push    eax
         popf
         pushf
         pop     eax
         popf
         and     eax,200000h
         and     ebx,200000h
         cmp     eax,ebx
         setnz   al
      end;


    function cr0 : longint;assembler;
      asm
         DB 0Fh,20h,0C0h
         { mov eax,cr0
           special registers are not allowed in the assembler
  	        parsers }
      end;


    function floating_point_emulation : boolean;
      begin
         {!!!! I don't know currently the position of the EM flag }
         { $4 after Ralf Brown's list }
         floating_point_emulation:=(cr0 and $4)<>0;
      end;

end.

{
  $Log$
  Revision 1.4  1998-08-11 00:04:46  peter
    * $ifdef ver0_99_5 updates

  Revision 1.3  1998/05/25 10:51:27  pierre
    * CR0 works now (written using DB to allow to use it we INTEL and ATT output)
    * floating_emulation bit set correctly

  Revision 1.2  1998/05/12 10:42:41  peter
    * moved getopts to inc/, all supported OS's need argc,argv exported
    + strpas, strlen are now exported in the systemunit
    * removed logs
    * removed $ifdef ver_above

}
