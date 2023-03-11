// Copyright 2018 by John Kouraklis and Contributors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
unit Casbin.Policy.Types;

interface

uses
  Casbin.Core.Base.Types, Casbin.Model.Sections.Types,
  System.Generics.Collections, System.Rtti, System.Types,
  Casbin.Watcher.Types, Casbin.Adapter.Types, Casbin.Adapter.Policy.Types;

const
  DefaultDomain = 'default';

type
  TRoleNode = class
  private
    fDomain: string;
    fID: string;
    fValue: string;
  public
    constructor Create(const aValue: String; const aDomain: string = DefaultDomain);
    property Domain: string read fDomain;
    property Value: string read fValue;
    property ID: string read fID write fID;
  end;

  TRoleMode = (
    {$REGION 'Returns all the roles and those inferred by the policies'}
    /// <summary>
    ///   Returns all the roles and those inferred by the policies
    /// </summary>
    {$ENDREGION}
    rmImplicit,
    {$REGION 'Returns only the roles'}
    /// <summary>
    ///   Returns only the roles
    /// </summary>
    {$ENDREGION}
    rmNonImplicit);

  IPolicyManager = interface (IBaseInterface)
    ['{B983A830-6107-4283-A45D-D74CDBB5E2EA}']
    function section (const aSlim: Boolean = true): string;
    function toOutputString: string;
    function getAdapter: IPolicyAdapter;

    // Policies
    function policies: TList<string>;
    procedure addPolicy (const aSection: TSectionType; const aTag: string;
                              const aAssertion: string); overload;
    procedure addPolicy (const aSection: TSectionType;
                              const aAssertion: string); overload;
    procedure load (const aFilter: TFilterArray = []);
    function policy (const aFilter: TFilterArray = []): string;
    procedure clear;
    function policyExists (const aFilter: TFilterArray = []): Boolean;

    {$REGION ''}
    /// <param name="aRoleMode">
    ///   <para>
    ///     rmImplicit: Deletes all roles from both 'g' and 'p' sections
    ///   </para>
    ///   <para>
    ///     rmNonImplicit: Deletes roles only in 'g' sections
    ///   </para>
    /// </param>
    {$ENDREGION}
    procedure removePolicy (const aFilter: TFilterArray = [];
            const aRoleMode: TRoleMode = rmImplicit);

    // Roles
    procedure clearRoles;
    function roles: TList<string>;
    function domains: TList<string>;
    function roleExists (const aFilter: TFilterArray = []): Boolean;

    {$REGION 'Adds the inheritance link between two roles'}
    /// <summary>
    ///   Adds the inheritance link between two roles
    /// </summary>
    /// <example>
    ///   addLink(name1, name2) adds a link between role:name 1 and role: name2
    /// </example>
    {$ENDREGION}
    procedure addLink(const aBottom: string; const aTop: string); overload;
    procedure addLink(const aBottom: string;
                      const aTopDomain: string; const aTop: string); overload;
    {$REGION 'Adds the inheritance link between two roles by passign domains'}
    /// <summary>
    ///   Adds the inheritance link between two roles by passing domains
    /// </summary>
    /// <example>
    ///   addLink(domain1, name1, domain2, name2) adds a link between role:name
    ///   1 in domain1 and role: name2 in domain 2
    /// </example>
    {$ENDREGION}
    procedure addLink(const aBottomDomain: string; const aBottom: string;
                      const aTopDomain: string; const aTop: string); overload;
    procedure removeLink(const aLeft: string; const aRight: string); overload;
    procedure removeLink(const aLeft: string;
                      const aRightDomain: string; const aRight: string); overload;
    procedure removeLink(const aLeftDomain: string; const aLeft: string;
                      const aRightDomain: string; const aRight: string); overload;
    function linkExists(const aLeft: string; const aRight: string):boolean; overload;
    function linkExists(const aLeft: string;
                      const aRightDomain: string; const aRight: string):boolean; overload;
    function linkExists(const aLeftDomain: string; const aLeft: string;
                      const aRightDomain: string; const aRight: string):boolean; overload;

    function rolesForEntity(const aEntity: string; const aDomain: string = '';
        const aRoleMode: TRoleMode = rmNonImplicit): TStringDynArray;

    function entitiesForRole (const aEntity: string; const aDomain: string =''):TStringDynArray;

    // Watchers
    procedure registerWatcher (const aWatcher: IWatcher);
    procedure unregisterWatcher (const aWatcher: IWatcher);
    procedure notifyWatchers;

    // Permissions
    {$REGION ''}
    /// <remarks>
    ///   Assumes the last part of a policy (assertion) statement indicates the
    ///   permission
    /// </remarks>
    {$ENDREGION}
    function permissionsForEntity (const aEntity: string): TStringDynArray;
    function permissionExists (const aEntity: string; const aPermission: string):
                                                              Boolean;

    // Adapter
    property Adapter: IPolicyAdapter read getAdapter;

  end;

implementation

uses
  System.SysUtils;

constructor TRoleNode.Create(const aValue: String; const aDomain: string =
    DefaultDomain);
var
  guid: TGUID;
begin
  inherited Create;
  fValue:=Trim(aValue);
  fDomain:=Trim(aDomain);
  if CreateGUID(guid) <> 0 then
    fID:=GUIDToString(TGUID.Empty)
  else
    fID:=GUIDToString(guid);
end;

end.
