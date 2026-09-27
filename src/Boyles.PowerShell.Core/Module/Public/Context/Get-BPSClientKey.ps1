<#
.SYNOPSIS
    Lists the keys of every client currently registered in the process-wide Boyles client store.

.DESCRIPTION
    Wraps [Boyles.PowerShell.Context.ContextCache]::Keys. Returns a snapshot of the keys at the
    time of the call; returns nothing if no clients are registered.

.EXAMPLE
    Get-BPSClientKey

    Lists every registered key, e.g. 'hudu' after Connect-Hudu has been run.

.OUTPUTS
    System.String
#>
function Get-BPSClientKey {
    [CmdletBinding()]
    [OutputType([string])]
    param ()

    process {
        [Boyles.PowerShell.Context.ContextCache]::Keys
    }
}
