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
