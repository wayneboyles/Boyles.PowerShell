<#
.SYNOPSIS
    Retrieves one or more IP addresses from the connected Hudu instance.

.DESCRIPTION
    With -Id, retrieves a single IP address record by ID, returning $null instead of throwing if
    the ID doesn't exist (Hudu responds with an HTTP 404 in that case). Without -Id, retrieves
    every IP address matching the supplied filters, across all pages.

.PARAMETER Id
    ID of a single IP address record to retrieve.

.PARAMETER NetworkId
    Filters results to IP addresses in the given network ID.

.PARAMETER Address
    Filters results to the given IP address.

.PARAMETER Status
    Filters results by status, e.g. 'assigned', 'reserved', or 'dhcp'.

.PARAMETER Fqdn
    Filters results to IP addresses with the given fully qualified domain name.

.PARAMETER AssetId
    Filters results to IP addresses assigned to the given asset ID.

.PARAMETER CompanyId
    Filters results to IP addresses belonging to the given company ID.

.EXAMPLE
    Get-HuduIpAddress -Address '10.0.0.10'

    Returns the IP address record for 10.0.0.10.

.EXAMPLE
    Get-HuduIpAddress -CompanyId 5 -Status 'reserved'

    Returns every reserved IP address belonging to company 5.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduIpAddress

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduIpAddress[]
#>
function Get-HuduIpAddress {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduIpAddress])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduIpAddress[]])]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryIgnore()]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('network_id')]
        [int] $NetworkId,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('address')]
        [string] $Address,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Assigned', 'Reserved', 'DHCP')]
        [QueryProperty('status')]
        [string] $Status,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('fqdn')]
        [string] $Fqdn,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('asset_id')]
        [int] $AssetId,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('company_id')]
        [int] $CompanyId
    )

    $client = Get-HuduClientInternal

    if ($PSCmdlet.ParameterSetName -eq 'Single') {

        try {
            [Boyles.PowerShell.Hudu.Models.HuduIpAddress] $ipAddress = $Client.GetIpAddress($Id)
            return $ipAddress
        } catch {
            $message = $_.Exception.Message
            if ($message -like '*HTTP 404*') {
                return $null # ID wasn't found.  Hudu returns a 404 error
            } else {
                throw $_
            }
        }

    }

    $query = ConvertTo-RequestQuery -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters | ConvertTo-StringDictionary

    Write-Verbose "QUERY = $($query | ConvertTo-Json)"

    [Boyles.PowerShell.Hudu.Models.HuduIpAddress[]] $results = $client.GetIpAddresses($query)
    return $results
}
