<#
.SYNOPSIS
    Deletes a flag from the connected Hudu instance.

.DESCRIPTION
    Deletes the flag with the given ID via the connected HuduClient (see Connect-Hudu), removing
    it from the record it was attached to. Returns $null instead of throwing when the ID doesn't
    exist, since Hudu responds with an HTTP 404 in that case. Supports -WhatIf/-Confirm, with a
    'High' confirm impact since deletion is irreversible.

.PARAMETER Id
    ID of the flag to delete. Accepts pipeline input by property name.

.EXAMPLE
    Remove-HuduFlag -Id 17

    Deletes the flag with ID 17, after confirmation.

.EXAMPLE
    Get-HuduFlag -FlagableId 345 | Remove-HuduFlag -Confirm:$false

    Deletes every flag attached to record 345 without prompting.

.OUTPUTS
    None
#>
function Remove-HuduFlag {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the Flag')) {
            try {
                $client.DeleteFlag($Id)
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
