unit tbs0308a;

interface

type
  tcourses = object
    function index(cName: string): integer;
    function name(cIndex: integer): string;
  end;

var coursedb: tcourses;
    l: longint;

implementation

function tcourses.index(cName: string): integer;
begin
  index := byte(cName[0]);
end;

function tcourses.name(cIndex: integer): string;
begin
  name := char(byte(cIndex));
end;

end.
