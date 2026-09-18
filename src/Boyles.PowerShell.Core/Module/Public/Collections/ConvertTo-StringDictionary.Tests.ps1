#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for ConvertTo-StringDictionary.

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

Describe 'ConvertTo-StringDictionary' {
    It 'returns a Dictionary[string, string]' {
        # Assigned to a variable first: passed as a bare argument, PowerShell's argument-mode
        # parser mistakes the generic type literal's comma for an array constructor.
        $expectedType = [System.Collections.Generic.Dictionary[string, string]]
        $result = ConvertTo-StringDictionary -Table @{ name = 'Acme' }

        $result | Should -BeOfType $expectedType
    }

    It 'returns an empty dictionary for an empty hashtable' {
        $result = ConvertTo-StringDictionary -Table @{}

        $result.Count | Should -Be 0
    }

    It 'passes string values through unchanged' {
        $result = ConvertTo-StringDictionary -Table @{ name = 'Acme' }

        $result['name'] | Should -Be 'Acme'
    }

    It 'stringifies numeric values' {
        $result = ConvertTo-StringDictionary -Table @{ page_size = 25 }

        $result['page_size'] | Should -Be '25'
        $result['page_size'] | Should -BeOfType [string]
    }

    It 'renders $true as lowercase "true"' {
        $result = ConvertTo-StringDictionary -Table @{ archived = $true }

        $result['archived'] | Should -Be 'true'
    }

    It 'renders $false as lowercase "false"' {
        $result = ConvertTo-StringDictionary -Table @{ archived = $false }

        $result['archived'] | Should -Be 'false'
    }

    It 'stringifies non-string keys' {
        $result = ConvertTo-StringDictionary -Table @{ 7 = 'seven' }

        $result.ContainsKey('7') | Should -Be $true
        $result['7'] | Should -Be 'seven'
    }

    It 'converts every entry in a multi-value hashtable' {
        $result = ConvertTo-StringDictionary -Table @{
            archived  = $true
            page_size = 25
            name      = 'Acme'
        }

        $result.Count | Should -Be 3
        $result['archived'] | Should -Be 'true'
        $result['page_size'] | Should -Be '25'
        $result['name'] | Should -Be 'Acme'
    }

    It 'throws when Table is $null' {
        { ConvertTo-StringDictionary -Table $null } | Should -Throw
    }

    It 'throws when Table is not a hashtable' {
        { ConvertTo-StringDictionary -Table 'not a hashtable' } | Should -Throw
    }
}
