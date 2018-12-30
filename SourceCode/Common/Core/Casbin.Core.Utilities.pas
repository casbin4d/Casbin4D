unit Casbin.Core.Utilities;

interface

function findStartPos: Integer;
function findEndPos (const aLine: string): Integer;

implementation

uses
  System.SysUtils;

function findStartPos: Integer;
begin
  Result:=Low(string);
end;

function findEndPos (const aLine: string): Integer;
begin
  Result:=0;
  if trim(aLine)<>'' then
    if findStartPos=0 then
     result:=Length(aLine)-1
    else
      result:=Length(aLine);
end;

end.
