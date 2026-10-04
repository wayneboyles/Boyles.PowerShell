<#
.SYNOPSIS
    Updates an existing asset password in the connected Hudu instance.

.DESCRIPTION
    Updates the asset password with the given ID via the connected HuduClient (see
    Connect-Hudu). Only the parameters actually supplied are sent in the request body, so
    omitted properties are left unchanged. Returns $null instead of throwing when the ID
    doesn't exist, since Hudu responds with an HTTP 404 in that case. Supports
    -WhatIf/-Confirm.

.PARAMETER Id
    ID of the asset password to update. Accepts pipeline input by property name.

.PARAMETER Name
    New name for the asset password.

.PARAMETER Password
    New password value, as plain text.

.PARAMETER CompanyId
    New company ID to associate the asset password with.

.PARAMETER PasswordableType
    New type of the record this password is attached to, e.g. 'Asset' or 'Website'.

.PARAMETER PasswordableId
    New ID of the record this password is attached to.

.PARAMETER InPortal
    Whether the password should be visible in the client portal.

.PARAMETER OtpSecret
    New TOTP/OTP secret associated with the password.

.PARAMETER Url
    New URL associated with the password.

.PARAMETER Username
    New username associated with the password.

.PARAMETER Description
    New free-form description of the password.

.PARAMETER PasswordType
    New type/category of the password.

.PARAMETER PasswordFolderId
    New password folder ID to file the password under.

.EXAMPLE
    Set-HuduAssetPassword -Id 123 -Username 'newadmin'

    Updates the username on asset password 123, leaving its other properties unchanged.

.EXAMPLE
    Get-HuduAssetPassword -CompanyId 5 -Search 'wifi' | Set-HuduAssetPassword -InPortal $true

    Makes every matching Wi-Fi password for company 5 visible in the client portal.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAssetPassword
#>
function Set-HuduAssetPassword {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetPassword])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Hudu takes a plain password')]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Password,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('company_id')]
        [int] $CompanyId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('passwordable_type')]
        [string] $PasswordableType,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('passwordable_id')]
        [int] $PasswordableId,

        [Parameter()]
        [BodyProperty('in_portal')]
        [bool] $InPortal,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('otp_secret')]
        [string] $OtpSecret,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Url,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Username,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Description,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('password_type')]
        [string] $PasswordType,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('password_folder_id')]
        [int] $PasswordFolderId
    )
    process {

        $Client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Asset Password')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduAssetPassword] $result = $client.UpdateAssetPassword($Id, $body)
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
