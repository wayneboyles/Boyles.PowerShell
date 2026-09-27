---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduGroup

## SYNOPSIS
Retrieves one or more user groups from the connected Hudu instance.

## SYNTAX

### All (Default)
```
Get-HuduGroup [-Name <String>] [-Default <Boolean>] [-Search <String>]
 [<CommonParameters>]
```

### Single
```
Get-HuduGroup -Id <Int32> [<CommonParameters>]
```

## DESCRIPTION
With -Id, retrieves a single group by ID, returning $null instead of throwing if the ID
doesn't exist (Hudu responds with an HTTP 404 in that case).
Without -Id, retrieves every
group matching the supplied filters, across all pages.
Group member lists exclude admins and
super admins.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduGroup
```

Returns every group.

### EXAMPLE 2
```
Get-HuduGroup -Name 'Technicians' | Select-Object -ExpandProperty Members
```

Lists the members of the 'Technicians' group.

## PARAMETERS

### -Default
Filters results to the default group for new users ($true) or other groups ($false).

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
ID of a single group to retrieve.

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
Filters results to groups with the given name (case-insensitive).

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

### -Search
Filters results to groups whose names match the given search text.

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

### Boyles.PowerShell.Hudu.Models.HuduGroup
### Boyles.PowerShell.Hudu.Models.HuduGroup[]
## NOTES

## RELATED LINKS
