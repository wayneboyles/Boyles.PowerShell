function Set-HuduIpAddress {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduIpAddress])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $Address,

        [Parameter()]
        [ValidateSet('Unassigned', 'Assigned', 'Reserved', 'Deprecated', 'DHCP', 'SLAAC')]
        [string] $Status,

        [Parameter()]
        [string] $Fqdn,

        [Parameter()]
        [string] $Description,

        [Parameter()]
        [string] $Notes,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('asset_id')]
        [int] $AssetId,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('network_id')]
        [int] $NetworkId,

        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('company_id')]
        [int] $CompanyId,

        [Parameter()]
        [BodyProperty('skip_dns_validation')]
        [switch] $SkipDnsValidation
    )
    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the IP Address')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduIpAddress] $result = $client.UpdateIpAddress($Id, $body)
                $result
            } catch {
                $message = $_.Exception.Message
                if ($message -like '*HTTP 404*') {
                    return $null # ID wasn't found.  Hudu returns a 404 error
                } else {
                    throw $_
                }
            }

        }

    }
}
