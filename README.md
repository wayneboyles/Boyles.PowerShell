# Boyles.PowerShell

A multi-module PowerShell family, structured the way `Az` and `Microsoft.Graph`
are: one umbrella module, one shared `Core` module, and one module per
service - each backed by a C# class library that owns HTTP/auth concerns so
the PowerShell layer stays thin.

| Module | Purpose |
|---|---|
| `Boyles.PowerShell` | Umbrella/meta-module. No cmdlets of its own - importing it imports every module below via `RequiredModules`. |
| `Boyles.PowerShell.Core` | Shared authentication, `HttpClient` management, and connection/context state. Every service module depends on this. |
| `Boyles.PowerShell.Hudu` | Example service module: cmdlets for [Hudu](https://www.hudu.com/), backed by a `HuduClient` C# library. |

## Repository layout

```
Boyles.PowerShell/
├── Boyles.PowerShell.slnx
├── Directory.Build.props        # shared MSBuild settings for every csproj
├── build.ps1                    # dotnet build + stage every module into .\out
├── src/
│   ├── Boyles.PowerShell/       # umbrella module (psd1/psm1 only, no C#)
│   ├── Core/                    # Boyles.PowerShell.Core
│   │   ├── Boyles.PowerShell.Core.csproj
│   │   ├── Authentication/      # IBoylesCredential + implementations
│   │   ├── Http/                # BoylesHttpClientFactory, BoylesApiConnection
│   │   ├── Context/             # BoylesConnection, BoylesContext, BoylesContextCache
│   │   ├── Exceptions/
│   │   └── Module/              # the PowerShell module half
│   │       ├── Boyles.PowerShell.Core.psd1
│   │       ├── Boyles.PowerShell.Core.psm1
│   │       ├── Public/          # exported cmdlets (one function per .ps1)
│   │       ├── Private/         # internal helpers
│   │       ├── en-US/           # about_* help
│   │       └── bin/             # compiled DLLs land here (build output, gitignored)
│   └── Hudu/                    # Boyles.PowerShell.Hudu - same shape as Core
│       ├── Boyles.PowerShell.Hudu.csproj
│       ├── Services/            # HuduClient
│       ├── Models/              # HuduAsset, response envelopes
│       └── Module/...
├── test/
│   ├── Boyles.PowerShell.Core.Tests/   # xUnit tests for the C# library
│   ├── Boyles.PowerShell.Hudu.Tests/
│   └── Pester/                          # Pester tests against the staged modules
├── tools/
│   └── New-BoylesSubmodule.ps1  # scaffolds a new Boyles.PowerShell.<Service>
└── out/                          # build.ps1 output: a ready-to-import module repo (gitignored)
```

Each service module pairs a `Module/` folder (the thing PowerShell imports)
with a sibling C# project (`Services/`, `Models/`, etc.) - the same
"library + module" split used throughout `azure-powershell` (e.g.
`src/Accounts/Authentication` next to `src/Accounts/Accounts`).

## How the pieces connect

- `Boyles.PowerShell.Core.dll` defines `IBoylesCredential`, `BoylesConnection`,
  `BoylesContext`/`BoylesContextCache` (a process-wide "current context", like
  Az's default context), `BoylesHttpClientFactory` (one pooled `HttpClient`
  per service), and `BoylesApiConnection` (a small JSON REST helper).
- `Connect-Boyles -ServiceName <name> -BaseUri <uri> -ApiKey <key>` builds a
  `BoylesConnection` and stores it in the current context.
- A service module wraps that in something friendlier
  (`Connect-BoylesHudu -BaseUri ... -ApiKey ...`) and its own C# client
  (`HuduClient.FromCurrentContext()`) pulls the connection back out to make
  calls, so every cmdlet stays a thin PowerShell wrapper around C# code.
- The `.psm1` in every module registers an `AssemblyResolve` handler pointed
  at its own `Module\bin` folder before calling `Add-Type`, so compiled
  dependencies (e.g. `System.Text.Json.dll`) load correctly under both
  Windows PowerShell 5.1 and PowerShell 7+.
- Service module manifests declare `RequiredModules = @('Boyles.PowerShell.Core')`,
  so importing a service module (or the umbrella) always pulls Core in first.

## Building

```powershell
./build.ps1              # dotnet build + stage every module into .\out
./build.ps1 -Import      # ...then Import-Module the umbrella for a smoke test
./build.ps1 -Clean       # wipe out/, bin/, obj/ first
```

```powershell
dotnet test               # run the C# (xUnit) test suites
Invoke-Pester ./test/Pester   # run the PowerShell (Pester) test suites, after ./build.ps1
```

## Adding a new service module

```powershell
./tools/New-BoylesSubmodule.ps1 -ServiceName ITGlue
```

This creates `src/ITGlue/...` in the same shape as `src/Hudu`, adds the new
`.csproj` to the solution, and references `Boyles.PowerShell.Core`. Follow the
printed next steps to add cmdlets and, once it's ready, list it in
`src/Boyles.PowerShell/Boyles.PowerShell.psd1`'s `RequiredModules`.

See [docs/Architecture.md](docs/Architecture.md) for more detail on the
design decisions behind this layout.
