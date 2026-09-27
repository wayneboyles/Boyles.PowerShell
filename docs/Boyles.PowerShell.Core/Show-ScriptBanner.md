---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Show-ScriptBanner

## SYNOPSIS
Writes a boxed banner to the console showing a script's name, version, and description.

## SYNTAX

```
Show-ScriptBanner [-ScriptVersion] <String> [-ScriptDescription] <String> [-Color <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Draws a bordered box using the running script's own file name (via $PSCommandPath), the
supplied version, a word-wrapped description, and a fixed author line, framed with a fixed 58-character inner
width.
Intended to be called once near the top of a top-level script to give interactive runs
a clear, consistent banner.

## EXAMPLES

### EXAMPLE 1
```
Show-ScriptBanner -ScriptVersion '1.0.0' -ScriptDescription 'Syncs Hudu assets from source of truth.'
```

Prints a bordered banner using the calling script's file name, the given version, and
description in the default yellow color.

### EXAMPLE 2
```
Show-ScriptBanner -ScriptVersion '2.3.1' -ScriptDescription 'Nightly cleanup job.' -Color Cyan
```

Prints the same banner in cyan instead of the default yellow.

## PARAMETERS

### -Color
Console foreground color the banner is drawn in.
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

### -ScriptDescription
Short description of what the script does.
Word-wrapped to fit inside the banner.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptVersion
Version string to display under the script name, e.g.
'1.2.0'.

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
