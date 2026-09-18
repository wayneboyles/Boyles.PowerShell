function Get-HuduApiInfo {
    [CmdletBinding()]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduApiInfo])]
    param ()

    $Client = Get-HuduClientInternal

    $ApiInfo = $Client.GetApiInfo()
    return $ApiInfo
}
