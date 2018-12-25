unit Test.Parser;

interface
uses
  DUnitX.TestFramework, Casbin.Parser.Types, Casbin.Lexer.Tokens.List,
  Casbin.Lexer.Tokeniser.Types;

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
    ///Use ¦ to enable Respect Spaces in Config
    [TestCase('Keep spaces after Assignment',
                '¦r = sub, obj, act'+testSeparator+
                                 'r= sub, obj, act', testSeparator)]
    [TestCase('Remove spaces after Assignment',
                'r = sub, obj, act'+testSeparator+
                                 'r=sub,obj,act', testSeparator)]
    [TestCase('Remove multi-line ',
                'r = sub, obj, \'+sLineBreak+' act'+testSeparator+
                                 'r=sub,obj,act', testSeparator)]
    [TestCase('Remove double multi-line ',
                'r = sub, obj, \\'+sLineBreak+' act'+testSeparator+
                                 'r=sub,obj,act', testSeparator)]
    [TestCase('Remove multiple multi-line ',
                'r = \'+sLineBreak+' \'+sLineBreak+'\'+testSeparator+
                                 'r=', testSeparator)]
    procedure testRemoveWhitespace(const aInputString, expectedValue: string);

    [Test]
    [TestCase('Double L Square','[[request_definition]')]
    [TestCase('Double L Square random', '[requ[est_definition]')]
    [TestCase('Multiple R Square random', '[requ]est_definition]')]
    [TestCase('Assignment without identifier', '=sub, obj, act')]
    procedure testSyntaxErrors(const aInputString: string);

    [Test]
    [TestCase ('Underscore in []', '[request_definition],'+
                                   '[request_definition]')]
    procedure testSpecialTreatement(const aInputString, expectedValue: string);
  end;

implementation

uses
  Casbin.Parser, Casbin.Lexer.Tokeniser, System.StrUtils;

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

procedure TTestParser.testSpecialTreatement(const aInputString, expectedValue:
    string);
var
  list: TTokenList;
begin
  fLexer:=nil;
  fLexer:=TTokeniser.Create(aInputString);
  fLexer.tokenise;
  runParser(fLexer.TokenList);

  Assert.AreEqual(expectedValue, fParser.toOutputString);
end;

procedure TTestParser.testSyntaxErrors(const aInputString: string);
var
  list: TTokenList;
begin
  fLexer:=nil;
  fLexer:=TTokeniser.Create(aInputString);
  fLexer.tokenise;
  runParser(fLexer.TokenList);

  Assert.AreEqual(psError, fParser.Status);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestParser);
end.
