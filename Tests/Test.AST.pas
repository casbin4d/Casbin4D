unit Test.AST;

interface
uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestAST = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase ('Request','[request_definition],request_definition')]
    [TestCase ('Request','[policy_definition],policy_definition')]
    [TestCase ('Request','[policy_effect],policy_effect')]
    [TestCase ('Request','[matchers],matchers')]
    [TestCase ('Request','[role_definition],role_definition')]
    [TestCase ('Request','[mysql],mysql')]
    procedure testSections(const aSection, aExpected: string);
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

uses
  Casbin.Lexer.Tokeniser.Types, Casbin.Lexer.Tokeniser, Casbin.AST.Types, Casbin.AST, Casbin.Parser.Types, Casbin.Parser;

procedure TTestAST.Setup;
begin
end;

procedure TTestAST.TearDown;
begin
end;

procedure TTestAST.testSections(const aSection, aExpected: string);
var
  lexer: ITokeniser;
  parser: IParser;
  ast: IAST;
begin
  lexer:=TTokeniser.Create(aSection);
  lexer.tokenise;
  if lexer.Status=tsFinished then
  begin
    parser:=TParser.Create(lexer.TokenList);
    parser.parse;
    if parser.Status=psFinished then
    begin
      ast:=TAST.Create(lexer.TokenList);
      ast.createAST;
      Assert.AreEqual(aExpected, ast.toOutputString);
    end;
  end;
end;

procedure TTestAST.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TTestAST);
end.
