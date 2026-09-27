<#
.SYNOPSIS
    Retrieves Hudu assets.

.DESCRIPTION
    Wraps the Hudu Assets API. -CompanyId, -Id, and the filters (-Name, -PrimarySerial,
    -AssetLayout/-AssetLayoutId, -Slug, -Search, -Archived) can be combined freely, so which
    endpoint is called depends on which parameters were bound:

    - -CompanyId and -Id together (regardless of any other filter) -> a single, direct GET
      against /companies/{company_id}/assets/{id}. Returns $null instead of throwing if the
      asset doesn't exist (Hudu responds with an HTTP 404 in that case).
    - -CompanyId alone, with no -Id and no other filter (only -Archived is compatible with
      it) -> the company-scoped list endpoint /companies/{company_id}/assets.
    - Everything else (-Id alone, -CompanyId with another filter, or any of the other filters)
      -> the global /assets endpoint, which supports every filter and accepts CompanyId and Id
      as ordinary filters rather than path segments.

    -AssetLayout and -AssetLayoutId are in separate parameter sets, so only one of them can be
    used per call. List calls are paginated internally (Hudu's 'page' / 'page_size' parameters)
    and this function always returns the full, materialized result set.

.PARAMETER Id
    The identifier of a specific asset. Combine with -CompanyId for a direct single-asset
    lookup; used without -CompanyId it is sent as a filter to the global assets endpoint.
    Accepts pipeline input by property name.

.PARAMETER Name
    Filters assets by name.

.PARAMETER CompanyId
    Restricts results to a single company. Combine with -Id for a direct single-asset lookup;
    alone (or with -Archived) it uses the company-scoped list endpoint; combined with another
    filter it is sent as a filter to the global endpoint. Accepts pipeline input by property
    name.

.PARAMETER PrimarySerial
    Filters assets by primary serial number.

.PARAMETER AssetLayout
    Filters assets by the name of their asset layout. The name is resolved to an ID with
    Get-HuduAssetLayout before the query is sent. Supports tab completion of existing asset
    layout names once Connect-Hudu has been run. Cannot be combined with -AssetLayoutId.

.PARAMETER AssetLayoutId
    Filters assets by the ID of their asset layout. Cannot be combined with -AssetLayout.

.PARAMETER Archived
    Returns only archived assets.

.PARAMETER Slug
    Filters assets by their URL slug.

.PARAMETER Search
    Free-text search filter.

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

    Searches company 12 for assets named 'DC01', via the global endpoint (company_id and name
    are both sent as filters, since the company-scoped endpoint does not support -Name).

.EXAMPLE
    Get-HuduAsset -AssetLayout 'Servers' -Search 'Dell'

    Searches every company for assets on the 'Servers' asset layout matching 'Dell'.

.EXAMPLE
    Get-HuduCompany -Name 'Acme' | ForEach-Object { Get-HuduAsset -CompanyId $_.Id }

    Retrieves every asset belonging to the Acme company. The company is passed explicitly
    because a piped HuduCompany's Id property would otherwise bind to -Id, not -CompanyId.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAsset

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAsset[]
#>
function Get-HuduAsset {
    [CmdletBinding()]
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
