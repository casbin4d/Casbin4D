unit Casbin.Core.Utilities;

interface

function findStartPos: Integer;
function findEndPos (const aLine: string): Integer;

function version: string;

implementation

uses
  System.SysUtils;

{$I ..\Version.inc}

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


function version: string;
begin
  result:=MajorVersion+'.'+MinorVersion+'.'+BugVersion;
  if TypeVersion<>'' then
    Result:=Result+' ('+TypeVersion+')'
end;
end.
