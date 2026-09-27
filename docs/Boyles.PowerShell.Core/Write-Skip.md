---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Write-Skip

## SYNOPSIS
Writes a "skipped" status line to the console.

## SYNTAX

```
Write-Skip [-Message] <String> [-Color <String>] [<CommonParameters>]
```

## DESCRIPTION
Writes the message prefixed with "\[SKIP\]" in the given console color.
Intended for reporting
a script step that was intentionally skipped.

## EXAMPLES

### EXAMPLE 1
```
Write-Skip 'Company already exists, skipping create'
```

Writes "\[SKIP\] Company already exists, skipping create" in dark gray.

## PARAMETERS

### -Color
Console foreground color to write in.
Defaults to 'DarkGray'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: DarkGray
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
The message to write.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None
## NOTES

## RELATED LINKS
