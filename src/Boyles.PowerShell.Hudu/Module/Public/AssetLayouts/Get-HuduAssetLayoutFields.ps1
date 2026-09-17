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
