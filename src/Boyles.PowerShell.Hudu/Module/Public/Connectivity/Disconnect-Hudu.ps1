<#
.SYNOPSIS
    Disconnects from Hudu, removing the registered client from the process-wide client store.

.DESCRIPTION
    Removes and disposes the HuduClient registered by Connect-Hudu (see Remove-BPSClient). Does
    nothing, without throwing, if Hudu is not currently connected.

.EXAMPLE
    Disconnect-Hudu

    Disconnects from Hudu, releasing the underlying HTTP client's resources.
#>
function Disconnect-Hudu {
    [CmdletBinding()]
    [OutputType([void])]
    param ()

    [string] $Key = [Boyles.PowerShell.Hudu.Consts]::ClientCacheKey

    if (Test-BPSClient -Key $Key) {
        Remove-BPSClient -Key $Key

        Write-Verbose 'Hudu is now disconnected.'
    } else {
        Write-Verbose 'Hudu is not connected, nothing to disconnect.'
    }
}
