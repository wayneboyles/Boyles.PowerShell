function Get-HuduArticle {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduArticle])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduArticle[]])]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [string] $Name,

        [Parameter(ParameterSetName = 'All', ValueFromPipelineByPropertyName)]
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
