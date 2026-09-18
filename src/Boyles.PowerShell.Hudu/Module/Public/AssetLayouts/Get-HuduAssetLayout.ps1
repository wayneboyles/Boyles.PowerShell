<#
.SYNOPSIS
    Retrieves one or more asset layouts from the connected Hudu instance.

.DESCRIPTION
    With -Id, retrieves a single asset layout by ID, returning $null instead of throwing if the
    ID doesn't exist (Hudu responds with an HTTP 404 in that case). Without -Id, retrieves every
    asset layout matching the supplied filters.

.PARAMETER Id
    ID of a single asset layout to retrieve.

.PARAMETER Name
    Filters results to asset layouts matching the given name.

.PARAMETER Slug
    Filters results to asset layouts matching the given slug.

.PARAMETER Active
    Filters results to active (or inactive) asset layouts.

.EXAMPLE
    Get-HuduAssetLayout -Id 42

    Returns the asset layout with ID 42, or $null if it doesn't exist.

.EXAMPLE
    Get-HuduAssetLayout -Active $true

    Returns every active asset layout.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAssetLayout

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAssetLayout[]
#>
function Get-HuduAssetLayout {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetLayout])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetLayout[]])]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [string] $Name,

        [Parameter(ParameterSetName = 'All')]
        [string] $Slug,

        [Parameter(ParameterSetName = 'All')]
        [bool] $Active
    )

    $Client = Get-HuduClientInternal

    if ($PSCmdlet.ParameterSetName -eq 'Single') {

        try {
            [Boyles.PowerShell.Hudu.Models.HuduAssetLayout] $assetLayout = $Client.GetAssetLayout($Id)
            return $assetLayout
        } catch {
            $message = $_.Exception.Message
            if ($message -like '*HTTP 404*') {
                return $null # ID wasn't found.  Hudu returns a 404 error
            } else {
                throw $_
            }
        }

    }

    $query = @{}

    if ($PSBoundParameters.ContainsKey('Name') -and (Test-HasValue $Name)) { $query['name'] = $Name }
    if ($PSBoundParameters.ContainsKey('Slug') -and (Test-HasValue $Slug)) { $query['slug'] = $Slug }
    if ($PSBoundParameters.ContainsKey('Active')) { $query['active'] = $Active }

    $queryDict = ConvertTo-StringDictionary -Table $query

    [Boyles.PowerShell.Hudu.Models.HuduAssetLayout[]] $assetLayouts = $Client.GetAssetLayouts($queryDict)
    return $assetLayouts
}
