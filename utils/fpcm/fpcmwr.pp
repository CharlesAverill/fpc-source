{
    $Id$
    Copyright (c) 2001 by Peter Vreman

    FPCMake - Makefile writer

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
{$ifdef fpc}{$mode objfpc}{$endif}
{$H+}
unit fpcmwr;
interface

    uses
      sysutils,classes,
      fpcmmain;

    type
      tsections=(sec_none,
        sec_units,sec_exes,sec_loaders,sec_examples,
        sec_compile,sec_install,
        sec_zipinstall,sec_clean,sec_libs,
        sec_command,sec_exts,sec_dirs,sec_tools,sec_info
      );

      trules=(
        r_all,r_debug,
        r_examples,
        r_smart,r_shared,
        r_install,r_sourceinstall,r_exampleinstall,r_distinstall,
        r_zipinstall,r_zipsourceinstall,r_zipexampleinstall,r_zipdistinstall,
        r_clean,r_distclean,r_cleanall,
        r_info
      );


    const
      rule2str : array[trules] of string=(
        'all','debug',
        'examples',
        'smart','shared',
        'install','sourceinstall','exampleinstall','distinstall',
        'zipinstall','zipsourceinstall','zipexampleinstall','zipdistinstall',
        'clean','distclean','cleanall',
        'info'
      );

      rule2sec : array[trules] of tsections=(
        sec_compile,sec_compile,
        sec_examples,
        sec_libs,sec_libs,
        sec_install,sec_install,sec_install,sec_install,
        sec_zipinstall,sec_zipinstall,sec_zipinstall,sec_zipinstall,
        sec_clean,sec_clean,sec_clean,
        sec_info
      );



    type
      TMakefileWriter=class
      private
        FFileName : string;
        FIni    : TFPCMake;
        FInput  : TFPCMake;
        FOutput : TStringList;
        FPhony  : string;
        FHasSection : array[tsections] of boolean;
        procedure LoadFPCMakeIni;
        procedure AddIniSection(const s:string);
        procedure AddCustomSection(const s:string);
        procedure AddTargetVariable(const inivar:string);
        procedure AddVariable(const inivar:string);
        function  AddTargetDefines(const inivar,prefix:string):string;
        procedure AddRequiredPackages;
        procedure AddTools(const inivar:string);
        procedure AddRules;
        procedure AddPhony(const s:string);
        procedure WritePhony;
        procedure AddTargetDirs(const inivar:string);
        function  CheckTargetVariable(const inivar:string):boolean;
        function  CheckVariable(const inivar:string):boolean;
      public
        constructor Create(AFPCMake:TFPCMake;const AFileName:string);
        destructor  Destroy;override;
        procedure WriteGenericMakefile;
      end;


implementation

{$i fpcmake.inc}

    type
      TMyMemoryStream=class(TMemoryStream)
      public
        constructor Create(p:pointer;mysize:integer);
      end;


{*****************************************************************************
                               Helpers
*****************************************************************************}

    function FixVariable(s:string):string;
      var
        i : integer;
      begin
        Result:=UpperCase(s);
        i:=pos('.',Result);
        if i>0 then
         Result[i]:='_';
      end;


    function VarName(const s:string):string;
      var
        i,j : longint;
      begin
        i:=0;
        result:=s;
        while i<length(result) do
         begin
           inc(i);
           case result[i] of
             '{' :
               begin
                 { this are pkgs which are hold the dirs between the accolades }
                 j:=PosIdx('}',result,i);
                 if j>0 then
                  Delete(result,i,j-i+1)
                 else
                  Delete(result,i,1);
                 dec(i);
               end;
             '$','(',')' :
               begin
                 Delete(result,i,1);
                 dec(i);
               end;
             'a'..'z' :
               result[i]:=chr(ord(result[i])-32);
           end;
         end;
      end;


    procedure AddStrNoDup(var s:string;const s2:string);
      var
        i,idx : longint;
        again,add : boolean;
      begin
        add:=false;
        idx:=0;
        repeat
          again:=false;
          i:=posidx(s2,s,idx);
          if (i=0) then
           add:=true
          else
           if (i=1) then
            begin
              if (length(s)>length(s2)) and
                 (s[length(s2)+1]<>' ') then
               add:=true;
            end
          else
           if (i>1) and
              ((s[i-1]<>' ') or
               ((length(s)>=i+length(s2)) and (s[i+length(s2)]<>' '))) then
            begin
              idx:=i+length(s2);
              again:=true;
            end;
        until not again;
        if add then
         begin
           if s='' then
            s:=s2
           else
            s:=s+' '+s2;
         end;
      end;


    procedure FixTab(sl:TStringList);
      var
        i,j,k : integer;
        s,s2  : string;
      begin
        i:=0;
        while (i<sl.Count) do
         begin
           if (sl[i]<>'') and (sl[i][1] in [' ',#9]) then
            begin
              s:=sl[i];
              k:=0;
              j:=0;
              repeat
                inc(j);
                case s[j] of
                  ' ' :
                    inc(k);
                  #9 :
                    k:=(k+7) and not(7);
                  else
                    break;
                end;
              until (j=length(s));
              if k>7 then
               begin
                 s2:='';
                 Delete(s,1,j-1);
                 while (k>7) do
                  begin
                    s2:=s2+#9;
                    dec(k,8);
                  end;
                 while (k>0) do
                  begin
                    s2:=s2+' ';
                    dec(k);
                  end;
                 sl[i]:=s2+s;
               end;
            end;
           inc(i);
         end;
      end;


{*****************************************************************************
                               TMyMemoryStream
*****************************************************************************}

    constructor TMyMemoryStream.Create(p:pointer;mysize:integer);
      begin
        inherited Create;
        SetPointer(p,mysize);
      end;


{*****************************************************************************
                               TMyMemoryStream
*****************************************************************************}

    constructor TMakefileWriter.Create(AFPCMake:TFPCMake;const AFileName:string);
      begin
        FInput:=AFPCMake;
        FFileName:=AFileName;
        FOutput:=TStringList.Create;
        FPhony:='';
        FillChar(FHasSection,sizeof(FHasSection),1);
        LoadFPCMakeIni;
      end;


    destructor TMakefileWriter.Destroy;
      begin
        FOutput.Free;
        FIni.Free;
      end;


    procedure TMakefileWriter.LoadFPCMakeIni;
      var
        IniStream : TStream;
      begin
        try
          IniStream:=TMyMemoryStream.Create(@fpcmakeini,sizeof(fpcmakeini));
          FIni:=TFPCMake.CreateFromStream(IniStream,'fpcmake.ini');
          { Leave the '#' comments in the output }
//          FIni.CommentChars:=[';'];
          FIni.LoadSections;
        finally
          IniStream.Destroy;
        end;
      end;


    procedure TMakefileWriter.AddIniSection(const s:string);
      var
        Sec : TFPCMakeSection;
      begin
        Sec:=TFPCMakeSection(FIni[s]);
        if assigned(Sec) then
         FOutput.AddStrings(Sec.List)
        else
         Raise Exception.Create(Format('Section "%s" doesn''t exists in fpcmake.ini',[s]));
      end;


    procedure TMakefileWriter.AddCustomSection(const s:string);
      var
        Sec : TFPCMakeSection;
      begin
        Sec:=TFPCMakeSection(FInput[s]);
        if assigned(Sec) then
         begin
           Sec.BuildMakefile;
           FOutput.AddStrings(Sec.List);
         end;
      end;


    function TMakefileWriter.CheckTargetVariable(const inivar:string):boolean;
      var
        t : TTarget;
      begin
        result:=false;
        if FInput.GetVariable(IniVar,false)<>'' then
         begin
           result:=true;
           exit;
         end;
        for t:=low(TTarget) to high(TTarget) do
         if FInput.GetVariable(IniVar+TargetSuffix[t],false)<>'' then
          begin
            result:=true;
            exit;
          end;
      end;


    function TMakefileWriter.CheckVariable(const inivar:string):boolean;
      begin
        Result:=(FInput.GetVariable(IniVar,false)<>'');
      end;


    procedure TMakefileWriter.AddTargetVariable(const inivar:string);
      var
        s : string;
        T : TTarget;
      begin
        s:=FInput.GetVariable(IniVar,false);
        if s<>'' then
         FOutput.Add('override '+FixVariable(IniVar)+'+='+s);
        for t:=low(TTarget) to high(TTarget) do
         begin
           s:=FInput.GetVariable(IniVar+TargetSuffix[t],false);
           if s<>'' then
            begin
              FOutput.Add('ifeq ($(OS_TARGET),'+TargetStr[t]+')');
              FOutput.Add('override '+FixVariable(IniVar)+'+='+s);
              FOutput.Add('endif');
            end;
         end;
      end;


    procedure TMakefileWriter.AddVariable(const inivar:string);
      var
        s : string;
      begin
        s:=FInput.GetVariable(IniVar,false);
        if s<>'' then
         FOutput.Add('override '+FixVariable(IniVar)+'='+s)
      end;


    function TMakefileWriter.AddTargetDefines(const inivar,prefix:string):string;
      var
        s : string;
        T : TTarget;
        name : string;
        k1,k2 : integer;
      begin
        result:='';
        s:=FInput.GetVariable(IniVar,false);
        repeat
          name:=GetToken(s);
          if Name='' then
           break;
          { Remove (..) }
          k1:=pos('(',name);
          if k1>0 then
           begin
             k2:=PosIdx(')',name,k1);
             if k2=0 then
              k2:=length(name)+1;
             Delete(Name,k1,k2);
           end;
          FOutput.Add(prefix+VarName(name)+'=1');
          { add to the list of dirs without duplicates }
          AddStrNoDup(result,name);
        until false;
        for t:=low(TTarget) to high(TTarget) do
         begin
           s:=FInput.GetVariable(IniVar+TargetSuffix[t],false);
           if s<>'' then
            begin
              FOutput.Add('ifeq ($(OS_TARGET),'+TargetStr[t]+')');
              repeat
                Name:=GetToken(s);
                if Name='' then
                 break;
                { Remove (..) }
                k1:=pos('(',name);
                if k1>0 then
                 begin
                   k2:=PosIdx(')',name,k1);
                   if k2=0 then
                    k2:=length(name)+1;
                   Delete(Name,k1,k2);
                 end;
                FOutput.Add(prefix+VarName(name)+'=1');
                { add to the list of dirs without duplicates }
                AddStrNoDup(result,name);
              until false;
              FOutput.Add('endif');
            end;
         end;
      end;


    procedure TMakefileWriter.AddTools(const inivar:string);

        procedure AddTool(const exename:string);
        var
          varname : string;
        begin
          with FOutput do
           begin
             varname:=FixVariable(exename);
             Add('ifndef '+varname);
             Add(varname+':=$(strip $(wildcard $(addsuffix /'+exename+'$(SRCEXEEXT),$(SEARCHPATH))))');
             Add('ifeq ($('+varname+'),)');
             Add(varname+'=');
             Add('else');
             Add(varname+':=$(firstword $('+varname+'))');
             Add('endif');
             Add('endif');
             Add('export '+varname);
           end;
        end;

      var
        hs,tool : string;
      begin
        hs:=FInput.GetVariable(inivar,false);
        repeat
          Tool:=GetToken(hs);
          if Tool='' then
           break;
          AddTool(Tool);
        until false;
      end;


    procedure TMakefileWriter.AddRules;

        procedure AddRule(rule:trules);
        var
          i : integer;
          hs : string;
          Sec : TFPCMakeSection;
          Rules : TStringList;
        begin
          Sec:=TFPCMakeSection(FInput['rules']);
          if assigned(Sec) then
           begin
             Rules:=Sec.List;
             for i:=0 to Rules.Count-1 do
              begin
                if (length(rules[i])>length(rule2str[rule])) and
                   (rules[i][1]=rule2str[rule][1]) and
                   ((rules[i][length(rule2str[rule])+1]=':') or
                    ((length(rules[i])>length(rule2str[rule])+1) and
                     (rules[i][length(rule2str[rule])+2]=':'))) and
                   (Copy(rules[i],1,length(rule2str[rule]))=rule2str[rule]) then
                  exit;
              end;
           end;
          hs:='';
          if FHasSection[Rule2Sec[rule]] then
           hs:=hs+' fpc_'+rule2str[rule];
          { include target dirs }
          if CheckTargetVariable('target_dirs') then
           begin
             if CheckVariable('default_dir') then
              hs:=hs+' $(addsuffix _'+rule2str[rule]+',$(DEFAULT_DIR))'
             else
              if not(rule in [r_sourceinstall,r_zipinstall,r_zipsourceinstall]) or
                 not(CheckVariable('package_name')) then
               hs:=hs+' $(addsuffix _'+rule2str[rule]+',$(TARGET_DIRS))';
           end;
          { include cleaning of example dirs }
          if (rule=r_clean) and
             CheckTargetVariable('target_exampledirs') then
           hs:=hs+' $(addsuffix _'+rule2str[rule]+',$(TARGET_EXAMPLEDIRS))';
          { Add the rule }
          AddPhony(Rule2Str[Rule]);
          FOutput.Add(rule2str[rule]+':'+hs);
        end;

      var
        rule : trules;
      begin
        for rule:=low(trules) to high(trules) do
         AddRule(rule);
        WritePhony;
      end;

    procedure TMakefileWriter.AddPhony(const s:string);
      begin
        FPhony:=FPhony+' '+s;
      end;


    procedure TMakefileWriter.WritePhony;
      begin
        if FPhony<>'' then
         begin
           FOutput.Add('.PHONY:'+FPhony);
           FPhony:='';
         end;
      end;


    procedure TMakefileWriter.AddTargetDirs(const inivar:string);

        procedure AddTargetDir(const s,defpref:string);
        var
          j  : trules;
        begin
          FOutput.Add('ifdef '+defpref+VarName(s));
          for j:=low(trules) to high(trules) do
           begin
             FOutput.Add(s+'_'+rule2str[j]+':');
             FOutput.Add(#9+'$(MAKE) -C '+s+' '+rule2str[j]);
             AddPhony(s+'_'+rule2str[j]);
           end;
          FOutput.Add(s+':');
          FOutput.Add(#9+'$(MAKE) -C '+s+' all');
          AddPhony(s);
          WritePhony;
          FOutput.Add('endif');
        end;

      var
        hs,dir : string;
        prefix : string;
      begin
        prefix:=FixVariable(inivar)+'_';
        hs:=AddTargetDefines(inivar,prefix);
        repeat
          Dir:=GetToken(hs);
          if Dir='' then
           break;
          AddTargetDir(Dir,prefix);
        until false;
      end;


    procedure TMakefileWriter.AddRequiredPackages;

        procedure AddPackage(const pack,prefix:string);
        var
          packdirvar,unitdirvar : string;
        begin
          FOutput.Add('ifdef '+Prefix+VarName(pack));
          { create needed variables }
          packdirvar:='PACKAGEDIR_'+VarName(pack);
          unitdirvar:='UNITDIR_'+VarName(pack);
          { Search packagedir by looking for Makefile.fpc }
          FOutput.Add(packdirvar+':=$(subst /Makefile.fpc,,$(strip $(wildcard $(addsuffix /'+pack+'/Makefile.fpc,$(PACKAGESDIR)))))');
          FOutput.Add('ifneq ($('+packdirvar+'),)');
          FOutput.Add(packdirvar+':=$(firstword $('+packdirvar+'))');
          { If Packagedir found look for FPCMade }
          FOutput.Add('ifeq ($(wildcard $('+packdirvar+')/$(FPCMADE)),)');
          FOutput.Add('override COMPILEPACKAGES+=package_'+pack);
          AddPhony('package_'+pack);
          FOutput.Add('package_'+pack+':');
          FOutput.Add(#9'$(MAKE) -C $('+packdirvar+') all');
          FOutput.Add('endif');
          { Create unit dir, check if os dependent dir exists }
          FOutput.Add('ifneq ($(wildcard $('+packdirvar+')/$(OS_TARGET)),)');
          FOutput.Add(unitdirvar+'=$('+packdirvar+')/$(OS_TARGET)');
          FOutput.Add('else');
          FOutput.Add(unitdirvar+'=$('+packdirvar+')');
          FOutput.Add('endif');
          { Package dir doesn't exists, check unit dir }
          FOutput.Add('else');
          FOutput.Add(packdirvar+'=');
          FOutput.Add(unitdirvar+':=$(subst /Package.fpc,,$(strip $(wildcard $(addsuffix /'+pack+'/Package.fpc,$(UNITSDIR)))))');
          FOutput.Add('ifneq ($('+unitdirvar+'),)');
          FOutput.Add(unitdirvar+':=$(firstword $('+unitdirvar+'))');
          FOutput.Add('else');
          FOutput.Add(unitdirvar+'=');
          FOutput.Add('endif');
          FOutput.Add('endif');
          { Add Unit dir to the command line -Fu }
          FOutput.Add('ifdef '+unitdirvar);
          FOutput.Add('override COMPILER_UNITDIR+=$('+unitdirvar+')');
          FOutput.Add('endif');
          { endif for package }
          FOutput.Add('endif');
        end;

      var
        i  : integer;
        reqs,req,prefix : string;
        t : Ttarget;
        sl : TStringList;
      begin
        prefix:='REQUIRE_PACKAGES_';
        reqs:='';
        { Add target defines }
        for t:=low(ttarget) to high(ttarget) do
         begin
           sl:=FInput.GetTargetRequires(t);
           if sl.count>0 then
            begin
              FOutput.Add('ifeq ($(OS_TARGET),'+TargetStr[t]+')');
              for i:=0 to sl.count-1 do
               begin
                 FOutput.Add(prefix+VarName(sl[i])+'=1');
                 AddStrNoDup(reqs,sl[i]);
               end;
              FOutput.Add('endif');
            end;
           sl.Free;
         end;
        { Add all require packages }
        repeat
          req:=GetToken(reqs);
          if Req='' then
           break;
          AddPackage(req,prefix);
        until false;
        WritePhony;
      end;

    procedure TMakefileWriter.WriteGenericMakefile;
      begin
        with FOutput do
         begin
           { Turn some sections off }
           if not FInput.IsPackage then
            FHasSection[sec_zipinstall]:=false;
           { Header }
           Add('#');
           Add('# Don''t edit, this file is generated by '+TitleDate);
           Add('#');
           if CheckVariable('default_rule') then
            Add('default: '+FInput.GetVariable('default_rule',false))
           else
            Add('default: all');
           { Add automatic detect sections }
           AddIniSection('osdetect');
           { Forced target }
           if CheckVariable('default_target') then
            Add('override OS_TARGET='+FInput.GetVariable('default_target',false));
           if CheckVariable('default_cpu') then
            Add('override CPU_TARGET='+FInput.GetVariable('default_cpu',false));
           { FPC Detection }
           AddIniSection('fpcdetect');
           AddIniSection('fpcdircheckenv');
           if CheckVariable('default_fpcdir') then
            begin
              Add('ifeq ($(FPCDIR),wrong)');
              Add('override FPCDIR='+FInput.GetVariable('default_fpcdir',false));
              Add('ifeq ($(wildcard $(FPCDIR)/rtl),)');
              Add('ifeq ($(wildcard $(FPCDIR)/units),)');
              Add('override FPCDIR=wrong');
              Add('endif');
              Add('endif');
              Add('endif');
            end;
           AddIniSection('fpcdirdetect');
           { Package }
           AddVariable('package_name');
           AddVariable('package_version');
           { First add the required packages sections }
//           for i:=0 to FInput.RequireList.Count-1 do
//            AddCustomSection(FInput.Requirelist[i]);
           { prerules section }
           if assigned(FInput['prerules']) then
            AddStrings(TFPCMakeSection(FInput['prerules']).List);
           { Default }
           AddVariable('default_dir');
           { Targets }
           AddTargetVariable('target_dirs');
           AddTargetVariable('target_programs');
           AddTargetVariable('target_units');
           AddTargetVariable('target_loaders');
           AddTargetVariable('target_rsts');
           AddTargetVariable('target_examples');
           AddTargetVariable('target_exampledirs');
           { Clean }
           AddTargetVariable('clean_units');
           AddTargetVariable('clean_files');
           { Install }
           AddTargetVariable('install_units');
           AddTargetVariable('install_files');
           AddVariable('install_prefixdir');
           AddVariable('install_basedir');
           AddVariable('install_datadir');
           { Dist }
           AddVariable('dist_zipname');
           AddVariable('dist_ziptarget');
           { Compiler }
           AddTargetVariable('compiler_options');
           AddTargetVariable('compiler_version');
           AddTargetVariable('compiler_includedir');
           AddTargetVariable('compiler_unitdir');
           AddTargetVariable('compiler_sourcedir');
           AddTargetVariable('compiler_objectdir');
           AddTargetVariable('compiler_librarydir');
           AddTargetVariable('compiler_targetdir');
           AddTargetVariable('compiler_unittargetdir');
           { default dirs/tools/extensions }
           AddIniSection('shelltools');
           AddIniSection('defaulttools');
           AddIniSection('extensions');
           AddIniSection('defaultdirs');
           if FInput.CheckLibcRequire then
            AddIniSection('dirlibc');
           { Required packages }
           AddRequiredPackages;
           { commandline }
           AddIniSection('command_begin');
           if FInput.CheckLibcRequire then
            AddIniSection('command_libc');
           AddIniSection('command_end');
           { compile }
           if CheckTargetVariable('target_loaders') then
            AddIniSection('loaderrules');
           if CheckTargetVariable('target_units') then
            AddIniSection('unitrules');
           if CheckTargetVariable('target_programs') then
            AddIniSection('exerules');
           if CheckTargetVariable('target_rsts') then
            AddIniSection('rstrules');
           if CheckTargetVariable('target_examples') or
              CheckTargetVariable('target_exampledirs') then
            AddIniSection('examplerules');
           AddIniSection('compilerules');
           if CheckVariable('lib_name') then
            AddIniSection('libraryrules');
           { install }
           AddIniSection('installrules');
           if FHasSection[sec_zipinstall] then
            AddIniSection('zipinstallrules');
           { clean }
           AddIniSection('cleanrules');
           { info }
           AddIniSection('inforules');
           { Subdirs }
           AddTargetDirs('target_dirs');
           AddTargetDirs('target_exampledirs');
           { Tools }
           AddTools('require_tools');
           { Rules }
           AddRules;
           { Users own rules }
           AddIniSection('localmakefile');
           AddIniSection('userrules');
           if assigned(FInput['rules']) then
            AddStrings(TFPCMakeSection(FInput['rules']).List);
         end;
        { write to disk }
        Fixtab(FOutput);
        FOutput.SaveToFile(FFileName);
      end;

end.
{
  $Log$
  Revision 1.6  2001-02-24 10:44:33  peter
    * another fix for internal variable checking

  Revision 1.5  2001/02/22 21:11:24  peter
    * fpcdir detection added
    * fixed loading of variables in fpcmake itself

  Revision 1.4  2001/02/20 21:49:31  peter
    * fixed change variable accessing using _ instead of .

  Revision 1.3  2001/02/01 22:00:10  peter
    * default.fpcdir is back
    * subdir requirement checking works, but not very optimal yet as
      it can load the same Makefile.fpc multiple times

  Revision 1.2  2001/01/29 21:49:10  peter
    * lot of updates

  Revision 1.1  2001/01/24 21:59:36  peter
    * first commit of new fpcmake

}
