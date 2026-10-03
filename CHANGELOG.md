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
| **Demo C#** | Blazor Server project for testing the HttpClient objects            |

## [Unreleased]

## [0.4.0] - 2026-10-01

### Added

- [**Core C#**] `HttpClientBase.GetAllPagesAsync` can now page by page number as well as by record
  offset. Two optional parameters control this: `mode` (`PaginationMode.Offset` or `PaginationMode.PageNumber`) and
  `firstPage` (default `1`). The default is still offset paging, so existing callers behave the same.

- [**Hudu PS**] Added Label functions
  - Added `Get-HuduLabel`
  - Added `New-HuduLabel`
  - Added `Remove-HuduLabel`
  - Added `Set-HuduLabel`

- [**Hudu PS**] Added LabelType functions
  - Added `Get-HuduLabelType`
  - Added `New-HuduLabelType`
  - Added `Remove-HuduLabelType`
  - Added `Set-HuduLabelType`

- [**Hudu PS**] Added List functions
  - Added `Get-HuduList`
  - Added `New-HuduList`
  - Added `Remove-HuduList`
  - Added `Set-HuduList`

- [**Hudu PS**] Added Magic Dash functions
  - Added `Get-HuduMagicDash`
  - Added `New-HuduMagicDash`
  - Added `Remove-HuduMagicDash`

- [**Hudu PS**] Added Network functions
  - Added `Get-HuduNetwork`
  - Added `New-HuduNetwork`
  - Added `Remove-HuduNetwork`
  - Added `Set-HuduNetwork`

- [**Hudu C#**] Added HuduClient.Labels.cs for Label functions.

- [**Hudu C#**] Added HuduClient.LabelTypes.cs for Label Type functions.

- [**Hudu C#**] Added HuduClient.Lists.cs for List Type functions.

- [**Hudu C#**] Added HuduClient.MagicDash.cs for Magic Dash functions.

- [**Hudu C#**] Added HuduClient.Networks.cs for Network functions.

### Fixed

- [**Hudu C#**] Updating an asset layout without a field list no longer deletes all of the layout's fields.

  Previously, the request always included `"fields": []` even when no fields were given. Hudu replaces a layout's
  whole field list whenever `fields` is present, so any such update wiped the layout. This affected:
  - `Enable-HuduAssetLayout` and `Disable-HuduAssetLayout`, which removed every field from the layout on each call.
  - `Set-HuduAssetLayout` when called without `-Fields` (for example, to change only `-Name` or `-Icon`).
  - `HuduClient.UpdateAssetLayout` / `UpdateAssetLayoutAsync` when called with `fields: null`.

- [**Hudu C#**] List commands no longer silently return only the first page of results. Hudu pages by
  1-based `page` number, but the client advanced `page` by the number of items returned. It requested `page=0`, then `page=100`, and stopped there, dropping everything after the first 100 records. The Flags, Labels, IP Addresses, Groups and Folders lists sent `limit`/`offset` instead of `page`/`page_size`, which Hudu doesn't use for paging.

  Every Hudu list method now goes through one shared helper that requests `page=1, 2, 3, …` with `page_size`.
  Affected: Activity Logs, Articles, Asset Layouts, Asset Passwords, Assets, Companies, Expirations, Flags, Flag
  Types, Folders, Groups, IP Addresses, Labels and Label Types.

- [**Hudu C#**] `GetAssetsAsync` now honours its `CancellationToken`

- [**Demo C#**] Fixed the main menu. It now breaks into columns instead of one long menu list.

- [**Core C#**] `GetAllPagesAsync` now longer pages indefinately if paging isn't supported. It will stop after the 2nd page of duplicate
  results.

### Changed

-

### Removed

-

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
