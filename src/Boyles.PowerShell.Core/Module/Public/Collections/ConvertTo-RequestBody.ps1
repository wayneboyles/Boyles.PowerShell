<#
.SYNOPSIS
    Builds a request body hashtable from a function's bound parameters.

.DESCRIPTION
    Loops through the calling function's parameter metadata and adds every parameter that was
    actually bound (present in $PSBoundParameters) to the returned hashtable, keyed by its JSON
    name:

    - A parameter decorated with [BodyProperty('json_name')] is keyed by that name.
    - A parameter with no [BodyProperty()] attribute is keyed by its own name in lowercase
      (e.g. -Name becomes 'name').
    - A parameter decorated with [BodyIgnore()] is skipped entirely. Use this for route/path
      parameters such as -Id or -CompanyId that belong in the URL rather than the body.
    - PowerShell's common parameters (-Verbose, -WhatIf, -ErrorAction, etc.) are always skipped.

    Value types (int, bool, switch, etc.) are always included when bound, even when they hold
    their default value, so -Enabled:$false is sent as false. Reference types (strings,
    arrays, objects) are only included when Test-HasValue returns $true, so an empty string or
    empty array is dropped.

.PARAMETER BoundParameters
    The $PSBoundParameters dictionary from the calling function.

.PARAMETER ParameterMetadata
    The calling function's parameter metadata, typically $MyInvocation.MyCommand.Parameters.

.EXAMPLE
    function Set-HuduWidget {
        [CmdletBinding(SupportsShouldProcess)]
        param(
            [BodyIgnore()]
            [Parameter(Mandatory)]
            [int] $Id,

            [Parameter()]
            [string] $Name,

            [BodyProperty('company_id')]
            [Parameter()]
            [int] $CompanyId
        )

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters
    }

    Set-HuduWidget -Id 7 -Name 'Core Switch' -CompanyId 5

    Inside the function, $body is @{ name = 'Core Switch'; company_id = 5 }. -Id is excluded
    by [BodyIgnore()], -Name falls back to its lowercase parameter name, and -CompanyId uses
    the name from [BodyProperty()].

.OUTPUTS
    System.Collections.Hashtable
#>
function ConvertTo-RequestBody {
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

    $body = @{}

    foreach ($paramName in $ParameterMetadata.Keys) {

        if ($commonParams -contains $paramName) {
            continue
        }

        if (-not $BoundParameters.ContainsKey($paramName)) {
            continue
        }

        $attributes = $ParameterMetadata[$paramName].Attributes

        if ($attributes | Where-Object { $_ -is [BodyIgnore] }) {
            continue
        }

        $value = $BoundParameters[$paramName]

        if ($value -isnot [ValueType] -and -not (Test-HasValue -Value $value)) {
            continue
        }

        $bodyAttr = $attributes | Where-Object { $_ -is [BodyProperty] } | Select-Object -First 1

        $key = if ($null -ne $bodyAttr) { $bodyAttr.Name } else { $paramName.ToLowerInvariant() }

        $body[$key] = $value
    }

    return $body
}
