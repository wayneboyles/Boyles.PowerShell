#Requires -Modules Pester

BeforeAll {
    $repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    $outRoot = Join-Path $repoRoot 'out'
    $manifestPath = Join-Path $outRoot 'Boyles.PowerShell.Core\Boyles.PowerShell.Core.psd1'

    if (-not (Test-Path $manifestPath)) {
        throw "Staged module not found at '$manifestPath'. Run ./build.ps1 first."
    }

    # RequiredModules resolution (both Import-Module's and Test-ModuleManifest's)
    # searches $env:PSModulePath, not "wherever the manifest we loaded lives" -
    # so sibling modules under out\ must be discoverable there too.
    if ($env:PSModulePath -notlike "*$outRoot*") {
        $env:PSModulePath = "$outRoot$([System.IO.Path]::PathSeparator)$env:PSModulePath"
    }

    Import-Module -Name $manifestPath -Force
}

Describe 'Boyles.PowerShell.Core' {
    It 'has a valid module manifest' {
        $manifestPath = Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) 'out\Boyles.PowerShell.Core\Boyles.PowerShell.Core.psd1'
        { Test-ModuleManifest -Path $manifestPath -ErrorAction Stop } | Should -Not -Throw
    }

    It 'exports Connect-Boyles, Disconnect-Boyles, and Get-BoylesContext' {
        Get-Command -Module Boyles.PowerShell.Core -Name Connect-Boyles | Should -Not -BeNullOrEmpty
        Get-Command -Module Boyles.PowerShell.Core -Name Disconnect-Boyles | Should -Not -BeNullOrEmpty
        Get-Command -Module Boyles.PowerShell.Core -Name Get-BoylesContext | Should -Not -BeNullOrEmpty
    }

    It 'connects and stores a retrievable context' {
        Connect-Boyles -ServiceName 'PesterTest' -BaseUri 'https://example.test' -ApiKey 'unit-test-key' | Out-Null

        $connection = Get-BoylesContext -ServiceName 'PesterTest'

        $connection | Should -Not -BeNullOrEmpty
        $connection.ServiceName | Should -Be 'PesterTest'

        Disconnect-Boyles -ServiceName 'PesterTest'
    }
}
