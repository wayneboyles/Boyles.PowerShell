---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# New-HuduFlagType

## SYNOPSIS
Creates a new flag type in the connected Hudu instance.

## SYNTAX

```
New-HuduFlagType [-Name] <String> [-Color <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a flag type via the connected HuduClient (see Connect-Hudu).
Hudu requires both a
name and a color.
Only the parameters actually supplied are sent in the request body.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
New-HuduFlagType -Name 'Critical Issue' -Color 'Red'
```

Creates a red flag type named 'Critical Issue'.

### EXAMPLE 2
```
New-HuduFlagType 'Pending Review' -Color 'Yellow' -WhatIf
```

Shows what would be created without changing anything.

## PARAMETERS

### -Color
Color of the new flag type: 'Red', 'Blue', 'Green', 'Yellow', 'Purple', 'Orange',
'Light Pink', 'Light Blue', 'Light Green', 'Light Purple', 'Light Orange', 'Light Yellow', 'White', or 'Grey'.

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
Name of the new flag type.

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

### Boyles.PowerShell.Hudu.Models.HuduFlagType
## NOTES

## RELATED LINKS
