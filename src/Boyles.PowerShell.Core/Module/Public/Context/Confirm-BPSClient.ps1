function Confirm-BPSClient {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Key,

        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $ServiceName
    )

    if (-not (Test-BPSClient -Key $Key)) {
        Write-Host $Key
        throw "$ServiceName is not connected!  Run Connect-$ServiceName to connect to the API."
    }
}
