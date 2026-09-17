function Remove-HuduCompany {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $Id
    )
    process {

        $Client = Get-HuduClientInternal

        Write-Verbose "Deleting Company with ID $Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Delete Company')) {

            try {
                $Client.DeleteCompany($Id)
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
