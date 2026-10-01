function Set-HuduLabelType {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduLabelType])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('name')]
        [string] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange', 'Light Pink', 'Light Blue', 'Light Green', 'Light Purple', 'Light Orange', 'Light Yellow', 'White', 'Grey')]
        [BodyProperty('color')]
        [string] $Color,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('access_level')]
        [string] $AccessLevel,

        [Parameter()]
        [BodyProperty('applicable_record_types')]
        [int[]] $ApplicableRecordTypes
    )
    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Label Type')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduLabelType] $result = $client.UpdateLabelType($Id, $body)
                $result
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
