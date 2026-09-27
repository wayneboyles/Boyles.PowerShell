---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Write-Done

## SYNOPSIS
Writes a "done" status line to the console.

## SYNTAX

```
Write-Done [-Message] <String> [-Color <String>] [<CommonParameters>]
```

## DESCRIPTION
Writes the message prefixed with "\[OK  \]" in the given console color.
Intended as the
success-case counterpart to Write-Err/Write-Skip/Write-Step when reporting the outcome of a
script step.

## EXAMPLES

### EXAMPLE 1
```
Write-Done 'Company synced'
```

Writes "\[OK  \] Company synced" in green.

## PARAMETERS

### -Color
Console foreground color to write in.
Defaults to 'Green'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Green
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
