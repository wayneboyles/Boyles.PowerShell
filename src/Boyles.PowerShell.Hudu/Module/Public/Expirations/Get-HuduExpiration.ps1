<#
.SYNOPSIS
    Retrieves expirations from the connected Hudu instance.

.DESCRIPTION
    Retrieves every expiration matching the supplied filters via the connected HuduClient (see
    Connect-Hudu), across all pages. Only filters that are supplied are sent to Hudu. Unless
    -Archived is specified, Hudu returns only active (non-archived) expirations.

.PARAMETER CompanyId
    Filters results to expirations belonging to the given company ID.

.PARAMETER ExpirationType
    Filters results by expiration type: 'undeclared', 'domain', 'ssl_certificate', 'warranty',
    'asset_field', or 'article_expiration'.

.PARAMETER ResourceId
    Filters results to expirations on the given resource ID. Use together with -ResourceType.

.PARAMETER ResourceType
    Filters results to expirations on the given resource type (e.g. 'Asset', 'Website').
    Use together with -ResourceId.

.PARAMETER Archived
    Filters results to archived ($true) or active ($false) expirations.

.EXAMPLE
    Get-HuduExpiration -CompanyId 5

    Returns every active expiration belonging to company 5.

.EXAMPLE
    Get-HuduExpiration -ExpirationType 'ssl_certificate' | Where-Object Date -lt (Get-Date).AddDays(30)

    Returns every SSL certificate expiration due in the next 30 days.

.EXAMPLE
    Get-HuduExpiration -ResourceType 'Asset' -ResourceId 345

    Returns the expirations for asset 345.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduExpiration[]
#>
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
