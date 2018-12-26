unit Tests.Parser.AST;

interface
uses
  DUnitX.TestFramework, Casbin.Parser.AST.Types;

type

  [TestFixture]
  TTestParserAST = class(TObject)
  private
    fExpressionNode: TExpressionNode;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure testAST;
    // Test with TestCase Attribute to supply parameters.
    [IgnoreAttribute]
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

uses
  Casbin.Parser.AST;

procedure TTestParserAST.Setup;
begin
end;

procedure TTestParserAST.TearDown;
begin
end;

procedure TTestParserAST.testAST;
var
  header: THeaderNode;
  output: string;
begin
  header:=THeaderNode.Create;
  header.ChildNodes.Add(addAssertion('r=sub,obj,act'));
  output:=header.toOutputString;
  header.Free;
end;

procedure TTestParserAST.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TTestParserAST);
end.
