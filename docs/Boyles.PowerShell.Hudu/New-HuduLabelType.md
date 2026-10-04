---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# New-HuduLabelType

## SYNOPSIS
Creates a new label type in the connected Hudu instance.

## SYNTAX

```
New-HuduLabelType [-Name] <String> [-Color <String>] [-AccessLevel <String>] [-ApplicableRecordTypes <Int32[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a label type via the connected HuduClient (see Connect-Hudu).
Only the parameters
actually supplied are sent in the request body.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
New-HuduLabelType -Name 'Critical'
```

Creates a red label type named 'Critical'.

### EXAMPLE 2
```
New-HuduLabelType -Name 'Reviewed' -Color 'Light Green'
```

Creates a light green label type named 'Reviewed'.

### EXAMPLE 3
```
New-HuduLabelType -Name 'Pending' -Color 'Yellow' -WhatIf
```

Shows what would happen without creating the label type.

## PARAMETERS

### -AccessLevel
Access level controlling who can apply and see labels of this type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplicableRecordTypes
IDs of the record types this label type can be applied to.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Color
Color of the label type.
Defaults to 'Red'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Red
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the label type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

### Boyles.PowerShell.Hudu.Models.HuduLabelType
## NOTES

## RELATED LINKS
