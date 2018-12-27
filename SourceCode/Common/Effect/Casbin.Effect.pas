unit Casbin.Effect;

interface

uses
  Casbin.Effect.Types;

function mergeEffects(const aEffectCondition: TEffectCondition;
  const aEffects: TEffectArray): Boolean;

implementation

function mergeEffects(const aEffectCondition: TEffectCondition;
  const aEffects: TEffectArray): Boolean;
var
  effect: TEffectResult;
begin
  Result:=False;
  case aEffectCondition of
    ecSomeAllow: begin
                   for effect in aEffects do
                   begin
                     if effect = erAllow then
                     begin
                       Result:=True;
                       Exit;
                     end;
                   end;
                 end;

    ecNotSomeDeny: begin
                     Result:=True;
                     if effect = erDeny then
                     begin
                       Result:=false;
                       Exit;
                     end;
                   end;

    ecSomeAllowANDNotDeny: begin
                             if effect = erAllow then
                              Result:=True
                             else
                             if effect = erDeny then
                             begin
                               Result:=false;
                               Exit;
                             end;
                           end;

    ecPriorityORDeny: begin
                        if effect <> erIndeterminate then
                        begin
                          Result:= effect = erAllow;
                          Exit;
                        end;
                      end;

    ecUnknown: result:=False;
  end;
end;

end.
