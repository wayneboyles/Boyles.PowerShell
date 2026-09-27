<#
.SYNOPSIS
    Creates a new flag type in the connected Hudu instance.

.DESCRIPTION
    Creates a flag type via the connected HuduClient (see Connect-Hudu). Hudu requires both a
    name and a color. Only the parameters actually supplied are sent in the request body.
    Supports -WhatIf/-Confirm.

.PARAMETER Name
    Name of the new flag type.

.PARAMETER Color
    Color of the new flag type: 'Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange',
    'Light Pink', 'Light Blue', 'Light Green', 'Light Purple', 'Light Orange', 'Light Yellow', 'White', or 'Grey'.

.EXAMPLE
    New-HuduFlagType -Name 'Critical Issue' -Color 'Red'

    Creates a red flag type named 'Critical Issue'.

.EXAMPLE
    New-HuduFlagType 'Pending Review' -Color 'Yellow' -WhatIf

    Shows what would be created without changing anything.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduFlagType
#>
function New-HuduFlagType {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduFlagType])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('name')]
        [string] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange', 'Light Pink', 'Light Blue', 'Light Green', 'Light Purple', 'Light Orange', 'Light Yellow', 'White', 'Grey')]
        [BodyProperty('color')]
        [string] $Color = 'Red'
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new Flag Type')) {
        [Boyles.PowerShell.Hudu.Models.HuduFlagType] $result = $client.NewFlagType($body)
        return $result
    }

}
