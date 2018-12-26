unit Casbin.Parser.AST;

interface

uses
  Casbin.Parser.AST.Types;

function addAssertion(const aLine: string): TExpressionNode;

implementation

uses
  Casbin.Parser.AST.Operators.Types, System.Generics.Collections, System.Generics.Defaults;

function sortOperators:  TArray<TOperatorRec>;
var
  opArray: TArray<TOperatorRec>;
  opRec: TOperatorRec;
  comparer: IComparer<TOperatorRec>;
begin
  for opRec in operatorsArray do
  begin
    SetLength(opArray, Length(opArray)+1);
    opArray[Length(opArray)-1]:=opRec;
  end;
  comparer:=TDelegatedComparer<TOperatorRec>.Create(
                function (const left, right: TOperatorRec): Integer
                begin
                  Result:=left.Priority - right.Priority;
                end);

  TArray.Sort<TOperatorRec>(opArray, comparer);
  Result:=opArray;
end;

function addAssertion(const aLine: string): TExpressionNode;
var
  assertStr: string;
  opArray: TArray<TOperatorRec>;
  opRec: TOperatorRec;
  litFound: boolean;
  litStr: string;
  litPosition: Integer;
  expNode: TExpressionNode;
  opIndex: Integer;
begin
  assertStr:=aLine;

  //Check Assignment
  opRec:= operatorsArray[opAssignment];
  opIndex:=-1;
  for litStr in opRec.Literal do
  begin
    if not litFound then
    begin
      litPosition:=Pos(litStr, assertStr, Low(string));
      litFound:= litPosition<>0;
      Inc(opIndex);
    end;
  end;

  if litFound then
  begin
    expNode:=TExpressionNode.Create(opAssignment);
    expNode.Identifier:=Copy(assertStr, Low(string), litPosition-1);

    Result:=expNode;
    assertStr:=Copy(assertStr, litPosition+Length(opRec.Literal[opIndex]), Length(assertStr));
    expNode.LeftChild:=addAssertion(assertStr);
  end
  else
  begin
    expNode:=TExpressionNode.Create(opAssignment);
    expNode.Identifier:=assertStr;
    Result:=expNode;
  end;

end;


end.
