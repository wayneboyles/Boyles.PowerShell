#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Register-BPSArgumentCompleter.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.

    Register-BPSArgumentCompleter hands its generated completer scriptblock to the built-in
    Register-ArgumentCompleter, which stores it inside the PowerShell engine with no supported way
    to read it back out and invoke it directly through real tab-completion. So every test mocks
    Register-ArgumentCompleter (inside InModuleScope, since the mock must intercept the call from
    within the module) to capture the scriptblock argument, then invokes that captured scriptblock
    directly with fake completion parameters - exercising the exact same caching/filtering logic a
    real Tab press would run, without needing the full completion engine.

    Each test uses its own GUID -CacheKey, since the completion cache ($script:BPSCompletionCache)
    is a single dictionary shared for the lifetime of the module.

    Every invocation of the completer also appends a line to "$env:TEMP\bps-completer.log" (a
    leftover debug statement in the source - see the # DEBUG comments in
    Register-BPSArgumentCompleter.ps1). That happens in real usage too, so these tests don't work
    around it, but it does mean running this suite will grow that file.
#>

BeforeAll {
    $script:ModuleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    $script:ManifestPath = Join-Path $script:ModuleRoot 'Boyles.PowerShell.Core.psd1'
    $script:BinPath = Join-Path $script:ModuleRoot 'bin\Boyles.PowerShell.Core.dll'

    if (-not (Test-Path $script:BinPath)) {
        throw "Compiled assembly not found at '$script:BinPath'. Run ./build.ps1 or 'dotnet build' first."
    }

    Import-Module -Name $script:ManifestPath -Force
}

AfterAll {
    Remove-Module -Name Boyles.PowerShell.Core -Force -ErrorAction SilentlyContinue
}

Describe 'Register-BPSArgumentCompleter' {
    It 'registers a completer under the given command and parameter names' {
        InModuleScope Boyles.PowerShell.Core {
            Mock Register-ArgumentCompleter { }

            Register-BPSArgumentCompleter -CommandName 'Get-PesterFoo' -ParameterName 'Bar' -CacheKey ([guid]::NewGuid().ToString()) -ValueProvider { @('a') }

            Should -Invoke Register-ArgumentCompleter -Times 1 -ParameterFilter {
                $CommandName -eq 'Get-PesterFoo' -and $ParameterName -eq 'Bar'
            }
        }
    }

    It 'returns a CompletionResult for each matching candidate' {
        InModuleScope Boyles.PowerShell.Core {
            Mock Register-ArgumentCompleter { $script:captured = $ScriptBlock }

            Register-BPSArgumentCompleter -CommandName 'Get-PesterFoo' -ParameterName 'Bar' -CacheKey ([guid]::NewGuid().ToString()) -ValueProvider { @('Acme', 'Beta') }

            $results = @(& $script:captured 'Get-PesterFoo' 'Bar' '' $null @{})

            $results | Should -HaveCount 2
            $results[0] | Should -BeOfType ([System.Management.Automation.CompletionResult])
            $results.CompletionText | Should -Be @('Acme', 'Beta')
        }
    }

    It 'filters candidates by the word already typed' {
        InModuleScope Boyles.PowerShell.Core {
            Mock Register-ArgumentCompleter { $script:captured = $ScriptBlock }

            Register-BPSArgumentCompleter -CommandName 'Get-PesterFoo' -ParameterName 'Bar' -CacheKey ([guid]::NewGuid().ToString()) -ValueProvider { @('Acme', 'Beta') }

            $results = @(& $script:captured 'Get-PesterFoo' 'Bar' 'Ac' $null @{})

            $results | Should -HaveCount 1
            $results[0].CompletionText | Should -Be 'Acme'
        }
    }

    It 'reads ValueProperty, DisplayProperty, and TooltipProperty from object candidates' {
        InModuleScope Boyles.PowerShell.Core {
            Mock Register-ArgumentCompleter { $script:captured = $ScriptBlock }

            $candidates = @(
                [pscustomobject]@{ Name = 'Acme'; Id = 1; Description = 'First company' }
            )

            Register-BPSArgumentCompleter -CommandName 'Get-PesterFoo' -ParameterName 'Bar' -CacheKey ([guid]::NewGuid().ToString()) -ValueProvider { $candidates } -ValueProperty 'Name' -DisplayProperty 'Description' -TooltipProperty 'Id'

            $results = @(& $script:captured 'Get-PesterFoo' 'Bar' '' $null @{})

            $results | Should -HaveCount 1
            $results[0].CompletionText | Should -Be 'Acme'
            $results[0].ListItemText | Should -Be 'First company'
            $results[0].ToolTip | Should -Be '1'
        }
    }

    It 'quotes a completion value containing whitespace' {
        InModuleScope Boyles.PowerShell.Core {
            Mock Register-ArgumentCompleter { $script:captured = $ScriptBlock }

            Register-BPSArgumentCompleter -CommandName 'Get-PesterFoo' -ParameterName 'Bar' -CacheKey ([guid]::NewGuid().ToString()) -ValueProvider { @('Acme Corp') }

            $results = @(& $script:captured 'Get-PesterFoo' 'Bar' '' $null @{})

            $results[0].CompletionText | Should -Be "'Acme Corp'"
        }
    }

    It 'caches results and does not invoke ValueProvider again within CacheSeconds' {
        InModuleScope Boyles.PowerShell.Core {
            Mock Register-ArgumentCompleter { $script:captured = $ScriptBlock }

            $script:callCount = 0
            Register-BPSArgumentCompleter -CommandName 'Get-PesterFoo' -ParameterName 'Bar' -CacheKey ([guid]::NewGuid().ToString()) -CacheSeconds 300 -ValueProvider {
                $script:callCount++
                @('Acme')
            }

            @(& $script:captured 'Get-PesterFoo' 'Bar' '' $null @{}) | Out-Null
            @(& $script:captured 'Get-PesterFoo' 'Bar' '' $null @{}) | Out-Null

            $script:callCount | Should -Be 1
        }
    }

    It 'falls back to the cached candidates when ValueProvider throws on a cache refresh' {
        InModuleScope Boyles.PowerShell.Core {
            Mock Register-ArgumentCompleter { $script:captured = $ScriptBlock }

            $cacheKey = [guid]::NewGuid().ToString()
            $script:shouldThrow = $false

            Register-BPSArgumentCompleter -CommandName 'Get-PesterFoo' -ParameterName 'Bar' -CacheKey $cacheKey -CacheSeconds 300 -ValueProvider {
                if ($script:shouldThrow) {
                    throw 'boom'
                }
                @('Acme')
            }

            # Populate the cache successfully.
            @(& $script:captured 'Get-PesterFoo' 'Bar' '' $null @{}) | Out-Null

            # Force the cache entry to look expired, then make the next refresh fail.
            $entry = $null
            $script:BPSCompletionCache.TryGetValue($cacheKey, [ref] $entry) | Out-Null
            $entry.Timestamp = [DateTimeOffset]::UtcNow.AddSeconds(-301)
            $script:shouldThrow = $true

            $results = @(& $script:captured 'Get-PesterFoo' 'Bar' '' $null @{})

            $results | Should -HaveCount 1
            $results[0].CompletionText | Should -Be 'Acme'
        }
    }

    It 'refreshes from ValueProvider again once the cache entry has expired' {
        InModuleScope Boyles.PowerShell.Core {
            Mock Register-ArgumentCompleter { $script:captured = $ScriptBlock }

            $cacheKey = [guid]::NewGuid().ToString()
            $script:callCount = 0

            Register-BPSArgumentCompleter -CommandName 'Get-PesterFoo' -ParameterName 'Bar' -CacheKey $cacheKey -CacheSeconds 300 -ValueProvider {
                $script:callCount++
                @('Acme')
            }

            @(& $script:captured 'Get-PesterFoo' 'Bar' '' $null @{}) | Out-Null

            $entry = $null
            $script:BPSCompletionCache.TryGetValue($cacheKey, [ref] $entry) | Out-Null
            $entry.Timestamp = [DateTimeOffset]::UtcNow.AddSeconds(-301)

            @(& $script:captured 'Get-PesterFoo' 'Bar' '' $null @{}) | Out-Null

            $script:callCount | Should -Be 2
        }
    }

    It 'swallows an exception thrown by the completer body instead of propagating it' {
        InModuleScope Boyles.PowerShell.Core {
            Mock Register-ArgumentCompleter { $script:captured = $ScriptBlock }

            Register-BPSArgumentCompleter -CommandName 'Get-PesterFoo' -ParameterName 'Bar' -CacheKey ([guid]::NewGuid().ToString()) -ValueProvider {
                throw 'boom'
            }

            { & $script:captured 'Get-PesterFoo' 'Bar' '' $null @{} } | Should -Not -Throw
        }
    }
}
