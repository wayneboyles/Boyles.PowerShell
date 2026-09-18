<#
.SYNOPSIS
    Deletes an article from the connected Hudu instance.

.DESCRIPTION
    Deletes the article with the given ID via the connected HuduClient (see Connect-Hudu).
    Returns $null instead of throwing when the ID doesn't exist, since Hudu responds with an
    HTTP 404 in that case. Supports -WhatIf/-Confirm, with a 'High' confirm impact since deletion
    is irreversible.

.PARAMETER Id
    ID of the article to delete. Accepts pipeline input by property name.

.EXAMPLE
    Remove-HuduArticle -Id 123

    Deletes the article with ID 123, after confirmation.

.EXAMPLE
    Get-HuduArticle -CompanyId 5 -Draft $true | Remove-HuduArticle -Confirm:$false

    Deletes every draft article belonging to company 5 without prompting.
#>
function Remove-HuduArticle {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $Id
    )
    process {

        $Client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the Article')) {
            try {
                $client.DeleteArticle($Id)
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
