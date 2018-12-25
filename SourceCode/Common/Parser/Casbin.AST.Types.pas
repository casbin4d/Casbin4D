unit Casbin.AST.Types;

interface

uses
  Casbin.Model.Sections.Types, Casbin.Lexer.Tokens.Types,
  Casbin.Core.Base.Types, Casbin.Core.Logger.Types,
  System.Generics.Collections, Casbin.Parser.Messages, System.Rtti;

type
  TAssociationType = (naUnary, naBinary);
  TNodeType = (ntHead,
               ntHeader, // request_definition
               ntIdentifier, // r (=)
               ntObject, // sub  obj  act
               ntProperty, // sub.obj
               ntKeyword,  // some where eft allow, etc.
               ntOperator, // == && etc.
               ntRoleFunction, // g(....
               ntFunction,  // keyMatch etc
               ntEffect // allow deny etc
               );

  TBaseNode = class;
  THeadNode = class;
  THeaderNode = class;
  TStatementNode = class;
  TIdentifierNode = class;
  TExpressionNode = class;

  TOperatorNode = class;
  TObjectNode = class;
  TFunctionNode = class;

  TBaseNode = class
  private
    fValue: string;
  public
    property Value: string read fValue write fValue;
  end;

  THeadNode = class (TBaseNode)
  private
    fChildNodes: TObjectList<THeaderNode>;
  public
    constructor Create;
    destructor Destroy; override;
    property ChildNodes: TObjectList<THeaderNode> read fChildNodes write
        fChildNodes;
  end;

  THeaderNode = class (THeadNode)
  private
    fSectionType: TSectionType;
  public
    property SectionType: TSectionType read fSectionType write fSectionType;
  end;

  TStatementNode = class (TBaseNode)
  private
    fExpression: TExpressionNode;
    fIdentifier: TIdentifierNode;
  public
    property Expression: TExpressionNode read fExpression write fExpression;
    property Identifier: TIdentifierNode read fIdentifier write fIdentifier;
  end;

  TIdentifierNode = class (TBaseNode)

  end;

  TExpressionNode = class (TBaseNode)

  end;

  TOperatorNode = class (TExpressionNode)
  private
    fAssociation: TAssociationType;
    fLeft: TExpressionNode;
    fOperator: TTokenType;
    fRight: TExpressionNode;
  public
    property Association: TAssociationType read fAssociation write fAssociation;
    property &Operator: TTokenType read fOperator write fOperator;
    property Left: TExpressionNode read fLeft write fLeft;
    property Right: TExpressionNode read fRight write fRight;
  end;

  TObjectNode = class (TExpressionNode)
  private
    fChildObject: TObjectNode;
  public
    property ChildObject: TObjectNode read fChildObject write fChildObject;
  end;

  TArgumentsArray = array of TValue;
  TFunctionNode = class (TExpressionNode)
  private
    fArguments: TArgumentsArray;
  public
    property Arguments: TArgumentsArray read fArguments write fArguments;
  end;

  IAST = interface (IBaseInterface)
    ['{2A7FA78F-0139-4784-B053-E42761146A93}']
    procedure createAST;
    function toOutputString: string;

    function getLogger: ILogger;
    function getMessages: TObjectList<TParserMessage>;
    procedure setLogger(const aValue: ILogger);
    procedure setSections(const aValue: TObjectList<TSection>);

    property Logger: ILogger read getLogger write setLogger;
    property Messages: TObjectList<TParserMessage> read getMessages;
    property Sections: TObjectList<TSection> write setSections;
  end;

implementation

{ THeadNode }

constructor THeadNode.Create;
begin
  inherited;
  fChildNodes:=TObjectList<THeaderNode>.Create;
end;

destructor THeadNode.Destroy;
begin
  fChildNodes.Free;
  inherited;
end;

end.
