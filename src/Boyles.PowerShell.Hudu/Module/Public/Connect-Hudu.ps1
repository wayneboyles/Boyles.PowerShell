<#
.SYNOPSIS
    Connects to a Hudu instance and registers the resulting client in the Boyles client store.
.DESCRIPTION
    Builds a [Boyles.PowerShell.Hudu.HuduClient] from -BaseUri/-ApiKey and registers it under -Key
    via Add-BoylesClient (Boyles.PowerShell.Core), so every other Hudu cmdlet can look the client
    back up by key instead of needing it passed to every call - from PowerShell via
    Get-BoylesClient -Key <Key>, or from C# via [Boyles.PowerShell.Hudu.HuduClient]::FromContext(<Key>).
    This mirrors how Connect-AzAccount leaves behind a context that later Az cmdlets read back
    implicitly.
.PARAMETER BaseUri
    Root URL of the Hudu instance, e.g. https://myinstance.huducloud.com.
.PARAMETER ApiKey
    Hudu API key, sent as the x-api-key header on every request.
.PARAMETER Key
    Unique name to register this connection under. Defaults to 'Default', so a single Connect-Hudu
    call with no -Key is enough for scripts that only ever talk to one Hudu instance; pass -Key to
    register additional named connections (e.g. 'Hudu-Prod', 'Hudu-Sandbox') side by side.
.EXAMPLE
    Connect-Hudu -BaseUri 'https://myinstance.huducloud.com' -ApiKey $env:HUDU_API_KEY

    Connects and registers the client under the default key. Later cmdlets in this module call
    Get-BoylesClient -Key 'Default' (or HuduClient.FromContext() in C#) to get it back.
.EXAMPLE
    Connect-Hudu -BaseUri 'https://prod.huducloud.com'    -ApiKey $prodKey    -Key 'Prod'
    Connect-Hudu -BaseUri 'https://sandbox.huducloud.com' -ApiKey $sandboxKey -Key 'Sandbox'

    $prodClient = Get-BoylesClient -Key 'Prod'

    Two Hudu instances registered side by side under different keys.
#>
function Connect-Hudu {
    [CmdletBinding()]
    [OutputType([void])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $BaseUri,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $ApiKey,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Key = [Boyles.PowerShell.Context.BoylesContextCache]::DefaultKey
    )

    process {
        $client = [Boyles.PowerShell.Hudu.HuduClient]::new($BaseUri, $ApiKey)

        Add-BoylesClient -Key $Key -Client $client

        Write-Verbose "Connected to Hudu at '$BaseUri' and registered the client under key '$Key'."
    }
}
