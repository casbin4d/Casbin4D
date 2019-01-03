unit Tests.Adapter.MemorySystem;

interface
uses
  DUnitX.TestFramework, Casbin.Adapter.Types;

type

  [TestFixture]
  TTestAdapterMemory = class(TObject)
  private
    fAdapter: IAdapter;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  end;

implementation

uses
  Casbin.Adapter.Memory;

procedure TTestAdapterMemory.Setup;
begin
  fAdapter:=TMemoryAdapter.Create;
end;

procedure TTestAdapterMemory.TearDown;
begin
end;


initialization
  TDUnitX.RegisterTestFixture(TTestAdapterMemory);
end.
