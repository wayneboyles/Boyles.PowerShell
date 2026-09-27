<#
.SYNOPSIS
    Retrieves one or more folders from the connected Hudu instance.

.DESCRIPTION
    With -Id, retrieves a single folder by ID, returning $null instead of throwing if the ID
    doesn't exist (Hudu responds with an HTTP 404 in that case). Without -Id, retrieves every
    folder matching the supplied filters, across all pages.

.PARAMETER Id
    ID of a single folder to retrieve.

.PARAMETER Name
    Filters results to folders matching the given name.

.PARAMETER CompanyId
    Filters results to folders belonging to the given company ID.

.PARAMETER InCompany
    Returns only company-specific folders, excluding global knowledge base folders.

.PARAMETER FolderType
    Filters results by folder type: 'article' or 'photo'.

.EXAMPLE
    Get-HuduFolder -Id 12

    Returns the folder with ID 12, or $null if it doesn't exist.

.EXAMPLE
    Get-HuduFolder -CompanyId 5 -FolderType 'article'

    Returns every article folder belonging to company 5.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduFolder

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduFolder[]
#>
function Get-HuduFolder {
    [CmdletBinding(DefaultParameterSetName = 'All')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduFolder])]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduFolder[]])]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryIgnore()]
        [int] $Id,

        [Parameter(ParameterSetName = 'All')]
        [ValidateNotNullOrEmpty()]
        [QueryProperty('name')]
        [string] $Name,

        [Parameter(ParameterSetName = 'All')]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryProperty('company_id')]
        [int] $CompanyId,

        [Parameter(ParameterSetName = 'All')]
        [QueryProperty('in_company')]
        [switch] $InCompany,

        [Parameter(ParameterSetName = 'All')]
        [ValidateSet('article', 'photo')]
        [QueryProperty('folder_type')]
        [string] $FolderType
    )

    $client = Get-HuduClientInternal

    if ($PSCmdlet.ParameterSetName -eq 'Single') {

        try {
            [Boyles.PowerShell.Hudu.Models.HuduFolder] $folder = $Client.GetFolder($Id)
            return $folder
        } catch {
            $message = $_.Exception.Message
            if ($message -like '*HTTP 404*') {
                return $null # ID wasn't found.  Hudu returns a 404 error
            } else {
                throw $_
            }
        }

    }

    $query = ConvertTo-RequestQuery -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters | ConvertTo-StringDictionary

    Write-Verbose "QUERY = $($query | ConvertTo-Json)"

    [Boyles.PowerShell.Hudu.Models.HuduFolder[]] $results = $client.GetFolders($query)
    return $results
}
