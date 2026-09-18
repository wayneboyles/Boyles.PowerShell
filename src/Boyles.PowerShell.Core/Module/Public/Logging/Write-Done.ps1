<#
.SYNOPSIS
    Writes a "done" status line to the console.

.DESCRIPTION
    Writes the message prefixed with "[OK  ]" in the given console color. Intended as the
    success-case counterpart to Write-Err/Write-Skip/Write-Step when reporting the outcome of a
    script step.

.PARAMETER Message
    The message to write.

.PARAMETER Color
    Console foreground color to write in. Defaults to 'Green'.

.EXAMPLE
    Write-Done 'Company synced'

    Writes "[OK  ] Company synced" in green.
#>
function Write-Done {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string] $Message,

        [Parameter()]
        [string] $Color = 'Green'
    )

    process {
        Write-Host "[OK  ] $Message" -ForegroundColor $Color
    }
}
