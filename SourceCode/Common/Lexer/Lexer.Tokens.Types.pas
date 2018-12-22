unit Lexer.Tokens.Types;

interface

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
                ttADD,
                ttMinus,
                ttMultiply,
                ttDivide,
                ttModulo,
                ttGreaterThan,
                ttGreateEqualThan,
                ttLowerThan,
                ttLowerEqualThan,

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

implementation

end.
