unit Casbin.Resolve;

interface

uses
  Casbin.Types, Casbin.Resolve.Types,
  System.Generics.Collections;

function resolve (const aResolve: TList<string>;
                  const aResolveType: TResolveType;
                  const aAssertions: TList<string>):
                    TDictionary<string, string>;

implementation

uses
  Casbin.Exception.Types, System.SysUtils;

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
  end;
end;

end.
