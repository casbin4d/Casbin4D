unit Lexer.Tokens.Types;

interface

uses
  System.SysUtils, System.Types;

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
                ttBackslash,
                //Operations
                ttAND,
                ttOR,
                ttNOT,
                ttAdd,
                ttMinus,
                ttMultiply,
                ttDivide,
                ttModulo,
                ttGreaterThan,
                ttGreaterEqualThan,
                ttLowerThan,
                ttLowerEqualThan,

                //Whitespace
                ttTab,
                ttSpace,
                ttCR,
                ttLF,
                ttEOL,
                ttEOF,

                //Unknown
                ttUnknown

                //Keywords
                );

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
  oneCharReserved: TSysCharSet  =
      ['#', ';', //Comments
       '[', ']', '=', ',', '(', ')', '_', '.',
       '+', '-', '*', '/', '%',
       '>', '<', '\', '!'];

  whiteSpaceChars: TSysCharSet = [#9, #32, #13, #10];

  twoCharReserved: TStringDynArray = ['==', '//', '&&', '||', '>=', '<='];

implementation

end.

