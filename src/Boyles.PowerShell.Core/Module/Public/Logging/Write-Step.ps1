<#
.SYNOPSIS
    Writes a labeled progress line to the console.

.DESCRIPTION
    Writes the message prefixed with "[<Prefix>]" in the given console color. Intended for
    reporting the start of a script step, with a customizable prefix label.

.PARAMETER Message
    The message to write.

.PARAMETER Prefix
    Label shown in brackets before the message. Defaults to 'TASK'.

.PARAMETER Color
    Console foreground color to write in. Defaults to 'Cyan'.

.EXAMPLE
    Write-Step 'Fetching companies from Hudu'

    Writes "[TASK] Fetching companies from Hudu" in cyan.

.EXAMPLE
    Write-Step 'Uploading results' -Prefix 'STEP' -Color White

    Writes "[STEP] Uploading results" in white.
#>
function Write-Step {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string] $Message,

        [Parameter()]
        [string] $Prefix = 'TASK',

        [Parameter()]
        [string] $Color = 'Cyan'
    )

    process {
        Write-Host "[$($Prefix)] $Message" -ForegroundColor $Color
    }
}
