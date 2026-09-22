# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`Boyles.PowerShell` is an early-stage, multi-module PowerShell family structured the way `Az` and
`Microsoft.Graph` are: one umbrella module, one shared `Boyles.PowerShell.Core` module, and one
module per service (currently just `Boyles.PowerShell.Hudu`) — each service module pairs a thin
PowerShell layer with a C# class library that owns HTTP/auth concerns.

**This repo is under active scaffolding — the docs, tests, and tooling describe the intended end
state, not always the current one.** Before relying on anything below as fact, check the actual
files; several pieces described in `README.md` do not exist yet (see "Known drift" below).

## Commands

```powershell
./build.ps1                      # dotnet-builds Core+Hudu, stages Module/ folders into ./out, runs Pester (via psake)
./build.ps1 -Bootstrap           # installs PSDepend + the modules in requirements.psd1, then Invoke-PSDepend
./build.ps1 -SetSecrets          # registers a SecretManagement vault and prompts for Hudu.BaseUrl/Hudu.ApiKey (manual/demo testing)
./build.ps1 -Task <TaskName>     # run specific psake task(s) from psakefile.ps1: Init, Clean, BuildCSharp,
                                  # BuildPowerShell, TestPowerShell, Test (=TestPowerShell), Full (=Build+Test), Package
./build.ps1 -Configuration Release

dotnet build Boyles.PowerShell.slnx     # compiles the C# projects directly (Core, Hudu) without staging ./out
dotnet test                             # run the xUnit test suites under test/*.Tests/
Invoke-Pester ./src                     # run the co-located Pester specs directly, no build required (see below)
```

To add a new service module (scaffolds the C# project + Module folder + an xUnit3 test project,
adds both to the .slnx, wires in the `Boyles.PowerShell.Core` reference):

```powershell
./tools/New-Submodule.ps1 -ServiceName ITGlue
```

It does **not** add the module to the umbrella — once it's ready to ship, add it by hand to
`RequiredModules` in `src/Boyles.PowerShell/Boyles.PowerShell.psd1`. `tools/` also has
`New-HttpClient.ps1` (scaffolds a new `HttpClientBase`-derived client + partial-class resource file
for an existing service), and `Test-Module.ps1` / `Test-Functions.ps1` / `Invoke-TestModuleWindow.ps1`
for interactively importing `./out` and poking at cmdlets in a scratch console.

Linting follows `PSScriptAnalyzerSettings.psd1` (kept in lock-step with `.vscode/settings.json`'s
PowerShell formatter settings — OTBS brace style, 4-space indent, no cmdlet aliases, 120-char
lines):

```powershell
Invoke-ScriptAnalyzer -Path . -Recurse -Settings ./PSScriptAnalyzerSettings.psd1
```

### Pester tests live next to the cmdlets they test

Unlike `dotnet test` (which targets the doubly-nested `test/*.Tests/` xUnit projects), the _working_
Pester suite is co-located as `<Verb-Noun>.Tests.ps1` right beside each cmdlet under
`src/<Module>/Module/Public/**/` (e.g. `Module/Public/Context/Add-BPSClient.Tests.ps1`,
`Module/Public/Settings/Get-BPSSetting.Tests.ps1`). The psake `TestPowerShell` task (`Test`/`Full`)
runs `Invoke-Pester` with `Run.Path = src`, so it discovers these automatically — no `./out` build is
required first, unlike what `Known drift` used to say about `test/Pester`. Add new cmdlet tests here,
next to the cmdlet, not under `test/Pester` (see Known drift below for why that folder is legacy).

## Known drift (read before trusting docs/tests)

- **`build.ps1` now actually builds.** It delegates to `Invoke-Psake` against `psakefile.ps1`, whose
  `Init`/`Clean`/`BuildCSharp`/`BuildPowerShell`/`TestPowerShell`/`Package` tasks are fully
  implemented — running it `dotnet build`s each module's `.csproj`, stages its `Module/` folder into
  `./out/<ModuleName>`, and (by default) runs the co-located Pester suite described above.
- **`test/Pester/*.Tests.ps1` are stale and expect cmdlets that don't exist.** `Core.Tests.ps1` calls
  `Connect-Boyles`, `Disconnect-Boyles`, and `Get-BoylesContext` — a _connection_-level API (base
  URI + API key + service name) distinct from the generic client store that now exists
  (`ContextCache` / `Add-BPSClient` / `Get-BPSClient`, see Architecture below). `Hudu.Tests.ps1`
  similarly expects `Connect-BoylesHudu` and `Get-BoylesHuduAsset`, but the actual cmdlets are named
  `Connect-Hudu`/`Disconnect-Hudu` and `Get-HuduAsset`. These have been superseded by the co-located
  `*.Tests.ps1` files under `src/` (see Commands above) — treat `test/Pester/` as dead until either
  it's deleted or reconciled with current naming, whichever comes first.
- **`Boyles.PowerShell.Common` has been removed.** `README.md` still describes a
  `Boyles.PowerShell.Common` module; it no longer exists in `src/` or in `Boyles.PowerShell.slnx`.
  Only `Boyles.PowerShell` (umbrella), `Boyles.PowerShell.Core`, and `Boyles.PowerShell.Hudu` exist
  today.
- **Every module's `.psm1` must `Get-ChildItem -Recurse`** over `Public`/`Private`, or any cmdlet
  grouped into a subfolder (`Public/Banner/`, `Public/Settings/`, `Public/Context/`, ...) never gets
  dot-sourced or exported — only files directly in `Public/`'s root would load. This is already fixed
  in `Boyles.PowerShell.Core.psm1`, `Boyles.PowerShell.Hudu.psm1`, and the `tools/New-Submodule.ps1`
  template. If you ever add a cmdlet and `Get-Command` doesn't see it, check this first.
- **C# source layout mirrors the target namespace as literal folders**, e.g.
  `src/Boyles.PowerShell.Core/Boyles/PowerShell/Authentication/*.cs` for namespace
  `Boyles.PowerShell.Authentication`. `Boyles.PowerShell.Core.csproj` sets `RootNamespace` to empty
  specifically so this works. Follow the same folder-mirrors-namespace convention when adding files
  to Core; the Hudu project instead sets `RootNamespace` to its own module name and uses normal
  folders (`Services/`, `Models/`, `Builders/`).
- Test project paths are doubly-nested (e.g.
  `test/Boyles.PowerShell.Hudu.Tests/Boyles.PowerShell.Hudu.Tests/*.csproj`), not the single level
  the README's tree diagram shows.
- **`test/Demo/Boyles.PowerShell.TestClient`** is a standalone Blazor Server app used for manual,
  interactive smoke-testing against a real Hudu instance (`./build.ps1 -SetSecrets` provisions the
  `Hudu.BaseUrl`/`Hudu.ApiKey` secrets it reads). It is not part of `Boyles.PowerShell.slnx` and is
  not touched by `build.ps1`/psake or `dotnet test`.

## Architecture

- **Umbrella module** (`src/Boyles.PowerShell/`): manifest-only, no C# and no cmdlets of its own.
  Its `.psd1` lists every service module in `RequiredModules`; importing it just pulls in Core plus
  every service module. New service modules are added here by hand once ready to ship — scaffolding
  a module does not add it automatically.
- **`Boyles.PowerShell.Core`**: shared library every service module depends on
  (`RequiredModules = @('Boyles.PowerShell.Core')` in each service manifest). Owns authentication
  (`Authentication/`), HTTP transport (`Http/HttpTransport.cs`, a
  `SocketsHttpHandler`/`HttpClientHandler` shared across all client instances so sockets pool),
  the retry/pagination/JSON pipeline (`HttpClients/HttpClientBase.cs`), diagnostics (`Diagnostics/`
  — `IHttpDiagnosticsSink` + `HttpCallRecordBuilder` build redacted request/response records per
  HTTP attempt), exceptions (`Exceptions/ApiException.cs`), the client state store
  (`Context/ContextCache.cs`, namespace `Boyles.PowerShell.Context`), request-shaping attributes
  (`Attributes/` — `BodyPropertyAttribute`/`BodyIgnoreAttribute`/`QueryPropertyAttribute`/
  `QueryIgnoreAttribute`, all `namespace Boyles.PowerShell.Attributes`), and a process-wide settings
  store (`Settings/SettingsStore.cs`, backed by `ISettingsPersistence` — a JSON file on disk by
  default via `JsonFileSettingsPersistence`). It also carries small cross-cutting PowerShell utility
  cmdlets not tied to any one service: `Module/Public/Validation/` (`Test-HasValue`,
  `Test-RequiredValue`), `Module/Public/Collections/` (`ConvertTo-StringDictionary`,
  `ConvertFrom-JToken`, `ConvertTo-RequestBody`, `ConvertTo-RequestQuery`),
  `Module/Public/Completion/` (`Register-BPSArgumentCompleter`), and `Module/Public/Settings/`
  (`Get-BPSSetting`, `Set-BPSSetting`, `Remove-BPSSetting`, `Reset-BPSSetting`,
  `Get-BPSSettingPath`).
- **Request-shaping attributes + `ConvertTo-RequestBody`/`ConvertTo-RequestQuery`**: rather than each
  cmdlet hand-assembling a body/query hashtable, a parameter is decorated with
  `[BodyProperty('json_name')]` (or `[QueryProperty('json_name')]`; `[BodyIgnore]`/`[QueryIgnore]` to
  opt a parameter out), and the cmdlet calls
  `ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters`
  to get back a hashtable of just the bound, attributed parameters keyed by their JSON name — so
  route/path parameters (e.g. `-CompanyId`) can sit alongside body parameters without special-casing.
  See any cmdlet under `Boyles.PowerShell.Hudu/Module/Public/Articles/` or `AssetLayouts/` for the
  pattern; this is the newer, preferred approach over hand-building envelopes in C# (see
  `HuduRequestBuilder` below, still used by `Assets`/`AssetLayouts` for Hudu's nested
  `custom_fields`/`fields` envelope shape).
- **`Register-BPSArgumentCompleter`**: a generic, cached wrapper around
  `Register-ArgumentCompleter` every module uses for tab-completion, so a service only supplies a
  `ValueProvider` scriptblock (e.g. `HuduClient.GetCompanies()`) and gets caching (default 300s,
  per `CacheKey`), typed-so-far filtering, and safe fallback-to-stale-cache-on-error for free. See
  `Get-HuduAsset`'s `-AssetLayout` completer for a working example.
- **Settings store** (`Settings/SettingsStore.cs`): a process-wide singleton
  (`SettingsStore.Instance`) that HTTP clients and cmdlets read/write through for cross-cutting flags
  — currently just `DebugEnabled` — persisted to a JSON file so a value set via `Set-BPSSetting` in
  one session is visible next session too. Wrapped for PowerShell by `Get-BPSSetting`,
  `Set-BPSSetting`, `Remove-BPSSetting`, `Reset-BPSSetting`, and `Get-BPSSettingPath`
  (`Module/Public/Settings/`).
- **Client state store** (`Context/ContextCache.cs`): a static, thread-safe
  `ConcurrentDictionary<string, object>` mapping a caller-chosen key to a connected service client
  (e.g. a `HuduClient`). A service module's `Connect-*` cmdlet builds its client and calls
  `Set(key, client)`; every other cmdlet in that module looks the client back up by the same key via
  `Get<T>(key)`/`TryGet<T>` instead of needing it passed to every call — the same shape as `Az`'s
  default-context cache. Re-registering a key disposes the previous client first if it's
  `IDisposable`, so re-running `Connect-*` doesn't leak sockets. Wrapped for PowerShell by
  `Add-BPSClient`, `Get-BPSClient`, `Test-BPSClient`, `Remove-BPSClient`, `Confirm-BPSClient` (throws
  if not connected), and `Get-BPSClientKey` (`Module/Public/Context/`) — these are generic across
  services; they don't know or care what type of client they're holding. `HuduClient.FromContext(key)`
  in `Boyles.PowerShell.Hudu` shows the C#-side counterpart: `ContextCache.Get<HuduClient>(key)`. See
  `Connect-Hudu.ps1` for the end-to-end pattern a new service module should follow.
- **Service modules** (currently `Boyles.PowerShell.Hudu`): each pairs a `Module/` folder (what
  PowerShell imports) with a sibling C# project referencing Core
  (`ProjectReference Include="..\Boyles.PowerShell.Core\..."`). A service's C# client derives from
  `HttpClientBase` and exposes a `FromContext(key)` static helper over `ContextCache`, so cmdlets
  stay thin wrappers that just call `Get-BPSClient` (PowerShell) or `FromContext` (C#) rather than
  re-authenticating.
- **`Boyles.PowerShell.Hudu` internal layout** — the pattern to follow when adding another Hudu
  resource area (or scaffolding a new service): `HuduClient` is split into `partial class` files per
  resource under `Services/` (`HuduClient.cs` for the core/shared plumbing, plus
  `HuduClient.ActivityLogs.cs`, `HuduClient.ApiInfo.cs`, `HuduClient.Articles.cs`,
  `HuduClient.AssetLayouts.cs`, `HuduClient.AssetPasswords.cs`, `HuduClient.Assets.cs`,
  `HuduClient.Companies.cs`), `Models/` holds the plain POCOs returned/sent for each resource
  (`HuduCompany`, `HuduAsset`, `HuduAssetLayout`, `HuduAssetField`, ...), and
  `Builders/HuduRequestBuilder.cs` is an internal static class that assembles the nested request JSON
  Hudu's API expects for `Assets`/`AssetLayouts` (wrapping a body in an `"asset"`/`"asset_layout"`
  envelope alongside a `custom_fields`/`fields` array) — keeping that shaping logic out of the client
  methods and cmdlets; newer resources prefer `ConvertTo-RequestBody` (above) over adding to this
  builder. `Module/Public/` has one folder per resource — `ActivityLogs/`, `ApiInfo/`, `Articles/`,
  `AssetLayouts/`, `AssetPasswords/`, `Assets/`, `Companies/`, `Connectivity/` — each following the
  full CRUD cmdlet-family pattern (`*-HuduCompany`'s Get/New/Set/Remove/Enable/Disable is the
  original reference example).
- **Module loading pattern** (every module's `.psm1`): before `Add-Type`-ing its own compiled
  assembly, each `.psm1` registers an `AssemblyResolve` handler pointed at its own `Module\bin`
  folder, so dependency DLLs (e.g. `Newtonsoft.Json.dll`) resolve correctly under both Windows
  PowerShell 5.1 and PowerShell 7+. It then dot-sources every `.ps1` found _recursively_ under
  `Public/` and `Private/` (subfolders like `Public/Context/`, `Public/Settings/` are expected — see
  the `-Recurse` note above) and exports only the `Public` function names. `tools/New-Submodule.ps1`
  generates this same `.psm1` boilerplate for new modules — copy that pattern rather than
  reinventing it.
- **Build wiring per C# project**: every module's `.csproj` sets `TargetFramework=netstandard2.0`
  (so one binary loads under both PS 5.1 and PS 7+), `CopyLocalLockFileAssemblies=true` in
  `Directory.Build.props` (class libraries don't copy NuGet deps to `bin/` by default — modules
  need them there for `Add-Type`), and a `CopyToPowerShellModule` post-build target that copies the
  built DLLs into its own `Module\bin\` folder. `Directory.Build.props` supplies shared
  Authors/Company/LangVersion/Nullable settings to every `.csproj` in the repo.
- **HTTP client pipeline** (`Boyles/PowerShell/HttpClients/HttpClientBase.cs`): one abstract base every service's typed client
  derives from. Handles JSON (snake_case property mapping via `SnakeCaseNamingStrategy`, nulls
  omitted), automatic retry with exponential back-off + jitter on 429/5xx/transport errors
  (`MaxRetries`, default 5), a single automatic re-auth-and-retry cycle on 401 via
  `IAuthenticationProvider.InvalidateAsync`, offset/limit-based `GetAllPagesAsync` pagination, and
  per-attempt diagnostics records sent to an `IHttpDiagnosticsSink` (default: a no-op sink, so
  verbose call logging is opt-in). Sync-over-async helpers (`Sync<T>`) exist for PowerShell-facing
  cmdlet entry points that can't be `async`.
