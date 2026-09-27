---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Set-BPSSetting

## SYNOPSIS
Sets a Boyles.PowerShell setting.

## SYNTAX

```
Set-BPSSetting [-Name] <String> [-Value] <Object> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Writes a value into the shared SettingsStore and persists it to disk immediately, so every
module and HTTP client built on Boyles.PowerShell.Core picks up the new value on its next read
- no restart required, since they all read through the same in-process singleton.
Because this
changes persisted state, it supports -WhatIf and -Confirm.

Any setting name can be stored.
DebugEnabled is currently the only setting the built-in
clients read.

## EXAMPLES

### EXAMPLE 1
```
Set-BPSSetting -Name DebugEnabled -Value $true
```

Turns on debug output for every Boyles.PowerShell client, in this session and future ones.

### EXAMPLE 2
```
Set-BPSSetting DebugEnabled $false -WhatIf
```

Shows what would change without actually writing the setting.

## PARAMETERS

### -Name
Name of the setting to set, e.g.
DebugEnabled.
Case-insensitive.

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

### -Value
Value to store.
Any JSON-serializable value is supported (bool, string, int, etc.).

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

### None
## NOTES

## RELATED LINKS
