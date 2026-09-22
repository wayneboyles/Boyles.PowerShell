<#
.SYNOPSIS
    Deletes an asset from the connected Hudu instance.

.DESCRIPTION
    Deletes the asset with the given ID, within the given company, via the connected HuduClient
    (see Connect-Hudu). Returns $null instead of throwing when the ID doesn't exist, since Hudu
    responds with an HTTP 404 in that case. Supports -WhatIf/-Confirm, with a 'High' confirm
    impact since deletion is irreversible.

.PARAMETER Id
    ID of the asset to delete.

.PARAMETER CompanyId
    ID of the company the asset belongs to.

.EXAMPLE
    Remove-HuduAsset -Id 123 -CompanyId 5

    Deletes the asset with ID 123 belonging to company 5, after confirmation.
#>
function Remove-HuduAsset {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id,

        [Parameter(Mandatory)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $CompanyId
    )

    $Client = Get-HuduClientInternal

    if ($PSCmdlet.ShouldProcess($Id, 'Delete the Asset')) {
        try {
            $client.DeleteAsset($Id, $CompanyId)
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
