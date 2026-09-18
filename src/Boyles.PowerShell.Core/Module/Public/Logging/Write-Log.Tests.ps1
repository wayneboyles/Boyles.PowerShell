#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for Write-Log.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.

    Write-Log reads $Global:LogFile / $Global:LogToConsole, so each test saves and restores
    them to avoid leaking state into other tests or the interactive session. Most tests set
    $Global:LogToConsole = $true in order to exercise console output at all - see the dedicated
    "suppresses console output by default" test below for the documented gotcha this guards
    against (an unset $Global:LogToConsole does NOT default to writing to the console).
#>

BeforeAll {
    $script:ModuleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    $script:ManifestPath = Join-Path $script:ModuleRoot 'Boyles.PowerShell.Core.psd1'
    $script:BinPath = Join-Path $script:ModuleRoot 'bin\Boyles.PowerShell.Core.dll'

    if (-not (Test-Path $script:BinPath)) {
        throw "Compiled assembly not found at '$script:BinPath'. Run ./build.ps1 or 'dotnet build' first."
    }

    Import-Module -Name $script:ManifestPath -Force

    $script:OriginalLogFile = $Global:LogFile
    $script:OriginalLogToConsole = $Global:LogToConsole
}

AfterAll {
    $Global:LogFile = $script:OriginalLogFile
    $Global:LogToConsole = $script:OriginalLogToConsole

    Remove-Module -Name Boyles.PowerShell.Core -Force -ErrorAction SilentlyContinue
}

Describe 'Write-Log' {
    BeforeEach {
        $Global:LogFile = $null
        $Global:LogToConsole = $true
    }

    It 'suppresses console output by default when $Global:LogToConsole has not been set' {
        # Known gotcha (see the DESCRIPTION in Write-Log.ps1): [bool]$Global:LogToConsole coerces
        # $null to $false, so leaving it unset suppresses console output entirely rather than
        # defaulting to "on".
        $Global:LogToConsole = $null

        Write-Log -Message 'Script started' -InformationVariable info

        $info | Should -BeNullOrEmpty
    }

    It 'writes a timestamped INFO line to the console when $Global:LogToConsole is $true' {
        Write-Log -Message 'Script started' -InformationVariable info

        $info | Should -HaveCount 1
        $info[0].MessageData.Message | Should -Match '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \| INFO    \| Script started$'
        $info[0].MessageData.ForegroundColor | Should -Be 'Cyan'
    }

    It 'maps each level to its console color' {
        @{ INFO = 'Cyan'; WARNING = 'Yellow'; ERROR = 'Red'; DEBUG = 'DarkGray'; SUCCESS = 'Green' }.GetEnumerator() | ForEach-Object {
            Write-Log -Message 'msg' -Level $_.Key -InformationVariable info

            $info[0].MessageData.ForegroundColor | Should -Be $_.Value -Because "Level $($_.Key) should use $($_.Value)"
        }
    }

    It 'rejects a level outside the ValidateSet' {
        { Write-Log -Message 'msg' -Level 'BOGUS' } | Should -Throw
    }

    It 'writes divider lines instead of a timestamped line when -Section is specified' {
        Write-Log -Message 'Phase 1: Connect' -Section -InformationVariable info

        $info | Should -HaveCount 5
        $info[2].MessageData.Message | Should -Be '  Phase 1: Connect'
        $info[0].MessageData.ForegroundColor | Should -Be 'White'
    }

    It 'suppresses console output when -NoConsole is specified' {
        Write-Log -Message 'Script started' -NoConsole -InformationVariable info

        $info | Should -BeNullOrEmpty
    }

    It 'suppresses console output when $Global:LogToConsole is $false' {
        $Global:LogToConsole = $false

        Write-Log -Message 'Script started' -InformationVariable info

        $info | Should -BeNullOrEmpty
    }

    It 'appends to $Global:LogFile when set' {
        $logPath = Join-Path ([System.IO.Path]::GetTempPath()) "bps-pester-$([guid]::NewGuid()).log"
        $Global:LogFile = $logPath

        try {
            Write-Log -Message 'Script started' -InformationVariable info | Out-Null

            Test-Path $logPath | Should -Be $true
            Get-Content -Path $logPath -Raw | Should -Match 'Script started'
        } finally {
            Remove-Item -Path $logPath -Force -ErrorAction SilentlyContinue
        }
    }

    It 'creates the log directory when it does not already exist' {
        $logDir = Join-Path ([System.IO.Path]::GetTempPath()) "bps-pester-dir-$([guid]::NewGuid())"
        $logPath = Join-Path $logDir 'test.log'
        $Global:LogFile = $logPath

        try {
            Test-Path $logDir | Should -Be $false

            Write-Log -Message 'Script started' -InformationVariable info | Out-Null

            Test-Path $logPath | Should -Be $true
        } finally {
            Remove-Item -Path $logDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    It 'still writes to the log file when -NoConsole is specified' {
        $logPath = Join-Path ([System.IO.Path]::GetTempPath()) "bps-pester-$([guid]::NewGuid()).log"
        $Global:LogFile = $logPath

        try {
            Write-Log -Message 'Script started' -NoConsole -InformationVariable info | Out-Null

            $info | Should -BeNullOrEmpty
            Get-Content -Path $logPath -Raw | Should -Match 'Script started'
        } finally {
            Remove-Item -Path $logPath -Force -ErrorAction SilentlyContinue
        }
    }
}
