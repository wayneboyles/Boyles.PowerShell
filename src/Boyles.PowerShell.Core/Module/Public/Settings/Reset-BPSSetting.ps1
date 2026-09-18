<#
.SYNOPSIS
    Clears every Boyles.PowerShell setting, reverting the entire store to its built-in defaults.

.DESCRIPTION
    Wipes the shared BpsSettingsStore and persists the now-empty state to disk. This affects every
    setting for every Boyles.PowerShell module that reads from the store, not just one — use
    Remove-BPSSetting instead when only a single setting needs to be reverted.

.EXAMPLE
    Reset-BPSSetting -Confirm

    Prompts for confirmation, then clears every stored setting.

.OUTPUTS
    None
#>
function Reset-BPSSetting {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    [OutputType([void])]
    param()

    $store = [Boyles.PowerShell.Settings.SettingsStore]::Instance

    if ($PSCmdlet.ShouldProcess('All Boyles.PowerShell settings', 'Reset-BPSSetting')) {
        $store.ResetAll()
    }
}
