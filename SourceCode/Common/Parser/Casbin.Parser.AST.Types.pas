unit Casbin.Parser.AST.Types;

interface

uses
  Casbin.Model.Sections.Types, System.Generics.Collections,
  Casbin.Parser.AST.Operators.Types;

type
  TBaseNode = class;
  TNodeCollection = class;
  THeaderNode = class;
  TExpressionNode = class;

  TBaseNode = class
  private
    fValue: string;
  public
    function toOutputString: string; virtual; abstract;

    property Value: string read fValue write fValue;
  end;

  TNodeCollection = class
  private
    fHeaders: TObjectList<THeaderNode>;
  public
    constructor Create;
    destructor Destroy; override;
    property Headers: TObjectList<THeaderNode> read fHeaders write fHeaders;
  end;

  THeaderNode = class (TBaseNode)
  private
    fSectionType: TSectionType;
    fStatementNode: TObjectList<TExpressionNode>;
  public
    constructor Create;
    destructor Destroy; override;
    function toOutputString: string; override;

    property SectionType: TSectionType read fSectionType write fSectionType;
    property ChildNodes: TObjectList<TExpressionNode> read fStatementNode
                                                        write fStatementNode;
  end;

  TExpressionNode = class (TBaseNode)
  private
    fIdentifier: string;
    fLeftChild: TExpressionNode;
    fOperator: TOperators;
    fRightChild: TExpressionNode;
  public
    constructor Create(const aOperator: TOperators);
    destructor Destroy; override;
    function toOutputString: string; override;

    property &Operator: TOperators read fOperator;
    property Identifier: string read fIdentifier write fIdentifier;
    property LeftChild: TExpressionNode read fLeftChild write fLeftChild;
    property RightChild: TExpressionNode read fRightChild write fRightChild;
  end;

implementation

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

constructor THeaderNode.Create;
begin
  inherited;
  fStatementNode:=TObjectList<TExpressionNode>.Create;
end;

destructor THeaderNode.Destroy;
begin
  fStatementNode.Free;
  inherited;
end;

function THeaderNode.toOutputString: string;
var
  expNode: TExpressionNode;
begin
  Result:='{HEADER: '+fValue+sLineBreak;
  for expNode in fStatementNode do
    result:=result+expNode.toOutputString+sLineBreak;
  Result:=Result+sLineBreak+'}';
end;

constructor TExpressionNode.Create(const aOperator: TOperators);
begin
  inherited Create;
  fOperator:=aOperator;
end;

destructor TExpressionNode.Destroy;
begin
  fLeftChild.Free;
  fRightChild.Free;
  inherited;
end;

function TExpressionNode.toOutputString: string;
var
  expNode: TExpressionNode;
begin
  Result:='{EXPRESSION: '+fIdentifier+sLineBreak;
  if Assigned(LeftChild) then
    result:=Result+'{LEFT: '+LeftChild.toOutputString+sLineBreak+'}';
  if Assigned(RightChild) then
    result:=Result+'{RIGHT: '+RightChild.toOutputString+sLineBreak+'}';
  Result:=Result+sLineBreak+'}';
end;

end.
