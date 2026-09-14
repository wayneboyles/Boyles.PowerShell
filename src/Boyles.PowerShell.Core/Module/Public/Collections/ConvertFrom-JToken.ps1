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
