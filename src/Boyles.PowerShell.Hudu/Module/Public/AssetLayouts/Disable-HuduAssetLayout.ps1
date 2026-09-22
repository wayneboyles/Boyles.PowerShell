<#
.SYNOPSIS
    Deactivates a Hudu asset layout.

.DESCRIPTION
    Sets 'active' to $false on the asset layout with the given ID via the connected HuduClient
    (see Connect-Hudu). Returns $null instead of throwing when the ID doesn't exist, since Hudu
    responds with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the asset layout to deactivate. Accepts pipeline input by property name.

.EXAMPLE
    Disable-HuduAssetLayout -Id 42

    Deactivates the asset layout with ID 42.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAssetLayout
#>
function Disable-HuduAssetLayout {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetLayout])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $Client = Get-HuduClientInternal

        $body = @{
            'active' = $false
        }

        Write-Verbose "Deactivating Asset Layout with ID $Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Dissable the Asset Layout')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduAssetLayout] $result = $client.UpdateAssetLayout($Id, $body, $null)
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
