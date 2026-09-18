<#
.SYNOPSIS
    Updates an existing company in the connected Hudu instance.

.DESCRIPTION
    Updates the company with the given ID via the connected HuduClient (see Connect-Hudu). Only
    the parameters actually supplied are sent in the request body, so omitted properties are left
    unchanged. Returns $null instead of throwing when the ID doesn't exist, since Hudu responds
    with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the company to update. Accepts pipeline input by property name.

.PARAMETER Name
    New name for the company.

.PARAMETER Nickname
    New short/alternate name for the company.

.PARAMETER CompanyType
    New type/category for the company.

.PARAMETER AddressLine1
    New first line of the company's street address.

.PARAMETER AddressLine2
    New second line of the company's street address.

.PARAMETER City
    New city for the company's address.

.PARAMETER State
    New state/province for the company's address.

.PARAMETER Zip
    New postal code for the company's address.

.PARAMETER CountryName
    New country for the company's address.

.PARAMETER PhoneNumber
    New company phone number.

.PARAMETER FaxNumber
    New company fax number.

.PARAMETER Website
    New company website URL.

.PARAMETER IdNumber
    New external/reference ID number for the company.

.PARAMETER ParentCompanyId
    New parent company ID.

.PARAMETER Notes
    New free-form notes about the company.

.EXAMPLE
    Set-HuduCompany -Id 5 -Website 'https://new-acme.example.com'

    Updates company 5's website, leaving its other properties unchanged.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduCompany
#>
function Set-HuduCompany {
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduCompany])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $Id,

        [Parameter()]
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
    process {

        $Client = Get-HuduClientInternal

        $body = @{}

        if ($PSBoundParameters.ContainsKey('Name') -and (Test-HasValue $Name)) { $body['name'] = $Name }
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

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Company')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduCompany] $result = $client.UpdateCompany($Id, $body)
                $result
            } catch {
                $message = $_.Exception.Message
                if ($message -like '*HTTP 404*') {
                    return $null # ID wasn't found.  Hudu returns a 404 error
                } else {
                    throw $_
                }
            }

        }
    }
}
