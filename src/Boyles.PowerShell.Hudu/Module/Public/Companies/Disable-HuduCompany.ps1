<#
.SYNOPSIS
    Archives a Hudu company.

.DESCRIPTION
    Archives the company with the given ID via the connected HuduClient (see Connect-Hudu).
    Returns $null instead of throwing when the ID doesn't exist, since Hudu responds with an
    HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the company to archive. Accepts pipeline input by property name.

.EXAMPLE
    Disable-HuduCompany -Id 5

    Archives the company with ID 5.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduCompany
#>
function Disable-HuduCompany {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduCompany])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $Id
    )
    process {

        $Client = Get-HuduClientInternal

        Write-Verbose "Archiving Company with ID $Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Disable Company')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduCompany] $result = $Client.ArchiveCompany($Id)
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
