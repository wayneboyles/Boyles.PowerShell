<#
.SYNOPSIS
    Deletes an expiration from the connected Hudu instance.

.DESCRIPTION
    Permanently deletes the expiration with the given ID via the connected HuduClient (see
    Connect-Hudu). Returns $null instead of throwing when the ID doesn't exist, since Hudu
    responds with an HTTP 404 in that case. Supports -WhatIf/-Confirm, with a 'High' confirm
    impact since deletion is irreversible. To hide an expiration without deleting it, use
    Set-HuduExpiration -Archived $true instead.

.PARAMETER Id
    ID of the expiration to delete. Accepts pipeline input by property name.

.EXAMPLE
    Remove-HuduExpiration -Id 88

    Deletes the expiration with ID 88, after confirmation.

.EXAMPLE
    Get-HuduExpiration -CompanyId 5 -Archived $true | Remove-HuduExpiration -Confirm:$false

    Deletes every archived expiration belonging to company 5 without prompting.

.OUTPUTS
    None
#>
function Remove-HuduExpiration {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the Expiration')) {
            try {
                $client.DeleteExpiration($Id)
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
