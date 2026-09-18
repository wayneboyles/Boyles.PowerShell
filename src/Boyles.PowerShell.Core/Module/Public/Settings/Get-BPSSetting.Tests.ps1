#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Get-BPSSetting.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.

    Get-BPSSetting reads from the real, process-wide SettingsStore.Instance (persisted to the
    real per-user settings.json - see Get-BPSSettingPath), so every test uses a fresh GUID-based
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

Describe 'Get-BPSSetting' {
    BeforeEach {
        $script:TestSettingName = "PesterTest_$([guid]::NewGuid().ToString('N'))"
    }

    AfterEach {
        Remove-BPSSetting -Name $script:TestSettingName -Confirm:$false -ErrorAction SilentlyContinue
    }

    It 'returns $null for a setting that was never set' {
        Get-BPSSetting -Name $script:TestSettingName | Should -BeNullOrEmpty
    }

    It 'returns the value after it has been set' {
        Set-BPSSetting -Name $script:TestSettingName -Value 'hello' -Confirm:$false

        Get-BPSSetting -Name $script:TestSettingName | Should -Be 'hello'
    }

    It 'includes the setting among every stored setting when called with no -Name' {
        Set-BPSSetting -Name $script:TestSettingName -Value 'hello' -Confirm:$false

        $all = Get-BPSSetting

        $all.($script:TestSettingName) | Should -Be 'hello'
    }

    It 'accepts a setting name via the pipeline' {
        Set-BPSSetting -Name $script:TestSettingName -Value 'hello' -Confirm:$false

        $script:TestSettingName | Get-BPSSetting | Should -Be 'hello'
    }

    It 'accepts multiple setting names via the pipeline' {
        $otherName = "PesterTest_$([guid]::NewGuid().ToString('N'))"

        try {
            Set-BPSSetting -Name $script:TestSettingName -Value 'first' -Confirm:$false
            Set-BPSSetting -Name $otherName -Value 'second' -Confirm:$false

            $results = @($script:TestSettingName, $otherName) | Get-BPSSetting

            $results | Should -Be @('first', 'second')
        } finally {
            Remove-BPSSetting -Name $otherName -Confirm:$false -ErrorAction SilentlyContinue
        }
    }
}
