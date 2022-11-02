{ %CPU=i386,x86_64 }
{ %OPT=-O3 -CpCOREAVX2 -OpCOREAVX2 }

program tbzhi2;

function MaskOut(Input: Int64; Index: Byte): Int64; noinline;
begin
  MaskOut := Input and ((Int64(1) shl Index) - 1);
end;

const
  Inputs:  array[0..3] of Int64 = (0, $FFFFFFFFFFFFFFFF, $0123456789ABCDEF, $FEDCBA9876543210);
  Expected: array[0..3] of array[0..63] of Int64 =
    (
      ($0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000),
      ($0000000000000000, $0000000000000001, $0000000000000003, $0000000000000007, $000000000000000F, $000000000000001F, $000000000000003F, $000000000000007F, $00000000000000FF, $00000000000001FF, $00000000000003FF, $00000000000007FF, $0000000000000FFF, $0000000000001FFF, $0000000000003FFF, $0000000000007FFF, $000000000000FFFF, $000000000001FFFF, $000000000003FFFF, $000000000007FFFF, $00000000000FFFFF, $00000000001FFFFF, $00000000003FFFFF, $00000000007FFFFF, $0000000000FFFFFF, $0000000001FFFFFF, $0000000003FFFFFF, $0000000007FFFFFF, $000000000FFFFFFF, $000000001FFFFFFF, $000000003FFFFFFF, $000000007FFFFFFF, $00000000FFFFFFFF, $00000001FFFFFFFF, $00000003FFFFFFFF, $00000007FFFFFFFF, $0000000FFFFFFFFF, $0000001FFFFFFFFF, $0000003FFFFFFFFF, $0000007FFFFFFFFF, $000000FFFFFFFFFF, $000001FFFFFFFFFF, $000003FFFFFFFFFF, $000007FFFFFFFFFF, $00000FFFFFFFFFFF, $00001FFFFFFFFFFF, $00003FFFFFFFFFFF, $00007FFFFFFFFFFF, $0000FFFFFFFFFFFF, $0001FFFFFFFFFFFF, $0003FFFFFFFFFFFF, $0007FFFFFFFFFFFF, $000FFFFFFFFFFFFF, $001FFFFFFFFFFFFF, $003FFFFFFFFFFFFF, $007FFFFFFFFFFFFF, $00FFFFFFFFFFFFFF, $01FFFFFFFFFFFFFF, $03FFFFFFFFFFFFFF, $07FFFFFFFFFFFFFF, $0FFFFFFFFFFFFFFF, $1FFFFFFFFFFFFFFF, $3FFFFFFFFFFFFFFF, $7FFFFFFFFFFFFFFF),
      ($0000000000000000, $0000000000000001, $0000000000000003, $0000000000000007, $000000000000000F, $000000000000000F, $000000000000002F, $000000000000006F, $00000000000000EF, $00000000000001EF, $00000000000001EF, $00000000000005EF, $0000000000000DEF, $0000000000000DEF, $0000000000000DEF, $0000000000004DEF, $000000000000CDEF, $000000000001CDEF, $000000000003CDEF, $000000000003CDEF, $00000000000BCDEF, $00000000000BCDEF, $00000000002BCDEF, $00000000002BCDEF, $0000000000ABCDEF, $0000000001ABCDEF, $0000000001ABCDEF, $0000000001ABCDEF, $0000000009ABCDEF, $0000000009ABCDEF, $0000000009ABCDEF, $0000000009ABCDEF, $0000000089ABCDEF, $0000000189ABCDEF, $0000000389ABCDEF, $0000000789ABCDEF, $0000000789ABCDEF, $0000000789ABCDEF, $0000002789ABCDEF, $0000006789ABCDEF, $0000006789ABCDEF, $0000016789ABCDEF, $0000016789ABCDEF, $0000056789ABCDEF, $0000056789ABCDEF, $0000056789ABCDEF, $0000056789ABCDEF, $0000456789ABCDEF, $0000456789ABCDEF, $0001456789ABCDEF, $0003456789ABCDEF, $0003456789ABCDEF, $0003456789ABCDEF, $0003456789ABCDEF, $0023456789ABCDEF, $0023456789ABCDEF, $0023456789ABCDEF, $0123456789ABCDEF, $0123456789ABCDEF, $0123456789ABCDEF, $0123456789ABCDEF, $0123456789ABCDEF, $0123456789ABCDEF, $0123456789ABCDEF),
      ($0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000000, $0000000000000010, $0000000000000010, $0000000000000010, $0000000000000010, $0000000000000010, $0000000000000210, $0000000000000210, $0000000000000210, $0000000000001210, $0000000000003210, $0000000000003210, $0000000000003210, $0000000000003210, $0000000000003210, $0000000000043210, $0000000000043210, $0000000000143210, $0000000000143210, $0000000000543210, $0000000000543210, $0000000000543210, $0000000002543210, $0000000006543210, $0000000006543210, $0000000016543210, $0000000036543210, $0000000076543210, $0000000076543210, $0000000076543210, $0000000076543210, $0000000076543210, $0000000876543210, $0000001876543210, $0000001876543210, $0000001876543210, $0000009876543210, $0000009876543210, $0000029876543210, $0000029876543210, $00000A9876543210, $00001A9876543210, $00003A9876543210, $00003A9876543210, $0000BA9876543210, $0000BA9876543210, $0000BA9876543210, $0004BA9876543210, $000CBA9876543210, $001CBA9876543210, $001CBA9876543210, $005CBA9876543210, $00DCBA9876543210, $00DCBA9876543210, $02DCBA9876543210, $06DCBA9876543210, $0EDCBA9876543210, $1EDCBA9876543210, $3EDCBA9876543210, $7EDCBA9876543210)
    );

var
  X: Byte;
  Y: Integer;
  Output: Int64;
begin
  for Y := Low(Inputs) to High(Inputs) do
    for X := 0 to 63 do
      begin
	    Output := MaskOut(Inputs[Y], X);
		if Output <> Expected[Y][X] then
		  begin
		    WriteLn('FAIL: $', HexStr(Inputs[Y], 16), ' and ((1 shl ', X, ') - 1) returned $', HexStr(Output, 16), '; expected $', HexStr(Expected[Y][X], 16));
		    Halt(1);
		  end;
	  end;

  WriteLn('ok');
end.