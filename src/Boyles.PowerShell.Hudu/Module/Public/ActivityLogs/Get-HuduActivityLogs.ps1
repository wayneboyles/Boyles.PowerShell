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
