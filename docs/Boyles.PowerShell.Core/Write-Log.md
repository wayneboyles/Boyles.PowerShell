---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Write-Log

## SYNOPSIS
Writes a timestamped log entry to the console and an optional log file.

## SYNTAX

```
Write-Log [-Message] <String> [-Level <String>] [-Section] [-NoConsole]
 [<CommonParameters>]
```

## DESCRIPTION
Reads the log file path from $Global:LogFile set in the calling script; when set, every log
line is also appended there (creating the containing directory if needed).
Use -Section to
write a visual section header to organize log output into readable blocks.

Console output is gated by $Global:LogToConsole: it must be set to $true for console output
to appear at all.
Leaving it unset (the default, $null) or setting it to $false both suppress
console output, same as passing -NoConsole - despite what "if not set" might suggest, an
unset $Global:LogToConsole does NOT default to writing to the console.

If neither $Global:LogFile nor $Global:LogToConsole is set, Write-Log produces no output.

## EXAMPLES

### EXAMPLE 1
```
$Global:LogFile = "C:\Logs\MyScript_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"
$Global:LogToConsole = $true
```

Write-Log 'Script started'
Write-Log 'Phase 1: Connect' -Section
Write-Log 'Connected to server'  -Level SUCCESS
Write-Log 'Retrying in 5s'       -Level WARNING
Write-Log 'Connection refused'   -Level ERROR

Writes each entry to both the console and the log file.

### EXAMPLE 2
```
Write-Log 'Raw response body saved' -Level DEBUG -NoConsole
```

Writes the entry to $Global:LogFile only, even when $Global:LogToConsole is $true.

## PARAMETERS

### -Level
Log severity level: INFO, WARNING, ERROR, DEBUG, or SUCCESS.
Defaults to INFO.
Controls the
console color and the level tag in the line.
Ignored when -Section is specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: INFO
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
The message to log.

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

### -NoConsole
Suppresses console output; writes to the log file only.
Console output is already suppressed
by default unless $Global:LogToConsole has been explicitly set to $true - see DESCRIPTION.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Section
Renders the message as a visual section header with divider lines instead of a timestamped
entry.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
