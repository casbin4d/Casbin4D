// Copyright 2018 The Casbin Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
unit Tests.Matcher;

interface
uses
  DUnitX.TestFramework, Casbin.Matcher.Types, Casbin.Effect.Types;

type

  [TestFixture]
  TTestMatcher = class(TObject)
  private
    fMatcher: IMatcher;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('Common-Go.1','john==john && kour==kour && m==m#erAllow', '#')]
    [TestCase('Common-Go.2','john==alice && kour==kour && m==m#erDeny', '#')]
    [TestCase('Common-Delphi.1','john==john and kour=kour and m=m#erAllow', '#')]
    [TestCase('Common-Delphi.2','kour=kour or !(root=root)#erAllow', '#')]
    [TestCase('Remove apostrophe','john==john and ''kour''=''kour'' and m=m#erAllow', '#')]
    [TestCase('Expression With Spaces','john ==john   and ''kour''= ''kour'' and m=m#erAllow', '#')]
    [TestCase('1 part.1-Allow','john==john#erAllow', '#')]
    [TestCase('1 part.2-Deny','john==alice#erDeny', '#')]
    [TestCase('2 parts.1-Deny','alice==kour and john=john#erDeny', '#')]
    procedure testMatcher(const aExpression: string; const aExpected:
        TEffectResult);
  end;

implementation

uses
  Casbin.Matcher;

procedure TTestMatcher.Setup;
begin
  fMatcher:=TMatcher.Create;
  fMatcher.addIdentifier('john');
  fMatcher.addIdentifier('alice');
  fMatcher.addIdentifier('kour');
  fMatcher.addIdentifier('m');
end;

procedure TTestMatcher.TearDown;
begin
end;

procedure TTestMatcher.testMatcher(const aExpression: string; const aExpected:
    TEffectResult);
begin
  Assert.AreEqual(aExpected, fMatcher.evaluateMatcher(aExpression));
end;

initialization
  TDUnitX.RegisterTestFixture(TTestMatcher);
end.
