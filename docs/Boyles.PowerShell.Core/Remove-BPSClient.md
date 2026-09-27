---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Remove-BPSClient

## SYNOPSIS
Removes a client from the process-wide Boyles client store.

## SYNTAX

```
Remove-BPSClient [-Key] <String> [<CommonParameters>]
```

## DESCRIPTION
Wraps \[Boyles.PowerShell.Context.ContextCache\]::Remove().
If the removed client
implements IDisposable it is disposed, releasing its underlying HttpClient/socket resources.
Does nothing, without throwing, if no client is registered under the given key.

## EXAMPLES

### EXAMPLE 1
```
Remove-BPSClient -Key 'hudu'
```

Removes and disposes the client Connect-Hudu registered.
Disconnect-Hudu does this for you.

### EXAMPLE 2
```
Get-BPSClientKey | ForEach-Object { Remove-BPSClient -Key $_ }
```

Removes every registered client.

## PARAMETERS

### -Key
The key the client was registered under.
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

### None
## NOTES

## RELATED LINKS
