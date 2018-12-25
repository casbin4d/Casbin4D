unit Casbin.AST.Types;

interface

uses
  Casbin.Model.Sections.Types, Casbin.Lexer.Tokens.Types, Casbin.Core.Base.Types, Casbin.Core.Logger.Types, System.Generics.Collections,
  Casbin.Parser.Messages;

type
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

  TBaseNodeClass = class of TBaseNode;
  TBaseNode = class
  private
    fNodeType: TNodeType;
    fValue: string;
  public
    property NodeType: TNodeType read fNodeType write fNodeType;
    property Value: string read fValue write fValue;
  end;

  THeadNode = class (TBaseNode)

  end;

  THeaderNode = class (TBaseNode)
  private
    fSectionType: TSectionType;
  public
    property SectionType: TSectionType read fSectionType write fSectionType;
  end;

  TElementNode = class (TBaseNode)
  private
    fType: TTokenType;
  public
    property &Type: TTokenType read fType write fType;
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

end.
