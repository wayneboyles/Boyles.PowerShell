<#
.SYNOPSIS
    Updates an existing list in the connected Hudu instance.

.DESCRIPTION
    Updates the list with the given ID via the connected HuduClient (see Connect-Hudu). Only the
    parameters actually supplied are sent, so omitted properties are left unchanged. Returns $null
    instead of throwing when the ID doesn't exist, since Hudu responds with an HTTP 404 in that
    case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the list to update. Accepts pipeline input by property name.

.PARAMETER Name
    New name for the list.

.PARAMETER Fields
    The items for the list, as HuduListItem objects.

.EXAMPLE
    Set-HuduList -Id 7 -Name 'Branch Offices'

    Renames the list with ID 7, leaving its items unchanged.

.EXAMPLE
    Get-HuduList -Name 'Office Locations' | Set-HuduList -Fields $items

    Updates the items of the 'Office Locations' list with the HuduListItem objects in $items.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduList
#>
function Set-HuduList {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduList])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter()]
        [BodyIgnore()]
        [Boyles.PowerShell.Hudu.Models.HuduListItem[]] $Fields
    )
    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the List')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduList] $result = $client.UpdateList($Id, $body, $Fields)
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
