function New-HuduLabelType {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduLabelType])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('name')]
        [string] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange', 'Light Pink', 'Light Blue', 'Light Green', 'Light Purple', 'Light Orange', 'Light Yellow', 'White', 'Grey')]
        [BodyProperty('color')]
        [string] $Color = 'Red',

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('access_level')]
        [string] $AccessLevel,

        [Parameter()]
        [BodyProperty('applicable_record_types')]
        [int[]] $ApplicableRecordTypes
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new Label Type')) {
        [Boyles.PowerShell.Hudu.Models.HuduLabelType] $result = $client.NewLabelType($body)
        return $result
    }

}
