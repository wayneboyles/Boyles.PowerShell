---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Test-BPSClient

## SYNOPSIS
Tests whether a client is currently registered under the given key.

## SYNTAX

```
Test-BPSClient [-Key] <String> [<CommonParameters>]
```

## DESCRIPTION
Wraps \[Boyles.PowerShell.Context.ContextCache\]::Contains().
Useful for guarding a
service module's cmdlets with a clearer error than the KeyNotFoundException Get-BPSClient
throws, or for skipping a redundant Connect-* call.

## EXAMPLES

### EXAMPLE 1
```
Test-BPSClient -Key 'hudu'
```

Returns $true if Connect-Hudu has been run in this session, otherwise $false.

### EXAMPLE 2
```
if (-not (Test-BPSClient -Key 'hudu')) {
    Connect-Hudu -BaseUrl $baseUrl -ApiKey $apiKey
}
```

Connects to Hudu only if a client isn't already registered.

## PARAMETERS

### -Key
The key to check.
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Boolean
## NOTES

## RELATED LINKS
