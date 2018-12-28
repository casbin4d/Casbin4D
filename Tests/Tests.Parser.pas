unit Tests.Parser;

interface
uses
  DUnitX.TestFramework, Casbin.Parser.Types, Casbin.Core.Defaults;

type

  [TestFixture]
  TTestParser = class(TObject)
  private
    fParser: IParser;
    procedure checkParserError;
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
    [TestCase('Header 1', '[default],default')]
    procedure testHeaderAssignment(const aInput, aExpected: string);

    [Test]
    [TestCase('Matchers respect spaces',
                '[matchers]'+sLineBreak+
                'm = r.sub == p.sub'+sLineBreak+
                '[request_definition]'+sLineBreak+
                '[policy_definition]'+sLineBreak+
                '[policy_effect]'+'#'+

                'm = r.sub == p.sub',
                '#')]
    procedure testMatchersSection(const aInput, aExpected: string);

    //We use Policy parser for this test
    [Test]
    [TestCase('Header 1', 'p,sub, obj, act#p.sub','#')]
    procedure testStatementOutputString(const aInput, aExpected: string);

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

    //We use Policy parser for this test
    [Test]
    [TestCase('Header Only', '[default],[default]')]
    [TestCase('Header With Statement', '[default]'+sLineBreak+'p,sub,obj,act'+
                              '#[default]'+sLineBreak+'p,sub,obj,act','#')]
    [TestCase('Header With Multiple Statement and Sections',
        '[default]'+sLineBreak+'p,sub,obj,act'+sLineBreak+
        '[default]'+sLineBreak+'p,alice,files,delete'+sLineBreak+
                               'p,alice,files,read'+sLineBreak+
        '#[default]'+sLineBreak+'p,sub,obj,act'+sLineBreak+sLineBreak+
        '[default]'+sLineBreak+'p,alice,files,delete'+sLineBreak+
                               'p,alice,files,read'
        ,'#')]
    procedure testHeaderOutputString(const aInput, aExpected: String);

  end;

implementation

uses
  Casbin.Parser, System.SysUtils, Casbin.Parser.AST.Types, System.Generics.Collections;

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

procedure TTestParser.testMatchersSection(const aInput, aExpected: string);
begin
  fParser:=TParser.Create(aInput, ptModel);
  fParser.parse;
  Assert.AreEqual(4, fParser.Nodes.Headers.Count,
                                      'Header count: '+fParser.ErrorMessage);
  Assert.AreEqual(1, fParser.Nodes.Headers.Items[0].ChildNodes.Count,
                                          'Child count'+fParser.ErrorMessage);
  Assert.AreEqual(aExpected,
    fParser.Nodes.Headers.Items[0].ChildNodes.Items[0].toOutputString,
                                        'Assertion'+fParser.ErrorMessage);
end;

procedure TTestParser.testStatementOutputString(const aInput, aExpected:
    string);
begin
  fParser:=TParser.Create(aInput, ptPolicy);
  fParser.parse;
  checkParserError;
  Assert.IsTrue(fParser.Nodes.Headers.Count = 1, 'Header count');

  Assert.IsTrue(fParser.Nodes.Headers.Items[0].ChildNodes.Count = 1,
                                                              'Child count');
  Assert.AreEqual(aExpected,
            fParser.Nodes.Headers.Items[0].ChildNodes.Items[0].
                  AssertionList.Items[0].toOutputString,
                                      'Output String');
  fParser:=nil;
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

procedure TTestParser.testHeaderAssignment(const aInput, aExpected: string);
begin
  fParser:=TParser.Create(aInput, ptPolicy);
  fParser.parse;
  checkParserError;
  Assert.IsTrue(fParser.Nodes.Headers.Count = 1);
  Assert.AreEqual(aExpected, fParser.Nodes.Headers.Items[0].Value);
  fParser:=nil;
end;

procedure TTestParser.testHeaderOutputString(const aInput, aExpected: String);
begin
  fParser:=TParser.Create(aInput, ptPolicy);
  fParser.parse;
  checkParserError;
  Assert.AreEqual(trim(aExpected), Trim(fParser.Nodes.toOutputString));
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
