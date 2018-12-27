unit Tests.Effect;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestEffect = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure testSomeAllow;
    [Test]
    procedure testNotSomeDeny;
    [Test]
    procedure testSomeAllowANDNotDeny;
    [Test]
    procedure testPriorityORDeny;
    [Test]
    procedure testUnknown;
    [Test]
    procedure testEmptyEffects;
  end;

implementation

uses
  Casbin.Effect.Types, Casbin.Effect;

procedure TTestEffect.Setup;
begin
end;

procedure TTestEffect.TearDown;
begin
end;

procedure TTestEffect.testEmptyEffects;
begin
  Assert.AreEqual(true, mergeEffects(ecNotSomeDeny, []));
end;

procedure TTestEffect.testNotSomeDeny;
var
  effects: TEffectArray;
begin
  SetLength(effects, 3);

  //Not Some Deny
  effects[0]:=erAllow;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(True, mergeEffects(ecNotSomeDeny, effects), '1');

  effects[0]:=erDeny;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(False, mergeEffects(ecNotSomeDeny, effects), '2');

end;

procedure TTestEffect.testPriorityORDeny;
var
  effects: TEffectArray;
begin
  SetLength(effects, 3);

  effects[0]:=erAllow;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(true, mergeEffects(ecPriorityORDeny, effects), '1');

  effects[0]:=erIndeterminate;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(True, mergeEffects(ecPriorityORDeny, effects), '2');

  effects[0]:=erIndeterminate;
  effects[1]:=erAllow;
  effects[2]:=erDeny;
  Assert.AreEqual(True, mergeEffects(ecPriorityORDeny, effects), '3');

  effects[0]:=erIndeterminate;
  effects[1]:=erDeny;
  effects[2]:=erAllow;
  Assert.AreEqual(False, mergeEffects(ecPriorityORDeny, effects), '4');
end;

procedure TTestEffect.testSomeAllow;
var
  effects: TEffectArray;
begin
  SetLength(effects, 3);

  effects[0]:=erAllow;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(True, mergeEffects(ecSomeAllow, effects), '1');

  effects[0]:=erDeny;
  effects[1]:=erDeny;
  effects[2]:=erDeny;
  Assert.AreEqual(False, mergeEffects(ecSomeAllow, effects), '2');

  effects[0]:=erAllow;
  effects[1]:=erDeny;
  effects[2]:=erDeny;
  Assert.AreEqual(True, mergeEffects(ecSomeAllow, effects), '3');

  effects[0]:=erIndeterminate;
  effects[1]:=erDeny;
  effects[2]:=erDeny;
  Assert.AreEqual(false, mergeEffects(ecSomeAllow, effects), '4');

  end;

procedure TTestEffect.testSomeAllowANDNotDeny;
var
  effects: TEffectArray;
begin
  SetLength(effects, 3);

  effects[0]:=erIndeterminate;
  effects[1]:=erIndeterminate;
  effects[2]:=erIndeterminate;
  Assert.AreEqual(False, mergeEffects(ecSomeAllowANDNotDeny, effects), '1');

  effects[0]:=erAllow;
  effects[1]:=erIndeterminate;
  effects[2]:=erIndeterminate;
  Assert.AreEqual(true, mergeEffects(ecSomeAllowANDNotDeny, effects), '2');

  effects[0]:=erAllow;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(true, mergeEffects(ecSomeAllowANDNotDeny, effects), '3');

  effects[0]:=erDeny;
  effects[1]:=erAllow;
  effects[2]:=erAllow;
  Assert.AreEqual(False, mergeEffects(ecSomeAllowANDNotDeny, effects), '4');

end;

procedure TTestEffect.testUnknown;
begin
  Assert.AreEqual(False, mergeEffects(ecUnknown, []));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestEffect);
end.
