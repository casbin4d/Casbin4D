// Copyright 2018 The Casbin Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
