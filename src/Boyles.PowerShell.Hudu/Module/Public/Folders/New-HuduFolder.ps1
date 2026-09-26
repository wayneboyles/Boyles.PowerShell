function New-HuduFolder {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduFolder])]
    param (
        [Parameter(Mandatory, Position = 0)]
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

        [Parameter(Mandatory)]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyProperty('company_id')]
        [int] $CompanyId,

        [Parameter(ParameterSetName = 'All')]
        [ValidateSet('article', 'photo')]
        [BodyProperty('folder_type')]
        [string] $FolderType
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new Folder')) {
        [Boyles.PowerShell.Hudu.Models.HuduFolder] $result = $client.NewFolder($body)
        return $result
    }

}
