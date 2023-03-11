# Changelog

This changelog describes the changes in Casbin4D project

## [1.2.0 - Beta] - 2023 - 03 - 11
### Added
- **[Casbin.Core.Logger.Default]** Add a Logger Pool
- New model (RBAC with explicit user) added. Check \Examples\Additional folder

### Changed
- The use of loggers (logger pool)
- Main Demo has more useful UI and a log window
- Cleaned code

## [1.1.2 - Beta] - 2023 - 02 - 25
### Added
- **[Casbin.Tests.Function]** New tests added (KeyMatch-10, KeyMatch2-9) (Many thanks to **wiphi**)
### Changed
- **[Casbin.Functions.KeyMatch.pas]** Fix a bug in KeyMatch (Many thanks to **wiphi**)
 

## [1.1.1 - Beta] - 2022 - 01 - 23
### Changed
- **[Casbin.Matcher.pas]** Fix a bug in matcher 

## [1.1.0 - Beta] - 2021 - 12 - 12
### Added
- Package for Delphi 11.0 Alexandria
- New property EnableConsole in logger to allow the output of debug information
- **[Casbin.inc]** Casbin.INC file added
- **[Casbin.inc]** CASBIN_DEBUG compiler directive (See Casbin.inc)
- **[Casbin.Functions.IPMatch.pas]** IPMatch has an added option to throw an exception
### Changed
- **[Casbin.Matcher.pas]** Improved RegEx matcher (Many thanks to **ErikUniformAgri**). Now all tests pass 
## [1.0.0 - Beta] - 2020 - 07 - 31
### Added
- RBAC model tests added

### Changed
- Code cleanup
 
## [0.2.0 - Alpha] - 2019 - 02 - 03
### Added
- Package for Delphi 10.2 Tokyo
- Package for Delphi 10.3 Rio
- Package for Delphi 10.4 Sydney

### Changed
- Code cleanup

## [0.1.0 - Alpha] - 2019 - 02 - 03
### Added
- Initial Release