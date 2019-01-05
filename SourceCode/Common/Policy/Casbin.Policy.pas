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
  Casbin.Adapter.Policy.Types, System.Rtti, System.Types;

type
  TPolicyManager = class(TBaseInterfacedObject, IPolicyManager)
  private
    fAdapter: IPolicyAdapter;
    fParser: IParser;
    fNodes: TNodeCollection;
    fPoliciesList: TList<string>;
    fRolesList: TList<string>;

    fRolesNodes: TObjectDictionary<string, TRoleNode>;
    fRolesLinks: TDictionary<string, TStringDynArray>;
    procedure loadPolicies;
    function findRolesNode(const aDomain, aValue: string): TRoleNode;
    procedure loadRoles;
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
    procedure remove (const aPolicyDefinition: string; const aFilter: string);
                                                                overload;

    procedure clearRoles;
    function roles: TList<string>;
    procedure addLink(const aBottom: string; const aTop: string); overload;
    procedure addLink(const aBottom: string;
                      const aTopDomain: string; const aTop: string); overload;
    procedure addLink(const aBottomDomain: string; const aBottom: string;
                      const aTopDomain: string; const aTop: string); overload;
    procedure removeLink(const aLeft, aRight: string); overload;
    procedure removeLink(const aLeft: string;
                      const aRightDomain: string; const aRight: string);
                                                                       overload;
    procedure removeLink(const aLeftDomain, aLeft, aRightDomain, aRight: string);
        overload;
    function linkExists(const aLeft: string; const aRight: string): Boolean;
        overload;
    function linkExists(const aLeft: string;
                      const aRightDomain: string; const aRight: string):boolean;
                                                                        overload;
    function linkExists(const aLeftDomain: string; const aLeft: string; const
        aRightDomain: string; const aRight: string): boolean; overload;
    function rolesForEntity (const aEntity: string; const aDomain: string =''):
                                                                TStringDynArray;
    function EntitiesForRole (const aEntity: string; const aDomain: string =''):
                                                                TStringDynArray;
{$ENDREGION}
  public
    constructor Create(const aPolicy: string); overload;
    constructor Create(const aAdapter: IPolicyAdapter); overload;
    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

uses
  Casbin.Adapter.Filesystem.Policy, Casbin.Exception.Types, System.Classes,
  Casbin.Parser, Casbin.Core.Utilities, Casbin.Model.Sections.Types,
  Casbin.Core.Defaults, System.SysUtils, System.StrUtils,
  Casbin.Model.Sections.Default, Casbin.Adapter.Memory.Policy;

{ TPolicyManager }

constructor TPolicyManager.Create(const aPolicy: string);
begin
  Create(TPolicyFileAdapter.Create(aPolicy));
end;

procedure TPolicyManager.add(const aTag: string);
begin
  fAdapter.add(aTag);
end;

procedure TPolicyManager.addLink(const aBottom, aTop: string);
begin
  addLink(DefaultDomain, aBottom, DefaultDomain, aTop);
end;

procedure TPolicyManager.addLink(const aBottomDomain, aBottom, aTopDomain,
  aTop: string);
var
  bottomNode: TRoleNode;
  topNode: TRoleNode;
  IDArray: TStringDynArray;
  itemString: string;
  itemStringExists: Boolean;
begin
  bottomNode:=findRolesNode(aBottomDomain, aBottom);
  if not Assigned(bottomNode) then
    bottomNode:=TRoleNode.Create(aBottom, aBottomDomain);

  topNode:=findRolesNode(aTopDomain, aTop);
  if not Assigned(topNode) then
    topNode:=TRoleNode.Create(aTop, aTopDomain);

  if not fRolesNodes.ContainsKey(bottomNode.ID) then
    fRolesNodes.Add(bottomNode.ID, bottomNode);
  if not fRolesNodes.ContainsKey(topNode.ID) then
    fRolesNodes.Add(topNode.ID, topNode);

  if not fRolesLinks.ContainsKey(bottomNode.ID) then
    SetLength(IDArray, 0)
  else
    IDArray:=fRolesLinks.Items[bottomNode.ID];

  itemStringExists:=False;
  for itemString in IDArray do
  begin
    if itemString = topNode.ID then
    begin
      itemStringExists:=true;
      Break;
    end;
  end;

  if not itemStringExists then
  begin
    SetLength(IDArray, Length(IDArray)+1);
    IDArray[Length(IDArray)-1]:=topNode.ID;
  end;

  fRolesLinks.AddOrSetValue(bottomNode.ID, IDArray);

end;

procedure TPolicyManager.addLink(const aBottom, aTopDomain, aTop: string);
begin
  addLink(DefaultDomain, aBottom, aTopDomain, aTop);
end;

procedure TPolicyManager.clear;
begin
  fAdapter.clear;
end;

procedure TPolicyManager.clearRoles;
begin
  fRolesLinks.Clear;
  fRolesNodes.Clear;
end;

constructor TPolicyManager.Create(const aAdapter: IPolicyAdapter);
begin
  if not Assigned(aAdapter) then
    raise ECasbinException.Create('Adapter is nil in '+Self.ClassName);
  inherited Create;
  fAdapter:=aAdapter;
  fPoliciesList:=TList<string>.Create;
  fRolesList:=TList<string>.Create;
  fRolesNodes:=TObjectDictionary<string, TRoleNode>.Create([doOwnsValues]);
  fRolesLinks:=TDictionary<string, TStringDynArray>.Create;
  loadPolicies;
end;

constructor TPolicyManager.Create;
begin
  Create(TPolicyMemoryAdapter.Create);
end;

procedure TPolicyManager.removeLink(const aLeftDomain, aLeft, aRightDomain,
    aRight: string);
var
  leftNode: TRoleNode;
  rightNode: TRoleNode;
  IDArray: TStringDynArray;
  newIDArray: TStringDynArray;
  itemString: string;
begin
  leftNode:=findRolesNode(aLeftDomain, aLeft);
  if not Assigned(leftNode) then
    Exit;

  rightNode:=findRolesNode(aRightDomain, aRight);
  if not Assigned(rightNode) then
    Exit;

  if fRolesLinks.ContainsKey(leftNode.id) then
  begin
    IDArray:=fRolesLinks.Items[leftNode.ID];
    SetLength(newIDArray, 0);
    for itemString in IDArray do
    begin
      if itemString <> rightNode.ID then
      begin
        SetLength(newIDArray, Length(newIDArray)+1);
        newIDArray[Length(newIDArray)-1]:=itemString;
      end;
    end;
    fRolesLinks.Items[leftNode.ID]:=newIDArray;
  end;

  loadRoles;
end;

procedure TPolicyManager.removeLink(const aLeft, aRightDomain, aRight: string);
begin
  removeLink(DefaultDomain, aLeft, aRightDomain, aRight);
end;

procedure TPolicyManager.removeLink(const aLeft, aRight: string);
begin
  removeLink(DefaultDomain, aLeft, DefaultDomain, aRight);
end;

destructor TPolicyManager.Destroy;
begin
  fPoliciesList.Free;
  fRolesList.Free;
  fRolesLinks.Free;
  fRolesNodes.Free;
  inherited;
end;

function TPolicyManager.EntitiesForRole(const aEntity,
  aDomain: string): TStringDynArray;
var
  domain: string;
  entity: TRoleNode;
  id: string;
  linkID: string;
begin
  SetLength(Result, 0);

  if Trim(aDomain)='' then
    domain:=DefaultDomain
  else
    domain:=Trim(aDomain);

  for id in fRolesLinks.Keys do
  begin
    for linkID in fRolesLinks.Items[id] do
    begin
      if fRolesNodes.ContainsKey(linkID) then
      begin
        entity:=fRolesNodes.Items[linkID];
        if SameText(entity.Domain, domain) and
            SameText(entity.Value, aEntity) then
        begin
          SetLength(Result, Length(Result)+1);
          Result[Length(Result)-1]:=fRolesNodes.items[id].Value;
        end;
      end;
    end;
  end;

  TArray.Sort<string>(Result);
end;

function TPolicyManager.findRolesNode(const aDomain, aValue: string): TRoleNode;
var
  node: TRoleNode;
  itemNode: TRoleNode;
begin
  node:=nil;
  for itemNode in fRolesNodes.Values do
  begin
    if SameText(UpperCase(itemNode.Domain), UpperCase(Trim(aDomain))) and
          SameText(UpperCase(itemNode.Value), UpperCase(Trim(aValue))) then
    begin
      node:=itemNode;
      Break;
    end;
  end;
  Result := node;
end;

function TPolicyManager.linkExists(const aLeft: string; const aRight: string):
    Boolean;
begin
  Result:=linkExists(DefaultDomain, aLeft, DefaultDomain, aRight);
end;

function TPolicyManager.linkExists(const aLeftDomain: string; const aLeft:
    string; const aRightDomain: string; const aRight: string): boolean;
var
  leftNode: TRoleNode;
  rightNode: TRoleNode;
  IDArray: TStringDynArray;
  item: string;
  itemString: string;
begin
{$IFDEF DEBUG}
  fAdapter.Logger.log('   Roles for Left: '+aLeft);
  fAdapter.Logger.log('      Roles: ');
  if Length(rolesForEntity(aLeft))=0 then
    fAdapter.Logger.log('         No Roles found')
  else
    for item in rolesForEntity(aLeft) do
      fAdapter.Logger.log('         '+item);

  fAdapter.Logger.log('   Roles for Right: '+aRight);
  fAdapter.Logger.log('      Roles: ');
  if Length(rolesForEntity(aRight))=0 then
    fAdapter.Logger.log('         No Roles found')
  else
    for item in rolesForEntity(aRight) do
      fAdapter.Logger.log('         '+item);


{$ENDIF}
  Result:=False;

  if SameText(UpperCase(aLeftDomain), UpperCase(aRightDomain)) and
      SameText(UpperCase(aLeft), UpperCase(aRight)) then
  begin
    Result:=True;
    exit;
  end;

  loadRoles;

  leftNode:=findRolesNode(aLeftDomain, aLeft);
  if not Assigned(leftNode) then
    Exit;

  rightNode:=findRolesNode(aRightDomain, aRight);
  if not Assigned(rightNode) then
    Exit;

  if fRolesLinks.ContainsKey(leftNode.id) then
  begin
    IDArray:=fRolesLinks.Items[leftNode.ID];
    for itemString in IDArray do
    begin
      if SameText(itemString, rightNode.ID) and
          SameText(aRightDomain, rightNode.Domain) then
      begin
        result:=true;
        Exit;
      end
    end;
    // If we are here it means that first level (top) links do not exist
    // We now check itineratively the top links
    for itemString in IDArray do
    begin
      if fRolesNodes.ContainsKey(itemString) then
      begin
        leftNode:=fRolesNodes.Items[itemString];
        if Assigned(leftNode) and Assigned(rightNode) then
          Result:=linkExists(leftNode.Domain, leftNode.Value,
                                      rightNode.Domain, rightNode.Value);
      end;
    end;
  end;

end;

function TPolicyManager.linkExists(const aLeft, aRightDomain,
  aRight: string): boolean;
begin
  Result:=linkExists(DefaultDomain, aLeft, aRightDomain, aRight);
end;

procedure TPolicyManager.load(const aFilter: TFilterArray);
begin
  fAdapter.clear;
  fAdapter.load(aFilter);
  loadPolicies;
  loadRoles;
end;

procedure TPolicyManager.loadPolicies;
begin
  if (Assigned(fNodes)) then
    Exit;
  fPoliciesList.Clear;
  fAdapter.clear;
  fAdapter.load(fAdapter.Filter);
  fParser:=TParser.Create(fAdapter.toOutputString, ptPolicy);
  fParser.parse;
  if fParser.Status=psError then
    raise ECasbinException.Create('Parsing error in Model: '+fParser.ErrorMessage);
  fNodes:=fParser.Nodes;
end;

procedure TPolicyManager.loadRoles;
var
  role: string;
  policy: string;
  roleList: TList<string>;
  policyList: TList<string>;
  section: TSection;
  useDomains: Boolean;
begin
  useDomains:=False;
  clearRoles;

  // We get the Role Rules
  section:=createDefaultSection(stRoleDefinition);
  for role in roles do
  begin
    roleList:=TList<string>.Create;
    roleList.AddRange(role.Split([',']));
    if roleList.Count>=3 then
    begin
      case IndexStr(roleList[0], section.Tag) of
        /// NEED TO REWRITE
        /// By HUGE and RISKY convention we assume 0 --> g and 1 --> g2
        0: addLink(roleList[1], roleList[2]);
        1: if roleList.Count>=4 then
           begin
            addLink(roleList[1], roleList[3], roleList[2]);
            useDomains:=true;
           end
      else
        raise ECasbinException.Create('The Role Rules are not correct.'+sLineBreak+
                                      'Make sure you use g or g2');
      end;
    end;
    roleList.Free;
  end;

  section.Free;

  // We now need to transverse the other policy rules to build the links
  for policy in policies do
  begin
    policyList:=TList<string>.Create;
    policyList.AddRange(policy.Split([',']));

    // Need to filter the policies to load based on the avail links from the g's
    // Now we load all the policies and have them hanging around although never
    // being called (enforced)
    if (policyList.Count>=5) and useDomains then
      addLink(policyList[1], policyList[3], policyList[2])
    else
      if (policyList.Count>=4) and (not useDomains) then
        addLink(policyList[1], policyList[2]);

    policyList.Free;
  end;
end;

function TPolicyManager.policies: TList<string>;
var
  node: TChildNode;
  headerNode: THeaderNode;
  section: TSection;
  tag: string;
  foundTag: Boolean;
begin
  foundTag:=False;
  fPoliciesList.Clear;
  fRolesList.Clear;
  section:=createDefaultSection(stPolicyDefinition);
  for headerNode in fNodes.Headers do
    if (headerNode.SectionType=stPolicyRules) then
    begin
      for node in headerNode.ChildNodes do
      begin
        for tag in section.Tag do
          if node.Key=tag then
          begin
            foundTag:=True;
            Break;
          end
          else
            foundTag:=False;
        if foundTag then
          fPoliciesList.add(node.Key+AssignmentCharForPolicies+node.Value)
      end;
    end;
  section.Free;
  Result:=fPoliciesList;
end;

function TPolicyManager.policy(const aFilter: TFilterArray = []): string;
var
  i: Integer;
  policy: string;
  test: string;
  testPolicy: string;
  strArray: TFilterArray;
begin
  Result:='undefined';

  //Clean aFilter
  strArray:=aFilter;
  for i:=0 to Length(strArray)-1 do
  begin
    strArray[i]:=trim(strArray[i]);
  end;
  testPolicy:=String.Join(',', strArray);

  for policy in policies do
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
        exit;
      end;
    end;
  end;
end;

function TPolicyManager.policyExists(const aFilter: TFilterArray): Boolean;
var
  i: Integer;
  policy: string;
  test: string;
  testPolicy: string;
  strArray: TFilterArray;
begin
  Result:=False;
  if Length(aFilter)=0 then
    Exit;

  if IndexStr(UpperCase(aFilter[0]), ['P', 'G', 'G2']) = -1 then
    testPolicy:='p,';
  for policy in aFilter do
    testPolicy:=testPolicy+policy+',';
  if testPolicy[findEndPos(testPolicy)]=',' then
    testPolicy:=Copy(testPolicy, findStartPos, findEndPos(testPolicy)-1);

  for policy in policies do
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
end;

procedure TPolicyManager.remove(const aPolicyDefinition: string);
begin
  fAdapter.remove(aPolicyDefinition);
end;

procedure TPolicyManager.remove(const aPolicyDefinition, aFilter: string);
begin
  fAdapter.remove(aPolicyDefinition, aFilter);
end;

function TPolicyManager.roles: TList<string>;
var
  node: TChildNode;
  headerNode: THeaderNode;
  section: TSection;
  tag: string;
  foundTag: Boolean;
begin
  foundTag:=False;
  fRolesList.Clear;
  section:=createDefaultSection(stRoleDefinition);
  for headerNode in fNodes.Headers do
    if (headerNode.SectionType=stPolicyRules) then
    begin
      for node in headerNode.ChildNodes do
      begin
        for tag in section.Tag do
          if node.Key=tag then
          begin
            foundTag:=True;
            Break;
          end
          else
            foundTag:=False;
        if foundTag then
          fRolesList.add(node.Key+AssignmentCharForRoles+node.Value)
      end;
    end;
  section.Free;
  Result:=fRolesList;
end;

function TPolicyManager.rolesForEntity(const aEntity,
  aDomain: string): TStringDynArray;
var
  nodeEntity: TRoleNode;
  entity: TRoleNode;
  domain: string;
  id: string;
begin
  if Trim(aDomain)='' then
    domain:=DefaultDomain
  else
    domain:=Trim(aDomain);

  nodeEntity:=findRolesNode(domain, aEntity);
  if Assigned(nodeEntity) then
  begin
    if fRolesLinks.ContainsKey(nodeEntity.ID) then
    begin
      for id in fRolesLinks.Items[nodeEntity.ID] do
      begin
        entity:=fRolesNodes.Items[id];
        SetLength(Result, Length(Result)+1);
        Result[Length(Result)-1]:=entity.Value;
      end;
    end;
  end;

  TArray.Sort<string>(Result);
end;

function TPolicyManager.section(const aSlim: Boolean): string;
var
  headerNode: THeaderNode;
  strList: TStringList;
  policy: string;
begin
  Result:='';
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
