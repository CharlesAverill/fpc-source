{
    $Id$
    This file is part of the Free Pascal Integrated Development Environment
    Copyright (c) 1998 by Berczi Gabor

    Desktop loading/saving routines

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit FPDesk;

interface

const
     DesktopVersion     = $0003; { <- if you change any Load&Store methods,
                                      then you should also change this }

     ResDesktopFlags    = 'FLAGS';
     ResHistory         = 'HISTORY';
     ResClipboard       = 'CLIPBOARD';
     ResWatches         = 'WATCHES';
     ResBreakpoints     = 'BREAKPOINTS';
     ResDesktop         = 'DESKTOP';
     ResSymbols         = 'SYMBOLS';

procedure InitDesktopFile;
function  LoadDesktop: boolean;
function  SaveDesktop: boolean;
procedure DoneDesktopFile;

implementation

uses Dos,
     Objects,Drivers,Views,App,HistList,BrowCol,
     WResource,WViews,WEditor,
{$ifndef NODEBUG}
     fpdebug,
{$endif ndef NODEBUG}
     FPConst,FPVars,FPUtils,FPViews,FPCompile,FPTools,FPHelp;

procedure InitDesktopFile;
begin
  if DesktopLocation=dlCurrentDir then
    DesktopPath:=FExpand(DesktopName)
  else
    DesktopPath:=FExpand(DirOf(INIPath)+DesktopName);
end;

procedure DoneDesktopFile;
begin
end;

function ReadHistory(F: PResourceFile): boolean;
var S: PMemoryStream;
    OK: boolean;
begin
  PushStatus('Reading history...');
  New(S, Init(32*1024,4096));
  OK:=F^.ReadResourceEntryToStream(resHistory,langDefault,S^);
  S^.Seek(0);
  if OK then
    LoadHistory(S^);
  Dispose(S, Done);
  PopStatus;
  ReadHistory:=OK;
end;

function WriteHistory(F: PResourceFile): boolean;
var S: PMemoryStream;
begin
  PushStatus('Storing history...');

  New(S, Init(10*1024,4096));
  StoreHistory(S^);
  S^.Seek(0);
  F^.CreateResource(resHistory,rcBinary,0);
  F^.AddResourceEntryFromStream(resHistory,langDefault,0,S^,S^.GetSize);
  Dispose(S, Done);
  PopStatus;
  WriteHistory:=true;
end;

(*function ReadClipboard(F: PResourceFile): boolean;
begin
  ReadClipboard:=true;
end;

function WriteClipboard(F: PResourceFile): boolean;
var S: PMemoryStream;
begin
  if Assigned(Clipboard) then
  begin
    PushStatus('Storing clipboard content...');

    New(S, Init(10*1024,4096));
    Clipboard^.SaveToStream(S^);
    S^.Seek(0);
    F^.CreateResource(resClipboard,rcBinary,0);
    F^.AddResourceEntryFromStream(resClipboard,langDefault,0,S^,S^.GetSize);
    Dispose(S, Done);
    PopStatus;
  end;
  WriteClipboard:=true;
end;*)

function ReadWatches(F: PResourceFile): boolean;
var S: PMemoryStream;
    OK: boolean;
    OWC : PWatchesCollection;
begin
{$ifndef NODEBUG}
  PushStatus('Reading watches...');
  New(S, Init(32*1024,4096));
  OK:=F^.ReadResourceEntryToStream(resWatches,langDefault,S^);
  S^.Seek(0);
  if OK then
    begin
      OWC:=WatchesCollection;
      New(WatchesCollection,Load(S^));
      OK:=(S^.Status=stOK);
      if OK and assigned(OWC) then
        Dispose(OWC,Done);
    end;
  ReadWatches:=OK;
  Dispose(S, Done);
  PopStatus;
{$else NODEBUG}
  ReadWatches:=true;
{$endif NODEBUG}
end;

function WriteWatches(F: PResourceFile): boolean;
var
  S : PMemoryStream;
begin
{$ifndef NODEBUG}
  if not assigned(WatchesCollection) then
{$endif NODEBUG}
    WriteWatches:=true
{$ifndef NODEBUG}
  else
    begin
      PushStatus('Storing watches...');
      New(S, Init(30*1024,4096));
      S^.Put(WatchesCollection);
      S^.Seek(0);
      F^.CreateResource(resWatches,rcBinary,0);
      WriteWatches:=F^.AddResourceEntryFromStream(resWatches,langDefault,0,S^,S^.GetSize);
      Dispose(S, Done);
      PopStatus;
    end;
{$endif NODEBUG}
end;

function ReadBreakpoints(F: PResourceFile): boolean;
var S: PMemoryStream;
    OK: boolean;
    OBC : PBreakpointCollection;
begin
{$ifndef NODEBUG}
  PushStatus('Reading breakpoints...');
  New(S, Init(32*1024,4096));
  OK:=F^.ReadResourceEntryToStream(resBreakpoints,langDefault,S^);
  S^.Seek(0);
  if OK then
    begin
      OBC:=BreakpointsCollection;
      New(BreakpointsCollection,Load(S^));
      OK:=(S^.Status=stOK);
      If OK and assigned(OBC) then
        Dispose(OBC,Done);
    end;
  ReadBreakpoints:=OK;
  Dispose(S, Done);
  PopStatus;
{$else NODEBUG}
  ReadBreakpoints:=true;
{$endif NODEBUG}
end;

function WriteBreakpoints(F: PResourceFile): boolean;
var
  S : PMemoryStream;
begin
{$ifndef NODEBUG}
  if not assigned(BreakpointsCollection) then
{$endif NODEBUG}
    WriteBreakPoints:=true
{$ifndef NODEBUG}
  else
    begin
      PushStatus('Storing breakpoints...');
      New(S, Init(30*1024,4096));
      BreakpointsCollection^.Store(S^);
      S^.Seek(0);
      F^.CreateResource(resBreakpoints,rcBinary,0);
      WriteBreakPoints:=F^.AddResourceEntryFromStream(resBreakpoints,langDefault,0,S^,S^.GetSize);
      Dispose(S, Done);
      PopStatus;
    end;
{$endif NODEBUG}
end;

function ReadOpenWindows(F: PResourceFile): boolean;
var S: PMemoryStream;
    TempDesk: PFPDesktop;
    OK: boolean;
    W: word;
begin
  PushStatus('Reading desktop contents...');
  New(S, Init(32*1024,4096));
  OK:=F^.ReadResourceEntryToStream(resDesktop,langDefault,S^);
  S^.Seek(0);
  if OK then
  begin
    S^.Read(W,SizeOf(W));
    OK:=(W=DesktopVersion);
    if OK=false then
      ErrorBox('Invalid desktop version. Desktop layout lost.',nil);
  end;
  if OK then
    begin
      TempDesk:=PFPDesktop(S^.Get);
      OK:=Assigned(TempDesk);
      if OK then
        begin
          Dispose(Desktop, Done);
          Desktop:=TempDesk;

          with Desktop^ do
          begin
            GetSubViewPtr(S^,CompilerMessageWindow);
            GetSubViewPtr(S^,CompilerStatusDialog);
            GetSubViewPtr(S^,ClipboardWindow);
            if Assigned(ClipboardWindow) then Clipboard:=ClipboardWindow^.Editor;
            GetSubViewPtr(S^,CalcWindow);
            GetSubViewPtr(S^,ProgramInfoWindow);
            GetSubViewPtr(S^,GDBWindow);
            GetSubViewPtr(S^,BreakpointsWindow);
            GetSubViewPtr(S^,WatchesWindow);
            GetSubViewPtr(S^,UserScreenWindow);
            GetSubViewPtr(S^,ASCIIChart);
            GetSubViewPtr(S^,MessagesWindow); LastToolMessageFocused:=nil;
          end;

          Application^.Insert(Desktop);
          Desktop^.ReDraw;
          Message(Application,evBroadcast,cmUpdate,nil);
        end;
      if OK=false then
        ErrorBox('Error loading desktop',nil);
    end;
  Dispose(S, Done);
  PopStatus;
  ReadOpenWindows:=OK;
end;

function WriteOpenWindows(F: PResourceFile): boolean;
var S: PMemoryStream;
    W: word;
begin
  PushStatus('Storing desktop contents...');

  New(S, Init(30*1024,4096));
  W:=DesktopVersion;
  S^.Write(W,SizeOf(W));
  S^.Put(Desktop);
  with Desktop^ do
  begin
    PutSubViewPtr(S^,CompilerMessageWindow);
    PutSubViewPtr(S^,CompilerStatusDialog);
    PutSubViewPtr(S^,ClipboardWindow);
    PutSubViewPtr(S^,CalcWindow);
    PutSubViewPtr(S^,ProgramInfoWindow);
    PutSubViewPtr(S^,GDBWindow);
    PutSubViewPtr(S^,BreakpointsWindow);
    PutSubViewPtr(S^,WatchesWindow);
    PutSubViewPtr(S^,UserScreenWindow);
    PutSubViewPtr(S^,ASCIIChart);
    PutSubViewPtr(S^,MessagesWindow);
  end;
  S^.Seek(0);
  F^.CreateResource(resDesktop,rcBinary,0);
  F^.AddResourceEntryFromStream(resDesktop,langDefault,0,S^,S^.GetSize);
  Dispose(S, Done);
  PopStatus;
  WriteOpenWindows:=true;
end;

function WriteFlags(F: PResourceFile): boolean;
begin
  F^.CreateResource(resDesktopFlags,rcBinary,0);
  WriteFlags:=F^.AddResourceEntry(resDesktopFlags,langDefault,0,DesktopFileFlags,
    SizeOf(DesktopFileFlags));
end;

function ReadFlags(F: PResourceFile): boolean;
var
  size : sw_word;
begin
  ReadFlags:=F^.ReadResourceEntry(resDesktopFlags,langDefault,DesktopFileFlags,
    size);
end;

function ReadSymbols(F: PResourceFile): boolean;
var S: PMemoryStream;
    OK: boolean;
begin
  PushStatus('Reading symbol information...');
  New(S, Init(32*1024,4096));
  OK:=F^.ReadResourceEntryToStream(resSymbols,langDefault,S^);
  S^.Seek(0);
  if OK then
    LoadBrowserCol(S);
  Dispose(S, Done);
  PopStatus;
  ReadSymbols:=OK;
end;

function WriteSymbols(F: PResourceFile): boolean;
var S: PMemoryStream;
    OK: boolean;
begin
  OK:=Assigned(Modules);

  if OK then
  begin
    PushStatus('Storing symbol information...');

    New(S, Init(200*1024,4096));
    StoreBrowserCol(S);
    S^.Seek(0);
    F^.CreateResource(resSymbols,rcBinary,0);
    OK:=F^.AddResourceEntryFromStream(resSymbols,langDefault,0,S^,S^.GetSize);
    Dispose(S, Done);
    PopStatus;
  end;
  WriteSymbols:=OK;
end;

function LoadDesktop: boolean;
var OK: boolean;
    F: PResourceFile;
begin
  PushStatus('Reading desktop file...');
  New(F, LoadFile(DesktopPath));

  OK:=Assigned(F);

  if OK then
  begin
    OK:=ReadFlags(F);
    if OK and ((DesktopFileFlags and dfHistoryLists)<>0) then
      OK:=ReadHistory(F);
    if OK and ((DesktopFileFlags and dfWatches)<>0) then
      OK:=ReadWatches(F);
    if OK and ((DesktopFileFlags and dfBreakpoints)<>0) then
      OK:=ReadBreakpoints(F);
  end;

  PopStatus;
  LoadDesktop:=OK;
end;

function SaveDesktop: boolean;
var OK: boolean;
    F: PResourceFile;
begin
  PushStatus('Writing desktop file...');
  New(F, CreateFile(DesktopPath));

  if Assigned(Clipboard) then
    if (DesktopFileFlags and dfClipboardContent)<>0 then
      Clipboard^.Flags:=Clipboard^.Flags or efStoreContent
    else
      Clipboard^.Flags:=Clipboard^.Flags and not efStoreContent;

  OK:=Assigned(F);
  if OK then
    OK:=WriteFlags(F);
  if OK and ((DesktopFileFlags and dfHistoryLists)<>0) then
    OK:=WriteHistory(F);
  if OK and ((DesktopFileFlags and dfWatches)<>0) then
    OK:=WriteWatches(F);
  if OK and ((DesktopFileFlags and dfBreakpoints)<>0) then
    OK:=WriteBreakpoints(F);
  if OK and ((DesktopFileFlags and dfOpenWindows)<>0) then
    OK:=WriteOpenWindows(F);
  { no errors if no browser info available PM }
  if OK and ((DesktopFileFlags and dfSymbolInformation)<>0) then
    OK:=WriteSymbols(F) or not Assigned(Modules);
  Dispose(F, Done);
  PopStatus;
  SaveDesktop:=OK;
end;

END.
{
  $Log$
  Revision 1.11  1999-09-17 16:28:58  pierre
   * ResWatches in WriteBreakpoints typo !

  Revision 1.10  1999/09/16 14:34:58  pierre
    + TBreakpoint and TWatch registering
    + WatchesCollection and BreakpointsCollection stored in desk file
    * Syntax highlighting was broken

  Revision 1.9  1999/09/07 09:23:00  pierre
   * no errors if no browser info available

  Revision 1.8  1999/08/16 18:25:16  peter
    * Adjusting the selection when the editor didn't contain any line.
    * Reserved word recognition redesigned, but this didn't affect the overall
      syntax highlight speed remarkably (at least not on my Amd-K6/350).
      The syntax scanner loop is a bit slow but the main problem is the
      recognition of special symbols. Switching off symbol processing boosts
      the performance up to ca. 200%...
    * The editor didn't allow copying (for ex to clipboard) of a single character
    * 'File|Save as' caused permanently run-time error 3. Not any more now...
    * Compiler Messages window (actually the whole desktop) did not act on any
      keypress when compilation failed and thus the window remained visible
    + Message windows are now closed upon pressing Esc
    + At 'Run' the IDE checks whether any sources are modified, and recompiles
      only when neccessary
    + BlockRead and BlockWrite (Ctrl+K+R/W) implemented in TCodeEditor
    + LineSelect (Ctrl+K+L) implemented
    * The IDE had problems closing help windows before saving the desktop

  Revision 1.7  1999/08/03 20:22:30  peter
    + TTab acts now on Ctrl+Tab and Ctrl+Shift+Tab...
    + Desktop saving should work now
       - History saved
       - Clipboard content saved
       - Desktop saved
       - Symbol info saved
    * syntax-highlight bug fixed, which compared special keywords case sensitive
      (for ex. 'asm' caused asm-highlighting, while 'ASM' didn't)
    * with 'whole words only' set, the editor didn't found occourences of the
      searched text, if the text appeared previously in the same line, but didn't
      satisfied the 'whole-word' condition
    * ^QB jumped to (SelStart.X,SelEnd.X) instead of (SelStart.X,SelStart.Y)
      (ie. the beginning of the selection)
    * when started typing in a new line, but not at the start (X=0) of it,
      the editor inserted the text one character more to left as it should...
    * TCodeEditor.HideSelection (Ctrl-K+H) didn't update the screen
    * Shift shouldn't cause so much trouble in TCodeEditor now...
    * Syntax highlight had problems recognizing a special symbol if it was
      prefixed by another symbol character in the source text
    * Auto-save also occours at Dos shell, Tool execution, etc. now...

  Revision 1.5  1999/06/30 23:58:13  pierre
    + BreakpointsList Window implemented
      with Edit/New/Delete functions
    + Individual breakpoint dialog with support for all types
      ignorecount and conditions
      (commands are not yet implemented, don't know if this wolud be useful)
      awatch and rwatch have problems because GDB does not annotate them
      I fixed v4.16 for this

  Revision 1.4  1999/04/15 08:58:05  peter
    * syntax highlight fixes
    * browser updates

  Revision 1.3  1999/04/07 21:55:45  peter
    + object support for browser
    * html help fixes
    * more desktop saving things
    * NODEBUG directive to exclude debugger

  Revision 1.2  1999/03/23 16:16:39  peter
    * linux fixes

  Revision 1.1  1999/03/23 15:11:28  peter
    * desktop saving things
    * vesa mode
    * preferences dialog

}
