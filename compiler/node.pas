{
    $Id$
    Copyright (c) 2000-2002 by Florian Klaempfl

    Basic node handling

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
unit node;

{$i fpcdefs.inc}

interface

    uses
       cclasses,
       globtype,globals,
       cpubase,cgbase,cgutils,
       aasmbase,
       symtype;

    type
       pconstset = ^tconstset;
       tconstset = set of 0..255;

       tnodetype = (
          emptynode,        {No node (returns nil when loading from ppu)}
          addn,             {Represents the + operator}
          muln,             {Represents the * operator}
          subn,             {Represents the - operator}
          divn,             {Represents the div operator}
          symdifn,          {Represents the >< operator}
          modn,             {Represents the mod operator}
          assignn,          {Represents an assignment}
          loadn,            {Represents the use of a variabele}
          rangen,           {Represents a range (i.e. 0..9)}
          ltn,              {Represents the < operator}
          lten,             {Represents the <= operator}
          gtn,              {Represents the > operator}
          gten,             {Represents the >= operator}
          equaln,           {Represents the = operator}
          unequaln,         {Represents the <> operator}
          inn,              {Represents the in operator}
          orn,              {Represents the or operator}
          xorn,             {Represents the xor operator}
          shrn,             {Represents the shr operator}
          shln,             {Represents the shl operator}
          slashn,           {Represents the / operator}
          andn,             {Represents the and operator}
          subscriptn,       {Field in a record/object}
          derefn,           {Dereferences a pointer}
          addrn,            {Represents the @ operator}
          ordconstn,        {Represents an ordinal value}
          typeconvn,        {Represents type-conversion/typecast}
          calln,            {Represents a call node}
          callparan,        {Represents a parameter}
          realconstn,       {Represents a real value}
          unaryminusn,      {Represents a sign change (i.e. -2)}
          asmn,             {Represents an assembler node }
          vecn,             {Represents array indexing}
          pointerconstn,    {Represents a pointer constant}
          stringconstn,     {Represents a string constant}
          notn,             {Represents the not operator}
          inlinen,          {Internal procedures (i.e. writeln)}
          niln,             {Represents the nil pointer}
          errorn,           {This part of the tree could not be
                             parsed because of a compiler error}
          typen,            {A type name. Used for i.e. typeof(obj)}
          setelementn,      {A set element(s) (i.e. [a,b] and also [a..b])}
          setconstn,        {A set constant (i.e. [1,2])}
          blockn,           {A block of statements}
          statementn,       {One statement in a block of nodes}
          ifn,              {An if statement}
          breakn,           {A break statement}
          continuen,        {A continue statement}
          whilerepeatn,     {A while or repeat statement}
          forn,             {A for loop}
          exitn,            {An exit statement}
          withn,            {A with statement}
          casen,            {A case statement}
          labeln,           {A label}
          goton,            {A goto statement}
          tryexceptn,       {A try except block}
          raisen,           {A raise statement}
          tryfinallyn,      {A try finally statement}
          onn,              {For an on statement in exception code}
          isn,              {Represents the is operator}
          asn,              {Represents the as typecast}
          caretn,           {Represents the ^ operator}
          starstarn,        {Represents the ** operator exponentiation }
          arrayconstructorn, {Construction node for [...] parsing}
          arrayconstructorrangen, {Range element to allow sets in array construction tree}
          tempcreaten,      { for temps in the result/firstpass }
          temprefn,         { references to temps }
          tempdeleten,      { for temps in the result/firstpass }
          addoptn,          { added for optimizations where we cannot suppress }
          nothingn,         {NOP, Do nothing}
          loadvmtaddrn,         {Load the address of the VMT of a class/object}
          guidconstn,       {A GUID COM Interface constant }
          rttin,             {Rtti information so they can be accessed in result/firstpass}
          loadparentfpn  { Load the framepointer of the parent for nested procedures }
       );

      const
        nodetype2str : array[tnodetype] of string[24] = (
          '<emptynode>',
          'addn',
          'muln',
          'subn',
          'divn',
          'symdifn',
          'modn',
          'assignn',
          'loadn',
          'rangen',
          'ltn',
          'lten',
          'gtn',
          'gten',
          'equaln',
          'unequaln',
          'inn',
          'orn',
          'xorn',
          'shrn',
          'shln',
          'slashn',
          'andn',
          'subscriptn',
          'derefn',
          'addrn',
          'ordconstn',
          'typeconvn',
          'calln',
          'callparan',
          'realconstn',
          'unaryminusn',
          'asmn',
          'vecn',
          'pointerconstn',
          'stringconstn',
          'notn',
          'inlinen',
          'niln',
          'errorn',
          'typen',
          'setelementn',
          'setconstn',
          'blockn',
          'statementn',
          'ifn',
          'breakn',
          'continuen',
          'whilerepeatn',
          'forn',
          'exitn',
          'withn',
          'casen',
          'labeln',
          'goton',
          'tryexceptn',
          'raisen',
          'tryfinallyn',
          'onn',
          'isn',
          'asn',
          'caretn',
          'starstarn',
          'arrayconstructn',
          'arrayconstructrangen',
          'tempcreaten',
          'temprefn',
          'tempdeleten',
          'addoptn',
          'nothingn',
          'loadvmtaddrn',
          'guidconstn',
          'rttin',
          'loadparentfpn');

    type
       { all boolean field of ttree are now collected in flags }
       tnodeflag = (
         nf_swapable,    { tbinop operands can be swaped }
         nf_swaped,      { tbinop operands are swaped    }
         nf_error,

         { general }
         nf_pass1_done,
         nf_write,       { Node is written to            }
         nf_isproperty,

         { taddrnode }
         nf_procvarload,
         nf_typedaddr,

         { tderefnode }
         nf_no_checkpointer,

         { tvecnode }
         nf_memindex,
         nf_memseg,
         nf_callunique,

         { tloadnode }
         nf_absolute,
         nf_load_self_pointer,

         { taddnode }
         nf_is_currency,
         nf_has_pointerdiv,

         { tassignmentnode }
         nf_concat_string,
         nf_use_strconcat,

         { tarrayconstructnode }
         nf_forcevaria,
         nf_novariaallowed,

         { ttypeconvnode }
         nf_explicit,
         nf_internal,  { no warnings/hints generated }

         { tinlinenode }
         nf_inlineconst,

         { tasmnode }
         nf_get_asm_position
       );

       tnodeflags = set of tnodeflag;

    const
       { contains the flags which must be equal for the equality }
       { of nodes                                                }
       flagsequal : tnodeflags = [nf_error];

    type
       tnodelist = class
       end;

       { later (for the newcg) tnode will inherit from tlinkedlist_item }
       tnode = class
       public
          { type of this node }
          nodetype : tnodetype;
          { type of the current code block, general/const/type }
          blocktype : tblock_type;
          { expected location of the result of this node (pass1) }
          expectloc : tcgloc;
          { the location of the result of this node (pass2) }
          location : tlocation;
          { the parent node of this is node    }
          { this field is set by concattolist  }
          parent : tnode;
          { there are some properties about the node stored }
          flags : tnodeflags;
          ppuidx : longint;
          { the number of registers needed to evalute the node }
          registersint,registersfpu,registersmm : longint;  { must be longint !!!! }
{$ifdef SUPPORT_MMX}
          registersmmx : longint;
{$endif SUPPORT_MMX}
          resulttype : ttype;
          fileinfo : tfileposinfo;
          localswitches : tlocalswitches;
{$ifdef extdebug}
          maxfirstpasscount,
          firstpasscount : longint;
{$endif extdebug}
          constructor create(t:tnodetype);
          { this constructor is only for creating copies of class }
          { the fields are copied by getcopy                      }
          constructor createforcopy;
          constructor ppuload(t:tnodetype;ppufile:tcompilerppufile);virtual;
          destructor destroy;override;
          procedure ppuwrite(ppufile:tcompilerppufile);virtual;
          procedure buildderefimpl;virtual;
          procedure derefimpl;virtual;
          procedure derefnode;virtual;

          { toggles the flag }
          procedure toggleflag(f : tnodeflag);

          { the 1.1 code generator may override pass_1 }
          { and it need not to implement det_* then    }
          { 1.1: pass_1 returns a value<>0 if the node has been transformed }
          { 2.0: runs det_resulttype and det_temp                           }
          function pass_1 : tnode;virtual;abstract;
          { dermines the resulttype of the node }
          function det_resulttype : tnode;virtual;abstract;
          { dermines the number of necessary temp. locations to evaluate
            the node }
{$ifdef state_tracking}
          { Does optimizations by keeping track of the variable states
            in a procedure }
          function track_state_pass(exec_known:boolean):boolean;virtual;
{$endif}
          { For a t1:=t2 tree, mark the part of the tree t1 that gets
            written to (normally the loadnode) as write access. }
          procedure mark_write;virtual;
          procedure det_temp;virtual;abstract;

          procedure pass_2;virtual;abstract;

          { comparing of nodes }
          function isequal(p : tnode) : boolean;
          { to implement comparisation, override this method }
          function docompare(p : tnode) : boolean;virtual;
          { gets a copy of the node }
          function getcopy : tnode;virtual;

          procedure insertintolist(l : tnodelist);virtual;
          { writes a node for debugging purpose, shouldn't be called }
          { direct, because there is no test for nil, use printnode  }
          { to write a complete tree }
          procedure printnodeinfo(var t:text);
          procedure printnodedata(var t:text);virtual;
          procedure printnodetree(var t:text);virtual;
          procedure concattolist(l : tlinkedlist);virtual;
          function ischild(p : tnode) : boolean;virtual;
          procedure set_file_line(from : tnode);
          procedure set_tree_filepos(const filepos : tfileposinfo);
       end;

       tnodeclass = class of tnode;

       tnodeclassarray = array[tnodetype] of tnodeclass;

       { this node is the anchestor for all nodes with at least   }
       { one child, you have to use it if you want to use         }
       { true- and falselabel                                     }
       punarynode = ^tunarynode;
       tunarynode = class(tnode)
          left : tnode;
          constructor create(t:tnodetype;l : tnode);
          constructor ppuload(t:tnodetype;ppufile:tcompilerppufile);override;
          destructor destroy;override;
          procedure ppuwrite(ppufile:tcompilerppufile);override;
          procedure buildderefimpl;override;
          procedure derefimpl;override;
          procedure derefnode;override;
          procedure concattolist(l : tlinkedlist);override;
          function ischild(p : tnode) : boolean;override;
          function docompare(p : tnode) : boolean;override;
          function getcopy : tnode;override;
          procedure insertintolist(l : tnodelist);override;
          procedure left_max;
          procedure printnodedata(var t:text);override;
       end;

       pbinarynode = ^tbinarynode;
       tbinarynode = class(tunarynode)
          right : tnode;
          constructor create(t:tnodetype;l,r : tnode);
          constructor ppuload(t:tnodetype;ppufile:tcompilerppufile);override;
          destructor destroy;override;
          procedure ppuwrite(ppufile:tcompilerppufile);override;
          procedure buildderefimpl;override;
          procedure derefimpl;override;
          procedure derefnode;override;
          procedure concattolist(l : tlinkedlist);override;
          function ischild(p : tnode) : boolean;override;
          function docompare(p : tnode) : boolean;override;
          procedure swapleftright;
          function getcopy : tnode;override;
          procedure insertintolist(l : tnodelist);override;
          procedure left_right_max;
          procedure printnodedata(var t:text);override;
          procedure printnodelist(var t:text);
       end;

       tbinopnode = class(tbinarynode)
          constructor create(t:tnodetype;l,r : tnode);virtual;
          function docompare(p : tnode) : boolean;override;
       end;

    var
      { array with all class types for tnodes }
      nodeclass : tnodeclassarray;

    function nodeppuidxget(i:longint):tnode;
    function ppuloadnode(ppufile:tcompilerppufile):tnode;
    procedure ppuwritenode(ppufile:tcompilerppufile;n:tnode);
    function ppuloadnodetree(ppufile:tcompilerppufile):tnode;
    procedure ppuwritenodetree(ppufile:tcompilerppufile;n:tnode);

    const
      printnodespacing = '   ';
    var
      { indention used when writing the tree to the screen }
      printnodeindention : string;

    procedure printnodeindent;
    procedure printnodeunindent;
    procedure printnode(var t:text;n:tnode);

    function is_constnode(p : tnode) : boolean;
    function is_constintnode(p : tnode) : boolean;
    function is_constcharnode(p : tnode) : boolean;
    function is_constrealnode(p : tnode) : boolean;
    function is_constboolnode(p : tnode) : boolean;
    function is_constenumnode(p : tnode) : boolean;
    function is_constwidecharnode(p : tnode) : boolean;


implementation

    uses
       cutils,verbose,ppu,
       symconst,
       defutil;

    const
      ppunodemarker = 255;


{****************************************************************************
                                 Helpers
 ****************************************************************************}

    var
      nodeppudata : tdynamicarray;
      nodeppuidx  : longint;


    procedure nodeppuidxcreate;
      begin
        nodeppudata:=tdynamicarray.create(1024);
        nodeppuidx:=0;
      end;


    procedure nodeppuidxfree;
      begin
        nodeppudata.free;
        nodeppudata:=nil;
      end;


    procedure nodeppuidxadd(n:tnode);
      begin
        if n.ppuidx<0 then
          internalerror(200311072);
        nodeppudata.seek(n.ppuidx*sizeof(pointer));
        nodeppudata.write(n,sizeof(pointer));
      end;


    function nodeppuidxget(i:longint):tnode;
      var
        l : longint;
      begin
        if i<0 then
          internalerror(200311072);
        nodeppudata.seek(i*sizeof(pointer));
        if nodeppudata.read(result,sizeof(pointer))<>sizeof(pointer) then
          internalerror(200311073);
      end;


    function ppuloadnode(ppufile:tcompilerppufile):tnode;
      var
        b : byte;
        t : tnodetype;
        hppuidx : longint;
      begin
        { marker }
        b:=ppufile.getbyte;
        if b<>ppunodemarker then
          internalerror(200208151);
        { load nodetype }
        t:=tnodetype(ppufile.getbyte);
        if t>high(tnodetype) then
          internalerror(200208152);
        if t<>emptynode then
         begin
           if not assigned(nodeclass[t]) then
             internalerror(200208153);
           hppuidx:=ppufile.getlongint;
           //writeln('load: ',nodetype2str[t]);
           { generate node of the correct class }
           result:=nodeclass[t].ppuload(t,ppufile);
           result.ppuidx:=hppuidx;
           nodeppuidxadd(result);
         end
        else
         result:=nil;
      end;


    procedure ppuwritenode(ppufile:tcompilerppufile;n:tnode);
      begin
        { marker, read by ppuloadnode }
        ppufile.putbyte(ppunodemarker);
        { type, read by ppuloadnode }
        if assigned(n) then
         begin
           if n.ppuidx=-1 then
             internalerror(200311071);
           n.ppuidx:=nodeppuidx;
           inc(nodeppuidx);
           ppufile.putbyte(byte(n.nodetype));
           ppufile.putlongint(n.ppuidx);
           //writeln('write: ',nodetype2str[n.nodetype]);
           n.ppuwrite(ppufile);
         end
        else
         ppufile.putbyte(byte(emptynode));
      end;


    function ppuloadnodetree(ppufile:tcompilerppufile):tnode;
      begin
        if ppufile.readentry<>ibnodetree then
          Message(unit_f_ppu_read_error);
        nodeppuidxcreate;
        result:=ppuloadnode(ppufile);
        result.derefnode;
        nodeppuidxfree;
      end;


    procedure ppuwritenodetree(ppufile:tcompilerppufile;n:tnode);
      begin
        nodeppuidx:=0;
        ppuwritenode(ppufile,n);
        ppufile.writeentry(ibnodetree);
      end;


    procedure printnodeindent;
      begin
        printnodeindention:=printnodeindention+printnodespacing;
      end;


    procedure printnodeunindent;
      begin
        delete(printnodeindention,1,length(printnodespacing));
      end;


    procedure printnode(var t:text;n:tnode);
      begin
        if assigned(n) then
         n.printnodetree(t)
        else
         writeln(t,printnodeindention,'nil');
      end;


    function is_constnode(p : tnode) : boolean;
      begin
        is_constnode:=(p.nodetype in [niln,ordconstn,realconstn,stringconstn,setconstn,guidconstn]);
      end;


    function is_constintnode(p : tnode) : boolean;
      begin
         is_constintnode:=(p.nodetype=ordconstn) and is_integer(p.resulttype.def);
      end;


    function is_constcharnode(p : tnode) : boolean;
      begin
         is_constcharnode:=(p.nodetype=ordconstn) and is_char(p.resulttype.def);
      end;


    function is_constwidecharnode(p : tnode) : boolean;
      begin
         is_constwidecharnode:=(p.nodetype=ordconstn) and is_widechar(p.resulttype.def);
      end;


    function is_constrealnode(p : tnode) : boolean;
      begin
         is_constrealnode:=(p.nodetype=realconstn);
      end;


    function is_constboolnode(p : tnode) : boolean;
      begin
         is_constboolnode:=(p.nodetype=ordconstn) and is_boolean(p.resulttype.def);
      end;


    function is_constenumnode(p : tnode) : boolean;
      begin
         is_constenumnode:=(p.nodetype=ordconstn) and (p.resulttype.def.deftype=enumdef);
      end;

{****************************************************************************
                                 TNODE
 ****************************************************************************}

    constructor tnode.create(t:tnodetype);

      begin
         inherited create;
         nodetype:=t;
         blocktype:=block_type;
         { updated by firstpass }
         expectloc:=LOC_INVALID;
         { updated by secondpass }
         location.loc:=LOC_INVALID;
         { save local info }
         fileinfo:=aktfilepos;
         localswitches:=aktlocalswitches;
         resulttype.reset;
         registersint:=0;
         registersfpu:=0;
{$ifdef SUPPORT_MMX}
         registersmmx:=0;
{$endif SUPPORT_MMX}
{$ifdef EXTDEBUG}
         maxfirstpasscount:=0;
         firstpasscount:=0;
{$endif EXTDEBUG}
         flags:=[];
         ppuidx:=-1;
      end;

    constructor tnode.createforcopy;

      begin
      end;

    constructor tnode.ppuload(t:tnodetype;ppufile:tcompilerppufile);

      begin
        nodetype:=t;
        { tnode fields }
        blocktype:=tblock_type(ppufile.getbyte);
        ppufile.getposinfo(fileinfo);
        ppufile.getsmallset(localswitches);
        ppufile.gettype(resulttype);
        ppufile.getsmallset(flags);
        { updated by firstpass }
        expectloc:=LOC_INVALID;
        { updated by secondpass }
        location.loc:=LOC_INVALID;
        registersint:=0;
        registersfpu:=0;
{$ifdef SUPPORT_MMX}
        registersmmx:=0;
{$endif SUPPORT_MMX}
{$ifdef EXTDEBUG}
        maxfirstpasscount:=0;
        firstpasscount:=0;
{$endif EXTDEBUG}
        ppuidx:=-1;
      end;


    procedure tnode.ppuwrite(ppufile:tcompilerppufile);
      begin
        ppufile.putbyte(byte(block_type));
        ppufile.putposinfo(fileinfo);
        ppufile.putsmallset(localswitches);
        ppufile.puttype(resulttype);
        ppufile.putsmallset(flags);
      end;


    procedure tnode.buildderefimpl;
      begin
        resulttype.buildderef;
      end;


    procedure tnode.derefimpl;
      begin
        resulttype.resolve;
      end;


    procedure tnode.derefnode;
      begin
      end;


    procedure tnode.toggleflag(f : tnodeflag);
      begin
         if f in flags then
           exclude(flags,f)
         else
           include(flags,f);
      end;


    destructor tnode.destroy;
      begin
{$ifdef EXTDEBUG}
         if firstpasscount>maxfirstpasscount then
            maxfirstpasscount:=firstpasscount;
{$endif EXTDEBUG}
      end;


    procedure tnode.concattolist(l : tlinkedlist);
      begin
      end;


    function tnode.ischild(p : tnode) : boolean;
      begin
         ischild:=false;
      end;


    procedure tnode.mark_write;
      begin
{$ifdef EXTDEBUG}
        Comment(V_Warning,'mark_write not implemented for '+nodetype2str[nodetype]);
{$endif EXTDEBUG}
      end;


    procedure tnode.printnodeinfo(var t:text);
      begin
        write(t,nodetype2str[nodetype]);
        if assigned(resulttype.def) then
          write(t,', resulttype = "',resulttype.def.gettypename,'"')
        else
          write(t,', resulttype = <nil>');
        writeln(t,', pos = (',fileinfo.line,',',fileinfo.column,')',
                  ', loc = ',tcgloc2str[location.loc],
                  ', expectloc = ',tcgloc2str[expectloc],
                  ', intregs = ',registersint,
                  ', fpuregs = ',registersfpu);
      end;


    procedure tnode.printnodedata(var t:text);
      begin
      end;


    procedure tnode.printnodetree(var t:text);
      begin
         write(t,printnodeindention,'(');
         printnodeinfo(t);
         printnodeindent;
         printnodedata(t);
         printnodeunindent;
         writeln(t,printnodeindention,')');
      end;


    function tnode.isequal(p : tnode) : boolean;
      begin
         isequal:=
           (not assigned(self) and not assigned(p)) or
           (assigned(self) and assigned(p) and
            { optimized subclasses have the same nodetype as their        }
            { superclass (for compatibility), so also check the classtype (JM) }
            (p.classtype=classtype) and
            (p.nodetype=nodetype) and
            (flags*flagsequal=p.flags*flagsequal) and
            docompare(p));
      end;

{$ifdef state_tracking}
    function Tnode.track_state_pass(exec_known:boolean):boolean;
      begin
        track_state_pass:=false;
      end;
{$endif state_tracking}


    function tnode.docompare(p : tnode) : boolean;
      begin
         docompare:=true;
      end;


    function tnode.getcopy : tnode;
      var
         p : tnode;
      begin
         { this is quite tricky because we need a node of the current }
         { node type and not one of tnode!                            }
         p:=tnodeclass(classtype).createforcopy;
         p.nodetype:=nodetype;
         p.expectloc:=expectloc;
         p.location:=location;
         p.parent:=parent;
         p.flags:=flags;
         p.registersint:=registersint;
         p.registersfpu:=registersfpu;
{$ifdef SUPPORT_MMX}
         p.registersmmx:=registersmmx;
         p.registerskni:=registerskni;
{$endif SUPPORT_MMX}
         p.resulttype:=resulttype;
         p.fileinfo:=fileinfo;
         p.localswitches:=localswitches;
{$ifdef extdebug}
         p.firstpasscount:=firstpasscount;
{$endif extdebug}
{         p.list:=list; }
         getcopy:=p;
      end;


    procedure tnode.insertintolist(l : tnodelist);
      begin
      end;


    procedure tnode.set_file_line(from : tnode);
      begin
         if assigned(from) then
           fileinfo:=from.fileinfo;
      end;


    procedure tnode.set_tree_filepos(const filepos : tfileposinfo);
      begin
         fileinfo:=filepos;
      end;


{****************************************************************************
                                 TUNARYNODE
 ****************************************************************************}

    constructor tunarynode.create(t:tnodetype;l : tnode);
      begin
         inherited create(t);
         left:=l;
      end;


    constructor tunarynode.ppuload(t:tnodetype;ppufile:tcompilerppufile);
      begin
        inherited ppuload(t,ppufile);
        left:=ppuloadnode(ppufile);
      end;


    destructor tunarynode.destroy;
      begin
        left.free;
        inherited destroy;
      end;


    procedure tunarynode.ppuwrite(ppufile:tcompilerppufile);
      begin
        inherited ppuwrite(ppufile);
        ppuwritenode(ppufile,left);
      end;


    procedure tunarynode.buildderefimpl;
      begin
        inherited buildderefimpl;
        if assigned(left) then
          left.buildderefimpl;
      end;


    procedure tunarynode.derefimpl;
      begin
        inherited derefimpl;
        if assigned(left) then
          left.derefimpl;
      end;


    procedure tunarynode.derefnode;
      begin
        inherited derefnode;
        if assigned(left) then
          left.derefnode;
      end;


    function tunarynode.docompare(p : tnode) : boolean;
      begin
         docompare:=(inherited docompare(p) and
           ((left=nil) or left.isequal(tunarynode(p).left))
         );
      end;


    function tunarynode.getcopy : tnode;
      var
         p : tunarynode;
      begin
         p:=tunarynode(inherited getcopy);
         if assigned(left) then
           p.left:=left.getcopy
         else
           p.left:=nil;
         getcopy:=p;
      end;


    procedure tunarynode.insertintolist(l : tnodelist);
      begin
      end;


    procedure tunarynode.printnodedata(var t:text);
      begin
         inherited printnodedata(t);
         printnode(t,left);
      end;


    procedure tunarynode.left_max;
      begin
         registersint:=left.registersint;
         registersfpu:=left.registersfpu;
{$ifdef SUPPORT_MMX}
         registersmmx:=left.registersmmx;
{$endif SUPPORT_MMX}
      end;


    procedure tunarynode.concattolist(l : tlinkedlist);
      begin
         left.parent:=self;
         left.concattolist(l);
         inherited concattolist(l);
      end;


    function tunarynode.ischild(p : tnode) : boolean;
      begin
         ischild:=p=left;
      end;


{****************************************************************************
                            TBINARYNODE
 ****************************************************************************}

    constructor tbinarynode.create(t:tnodetype;l,r : tnode);
      begin
         inherited create(t,l);
         right:=r
      end;


    constructor tbinarynode.ppuload(t:tnodetype;ppufile:tcompilerppufile);
      begin
        inherited ppuload(t,ppufile);
        right:=ppuloadnode(ppufile);
      end;


    destructor tbinarynode.destroy;
      begin
        right.free;
        inherited destroy;
      end;


    procedure tbinarynode.ppuwrite(ppufile:tcompilerppufile);
      begin
        inherited ppuwrite(ppufile);
        ppuwritenode(ppufile,right);
      end;


    procedure tbinarynode.buildderefimpl;
      begin
        inherited buildderefimpl;
        if assigned(right) then
          right.buildderefimpl;
      end;


    procedure tbinarynode.derefimpl;
      begin
        inherited derefimpl;
        if assigned(right) then
          right.derefimpl;
      end;


    procedure tbinarynode.derefnode;
      begin
        inherited derefnode;
        if assigned(right) then
          right.derefnode;
      end;


    procedure tbinarynode.concattolist(l : tlinkedlist);
      begin
         { we could change that depending on the number of }
         { required registers                              }
         left.parent:=self;
         left.concattolist(l);
         left.parent:=self;
         left.concattolist(l);
         inherited concattolist(l);
      end;


    function tbinarynode.ischild(p : tnode) : boolean;
      begin
         ischild:=(p=right);
      end;


    function tbinarynode.docompare(p : tnode) : boolean;
      begin
         docompare:=(inherited docompare(p) and
             ((right=nil) or right.isequal(tbinarynode(p).right))
         );
      end;


    function tbinarynode.getcopy : tnode;
      var
         p : tbinarynode;
      begin
         p:=tbinarynode(inherited getcopy);
         if assigned(right) then
           p.right:=right.getcopy
         else
           p.right:=nil;
         getcopy:=p;
      end;


    procedure tbinarynode.insertintolist(l : tnodelist);
      begin
      end;


    procedure tbinarynode.swapleftright;
      var
         swapp : tnode;
      begin
         swapp:=right;
         right:=left;
         left:=swapp;
         if nf_swaped in flags then
           exclude(flags,nf_swaped)
         else
           include(flags,nf_swaped);
      end;


    procedure tbinarynode.left_right_max;
      begin
        if assigned(left) then
         begin
           if assigned(right) then
            begin
              registersint:=max(left.registersint,right.registersint);
              registersfpu:=max(left.registersfpu,right.registersfpu);
{$ifdef SUPPORT_MMX}
              registersmmx:=max(left.registersmmx,right.registersmmx);
{$endif SUPPORT_MMX}
            end
           else
            begin
              registersint:=left.registersint;
              registersfpu:=left.registersfpu;
{$ifdef SUPPORT_MMX}
              registersmmx:=left.registersmmx;
{$endif SUPPORT_MMX}
            end;
         end;
      end;


    procedure tbinarynode.printnodedata(var t:text);
      begin
         inherited printnodedata(t);
         printnode(t,right);
      end;


    procedure tbinarynode.printnodelist(var t:text);
      var
        hp : tbinarynode;
      begin
        hp:=self;
        while assigned(hp) do
         begin
           write(t,printnodeindention,'(');
           printnodeindent;
           hp.printnodeinfo(t);
           printnode(t,hp.left);
           printnodeunindent;
           writeln(t,printnodeindention,')');
           hp:=tbinarynode(hp.right);
         end;
      end;


{****************************************************************************
                            TBINOPYNODE
 ****************************************************************************}

    constructor tbinopnode.create(t:tnodetype;l,r : tnode);
      begin
         inherited create(t,l,r);
      end;


    function tbinopnode.docompare(p : tnode) : boolean;
      begin
         docompare:=(inherited docompare(p)) or
           { if that's in the flags, is p then always a tbinopnode (?) (JM) }
           ((nf_swapable in flags) and
            left.isequal(tbinopnode(p).right) and
            right.isequal(tbinopnode(p).left));
      end;

end.
{
  $Log$
  Revision 1.90  2004-11-02 12:55:16  peter
    * nf_internal flag for internal inserted typeconvs. This will
      supress the generation of warning/hints

  Revision 1.89  2004/11/01 17:15:47  peter
    * no checkpointer code for dynarr to openarr

  Revision 1.88  2004/10/31 21:45:03  peter
    * generic tlocation
    * move tlocation to cgutils

  Revision 1.87  2004/06/20 08:55:29  florian
    * logs truncated

  Revision 1.86  2004/06/16 20:07:09  florian
    * dwarf branch merged

  Revision 1.85  2004/05/24 20:39:41  florian
    * stricter handling of formal const parameters and IE fixed

  Revision 1.84  2004/05/23 18:28:41  peter
    * methodpointer is loaded into a temp when it was a calln

  Revision 1.83  2004/05/23 15:06:21  peter
    * implicit_finally flag must be set in pass1
    * add check whether the implicit frame is generated when expected

  Revision 1.82  2004/05/20 21:54:33  florian
    + <pointer> - <pointer> result is divided by the pointer element size now
      this is delphi compatible as well as resulting in the expected result for p1+(p2-p1)

}
