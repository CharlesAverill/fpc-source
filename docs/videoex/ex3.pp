program testvideo;

uses video,keyboard,vidutil;

Var 
  i : longint;
  k : TkeyEvent;
  
begin
  InitVideo;
  InitKeyboard;
  For I:=1 to 10 do
    TextOut(i,i, 'Press any key to clear screen');
  UpdateScreen(false);
  K:=GetKeyEvent;
  ClearScreen;
  TextOut(1,1,'Cleared screen. Press any key to end');  
  UpdateScreen(true);
  K:=GetKeyEvent;
  DoneKeyBoard;
  DoneVideo;
end.  