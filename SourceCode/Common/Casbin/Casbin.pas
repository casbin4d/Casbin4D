// Copyright 2018 The Casbin Authors. All Rights Reserved.
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
  Casbin.Adapter.Types, Casbin.Core.Logger.Types, Casbin.Functions.Types, Casbin.Policy.Types;

type
  TCasbin = class (TBaseInterfacedObject, ICasbin)
  private
    fModel: IModel;
    fPolicy: IPolicyManager;
    fLogger: ILogger;
    fEnabled: boolean;
    fFunctions: IFunctions;

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
    function enforce (const aParams: TEnforceParameters;
                      const reqOwner: string): boolean; overload;
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
  Casbin.Functions, Casbin.Adapter.Memory, Casbin.Adapter.Memory.Policy, System.SyncObjs, System.Types, System.StrUtils, Casbin.Core.Defaults;

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
begin
  Result:=enforce(aParams, '');
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

function TCasbin.enforce(const aParams: TEnforceParameters;
                         const reqOwner: string): boolean;
var
  item: string;
  request: TList<string>;
  requestDict: TDictionary<string, string>;
  policyDict: TDictionary<string, string>;
  requestStr: string;
  matcherResult: TEffectResult;
  matcher: TList<string>;
  policyList: TList<string>;
  effectArray: TEffectArray;
  matchString: string;
begin
  result:=true;
  if Length(aParams) = 0 then
    Exit;
  if not fEnabled then
    Exit;

  criticalSection.Acquire;
  try
    request:=TList<string>.Create;  //PALOFF
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
    fLogger.log('      Assertions: ');
    if fModel.assertions(stRequestDefinition).Count=0 then
      fLogger.log('         No Request Assertions found')
    else
      for item in fModel.assertions(stRequestDefinition) do
        fLogger.log('         '+item);
  {$ENDIF}
    requestDict:=resolve(request, rtRequest,
                            fModel.assertions(stRequestDefinition));
    if Trim(reqOwner)<>'' then
    begin
      fLogger.log('Owner identified');
      // This assumes the request uses the letter 'r'
      if requestDict.ContainsKey('R.OBJ') then
      begin
        requestDict.Add('R.OBJ.OWNER', UpperCase(Trim(reqOwner)));
        fLogger.log('r.obj.owner added');
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
    for item in fPolicy.policies do
    begin
      fLogger.log('   Processing policy: '+item);
      // Resolve Policy
      policyList:=TList<string>.Create;   //PALOFF
      policyList.AddRange(item.Split([',']));     //PALOFF

      // Item 0 has p,g, etc
      policyList.Delete(0);
      // We look at the relevant policies only
      if fPolicy.linkExists(request[0], policyList[0]) or
        soundexSimilar(Trim(request[0]), Trim(policyList[0]),
                                        Trunc(0.50 * Length(request[0]))) then
      begin
        policyDict:=resolve(policyList, rtPolicy,
                              fModel.assertions(stPolicyDefinition));

        // Match Owner
        if (Trim(reqOwner)<>'') then
          if policyDict.ContainsKey('P.OBJ') then
            policyDict.Add('P.OBJ.OWNER',trim(reqOwner));

        fLogger.log('   Resolving Functions and Matcher...');


        // Resolve Matcher
        if string.Compare('indeterminate', Trim(policyList[policyList.Count-1]),
                                                    [coIgnoreCase])=0 then
          matcherResult:=erIndeterminate
        else
          if matchString<>'' then
            matcherResult:=resolve(requestDict, policyDict, fFunctions, matchString)
          else
            matcherResult:=erIndeterminate;
        SetLength(effectArray, Length(effectArray)+1);
        effectArray[Length(effectArray)-1]:=matcherResult; //PALOFF

        policyDict.Free;
        policyList.Free;
      end;
    end;
    matcher.Free;

    //Resolve Effector
    fLogger.log('   Merging effects...');

    Result:=mergeEffects(fModel.effectCondition, effectArray);

    fLogger.log('Enforcement completed (Result: '+BoolToStr(Result, true)+')');

    request.Free;
    requestDict.Free;

  finally
    criticalSection.Release;
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
  Result:=False;
  if (Length(Args)<2) or (Length(Args)>3) then
    raise ECasbinException.Create('The arguments are different than expected in '+
                                    'g');
  if Length(Args)=3 then
    Result:=rolesG2(Args);
  if Length(Args)=2 then
    Result:=fPolicy.linkExists(Args[0], Args[1]);
end;

function TCasbin.rolesG2(const Args: array of string): Boolean;
begin
  Result:=False;
  if (Length(Args)<2) or (Length(Args)>3) then
    raise ECasbinException.Create('The arguments are different than expected in '+
                                    'g2');
  if Length(Args)=3 then
    Result:=fPolicy.linkExists(Args[0], Args[2], Args[1]);
  if Length(Args)=2 then
    Result:=rolesG(Args);
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
