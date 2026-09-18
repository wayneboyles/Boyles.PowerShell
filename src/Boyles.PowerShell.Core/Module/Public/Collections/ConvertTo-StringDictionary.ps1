<#
.SYNOPSIS
    Converts a hashtable into a Dictionary[string, string] suitable for REST query parameters.

.DESCRIPTION
    Stringifies every value in the input hashtable, with special handling for booleans: they are
    rendered as lowercase "true"/"false" (rather than PowerShell's default "True"/"False") because
    that is what REST query parameters - Hudu's API included - expect. All other value types are
    converted via [string].

.PARAMETER Table
    The hashtable to convert. Keys are stringified; values are stringified per the rules above.

.EXAMPLE
    ConvertTo-StringDictionary -Table @{ archived = $true; page_size = 25 }

    Returns a Dictionary[string, string] with 'archived' = 'true' and 'page_size' = '25'.
#>
function ConvertTo-StringDictionary {
    param(
        [Parameter(Mandatory, Position = 0)]
        [hashtable] $Table
    )

    $dict = [System.Collections.Generic.Dictionary[string, string]]::new()

    foreach ($key in $Table.Keys) {
        $value = $Table[$key]

        # ToString() matters: 100 (int) etc. must become strings. Booleans need an
        # explicit lowercase conversion - [string]$true/$false yield "True"/"False",
        # but REST query parameters (Hudu included) expect lowercase "true"/"false".
        $stringValue = if ($value -is [bool]) {
            $value.ToString().ToLowerInvariant()
        } else {
            [string] $value
        }

        $dict[[string]$key] = $stringValue

        # # ToString() matters: 100 (int), $true (bool) etc. must become strings
        # $dict[[string]$key] = [string]$Table[$key].ToString().ToLower()
    }

    return $dict
}
