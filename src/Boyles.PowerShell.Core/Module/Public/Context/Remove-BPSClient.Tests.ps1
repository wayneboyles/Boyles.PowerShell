#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Remove-BPSClient.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.

    Uses a fresh GUID-based key per test to avoid colliding with other tests or a real
    connected service.
#>

class FakeDisposableClientForRemove : System.IDisposable {
    [bool] $Disposed = $false
    [void] Dispose() {
        $this.Disposed = $true
    }
}

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

Describe 'Remove-BPSClient' {
    BeforeEach {
        $script:TestKey = "PesterTest-$([guid]::NewGuid())"
    }

    AfterEach {
        Remove-BPSClient -Key $script:TestKey
    }

    It 'removes a registered client' {
        Add-BPSClient -Key $script:TestKey -Client ([pscustomobject]@{ Name = 'fake-client' })

        Remove-BPSClient -Key $script:TestKey

        Test-BPSClient -Key $script:TestKey | Should -Be $false
    }

    It 'disposes the client if it implements IDisposable' {
        $client = [FakeDisposableClientForRemove]::new()
        Add-BPSClient -Key $script:TestKey -Client $client

        Remove-BPSClient -Key $script:TestKey

        $client.Disposed | Should -Be $true
    }

    It 'does not throw when no client is registered under the key' {
        { Remove-BPSClient -Key $script:TestKey } | Should -Not -Throw
    }
}
