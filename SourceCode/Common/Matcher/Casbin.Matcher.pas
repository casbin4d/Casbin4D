// Copyright 2018 by John Kouraklis and Contributors. All Rights Reserved.
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
unit Casbin.Matcher;

interface

uses
  Casbin.Core.Base.Types, Casbin.Matcher.Types, Casbin.Effect.Types, ParseExpr,
  System.Generics.Collections;

type
  TMatcher = class (TBaseInterfacedObject, IMatcher)
  private
    fMatcherString: string;
    fMathsParser: TCStyleParser;
    fIdentifiers: TDictionary<string, integer>;
    fNextID: integer;
    procedure cleanMatcher;
    procedure replaceIdentifiers(var aParseString: string);
  private
  {$REGION 'Interface'}
    function evaluateMatcher(const aMatcherString: string): TEffectResult;
    procedure clearIdentifiers;
    procedure addIdentifier (const aTag: string);
  {$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;

  end;

implementation

uses
  System.StrUtils, System.SysUtils, Casbin.Exception.Types, System.Rtti, Casbin.Core.Defaults,
  System.RegularExpressions;

procedure TMatcher.clearIdentifiers;
begin
  fIdentifiers.Clear;
end;

constructor TMatcher.Create;
var
  item: string;
begin
  inherited;
  fMathsParser:=TCStyleParser.Create;
  TCStyleParser(fMathsParser).CStyle:=False;
  fIdentifiers:=TDictionary<string, integer>.Create;

  fNextID:=0;

  addIdentifier('true');
  addIdentifier('false');

  for item in builtinAccounts do
    addIdentifier(item);
end;

destructor TMatcher.Destroy;
begin
  fIdentifiers.Free;
  fMathsParser.Free;
  inherited;
end;

procedure TMatcher.addIdentifier(const aTag: string);
var
  tag: string;
begin
  tag:=aTag.Trim.ToUpper;
  if not fIdentifiers.ContainsKey(tag) then
  begin
    AtomicIncrement(fNextID);
    fIdentifiers.Add(tag, fNextID);
  end;
end;

procedure TMatcher.cleanMatcher;
var
  index: Integer;
begin
  fMatcherString:=fMatcherString.Replace('==', '=');
  fMatcherString:=fMatcherString.Replace('&&', 'and');
  fMatcherString:=fMatcherString.Replace('||', 'or');
  fMatcherString:=fMatcherString.Replace('!', 'not');
  index:=fMatcherString.IndexOf('''');
  while Index<>-1 do
  begin
    fMatcherString:=fMatcherString.Remove(index, 1);
    index:=fMatcherString.IndexOf('''');
  end;
end;

function TMatcher.evaluateMatcher(const aMatcherString: string): TEffectResult;
var
  eval: string;
begin
  fMatcherString:=UpperCase(aMatcherString);
  if fMatcherString.Trim.IsEmpty then
  begin
    Result:=erIndeterminate;
    Exit;
  end;
  cleanMatcher;
  replaceIdentifiers(fMatcherString);

  {TODO -oOwner -cGeneral : ReplaceStr(functions in expressions)}
  fMathsParser.Optimize := true;
  eval:=fMathsParser.AsString[fMathsParser.AddExpression(fMatcherString.Trim)];
  if eval.ToUpper='TRUE' then
    Result:=erAllow
  else
    result:=erDeny;
end;

procedure TMatcher.replaceIdentifiers(var aParseString: string);
var
  pair: TPair<string, integer>;
  pattern: string;
begin
  // JOHN == JOHNNY
  // Replace JOHN -> 22. Dont replace JOHNNY to 22NY
  // * Key has to be at the start of the string or the previous char is not part of the identifier (not a word)
  // * Key has to be at the end of the string or the following char is not part of the identifier (not a word)
  //
  // Written by ErikUniformAgri
  for pair in fIdentifiers do
  begin
    pattern:='(^|\W)'+pair.Key+'($|\W)';
    while TRegex.Match(aParseString, pattern).Success do
      aParseString:=TRegex.Replace(aParseString, pattern, '$1'+pair.Value.ToString+'$2');
  end;
end;

end.
