<#
.SYNOPSIS
    Creates a new flag on a record in the connected Hudu instance.

.DESCRIPTION
    Attaches a flag of the given flag type to a record via the connected HuduClient (see
    Connect-Hudu). Hudu requires -FlagTypeId, -FlagableType, and -FlagableId, and the flagged
    record must exist. Only the parameters actually supplied are sent in the request body.
    Supports -WhatIf/-Confirm.

.PARAMETER FlagTypeId
    ID of the flag type to apply (see Get-HuduFlagType).

.PARAMETER Description
    Optional description for the flag.

.PARAMETER FlagableType
    Type of record being flagged: 'Asset', 'Website', 'Article', 'AssetPassword', 'Company',
    'Procedure', 'RackStorage', 'Network', 'IpAddress', 'Vlan', or 'VlanZone'.

.PARAMETER FlagableId
    ID of the record being flagged.

.EXAMPLE
    New-HuduFlag -FlagTypeId 1 -FlagableType 'Asset' -FlagableId 345 -Description 'Needs a firmware update'

    Flags asset 345 with flag type 1.

.EXAMPLE
    $type = Get-HuduFlagType -Name 'Critical Issue'
    New-HuduFlag -FlagTypeId $type.Id -FlagableType 'Company' -FlagableId 5

    Flags company 5 with the 'Critical Issue' flag type.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduFlag
#>
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
