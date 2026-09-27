---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Write-Header

## SYNOPSIS
Writes a message to the console underlined with a matching-length divider.

## SYNTAX

```
Write-Header [-Message] <String> [-Color <String>] [<CommonParameters>]
```

## DESCRIPTION
Writes the message, then a line of dashes as long as the message itself, both in the given
console color.
Useful for marking the start of a distinct section of script output.

## EXAMPLES

### EXAMPLE 1
```
Write-Header 'Connecting to Hudu'
```

Writes "Connecting to Hudu" followed by a matching dashed underline, in yellow.

## PARAMETERS

### -Color
Console foreground color to write in.
Defaults to 'Yellow'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Yellow
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
The header text to write.

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
