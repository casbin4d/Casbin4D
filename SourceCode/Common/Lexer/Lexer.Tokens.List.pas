unit Lexer.Tokens.List;

interface

uses
  Lexer.Tokens.Types, System.Generics.Collections;

type
  TTokenList = class (TList<PToken>)
  public
    destructor Destroy; override;

    function toOutputString: string;
  end;

implementation

uses
  System.TypInfo,
  SysUtils, Lexer.Utilities;

destructor TTokenList.Destroy;
var
  i: Integer;
begin
  for i:=0 to Self.Count-1 do
    Dispose(Self.Items[i]);
  inherited;
end;

function TTokenList.toOutputString: string;
var
  item: PToken;
  finalStr: string;
begin
  for item in Self do
  begin
    finalStr:=finalStr+'{Token: '+normalisedTokenName(item^.&Type)+'; '+
             'Value: '+item^.Value+'; ('+item^.StartPosition.Column.ToString+
             ', '+item^.StartPosition.Row.toString+') --> ('+
                 item^.EndPosition.Column.ToString+', '+
                 item^.EndPosition.Row.ToString+')}'+sLineBreak;                    
  end;
  finalStr:=Trim(finalStr);
  Result:=finalStr;
end;

end.
