---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Set-HuduExpiration

## SYNOPSIS
Updates an expiration in the connected Hudu instance.

## SYNTAX

```
Set-HuduExpiration [-Id] <Int32> [-Archived <Boolean>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the expiration with the given ID via the connected HuduClient (see Connect-Hudu).
Hudu only allows an expiration's archived status to be changed.
Returns $null instead of
throwing when the ID doesn't exist, since Hudu responds with an HTTP 404 in that case.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
Set-HuduExpiration -Id 88 -Archived $true
```

Archives the expiration with ID 88.

### EXAMPLE 2
```
Get-HuduExpiration -CompanyId 5 -ExpirationType 'warranty' | Set-HuduExpiration -Archived $true
```

Archives every warranty expiration belonging to company 5.

## PARAMETERS

### -Archived
Whether the expiration is archived.
$true archives it; $false restores it.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of the expiration to update.
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

### Boyles.PowerShell.Hudu.Models.HuduExpiration
## NOTES

## RELATED LINKS
