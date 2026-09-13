#Requires -Modules Pester

BeforeAll {
    $repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    $outRoot = Join-Path $repoRoot 'out'
    $manifestPath = Join-Path $outRoot 'Boyles.PowerShell.Hudu\Boyles.PowerShell.Hudu.psd1'

    if (-not (Test-Path $manifestPath)) {
        throw "Staged module not found at '$manifestPath'. Run ./build.ps1 first."
    }

    if ($env:PSModulePath -notlike "*$outRoot*") {
        $env:PSModulePath = "$outRoot$([System.IO.Path]::PathSeparator)$env:PSModulePath"
    }

    Import-Module -Name $manifestPath -Force
}

Describe 'Boyles.PowerShell.Hudu' {
    It 'has a valid module manifest' {
        $manifestPath = Join-Path (Split-Path -Parent (Split-Path -Parent $PSScriptRoot)) 'out\Boyles.PowerShell.Hudu\Boyles.PowerShell.Hudu.psd1'
        { Test-ModuleManifest -Path $manifestPath -ErrorAction Stop } | Should -Not -Throw
    }

    It 'automatically pulls in Boyles.PowerShell.Core via RequiredModules' {
        Get-Module -Name Boyles.PowerShell.Core | Should -Not -BeNullOrEmpty
    }

    It 'exports Connect-BoylesHudu and Get-BoylesHuduAsset' {
        Get-Command -Module Boyles.PowerShell.Hudu -Name Connect-BoylesHudu | Should -Not -BeNullOrEmpty
        Get-Command -Module Boyles.PowerShell.Hudu -Name Get-BoylesHuduAsset | Should -Not -BeNullOrEmpty
    }

    It 'fails with a clear error when Get-BoylesHuduAsset is called before connecting' {
        Disconnect-Boyles -ServiceName 'Hudu' -ErrorAction SilentlyContinue

        { Get-BoylesHuduAsset } | Should -Throw -ExpectedMessage '*Connect-Boyles*'
    }
}
