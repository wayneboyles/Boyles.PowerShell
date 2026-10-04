function New-HuduNetwork {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduNetwork])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Address,

        [Parameter(Mandatory)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('company_id')]
        [int] $CompanyId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Description,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('network_type')]
        [int] $NetworkType,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('location_id')]
        [int] $LocationId,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('vlan_id')]
        [int] $VlanId,

        [Parameter()]
        [switch] $Archived
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new Network')) {
        [Boyles.PowerShell.Hudu.Models.HuduNetwork] $result = $client.NewNetwork($body)
        return $result
    }
}
