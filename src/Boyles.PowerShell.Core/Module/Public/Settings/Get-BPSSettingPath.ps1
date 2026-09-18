<#
.SYNOPSIS
    Returns the path of the file the Boyles.PowerShell settings store persists to.

.DESCRIPTION
    Useful for troubleshooting — e.g. confirming which settings.json a given machine or user
    profile is actually reading from and writing to, or attaching it to a support ticket.

.EXAMPLE
    Get-BPSSettingPath

    C:\Users\wayne\AppData\Roaming\Boyles.PowerShell\settings.json

.OUTPUTS
    System.String
#>
function Get-BPSSettingPath {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    [Boyles.PowerShell.Settings.SettingsStore]::Instance.SettingsFilePath
}
