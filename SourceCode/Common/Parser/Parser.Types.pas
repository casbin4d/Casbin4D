unit Parser.Types;

interface

uses
  Core.Base.Types, Core.Logger.Types, Parser.Config.Types, Parser.Messages,
  System.Generics.Collections, Model.Sections.Types;

type
  IParser = interface (IBaseInterface)
    ['{0BF6EA37-52C7-4C0A-8B8E-78668F14B73B}']
    function getConfig: IParserConfig;
    function getLogger: ILogger;
    function getMessages: TObjectList<TParserMessage>;
    function getSections: TObjectList<TSection>;
    procedure setConfig(const aValue: IParserConfig);
    procedure setLogger(const aValue: ILogger);
    procedure parse;
    procedure setSections(const aValue: TObjectList<TSection>);

    property Config: IParserConfig read getConfig write setConfig;
    property Logger: ILogger read getLogger write setLogger;
    property Messages: TObjectList<TParserMessage> read getMessages;
    property Sections: TObjectList<TSection> read getSections write setSections;
  end;

implementation

end.
