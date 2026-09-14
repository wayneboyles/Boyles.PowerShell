function Enable-HuduCompany {
    [CmdletBinding(SupportsShouldProcess = $true)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduCompany])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $Id
    )
    process {

        Confirm-BPSClient -Key ([Boyles.PowerShell.Hudu.Consts]::ClientCacheKey) -ServiceName 'Hudu'

        $Client = Get-BPSClient -Key ([Boyles.PowerShell.Hudu.Consts]::ClientCacheKey)

        Write-Verbose "Unarchiving Company with ID $Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Enable Company')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduCompany] $result = $Client.UnarchiveCompany($Id)
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
