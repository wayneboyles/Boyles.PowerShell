<#
.SYNOPSIS
    Creates a new asset password in the connected Hudu instance.

.DESCRIPTION
    Creates an asset password via the connected HuduClient (see Connect-Hudu). Only the
    parameters actually supplied are sent in the request body. Supports -WhatIf/-Confirm.

.PARAMETER Name
    Name of the new asset password.

.PARAMETER Password
    The password value to store.

.PARAMETER CompanyId
    ID of the company to associate the asset password with.

.PARAMETER PasswordableType
    Type of the object this password is attached to (e.g. 'Asset').

.PARAMETER PasswordableId
    ID of the object this password is attached to.

.PARAMETER InPortal
    Whether the password should be visible in the client portal.

.PARAMETER OtpSecret
    TOTP/OTP secret associated with the password.

.PARAMETER Url
    URL associated with the password.

.PARAMETER Username
    Username associated with the password.

.PARAMETER Description
    Free-form description of the password.

.PARAMETER PasswordType
    Type/category of the password.

.PARAMETER PasswordFolderId
    ID of the password folder to file the password under.

.EXAMPLE
    New-HuduAssetPassword -Name 'Admin Login' -Password 'S3cr3t!' -CompanyId 5

    Creates a new asset password named 'Admin Login' under company 5.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAssetPassword
#>
function New-HuduAssetPassword {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetPassword])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Hudu takes a plain password')]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory)]
        [string] $Password,

        [BodyProperty('company_id')]
        [Parameter(Mandatory)]
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

    $Client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new asset password in Hudu')) {
        [Boyles.PowerShell.Hudu.Models.HuduAssetPassword] $result = $client.NewAssetPassword($body)
        $result
    }
}
