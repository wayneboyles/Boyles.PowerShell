<#
.SYNOPSIS
    Creates a new folder in the connected Hudu instance.

.DESCRIPTION
    Creates a folder under the given company via the connected HuduClient (see Connect-Hudu).
    Only the parameters actually supplied are sent in the request body. Supports
    -WhatIf/-Confirm.

.PARAMETER Name
    Name of the new folder.

.PARAMETER Icon
    Font Awesome icon class for the folder, e.g. 'fas fa-folder'.

.PARAMETER Description
    Description of the folder.

.PARAMETER ParentFolderId
    ID of the parent folder, to create this folder as a subfolder.

.PARAMETER CompanyId
    ID of the company to create the folder under.

.PARAMETER FolderType
    Type of folder: 'article' or 'photo'. Hudu defaults to 'article' when omitted. Cannot be
    changed after the folder is created.

.EXAMPLE
    New-HuduFolder -Name 'Network' -CompanyId 5

    Creates an article folder named 'Network' under company 5.

.EXAMPLE
    New-HuduFolder 'Switches' -CompanyId 5 -ParentFolderId 12 -Icon 'fas fa-network-wired'

    Creates a 'Switches' subfolder inside folder 12.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduFolder
#>
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
