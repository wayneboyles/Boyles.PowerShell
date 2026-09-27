---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Get-BPSClientKey

## SYNOPSIS
Lists the keys of every client currently registered in the process-wide Boyles client store.

## SYNTAX

```
Get-BPSClientKey [<CommonParameters>]
```

## DESCRIPTION
Wraps \[Boyles.PowerShell.Context.ContextCache\]::Keys.
Returns a snapshot of the keys at the
time of the call; returns nothing if no clients are registered.

## EXAMPLES

### EXAMPLE 1
```
Get-BPSClientKey
```

Lists every registered key, e.g.
'hudu' after Connect-Hudu has been run.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES

## RELATED LINKS
