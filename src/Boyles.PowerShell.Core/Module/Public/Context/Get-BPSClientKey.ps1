<#
.SYNOPSIS
    Lists the keys of every client currently registered in the process-wide Boyles client store.
.DESCRIPTION
    Wraps [Boyles.PowerShell.Context.BoylesContextCache]::Keys.
.EXAMPLE
    Get-BoylesClientKey
#>
function Get-BPSClientKey {
    [CmdletBinding()]
    [OutputType([string])]
    param ()

    process {
        [Boyles.PowerShell.Context.ContextCache]::Keys
    }
}
