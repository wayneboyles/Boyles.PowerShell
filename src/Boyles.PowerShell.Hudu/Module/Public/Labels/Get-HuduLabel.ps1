<#
.SYNOPSIS
    Retrieves one or more labels from the connected Hudu instance.

.DESCRIPTION
    With -Id, retrieves a single label by ID, returning $null instead of throwing if the ID
    doesn't exist (Hudu responds with an HTTP 404 in that case). Without -Id, retrieves every
    label matching the supplied filters.

.PARAMETER Id
    ID of a single label to retrieve.

.PARAMETER LabelTypeId
    Filters results to labels of the given label type ID.

.PARAMETER LabelableId
    Filters results to labels applied to the record with the given ID.

.PARAMETER UserId
    Filters results to labels created by the given user ID.

.EXAMPLE
    Get-HuduLabel -Id 12

    Returns the label with ID 12, or $null if it doesn't exist.

.EXAMPLE
    Get-HuduLabel

    Returns every label.

.EXAMPLE
    Get-HuduLabelType -Name 'Critical' | ForEach-Object { Get-HuduLabel -LabelTypeId $_.Id }

    Returns every label that uses the 'Critical' label type.

.EXAMPLE
    Get-HuduLabel -LabelableId 456

    Returns the labels applied to the record with ID 456.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduLabel

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduLabel[]
#>
function Get-HuduLabel {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduLabel])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduLabel[]])]
    param (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Single')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryIgnore()]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('label_type_id')]
        [int] $LabelTypeId,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('labelable_id')]
        [int] $LabelableId,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('user_id')]
        [int] $UserId
    )

    $client = Get-HuduClientInternal

    if ($PSCmdlet.ParameterSetName -eq 'Single') {

        try {
            [Boyles.PowerShell.Hudu.Models.HuduLabel] $Label = $Client.GetLabel($Id)
            return $Label
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

    [Boyles.PowerShell.Hudu.Models.HuduLabel[]] $results = $client.GetLabels($query)
    return $results
}
