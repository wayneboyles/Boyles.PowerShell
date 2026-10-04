<#
.SYNOPSIS
    Retrieves one or more user groups from the connected Hudu instance.

.DESCRIPTION
    With -Id, retrieves a single group by ID, returning $null instead of throwing if the ID
    doesn't exist (Hudu responds with an HTTP 404 in that case). Without -Id, retrieves every
    group matching the supplied filters, across all pages. Group member lists exclude admins and
    super admins.

.PARAMETER Id
    ID of a single group to retrieve.

.PARAMETER Name
    Filters results to groups with the given name (case-insensitive).

.PARAMETER Default
    Filters results to the default group for new users ($true) or other groups ($false).

.PARAMETER Search
    Filters results to groups whose names match the given search text.

.EXAMPLE
    Get-HuduGroup

    Returns every group.

.EXAMPLE
    Get-HuduGroup -Name 'Technicians' | Select-Object -ExpandProperty Members

    Lists the members of the 'Technicians' group.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduGroup

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduGroup[]
#>
function Get-HuduGroup {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduGroup])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduGroup[]])]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryIgnore()]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('name')]
        [string] $Name,

        [Parameter(ParameterSetName = 'All')]
        [QueryProperty('default')]
        [bool] $Default,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('search')]
        [string] $Search
    )

    $client = Get-HuduClientInternal

    if ($PSCmdlet.ParameterSetName -eq 'Single') {

        try {
            [Boyles.PowerShell.Hudu.Models.HuduGroup] $group = $Client.GetGroup($Id)
            return $group
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

    [Boyles.PowerShell.Hudu.Models.HuduGroup[]] $results = $client.GetGroups($query)
    return $results
}
