unit Casbin.Resolve;

interface

uses
  Casbin.Types, Casbin.Resolve.Types,
  System.Generics.Collections, Casbin.Effect.Types;

function resolve (const aResolve: TList<string>;
                  const aResolveType: TResolveType;
                  const aAssertions: TList<string>):
                    TDictionary<string, string>; overload;

function resolve(const aResolvedRequest,
                       aResolvedPolicy: TDictionary<string, string>;
                 const aFunctionListList,
                       aMatcher: string): TEffectResult; overload;

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
                  request[i]:=Trim(aResolve.Items[i]);
                 if (aResolveType=rtRequest) and
                        (Length(request)<>aAssertions.Count) then
                   raise ECasbinException.Create
                   ('The resolve param has more fields than the definition');
                 for index:=0 to aAssertions.Count-1 do
                  Result.Add(aAssertions.Items[index],
                                aResolve[index]);
               end;
  else
    raise ECasbinException.Create('Resolve Type not correct');
  end;
end;

function resolve(const aResolvedRequest, aResolvedPolicy: TDictionary<string,
    string>; const aFunctionListList, aMatcher: string): TEffectResult;
var
  matcher: IMatcher;
  resolvedMatcher: string;
  item: string;
begin
  if not Assigned(aResolvedRequest) then
    raise ECasbinException.Create('Resolved Request is nil');
  if not Assigned(aResolvedPolicy) then
    raise ECasbinException.Create('Policy Request is nil');

  resolvedMatcher:=Trim(aMatcher);
  matcher:=TMatcher.Create;

  for item in aResolvedRequest.Keys do
  begin
    resolvedMatcher:=resolvedMatcher.Replace
                          (item, aResolvedRequest.Items[item], [rfReplaceAll]);
    matcher.addIdentifier(aResolvedRequest.Items[item]);
  end;
  for item in aResolvedPolicy.Keys do
  begin
    resolvedMatcher:=resolvedMatcher.Replace
                          (item, aResolvedPolicy.Items[item], [rfReplaceAll]);
    matcher.addIdentifier(aResolvedPolicy.Items[item]);
  end;

  Result:=matcher.evaluateMatcher(resolvedMatcher);
end;

end.
