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
  Result:=True;
  case aEffectCondition of
    ecSomeAllow: begin
                   Result:=False;
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
                     for effect in aEffects do
                     begin
                       if effect = erDeny then
                       begin
                         Result:=false;
                         Exit;
                       end;
                     end;
                   end;

    ecSomeAllowANDNotDeny: begin
                             Result:=False;
                             for effect in aEffects do
                             begin
                               if effect = erAllow then
                                 Result:=True
                               else
                               if effect = erDeny then
                               begin
                                 Result:=false;
                                 Exit;
                               end;
                             end;
                           end;

    ecPriorityORDeny: begin
                        Result:=False;
                        for effect in aEffects do
                        begin
                          if effect <> erIndeterminate then
                          begin
                            Result:= effect = erAllow;
                            Exit;
                          end;
                        end;
                      end;

    ecUnknown: result:=False;
  end;
end;

end.
