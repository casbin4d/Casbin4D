unit Parser.Types;

interface

uses
  Core.Base.Types, Core.Logger.Types, Parser.Config.Types, Parser.Messages,
  System.Generics.Collections, Model.Sections.Types;

type
  TParserStatus = (psNotStarted, psRunning, psError, psFinished);
  IParser = interface (IBaseInterface)
    ['{0BF6EA37-52C7-4C0A-8B8E-78668F14B73B}']
    function getConfig: IParserConfig;
    function getLogger: ILogger;
    function getMessages: TObjectList<TParserMessage>;
    function getSections: TObjectList<TSection>;
    function getStatus: TParserStatus;
    procedure setConfig(const aValue: IParserConfig);
    procedure setLogger(const aValue: ILogger);
    procedure parse;
    function toOutputString: string;
    procedure setSections(const aValue: TObjectList<TSection>);

    property Config: IParserConfig read getConfig write setConfig;
    property Logger: ILogger read getLogger write setLogger;
    property Messages: TObjectList<TParserMessage> read getMessages;
    property Sections: TObjectList<TSection> read getSections write setSections;
    property Status: TParserStatus read getStatus;
  end;

implementation

end.
