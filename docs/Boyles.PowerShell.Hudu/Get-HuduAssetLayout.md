---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduAssetLayout

## SYNOPSIS
Retrieves one or more asset layouts from the connected Hudu instance.

## SYNTAX

### All (Default)
```
Get-HuduAssetLayout [-Name <String>] [-Slug <String>] [-Active <Boolean>]
 [<CommonParameters>]
```

### Single
```
Get-HuduAssetLayout -Id <Int32> [<CommonParameters>]
```

## DESCRIPTION
With -Id, retrieves a single asset layout by ID, returning $null instead of throwing if the
ID doesn't exist (Hudu responds with an HTTP 404 in that case).
Without -Id, retrieves every
asset layout matching the supplied filters, across all pages.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduAssetLayout -Id 42
```

Returns the asset layout with ID 42, or $null if it doesn't exist.

### EXAMPLE 2
```
Get-HuduAssetLayout -Active $true
```

Returns every active asset layout.

### EXAMPLE 3
```
Get-HuduAssetLayout -Name 'Servers'
```

Returns the asset layout named 'Servers'.

## PARAMETERS

### -Active
Filters results to active ($true) or inactive ($false) asset layouts.

```yaml
Type: Boolean
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of a single asset layout to retrieve.

```yaml
Type: Int32
Parameter Sets: Single
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Filters results to asset layouts matching the given name.
Supports tab completion of
existing asset layout names once Connect-Hudu has been run.

```yaml
Type: String
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Slug
Filters results to asset layouts matching the given URL slug.

```yaml
Type: String
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Boyles.PowerShell.Hudu.Models.HuduAssetLayout
### Boyles.PowerShell.Hudu.Models.HuduAssetLayout[]
## NOTES

## RELATED LINKS
