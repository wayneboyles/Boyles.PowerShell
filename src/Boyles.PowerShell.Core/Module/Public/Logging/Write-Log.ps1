<#
.SYNOPSIS
    Writes a timestamped log entry to the console and an optional log file.

.DESCRIPTION
    Reads the log file path from $Global:LogFile set in the calling script; when set, every log
    line is also appended there (creating the containing directory if needed). Use -Section to
    write a visual section header to organize log output into readable blocks.

    Console output is gated by $Global:LogToConsole: it must be set to $true for console output
    to appear at all. Leaving it unset (the default, $null) or setting it to $false both suppress
    console output, same as passing -NoConsole - despite what "if not set" might suggest, an
    unset $Global:LogToConsole does NOT default to writing to the console.

.PARAMETER Message
    The message to log.

.PARAMETER Level
    Log severity level: INFO, WARNING, ERROR, DEBUG, or SUCCESS. Defaults to INFO.

.PARAMETER Section
    Renders the message as a visual section header with divider lines.

.PARAMETER NoConsole
    Suppresses console output; writes to the log file only. Console output is already suppressed
    by default unless $Global:LogToConsole has been explicitly set to $true - see DESCRIPTION.

.EXAMPLE
    $Global:LogFile = "C:\Logs\MyScript_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

    Write-Log 'Script started'
    Write-Log 'Phase 1: Connect' -Section
    Write-Log 'Connected to server'  -Level SUCCESS
    Write-Log 'Retrying in 5s'       -Level WARNING
    Write-Log 'Connection refused'   -Level ERROR
#>
function Write-Log {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string] $Message,

        [Parameter()]
        [ValidateSet('INFO', 'WARNING', 'ERROR', 'DEBUG', 'SUCCESS')]
        [string] $Level = 'INFO',

        [Parameter()]
        [switch] $Section,

        [Parameter()]
        [switch] $NoConsole
    )

    process {
        [string] $logFile = $Global:LogFile
        [bool]   $consoleOutput = $Global:LogToConsole

        if ($null -ne $consoleOutput -and $consoleOutput -eq $false) {
            $NoConsole = $true
        }

        if ($Section) {
            $divider = '-' * 80
            $lines = @('', $divider, "  $Message", $divider, '')
            $color = 'White'
        } else {
            $timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
            $tag = $Level.PadRight(7)
            $lines = @("$timestamp | $tag | $Message")
            $color = switch ($Level) {
                'INFO' {
                    'Cyan'
                }
                'WARNING' {
                    'Yellow'
                }
                'ERROR' {
                    'Red'
                }
                'DEBUG' {
                    'DarkGray'
                }
                'SUCCESS' {
                    'Green'
                }
            }
        }

        if (-not $NoConsole) {
            foreach ($line in $lines) {
                Write-Host $line -ForegroundColor $color
            }
        }

        if ($logFile) {
            $logDir = Split-Path -Path $logFile -Parent

            if ($logDir -and -not (Test-Path -Path $logDir)) {
                $null = New-Item -ItemType Directory -Path $logDir -Force
            }

            Add-Content -Path $logFile -Value $lines -Encoding UTF8
        }
    }
}
