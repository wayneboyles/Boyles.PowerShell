<#
.SYNOPSIS
    Retrieves one or more lists from the connected Hudu instance.

.DESCRIPTION
    With -Id, retrieves a single list by ID, returning $null instead of throwing if the ID
    doesn't exist (Hudu responds with an HTTP 404 in that case). Without -Id, retrieves every
    list matching the supplied filters.

.PARAMETER Id
    ID of a single list to retrieve.

.PARAMETER Query
    Filters results to lists matching the given search text.

.PARAMETER Name
    Filters results to lists matching the given name.

.EXAMPLE
    Get-HuduList -Id 7

    Returns the list with ID 7, or $null if it doesn't exist.

.EXAMPLE
    Get-HuduList

    Returns every list.

.EXAMPLE
    Get-HuduList -Name 'Office Locations'

    Returns the lists matching the name 'Office Locations'.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduList

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduList[]
#>
function Get-HuduList {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduList])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduList[]])]
    param (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Single')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryIgnore()]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('query')]
        [string] $Query,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('name')]
        [string] $Name
    )

    $client = Get-HuduClientInternal

    if ($PSCmdlet.ParameterSetName -eq 'Single') {

        try {
            [Boyles.PowerShell.Hudu.Models.HuduList] $List = $Client.GetList($Id)
            return $List
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

    [Boyles.PowerShell.Hudu.Models.HuduList[]] $results = $client.GetLists($requestQuery)
    return $results
}
