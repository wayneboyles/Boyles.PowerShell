<#
.SYNOPSIS
    Creates a new company in the connected Hudu instance.

.DESCRIPTION
    Creates a company via the connected HuduClient (see Connect-Hudu). Only the parameters
    actually supplied are sent in the request body. Supports -WhatIf/-Confirm.

.PARAMETER Name
    Name of the new company.

.PARAMETER Nickname
    Short/alternate name for the company.

.PARAMETER CompanyType
    Type/category of the company.

.PARAMETER AddressLine1
    First line of the company's street address.

.PARAMETER AddressLine2
    Second line of the company's street address.

.PARAMETER City
    City of the company's address.

.PARAMETER State
    State/province of the company's address.

.PARAMETER Zip
    Postal code of the company's address.

.PARAMETER CountryName
    Country of the company's address.

.PARAMETER PhoneNumber
    Company phone number.

.PARAMETER FaxNumber
    Company fax number.

.PARAMETER Website
    Company website URL.

.PARAMETER IdNumber
    External/reference ID number for the company.

.PARAMETER ParentCompanyId
    ID of the parent company, if this company is a subsidiary/child.

.PARAMETER Notes
    Free-form notes about the company.

.EXAMPLE
    New-HuduCompany -Name 'Acme Corp' -Website 'https://acme.example.com'

    Creates a new company named 'Acme Corp'.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduCompany
#>
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

    $Client = Get-HuduClientInternal

    $body = @{
        name = $Name
    }

    if ($PSBoundParameters.ContainsKey('Nickname') -and (Test-HasValue $Nickname)) { $body['nickname'] = $Nickname }
    if ($PSBoundParameters.ContainsKey('CompanyType') -and (Test-HasValue $CompanyType)) { $body['company_type'] = $CompanyType }
    if ($PSBoundParameters.ContainsKey('AddressLine1') -and (Test-HasValue $AddressLine1)) { $body['address_line_1'] = $AddressLine1 }
    if ($PSBoundParameters.ContainsKey('AddressLine2') -and (Test-HasValue $AddressLine2)) { $body['address_line_2'] = $AddressLine2 }
    if ($PSBoundParameters.ContainsKey('City') -and (Test-HasValue $City)) { $body['city'] = $City }
    if ($PSBoundParameters.ContainsKey('State') -and (Test-HasValue $State)) { $body['state'] = $State }
    if ($PSBoundParameters.ContainsKey('Zip') -and (Test-HasValue $Zip)) { $body['zip'] = $Zip }
    if ($PSBoundParameters.ContainsKey('CountryName') -and (Test-HasValue $CountryName)) { $body['country_name'] = $CountryName }
    if ($PSBoundParameters.ContainsKey('PhoneNumber') -and (Test-HasValue $PhoneNumber)) { $body['phone_number'] = $PhoneNumber }
    if ($PSBoundParameters.ContainsKey('FaxNumber') -and (Test-HasValue $FaxNumber)) { $body['fax_number'] = $FaxNumber }
    if ($PSBoundParameters.ContainsKey('Website') -and (Test-HasValue $Website)) { $body['website'] = $Website }
    if ($PSBoundParameters.ContainsKey('IdNumber') -and (Test-HasValue $IdNumber)) { $body['id_number'] = $IdNumber }
    if ($PSBoundParameters.ContainsKey('ParentCompanyId') -and (Test-HasValue $ParentCompanyId)) { $body['parent_company_id'] = $ParentCompanyId }
    if ($PSBoundParameters.ContainsKey('Notes') -and (Test-HasValue $Notes)) { $body['notes'] = $Notes }

    Write-Verbose "Body = $body"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new company in Hudu')) {
        [Boyles.PowerShell.Hudu.Models.HuduCompany] $result = $client.NewCompany($body)
        $result
    }
}
