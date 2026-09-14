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
    process {

        Confirm-BPSClient -Key ([Boyles.PowerShell.Hudu.Consts]::ClientCacheKey) -ServiceName 'Hudu'

        $Client = Get-BPSClient -Key ([Boyles.PowerShell.Hudu.Consts]::ClientCacheKey)

        $query = @{}

        if (Test-HasValue $Name) { $query['name'] = $Name }
        if (Test-HasValue $Slug) { $query['slug'] = $Slug }
        if ($PSBoundParameters.ContainsKey('Active')) { $query['active'] = $Active }

        $queryDict = ConvertTo-StringDictionary -Table $query

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

        } else {

            [Boyles.PowerShell.Hudu.Models.HuduAssetLayout[]] $assetLayouts = $Client.GetAssetLayouts($queryDict)
            return $assetLayouts

        }
    }
}
