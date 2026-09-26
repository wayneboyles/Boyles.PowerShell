function Remove-HuduExpiration {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $Id
    )
    process {

        $client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the Expiration')) {
            try {
                $client.DeleteExpiration($Id)
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
