<#
.SYNOPSIS
    Connects to a Hudu instance and registers the resulting client for use by other Hudu cmdlets.

.DESCRIPTION
    Builds a HuduClient for the given base URL and API key and registers it in the process-wide
    Boyles client store (see Add-BPSClient) under Hudu's well-known cache key ('hudu'). Every
    other Boyles.PowerShell.Hudu cmdlet looks the client back up via Get-HuduClientInternal, so
    Connect-Hudu only needs to be run once per session. Running it again replaces (and disposes)
    the existing client, which is how you switch instances or keys.

    Connect-Hudu does not call the API, so an invalid URL or key only surfaces on the first
    request. Run Get-HuduApiInfo afterwards to verify the connection.

.PARAMETER BaseUrl
    Base URL of the Hudu instance, e.g. 'https://myinstance.huducloud.com'.

.PARAMETER ApiKey
    API key used to authenticate requests to the Hudu API.

.EXAMPLE
    Connect-Hudu -BaseUrl 'https://myinstance.huducloud.com' -ApiKey $env:HUDU_API_KEY

    Connects to the given Hudu instance and registers the client for use by other Hudu cmdlets.

.EXAMPLE
    Connect-Hudu 'https://myinstance.huducloud.com' (Get-Secret -Name 'Hudu.ApiKey' -AsPlainText)
    Get-HuduApiInfo

    Connects using an API key from a SecretManagement vault, then verifies the connection.

.OUTPUTS
    None
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

    Write-Verbose "Connected to Hudu at '$BaseUrl' and registered the client under key '$Key'."
}
