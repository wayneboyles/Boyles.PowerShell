---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduLabel

## SYNOPSIS
Retrieves one or more labels from the connected Hudu instance.

## SYNTAX

### All (Default)
```
Get-HuduLabel [-LabelTypeId <Int32>] [-LabelableId <Int32>] [-UserId <Int32>]
 [<CommonParameters>]
```

### Single
```
Get-HuduLabel [-Id] <Int32> [<CommonParameters>]
```

## DESCRIPTION
With -Id, retrieves a single label by ID, returning $null instead of throwing if the ID
doesn't exist (Hudu responds with an HTTP 404 in that case).
Without -Id, retrieves every
label matching the supplied filters.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduLabel -Id 12
```

Returns the label with ID 12, or $null if it doesn't exist.

### EXAMPLE 2
```
Get-HuduLabel
```

Returns every label.

### EXAMPLE 3
```
Get-HuduLabelType -Name 'Critical' | ForEach-Object { Get-HuduLabel -LabelTypeId $_.Id }
```

Returns every label that uses the 'Critical' label type.

### EXAMPLE 4
```
Get-HuduLabel -LabelableId 456
```

Returns the labels applied to the record with ID 456.

## PARAMETERS

### -Id
ID of a single label to retrieve.

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

### -LabelableId
Filters results to labels applied to the record with the given ID.

```yaml
Type: Int32
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -LabelTypeId
Filters results to labels of the given label type ID.

```yaml
Type: Int32
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserId
Filters results to labels created by the given user ID.

```yaml
Type: Int32
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Boyles.PowerShell.Hudu.Models.HuduLabel
### Boyles.PowerShell.Hudu.Models.HuduLabel[]
## NOTES

## RELATED LINKS
