function Disable-HuduArticle {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduArticle])]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)]
        [int] $Id
    )
    process {

        $Client = Get-HuduClientInternal

        Write-Verbose "Archiving Article with ID $Id"

        if ($PSCmdlet.ShouldProcess($Id, 'Archive Article')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduArticle] $result = $Client.ArchiveArticle($Id)
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
