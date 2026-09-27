---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Test-RequiredValue

## SYNOPSIS
Returns a required value, prompting for it interactively if it wasn't supplied.

## SYNTAX

```
Test-RequiredValue [-Name] <String> [[-Value] <Object>] [-Secret]
 [<CommonParameters>]
```

## DESCRIPTION
If Value is already populated, it is returned unchanged.
Otherwise, in an interactive session,
the user is prompted via Read-Host (masked, as a SecureString, when -Secret is specified) and
the entered value is returned.
In a non-interactive session (no interactive host, or
-NonInteractive was passed on the command line), throws instead of prompting, since there is
no one to answer.

## EXAMPLES

### EXAMPLE 1
```
$apiKey = Test-RequiredValue -Name 'ApiKey' -Value $ApiKey -Secret
```

Returns $ApiKey if it was already provided; otherwise prompts for it with masked input.

### EXAMPLE 2
```
$baseUri = Test-RequiredValue -Name 'BaseUri' -Value $BaseUri
```

Returns $BaseUri if already provided; otherwise prompts for it with visible input, or throws
if running non-interactively.

## PARAMETERS

### -Name
Name of the value, used in the prompt text and in the error thrown when it can't be prompted
for.

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

### -Secret
Prompts with masked input (a SecureString, converted back to plain text) instead of visible
text.

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

### -Value
The value as already supplied by the caller, if any.
When non-empty (not null, empty, or
whitespace), it is returned as-is without prompting.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
