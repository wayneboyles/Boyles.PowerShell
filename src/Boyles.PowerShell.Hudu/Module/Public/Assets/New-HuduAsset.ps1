function New-HuduAsset {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAsset])]
    param (
        [Parameter(Mandatory)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $CompanyId,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(Mandatory)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('asset_layout_id')]
        [int] $AssetLayoutId,

        [Parameter()]
        [BodyProperty('primary_serial')]
        [string] $PrimarySerial,

        [Parameter()]
        [BodyProperty('primary_mail')]
        [string] $PrimaryMail,

        [Parameter()]
        [BodyProperty('primary_model')]
        [string] $PrimaryModel,

        [Parameter()]
        [BodyProperty('primary_manufacturer')]
        [string] $PrimaryManufacturer,

        [Parameter()]
        [BodyIgnore()]
        [Boyles.PowerShell.Hudu.Models.HuduAssetField[]] $Fields
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, "Create a new Asset for Company $CompanyId")) {
        [Boyles.PowerShell.Hudu.Models.HuduAsset] $result = $client.NewAsset($CompanyId, $body, $Fields)
        return $result
    }
}
