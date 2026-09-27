---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Remove-HuduAsset

## SYNOPSIS
Deletes an asset from the connected Hudu instance.

## SYNTAX

```
Remove-HuduAsset [-Id] <Int32> [-CompanyId] <Int32> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Deletes the asset with the given ID, within the given company, via the connected HuduClient
(see Connect-Hudu).
Returns $null instead of throwing when the ID doesn't exist, since Hudu
responds with an HTTP 404 in that case.
Supports -WhatIf/-Confirm, with a 'High' confirm
impact since deletion is irreversible.

## EXAMPLES

### EXAMPLE 1
```
Remove-HuduAsset -Id 123 -CompanyId 5
```

Deletes the asset with ID 123 belonging to company 5, after confirmation.

### EXAMPLE 2
```
Remove-HuduAsset -Id 123 -CompanyId 5 -WhatIf
```

Shows what would be deleted without changing anything.

## PARAMETERS

### -CompanyId
ID of the company the asset belongs to.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of the asset to delete.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
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

### None
## NOTES

## RELATED LINKS
