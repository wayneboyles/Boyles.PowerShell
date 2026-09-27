---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# ConvertTo-StringDictionary

## SYNOPSIS
Converts a hashtable into a Dictionary\[string, string\] suitable for REST query parameters.

## SYNTAX

```
ConvertTo-StringDictionary [-Table] <Hashtable> [<CommonParameters>]
```

## DESCRIPTION
Stringifies every key and value in the input hashtable.
Booleans are rendered as lowercase
"true"/"false" (rather than PowerShell's default "True"/"False") because that is what REST
query parameters - Hudu's API included - expect.
All other values are converted via
\[string\], so a $null value becomes an empty string.

Typically used to turn the output of ConvertTo-RequestQuery (or a hand-built query
hashtable) into the dictionary the C# client methods accept.

## EXAMPLES

### EXAMPLE 1
```
ConvertTo-StringDictionary -Table @{ archived = $true; page_size = 25 }
```

Returns a Dictionary\[string, string\] with 'archived' = 'true' and 'page_size' = '25'.

### EXAMPLE 2
```
@{ company_id = 5; draft = $false } | ConvertTo-StringDictionary
```

Returns a Dictionary\[string, string\] with 'company_id' = '5' and 'draft' = 'false'.

## PARAMETERS

### -Table
The hashtable to convert.
Accepts pipeline input.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Generic.Dictionary[string, string]
## NOTES

## RELATED LINKS
