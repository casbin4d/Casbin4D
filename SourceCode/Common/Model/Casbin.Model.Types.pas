unit Casbin.Model.Types;

interface

uses
  Casbin.Core.Base.Types, Casbin.Model.Sections.Types,
  System.Generics.Collections, Casbin.Effect.Types;

type
  IModel = interface (IBaseInterface)
    ['{A1B8A09F-0562-4C15-B9F3-74537C5A9E27}']
    function section (const aSection: TSectionType;
                                        const aSlim: Boolean = true): string;
    {$REGION ''}
    /// <remarks>
    ///   The function instantiates the list
    ///   The consumer is responsible to free the list
    /// </remarks>
    {$ENDREGION}
    function assertions (const aSection: TSectionType): TList<string>;
    function effectCondition: TEffectCondition;
  end;

implementation

end.
