function Get-HuduMagicDash {
    [CmdletBinding()]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduMagicDash])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduMagicDash[]])]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('title')]
        [string] $Title,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('company_id')]
        [int] $CompanyId
    )

    $client = Get-HuduClientInternal

    $requestQuery = ConvertTo-RequestQuery -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters | ConvertTo-StringDictionary

    Write-Verbose "QUERY = $($requestQuery | ConvertTo-Json)"

    [Boyles.PowerShell.Hudu.Models.HuduMagicDash[]] $results = $client.GetMagicDashes($requestQuery)
    return $results
}
