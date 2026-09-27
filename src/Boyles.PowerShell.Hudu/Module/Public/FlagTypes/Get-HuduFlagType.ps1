<#
.SYNOPSIS
    Retrieves one or more flag types from the connected Hudu instance.

.DESCRIPTION
    With -Id, retrieves a single flag type by ID, returning $null instead of throwing if the ID
    doesn't exist (Hudu responds with an HTTP 404 in that case). Without -Id, retrieves every
    flag type matching the supplied filters, across all pages. Hudu matches the filters exactly.

.PARAMETER Id
    ID of a single flag type to retrieve.

.PARAMETER Name
    Filters results to the flag type with exactly the given name.

.PARAMETER Color
    Filters results to flag types with exactly the given color.

.PARAMETER Slug
    Filters results to the flag type with exactly the given URL slug.

.EXAMPLE
    Get-HuduFlagType

    Returns every flag type.

.EXAMPLE
    Get-HuduFlagType -Name 'Critical Issue'

    Returns the flag type named 'Critical Issue'.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduFlagType

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduFlagType[]
#>
function Get-HuduFlagType {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduFlagType])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduFlagType[]])]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [string] $Color,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [string] $Slug
    )

    $client = Get-HuduClientInternal

    if ($PSCmdlet.ParameterSetName -eq 'Single') {

        try {
            [Boyles.PowerShell.Hudu.Models.HuduFlagType] $flagType = $Client.GetFlagType($Id)
            return $flagType
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

    [Boyles.PowerShell.Hudu.Models.HuduFlagType[]] $results = $client.GetFlagTypes($query)
    return $results
}
