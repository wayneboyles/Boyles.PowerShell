<#
.SYNOPSIS
    Deletes a flag type from the connected Hudu instance.

.DESCRIPTION
    Deletes the flag type with the given ID via the connected HuduClient (see Connect-Hudu).
    Returns $null instead of throwing when the ID doesn't exist, since Hudu responds with an
    HTTP 404 in that case. Supports -WhatIf/-Confirm, with a 'High' confirm impact since
    deletion is irreversible.

.PARAMETER Id
    ID of the flag type to delete. Accepts pipeline input by property name.

.EXAMPLE
    Remove-HuduFlagType -Id 3

    Deletes the flag type with ID 3, after confirmation.

.EXAMPLE
    Get-HuduFlagType -Name 'Pending Review' | Remove-HuduFlagType -WhatIf

    Shows which flag type would be deleted without changing anything.

.OUTPUTS
    None
#>
function Remove-HuduFlagType {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the Flag Type')) {
            try {
                $client.DeleteFlagType($Id)
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
