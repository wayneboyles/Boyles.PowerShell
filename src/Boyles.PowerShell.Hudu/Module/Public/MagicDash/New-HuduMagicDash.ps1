<#
.SYNOPSIS
    Creates or updates a Magic Dash item in the connected Hudu instance.

.DESCRIPTION
    Sends a Magic Dash item to the connected HuduClient (see Connect-Hudu). Hudu identifies an
    item by its title and company name, so submitting an existing combination updates that item.
    Supports -WhatIf/-Confirm.

.PARAMETER Title
    Title of the Magic Dash item.

.PARAMETER Message
    Short message displayed on the item.

.PARAMETER CompanyName
    Name of the company the item belongs to.

.PARAMETER Icon
    Icon displayed on the item, for example a Font Awesome icon name.

.PARAMETER ImageUrl
    URL of an image to display on the item.

.PARAMETER ContentLink
    URL the item links to.

.PARAMETER Content
    HTML content displayed when the item is opened.

.PARAMETER Shade
    Shade (color) of the item, for example 'success', 'warning' or 'danger'.

.EXAMPLE
    New-HuduMagicDash -Title 'Backup Status' -Message 'Last backup OK' -CompanyName 'Acme'

    Creates a Magic Dash item for Acme.

.EXAMPLE
    New-HuduMagicDash -Title 'Backup Status' -Message 'Backup failed' -CompanyName 'Acme' -Shade 'danger' -ContentLink 'https://backup.example.com'

    Creates a red Magic Dash item for Acme that links to the backup console.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduMagicDash
#>
function New-HuduMagicDash {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduMagicDash])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Title,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $Message,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $CompanyName,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Icon,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $ImageUrl,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $ContentLink,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Content,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Shade
    )

    $client = Get-HuduClientInternal

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

    Write-Verbose "Body = $($body | ConvertTo-Json)"

    if ($PSCmdlet.ShouldProcess($Name, 'Create a new MagicDash')) {
        [Boyles.PowerShell.Hudu.Models.HuduMagicDash] $result = $client.NewMagicDash($body)
        return $result
    }
}
