program MiniZip;

{ minizip demo package by Gilles Vollant

  Usage : minizip [-o] file.zip [files_to_add]

  a file.zip file is created, all files listed in [files_to_add] are added
  to the new .zip file.
  -o an existing .zip file with be overwritten without warning

  Pascal tranlastion
  Copyright (C) 2000 by Jacques Nomssi Nzali
  For conditions of distribution and use, see copyright notice in readme.txt
}

{$ifdef WIN32}
  {$define Delphi}
  {$ifndef FPC}
    {$define Delphi32}
  {$endif}
{$endif}

uses
 Sysutils,
 {$ifdef Delphi}
  Windows,
 {$else}
   zlib,ctypes,
 {$endif}
  //zutil,
  //zlib,
  ziputils,
  zip;

const
  WRITEBUFFERSIZE = Z_BUFSIZE;
  MAXFILENAME     = Z_MAXFILENAMEINZIP;

{$ifdef Delphi32}
  function filetime(f: PChar;               { name of file to get info on }
  var tmzip: tm_zip; { return value: access, modific. and creation times }
  var dt: uLong): uLong;                { dostime }
  var
    ret:     int;
  var
    ftLocal: TFileTime; // FILETIME;
    hFind:   THandle;   // HANDLE;
    ff32:    TWIN32FindData; //  WIN32_FIND_DATA;
  begin
    ret   := 0;
    hFind := FindFirstFile(f, ff32);
    if (hFind <> INVALID_HANDLE_VALUE) then
    begin
      FileTimeToLocalFileTime(ff32.ftLastWriteTime, ftLocal);
      FileTimeToDosDateTime(ftLocal, LongRec(dt).hi, LongRec(dt).lo);
      FindClose(hFind);
      ret := 1;
    end;
    filetime := ret;
  end;

{$else}
{$ifdef delphi)} // fpcwin32
function filetime(f : PChar;               { name of file to get info on }
   var tmzip : tm_zip; { return value: access, modific. and creation times }
   var dt : uLong) : uLong;                { dostime }
var
  ret : longint;
var
  ftLocal : TFileTime; // FILETIME;
  hFind : THandle; // HANDLE;
  ff32 : TWIN32FindData; //  WIN32_FIND_DATA;
begin
  ret := 0;
  hFind := FindFirstFile(f, @ff32);
  if (hFind <> INVALID_HANDLE_VALUE) then
  begin
    FileTimeToLocalFileTime(ff32.ftLastWriteTime,ftLocal);
    FileTimeToDosDateTime(ftLocal,LongRec(dt).hi,LongRec(dt).lo);
    FindClose(hFind);
    ret := 1;
  end;
  filetime := ret;
end;
{$else}
function filetime(f : PChar;               { name of file to get info on }
   var tmzip : tm_zip; { return value: access, modific. and creation times }
   var dt : cuLong) : cuLong;                { dostime }
var
  fl : file;
  yy, mm, dd, dow : Word;
  h, m, s, hund : Word; { For GetTime}
  dtrec : TDateTime; { For Pack/UnpackTime}
  stime:tsystemtime;
begin
  dtrec:=FileDateToDateTime(fileage(f));
  datetimetosystemtime(dtrec,stime);
  tmzip.tm_sec  := stime.second;
  tmzip.tm_min  := stime.minute;
  tmzip.tm_hour := stime.hour;
  tmzip.tm_mday := stime.day;
  tmzip.tm_mon  := stime.month;
  tmzip.tm_year := stime.year;
  filetime := 0;
end;
{$endif}
{$endif}

  function check_exist_file(const filename: PChar): longint;
  var
    ftestexist: file;
    ret: longint;
  begin
    ret := 1;
    Assign(ftestexist, filename);
  {$i-}
    reset(ftestexist);
    if IOresult <> 0 then
      ret := 0
    else
      system.Close(ftestexist);
    check_exist_file := ret;
  end;

  procedure do_banner;
  begin
    WriteLn('MiniZip 0.15, demo package written by Gilles Vollant');
    WriteLn('Pascal port by Jacques Nomssi Nzali');
    WriteLn('more info at http://www.tu-chemnitz.de/~nomssi/paszlib.html');
    WriteLn;
  end;

  procedure do_help;
  begin
    WriteLn('Usage : minizip [-o] file.zip [files_to_add]');
    WriteLn;
  end;

  function main: longint;
  var
    argstr: string;
    i:      longint;
    opt_overwrite: longint;
    opt_compress_level: longint;
    zipfilenamearg: longint;
    filename_try: array[0..MAXFILENAME - 1] of char;
    zipok:  longint;
    err:    longint;
    size_buf: longint;
    buf:    pointer;
  var
    p:      PChar;
    c:      char;
  var
    len:    longint;
    dot_found: longint;
  var
    rep:    char;
    answer: string[128];
  var
    zf:     zipFile;
    errclose: longint;
  var
    fin:    FILEptr;
    size_read: longint;
    filenameinzip: {const} PChar;
    zi:     zip_fileinfo;
  begin
    opt_overwrite := 0;
    opt_compress_level := Z_DEFAULT_COMPRESSION;
    zipfilenamearg := 0;
    err  := 0;
    main := 0;

    do_banner;
    if (ParamCount = 0) then
    begin
      do_help;
      main := 0;
      exit;
    end
    else
      for i := 1 to ParamCount - 1 + 1 do
      begin
        argstr := ParamStr(i) + #0;
        if (argstr[1] = '-') then
        begin
          p := @argstr[1 + 1];       {const char *p=argv[i]+1;}

          while (p^ <> #0) do
          begin
            c := p^;
            Inc(p);
            if (c = 'o') or (c = 'O') then
              opt_overwrite := 1;
            if (c >= '0') and (c <= '9') then
              opt_compress_level := byte(c) - byte('0');
          end;
        end
        else
        if (zipfilenamearg = 0) then
          zipfilenamearg := i;
      end;

    size_buf := WRITEBUFFERSIZE;
    buf      := AllocMem(size_buf);
    if (buf = nil) then
    begin
      WriteLn('Error allocating memory');
      main := ZIP_INTERNALERROR;
      exit;
    end;

    if (zipfilenamearg = 0) then
      zipok := 0
    else
    begin
      dot_found := 0;

      zipok  := 1;
      argstr := ParamStr(zipfilenamearg) + #0;
      strcopy(filename_try, PChar(@argstr[1]));
      len := strlen(filename_try);
      for i := 0 to len - 1 do
        if (filename_try[i] = '.') then
          dot_found := 1;

      if (dot_found = 0) then
        strcat(filename_try, '.zip');

      if (opt_overwrite = 0) then
        if (check_exist_file(filename_try) <> 0) then
        begin
          repeat
            WriteLn('The file ', filename_try,
              ' exist. Overwrite ? [y]es, [n]o : ');
            ReadLn(answer);
            rep := answer[1];
            if (rep >= 'a') and (rep <= 'z') then
              Dec(rep, $20);
          until (rep = 'Y') or (rep = 'N');
          if (rep = 'N') then
            zipok := 0;
        end;
    end;

    if (zipok = 1) then
    begin
      zf := zipOpen(filename_try, 0);
      if (zf = nil) then
      begin
        WriteLn('error opening ', filename_try);
        err := ZIP_ERRNO;
      end
      else
        WriteLn('creating ', filename_try);

      i := zipfilenamearg + 1;
      while (i <= ParamCount) and (err = ZIP_OK) do
      begin
        argstr := ParamStr(i) + #0;
        if (argstr[1] <> '-') and (argstr[1] <> '/') then
        begin
          filenameinzip := PChar(@argstr[1]);

          zi.tmz_date.tm_sec := 0;
          zi.tmz_date.tm_min := 0;
          zi.tmz_date.tm_hour := 0;
          zi.tmz_date.tm_mday := 0;
          zi.tmz_date.tm_min := 0;
          zi.tmz_date.tm_year := 0;
          zi.dosDate     := 0;
          zi.internal_fa := 0;
          zi.external_fa := 0;
          filetime(filenameinzip, zi.tmz_date, zi.dosDate);

          if (opt_compress_level <> 0) then
            err := zipOpenNewFileInZip(zf, filenameinzip, @zi,
              nil, 0, nil, 0, nil { comment}, Z_DEFLATED, opt_compress_level)
          else
            err := zipOpenNewFileInZip(zf, filenameinzip, @zi,
              nil, 0, nil, 0, nil, 0, opt_compress_level);

          if (err <> ZIP_OK) then
            WriteLn('error in opening ', filenameinzip, ' in zipfile')
          else
          begin
            fin := fopen(filenameinzip, fopenread);
            if (fin = nil) then
            begin
              err := ZIP_ERRNO;
              WriteLn('error in opening ', filenameinzip, ' for reading');
            end;

            if (err = ZIP_OK) then
              repeat
                err := ZIP_OK;
                size_read := fread(buf, 1, size_buf, fin);

                if (size_read < size_buf) then
                  if feof(fin) = 0 then
                  begin
                    WriteLn('error in reading ', filenameinzip);
                    err := ZIP_ERRNO;
                  end;

                if (size_read > 0) then
                begin
                  err := zipWriteInFileInZip(zf, buf, size_read);
                  if (err < 0) then
                    WriteLn('error in writing ', filenameinzip, ' in the zipfile');
                end;
              until (err <> ZIP_OK) or (size_read = 0);

            fclose(fin);
          end;
          if (err < 0) then
            err := ZIP_ERRNO
          else
          begin
            err := zipCloseFileInZip(zf);
            if (err <> ZIP_OK) then
              WriteLn('error in closing ', filenameinzip, ' in the zipfile');
          end;
          Inc(i);
        end; { while }
      end; { if }

      errclose := zipClose(zf, nil);
      if (errclose <> ZIP_OK) then
        WriteLn('error in closing ', filename_try);
    end;

    FreeMem(buf); {FreeMem(buf, size_buf);}
  end;

begin
  main;
  Write('Done...');
  ReadLn;
end.
