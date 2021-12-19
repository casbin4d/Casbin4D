unit Casbin.Functions.IPMatch;

interface

/// <summary>
///   Determines whether an IP address ip1 matches the pattern of ip2
///   ip1 and ip2 can be an IP address or a CIDR pattern
///   eg. '192.168.2.123' matches '192.168.2.0/24'
/// </summary>
function IPMatch (const aArgs: array of string): Boolean; overload;
function IPMatch (const aIP1, aIP2: string; const aInvalidIPAsError: Boolean): Boolean; overload;

implementation

uses
  System.SysUtils,
  System.Types, System.StrUtils;

function IPMatch (const aArgs: array of string): Boolean;
begin
  if Length(aArgs)<>2 then
    raise Exception.Create('Wrong number of arguments in IPMatch');
  Result := IPMatch(aArgs[0], aArgs[1], True);
end;

function IPMatch(const aIP1, aIP2: string; const aInvalidIPAsError: Boolean): Boolean;
var
  ip1: string;
  ip2: string;
  IPArr1: TStringDynArray;
  IPArr2: TStringDynArray;

  function validIP(const aIP: string): Boolean;  //PALOFF
  var
    strArr: TStringDynArray;
    i: Integer;
    numIP: integer;
  begin
    Result:=True;
    strArr:=aIP.Split(['.']);
    if Length(strArr) <> 4 then
      Result:=false
    else
    begin
      for i:=0 to Length(strArr)-1 do
      begin
        if not (TryStrToInt(strArr[i], numIP)
                          and (numIP>=0) and (numIP<=255)) then
        begin
          Result:=False;
          Break;
        end;
      end;
    end;
  end;

begin
  result:=false;

  ip1 := aIP1.Trim;
  ip2 := aIP2.Trim;

  if ip1.IsEmpty or ip2.IsEmpty then
    Exit;

  if ip1.IndexOf('/') > -1 then
    ip1:=ip1.Split(['/'])[0];
  if ip2.IndexOf('/') > -1 then
    ip2:=ip2.Split(['/'])[0];

  if not validIP(ip1) then
  begin
    if aInvalidIPAsError then
      raise Exception.Create('Invalid IP: '+ip1+' in IPMatch');
    Exit(False);
  end;

  if not validIP(ip2) then
  begin
    if aInvalidIPAsError then
      raise Exception.Create('Invalid IP: '+ip1+' in IPMatch');
    Exit(False);
  end;

  if ip1.Equals(ip2) then
  begin
    result:=true;
    exit;
  end;

  IPArr1:=ip1.Split(['.']);
  IPArr2:=ip2.Split(['.']);

  Result:= (IPArr1[0]=IPArr2[0]) and (IPArr1[1]=IPArr2[1])
                                        and (IPArr1[2]=IPArr2[2]);
end;

end.
