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
unit Casbin.Policy;

interface

uses
  Casbin.Core.Base.Types, Casbin.Policy.Types, Casbin.Parser.Types,
  Casbin.Parser.AST.Types, Casbin.Adapter.Policy.Types, System.Rtti,
  System.Types, System.Classes, Casbin.Model.Sections.Types,
  System.Generics.Collections, Casbin.Watcher.Types;

type
  TPolicyManager = class(TBaseInterfacedObject, IPolicyManager)
  private
    fAdapter: IPolicyAdapter;
    fParser: IParser;    //PALOFF
    fNodes: TNodeCollection;
    fPoliciesList: TList<string>;
    fRolesList: TList<string>;
    fDomains: TList<string>;
    fWatchers: TList<IWatcher>;
    fRolesNodes: TObjectDictionary<string, TRoleNode>;
    fRolesLinks: TObjectDictionary<string, TStringList>;
    procedure loadPolicies;
    function findRolesNode(const aDomain, aValue: string): TRoleNode;
    function implicitPolicyExists(const aValue, aResource: string): Boolean;
    procedure loadRoles;
  private
{$REGION 'Interface'}
    function section (const aSlim: Boolean = true): string;
    function toOutputString: string;
    function getAdapter: IPolicyAdapter;

    // Policies
    function policies: TList<string>;
    procedure load (const aFilter: TFilterArray = []);

    function policy(const aFilter: TFilterArray = []): string;
    procedure clear;
    function policyExists(const aFilter: TFilterArray = []): Boolean;
    procedure removePolicy(const aFilter: TFilterArray = []; const aRoleMode:
        TRoleMode = rmImplicit);
    procedure addPolicy (const aSection: TSectionType; const aTag: string;
                              const aAssertion: string); overload;
    procedure addPolicy (const aSection: TSectionType;
                              const aAssertion: string); overload;

    // Roles
    procedure clearRoles;
    function roles: TList<string>;
    function domains: TList<string>;
    function roleExists (const aFilter: TFilterArray = []): Boolean;
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
    function rolesForEntity(const aEntity: string; const aDomain: string = '';
        const aRoleMode: TRoleMode = rmNonImplicit): TStringDynArray;
    function entitiesForRole(const aEntity: string; const aDomain: string =''):
        TStringDynArray;

    // Watchers
    procedure registerWatcher (const aWatcher: IWatcher);
    procedure unregisterWatcher(const aWatcher: IWatcher);
    procedure notifyWatchers;

    //Permissions
    function permissionsForEntity(const aEntity: string): TStringDynArray;
    function permissionExists (const aEntity: string; const aPermission: string):
                                                              Boolean;
{$ENDREGION}
  public
    constructor Create(const aPolicy: string); overload;
    constructor Create(const aAdapter: IPolicyAdapter); overload;
    constructor Create; overload;
    destructor Destroy; override;
  end;

implementation

uses
  Casbin.Adapter.Filesystem.Policy, Casbin.Exception.Types, Casbin.Parser,
  Casbin.Core.Utilities, Casbin.Core.Defaults, System.SysUtils,
  System.StrUtils, Casbin.Model.Sections.Default, Casbin.Adapter.Memory.Policy,
  Casbin.Parser.AST, ArrayHelper, System.RegularExpressions, Casbin.Functions.IPMatch;

{ TPolicyManager }

constructor TPolicyManager.Create(const aPolicy: string);
begin
  Create(TPolicyFileAdapter.Create(aPolicy));
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
  IDList: TStringList;
begin
  bottomNode:=findRolesNode(aBottomDomain, aBottom);
  if not Assigned(bottomNode) then
  begin
    bottomNode:=TRoleNode.Create(aBottom, aBottomDomain);
    fRolesNodes.add(bottomNode.ID, bottomNode);
  end;

  topNode:=findRolesNode(aTopDomain, aTop);
  if not Assigned(topNode) then
  begin
    topNode:=TRoleNode.Create(aTop, aTopDomain);
    fRolesNodes.add(topNode.ID, topNode);
  end;

  if not fRolesLinks.ContainsKey(bottomNode.ID) then
  begin
    IDList:=TStringList.Create;
    IDList.Sorted:=true;
    IDList.CaseSensitive:=False;
    fRolesLinks.add(bottomNode.ID, IDList);
  end;

  IDList:=fRolesLinks.Items[bottomNode.ID];

  if IDList.IndexOf(topNode.id)=-1 then
    IDList.add(topNode.ID);

end;

procedure TPolicyManager.addPolicy(const aSection: TSectionType;
  const aAssertion: string);
var
  arrStr: TArray<string>;
 begin
  if trim(aAssertion)='' then
    raise ECasbinException.Create('The Assertion is empty');
  arrStr:=aAssertion.Split([',']);
  if Length(arrStr)<=1 then
    raise ECasbinException.Create('The Assertion '+aAssertion+' is wrong');

  addPolicy(aSection, arrStr[0], string.Join(',', arrStr, 1, Length(arrStr)-1));
end;

procedure TPolicyManager.addPolicy(const aSection: TSectionType; const aTag,
  aAssertion: string);
begin
  if trim(aTag)='' then
    raise ECasbinException.Create('The Tag is empty');
  if trim(aAssertion)='' then
    raise ECasbinException.Create('The Assertion is empty');
  if not ((aSection=stDefault) or (aSection=stPolicyRules) or
                                            (aSection=stRoleRules)) then
    raise ECasbinException.Create('Wrong section type');

  fAdapter.add(Trim(aTag)+','+trim(aAssertion));
  fParser:=TParser.Create(fAdapter.toOutputString, ptPolicy);
  fParser.parse;
  if fParser.Status=psError then
    raise ECasbinException.Create('Parsing error in Model: '+fParser.ErrorMessage);
  fNodes:=fParser.Nodes;
  loadRoles;
  notifyWatchers;
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
  fPoliciesList:=TList<string>.Create;  //PALOFF
  fRolesList:=TList<string>.Create;  //PALOFF
  fRolesNodes:=TObjectDictionary<string, TRoleNode>.Create([doOwnsValues]);
  fRolesLinks:=TObjectDictionary<string, TStringList>.Create([doOwnsValues]);
  fDomains:=TList<string>.Create; //PALOFF
  fWatchers:=TList<IWatcher>.Create; //PALOFF
  loadPolicies;
  loadRoles;
end;

constructor TPolicyManager.Create;
begin
  Create(TPolicyMemoryAdapter.Create);
end;

procedure TPolicyManager.registerWatcher(const aWatcher: IWatcher);
begin
  if not fWatchers.Contains(aWatcher) then
    fWatchers.Add(aWatcher);
end;

procedure TPolicyManager.removeLink(const aLeftDomain, aLeft, aRightDomain,
    aRight: string);
var
  leftNode: TRoleNode;
  rightNode: TRoleNode;
  index: integer;
  list: TStringList;
begin
  leftNode:=findRolesNode(aLeftDomain, aLeft);
  if not Assigned(leftNode) then
    Exit;

  rightNode:=findRolesNode(aRightDomain, aRight);
  if not Assigned(rightNode) then
    Exit;

  list:=fRolesLinks.Items[leftNode.ID];
  if Assigned(list) then
  begin
    index:=list.IndexOf(rightNode.ID);
    if (index>-1) and (rightNode.Domain=aRightDomain) then
      list.Delete(index);
  end;
end;

procedure TPolicyManager.removePolicy(const aFilter: TFilterArray = []; const
    aRoleMode: TRoleMode = rmImplicit);
var
  arrString: TArrayRecord<string>;
  item: string;
  header: THeaderNode;
  child: TChildNode;
  outStr: string;
  itemString: string;
  regExp: TRegEx;
  match: TMatch;
  key: string;
  pType: Boolean;
begin
  arrString:=TArrayRecord<string>.Create(aFilter);

  itemString:=string.Join(',', aFilter);
  while Pos(#32, itemString, findStartPos)<>0 do
    Delete(itemString, Pos(#32, itemString, findStartPos), 1);

  for header in fNodes.Headers do
  begin
    for child in header.ChildNodes do
    begin
      outStr:=child.toOutputString;
      pType:=UpperCase(outStr).Contains('P=');
      outStr:=outStr.Replace('p=',' ');
      outStr:=outStr.Replace('g=',' ');
      outStr:=outStr.Replace('g2=',' ');
      while Pos(#32, outStr, findStartPos)<>0 do
        Delete(outStr, Pos(#32, outStr, findStartPos), 1);

      if arrString.Contains('*') then
      begin
        key:='^';
        for item in arrString do
        begin
          if item<>'*' then
            key:=key+'(?=.*\b'+Trim(item)+'\b)';
        end;
        key:=key+'.*$';
        regExp:=TRegEx.Create(key);
        match:=regExp.Match(outStr);
        if match.Success then
        begin
          if (aRoleMode=rmImplicit) or
            ((aRoleMode=rmNonImplicit) and (not pType)) then
          begin
            fAdapter.remove(child.toOutputString.Replace('=',','));
            header.ChildNodes.Remove(child);
          end;
        end;
      end
      else
        if Trim(UpperCase(outStr)) = Trim(UpperCase(itemString)) then
        begin
          if (aRoleMode=rmImplicit) or
            ((aRoleMode=rmNonImplicit) and (not pType)) then
          begin
            fAdapter.remove(child.toOutputString.Replace('=',','));
            header.ChildNodes.Remove(child);
          end;
        end;
    end;
  end;
  loadRoles;
  notifyWatchers;
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
  fDomains.Free;
  fWatchers.Free;
  inherited;
end;

function TPolicyManager.domains: TList<string>;
begin
  Result:=fDomains;
end;

function TPolicyManager.entitiesForRole(const aEntity: string; const aDomain:
    string =''): TStringDynArray;
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
        if SameText(Trim(UpperCase(entity.Domain)), Trim(UpperCase(domain))) and
            SameText(Trim(UpperCase(entity.Value)), Trim(UpperCase(aEntity))) then
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

function TPolicyManager.getAdapter: IPolicyAdapter;
begin
  result:=fAdapter;
end;

function TPolicyManager.implicitPolicyExists(const aValue, aResource: string):
    Boolean;
var
  policyStr: string;
begin
  Result:=False;
  for policyStr in policies do
  begin
    if UpperCase(policyStr).Contains(Trim(UpperCase(aValue))) and
      UpperCase(policyStr).Contains(Trim(UpperCase(aResource))) then
    begin
      Result:=True;
      Break;
    end;
  end;
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
  item: string;
  lDomain,
  rDomain,
  lItem,
  rItem: string;
begin
  lDomain:=Trim(aLeftDomain);
  rDomain:=Trim(aRightDomain);
  lItem:=Trim(aLeft);
  rItem:=Trim(aRight);
{$IFDEF DEBUG}
  fAdapter.Logger.log('   Roles for Left: '+lItem);
  fAdapter.Logger.log('      Roles: ');
  if Length(rolesForEntity(aLeft))=0 then
    fAdapter.Logger.log('         No Roles found')
  else
    for item in rolesForEntity(lItem) do
      fAdapter.Logger.log('         '+item);

  fAdapter.Logger.log('   Roles for Right: '+rItem);
  fAdapter.Logger.log('      Roles: ');
  if Length(rolesForEntity(rItem))=0 then
    fAdapter.Logger.log('         No Roles found')
  else
    for item in rolesForEntity(rItem) do
      fAdapter.Logger.log('         '+item);


{$ENDIF}
  Result:=False;

  if SameText(lDomain, rDomain) and
      (SameText(lItem, rItem) or IPmatch(lItem, rItem, False)) or
        (IndexStr(lItem, builtinAccounts)>-1) then
  begin
    Result:=True;
    exit;
  end;

  leftNode:=findRolesNode(lDomain, lItem);
  if not Assigned(leftNode) then
    Exit;

  rightNode:=findRolesNode(rDomain, rItem);
  if not Assigned(rightNode) then
    Exit;

  if fRolesLinks.ContainsKey(leftNode.ID) then
  begin
    if fRolesLinks.Items[leftNode.ID].IndexOf(rightNode.ID)>-1 then
    begin
      Result:=True;
      Exit;
    end
    else
    begin
      for item in fRolesLinks.Items[leftNode.ID] do
      begin
        leftNode:=fRolesNodes.Items[item];

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
  fPoliciesList.Clear;
//  fAdapter.clear;
  fAdapter.load(fAdapter.Filter);  // Forces the default tags
  fParser:=TParser.Create(fAdapter.toOutputString, ptPolicy);
  fParser.parse;
  if fParser.Status=psError then
    raise ECasbinException.Create('Parsing error in Model: '+fParser.ErrorMessage);
  fNodes:=fParser.Nodes;
end;

procedure TPolicyManager.loadRoles;
var
  role: string;
  policyItem: string;
  roleList: TList<string>;
  sectionItem: TSection;
  useDomains: Boolean;
  tagArrayRec: TArrayRecord<string>;
  policyList: TList<string>;
begin
  useDomains:=False;
  clearRoles;

  // Domains
  fDomains.Clear;

  // We get the Role Rules
  sectionItem:=createDefaultSection(stRoleDefinition);
  for role in roles do
  begin
    roleList:=TList<string>.Create;
    roleList.AddRange(role.Split([',']));
    if roleList.Count>=3 then
    begin
      tagArrayRec:=TArrayRecord<string>.Create(sectionItem.Tag);
      if tagArrayRec.Contains(roleList[0]) then
      begin
        if roleList.Count=3 then  //No Domains
          addLink(roleList[1], roleList[2])
        else
        if roleList.Count=4 then  //Domains
        begin
         addLink(roleList[1], roleList[3], roleList[2]);
         if (trim(roleList[3])<>DefaultDomain) then
           fDomains.Add(trim(roleList[3]));
         useDomains:=true;
        end
        else
          raise ECasbinException.Create('The Role Rules are not correct.');
      end
      else
        raise ECasbinException.Create('The Role Rules are not correct.');
    end;
    roleList.Free;
  end;

  sectionItem.Free;

  fDomains.Sort;

  // We now need to transverse the other policy rules to build the links
  for policyItem in policies do
  begin
    tagArrayRec:=TArrayRecord<string>.Create(fDomains.ToArray);
    policyList:=TList<string>.Create;
    policyList.AddRange(policyItem.Split([',']));
    if useDomains then
    begin
      tagArrayRec.ForEach(procedure(var Value: string; Index: integer)
                          var
                            domIndex: integer;
                          begin
                            if policyItem.Contains(Value) then
                            begin
                              domIndex:=IndexStr(Value, policyList.ToArray);
                              if (domIndex-1>=0) and
                                    (domIndex+1<=policyList.Count-1) then
                                addLink(policyList[domIndex-1], Value,
                                          policyList[domIndex+1]);
                            end;
                          end);
    end
    else
      addLink(policyList[1], policyList[2]);
    policyList.Free;
  end;
end;

procedure TPolicyManager.notifyWatchers;
var
  watcher: IWatcher;
begin
  for watcher in fWatchers do
    watcher.update;
end;

function TPolicyManager.permissionExists(const aEntity,
  aPermission: string): Boolean;
var
  permArray: TStringDynArray;
  permArrRec: TArrayRecord<string>;
begin
  permArray:=permissionsForEntity(aEntity);
  permArrRec:=TArrayRecord<string>.Create(permArray);
  permArrRec.ForEach(procedure(var Value: string; Index: Integer)
                     begin
                       value:=trim(UpperCase(value));
                     end);
  Result:=permArrRec.Contains(UpperCase(aPermission));
end;

function TPolicyManager.permissionsForEntity(const aEntity: string):
    TStringDynArray;
var
  policyItem: string;
  polArray: TArrayRecord<string>;
  tmpArray: TArrayRecord<string>;
begin
  SetLength(Result, 0);
  if Trim(aEntity)<>'' then
  begin
    for policyItem in policies do
    begin
      polArray:=TArrayRecord<string>.Create(UpperCase(policyItem).Split([',']));
      polArray.ForEach(procedure(var Value: string; Index: Integer)
                       begin
                         value:=trim(value);
                       end);

      tmpArray:=TArrayRecord<string>.Create(policyItem.Split([',']));
      tmpArray.ForEach(procedure(var Value: string; Index: Integer)
                       begin
                         value:=trim(value);
                       end);

      if polArray.Contains(UpperCase(aEntity)) then
      begin
        SetLength(Result, Length(Result)+1);
        result[Length(Result)-1]:=tmpArray[tmpArray.Count-1];
      end;
    end;
  end;
end;

function TPolicyManager.policies: TList<string>;
var
  node: TChildNode;
  headerNode: THeaderNode;
  sectionItem: TSection;
  tag: string;
  foundTag: Boolean;
begin
  foundTag:=False;
  fPoliciesList.Clear;
  fRolesList.Clear;
  sectionItem:=createDefaultSection(stPolicyDefinition);
  for headerNode in fNodes.Headers do
    if (headerNode.SectionType=stPolicyRules) then
    begin
      for node in headerNode.ChildNodes do
      begin
        for tag in sectionItem.Tag do
        begin
          if node.Key <> tag then
            foundTag:=false
          else
          begin
            foundTag:=True;
            Break;
          end
        end;
        if foundTag then
          fPoliciesList.add(node.Key+AssignmentCharForPolicies+node.Value)
      end;
    end;
  sectionItem.Free;
  Result:=fPoliciesList;
end;

function TPolicyManager.policy(const aFilter: TFilterArray = []): string;
var
  i: Integer;
  policyItem: string;
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

  for policyItem in policies do
  begin
    strArray:=TFilterArray(policyItem.Split([','])); //PALOFF
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
  policyItem: string;
  filterRec: TArrayRecord<string>;
  policyRec: TArrayRecord<string>;
  outcome: Boolean;
  policyStr: string;
begin
  Result:=False;
  if Length(aFilter)=0 then
    Exit;

  filterRec:=TArrayRecord<string>.Create(aFilter);
  filterRec.Remove('p');
  filterRec.Remove('P');
  filterRec.Remove('g');
  filterRec.Remove('G');
  filterRec.Remove('g2');
  filterRec.Remove('G2');
  filterRec.ForEach(procedure(var Value: string; Index: Integer)
                    begin
                      value:=Trim(value);
                    end);

  for policyItem in policies do
  begin
    policyRec:=TArrayRecord<string>.Create(policyItem.Split([',']));
    policyRec.Remove('p');
    policyRec.Remove('P');
    policyRec.Remove('g');
    policyRec.Remove('G');
    policyRec.Remove('g2');
    policyRec.Remove('G2');
    policyRec.ForEach(procedure(var Value: string; Index: Integer)
                      begin
                        value:=trim(value);
                      end);

    policyStr:=string.Join(',', policyRec.Items);

    outcome:=true;
    filterRec.ForEach(procedure(var Value: string; Index: Integer)
                   begin
                     outcome:= outcome and
                                UpperCase(policyStr).Contains(UpperCase(Value));
                   end);
    Result:=outcome;

    if Result then
      Break;

  end;

  if not Result then
    Result:=roleExists(aFilter);
end;

function TPolicyManager.roleExists(const aFilter: TFilterArray): Boolean;
var
  i: Integer;
  ruleItem: string;
  test: string;
  testRule: string;
begin
  Result:=False;
  if Length(aFilter)=0 then
    Exit;

  testRule:=string.Join(',', aFilter);

  while Pos(#32, testRule, findStartPos)<>0 do
    Delete(testRule, Pos(#32, testRule, findStartPos), 1);

  if UpperCase(testRule).StartsWith('P,') or
       UpperCase(testRule).StartsWith('G,') or
         UpperCase(testRule).StartsWith('G2,') then
  begin
    i:=Pos(',', testRule, findStartPos);
    Delete(testRule, findStartPos, i);
  end;

  for ruleItem in roles do
  begin
    test:=ruleItem;

    while Pos(#32, test, findStartPos)<>0 do
      Delete(test, Pos(#32, test, findStartPos), 1);

    if UpperCase(test).StartsWith('P,') or
         UpperCase(test).StartsWith('G,') or
           UpperCase(test).StartsWith('G2,') then
    begin
      i:=Pos(',', test, findStartPos);
      Delete(test, findStartPos, i);
    end;

    Result:=string.Compare(test, testRule, [coIgnoreCase]) = 0;

    if Result then
      Break;

  end;
end;

function TPolicyManager.roles: TList<string>;
var
  node: TChildNode;
  headerNode: THeaderNode;
  sectionItem: TSection;
  tag: string;
  foundTag: Boolean;
begin
  foundTag:=False;
  fRolesList.Clear;
  sectionItem:=createDefaultSection(stRoleDefinition);
  for headerNode in fNodes.Headers do
    if (headerNode.SectionType=stPolicyRules) then
    begin
      for node in headerNode.ChildNodes do
      begin
        for tag in sectionItem.Tag do
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
  sectionItem.Free;
  Result:=fRolesList;
end;

function TPolicyManager.rolesForEntity(const aEntity: string; const aDomain:
    string = ''; const aRoleMode: TRoleMode = rmNonImplicit): TStringDynArray;
var
  nodeEntity: TRoleNode;
  entity: TRoleNode;
  domain: string; //PALOFF
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

        if (aRoleMode=rmImplicit) then
        begin
          SetLength(Result, Length(Result)+1);
          Result[Length(Result)-1]:=entity.Value;
        end
        else
        if not implicitPolicyExists(aEntity, entity.Value) then
        begin
          SetLength(Result, Length(Result)+1);
          Result[Length(Result)-1]:=entity.Value;
        end;
      end;
    end;
  end;

  TArray.Sort<string>(Result);
end;

function TPolicyManager.section(const aSlim: Boolean): string;
var
  headerNode: THeaderNode;
  strList: TStringList;
  policyItem: string;
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
        for policyItem in strList do
          Result:=Result+policyItem+sLineBreak;
      end;
      strList.Free;
      Exit;
    end;
end;

function TPolicyManager.toOutputString: string;
begin
  Result:=section;
end;

procedure TPolicyManager.unregisterWatcher(const aWatcher: IWatcher);
begin
  if fWatchers.Contains(aWatcher) then
    fWatchers.Remove(aWatcher);
end;

end.
