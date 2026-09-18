#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for the Boyles.PowerShell.Core module manifest.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.
#>

BeforeAll {
    $script:ManifestPath = Join-Path $PSScriptRoot 'Boyles.PowerShell.Core.psd1'
    $script:BinPath = Join-Path $PSScriptRoot 'bin\Boyles.PowerShell.Core.dll'

    if (-not (Test-Path $script:BinPath)) {
        throw "Compiled assembly not found at '$script:BinPath'. Run ./build.ps1 or 'dotnet build' first."
    }

    Import-Module -Name $script:ManifestPath -Force
}

AfterAll {
    Remove-Module -Name Boyles.PowerShell.Core -Force -ErrorAction SilentlyContinue
}

Describe 'Boyles.PowerShell.Core module manifest' {
    It 'is a valid module manifest' {
        { Test-ModuleManifest -Path $script:ManifestPath -ErrorAction Stop } | Should -Not -Throw
    }

    It 'imports successfully' {
        Get-Module -Name Boyles.PowerShell.Core | Should -Not -BeNullOrEmpty
    }

    It 'exports every function listed in FunctionsToExport' {
        $manifest = Test-ModuleManifest -Path $script:ManifestPath

        foreach ($functionName in $manifest.ExportedFunctions.Keys) {
            Get-Command -Module Boyles.PowerShell.Core -Name $functionName -ErrorAction SilentlyContinue |
                Should -Not -BeNullOrEmpty -Because "FunctionsToExport lists '$functionName'"
        }
    }

    It 'exports a function for every script under Module\Public (regression guard for the missing -Recurse bug)' {
        $publicRoot = Join-Path $PSScriptRoot 'Public'
        $expectedNames = Get-ChildItem -Path $publicRoot -Filter '*.ps1' -Exclude '*.Tests.ps1' -File -Recurse | Select-Object -ExpandProperty BaseName
        $module = Get-Module -Name Boyles.PowerShell.Core

        foreach ($name in $expectedNames) {
            $module.ExportedFunctions.Keys | Should -Contain $name
        }
    }
}
