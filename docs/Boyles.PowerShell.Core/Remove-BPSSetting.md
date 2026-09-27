---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Remove-BPSSetting

## SYNOPSIS
Removes a single Boyles.PowerShell setting, reverting it to its built-in default.

## SYNTAX

```
Remove-BPSSetting [-Name] <String> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Deletes the named entry from the shared SettingsStore and persists the change.
Once
removed, Get-BPSSetting for that name returns $null until it is set again, and any typed
convenience property (such as DebugEnabled) falls back to its coded default.
Does nothing if
the setting isn't stored.
Supports -WhatIf and -Confirm.

## EXAMPLES

### EXAMPLE 1
```
Remove-BPSSetting -Name DebugEnabled
```

Clears the DebugEnabled override, reverting to the built-in default of $false.

### EXAMPLE 2
```
'DebugEnabled', 'MyCustomSetting' | Remove-BPSSetting -WhatIf
```

Shows which settings would be removed without changing anything.

## PARAMETERS

### -Name
Name of the setting to remove.
Case-insensitive.
Accepts pipeline input, by value or by
property name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
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

### None
## NOTES

## RELATED LINKS
