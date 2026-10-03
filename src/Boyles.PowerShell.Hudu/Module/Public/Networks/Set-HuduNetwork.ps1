function Set-HuduNetwork {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduNetwork])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Address,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Description,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('network_type')]
        [int] $NetworkType,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('company_id')]
        [int] $CompanyId,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('location_id')]
        [int] $LocationId,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('vlan_id')]
        [int] $VlanId,

        [Parameter()]
        [switch] $Archived
    )
    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Network')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduNetwork] $result = $client.UpdateNetwork($Id, $body)
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
