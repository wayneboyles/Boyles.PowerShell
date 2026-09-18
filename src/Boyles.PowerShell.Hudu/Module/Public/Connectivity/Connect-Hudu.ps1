<#
.SYNOPSIS
    Connects to a Hudu instance and registers the resulting client for use by other Hudu cmdlets.

.DESCRIPTION
    Builds a HuduClient for the given base URL and API key and registers it in the process-wide
    Boyles client store (see Add-BPSClient) under Hudu's well-known cache key. Every other
    Boyles.PowerShell.Hudu cmdlet looks the client back up via Get-HuduClientInternal, so
    Connect-Hudu only needs to be run once per session (or again to switch instances/keys).

.PARAMETER BaseUrl
    Base URL of the Hudu instance, e.g. 'https://myinstance.huducloud.com'.

.PARAMETER ApiKey
    API key used to authenticate requests to the Hudu API.

.EXAMPLE
    Connect-Hudu -BaseUrl 'https://myinstance.huducloud.com' -ApiKey $env:HUDU_API_KEY

    Connects to the given Hudu instance and registers the client for use by other Hudu cmdlets.
#>
function Connect-Hudu {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $BaseUrl,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $ApiKey
    )

    [string] $Key = [Boyles.PowerShell.Hudu.Consts]::ClientCacheKey

    [Boyles.PowerShell.Hudu.Services.HuduClient] $Client = [Boyles.PowerShell.Hudu.Services.HuduClient]::Create($BaseUrl, $ApiKey)

    Add-BPSClient -Key $Key -Client $Client

    Write-Verbose "Connected to Hudu at '$BaseUri' and registered the client under key '$Key'."
}
