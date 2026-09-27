<#
.SYNOPSIS
    Throws if a client is not currently registered under the given key.

.DESCRIPTION
    Wraps Test-BPSClient with a clearer, service-specific error message than the exception
    Get-BPSClient throws on a missing key. Intended to be called at the top of a service module's
    cmdlets (or a shared helper such as Get-HuduClientInternal) to fail fast with actionable
    guidance when the user hasn't connected yet. Returns nothing when the client is registered.

.PARAMETER Key
    The key the client should be registered under. Case-insensitive.

.PARAMETER ServiceName
    Name of the service, used to build the error message (e.g. "Run Connect-<ServiceName>").

.EXAMPLE
    Confirm-BPSClient -Key 'hudu' -ServiceName 'Hudu'

    Throws "Hudu is not connected!  Run Connect-Hudu to connect to the API." if no client is
    registered under the 'hudu' key; otherwise does nothing.

.EXAMPLE
    Confirm-BPSClient 'hudu' 'Hudu'
    $client = Get-BPSClient -Key 'hudu'

    Guards a Get-BPSClient call so the user sees the friendlier "not connected" message instead
    of a KeyNotFoundException.

.OUTPUTS
    None
#>
function Confirm-BPSClient {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Key,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $ServiceName
    )

    if (-not (Test-BPSClient -Key $Key)) {
        throw "$ServiceName is not connected!  Run Connect-$ServiceName to connect to the API."
    }
}
