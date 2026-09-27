---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# ConvertFrom-JToken

## SYNOPSIS
Recursively converts a Newtonsoft.Json.Linq token graph into native PowerShell objects.

## SYNTAX

```
ConvertFrom-JToken [[-InputObject] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Walks a JObject/JArray/JValue tree (as returned by Newtonsoft.Json when a response is
deserialized without a target .NET type) and converts it into ordered \[pscustomobject\]
instances, arrays, and plain values so the result behaves like anything else produced by
ConvertFrom-Json.
Returns $null unchanged.
Any value that is not a recognized JToken type is
returned as-is.

JObject, JArray, and JValue all implement IEnumerable, so PowerShell auto-enumerates them into
their child tokens if piped directly, before this function ever sees the original object.
Pass
them via -InputObject instead, or wrap a piped value with Write-Output -NoEnumerate.

## EXAMPLES

### EXAMPLE 1
```
ConvertFrom-JToken -InputObject $jObject
```

Converts a Newtonsoft.Json.Linq.JObject into a \[pscustomobject\] with the same properties.

### EXAMPLE 2
```
ConvertFrom-JToken -InputObject $jArrayOfObjects
```

Converts a JArray of JObjects into an array of \[pscustomobject\] instances.

### EXAMPLE 3
```
Write-Output -NoEnumerate $jObject | ConvertFrom-JToken
```

Pipes a JObject through without PowerShell unrolling it first.

### EXAMPLE 4
```
ConvertFrom-JToken -InputObject ([Newtonsoft.Json.Linq.JToken]::Parse('{"name":"Acme","tags":["a","b"]}'))
```

Returns a \[pscustomobject\] with name = 'Acme' and tags = @('a', 'b').

## PARAMETERS

### -InputObject
The JToken (JObject, JArray, or JValue) - or plain value - to convert.
Accepts pipeline input
for plain values, but a JObject/JArray/JValue should be passed via -InputObject instead - see
DESCRIPTION.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
