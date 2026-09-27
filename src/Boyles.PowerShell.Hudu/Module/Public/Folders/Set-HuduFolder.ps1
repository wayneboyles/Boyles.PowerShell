<#
.SYNOPSIS
    Updates an existing folder in the connected Hudu instance.

.DESCRIPTION
    Updates the folder with the given ID via the connected HuduClient (see Connect-Hudu). Only
    the parameters actually supplied are sent in the request body, so omitted properties are
    left unchanged. Returns $null instead of throwing when the ID doesn't exist, since Hudu
    responds with an HTTP 404 in that case. Supports -WhatIf/-Confirm.

.PARAMETER Id
    ID of the folder to update. Accepts pipeline input by property name.

.PARAMETER Name
    New name for the folder.

.PARAMETER Icon
    New Font Awesome icon class for the folder.

.PARAMETER Description
    New description for the folder.

.PARAMETER ParentFolderId
    ID of the folder to move this folder under.

.PARAMETER CompanyId
    ID of the company to associate the folder with.

.PARAMETER FolderType
    Type of folder: 'article' or 'photo'. A folder's type cannot be changed after creation, so
    Hudu rejects the update if this differs from the folder's current type.

.EXAMPLE
    Set-HuduFolder -Id 12 -Name 'Networking'

    Renames folder 12.

.EXAMPLE
    Get-HuduFolder -CompanyId 5 -Name 'Switches' | Set-HuduFolder -ParentFolderId 20

    Moves the 'Switches' folder under folder 20.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduFolder
#>
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
