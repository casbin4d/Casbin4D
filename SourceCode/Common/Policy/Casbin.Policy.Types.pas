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
  end;

implementation

end.
