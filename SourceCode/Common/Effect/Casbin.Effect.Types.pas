unit Casbin.Effect.Types;

interface

type
  TEffectResult = (erAllow, erIndeterminate, erDeny);
  TEffectCondition = (ecSomeAllow, ecNotSomeDeny, ecSomeAllowANDNotDeny,
                      ecPriorityORDeny, ecUnknown);
  TEffectArray = array of TEffectResult;

const
  effectConditions: array [0..7] of string =
    (('some(where(p.eft==allow))'), //Go-Style
     ('some(where(p.eft=allow))'),  //Delphi-Style
     ('!some(where(p.eft==deny))'), //Go-Style
     ('not(some(where(p.eft=deny)))'), //Delphi-Style
     ('some(where(p.eft==allow))&&!some(where(p.eft==deny))'),  //Go-Style
     ('some(where(p.eft=allow))and(not(some(where(p.eft=deny))))'),  //Delphi-Style
     ('priority(p.eft)||deny'), // Go-Style
     ('priority(p.eft)ordeny')); //Delphi-style

implementation

end.
