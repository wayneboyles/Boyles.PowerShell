function Get-HuduCompany {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduCompany], [Boyles.PowerShell.Hudu.Models.HuduCompany[]])]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [string] $Name,

        [Parameter(ParameterSetName = 'All')]
        [int] $IdNumber,

        [Parameter(ParameterSetName = 'All')]
        [string] $PhoneNumber,

        [Parameter(ParameterSetName = 'All')]
        [string] $Website,

        [Parameter(ParameterSetName = 'All')]
        [string] $City,

        [Parameter(ParameterSetName = 'All')]
        [string] $State,

        [Parameter(ParameterSetName = 'All')]
        [string] $Slug,

        [Parameter(ParameterSetName = 'All')]
        [string] $Search,

        [Parameter(ParameterSetName = 'All')]
        [int] $Page,

        [Parameter(ParameterSetName = 'All')]
        [int] $PageSize
    )

    $Client = Get-HuduClientInternal

    if ($PSCmdlet.ParameterSetName -eq 'Single') {

        try {
            [Boyles.PowerShell.Hudu.Models.HuduCompany] $company = $Client.GetCompany($Id)
            return $company
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
    if ($PSBoundParameters.ContainsKey('IdNumber') -and (Test-HasValue $IdNumber)) { $query['id_number'] = $IdNumber }
    if ($PSBoundParameters.ContainsKey('PhoneNumber') -and (Test-HasValue $PhoneNumber)) { $query['phone_number'] = $PhoneNumber }
    if ($PSBoundParameters.ContainsKey('Website') -and (Test-HasValue $Website)) { $query['website'] = $Website }
    if ($PSBoundParameters.ContainsKey('City') -and (Test-HasValue $City)) { $query['city'] = $City }
    if ($PSBoundParameters.ContainsKey('State') -and (Test-HasValue $State)) { $query['state'] = $State }
    if ($PSBoundParameters.ContainsKey('Slug') -and (Test-HasValue $Slug)) { $query['slug'] = $Slug }
    if ($PSBoundParameters.ContainsKey('Search') -and (Test-HasValue $Search)) { $query['search'] = $Search }

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

        [Boyles.PowerShell.Hudu.Models.HuduCompany[]] $companies = $client.GetCompaniesPage($queryDict, $effectivePage, $effectivePageSize)
        return $articles

    }

    [Boyles.PowerShell.Hudu.Models.HuduCompany[]] $companies = $Client.GetCompanies($queryDict)
    return $companies
}
