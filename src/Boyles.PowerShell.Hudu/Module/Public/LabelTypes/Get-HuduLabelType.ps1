<#
.SYNOPSIS
    Retrieves one or more label types from the connected Hudu instance.

.DESCRIPTION
    With -Id, retrieves a single label type by ID, returning $null instead of throwing if the ID
    doesn't exist (Hudu responds with an HTTP 404 in that case). Without -Id, retrieves every
    label type matching the supplied filters.

.PARAMETER Id
    ID of a single label type to retrieve.

.PARAMETER Name
    Filters results to label types matching the given name.

.PARAMETER Color
    Filters results to label types of the given color.

.PARAMETER Slug
    Filters results to label types matching the given URL slug.

.EXAMPLE
    Get-HuduLabelType -Id 3

    Returns the label type with ID 3, or $null if it doesn't exist.

.EXAMPLE
    Get-HuduLabelType -Name 'Critical'

    Returns the label types matching the name 'Critical'.

.EXAMPLE
    Get-HuduLabelType -Color 'Red'

    Returns every red label type.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduLabelType

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduLabelType[]
#>
function Get-HuduLabelType {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduLabelType])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduLabelType[]])]
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
            [Boyles.PowerShell.Hudu.Models.HuduLabelType] $LabelType = $Client.GetLabelType($Id)
            return $LabelType
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

    [Boyles.PowerShell.Hudu.Models.HuduLabelType[]] $results = $client.GetLabelTypes($query)
    return $results
}
