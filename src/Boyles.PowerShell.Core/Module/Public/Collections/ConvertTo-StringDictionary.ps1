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
