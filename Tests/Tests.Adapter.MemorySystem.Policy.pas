unit Tests.Adapter.MemorySystem.Policy;

interface
uses
  DUnitX.TestFramework, Casbin.Adapter.Policy.Types;

type

  [TestFixture]
  TTestPolicyMemoryAdapter = class(TObject)
  private
    fAdapter: IPolicyAdapter;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

implementation

uses
  Casbin.Adapter.Memory.Policy;

procedure TTestPolicyMemoryAdapter.Setup;
begin
  fAdapter:=TPolicyMemoryAdapter.Create;
end;

procedure TTestPolicyMemoryAdapter.TearDown;
begin
end;


initialization
  TDUnitX.RegisterTestFixture(TTestPolicyMemoryAdapter);
end.
