unit Tests.Model;

interface
uses
  DUnitX.TestFramework, Casbin.Model.Types, Casbin.Model.Sections.Types;

type
  [TestFixture]
  TTestModel = class(TObject)
  private
    fModel: IModel;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    [TestCase ('Request', 'stRequestDefinition')]
    [TestCase ('Policy_Definition', 'stPolicyDefinition')]
    [TestCase ('Effect', 'stPolicyEffect')]
    [TestCase ('Matcher', 'stMatchers')]
    procedure testSections (const aSection: TSectionType);

    [Test]
    [TestCase ('Request', 'stRequestDefinition')]
    [TestCase ('Policy_Definition', 'stPolicyDefinition')]
    [TestCase ('Effect', 'stPolicyEffect')]
    [TestCase ('Matcher', 'stMatchers')]
    procedure testAssertions (const aSection: TSectionType);

    [Test]
    procedure testEffect;
  end;

implementation

uses
  Casbin.Adapter.Filesystem, Casbin.Model, System.SysUtils,
  System.Generics.Collections, System.Classes, Casbin.Effect.Types;

procedure TTestModel.Setup;
begin
  fModel:=TModel.Create('..\..\..\Examples\Default\basic_model.conf');
end;

procedure TTestModel.TearDown;
begin
end;


procedure TTestModel.testAssertions(const aSection: TSectionType);
var
  list: TList<string>;
begin
  list:=fModel.assertions(aSection);
  case aSection of
    stRequestDefinition: begin
                           Assert.AreEqual(3, list.Count);
                           Assert.AreEqual('r.sub', Trim(list.Items[0]));
                           Assert.AreEqual('r.obj', Trim(list.Items[1]));
                           Assert.AreEqual('r.act', Trim(list.Items[2]));
                         end;
    stPolicyDefinition: begin
                           Assert.AreEqual(3, list.Count);
                           Assert.AreEqual('p.sub', Trim(list.Items[0]));
                           Assert.AreEqual('p.obj', Trim(list.Items[1]));
                           Assert.AreEqual('p.act', Trim(list.Items[2]));
                         end;
    stPolicyEffect: begin
                      Assert.AreEqual(1, list.Count);
                      Assert.AreEqual('some(where(p.eft==allow))', Trim(list.Items[0]));
                    end;
    stMatchers: begin
                  Assert.AreEqual(1, list.Count);
      Assert.AreEqual('r.sub == p.sub && r.obj == p.obj && r.act == p.act',
                                      Trim(list.Items[0]));
    end;
  end;
  list.Free;
end;

procedure TTestModel.testEffect;
begin
  Assert.AreEqual(ecSomeAllow, fModel.effectCondition);
end;

procedure TTestModel.testSections(const aSection: TSectionType);
var
  expected: string;
begin
  case aSection of
    stRequestDefinition: expected:= 'r=sub,obj,act';
    stPolicyDefinition: expected:= 'p=sub,obj,act';
    stPolicyEffect: expected:= 'e=some(where(p.eft==allow))';
    stMatchers: expected:=
                'm = r.sub == p.sub && r.obj == p.obj && r.act == p.act';
  end;
  Assert.AreEqual(trim(expected), Trim(fModel.Section(aSection)));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestModel);
end.
