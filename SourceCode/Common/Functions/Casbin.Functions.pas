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
unit Casbin.Functions;

interface

uses
  Casbin.Core.Base.Types, Casbin.Functions.Types,
  System.Generics.Collections, System.Classes;

type
  TFunctions = class (TBaseInterfacedObject, IFunctions)
  private
    fDictionary: TDictionary<string, TCasbinFunc>;
    procedure loadBuiltInFunctions;
    procedure loadCustomFunctions;
  private
{$REGION 'Interface'}
    procedure registerFunction(const aName: string;
      const aFunc: TCasbinFunc);
    function retrieveFunction(const aName: string): TCasbinFunc;
    function list: TStringList;
    procedure refreshFunctions;
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils, System.RegularExpressions, System.Types, System.StrUtils;

constructor TFunctions.Create;
begin
  inherited;
  fDictionary:=TDictionary<string, TCasbinFunc>.Create;
  loadBuiltInFunctions;
  loadCustomFunctions;
end;

destructor TFunctions.Destroy;
var
  item: string;
begin
  for item in fDictionary.Keys do
    fDictionary.AddOrSetValue(item, nil);
  fDictionary.Free;
  inherited;
end;

procedure TFunctions.refreshFunctions;
begin
  fDictionary.Clear;
  loadBuiltInFunctions;
  loadCustomFunctions;
end;

procedure TFunctions.registerFunction(const aName: string;
  const aFunc: TCasbinFunc);
begin
  if Trim(aName)='' then
    raise Exception.Create('Function to register must have a name');
  if not Assigned(aFunc) then
    raise Exception.Create('Function to register is nil');
  if Assigned(aFunc) then
    fDictionary.AddOrSetValue(Trim(aName), aFunc);
end;

function TFunctions.retrieveFunction(const aName: string): TCasbinFunc;
begin
  if not fDictionary.ContainsKey(Trim(aName)) then
    raise Exception.Create('Function '+aName+' is not registered');
  Result:=fDictionary.Items[Trim(aName)];
end;

// Built-in functions
// In this section, built-in functions are imported
{$IFDEF TESTINSIGHT}
  {$I ..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch.pas}
  {$I ..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch2.pas}
  {$I ..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch3.pas}
  {$I ..\SourceCode\Common\Functions\Casbin.Functions.RegExMatch.pas}
  {$I ..\SourceCode\Common\Functions\Casbin.Functions.IPMatch.pas}
{$ELSE}
  {$I ..\..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch.pas}
  {$I ..\..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch2.pas}
  {$I ..\..\SourceCode\Common\Functions\Casbin.Functions.KeyMatch3.pas}
  {$I ..\..\SourceCode\Common\Functions\Casbin.Functions.RegExMatch.pas}
  {$I ..\..\SourceCode\Common\Functions\Casbin.Functions.IPMatch.pas}
{$ENDIF}

function TFunctions.list: TStringList;
var
  name: string;
begin
  result:=TStringList.Create;
  Result.Sorted:=true;
  for name in fDictionary.Keys do
    result.add(name);
end;

procedure TFunctions.loadBuiltInFunctions;
begin
  fDictionary.Add('KeyMatch', KeyMatch);
  fDictionary.Add('KeyMatch2', KeyMatch2);
  fDictionary.Add('KeyMatch3', KeyMatch2);
  fDictionary.Add('RegExMatch', regexMatch);
  fDictionary.Add('IPMatch', IPMatch);
end;

// Custom functions
// If you want to add more functions include the files here
// Then register it in loadCustomFunctions
// (see loadBuiltInFunctions for examples)

{ $I ..\SourceCode\Common\Functions\NewCustomFunction.pas}

procedure TFunctions.loadCustomFunctions;
begin
// Add call to fDictionary.Add to register a customn function
end;

end.
