function Test-RequiredValue {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter()]
        [AllowNull()]
        [AllowEmptyString()]
        [object]$Value,

        [Parameter()]
        [switch] $Secret
    )

    if (-not [string]::IsNullOrWhiteSpace($Value)) {
        return $Value
    }

    $nonInteractive = -not [Environment]::UserInteractive -or (([Environment]::GetCommandLineArgs()) -match '-NonInteractive')
    if ($nonInteractive) {
        throw "Required value '$Name' was not provided and no interactive session is available."
    }

    if ($Secret) {
        $sec = Read-Host -Prompt "Enter value for $Name" -AsSecureString
        return (New-Object System.Net.NetworkCredential('', $sec)).Password
    }

    return (Read-Host -Prompt "Enter value for $Name")
}
