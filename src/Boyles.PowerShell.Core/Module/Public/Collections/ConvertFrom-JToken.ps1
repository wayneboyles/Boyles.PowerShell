<#
.SYNOPSIS
    Recursively converts a Newtonsoft.Json.Linq token graph into native PowerShell objects.

.DESCRIPTION
    Walks a JObject/JArray/JValue tree (as returned by Newtonsoft.Json when a response is
    deserialized without a target .NET type) and converts it into ordered [pscustomobject]
    instances, arrays, and plain values so the result behaves like anything else produced by
    ConvertFrom-Json. Accepts pipeline input and returns $null unchanged. Any value that is not a
    recognized JToken type is returned as-is.

.PARAMETER InputObject
    The JToken (JObject, JArray, or JValue) - or plain value - to convert. Accepts pipeline input.

.EXAMPLE
    $jObject | ConvertFrom-JToken

    Converts a Newtonsoft.Json.Linq.JObject into a [pscustomobject] with the same properties.

.EXAMPLE
    ConvertFrom-JToken -InputObject $jArrayOfObjects

    Converts a JArray of JObjects into an array of [pscustomobject] instances.
#>
function ConvertFrom-JToken {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        [AllowNull()]
        [object] $InputObject
    )

    process {
        if ($null -eq $InputObject) {
            return $null
        }

        if ($InputObject -is [Newtonsoft.Json.Linq.JObject]) {
            $result = [ordered] @{}

            foreach ($property in $InputObject.Properties()) {
                $result[$property.Name] = ConvertFrom-JToken -InputObject $property.Value
            }

            return [pscustomobject] $result
        }

        if ($InputObject -is [Newtonsoft.Json.Linq.JArray]) {
            return @(foreach ($item in $InputObject) {
                    ConvertFrom-JToken -InputObject $item
                })
        }

        if ($InputObject -is [Newtonsoft.Json.Linq.JValue]) {
            return $InputObject.Value
        }

        return $InputObject
    }
}
