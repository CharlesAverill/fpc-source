{ %FAIL }

program tfuncref35;

{$mode delphi}
{$modeswitch functionreferences}
{$modeswitch nestedprocvars}

type
  TProcRef = reference to procedure;
  TNestedVar = procedure is nested;

var
  f: TProcRef;
  v: TNestedVar;
begin
  f := v;
end.

