<#
.SYNOPSIS
    Writes a "skipped" status line to the console.

.DESCRIPTION
    Writes the message prefixed with "[SKIP]" in the given console color. Intended for reporting
    a script step that was intentionally skipped.

.PARAMETER Message
    The message to write.

.PARAMETER Color
    Console foreground color to write in. Defaults to 'DarkGray'.

.EXAMPLE
    Write-Skip 'Company already exists, skipping create'

    Writes "[SKIP] Company already exists, skipping create" in dark gray.
#>
function Write-Skip {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string] $Message,

        [Parameter()]
        [string] $Color = 'DarkGray'
    )

    process {
        Write-Host "[SKIP] $Message" -ForegroundColor $Color
    }
}
