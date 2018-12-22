unit Core.Logger.Base;

interface

uses
  Core.Base.Types, Core.Logger.Types;

type
  {$REGION 'This is the base logger class. It does not do anything. You can expand the functionality by subclassing this one'}
  /// <summary>
  ///   <para>
  ///     This is the base logger class. It does not do anything.
  ///   </para>
  ///   <para>
  ///     You can expand the functionality by subclassing this one
  ///   </para>
  /// </summary>
  {$ENDREGION}
  TBaseLogger = class (TBaseInterfacedObject, ILogger)
  private
    fEnabled: Boolean;
{$REGION 'Interface'}
    function getEnabled: Boolean;
    function getLastLoggedMessage: string;
    procedure setEnabled(const aValue: Boolean);
{$ENDREGION}
  protected
    fLastLoggedMessage: string;
  public
{$REGION 'Interface'}
    procedure log(const aMessage: string);
{$ENDREGION}
  public
    constructor Create;
  end;

implementation

uses
  System.SysUtils;

constructor TBaseLogger.Create;
begin
  inherited;
  fEnabled:=True;
end;

{ TBaseLogger }

function TBaseLogger.getEnabled: Boolean;
begin
  result:=fEnabled;
end;

function TBaseLogger.getLastLoggedMessage: string;
begin
  Result:=fLastLoggedMessage;
end;

procedure TBaseLogger.log(const aMessage: string);
begin
  if not fEnabled then
    Exit;
  fLastLoggedMessage:=trim(aMessage);
end;

procedure TBaseLogger.setEnabled(const aValue: Boolean);
begin
  fEnabled:=aValue;
  fLastLoggedMessage:='';
end;

end.
