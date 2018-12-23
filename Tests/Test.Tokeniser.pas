unit Test.Tokeniser;

interface

uses
  DUnitX.TestFramework, Lexer.Tokeniser.Types,
  Test.Tokeniser.Tokens;

type
  [TestFixture]
  TTestTokeniser = class(TObject)
  private
  public
    [Test]
    procedure testDefaultLogger;
    [Test]
    procedure testEmptyString;
    [Test]
    [TestCase (tokenTestName1, tokenTest1, '£')]
    [TestCase (tokenTestName2, tokenTest2, '£')]
    [TestCase (tokenTestName3, tokenTest3, '£')]
    [TestCase (tokenTestName4, tokenTest4, '£')]
    [TestCase (tokenTestName5, tokenTest5, '£')]
    [TestCase (tokenTestName6, tokenTest6, '£')]
    [TestCase (tokenTestName7, tokenTest7, '£')]
    [TestCase (tokenTestName8, tokenTest8, '£')]
    [TestCase (tokenTestName9, tokenTest9, '£')]
    [TestCase (tokenTestName10, tokenTest10, '£')]
    [TestCase (tokenTestName11, tokenTest11, '£')]
    [TestCase (tokenTestName12, tokenTest12, '£')]
    procedure testTokeniser(const aPass, aExpected, aNumTokens: string);
  end;

implementation

uses
  Lexer.Tokeniser, System.SysUtils, System.Classes;


{ TTestTokeniser }

procedure TTestTokeniser.testDefaultLogger;
var
  fTokeniser: ITokeniser;
begin
  fTokeniser:=TTokeniser.Create('123');
  Assert.IsNotNull(fTokeniser.Logger);
end;

procedure TTestTokeniser.testEmptyString;
var
  fTokeniser: ITokeniser;
begin
  fTokeniser:=TTokeniser.Create('');
  fTokeniser.tokenise;

  Assert.AreEqual(tsFatalError, fTokeniser.Status);
end;

procedure TTestTokeniser.testTokeniser(const aPass, aExpected,
    aNumTokens: string);
var
  fTokeniser: ITokeniser;
  expectedStr: string;
  expectedArray: TArray<string>;
  actualArray: TArray<string>;
  i: integer;
begin
  fTokeniser:=TTokeniser.Create(aPass);
  fTokeniser.tokenise;
  Assert.AreEqual(aNumTokens.ToInteger, fTokeniser.TokenList.Count,
                                            'Nums of tokens');
  expectedArray:=aExpected.Split([sLineBreak]);
  actualArray:=fTokeniser.TokenList.toOutputString.Split([sLineBreak]);
  for i:=0 to Length(expectedArray)-1 do
    Assert.AreEqual(expectedArray[i], actualArray[i]);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestTokeniser);
end.
