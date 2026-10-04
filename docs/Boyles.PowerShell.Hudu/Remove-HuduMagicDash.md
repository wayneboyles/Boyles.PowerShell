---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Remove-HuduMagicDash

## SYNOPSIS
Removes a Magic Dash item from the connected Hudu instance.

## SYNTAX

### ById (Default)
```
Remove-HuduMagicDash -Id <Int32> [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ByTitle
```
Remove-HuduMagicDash -Title <String> -CompanyName <String> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Deletes a Magic Dash item either by ID, or by the combination of title and company name.
Returns $null instead of throwing when the item doesn't exist, since Hudu responds with an
HTTP 404 in that case.
Supports -WhatIf/-Confirm, with a 'High' confirm impact since deletion
is irreversible.

## EXAMPLES

### EXAMPLE 1
```
Remove-HuduMagicDash -Id 42
```

Deletes the Magic Dash item with ID 42, after confirmation.

### EXAMPLE 2
```
Remove-HuduMagicDash -Title 'Backup Status' -CompanyName 'Acme'
```

Deletes Acme's 'Backup Status' Magic Dash item, after confirmation.

### EXAMPLE 3
```
Get-HuduMagicDash -CompanyId 5 | Remove-HuduMagicDash -Confirm:$false
```

Deletes every Magic Dash item for company 5 without prompting.

## PARAMETERS

### -CompanyName
Name of the company the Magic Dash item belongs to.
Must be used with -Title.

```yaml
Type: String
Parameter Sets: ByTitle
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of the Magic Dash item to delete.
Accepts pipeline input by property name.
Cannot be
combined with -Title and -CompanyName.

```yaml
Type: Int32
Parameter Sets: ById
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Title
Title of the Magic Dash item to delete.
Must be used with -CompanyName.

```yaml
Type: String
Parameter Sets: ByTitle
Aliases:

Required: True
Position: Named
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

### None
## NOTES

## RELATED LINKS
