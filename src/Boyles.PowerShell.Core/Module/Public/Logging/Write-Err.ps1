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
