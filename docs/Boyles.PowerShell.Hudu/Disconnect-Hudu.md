---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Disconnect-Hudu

## SYNOPSIS
Disconnects from Hudu, removing the registered client from the process-wide client store.

## SYNTAX

```
Disconnect-Hudu [<CommonParameters>]
```

## DESCRIPTION
Removes and disposes the HuduClient registered by Connect-Hudu (see Remove-BPSClient).
Does
nothing, without throwing, if Hudu is not currently connected.

## EXAMPLES

### EXAMPLE 1
```
Disconnect-Hudu
```

Disconnects from Hudu, releasing the underlying HTTP client's resources.

### EXAMPLE 2
```
Disconnect-Hudu -Verbose
```

Disconnects and reports whether a connection was actually removed.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### None
## NOTES

## RELATED LINKS
