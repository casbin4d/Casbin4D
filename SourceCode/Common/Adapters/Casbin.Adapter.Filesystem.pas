unit Casbin.Adapter.Filesystem;

interface

uses
  Casbin.Adapter.Base, Casbin.Core.Base.Types;

type
  TFileAdapter = class(TBaseAdapter)
  protected
    fFilename: string;
   public
    constructor Create(const aFilename: string); virtual;
    procedure load(const aFilter: TFilterArray); override;
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

procedure TFileAdapter.load(const aFilter: TFilterArray);
begin
  inherited;
  getAssertions.Clear;
  getAssertions.AddRange(TFile.ReadAllLines(fFilename));
end;

procedure TFileAdapter.save;
begin
  inherited;
end;

end.
