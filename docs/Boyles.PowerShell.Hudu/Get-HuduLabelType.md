---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduLabelType

## SYNOPSIS
Retrieves one or more label types from the connected Hudu instance.

## SYNTAX

### All (Default)
```
Get-HuduLabelType [-Name <String>] [-Color <String>] [-Slug <String>]
 [<CommonParameters>]
```

### Single
```
Get-HuduLabelType -Id <Int32> [<CommonParameters>]
```

## DESCRIPTION
With -Id, retrieves a single label type by ID, returning $null instead of throwing if the ID
doesn't exist (Hudu responds with an HTTP 404 in that case).
Without -Id, retrieves every
label type matching the supplied filters.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduLabelType -Id 3
```

Returns the label type with ID 3, or $null if it doesn't exist.

### EXAMPLE 2
```
Get-HuduLabelType -Name 'Critical'
```

Returns the label types matching the name 'Critical'.

### EXAMPLE 3
```
Get-HuduLabelType -Color 'Red'
```

Returns every red label type.

## PARAMETERS

### -Color
Filters results to label types of the given color.

```yaml
Type: String
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of a single label type to retrieve.

```yaml
Type: Int32
Parameter Sets: Single
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Filters results to label types matching the given name.

```yaml
Type: String
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Slug
Filters results to label types matching the given URL slug.

```yaml
Type: String
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Boyles.PowerShell.Hudu.Models.HuduLabelType
### Boyles.PowerShell.Hudu.Models.HuduLabelType[]
## NOTES

## RELATED LINKS
