<#
.SYNOPSIS
    Converts a hashtable into a Dictionary[string, string] suitable for REST query parameters.

.DESCRIPTION
    Stringifies every key and value in the input hashtable. Booleans are rendered as lowercase
    "true"/"false" (rather than PowerShell's default "True"/"False") because that is what REST
    query parameters - Hudu's API included - expect. All other values are converted via
    [string], so a $null value becomes an empty string.

    Typically used to turn the output of ConvertTo-RequestQuery (or a hand-built query
    hashtable) into the dictionary the C# client methods accept.

.PARAMETER Table
    The hashtable to convert. Accepts pipeline input.

.EXAMPLE
    ConvertTo-StringDictionary -Table @{ archived = $true; page_size = 25 }

    Returns a Dictionary[string, string] with 'archived' = 'true' and 'page_size' = '25'.

.EXAMPLE
    @{ company_id = 5; draft = $false } | ConvertTo-StringDictionary

    Returns a Dictionary[string, string] with 'company_id' = '5' and 'draft' = 'false'.

.OUTPUTS
    System.Collections.Generic.Dictionary[string, string]
#>
function ConvertTo-StringDictionary {
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
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
