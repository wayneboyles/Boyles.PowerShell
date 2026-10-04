<#
.SYNOPSIS
    Updates an existing label in the connected Hudu instance.

.DESCRIPTION
    Updates the label with the given ID via the connected HuduClient (see Connect-Hudu). Only
    the parameters actually supplied are sent in the request body, so omitted properties are left
    unchanged. Returns $null instead of throwing when the ID doesn't exist, since Hudu responds
    with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the label to update. Accepts pipeline input by property name.

.PARAMETER LabelableId
    ID of the record the label should be applied to.

.PARAMETER LabelableType
    Type of the record the label is applied to, for example 'Asset' or 'Article'.

.EXAMPLE
    Set-HuduLabel -Id 12 -LabelableId 789 -LabelableType 'Asset'

    Moves label 12 onto the asset with ID 789.

.EXAMPLE
    Get-HuduLabel -LabelableId 456 | Set-HuduLabel -LabelableId 789

    Moves every label on record 456 onto record 789.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduLabel
#>
function Set-HuduLabel {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduLabel])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('labelable_id')]
        [int] $LabelableId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('labelable_type')]
        [string] $LabelableType
    )
    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Label')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduLabel] $result = $client.UpdateLabel($Id, $body)
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
