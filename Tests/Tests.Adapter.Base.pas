unit Tests.Adapter.Base;

interface

uses
  DUnitX.TestFramework, Casbin.Adapter.Types;

type
  // No need to test anything as TBaseAdapter is very basic
  // This unit is a placeholder for future tests
  [TestFixture]
  TTestAdapterBase = class
  private
    fAdapter: IAdapter;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;


// function getAssertions: TList<string>;
// function getLogger: ILogger;
// procedure setLogger(const aValue: ILogger);
// procedure load (const aFilter: TFilterArray = []);
// procedure save;
// procedure setAssertions(const aValue: TList<string>);
//
// function toOutputString: string;
// procedure clear;
// function getFilter: TFilterArray;
// function getFiltered: boolean;
//
// property Assertions: TList<string> read getAssertions write setAssertions; //PALOFF
// property Filter: TFilterArray read getFilter;
// property Filtered: boolean read getFiltered;
// property Logger: ILogger read getLogger write setLogger;

  end;

implementation

uses
  Casbin.Adapter.Base;

procedure TTestAdapterBase.Setup;
begin
  fAdapter:=TBaseAdapter.Create;
end;

procedure TTestAdapterBase.TearDown;
begin
end;

initialization
  TDUnitX.RegisterTestFixture(TTestAdapterBase);

end.
