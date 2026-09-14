function Enable-HuduAssetLayout {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAssetLayout])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position = 0)]
        [int] $Id
    )
    process {

        Confirm-BPSClient -Key ([Boyles.PowerShell.Hudu.Consts]::ClientCacheKey) -ServiceName 'Hudu'

        $Client = Get-BPSClient -Key ([Boyles.PowerShell.Hudu.Consts]::ClientCacheKey)

        $body = @{
            'active' = $true
        }

        Write-Verbose "Reactivating Asset Layout with ID $Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Enable the Asset Layout')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduAssetLayout] $result = $client.UpdateAssetLayout($Id, $body, $null)
                return $result
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
