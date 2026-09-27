<#
.SYNOPSIS
    Builds a query-string hashtable from a function's bound parameters.

.DESCRIPTION
    The query-string counterpart to ConvertTo-RequestBody. Loops through the calling function's
    parameter metadata and adds every parameter that was actually bound (present in
    $PSBoundParameters) to the returned hashtable, keyed by its query-string name:

    - A parameter decorated with [QueryProperty('query_name')] is keyed by that name.
    - A parameter with no [QueryProperty()] attribute is keyed by its own name in lowercase.
    - A parameter decorated with [QueryIgnore()] is skipped entirely. Use this for route/path
      parameters such as -Id that belong in the URL rather than the query string.
    - PowerShell's common parameters (-Verbose, -WhatIf, -ErrorAction, etc.) are always skipped.

    Value types (int, bool, switch, etc.) are always included when bound, even when they hold
    their default value. Reference types (strings, arrays, objects) are only included when
    Test-HasValue returns $true.

    The result is a plain hashtable of typed values. Pipe it to ConvertTo-StringDictionary to
    get the Dictionary[string, string] that the C# client methods expect, with booleans
    rendered as lowercase 'true'/'false'.

.PARAMETER BoundParameters
    The $PSBoundParameters dictionary from the calling function.

.PARAMETER ParameterMetadata
    The calling function's parameter metadata, typically $MyInvocation.MyCommand.Parameters.

.EXAMPLE
    function Get-HuduWidget {
        [CmdletBinding()]
        param(
            [QueryProperty('company_id')]
            [Parameter()]
            [int] $CompanyId,

            [QueryProperty('archived')]
            [Parameter()]
            [bool] $Archived
        )

        $query = ConvertTo-RequestQuery -BoundParameters $PSBoundParameters `
            -ParameterMetadata $MyInvocation.MyCommand.Parameters | ConvertTo-StringDictionary
    }

    Get-HuduWidget -CompanyId 5 -Archived $false

    Inside the function, $query is a Dictionary[string, string] containing
    company_id = '5' and archived = 'false'.

.OUTPUTS
    System.Collections.Hashtable
#>
function ConvertTo-RequestQuery {
    [OutputType([hashtable])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $BoundParameters,

        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, System.Management.Automation.ParameterMetadata]] $ParameterMetadata
    )

    # PowerShell's built-in parameters (-Verbose, -WhatIf, -ErrorAction, etc.) show up in both
    # ParameterMetadata and PSBoundParameters just like the function's own parameters, so they
    # have to be excluded explicitly - there's no metadata flag that marks them as "common".
    $commonParams = [System.Management.Automation.Cmdlet]::CommonParameters + [System.Management.Automation.Cmdlet]::OptionalCommonParameters

    $query = @{}

    foreach ($paramName in $ParameterMetadata.Keys) {

        if ($commonParams -contains $paramName) {
            continue
        }

        if (-not $BoundParameters.ContainsKey($paramName)) {
            continue
        }

        $attributes = $ParameterMetadata[$paramName].Attributes

        if ($attributes | Where-Object { $_ -is [QueryIgnore] }) {
            continue
        }

        $value = $BoundParameters[$paramName]

        if ($value -isnot [ValueType] -and -not (Test-HasValue -Value $value)) {
            continue
        }

        $queryAttr = $attributes | Where-Object { $_ -is [QueryProperty] } | Select-Object -First 1

        $key = if ($null -ne $queryAttr) { $queryAttr.Name } else { $paramName.ToLowerInvariant() }

        $query[$key] = $value
    }

    return $query
}
