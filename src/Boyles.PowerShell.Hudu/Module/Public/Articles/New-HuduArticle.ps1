function New-HuduArticle {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduArticle])]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
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

    $Client = Get-HuduClientInternal

    $body = @{
        name = $Name
    }

    if ($PSBoundParameters.ContainsKey('Content') -and (Test-HasValue $Content)) { $body['content'] = $Content }
    if ($PSBoundParameters.ContainsKey('EnableSharing')) { $body['enable_sharing'] = $EnableSharing }
    if ($PSBoundParameters.ContainsKey('FolderId') -and (Test-HasValue $FolderId)) { $body['folder_id'] = $FolderId }
    if ($PSBoundParameters.ContainsKey('CompanyId') -and (Test-HasValue $CompanyId)) { $body['company_id'] = $CompanyId }

    Write-Verbose "Body = $body"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new article in Hudu')) {
        [Boyles.PowerShell.Hudu.Models.HuduArticle] $result = $client.NewArticle($body)
        $result
    }
}
