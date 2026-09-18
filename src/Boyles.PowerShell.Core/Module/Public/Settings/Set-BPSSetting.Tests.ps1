#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Set-BPSSetting.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.

    Set-BPSSetting writes to the real, process-wide SettingsStore.Instance (persisted to the real
    per-user settings.json - see Get-BPSSettingPath), so every test uses a fresh GUID-based
    setting name to avoid colliding with a real stored setting, and removes it afterward.
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

Describe 'Set-BPSSetting' {
    BeforeEach {
        $script:TestSettingName = "PesterTest_$([guid]::NewGuid().ToString('N'))"
    }

    AfterEach {
        Remove-BPSSetting -Name $script:TestSettingName -Confirm:$false -ErrorAction SilentlyContinue
    }

    It 'sets a new value retrievable via Get-BPSSetting' {
        Set-BPSSetting -Name $script:TestSettingName -Value 'hello' -Confirm:$false

        Get-BPSSetting -Name $script:TestSettingName | Should -Be 'hello'
    }

    It 'overwrites a value already set' {
        Set-BPSSetting -Name $script:TestSettingName -Value 'first' -Confirm:$false
        Set-BPSSetting -Name $script:TestSettingName -Value 'second' -Confirm:$false

        Get-BPSSetting -Name $script:TestSettingName | Should -Be 'second'
    }

    It 'stores a boolean value' {
        Set-BPSSetting -Name $script:TestSettingName -Value $true -Confirm:$false

        Get-BPSSetting -Name $script:TestSettingName | Should -Be $true
    }

    It 'stores an integer value' {
        Set-BPSSetting -Name $script:TestSettingName -Value 3 -Confirm:$false

        Get-BPSSetting -Name $script:TestSettingName | Should -Be 3
    }

    It 'does not persist the change when -WhatIf is specified' {
        Set-BPSSetting -Name $script:TestSettingName -Value 'hello' -WhatIf

        Get-BPSSetting -Name $script:TestSettingName | Should -BeNullOrEmpty
    }
}
