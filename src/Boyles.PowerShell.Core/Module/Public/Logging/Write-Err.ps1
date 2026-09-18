<#
.SYNOPSIS
    Writes an error status line to the console, optionally terminating the script.

.DESCRIPTION
    Writes the message prefixed with "[ERR ]" in red. When -Terminate is specified, exits the
    process afterward with the given exit code instead of letting execution continue.

.PARAMETER Message
    The error message to write.

.PARAMETER ExitCode
    Exit code to use when -Terminate is specified. Defaults to 1.

.PARAMETER Terminate
    Exits the process with ExitCode after writing the message.

.EXAMPLE
    Write-Err 'Failed to reach the Hudu API'

    Writes "[ERR ] Failed to reach the Hudu API" in red and continues execution.

.EXAMPLE
    Write-Err 'Missing required setting' -Terminate -ExitCode 2

    Writes the message, then exits the process with code 2.
#>
function Write-Err {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string] $Message,

        [Parameter()]
        [int] $ExitCode = 1,

        [Parameter()]
        [switch] $Terminate
    )

    process {
        Write-Host "[ERR ] $Message" -ForegroundColor Red

        if ($Terminate) {
            exit $ExitCode
        }
    }
}
