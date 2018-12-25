unit Casbin.AST.Types;

interface

uses
  Casbin.Model.Sections.Types, Casbin.Lexer.Tokens.Types,
  Casbin.Core.Base.Types, Casbin.Core.Logger.Types,
  System.Generics.Collections, Casbin.Parser.Messages, System.Rtti;

type
  TAssociationType = (naUnary, naBinary);
//
//@
//not
// first (highest)
//
//*
///
//div
//mod
//and
//shl
//shr
//as
// second
//
//+
//-
//or
//xor
// third
//
//=
//<>
//<
//>
//<=
//>=
//in
//is
// fourth (lowest)
//
//
//
//const
//  nodeTypes: array [Low(TTokenType)..High(TTokenType)] of TNodeRec =
//    ((TokenType: ttIdentifier; Priority: 1; Association: naUnary),
//     (TokenType: ttComment; Priority: 1; Association: naUnary),
//     (TokenType: ttLSquareBracket; Priority: 1; Association: naUnary)
//     (TokenType: ttRSquareBracket; Priority: 1; Association: naUnary)
//     (TokenType: ttAssignment; Priority: 1; Association: naUnary)
//     (TokenType: ttComma; Priority: 1; Association: naUnary)
//     (TokenType: ttLParenthesis; Priority: 1; Association: naUnary)
//     (TokenType: ttRParenthesis; Priority: 1; Association: naUnary)
//     (TokenType: ttUnderscore; Priority: 1; Association: naUnary)
//     (TokenType: ttDot; Priority: 1; Association: naUnary)
//     (TokenType: ttColon; Priority: 1; Association: naUnary)
//     (TokenType: ttEquality; Priority: 1; Association: naUnary)
//     (TokenType: ttDoubleSlash; Priority: 1; Association: naUnary)
//     (TokenType: ttBackslash; Priority: 1; Association: naUnary)
//     (TokenType: ttAND; Priority: 1; Association: naUnary)
//     (TokenType: ttOR; Priority: 1; Association: naUnary)
//     (TokenType: ttNOT; Priority: 1; Association: naUnary)
//     (TokenType: ttAdd; Priority: 1; Association: naUnary)
//     (TokenType: ttMinus; Priority: 1; Association: naUnary)
//     (TokenType: ttMultiply; Priority: 1; Association: naUnary)
//     (TokenType: ttDivide; Priority: 1; Association: naUnary)
//     (TokenType: ttModulo; Priority: 1; Association: naUnary)
//     (TokenType: ttGreaterThan; Priority: 1; Association: naUnary)
//     (TokenType: ttGreaterEqualThan; Priority: 1; Association: naUnary)
//     (TokenType: ttLowerThan; Priority: 1; Association: naUnary)
//     (TokenType: ttLowerEqualThan; Priority: 1; Association: naUnary)                ,
//     (TokenType: ttAllow; Priority: 1; Association: naUnary)
//     (TokenType: ttDeny; Priority: 1; Association: naUnary)                ,
//     (TokenType: ttIndeterminate; Priority: 1; Association: naUnary)
//     (TokenType: ttSome; Priority: 1; Association: naUnary)                ,
//     (TokenType: ttAny; Priority: 1; Association: naUnary)
//     (TokenType: ttWhere; Priority: 1; Association: naUnary)
//     (TokenType: ttEft; Priority: 1; Association: naUnary)
//     (TokenType: ttPriority; Priority: 1; Association: naUnary)
//
//
//
//
//
//

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
