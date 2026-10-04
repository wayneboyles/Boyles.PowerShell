---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Set-HuduLabelType

## SYNOPSIS
Updates an existing label type in the connected Hudu instance.

## SYNTAX

```
Set-HuduLabelType [-Id] <Int32> [[-Name] <String>] [[-Color] <String>] [[-AccessLevel] <String>]
 [[-ApplicableRecordTypes] <Int32[]>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates the label type with the given ID via the connected HuduClient (see Connect-Hudu).
Only
the parameters actually supplied are sent in the request body, so omitted properties are left
unchanged.
Returns $null instead of throwing when the ID doesn't exist, since Hudu responds
with an HTTP 404 in that case.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
Set-HuduLabelType -Id 3 -Name 'High Priority'
```

Renames the label type with ID 3, leaving its other properties unchanged.

### EXAMPLE 2
```
Get-HuduLabelType -Name 'Critical' | Set-HuduLabelType -Color 'Orange'
```

Changes the 'Critical' label type to orange.

## PARAMETERS

### -AccessLevel
New access level controlling who can apply and see labels of this type.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ApplicableRecordTypes
IDs of the record types this label type can be applied to.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Color
New color for the label type.

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

### -Id
ID of the label type to update.
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
New name for the label type.

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

### Boyles.PowerShell.Hudu.Models.HuduLabelType
## NOTES

## RELATED LINKS
