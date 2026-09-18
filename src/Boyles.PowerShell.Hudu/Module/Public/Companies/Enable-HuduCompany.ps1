<#
.SYNOPSIS
    Unarchives a Hudu company.

.DESCRIPTION
    Unarchives the company with the given ID via the connected HuduClient (see Connect-Hudu).
    Returns $null instead of throwing when the ID doesn't exist, since Hudu responds with an
    HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the company to unarchive. Accepts pipeline input by property name.

.EXAMPLE
    Enable-HuduCompany -Id 5

    Unarchives the company with ID 5.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduCompany
#>
function Enable-HuduCompany {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduCompany])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $Id
    )
    process {

        $Client = Get-HuduClientInternal

        Write-Verbose "Unarchiving Company with ID $Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Enable Company')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduCompany] $result = $Client.UnarchiveCompany($Id)
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
