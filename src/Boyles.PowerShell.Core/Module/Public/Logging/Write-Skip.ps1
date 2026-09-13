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
