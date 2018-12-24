unit Parser.Config.Types;

interface

uses
  Core.Base.Types, Core.Logger.Types;

type
  IParserConfig = interface (IBaseInterface)
    ['{A5F84A24-68D5-48B7-B10E-1E9AF8661651}']
    function getAssignmentChar: Char;
    function getAutoAssignSections: boolean;
    function getRespectSpacesInValues: boolean;
    procedure setAssignmentChar(const aValue: Char);
    procedure setAutoAssignSections(const aValue: boolean);
    procedure setRespectSpacesInValues(const aValue: boolean);

    {$REGION 'This defines which character will be used to set the key-values in different situations. See examples'}
    /// <summary>
    ///   <para>
    ///     This defines which character will be used to set the key-values
    ///     in different situations.
    ///   </para>
    ///   <para>
    ///     See examples
    ///   </para>
    /// </summary>
    /// <remarks>
    ///   This character refers to the first occurrence of the character
    /// </remarks>
    /// <example>
    ///   <para>
    ///     In the Model file, the Assignment Char should be '='.
    ///   </para>
    ///   <para>
    ///     In Policy files, it should be ','.
    ///   </para>
    /// </example>
    {$ENDREGION}
    property AssignmentChar: Char read getAssignmentChar write setAssignmentChar;
    property AutoAssignSections: boolean read getAutoAssignSections write
        setAutoAssignSections;
    property RespectSpacesInValues: boolean read getRespectSpacesInValues write
        setRespectSpacesInValues;
  end;

implementation

end.
