<#
.SYNOPSIS
    Unarchives a Hudu asset password.

.DESCRIPTION
    Unarchives the asset password with the given ID via the connected HuduClient (see
    Connect-Hudu). Returns $null instead of throwing when the ID doesn't exist, since Hudu
    responds with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the asset password to unarchive. Accepts pipeline input by property name.

.EXAMPLE
    Enable-HuduAssetPassword -Id 123

    Unarchives the asset password with ID 123.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAssetPassword
#>
function Enable-HuduAssetPassword {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetPassword])]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $Client = Get-HuduClientInternal

        Write-Verbose "Unarchiving Asset Password with ID $Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Unarchive Asset Password')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduAssetPassword] $result = $Client.UnarchiveAssetPassword($Id)
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
