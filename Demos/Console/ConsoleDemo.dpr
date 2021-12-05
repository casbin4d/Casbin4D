program ConsoleDemo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Casbin.Types,
  Casbin,
  Casbin.Model.Sections.Types;

var
  casbin: ICasbin;

begin
  try
    casbin:=TCasbin.Create('..\..\rbac_with_deny_model.conf','');
    with casbin.Policy do
    begin
      addPolicy(stPolicyRules, 'p, applicationManager, user, add, allow');
      addPolicy(stPolicyRules, 'p, applicationManager, user, delete, allow');
      addPolicy(stPolicyRules, 'p, alice, user, delete, deny');
      addPolicy(stPolicyRules, 'g, alice, applicationManager');
      addPolicy(stPolicyRules, 'g, bob, applicationManager');
    end;

    Assert(casbin.enforce(['alice', 'user', 'add']) = true);
    Assert(casbin.enforce(['alice', 'user', 'delete']) = false);
    Assert(casbin.enforce(['bob', 'user', 'add']) = true);
    Assert(casbin.enforce(['bob', 'user', 'delete']) = True);

    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
