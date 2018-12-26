unit Tests.Parser;

interface
uses
  DUnitX.TestFramework, Casbin.Parser.Types, Casbin.Core.Defaults;

type

  [TestFixture]
  TTestParser = class(TObject)
  private
    fParser: IParser;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure testLogger;
    [Test]
    [TestCase('Simple Header', '[default],default')]
    [TestCase('EOL in heading', '[def \\'+EOL+'ault],default')]
    [TestCase('Tab','[def'+#9+'ault],default')]
    procedure testHeadersInPolicy(const aInput, aExpected: String);

    [Test]
    [TestCase('Space before assignment', 'na me = 123'+'#'+'default','#')]
    procedure testHeadersInConfig(const aInput, aExpected: String);

    [Test]
    [TestCase('Double [ in header', '[req[]')]
    [TestCase('Missed [ in header', 'req]')]
    [TestCase('Missing section', '[request_definition]'+EOL+
                                 'r=sub, obj, act'+EOL+
                                 '[policy_definition]')]
    procedure testErrors(const aInput: String);

    [Test]
    //This should be for Policy or Config file only
    [TestCase('Missing Header', 'r = sub, obj, act'+sLineBreak+'p=sub'+
                        '#'+'default','#')]
    [TestCase('Start with EOL', sLineBreak+'r = sub, obj, act#default','#')]
    [TestCase('Start with multiple EOL',
             sLineBreak+sLineBreak+sLineBreak+'r = sub, obj, act#default','#')]
    procedure testFix(const aInput: String; const aExpected: String);

  end;

implementation

uses
  Casbin.Parser, System.SysUtils, Casbin.Parser.AST.Types;

procedure TTestParser.checkParserError;
begin
  Assert.IsFalse(fParser.Status = psError,'Parsing Error: '+fParser.ErrorMessage);
end;

procedure TTestParser.Setup;
begin
end;

procedure TTestParser.TearDown;
begin
end;

procedure TTestParser.testLogger;
begin
  fParser:=TParser.Create('', ptModel);
  Assert.IsNotNull(fParser.Logger);
end;

procedure TTestParser.testErrors(const aInput: String);
begin
  fParser:=TParser.Create(aInput, ptModel);
  fParser.parse;
  Assert.AreEqual(psError, fParser.Status);
  fParser:=nil;
end;

procedure TTestParser.testFix(const aInput: String; const aExpected: String);
begin
  fParser:=TParser.Create(aInput, ptPolicy);
  fParser.parse;
  Assert.IsTrue(fParser.Nodes.Headers.Count >= 1);
  Assert.AreEqual(aExpected, fParser.Nodes.Headers.Items[0].Value);
  fParser:=nil;
end;

procedure TTestParser.testHeadersInConfig(const aInput, aExpected: String);
begin
  fParser:=TParser.Create(aInput, ptConfig);
  fParser.parse;
  Assert.IsTrue(fParser.Nodes.Headers.Count = 1);
  Assert.AreEqual(aExpected, fParser.Nodes.Headers.Items[0].Value);
  fParser:=nil;
end;

procedure TTestParser.testHeadersInPolicy(const aInput, aExpected: String);
begin
  fParser:=TParser.Create(aInput, ptPolicy);
  fParser.parse;
  Assert.IsTrue(fParser.Nodes.Headers.Count = 1);
  Assert.AreEqual(aExpected, fParser.Nodes.Headers.Items[0].Value);
  fParser:=nil;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestParser);
end.
