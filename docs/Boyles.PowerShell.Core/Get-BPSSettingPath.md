---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Get-BPSSettingPath

## SYNOPSIS
Returns the path of the file the Boyles.PowerShell settings store persists to.

## SYNTAX

```
Get-BPSSettingPath [<CommonParameters>]
```

## DESCRIPTION
Useful for troubleshooting - e.g.
confirming which settings.json a given machine or user
profile is actually reading from and writing to, or attaching it to a support ticket.

## EXAMPLES

### EXAMPLE 1
```
Get-BPSSettingPath
```

C:\Users\wayne\AppData\Roaming\Boyles.PowerShell\settings.json

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.String
## NOTES

## RELATED LINKS
