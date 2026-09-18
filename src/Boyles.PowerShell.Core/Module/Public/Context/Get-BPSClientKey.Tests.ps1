#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Get-BPSClientKey.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.

    ContextCache is a process-wide static store, so this only asserts that a freshly registered
    key is included/excluded - it does not assume it is the only key present.
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

Describe 'Get-BPSClientKey' {
    BeforeEach {
        $script:TestKey = "PesterTest-$([guid]::NewGuid())"
    }

    AfterEach {
        Remove-BPSClient -Key $script:TestKey
    }

    It 'includes a freshly registered key' {
        Add-BPSClient -Key $script:TestKey -Client ([pscustomobject]@{ Name = 'fake-client' })

        Get-BPSClientKey | Should -Contain $script:TestKey
    }

    It 'no longer includes a key after it is removed' {
        Add-BPSClient -Key $script:TestKey -Client ([pscustomobject]@{ Name = 'fake-client' })
        Remove-BPSClient -Key $script:TestKey

        Get-BPSClientKey | Should -Not -Contain $script:TestKey
    }
}
