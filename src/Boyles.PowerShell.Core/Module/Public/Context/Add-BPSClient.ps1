<#
.SYNOPSIS
    Registers a connected service client in the process-wide Boyles client store.

.DESCRIPTION
    Wraps [Boyles.PowerShell.Context.ContextCache]::Set(). A service module's own Connect-*
    cmdlet (see Connect-Hudu.ps1) calls this after building a client, so every other cmdlet in
    that module can look the client back up by key via Get-BPSClient instead of requiring the
    client to be passed to every call explicitly.

.PARAMETER Key
    Unique, case-insensitive name to register the client under (e.g. 'Hudu', 'Hudu-Prod').
    Registering a second client under a key that is already in use replaces - and disposes, if
    the previous client implements IDisposable - the one already there.

.PARAMETER Client
    The client instance to store, e.g. a HuduClient.

.EXAMPLE
    Add-BPSClient -Key 'Hudu' -Client $huduClient
#>
function Add-BPSClient {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Key,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNull()]
        [object] $Client
    )

    process {
        [Boyles.PowerShell.Context.ContextCache]::Set($Key, $Client)
    }
}
