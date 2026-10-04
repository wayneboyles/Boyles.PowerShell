<#
.SYNOPSIS
    Retrieves Magic Dash items from the connected Hudu instance.

.DESCRIPTION
    Retrieves every Magic Dash item matching the supplied filters, or all of them when no
    filters are given.

.PARAMETER Title
    Filters results to Magic Dash items matching the given title.

.PARAMETER CompanyId
    Filters results to Magic Dash items belonging to the given company ID.

.EXAMPLE
    Get-HuduMagicDash

    Returns every Magic Dash item.

.EXAMPLE
    Get-HuduMagicDash -CompanyId 5

    Returns the Magic Dash items for company 5.

.EXAMPLE
    Get-HuduMagicDash -Title 'Backup Status'

    Returns the Magic Dash items titled 'Backup Status'.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduMagicDash

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduMagicDash[]
#>
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
