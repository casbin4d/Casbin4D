unit Casbin.Watcher.Types;

interface

uses
  Casbin.Core.Base.Types;

type
  IWatcher = interface (IBaseInterface)
    ['{2166B5C3-2B57-423D-9F0A-3A35B35F9DA0}']
    procedure update;
  end;

implementation

end.
