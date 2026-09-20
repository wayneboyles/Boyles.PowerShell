function Get-HuduAsset {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAsset])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAsset[]])]
    param (
        [Parameter()]
        [int] $Id,

        [Parameter()]
        [string] $Name,

        [BodyProperty('company_id')]
        [Parameter()]
        [int] $CompanyId,

        [BodyProperty('primary_serial')]
        [Parameter()]
        [string] $PrimarySerial,

        [BodyProperty('asset_layout_id')]
        [Parameter()]
        [int] $AssetLayoutId,

        [Parameter()]
        [bool] $Archived,

        [Parameter()]
        [string] $Slug,

        [Parameter()]
        [string] $Search,

        [BodyIgnore()]
        [Parameter()]
        [Boyles.PowerShell.Hudu.Models.HuduCompany] $InputObject
    )
    process {

        $client = Get-HuduClientInternal

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

        if ($PSBoundParameters.ContainsKey('Id') -and $PSBoundParameters.ContainsKey('CompanyId')) {
            try {
                [Boyles.PowerShell.Hudu.Models.HuduAsset[]] $assets = $client.GetAssetsForCompany($CompanyId)
                return $assets
            } catch {
                $message = $_.Exception.Message
                if ($message -like '*HTTP 404*') {
                    return $null # ID wasn't found.  Hudu returns a 404 error
                } else {
                    throw $_
                }
            }
        }

        $query = ConvertTo-RequestQuery -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        if ($PSBoundParameters.ContainsKey('InputObject')) {
            $query['company_id'] = $InputObject.Id
        } elseif ($PSBoundParameters.ContainsKey('CompanyId')) {
            $query['company_id'] = $CompanyId
        }

        [Boyles.PowerShell.Hudu.Models.HuduAsset[]] $assets = $client.GetAssets($query)
        return $assets
    }
}
