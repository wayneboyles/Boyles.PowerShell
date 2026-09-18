<#
.SYNOPSIS
    Removes a single Boyles.PowerShell setting, reverting it to its built-in default.

.DESCRIPTION
    Deletes the named entry from the shared BpsSettingsStore and persists the change. Once
    removed, Get-BPSSetting for that name returns $null until it is set again, and any typed
    convenience property (such as DebugEnabled) falls back to its coded default.

.PARAMETER Name
    Name of the setting to remove. Accepts pipeline input.

.EXAMPLE
    Remove-BPSSetting -Name DebugEnabled

    Clears the DebugEnabled override, reverting to the built-in default of $false.

.EXAMPLE
    'DebugEnabled', 'RetryCount' | Remove-BPSSetting -WhatIf

    Shows which settings would be removed without changing anything.

.OUTPUTS
    None
#>
function Remove-BPSSetting {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([void])]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Name
    )

    process {
        $store = [Boyles.PowerShell.Settings.SettingsStore]::Instance

        if ($PSCmdlet.ShouldProcess($Name, 'Remove-BPSSetting')) {
            [void]$store.RemoveValue($Name)
        }
    }
}
