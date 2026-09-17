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
        [string] $Search
    )

    $Client = Get-HuduClientInternal

    $query = @{}

    if (Test-HasValue $Name) { $query['name'] = $Name }
    if (Test-HasValue $IdNumber) { $query['id_number'] = $IdNumber }
    if (Test-HasValue $PhoneNumber) { $query['phone_number'] = $PhoneNumber }
    if (Test-HasValue $Website) { $query['website'] = $Website }
    if (Test-HasValue $City) { $query['city'] = $City }
    if (Test-HasValue $State) { $query['state'] = $State }
    if (Test-HasValue $Slug) { $query['slug'] = $Slug }
    if (Test-HasValue $Search) { $query['search'] = $Search }

    $queryDict = ConvertTo-StringDictionary -Table $query

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

    } else {

        [Boyles.PowerShell.Hudu.Models.HuduCompany[]] $companies = $Client.GetCompanies($queryDict)
        return $companies

    }
}
