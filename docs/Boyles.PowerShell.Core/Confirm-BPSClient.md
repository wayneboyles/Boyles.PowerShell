---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Confirm-BPSClient

## SYNOPSIS
Throws if a client is not currently registered under the given key.

## SYNTAX

```
Confirm-BPSClient [-Key] <String> [-ServiceName] <String>
 [<CommonParameters>]
```

## DESCRIPTION
Wraps Test-BPSClient with a clearer, service-specific error message than the exception
Get-BPSClient throws on a missing key.
Intended to be called at the top of a service module's
cmdlets (or a shared helper such as Get-HuduClientInternal) to fail fast with actionable
guidance when the user hasn't connected yet.
Returns nothing when the client is registered.

## EXAMPLES

### EXAMPLE 1
```
Confirm-BPSClient -Key 'hudu' -ServiceName 'Hudu'
```

Throws "Hudu is not connected! 
Run Connect-Hudu to connect to the API." if no client is
registered under the 'hudu' key; otherwise does nothing.

### EXAMPLE 2
```
Confirm-BPSClient 'hudu' 'Hudu'
$client = Get-BPSClient -Key 'hudu'
```

Guards a Get-BPSClient call so the user sees the friendlier "not connected" message instead
of a KeyNotFoundException.

## PARAMETERS

### -Key
The key the client should be registered under.
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

### -ServiceName
Name of the service, used to build the error message (e.g.
"Run Connect-\<ServiceName\>").

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None
## NOTES

## RELATED LINKS
