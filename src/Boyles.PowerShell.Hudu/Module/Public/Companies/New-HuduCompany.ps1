function New-HuduCompany {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduCompany])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter()]
        [string] $Nickname,

        [Parameter()]
        [string] $CompanyType,

        [Parameter()]
        [string] $AddressLine1,

        [Parameter()]
        [string] $AddressLine2,

        [Parameter()]
        [string] $City,

        [Parameter()]
        [string] $State,

        [Parameter()]
        [string] $Zip,

        [Parameter()]
        [string] $CountryName,

        [Parameter()]
        [string] $PhoneNumber,

        [Parameter()]
        [string] $FaxNumber,

        [Parameter()]
        [string] $Website,

        [Parameter()]
        [string] $IdNumber,

        [Parameter()]
        [int] $ParentCompanyId,

        [Parameter()]
        [string] $Notes
    )

    Confirm-BPSClient -Key ([Boyles.PowerShell.Hudu.Consts]::ClientCacheKey) -ServiceName 'Hudu'

    $Client = Get-BPSClient -Key ([Boyles.PowerShell.Hudu.Consts]::ClientCacheKey)

    $body = @{
        name = $Name
    }

    if (Test-HasValue $Nickname) { $body['nickname'] = $Nickname }
    if (Test-HasValue $CompanyType) { $body['company_type'] = $CompanyType }
    if (Test-HasValue $AddressLine1) { $body['address_line_1'] = $AddressLine1 }
    if (Test-HasValue $AddressLine2) { $body['address_line_2'] = $AddressLine2 }
    if (Test-HasValue $City) { $body['city'] = $City }
    if (Test-HasValue $State) { $body['state'] = $State }
    if (Test-HasValue $Zip) { $body['zip'] = $Zip }
    if (Test-HasValue $CountryName) { $body['country_name'] = $CountryName }
    if (Test-HasValue $PhoneNumber) { $body['phone_number'] = $PhoneNumber }
    if (Test-HasValue $FaxNumber) { $body['fax_number'] = $FaxNumber }
    if (Test-HasValue $Website) { $body['website'] = $Website }
    if (Test-HasValue $IdNumber) { $body['id_number'] = $IdNumber }
    if (Test-HasValue $ParentCompanyId) { $body['parent_company_id'] = $ParentCompanyId }
    if (Test-HasValue $Notes) { $body['notes'] = $Notes }

    Write-Verbose "Body = $body"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new company in Hudu')) {
        [Boyles.PowerShell.Hudu.Models.HuduCompany] $result = $client.NewCompany($body)
        $result
    }
}
