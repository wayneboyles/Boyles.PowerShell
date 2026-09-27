---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Get-BPSSetting

## SYNOPSIS
Retrieves one or more Boyles.PowerShell settings.

## SYNTAX

```
Get-BPSSetting [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Reads settings from the shared \[Boyles.PowerShell.Settings.SettingsStore\]::Instance singleton -
the same store every Boyles.PowerShell.Core-based HTTP client reads from at runtime.
Settings
are persisted to disk (see Get-BPSSettingPath), so a value set in one session is still there
the next time PowerShell starts.

## EXAMPLES

### EXAMPLE 1
```
Get-BPSSetting -Name DebugEnabled
```

Returns the current value of the DebugEnabled setting, or $null if it has never been set.

### EXAMPLE 2
```
'DebugEnabled', 'MyCustomSetting' | Get-BPSSetting
```

Retrieves several named settings via the pipeline.

### EXAMPLE 3
```
Get-BPSSetting
```

Returns every setting currently stored, as a single object with one property per setting.

## PARAMETERS

### -Name
Name of the setting to retrieve.
Case-insensitive.
Accepts pipeline input, by value or by
property name.
Omit to return every stored setting.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
