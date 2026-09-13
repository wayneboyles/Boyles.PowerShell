<#
.SYNOPSIS
    Tests whether a client is currently registered under the given key.
.DESCRIPTION
    Wraps [Boyles.PowerShell.Context.ContextCache]::Contains(). Useful for guarding a
    service module's cmdlets with a clearer error than the KeyNotFoundException Get-BPSClient
    throws, or for skipping a redundant Connect-* call.
.PARAMETER Key
    The key to check.
.EXAMPLE
    if (-not (Test-BPSClient -Key 'Hudu')) {
        throw 'Not connected to Hudu. Run Connect-Hudu first.'
    }
#>
function Test-BPSClient {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Key
    )

    process {
        [Boyles.PowerShell.Context.ContextCache]::Contains($Key)
    }
}
