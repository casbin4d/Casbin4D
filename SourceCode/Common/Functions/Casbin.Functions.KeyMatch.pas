unit Casbin.Functions.KeyMatch;

interface

/// <summary>
///   Determines whether key1 matches the pattern of key2
///   (as in REST paths)
///   key2 can contain '*'
///   eg. '/foo/bar' matches '/foo/*'
/// </summary>
function KeyMatch (const aArgs: array of string): Boolean;

implementation

uses
  System.SysUtils;

function KeyMatch (const aArgs: array of string): Boolean;
var
  key1: string;
  key2: string;
  index: Integer;
begin
  if Length(aArgs)<>2 then
    raise Exception.Create('Wrong number of arguments in KeyMatch');
  key1:=aArgs[0];
  key2:=aArgs[1];

  index:=Pos('*', key2);

  if index=0 then
    Exit(key1 = key2);

  if Length(key1) >= index then
    Exit(Copy(key1, low(string), index-1) = Copy(key2, low(string), index-1));

  Exit(key1 = Copy(key2, low(string), index-1));

end;

end.
