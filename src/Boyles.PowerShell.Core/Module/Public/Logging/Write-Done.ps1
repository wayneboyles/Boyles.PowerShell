<#
    .SYNOPSIS
        Write a header to the console
    .PARAMETER Message
        The header to write
    .PARAMETER Color
        The color of the Header.  Defaults to Green
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
