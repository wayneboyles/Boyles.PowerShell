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
    New password value.

.PARAMETER CompanyId
    New company ID to associate the asset password with.

.PARAMETER PasswordableType
    New type of the object this password is attached to.

.PARAMETER PasswordableId
    New ID of the object this password is attached to.

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

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAssetPassword
#>
function Set-HuduAssetPassword {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetPassword])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Hudu takes a plain password')]
    param (
        [BodyIgnore()]
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter()]
        [string] $Password,

        [BodyProperty('company_id')]
        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $CompanyId,

        [BodyProperty('passwordable_type')]
        [Parameter()]
        [string] $PasswordableType,

        [BodyProperty('passwordable_id')]
        [Parameter()]
        [int] $PasswordableId,

        [BodyProperty('in_portal')]
        [Parameter()]
        [bool] $InPortal,

        [BodyProperty('otp_secret')]
        [Parameter()]
        [string] $OtpSecret,

        [Parameter()]
        [string] $Url,

        [Parameter()]
        [string] $Username,

        [Parameter()]
        [string] $Description,

        [BodyProperty('password_type')]
        [Parameter()]
        [string] $PasswordType,

        [BodyProperty('password_folder_id')]
        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
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
