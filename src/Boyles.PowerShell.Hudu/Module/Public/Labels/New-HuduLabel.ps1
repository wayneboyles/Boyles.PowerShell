<#
.SYNOPSIS
    Applies a label to a record in the connected Hudu instance.

.DESCRIPTION
    Creates a label by linking an existing label type to a record, via the connected HuduClient
    (see Connect-Hudu). Supports -WhatIf/-Confirm.

.PARAMETER LabelTypeId
    ID of the label type to apply. See Get-HuduLabelType.

.PARAMETER LabelableId
    ID of the record to apply the label to.

.PARAMETER LabelableType
    Type of the record being labelled, for example 'Asset' or 'Article'.

.EXAMPLE
    New-HuduLabel -LabelTypeId 3 -LabelableId 456 -LabelableType 'Asset'

    Applies label type 3 to the asset with ID 456.

.EXAMPLE
    New-HuduLabel -LabelTypeId 3 -LabelableId 456 -LabelableType 'Asset' -WhatIf

    Shows what would happen without creating the label.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduLabel
#>
function New-HuduLabel {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduLabel])]
    param (
        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('label_type_id')]
        [int] $LabelTypeId,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('labelable_id')]
        [int] $LabelableId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('labelable_type')]
        [string] $LabelableType
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new Label')) {
        [Boyles.PowerShell.Hudu.Models.HuduLabel] $result = $client.NewLabel($body)
        return $result
    }
}
