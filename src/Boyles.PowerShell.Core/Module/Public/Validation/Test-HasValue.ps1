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
