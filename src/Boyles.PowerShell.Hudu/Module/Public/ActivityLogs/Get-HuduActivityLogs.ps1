<#
.SYNOPSIS
    Retrieves activity logs from the connected Hudu instance.

.DESCRIPTION
    Queries the Hudu activity log endpoint via the connected HuduClient (see Connect-Hudu),
    applying whichever filters were supplied as query parameters. ResourceId and ResourceType
    must be specified together - supplying only one of the pair throws.

.PARAMETER Page
    Page size / number of results to return per page.

.PARAMETER PageNumber
    Page number to retrieve.

.PARAMETER UserId
    Filters results to activity performed by the given user ID.

.PARAMETER UserEmail
    Filters results to activity performed by the user with the given email address.

.PARAMETER ResourceId
    Filters results to activity on the given resource ID. Must be specified together with
    ResourceType.

.PARAMETER ResourceType
    Filters results to activity on the given resource type (e.g. 'Asset', 'Article'). Must be
    specified together with ResourceId.

.PARAMETER ActionMessage
    Filters results to log entries whose action message matches the given text.

.EXAMPLE
    Get-HuduActivityLogs

    Returns the most recent activity log entries with no filters applied.

.EXAMPLE
    Get-HuduActivityLogs -ResourceId 123 -ResourceType 'Asset'

    Returns activity log entries for the asset with ID 123.

.EXAMPLE
    Get-HuduActivityLogs -UserEmail 'tech@example.com' -PageNumber 2

    Returns page 2 of activity performed by the given user.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduActivityLog[]
#>
function Get-HuduActivityLogs {
    [CmdletBinding()]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduActivityLog[]])]
    param (
        [Parameter()]
        [int] $Page,

        [Parameter()]
        [int] $PageNumber,

        [Parameter()]
        [int] $UserId,

        [Parameter()]
        [string] $UserEmail,

        [Parameter()]
        [int] $ResourceId,

        [Parameter()]
        [string] $ResourceType,

        [Parameter()]
        [string] $ActionMessage
    )

    if (($PSBoundParameters.ContainsKey('ResourceId') -and -not $PSBoundParameters.ContainsKey('ResourceType')) -or ($PSBoundParameters.ContainsKey('ResourceType') -and -not $PSBoundParameters.ContainsKey('ResourceId'))) {
        throw 'ResourceId and ResourceType must be specified together.'
    }

    $Client = Get-HuduClientInternal

    $query = @{}

    if ($PSBoundParameters.ContainsKey($Page)) { $query['page'] = $Page }
    if ($PSBoundParameters.ContainsKey($PageNumber)) { $query['page_number'] = $PageNumber }
    if ($PSBoundParameters.ContainsKey($UserId)) { $query['user_id'] = $UserId }
    if ($PSBoundParameters.ContainsKey($UserEmail) -and (Test-HasValue $UserEmail)) { $query['user_email'] = $UserEmail }
    if ($PSBoundParameters.ContainsKey($ResourceId)) { $query['resource_id'] = $ResourceId }
    if ($PSBoundParameters.ContainsKey($ResourceType) -and (Test-HasValue $ResourceType)) { $query['resource_type'] = $ResourceType }
    if ($PSBoundParameters.ContainsKey($ActionMessage) -and (Test-HasValue $ActionMessage)) { $query['action_message'] = $ActionMessage }

    $queryDict = ConvertTo-StringDictionary -Table $query

    [Boyles.PowerShell.Hudu.Models.HuduActivityLog[]] $logs = $Client.GetActivityLogs($queryDict)
    return $logs
}
