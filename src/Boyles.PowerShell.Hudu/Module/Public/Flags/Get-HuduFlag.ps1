<#
.SYNOPSIS
    Retrieves one or more flags from the connected Hudu instance.

.DESCRIPTION
    With -Id, retrieves a single flag by ID, returning $null instead of throwing if the ID
    doesn't exist (Hudu responds with an HTTP 404 in that case). Without -Id, retrieves every
    flag matching the supplied filters, across all pages.

.PARAMETER Id
    ID of a single flag to retrieve.

.PARAMETER FlagTypeId
    Filters results to flags of the given flag type ID.

.PARAMETER FlagableId
    Filters results to flags attached to the record with the given ID.

.PARAMETER Description
    Filters results to flags with the given description.

.EXAMPLE
    Get-HuduFlag -Id 17

    Returns the flag with ID 17, or $null if it doesn't exist.

.EXAMPLE
    Get-HuduFlagType -Name 'Critical Issue' | ForEach-Object { Get-HuduFlag -FlagTypeId $_.Id }

    Returns every flag of the 'Critical Issue' flag type.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduFlag

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduFlag[]
#>
function Get-HuduFlag {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduFlag])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduFlag[]])]
    param (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Single')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryIgnore()]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('flag_type_id')]
        [int] $FlagTypeId,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('flagable_id')]
        [int] $FlagableId,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('description')]
        [string] $Description
    )

    $client = Get-HuduClientInternal

    if ($PSCmdlet.ParameterSetName -eq 'Single') {

        try {
            [Boyles.PowerShell.Hudu.Models.HuduFlag] $flag = $Client.GetFlag($Id)
            return $flag
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

    [Boyles.PowerShell.Hudu.Models.HuduFlag[]] $results = $client.GetFlags($query)
    return $results
}
