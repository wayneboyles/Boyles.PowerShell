---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# New-HuduLabel

## SYNOPSIS
Applies a label to a record in the connected Hudu instance.

## SYNTAX

```
New-HuduLabel [[-LabelTypeId] <Int32>] [[-LabelableId] <Int32>] [[-LabelableType] <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a label by linking an existing label type to a record, via the connected HuduClient
(see Connect-Hudu).
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
New-HuduLabel -LabelTypeId 3 -LabelableId 456 -LabelableType 'Asset'
```

Applies label type 3 to the asset with ID 456.

### EXAMPLE 2
```
New-HuduLabel -LabelTypeId 3 -LabelableId 456 -LabelableType 'Asset' -WhatIf
```

Shows what would happen without creating the label.

## PARAMETERS

### -LabelableId
ID of the record to apply the label to.

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

### -LabelableType
Type of the record being labelled, for example 'Asset' or 'Article'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LabelTypeId
ID of the label type to apply.
See Get-HuduLabelType.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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

### Boyles.PowerShell.Hudu.Models.HuduLabel
## NOTES

## RELATED LINKS
