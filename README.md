Casbin4D
====

[![Made With Delphi](https://img.shields.io/badge/MADE%20WITH-DELPHI-red.svg)](<https://www.embarcadero.com/products/delphi>)
[![CodeCoverage](https://img.shields.io/badge/coverage-91%25-green.svg)]()
[![Version](https://img.shields.io/github/tag/casbin4D/casbin4D.svg?label=latest%20version&style=popout)]()
[![Discord](https://img.shields.io/discord/1022748306096537660?logo=discord&label=discord&color=5865F2)](https://discord.gg/S5UjpzGZjN)

![casbin Logo](https://github.com/casbin4d/Casbin4D/blob/master/Images/casbin4D-logo.png)

Casbin4D is a cross platform (FireMonkey) implementation for Delphi/Pascal of the popular authorisation library [Casbin](https://casbin.org). It provides support for enforcing authorization based on various [access control models](https://en.wikipedia.org/wiki/Computer_security_model).

<img style="float: left;" src="https://github.com/casbin4d/Casbin4D/blob/master/Images/Speaker-128x117.png">You are cordially invited to share, fork, review and improve this library.
Please feel free to comment and offer suggestions. If you want to contribute, check the wiki page for developers first

## All the languages supported by Casbin:

[![golang](https://casbin.org/img/langs/golang.png)](https://github.com/casbin/casbin) | [![java](https://casbin.org/img/langs/java.png)](https://github.com/casbin/jcasbin) | [![nodejs](https://casbin.org/img/langs/nodejs.png)](https://github.com/casbin/node-casbin) | [![php](https://casbin.org/img/langs/php.png)](https://github.com/php-casbin/php-casbin)
----|----|----|----
[Casbin](https://github.com/casbin/casbin) | [jCasbin](https://github.com/casbin/jcasbin) | [node-Casbin](https://github.com/casbin/node-casbin) | [PHP-Casbin](https://github.com/php-casbin/php-casbin)
production-ready | production-ready | production-ready | production-ready

[![python](https://casbin.org/img/langs/python.png)](https://github.com/casbin/pycasbin) | [![delphi](https://github.com/casbin4d/Casbin4D/blob/master/Images/Delphi.png)](https://github.com/casbin4d/Casbin4D) | [![dotnet](https://casbin.org/img/langs/dotnet.png)](https://github.com/Devolutions/casbin-net) | [![rust](https://casbin.org/img/langs/rust.png)](https://github.com/casbin/casbin-rs)
----|----|----|----
[PyCasbin](https://github.com/casbin/pycasbin) | [Casbin4D](https://github.com/casbin4d/Casbin4D) | [Casbin-Net](https://github.com/Devolutions/casbin-net) | [Casbin-RS](https://github.com/casbin/casbin-rs)
production-ready | experimental | production-ready | production-ready

## Table of contents

- [Supported models](#supported-models)
- [How it works](#how-it-works)
- [Features](#features)
- [Installation](#installation)
- [Documentation](#documentation)
- [Online editor](#online-editor)
- [Demos](#Demos)
- [Get started](#get-started)
- [Policy management](#policy-management)
- [Policy persistence](#policy-persistence)
- [Multi-threading](#multi-threading)
- [Benchmarks](#benchmarks)
- [Examples](#examples)
- [Tests](#tests)

## Supported models

1. [**ACL (Access Control List)**](https://en.wikipedia.org/wiki/Access_control_list)
2. **ACL with [superuser](https://en.wikipedia.org/wiki/Superuser)**
3. **ACL without users**: especially useful for systems that don't have authentication or user log-ins.
3. **ACL without resources**: some scenarios may target for a type of resources instead of an individual resource by using permissions like ``write-article``, ``read-log``. It doesn't control the access to a specific article or log.
4. **[RBAC (Role-Based Access Control)](https://en.wikipedia.org/wiki/Role-based_access_control)**
5. **RBAC with resource roles**: both users and resources can have roles (or groups) at the same time.
6. **RBAC with domains/tenants**: users can have different role sets for different domains/tenants.
7. **[ABAC (Attribute-Based Access Control)](https://en.wikipedia.org/wiki/Attribute-Based_Access_Control)**: syntax sugar like ``resource.Owner`` can be used to get the attribute for a resource.
8. **[RESTful](https://en.wikipedia.org/wiki/Representational_state_transfer)**: supports paths like ``/res/*``, ``/res/:id`` and HTTP methods like ``GET``, ``POST``, ``PUT``, ``DELETE``.
9. **Deny-override**: both allow and deny authorizations are supported, deny overrides the allow.
10. **Priority**: the policy rules can be prioritized like firewall rules.

## How it works

In Casbin, an access control model is abstracted into a CONF file based on the **PERM metamodel (Policy, Effect, Request, Matchers)**. So switching or upgrading the authorization mechanism for a project is just as simple as modifying a configuration. You can customize your own access control model by combining the available models. For example, you can get RBAC roles and ABAC attributes together inside one model and share one set of policy rules.

The most basic and simplest model in Casbin is ACL. ACL's model CONF looks like this:

```
# Request definition
[request_definition]
r = sub, obj, act

# Policy definition
[policy_definition]
p = sub, obj, act

# Policy effect
[policy_effect]
e = some(where (p.eft == allow))

# Matchers
[matchers]
m = r.sub == p.sub && r.obj == p.obj && r.act == p.act

```
The above configuration follows the Go language. 

Casbin4D understands it but you can also use the typical Delphi/Pascal style:

```
...
[matchers]
m = r.sub = p.sub and r.obj = p.sub and r.act = p.act
```

An example policy for ACL model is like:

```
p, alice, data1, read
p, bob, data2, write
```

For Casbin this means that:

- alice can read data1
- bob can write data2

Then, in your application instantiate a new Casbin (interfaced) object and pass the required files:
```
var
  casbin: ICasbin;
begin
  casbin:=TCasbin.Create ('model.conf', 'policies.csv');
  ...
end
```
and, finally, test (enforce) an assertion:
```
  ...
  if casbin.enforce(['alice,data1,read']) then
    // Alice is super happy as she can read data1
  else
    // Alice is sad
  ...
```


## Features

What Casbin does:

1. enforce the policy in the classic ``{subject, object, action}`` form or a customized form as you defined, both allow and deny authorizations are supported.
2. manage the role-user mappings and role-role mappings (aka role hierarchy in RBAC).
3. support built-in superuser like ``root`` or ``administrator``. A superuser can do anything without explict permissions.
4. multiple built-in operators to support the rule matching. For example, ``keyMatch`` can map a resource key ``/foo/bar`` to the pattern ``/foo*``

What Casbin does NOT do:

1. authentication (aka verify ``username`` and ``password`` when a user logs in)
2. manage the list of users or roles. This is left to the application that uses Casbin. Keep in mind that Casbin is not designed as a password container. However, Casbin stores the user-role mapping for the RBAC scenario 

## Installation

Casbin4D comes in a package (currently for Delphi 10.3 Rio) and you can install it in the IDE. However, there are no visual components which means that you can use the units independently of packages. Just import the units in your project (assuming you do not mind the number of them)

## Documentation

Please see the [wiki pages](<https://github.com/casbin4d/Casbin4D/wiki>)

## Online editor

You can also use the online editor (http://casbin.org/editor/) to write your Casbin model and policy in your web browser. It provides functionality such as ``syntax highlighting`` and ``code completion``, just like an IDE for a programming language.

You can, also, use the Main Demo to test the scripts and the assertions. See the [Demos](#Demos) 

## Demos

See the Demos folder. The Examples folder contains the example configuration and policy files from the original Go implementation

The main demo is under Demos/Main folder. You can, also, find an executable file in this folder so you can download it and try Casbin4D

![Main Demo](https://github.com/casbin4d/Casbin4D/blob/master/Demos/Main/Images/MainDemo.png)


## Get started

Please see the [Documentation](<https://github.com/casbin4d/Casbin4D/wiki>)

## Policy management

Casbin4D provides one point of access to manage permissions via the IPolicyManager. If you are familiar with other implementations, you will notice that they have two sets of APIs (Management API and RBAC API). This implementation combines both of them under the Policy Manager

## Policy persistence

In Casbin4D, the policy storage is abstracted via the concept of the adapter. The consumer of Casbin4D is free to implement the management of policy storage as they see fit to their needs. For convenience, Casbin4D provides two adapters: one for text files (.csv) and one memory adapter. You are welcome (and invited) to contribute any new adapters with broader usage. Please let us know 

## Multi-threading

Casbin4D is designed with multi-threading in mind. The current implementation achieves this at the Enforcer level

## Benchmarks

There is a benchmark project located in [Benchmarks](https://github.com/casbin4d/Casbin4D/blob/master/Benchmarks) folder which tests the policy enforcement. 

The project was executed in the following machine/installation:
```
* Dell XPS 15 9560: Intel(R) Core(TM) i7-7700HQ CPU @2.80GHz, 2801MHz, 4 Core(s), 8 Logical Processor(s)

* Windows: Windows 10 Pro 64-bit, 10.0.16299 Build 16299
```

The results are shown in the following table. The time overhead is calculated per operation (op) which represents a single call to ```TCasbin.enforce[..]```  

Test case | Size | Time overhead | Memory overhead
----|------|------|----
Raw Enforce | 2 Rules (2 Users) | 0.000090 sec/op |   0 KB
Basic Model | 2 Rules (2 Users) | 0.000466 sec/op | 432 B
RBAC | 5 Rules (2 Users, 1 Role) | 0.000872 sec/op | 352 B
RBAC (Small) | 1,100 Rules (1,000 Users, 100 roles) | 0.238945 sec/op | 1.49 MB
RBAC (Medium) | 11,000 Rules (10,000 Users, 1,000 Roles) | 9.745707 sec/op | 15.7 MB
RBAC (With Resource Roles) | 6 Rules (2 Users, 2 Roles) | 0.000658 sec/op | 352 B
RBAC (With Domains/Tenants) | 6 Rules (2 Users, 1 Role, 2 Domains) | 0.000670 sec/op | 352 B
RBAC (With Deny) | 6 Rules (2 Users, 1 Role) | 0.001260 sec/op | 380 B
ABAC | 0 Rules (0 Users) | 0.000181 sec/op | 120 B
KeyMatch | 2 Rules (2 Users) | 0.000782 sec/op | 352 B 
Priority | 9 Rules (2 Users, 2 Roles) | 0.001124 sec/op | 380 B

## Examples

Model | Model file | Policy file
----|------|----
ACL | [basic_model.conf](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/basic_model.conf) | [basic_policy.csv](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/basic_policy.csv)
ACL with superuser | [basic_model_with_root.conf](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/basic_with_root_model.conf) | [basic_policy.csv](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/basic_policy.csv)
ACL without users | [basic_model_without_users.conf](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/basic_without_users_model.conf) | [basic_policy_without_users.csv](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/basic_without_users_policy.csv)
ACL without resources | [basic_model_without_resources.conf](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/basic_without_resources_model.conf) | [basic_policy_without_resources.csv](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/basic_without_resources_policy.csv)
RBAC | [rbac_model.conf](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/rbac_model.conf)  | [rbac_policy.csv](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/rbac_policy.csv)
RBAC with resource roles | [rbac_model_with_resource_roles.conf](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/rbac_with_resource_roles_model.conf)  | [rbac_policy_with_resource_roles.csv](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/rbac_with_resource_roles_policy.csv)
RBAC with domains/tenants | [rbac_model_with_domains.conf](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/rbac_with_domains_model.conf)  | [rbac_policy_with_domains.csv](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/rbac_with_domains_policy.csv)
ABAC | [abac_model.conf](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/abac_model.conf)  | N/A
RESTful | [keymatch_model.conf](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/keymatch_model.conf)  | [keymatch_policy.csv](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/keymatch_policy.csv)
Deny-override | [rbac_model_with_deny.conf](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/rbac_with_deny_model.conf)  | [rbac_policy_with_deny.csv](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/rbac_with_deny_policy.csv)
Priority | [priority_model.conf](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/priority_model.conf)  | [priority_policy.csv](https://github.com/casbin4d/Casbin4D/blob/master/Examples/Default/priority_policy.csv)

## Tests
The vast majority of the tests of the original implementation in Go have been imported in Delphi. Please see the [Tests](<https://github.com/casbin4d/Casbin4D/Tests>)

You can check the code coverage [here](http://codecoverage.casbin4d.kouraklis.com/) for the up to date status. You are welcome to improve the tests and the coverage

## License

This project is licensed under the [Apache 2.0 license](LICENSE).

## Contact

If you have any issues or feature requests, please contact us. PR is welcome
- [https://github.com/casbin4d/Casbin4D/issues](https://github.com/casbin4d/Casbin4D/issues)
- [j_kour@hotmail.com](mailto:j_kour@hotmail.com)
- [Discord](https://discord.gg/S5UjpzGZjN)

