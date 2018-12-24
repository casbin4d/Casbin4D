unit Casbin.Lexer.Utilities;

interface

uses
  Casbin.Lexer.Tokens.Types;

function tokenName(aValue: TTokenType): string;
function normalisedTokenName(aValue: TTokenType): string;

function tokenForOneCharReserved (const aChar: Char): PToken;
function tokenForTwoCharReserved (const aToken: string): PToken;
function tokenForReservedWord (const aWord: string): PToken;

implementation

uses
  System.TypInfo,
  SysUtils, System.StrUtils;

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
    '=' : result^.&Type:=ttAssignment;
    ',' : result^.&Type:=ttComma;
    '(' : result^.&Type:=ttLParenthesis;
    ')' : result^.&Type:=ttRParenthesis;
    '_' : result^.&Type:=ttUnderscore;
    '.' : result^.&Type:=ttDot;
    ':' : result^.&Type:=ttColon;
    '+' : result^.&Type:=ttAdd;
    '-' : result^.&Type:=ttMinus;
    '*' : result^.&Type:=ttMultiply;
    '/' : result^.&Type:=ttDivide;
    '%' : result^.&Type:=ttModulo;
    '>' : result^.&Type:=ttGreaterThan;
    '<' : result^.&Type:=ttLowerThan;
    '\' : result^.&Type:=ttBackSlash;
    '!' : result^.&Type:=ttNOT;
    #32 : result^.&Type:=ttSpace;
    #13 : result^.&Type:=ttCR;        //#$D
    #10 : result^.&Type:=ttLF;        //#$A
    #9  : result^.&type:=ttTab;
  else
    result^.&Type:=ttUnknown;
  end;
  result^.Value:=aChar;
end;


function tokenForTwoCharReserved (const aToken: string): PToken;
begin
  New(result);
  FillChar(result^, SizeOf(TToken), 0);

  case IndexStr(UpperCase(aToken),  ['==', '//', '&&', '||', '>=', '<=', 'OR']) of
    0: result^.&Type:=ttEquality;
    1: result^.&Type:=ttDoubleSlash;
    2: result^.&Type:=ttAND;
    3: result^.&Type:=ttOR;
    4: result^.&Type:=ttGreaterEqualThan;
    5: result^.&Type:=ttLowerEqualThan;
    6: result^.&Type:=ttOR;
  else
    result^.&Type:=ttUnknown;
  end;
  result^.Value:=aToken;
end;

function tokenForReservedWord (const aWord: string): PToken;
begin
  New(result);
  FillChar(result^, SizeOf(TToken), 0);

  case IndexStr(UpperCase(aWord),
    ['AND', 'NOT', 'ALLOW', 'DENY', 'INDETERMINATE', 'SOME', 'WHERE', 'EFT',
                     'ANY', 'PRIORITY']) of
    0: result^.&Type:=ttAND;
    1: result^.&Type:=ttNOT;
    2: result^.&Type:=ttAllow;
    3: result^.&Type:=ttDeny;
    4: result^.&Type:=ttIndeterminate;
    5: result^.&Type:=ttSome;
    6: result^.&Type:=ttWhere;
    7: result^.&Type:=ttEft;
    8: result^.&Type:=ttAny;
    9: result^.&Type:=ttPriority;
  else
    result^.&Type:=ttUnknown;
  end;
  result^.Value:=aWord;
end;
end.
