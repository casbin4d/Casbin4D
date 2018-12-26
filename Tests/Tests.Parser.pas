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
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('Simple Header', '[request],request')]
    [TestCase('Underscore in heading', '[req_def],req_def')]
    [TestCase('EOL in heading', '[req_ \\'+EOL+'def],req_def')]
    [TestCase('Tab','[req'+#9+'uest],request')]
    procedure testHeadersInModel(const aInput, aExpected: String);

    [Test]
    [TestCase('Space before assignment', 'na me = 123, name=123')]
    procedure testHeadersInConfig(const aInput, aExpected: String);

    [Test]
    [TestCase('Double [ in header', '[req[]')]
    [TestCase('Missed [ in header', 'req]')]
    [TestCase('Missing section', '[request_definition]'+EOL+
                                 'r=sub, obj, act'+EOL+
                                 '[policy_definition]')]
    procedure testErrors(const aInput: String);

    [Test]
    [TestCase('Missing Header', 'r = sub, obj, act'+sLineBreak+'p=sub'+
                        '#'+'[default]'+sLineBreak+'r = sub, obj, act'+
                            sLineBreak+'p=sub','#')]
    procedure testFix(const aInput: String; const aExpected: String);

  end;

implementation

uses
  Casbin.Parser;

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
  fParser:=TParser.Create(aInput, ptModel);
  fParser.parse;
  Assert.IsTrue(fParser.Nodes.Headers.Count > 1);
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

procedure TTestParser.testHeadersInModel(const aInput, aExpected: String);
begin
  fParser:=TParser.Create(aInput, ptModel);
  fParser.parse;
  Assert.IsTrue(fParser.Nodes.Headers.Count = 1);
  Assert.AreEqual(aExpected, fParser.Nodes.Headers.Items[0].Value);
  fParser:=nil;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestParser);
end.
