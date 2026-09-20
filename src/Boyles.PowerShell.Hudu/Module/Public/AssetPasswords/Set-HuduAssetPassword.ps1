function Set-HuduAssetPassword {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetPassword])]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', '', Justification = 'Hudu takes a plain password')]
    param (
        [BodyIgnore()]
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [int] $Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter()]
        [string] $Password,

        [BodyProperty('company_id')]
        [Parameter()]
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
