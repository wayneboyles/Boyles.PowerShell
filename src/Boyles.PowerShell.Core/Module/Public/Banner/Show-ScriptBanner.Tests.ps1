#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Show-ScriptBanner.

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

Describe 'Show-ScriptBanner' {
    It 'does not throw with valid parameters' {
        { Show-ScriptBanner -ScriptVersion '1.0.0' -ScriptDescription 'A short description.' -InformationVariable info } | Should -Not -Throw
    }

    It 'draws a bordered box with a version line and the description' {
        Show-ScriptBanner -ScriptVersion '1.2.3' -ScriptDescription 'A short description.' -InformationVariable info

        $info | Should -HaveCount 12
        $info[1].MessageData.Message | Should -Match '^╔═+╗$'
        $info[2].MessageData.Message | Should -Match 'Show-ScriptBanner\.ps1'
        $info[3].MessageData.Message | Should -Match 'Version 1\.2\.3'
        $info[6].MessageData.Message | Should -Match 'A short description\.'
        $info[8].MessageData.Message | Should -Match 'Author: Wayne Boyles'
        $info[10].MessageData.Message | Should -Match '^╚═+╝$'
    }

    It 'always shows "Show-ScriptBanner.ps1" as the script name, regardless of caller (known gotcha)' {
        # $PSCommandPath inside a dot-sourced function resolves to the file the function was
        # *defined* in (Show-ScriptBanner.ps1, dot-sourced by the module's .psm1 loader), not the
        # path of whatever top-level script calls Show-ScriptBanner. So the banner's "script name"
        # line is not actually the calling script's name - it is always this literal string.
        Show-ScriptBanner -ScriptVersion '1.0.0' -ScriptDescription 'desc' -InformationVariable info

        $info[2].MessageData.Message | Should -Match 'Show-ScriptBanner\.ps1'
    }

    It 'uses the default yellow color for bordered lines' {
        Show-ScriptBanner -ScriptVersion '1.0.0' -ScriptDescription 'desc' -InformationVariable info

        $info[1].MessageData.ForegroundColor | Should -Be 'Yellow'
    }

    It 'honors a custom color for bordered lines' {
        Show-ScriptBanner -ScriptVersion '1.0.0' -ScriptDescription 'desc' -Color 'Cyan' -InformationVariable info

        $info[1].MessageData.ForegroundColor | Should -Be 'Cyan'
    }

    It 'word-wraps a long description across multiple lines' {
        $longDescription = 'This is a much longer description that should definitely wrap across more than one line inside the banner box.'

        Show-ScriptBanner -ScriptVersion '1.0.0' -ScriptDescription $longDescription -InformationVariable info

        $info | Should -HaveCount 13
        $info[6].MessageData.Message | Should -Match 'This is a much longer description'
        $info[7].MessageData.Message | Should -Match 'wrap across more than one line'
    }

    It 'throws when ScriptVersion is empty' {
        { Show-ScriptBanner -ScriptVersion '' -ScriptDescription 'desc' } | Should -Throw
    }

    It 'throws when ScriptDescription is empty' {
        { Show-ScriptBanner -ScriptVersion '1.0.0' -ScriptDescription '' } | Should -Throw
    }
}
