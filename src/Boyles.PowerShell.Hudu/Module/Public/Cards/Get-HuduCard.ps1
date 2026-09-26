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
