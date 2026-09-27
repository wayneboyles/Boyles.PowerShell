---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduAssetLayoutFields

## SYNOPSIS
Retrieves the field definitions of a Hudu asset layout.

## SYNTAX

```
Get-HuduAssetLayoutFields [-AssetLayoutId] <Int32> [<CommonParameters>]
```

## DESCRIPTION
Looks up the asset layout with the given ID via Get-HuduAssetLayout and returns just its
Fields property.
Returns $null if the asset layout doesn't exist.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduAssetLayoutFields -AssetLayoutId 42
```

Returns the field definitions for asset layout 42.

### EXAMPLE 2
```
Get-HuduAssetLayout -Name 'Servers' | Get-HuduAssetLayoutFields | Select-Object Label, FieldType, Required
```

Lists the label, type, and required flag of every field on the 'Servers' asset layout.

## PARAMETERS

### -AssetLayoutId
ID of the asset layout whose fields should be retrieved.
Accepts pipeline input by property
name.
Aliased as Id, so HuduAssetLayout objects can be piped in directly.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Boyles.PowerShell.Hudu.Models.HuduAssetLayoutField
## NOTES

## RELATED LINKS
