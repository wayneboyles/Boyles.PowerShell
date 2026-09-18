#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Add-BPSClient.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.

    Add-BPSClient/Get-BPSClient/Remove-BPSClient share one process-wide, static client store
    (ContextCache), so every test uses a fresh GUID-based key to avoid colliding with other tests
    or a real connected service, and removes that key afterward.
#>

class FakeDisposableClientForAdd : System.IDisposable {
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

Describe 'Add-BPSClient' {
    BeforeEach {
        $script:TestKey = "PesterTest-$([guid]::NewGuid())"
    }

    AfterEach {
        Remove-BPSClient -Key $script:TestKey
    }

    It 'registers a client retrievable via Get-BPSClient' {
        $client = [pscustomobject]@{ Name = 'fake-client' }

        Add-BPSClient -Key $script:TestKey -Client $client

        Get-BPSClient -Key $script:TestKey | Should -Be $client
    }

    It 'replaces a client already registered under the same key' {
        Add-BPSClient -Key $script:TestKey -Client ([pscustomobject]@{ Name = 'first' })
        Add-BPSClient -Key $script:TestKey -Client ([pscustomobject]@{ Name = 'second' })

        (Get-BPSClient -Key $script:TestKey).Name | Should -Be 'second'
    }

    It 'disposes the previous client when it is replaced and implements IDisposable' {
        $first = [FakeDisposableClientForAdd]::new()
        $second = [FakeDisposableClientForAdd]::new()

        Add-BPSClient -Key $script:TestKey -Client $first
        Add-BPSClient -Key $script:TestKey -Client $second

        $first.Disposed | Should -Be $true
        $second.Disposed | Should -Be $false
    }

    It 'does not dispose the client when the same reference is re-registered' {
        $client = [FakeDisposableClientForAdd]::new()

        Add-BPSClient -Key $script:TestKey -Client $client
        Add-BPSClient -Key $script:TestKey -Client $client

        $client.Disposed | Should -Be $false
    }
}
