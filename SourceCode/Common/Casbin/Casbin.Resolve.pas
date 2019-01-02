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
  Casbin.Exception.Types, SysUtils, Casbin.Matcher.Types, Casbin.Matcher;

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
  func: TCasbinFunc;
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
    if resolvedMatcher.Contains(item) then
    begin
      //We need to find the arguments

    end;
  end;


  // Evaluation
  Result:=matcher.evaluateMatcher(resolvedMatcher);
end;

end.
