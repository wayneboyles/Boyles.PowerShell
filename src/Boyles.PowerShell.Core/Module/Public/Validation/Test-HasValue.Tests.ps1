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

    Context 'array inputs (known gotcha - see below)' {
        # PowerShell's `switch` statement auto-enumerates a plain array/collection before testing
        # any of Test-HasValue's `-is [...]` branches (it does NOT do this for a Hashtable, which
        # switch treats as one scalar object - that's why the hashtable tests above behave as
        # documented). For an array, this means the -is [ICollection]/[IEnumerable] branches -
        # which are supposed to check "does the collection have any elements" - are never actually
        # reached: switch instead evaluates the branches against the FIRST ELEMENT only, and
        # `return` inside that case exits the function immediately. The result for an array
        # therefore depends on the type/value of its first element, not on whether the array
        # itself has content - these tests lock in that verified (buggy) behavior rather than the
        # documented intent, so a fix doesn't silently change behavior unnoticed.

        It 'returns $null (not $false) for an empty array, because switch performs zero iterations' {
            Test-HasValue -Value @() | Should -BeNullOrEmpty
        }

        It 'returns $false for a non-empty array whose first element is a default value type, even though the array has content' {
            Test-HasValue -Value @(0, 'real value') | Should -Be $false
        }

        It 'returns $true for a non-empty array whose first element is a non-default value type' {
            Test-HasValue -Value @(5, 0) | Should -Be $true
        }

        It 'gives a different result for the same content in a different order (order-dependent)' {
            Test-HasValue -Value @(0, 5) | Should -Be $false
            Test-HasValue -Value @(5, 0) | Should -Be $true
        }
    }
}
