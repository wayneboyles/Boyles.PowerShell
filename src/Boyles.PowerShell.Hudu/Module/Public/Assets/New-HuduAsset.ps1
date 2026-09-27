<#
.SYNOPSIS
    Creates a new asset in the connected Hudu instance.

.DESCRIPTION
    Creates an asset under the given company via the connected HuduClient (see Connect-Hudu).
    Only the parameters actually supplied are sent in the request body. Custom field values are
    supplied through -Fields and sent as the asset's custom_fields. Supports -WhatIf/-Confirm.

.PARAMETER CompanyId
    ID of the company to create the asset under.

.PARAMETER Name
    Name of the new asset.

.PARAMETER AssetLayoutId
    ID of the asset layout the new asset uses.

.PARAMETER PrimarySerial
    Primary serial number of the asset.

.PARAMETER PrimaryMail
    Primary email address associated with the asset.

.PARAMETER PrimaryModel
    Primary model of the asset.

.PARAMETER PrimaryManufacturer
    Primary manufacturer of the asset.

.PARAMETER Fields
    Custom field values for the asset, as an array of HuduAssetField objects. Each field's
    Label must match a field on the asset layout; use Get-HuduAssetLayoutFields to list them.

.EXAMPLE
    New-HuduAsset -CompanyId 12 -Name 'DC01' -AssetLayoutId 7 -PrimarySerial 'ABC1234'

    Creates an asset named 'DC01' on asset layout 7 for company 12.

.EXAMPLE
    $fields = @(
        [Boyles.PowerShell.Hudu.Models.HuduAssetField]@{ Label = 'Hostname'; Value = 'dc01.acme.local' }
        [Boyles.PowerShell.Hudu.Models.HuduAssetField]@{ Label = 'Operating System'; Value = 'Windows Server 2022' }
    )

    New-HuduAsset -CompanyId 12 -Name 'DC01' -AssetLayoutId 7 -Fields $fields

    Creates the asset and populates two of its custom fields.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAsset
#>
function New-HuduAsset {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAsset])]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $CompanyId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('asset_layout_id')]
        [int] $AssetLayoutId,

        [Parameter()]
        [BodyProperty('primary_serial')]
        [string] $PrimarySerial,

        [Parameter()]
        [BodyProperty('primary_mail')]
        [string] $PrimaryMail,

        [Parameter()]
        [BodyProperty('primary_model')]
        [string] $PrimaryModel,

        [Parameter()]
        [BodyProperty('primary_manufacturer')]
        [string] $PrimaryManufacturer,

        [Parameter()]
        [BodyIgnore()]
        [Boyles.PowerShell.Hudu.Models.HuduAssetField[]] $Fields
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, "Create a new Asset for Company $CompanyId")) {
        [Boyles.PowerShell.Hudu.Models.HuduAsset] $result = $client.NewAsset($CompanyId, $body, $Fields)
        return $result
    }
}
