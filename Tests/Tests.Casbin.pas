unit Tests.Casbin;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TTestCasbin = class(TObject)
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure testFileConstructor;
    [Test]
    procedure testAdapterConstructor;
  end;

implementation

uses
  Casbin.Model.Types, Casbin.Policy.Types, Casbin.Model, Casbin.Policy;

procedure TTestCasbin.Setup;
begin
end;

procedure TTestCasbin.TearDown;
begin
end;


procedure TTestCasbin.testAdapterConstructor;
var
  model: IModel;
  policy: IPolicyManager;
begin
  model:=TModel.Create('');
  policy:=TPolicyManager.Create('');
end;

procedure TTestCasbin.testFileConstructor;
begin

end;

initialization
  TDUnitX.RegisterTestFixture(TTestCasbin);
end.
