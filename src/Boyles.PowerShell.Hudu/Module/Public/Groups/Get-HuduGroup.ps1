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
