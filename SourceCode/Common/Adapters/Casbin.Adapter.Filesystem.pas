unit Casbin.Adapter.Filesystem;

interface

uses
  Casbin.Adapter.Base;

type
  TFileAdapter = class(TBaseAdapter)
  private
    fFilename: string;
  public
    constructor Create(const aFilename: string);
    procedure load(const aFilter: string = ''); override;
    procedure save; override;
  end;

implementation

uses
  System.SysUtils, System.Generics.Collections, System.IOUtils, System.Types;

constructor TFileAdapter.Create(const aFilename: string);
begin
  if not fileExists(aFilename) then
    raise Exception.Create('File '+aFilename+' does not exist');
  inherited Create;
  fFilename:=aFilename;
end;

{ TFileAdapter }

procedure TFileAdapter.load(const aFilter: string);
begin
  inherited;
  getAssertions.AddRange(TFile.ReadAllLines(fFilename));
end;

procedure TFileAdapter.save;
begin
  inherited;
end;

end.
