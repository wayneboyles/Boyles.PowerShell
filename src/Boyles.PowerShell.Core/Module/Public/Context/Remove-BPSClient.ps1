<#
.SYNOPSIS
    Removes a client from the process-wide Boyles client store.
.DESCRIPTION
    Wraps [Boyles.PowerShell.Context.BoylesContextCache]::Remove(). If the removed client
    implements IDisposable it is disposed, releasing its underlying HttpClient/socket resources.
    Does nothing, without throwing, if no client is registered under the given key.
.PARAMETER Key
    The key the client was registered under.
.EXAMPLE
    Remove-BoylesClient -Key 'Hudu'
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
