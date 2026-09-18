<#
.SYNOPSIS
    Retrieves one or more Boyles.PowerShell settings.

.DESCRIPTION
    Reads settings from the shared Boyles.PowerShell.Settings.BpsSettingsStore singleton — the
    same store every Boyles.PowerShell.Core-based HTTP client reads from at runtime. Settings are
    persisted to disk (see Get-BPSSettingPath), so a value set in one session is still there the
    next time PowerShell starts.

.PARAMETER Name
    Name of the setting to retrieve. Accepts pipeline input. Omit to return every stored setting.

.EXAMPLE
    Get-BPSSetting -Name DebugEnabled

    Returns the current value of the DebugEnabled setting, or $null if it has never been set.

.EXAMPLE
    'DebugEnabled', 'RetryCount' | Get-BPSSetting

    Retrieves several named settings via the pipeline.

.EXAMPLE
    Get-BPSSetting

    Returns every setting currently stored, as a single object with one property per setting.

.OUTPUTS
    System.Object
#>
function Get-BPSSetting {
    [CmdletBinding()]
    [OutputType([object])]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string]$Name
    )

    process {
        $store = [Boyles.PowerShell.Settings.SettingsStore]::Instance

        if ([string]::IsNullOrWhiteSpace($Name)) {
            $current = $store.GetAll()
            $all = [ordered]@{}
            foreach ($key in $current.Keys) {
                $all[$key] = $current[$key]
            }

            return [pscustomobject]$all
        }

        $store.GetRaw($Name)
    }
}
