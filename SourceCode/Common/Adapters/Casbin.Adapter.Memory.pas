unit Casbin.Adapter.Memory;

interface

uses
  Casbin.Core.Base.Types, Casbin.Adapter.Base, System.Classes;

type
  TMemoryAdapter = class(TBaseAdapter)
  private
    procedure resetSection;
  protected
    fContent: TStringList;
   public
    constructor Create; overload;
    destructor Destroy; override;
    procedure load(const aFilter: TFilterArray); override;
    procedure save; override;
  end;

implementation

constructor TMemoryAdapter.Create;
begin
  inherited;
  fContent:=TStringList.Create;
  resetSection;
end;

destructor TMemoryAdapter.Destroy;
begin
  fContent.Free;
  inherited;
end;

procedure TMemoryAdapter.load(const aFilter: TFilterArray);
begin
  inherited;
  resetSection;
  clear;
  getAssertions.AddRange(fContent.ToStringArray);
end;

procedure TMemoryAdapter.save;
begin
  inherited;
end;

procedure TMemoryAdapter.resetSection;
begin
  if fContent.Count=0 then
  begin
    fContent.Add('[request_definition]');
    fContent.Add('[policy_definition]');
    fContent.Add('[role_definition]');
    fContent.Add('[policy_effect]');
    fContent.Add('[matchers]');
  end;
end;

end.
