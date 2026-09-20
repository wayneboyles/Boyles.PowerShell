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
