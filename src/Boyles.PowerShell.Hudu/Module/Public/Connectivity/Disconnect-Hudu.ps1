function Disconnect-Hudu {
    [CmdletBinding()]
    [OutputType([void])]
    param ()

    $Key = [Boyles.PowerShell.Hudu.Consts]::ClientCacheKey

    if (Test-BPSClient -Key $Key) {
        Remove-BPSClient -Key $Key
        Write-Verbose 'Hudu is now disconnected.'
    } else {
        Write-Verbose 'Hudu is not connected, nothing to disconnect.'
    }
}
