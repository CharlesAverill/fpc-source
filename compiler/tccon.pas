{
    $Id$
    Copyright (c) 1993-98 by Florian Klaempfl

    Type checking and register allocation for constants

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
unit tccon;
interface

    uses
      tree;

    procedure firstrealconst(var p : ptree);
    procedure firstfixconst(var p : ptree);
    procedure firstordconst(var p : ptree);
    procedure firststringconst(var p : ptree);
    procedure firstsetconst(var p : ptree);
    procedure firstniln(var p : ptree);


implementation

    uses
      cobjects,verbose,globals,systems,
      symtable,aasm,types,
      hcodegen,pass_1
{$ifdef i386}
      ,i386base
{$endif}
{$ifdef m68k}
      ,m68k
{$endif}
      ;

{*****************************************************************************
                             FirstRealConst
*****************************************************************************}

    procedure firstrealconst(var p : ptree);
      begin
         p^.location.loc:=LOC_MEM;
      end;


{*****************************************************************************
                             FirstFixConst
*****************************************************************************}

    procedure firstfixconst(var p : ptree);
      begin
         p^.location.loc:=LOC_MEM;
      end;


{*****************************************************************************
                             FirstOrdConst
*****************************************************************************}

    procedure firstordconst(var p : ptree);
      begin
         p^.location.loc:=LOC_MEM;
      end;


{*****************************************************************************
                            FirstStringConst
*****************************************************************************}

    procedure firststringconst(var p : ptree);
      begin
{        if cs_ansistrings in aktlocalswitches then
          p^.resulttype:=cansistringdef
         else
          p^.resulttype:=cshortstringdef; }
        case p^.stringtype of
          st_shortstring :
            p^.resulttype:=cshortstringdef;
          st_ansistring :
            p^.resulttype:=cansistringdef;
          st_widestring :
            p^.resulttype:=cwidestringdef;
          st_longstring :
            p^.resulttype:=clongstringdef;
        end;
        p^.location.loc:=LOC_MEM;
      end;


{*****************************************************************************
                           FirstSetConst
*****************************************************************************}

    procedure firstsetconst(var p : ptree);
      begin
         p^.location.loc:=LOC_MEM;
      end;


{*****************************************************************************
                              FirstNilN
*****************************************************************************}

    procedure firstniln(var p : ptree);
      begin
        p^.resulttype:=voidpointerdef;
        p^.location.loc:=LOC_MEM;
      end;


end.
{
  $Log$
  Revision 1.6  1999-05-27 19:45:16  peter
    * removed oldasm
    * plabel -> pasmlabel
    * -a switches to source writing automaticly
    * assembler readers OOPed
    * asmsymbol automaticly external
    * jumptables and other label fixes for asm readers

  Revision 1.5  1999/05/01 13:24:50  peter
    * merged nasm compiler
    * old asm moved to oldasm/

  Revision 1.4  1999/02/22 02:15:47  peter
    * updates for ag386bin

  Revision 1.3  1998/11/17 00:36:48  peter
    * more ansistring fixes

  Revision 1.2  1998/11/05 12:03:04  peter
    * released useansistring
    * removed -Sv, its now available in fpc modes

  Revision 1.1  1998/09/23 20:42:24  peter
    * splitted pass_1

}
