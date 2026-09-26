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
