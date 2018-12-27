unit Casbin.Parser.AST.Types;

interface

uses
  Casbin.Model.Sections.Types, System.Generics.Collections, Casbin.Effect.Types;

type
  TBaseNode = class;
  TNodeCollection = class;
  THeaderNode = class;
  TChildNode = class;
  TAssertionNode = class;

  TBaseNode = class
  private
    fKey: string;
    fValue: string;
  public
    function toOutputString: string; virtual;

    property Key: string read fKey write fKey;
    property Value: string read fValue write fValue;
  end;

  TNodeCollection = class
  private
    fHeaders: TObjectList<THeaderNode>;
  public
    constructor Create;
    destructor Destroy; override;
    function toOutputString: string; virtual;

    property Headers: TObjectList<THeaderNode> read fHeaders write fHeaders;
  end;

  THeaderNode = class (TBaseNode)
  private
    fSectionType: TSectionType;
    fStatementNode: TObjectList<TChildNode>;
  public
    constructor Create;
    destructor Destroy; override;
    function toOutputString: string; override;

    property SectionType: TSectionType read fSectionType write fSectionType;
    property ChildNodes: TObjectList<TChildNode> read fStatementNode
                                                        write fStatementNode;
  end;

  TChildNode = class (TBaseNode)
  private
    fAssertionList: TObjectList<TAssertionNode>;
  public
    constructor Create;
    destructor Destroy; override;
    function toOutputString: string; override;

    property AssertionList: TObjectList<TAssertionNode> read fAssertionList write
        fAssertionList;
  end;

  TAssertionNode = class (TChildNode)
  public
    function toOutputString: string; override;
  end;

  TEffectNode = class (TChildNode)
  private
    fEffectCondition: TEffectCondition;
  public
    property EffectCondition: TEffectCondition read fEffectCondition write
        fEffectCondition;
  end;

implementation

uses
  System.SysUtils;

constructor TNodeCollection.Create;
begin
  inherited;
  fHeaders:=TObjectList<THeaderNode>.Create;
end;

destructor TNodeCollection.Destroy;
begin
  fHeaders.Free;
  inherited;
end;

function TNodeCollection.toOutputString: string;
var
  header: THeaderNode;
begin
  for header in fHeaders do
    Result:=Result+header.toOutputString+sLineBreak;
end;

constructor THeaderNode.Create;
begin
  inherited;
  fStatementNode:=TObjectList<TChildNode>.Create;
end;

destructor THeaderNode.Destroy;
begin
  fStatementNode.Free;
  inherited;
end;

function THeaderNode.toOutputString: string;
var
  i: Integer;
  sep: string;
begin
  if fSectionType=stPolicyRules then
    sep:=','
  else
    sep:='=';
  Result:='['+Value+']'+sLineBreak;
  for i:=0 to fStatementNode.Count-1 do
  begin
    if i=0 then
//      result:=Result+fStatementNode.Items[i].Key+sep+
//        fStatementNode.Items[0].Value else
//      result:=result+','+fStatementNode.Items[i].Value;
      Result:=Result+fStatementNode.Items[i].toOutputString+sLineBreak;
  end;
end;

{ TBaseNode }

function TBaseNode.toOutputString: string;
begin
  Result:=fValue;
end;

constructor TChildNode.Create;
begin
  inherited;
  fAssertionList:=TObjectList<TAssertionNode>.Create;
end;

destructor TChildNode.Destroy;
begin
  fAssertionList.Free;
  inherited;
end;

{ TChildNode }

function TChildNode.toOutputString: string;
begin
  Result:=fKey+'='+fValue;
end;

{ TAssertionNode }

function TAssertionNode.toOutputString: string;
begin
  Result:=fKey+'.'+fValue;
end;

end.
