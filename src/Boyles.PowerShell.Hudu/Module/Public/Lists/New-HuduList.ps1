<#
.SYNOPSIS
    Creates a new list in the connected Hudu instance.

.DESCRIPTION
    Creates a list, and optionally its items, via the connected HuduClient (see Connect-Hudu).
    Supports -WhatIf/-Confirm.

.PARAMETER Name
    Name of the list.

.PARAMETER Fields
    The items to create in the list, as HuduListItem objects.

.EXAMPLE
    New-HuduList -Name 'Office Locations'

    Creates an empty list named 'Office Locations'.

.EXAMPLE
    New-HuduList -Name 'Office Locations' -Fields $items

    Creates the list and populates it with the HuduListItem objects in $items.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduList
#>
function New-HuduList {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduList])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter()]
        [BodyIgnore()]
        [Boyles.PowerShell.Hudu.Models.HuduListItem[]] $Fields
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new List')) {
        [Boyles.PowerShell.Hudu.Models.HuduList] $result = $client.NewList($body, $Fields)
        return $result
    }
}
