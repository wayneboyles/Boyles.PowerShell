<#
.SYNOPSIS
    Tests whether a value is meaningfully populated.

.DESCRIPTION
    Unlike a plain $null or empty-string check, this inspects the value's type to decide what
    "has a value" means: strings must be non-null/non-whitespace, collections/enumerables must
    have at least one element, and value types (structs, including numbers, dates, bools, etc.)
    must differ from their type's default - so 0 and $false return $false. Any other non-null
    reference type is considered to have a value.

.PARAMETER Value
    The value to test. Accepts pipeline input. $null, empty/whitespace strings, empty
    collections, and default value types return $false.

.EXAMPLE
    Test-HasValue -Value '   '

    Returns $false.

.EXAMPLE
    Test-HasValue -Value @()

    Returns $false.

.EXAMPLE
    Test-HasValue -Value 0

    Returns $false, because 0 is the default value for [int].

.EXAMPLE
    'Hudu' | Test-HasValue

    Returns $true.

.OUTPUTS
    System.Boolean
#>
function Test-HasValue {
    [CmdletBinding()]
    [OutputType([bool])]
    param (
        [Parameter(ValueFromPipeline)]
        [AllowNull()]
        [AllowEmptyString()]
        [AllowEmptyCollection()]
        [object] $Value
    )
    process {
        if ($null -eq $Value) {
            return $false
        }

        # Deliberately an if/elseif chain rather than `switch ($Value) { ... }`: switch
        # auto-enumerates an array/collection value and tests each element separately, which
        # would break the ICollection/IEnumerable branches below (they need to test $Value as a
        # single object, e.g. its .Count, not its first element).
        if ($Value -is [string]) {
            return ![string]::IsNullOrWhiteSpace($Value)
        } elseif ($Value -is [System.Collections.ICollection]) {
            return $Value.Count -gt 0
        } elseif ($Value -is [System.Collections.IEnumerable]) {
            return $Value.GetEnumerator().MoveNext()
        } elseif ($Value -is [ValueType]) {
            return $Value -ne [Activator]::CreateInstance($Value.GetType())
        } else {
            return $true
        }
    }
}
