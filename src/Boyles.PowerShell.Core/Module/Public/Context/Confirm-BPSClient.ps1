<#
.SYNOPSIS
    Throws if a client is not currently registered under the given key.

.DESCRIPTION
    Wraps Test-BPSClient with a clearer, service-specific error message than the exception
    Get-BPSClient throws on a missing key. Intended to be called at the top of a service module's
    cmdlets to fail fast with actionable guidance when the user hasn't connected yet.

.PARAMETER Key
    The key the client should be registered under.

.PARAMETER ServiceName
    Name of the service, used to build the error message (e.g. "Run Connect-<ServiceName>").

.EXAMPLE
    Confirm-BPSClient -Key 'Hudu' -ServiceName 'Hudu'

    Throws "Hudu is not connected! Run Connect-Hudu to connect to the API." if no client is
    registered under the 'Hudu' key.
#>
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
