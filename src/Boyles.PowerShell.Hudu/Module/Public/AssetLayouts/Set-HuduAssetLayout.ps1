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
