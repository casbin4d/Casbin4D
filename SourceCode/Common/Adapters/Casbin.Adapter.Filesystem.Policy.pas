unit Casbin.Adapter.Filesystem.Policy;

interface

uses
  Casbin.Adapter.Filesystem, Casbin.Adapter.Policy.Types, Casbin.Core.Base.Types;

type
  TPolicyFileAdapter = class (TFileAdapter, IPolicyAdapter)
  private
    fCached: Boolean;
    fAutosave: Boolean;
    fCacheSize: Integer;
  protected
{$REGION 'IPolicyAdapter'}
    procedure add(const aTag: string);
    function getAutoSave: Boolean;
    function getCached: Boolean;

    procedure setAutoSave(const aValue: Boolean);
    procedure setCached(const aValue: Boolean);

    function getCacheSize: Integer;
    procedure setCacheSize(const aValue: Integer);
{$ENDREGION}
  public
{$REGION 'IAdapter'}
    procedure load(const aFilter: TFilterArray = []); override;
    procedure save; override;
{$ENDREGION}
{$REGION 'IPolicyAdapter'}
    procedure remove(const aPolicyDefinition: string); overload;
    procedure remove (const aPolicyDefinition: string; const aFilter: string); overload;
{$ENDREGION}
    constructor Create(const aFilename: string); override;
  end;

implementation

uses
  System.SysUtils, Casbin.Core.Utilities, System.Classes, System.Generics.Collections;

{ TPolicyFileAdapter }

procedure TPolicyFileAdapter.add(const aTag: string);
begin

end;

constructor TPolicyFileAdapter.Create(const aFilename: string);
begin
  inherited;
  fAutosave:=True;
  fCached:=False;
  fCacheSize:=DefaultCacheSize;
end;

function TPolicyFileAdapter.getAutoSave: Boolean;
begin
  Result:=fAutosave;
end;

function TPolicyFileAdapter.getCached: Boolean;
begin
  Result:=fCached;
end;

function TPolicyFileAdapter.getCacheSize: Integer;
begin
  Result:=fCacheSize;
end;

procedure TPolicyFileAdapter.load(const aFilter: TFilterArray);
var
  policy: string;
  filter: string;
  index: Integer;
  filteredArray: TStringList;
  match: Boolean;
  modifiedFilter: TList<string>;
begin
  // DO NOT CALL inherited
  // WE NEED TO MANAGE THE CACHE
  {TODO -oOwner -cGeneral : Implement Cache}
  inherited;
  if Length(aFilter)<>0 then
  begin
    modifiedFilter:=TList<string>.Create;
    for policy in aFilter do
      modifiedFilter.Add(Trim(policy));

    for policy in getAssertions do
    begin
      filteredArray:=TStringList.Create;
      filteredArray.Delimiter:=',';
      filteredArray.StrictDelimiter:=True;
      filteredArray.DelimitedText:=policy;

      if modifiedFilter.Count<=filteredArray.Count then
      begin
        match:= false;
        for index:=0 to modifiedFilter.Count-1 do
        begin
          match:=match and ((UpperCase(Trim(modifiedFilter[index])) =
                                (UpperCase(Trim(filteredArray[index])))));
        end;

        if match then
          getAssertions.Remove(policy);
      end;

      filteredArray.Free;
    end;
  end;
end;

procedure TPolicyFileAdapter.remove(const aPolicyDefinition, aFilter: string);
begin

end;

procedure TPolicyFileAdapter.remove(const aPolicyDefinition: string);
begin

end;

procedure TPolicyFileAdapter.save;
begin
  inherited;

end;

procedure TPolicyFileAdapter.setAutoSave(const aValue: Boolean);
begin
  fAutosave:=aValue;
end;

procedure TPolicyFileAdapter.setCached(const aValue: Boolean);
begin
  fCached:=aValue;
end;

procedure TPolicyFileAdapter.setCacheSize(const aValue: Integer);
begin
  fCacheSize:=aValue;
end;

end.
