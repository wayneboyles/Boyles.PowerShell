<#
.SYNOPSIS
    Deletes an asset password from the connected Hudu instance.

.DESCRIPTION
    Deletes the asset password with the given ID via the connected HuduClient (see
    Connect-Hudu). Returns $null instead of throwing when the ID doesn't exist, since Hudu
    responds with an HTTP 404 in that case. Supports -WhatIf/-Confirm, with a 'High' confirm
    impact since deletion is irreversible.

.PARAMETER Id
    ID of the asset password to delete. Accepts pipeline input by property name.

.EXAMPLE
    Remove-HuduAssetPassword -Id 123

    Deletes the asset password with ID 123, after confirmation.

.EXAMPLE
    Get-HuduAssetPassword -CompanyId 5 -Archived $true | Remove-HuduAssetPassword -Confirm:$false

    Deletes every archived asset password belonging to company 5 without prompting.
#>
function Remove-HuduAssetPassword {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $Client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the Asset Password')) {
            try {
                $client.DeleteAssetPassword($Id)
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
