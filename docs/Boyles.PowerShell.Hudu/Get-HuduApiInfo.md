---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduApiInfo

## SYNOPSIS
Retrieves version and status information about the connected Hudu instance.

## SYNTAX

```
Get-HuduApiInfo [<CommonParameters>]
```

## DESCRIPTION
Calls the Hudu API's info endpoint via the connected HuduClient (see Connect-Hudu) and
returns it as a HuduApiInfo object.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduApiInfo
```

Returns version and status details for the currently connected Hudu instance.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Boyles.PowerShell.Hudu.Models.HuduApiInfo
## NOTES

## RELATED LINKS
