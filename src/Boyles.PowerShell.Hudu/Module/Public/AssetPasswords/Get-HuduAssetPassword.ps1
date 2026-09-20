function Get-HuduAssetPassword {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetPassword])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetPassword[]])]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [string] $Name,

        [Parameter(ParameterSetName = 'All', ValueFromPipelineByPropertyName)]
        [int] $CompanyId,

        [Parameter(ParameterSetName = 'All')]
        [bool] $Archived,

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
                [Boyles.PowerShell.Hudu.Models.HuduAssetPassword] $password = $client.GetAssetPassword($Id)
                return $password
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

        if ($PSBoundParameters.ContainsKey('Name') -and (Test-HasValue $Name)) { $query['name'] = $Name }
        if ($PSBoundParameters.ContainsKey('Archived')) { $query['archived'] = $Archived.ToString().ToLowerInvariant() }
        if ($PSBoundParameters.ContainsKey('Slug') -and (Test-HasValue $Slug)) { $query['slug'] = $Slug }
        if ($PSBoundParameters.ContainsKey('Search') -and (Test-HasValue $Search)) { $query['search'] = $Search }

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

            [Boyles.PowerShell.Hudu.Models.HuduAssetPassword[]] $passwords = $client.GetAssetPasswordsPage($queryDict, $effectivePage, $effectivePageSize)
            return $passwords

        }

        [Boyles.PowerShell.Hudu.Models.HuduAssetPassword[]] $passwords = $client.GetAssetPasswords($queryDict)
        return $passwords
    }
}
