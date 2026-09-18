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
