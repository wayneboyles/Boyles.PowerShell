#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Confirm-BPSClient.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.

    Uses a fresh GUID-based key per test to avoid colliding with other tests or a real
    connected service, and removes that key afterward.
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

Describe 'Confirm-BPSClient' {
    BeforeEach {
        $script:TestKey = "PesterTest-$([guid]::NewGuid())"
    }

    AfterEach {
        Remove-BPSClient -Key $script:TestKey
    }

    It 'does not throw when a client is registered under the key' {
        Add-BPSClient -Key $script:TestKey -Client ([pscustomobject]@{ Name = 'fake-client' })

        { Confirm-BPSClient -Key $script:TestKey -ServiceName 'PesterService' } | Should -Not -Throw
    }

    It 'throws a message naming the service and its Connect-* cmdlet when not connected' {
        { Confirm-BPSClient -Key $script:TestKey -ServiceName 'PesterService' } | Should -Throw '*PesterService*Connect-PesterService*'
    }
}
