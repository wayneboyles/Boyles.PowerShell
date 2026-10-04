<#
.SYNOPSIS
    Updates an existing IP address record in the connected Hudu instance.

.DESCRIPTION
    Updates the IP address record with the given ID via the connected HuduClient (see
    Connect-Hudu). -Address is always required. Only the parameters actually supplied are sent
    in the request body, so omitted properties are left unchanged. Returns $null instead of
    throwing when the ID doesn't exist, since Hudu responds with an HTTP 404 in that case.
    Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the IP address record to update. Accepts pipeline input by property name.

.PARAMETER Address
    The IP address. Required even if it isn't changing.

.PARAMETER Status
    New status of the IP address: 'Unassigned', 'Assigned', 'Reserved', 'Deprecated', 'DHCP', or
    'SLAAC'.

.PARAMETER Fqdn
    New fully qualified domain name for the IP address.

.PARAMETER Description
    New description of the IP address.

.PARAMETER Notes
    New notes about the IP address.

.PARAMETER AssetId
    ID of the asset to assign the IP address to.

.PARAMETER NetworkId
    ID of the network the IP address belongs to.

.PARAMETER CompanyId
    ID of the company that owns the IP address. Accepts pipeline input by property name.

.PARAMETER SkipDnsValidation
    Skips Hudu's check that -Fqdn resolves to -Address. Use for internal-only hostnames.

.EXAMPLE
    Set-HuduIpAddress -Id 40 -Address '10.0.0.10' -Status 'Reserved'

    Marks IP address record 40 as reserved.

.EXAMPLE
    Set-HuduIpAddress -Id 40 -Address '10.0.0.10' -Fqdn 'dc01.acme.local' -SkipDnsValidation

    Sets an internal-only hostname without Hudu attempting to resolve it.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduIpAddress
#>
function Set-HuduIpAddress {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduIpAddress])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Address,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Unassigned', 'Assigned', 'Reserved', 'Deprecated', 'DHCP', 'SLAAC')]
        [string] $Status,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Fqdn,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
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
    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the IP Address')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduIpAddress] $result = $client.UpdateIpAddress($Id, $body)
                $result
            } catch {
                $message = $_.Exception.Message
                if ($message -like '*HTTP 404*') {
                    return $null # ID wasn't found.  Hudu returns a 404 error
                } else {
                    throw $_
                }
            }

        }

    }
}
