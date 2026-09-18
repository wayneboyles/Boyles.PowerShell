<#
.SYNOPSIS
    Retrieves the currently connected HuduClient, throwing if not connected.

.DESCRIPTION
    Internal helper used by every public Hudu cmdlet to look up the HuduClient registered by
    Connect-Hudu, rather than duplicating the Confirm-BPSClient/Get-BPSClient pair in each cmdlet.
    Throws via Confirm-BPSClient if Connect-Hudu hasn't been run yet.

.EXAMPLE
    $Client = Get-HuduClientInternal

    Returns the connected HuduClient, or throws if Connect-Hudu hasn't been run.

.OUTPUTS
    Boyles.PowerShell.Hudu.Services.HuduClient
#>
function Get-HuduClientInternal {
    [CmdletBinding()]
    [OutputType([Boyles.PowerShell.Hudu.Services.HuduClient])]
    param ()

    # Ensure we have a connection.  This will throw if
    # no connection exists
    Confirm-BPSClient -Key ([Boyles.PowerShell.Hudu.Consts]::ClientCacheKey) -ServiceName 'Hudu'

    # Get the client
    [Boyles.PowerShell.Hudu.Services.HuduClient] $Client = Get-BPSClient -Key ([Boyles.PowerShell.Hudu.Consts]::ClientCacheKey)
    return $Client
}
