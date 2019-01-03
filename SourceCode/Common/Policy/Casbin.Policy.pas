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
unit Casbin.Policy;

interface

uses
  Casbin.Core.Base.Types, Casbin.Policy.Types, Casbin.Parser.Types,
  Casbin.Parser.AST.Types, System.Generics.Collections,
  Casbin.Adapter.Policy.Types;

type
  TPolicyManager = class(TBaseInterfacedObject, IPolicyManager)
  private
    fAdapter: IPolicyAdapter;
    fParser: IParser;
    fNodes: TNodeCollection;
    procedure loadPolicies;
  private
{$REGION 'Interface'}
    function section (const aSlim: Boolean = true): string;
    function policies: TList<string>;
    procedure add(const aTag: string);
    procedure load (const aFilter: TFilterArray = []);
    function policy(const aFilter: TFilterArray = []): string;
    procedure clear;
    function policyExists(const aFilter: TFilterArray = []): Boolean;
    procedure remove(const aPolicyDefinition: string); overload;
    procedure remove (const aPolicyDefinition: string; const aFilter: string); overload;
{$ENDREGION}
  public
    constructor Create(const aPolicy: string); overload;
    constructor Create(const aAdapter: IPolicyAdapter); overload;
  end;

implementation

uses
  Casbin.Adapter.Filesystem.Policy, Casbin.Exception.Types, System.Classes,
  Casbin.Parser, Casbin.Core.Utilities, Casbin.Model.Sections.Types,
  Casbin.Core.Defaults, System.SysUtils, System.StrUtils;

{ TPolicyManager }

constructor TPolicyManager.Create(const aPolicy: string);
begin
  Create(TPolicyFileAdapter.Create(aPolicy));
end;

procedure TPolicyManager.add(const aTag: string);
begin
  fAdapter.add(aTag);
end;

procedure TPolicyManager.clear;
begin
  fAdapter.clear;
end;

constructor TPolicyManager.Create(const aAdapter: IPolicyAdapter);
begin
  if not Assigned(aAdapter) then
    raise ECasbinException.Create('Adapter is nil in '+Self.ClassName);
  inherited Create;
  fAdapter:=aAdapter;
end;

procedure TPolicyManager.load(const aFilter: TFilterArray);
begin
  fAdapter.clear;
  fAdapter.load(aFilter);
end;

procedure TPolicyManager.loadPolicies;
begin
  if (Assigned(fNodes)) then
    Exit;
  fAdapter.clear;
  fAdapter.load(fAdapter.Filter);
  fParser:=TParser.Create(fAdapter.toOutputString, ptPolicy);
  fParser.parse;
  if fParser.Status=psError then
    raise ECasbinException.Create('Parsing error in Model: '+fParser.ErrorMessage);
  fNodes:=fParser.Nodes;
end;

function TPolicyManager.policies: TList<string>;
var
  node: TChildNode;
  headerNode: THeaderNode;
begin
  Result:=TList<string>.Create;
  loadPolicies;
  for headerNode in fNodes.Headers do
    if headerNode.SectionType=stPolicyRules then
    begin
      for node in headerNode.ChildNodes do
      begin
        Result.add(node.Key+AssignmentCharForPolicies+node.Value)
      end;
      Exit;
    end;
end;

function TPolicyManager.policy(const aFilter: TFilterArray = []): string;
var
  i: Integer;
  list: TList<string>;
  policy: string;
  test: string;
  testPolicy: string;
  strArray: TFilterArray;
begin
  Result:='undefined';

  loadPolicies;

  //Clean aFilter
  strArray:=aFilter;
  for i:=0 to Length(strArray)-1 do
  begin
    strArray[i]:=trim(strArray[i]);
  end;
  testPolicy:=String.Join(',', strArray);

  list:=policies;
  for policy in list do
  begin
    strArray:=policy.Split([',']);
    for i:=0 to Length(strArray)-1 do
    begin
      strArray[i]:=trim(strArray[i]);
    end;
    if Length(strArray)>=1 then
    begin
      test:=String.Join(',', strArray);
      if UpperCase(Copy(Trim(test), findStartPos,
                    findEndPos(testPolicy)))=UpperCase(Trim(testPolicy)) then
      begin
        Result:=Trim(strArray[Length(strArray)-1]);
        list.Free;
        exit;
      end;
    end;
  end;
  list.Free;
end;

function TPolicyManager.policyExists(const aFilter: TFilterArray): Boolean;
var
  i: Integer;
  list: TList<string>;
  policy: string;
  test: string;
  testPolicy: string;
  modArray: TFilterArray;
  strArray: TFilterArray;
begin
  Result:=False;
  if Length(aFilter)=0 then
    Exit;
  loadPolicies;

  if IndexStr(UpperCase(aFilter[0]), ['P', 'G']) = -1 then
    testPolicy:='p,';
  for policy in aFilter do
    testPolicy:=testPolicy+policy+',';
  if testPolicy[findEndPos(testPolicy)]=',' then
    testPolicy:=Copy(testPolicy, findStartPos, findEndPos(testPolicy)-1);

  list:=policies;
  for policy in list do
  begin
    strArray:=policy.Split([',']);
    for i:=0 to Length(strArray)-1 do
      strArray[i]:=trim(strArray[i]);
    if Length(strArray)>=1 then
    begin
      test:=String.Join(',', strArray);
      if UpperCase(Trim(test))=UpperCase(Trim(testPolicy)) then
      begin
        Result:=true;
        break;
      end;
    end;
  end;
  list.Free;
end;

procedure TPolicyManager.remove(const aPolicyDefinition: string);
begin
  fAdapter.remove(aPolicyDefinition);
end;

procedure TPolicyManager.remove(const aPolicyDefinition, aFilter: string);
begin
  fAdapter.remove(aPolicyDefinition, aFilter);
end;

function TPolicyManager.section(const aSlim: Boolean): string;
var
  headerNode: THeaderNode;
  strList: TStringList;
  policy: string;
begin
  Result:='';
  loadPolicies;
  for headerNode in fNodes.Headers do
    if headerNode.SectionType=stPolicyRules then
    begin
      Result:=headerNode.toOutputString;
      strList:=TStringList.Create;
      strList.Text:=Result;
      if (strList.Count>1) then
      begin
        Result:='';
        if aSlim and (strList.Strings[0][findStartPos]='[') then
          strList.Delete(0);
        for policy in strList do
          Result:=Result+policy+sLineBreak;
      end;
      strList.Free;
      Exit;
    end;
end;

end.
