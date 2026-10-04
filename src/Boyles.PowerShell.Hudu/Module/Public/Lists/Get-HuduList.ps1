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
