<#
.SYNOPSIS
    Recursively converts a Newtonsoft.Json.Linq token graph into native PowerShell objects.

.DESCRIPTION
    Walks a JObject/JArray/JValue tree (as returned by Newtonsoft.Json when a response is
    deserialized without a target .NET type) and converts it into ordered [pscustomobject]
    instances, arrays, and plain values so the result behaves like anything else produced by
    ConvertFrom-Json. Returns $null unchanged. Any value that is not a recognized JToken type is
    returned as-is.

    JObject, JArray, and JValue all implement IEnumerable, so PowerShell auto-enumerates them into
    their child tokens if piped directly, before this function ever sees the original object. Pass
    them via -InputObject instead, or wrap a piped value with Write-Output -NoEnumerate.

.PARAMETER InputObject
    The JToken (JObject, JArray, or JValue) - or plain value - to convert. Accepts pipeline input
    for plain values, but a JObject/JArray/JValue should be passed via -InputObject instead - see
    DESCRIPTION.

.EXAMPLE
    ConvertFrom-JToken -InputObject $jObject

    Converts a Newtonsoft.Json.Linq.JObject into a [pscustomobject] with the same properties.

.EXAMPLE
    ConvertFrom-JToken -InputObject $jArrayOfObjects

    Converts a JArray of JObjects into an array of [pscustomobject] instances.

.EXAMPLE
    Write-Output -NoEnumerate $jObject | ConvertFrom-JToken

    Pipes a JObject through without PowerShell unrolling it first.
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
