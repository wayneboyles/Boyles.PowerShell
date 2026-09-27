<#
.SYNOPSIS
    Looks up the Hudu integration card for a record in an external integration.

.DESCRIPTION
    Calls Hudu's /cards/lookup endpoint via the connected HuduClient (see Connect-Hudu) to find
    the integrator card that links a record in an external system (PSA, RMM, Microsoft 365,
    etc.) to Hudu. Identify the external record either by its numeric -IntegrationId or by its
    string -IntegrationIdentifier.

.PARAMETER IntegrationSlug
    Slug of the external integration, e.g. 'cw_manage', 'autotask', 'halo', or 'syncro'.

.PARAMETER IntegrationId
    Numeric ID of the record in the external integration. Cannot be combined with
    -IntegrationIdentifier.

.PARAMETER IntegrationIdentifier
    String identifier of the record in the external integration, for integrations that don't use
    numeric IDs. Cannot be combined with -IntegrationId.

.EXAMPLE
    Get-HuduCard -IntegrationSlug 'cw_manage' -IntegrationId 1234

    Returns the card for ConnectWise Manage record 1234.

.EXAMPLE
    Get-HuduCard -IntegrationSlug 'watchman' -IntegrationIdentifier 'c1a2b3d4'

    Returns the card for the Watchman Monitoring computer with the given identifier.

.OUTPUTS
    Boyles.PowerShell.Hudu.Models.HuduCard
#>
function Get-HuduCard {
    [CmdletBinding(DefaultParameterSetName = 'ById')]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduCard])]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string] $IntegrationSlug,

        [Parameter(Mandatory, ParameterSetName = 'ById')]
        [ValidateRange(1, [int]::MaxValue)]
        [int] $IntegrationId,

        [Parameter(Mandatory, ParameterSetName = 'ByIdentifier')]
        [ValidateNotNullOrEmpty()]
        [string] $IntegrationIdentifier
    )

    $client = Get-HuduClientInternal

    if ($PSCmdlet.ParameterSetName -eq 'ById') {
        [Boyles.PowerShell.Hudu.Models.HuduCard[]] $results = $client.GetCardLookup($IntegrationSlug, $IntegrationId, $null)
        return $results
    } else {
        [Boyles.PowerShell.Hudu.Models.HuduCard[]] $results = $client.GetCardLookup($IntegrationSlug, $null, $IntegrationIdentifier)
        return $results
    }
}
