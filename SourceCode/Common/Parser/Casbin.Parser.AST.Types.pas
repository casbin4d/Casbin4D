unit Casbin.Parser.AST.Types;

interface

uses
  Casbin.Model.Sections.Types, System.Generics.Collections;

type
  TBaseNode = class;
  TNodeCollection = class;
  THeaderNode = class;

  TBaseNode = class
  private
    fValue: string;
  public
    function toOutputString: string; virtual; abstract;

    property Value: string read fValue write fValue;
  end;

  TNodeCollection = class
  private
    fHeaders: TObjectList<THeaderNode>;
  public
    constructor Create;
    destructor Destroy; override;
    property Headers: TObjectList<THeaderNode> read fHeaders write fHeaders;
  end;

  THeaderNode = class (TBaseNode)
  private
    fSectionType: TSectionType;
  public
    property SectionType: TSectionType read fSectionType write fSectionType;
  end;

implementation

constructor TNodeCollection.Create;
begin
  inherited;
  fHeaders:=TObjectList<THeaderNode>.Create;
end;

destructor TNodeCollection.Destroy;
begin
  fHeaders.Free;
  inherited;
end;

end.
