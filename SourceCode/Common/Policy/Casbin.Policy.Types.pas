unit Casbin.Policy.Types;

interface

uses
  Casbin.Core.Base.Types, Casbin.Model.Sections.Types, System.Generics.Collections;

type
  IPolicy = interface (IBaseInterface)
    ['{B983A830-6107-4283-A45D-D74CDBB5E2EA}']
    function section (const aSlim: Boolean = true): string;

    {$REGION ''}
    /// <remarks>
    ///   The function instantiates the list
    ///   The consumer is responsible to free the list
    /// </remarks>
    {$ENDREGION}
    function policies: TList<string>;

    procedure add (const aTag: string);
    procedure clear;
    function policyExists (const aFilter: TFilterArray = []): Boolean;
    {$REGION 'Removes a policy rule from the adapter'}
    /// <summary>
    ///   Removes a policy rule from the adapter
    /// </summary>
    /// <param name="aPolicyDefinition">
    ///   The tag of the policy (e.g. p, g, g2)
    /// </param>
    /// <example>
    ///   <list type="bullet">
    ///     <item>
    ///       <font color="#2A2A2A">remove ('p')</font>
    ///     </item>
    ///   </list>
    /// </example>
    {$ENDREGION}
    procedure remove (const aPolicyDefinition: string); overload;

    {$REGION 'Removes a policy rule from the adapter'}
    /// <summary>
    ///   Removes a policy rule from the adapter
    /// </summary>
    /// <param name="aPolicyDefinition">
    ///   The definition of the policy (e.g. p=sub, act)
    /// </param>
    /// <param name="aFilter">
    ///   It can contain the tag of the rule (e.g. 'p') or a filter.The filter
    ///   should be assigned to an object as defined in the model (Policy)
    ///   using the assign operator <br />
    /// </param>
    /// <example>
    ///   <list type="bullet">
    ///     <item>
    ///       <font color="#2A2A2A">remove ('p')</font>
    ///     </item>
    ///     <item>
    ///       <font color="#2A2A2A">remove ('sub=john')</font>
    ///     </item>
    ///     <item>
    ///       <font color="#2A2A2A">remove ('domain=network*')</font>
    ///     </item>
    ///   </list>
    /// </example>
    {$ENDREGION}
    procedure remove (const aPolicyDefinition: string; const aFilter: string); overload;
  end;

implementation

end.
