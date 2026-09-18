<#
.SYNOPSIS
    Retrieves version and status information about the connected Hudu instance.

.DESCRIPTION
    Calls the Hudu API's info endpoint via the connected HuduClient (see Connect-Hudu) and
    returns it as a HuduApiInfo object.

.EXAMPLE
    Get-HuduApiInfo

    Returns version and status details for the currently connected Hudu instance.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduApiInfo
#>
function Get-HuduApiInfo {
    [CmdletBinding()]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduApiInfo])]
    param ()

    $Client = Get-HuduClientInternal

    $ApiInfo = $Client.GetApiInfo()
    return $ApiInfo
}
