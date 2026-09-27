<#
.SYNOPSIS
    Deletes a folder from the connected Hudu instance.

.DESCRIPTION
    Deletes the folder with the given ID via the connected HuduClient (see Connect-Hudu).
    Returns $null instead of throwing when the ID doesn't exist, since Hudu responds with an
    HTTP 404 in that case. Supports -WhatIf/-Confirm, with a 'High' confirm impact since
    deletion is irreversible.

.PARAMETER Id
    ID of the folder to delete. Accepts pipeline input by property name.

.EXAMPLE
    Remove-HuduFolder -Id 12

    Deletes the folder with ID 12, after confirmation.

.EXAMPLE
    Get-HuduFolder -CompanyId 5 -Name 'Old Docs' | Remove-HuduFolder -WhatIf

    Shows which folders would be deleted without changing anything.

.OUTPUTS
    None
#>
function Remove-HuduFolder {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the Folder')) {
            try {
                $client.DeleteFolder($Id)
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
