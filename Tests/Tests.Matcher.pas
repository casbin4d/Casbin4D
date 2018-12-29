unit Tests.Matcher;

interface
uses
  DUnitX.TestFramework, Casbin.Matcher.Types, Casbin.Effect.Types;

type

  [TestFixture]
  TTestMatcher = class(TObject)
  private
    fMatcher: IMatcher;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('Common-Go','john==john && kour==kour && m==m#erAllow', '#')]
    [TestCase('Common-Delphi','john==john and kour=kour and m=m#erAllow', '#')]
    [TestCase('Remove apostrophe','john==john and ''kour''=''kour'' and m=m#erAllow', '#')]
    procedure testMatcher(const aExpression: string; const aExpected:
        TEffectResult);
  end;

implementation

uses
  Casbin.Matcher;

procedure TTestMatcher.Setup;
begin
  fMatcher:=TMatcher.Create;
end;

procedure TTestMatcher.TearDown;
begin
end;

procedure TTestMatcher.testMatcher(const aExpression: string; const aExpected:
    TEffectResult);
begin
  Assert.AreEqual(aExpected, fMatcher.evaluateMatcher(aExpression));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestMatcher);
end.
