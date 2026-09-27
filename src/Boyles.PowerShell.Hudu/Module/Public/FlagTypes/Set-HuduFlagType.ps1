<#
.SYNOPSIS
    Updates an existing flag type in the connected Hudu instance.

.DESCRIPTION
    Updates the flag type with the given ID via the connected HuduClient (see Connect-Hudu).
    Only the parameters actually supplied are sent in the request body, so omitted properties
    are left unchanged. Returns $null instead of throwing when the ID doesn't exist, since Hudu
    responds with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the flag type to update. Accepts pipeline input by property name.

.PARAMETER Name
    New name for the flag type.

.PARAMETER Color
    New color for the flag type: 'Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange',
    'Light Pink', 'Light Blue', 'Light Green', 'Light Purple', 'Light Orange', 'Light Yellow', 'White', or 'Grey'.

.EXAMPLE
    Set-HuduFlagType -Id 3 -Name 'Needs Attention'

    Renames flag type 3.

.EXAMPLE
    Get-HuduFlagType -Name 'Critical Issue' | Set-HuduFlagType -Color 'Orange'

    Changes the 'Critical Issue' flag type's color to orange.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduFlagType
#>
function Set-HuduFlagType {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduFlagType])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('name')]
        [string] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange', 'Light Pink', 'Light Blue', 'Light Green', 'Light Purple', 'Light Orange', 'Light Yellow', 'White', 'Grey')]
        [BodyProperty('color')]
        [string] $Color
    )
    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Flag Type')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduFlagType] $result = $client.UpdateFlagType($Id, $body)
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
