<#
.SYNOPSIS
    Updates an existing asset in the connected Hudu instance.

.DESCRIPTION
    Updates the asset with the given ID, within the given company, via the connected HuduClient
    (see Connect-Hudu). Only the parameters actually supplied are sent in the request body, so
    omitted properties are left unchanged. Custom field values are supplied through -Fields and
    sent as the asset's custom_fields. Returns $null instead of throwing when the ID doesn't
    exist, since Hudu responds with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the asset to update. Accepts pipeline input by property name.

.PARAMETER CompanyId
    ID of the company the asset belongs to. Accepts pipeline input by property name.

.PARAMETER Name
    New display name for the asset.

.PARAMETER PrimarySerial
    New primary serial number for the asset.

.PARAMETER PrimaryMail
    New primary email address for the asset.

.PARAMETER PrimaryModel
    New primary model for the asset.

.PARAMETER PrimaryManufacturer
    New primary manufacturer for the asset.

.PARAMETER Fields
    Custom field values to write, as an array of HuduAssetField objects. Each field's Label must
    match a field on the asset's layout; use Get-HuduAssetLayoutFields to list them.

.EXAMPLE
    Set-HuduAsset -Id 345 -CompanyId 12 -Name 'DC01 (Updated)'

    Renames asset 345 in company 12.

.EXAMPLE
    Get-HuduAsset -CompanyId 12 -Id 345 | Set-HuduAsset -PrimarySerial 'XYZ9876'

    Pipes an asset in (its Id and CompanyId bind by property name) and updates its serial number.

.EXAMPLE
    $os = @{ Label = 'Operating System'; Value = 'Windows Server 2025' }

    Set-HuduAsset -Id 345 -CompanyId 12 -Fields $os

    Updates the 'Operating System' custom field on asset 345.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAsset
#>
function Set-HuduAsset {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAsset])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $CompanyId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('primary_serial')]
        [string] $PrimarySerial,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('primary_mail')]
        [string] $PrimaryMail,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('primary_model')]
        [string] $PrimaryModel,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('primary_manufacturer')]
        [string] $PrimaryManufacturer,

        [Parameter()]
        [BodyIgnore()]
        [Boyles.PowerShell.Hudu.Models.HuduAssetField[]] $Fields
    )

    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Asset')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduAsset] $result = $client.UpdateAsset($Id, $CompanyId, $body, $Fields)
                return $result
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
