unit Casbin.Adapter.Base;

interface

uses
  Casbin.Core.Base.Types, Casbin.Adapter.Types, Casbin.Core.Logger.Types, System.Generics.Collections;

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
{$REGION 'Interface'}
    function getAssertions: TList<string>;
    function getLogger: ILogger; virtual;
    procedure load(const aFilter: string); virtual; abstract;
    procedure save; virtual; abstract;
    procedure setAssertions(const aValue: TList<string>); virtual;
    procedure setLogger(const aValue: ILogger);
    function toOutputString: string; virtual;
{$ENDREGION}
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  Casbin.Core.Logger.Default;

constructor TBaseAdapter.Create;
begin
  inherited;
  fAssertions:=TList<string>.Create;
  fLogger:=TDefaultLogger.Create;
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

function TBaseAdapter.getLogger: ILogger;
begin
  Result:=fLogger;
end;

procedure TBaseAdapter.setAssertions(const aValue: TList<string>);
begin
  fAssertions:=aValue;
end;

procedure TBaseAdapter.setLogger(const aValue: ILogger);
begin
  if Assigned(aValue) then
  begin
    fLogger:=nil;
    fLogger:=aValue;
  end
  else
    fLogger:=TDefaultLogger.Create;
end;

function TBaseAdapter.toOutputString: string;
var
  item: string;
begin
  for item in fAssertions do
    Result:=Result+item+sLineBreak;
end;

end.
