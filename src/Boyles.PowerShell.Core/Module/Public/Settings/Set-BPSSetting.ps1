<#
.SYNOPSIS
    Sets a Boyles.PowerShell setting.

.DESCRIPTION
    Writes a value into the shared BpsSettingsStore and persists it to disk immediately, so every
    module and HTTP client built on Boyles.PowerShell.Core picks up the new value on its next read
    — no restart required, since they all read through the same in-process singleton. Because this
    changes persisted state, it supports -WhatIf and -Confirm.

.PARAMETER Name
    Name of the setting to set, e.g. DebugEnabled.

.PARAMETER Value
    Value to store. Any JSON-serializable value is supported (bool, string, int, etc.).

.EXAMPLE
    Set-BPSSetting -Name DebugEnabled -Value $true

    Turns on debug output for every Boyles.PowerShell client in this process going forward.

.EXAMPLE
    Set-BPSSetting -Name RetryCount -Value 3 -WhatIf

    Shows what would change without actually writing the setting.

.OUTPUTS
    None
#>
function Set-BPSSetting {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Name,

        [Parameter(Mandatory, Position = 1)]
        [object]$Value
    )

    $store = [Boyles.PowerShell.Settings.SettingsStore]::Instance

    if ($PSCmdlet.ShouldProcess($Name, "Set-BPSSetting to '$Value'")) {
        $store.SetValue($Name, $Value)
    }
}
