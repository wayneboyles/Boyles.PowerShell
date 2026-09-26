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
        [QueryProperty('flag_type_id')]
        [int] $FlagTypeId,

        [Parameter(ParameterSetName = 'All')]
        [QueryProperty('flagable_id')]
        [int] $FlagableId,

        [Parameter(ParameterSetName = 'All')]
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
