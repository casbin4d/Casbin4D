// Copyright 2018 by John Kouraklis and Contributors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
unit Casbin;

interface

uses
  Casbin.Core.Base.Types, Casbin.Types, Casbin.Model.Types,
  Casbin.Adapter.Types, Casbin.Core.Logger.Types, Casbin.Functions.Types,
  Casbin.Policy.Types, System.TypInfo;

type
  TCasbin = class (TBaseInterfacedObject, ICasbin)
  private
    fModel: IModel;
    fPolicy: IPolicyManager;
    fLogger: ILogger;
    fEnabled: boolean;
    fFunctions: IFunctions;

    function rolesGsInternal(const Args: array of string): Boolean;
    function rolesG(const Args: array of string): Boolean;
    function rolesG2(const Args: array of string): Boolean;
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

    function enforce (const aParams: TEnforceParameters): boolean; overload;
    function enforce(const aParams: TEnforceParameters; const aPointer: PTypeInfo;
        const aRec): boolean; overload;
{$ENDREGION}
  public
    constructor Create; overload;
    constructor Create(const aModelFile, aPolicyFile: string); overload;  //PALOFF
    constructor Create(const aModel: IModel; const aPolicyAdapter: IPolicyManager);
        overload;
    constructor Create(const aModelFile: string; const aPolicyAdapter: IPolicyManager);
        overload;
    constructor Create(const aModel: IModel; const aPolicyFile: string);
        overload;
  end;

implementation

uses
  Casbin.Exception.Types, Casbin.Model, Casbin.Policy,
  Casbin.Core.Logger.Default, System.Generics.Collections, System.SysUtils,
  Casbin.Resolve, Casbin.Resolve.Types, Casbin.Model.Sections.Types,
  Casbin.Core.Utilities, System.Rtti, Casbin.Effect.Types, Casbin.Effect,
  Casbin.Functions, Casbin.Adapter.Memory, Casbin.Adapter.Memory.Policy,
  System.SyncObjs, System.Types, System.StrUtils, Casbin.Core.Defaults,
  ArrayHelper;

var
  criticalSection: TCriticalSection;

constructor TCasbin.Create(const aModelFile, aPolicyFile: string);
var
  model: IModel;
  policy: IPolicyManager;
begin
  if trim(aModelFile)='' then
    model:=TModel.Create(TMemoryAdapter.Create)
  else
    model:=TModel.Create(aModelFile);

  if Trim(aPolicyFile)='' then
    policy:=TPolicyManager.Create(TPolicyMemoryAdapter.Create)
  else
    policy:=TPolicyManager.Create(aPolicyFile);

  Create(model, policy);
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
  fFunctions:=TFunctions.Create;
  fFunctions.registerFunction('g', rolesG);
  fFunctions.registerFunction('g2', rolesG2);
end;

function TCasbin.enforce(const aParams: TEnforceParameters): boolean;
var
  rec: string; //PALOFF
begin
  Result:=enforce(aParams, nil, rec);
end;

constructor TCasbin.Create;
begin
  Create(TModel.Create(TMemoryAdapter.Create), TPolicyManager.Create(
                                                  TPolicyMemoryAdapter.Create));
end;

constructor TCasbin.Create(const aModelFile: string;
  const aPolicyAdapter: IPolicyManager);
var
  model: IModel;
begin
  if trim(aModelFile)='' then
    model:=TModel.Create(TMemoryAdapter.Create)
  else
    model:=TModel.Create(aModelFile);

  Create(model, aPolicyAdapter);
end;

function TCasbin.enforce(const aParams: TEnforceParameters; const aPointer:
    PTypeInfo; const aRec): boolean;
var
  item: string;
  request: TList<string>;
  requestDict: TDictionary<string, string>;
  policyDict: TDictionary<string, string>;
  requestStr: string;
  matcherResult: TEffectResult;
  policyList: TList<string>;
  effectArray: TEffectArray;
  matchString: string;
  reqDomain: string;
  domainsArrayRec: TArrayRecord<string>;
  requestArrayRec: TArrayRecord<string>;
  ctx: TRttiContext;
  cType: TRttiType;
  cField: TRttiField;
  abacList: TList<string>;
begin
  result:=true;
  if Length(aParams) = 0 then
    Exit;
  if not fEnabled then
    Exit;

  requestArrayRec:=TArrayRecord<string>.Create(aParams);
  request:=TList<string>.Create;
  requestDict:=nil;
  abacList:=TList<string>.Create;
  criticalSection.Acquire;
  try
    requestArrayRec.List(request);

    requestStr:=string.Join(',', aParams);

    fLogger.log('Enforcing request '''+requestStr+'''');
    fLogger.log('   Resolving Request...');

    // Resolve Request
  {$IFDEF DEBUG}
    fLogger.log('   Request: '+requestStr);
    fLogger.log('      Assertions: ');
    if fModel.assertions(stRequestDefinition).Count=0 then
      fLogger.log('         No Request Assertions found')
    else
      for item in fModel.assertions(stRequestDefinition) do
        fLogger.log('         '+item);
  {$ENDIF}
    requestDict:=resolve(request, rtRequest,
                            fModel.assertions(stRequestDefinition));

    // Resolve ABAC record
    if Assigned(aPointer) and Assigned(@aRec) then
    begin
      fLogger.log('Record Identified');
      ctx:=TRttiContext.Create;
      cType:=ctx.GetType(aPointer);

      if fModel.assertions(stRequestDefinition).Count>0 then
      begin
        abacList.AddRange(fModel.assertions(stRequestDefinition));
        fLogger.log('Request identifiers retrieved ('+string.Join(',', abacList.ToArray)+')');
      end
      else
      begin
        // This assumes the request uses the letter 'r' and typical 'sub,obj,act'
        abacList.Add('r.sub');
        abacList.Add('r.obj');
        abacList.Add('r.act');
        fLogger.log('Default identifiers used (r)');
      end;

      fLogger.log('Retrieving content of '+cType.Name+' record');
      for cField in cType.GetFields do
      begin
        for item in abacList do
        begin
          requestDict.Add(UpperCase(item)+'.'+UpperCase(cField.Name),
                          UpperCase(cField.GetValue(@aRec).AsString));
        end;
      end;
    end;

    fLogger.log('   Resolving Policies...');

  {$IFDEF DEBUG}
    fLogger.log('   Policies: ');
    fLogger.log('      Assertions: ');
    if fPolicy.policies.Count=0 then
      fLogger.log('         No Policy Assertions found')
    else
      for item in fPolicy.policies do
        fLogger.log('         '+item);

    fLogger.log('      Assertions: '+requestStr);
    for item in fModel.assertions(stPolicyDefinition) do
      fLogger.log('         '+item);
  {$ENDIF}

  {$IFDEF DEBUG}
    fLogger.log('   Matchers: '+requestStr);
    fLogger.log('      Assertions: ');
    if fModel.assertions(stMatchers).Count=0 then
      fLogger.log('         No Matcher Assertions found')
    else
      for item in fModel.assertions(stMatchers) do
        fLogger.log('         '+item);
  {$ENDIF}
    if fModel.assertions(stMatchers).Count>0 then
    begin
      matchString:=fModel.assertions(stMatchers).Items[0];

      // Check for builtin accounts
      for item in builtinAccounts do
        if matchString.Contains(item) and requestStr.Contains(item) then
          Exit;

    end
    else
      matchString:='';

    domainsArrayRec:=TArrayRecord<string>.Create(fPolicy.domains.ToArray);
    for item in fPolicy.policies do
    begin
      fLogger.log('   Processing policy: '+item);
      // Resolve Policy
      policyList:=TList<string>.Create;   //PALOFF
      policyList.AddRange(item.Split([',']));     //PALOFF

      // Item 0 has p,g, etc
      policyList.Delete(0);
      // We look at the relevant policies only
      // by working out the domains
      reqDomain:=DefaultDomain;
      domainsArrayRec.ForEach(procedure(var Value: string; Index: integer)
                              var
                                item: string;
                              begin
                                for item in policyList do
                                  if Trim(Value) = Trim(item) then
                                  begin
                                    reqDomain:=Trim(Value);
                                    Break;
                                  end;
                              end);

      if fPolicy.linkExists(request[0], reqDomain, policyList[0])
//      or
//        soundexSimilar(Trim(request[0]), Trim(policyList[0]),
//                                        Trunc(0.50 * Length(request[0]))))
                                                                          then
      begin
        policyDict:=resolve(policyList, rtPolicy,
                              fModel.assertions(stPolicyDefinition));

        fLogger.log('   Resolving Functions and Matcher...');

        // Resolve Matcher
        if string.Compare('indeterminate', Trim(policyList[policyList.Count-1]),
                                                    [coIgnoreCase])=0 then
        begin
          SetLength(effectArray, Length(effectArray)+1);
          effectArray[Length(effectArray)-1]:=erIndeterminate; //PALOFF
        end
        else
        begin
          /// resolve returns one of the two options erAllow (means the policy is
          /// relevant) or erDeny (the policy is not relevant)
          matcherResult:=resolve(requestDict, policyDict, fFunctions, matchString);
          if matcherResult = erAllow then
          begin
            if policyList.count = request.Count then
            begin
              matcherResult:=erAllow;
            end
            else
            begin
              if policyList.Count > request.Count then
                if policyList[request.Count].Trim.ToUpper.Equals('ALLOW') then
                  matcherResult:=erAllow
                else
                  matcherResult:=erDeny;
            end;
            SetLength(effectArray, Length(effectArray)+1);
            effectArray[Length(effectArray)-1]:=matcherResult; //PALOFF
          end;
        end;
        policyDict.Free;
      end;
      policyList.Free;
    end;

    //Resolve Effector
    fLogger.log('   Merging effects...');

    Result:=mergeEffects(fModel.effectCondition, effectArray);

    fLogger.log('Enforcement completed (Result: '+BoolToStr(Result, true)+')');

  finally
    criticalSection.Release;
    request.Free;
    requestDict.Free;
    abacList.Free;
  end;
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

function TCasbin.rolesG(const Args: array of string): Boolean;
begin
  Result:=rolesGsInternal(Args);
end;

function TCasbin.rolesG2(const Args: array of string): Boolean;
begin
  Result:=rolesGsInternal(Args);
end;

function TCasbin.rolesGsInternal(const Args: array of string): Boolean;
begin
  result:=False;
  if (Length(Args)<2) or (Length(Args)>3) then
    raise ECasbinException.Create('The arguments are different than expected in '+
                                    'g''s functions');
  if Length(Args)=3 then
    Result:=fPolicy.linkExists(Args[0], Args[2], Args[1]);
  if Length(Args)=2 then
    Result:=fPolicy.linkExists(Args[0], Args[1]);
end;

procedure TCasbin.setEnabled(const aValue: Boolean);
begin
  fEnabled:=aValue;
end;

procedure TCasbin.setLogger(const aValue: ILogger);
begin
  fLogger:=nil;
  if Assigned(aValue) then
    fLogger:=aValue
  else
    fLogger:=TDefaultLogger.Create;
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

constructor TCasbin.Create(const aModel: IModel; const aPolicyFile: string);
var
  policy: IPolicyManager;
begin
  if Trim(aPolicyFile)='' then
    policy:=TPolicyManager.Create(TPolicyMemoryAdapter.Create)
  else
    policy:=TPolicyManager.Create(aPolicyFile);

  Create(aModel, policy);
end;

initialization
  criticalSection:=TCriticalSection.Create;

finalization
  criticalSection.Free;

end.
