unit Casbin.Model.Sections.Types;

interface

uses
  Casbin.Core.Base.Types, System.Types;

type
  TSectionType = (stRequestDefinition, stPolicyDefinition,
                  stRoleDefinition,
                  stPolicyEffect, stMatchers,
                  stUnknown);

  {$REGION 'Determines a section in the configuration files'}
  /// <summary>
  ///   Determines a section in the configuration files
  /// </summary>
  {$ENDREGION}
  TSection = class (TBaseObject)
  private
    fType: TSectionType;
    fEnforceTag: boolean;
    fHeader: string;
    fRequired: boolean;
    fTag: TStringDynArray;
  public
    {$REGION 'If True, then the assignment of assertions in each section should usethe default ''r,p,g,g2,e,m'''}
    /// <summary>
    ///   If True, then the assignment of assertions in each section should
    ///   usethe default 'r,p,g,g2,e,m'
    /// </summary>
    {$ENDREGION}
    property EnforceTag: boolean read fEnforceTag write fEnforceTag;
    {$REGION 'The string that defines the sections in the files'}
    /// <summary>
    ///   The string that defines the sections in the files
    /// </summary>
    {$ENDREGION}
    property Header: string read fHeader write fHeader;
    {$REGION 'Determines if the section is mandatory or optional'}
    /// <summary>
    ///   Determines if the section is mandatory or optional
    /// </summary>
    /// <remarks>
    ///   The only optional section is role_definition
    /// </remarks>
    {$ENDREGION}
    property Required: boolean read fRequired write fRequired;
    {$REGION 'The tag to be used in the key=value assertions'}
    /// <summary>
    ///   The tag to be used in the key=value assertions
    /// </summary>
    /// <remarks>
    ///   The default are: r,p,g,g2,e,m
    /// </remarks>
    {$ENDREGION}
    property Tag: TStringDynArray read fTag write fTag;
    property &Type: TSectionType read fType write fType;
  end;

implementation

end.
