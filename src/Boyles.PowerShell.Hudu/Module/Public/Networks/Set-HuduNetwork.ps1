<#
.SYNOPSIS
    Updates an existing network in the connected Hudu instance.

.DESCRIPTION
    Updates the network with the given ID via the connected HuduClient (see Connect-Hudu). Only
    the parameters actually supplied are sent in the request body, so omitted properties are left
    unchanged. Returns $null instead of throwing when the ID doesn't exist, since Hudu responds
    with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the network to update. Accepts pipeline input by property name.

.PARAMETER Name
    New name for the network.

.PARAMETER Address
    New address for the network, for example '10.0.0.0/24'.

.PARAMETER Description
    New description for the network.

.PARAMETER NetworkType
    New network type.

.PARAMETER CompanyId
    ID of the company to associate the network with.

.PARAMETER LocationId
    ID of the location the network is at.

.PARAMETER VlanId
    New VLAN ID for the network.

.PARAMETER Archived
    Marks the network as archived.

.EXAMPLE
    Set-HuduNetwork -Id 9 -Name 'Main Office LAN'

    Renames the network with ID 9, leaving its other properties unchanged.

.EXAMPLE
    Get-HuduNetwork -CompanyId 5 -Name 'Guest WiFi' | Set-HuduNetwork -VlanId 60

    Moves company 5's 'Guest WiFi' network to VLAN 60.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduNetwork
#>
function Set-HuduNetwork {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduNetwork])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Address,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Description,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('network_type')]
        [int] $NetworkType,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('company_id')]
        [int] $CompanyId,

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
    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Network')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduNetwork] $result = $client.UpdateNetwork($Id, $body)
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
