---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduNetwork

## SYNOPSIS
Retrieves one or more networks from the connected Hudu instance.

## SYNTAX

### All (Default)
```
Get-HuduNetwork [-CompanyId <Int32>] [-Name <String>] [-Slug <String>] [-NetworkType <Int32>]
 [-Address <String>] [-LocationId <Int32>] [-Archived]
 [<CommonParameters>]
```

### Single
```
Get-HuduNetwork [-Id] <Int32> [<CommonParameters>]
```

## DESCRIPTION
With -Id, retrieves a single network by ID, returning $null instead of throwing if the ID
doesn't exist (Hudu responds with an HTTP 404 in that case).
Without -Id, retrieves every
network matching the supplied filters.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduNetwork -Id 9
```

Returns the network with ID 9, or $null if it doesn't exist.

### EXAMPLE 2
```
Get-HuduNetwork -CompanyId 5
```

Returns every network belonging to company 5.

### EXAMPLE 3
```
Get-HuduNetwork -Address '10.0.0.0/24'
```

Returns the networks matching the given address.

### EXAMPLE 4
```
Get-HuduNetwork -CompanyId 5 -Archived
```

Returns company 5's archived networks.

## PARAMETERS

### -Address
Filters results to networks matching the given address, for example '10.0.0.0/24'.

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

### -Archived
Filters results to archived networks.

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompanyId
Filters results to networks belonging to the given company ID.

```yaml
Type: Int32
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of a single network to retrieve.

```yaml
Type: Int32
Parameter Sets: Single
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -LocationId
Filters results to networks at the given location ID.

```yaml
Type: Int32
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Filters results to networks matching the given name.

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

### -NetworkType
Filters results to networks of the given network type.

```yaml
Type: Int32
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Slug
Filters results to networks matching the given URL slug.

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

### Boyles.PowerShell.Hudu.Models.HuduNetwork
### Boyles.PowerShell.Hudu.Models.HuduNetwork[]
## NOTES

## RELATED LINKS
