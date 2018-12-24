unit Tests.Logger;

interface

uses
  DUnitX.TestFramework, Casbin.Core.Logger.Types;

type
  [TestFixture]
  TTestLogger = class(TObject)
  private
    fLogger: ILogger;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure testEnabled;

    [Test]
    procedure testLogWhenEnabled;

    [Test]
    procedure testLogWhenDisabled;
  end;

implementation

uses
  Casbin.Core.Logger.Default;

procedure TTestLogger.Setup;
begin
  fLogger:=TDefaultLogger.Create;
end;

procedure TTestLogger.TearDown;
begin
  fLogger:=nil;
end;

procedure TTestLogger.testEnabled;
begin
  Assert.IsTrue(fLogger.Enabled);
  fLogger.Enabled:=False;
  Assert.IsFalse(fLogger.Enabled);
  fLogger.Enabled:=True;
  Assert.IsTrue(fLogger.Enabled);
end;

procedure TTestLogger.testLogWhenDisabled;
begin
  fLogger.Enabled:=False;
  fLogger.log('Disabled');
  Assert.IsTrue(fLogger.LastLoggedMessage='');
end;

procedure TTestLogger.testLogWhenEnabled;
begin
  fLogger.Enabled:=True;
  fLogger.log('Test');
  Assert.AreEqual('Test', fLogger.LastLoggedMessage);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestLogger);
end.
