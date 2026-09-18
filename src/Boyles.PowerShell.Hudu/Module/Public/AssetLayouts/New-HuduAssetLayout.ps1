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

        [Parameter()]
        [string] $IconColor,

        [Parameter()]
        [switch] $Inactive,

        [Parameter()]
        [switch] $IncludePasswords,

        [Parameter()]
        [switch] $IncludePhotos,

        [Parameter()]
        [switch] $IncludeComments,

        [Parameter()]
        [switch] $IncludeFiles,

        [Parameter()]
        [switch] $IncludeProcesses
    )

    $Client = Get-HuduClientInternal

    $body = @{
        name = $Name
    }

    if ($PSBoundParameters.ContainsKey('Color') -and (Test-HasValue $Color)) { $body['color'] = $Color }
    if ($PSBoundParameters.ContainsKey('Icon') -and (Test-HasValue $Icon)) { $body['icon'] = $Icon }
    if ($PSBoundParameters.ContainsKey('IconColor') -and (Test-HasValue $IconColor)) { $body['icon_color'] = $IconColor }


    if ($IncludePasswords.IsPresent) {
        $body['include_passwords'] = $true
    } else {
        $body['include_passwords'] = $false
    }

    if ($IncludePhotos.IsPresent) {
        $body['include_photos'] = $true
    } else {
        $body['include_photos'] = $false
    }

    if ($IncludeComments.IsPresent) {
        $body['include_comments'] = $true
    } else {
        $body['include_comments'] = $false
    }

    if ($IncludeFiles.IsPresent) {
        $body['include_files'] = $true
    } else {
        $body['include_files'] = $false
    }

    if ($IncludeProcesses.IsPresent) {
        $body['include_processes'] = $true
    } else {
        $body['include_processes'] = $false
    }

    if ($Inactive.IsPresent) {
        $body['active'] = $false
    } else {
        $body['active'] = $true
    }

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new Asset Layout')) {
        [Boyles.PowerShell.Hudu.Models.HuduAssetLayout] $result = $client.NewAssetLayout($body, $Fields)
        return $result
    }
}
