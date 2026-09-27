<#
.SYNOPSIS
    Deletes an IP address record from the connected Hudu instance.

.DESCRIPTION
    Deletes the IP address record with the given ID via the connected HuduClient (see
    Connect-Hudu). Returns $null instead of throwing when the ID doesn't exist, since Hudu
    responds with an HTTP 404 in that case. Supports -WhatIf/-Confirm, with a 'High' confirm
    impact since deletion is irreversible.

.PARAMETER Id
    ID of the IP address record to delete. Accepts pipeline input by property name.

.EXAMPLE
    Remove-HuduIpAddress -Id 40

    Deletes the IP address record with ID 40, after confirmation.

.EXAMPLE
    Get-HuduIpAddress -CompanyId 5 -Status 'deprecated' | Remove-HuduIpAddress -Confirm:$false

    Deletes every deprecated IP address belonging to company 5 without prompting.

.OUTPUTS
    None
#>
function Remove-HuduIpAddress {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the IP Address')) {
            try {
                $client.DeleteIpAddress($Id)
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
