unit Lexer.Utilities;

interface

uses
  Lexer.Tokens.Types;

function tokenName(aValue: TTokenType): string;
function normalisedTokenName(aValue: TTokenType): string;

implementation

uses
  System.TypInfo,
  SysUtils;

function tokenName(aValue: TTokenType): string;
begin
  result := GetEnumName(TypeInfo(TTokenType), Integer(aValue));
end;

function normalisedTokenName(aValue: TTokenType): string;
begin
  Result := tokenName(aValue).Remove(0, 2);
end;

end.
