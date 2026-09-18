<#
.SYNOPSIS
    Creates a new article in the connected Hudu instance.

.DESCRIPTION
    Creates an article via the connected HuduClient (see Connect-Hudu). Only the parameters
    actually supplied are sent in the request body. Supports -WhatIf/-Confirm.

.PARAMETER Name
    Name/title of the new article.

.PARAMETER Content
    Body content of the article.

.PARAMETER EnableSharing
    Whether to enable public sharing for the article.

.PARAMETER FolderId
    ID of the folder to create the article in.

.PARAMETER CompanyId
    ID of the company to associate the article with.

.EXAMPLE
    New-HuduArticle -Name 'Password Policy' -Content '<p>...</p>' -CompanyId 5

    Creates a new article named 'Password Policy' under company 5.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduArticle
#>
function New-HuduArticle {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduArticle])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
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

    $Client = Get-HuduClientInternal

    $body = @{
        name = $Name
    }

    if ($PSBoundParameters.ContainsKey('Content') -and (Test-HasValue $Content)) { $body['content'] = $Content }
    if ($PSBoundParameters.ContainsKey('EnableSharing')) { $body['enable_sharing'] = $EnableSharing }
    if ($PSBoundParameters.ContainsKey('FolderId') -and (Test-HasValue $FolderId)) { $body['folder_id'] = $FolderId }
    if ($PSBoundParameters.ContainsKey('CompanyId') -and (Test-HasValue $CompanyId)) { $body['company_id'] = $CompanyId }

    Write-Verbose "Body = $body"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new article in Hudu')) {
        [Boyles.PowerShell.Hudu.Models.HuduArticle] $result = $client.NewArticle($body)
        $result
    }
}
