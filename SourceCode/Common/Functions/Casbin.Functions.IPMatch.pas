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
  index: integer;
  IPArr1: TStringDynArray;
  IPArr2: TStringDynArray;

  function validIP(const aIP: string): Boolean;  //PALOFF
  var
    strArr: TStringDynArray;
    i: Integer;
    numIP: integer;
  begin
    Result:=True;
    strArr:=SplitString(aIP, '.');
    if Length(strArr)<>4 then
      Result:=false
    else
    begin
      for i:=0 to Length(strArr)-1 do
      begin
        if not (TryStrToInt(strArr[i], numIP)
                          and (numIP>=0) and (numIP<=255)) then
        begin
          Result:=False;
          Exit;
        end;
      end;
    end;
  end;

begin
  ip1 := Trim(aIP1);
  ip2 := Trim(aIP2);

  index:=Pos('/', ip1, low(string));
  if index<>0 then
    ip1:=Copy(ip1, Low(string), index-1);

  index:=Pos('/', ip2, low(string));
  if index<>0 then
    ip2:=Copy(ip2, Low(string), index-1);

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

  if ip1=ip2 then
  begin
    Result:=True;
    Exit;
  end;

  IPArr1:=SplitString(ip1, '.');
  IPArr2:=SplitString(ip2, '.');

  Result:= (IPArr1[0]=IPArr2[0]) and (IPArr1[1]=IPArr2[1])
                                        and (IPArr1[2]=IPArr2[2]);
end;

end.
