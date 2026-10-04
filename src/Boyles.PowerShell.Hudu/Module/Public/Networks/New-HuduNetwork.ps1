<#
.SYNOPSIS
    Creates a new network in the connected Hudu instance.

.DESCRIPTION
    Creates a network for a company via the connected HuduClient (see Connect-Hudu). Only the
    parameters actually supplied are sent in the request body. Supports -WhatIf/-Confirm.

.PARAMETER Name
    Name of the network.

.PARAMETER Address
    Address of the network, for example '10.0.0.0/24'.

.PARAMETER CompanyId
    ID of the company the network belongs to.

.PARAMETER Description
    Description of the network.

.PARAMETER NetworkType
    Network type.

.PARAMETER LocationId
    ID of the location the network is at.

.PARAMETER VlanId
    VLAN ID of the network.

.PARAMETER Archived
    Creates the network in an archived state.

.EXAMPLE
    New-HuduNetwork -Name 'Office LAN' -Address '10.0.0.0/24' -CompanyId 5

    Creates a network named 'Office LAN' for company 5.

.EXAMPLE
    New-HuduNetwork -Name 'Guest WiFi' -Address '192.168.50.0/24' -CompanyId 5 -VlanId 50 -Description 'Guest access only'

    Creates a network on VLAN 50 with a description.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduNetwork
#>
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
