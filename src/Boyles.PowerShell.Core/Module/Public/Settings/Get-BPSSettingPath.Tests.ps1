#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Get-BPSSettingPath.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.

    Read-only: unlike the other Settings tests, this never touches the real settings file.
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

Describe 'Get-BPSSettingPath' {
    It 'returns a non-empty path ending in settings.json' {
        $path = Get-BPSSettingPath

        $path | Should -Not -BeNullOrEmpty
        $path | Should -Match 'settings\.json$'
    }

    It 'matches the underlying SettingsStore.Instance.SettingsFilePath' {
        Get-BPSSettingPath | Should -Be ([Boyles.PowerShell.Settings.SettingsStore]::Instance.SettingsFilePath)
    }

    It 'returns the same path on repeated calls' {
        (Get-BPSSettingPath) | Should -Be (Get-BPSSettingPath)
    }
}
