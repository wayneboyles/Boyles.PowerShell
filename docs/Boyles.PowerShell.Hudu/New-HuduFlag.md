---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# New-HuduFlag

## SYNOPSIS
Creates a new flag on a record in the connected Hudu instance.

## SYNTAX

```
New-HuduFlag [[-FlagTypeId] <Int32>] [[-Description] <String>] [[-FlagableType] <String>]
 [[-FlagableId] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Attaches a flag of the given flag type to a record via the connected HuduClient (see
Connect-Hudu).
Hudu requires -FlagTypeId, -FlagableType, and -FlagableId, and the flagged
record must exist.
Only the parameters actually supplied are sent in the request body.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
New-HuduFlag -FlagTypeId 1 -FlagableType 'Asset' -FlagableId 345 -Description 'Needs a firmware update'
```

Flags asset 345 with flag type 1.

### EXAMPLE 2
```
$type = Get-HuduFlagType -Name 'Critical Issue'
New-HuduFlag -FlagTypeId $type.Id -FlagableType 'Company' -FlagableId 5
```

Flags company 5 with the 'Critical Issue' flag type.

## PARAMETERS

### -Description
Optional description for the flag.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FlagableId
ID of the record being flagged.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FlagableType
Type of record being flagged: 'Asset', 'Website', 'Article', 'AssetPassword', 'Company',
'Procedure', 'RackStorage', 'Network', 'IpAddress', 'Vlan', or 'VlanZone'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FlagTypeId
ID of the flag type to apply (see Get-HuduFlagType).

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

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

### Boyles.PowerShell.Hudu.Models.HuduFlag
## NOTES

## RELATED LINKS
