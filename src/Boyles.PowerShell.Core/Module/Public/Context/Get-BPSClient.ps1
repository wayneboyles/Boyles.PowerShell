<#
.SYNOPSIS
    Retrieves a previously registered client from the process-wide Boyles client store.

.DESCRIPTION
    Wraps [Boyles.PowerShell.Context.ContextCache]::Get(). Throws a KeyNotFoundException if no
    client is registered under the given key - callers should run the service's Connect-* cmdlet
    first (see Connect-Hudu.ps1), or guard the call with Test-BPSClient or Confirm-BPSClient.

.PARAMETER Key
    The key the client was registered under via Add-BPSClient. Case-insensitive.

.EXAMPLE
    $client = Get-BPSClient -Key 'hudu'

    Returns the client registered under the 'hudu' key (the key Connect-Hudu uses).

.EXAMPLE
    Get-BPSClientKey | ForEach-Object { Get-BPSClient -Key $_ }

    Returns every registered client.

.OUTPUTS
    System.Object
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
