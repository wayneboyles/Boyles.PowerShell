function New-HuduList {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduList])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter()]
        [BodyIgnore()]
        [Boyles.PowerShell.Hudu.Models.HuduListItem[]] $Fields
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new List')) {
        [Boyles.PowerShell.Hudu.Models.HuduList] $result = $client.NewList($body, $Fields)
        return $result
    }
}
