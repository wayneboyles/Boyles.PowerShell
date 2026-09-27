---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Write-Step

## SYNOPSIS
Writes a labeled progress line to the console.

## SYNTAX

```
Write-Step [-Message] <String> [-Prefix <String>] [-Color <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Writes the message prefixed with "\[\<Prefix\>\]" in the given console color.
Intended for
reporting the start of a script step, with a customizable prefix label.

## EXAMPLES

### EXAMPLE 1
```
Write-Step 'Fetching companies from Hudu'
```

Writes "\[TASK\] Fetching companies from Hudu" in cyan.

### EXAMPLE 2
```
Write-Step 'Uploading results' -Prefix 'STEP' -Color White
```

Writes "\[STEP\] Uploading results" in white.

## PARAMETERS

### -Color
Console foreground color to write in.
Defaults to 'Cyan'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Cyan
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

### -Prefix
Label shown in brackets before the message.
Defaults to 'TASK'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: TASK
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
