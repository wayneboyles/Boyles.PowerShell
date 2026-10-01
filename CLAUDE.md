# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`Boyles.PowerShell` is a multi-module PowerShell family structured the way `Az` and `Microsoft.Graph` are: one
umbrella module (`Boyles.PowerShell`), one shared module (`Boyles.PowerShell.Core`), and one module per service
(currently just `Boyles.PowerShell.Hudu`). Each service module pairs a thin PowerShell layer (`Module/`) with a
`netstandard2.0` C# class library that owns HTTP/auth concerns, so one binary loads under both Windows PowerShell 5.1
and PowerShell 7+.

The repo is still being scaffolded. `README.md` is partly stale (see "Known drift"), so check the actual files before
trusting prose docs.

## Commands

```powershell
./build.ps1 -Bootstrap            # one-time: installs PSDepend + everything in requirements.psd1 (psake, Pester, platyPS, ...)
./build.ps1                       # default task 'Build': dotnet-builds each module, stages Module/ folders into ./out/<ModuleName>
./build.ps1 -Task <Name>          # psake tasks: Build, Test, Full, Package, Docs, DocsServe, Clean, BuildCSharp, BuildPowerShell
./build.ps1 -Configuration Release
./build.ps1 -SetSecrets           # registers a SecretStore vault + prompts for Hudu.BaseUrl / Hudu.ApiKey (manual testing only)

dotnet build Boyles.PowerShell.slnx                    # compile C# only, no ./out staging
dotnet test                                            # all xUnit v3 suites (Microsoft.Testing.Platform runner, per global.json)
dotnet test --project test/Boyles.PowerShell.Core.Tests/Boyles.PowerShell.Core.Tests/Boyles.PowerShell.Core.Tests.csproj --filter-class "*ContextCacheTests"
                                                       # single class; --filter-method "*Name*" for a single test

Invoke-Pester ./test/Global       # comment-based-help checks for every exported function; needs ./build.ps1 first (imports from ./out)

Invoke-ScriptAnalyzer -Path . -Recurse -Settings ./PSScriptAnalyzerSettings.psd1
```

Things that are easy to get wrong:

- **`./build.ps1` never runs tests.** It forces `RunPesterTests`/`RunCSharpTests` to `$false` when calling psake, so even
  `-Task Test`/`Full` skips Pester. Psake's `TestPowerShell` task also only looks for `*.Tests.ps1` under `src/`, where
  there currently are none. Run `dotnet test` and `Invoke-Pester ./test/Global` directly.
- **Tests:** `test/Boyles.PowerShell.Core.Tests` has real xUnit tests. `test/Boyles.PowerShell.Hudu.Tests` is an empty
  project. Test project paths are doubly nested (`test/<Name>.Tests/<Name>.Tests/<Name>.Tests.csproj`).
- **Writing C# XML docs:** `GenerateDocumentationFile` is off in `Directory.Build.props`. To check XML doc coverage
  (missing comments, bad `cref`s), build with `-p:GenerateDocumentationFile=true` and look for `CS1591`/`CS157x`
  warnings.

### Docs site

Reference docs are generated, not hand-written. `./build.ps1 -Task Docs` builds the modules, then runs
`tools/New-ModuleDocs.ps1` (platyPS) out-of-process. That writes one Markdown page per exported command into
`docs/<ModuleName>/` plus a `README.md` landing page per module, and updates `mkdocs.yml` nav. It then builds the site
with **zensical** from a local `.venv` into `./site`. `-Task DocsServe` serves it locally.

The `docs.yml` GitHub workflow only runs `zensical build` on whatever is committed under `docs/` (on push to `main`) and
deploys to GitHub Pages. **It does not regenerate command docs.** After changing a cmdlet's comment-based help,
re-run `-Task Docs` locally and commit the updated `docs/`. Comment-based help on every public function needs a
synopsis, a description, at least one example, and a `.PARAMETER` entry per parameter;
`test/Global/Docs.Tests.ps1` checks this.

### Releases

The version lives in `src/common.props` (`<Version>`), which every module `.csproj` imports.
`build_release_on_tag.yml` runs `-Bootstrap` and then `-Task Package` on a `v*.*.*` tag push (or a manual run) and
publishes a GitHub release. `CHANGELOG.md` is maintained by hand.

### Scaffolding tools (`tools/`)

- `New-Submodule.ps1 -ServiceName ITGlue` scaffolds a new service module: C# project, `Module/` folder with the
  standard `.psm1`, and an xUnit project, all added to the `.slnx` and referencing Core. It does **not** add the module
  to the umbrella; add it by hand to `RequiredModules` in `src/Boyles.PowerShell/Boyles.PowerShell.psd1`, and to
  `$ModuleNames` in `psakefile.ps1` so it gets built and documented.
- `New-HttpClient.ps1` scaffolds a new `HttpClientBase`-derived client and partial-class resource file.
- `Test-Module.ps1`, `Test-Functions.ps1`, `Invoke-TestModuleWindow.ps1` import `./out` into a scratch console for
  manual poking.
- `test/Demo/Boyles.PowerShell.TestClient` is a standalone Blazor Server app for interactive smoke-testing against a
  real Hudu instance (it reads the `-SetSecrets` vault). It's outside the `.slnx` and isn't built by psake.

## Architecture

### How a cmdlet call flows

`Connect-Hudu` builds a `HuduClient` (C#) and registers it in Core's `ContextCache` under
`[Boyles.PowerShell.Hudu.Consts]::ClientCacheKey`. Every other Hudu cmdlet gets it back through the private
`Get-HuduClientInternal` (which calls `Confirm-BPSClient` + `Get-BPSClient`) and calls one `HuduClient` method. The
method builds a path under `api/v1` and goes through `HttpClientBase`, which handles auth, retry and JSON. Cmdlets stay
thin: shaping request bodies, plus the occasional argument completer.

### Core (`src/Boyles.PowerShell.Core`)

- **C# folders mirror namespaces literally** (`Boyles/PowerShell/HttpClients/*.cs` → `Boyles.PowerShell.HttpClients`)
  because `RootNamespace` is empty in the `.csproj`; follow that when adding Core files. `System/ObjectExtensions.cs`
  (`ConvertToJObject`) deliberately lives in namespace `System`.
- **`HttpClients/HttpClientBase.cs`** is the pipeline every service client derives from:
  - Snake_case JSON via Newtonsoft (`SnakeCaseNamingStrategy`; explicit `[JsonProperty]` names win; nulls omitted).
  - Retry with exponential back-off and jitter on 429/5xx/transport errors (`MaxRetries`, default 5), honouring
    `Retry-After`.
  - Exactly one re-auth-and-retry on a 401, via `IAuthenticationProvider.InvalidateAsync`.
  - `itemsProperty` envelope unwrapping, so `{"company": {...}}` deserializes straight to the model.
  - `GetAllPagesAsync` pagination with a `PaginationMode`: `Offset` (record offset, the default) or `PageNumber`
    (1-based page counter).
  - `Sync(...)` helpers so synchronous PowerShell-facing methods can wrap the async ones.
- **`Http/HttpTransport.cs`**: one process-wide handler shared by every client (`disposeHandler: false`), so sockets
  pool and disposing a client doesn't tear them down.
- **`Authentication/`**: `ApiKeyAuthenticationProvider` (a static header, `.Bearer()`/`.Header()` factories) and
  `OAuth2ClientCredentialsProvider` (cached token, refreshed `SkewSeconds` before expiry).
- **`Diagnostics/`**: every HTTP *attempt* produces a redacted `HttpCallRecord` sent to an `IHttpDiagnosticsSink`
  (no-op by default). Records for retries share a `CorrelationId`. The Blazor demo app is the main consumer.
- **`Context/ContextCache.cs`**: a static, case-insensitive `ConcurrentDictionary<string, object>` from key to client.
  Re-registering a key disposes the old client. It's wrapped generically by the `*-BPSClient` cmdlets
  (`Module/Public/Context/`).
- **`Settings/SettingsStore.cs`**: a process-wide singleton persisted to `%APPDATA%\Boyles.PowerShell\settings.json`
  (`~/.config/...` elsewhere). It currently holds only `DebugEnabled`. It's wrapped by the `*-BPSSetting` cmdlets.
- **Request-shaping attributes + `ConvertTo-RequestBody`/`ConvertTo-RequestQuery`**: this is the preferred way for a
  cmdlet to build a request.
  - Decorate parameters with `[BodyProperty('json_name')]`/`[QueryProperty('name')]`, or opt them out with
    `[BodyIgnore]`/`[QueryIgnore]`.
  - Then call `ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters`.
    It returns a hashtable of only the bound, attributed parameters keyed by their API names, so route parameters like
    `-Id` can sit alongside body parameters.
  - See `Hudu/Module/Public/Articles/` for the pattern.
- **`Register-BPSArgumentCompleter`**: a cached tab-completion wrapper. A service supplies a `ValueProvider`
  scriptblock and gets caching (300s per `CacheKey`), prefix filtering, and a fall back to stale cache on error. See the
  `-AssetLayout` completer on `Get-HuduAsset`.
- Other cross-cutting cmdlets: `Logging/` (`Write-Log`, `Write-Step`, ...), `Banner/`, `Validation/`, `Collections/`.

### Hudu (`src/Boyles.PowerShell.Hudu`)

- `RootNamespace` is `Boyles.PowerShell.Hudu`, with normal folders: `Services/`, `Models/`, `Builders/`.
- **`HuduClient` is one `partial class` split per resource** (`Services/HuduClient.<Resource>.cs`), with shared
  plumbing in `HuduClient.cs`. Each operation is a pair: an `...Async` method plus a sync wrapper calling
  `Sync(...)`. Each resource also has a matching `Module/Public/<Resource>/` folder of Get/New/Set/Remove (and
  sometimes Enable/Disable) cmdlets.
- **Hudu conventions every resource must follow:**
  - **List endpoints must page through the private `GetAllHuduPagesAsync<T>(path, query, "<plural_envelope>", ct)`**,
    never `GetAllPagesAsync` directly. Hudu pages by 1-based `page` plus `page_size`, not offset/limit; calling the
    base method with defaults silently truncates results.
  - Single-item responses are wrapped in a singular envelope (`itemsProperty: "company"`). List responses use the
    plural (`"companies"`). `/activity_logs` returns a bare array.
  - Request bodies go in a singular envelope too (`new { company = body }`). Anonymous-type property names pass through
    the snake_case serializer, so `IpAddress` is sent as `ip_address`. The *response* `itemsProperty` string is matched
    literally, so it must be written in snake_case.
- **`Builders/HuduRequestBuilder.cs`** builds the nested JSON for Assets (`custom_fields` array of single-key objects)
  and AssetLayouts (`fields`). A layout update replaces the entire field list whenever `fields` is present, so passing
  `null` omits it, and `AddAssetLayoutFieldsAsync` does read-merge-write to append. Newer resources use
  `ConvertTo-RequestBody` instead of adding to this builder.

### Module packaging

- **Every `.psm1`** (and the `New-Submodule.ps1` template):
  - Registers an `AssemblyResolve` handler for its own `Module\bin` before `Add-Type`-ing its DLL, so NuGet
    dependencies like `Newtonsoft.Json.dll` resolve under PS 5.1 and 7+.
  - Dot-sources `Public/` and `Private/` **recursively** and exports only the `Public` function names. If a new cmdlet
    in a subfolder doesn't show up in `Get-Command`, check the `-Recurse`.
- Each module `.csproj` has a `CopyToPowerShellModule` post-build target that copies the DLLs into its `Module\bin\`.
  `CopyLocalLockFileAssemblies=true` (in `Directory.Build.props`) makes NuGet dependencies land there too.
- Service manifests declare `RequiredModules = @('Boyles.PowerShell.Core')`. The umbrella `Boyles.PowerShell` is
  manifest-only, with no C# and no cmdlets.

### Style

PSScriptAnalyzer settings are kept in step with `.vscode/settings.json`: OTBS braces, 4-space indent, no cmdlet aliases,
120-character lines. Core C# uses Allman braces with block-scoped namespaces. Newer Hudu `Services/` files use
file-scoped namespaces, and some `Models/` files use K&R braces, so match the file you're editing.

## Known drift

- `README.md` still describes a removed `Boyles.PowerShell.Common` module, a `test/Pester` folder that no longer
  exists, and `./build.ps1 -Clean`. It also says `./build.ps1` doesn't compile; it does.
- `psakefile.ps1`'s `Get-TestProjectPath` assumes single-level test paths (`Test/<Name>/<Name>.Tests.csproj`), so it
  never finds the doubly nested test projects. `RunCSharpTests` isn't used by any task.
