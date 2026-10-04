<#
.SYNOPSIS
    Retrieves activity logs from the connected Hudu instance.

.DESCRIPTION
    Queries the Hudu activity log endpoint via the connected HuduClient (see Connect-Hudu),
    applying whichever filters were supplied as query parameters. Every page of results is
    retrieved automatically and returned as a single array. ResourceId and ResourceType must be
    specified together - supplying only one of the pair throws.

.PARAMETER Page
    Sent to Hudu as the 'page' query parameter. Currently has no effect: the client retrieves
    every page automatically and overwrites 'page' while paging.

.PARAMETER UserId
    Filters results to activity performed by the given user ID.

.PARAMETER UserEmail
    Filters results to activity performed by the user with the given email address.

.PARAMETER ResourceId
    Filters results to activity on the given resource ID. Must be specified together with
    ResourceType.

.PARAMETER ResourceType
    Filters results to activity on the given resource type (e.g. 'Asset', 'AssetPassword',
    'Company', 'Article'). Must be specified together with ResourceId.

.PARAMETER ActionMessage
    Filters results to log entries for the given action (e.g. 'viewed', 'updated').

.EXAMPLE
    Get-HuduActivityLogs

    Returns every activity log entry, with no filters applied.

.EXAMPLE
    Get-HuduActivityLogs -ResourceId 123 -ResourceType 'Asset'

    Returns activity log entries for the asset with ID 123.

.EXAMPLE
    Get-HuduActivityLogs -UserEmail 'tech@example.com' -ActionMessage 'viewed'

    Returns every 'viewed' entry recorded for the given user.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduActivityLog[]
#>
function Get-HuduActivityLogs {
    [CmdletBinding()]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduActivityLog[]])]
    param (
        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Page,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('user_id')]
        [int] $UserId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('user_email')]
        [string] $UserEmail,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('resource_id')]
        [int] $ResourceId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('resource_type')]
        [string] $ResourceType,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('action_message')]
        [string] $ActionMessage
    )

    if (($PSBoundParameters.ContainsKey('ResourceId') -and -not $PSBoundParameters.ContainsKey('ResourceType')) -or ($PSBoundParameters.ContainsKey('ResourceType') -and -not $PSBoundParameters.ContainsKey('ResourceId'))) {
        throw 'ResourceId and ResourceType must be specified together.'
    }

    $Client = Get-HuduClientInternal

    $query = ConvertTo-RequestQuery -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters | ConvertTo-StringDictionary

    Write-Verbose "QUERY = $($query | ConvertTo-Json)"

    [Boyles.PowerShell.Hudu.Models.HuduActivityLog[]] $logs = $Client.GetActivityLogs($query)
    return $logs
}
