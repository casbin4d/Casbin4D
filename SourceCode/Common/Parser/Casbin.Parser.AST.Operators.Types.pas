unit Casbin.Parser.AST.Operators.Types;

interface

uses
  System.Types;

type
  TOperatorType = (otUnary, otBinary);

  TOperators = (opAssignment,
                opComma,
                opDot,
                opEquality,
                opInequality,

                //Numeric
                opAdd,
                opMinus,
                opMultiply,
                opDivide,
                opModulo,
                opGreater,
                opGreaterEqual,
                opLess,
                opLessEqual,

                //Logical
                opAND,
                opOR,
                opNOT,

                //Function
                opFunction,

                //Keyword
                opWhere,
                opSome,
                opAny,
                opAllow,
                opDeny,
                opIndeterminate,
                opEffect,
                opPriority

                );

  TOperatorRec = record
    &Type : TOperatorType;
    &Operator: TOperators;
    Literal: TStringDynArray;
    {$REGION '1 --> Highest (evaluated first) 20 --> Lowest Operators with the same priority are evaluated from left to right'}
    /// <summary>
    ///   <para>
    ///     1 --&gt; Highest (evaluated first)
    ///   </para>
    ///   <para>
    ///     20 --&gt; Lowest
    ///   </para>
    ///   <para>
    ///     Operators with the same priority are evaluated from left to right
    ///   </para>
    /// </summary>
    {$ENDREGION}
    Priority: Byte;
  end;

const
  operatorsArray: array [opAssignment..opPriority] of TOperatorRec =
  (
  (&Type: otBinary; &Operator: opAssignment; Literal: ['=', ',']; Priority: 0),
  (&Type: otBinary; &Operator: opComma; Literal: [',']; Priority: 5),
  (&Type: otBinary; &Operator: opDot; Literal: ['.']; Priority: 5),
  (&Type: otBinary; &Operator: opEquality; Literal: ['==']; Priority: 5),
  (&Type: otBinary; &Operator: opInequality; Literal: ['<>']; Priority: 5),
  (&Type: otBinary; &Operator: opAdd; Literal: ['+']; Priority: 4),
  (&Type: otBinary; &Operator: opMinus; Literal: ['-']; Priority: 4),
  (&Type: otBinary; &Operator: opMultiply; Literal: ['*']; Priority: 3),
  (&Type: otBinary; &Operator: opDivide; Literal: ['/']; Priority: 3),
  (&Type: otBinary; &Operator: opModulo; Literal: ['%','mod']; Priority: 3),
  (&Type: otBinary; &Operator: opGreater; Literal: ['>']; Priority: 5),
  (&Type: otBinary; &Operator: opGreaterEqual; Literal: ['>=']; Priority: 5),
  (&Type: otBinary; &Operator: opLess; Literal: ['<']; Priority: 5),
  (&Type: otBinary; &Operator: opLessEqual; Literal: ['<=']; Priority: 5),
  (&Type: otBinary; &Operator: opAND; Literal: ['&&','and']; Priority: 1),
  (&Type: otBinary; &Operator: opOR; Literal: ['||','or']; Priority: 1),
  (&Type: otUnary; &Operator: opNOT; Literal: ['!','not']; Priority: 2),
  (&Type: otUnary; &Operator: opFunction; Literal: ['']; Priority: 5),
  (&Type: otUnary; &Operator: opWhere; Literal: ['where']; Priority: 7),
  (&Type: otUnary; &Operator: opSome; Literal: ['some']; Priority: 8),
  (&Type: otUnary; &Operator: opAny; Literal: ['any']; Priority: 8),
  (&Type: otUnary; &Operator: opAllow; Literal: ['allow']; Priority: 5),
  (&Type: otUnary; &Operator: opDeny; Literal: ['deny']; Priority: 5),
  (&Type: otUnary; &Operator: opIndeterminate; Literal: ['indeterminate']; Priority: 5),
  (&Type: otUnary; &Operator: opEffect; Literal: ['eft']; Priority: 5),
  (&Type: otUnary; &Operator: opPriority; Literal: ['priority']; Priority: 5)
  );

implementation

end.
