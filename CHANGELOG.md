# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Legend

| Label       | Purpose                                                             |
| ----------- | ------------------------------------------------------------------- |
| **General** | General changes and additions not classified by a project or module |
| **Core PS** | Core PowerShell module                                              |
| **Core C#** | Core C# library project (Boyles.PowerShell.Core)                    |
| **Hudu PS** | Hudu PowerShell module                                              |
| **Hudu C#** | Hudu C# library project (Boyles.PowerShell.Hudu)                    |

## [Unreleased]

## [0.3.0] - 2026-09-23

### Added

- [**Hudu PS**] Added argument completer to `Get-HuduAssetLayout`

- [**Hudu PS**] Added Card lookup functions.
  - Added `Get-HuduCard`

- [**Hudu PS**] Added Expiration functions.
  - Added `Get-HuduExpiration`
  - Added `Remove-HuduExpiration`
  - Added `Set-HuduExpiration`

- [**Hudu PS**] Added Flag Type functions
  - Added `Get-HuduFlagType`
  - Added `New-HuduFlagType`
  - Added `Remove-HuduFlagType`
  - Added `Set-HuduFlagType`

- [**Hudu PS**] Added Flag functions
  - Added `Get-HuduFlag`
  - Added `New-HuduFlag`
  - Added `Remove-HuduFlag`
  - Added `Set-HuduFlag`

- [**Hudu C#**] Added HuduClient.Cards.cs for Card functions.

- [**Hudu C#**] Added HuduClient.Expirations.cs for Expiration functions.

- [**Hudu C#**] Added HuduClient.FlagTypes.cs for Flag Type functions.

- [**Hudu C#**] Added HuduClient.Flags.cs for Flag functions.

- [**Hudu PS**] Added Folder functions
  - Added `Get-HuduFolder`
  - Added `New-HuduFolder`
  - Added `Remove-HuduFolder`
  - Added `Set-HuduFolder`

- [**Hudu PS**] Added Group functions
  - Added `Get-HuduGroup`

- [**Hudu PS**] Added IP Address functions
  - Added `Get-HuduIpAddress`
  - Added `New-HuduIpAddress`
  - Added `Remove-HuduIpAddress`
  - Added `Set-HuduIpAddress`

### Fixed

- [**Core PS**] Fixed `ConvertTo-RequestBody` and `ConvertTo-RequestQuery` to properly handle bool values

### Changed

- [**Core PS**] `ConvertTo-RequestQuery` now returns a hashtable, not a Dictionary object

### Removed

- [**Hudu C#**] Removed Pester tests. These will be redone.

## [0.2.1] - 2026-09-19

### Added

- [**Demo**] Added demo pages for Activity Logs, Articles and API Info.
- [**Hudu**] Added Asset Password functions.
- [**Demo**] Added demo pages for Asset Password functions.
- [**Core**] Added `ConvertTo-RequestBody` to automatically build a body object from parameters.
- [**Core**] Added two new attributes, `BodyProperty` and `BodyIgnore` for body parameter building.
- [**Core**] Added two new attributes, `QueryProperty` and `QueryIgnore` for query parameter building.
- [**Hudu**] Added Asset functions.
- [**Hudu**] Added argument completer to `Get-HuduAsset` for the `AssetLayout` parameter.

### Fixed

- [**Core**] Fixed Confirm-BPSClient parameter positions.
- [**Hudu**] Fixed Get-HuduActivityLogs parameter validation.
- [**Core**] Fixed Test-HasValue.

### Changed

- [**Hudu**] Changed parameter validation logic to use `ConvertTo-RequestBody`.
- Changed the build script to include secrets management for testing easily.
- [**Core**] Updated `ConvertTo-StringDictionary`.

### Removed

- [**Core**] Cleaned up left over debugging lines.

## [0.1.0] - 2026-09-18

### Added

- New Logo.
- [**Hudu**] Activity Log functions.
- [**Hudu**] API Info function.
- [**Hudu**] Article functions.
- [**Hudu**] Asset Layout functions.
- [**Hudu**] Company functions.
- [**Hudu**] Connectivity functions / helpers.
- [**Core**][**Hudu**] Initial Argument Completer Implementation.
- [**Core**][**Hudu**] Paging Support.
- [**Core**] Settings Support. You can now save and retrieve settings throughout the modules.
- [**Core**] Http UserAgent is now set on every request. It defaults to `Boyles.PowerShell\<Version>`.
- [**Hudu**] Added comments to all PowerShell functions.

### Fixed

- Fixed `GetAllPagesAsync` to correctly handle a `JArray` instead of just a `JObject`.

### Changed

-

### Removed

-
