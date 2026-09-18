#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Write-Header.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.
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

Describe 'Write-Header' {
    It 'writes the message followed by a matching-length dashed underline' {
        Write-Header -Message 'Connecting to Hudu' -InformationVariable info

        $info | Should -HaveCount 2
        $info[0].MessageData.Message | Should -Be 'Connecting to Hudu'
        $info[1].MessageData.Message | Should -Be ('-' * 'Connecting to Hudu'.Length)
    }

    It 'defaults to yellow' {
        Write-Header -Message 'Connecting to Hudu' -InformationVariable info

        $info[0].MessageData.ForegroundColor | Should -Be 'Yellow'
        $info[1].MessageData.ForegroundColor | Should -Be 'Yellow'
    }

    It 'honors a custom color' {
        Write-Header -Message 'Connecting to Hudu' -Color 'White' -InformationVariable info

        $info[0].MessageData.ForegroundColor | Should -Be 'White'
        $info[1].MessageData.ForegroundColor | Should -Be 'White'
    }
}
