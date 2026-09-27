---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Test-HasValue

## SYNOPSIS
Tests whether a value is meaningfully populated.

## SYNTAX

```
Test-HasValue [[-Value] <Object>] [<CommonParameters>]
```

## DESCRIPTION
Unlike a plain $null or empty-string check, this inspects the value's type to decide what
"has a value" means: strings must be non-null/non-whitespace, collections/enumerables must
have at least one element, and value types (structs, including numbers, dates, bools, etc.)
must differ from their type's default - so 0 and $false return $false.
Any other non-null
reference type is considered to have a value.

## EXAMPLES

### EXAMPLE 1
```
Test-HasValue -Value '   '
```

Returns $false.

### EXAMPLE 2
```
Test-HasValue -Value @()
```

Returns $false.

### EXAMPLE 3
```
Test-HasValue -Value 0
```

Returns $false, because 0 is the default value for \[int\].

### EXAMPLE 4
```
'Hudu' | Test-HasValue
```

Returns $true.

## PARAMETERS

### -Value
The value to test.
Accepts pipeline input.
$null, empty/whitespace strings, empty
collections, and default value types return $false.

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

### System.Boolean
## NOTES

## RELATED LINKS
