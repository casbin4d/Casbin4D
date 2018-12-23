unit Lexer.Utilities;

interface

uses
  Lexer.Tokens.Types;

function tokenName(aValue: TTokenType): string;
function normalisedTokenName(aValue: TTokenType): string;

function tokenForOneCharReserved (const aChar: Char): PToken;

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

function tokenForOneCharReserved (const aChar: Char): PToken;
begin
  New(result);
  FillChar(result^, SizeOf(TToken), 0);

  case aChar of
    '#', ';': result^.&Type:=ttComment;
    '[' : result^.&Type:=ttLSquareBracket;
    ']' : result^.&Type:=ttRSquareBracket;
    '=' : result^.&Type:=ttEquality;
    ',' : result^.&Type:=ttComma;
    '(' : result^.&Type:=ttLParenthesis;
    ')' : result^.&Type:=ttRParenthesis;
    '_' : result^.&Type:=ttUnderscore;
    '.' : result^.&Type:=ttDot;
    '+' : result^.&Type:=ttAdd;
    '-' : result^.&Type:=ttMinus;
    '*' : result^.&Type:=ttMultiply;
    '/' : result^.&Type:=ttDivide;
    '%' : result^.&Type:=ttModulo;
    '>' : result^.&Type:=ttGreaterThan;
    '<' : result^.&Type:=ttLowerThan;
    #32 : result^.&Type:=ttSpace;
    #13 : result^.&Type:=ttCR;        //#$D
    #10 : result^.&Type:=ttLF;        //#$A
    #9  : result^.&type:=ttTab;
  else
    result^.&Type:=ttUnknown;
  end;
  result^.Value:=aChar;
end;

end.
