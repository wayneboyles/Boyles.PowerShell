#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Write-Err.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.

    The -Terminate path calls the `exit` statement, which would kill the Pester host process
    itself if invoked in-process - that test spawns a real child PowerShell process instead and
    checks its exit code.
#>

BeforeAll {
    $script:ModuleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    $script:ManifestPath = Join-Path $script:ModuleRoot 'Boyles.PowerShell.Core.psd1'
    $script:BinPath = Join-Path $script:ModuleRoot 'bin\Boyles.PowerShell.Core.dll'

    if (-not (Test-Path $script:BinPath)) {
        throw "Compiled assembly not found at '$script:BinPath'. Run ./build.ps1 or 'dotnet build' first."
    }

    Import-Module -Name $script:ManifestPath -Force

    $script:HostExePath = (Get-Process -Id $PID).Path
}

AfterAll {
    Remove-Module -Name Boyles.PowerShell.Core -Force -ErrorAction SilentlyContinue
}

Describe 'Write-Err' {
    It 'writes the message prefixed with "[ERR ]" in red' {
        Write-Err -Message 'Failed to reach the Hudu API' -InformationVariable info

        $info[0].MessageData.Message | Should -Be '[ERR ] Failed to reach the Hudu API'
        $info[0].MessageData.ForegroundColor | Should -Be 'Red'
    }

    It 'does not terminate the process when -Terminate is not specified' {
        { Write-Err -Message 'Failed to reach the Hudu API' -InformationVariable info } | Should -Not -Throw
    }

    It 'terminates the process with the given exit code when -Terminate is specified' {
        $scriptBlock = "Import-Module '$($script:ManifestPath)' -Force; Write-Err -Message 'boom' -Terminate -ExitCode 7 *> `$null"

        & $script:HostExePath -NoProfile -NonInteractive -Command $scriptBlock

        $LASTEXITCODE | Should -Be 7
    }

    It 'defaults to exit code 1 when -Terminate is specified without -ExitCode' {
        $scriptBlock = "Import-Module '$($script:ManifestPath)' -Force; Write-Err -Message 'boom' -Terminate *> `$null"

        & $script:HostExePath -NoProfile -NonInteractive -Command $scriptBlock

        $LASTEXITCODE | Should -Be 1
    }
}
