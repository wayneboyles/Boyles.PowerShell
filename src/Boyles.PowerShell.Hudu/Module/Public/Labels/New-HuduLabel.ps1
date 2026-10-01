function New-HuduLabel {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduLabel])]
    param (
        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('label_type_id')]
        [int] $LabelTypeId,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('labelable_id')]
        [int] $LabelableId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('labelable_type')]
        [string] $LabelableType
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new Label')) {
        [Boyles.PowerShell.Hudu.Models.HuduLabel] $result = $client.NewLabel($body)
        return $result
    }
}
