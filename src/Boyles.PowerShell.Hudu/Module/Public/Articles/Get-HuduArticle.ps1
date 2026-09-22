<#
.SYNOPSIS
    Retrieves one or more articles from the connected Hudu instance.

.DESCRIPTION
    With -Id, retrieves a single article by ID, returning $null instead of throwing if the ID
    doesn't exist (Hudu responds with an HTTP 404 in that case). Without -Id, retrieves every
    article matching the supplied filters, optionally scoped to a company via -CompanyId or a
    piped HuduCompany object (not both), and optionally paginated via -Page/-PageSize.

.PARAMETER Id
    ID of a single article to retrieve.

.PARAMETER Name
    Filters results to articles matching the given name.

.PARAMETER CompanyId
    Filters results to articles belonging to the given company ID. Accepts pipeline input by
    property name. Mutually exclusive with a piped HuduCompany object.

.PARAMETER Draft
    Filters results to draft (or non-draft) articles.

.PARAMETER EnableSharing
    Filters results to articles with (or without) sharing enabled.

.PARAMETER Slug
    Filters results to articles matching the given slug.

.PARAMETER Search
    Filters results to articles matching the given search text.

.PARAMETER InputObject
    A HuduCompany object to scope results to. Accepts pipeline input. Mutually exclusive with
    -CompanyId.

.PARAMETER Page
    Page number to retrieve. Requires -PageSize or falls back to a default page size of 50.

.PARAMETER PageSize
    Number of results per page. Requires -Page or falls back to page 1.

.EXAMPLE
    Get-HuduArticle -Id 123

    Returns the article with ID 123, or $null if it doesn't exist.

.EXAMPLE
    Get-HuduArticle -CompanyId 5 -Draft $false

    Returns every non-draft article belonging to company 5.

.EXAMPLE
    Get-HuduCompany -Name 'Acme' | Get-HuduArticle -Search 'password policy'

    Returns Acme's articles matching the given search text.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduArticle

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduArticle[]
#>
function Get-HuduArticle {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduArticle])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduArticle[]])]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [string] $Name,

        [Parameter(ParameterSetName = 'All', ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $CompanyId,

        [Parameter(ParameterSetName = 'All')]
        [bool] $Draft,

        [Parameter(ParameterSetName = 'All')]
        [bool] $EnableSharing,

        [Parameter(ParameterSetName = 'All')]
        [string] $Slug,

        [Parameter(ParameterSetName = 'All')]
        [string] $Search,

        [Parameter(ParameterSetName = 'All', ValueFromPipeline)]
        [Boyles.PowerShell.Hudu.Models.HuduCompany] $InputObject,

        [Parameter(ParameterSetName = 'All')]
        [int] $Page,

        [Parameter(ParameterSetName = 'All')]
        [int] $PageSize
    )
    process {

        $client = Get-HuduClientInternal

        if ($PSCmdlet.ParameterSetName -eq 'Single') {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduArticle] $article = $client.GetArticle($Id)
                return $article
            } catch {
                $message = $_.Exception.Message
                if ($message -like '*HTTP 404*') {
                    return $null # ID wasn't found.  Hudu returns a 404 error
                } else {
                    throw $_
                }
            }

        }

        if ($PSBoundParameters.ContainsKey('InputObject') -and $PSBoundParameters.ContainsKey('CompanyId')) {
            $PSCmdlet.ThrowTerminatingError(
                [System.Management.Automation.ErrorRecord]::new(
                    [System.ArgumentException]::new('Specify either -CompanyId or a piped company object, not both.'),
                    'AmbiguousCompanyScope',
                    [System.Management.Automation.ErrorCategory]::InvalidArgument,
                    $null
                )
            )
        }

        $query = @{}

        if ($PSBoundParameters.ContainsKey('Name')) { $query['name'] = $Name }
        if ($PSBoundParameters.ContainsKey('Draft')) { $query['draft'] = $Draft.ToString().ToLowerInvariant() }
        if ($PSBoundParameters.ContainsKey('EnableSharing')) { $query['enable_sharing'] = $EnableSharing.ToString().ToLowerInvariant() }
        if ($PSBoundParameters.ContainsKey('Slug')) { $query['slug'] = $Slug }
        if ($PSBoundParameters.ContainsKey('Search')) { $query['search'] = $Search }

        if ($PSBoundParameters.ContainsKey('InputObject')) {
            $query['company_id'] = $InputObject.Id
        } elseif ($PSBoundParameters.ContainsKey('CompanyId')) {
            $query['company_id'] = $CompanyId
        }

        $queryDict = ConvertTo-StringDictionary -Table $query

        if ($PSBoundParameters.ContainsKey('Page') -or $PSBoundParameters.ContainsKey('PageSize')) {

            $effectivePageSize = if ($PSBoundParameters.ContainsKey('PageSize')) {
                $PageSize
            } else {
                50
            }

            $effectivePage = if ($PSBoundParameters.ContainsKey('Page')) {
                $Page
            } else {
                1
            }

            [Boyles.PowerShell.Hudu.Models.HuduArticle[]] $articles = $client.GetArticlesPage($queryDict, $effectivePage, $effectivePageSize)
            return $articles

        }

        [Boyles.PowerShell.Hudu.Models.HuduArticle[]] $articles = $client.GetArticles($queryDict)
        return $articles
    }
}
