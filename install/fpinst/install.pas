{
    $Id$
    This file is part of the Free Pascal run time library.
    Copyright (c) 1993-98 by Florian Klaempfl
    member of the Free Pascal development team

    This is the install program for Free Pascal

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
program install;

{$DEFINE FV}         (* TH - added to make use of the original Turbo Vision possible. *)
{ $DEFINE DLL}       (* TH - if defined, UNZIP32.DLL library is used to unpack. *)
{ $DEFINE DOSSTUB}   (* TH - should _not_ be defined unless creating a bound DOS and OS/2 installer!!! *)
(* Defining DOSSTUB causes adding a small piece of code    *)
(* for starting the OS/2 part from the DOS part of a bound *)
(* application if running in OS/2 VDM (DOS) window. Used   *)
(* only if compiling with TP/BP (see conditionals below).  *)

{$IFDEF VER60}
 {$DEFINE TP}
{$ENDIF}

{$IFDEF VER70}
 {$DEFINE TP}
{$ENDIF}

{$IFNDEF TP}
 {$UNDEF DOSSTUB}
{$ELSE}
 {$IFDEF OS2}
  {$UNDEF DOSSTUB}
 {$ENDIF}
{$ENDIF}

{$IFDEF OS2}
 {$UNDEF FV}
 {$IFDEF VIRTUALPASCAL}
  {$DEFINE DLL}
 {$ENDIF}
{$ENDIF}

{$IFDEF DPMI}
 {$UNDEF DOSSTUB}
{$ENDIF}

  uses
{$IFDEF OS2}
 {$IFDEF FPC}
     DosCalls,
 {$ELSE FPC}
  {$IFDEF VirtualPascal}
     OS2Base,
  {$ELSE VirtualPascal}
     BseDos,
  {$ENDIF VirtualPascal}
 {$ENDIF FPC}
{$ENDIF OS2}
{$ifdef HEAPTRC}
     heaptrc,
{$endif HEAPTRC}
     strings,dos,objects,drivers,
{$IFDEF FV}
     commands,
{$ENDIF}
     unzip,ziptypes,
{$IFDEF DLL}
     unzipdll,
{$ENDIF}
     app,dialogs,views,menus,msgbox,colortxt,tabs;


  const
     installerversion='1.02';

     maxpacks=10;
     maxpackages=20;
     maxdefcfgs=1024;

     CfgExt = '.dat';

     MaxStatusPos = 4;
     StatusChars: string [MaxStatusPos] = '/-\|';
     StatusPos: byte = 1;

{$IFDEF LINUX}
     DirSep='/';
{$ELSE}
 {$IFDEF UNIX}
     DirSep='/';
 {$ELSE}
     DirSep='\';
 {$ENDIF}
{$ENDIF}

{$IFNDEF GO32V2}
 {$IFDEF GO32V1}
     LFNSupport = false;
 {$ELSE}
  {$IFDEF TP}
     LFNSupport = false;
  {$ELSE}
     LFNSupport = true;
  {$ENDIF}
 {$ENDIF}
{$ENDIF}

  type
     tpackage=record
       name  : string[60];
       zip   : string[12];
     end;

     tpack=record
       name     : string[12];
       binsub   : string[40];
       ppc386   : string[20];
       defcfgfile : string[12];
       include  : boolean;
       filechk  : string[40];
       packages : longint;
       package  : array[1..maxpackages] of tpackage;
     end;

     cfgrec=record
       title    : string[80];
       version  : string[20];
       basepath : DirStr;
       packs    : word;
       pack     : array[1..maxpacks] of tpack;
       defcfgs  : longint;
       defcfg   : array[1..maxdefcfgs] of pstring;
     end;

     datarec=packed record
       basepath : DirStr;
       cfgval   : word;
       packmask : array[1..maxpacks] of word;
     end;

     punzipdialog=^tunzipdialog;
     tunzipdialog=object(tdialog)
        filetext : pstatictext;
        constructor Init(var Bounds: TRect; ATitle: TTitleStr);
        procedure do_unzip(s,topath:string);
     end;

     penddialog = ^tenddialog;
     tenddialog = object(tdialog)
        constructor init;
     end;

     pinstalldialog = ^tinstalldialog;
     tinstalldialog = object(tdialog)
        constructor init;
     end;

     tapp = object(tapplication)
         procedure initmenubar;virtual;
         procedure handleevent(var event : tevent);virtual;
         procedure do_installdialog;
         procedure readcfg(const fn:string);
         procedure checkavailpack;
     end;

{$IFDEF DOSSTUB}
  PByte = ^byte;
  PRunBlock = ^TRunBlock;
  TRunBlock = record
    Length: word;
    Dependent: word;
    Background: word;
    TraceLevel: word;
    PrgTitle: PChar;
    PrgName: PChar;
    Args: PChar;
    TermQ: longint;
    Environment: pointer;
    Inheritance: word;
    SesType: word;
    Icon: pointer;
    PgmHandle: longint;
    PgmControl: word;
    Column: word;
    Row: word;
    Width: word;
    Height: word;
  end;
{$ENDIF}

  var
     installapp  : tapp;
     startpath   : string;
     successfull : boolean;
     cfg         : cfgrec;
     data        : datarec;
     CfgName: NameStr;
     DStr: DirStr;
     EStr: ExtStr;
     UnzDlg      : punzipdialog;
     log         : text;
     createlog   : boolean;
{$IFNDEF DLL}

  const
     UnzipErr: longint = 0;
{$ENDIF}


{*****************************************************************************
                                  Helpers
*****************************************************************************}

  procedure errorhalt;
    begin
      installapp.done;
      halt(1);
    end;


  function packagemask(i:longint):longint;
    begin
      packagemask:=1 shl (i-1);
    end;


  function upper(const s : string):string;
    var
       i : integer;
    begin
       for i:=1 to length(s) do
         if s[i] in ['a'..'z'] then
          upper[i]:=chr(ord(s[i])-32)
         else
          upper[i]:=s[i];
       upper[0]:=s[0];
    end;


  procedure Replace(var s:string;const s1,s2:string);
    var
       i  : longint;
    begin
      repeat
        i:=pos(s1,s);
        if i>0 then
         begin
           Delete(s,i,length(s1));
           Insert(s2,s,i);
         end;
      until i=0;
    end;


  function file_exists(const f : string;const path : string) : boolean;
    begin
       file_exists:=fsearch(f,path)<>'';
    end;


  function createdir(s:string):boolean;
    var
      s1,start : string;
      err : boolean;
      i : longint;
    begin
       err:=false;
       {$I-}
       getdir(0,start);
{$ifndef linux}
       if (s[2]=':') and (s[3]=DirSep) then
        begin
          chdir(Copy(s,1,3));
          Delete(S,1,3);
        end;
{$endif}
       repeat
         i:=Pos(DirSep,s);
         if i=0 then
          i:=255;
         s1:=Copy(s,1,i-1);
         Delete(s,1,i);
         ChDir(s1);
         if ioresult<>0 then
          begin
            mkdir(s1);
            chdir(s1);
            if ioresult<>0 then
             begin
               err:=true;
               break;
             end;
          end;
       until s='';
       chdir(start);
       {$I+}
       createdir:=err;
    end;


  function DiskSpaceN(const zipfile : string) : longint;
    var
      compressed,uncompressed : longint;
      s : string;
    begin
      s:=zipfile+#0;
      if not (IsZip (@S [1])) then DiskSpaceN := -1 else
      begin
       Uncompressed:=UnzipSize(@s[1],compressed);
       DiskSpaceN:=uncompressed shr 10;
      end;
    end;


  function diskspace(const zipfile : string) : string;
    var
      uncompressed : longint;
      s : string;
    begin
      uncompressed:=DiskSpaceN (zipfile);
      if Uncompressed = -1 then DiskSpace := ' [INVALID]' else
      begin
       str(uncompressed,s);
       diskspace:=' ('+s+' KB)';
      end;
    end;


  function createinstalldir(s : string) : boolean;
    var
      err : boolean;
      dir : searchrec;
      params : array[0..0] of pointer;
    begin
       if s[length(s)]=DirSep then
        dec(s[0]);
       FindFirst(s,AnyFile,dir);
       if doserror=0 then
         begin
            if Dir.Attr and Directory = 0 then
              begin
                messagebox('A file with the name chosen as the installation '+
                'directory exists already. Cannot create this directory!',nil,
                mferror+mfokbutton);
                createinstalldir:=false;
              end else
                createinstalldir:=messagebox('The installation directory exists already. '+
                'Do you want to continue ?',nil,
                mferror+mfyesbutton+mfnobutton)=cmYes;
            exit;
         end;
       err:=Createdir(s);
       if err then
         begin
            params[0]:=@s;
            messagebox('The installation directory %s couldn''t be created',
              @params,mferror+mfokbutton);
            createinstalldir:=false;
            exit;
         end;
{$ifndef TP}
 {$IFNDEF OS2}
       FindClose (dir);
 {$ENDIF}
{$endif}
       createinstalldir:=true;
    end;


  function GetProgDir: DirStr;
    var
      D: DirStr;
      N: NameStr;
      E: ExtStr;
    begin
       FSplit (FExpand (ParamStr (0)), D, N, E);
       if (D [0] <> #0) and (D [byte (D [0])] = '\') then Dec (D [0]);
       GetProgDir := D;
    end;


{*****************************************************************************
                          Writing of ppc386.cfg
*****************************************************************************}

  procedure writedefcfg(const fn:string);
    var
      t      : text;
      i      : longint;
      s      : string;
      dir    : searchrec;
      params : array[0..0] of pointer;
      d : dirstr;
      n : namestr;
      e : extstr;
    begin
    { already exists }
      findfirst(fn,AnyFile,dir);
      if doserror=0 then
       begin
         params[0]:=@fn;
         if MessageBox('Config %s already exists, continue writing default config?',@params,
                       mfinformation+mfyesbutton+mfnobutton)=cmNo then
           exit;
       end;
    { create directory }
      fsplit(fn,d,n,e);
      createdir(d);
    { create the ppc386.cfg }
      assign(t,fn);
      {$I-}
       rewrite(t);
      {$I+}
      if ioresult<>0 then
       begin
         params[0]:=@fn;
         MessageBox(#3'Default config not written.'#13#3'%s'#13#3'couldn''t be created',@params,mfinformation+mfokbutton);
         exit;
       end;
      for i:=1 to cfg.defcfgs do
       if assigned(cfg.defcfg[i]) then
         begin
           s:=cfg.defcfg[i]^;
           Replace(s,'$1',data.basepath);
           writeln(t,s);
         end
       else
         writeln(t,'');
      close(t);
    end;


{*****************************************************************************
                               TUnZipDialog
*****************************************************************************}

  constructor tunzipdialog.Init(var Bounds: TRect; ATitle: TTitleStr);
    var
      r : trect;
    begin
      inherited init(bounds,atitle);
(*      R.Assign (11, 4, 38, 6);*)
      R.Assign (1, 4, 39, 6);
      filetext:=new(pstatictext,init(r,#3'File: '));
      insert(filetext);
    end;

{$IFNDEF DLL}
  procedure UnzipCheckFn (Retcode: longint; Rec: pReportRec );{$ifdef Delphi32}STDCALL;{$endif}
  {$IFNDEF BIT32} FAR;{$ENDIF BIT32}
  begin
    case Rec^.Status of
     unzip_starting: UnzipErr := 0;
     file_failure: UnzipErr := RetCode;
     file_unzipping:
        begin
         with UnzDlg^.FileText^ do
         begin
          Inc (StatusPos);
          if StatusPos > MaxStatusPos then StatusPos := 1;
          Text^ [Length (Text^)] := StatusChars [StatusPos];
          DrawView;
         end;
        end;
    end;
  end;
{$ENDIF}

  procedure tunzipdialog.do_unzip(s,topath : string);
    var
      again : boolean;
      fn,dir,wild : string;
      Cnt: integer;
    begin
       Disposestr(filetext^.text);
       filetext^.Text:=NewStr(#3'File: '+s + #13#3' ');
       filetext^.drawview;
       if not(file_exists(s,startpath)) then
         begin
            messagebox('File "'+s+'" missing for the selected installation. '+
                       'Installation hasn''t been completed.',nil,mferror+mfokbutton);
            errorhalt;
         end;
{$IFNDEF DLL}
 {$IFDEF FPC}
       SetUnzipReportProc (@UnzipCheckFn);
 {$ELSE FPC}
       SetUnzipReportProc (UnzipCheckFn);
 {$ENDIF FPC}
{$ENDIF DLL}
       repeat
         fn:=startpath+DirSep+s+#0;
         dir:=topath+#0;
         wild:=AllFiles + #0;
         again:=false;
         FileUnzipEx(@fn[1],@dir[1],@wild[1]);
         if (UnzipErr <> 0) then
           begin
              Str(UnzipErr,s);
              if messagebox('Error (' + S + ') while extracting. Disk full?'#13+
                            #13#3'Try again?',nil,mferror+mfyesbutton+mfnobutton)=cmNo then
               errorhalt
              else
               again:=true;
           end;
       until not again;
    end;


{*****************************************************************************
                               TEndDialog
*****************************************************************************}

  constructor tenddialog.init;
    var
      R       : TRect;
      P       : PStaticText;
      Control : PButton;
      YB: word;
{$IFNDEF LINUX}
      i : longint;
      S: string;
      WPath: boolean;
{$ENDIF}
{$IFDEF OS2}
      ErrPath: array [0..259] of char;
      Handle: longint;
      WLibPath: boolean;
    const
      EMXName: array [1..4] of char = 'EMX'#0;
{$ENDIF}
    begin
      YB := 14;

{$IFNDEF LINUX}
      s:='';
      for i:=1 to cfg.packs do
       if cfg.pack[i].binsub<>'' then
        begin
          if s<>'' then
           s:=s+';';
          S := s+Data.BasePath + Cfg.pack[i].BinSub;
        end;
      if Pos (Upper (S), Upper (GetEnv ('PATH'))) = 0 then
       begin
         WPath := true;
         Inc (YB, 2);
       end
      else
       WPath := false;
  {$IFDEF OS2}
      if DosLoadModule (@ErrPath, SizeOf (ErrPath), @EMXName, Handle) = 0 then
       begin
         WLibPath := false;
         DosFreeModule (Handle);
       end
      else
       begin
         WLibPath := true;
         Inc (YB, 2);
       end;
  {$ENDIF}
{$ENDIF}

      R.Assign(6, 6, 74, YB);
      inherited init(r,'Installation Successfull');

{$IFNDEF LINUX}
      if WPath then
       begin
         R.Assign(2, 3, 64, 5);
         P:=new(pstatictext,init(r,'Extend your PATH variable with '''+S+''''));
         insert(P);
       end;

  {$IFDEF OS2}
      if WLibPath then
       begin
         if WPath then
          S := 'and your LIBPATH with ''' + S + '\dll'''
         else
          S := 'Extend your LIBPATH with ''' + S + '\dll''';
         R.Assign (2, YB - 13, 64, YB - 11);
         P := New (PStaticText, Init (R, S));
         Insert (P);
       end;
  {$ENDIF}
{$ENDIF}

      R.Assign(2, YB - 11, 64, YB - 10);
      P:=new(pstatictext,init(r,'To compile files enter '''+cfg.pack[1].ppc386+' [file]'''));
      insert(P);

      R.Assign (29, YB - 9, 39, YB - 7);
      Control := New (PButton, Init (R,'~O~k', cmOK, bfDefault));
      Insert (Control);
    end;


{*****************************************************************************
                               TInstallDialog
*****************************************************************************}

  var
     islfn : boolean;

  procedure lfnreport( Retcode : longint;Rec : pReportRec );
{$IFDEF TP}
                                                             far;
{$ENDIF}

    var
       p : pathstr;
       n : namestr;
       e : extstr;

    begin
       fsplit(strpas(rec^.Filename),p,n,e);
       if length(n)>8 then
         islfn:=true;
    end;

  function haslfn(const zipfile,path : string) : boolean;

    var
       buf : array[0..255] of char;

    begin
       strpcopy(buf,path+DirSep+zipfile);
       islfn:=false;
{$ifdef FPC}
       ViewZip(buf,AllFiles,@lfnreport);
{$else FPC}
       ViewZip(buf,AllFiles,lfnreport);
{$endif FPC}
       haslfn:=islfn;
    end;

  constructor tinstalldialog.init;
    const
       width = 76;
       height = 21;
       x1 = (79-width) div 2;
       y1 = (23-height) div 2;
       x2 = x1+width;
       y2 = y1+height;
    var
       tabr,tabir,r : trect;
       packmask : array[1..maxpacks] of longint;
       i,line,j : integer;
       items : array[1..maxpacks] of psitem;
       f : pview;
       found : boolean;
       okbut,cancelbut : pbutton;
       firstitem : array[1..maxpacks] of integer;
       packcbs : array[1..maxpacks] of pcheckboxes;
       packtd : ptabdef;
       labpath : plabel;
       ilpath : pinputline;
       tab : ptab;
       titletext : pcoloredtext;
       labcfg : plabel;
       cfgcb : pcheckboxes;
    begin
       f:=nil;
     { walk packages reverse and insert a newsitem for each, and set the mask }
       for j:=1 to cfg.packs do
        with cfg.pack[j] do
         begin
           firstitem[j]:=0;
           items[j]:=nil;
           packmask[j]:=0;
           for i:=packages downto 1 do
            begin
              if file_exists(package[i].zip,startpath) then
               begin
{$ifdef go32v2}
                 if not(lfnsupport) then
                   begin
                      if not(haslfn(package[i].zip,startpath)) then
                        begin
                           items[j]:=newsitem(package[i].name+diskspace(startpath+DirSep+package[i].zip),items[j]);
                           packmask[j]:=packmask[j] or packagemask(i);
                           firstitem[j]:=i;
                           if createlog then
                             writeln(log,'Checking lfn usage for ',startpath+DirSep+package[i].zip,' ... no lfn');
                        end
                      else
                        begin
                           items[j]:=newsitem(package[i].name+' (requires LFN support)',items[j]);
                           if createlog then
                             writeln(log,'Checking lfn usage for ',startpath+DirSep+package[i].zip,' ... uses lfn');
                        end;
                   end
                 else
{$endif go32v2}
                   begin
                      items[j]:=newsitem(package[i].name+diskspace(startpath+DirSep+package[i].zip),items[j]);
                      packmask[j]:=packmask[j] or packagemask(i);
                      firstitem[j]:=i;
                   end;
               end
              else
               items[j]:=newsitem(package[i].name,items[j]);
            end;
         end;

     { If no component found abort }
       found:=false;
       for j:=1 to cfg.packs do
        if packmask[j]<>0 then
         found:=true;
       if not found then
        begin
          messagebox('No components found to install, aborting.',nil,mferror+mfokbutton);
          errorhalt;
        end;

       r.assign(x1,y1,x2,y2);
       inherited init(r,'');
       GetExtent(R);
       R.Grow(-2,-1);
       Dec(R.B.Y,2);
       TabR.Copy(R);
       TabIR.Copy(R);
       TabIR.Grow(-2,-2);
       TabIR.Move(-2,0);

       {-------- General Sheets ----------}
       R.Copy(TabIR);
       r.move(0,1);
       r.b.x:=r.a.x+40;
       r.b.y:=r.a.y+1;
       new(titletext,init(r,cfg.title,$71));

       r.move(0,2);
       r.b.x:=r.a.x+40;
       new(labpath,init(r,'~B~ase path',f));
       r.move(0,1);
       r.b.x:=r.a.x+40;
       r.b.y:=r.a.y+1;
       new(ilpath,init(r,high(DirStr)));

       r.move(0,2);
       r.b.x:=r.a.x+40;
       new(labcfg,init(r,'Con~f~ig',f));
       r.move(0,1);
       r.b.x:=r.a.x+40;
       r.b.y:=r.a.y+1;
       new(cfgcb,init(r,newsitem('create ppc386.cfg',nil)));
       data.cfgval:=1;

       {-------- Pack Sheets ----------}
       for j:=1 to cfg.packs do
        begin
          R.Copy (TabIR);
          new(packcbs[j],init(r,items[j]));
          if data.packmask[j]=$ffff then
           data.packmask[j]:=packmask[j];
          packcbs[j]^.enablemask:=packmask[j];
          packcbs[j]^.movedto(firstitem[j]);
        end;

       {--------- Main ---------}
       packtd:=nil;
       for j:=cfg.packs downto 1 do
        packtd:=NewTabDef(cfg.pack[j].name,packcbs[j],NewTabItem(packcbs[j],nil),packtd);

       New(Tab, Init(TabR,
         NewTabDef('~G~eneral',IlPath,
           NewTabItem(TitleText,
           NewTabItem(LabPath,
           NewTabItem(ILPath,
           NewTabItem(LabCfg,
           NewTabItem(CfgCB,
           nil))))),
         packtd)
       ));
       Tab^.GrowMode:=0;
       Insert(Tab);

       line:=tabr.b.y;
       r.assign((width div 2)-18,line,(width div 2)-4,line+2);
       new(okbut,init(r,'~C~ontinue',cmok,bfdefault));
       Insert(OkBut);

       r.assign((width div 2)+4,line,(width div 2)+14,line+2);
       new(cancelbut,init(r,'~Q~uit',cmcancel,bfnormal));
       Insert(CancelBut);

       Tab^.Select;
    end;


{*****************************************************************************
                                TApp
*****************************************************************************}

  const
     cmstart = 1000;

  procedure tapp.do_installdialog;
    var
       p    : pinstalldialog;
       p3   : penddialog;
       r    : trect;
       result,
       c    : word;
       i,j  : longint;
       found : boolean;
{$ifndef linux}
       DSize,Space,ASpace : longint;
       S: DirStr;
{$endif}
    begin
      data.basepath:=cfg.basepath;
      data.cfgval:=0;
      for j:=1 to cfg.packs do
       data.packmask[j]:=$ffff;

      repeat
      { select components }
        p:=new(pinstalldialog,init);
        c:=executedialog(p,@data);
        if (c=cmok) then
          begin
            if Data.BasePath = '' then
              messagebox('Please, choose the directory for installation first.',nil,mferror+mfokbutton)
            else
             begin
               found:=false;
               for j:=1 to cfg.packs do
                if data.packmask[j]>0 then
                 found:=true;
               if found then
                begin
{$IFNDEF LINUX}
                { TH - check the available disk space here }
                  DSize := 0;
                  for j:=1 to cfg.packs do
                   with cfg.pack[j] do
                    begin
                      for i:=1 to packages do
                       begin
                         if data.packmask[j] and packagemask(i)<>0 then
                         begin
                          ASpace := DiskSpaceN (package[i].zip);
                          if ASpace = -1 then
                              MessageBox ('File ' + package[i].zip +
                                            ' is probably corrupted!', nil,
                                                        mferror + mfokbutton)
                              else Inc (DSize, ASpace);
                         end;
                       end;
                    end;
                  S := FExpand (Data.BasePath);
                  if S [Length (S)] = DirSep then
                   Dec (S [0]);
                  Space := DiskFree (byte (Upcase(S [1])) - 64) shr 10;

                  if Space < DSize then
                   S := 'is not'
                  else
                   S := '';
                  if (Space < DSize + 500) then
                   begin
                     if S = '' then
                      S := 'might not be';
                     if messagebox('There ' + S + ' enough space on the target ' +
                                   'drive for all the selected components. Do you ' +
                                   'want to change the installation path?',nil,
                                   mferror+mfyesbutton+mfnobutton) = cmYes then
                      Continue;
                   end;
{$ENDIF}
                  if createinstalldir(data.basepath) then
                   break;
                end
               else
                begin
                  { maybe only config }
                  if (data.cfgval and 1)<>0 then
                   begin
                     result:=messagebox('No components selected.'#13#13'Create a configfile ?',nil,
                                                mfinformation+mfyesbutton+mfnobutton);
                     if (result=cmYes) and createinstalldir(data.basepath) then
                      begin
                        for i:=1 to cfg.packs do
                         if cfg.pack[i].defcfgfile<>'' then
                          writedefcfg(data.basepath+cfg.pack[i].binsub+DirSep+cfg.pack[i].defcfgfile);
                      end;
                     exit;
                   end
                  else
                   begin
                     result:=messagebox('No components selected.'#13#13'Abort installation?',nil,
                                               mferror+mfyesbutton+mfnobutton);
                     if result=cmYes then
                      exit;
                   end;
                end;
             end;
          end
        else
          exit;
      until false;

    { extract packages }
      for j:=1 to cfg.packs do
       with cfg.pack[j] do
        begin
          r.assign(20,7,60,16);
          UnzDlg:=new(punzipdialog,init(r,'Extracting Packages'));
          desktop^.insert(UnzDlg);
          for i:=1 to packages do
           begin
             if data.packmask[j] and packagemask(i)<>0 then
              UnzDlg^.do_unzip(package[i].zip,data.basepath);
           end;
          desktop^.delete(UnzDlg);
          dispose(UnzDlg,done);
        end;

    { write config }
      if (data.cfgval and 1)<>0 then
       begin
         for i:=1 to cfg.packs do
          if cfg.pack[i].defcfgfile<>'' then
           writedefcfg(data.basepath+cfg.pack[i].binsub+DirSep+cfg.pack[i].defcfgfile);
       end;

    { show end message }
      p3:=new(penddialog,init);
      executedialog(p3,nil);
    end;


  procedure tapp.readcfg(const fn:string);
    var
      t    : text;
      i,j,
      line : longint;
      item,
      s    : string;
      params : array[0..0] of pointer;

{$ifndef FPC}
      procedure readln(var t:text;var s:string);
      var
        c : char;
        i : longint;
      begin
        c:=#0;
        i:=0;
        while (not eof(t)) and (c<>#10) do
         begin
           read(t,c);
           if c<>#10 then
            begin
              inc(i);
              s[i]:=c;
            end;
         end;
        if (i>0) and (s[i]=#13) then
         dec(i);
        s[0]:=chr(i);
      end;
{$endif}

    begin
      assign(t,StartPath + DirSep + fn);
      {$I-}
       reset(t);
      {$I+}
      if ioresult<>0 then
       begin
         StartPath := GetProgDir;
         assign(t,StartPath + DirSep + fn);
         {$I-}
          reset(t);
         {$I+}
         if ioresult<>0 then
          begin
            params[0]:=@fn;
            messagebox('File %s not found!',@params,mferror+mfokbutton);
            errorhalt;
          end;
       end;
      line:=0;
      while not eof(t) do
       begin
         readln(t,s);
         inc(line);
         if (s<>'') and not(s[1] in ['#',';']) then
          begin
            i:=pos('=',s);
            if i>0 then
             begin
               item:=upper(Copy(s,1,i-1));
               system.delete(s,1,i);
               if item='VERSION' then
                cfg.version:=s
               else
                if item='TITLE' then
                 cfg.title:=s
               else
                if item='BASEPATH' then
                 cfg.basepath:=s
               else
                if item='DEFAULTCFG' then
                 begin
                   repeat
                     readln(t,s);
                     if upper(s)='ENDCFG' then
                      break;
                     if cfg.defcfgs<maxdefcfgs then
                      begin
                        inc(cfg.defcfgs);
                        cfg.defcfg[cfg.defcfgs]:=newstr(s);
                      end;
                   until false;
                 end
               else
                if item='PACK' then
                 begin
                   inc(cfg.packs);
                   if cfg.packs>maxpacks then
                    begin
                      writeln('Too much packs');
                      halt(1);
                    end;
                   cfg.pack[cfg.packs].name:=s;
                 end
               else
                if item='CFGFILE' then
                 begin
                   if cfg.packs=0 then
                    begin
                      writeln('No pack set');
                      halt(1);
                    end;
                   cfg.pack[cfg.packs].defcfgfile:=s
                 end
               else
                if item='PPC386' then
                 begin
                   if cfg.packs=0 then
                    begin
                      writeln('No pack set');
                      halt(1);
                    end;
                   cfg.pack[cfg.packs].ppc386:=s;
                 end
               else
                if item='BINSUB' then
                 begin
                   if cfg.packs=0 then
                    begin
                      writeln('No pack set');
                      halt(1);
                    end;
                   cfg.pack[cfg.packs].binsub:=s;
                 end
               else
                if item='FILECHECK' then
                 begin
                   if cfg.packs=0 then
                    begin
                      writeln('No pack set');
                      halt(1);
                    end;
                   cfg.pack[cfg.packs].filechk:=s;
                 end
               else
                if item='PACKAGE' then
                 begin
                   if cfg.packs=0 then
                    begin
                      writeln('No pack set');
                      halt(1);
                    end;
                   with cfg.pack[cfg.packs] do
                    begin
                      j:=pos(',',s);
                      if (j>0) and (packages<maxpackages) then
                       begin
                         inc(packages);
                         package[packages].zip:=copy(s,1,j-1);
                         package[packages].name:=copy(s,j+1,255);
                       end;
                    end;
                 end
             end;
          end;
       end;
      close(t);
    end;


  procedure tapp.checkavailpack;
    var
      j : longint;
      dir : searchrec;
    begin
    { check the packages }
      j:=0;
      while (j<cfg.packs) do
       begin
         inc(j);
         if cfg.pack[j].filechk<>'' then
          begin
            findfirst(cfg.pack[j].filechk,$20,dir);
            if doserror<>0 then
             begin
               { remove the package }
               move(cfg.pack[j+1],cfg.pack[j],sizeof(tpack)*(cfg.packs-j));
               dec(cfg.packs);
               dec(j);
             end;
{$IFNDEF TP}
            findclose(dir);
{$ENDIF}
          end;
       end;
     end;


  procedure tapp.initmenubar;
    var
       r : trect;
    begin
       getextent(r);
       r.b.y:=r.a.y+1;
       menubar:=new(pmenubar,init(r,newmenu(
          newsubmenu('Free Pascal Installer',hcnocontext,newmenu(nil
          ),
       nil))));
    end;


  procedure tapp.handleevent(var event : tevent);
    begin
       inherited handleevent(event);
       if event.what=evcommand then
         if event.command=cmstart then
           begin
              clearevent(event);
              do_installdialog;
              if successfull then
               begin
                 event.what:=evcommand;
                 event.command:=cmquit;
                 handleevent(event);
               end;
           end;
    end;

{$IFDEF DOSSTUB}
function CheckOS2: boolean;
var
 OwnName: PathStr;
 OwnDir: DirStr;
 Name: NameStr;
 Ext: ExtStr;
 DosV, W: word;
 P: PChar;
const
 Title: string [15] = 'FPC Installer'#0;
 RunBlock: TRunBlock = (Length: $32;
                        Dependent: 0;
                        Background: 0;
                        TraceLevel: 0;
                        PrgTitle: @Title [1];
                        PrgName: nil;
                        Args: nil;
                        TermQ: 0;
                        Environment: nil;
                        Inheritance: 0;
                        SesType: 2;
                        Icon: nil;
                        PgmHandle: 0;
                        PgmControl: 2;
                        Column: 0;
                        Row: 0;
                        Width: 80;
                        Height: 25);
begin
 CheckOS2 := false;
 asm
  mov ah, 30h
  int 21h
  xchg ah, al
  mov DosV, ax
  mov ax, 4010h
  int 2Fh
  cmp ax, 4010h
  jnz @0
  xor bx, bx
@0:
  mov W, bx
 end;
 if DosV > 3 shl 8 then
 begin
  OwnName := FExpand (ParamStr (0));
  FSplit (OwnName, OwnDir, Name, Ext);
  if (DosV >= 20 shl 8 + 10) and (W >= 20 shl 8 + 10) then
                       (* OS/2 version 2.1 or later running (double-checked) *)
  begin
   OwnName [Succ (byte (OwnName [0]))] := #0;
   RunBlock.PrgName := @OwnName [1];
   P := Ptr (PrefixSeg, $80);
   if PByte (P)^ <> 0 then
   begin
    Inc (P);
    RunBlock.Args := Ptr (PrefixSeg, $81);
   end;
   asm
    mov ax, 6400h
    mov bx, 0025h
    mov cx, 636Ch
    mov si, offset RunBlock
    int 21h
    jc @0
    mov DosV, 0
@0:
   end;
   CheckOS2 := DosV = 0;
  end;
 end;
end;
{$ENDIF}

var
   i : longint;

begin
{$ifdef FPC}
{$ifdef win32}
  Dos.Exec(GetEnv('COMSPEC'),'/C echo This dummy call gets the mouse to become visible');
{$endif win32}
{$endif FPC}
(* TH - no error boxes if checking an inaccessible disk etc. *)
{$IFDEF OS2}
 {$IFDEF FPC}
   DosCalls.DosError (0);
 {$ELSE FPC}
  {$IFDEF VirtualPascal}
   OS2Base.DosError (ferr_DisableHardErr);
  {$ELSE VirtualPascal}
   BseDos.DosError (0);
  {$ENDIF VirtualPascal}
 {$ENDIF FPC}
{$ENDIF}
{$IFDEF DOSSTUB}
   if CheckOS2 then Halt;
{$ENDIF}
   createlog:=false;
   for i:=1 to paramcount do
     begin
        if paramstr(i)='-l' then
          createlog:=true
        else if paramstr(i)='-h' then
          begin
             writeln('FPC Installer Copyright (c) 1993-2000 Florian Klaempfl');
             writeln('Command line options:');
             writeln('  -l   create log file');
             writeln;
             writeln('  -h   displays this help');
             halt(0);
          end
        else
          begin
             writeln('Illegal command line parameter: ',paramstr(i));
             halt(1);
          end;
     end;
   if createlog then
     begin
        assign(log,'install.log');
        rewrite(log);
        if not(lfnsupport) then
          writeln(log,'OS doesn''t have LFN support');
     end;
   getdir(0,startpath);
   successfull:=false;

   fillchar(cfg, SizeOf(cfg), 0);
   fillchar(data, SizeOf(data), 0);

   installapp.init;

   FSplit (FExpand (ParamStr (0)), DStr, CfgName, EStr);

   installapp.readcfg(CfgName + CfgExt);
   installapp.checkavailpack;
{   installapp.readcfg(startpath+dirsep+cfgfile);}
   if not(lfnsupport) then
     MessageBox('The operating system doesn''t support LFN (long file names),'+
       ' so some packages won''t be installed',nil,mfinformation or mfokbutton);
   installapp.do_installdialog;
   installapp.done;
   if createlog then
     close(log);
end.
{
  $Log$
  Revision 1.3  2000-09-17 14:44:12  hajny
    * compilable with TP again

  Revision 1.2  2000/07/21 10:43:01  florian
    + added for lfn support

  Revision 1.1  2000/07/13 06:30:21  michael
  + Initial import

  Revision 1.20  2000/07/09 12:55:45  hajny
    * updated for version 1.0

  Revision 1.19  2000/06/18 18:27:32  hajny
    + archive validity checking, progress indicator, better error checking

  Revision 1.18  2000/02/24 17:47:47  peter
    * last fixes for 0.99.14a release

  Revision 1.17  2000/02/23 17:17:56  peter
    * write ppc386.cfg for all found targets

  Revision 1.16  2000/02/06 12:59:39  peter
    * change upper -> upcase
    * fixed stupid debugging leftover with diskspace check

  Revision 1.15  2000/02/02 17:19:10  pierre
   * avoid diskfree problem and get mouse visible

  Revision 1.14  2000/02/02 15:21:31  peter
    * show errorcode in message when error in unzipping

  Revision 1.13  2000/01/26 21:49:33  peter
    * install.pas compilable by FPC again
    * removed some notes from unzip.pas
    * support installer creation under linux (install has name conflict)

  Revision 1.12  2000/01/26 21:15:59  hajny
    * compilable with TP again (lines < 127install.pas, ifdef around findclose)

  Revision 1.11  2000/01/24 22:21:48  peter
    * new install version (keys not wrong correct yet)

  Revision 1.10  2000/01/18 00:22:48  peter
    * fixed uninited local var

  Revision 1.9  1999/08/03 20:21:53  peter
    * fixed sources mask which was not set correctly

  Revision 1.7  1999/07/01 07:56:58  hajny
    * installation to root fixed

  Revision 1.6  1999/06/29 22:20:19  peter
    * updated to use tab pages

  Revision 1.5  1999/06/25 07:06:30  hajny
    + searching for installation script updated

  Revision 1.4  1999/06/10 20:01:23  peter
    + fcl,fv,gtk support

  Revision 1.3  1999/06/10 15:00:14  peter
    * fixed to compile for not os2
    * update install.dat

  Revision 1.2  1999/06/10 07:28:27  hajny
    * compilable with TP again

  Revision 1.1  1999/02/19 16:45:26  peter
    * moved to fpinst/ directory
    + makefile

  Revision 1.15  1999/02/17 22:34:08  peter
    * updates from TH for OS2

  Revision 1.14  1998/12/22 22:47:34  peter
    * updates for OS2
    * small fixes

  Revision 1.13  1998/12/21 13:11:39  peter
    * updates for 0.99.10

  Revision 1.12  1998/12/16 00:25:34  peter
    * updated for 0.99.10
    * new end dialogbox

  Revision 1.11  1998/11/01 20:32:25  peter
    * packed record

  Revision 1.10  1998/10/25 23:38:35  peter
    * removed warnings

  Revision 1.9  1998/10/23 16:57:40  pierre
   * compiles without -So option
   * the main dialog init was buggy !!

  Revision 1.8  1998/09/22 21:10:31  jonas
    * initialize cfg and data with 0 at startup

  Revision 1.7  1998/09/16 16:46:37  peter
    + updates

  Revision 1.6  1998/09/15 13:11:14  pierre
  small fix to cleanup if no package

  Revision 1.5  1998/09/15 12:06:06  peter
    * install updated to support w32 and dos and config file

  Revision 1.4  1998/09/10 10:50:49  florian
    * DOS install program updated

  Revision 1.3  1998/09/09 13:39:58  peter
    + internal unzip
    * dialog is showed automaticly

  Revision 1.2  1998/04/07 22:47:57  florian
    + version/release/patch numbers as string added

}
