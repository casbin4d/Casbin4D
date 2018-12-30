unit Casbin.Policy;

interface

uses
  Casbin.Core.Base.Types, Casbin.Policy.Types, Casbin.Parser.Types,
  Casbin.Parser.AST.Types, System.Generics.Collections,
  Casbin.Adapter.Policy.Types;

type
  TPolicyManager = class(TBaseInterfacedObject, IPolicy)
  private
    fAdapter: IPolicyAdapter;
    fParser: IParser;
    fNodes: TNodeCollection;
{$REGION 'Interface'}
    function section (const aSlim: Boolean = true): string;
    function policies: TList<string>;
    procedure add(const aTag: string);
    function policy(const aFilter: TFilterArray = []): string;
    procedure clear;
    function policyExists(const aFilter: TFilterArray = []): Boolean;
    procedure remove(const aPolicyDefinition: string); overload;
    procedure remove (const aPolicyDefinition: string; const aFilter: string); overload;
{$ENDREGION}
  public
    constructor Create(const aModel: string); overload;
    constructor Create(const aAdapter: IPolicyAdapter); overload;
  end;

implementation

uses
  Casbin.Adapter.Filesystem.Policy, Casbin.Exception.Types, System.Classes,
  Casbin.Parser, Casbin.Core.Utilities, Casbin.Model.Sections.Types,
  Casbin.Core.Defaults, System.SysUtils;

{ TPolicyManager }

constructor TPolicyManager.Create(const aModel: string);
begin
  Create(TPolicyFileAdapter.Create(aModel));
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
  fAdapter.load;
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
  strArray: TFilterArray;
begin
  Result:=False;
  testPolicy:=testPolicy.Join(',', aFilter);
  list:=policies;
  for policy in list do
  begin
    strArray:=policy.Split([',']);
    for i:=0 to Length(strArray)-1 do
      strArray[i]:=trim(strArray[i]);
    if Length(strArray)>=1 then
    begin
      test:=''.Join(',', strArray);
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
