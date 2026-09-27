<#
.SYNOPSIS
    Creates a new IP address record in the connected Hudu instance.

.DESCRIPTION
    Creates an IP address record via the connected HuduClient (see Connect-Hudu). Only the
    parameters actually supplied are sent in the request body. Unless -SkipDnsValidation is
    specified, Hudu checks that -Fqdn resolves to -Address. Supports -WhatIf/-Confirm.

.PARAMETER Address
    The IP address.

.PARAMETER Status
    Status of the IP address: 'Unassigned', 'Assigned', 'Reserved', 'Deprecated', 'DHCP', or
    'SLAAC'.

.PARAMETER Fqdn
    Fully qualified domain name associated with the IP address.

.PARAMETER Description
    Brief description of the IP address.

.PARAMETER Notes
    Additional notes about the IP address.

.PARAMETER AssetId
    ID of the asset the IP address is assigned to.

.PARAMETER NetworkId
    ID of the network the IP address belongs to.

.PARAMETER CompanyId
    ID of the company that owns the IP address. Accepts pipeline input by property name.

.PARAMETER SkipDnsValidation
    Skips Hudu's check that -Fqdn resolves to -Address. Use for internal-only hostnames.

.EXAMPLE
    New-HuduIpAddress -Address '10.0.0.10' -Status 'Assigned' -CompanyId 5 -AssetId 345

    Records 10.0.0.10 as assigned to asset 345.

.EXAMPLE
    New-HuduIpAddress -Address '10.0.0.20' -Fqdn 'fs01.acme.local' -CompanyId 5 -SkipDnsValidation

    Records an internal-only hostname without Hudu attempting to resolve it.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduIpAddress
#>
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
