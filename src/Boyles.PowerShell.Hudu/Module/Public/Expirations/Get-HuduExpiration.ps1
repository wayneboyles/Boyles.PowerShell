function Get-HuduExpiration {
    [CmdletBinding()]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduExpiration[]])]
    param (
        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('company_id')]
        [int] $CompanyId,

        [Parameter()]
        [QueryProperty('expiration_type')]
        [string] $ExpirationType,

        [Parameter()]
        [QueryProperty('resource_id')]
        [int] $ResourceId,

        [Parameter()]
        [QueryProperty('resource_type')]
        [string] $ResourceType,

        [Parameter()]
        [QueryProperty('archived')]
        [bool] $Archived
    )

    $client = Get-HuduClientInternal

    $query = ConvertTo-RequestQuery -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters | ConvertTo-StringDictionary

    Write-Verbose "QUERY = $($query | ConvertTo-Json)"

    [Boyles.PowerShell.Hudu.Models.HuduExpiration[]] $results = $client.GetExpirations($query)
    return $results
}
