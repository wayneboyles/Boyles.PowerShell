function New-HuduIpAddress {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduIpAddress])]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Address,

        [Parameter()]
        [ValidateSet('Unassigned', 'Assigned', 'Reserved', 'Deprecated', 'DHCP', 'SLAAC')]
        [string] $Status,

        [Parameter()]
        [string] $Fqdn,

        [Parameter()]
        [string] $Description,

        [Parameter()]
        [string] $Notes,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('asset_id')]
        [int] $AssetId,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('network_id')]
        [int] $NetworkId,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('company_id')]
        [int] $CompanyId,

        [Parameter()]
        [BodyProperty('skip_dns_validation')]
        [switch] $SkipDnsValidation
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new IP Address')) {
        [Boyles.PowerShell.Hudu.Models.HuduIpAddress] $result = $client.NewIpAddress($body)
        return $result
    }

}
