<#
.SYNOPSIS
    Creates a new asset layout in the connected Hudu instance.

.DESCRIPTION
    Creates an asset layout via the connected HuduClient (see Connect-Hudu). Only the parameters
    actually supplied are sent in the request body; the field definitions in -Fields are sent
    alongside them. Hudu creates the layout as active unless -Inactive is specified. Supports
    -WhatIf/-Confirm.

.PARAMETER Name
    Name of the new asset layout.

.PARAMETER Fields
    Field definitions for the asset layout, as an array of HuduAssetLayoutField objects. Each
    field needs at least a Label and a FieldType (see [Boyles.PowerShell.Hudu.Models.HuduFieldType]
    for the supported type names).

.PARAMETER Icon
    Font Awesome icon class to display for the asset layout, e.g. 'fas fa-server'.

.PARAMETER Color
    Hex code for the icon's background color, e.g. '#1E88E5'.

.PARAMETER IconColor
    Hex code for the icon glyph's color, e.g. '#FFFFFF'.

.PARAMETER Inactive
    Creates the asset layout as inactive instead of active.

.PARAMETER IncludePasswords
    Enables the passwords section on assets using this layout.

.PARAMETER IncludePhotos
    Enables the photos section on assets using this layout.

.PARAMETER IncludeComments
    Enables the comments section on assets using this layout.

.PARAMETER IncludeFiles
    Enables the files section on assets using this layout.

.PARAMETER IncludeProcesses
    Enables the processes section on assets using this layout.

.EXAMPLE
    $fields = @(
        @{ Label = 'Hostname'; FieldType = 'Text'; Required = $true; ShowInList = $true; Position = 1 }
        @{ Label = 'Notes'; FieldType = 'RichText'; Position = 2 }
    )

    New-HuduAssetLayout -Name 'Servers' -Fields $fields -Icon 'fas fa-server' -IncludePasswords -IncludeFiles

    Creates an active 'Servers' asset layout with two fields and the passwords and files
    sections enabled.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAssetLayout
#>
function New-HuduAssetLayout {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetLayout])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [BodyIgnore()]
        [Boyles.PowerShell.Hudu.Models.HuduAssetLayoutField[]] $Fields,

        [Parameter()]
        [string] $Icon,

        [Parameter()]
        [string] $Color,

        [BodyProperty('icon_color')]
        [Parameter()]
        [string] $IconColor,

        [Parameter()]
        [switch] $Inactive,

        [BodyProperty('include_passwords')]
        [Parameter()]
        [switch] $IncludePasswords,

        [BodyProperty('include_photos')]
        [Parameter()]
        [switch] $IncludePhotos,

        [BodyProperty('include_comments')]
        [Parameter()]
        [switch] $IncludeComments,

        [BodyProperty('include_files')]
        [Parameter()]
        [switch] $IncludeFiles,

        [BodyProperty('include_processes')]
        [Parameter()]
        [switch] $IncludeProcesses
    )

    $Client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new Asset Layout')) {
        [Boyles.PowerShell.Hudu.Models.HuduAssetLayout] $result = $client.NewAssetLayout($body, $Fields)
        return $result
    }
}
