#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Test-HasValue.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.
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

Describe 'Test-HasValue' {
    It 'returns $false for $null' {
        Test-HasValue -Value $null | Should -Be $false
    }

    It 'returns $false for an empty string' {
        Test-HasValue -Value '' | Should -Be $false
    }

    It 'returns $false for a whitespace-only string' {
        Test-HasValue -Value '   ' | Should -Be $false
    }

    It 'returns $true for a non-empty string' {
        Test-HasValue -Value 'hello' | Should -Be $true
    }

    It 'returns $false for the default value of a value type (0)' {
        Test-HasValue -Value 0 | Should -Be $false
    }

    It 'returns $true for a non-default value type' {
        Test-HasValue -Value 5 | Should -Be $true
    }

    It 'returns $false for $false (the default value of [bool])' {
        Test-HasValue -Value $false | Should -Be $false
    }

    It 'returns $true for $true' {
        Test-HasValue -Value $true | Should -Be $true
    }

    It 'returns $false for [datetime]::MinValue (the default value of [datetime])' {
        Test-HasValue -Value ([datetime]::MinValue) | Should -Be $false
    }

    It 'returns $true for a non-default [datetime]' {
        Test-HasValue -Value (Get-Date) | Should -Be $true
    }

    It 'returns $true for an arbitrary reference-type object' {
        Test-HasValue -Value ([pscustomobject]@{ Name = 'Acme' }) | Should -Be $true
    }

    It 'returns $false for an empty hashtable' {
        Test-HasValue -Value @{} | Should -Be $false
    }

    It 'returns $true for a non-empty hashtable' {
        Test-HasValue -Value @{ Name = 'Acme' } | Should -Be $true
    }

    It 'accepts pipeline input' {
        'hello' | Test-HasValue | Should -Be $true
    }

    Context 'array inputs' {
        # Regression coverage for a fixed bug: the function used to test $Value via a `switch`
        # statement, which auto-enumerates a plain array/collection (it does NOT do this for a
        # Hashtable, which switch treats as one scalar object - that's why the hashtable tests
        # above were never affected). That meant the -is [ICollection] branch - meant to check
        # "does the collection have any elements" - was never actually reached for an array:
        # switch instead evaluated the branches against the array's FIRST ELEMENT only. An empty
        # array returned $null (zero switch iterations), and a non-empty array's result depended
        # on its first element's type/value rather than whether the array had content at all.
        # Rewritten as an if/elseif chain, which tests $Value as a whole and fixes all of this.

        It 'returns $false for an empty array' {
            Test-HasValue -Value @() | Should -Be $false
        }

        It 'returns $true for a non-empty array, regardless of its first element' {
            Test-HasValue -Value @(0, 'real value') | Should -Be $true
        }

        It 'returns the same result regardless of element order' {
            Test-HasValue -Value @(0, 5) | Should -Be $true
            Test-HasValue -Value @(5, 0) | Should -Be $true
        }
    }
}
