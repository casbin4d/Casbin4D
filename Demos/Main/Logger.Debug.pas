unit Logger.Debug;

interface

uses
  Casbin.Core.Logger.Base, LogWindow;

type
  TLogDebug = class (TBaseLogger)
  private
    fForm: TFormLog;
  public
    constructor Create(const aForm: TFormLog);

    procedure log(const aMessage: string); override;
  end;


implementation

uses
  System.classes, System.SysUtils;

constructor TLogDebug.Create(const aForm: TFormLog);
begin
  inherited Create;
  fForm:=aForm;
  fEnabled:=true;
  fEnableConsole:=false;
end;

procedure TLogDebug.log(const aMessage: string);
begin
  inherited;
  if Trim(aMessage) <> '' then
    TThread.Queue(nil, procedure
                           begin
                             with fForm.lbLog do
                             begin
                               BeginUpdate;
                               Items.Insert(0, aMessage);
                               EndUpdate;
                               Repaint;
                             end;
                           end);
end;

end.
