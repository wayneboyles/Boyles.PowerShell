---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Reset-BPSSetting

## SYNOPSIS
Clears every Boyles.PowerShell setting, reverting the entire store to its built-in defaults.

## SYNTAX

```
Reset-BPSSetting [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Wipes the shared SettingsStore and persists the now-empty state to disk.
This affects every
setting for every Boyles.PowerShell module that reads from the store, not just one - use
Remove-BPSSetting instead when only a single setting needs to be reverted.
Has a 'High'
confirm impact, so it prompts for confirmation by default.

## EXAMPLES

### EXAMPLE 1
```
Reset-BPSSetting
```

Prompts for confirmation, then clears every stored setting.

### EXAMPLE 2
```
Reset-BPSSetting -Confirm:$false
```

Clears every stored setting without prompting, e.g.
from a non-interactive script.

## PARAMETERS

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
