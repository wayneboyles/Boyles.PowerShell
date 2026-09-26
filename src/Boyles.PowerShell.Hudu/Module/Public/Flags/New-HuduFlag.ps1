function New-HuduFlag {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduFlag])]
    param (
        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('flag_type_id')]
        [int] $FlagTypeId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Description,

        [Parameter()]
        [ValidateSet('Asset', 'Website', 'Article', 'AssetPassword', 'Company', 'Procedure', 'RackStorage', 'Network', 'IpAddress', 'Vlan', 'VlanZone')]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('flagable_type')]
        [string] $FlagableType,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('flagable_id')]
        [int] $FlagableId
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new Flag')) {
        [Boyles.PowerShell.Hudu.Models.HuduFlag] $result = $client.NewFlag($body)
        return $result
    }
}
