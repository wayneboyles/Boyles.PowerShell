---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduFlag

## SYNOPSIS
Retrieves one or more flags from the connected Hudu instance.

## SYNTAX

### All (Default)
```
Get-HuduFlag [-FlagTypeId <Int32>] [-FlagableId <Int32>] [-Description <String>]
 [<CommonParameters>]
```

### Single
```
Get-HuduFlag [-Id] <Int32> [<CommonParameters>]
```

## DESCRIPTION
With -Id, retrieves a single flag by ID, returning $null instead of throwing if the ID
doesn't exist (Hudu responds with an HTTP 404 in that case).
Without -Id, retrieves every
flag matching the supplied filters, across all pages.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduFlag -Id 17
```

Returns the flag with ID 17, or $null if it doesn't exist.

### EXAMPLE 2
```
Get-HuduFlagType -Name 'Critical Issue' | ForEach-Object { Get-HuduFlag -FlagTypeId $_.Id }
```

Returns every flag of the 'Critical Issue' flag type.

## PARAMETERS

### -Description
Filters results to flags with the given description.

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

### -FlagableId
Filters results to flags attached to the record with the given ID.

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

### -FlagTypeId
Filters results to flags of the given flag type ID.

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
ID of a single flag to retrieve.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Boyles.PowerShell.Hudu.Models.HuduFlag
### Boyles.PowerShell.Hudu.Models.HuduFlag[]
## NOTES

## RELATED LINKS
