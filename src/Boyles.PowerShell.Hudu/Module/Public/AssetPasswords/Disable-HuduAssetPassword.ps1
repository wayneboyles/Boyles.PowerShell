function Disable-HuduAssetPassword {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetPassword])]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [int] $Id
    )
    process {

        $Client = Get-HuduClientInternal

        Write-Verbose "Archiving Asset Password with ID $Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Archive Asset Password')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduAssetPassword] $result = $Client.ArchiveAssetPassword($Id)
                return $result
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
