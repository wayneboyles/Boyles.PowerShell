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
        [int] $ParentCompanyId,

        [Parameter()]
        [string] $Notes
    )
    process {

        $Client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

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
