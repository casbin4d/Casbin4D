unit Casbin.Types;

interface

uses
  Casbin.Core.Base.Types, Casbin.Model.Types, Casbin.Policy.Types,
  Casbin.Core.Logger.Types, System.Types;

type
  TEnforceParameters = TStringDynArray;

  ICasbin = interface (IBaseInterface)
    ['{7DC6F205-0000-40EF-BA8A-BF18018E5674}']
    function getEnabled: Boolean;
    function getLogger: ILogger;
    function getModel: IModel;
    function getPolicy: IPolicyManager;
    procedure setEnabled(const aValue: Boolean);
    procedure setLogger(const aValue: ILogger);
    procedure setModel(const aValue: IModel);
    procedure setPolicy(const aValue: IPolicyManager);

    function enforce (const aParams: TEnforceParameters): boolean;

    property Enabled: Boolean read getEnabled write setEnabled;
    property Logger: ILogger read getLogger write setLogger;
    property Model: IModel read getModel write setModel;
    property Policy: IPolicyManager read getPolicy write setPolicy;
  end;

implementation

end.
