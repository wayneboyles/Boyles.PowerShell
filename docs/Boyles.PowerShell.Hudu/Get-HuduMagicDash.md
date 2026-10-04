---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduMagicDash

## SYNOPSIS
Retrieves Magic Dash items from the connected Hudu instance.

## SYNTAX

```
Get-HuduMagicDash [[-Title] <String>] [[-CompanyId] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Retrieves every Magic Dash item matching the supplied filters, or all of them when no
filters are given.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduMagicDash
```

Returns every Magic Dash item.

### EXAMPLE 2
```
Get-HuduMagicDash -CompanyId 5
```

Returns the Magic Dash items for company 5.

### EXAMPLE 3
```
Get-HuduMagicDash -Title 'Backup Status'
```

Returns the Magic Dash items titled 'Backup Status'.

## PARAMETERS

### -CompanyId
Filters results to Magic Dash items belonging to the given company ID.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
Filters results to Magic Dash items matching the given title.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Boyles.PowerShell.Hudu.Models.HuduMagicDash
### Boyles.PowerShell.Hudu.Models.HuduMagicDash[]
## NOTES

## RELATED LINKS
