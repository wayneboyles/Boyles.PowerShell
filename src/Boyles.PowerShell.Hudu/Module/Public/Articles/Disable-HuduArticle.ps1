<#
.SYNOPSIS
    Archives a Hudu article.

.DESCRIPTION
    Archives the article with the given ID via the connected HuduClient (see Connect-Hudu).
    Returns $null instead of throwing when the ID doesn't exist, since Hudu responds with an
    HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the article to archive. Accepts pipeline input by property name.

.EXAMPLE
    Disable-HuduArticle -Id 123

    Archives the article with ID 123.

.EXAMPLE
    Get-HuduArticle -CompanyId 5 | Disable-HuduArticle

    Archives every article belonging to company 5.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduArticle
#>
function Disable-HuduArticle {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduArticle])]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [int] $Id
    )
    process {

        $Client = Get-HuduClientInternal

        Write-Verbose "Archiving Article with ID $Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Archive Article')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduArticle] $result = $Client.ArchiveArticle($Id)
                return $result
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
