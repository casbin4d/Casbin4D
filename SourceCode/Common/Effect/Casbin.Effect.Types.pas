unit Casbin.Effect.Types;

interface

type
  TEffectResult = (erAllow, erIndeterminate, erDeny);
  TEffectCondition = (ecSomeAllow, ecNotSomeDeny, ecSomeAllowANDNotDeny,
                      ecPriorityORDeny, ecUnknown);

const
  effectConditions: array [0..3] of string =
    (('some(where(p.eft==allow))'),
     ('!some(where(p.eft==deny))'),
     ('some(where(p.eft==allow))&&!some(where(p.eft==deny))'),
     ('priority(p.eft)||deny'));

implementation

end.
