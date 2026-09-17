function Get-HuduClientInternal {
    [CmdletBinding()]
    param ()

    # Ensure we have a connection.  This will throw if
    # no connection exists
    Confirm-BPSClient -Key ([Boyles.PowerShell.Hudu.Consts]::ClientCacheKey) -ServiceName 'Hudu'

    # Get the client
    $Client = Get-BPSClient -Key ([Boyles.PowerShell.Hudu.Consts]::ClientCacheKey)
    return $Client
}
