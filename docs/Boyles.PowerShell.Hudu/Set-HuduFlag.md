---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Set-HuduFlag

## SYNOPSIS
Updates an existing flag in the connected Hudu instance.

## SYNTAX

```
Set-HuduFlag [-Id] <Int32> [[-FlagTypeId] <Int32>] [[-Description] <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the flag with the given ID via the connected HuduClient (see Connect-Hudu).
Only the
parameters actually supplied are sent in the request body, so omitted properties are left
unchanged.
Returns $null instead of throwing when the ID doesn't exist, since Hudu responds
with an HTTP 404 in that case.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
Set-HuduFlag -Id 17 -Description 'Firmware updated, pending reboot'
```

Updates the description of flag 17.

### EXAMPLE 2
```
Get-HuduFlag -FlagTypeId 1 | Set-HuduFlag -FlagTypeId 2
```

Moves every flag of flag type 1 to flag type 2.

## PARAMETERS

### -Description
New description for the flag.

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

### -FlagTypeId
New flag type ID for the flag.

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

### -Id
ID of the flag to update.
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

### Boyles.PowerShell.Hudu.Models.HuduFlag
## NOTES

## RELATED LINKS
