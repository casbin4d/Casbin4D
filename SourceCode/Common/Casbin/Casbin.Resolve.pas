unit Casbin.Resolve;

interface

uses
  Casbin.Types, Casbin.Resolve.Types,
  System.Generics.Collections, Casbin.Effect.Types, Casbin.Functions.Types;

function resolve (const aResolve: TList<string>;
                  const aResolveType: TResolveType;
                  const aAssertions: TList<string>):
                    TDictionary<string, string>; overload;

function resolve(const aResolvedRequest, aResolvedPolicy: TDictionary<string,
    string>; const aFunctions: IFunctions; const aMatcher: string):
    TEffectResult; overload;

implementation

uses
  Casbin.Exception.Types, SysUtils, Casbin.Matcher.Types, Casbin.Matcher, Casbin.Core.Utilities;

function resolve (const aResolve: TList<string>;
                  const aResolveType: TResolveType;
                  const aAssertions: TList<string>):
                    TDictionary<string, string>;
var
  i: Integer;
  index: Integer;
  request: TEnforceParameters;
begin
  if not Assigned(aAssertions) then
    raise ECasbinException.Create('Assertions list is nil');
  Result:=TDictionary<string, string>.Create;
  case aResolveType of
    rtRequest,
    rtPolicy: begin
                 SetLength(request, aResolve.Count);
                 for i:=0 to aResolve.Count-1 do
                  request[i]:=UpperCase(Trim(aResolve.Items[i]));
                 if (aResolveType=rtRequest) and
                        (Length(request)<>aAssertions.Count) then
                   raise ECasbinException.Create
                   ('The resolve param has more fields than the definition');
                 for index:=0 to aAssertions.Count-1 do
                  Result.Add(UpperCase(aAssertions.Items[index]),
                                UpperCase(aResolve[index]));
               end;
  else
    raise ECasbinException.Create('Resolve Type not correct');
  end;
end;

function resolve(const aResolvedRequest, aResolvedPolicy: TDictionary<string,
    string>; const aFunctions: IFunctions; const aMatcher: string):
    TEffectResult;
var
  matcher: IMatcher;
  resolvedMatcher: string;
  item: string;
  item2: string;
  func: TCasbinFunc;
  args: string;
  argsArray: TArray<string>;
  endArgsPos: Integer;
  resolvedList: TArray<string>;
  replacedList: TArray<string>;
  startArgsPos: Integer;
  startFunPos: Integer;
  funcResult: Boolean;
  replaceStr: string;
  boolReplacseStr: string;
  i: Integer;
begin
  if not Assigned(aResolvedRequest) then
    raise ECasbinException.Create('Resolved Request is nil');
  if not Assigned(aResolvedPolicy) then
    raise ECasbinException.Create('Policy Request is nil');
  if not Assigned(aFunctions) then
    raise ECasbinException.Create('Functions are nil');

  resolvedMatcher:=UpperCase(Trim(aMatcher));
  matcher:=TMatcher.Create;

  for item in aResolvedRequest.Keys do
  begin
    resolvedMatcher:=resolvedMatcher.Replace
                          (UpperCase(item), UpperCase(aResolvedRequest.Items[item])
                                                  , [rfReplaceAll]);
    matcher.addIdentifier(UpperCase(aResolvedRequest.Items[item]));
  end;
  for item in aResolvedPolicy.Keys do
  begin
    resolvedMatcher:=resolvedMatcher.Replace
                          (UpperCase(item),
                              UpperCase(aResolvedPolicy.Items[item]),
                                                  [rfReplaceAll]);
    matcher.addIdentifier(UpperCase(aResolvedPolicy.Items[item]));
  end;

  //Functions
  for item in aFunctions.list do
  begin
    if resolvedMatcher.Contains(UpperCase(item)) then
    begin
      //We need to find the arguments
      startFunPos:=resolvedMatcher.IndexOf(UpperCase(item));
      startArgsPos:=startFunPos+Length(item)+1;
      endArgsPos:=resolvedMatcher.IndexOfAny([')'], startArgsPos);
      args:= Copy(resolvedMatcher, startArgsPos, endArgsPos-startArgsPos+1);
      argsArray:=args.Split([',']);

      for i:=0 to Length(argsArray)-1 do
      begin
        argsArray[i]:=Trim(argsArray[i]);
        if argsArray[i][findStartPos]='(' then
          argsArray[i]:=Copy(argsArray[i],findStartPos+1, Length(argsArray[i]));
        if argsArray[i][findEndPos(argsArray[i])]=')' then
          argsArray[i]:=Copy(argsArray[i], findStartPos, Length(argsArray[i])-1);
      end;
      
      funcResult:=aFunctions.retrieveFunction(item)(argsArray);
      replaceStr:=UpperCase(item);
      if args[findStartPos]<>'(' then
        replaceStr:=replaceStr+'(';
      replaceStr:=replaceStr+args;
      if args[findEndPos(args)]<>')' then 
        replaceStr:=replaceStr+')';

      if funcResult then 
        boolReplacseStr:='100 = 100'
      else
        boolReplacseStr:='100 = 90';
        
      resolvedMatcher:=resolvedMatcher.Replace(replaceStr, boolReplacseStr, 
                                                          [rfReplaceAll]);
    end;
  end;
  // Evaluation
  Result:=matcher.evaluateMatcher(resolvedMatcher);
end;

end.
