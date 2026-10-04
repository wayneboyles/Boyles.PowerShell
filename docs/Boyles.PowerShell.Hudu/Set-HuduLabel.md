---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Set-HuduLabel

## SYNOPSIS
Updates an existing label in the connected Hudu instance.

## SYNTAX

```
Set-HuduLabel [-Id] <Int32> [[-LabelableId] <Int32>] [[-LabelableType] <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the label with the given ID via the connected HuduClient (see Connect-Hudu).
Only
the parameters actually supplied are sent in the request body, so omitted properties are left
unchanged.
Returns $null instead of throwing when the ID doesn't exist, since Hudu responds
with an HTTP 404 in that case.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
Set-HuduLabel -Id 12 -LabelableId 789 -LabelableType 'Asset'
```

Moves label 12 onto the asset with ID 789.

### EXAMPLE 2
```
Get-HuduLabel -LabelableId 456 | Set-HuduLabel -LabelableId 789
```

Moves every label on record 456 onto record 789.

## PARAMETERS

### -Id
ID of the label to update.
Accepts pipeline input by property name.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LabelableId
ID of the record the label should be applied to.

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
Type of the record the label is applied to, for example 'Asset' or 'Article'.

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
