<#
.SYNOPSIS
    Tests whether a value is meaningfully populated.

.DESCRIPTION
    Unlike a plain $null or empty-string check, this inspects the value's type to decide what
    "has a value" means: strings must be non-null/non-whitespace, collections/enumerables must
    have at least one element, and value types (structs, including numbers, dates, bools, etc.)
    must differ from their type's default. Any other non-null reference type is considered to
    have a value.

.PARAMETER Value
    The value to test. Accepts pipeline input. $null, empty strings/collections, and default value
    types return $false.

.EXAMPLE
    Test-HasValue -Value ''

    Returns $false.

.EXAMPLE
    Test-HasValue -Value @()

    Returns $false.

.EXAMPLE
    'Hudu' | Test-HasValue

    Returns $true.
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

        switch ($Value) {
            { $_ -is [string] } { return ![string]::IsNullOrWhiteSpace($_) }
            { $_ -is [System.Collections.ICollection] } { return $_.Count -gt 0 }
            { $_ -is [System.Collections.IEnumerable] } { return $_.GetEnumerator().MoveNext() }
            { $_ -is [ValueType] } { return $_ -ne [Activator]::CreateInstance($_.GetType()) }
            default { return $true }
        }
    }
}
