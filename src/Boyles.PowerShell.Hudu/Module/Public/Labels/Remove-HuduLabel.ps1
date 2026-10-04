<#
.SYNOPSIS
    Removes a label from the connected Hudu instance.

.DESCRIPTION
    Deletes the label with the given ID via the connected HuduClient (see Connect-Hudu).
    Returns $null instead of throwing when the ID doesn't exist, since Hudu responds with an
    HTTP 404 in that case. Supports -WhatIf/-Confirm, with a 'High' confirm impact since deletion
    is irreversible.

.PARAMETER Id
    ID of the label to delete. Accepts pipeline input by property name.

.EXAMPLE
    Remove-HuduLabel -Id 12

    Deletes the label with ID 12, after confirmation.

.EXAMPLE
    Get-HuduLabel -LabelableId 456 | Remove-HuduLabel -Confirm:$false

    Removes every label applied to the record with ID 456 without prompting.

.OUTPUTS
    None
#>
function Remove-HuduLabel {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the Label')) {
            try {
                $client.DeleteLabel($Id)
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
