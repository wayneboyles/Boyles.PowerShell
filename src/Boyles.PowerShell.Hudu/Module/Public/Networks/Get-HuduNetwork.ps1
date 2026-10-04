<#
.SYNOPSIS
    Retrieves one or more networks from the connected Hudu instance.

.DESCRIPTION
    With -Id, retrieves a single network by ID, returning $null instead of throwing if the ID
    doesn't exist (Hudu responds with an HTTP 404 in that case). Without -Id, retrieves every
    network matching the supplied filters.

.PARAMETER Id
    ID of a single network to retrieve.

.PARAMETER CompanyId
    Filters results to networks belonging to the given company ID.

.PARAMETER Name
    Filters results to networks matching the given name.

.PARAMETER Slug
    Filters results to networks matching the given URL slug.

.PARAMETER NetworkType
    Filters results to networks of the given network type.

.PARAMETER Address
    Filters results to networks matching the given address, for example '10.0.0.0/24'.

.PARAMETER LocationId
    Filters results to networks at the given location ID.

.PARAMETER Archived
    Filters results to archived networks.

.EXAMPLE
    Get-HuduNetwork -Id 9

    Returns the network with ID 9, or $null if it doesn't exist.

.EXAMPLE
    Get-HuduNetwork -CompanyId 5

    Returns every network belonging to company 5.

.EXAMPLE
    Get-HuduNetwork -Address '10.0.0.0/24'

    Returns the networks matching the given address.

.EXAMPLE
    Get-HuduNetwork -CompanyId 5 -Archived

    Returns company 5's archived networks.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduNetwork

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduNetwork[]
#>
function Get-HuduNetwork {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduNetwork])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduNetwork[]])]
    param (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Single')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryIgnore()]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('company_id')]
        [int] $CompanyId,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('name')]
        [string] $Name,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('slug')]
        [string] $Slug,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('network_type')]
        [int] $NetworkType,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('address')]
        [string] $Address,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('location_id')]
        [int] $LocationId,

        [Parameter(ParameterSetName = 'All')]
        [QueryProperty('archived')]
        [switch] $Archived
    )

    $client = Get-HuduClientInternal

    if ($PSCmdlet.ParameterSetName -eq 'Single') {

        try {
            [Boyles.PowerShell.Hudu.Models.HuduNetwork] $Network = $Client.GetNetwork($Id)
            return $Network
        } catch {
            $message = $_.Exception.Message
            if ($message -like '*HTTP 404*') {
                return $null # ID wasn't found.  Hudu returns a 404 error
            } else {
                throw $_
            }
        }

    }

    $requestQuery = ConvertTo-RequestQuery -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters | ConvertTo-StringDictionary

    Write-Verbose "QUERY = $($requestQuery | ConvertTo-Json)"

    [Boyles.PowerShell.Hudu.Models.HuduNetwork[]] $results = $client.GetNetworks($requestQuery)
    return $results
}
