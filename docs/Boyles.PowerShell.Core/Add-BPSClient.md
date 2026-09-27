---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Add-BPSClient

## SYNOPSIS
Registers a connected service client in the process-wide Boyles client store.

## SYNTAX

```
Add-BPSClient [-Key] <String> [-Client] <Object> [<CommonParameters>]
```

## DESCRIPTION
Wraps \[Boyles.PowerShell.Context.ContextCache\]::Set().
A service module's own Connect-*
cmdlet (see Connect-Hudu.ps1) calls this after building a client, so every other cmdlet in
that module can look the client back up by key via Get-BPSClient instead of requiring the
client to be passed to every call explicitly.

## EXAMPLES

### EXAMPLE 1
```
Add-BPSClient -Key 'hudu' -Client $huduClient
```

Stores $huduClient under the 'hudu' key so it can be retrieved later with
Get-BPSClient -Key 'hudu'.

### EXAMPLE 2
```
$client = [Boyles.PowerShell.Hudu.Services.HuduClient]::Create($baseUrl, $apiKey)
Add-BPSClient 'Hudu-Prod' $client
```

Builds a HuduClient and registers it under a custom key using positional parameters.

## PARAMETERS

### -Client
The client instance to store, e.g.
a HuduClient.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Key
Unique, case-insensitive name to register the client under (e.g.
'hudu', 'Hudu-Prod').
Registering a second client under a key that is already in use replaces - and disposes, if
the previous client implements IDisposable - the one already there.

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
