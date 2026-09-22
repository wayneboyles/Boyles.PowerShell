<#
.SYNOPSIS
    Archives a Hudu asset.

.DESCRIPTION
    Archives the asset with the given ID, within the given company, via the connected
    HuduClient (see Connect-Hudu). Returns $null instead of throwing when the ID doesn't exist,
    since Hudu responds with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the asset to archive. Accepts pipeline input by property name.

.PARAMETER CompanyId
    ID of the company the asset belongs to.

.EXAMPLE
    Disable-HuduAsset -Id 123 -CompanyId 5

    Archives the asset with ID 123 belonging to company 5.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAsset
#>
function Disable-HuduAsset {
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

        Write-Verbose "Archiving Asset with ID $Id in Company $CompanyId"

        if ($PSCmdlet.ShouldProcess($Id, 'Archive Asset')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduAsset] $result = $Client.ArchiveAsset($Id, $CompanyId)
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
