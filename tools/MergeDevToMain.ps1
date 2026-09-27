[CmdletBinding()]
[OutputType([void])]
param (
    [Parameter()]
    [ValidateScript({
            if ($_ -notmatch '^v\d+\.\d+\.\d+$') {
                throw "Tag '$_' is invalid. Expected format: v0.0.0 (e.g. v1.2.3)."
            }
            $true
        })]
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

$status = git status 2>&1 | Out-String
if ($status -notmatch 'working tree clean') {
    throw 'Repository has pending changes.  Commit and push those changes to the repository first.'
}

git checkout main

git pull origin main

git merge dev

git push origin main

if (Test-HasValue($Tag)) {
    git tag -a $Tag -m "$Tag"
    git push origin $Tag
}

git checkout dev

git merge main
