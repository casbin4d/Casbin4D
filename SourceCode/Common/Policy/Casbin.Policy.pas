unit Casbin.Policy;

interface

uses
  Casbin.Core.Base.Types, Casbin.Policy.Types, Casbin.Adapter.Types,
  Casbin.Parser.Types, Casbin.Parser.AST.Types, System.Generics.Collections;

type
  TPolicy = class (TBaseInterfacedObject, IPolicy)
  private
    fAdapter: IAdapter;
    fParser: IParser;
    fNodes: TNodeCollection;
{$REGION 'Interface'}
    function section (const aSlim: Boolean = true): string;
    function policies: TList<string>;
{$ENDREGION}
  public
    constructor Create(const aModel: string); overload;
    constructor Create(const aAdapter: IAdapter); overload;
  end;

implementation

uses
  Casbin.Adapter.Filesystem.Policy, Casbin.Exception.Types,
  System.Classes, Casbin.Parser, Casbin.Core.Utilities, Casbin.Model.Sections.Types;

{ TPolicy }

constructor TPolicy.Create(const aModel: string);
begin
  Create(TPolicyFileAdapter.Create(aModel));
end;

constructor TPolicy.Create(const aAdapter: IAdapter);
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

function TPolicy.policies: TList<string>;
var
  node: TChildNode;
  headerNode: THeaderNode;
  assertionNode: TAssertionNode;
  assertion: string;
begin
  Result:=TList<string>.Create;
  for headerNode in fNodes.Headers do
    if headerNode.SectionType=stPolicyRules then
    begin
      for node in headerNode.ChildNodes do
      begin
        Result.add(node.Value)
      end;
      Exit;
    end;
end;

function TPolicy.section(const aSlim: Boolean): string;
var
  headerNode: THeaderNode;
  strList: TStringList;
begin
  Result:='';
  for headerNode in fNodes.Headers do
    if headerNode.SectionType=stPolicyRules then
    begin
      Result:=headerNode.toOutputString;
      strList:=TStringList.Create;
      strList.Text:=Result;
      if (strList.Count>1) and (strList.Strings[0][findStartPos]='[') then
        Result:=strList.Strings[1];
      strList.Free;
      Exit;
    end;
end;

end.
