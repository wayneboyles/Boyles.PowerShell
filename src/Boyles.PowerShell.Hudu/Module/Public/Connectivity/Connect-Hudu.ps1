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

    process {
        $Key = [Boyles.PowerShell.Hudu.Consts]::ClientCacheKey

        $Client = [Boyles.PowerShell.Hudu.Services.HuduClient]::Create($BaseUrl, $ApiKey)

        Add-BPSClient -Key $Key -Client $Client

        Write-Verbose "Connected to Hudu at '$BaseUri' and registered the client under key '$Key'."
    }
}
