<#
.SYNOPSIS
    Removes a label type from the connected Hudu instance.

.DESCRIPTION
    Deletes the label type with the given ID via the connected HuduClient (see Connect-Hudu).
    Returns $null instead of throwing when the ID doesn't exist, since Hudu responds with an
    HTTP 404 in that case. Supports -WhatIf/-Confirm, with a 'High' confirm impact since deletion
    is irreversible.

.PARAMETER Id
    ID of the label type to delete. Accepts pipeline input by property name.

.EXAMPLE
    Remove-HuduLabelType -Id 3

    Deletes the label type with ID 3, after confirmation.

.EXAMPLE
    Get-HuduLabelType -Name 'Obsolete' | Remove-HuduLabelType -Confirm:$false

    Deletes the 'Obsolete' label type without prompting.

.OUTPUTS
    None
#>
function Remove-HuduLabelType {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the Label Type')) {
            try {
                $client.DeleteLabelType($Id)
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
