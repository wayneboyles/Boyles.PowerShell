---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduFlagType

## SYNOPSIS
Retrieves one or more flag types from the connected Hudu instance.

## SYNTAX

### All (Default)
```
Get-HuduFlagType [-Name <String>] [-Color <String>] [-Slug <String>]
 [<CommonParameters>]
```

### Single
```
Get-HuduFlagType -Id <Int32> [<CommonParameters>]
```

## DESCRIPTION
With -Id, retrieves a single flag type by ID, returning $null instead of throwing if the ID
doesn't exist (Hudu responds with an HTTP 404 in that case).
Without -Id, retrieves every
flag type matching the supplied filters, across all pages.
Hudu matches the filters exactly.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduFlagType
```

Returns every flag type.

### EXAMPLE 2
```
Get-HuduFlagType -Name 'Critical Issue'
```

Returns the flag type named 'Critical Issue'.

## PARAMETERS

### -Color
Filters results to flag types with exactly the given color.

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
ID of a single flag type to retrieve.

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
Filters results to the flag type with exactly the given name.

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
Filters results to the flag type with exactly the given URL slug.

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

### Boyles.PowerShell.Hudu.Models.HuduFlagType
### Boyles.PowerShell.Hudu.Models.HuduFlagType[]
## NOTES

## RELATED LINKS
