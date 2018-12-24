unit Test.Parser;

interface
uses
  DUnitX.TestFramework, Parser.Types, Lexer.Tokens.List, Lexer.Tokeniser.Types;

const
  testSeparator = '#';

type
  [TestFixture]
  TTestParser = class(TObject)
  private
    fParser: IParser;
    fLexer: ITokeniser;
    procedure runParser (const aTokenList: TTokenList);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure testDefaultProperties;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('Simple Statement','r = sub, obj, act'+testSeparator+
                                 'r=sub,obj,act', testSeparator)]
    [TestCase('Keep spaces after Assignment',
                '¦r = sub, obj, act'+testSeparator+
                                 'r= sub, obj, act', testSeparator)]
    [TestCase('Remove spaces after Assignment',
                'r = sub, obj, act'+testSeparator+
                                 'r=sub,obj,act', testSeparator)]
//    [TestCase('Double L Square','[[request_definition]'+testSeparator+
//                                '[request_definition]', testSeparator)]
//    [TestCase('Double L Square random',
//                  '[requ[est_definition]'+testSeparator+
//                  '[request_definition]', testSeparator)]
    procedure testRemoveWhitespace(const aInputString, expectedValue: string);
  end;

implementation

uses
  Parser, Lexer.Tokeniser, System.StrUtils;

procedure TTestParser.runParser(const aTokenList: TTokenList);
begin
  fParser:=nil;
  fParser:=TParser.Create(aTokenList);
  fParser.parse;
end;

procedure TTestParser.Setup;
begin
end;

procedure TTestParser.TearDown;
begin
end;

procedure TTestParser.testDefaultProperties;
var
  list: TTokenList;
begin
  list:=TTokenList.Create;
  fParser:=TParser.Create(list);
  Assert.IsNotNull(fParser.Logger);
  Assert.IsNotNull(fParser.Config);
  Assert.IsNotNull(fParser.Messages);
  Assert.IsNotNull(fParser.Sections);
  Assert.AreEqual(psNotStarted, fParser.Status);
  list.Free;
end;

procedure TTestParser.testRemoveWhitespace(const aInputString, expectedValue:
    string);
var
  inString: string;
begin
  if aInputString[Low(string)] ='¦' then
    inString:=RightStr(aInputString, Length(aInputString)-1)
  else
    inString:=aInputString;

  fLexer:=nil;
  fLexer:=TTokeniser.Create(inString);
  fLexer.tokenise;

  fParser:=nil;
  fParser:=TParser.Create(fLexer.TokenList);

  if Length(aInputString) > 0 then
    fParser.Config.RespectSpacesInValues:=(aInputString[Low(string)] ='¦');

  fParser.parse;

  Assert.IsTrue(fParser.Status = psFinished, 'Status');

  Assert.AreEqual(expectedValue, fParser.toOutputString);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestParser);
end.
