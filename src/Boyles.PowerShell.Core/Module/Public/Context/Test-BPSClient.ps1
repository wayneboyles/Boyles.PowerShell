<#
.SYNOPSIS
    Tests whether a client is currently registered under the given key.

.DESCRIPTION
    Wraps [Boyles.PowerShell.Context.ContextCache]::Contains(). Useful for guarding a
    service module's cmdlets with a clearer error than the KeyNotFoundException Get-BPSClient
    throws, or for skipping a redundant Connect-* call.

.PARAMETER Key
    The key to check. Case-insensitive.

.EXAMPLE
    Test-BPSClient -Key 'hudu'

    Returns $true if Connect-Hudu has been run in this session, otherwise $false.

.EXAMPLE
    if (-not (Test-BPSClient -Key 'hudu')) {
        Connect-Hudu -BaseUrl $baseUrl -ApiKey $apiKey
    }

    Connects to Hudu only if a client isn't already registered.

.OUTPUTS
    System.Boolean
#>
function Test-BPSClient {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Key
    )

    process {
        [Boyles.PowerShell.Context.ContextCache]::Contains($Key)
    }
}
