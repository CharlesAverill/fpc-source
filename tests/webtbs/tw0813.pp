program TestVm2;

procedure Test;
var
  P: Pointer;
begin
  P:=nil;
  ReAllocMem(P, 8);
  ReAllocMem(P, 0);
  if P<>nil then
    begin
      Writeln('ReAllocMem wtih zero size does not set pointer to nil');
      Writeln('Bug 813 is not yet fixed');
      Halt(1);
    end;
end;

var MemBefore : longint;
begin
  writeln(heapsize-MemAvail);
  MemBefore:=heapsize-MemAvail;
  Test;
  writeln(heapsize-MemAvail);
  if MemBefore<>heapsize-MemAvail then
    begin
      Writeln('ReAllocMem creates emory leaks');
      Writeln('Bug 812 is not yet fixed');
    end;
end.
