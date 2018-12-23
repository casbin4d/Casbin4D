unit Lexer.Tokens.Types;

interface

uses
  System.SysUtils;

type
  TTokenType = (ttIdentifier,
                ttComment,
                ttLSquareBracket,
                ttRSquareBracket,
                ttAssignment,
                ttComma,
                ttLParenthesis,
                ttRParenthesis,
                ttUnderscore,
                ttDot,
                ttEquality,
                ttDoubleSlash,
                ttAND,
                ttOR,
                ttNOT,
                ttAdd,
                ttMinus,
                ttMultiply,
                ttDivide,
                ttModulo,
                ttGreaterThan,
                ttGreateEqualThan,
                ttLowerThan,
                ttLowerEqualThan,
                ttBackslash,

                ttTab,
                ttSpace,
                ttCR,
                ttLF,
                ttEOL,
                ttEOF,
                ttUnknown);

  TPosition = record
    Row: Integer;
    Column: Integer;
  end;

  PToken = ^TToken;
  TToken = record
    &Type: TTokenType;
    Value: string;
    StartPosition: TPosition;
    EndPosition: TPosition;
  end;

const
  oneCharReserved: TSysCharSet  = ['#', ';', //Comments
                                    '[', ']',
                                    '=',
                                    ',',
                                    '(', ')',
                                    '_',
                                    '.',
                                    '+', '-', '*', '/', '%',
                                    '>',
                                    '<',
                                    '\',
                                    '!'];
  whiteSpaceChars: TSysCharSet = [#9, #32, #13, #10];




implementation

end.

                ttEquality,
                ttDoubleSlash,
                ttAND,
                ttOR,
                ttNOT,

                ttGreateEqualThan,
                ttLowerEqualThan,
