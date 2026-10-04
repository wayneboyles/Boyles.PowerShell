<#
.SYNOPSIS
    Removes a Magic Dash item from the connected Hudu instance.

.DESCRIPTION
    Deletes a Magic Dash item either by ID, or by the combination of title and company name.
    Returns $null instead of throwing when the item doesn't exist, since Hudu responds with an
    HTTP 404 in that case. Supports -WhatIf/-Confirm, with a 'High' confirm impact since deletion
    is irreversible.

.PARAMETER Id
    ID of the Magic Dash item to delete. Accepts pipeline input by property name. Cannot be
    combined with -Title and -CompanyName.

.PARAMETER Title
    Title of the Magic Dash item to delete. Must be used with -CompanyName.

.PARAMETER CompanyName
    Name of the company the Magic Dash item belongs to. Must be used with -Title.

.EXAMPLE
    Remove-HuduMagicDash -Id 42

    Deletes the Magic Dash item with ID 42, after confirmation.

.EXAMPLE
    Remove-HuduMagicDash -Title 'Backup Status' -CompanyName 'Acme'

    Deletes Acme's 'Backup Status' Magic Dash item, after confirmation.

.EXAMPLE
    Get-HuduMagicDash -CompanyId 5 | Remove-HuduMagicDash -Confirm:$false

    Deletes every Magic Dash item for company 5 without prompting.

.OUTPUTS
    None
#>
function Remove-HuduMagicDash {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'ById')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter(Mandatory, ParameterSetName = 'ByTitle')]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('title')]
        [string] $Title,

        [Parameter(Mandatory, ParameterSetName = 'ByTitle')]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('company_name')]
        [string] $CompanyName
    )
    process {

        $client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the MagicDash')) {
            try {
                if ($PSCmdlet.ParameterSetName -eq 'ById') {

                    # Delete by the MagicDash ID

                    $client.DeleteMagicDash($Id, $null)

                } else {

                    # Build the body from the parameters and delete by title and
                    # company name

                    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

                    Write-Verbose "Body = $($body | ConvertTo-Json)"

                    $client.DeleteMagicDash(0, $body)

                }
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
