<#
.SYNOPSIS
    Unarchives a Hudu asset.

.DESCRIPTION
    Unarchives the asset with the given ID, within the given company, via the connected
    HuduClient (see Connect-Hudu). Returns $null instead of throwing when the ID doesn't exist,
    since Hudu responds with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the asset to unarchive. Accepts pipeline input by property name.

.PARAMETER CompanyId
    ID of the company the asset belongs to.

.EXAMPLE
    Enable-HuduAsset -Id 123 -CompanyId 5

    Unarchives the asset with ID 123 belonging to company 5.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAsset
#>
function Enable-HuduAsset {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAsset])]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id,

        [Parameter(Mandatory, Position = 0)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $CompanyId
    )
    process {

        $Client = Get-HuduClientInternal

        Write-Verbose "Unarchiving Asset with ID $Id in Company $CompanyId"

        if ($PSCmdlet.ShouldProcess($Id, 'Archive Asset')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduAsset] $result = $Client.UnarchiveAsset($Id, $CompanyId)
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
