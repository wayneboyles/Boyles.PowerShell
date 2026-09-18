#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Write-Step.

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

Describe 'Write-Step' {
    It 'writes the message prefixed with the default "[TASK]" label' {
        Write-Step -Message 'Fetching companies from Hudu' -InformationVariable info

        $info[0].MessageData.Message | Should -Be '[TASK] Fetching companies from Hudu'
    }

    It 'defaults to cyan' {
        Write-Step -Message 'Fetching companies from Hudu' -InformationVariable info

        $info[0].MessageData.ForegroundColor | Should -Be 'Cyan'
    }

    It 'honors a custom prefix' {
        Write-Step -Message 'Uploading results' -Prefix 'STEP' -InformationVariable info

        $info[0].MessageData.Message | Should -Be '[STEP] Uploading results'
    }

    It 'honors a custom color' {
        Write-Step -Message 'Uploading results' -Color 'White' -InformationVariable info

        $info[0].MessageData.ForegroundColor | Should -Be 'White'
    }
}
