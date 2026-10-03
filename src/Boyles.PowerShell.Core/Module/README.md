# Boyles.PowerShell.Core

Shared authentication, HTTP transport, and context primitives for the `Boyles.PowerShell` module
family. Every `Boyles.PowerShell.<Service>` module (e.g. `Boyles.PowerShell.Hudu`) depends on this
module, the same way `Az.*` modules depend on `Az.Accounts`.

## What's in here

- A shared HTTP pipeline (retry with back-off/jitter, pagination, snake_case JSON) that service
  modules build their clients on top of.
- `ApiKeyAuthenticationProvider` and `OAuth2ClientCredentialsProvider` for common auth schemes.
- `ContextCache`, wrapped by the `*-BPSClient` cmdlets, so a service module's `Connect-*` cmdlet can
  register a client once and every other cmdlet in that module can look it back up.
- `*-BPSSetting` cmdlets over a small persisted settings store.
- Request-shaping helpers (`ConvertTo-RequestBody`/`ConvertTo-RequestQuery`) driven by
  `[BodyProperty]`/`[QueryProperty]` attributes on cmdlet parameters.

## Install

```powershell
Install-Module -Name Boyles.PowerShell.Core
```

You normally don't install this directly - installing a service module like `Boyles.PowerShell.Hudu`
pulls it in automatically via `RequiredModules`.

## Links

- [Project repository](https://github.com/wayneboyles/Boyles.PowerShell)
- [Command reference](https://wayneboyles.github.io/Boyles.PowerShell/Boyles.PowerShell.Core/)
