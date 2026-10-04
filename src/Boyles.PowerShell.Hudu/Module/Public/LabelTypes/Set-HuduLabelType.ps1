<#
.SYNOPSIS
    Updates an existing label type in the connected Hudu instance.

.DESCRIPTION
    Updates the label type with the given ID via the connected HuduClient (see Connect-Hudu). Only
    the parameters actually supplied are sent in the request body, so omitted properties are left
    unchanged. Returns $null instead of throwing when the ID doesn't exist, since Hudu responds
    with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the label type to update. Accepts pipeline input by property name.

.PARAMETER Name
    New name for the label type.

.PARAMETER Color
    New color for the label type.

.PARAMETER AccessLevel
    New access level controlling who can apply and see labels of this type.

.PARAMETER ApplicableRecordTypes
    IDs of the record types this label type can be applied to.

.EXAMPLE
    Set-HuduLabelType -Id 3 -Name 'High Priority'

    Renames the label type with ID 3, leaving its other properties unchanged.

.EXAMPLE
    Get-HuduLabelType -Name 'Critical' | Set-HuduLabelType -Color 'Orange'

    Changes the 'Critical' label type to orange.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduLabelType
#>
function Set-HuduLabelType {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduLabelType])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('name')]
        [string] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange', 'Light Pink', 'Light Blue', 'Light Green', 'Light Purple', 'Light Orange', 'Light Yellow', 'White', 'Grey')]
        [BodyProperty('color')]
        [string] $Color,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('access_level')]
        [string] $AccessLevel,

        [Parameter()]
        [BodyProperty('applicable_record_types')]
        [int[]] $ApplicableRecordTypes
    )
    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Label Type')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduLabelType] $result = $client.UpdateLabelType($Id, $body)
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
