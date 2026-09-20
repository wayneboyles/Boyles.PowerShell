<#
.SYNOPSIS
    Creates a new asset layout in the connected Hudu instance.

.DESCRIPTION
    Creates an asset layout via the connected HuduClient (see Connect-Hudu). Optional cosmetic
    parameters (Icon/Color/IconColor) are only sent when supplied; the Include* switches and
    -Inactive always send an explicit true/false value, defaulting the layout to active with all
    Include* options off. Supports -WhatIf/-Confirm.

.PARAMETER Name
    Name of the new asset layout.

.PARAMETER Fields
    Field definitions for the asset layout, as an array of HuduAssetLayoutField objects.

.PARAMETER Icon
    Icon identifier to display for the asset layout.

.PARAMETER Color
    Color to display the asset layout's icon background in.

.PARAMETER IconColor
    Color to display the asset layout's icon glyph in.

.PARAMETER Inactive
    Creates the asset layout as inactive instead of active.

.PARAMETER IncludePasswords
    Enables the passwords tab on assets using this layout.

.PARAMETER IncludePhotos
    Enables the photos tab on assets using this layout.

.PARAMETER IncludeComments
    Enables the comments tab on assets using this layout.

.PARAMETER IncludeFiles
    Enables the files tab on assets using this layout.

.PARAMETER IncludeProcesses
    Enables the processes tab on assets using this layout.

.EXAMPLE
    New-HuduAssetLayout -Name 'Servers' -Fields $fields -IncludePasswords -IncludeFiles

    Creates an active 'Servers' asset layout with the passwords and files tabs enabled.

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

    # $body = @{
    #     name = $Name
    # }

    # if ($PSBoundParameters.ContainsKey('Color') -and (Test-HasValue $Color)) { $body['color'] = $Color }
    # if ($PSBoundParameters.ContainsKey('Icon') -and (Test-HasValue $Icon)) { $body['icon'] = $Icon }
    # if ($PSBoundParameters.ContainsKey('IconColor') -and (Test-HasValue $IconColor)) { $body['icon_color'] = $IconColor }


    # if ($IncludePasswords.IsPresent) {
    #     $body['include_passwords'] = $true
    # } else {
    #     $body['include_passwords'] = $false
    # }

    # if ($IncludePhotos.IsPresent) {
    #     $body['include_photos'] = $true
    # } else {
    #     $body['include_photos'] = $false
    # }

    # if ($IncludeComments.IsPresent) {
    #     $body['include_comments'] = $true
    # } else {
    #     $body['include_comments'] = $false
    # }

    # if ($IncludeFiles.IsPresent) {
    #     $body['include_files'] = $true
    # } else {
    #     $body['include_files'] = $false
    # }

    # if ($IncludeProcesses.IsPresent) {
    #     $body['include_processes'] = $true
    # } else {
    #     $body['include_processes'] = $false
    # }

    # if ($Inactive.IsPresent) {
    #     $body['active'] = $false
    # } else {
    #     $body['active'] = $true
    # }

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new Asset Layout')) {
        [Boyles.PowerShell.Hudu.Models.HuduAssetLayout] $result = $client.NewAssetLayout($body, $Fields)
        return $result
    }
}
