unit tw11435c;

{$MODE ObjFPC}

interface

type
  generic TList<_T>=class(TObject)
    public
      type
        TCompareFunc = function(const Item1, Item2: _T): Integer;
    public
      var
        data : _T;
    procedure Add(item: _T);
    procedure Sort(compare: TCompareFunc);
  end;

type
  TA = specialize TList<byte>;

implementation

procedure TList<_T>.Add(item: _T);
begin
  data:=item;
end;

procedure TList<_T>.Sort(compare: TCompareFunc);
begin
  if compare(data, 20) <= 0 then
    halt(1);
end;

end.
