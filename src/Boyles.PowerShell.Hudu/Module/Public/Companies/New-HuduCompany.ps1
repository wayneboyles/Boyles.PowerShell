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

        [BodyProperty('company_type')]
        [Parameter()]
        [string] $CompanyType,

        [BodyProperty('address_line_1')]
        [Parameter()]
        [string] $AddressLine1,

        [BodyProperty('address_line_2')]
        [Parameter()]
        [string] $AddressLine2,

        [Parameter()]
        [string] $City,

        [Parameter()]
        [string] $State,

        [Parameter()]
        [string] $Zip,

        [BodyProperty('country_name')]
        [Parameter()]
        [string] $CountryName,

        [BodyProperty('phone_number')]
        [Parameter()]
        [string] $PhoneNumber,

        [BodyProperty('fax_number')]
        [Parameter()]
        [string] $FaxNumber,

        [Parameter()]
        [string] $Website,

        [BodyProperty('id_number')]
        [Parameter()]
        [string] $IdNumber,

        [BodyProperty('parent_company_id')]
        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $ParentCompanyId,

        [Parameter()]
        [string] $Notes
    )

    $Client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new company in Hudu')) {
        [Boyles.PowerShell.Hudu.Models.HuduCompany] $result = $client.NewCompany($body)
        $result
    }
}
