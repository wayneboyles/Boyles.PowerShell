function Get-HuduNetwork {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduNetwork])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduNetwork[]])]
    param (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Single')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryIgnore()]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('company_id')]
        [int] $CompanyId,

        [Parameter(ParameterSetName = 'All')]
        [QueryProperty('name')]
        [string] $Name,

        [Parameter(ParameterSetName = 'All')]
        [QueryProperty('slug')]
        [string] $Slug,

        [Parameter(ParameterSetName = 'All')]
        [QueryProperty('network_type')]
        [int] $NetworkType,

        [Parameter(ParameterSetName = 'All')]
        [QueryProperty('address')]
        [string] $Address,

        [Parameter(ParameterSetName = 'All')]
        [QueryProperty('location_id')]
        [int] $LocationId,

        [Parameter(ParameterSetName = 'All')]
        [QueryProperty('archived')]
        [switch] $Archived
    )

    $client = Get-HuduClientInternal

    if ($PSCmdlet.ParameterSetName -eq 'Single') {

        try {
            [Boyles.PowerShell.Hudu.Models.HuduNetwork] $Network = $Client.GetNetwork($Id)
            return $Network
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

    [Boyles.PowerShell.Hudu.Models.HuduNetwork[]] $results = $client.GetNetworks($requestQuery)
    return $results
}
