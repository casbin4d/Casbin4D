unit Test.Tokeniser;

interface
uses
  DUnitX.TestFramework, Lexer.Tokeniser.Types;

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
    procedure testTokeniser;

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

type
  TTokenTest = record
    Name: string;
    Pass: string;
    Expected: string;
    NumTokens: Integer;
  end;

const
  numOfTests = 3;
  // The positions of the strings are for NON-ARC compilers (eg.Win32, Win64, etc.)
  tokenTestsArray: array [0..numOfTests - 1] of TTokenTest =
    ( (Name: 'Simple Identifier'; Pass: '[123]';
        Expected: '{Token: LSquareBracket; Value: [; (1,0) --> (1,0)}'+sLineBreak+
                  '{Token: Identifier; Value: 123; (2,0) --> (4,0)}'+sLineBreak+
                  '{Token: RSquareBracket; Value: ]; (5,0) --> (5,0)}';
                          NumTokens: 3),

      (Name: 'Simple Identifier with Spaces'; Pass: '[1 23 ]';
        Expected: '{Token: LSquareBracket; Value: [; (1,0) --> (1,0)}'+sLineBreak+
                  '{Token: Identifier; Value: 123; (2,0) --> (5,0)}'+sLineBreak+
                  '{Token: RSquareBracket; Value: ]; (7,0) --> (7,0)}';
                          NumTokens: 3),

      (Name: 'Section Header'; Pass: '[request_definition]';
        Expected: '{Token: LSquareBracket; Value: [; (0,0) --> (0,0)}'+sLineBreak+
                  '{Token: Identifier; Value: request; (1,0) --> (7,0)}'+sLineBreak+
                  '{Token: Underscore; Value: _; (8,0) --> (9,0)}'+sLineBreak+
                  '{Token: Identifier; Value: definition; (9,0) --> (19,0)}'+sLineBreak+
                  '{Token: RSquareBracket; Value: ]; (20,0) --> (21,0)}';
                          NumTokens: 5));

procedure TTestTokeniser.testTokeniser;
var
  fTokeniser: ITokeniser;
  tokenTest: TTokenTest;
  i: Integer;
begin
  for i:=0 to Length(tokenTestsArray)-1 do
  begin
    tokenTest:=tokenTestsArray[i];
    fTokeniser:=TTokeniser.Create(tokenTest.Pass);
    fTokeniser.tokenise;
    Assert.AreEqual(tokenTest.NumTokens, fTokeniser.TokenList.Count,
                                                        tokenTest.Name+' Nums');
    Assert.AreEqual(tokenTest.Expected, fTokeniser.TokenList.toOutputString,
                                                        tokenTest.Name);
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestTokeniser);
end.
