unit Casbin;

interface

uses
  Casbin.Core.Base.Types, Casbin.Types, Casbin.Model.Types,
  Casbin.Policy.Types, Casbin.Adapter.Types, Casbin.Core.Logger.Types;

type
  TCasbin = class (TBaseInterfacedObject, ICasbin)
  private
    fModel: IModel;
    fPolicy: IPolicyManager;
    fLogger: ILogger;
    fEnabled: boolean;
  private
{$REGION 'Interface'}
    function getModel: IModel;
    function getPolicy: IPolicyManager;
    procedure setModel(const aValue: IModel);
    procedure setPolicy(const aValue: IPolicyManager);
    function getLogger: ILogger;
    procedure setLogger(const aValue: ILogger);
    function getEnabled: Boolean;
    procedure setEnabled(const aValue: Boolean);

    function enforce (const aParams: TEnforceParameters): boolean;
{$ENDREGION}
  public
    constructor Create(const aModelFile, aPolicyFile: string); overload;
    constructor Create(const aModel: IModel; const aPolicyAdapter: IPolicyManager);
        overload;
  end;

implementation

uses
  Casbin.Exception.Types, Casbin.Model, Casbin.Policy,
  Casbin.Core.Logger.Default, System.Generics.Collections, System.SysUtils,
  Casbin.Resolve, Casbin.Resolve.Types, Casbin.Model.Sections.Types, Casbin.Core.Utilities, System.Rtti;

constructor TCasbin.Create(const aModelFile, aPolicyFile: string);
begin
  Create(TModel.Create(aModelFile), TPolicyManager.Create(aPolicyFile));
end;

constructor TCasbin.Create(const aModel: IModel; const aPolicyAdapter:
    IPolicyManager);
begin
  if not Assigned(aModel) then
    raise ECasbinException.Create('Model Adapter is nil');
  if not Assigned(aPolicyAdapter) then
    raise ECasbinException.Create('Policy Manager is nil');
  inherited Create;
  fModel:=aModel;
  fPolicy:=aPolicyAdapter;
  fLogger:=TDefaultLogger.Create;
  fEnabled:=True;
end;

function TCasbin.enforce(const aParams: TEnforceParameters): boolean;
var
  i: Integer;
  index: Integer;
  item: string;
  request: TList<string>;
  requestDict: TDictionary<string, string>;
  policyDict: TDictionary<string, string>;
  requestStr: string;
begin
  result:=true;
  if not fEnabled then
    Exit;

  request:=TList<string>.Create;
  for item in aParams do
    request.Add(item);

  for item in aParams do
    requestStr:=requestStr+item+',';
  if requestStr[findEndPos(requestStr)]=',' then
    requestStr:=Copy(requestStr, findStartPos,
                        findEndPos(requestStr));
  fLogger.log('Enforcing request '''+requestStr+'''');

  // Resolve Request
  requestDict:=resolve(request,
                       rtRequest,
                       fModel.assertions(stRequestDefinition));

  // Resolve Policy
  policyDict:=resolve(fPolicy.policies, rtPolicy,
                      fModel.assertions(stPolicyDefinition));

  request.Free;
  policyDict.Free;
  requestDict.Free;
end;

{ TCasbin }

function TCasbin.getEnabled: Boolean;
begin
  Result:=fEnabled;
end;

function TCasbin.getLogger: ILogger;
begin
  Result:=fLogger;
end;

function TCasbin.getModel: IModel;
begin
  Result:=fModel;
end;

function TCasbin.getPolicy: IPolicyManager;
begin
  Result:=fPolicy;
end;

procedure TCasbin.setEnabled(const aValue: Boolean);
begin
  fEnabled:=aValue;
end;

procedure TCasbin.setLogger(const aValue: ILogger);
begin
  if Assigned(aValue) then
  begin
    fLogger:=nil;
    fLogger:=aValue;
  end;
end;

procedure TCasbin.setModel(const aValue: IModel);
begin
  if not Assigned(aValue) then
    raise ECasbinException.Create('Model in nil');
  fModel:=aValue;
end;

procedure TCasbin.setPolicy(const aValue: IPolicyManager);
begin
  if not Assigned(aValue) then
    raise ECasbinException.Create('Policy Manager in nil');
  fPolicy:=aValue;
end;

end.
