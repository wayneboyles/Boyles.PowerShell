<#
.SYNOPSIS
    Clears every Boyles.PowerShell setting, reverting the entire store to its built-in defaults.

.DESCRIPTION
    Wipes the shared SettingsStore and persists the now-empty state to disk. This affects every
    setting for every Boyles.PowerShell module that reads from the store, not just one - use
    Remove-BPSSetting instead when only a single setting needs to be reverted. Has a 'High'
    confirm impact, so it prompts for confirmation by default.

.EXAMPLE
    Reset-BPSSetting

    Prompts for confirmation, then clears every stored setting.

.EXAMPLE
    Reset-BPSSetting -Confirm:$false

    Clears every stored setting without prompting, e.g. from a non-interactive script.

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
