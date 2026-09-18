<#
.SYNOPSIS
    Retrieves a previously registered client from the process-wide Boyles client store.

.DESCRIPTION
    Wraps [Boyles.PowerShell.Context.ContextCache]::Get(). Throws if no client is registered
    under the given key - callers should run the service's Connect-* cmdlet first (see
    Connect-Hudu.ps1).

.PARAMETER Key
    The key the client was registered under via Add-BPSClient.

.EXAMPLE
    $client = Get-BPSClient -Key 'Hudu'
#>
function Get-BPSClient {
    [CmdletBinding()]
    [OutputType([object])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Key
    )

    process {
        [Boyles.PowerShell.Context.ContextCache]::Get($Key)
    }
}
