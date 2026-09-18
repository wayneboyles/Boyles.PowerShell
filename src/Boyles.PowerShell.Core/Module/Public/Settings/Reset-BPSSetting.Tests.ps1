#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Reset-BPSSetting.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.

    Reset-BPSSetting clears EVERY setting in the real, process-wide SettingsStore.Instance
    (persisted to the real per-user settings.json - see Get-BPSSettingPath) - there is no isolated
    instance to redirect it at, since the cmdlet always reads SettingsStore.Instance directly.
    Deliberately, this suite never actually invokes a real (non-WhatIf) reset: doing so would
    briefly wipe every real setting on whatever machine runs the tests. It only verifies the
    ShouldProcess/-WhatIf safety plumbing, which is exactly what stands between a routine test run
    and a real wipe.
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

Describe 'Reset-BPSSetting' {
    It 'supports ShouldProcess' {
        (Get-Command Reset-BPSSetting).Parameters.Keys | Should -Contain 'WhatIf'
    }

    It 'has a High confirm impact, given it clears every setting' {
        $cmdletBinding = (Get-Command Reset-BPSSetting).ScriptBlock.Attributes |
            Where-Object { $_ -is [System.Management.Automation.CmdletBindingAttribute] }

        $cmdletBinding.ConfirmImpact | Should -Be 'High'
    }

    It 'does not remove an existing setting when -WhatIf is specified' {
        $testSettingName = "PesterTest_$([guid]::NewGuid().ToString('N'))"
        Set-BPSSetting -Name $testSettingName -Value 'hello' -Confirm:$false

        try {
            Reset-BPSSetting -WhatIf

            Get-BPSSetting -Name $testSettingName | Should -Be 'hello'
        } finally {
            Remove-BPSSetting -Name $testSettingName -Confirm:$false -ErrorAction SilentlyContinue
        }
    }
}
