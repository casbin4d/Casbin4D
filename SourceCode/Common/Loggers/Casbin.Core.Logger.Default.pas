unit Casbin.Core.Logger.Default;

interface

uses
  Casbin.Core.Logger.Base;

type
  TDefaultLogger = class (TBaseLogger)
  public
    procedure log(const aMessage: string); override;
  end;

implementation

{$IFDEF MSWINDOWS}
uses
  Winapi.Windows;
{$ENDIF}

{ TDefaultLogger }

procedure TDefaultLogger.log(const aMessage: string);
begin
  inherited;
{$IFDEF MSWINDOWS}
{$IFDEF DEBUG}
  OutputDebugString(PChar(aMessage));
{$ENDIF}
{$ENDIF}
end;

end.
