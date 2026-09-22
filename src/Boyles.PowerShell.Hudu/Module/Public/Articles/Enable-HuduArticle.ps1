<#
.SYNOPSIS
    Unarchives a Hudu article.

.DESCRIPTION
    Unarchives the article with the given ID via the connected HuduClient (see Connect-Hudu).
    Returns $null instead of throwing when the ID doesn't exist, since Hudu responds with an
    HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the article to unarchive. Accepts pipeline input by property name.

.EXAMPLE
    Enable-HuduArticle -Id 123

    Unarchives the article with ID 123.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduArticle
#>
function Enable-HuduArticle {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduArticle])]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $Client = Get-HuduClientInternal

        Write-Verbose "Unarchiving Article with ID $Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Unarchive Article')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduArticle] $result = $Client.UnarchiveArticle($Id)
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
