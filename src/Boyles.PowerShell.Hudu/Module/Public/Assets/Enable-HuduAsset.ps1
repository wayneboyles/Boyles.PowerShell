function Enable-HuduAsset {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduAsset])]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id,

        [Parameter(Mandatory, Position = 0)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $CompanyId
    )
    process {

        $Client = Get-HuduClientInternal

        Write-Verbose "Unarchiving Asset with ID $Id in Company $CompanyId"

        if ($PSCmdlet.ShouldProcess($Id, 'Archive Asset')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduAsset] $result = $Client.UnarchiveAsset($Id, $CompanyId)
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
