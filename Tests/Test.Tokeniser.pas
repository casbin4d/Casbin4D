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
    [TestCase (tokenTestName1, tokenTest1, '#')]
    [TestCase (tokenTestName2, tokenTest2, '#')]
    [TestCase (tokenTestName3, tokenTest3, '#')]
    [TestCase (tokenTestName4, tokenTest4, '#')]
    [TestCase (tokenTestName5, tokenTest5, '#')]
    procedure testTokeniser(const aPass, aExpected, aNumTokens: string);
  end;

implementation

uses
  Lexer.Tokeniser, System.SysUtils;


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
begin
  fTokeniser:=TTokeniser.Create(aPass);
  fTokeniser.tokenise;
  Assert.AreEqual(aNumTokens.ToInteger, fTokeniser.TokenList.Count,
                                            'Nums of tokens');
  Assert.AreEqual(aExpected, fTokeniser.TokenList.toOutputString);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestTokeniser);
end.
