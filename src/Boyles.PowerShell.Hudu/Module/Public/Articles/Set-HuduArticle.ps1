<#
.SYNOPSIS
    Updates an existing article in the connected Hudu instance.

.DESCRIPTION
    Updates the article with the given ID via the connected HuduClient (see Connect-Hudu). Only
    the parameters actually supplied are sent in the request body, so omitted properties are left
    unchanged. Returns $null instead of throwing when the ID doesn't exist, since Hudu responds
    with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the article to update. Accepts pipeline input by property name.

.PARAMETER Name
    New name/title for the article.

.PARAMETER Content
    New body content for the article.

.PARAMETER EnableSharing
    Whether to enable public sharing for the article.

.PARAMETER FolderId
    ID of the folder to move the article into.

.PARAMETER CompanyId
    ID of the company to associate the article with.

.EXAMPLE
    Set-HuduArticle -Id 123 -Name 'Updated Password Policy'

    Renames the article with ID 123, leaving its other properties unchanged.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduArticle
#>
function Set-HuduArticle {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduArticle])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $Id,

        [Parameter()]
        [string] $Name,

        [Parameter()]
        [string] $Content,

        [Parameter()]
        [bool] $EnableSharing,

        [Parameter()]
        [int] $FolderId,

        [Parameter()]
        [int] $CompanyId
    )
    process {

        $Client = Get-HuduClientInternal

        $body = @{}

        if ($PSBoundParameters.ContainsKey('Name') -and (Test-HasValue $Name)) { $body['name'] = $Name }
        if ($PSBoundParameters.ContainsKey('Content') -and (Test-HasValue $Content)) { $body['content'] = $Content }
        if ($PSBoundParameters.ContainsKey('EnableSharing')) { $body['enable_sharing'] = $EnableSharing }
        if ($PSBoundParameters.ContainsKey('FolderId') -and (Test-HasValue $FolderId)) { $body['folder_id'] = $FolderId }
        if ($PSBoundParameters.ContainsKey('CompanyId') -and (Test-HasValue $CompanyId)) { $body['company_id'] = $CompanyId }

        Write-Verbose "Body = $body"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Article')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduArticle] $result = $client.UpdateArticle($Id, $body)
                $result
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
