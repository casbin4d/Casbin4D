unit Casbin.Adapter.Policy.Types;

interface

uses
  Casbin.Adapter.Types;

type
  IPolicyAdapter = interface (IAdapter)
    ['{56990FAD-9212-4169-8A94-D55039D1F403}']
    function getAutoSave: Boolean;
    function getCached: boolean;
    procedure setAutoSave(const aValue: Boolean);
    procedure setCached(const aValue: boolean);

    procedure add (const aTag: string);
    function getCacheSize: Integer;

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
    procedure setCacheSize(const aValue: Integer);

    property AutoSave: Boolean read getAutoSave write setAutoSave;
    property Cached: boolean read getCached write setCached;
    property CacheSize: Integer read getCacheSize write setCacheSize;
  end;

const
  DefaultCacheSize = 15;

implementation

end.
