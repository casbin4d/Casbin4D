unit Casbin.Matcher.Types;

interface

uses
  Casbin.Core.Base.Types, Casbin.Effect.Types;

type
  IMatcher = interface (IBaseInterface)
    ['{7870739A-B58D-4127-8F29-F04482D5FCF3}']
    function evaluateMatcher (const aMatcherString: string): TEffectResult;
    procedure clearIdentifiers;
    procedure addIdentifier (const aTag: string);
  end;

implementation

end.
