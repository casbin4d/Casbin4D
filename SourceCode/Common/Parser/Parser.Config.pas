unit Parser.Config;

interface

uses
  Core.Base.Types, Parser.Config.Types;

type
  TParserConfig = class (TBaseInterfacedObject, IParserConfig)
  private
    fAssignmentChar: Char;
    fAutoAssignSections: Boolean;
    fRespectSpacesInValues: Boolean;
  private
{$REGION 'Interface'}
    function getAssignmentChar: Char;
    function getAutoAssignSections: boolean;
    function getRespectSpacesInValues: boolean;
    procedure setAssignmentChar(const aValue: Char);
    procedure setAutoAssignSections(const aValue: boolean);
    procedure setRespectSpacesInValues(const aValue: boolean);
{$ENDREGION}
  public
    constructor Create;
  end;

implementation

constructor TParserConfig.Create;
begin
  inherited;
  fAssignmentChar:='=';
  fAutoAssignSections:=False;
  fRespectSpacesInValues:=False;
end;

{ TParserConfig }

function TParserConfig.getAssignmentChar: Char;
begin
  Result:=fAssignmentChar;
end;

function TParserConfig.getAutoAssignSections: boolean;
begin
  Result:=fAutoAssignSections;
end;

function TParserConfig.getRespectSpacesInValues: boolean;
begin
  Result:=fRespectSpacesInValues;
end;

procedure TParserConfig.setAssignmentChar(const aValue: Char);
begin
  fAssignmentChar:=aValue;
end;

procedure TParserConfig.setAutoAssignSections(const aValue: boolean);
begin
  fAutoAssignSections:=aValue;
end;

procedure TParserConfig.setRespectSpacesInValues(const aValue: boolean);
begin
  fRespectSpacesInValues:=aValue;
end;

end.
