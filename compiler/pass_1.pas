{
    $Id$
    Copyright (c) 1998-2000 by Florian Klaempfl

    This unit handles the typecheck and node conversion pass

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
unit pass_1;

{$i defines.inc}

interface

    uses
       node;

    var
      resulttypepasscnt,
      multiresulttypepasscnt : longint;

    procedure resulttypepass(var p : tnode);
    function  do_resulttypepass(var p : tnode) : boolean;

    procedure firstpass(var p : tnode);
    function  do_firstpass(var p : tnode) : boolean;

    var
       { the block node of the current exception block to check gotos }
       aktexceptblock : tnode;

implementation

    uses
      globtype,systems,
      cutils,globals,
      hcodegen,symdef,
{$ifdef extdebug}
      verbose,
      htypechk,
{$endif extdebug}
      tgcpu
{$ifdef newcg}
      ,cgbase
{$endif}
      ;

{*****************************************************************************
                            Global procedures
*****************************************************************************}

    procedure resulttypepass(var p : tnode);
      var
         oldcodegenerror  : boolean;
         oldlocalswitches : tlocalswitches;
         oldpos    : tfileposinfo;
         hp        : tnode;
      begin
        inc(resulttypepasscnt);
        if (p.resulttype.def=nil) then
         begin
           oldcodegenerror:=codegenerror;
           oldpos:=aktfilepos;
           oldlocalswitches:=aktlocalswitches;
           codegenerror:=false;
           aktfilepos:=p.fileinfo;
           aktlocalswitches:=p.localswitches;
           hp:=p.det_resulttype;
           { should the node be replaced? }
           if assigned(hp) then
            begin
               p.free;
               p:=hp;
            end;
           aktlocalswitches:=oldlocalswitches;
           aktfilepos:=oldpos;
           if codegenerror then
            begin
              include(p.flags,nf_error);
              { default to errortype if no type is set yet }
              if p.resulttype.def=nil then
               p.resulttype:=generrortype;
            end;
           codegenerror:=codegenerror or oldcodegenerror;
         end
        else
         inc(multiresulttypepasscnt);
      end;


    function do_resulttypepass(var p : tnode) : boolean;
      begin
         aktexceptblock:=nil;
         codegenerror:=false;
         resulttypepass(p);
         do_resulttypepass:=codegenerror;
      end;


    procedure firstpass(var p : tnode);
      var
         oldcodegenerror  : boolean;
         oldlocalswitches : tlocalswitches;
         oldpos    : tfileposinfo;
         hp : tnode;
      begin
{$ifdef extdebug}
         inc(total_of_firstpass);
         if (p.firstpasscount>0) and only_one_pass then
           exit;
{$endif extdebug}
         oldcodegenerror:=codegenerror;
         oldpos:=aktfilepos;
         oldlocalswitches:=aktlocalswitches;
{$ifdef extdebug}
         if p.firstpasscount>0 then
          inc(firstpass_several);
{$endif extdebug}
         if not(nf_error in p.flags) then
           begin
              codegenerror:=false;
              aktfilepos:=p.fileinfo;
              aktlocalswitches:=p.localswitches;
              { determine the resulttype if not done }
              if (p.resulttype.def=nil) then
               begin
                 hp:=p.det_resulttype;
                 { should the node be replaced? }
                 if assigned(hp) then
                  begin
                     p.free;
                     p:=hp;
                  end;
               end;
              { first pass }
              hp:=p.pass_1;
              { should the node be replaced? }
              if assigned(hp) then
                begin
                   p.free;
                   p:=hp;
                end;
              aktlocalswitches:=oldlocalswitches;
              aktfilepos:=oldpos;
              if codegenerror then
                include(p.flags,nf_error);
              codegenerror:=codegenerror or oldcodegenerror;
           end
         else
           codegenerror:=true;
{$ifdef extdebug}
         if count_ref then
           inc(p.firstpasscount);
{$endif extdebug}
      end;


    function do_firstpass(var p : tnode) : boolean;
      begin
         aktexceptblock:=nil;
         codegenerror:=false;
         firstpass(p);
         do_firstpass:=codegenerror;
      end;

end.
{
  $Log$
  Revision 1.13  2001-04-13 01:22:10  peter
    * symtable change to classes
    * range check generation and errors fixed, make cycle DEBUG=1 works
    * memory leaks fixed

  Revision 1.12  2001/04/02 21:20:31  peter
    * resulttype rewrite

  Revision 1.11  2000/12/18 21:56:52  peter
    * extdebug fixes

  Revision 1.10  2000/11/29 00:30:35  florian
    * unused units removed from uses clause
    * some changes for widestrings

  Revision 1.9  2000/10/14 10:14:51  peter
    * moehrendorf oct 2000 rewrite

  Revision 1.8  2000/10/01 19:48:25  peter
    * lot of compile updates for cg11

  Revision 1.7  2000/09/30 16:08:45  peter
    * more cg11 updates

  Revision 1.6  2000/09/28 19:49:52  florian
  *** empty log message ***

  Revision 1.5  2000/09/24 21:15:34  florian
    * some errors fix to get more stuff compilable

  Revision 1.4  2000/09/24 15:06:21  peter
    * use defines.inc

  Revision 1.3  2000/09/19 23:09:07  pierre
   * problems wih extdebug cond. solved

  Revision 1.2  2000/07/13 11:32:44  michael
  + removed logs

}
