function Get-HuduIpAddress {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduIpAddress])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduIpAddress[]])]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryIgnore()]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('network_id')]
        [int] $NetworkId,

        [Parameter(ParameterSetName = 'All')]
        [QueryProperty('address')]
        [string] $Address,

        [Parameter(ParameterSetName = 'All')]
        [QueryProperty('status')]
        [string] $Status,

        [Parameter(ParameterSetName = 'All')]
        [QueryProperty('fqdn')]
        [string] $Fqdn,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('asset_id')]
        [int] $AssetId,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('company_id')]
        [int] $CompanyId
    )

    $client = Get-HuduClientInternal

    if ($PSCmdlet.ParameterSetName -eq 'Single') {

        try {
            [Boyles.PowerShell.Hudu.Models.HuduIpAddress] $ipAddress = $Client.GetIpAddress($Id)
            return $ipAddress
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

    [Boyles.PowerShell.Hudu.Models.HuduIpAddress[]] $results = $client.GetIpAddresses($query)
    return $results
}
