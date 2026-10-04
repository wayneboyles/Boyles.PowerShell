<#
.SYNOPSIS
    Removes a list from the connected Hudu instance.

.DESCRIPTION
    Deletes the list with the given ID via the connected HuduClient (see Connect-Hudu).
    Returns $null instead of throwing when the ID doesn't exist, since Hudu responds with an
    HTTP 404 in that case. Supports -WhatIf/-Confirm, with a 'High' confirm impact since deletion
    is irreversible.

.PARAMETER Id
    ID of the list to delete. Accepts pipeline input by property name.

.EXAMPLE
    Remove-HuduList -Id 7

    Deletes the list with ID 7, after confirmation.

.EXAMPLE
    Get-HuduList -Name 'Old Locations' | Remove-HuduList -Confirm:$false

    Deletes the 'Old Locations' list without prompting.

.OUTPUTS
    None
#>
function Remove-HuduList {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the List')) {
            try {
                $client.DeleteList($Id)
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
