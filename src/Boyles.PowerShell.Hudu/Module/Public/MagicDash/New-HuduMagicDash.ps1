function New-HuduMagicDash {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduMagicDash])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Title,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Message,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $CompanyName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Icon,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $ImageUrl,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $ContentLink,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Content,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Shade
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new MagicDash')) {
        [Boyles.PowerShell.Hudu.Models.HuduMagicDash] $result = $client.NewMagicDash($body)
        return $result
    }
}
