<#
.SYNOPSIS
    Creates a new label type in the connected Hudu instance.

.DESCRIPTION
    Creates a label type via the connected HuduClient (see Connect-Hudu). Only the parameters
    actually supplied are sent in the request body. Supports -WhatIf/-Confirm.

.PARAMETER Name
    Name of the label type.

.PARAMETER Color
    Color of the label type. Defaults to 'Red'.

.PARAMETER AccessLevel
    Access level controlling who can apply and see labels of this type.

.PARAMETER ApplicableRecordTypes
    IDs of the record types this label type can be applied to.

.EXAMPLE
    New-HuduLabelType -Name 'Critical'

    Creates a red label type named 'Critical'.

.EXAMPLE
    New-HuduLabelType -Name 'Reviewed' -Color 'Light Green'

    Creates a light green label type named 'Reviewed'.

.EXAMPLE
    New-HuduLabelType -Name 'Pending' -Color 'Yellow' -WhatIf

    Shows what would happen without creating the label type.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduLabelType
#>
function New-HuduLabelType {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduLabelType])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('name')]
        [string] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange', 'Light Pink', 'Light Blue', 'Light Green', 'Light Purple', 'Light Orange', 'Light Yellow', 'White', 'Grey')]
        [BodyProperty('color')]
        [string] $Color = 'Red',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('access_level')]
        [string] $AccessLevel,

        [Parameter()]
        [BodyProperty('applicable_record_types')]
        [int[]] $ApplicableRecordTypes
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new Label Type')) {
        [Boyles.PowerShell.Hudu.Models.HuduLabelType] $result = $client.NewLabelType($body)
        return $result
    }

}
