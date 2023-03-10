// Copyright 2018 by John Kouraklis and Contributors. All Rights Reserved.
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
unit Casbin.Adapter.Base;

interface

uses
  Casbin.Core.Base.Types, Casbin.Adapter.Types, Casbin.Core.Logger.Types,
  System.Generics.Collections;

type
  {$REGION 'This is the base class for all Adapters'}
  /// <summary>
  ///   This is the base class for all Adapters
  /// </summary>
  /// <remarks>
  ///   <para>
  ///     Subclass this if you want to create a generic adapter.
  ///   </para>
  /// </remarks>
  {$ENDREGION}
  TBaseAdapter = class (TBaseInterfacedObject, IAdapter)
  private
    fLogger: ILogger;
    fAssertions: TList<string>;
  protected
    fFiltered: Boolean;   //PALOFF
    fFilter: TFilterArray;  //PALOFF
  protected
{$REGION 'Interface'}
    function getAssertions: TList<string>;
    function getLogger: ILogger; virtual;  //PALOFF
    function getFilter: TFilterArray;
    procedure load(const aFilter: TFilterArray); virtual;
    procedure save; virtual; abstract;
    procedure setAssertions(const aValue: TList<string>); virtual;
    procedure setLogger(const aValue: ILogger);
    function toOutputString: string; virtual;   //PALOFF
    procedure clear;
    function getFiltered: boolean;
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  Casbin.Core.Logger.Default;

procedure TBaseAdapter.clear;
begin
  fAssertions.Clear;
end;

constructor TBaseAdapter.Create;
begin
  inherited;
  fAssertions:=TList<string>.Create;
  fLogger:=TDefaultLogger.Create;
  fFiltered:=False;
end;

destructor TBaseAdapter.Destroy;
begin
  fAssertions.Free;
  inherited;
end;

function TBaseAdapter.getAssertions: TList<string>;
begin
  Result:=fAssertions;
end;

function TBaseAdapter.getFilter: TFilterArray;
begin
  Result:=fFilter;
end;

function TBaseAdapter.getFiltered: boolean;
begin
  Result:=fFiltered;
end;

function TBaseAdapter.getLogger: ILogger;
begin
  Result:=fLogger;
end;

procedure TBaseAdapter.load(const aFilter: TFilterArray);
begin
  SetLength(fFilter, 0);
  for var str in aFilter do
  begin
    SetLength(fFilter, Length(fFilter) + 1);
    fFilter[Length(fFilter) - 1]:=str;
  end;
  fFiltered:= Length(fFilter) <> 0;
end;

procedure TBaseAdapter.setAssertions(const aValue: TList<string>);
begin
  fAssertions.Clear;
  for var str in aValue do
    fAssertions.Add(str);
end;

procedure TBaseAdapter.setLogger(const aValue: ILogger);
begin
  fLogger:=nil;
  if Assigned(aValue) then
    fLogger:=aValue
  else
    fLogger:=TDefaultLogger.Create;
end;

function TBaseAdapter.toOutputString: string;
var
  item: string;
begin
  result:='';
  for item in fAssertions do
    Result:=Result+item+sLineBreak;
end;

end.
