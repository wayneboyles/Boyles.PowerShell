<#
.SYNOPSIS
    Deletes a company from the connected Hudu instance.

.DESCRIPTION
    Deletes the company with the given ID via the connected HuduClient (see Connect-Hudu).
    Returns $null instead of throwing when the ID doesn't exist, since Hudu responds with an
    HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the company to delete. Accepts pipeline input by property name.

.EXAMPLE
    Remove-HuduCompany -Id 5

    Deletes the company with ID 5, after confirmation.
#>
function Remove-HuduCompany {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $Client = Get-HuduClientInternal

        Write-Verbose "Deleting Company with ID $Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Delete Company')) {

            try {
                $Client.DeleteCompany($Id)
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
