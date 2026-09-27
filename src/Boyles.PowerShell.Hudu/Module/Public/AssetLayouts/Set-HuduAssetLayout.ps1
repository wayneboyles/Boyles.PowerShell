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
    Field definitions for the asset layout, as an array of HuduAssetLayoutField objects. To
    update an existing field, include its Id; fields without an Id are added as new fields.
    Changing the list of a ListSelect field clears that field's existing values on every asset.

.PARAMETER Icon
    New Font Awesome icon class for the asset layout, e.g. 'fas fa-server'.

.PARAMETER Active
    Whether the asset layout should be active. Enable-HuduAssetLayout and
    Disable-HuduAssetLayout are shortcuts for this.

.PARAMETER Color
    New hex code for the icon's background color.

.PARAMETER IconColor
    New hex code for the icon glyph's color.

.PARAMETER Inactive
    Marks the asset layout as inactive. Prefer -Active $false (or Disable-HuduAssetLayout),
    which sends Hudu's 'active' property directly.

.PARAMETER IncludePasswords
    Enables the passwords section on assets using this layout. Pass -IncludePasswords:$false
    to disable it.

.PARAMETER IncludePhotos
    Enables the photos section on assets using this layout. Pass -IncludePhotos:$false to
    disable it.

.PARAMETER IncludeComments
    Enables the comments section on assets using this layout. Pass -IncludeComments:$false to
    disable it.

.PARAMETER IncludeFiles
    Enables the files section on assets using this layout. Pass -IncludeFiles:$false to
    disable it.

.PARAMETER IncludeProcesses
    Enables the processes section on assets using this layout. Pass -IncludeProcesses:$false
    to disable it.

.EXAMPLE
    Set-HuduAssetLayout -Id 42 -Name 'Servers (Updated)'

    Renames asset layout 42, leaving its other properties unchanged.

.EXAMPLE
    $layout = Get-HuduAssetLayout -Name 'Servers'

    $layout.Fields.Add(@{
        Label = 'Warranty Expires'; FieldType = 'Date'; Expiration = $true; Position = 10
    })

    $layout | Set-HuduAssetLayout -Fields $layout.Fields

    Adds a new date field to the 'Servers' asset layout, keeping its existing fields.

.EXAMPLE
    Set-HuduAssetLayout -Id 42 -IncludeComments:$false

    Turns off the comments section on asset layout 42.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduAssetLayout
#>
function Set-HuduAssetLayout {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetLayout])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id,

        [Parameter()]
        [string] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [Boyles.PowerShell.Hudu.Models.HuduAssetLayoutField[]] $Fields,

        [Parameter()]
        [string] $Icon,

        [Parameter()]
        [bool] $Active,

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

    process {

        $Client = Get-HuduClientInternal

        $body = @{}

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

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
