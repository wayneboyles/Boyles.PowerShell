---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Write-Err

## SYNOPSIS
Writes an error status line to the console, optionally terminating the script.

## SYNTAX

```
Write-Err [-Message] <String> [-ExitCode <Int32>] [-Terminate]
 [<CommonParameters>]
```

## DESCRIPTION
Writes the message prefixed with "\[ERR \]" in red.
When -Terminate is specified, exits the
process afterward with the given exit code instead of letting execution continue.

## EXAMPLES

### EXAMPLE 1
```
Write-Err 'Failed to reach the Hudu API'
```

Writes "\[ERR \] Failed to reach the Hudu API" in red and continues execution.

### EXAMPLE 2
```
Write-Err 'Missing required setting' -Terminate -ExitCode 2
```

Writes the message, then exits the process with code 2.

## PARAMETERS

### -ExitCode
Exit code to use when -Terminate is specified.
Defaults to 1.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
The error message to write.

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

### -Terminate
Exits the process with ExitCode after writing the message.

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
