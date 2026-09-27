---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Get-BPSClient

## SYNOPSIS
Retrieves a previously registered client from the process-wide Boyles client store.

## SYNTAX

```
Get-BPSClient [-Key] <String> [<CommonParameters>]
```

## DESCRIPTION
Wraps \[Boyles.PowerShell.Context.ContextCache\]::Get().
Throws a KeyNotFoundException if no
client is registered under the given key - callers should run the service's Connect-* cmdlet
first (see Connect-Hudu.ps1), or guard the call with Test-BPSClient or Confirm-BPSClient.

## EXAMPLES

### EXAMPLE 1
```
$client = Get-BPSClient -Key 'hudu'
```

Returns the client registered under the 'hudu' key (the key Connect-Hudu uses).

### EXAMPLE 2
```
Get-BPSClientKey | ForEach-Object { Get-BPSClient -Key $_ }
```

Returns every registered client.

## PARAMETERS

### -Key
The key the client was registered under via Add-BPSClient.
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

### System.Object
## NOTES

## RELATED LINKS
