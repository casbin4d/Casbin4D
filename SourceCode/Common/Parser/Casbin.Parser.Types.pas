unit Casbin.Parser.Types;

interface

uses
  Casbin.Core.Base.Types, Casbin.Core.Logger.Types, Casbin.Parser.AST.Types;

type
  TParseType = (ptModel, ptPolicy, ptConfig);
  TParserStatus = (psIdle, psRunning, psError);

  IParser = interface (IBaseInterface)
    function getErrorMessage: string;
    function getLogger: ILogger;
    function getNodes: TNodeCollection;
    function getParseType: TParseType;
    function getStatus: TParserStatus;
    procedure setLogger(const aValue: ILogger);

    procedure parse;
    property ErrorMessage: string read getErrorMessage;
    property Logger: ILogger read getLogger write setLogger;
    property Nodes: TNodeCollection read getNodes;
    property ParseType: TParseType read getParseType;
    property Status: TParserStatus read getStatus;
  end;

implementation

end.
