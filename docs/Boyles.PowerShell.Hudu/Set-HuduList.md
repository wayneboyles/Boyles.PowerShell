---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Set-HuduList

## SYNOPSIS
Updates an existing list in the connected Hudu instance.

## SYNTAX

```
Set-HuduList [-Id] <Int32> [[-Name] <String>] [[-Fields] <HuduListItem[]>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the list with the given ID via the connected HuduClient (see Connect-Hudu).
Only the
parameters actually supplied are sent, so omitted properties are left unchanged.
Returns $null
instead of throwing when the ID doesn't exist, since Hudu responds with an HTTP 404 in that
case.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
Set-HuduList -Id 7 -Name 'Branch Offices'
```

Renames the list with ID 7, leaving its items unchanged.

### EXAMPLE 2
```
Get-HuduList -Name 'Office Locations' | Set-HuduList -Fields $items
```

Updates the items of the 'Office Locations' list with the HuduListItem objects in $items.

## PARAMETERS

### -Fields
The items for the list, as HuduListItem objects.

```yaml
Type: HuduListItem[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of the list to update.
Accepts pipeline input by property name.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
New name for the list.

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

### Boyles.PowerShell.Hudu.Models.HuduList
## NOTES

## RELATED LINKS
