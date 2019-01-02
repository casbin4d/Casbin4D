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
    [TestCase('Common-Go.1','john==john && kour==kour && m==m#erAllow', '#')]
    [TestCase('Common-Go.2','john==alice && kour==kour && m==m#erDeny', '#')]
    [TestCase('Common-Delphi.1','john==john and kour=kour and m=m#erAllow', '#')]
    [TestCase('Common-Delphi.2','kour=kour or !(root=root)#erAllow', '#')]
    [TestCase('Remove apostrophe','john==john and ''kour''=''kour'' and m=m#erAllow', '#')]
    [TestCase('Expression With Spaces','john ==john   and ''kour''= ''kour'' and m=m#erAllow', '#')]
    [TestCase('1 part.1-Allow','john==john#erAllow', '#')]
    [TestCase('1 part.2-Deny','john==alice#erDeny', '#')]
    [TestCase('2 parts.1-Deny','alice==kour and john=john#erDeny', '#')]
    procedure testMatcher(const aExpression: string; const aExpected:
        TEffectResult);
  end;

implementation

uses
  Casbin.Matcher;

procedure TTestMatcher.Setup;
begin
  fMatcher:=TMatcher.Create;
  fMatcher.addIdentifier('john');
  fMatcher.addIdentifier('alice');
  fMatcher.addIdentifier('kour');
  fMatcher.addIdentifier('mu');
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
