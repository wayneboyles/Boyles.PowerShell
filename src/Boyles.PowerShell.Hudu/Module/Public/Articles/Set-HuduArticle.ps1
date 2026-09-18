function Set-HuduArticle {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduArticle])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [int] $Id,

        [Parameter()]
        [string] $Name,

        [Parameter()]
        [string] $Content,

        [Parameter()]
        [bool] $EnableSharing,

        [Parameter()]
        [int] $FolderId,

        [Parameter()]
        [int] $CompanyId
    )
    process {

        $Client = Get-HuduClientInternal

        $body = @{}

        if ($PSBoundParameters.ContainsKey('Name') -and (Test-HasValue $Name)) { $body['name'] = $Name }
        if ($PSBoundParameters.ContainsKey('Content') -and (Test-HasValue $Content)) { $body['content'] = $Content }
        if ($PSBoundParameters.ContainsKey('EnableSharing')) { $body['enable_sharing'] = $EnableSharing }
        if ($PSBoundParameters.ContainsKey('FolderId') -and (Test-HasValue $FolderId)) { $body['folder_id'] = $FolderId }
        if ($PSBoundParameters.ContainsKey('CompanyId') -and (Test-HasValue $CompanyId)) { $body['company_id'] = $CompanyId }

        Write-Verbose "Body = $body"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Article')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduArticle] $result = $client.UpdateArticle($Id, $body)
                $result
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
