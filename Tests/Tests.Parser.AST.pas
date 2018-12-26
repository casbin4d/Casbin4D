unit Tests.Parser.AST;

interface
uses
  DUnitX.TestFramework, Casbin.Parser.AST.Types, Casbin.Effect.Types;

type

  [TestFixture]
  TTestParserAST = class(TObject)
  private
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;

    [Test]
    procedure testRequest;

    [Test]
    procedure testPolicyDefinition;

    [Test]
    procedure testPolicyRules;

    [Test]
    procedure testMatchers;

    [Test]
    [TestCase('ecSomeAllow','e=some(where(p.eft==allow))#ecSomeAllow','#')]
    [TestCase('ecNotSomeDeny','e=!some(where(p.eft==deny))#ecNotSomeDeny','#')]
    [TestCase('ecSomeAllowANDNotDeny','e=some(where(p.eft==allow))&&!some(where(p.eft==deny))#'+
                                  'ecSomeAllowANDNotDeny','#')]
    [TestCase('ecPriorityORDeny','e=priority(p.eft)||deny#ecPriorityORDeny','#')]
    [TestCase('ecUnknown','e=a new type#ecUnknown','#')]
    procedure testEffects(const aInput: string; const aResult: TEffectCondition);
  end;

implementation

uses
  Casbin.Parser.AST, Casbin.Model.Sections.Types, Winapi.Windows;

procedure TTestParserAST.Setup;
begin
end;

procedure TTestParserAST.TearDown;
begin
end;

procedure TTestParserAST.testMatchers;
var
  header: THeaderNode;
 begin
  header:=THeaderNode.Create;
  header.SectionType:=stMatchers;
  addAssertion(header, 'm=r.sub==p.sub&&r.act==p.act');
  Assert.IsTrue(header.ChildNodes.Count = 1);

  Assert.AreEqual('m', header.ChildNodes.Items[0].Key);
  Assert.AreEqual('r.sub==p.sub&&r.act==p.act', header.ChildNodes.Items[0].Value);

  header.Free;
end;

procedure TTestParserAST.testPolicyDefinition;
var
  header: THeaderNode;
begin
  header:=THeaderNode.Create;
  header.SectionType:=stPolicyDefinition;
  addAssertion(header, 'p=sub,obj,act');
  Assert.IsTrue(header.ChildNodes.Count = 3);

  Assert.AreEqual('p', header.ChildNodes.Items[0].Key);
  Assert.AreEqual('sub', header.ChildNodes.Items[0].Value);

  Assert.AreEqual('p', header.ChildNodes.Items[1].Key);
  Assert.AreEqual('obj', header.ChildNodes.Items[1].Value);

  Assert.AreEqual('p', header.ChildNodes.Items[2].Key);
  Assert.AreEqual('act', header.ChildNodes.Items[2].Value);

  header.Free;
end;

procedure TTestParserAST.testPolicyRules;
var
  header: THeaderNode;
begin
  header:=THeaderNode.Create;
  header.SectionType:=stPolicyRules;
  addAssertion(header, 'p,alice,data1,read');
  Assert.IsTrue(header.ChildNodes.Count = 3);

  Assert.AreEqual('p', header.ChildNodes.Items[0].Key);
  Assert.AreEqual('alice', header.ChildNodes.Items[0].Value);

  Assert.AreEqual('p', header.ChildNodes.Items[1].Key);
  Assert.AreEqual('data1', header.ChildNodes.Items[1].Value);

  Assert.AreEqual('p', header.ChildNodes.Items[2].Key);
  Assert.AreEqual('read', header.ChildNodes.Items[2].Value);

  header.Free;
end;

procedure TTestParserAST.testRequest;
var
  header: THeaderNode;
begin
  header:=THeaderNode.Create;
  header.SectionType:=stRequestDefinition;
  addAssertion(header, 'r=sub,obj,act');
  Assert.IsTrue(header.ChildNodes.Count = 3);

  Assert.AreEqual('r', header.ChildNodes.Items[0].Key);
  Assert.AreEqual('sub', header.ChildNodes.Items[0].Value);

  Assert.AreEqual('r', header.ChildNodes.Items[1].Key);
  Assert.AreEqual('obj', header.ChildNodes.Items[1].Value);

  Assert.AreEqual('r', header.ChildNodes.Items[2].Key);
  Assert.AreEqual('act', header.ChildNodes.Items[2].Value);

{$IFDEF DEBUG}
  OutputDebugString(PChar(header.toOutputString));
{$ENDIF}

  header.Free;

end;

procedure TTestParserAST.testEffects(const aInput: string; const aResult:
    TEffectCondition);
var
  header: THeaderNode;
begin
  header:=THeaderNode.Create;
  header.SectionType:=stPolicyEffect;
  addAssertion(header, aInput);

  Assert.AreEqual(aResult,
                   (header.ChildNodes.Items[0] as TEffectNode).EffectCondition);

  header.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TTestParserAST);
end.
