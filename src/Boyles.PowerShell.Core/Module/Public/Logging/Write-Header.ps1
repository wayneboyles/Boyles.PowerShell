<#
.SYNOPSIS
    Writes a message to the console underlined with a matching-length divider.

.DESCRIPTION
    Writes the message, then a line of dashes as long as the message itself, both in the given
    console color. Useful for marking the start of a distinct section of script output.

.PARAMETER Message
    The header text to write.

.PARAMETER Color
    Console foreground color to write in. Defaults to 'Yellow'.

.EXAMPLE
    Write-Header 'Connecting to Hudu'

    Writes "Connecting to Hudu" followed by a matching dashed underline, in yellow.
#>
function Write-Header {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string] $Message,

        [Parameter()]
        [string] $Color = 'Yellow'
    )

    process {
        Write-Host $Message -ForegroundColor $Color
        Write-Host ('-' * $Message.Length) -ForegroundColor $Color
    }
}
