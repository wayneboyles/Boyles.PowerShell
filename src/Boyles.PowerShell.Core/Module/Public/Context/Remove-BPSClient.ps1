<#
.SYNOPSIS
    Removes a client from the process-wide Boyles client store.

.DESCRIPTION
    Wraps [Boyles.PowerShell.Context.ContextCache]::Remove(). If the removed client
    implements IDisposable it is disposed, releasing its underlying HttpClient/socket resources.
    Does nothing, without throwing, if no client is registered under the given key.

.PARAMETER Key
    The key the client was registered under. Case-insensitive.

.EXAMPLE
    Remove-BPSClient -Key 'hudu'

    Removes and disposes the client Connect-Hudu registered. Disconnect-Hudu does this for you.

.EXAMPLE
    Get-BPSClientKey | ForEach-Object { Remove-BPSClient -Key $_ }

    Removes every registered client.

.OUTPUTS
    None
#>
function Remove-BPSClient {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Key
    )

    process {
        [void][Boyles.PowerShell.Context.ContextCache]::Remove($Key)
    }
}
