#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Test-RequiredValue.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.

    Test-RequiredValue's empty-value behavior branches on whether the current session is
    interactive. That branch is computed once here (using the exact same check the function
    itself uses) so the right half of the suite runs and the other half is skipped, regardless of
    which kind of session actually runs these tests.
#>

$script:IsNonInteractiveHost = -not [Environment]::UserInteractive -or (([Environment]::GetCommandLineArgs()) -match '-NonInteractive')

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

Describe 'Test-RequiredValue' {
    It 'returns the value unchanged when already provided' {
        Test-RequiredValue -Name 'ApiKey' -Value 'already-set' | Should -Be 'already-set'
    }

    It 'returns the value unchanged when already provided, even with -Secret' {
        Test-RequiredValue -Name 'ApiKey' -Value 'already-set' -Secret | Should -Be 'already-set'
    }

    It 'throws naming the value when empty and no interactive session is available' -Skip:(-not $script:IsNonInteractiveHost) {
        { Test-RequiredValue -Name 'ApiKey' -Value '' } | Should -Throw "*'ApiKey'*"
    }

    It 'prompts via Read-Host when empty and the session is interactive' -Skip:$script:IsNonInteractiveHost {
        InModuleScope Boyles.PowerShell.Core {
            Mock Read-Host { 'typed-value' }

            Test-RequiredValue -Name 'ApiKey' -Value '' | Should -Be 'typed-value'
        }
    }

    It 'prompts with masked input via Read-Host -AsSecureString when empty, interactive, and -Secret is specified' -Skip:$script:IsNonInteractiveHost {
        InModuleScope Boyles.PowerShell.Core {
            $secure = ConvertTo-SecureString -String 'typed-secret' -AsPlainText -Force
            Mock Read-Host { $secure } -ParameterFilter { $AsSecureString }

            Test-RequiredValue -Name 'ApiKey' -Value '' -Secret | Should -Be 'typed-secret'
        }
    }
}
