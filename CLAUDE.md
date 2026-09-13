# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`Boyles.PowerShell` is an early-stage, multi-module PowerShell family structured the way `Az` and
`Microsoft.Graph` are: one umbrella module, one shared `Boyles.PowerShell.Core` module, and one
module per service (e.g. `Boyles.PowerShell.Hudu`) — each service module pairs a thin PowerShell
layer with a C# class library that owns HTTP/auth concerns.

**This repo is under active scaffolding — the docs, tests, and tooling describe the intended end
state, not always the current one.** Before relying on anything below as fact, check the actual
files; several pieces described in `README.md` and `test/Pester/*.Tests.ps1` do not exist yet (see
"Known drift" below).

There is no git repository initialized here yet (`.gitignore` exists but there's no `.git`).

## Commands

```powershell
./build.ps1                      # runs psake (see "Known drift" - this does not currently compile anything)
./build.ps1 -Bootstrap           # installs PSDepend + the modules in requirements.psd1, then Invoke-PSDepend
./build.ps1 -Task <TaskName>     # run a specific psake task from psakefile.ps1 (default task is 'Init')
./build.ps1 -Clean               # intended to wipe out/, bin/, obj/ first (currently a no-op, see below)

dotnet build Boyles.PowerShell.slnx     # actually compiles the C# projects (Core, Hudu, Common)
dotnet test                             # run the xUnit test suites under test/*.Tests/
Invoke-Pester ./test/Pester             # run the Pester suites — requires a populated ./out first
```

To add a new service module (scaffolds the C# project + Module folder, adds it to the .slnx, wires
in the `Boyles.PowerShell.Core` reference):

```powershell
./tools/New-Submodule.ps1 -ServiceName ITGlue
```
(`README.md` calls this `New-BoylesSubmodule.ps1` — the actual file is `tools/New-Submodule.ps1`.)

Linting follows `PSScriptAnalyzerSettings.psd1` (kept in lock-step with `.vscode/settings.json`'s
PowerShell formatter settings — OTBS brace style, 4-space indent, no cmdlet aliases, 120-char
lines):

```powershell
Invoke-ScriptAnalyzer -Path . -Recurse -Settings ./PSScriptAnalyzerSettings.psd1
```

## Known drift (read before trusting docs/tests)

- **`build.ps1` doesn't build anything right now.** It now delegates to `Invoke-Psake` against
  `psakefile.ps1`, whose `Init` and `Clean` tasks are empty stubs. The old logic that actually ran
  `dotnet build` and staged each module's `Module/` folder into `.\out` is still in `build.ps1` as
  dead code *after* an unconditional `exit`/`exit 0` near the bottom of the file — it never runs.
  Until `psakefile.ps1` is filled in (or that dead code is revived), use `dotnet build` directly and
  stage modules into `out/` by hand if you need a working module tree for Pester or manual testing.
- **`test/Pester/*.Tests.ps1` expect cmdlets that still don't exist.** `Core.Tests.ps1` calls
  `Connect-Boyles`, `Disconnect-Boyles`, and `Get-BoylesContext` — a *connection*-level API (base
  URI + API key + service name) distinct from the generic client store that now exists
  (`BoylesContextCache` / `Add-BoylesClient` / `Get-BoylesClient`, see Architecture below). Nothing
  named `Connect-Boyles` or `Get-BoylesContext` has been implemented. These Pester tests will keep
  failing until that connection-level layer is built on top of the client store.
- **Every module's `.psm1` was silently exporting almost nothing** because its `Get-ChildItem` over
  `Public`/`Private` had no `-Recurse`, so any cmdlet grouped into a subfolder (`Public/Banner/`,
  `Public/Logging/`, `Public/Context/`, ...) never got dot-sourced or exported — only files directly
  in `Public/`'s root loaded. Fixed (added `-Recurse`) in `Boyles.PowerShell.Core.psm1`,
  `Boyles.PowerShell.Hudu.psm1`, `Boyles.PowerShell.Common.psm1`, and the `tools/New-Submodule.ps1`
  template. If you ever add a cmdlet and `Get-Command` doesn't see it, check this first.
- **C# source layout mirrors the target namespace as literal folders**, e.g.
  `src/Boyles.PowerShell.Core/Boyles/PowerShell/Authentication/*.cs` for namespace
  `Boyles.PowerShell.Authentication`. `Boyles.PowerShell.Core.csproj` sets `RootNamespace` to empty
  specifically so this works. Follow the same folder-mirrors-namespace convention when adding files
  to Core; service module projects (Hudu, Common) instead set `RootNamespace` to their own module
  name and use normal folders (`Services/`, `Models/`).
- The solution (`Boyles.PowerShell.slnx`) currently references `Core`, `Hudu`, and `Common` C#
  projects, plus the two test projects — `Common` is not mentioned in `README.md`'s repository
  layout but is wired into the umbrella's `RequiredModules`.
- Test project paths are doubly-nested (e.g.
  `test/Boyles.PowerShell.Hudu.Tests/Boyles.PowerShell.Hudu.Tests/*.csproj`), not the single level
  the README's tree diagram shows.

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
  HTTP attempt), exceptions (`Exceptions/ApiException.cs`), and the client state store
  (`Context/BoylesContextCache.cs`).
- **Client state store** (`Context/BoylesContextCache.cs`): a static, thread-safe
  `ConcurrentDictionary<string, object>` mapping a caller-chosen key to a connected service client
  (e.g. a `HuduClient`). A service module's `Connect-*` cmdlet builds its client and calls
  `Set(key, client)`; every other cmdlet in that module looks the client back up by the same key via
  `Get<T>(key)`/`TryGet<T>` instead of needing it passed to every call — the same shape as `Az`'s
  default-context cache. Re-registering a key disposes the previous client first if it's
  `IDisposable`, so re-running `Connect-*` doesn't leak sockets. Wrapped for PowerShell by
  `Add-BoylesClient`, `Get-BoylesClient`, `Test-BoylesClient`, `Remove-BoylesClient`, and
  `Get-BoylesClientKey` (`Module/Public/Context/`) — these are generic across services; they don't
  know or care what type of client they're holding. `HuduClient.FromContext(key)` in
  `Boyles.PowerShell.Hudu` shows the C#-side counterpart:
  `BoylesContextCache.Get<HuduClient>(key)`. See `Connect-Hudu.ps1` for the end-to-end pattern a new
  service module should follow.
- **Service modules** (e.g. `Boyles.PowerShell.Hudu`): each pairs a `Module/` folder (what
  PowerShell imports) with a sibling C# project referencing Core
  (`ProjectReference Include="..\Boyles.PowerShell.Core\..."`). A service's C# client
  (e.g. `Services/HuduClient.cs`) derives from `HttpClientBase` and exposes a
  `FromContext(key)` static helper over `BoylesContextCache`, so cmdlets stay thin wrappers that
  just call `Get-BoylesClient` (PowerShell) or `FromContext` (C#) rather than re-authenticating.
- **Module loading pattern** (every module's `.psm1`): before `Add-Type`-ing its own compiled
  assembly, each `.psm1` registers an `AssemblyResolve` handler pointed at its own `Module\bin`
  folder, so dependency DLLs (e.g. `Newtonsoft.Json.dll`) resolve correctly under both Windows
  PowerShell 5.1 and PowerShell 7+. It then dot-sources every `.ps1` found *recursively* under
  `Public/` and `Private/` (subfolders like `Public/Context/`, `Public/Logging/` are expected — see
  the `-Recurse` fix noted above) and exports only the `Public` function names. `tools/New-Submodule.ps1`
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
