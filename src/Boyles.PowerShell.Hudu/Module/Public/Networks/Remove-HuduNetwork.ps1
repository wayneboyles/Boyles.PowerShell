<#
.SYNOPSIS
    Removes a network from the connected Hudu instance.

.DESCRIPTION
    Deletes the network with the given ID via the connected HuduClient (see Connect-Hudu).
    Returns $null instead of throwing when the ID doesn't exist, since Hudu responds with an
    HTTP 404 in that case. Supports -WhatIf/-Confirm, with a 'High' confirm impact since deletion
    is irreversible.

.PARAMETER Id
    ID of the network to delete. Accepts pipeline input by property name.

.EXAMPLE
    Remove-HuduNetwork -Id 9

    Deletes the network with ID 9, after confirmation.

.EXAMPLE
    Get-HuduNetwork -CompanyId 5 -Archived | Remove-HuduNetwork -Confirm:$false

    Deletes company 5's archived networks without prompting.

.OUTPUTS
    None
#>
function Remove-HuduNetwork {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the Network')) {
            try {
                $client.DeleteNetwork($Id)
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
