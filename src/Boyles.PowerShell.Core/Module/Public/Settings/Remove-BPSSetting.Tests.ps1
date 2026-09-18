#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Remove-BPSSetting.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.

    Remove-BPSSetting mutates the real, process-wide SettingsStore.Instance (persisted to the real
    per-user settings.json - see Get-BPSSettingPath), so every test uses a fresh GUID-based
    setting name to avoid colliding with a real stored setting, and removes it afterward
    regardless of what a given test did to it.
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

Describe 'Remove-BPSSetting' {
    BeforeEach {
        $script:TestSettingName = "PesterTest_$([guid]::NewGuid().ToString('N'))"
        Set-BPSSetting -Name $script:TestSettingName -Value 'hello' -Confirm:$false
    }

    AfterEach {
        Remove-BPSSetting -Name $script:TestSettingName -Confirm:$false -ErrorAction SilentlyContinue
    }

    It 'removes a setting so Get-BPSSetting returns $null afterward' {
        Remove-BPSSetting -Name $script:TestSettingName -Confirm:$false

        Get-BPSSetting -Name $script:TestSettingName | Should -BeNullOrEmpty
    }

    It 'does not remove the setting when -WhatIf is specified' {
        Remove-BPSSetting -Name $script:TestSettingName -WhatIf

        Get-BPSSetting -Name $script:TestSettingName | Should -Be 'hello'
    }

    It 'accepts a setting name via the pipeline' {
        $script:TestSettingName | Remove-BPSSetting -Confirm:$false

        Get-BPSSetting -Name $script:TestSettingName | Should -BeNullOrEmpty
    }

    It 'does not throw when the setting was never set' {
        $neverSet = "PesterTest_$([guid]::NewGuid().ToString('N'))"

        { Remove-BPSSetting -Name $neverSet -Confirm:$false } | Should -Not -Throw
    }
}
