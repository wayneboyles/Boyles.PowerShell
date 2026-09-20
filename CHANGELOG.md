# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.1] - 2026-09-19

### Added

- [**Demo**] Added demo pages for Activity Logs, Articles and API Info.
- [**Hudu**] Added Asset Password functions.
- [**Demo**] Added demo pages for Asset Password functions.
- [**Core**] Added `ConvertTo-RequestBody` to automatically build a body object from parameters.
- [**Core**] Added two new attributes, `BodyProperty` and `BodyIgnore`.

### Fixed

- [**Core**] Fixed Confirm-BPSClient parameter positions.
- [**Hudu**] Fixed Get-HuduActivityLogs parameter validation.
- [**Core**] Fixed Test-HasValue.

### Changed

- [**Hudu**] Changed parameter validation logic to use `ConvertTo-RequestBody`.
- Changed the build script to include secrets management for testing easily.

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
