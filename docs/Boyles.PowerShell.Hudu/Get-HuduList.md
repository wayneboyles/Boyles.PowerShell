---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduList

## SYNOPSIS
Retrieves one or more lists from the connected Hudu instance.

## SYNTAX

### All (Default)
```
Get-HuduList [-Query <String>] [-Name <String>] [<CommonParameters>]
```

### Single
```
Get-HuduList [-Id] <Int32> [<CommonParameters>]
```

## DESCRIPTION
With -Id, retrieves a single list by ID, returning $null instead of throwing if the ID
doesn't exist (Hudu responds with an HTTP 404 in that case).
Without -Id, retrieves every
list matching the supplied filters.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduList -Id 7
```

Returns the list with ID 7, or $null if it doesn't exist.

### EXAMPLE 2
```
Get-HuduList
```

Returns every list.

### EXAMPLE 3
```
Get-HuduList -Name 'Office Locations'
```

Returns the lists matching the name 'Office Locations'.

## PARAMETERS

### -Id
ID of a single list to retrieve.

```yaml
Type: Int32
Parameter Sets: Single
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Filters results to lists matching the given name.

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

### -Query
Filters results to lists matching the given search text.

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

### Boyles.PowerShell.Hudu.Models.HuduList
### Boyles.PowerShell.Hudu.Models.HuduList[]
## NOTES

## RELATED LINKS
