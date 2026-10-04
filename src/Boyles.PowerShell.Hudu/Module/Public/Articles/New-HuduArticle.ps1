<#
.SYNOPSIS
    Creates a new article in the connected Hudu instance.

.DESCRIPTION
    Creates an article via the connected HuduClient (see Connect-Hudu). Only the parameters
    actually supplied are sent in the request body. Omit -CompanyId to create a global
    (non-company) knowledge base article. Supports -WhatIf/-Confirm.

.PARAMETER Name
    Name/title of the new article.

.PARAMETER Content
    Body content of the article, as HTML.

.PARAMETER EnableSharing
    Whether to give the article a public URL that non-authenticated users can view.

.PARAMETER FolderId
    ID of the folder to create the article in.

.PARAMETER CompanyId
    ID of the company to associate the article with.

.EXAMPLE
    New-HuduArticle -Name 'Password Policy' -Content '<p>...</p>' -CompanyId 5

    Creates a new article named 'Password Policy' under company 5.

.EXAMPLE
    New-HuduArticle 'Onboarding Checklist' -Content $html -FolderId 12 -EnableSharing $true

    Creates a global article in folder 12 with public sharing enabled.

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
        [ValidateNotNullOrEmpty()]
        [string] $Content,

        [Parameter()]
        [BodyProperty('enable_sharing')]
        [bool] $EnableSharing,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('folder_id')]
        [int] $FolderId,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('company_id')]
        [int] $CompanyId
    )

    $Client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new article in Hudu')) {
        [Boyles.PowerShell.Hudu.Models.HuduArticle] $result = $client.NewArticle($body)
        $result
    }
}
