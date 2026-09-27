<#
.SYNOPSIS
    Updates an expiration in the connected Hudu instance.

.DESCRIPTION
    Updates the expiration with the given ID via the connected HuduClient (see Connect-Hudu).
    Hudu only allows an expiration's archived status to be changed. Returns $null instead of
    throwing when the ID doesn't exist, since Hudu responds with an HTTP 404 in that case.
    Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the expiration to update. Accepts pipeline input by property name.

.PARAMETER Archived
    Whether the expiration is archived. $true archives it; $false restores it.

.EXAMPLE
    Set-HuduExpiration -Id 88 -Archived $true

    Archives the expiration with ID 88.

.EXAMPLE
    Get-HuduExpiration -CompanyId 5 -ExpirationType 'warranty' | Set-HuduExpiration -Archived $true

    Archives every warranty expiration belonging to company 5.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduExpiration
#>
function Set-HuduExpiration {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduExpiration])]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter()]
        [BodyProperty('archived')]
        [bool] $Archived
    )
    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters
        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Expiration')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduExpiration] $result = $client.UpdateExpiration($Id, $body)
                $result
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
