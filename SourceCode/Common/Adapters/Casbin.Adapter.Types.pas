unit Casbin.Adapter.Types;

interface

uses
  Casbin.Core.Base.Types, Casbin.Core.Logger.Types, System.Generics.Collections;

type

  IAdapter = interface (IBaseInterface)
    ['{474D7E69-1015-4DB8-92CF-AA19A448A4B6}']
    function getAssertions: TList<string>;
    function getLogger: ILogger;
    procedure setLogger(const aValue: ILogger);
    procedure load (const aFilter: TFilterArray = []);
    procedure save;
    procedure setAssertions(const aValue: TList<string>);

    function toOutputString: string;
    procedure clear;
    function getFilter: TFilterArray;
    function getFiltered: boolean;

    property Assertions: TList<string> read getAssertions write setAssertions;
    property Filter: TFilterArray read getFilter;
    property Filtered: boolean read getFiltered;
    property Logger: ILogger read getLogger write setLogger;
  end;

implementation

end.
