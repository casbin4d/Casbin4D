unit Casbin.Functions.Types;

interface

uses
  Casbin.Core.Base.Types;

type
  TCasbinFunc = function (const Args: array of string): Boolean;

  IFunctions = interface (IBaseInterface)
    ['{1AF251A3-A0DE-4FB5-B49E-C46E3D8726AE}']
    procedure registerFunction (const aName: string;
                                  const aFunc: TCasbinFunc);
    function retrieveFunction(const aName: string): TCasbinFunc;
  end;

implementation

end.
