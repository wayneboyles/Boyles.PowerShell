---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Connect-Hudu

## SYNOPSIS
Connects to a Hudu instance and registers the resulting client for use by other Hudu cmdlets.

## SYNTAX

```
Connect-Hudu [-BaseUrl] <String> [-ApiKey] <String> [<CommonParameters>]
```

## DESCRIPTION
Builds a HuduClient for the given base URL and API key and registers it in the process-wide
Boyles client store (see Add-BPSClient) under Hudu's well-known cache key ('hudu').
Every
other Boyles.PowerShell.Hudu cmdlet looks the client back up via Get-HuduClientInternal, so
Connect-Hudu only needs to be run once per session.
Running it again replaces (and disposes)
the existing client, which is how you switch instances or keys.

Connect-Hudu does not call the API, so an invalid URL or key only surfaces on the first
request.
Run Get-HuduApiInfo afterwards to verify the connection.

## EXAMPLES

### EXAMPLE 1
```
Connect-Hudu -BaseUrl 'https://myinstance.huducloud.com' -ApiKey $env:HUDU_API_KEY
```

Connects to the given Hudu instance and registers the client for use by other Hudu cmdlets.

### EXAMPLE 2
```
Connect-Hudu 'https://myinstance.huducloud.com' (Get-Secret -Name 'Hudu.ApiKey' -AsPlainText)
Get-HuduApiInfo
```

Connects using an API key from a SecretManagement vault, then verifies the connection.

## PARAMETERS

### -ApiKey
API key used to authenticate requests to the Hudu API.

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

### -BaseUrl
Base URL of the Hudu instance, e.g.
'https://myinstance.huducloud.com'.

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
