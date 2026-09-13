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
