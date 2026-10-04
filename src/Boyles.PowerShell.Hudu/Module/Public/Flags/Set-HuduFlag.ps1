<#
.SYNOPSIS
    Updates an existing flag in the connected Hudu instance.

.DESCRIPTION
    Updates the flag with the given ID via the connected HuduClient (see Connect-Hudu). Only the
    parameters actually supplied are sent in the request body, so omitted properties are left
    unchanged. Returns $null instead of throwing when the ID doesn't exist, since Hudu responds
    with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the flag to update. Accepts pipeline input by property name.

.PARAMETER FlagTypeId
    New flag type ID for the flag.

.PARAMETER Description
    New description for the flag.

.EXAMPLE
    Set-HuduFlag -Id 17 -Description 'Firmware updated, pending reboot'

    Updates the description of flag 17.

.EXAMPLE
    Get-HuduFlag -FlagTypeId 1 | Set-HuduFlag -FlagTypeId 2

    Moves every flag of flag type 1 to flag type 2.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduFlag
#>
function Set-HuduFlag {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduFlag])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryIgnore()]
        [int] $Id,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('flag_type_id')]
        [int] $FlagTypeId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('description')]
        [string] $Description
    )
    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Flag')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduFlag] $result = $client.UpdateFlag($Id, $body)
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
