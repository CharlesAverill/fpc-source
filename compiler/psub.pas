{
    $Id$
    Copyright (c) 1998-2002 by Florian Klaempfl, Daniel Mantione

    Does the parsing and codegeneration at subroutine level

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
unit psub;

{$i fpcdefs.inc}

{$define NOOPT}

interface

    uses
      cclasses,globals,
      node,nbas,
      symdef,procinfo;

    type
      tcgprocinfo=class(tprocinfo)
        { code for the subroutine as tree }
        code : tnode;
        { positions in the tree for init/final }
        entry_asmnode,
        loadpara_asmnode,
        exitlabel_asmnode,
        init_asmnode,
        final_asmnode : tasmnode;
        { list to store the procinfo's of the nested procedures }
        nestedprocs : tlinkedlist;
        constructor create(aparent:tprocinfo);override;
        destructor  destroy;override;
        procedure generate_code;
        procedure resetprocdef;
        procedure add_to_symtablestack;
        procedure remove_from_symtablestack;
        procedure parse_body;
        procedure add_entry_exit_code;
      end;


    procedure printnode_reset;

    { reads the declaration blocks }
    procedure read_declarations(islibrary : boolean);

    { reads declarations in the interface part of a unit }
    procedure read_interface_declarations;



implementation

    uses
       { common }
       cutils,
       { global }
       globtype,tokens,verbose,comphook,
       systems,
       { aasm }
       cpubase,aasmtai,
       { symtable }
       symconst,symbase,symsym,symtype,symtable,defutil,
       paramgr,
       ppu,fmodule,
       { pass 1 }
       nutils,nld,ncal,ncon,nflw,nadd,ncnv,nmem,
       pass_1,
    {$ifdef state_tracking}
       nstate,
    {$endif state_tracking}
       { pass 2 }
{$ifndef NOPASS2}
       pass_2,
{$endif}
       { parser }
       scanner,
       pbase,pstatmnt,pdecl,pdecsub,pexports,
       { codegen }
       tgobj,cgobj,
       ncgutil,regvars
       {$ifndef NOOPT}
         {$ifdef i386}
           ,aopt386
         {$else i386}
           ,aoptcpu
         {$endif i386}
       {$endif}
       ;

{****************************************************************************
                      PROCEDURE/FUNCTION BODY PARSING
****************************************************************************}

    procedure initializevars(p:tnamedindexitem;arg:pointer);
      var
        b : tblocknode;
      begin
        if tsym(p).typ<>varsym then
         exit;
        with tvarsym(p) do
         begin
           if assigned(defaultconstsym) then
            begin
              b:=tblocknode(arg);
              b.left:=cstatementnode.create(
                        cassignmentnode.create(
                            cloadnode.create(tsym(p),tsym(p).owner),
                            cloadnode.create(defaultconstsym,defaultconstsym.owner)),
                        b.left);
            end;
         end;
      end;


    function block(islibrary : boolean) : tnode;
      begin
         { parse const,types and vars }
         read_declarations(islibrary);

         { do we have an assembler block without the po_assembler?
           we should allow this for Delphi compatibility (PFV) }
         if (token=_ASM) and (m_delphi in aktmodeswitches) then
          include(current_procinfo.procdef.procoptions,po_assembler);

         { Handle assembler block different }
         if (po_assembler in current_procinfo.procdef.procoptions) then
          begin
            block:=assembler_block;
            exit;
          end;

         {Unit initialization?.}
         if (
             assigned(current_procinfo.procdef.localst) and
             (current_procinfo.procdef.localst.symtablelevel=main_program_level) and
             (current_module.is_unit)
            ) or
            islibrary then
           begin
             if (token=_END) then
                begin
                   consume(_END);
                   { We need at least a node, else the entry/exit code is not
                     generated and thus no PASCALMAIN symbol which we need (PFV) }
                   if islibrary then
                    block:=cnothingnode.create
                   else
                    block:=nil;
                end
              else
                begin
                   if token=_INITIALIZATION then
                     begin
                        { The library init code is already called and does not
                          need to be in the initfinal table (PFV) }
                        if not islibrary then
                          current_module.flags:=current_module.flags or uf_init;
                        block:=statement_block(_INITIALIZATION);
                     end
                   else if (token=_FINALIZATION) then
                     begin
                        if (current_module.flags and uf_finalize)<>0 then
                          block:=statement_block(_FINALIZATION)
                        else
                          begin
                          { can we allow no INITIALIZATION for DLL ??
                            I think it should work PM }
                             block:=nil;
                             exit;
                          end;
                     end
                   else
                     begin
                        { The library init code is already called and does not
                          need to be in the initfinal table (PFV) }
                        if not islibrary then
                          current_module.flags:=current_module.flags or uf_init;
                        block:=statement_block(_BEGIN);
                     end;
                end;
            end
         else
            begin
               block:=statement_block(_BEGIN);
               if symtablestack.symtabletype=localsymtable then
                 symtablestack.foreach_static({$ifdef FPCPROCVAR}@{$endif}initializevars,block);
            end;
         if (current_procinfo.procdef.localst.symtablelevel=main_program_level) and
             (not current_module.is_unit) then
           begin
             { there's always a call to FPC_DO_EXIT in the main program }
             include(current_procinfo.flags,pi_do_call);
           end;
         if ([cs_check_range,cs_check_overflow] * aktlocalswitches <> []) then
           include(current_procinfo.flags,pi_do_call);
      end;


{****************************************************************************
                       PROCEDURE/FUNCTION COMPILING
****************************************************************************}

    procedure printnode_reset;
      begin
        assign(printnodefile,treelogfilename);
        {$I-}
         rewrite(printnodefile);
        {$I+}
        if ioresult<>0 then
         begin
           Comment(V_Error,'Error creating '+treelogfilename);
           exit;
         end;
        close(printnodefile);
      end;


    procedure printnode_procdef(pd:tprocdef);
      begin
        assign(printnodefile,treelogfilename);
        {$I-}
         append(printnodefile);
         if ioresult<>0 then
          rewrite(printnodefile);
        {$I+}
        if ioresult<>0 then
         begin
           Comment(V_Error,'Error creating '+treelogfilename);
           exit;
         end;
        writeln(printnodefile);
        writeln(printnodefile,'*******************************************************************************');
        writeln(printnodefile,current_procinfo.procdef.fullprocname(false));
        writeln(printnodefile,'*******************************************************************************');
        printnode(printnodefile,pd.code);
        close(printnodefile);
      end;


    function generate_bodyentry_block:tnode;
      var
        srsym        : tsym;
        para         : tcallparanode;
        newstatement : tstatementnode;
        htype        : ttype;
      begin
        result:=internalstatements(newstatement,true);

        if assigned(current_procinfo.procdef._class) then
          begin
            { a constructor needs a help procedure }
            if (current_procinfo.procdef.proctypeoption=potype_constructor) then
              begin
                if is_class(current_procinfo.procdef._class) then
                  begin
                    if (cs_implicit_exceptions in aktmoduleswitches) then
                      include(current_procinfo.flags,pi_needs_implicit_finally);
                    srsym:=search_class_member(current_procinfo.procdef._class,'NEWINSTANCE');
                    if assigned(srsym) and
                       (srsym.typ=procsym) then
                      begin
                        { if vmt<>0 then newinstance }
                        addstatement(newstatement,cifnode.create(
                            caddnode.create(unequaln,
                                load_vmt_pointer_node,
                                cnilnode.create),
                            cassignmentnode.create(
                                ctypeconvnode.create_explicit(
                                    load_self_pointer_node,
                                    voidpointertype),
                                ccallnode.create(nil,tprocsym(srsym),srsym.owner,load_vmt_pointer_node)),
                            nil));
                      end
                    else
                      internalerror(200305108);
                  end
                else
                  if is_object(current_procinfo.procdef._class) then
                    begin
                      htype.setdef(current_procinfo.procdef._class);
                      htype.setdef(tpointerdef.create(htype));
                      { parameter 3 : vmt_offset }
                      { parameter 2 : address of pointer to vmt,
                        this is required to allow setting the vmt to -1 to indicate
                        that memory was allocated }
                      { parameter 1 : self pointer }
                      para:=ccallparanode.create(
                                cordconstnode.create(current_procinfo.procdef._class.vmt_offset,s32bittype,false),
                            ccallparanode.create(
                                ctypeconvnode.create_explicit(
                                    load_vmt_pointer_node,
                                    voidpointertype),
                            ccallparanode.create(
                                ctypeconvnode.create_explicit(
                                    load_self_pointer_node,
                                    voidpointertype),
                            nil)));
                      addstatement(newstatement,cassignmentnode.create(
                          ctypeconvnode.create_explicit(
                              load_self_pointer_node,
                              voidpointertype),
                          ccallnode.createintern('fpc_help_constructor',para)));
                    end
                else
                  internalerror(200305103);
                { if self=nil then exit
                  calling fail instead of exit is useless because
                  there is nothing to dispose (PFV) }
                addstatement(newstatement,cifnode.create(
                    caddnode.create(equaln,
                        load_self_pointer_node,
                        cnilnode.create),
                    cexitnode.create(nil),
                    nil));
              end;

            { maybe call BeforeDestruction for classes }
            if (current_procinfo.procdef.proctypeoption=potype_destructor) and
               is_class(current_procinfo.procdef._class) then
              begin
                srsym:=search_class_member(current_procinfo.procdef._class,'BEFOREDESTRUCTION');
                if assigned(srsym) and
                   (srsym.typ=procsym) then
                  begin
                    { if vmt<>0 then beforedestruction }
                    addstatement(newstatement,cifnode.create(
                        caddnode.create(unequaln,
                            load_vmt_pointer_node,
                            cnilnode.create),
                        ccallnode.create(nil,tprocsym(srsym),srsym.owner,load_self_node),
                        nil));
                  end
                else
                  internalerror(200305104);
              end;
          end;
      end;


    function generate_bodyexit_block:tnode;
      var
        srsym : tsym;
        para : tcallparanode;
        newstatement : tstatementnode;
      begin
        result:=internalstatements(newstatement,true);

        if assigned(current_procinfo.procdef._class) then
          begin
            { maybe call AfterConstruction for classes }
            if (current_procinfo.procdef.proctypeoption=potype_constructor) and
               is_class(current_procinfo.procdef._class) then
              begin
                srsym:=search_class_member(current_procinfo.procdef._class,'AFTERCONSTRUCTION');
                if assigned(srsym) and
                   (srsym.typ=procsym) then
                  begin
                    { Self can be nil when fail is called }
                    { if self<>nil and vmt<>nil then afterconstruction }
                    addstatement(newstatement,cifnode.create(
                        caddnode.create(andn,
                            caddnode.create(unequaln,
                                load_self_pointer_node,
                                cnilnode.create),
                            caddnode.create(unequaln,
                                load_vmt_pointer_node,
                                cnilnode.create)),
                        ccallnode.create(nil,tprocsym(srsym),srsym.owner,load_self_node),
                        nil));
                  end
                else
                  internalerror(200305106);
              end;

            { a destructor needs a help procedure }
            if (current_procinfo.procdef.proctypeoption=potype_destructor) then
              begin
                if is_class(current_procinfo.procdef._class) then
                  begin
                    srsym:=search_class_member(current_procinfo.procdef._class,'FREEINSTANCE');
                    if assigned(srsym) and
                       (srsym.typ=procsym) then
                      begin
                        { if self<>0 and vmt=1 then freeinstance }
                        addstatement(newstatement,cifnode.create(
                            caddnode.create(andn,
                                caddnode.create(unequaln,
                                    load_self_pointer_node,
                                    cnilnode.create),
                                caddnode.create(equaln,
                                    ctypeconvnode.create(
                                        load_vmt_pointer_node,
                                        voidpointertype),
                                    cpointerconstnode.create(1,voidpointertype))),
                            ccallnode.create(nil,tprocsym(srsym),srsym.owner,load_self_node),
                            nil));
                      end
                    else
                      internalerror(200305108);
                  end
                else
                  if is_object(current_procinfo.procdef._class) then
                    begin
                      { finalize object data }
                      if current_procinfo.procdef._class.needs_inittable then
                        addstatement(newstatement,finalize_data_node(load_self_node));
                      { parameter 3 : vmt_offset }
                      { parameter 2 : pointer to vmt }
                      { parameter 1 : self pointer }
                      para:=ccallparanode.create(
                                cordconstnode.create(current_procinfo.procdef._class.vmt_offset,s32bittype,false),
                            ccallparanode.create(
                                ctypeconvnode.create_explicit(
                                    load_vmt_pointer_node,
                                    voidpointertype),
                            ccallparanode.create(
                                ctypeconvnode.create_explicit(
                                    load_self_pointer_node,
                                    voidpointertype),
                            nil)));
                      addstatement(newstatement,
                          ccallnode.createintern('fpc_help_destructor',para));
                    end
                else
                  internalerror(200305105);
              end;
          end;
      end;


    function generate_except_block:tnode;
      var
        pd : tprocdef;
        newstatement : tstatementnode;
      begin
        generate_except_block:=internalstatements(newstatement,true);

        { a constructor needs call destructor (if available) when it
          is not inherited }
        if assigned(current_procinfo.procdef._class) and
           (current_procinfo.procdef.proctypeoption=potype_constructor) then
          begin
            pd:=current_procinfo.procdef._class.searchdestructor;
            if assigned(pd) then
              begin
                { if vmt<>0 then call destructor }
                addstatement(newstatement,cifnode.create(
                    caddnode.create(unequaln,
                        load_vmt_pointer_node,
                        cnilnode.create),
                    ccallnode.create(nil,tprocsym(pd.procsym),pd.procsym.owner,load_self_node),
                    nil));
              end;
          end
        else
          begin
            { no constructor }
            { must be the return value finalized before reraising the exception? }
            if (not is_void(current_procinfo.procdef.rettype.def)) and
               (current_procinfo.procdef.rettype.def.needs_inittable) and
               (not is_class(current_procinfo.procdef.rettype.def)) then
              addstatement(newstatement,finalize_data_node(load_result_node));
          end;
      end;


{****************************************************************************
                                  TCGProcInfo
****************************************************************************}

    constructor tcgprocinfo.create(aparent:tprocinfo);
      begin
        inherited Create(aparent);
        nestedprocs:=tlinkedlist.create;
      end;


     destructor tcgprocinfo.destroy;
       begin
         nestedprocs.free;
         if assigned(code) then
           code.free;
         inherited destroy;
       end;


    procedure tcgprocinfo.add_entry_exit_code;
      var
        finalcode,
        bodyentrycode,
        bodyexitcode,
        exceptcode   : tnode;
        newblock     : tblocknode;
        codestatement,
        newstatement : tstatementnode;
        oldfilepos   : tfileposinfo;
      begin
        oldfilepos:=aktfilepos;
        { Generate code/locations used at start of proc }
        aktfilepos:=entrypos;
        entry_asmnode:=casmnode.create_get_position;
        loadpara_asmnode:=casmnode.create_get_position;
        init_asmnode:=casmnode.create_get_position;
        bodyentrycode:=generate_bodyentry_block;
        { Generate code/locations used at end of proc }
        aktfilepos:=exitpos;
        exitlabel_asmnode:=casmnode.create_get_position;
        final_asmnode:=casmnode.create_get_position;
        bodyexitcode:=generate_bodyexit_block;

        { Generate procedure by combining init+body+final,
          depending on the implicit finally we need to add
          an try...finally...end wrapper }
        newblock:=internalstatements(newstatement,true);
        if (pi_needs_implicit_finally in current_procinfo.flags) and
           { but it's useless in init/final code of units }
           not(current_procinfo.procdef.proctypeoption in [potype_unitfinalize,potype_unitinit]) then
          begin
            { Generate special exception block only needed when
              implicit finaly is used }
            aktfilepos:=exitpos;
            exceptcode:=generate_except_block;
            { Generate code that will be in the try...finally }
            finalcode:=internalstatements(codestatement,true);
            addstatement(codestatement,bodyexitcode);
            addstatement(codestatement,final_asmnode);
            { Initialize before try...finally...end frame }
            addstatement(newstatement,entry_asmnode);
            addstatement(newstatement,loadpara_asmnode);
            addstatement(newstatement,init_asmnode);
            addstatement(newstatement,bodyentrycode);
            aktfilepos:=entrypos;
            addstatement(newstatement,ctryfinallynode.create_implicit(
               code,
               finalcode,
               exceptcode));
            addstatement(newstatement,exitlabel_asmnode);
          end
        else
          begin
            addstatement(newstatement,entry_asmnode);
            addstatement(newstatement,loadpara_asmnode);
            addstatement(newstatement,init_asmnode);
            addstatement(newstatement,bodyentrycode);
            addstatement(newstatement,code);
            addstatement(newstatement,exitlabel_asmnode);
            addstatement(newstatement,bodyexitcode);
            addstatement(newstatement,final_asmnode);
          end;
        resulttypepass(newblock);
        code:=newblock;
        aktfilepos:=oldfilepos;
      end;


    procedure clearrefs(p : tnamedindexitem;arg:pointer);
      begin
         if (tsym(p).typ=varsym) then
           if tvarsym(p).refs>1 then
             tvarsym(p).refs:=1;
      end;


    procedure tcgprocinfo.generate_code;
      var
        oldprocinfo : tprocinfo;
        oldaktmaxfpuregisters : longint;
        oldfilepos : tfileposinfo;
        templist : Taasmoutput;
        headertai : tai;
        usesacc,
        usesfpu,
        usesacchi      : boolean;
      begin
        { the initialization procedure can be empty, then we
          don't need to generate anything. When it was an empty
          procedure there would be at least a blocknode }
        if not assigned(code) then
          exit;

        { We need valid code }
        if Errorcount<>0 then
          exit;

        { The RA and Tempgen shall not be available yet }
        if assigned(tg) then
          internalerror(200309201);

        oldprocinfo:=current_procinfo;
        oldfilepos:=aktfilepos;
        oldaktmaxfpuregisters:=aktmaxfpuregisters;

        current_procinfo:=self;

        { get new labels }
        aktbreaklabel:=nil;
        aktcontinuelabel:=nil;
        templist:=Taasmoutput.create;

        { add parast/localst to symtablestack }
        add_to_symtablestack;

        { when size optimization only count occurrence }
        if cs_littlesize in aktglobalswitches then
          cg.t_times:=1
        else
          { reference for repetition is 100 }
          cg.t_times:=100;

        { clear register count }
        symtablestack.foreach_static({$ifdef FPCPROCVAR}@{$endif}clearrefs,nil);
        symtablestack.next.foreach_static({$ifdef FPCPROCVAR}@{$endif}clearrefs,nil);

        { firstpass everything }
        flowcontrol:=[];
        do_firstpass(code);

        { only do secondpass if there are no errors }
        if ErrorCount=0 then
          begin
            { set the start offset to the start of the temp area in the stack }
            tg:=ttgobj.create;

            { Create register allocator }
            cg.init_register_allocators;

            current_procinfo.set_first_temp_offset;
            current_procinfo.generate_parameter_info;

            { Allocate space in temp/registers for parast and localst }
            aktfilepos:=entrypos;
            gen_alloc_parast(aktproccode,tparasymtable(current_procinfo.procdef.parast));
            if current_procinfo.procdef.localst.symtabletype=localsymtable then
              gen_alloc_localst(aktproccode,tlocalsymtable(current_procinfo.procdef.localst));
            if (cs_asm_source in aktglobalswitches) then
              aktproccode.concat(Tai_comment.Create(strpnew('Temps start at '+std_regname(current_procinfo.framepointer)+
                  tostr_with_plus(tg.lasttemp))));

            { Generate code to load register parameters in temps and insert local
              copies for values parameters. This must be done before the code for the
              body is generated because the localloc is updated.
              Note: The generated code will be inserted after the code generation of
              the body is finished, because only then the position is known }
            aktfilepos:=entrypos;
            gen_load_para_value(templist);

            { caller paraloc info is also necessary in the stackframe_entry
              code of the ppc (and possibly other processors)               }
            if not procdef.has_paraloc_info then
              begin
                paramanager.create_paraloc_info(procdef,callerside);
                procdef.has_paraloc_info:=true;
              end;

            { generate code for the node tree }
            do_secondpass(code);
            current_procinfo.aktproccode.concatlist(exprasmlist);
{$ifdef i386}
            procdef.fpu_used:=code.registersfpu;
{$endif i386}

            { The position of the loadpara_asmnode is now known }
            aktproccode.insertlistafter(loadpara_asmnode.currenttai,templist);

            { first generate entry and initialize code with the correct
              position and switches }
            aktfilepos:=entrypos;
            aktlocalswitches:=entryswitches;
            gen_entry_code(templist);
            aktproccode.insertlistafter(entry_asmnode.currenttai,templist);
            gen_initialize_code(templist,false);
            aktproccode.insertlistafter(init_asmnode.currenttai,templist);

            { now generate finalize and exit code with the correct position
              and switches }
            aktfilepos:=exitpos;
            aktlocalswitches:=exitswitches;
            gen_finalize_code(templist,false);
            { the finalcode must be concated if there was no position available,
              using insertlistafter will result in an insert at the start
              when currentai=nil }
            if assigned(final_asmnode.currenttai) then
              aktproccode.insertlistafter(final_asmnode.currenttai,templist)
            else
              aktproccode.concatlist(templist);
            { insert exit label at the correct position }
            cg.a_label(templist,current_procinfo.aktexitlabel);
            if assigned(exitlabel_asmnode.currenttai) then
              aktproccode.insertlistafter(exitlabel_asmnode.currenttai,templist)
            else
              aktproccode.concatlist(templist);
            { exit code }
            gen_exit_code(templist);
            aktproccode.concatlist(templist);

{$ifdef OLDREGVARS}
            { note: this must be done only after as much code as possible has  }
            {   been generated. The result is that when you ungetregister() a  }
            {   regvar, it will actually free the regvar (and alse free the    }
            {   the regvars at the same time). Doing this too early will       }
            {   confuse the register allocator, as the regvars will still be   }
            {   used. It should be done before loading the result regs (so     }
            {   they don't conflict with the regvars) and before               }
            {   gen_entry_code (that one has to be able to allocate the        }
            {   regvars again) (JM)                                            }
            free_regvars(aktproccode);
{$endif OLDREGVARS}

            { add code that will load the return value, this is not done
              for assembler routines when they didn't reference the result
              variable }
            usesacc:=false;
            usesfpu:=false;
            usesacchi:=false;
            gen_load_return_value(templist,usesacc,usesacchi,usesfpu);
            aktproccode.concatlist(templist);

            { generate symbol and save end of header position }
            aktfilepos:=entrypos;
            gen_proc_symbol(templist);
            headertai:=tai(templist.last);
            { insert symbol }
            aktproccode.insertlist(templist);

            { Free space in temp/registers for parast and localst, must be
              done after gen_entry_code }
            aktfilepos:=exitpos;
            if current_procinfo.procdef.localst.symtabletype=localsymtable then
              gen_free_localst(aktproccode,tlocalsymtable(current_procinfo.procdef.localst));
            gen_free_parast(aktproccode,tparasymtable(current_procinfo.procdef.parast));

            { The procedure body is finished, we can now
              allocate the registers }
            if not(cs_no_regalloc in aktglobalswitches) then
              begin
                cg.do_register_allocation(aktproccode,headertai);
(*
{$ifndef NoOpt}
                if (cs_optimize in aktglobalswitches) and
                { do not optimize pure assembler procedures }
                   not(pi_is_assembler in current_procinfo.flags)  then
                  optimize(aktproccode);
{$endif NoOpt}
*)
              end;

            { Add save and restore of used registers }
            aktfilepos:=entrypos;
            gen_save_used_regs(templist);
            aktproccode.insertlistafter(headertai,templist);
            aktfilepos:=exitpos;
            gen_restore_used_regs(aktproccode,usesacc,usesacchi,usesfpu);
            { Add stack allocation code after header }
            aktfilepos:=entrypos;
            gen_stackalloc_code(templist);
            aktproccode.insertlistafter(headertai,templist);
            { Add exit code at the end }
            aktfilepos:=exitpos;
            gen_stackfree_code(templist,usesacc,usesacchi);
            aktproccode.concatlist(templist);
            { Add end symbol and debug info }
            aktfilepos:=exitpos;
            gen_proc_symbol_end(templist);
            aktproccode.concatlist(templist);

            { save local data (casetable) also in the same file }
            if assigned(aktlocaldata) and
               (not aktlocaldata.empty) then
             begin
               { because of the limited constant size of the arm, all data access is done pc relative }
               if target_info.cpu=cpu_arm then
                 aktproccode.concatlist(aktlocaldata)
               else
                 begin
                   aktproccode.concat(Tai_section.Create(sec_data));
                   aktproccode.concatlist(aktlocaldata);
                   aktproccode.concat(Tai_section.Create(sec_code));
                 end;
            end;

            { add the procedure to the codesegment }
            if (cs_create_smart in aktmoduleswitches) then
              codesegment.concat(Tai_cut.Create);
            codesegment.concatlist(aktproccode);

            { only now we can remove the temps }
            tg.resettempgen;

            { stop tempgen and ra }
            tg.free;
            cg.done_register_allocators;
            tg:=nil;
          end;

        { restore symtablestack }
        remove_from_symtablestack;

        { restore }
        templist.free;
        aktmaxfpuregisters:=oldaktmaxfpuregisters;
        aktfilepos:=oldfilepos;
        current_procinfo:=oldprocinfo;
      end;


    procedure tcgprocinfo.add_to_symtablestack;
      var
        _class,hp : tobjectdef;
      begin
        { insert symtables for the class, but only if it is no nested function }
        if assigned(procdef._class) and
           not(assigned(parent) and
               assigned(parent.procdef) and
               assigned(parent.procdef._class)) then
          begin
            { insert them in the reverse order }
            hp:=nil;
            repeat
              _class:=procdef._class;
              while _class.childof<>hp do
                _class:=_class.childof;
              hp:=_class;
              _class.symtable.next:=symtablestack;
              symtablestack:=_class.symtable;
            until hp=procdef._class;
          end;

        { insert parasymtable in symtablestack when parsing
          a function }
        if procdef.parast.symtablelevel>=normal_function_level then
          begin
             procdef.parast.next:=symtablestack;
             symtablestack:=procdef.parast;
          end;

        procdef.localst.next:=symtablestack;
        symtablestack:=procdef.localst;
      end;


    procedure tcgprocinfo.remove_from_symtablestack;
      begin
        { remove localst/parast }
        if procdef.parast.symtablelevel>=normal_function_level then
          symtablestack:=symtablestack.next.next
        else
          symtablestack:=symtablestack.next;

        { remove class member symbol tables }
        while symtablestack.symtabletype=objectsymtable do
          symtablestack:=symtablestack.next;
      end;


    procedure tcgprocinfo.resetprocdef;
      begin
         { the local symtables can be deleted, but the parast   }
         { doesn't, (checking definitons when calling a        }
         { function                                        }
         { not for a inline procedure !!               (PM)   }
         { at lexlevel = 1 localst is the staticsymtable itself }
         { so no dispose here !!                              }
         if assigned(code) and
            not(cs_browser in aktmoduleswitches) and
            (procdef.proccalloption<>pocall_inline) then
           begin
             if procdef.parast.symtablelevel>=normal_function_level then
               procdef.localst.free;
             procdef.localst:=nil;
           end;

         { remove code tree, if not inline procedure }
         if assigned(code) then
          begin
            { the inline procedure has already got a copy of the tree
              stored in current_procinfo.procdef.code }
            code.free;
            code:=nil;
            if (procdef.proccalloption<>pocall_inline) then
              procdef.code:=nil;
          end;
       end;


    procedure tcgprocinfo.parse_body;
      var
         oldprocinfo : tprocinfo;
      begin
         oldprocinfo:=current_procinfo;

         current_procinfo:=self;

         { calculate the lexical level }
         if procdef.parast.symtablelevel>maxnesting then
           Message(parser_e_too_much_lexlevel);

         { static is also important for local procedures !! }
         if (po_staticmethod in procdef.procoptions) then
           allow_only_static:=true
         else if (procdef.parast.symtablelevel=normal_function_level) then
           allow_only_static:=false;

         { reset break and continue labels }
         block_type:=bt_general;
    {$ifdef state_tracking}
{    aktstate:=Tstate_storage.create;}
    {$endif state_tracking}

         { create a local symbol table for this routine }
         if not assigned(procdef.localst) then
           procdef.insert_localst;

         { add parast/localst to symtablestack }
         add_to_symtablestack;

         { constant symbols are inserted in this symboltable }
         constsymtable:=symtablestack;

         { save entry info }
         entrypos:=aktfilepos;
         entryswitches:=aktlocalswitches;

         { parse the code ... }
         code:=block(current_module.islibrary);

         { save exit info }
         exitswitches:=aktlocalswitches;
         exitpos:=last_endtoken_filepos;

         if assigned(code) then
           begin
             { get a better entry point }
             entrypos:=code.fileinfo;

             { the procedure is now defined }
             procdef.forwarddef:=false;

             if (Errorcount=0) then
               begin
                 { add implicit entry and exit code }
                 add_entry_exit_code;
                 { check if forwards are resolved }
                 tstoredsymtable(procdef.localst).check_forwards;
                 { check if all labels are used }
                 tstoredsymtable(procdef.localst).checklabels;
                 { remove cross unit overloads }
                 tstoredsymtable(procdef.localst).unchain_overloaded;
               end;

             { check for unused symbols, but only if there is no asm block }
             if not(pi_uses_asm in flags) then
               begin
                  { not for unit init, becuase the var can be used in finalize,
                    it will be done in proc_unit }
                  if not(procdef.proctypeoption in [potype_proginit,potype_unitinit,potype_unitfinalize]) then
                     tstoredsymtable(procdef.localst).allsymbolsused;
                  tstoredsymtable(procdef.parast).allsymbolsused;
               end;

             { Finish type checking pass }
             do_resulttypepass(code);

             { Print the node to tree.log }
             if paraprintnodetree=1 then
               printnode_procdef(procdef);
           end;

         { store a copy of the original tree for inline, for
           normal procedures only store a reference to the
           current tree }
         if (procdef.proccalloption=pocall_inline) then
           procdef.code:=code.getcopy
         else
           procdef.code:=code;

         { ... remove symbol tables }
         remove_from_symtablestack;

    {$ifdef state_tracking}
{    aktstate.destroy;}
    {$endif state_tracking}

         { reset to normal non static function }
         if (current_procinfo.procdef.parast.symtablelevel=normal_function_level) then
           allow_only_static:=false;
         current_procinfo:=oldprocinfo;
      end;


{****************************************************************************
                        PROCEDURE/FUNCTION PARSING
****************************************************************************}

    procedure check_init_paras(p:tnamedindexitem;arg:pointer);
      begin
        if tsym(p).typ<>varsym then
         exit;
        with tvarsym(p) do
          if (not is_class(vartype.def) and
             vartype.def.needs_inittable and
             (varspez in [vs_value,vs_out])) then
            include(current_procinfo.flags,pi_do_call);
      end;


    procedure read_proc;
      {
        Parses the procedure directives, then parses the procedure body, then
        generates the code for it
      }

      procedure do_generate_code(pi:tcgprocinfo);
        var
          hpi : tcgprocinfo;
        begin
          { generate code for this procedure }
          pi.generate_code;
          { process nested procs }
          hpi:=tcgprocinfo(pi.nestedprocs.first);
          while assigned(hpi) do
           begin
             do_generate_code(hpi);
             hpi:=tcgprocinfo(hpi.next);
           end;
          pi.resetprocdef;
        end;

      var
        old_current_procinfo : tprocinfo;
        oldconstsymtable : tsymtable;
        oldfailtokenmode : tmodeswitch;
        pdflags          : tpdflags;
        pd               : tprocdef;
        isnestedproc     : boolean;
      begin
         { save old state }
         oldconstsymtable:=constsymtable;
         old_current_procinfo:=current_procinfo;

         { reset current_procinfo.procdef to nil to be sure that nothing is writing
           to an other procdef }
         current_procinfo:=nil;

         { parse procedure declaration }
         if assigned(old_current_procinfo) and
            assigned(old_current_procinfo.procdef) then
          pd:=parse_proc_dec(old_current_procinfo.procdef._class)
         else
          pd:=parse_proc_dec(nil);

         { set the default function options }
         if parse_only then
          begin
            pd.forwarddef:=true;
            { set also the interface flag, for better error message when the
              implementation doesn't much this header }
            pd.interfacedef:=true;
            include(pd.procoptions,po_public);
            pdflags:=[pd_interface];
          end
         else
          begin
            pdflags:=[pd_body];
            if (not current_module.in_interface) then
              include(pdflags,pd_implemen);
            if (not current_module.is_unit) or
               (cs_create_smart in aktmoduleswitches) then
              include(pd.procoptions,po_public);
            pd.forwarddef:=false;
          end;

         { parse the directives that may follow }
         parse_proc_directives(pd,pdflags);

         { hint directives, these can be separated by semicolons here,
           that needs to be handled here with a loop (PFV) }
         while try_consume_hintdirective(pd.symoptions) do
          Consume(_SEMICOLON);

         { Set calling convention }
         handle_calling_convention(pd);

         { everything of the proc definition is known, we can now
           calculate the parameters }
         calc_parast(pd);

         { search for forward declarations }
         if not proc_add_definition(pd) then
           begin
             { A method must be forward defined (in the object declaration) }
             if assigned(pd._class) and
                (not assigned(old_current_procinfo.procdef._class)) then
              begin
                MessagePos1(pd.fileinfo,parser_e_header_dont_match_any_member,pd.fullprocname(false));
                tprocsym(pd.procsym).write_parameter_lists(pd);
              end
             else
              begin
                { Give a better error if there is a forward def in the interface and only
                  a single implementation }
                if (not pd.forwarddef) and
                   (not pd.interfacedef) and
                   (tprocsym(pd.procsym).procdef_count>1) and
                   tprocsym(pd.procsym).first_procdef.forwarddef and
                   tprocsym(pd.procsym).first_procdef.interfacedef and
                   not(tprocsym(pd.procsym).procdef_count>2) then
                 begin
                   MessagePos1(pd.fileinfo,parser_e_header_dont_match_forward,pd.fullprocname(false));
                   tprocsym(pd.procsym).write_parameter_lists(pd);
                 end;
              end;
           end;

         { compile procedure when a body is needed }
         if (pd_body in pdflags) then
           begin
             Message1(parser_d_procedure_start,pd.fullprocname(false));

             { create a new procedure }
             current_procinfo:=cprocinfo.create(old_current_procinfo);
             current_module.procinfo:=current_procinfo;
             current_procinfo.procdef:=pd;
             isnestedproc:=(current_procinfo.procdef.parast.symtablelevel>normal_function_level);

             { Insert mangledname }
             pd.aliasnames.insert(pd.mangledname);

             { Insert result variables in the localst }
             insert_funcret_local(pd);

             { check if there are para's which require initing -> set }
             { pi_do_call (if not yet set)                            }
             if not(pi_do_call in current_procinfo.flags) then
               pd.parast.foreach_static({$ifdef FPCPROCVAR}@{$endif}check_init_paras,nil);

             { set _FAIL as keyword if constructor }
             if (pd.proctypeoption=potype_constructor) then
              begin
                oldfailtokenmode:=tokeninfo^[_FAIL].keyword;
                tokeninfo^[_FAIL].keyword:=m_all;
              end;

             tcgprocinfo(current_procinfo).parse_body;

             { When it's a nested procedure then defer the code generation,
               when back at normal function level then generate the code
               for all defered nested procedures and the current procedure }
             if isnestedproc then
               tcgprocinfo(current_procinfo.parent).nestedprocs.insert(current_procinfo)
             else
               begin
                 { We can't support inlining for procedures that have nested
                   procedures because the nested procedures use a fixed offset
                   for accessing locals in the parent procedure (PFV) }
                 if (current_procinfo.procdef.proccalloption=pocall_inline) and
                    (tcgprocinfo(current_procinfo).nestedprocs.count>0) then
                   begin
                     Message1(parser_w_not_supported_for_inline,'nested procedures');
                     Message(parser_w_inlining_disabled);
                     current_procinfo.procdef.proccalloption:=pocall_default;
                   end;
                 do_generate_code(tcgprocinfo(current_procinfo));
               end;

             { reset _FAIL as _SELF normal }
             if (pd.proctypeoption=potype_constructor) then
               tokeninfo^[_FAIL].keyword:=oldfailtokenmode;

             { release procinfo }
             if tprocinfo(current_module.procinfo)<>current_procinfo then
               internalerror(200304274);
             current_module.procinfo:=current_procinfo.parent;
             if not isnestedproc then
               current_procinfo.free;

             consume(_SEMICOLON);
           end;

         { Restore old state }
         constsymtable:=oldconstsymtable;

         current_procinfo:=old_current_procinfo;
      end;


{****************************************************************************
                             DECLARATION PARSING
****************************************************************************}

    { search in symtablestack for not complete classes }
    procedure check_forward_class(p : tnamedindexitem;arg:pointer);
      begin
        if (tsym(p).typ=typesym) and
           (ttypesym(p).restype.def.deftype=objectdef) and
           (oo_is_forward in tobjectdef(ttypesym(p).restype.def).objectoptions) then
          MessagePos1(tsym(p).fileinfo,sym_e_forward_type_not_resolved,tsym(p).realname);
      end;


    procedure read_declarations(islibrary : boolean);
      begin
         repeat
           if not assigned(current_procinfo) then
             internalerror(200304251);
           case token of
              _LABEL:
                begin
                   label_dec;
                end;
              _CONST:
                begin
                   const_dec;
                end;
              _TYPE:
                begin
                   type_dec;
                end;
              _VAR:
                var_dec;
              _THREADVAR:
                threadvar_dec;
              _CONSTRUCTOR,
              _DESTRUCTOR,
              _FUNCTION,
              _PROCEDURE,
              _OPERATOR,
              _CLASS:
                read_proc;
              _RESOURCESTRING:
                resourcestring_dec;
              _EXPORTS:
                begin
                   if not(assigned(current_procinfo.procdef.localst)) or
                      (current_procinfo.procdef.localst.symtablelevel>main_program_level) or
                      (current_module.is_unit) then
                     begin
                        Message(parser_e_syntax_error);
                        consume_all_until(_SEMICOLON);
                     end
                   else if islibrary or
                           (target_info.system in [system_i386_WIN32,system_i386_wdosx,system_i386_Netware]) then
                     read_exports
                   else
                     begin
                        Message(parser_w_unsupported_feature);
                        consume(_BEGIN);
                     end;
                end
              else
                break;
           end;
         until false;

         { check for incomplete class definitions, this is only required
           for fpc modes }
         if (m_fpc in aktmodeswitches) then
           symtablestack.foreach_static({$ifdef FPCPROCVAR}@{$endif}check_forward_class,nil);
      end;


    procedure read_interface_declarations;
      begin
         repeat
           case token of
             _CONST :
               const_dec;
             _TYPE :
               type_dec;
             _VAR :
               var_dec;
             _THREADVAR :
               threadvar_dec;
             _RESOURCESTRING:
               resourcestring_dec;
             _FUNCTION,
             _PROCEDURE,
             _OPERATOR :
               read_proc;
             else
               break;
           end;
         until false;
         { check for incomplete class definitions, this is only required
           for fpc modes }
         if (m_fpc in aktmodeswitches) then
          symtablestack.foreach_static({$ifdef FPCPROCVAR}@{$endif}check_forward_class,nil);
      end;


end.
{
  $Log$
  Revision 1.169  2003-10-31 15:52:18  peter
    * fix crash with fail in constructor

  Revision 1.168  2003/10/30 16:22:40  peter
    * call firstpass before allocation and codegeneration is started
    * move leftover code from pass_2.generatecode() to psub

  Revision 1.167  2003/10/24 17:40:23  peter
    * cleanup of the entry and exit code insertion

  Revision 1.166  2003/10/21 15:14:33  peter
    * fixed memleak for initfinalcode
    * exit from generatecode when there are already errors

  Revision 1.165  2003/10/20 19:28:51  peter
    * disable inlining when nested procedures are found

  Revision 1.164  2003/10/19 01:34:30  florian
    * some ppc stuff fixed
    * memory leak fixed

  Revision 1.163  2003/10/17 14:38:32  peter
    * 64k registers supported
    * fixed some memory leaks

  Revision 1.162  2003/10/10 17:48:13  peter
    * old trgobj moved to x86/rgcpu and renamed to trgx86fpu
    * tregisteralloctor renamed to trgobj
    * removed rgobj from a lot of units
    * moved location_* and reference_* to cgobj
    * first things for mmx register allocation

  Revision 1.161  2003/10/09 21:31:37  daniel
    * Register allocator splitted, ans abstract now

  Revision 1.160  2003/10/09 15:20:56  peter
    * self is not a token anymore. It is handled special when found
      in a code block and when parsing an method

  Revision 1.159  2003/10/07 15:17:07  peter
    * inline supported again, LOC_REFERENCEs are used to pass the
      parameters
    * inlineparasymtable,inlinelocalsymtable removed
    * exitlabel inserting fixed

  Revision 1.158  2003/10/06 22:23:41  florian
    + added basic olevariant support

  Revision 1.157  2003/10/03 14:45:09  peter
    * more proc directive for procvar fixes

  Revision 1.156  2003/10/02 21:20:32  peter
    * handle_calling_convention removed from parse_proc_directive to
      separate call

  Revision 1.155  2003/10/01 20:34:49  peter
    * procinfo unit contains tprocinfo
    * cginfo renamed to cgbase
    * moved cgmessage to verbose
    * fixed ppc and sparc compiles

  Revision 1.154  2003/09/29 20:58:56  peter
    * optimized releasing of registers

  Revision 1.153  2003/09/28 17:55:04  peter
    * parent framepointer changed to hidden parameter
    * tloadparentfpnode added

  Revision 1.152  2003/09/27 13:29:43  peter
    * fix reported file position for not matched forwards

  Revision 1.151  2003/09/25 21:25:13  peter
    * remove allocate_intterupt_parameter, allocation is platform
      dependent and needs to be done in create_paraloc_info

  Revision 1.150  2003/09/25 16:19:32  peter
    * fix filepositions
    * insert spill temp allocations at the start of the proc

  Revision 1.149  2003/09/23 17:56:06  peter
    * locals and paras are allocated in the code generation
    * tvarsym.localloc contains the location of para/local when
      generating code for the current procedure

  Revision 1.148  2003/09/14 19:18:10  peter
    * remove obsolete code already in comments

  Revision 1.147  2003/09/14 12:58:00  peter
    * support mulitple overloads in implementation, this is delphi
      compatible
    * procsym only stores the overloads available in the interface

  Revision 1.146  2003/09/12 19:07:42  daniel
    * Fixed fast spilling functionality by re-adding the code that initializes
      precoloured nodes to degree 255. I would like to play hangman on the one
      who removed that code.

  Revision 1.145  2003/09/10 19:14:31  daniel
    * Failed attempt to restore broken fastspill functionality

  Revision 1.144  2003/09/09 20:59:27  daniel
    * Adding register allocation order

  Revision 1.143  2003/09/09 15:55:44  peter
    * use register with least interferences in spillregister

  Revision 1.142  2003/09/07 22:09:35  peter
    * preparations for different default calling conventions
    * various RA fixes

  Revision 1.141  2003/09/04 14:46:12  peter
    * abort with IE when spilling requires > 20 loops

  Revision 1.140  2003/09/03 15:55:01  peter
    * NEWRA branch merged

  Revision 1.139  2003/09/03 11:18:37  florian
    * fixed arm concatcopy
    + arm support in the common compiler sources added
    * moved some generic cg code around
    + tfputype added
    * ...

  Revision 1.138.2.1  2003/08/31 13:50:16  daniel
    * Remove sorting and use pregenerated indexes
    * Some work on making things compile

  Revision 1.138  2003/08/20 17:48:49  peter
    * fixed stackalloc to not allocate localst.datasize twice
    * order of stackalloc code fixed for implicit init/final

  Revision 1.137  2003/08/20 15:50:35  peter
    * define NOOPT until optimizer is fixed

  Revision 1.136  2003/08/20 09:07:00  daniel
    * New register coding now mandatory, some more convert_registers calls
      removed.

  Revision 1.135  2003/08/20 07:48:03  daniel
    * Made internal assembler use new register coding

  Revision 1.134  2003/08/17 16:59:20  jonas
    * fixed regvars so they work with newra (at least for ppc)
    * fixed some volatile register bugs
    + -dnotranslation option for -dnewra, which causes the registers not to
      be translated from virtual to normal registers. Requires support in
      the assembler writer as well, which is only implemented in aggas/
      agppcgas currently

  Revision 1.133  2003/07/23 11:04:15  jonas
    * split en_exit_code into a part that may allocate a register and a part
      that doesn't, so the former can be done before the register colouring
      has been performed

  Revision 1.132  2003/07/06 17:58:22  peter
    * framepointer fixes for sparc
    * parent framepointer code more generic

  Revision 1.131  2003/07/06 15:31:21  daniel
    * Fixed register allocator. *Lots* of fixes.

  Revision 1.130  2003/07/05 20:15:24  jonas
    * set pi_do_call if range/overflow checking is on

  Revision 1.129  2003/06/17 16:34:44  jonas
    * lots of newra fixes (need getfuncretparaloc implementation for i386)!
    * renamed all_intregisters to paramanager.get_volatile_registers_int(pocall_default) and made it
      processor dependent

  Revision 1.128  2003/06/14 14:53:50  jonas
    * fixed newra cycle for x86
    * added constants for indicating source and destination operands of the
      "move reg,reg" instruction to aasmcpu (and use those in rgobj)

  Revision 1.127  2003/06/13 21:19:31  peter
    * current_procdef removed, use current_procinfo.procdef instead

  Revision 1.126  2003/06/12 16:43:07  peter
    * newra compiles for sparc

  Revision 1.125  2003/06/09 12:23:30  peter
    * init/final of procedure data splitted from genentrycode
    * use asmnode getposition to insert final at the correct position
      als for the implicit try...finally

  Revision 1.124  2003/06/07 19:37:43  jonas
    * pi_do_call must always be set for the main program, since it always
      ends with a call to FPC_DO_EXIT

  Revision 1.123  2003/06/07 18:57:04  jonas
    + added freeintparaloc
    * ppc get/freeintparaloc now check whether the parameter regs are
      properly allocated/deallocated (and get an extra list para)
    * ppc a_call_* now internalerrors if pi_do_call is not yet set
    * fixed lot of missing pi_do_call's

  Revision 1.122  2003/06/03 13:01:59  daniel
    * Register allocator finished

  Revision 1.121  2003/05/31 20:23:39  jonas
    * added pi_do_call if a procedure has a value shortstring parameter
      (it's copied to the local stackframe with a helper)

  Revision 1.120  2003/05/30 23:57:08  peter
    * more sparc cleanup
    * accumulator removed, splitted in function_return_reg (called) and
      function_result_reg (caller)

  Revision 1.119  2003/05/28 23:58:18  jonas
    * added missing initialization of rg.usedintin,byproc
    * ppc now also saves/restores used fpu registers
    * ncgcal doesn't add used registers to usedby/inproc anymore, except for
      i386

  Revision 1.118  2003/05/26 21:17:18  peter
    * procinlinenode removed
    * aktexit2label removed, fast exit removed
    + tcallnode.inlined_pass_2 added

  Revision 1.117  2003/05/25 08:59:47  peter
    * do not generate code when there was an error

  Revision 1.116  2003/05/23 18:49:55  jonas
    * generate code for parent procedure before that of nested procedures as
      well (I only need pass_1 to be done for the ppc, but pass_1 and pass_2
      are grouped and it doesn't hurt that pass_2 is done as well)

  Revision 1.115  2003/05/22 21:31:35  peter
    * defer codegeneration for nested procedures

  Revision 1.114  2003/05/16 20:00:39  jonas
    * powerpc nested procedure fixes, should work completely now if all
      local variables of the parent procedure are declared before the
      nested procedures are declared

  Revision 1.113  2003/05/16 14:33:31  peter
    * regvar fixes

  Revision 1.112  2003/05/13 21:26:38  peter
    * only call destructor in except block when there is a destructor
      available

  Revision 1.111  2003/05/13 19:14:41  peter
    * failn removed
    * inherited result code check moven to pexpr

  Revision 1.110  2003/05/13 15:18:49  peter
    * fixed various crashes

  Revision 1.109  2003/05/11 21:37:03  peter
    * moved implicit exception frame from ncgutil to psub
    * constructor/destructor helpers moved from cobj/ncgutil to psub

  Revision 1.108  2003/05/09 17:47:03  peter
    * self moved to hidden parameter
    * removed hdisposen,hnewn,selfn

  Revision 1.107  2003/04/27 11:21:34  peter
    * aktprocdef renamed to current_procinfo.procdef
    * procinfo renamed to current_procinfo
    * procinfo will now be stored in current_module so it can be
      cleaned up properly
    * gen_main_procsym changed to create_main_proc and release_main_proc
      to also generate a tprocinfo structure
    * fixed unit implicit initfinal

  Revision 1.106  2003/04/27 07:29:50  peter
    * current_procinfo.procdef cleanup, current_procdef is now always nil when parsing
      a new procdef declaration
    * aktprocsym removed
    * lexlevel removed, use symtable.symtablelevel instead
    * implicit init/final code uses the normal genentry/genexit
    * funcret state checking updated for new funcret handling

  Revision 1.105  2003/04/26 00:31:42  peter
    * set return_offset moved to after_header

  Revision 1.104  2003/04/25 20:59:34  peter
    * removed funcretn,funcretsym, function result is now in varsym
      and aliases for result and function name are added using absolutesym
    * vs_hidden parameter for funcret passed in parameter
    * vs_hidden fixes
    * writenode changed to printnode and released from extdebug
    * -vp option added to generate a tree.log with the nodetree
    * nicer printnode for statements, callnode

  Revision 1.103  2003/04/24 13:03:01  florian
    * comp is now written with its bit pattern to the ppu instead as an extended

  Revision 1.102  2003/04/23 12:35:34  florian
    * fixed several issues with powerpc
    + applied a patch from Jonas for nested function calls (PowerPC only)
    * ...

  Revision 1.101  2003/04/22 14:33:38  peter
    * removed some notes/hints

  Revision 1.100  2003/04/22 13:47:08  peter
    * fixed C style array of const
    * fixed C array passing
    * fixed left to right with high parameters

  Revision 1.99  2003/04/22 10:09:35  daniel
    + Implemented the actual register allocator
    + Scratch registers unavailable when new register allocator used
    + maybe_save/maybe_restore unavailable when new register allocator used

  Revision 1.98  2003/04/17 07:50:24  daniel
    * Some work on interference graph construction

  Revision 1.97  2003/04/16 09:26:55  jonas
    * assembler procedures now again get a stackframe if they have local
      variables. No space is reserved for a function result however.
      Also, the register parameters aren't automatically saved on the stack
      anymore in assembler procedures.

  Revision 1.96  2003/04/05 21:09:31  jonas
    * several ppc/generic result offset related fixes. The "normal" result
      offset seems now to be calculated correctly and a lot of duplicate
      calculations have been removed. Nested functions accessing the parent's
      function result don't work at all though :(

  Revision 1.95  2003/04/02 16:11:34  peter
    * give error when exports is not supported

  Revision 1.94  2003/03/12 22:43:38  jonas
    * more powerpc and generic fixes related to the new register allocator

  Revision 1.93  2003/03/08 08:59:07  daniel
    + $define newra will enable new register allocator
    + getregisterint will return imaginary registers with $newra
    + -sr switch added, will skip register allocation so you can see
      the direct output of the code generator before register allocation

  Revision 1.92  2003/02/19 22:00:14  daniel
    * Code generator converted to new register notation
    - Horribily outdated todo.txt removed

  Revision 1.91  2003/01/09 21:52:37  peter
    * merged some verbosity options.
    * V_LineInfo is a verbosity flag to include line info

  Revision 1.90  2003/01/09 20:40:59  daniel
    * Converted some code in cgx86.pas to new register numbering

  Revision 1.89  2003/01/09 15:49:56  daniel
    * Added register conversion

  Revision 1.88  2003/01/08 18:43:56  daniel
   * Tregister changed into a record

  Revision 1.87  2003/01/03 20:35:08  peter
    * check also interfacedef when checking for matching forwarddef

  Revision 1.86  2003/01/02 11:14:02  michael
  + Patch from peter to support initial values for local variables

  Revision 1.85  2002/12/29 18:59:34  peter
    * fixed parsing of declarations before asm statement

  Revision 1.84  2002/12/29 18:25:18  peter
    * parse declarations before check _ASM token

  Revision 1.83  2002/12/29 14:57:50  peter
    * unit loading changed to first register units and load them
      afterwards. This is needed to support uses xxx in yyy correctly
    * unit dependency check fixed

  Revision 1.82  2002/12/25 01:26:56  peter
    * duplicate procsym-unitsym fix

  Revision 1.81  2002/12/15 13:37:15  peter
    * don't include uf_init for library. The code is already called and
      does not need to be in the initfinal table

  Revision 1.80  2002/12/07 14:27:09  carl
    * 3% memory optimization
    * changed some types
    + added type checking with different size for call node and for
       parameters

  Revision 1.79  2002/11/25 18:43:32  carl
   - removed the invalid if <> checking (Delphi is strange on this)
   + implemented abstract warning on instance creation of class with
      abstract methods.
   * some error message cleanups

  Revision 1.78  2002/11/25 17:43:23  peter
    * splitted defbase in defutil,symutil,defcmp
    * merged isconvertable and is_equal into compare_defs(_ext)
    * made operator search faster by walking the list only once

  Revision 1.77  2002/11/23 22:50:06  carl
    * some small speed optimizations
    + added several new warnings/hints

  Revision 1.76  2002/11/18 17:31:58  peter
    * pass proccalloption to ret_in_xxx and push_xxx functions

  Revision 1.75  2002/11/17 16:31:57  carl
    * memory optimization (3-4%) : cleanup of tai fields,
       cleanup of tdef and tsym fields.
    * make it work for m68k

  Revision 1.74  2002/11/15 01:58:53  peter
    * merged changes from 1.0.7 up to 04-11
      - -V option for generating bug report tracing
      - more tracing for option parsing
      - errors for cdecl and high()
      - win32 import stabs
      - win32 records<=8 are returned in eax:edx (turned off by default)
      - heaptrc update
      - more info for temp management in .s file with EXTDEBUG

  Revision 1.73  2002/11/09 15:32:30  carl
    * noopt for non-i386 targets

  Revision 1.72  2002/09/10 20:31:48  florian
    * call to current_procinfo.after_header added

  Revision 1.71  2002/09/07 15:25:07  peter
    * old logs removed and tabs fixed

  Revision 1.70  2002/09/03 16:26:27  daniel
    * Make Tprocdef.defs protected

  Revision 1.69  2002/08/25 19:25:20  peter
    * sym.insert_in_data removed
    * symtable.insertvardata/insertconstdata added
    * removed insert_in_data call from symtable.insert, it needs to be
      called separatly. This allows to deref the address calculation
    * procedures now calculate the parast addresses after the procedure
      directives are parsed. This fixes the cdecl parast problem
    * push_addr_param has an extra argument that specifies if cdecl is used
      or not

  Revision 1.68  2002/08/17 09:23:41  florian
    * first part of procinfo rewrite

  Revision 1.67  2002/08/16 14:24:59  carl
    * issameref() to test if two references are the same (then emit no opcodes)
    + ret_in_reg to replace ret_in_acc
      (fix some register allocation bugs at the same time)
    + save_std_register now has an extra parameter which is the
      usedinproc registers

  Revision 1.66  2002/08/11 14:32:27  peter
    * renamed current_library to objectlibrary

  Revision 1.65  2002/08/11 13:24:13  peter
    * saving of asmsymbols in ppu supported
    * asmsymbollist global is removed and moved into a new class
      tasmlibrarydata that will hold the info of a .a file which
      corresponds with a single module. Added librarydata to tmodule
      to keep the library info stored for the module. In the future the
      objectfiles will also be stored to the tasmlibrarydata class
    * all getlabel/newasmsymbol and friends are moved to the new class

  Revision 1.64  2002/08/09 19:14:28  carl
    * fixed stackframe parameter (should only contain local size),
      set to zero currently

  Revision 1.63  2002/08/06 20:55:22  florian
    * first part of ppc calling conventions fix

  Revision 1.62  2002/07/26 21:15:41  florian
    * rewrote the system handling

  Revision 1.61  2002/07/20 11:57:56  florian
    * types.pas renamed to defbase.pas because D6 contains a types
      unit so this would conflicts if D6 programms are compiled
    + Willamette/SSE2 instructions to assembler added

  Revision 1.60  2002/07/19 11:41:36  daniel
  * State tracker work
  * The whilen and repeatn are now completely unified into whilerepeatn. This
    allows the state tracker to change while nodes automatically into
    repeat nodes.
  * Resulttypepass improvements to the notn. 'not not a' is optimized away and
    'not(a>b)' is optimized into 'a<=b'.
  * Resulttypepass improvements to the whilerepeatn. 'while not a' is optimized
    by removing the notn and later switchting the true and falselabels. The
    same is done with 'repeat until not a'.

  Revision 1.59  2002/07/15 18:03:15  florian
    * readded removed changes

  Revision 1.57  2002/07/11 14:41:28  florian
    * start of the new generic parameter handling

  Revision 1.58  2002/07/14 18:00:44  daniel
  + Added the beginning of a state tracker. This will track the values of
    variables through procedures and optimize things away.

  Revision 1.56  2002/07/07 09:52:32  florian
    * powerpc target fixed, very simple units can be compiled
    * some basic stuff for better callparanode handling, far from being finished

  Revision 1.55  2002/07/04 20:43:01  florian
    * first x86-64 patches

  Revision 1.54  2002/07/01 18:46:25  peter
    * internal linker
    * reorganized aasm layer

  Revision 1.53  2002/05/18 13:34:14  peter
    * readded missing revisions

  Revision 1.52  2002/05/16 19:46:44  carl
  + defines.inc -> fpcdefs.inc to avoid conflicts if compiling by hand
  + try to fix temp allocation (still in ifdef)
  + generic constructor calls
  + start of tassembler / tmodulebase class cleanup

  Revision 1.51  2002/05/14 19:34:49  peter
    * removed old logs and updated copyright year

}
