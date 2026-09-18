<#
.SYNOPSIS
    Updates an existing asset layout in the connected Hudu instance.

.DESCRIPTION
    Updates the asset layout with the given ID via the connected HuduClient (see Connect-Hudu).
    Only the parameters actually supplied are sent in the request body, so omitted properties are
    left unchanged. Returns $null instead of throwing when the ID doesn't exist, since Hudu
    responds with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the asset layout to update. Accepts pipeline input by property name.

.PARAMETER Name
    New name for the asset layout.

.PARAMETER Fields
    New field definitions for the asset layout, as an array of HuduAssetLayoutField objects.

.PARAMETER Icon
    New icon identifier for the asset layout.

.PARAMETER Color
    New icon background color for the asset layout.

.PARAMETER IconColor
    New icon glyph color for the asset layout.

.PARAMETER Active
    Whether the asset layout should be active.

.PARAMETER IncludePasswords
    Whether the passwords tab should be enabled on assets using this layout.

.PARAMETER IncludePhotos
    Whether the photos tab should be enabled on assets using this layout.

.PARAMETER IncludeComments
    Whether the comments tab should be enabled on assets using this layout.

.PARAMETER IncludeFiles
    Whether the files tab should be enabled on assets using this layout.

.PARAMETER IncludeProcesses
    Whether the processes tab should be enabled on assets using this layout.

.EXAMPLE
    Set-HuduAssetLayout -Id 42 -Name 'Servers (Updated)'

    Renames asset layout 42, leaving its other properties unchanged.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAssetLayout
#>
function Set-HuduAssetLayout {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetLayout])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $Id,

        [Parameter()]
        [string] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Boyles.PowerShell.Hudu.Models.HuduAssetLayoutField[]] $Fields,

        [Parameter()]
        [string] $Icon,

        [Parameter()]
        [string] $Color,

        [Parameter()]
        [string] $IconColor,

        [Parameter()]
        [bool] $Active,

        [Parameter()]
        [bool] $IncludePasswords,

        [Parameter()]
        [bool] $IncludePhotos,

        [Parameter()]
        [bool] $IncludeComments,

        [Parameter()]
        [bool] $IncludeFiles,

        [Parameter()]
        [bool] $IncludeProcesses
    )

    process {

        $Client = Get-HuduClientInternal

        $body = @{}

        if ($PSBoundParameters.ContainsKey('Name') -and (Test-HasValue $Name)) { $body['name'] = $Name }
        if ($PSBoundParameters.ContainsKey('Icon') -and (Test-HasValue $Icon)) { $body['icon'] = $Icon }
        if ($PSBoundParameters.ContainsKey('IconColor') -and (Test-HasValue $IconColor)) { $body['icon_color'] = $IconColor }
        if ($PSBoundParameters.ContainsKey('Color') -and (Test-HasValue $Color)) { $body['color'] = $Color }
        if ($PSBoundParameters.ContainsKey('IncludePasswords')) { $body['include_passwords'] = $IncludePasswords }
        if ($PSBoundParameters.ContainsKey('IncludePhotos')) { $body['include_photos'] = $IncludePhotos }
        if ($PSBoundParameters.ContainsKey('IncludeComments')) { $body['include_comments'] = $IncludeComments }
        if ($PSBoundParameters.ContainsKey('IncludeFiles')) { $body['include_files'] = $IncludeFiles }
        if ($PSBoundParameters.ContainsKey('IncludeProcesses')) { $body['include_processes'] = $IncludeProcesses }
        if ($PSBoundParameters.ContainsKey('Active')) { $body['active'] = $Active }

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Asset Layout')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduAssetLayout] $result = $client.UpdateAssetLayout($Id, $body, $Fields)
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
