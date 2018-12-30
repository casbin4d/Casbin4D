unit Casbin.Model;

interface

uses
  Casbin.Core.Base.Types, Casbin.Model.Types, Casbin.Adapter.Types,
  Casbin.Parser.Types, Casbin.Parser.AST.Types, Casbin.Model.Sections.Types,
  System.Generics.Collections;

type
  TModel = class (TBaseInterfacedObject, IModel)
  private
    fAdapter: IAdapter;
    fParser: IParser;
    fNodes: TNodeCollection;
    procedure checkSection(const aSection: TSectionType);
  protected
{$REGION 'Interface'}
    function section(const aSection: TSectionType; const aSlim: Boolean = true):
        string; virtual;
    function assertions(const aSection: TSectionType): TList<System.string>;
{$ENDREGION}
  public
    constructor Create(const aModel: string); overload;
    constructor Create(const aAdapter: IAdapter); overload;
  end;

implementation

uses
  Casbin.Exception.Types, Casbin.Adapter.Filesystem,
  System.IOUtils, System.Classes, Casbin.Parser, Casbin.Core.Utilities;

constructor TModel.Create(const aModel: string);
var
  adapter: IAdapter;
begin
  adapter:=TFileAdapter.Create(aModel);
  Create(adapter);
end;

function TModel.assertions(const aSection: TSectionType): TList<System.string>;
var
  node: TChildNode;
  headerNode: THeaderNode;
  assertionNode: TAssertionNode;
  assertion: string;
begin
  Result:=TList<string>.Create;
  checkSection(aSection);
  for headerNode in fNodes.Headers do
    if headerNode.SectionType=aSection then
    begin
      for node in headerNode.ChildNodes do
      begin
        if node.AssertionList.Count=0 then
          Result.add(node.Value)
        else
        begin
          for assertionNode in node.AssertionList do
          begin
            assertion:=node.Key+'.'+assertionNode.Value;
            Result.Add(assertion);
          end;
        end;
      end;
      Exit;
    end;
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
  checkSection(aSection);
  for headerNode in fNodes.Headers do
    if headerNode.SectionType=aSection then
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
