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
unit Casbin.Model;

interface

uses
  Casbin.Core.Base.Types, Casbin.Model.Types, Casbin.Adapter.Types,
  Casbin.Parser.Types, Casbin.Parser.AST.Types, Casbin.Model.Sections.Types,
  System.Generics.Collections, Casbin.Effect.Types;

type
  TModel = class (TBaseInterfacedObject, IModel)
  private
    fAdapter: IAdapter;  //PALOFF
    fParser: IParser;    //PALOFF
    fNodes: TNodeCollection;
    fAssertions: TList<string>;
    procedure checkSection(const aSection: TSectionType);
  protected
{$REGION 'Interface'}
    function section(const aSection: TSectionType; const aSlim: Boolean = true):
        string;
    function assertions(const aSection: TSectionType): TList<System.string>;
    function effectCondition: TEffectCondition;
{$ENDREGION}
  public
    constructor Create(const aModel: string); overload;
    constructor Create(const aAdapter: IAdapter); overload;
    destructor Destroy; override;
  end;

implementation

uses
  Casbin.Exception.Types, Casbin.Adapter.Filesystem,
  System.IOUtils, System.Classes, Casbin.Parser, Casbin.Core.Utilities;

constructor TModel.Create(const aModel: string);
begin
  Create(TFileAdapter.Create(aModel));
end;

function TModel.assertions(const aSection: TSectionType): TList<System.string>;
var
  node: TChildNode;
  headerNode: THeaderNode;
  assertionNode: TAssertionNode;
  assertion: string;
begin
  fAssertions.Clear;
  checkSection(aSection);
  for headerNode in fNodes.Headers do
    if headerNode.SectionType=aSection then
    begin
      for node in headerNode.ChildNodes do
      begin
        if node.AssertionList.Count=0 then
          fAssertions.add(node.Value)
        else
        begin
          for assertionNode in node.AssertionList do
          begin
            assertion:=node.Key+'.'+assertionNode.Value;
            fAssertions.Add(assertion);
          end;
        end;
      end;
      Break;
    end;
  Result:=fAssertions;
end;

constructor TModel.Create(const aAdapter: IAdapter);
begin
  if not Assigned(aAdapter) then
    raise ECasbinException.Create('Adapter is nil in '+Self.ClassName);
  inherited Create;
  fAdapter:=aAdapter;
  fAdapter.load;
  fParser:=TParser.Create(fAdapter.toOutputString, ptModel);
  fParser.parse;
  if fParser.Status=psError then
    raise ECasbinException.Create('Parsing error in Model: '+fParser.ErrorMessage);
  fNodes:=fParser.Nodes;
  fAssertions:=TList<string>.Create;
end;

destructor TModel.Destroy;
begin
  fAssertions.Free;
  inherited;
end;

function TModel.effectCondition: TEffectCondition;
var
  headerNode: THeaderNode;
begin
  Result:=ecUnknown;
  for headerNode in fParser.Nodes.Headers do
  begin
    if headerNode.SectionType=stPolicyEffect then
    begin
      if (headerNode.ChildNodes.Count>=0) and
        (headerNode.ChildNodes.Items[0] is TEffectNode) then
      begin
        Result:=(headerNode.ChildNodes.Items[0] as TEffectNode).EffectCondition;
      end;
    end;
  end;
end;

procedure TModel.checkSection(const aSection: TSectionType);
begin
  if not (aSection in [stRequestDefinition, stPolicyDefinition,
                       stPolicyEffect, stMatchers,
                       stRoleDefinition]) then
    raise ECasbinException.Create('Wrong section type');
end;

function TModel.section(const aSection: TSectionType; const aSlim: Boolean =
    true): string;
var
  headerNode: THeaderNode;
  strList: TStringList;
begin
  Result:='';
  if fNodes.Headers.Count=0 then
    Exit;
  checkSection(aSection);
  for headerNode in fNodes.Headers do
    if headerNode.SectionType=aSection then
    begin
      Result:=headerNode.toOutputString;
      strList:=TStringList.Create;
      strList.Text:=Result;
      if (strList.Count>1) then
        if aSlim and (strList.Strings[0][findStartPos]='[') then
          Result:=strList.Strings[1];
      strList.Free;
      Exit;
    end;
end;

end.
