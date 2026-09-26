function Set-HuduFolder {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduFolder])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('name')]
        [string] $Name,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('icon')]
        [string] $Icon,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('description')]
        [string] $Description,

        [Parameter()]
        [BodyProperty('parent_folder_id')]
        [int] $ParentFolderId,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('company_id')]
        [int] $CompanyId,

        [Parameter(ParameterSetName = 'All')]
        [ValidateSet('article', 'photo')]
        [BodyProperty('folder_type')]
        [string] $FolderType
    )
    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Folder')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduFolder] $result = $client.UpdateFolder($Id, $body)
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
