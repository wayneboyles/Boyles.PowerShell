---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduCard

## SYNOPSIS
Looks up the Hudu integration card for a record in an external integration.

## SYNTAX

### ById (Default)
```
Get-HuduCard -IntegrationSlug <String> -IntegrationId <Int32>
 [<CommonParameters>]
```

### ByIdentifier
```
Get-HuduCard -IntegrationSlug <String> -IntegrationIdentifier <String>
 [<CommonParameters>]
```

## DESCRIPTION
Calls Hudu's /cards/lookup endpoint via the connected HuduClient (see Connect-Hudu) to find
the integrator card that links a record in an external system (PSA, RMM, Microsoft 365,
etc.) to Hudu.
Identify the external record either by its numeric -IntegrationId or by its
string -IntegrationIdentifier.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduCard -IntegrationSlug 'cw_manage' -IntegrationId 1234
```

Returns the card for ConnectWise Manage record 1234.

### EXAMPLE 2
```
Get-HuduCard -IntegrationSlug 'watchman' -IntegrationIdentifier 'c1a2b3d4'
```

Returns the card for the Watchman Monitoring computer with the given identifier.

## PARAMETERS

### -IntegrationId
Numeric ID of the record in the external integration.
Cannot be combined with
-IntegrationIdentifier.

```yaml
Type: Int32
Parameter Sets: ById
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -IntegrationIdentifier
String identifier of the record in the external integration, for integrations that don't use
numeric IDs.
Cannot be combined with -IntegrationId.

```yaml
Type: String
Parameter Sets: ByIdentifier
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IntegrationSlug
Slug of the external integration, e.g.
'cw_manage', 'autotask', 'halo', or 'syncro'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Boyles.PowerShell.Hudu.Models.HuduCard
## NOTES

## RELATED LINKS
