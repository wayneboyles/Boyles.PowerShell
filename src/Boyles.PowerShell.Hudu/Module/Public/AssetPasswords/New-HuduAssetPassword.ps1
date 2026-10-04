<#
.SYNOPSIS
    Creates a new asset password in the connected Hudu instance.

.DESCRIPTION
    Creates an asset password via the connected HuduClient (see Connect-Hudu). Only the
    parameters actually supplied are sent in the request body. Supports -WhatIf/-Confirm.

.PARAMETER Name
    Name of the new asset password.

.PARAMETER Password
    The password value to store, as plain text (Hudu's API requires it unencrypted).

.PARAMETER CompanyId
    ID of the company to associate the asset password with.

.PARAMETER PasswordableType
    Type of the record this password is attached to, e.g. 'Asset' or 'Website'. Use together
    with -PasswordableId.

.PARAMETER PasswordableId
    ID of the record this password is attached to. Use together with -PasswordableType.

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

.EXAMPLE
    $params = @{
        Name             = 'iDRAC'
        Password         = $pw
        CompanyId        = 5
        Username         = 'root'
        PasswordableType = 'Asset'
        PasswordableId   = 345
    }
    New-HuduAssetPassword @params

    Creates a password for the 'root' user and attaches it to asset 345.

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
        [ValidateNotNullOrEmpty()]
        [string] $Password,

        [Parameter(Mandatory)]
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

    $Client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new asset password in Hudu')) {
        [Boyles.PowerShell.Hudu.Models.HuduAssetPassword] $result = $client.NewAssetPassword($body)
        $result
    }
}
