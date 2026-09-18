<#
.SYNOPSIS
    Retrieves the field definitions of a Hudu asset layout.

.DESCRIPTION
    Looks up the asset layout with the given ID via Get-HuduAssetLayout and returns just its
    'fields' property. Returns $null if the asset layout doesn't exist.

.PARAMETER AssetLayoutId
    ID of the asset layout whose fields should be retrieved. Accepts pipeline input by property
    name. Aliased as Id.

.EXAMPLE
    Get-HuduAssetLayoutFields -AssetLayoutId 42

    Returns the field definitions for asset layout 42.

.EXAMPLE
    Get-HuduAssetLayout -Name 'Servers' | Get-HuduAssetLayoutFields

    Returns the field definitions for the 'Servers' asset layout.
#>
function Get-HuduAssetLayoutFields {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias('Id')]
        [int] $AssetLayoutId
    )
    process {

        $assetLayout = Get-HuduAssetLayout -Id $AssetLayoutId
        if ($null -ne $assetLayout) {
            return $assetLayout.fields
        }

        return $null
    }
}
