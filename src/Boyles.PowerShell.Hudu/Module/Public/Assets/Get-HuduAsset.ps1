<#
.SYNOPSIS
    Retrieves Hudu assets.
.DESCRIPTION
    Wraps the Hudu Assets API. There is only one parameter set: -CompanyId, -Id, and the
    global filters (-Name, -PrimarySerial, -AssetLayoutId, -Slug, -Search, -UpdatedAfter,
    -UpdatedBefore, -Archived) can all be combined, so parameter sets cannot express the
    routing rule below - it depends on which specific parameters were bound, not on which
    parameters are structurally allowed together. That routing is therefore a runtime check
    in the function body:

    - -CompanyId and -Id together (regardless of any other filter) -> a single, direct GET
      against /companies/{company_id}/assets/{id}. This is the only combination that maps to
      exactly one asset, so it always takes the cheapest, most specific call.
    - -CompanyId alone, with no -Id and no other filter (only -Archived is compatible with
      it) -> the lighter company-scoped list endpoint /companies/{company_id}/assets, as an
      optimization over the equivalent global-endpoint call.
    - Everything else (-Id alone, -CompanyId with another filter, or any of the other filters)
      -> the global /assets endpoint, the only one that supports Name, PrimarySerial,
      AssetLayoutId, Slug, Search and UpdatedAt, and which also accepts CompanyId and Id as
      ordinary filters rather than path segments.

    List calls are paginated internally (Hudu's `page` / `page_size` parameters) and this
    function always returns the full, materialized result set.
.PARAMETER CompanyId
    Restrict results to a single company. Combine with -Id for a direct single-asset lookup;
    alone (or with -Archived) it uses the company-scoped list endpoint; combined with another
    filter it is sent as a filter to the global endpoint. Accepted from the pipeline by
    property name.
.PARAMETER Id
    The identifier of a specific asset. Combine with -CompanyId for a direct single-asset
    lookup; used without -CompanyId it is sent as a filter to the global assets endpoint.
    Accepted from the pipeline by property name.
.PARAMETER Name
    Filter assets by name. Global assets endpoint only.
.PARAMETER PrimarySerial
    Filter assets by primary serial number. Global assets endpoint only.
.PARAMETER AssetLayoutId
    Filter assets by their associated asset layout's Id. Global assets endpoint only.
.PARAMETER Slug
    Filter assets by their URL slug. Global assets endpoint only.
.PARAMETER Search
    Free-text search filter. Global assets endpoint only.
.PARAMETER UpdatedAfter
    Only return assets updated on or after this date/time. Combine with -UpdatedBefore for a
    bounded range, or use alone for an open-ended range. Global assets endpoint only.
.PARAMETER UpdatedBefore
    Only return assets updated on or before this date/time. Combine with -UpdatedAfter for a
    bounded range, or use alone for an open-ended range. Global assets endpoint only.
.PARAMETER Archived
    Only return archived assets.
.EXAMPLE
    Get-HuduAsset -CompanyId 12 -Id 345

    Retrieves a single asset directly, via /companies/12/assets/345.
.EXAMPLE
    Get-HuduAsset -CompanyId 12

    Retrieves every non-archived asset for company 12, via the company-scoped endpoint.
.EXAMPLE
    Get-HuduAsset -CompanyId 12 -Archived

    Retrieves every archived asset for company 12, via the company-scoped endpoint.
.EXAMPLE
    Get-HuduAsset -CompanyId 12 -Name 'DC01'

    Searches company 12 for assets named 'DC01', via the global endpoint (company_id + name
    are both sent as filters, since the company-scoped endpoint does not support -Name).
.EXAMPLE
    Get-HuduAsset -Name 'DC01' -AssetLayoutId 7

    Searches across every company for assets named 'DC01' on asset layout 7, via the global endpoint.
.EXAMPLE
    Get-HuduAsset -UpdatedAfter (Get-Date).AddDays(-7)

    Retrieves every asset updated in the last week, across every company.
.EXAMPLE
    Get-HuduCompany | Get-HuduAsset

    Retrieves every asset for every company, piping CompanyId from Get-HuduCompany.
#>
function Get-HuduAsset {
    [CmdletBinding(DefaultParameterSetName = 'Filter')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAsset])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAsset[]])]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id,

        [Parameter()]
        [string] $Name,

        [Parameter(ValueFromPipelineByPropertyName)]
        [BodyProperty('company_id')]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $CompanyId,

        [Parameter()]
        [BodyProperty('primary_serial')]
        [string] $PrimarySerial,

        [Parameter(ParameterSetName = 'ByLayoutName')]
        [BodyIgnore()]
        [ValidateNotNullOrEmpty()]
        [string] $AssetLayout,

        [Parameter(ParameterSetName = 'ByLayoutId')]
        [BodyProperty('asset_layout_id')]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $AssetLayoutId,

        [Parameter()]
        [switch] $Archived,

        [Parameter()]
        [string] $Slug,

        [Parameter()]
        [string] $Search
    )
    process {

        $client = Get-HuduClientInternal

        $hasCompanyId = $PSBoundParameters.ContainsKey('CompanyId')

        $hasId = $PSBoundParameters.ContainsKey('Id')

        $hasOtherFilter = [bool]($Name -or $PrimarySerial -or $Slug -or $Search -or $PSBoundParameters.ContainsKey('AssetLayoutId') -or $PSBoundParameters.ContainsKey('UpdatedAfter') -or $PSBoundParameters.ContainsKey('UpdatedBefore'))

        # CompanyId + Id together always identifies exactly one asset - take the cheapest,
        # most specific call regardless of anything else bound.
        if ($hasCompanyId -and $hasId) {
            try {
                [Boyles.PowerShell.Hudu.Models.HuduAsset] $asset = $client.GetAsset($Id, $CompanyId)
                return $asset

            } catch {
                $message = $_.Exception.Message
                if ($message -like '*HTTP 404*') {
                    return $null # ID wasn't found.  Hudu returns a 404 error
                } else {
                    throw $_
                }
            }
        }

        # CompanyId alone (optionally with -Archived, the only filter this endpoint accepts):
        # use the lighter company-scoped list endpoint as an optimization.
        if ($hasCompanyId -and -not $hasId -and -not $hasOtherFilter) {
            $query = @{}

            if ($Archived.IsPresent) {
                $query['archived'] = 'true'
            }

            $queryDict = $query | ConvertTo-StringDictionary

            [Boyles.PowerShell.Hudu.Models.HuduAsset[]] $assets = $client.GetAssetsForCompany($CompanyId, $queryDict)
            return $assets
        }

        $layoutId = 0

        if ($PSCmdlet.ParameterSetName -eq 'ByLayoutName') {
            $layoutId = (Get-HuduAssetLayout -Name $AssetLayout).Id
        }

        $query = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters
        $query['asset_layout_id'] = $layoutId

        $queryDict = $query | ConvertTo-StringDictionary

        [Boyles.PowerShell.Hudu.Models.HuduAsset[]] $assets = $client.GetAssets($queryDict)
        return $assets
    }
}
