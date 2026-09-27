[CmdletBinding()]
param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [string] $Tag
)

#==================================================================
# VARIABLES
#==================================================================



#==================================================================
# FUNCTIONS
#==================================================================

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

#==================================================================
# EXECUTION
#==================================================================
