<#
.SYNOPSIS
    Returns a required value, prompting for it interactively if it wasn't supplied.

.DESCRIPTION
    If Value is already populated, it is returned unchanged. Otherwise, in an interactive session,
    the user is prompted via Read-Host (masked, as a SecureString, when -Secret is specified) and
    the entered value is returned. In a non-interactive session (no interactive host, or
    -NonInteractive was passed on the command line), throws instead of prompting, since there is
    no one to answer.

.PARAMETER Name
    Name of the value, used in the prompt text and in the error thrown when it can't be prompted
    for.

.PARAMETER Value
    The value as already supplied by the caller, if any. When non-empty, it is returned as-is
    without prompting.

.PARAMETER Secret
    Prompts with masked input (a SecureString, converted back to plain text) instead of visible
    text.

.EXAMPLE
    $apiKey = Test-RequiredValue -Name 'ApiKey' -Value $ApiKey -Secret

    Returns $ApiKey if it was already provided; otherwise prompts for it with masked input.

.EXAMPLE
    $baseUri = Test-RequiredValue -Name 'BaseUri' -Value $BaseUri

    Returns $BaseUri if already provided; otherwise prompts for it with visible input, or throws
    if running non-interactively.
#>
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
