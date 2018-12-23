unit Lexer.Tokens.List;

interface

uses
  Lexer.Tokens.Types, System.Generics.Collections;

type
  TTokenList = class (TList<PToken>)
  public
    destructor Destroy; override;

    {$REGION 'Output format: {Token: xxx; Value: xxx; (StartCol, StartRow) --> (EndCol,EndRow)'}
    /// <summary>
    ///   Output format: {Token: xxx; Value: xxx; (StartCol, StartRow) --&gt;
    ///   (EndCol,EndRow) + sLineBreak
    /// </summary>
    {$ENDREGION}
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
  value: string;
begin
  for item in Self do
  begin
    if item^.Value = #32 then
      value:='(space)'
    else
      if item^.Value = #13 then
        value:='(eol)'
      else
        if item^.Value = #10 then
          value:='(eol)'
        else
          if item^.Value = #9 then
            value:='(tab)'
          else
            value:=item^.Value;

    finalStr:=finalStr+'{Token: '+normalisedTokenName(item^.&Type)+'; '+
             'Value: '+value+'; ('+item^.StartPosition.Column.ToString+
             ','+item^.StartPosition.Row.toString+') --> ('+
                 item^.EndPosition.Column.ToString+','+
                 item^.EndPosition.Row.ToString+')}'+sLineBreak;
  end;
  finalStr:=Trim(finalStr);
  Result:=finalStr;
end;

end.
