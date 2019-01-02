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
  Casbin.Resolve, Casbin.Resolve.Types, Casbin.Model.Sections.Types, Casbin.Core.Utilities, System.Rtti, Casbin.Effect.Types,
  Casbin.Effect, Casbin.Functions.Types, Casbin.Functions;

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
  tmpList: TList<string>;
  requestDict: TDictionary<string, string>;
  policyDict: TDictionary<string, string>;
  requestStr: string;
  matcherResult: TEffectResult;
  matcher: TList<string>;
  policyList: TList<string>;
  policyArray: TArray<string>;
  policy: string;
  effectArray: TEffectArray;
  matchString: string;
  func: IFunctions;
  reqDefinitions: TList<string>;
  polDefinitions: TList<string>;
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

  fLogger.log('   Resolving Request...');
  // Resolve Request
{$IFDEF DEBUG}
  fLogger.log('   Request: '+requestStr);
  tmpList:=fModel.assertions(stRequestDefinition);
  fLogger.log('      Assertions: ');
  for item in tmpList do
    fLogger.log('         '+item);
  tmpList.Free;
{$ENDIF}
  reqDefinitions:=fModel.assertions(stRequestDefinition);
  requestDict:=resolve(request, rtRequest, reqDefinitions);

  fLogger.log('   Resolving Policies...');

{$IFDEF DEBUG}
  fLogger.log('   Policies: ');
  fLogger.log('      Assertions: ');
  tmpList:=fPolicy.policies;
  for item in tmpList do
    fLogger.log('         '+item);
  tmpList.Free;

  tmpList:=fModel.assertions(stPolicyDefinition);
  fLogger.log('      Assertions: '+requestStr);
  for item in tmpList do
    fLogger.log('         '+item);
  tmpList.Free;
{$ENDIF}

  matcher:=fModel.assertions(stMatchers);
  func:=TFunctions.Create;

  for item in fPolicy.policies do
  begin
    // Resolve Policy
    policyList:=TList<string>.Create;
    policyList.AddRange(item.Split([',']));

    //Item 0 has p,g, etc
    policyList.Delete(0);
    polDefinitions:= fModel.assertions(stPolicyDefinition);
    policyDict:=resolve(policyList, rtPolicy, polDefinitions);

    fLogger.log('   Resolving Functions and Matcher...');
    // Resolve Matcher
    if matcher.Count>0 then
      matcherResult:=resolve(requestDict, policyDict, func, matcher.Items[0])
    else
      matcherResult:=erIndeterminate;
    SetLength(effectArray, Length(effectArray)+1);
    effectArray[Length(effectArray)-1]:=matcherResult;

    polDefinitions.Free;
    policyDict.Free;
    policyList.Free;

  end;

  matcher.Free;

  //Resolve Effector
  fLogger.log('   Merging effects...');

  Result:=mergeEffects(fModel.effectCondition, effectArray);

  fLogger.log('Enforcement completed (Result: '+BoolToStr(Result, true)+')');

  reqDefinitions.Free;
  request.Free;
  requestDict.Free;
  func:=nil;
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
