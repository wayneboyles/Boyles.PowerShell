---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# New-HuduMagicDash

## SYNOPSIS
Creates or updates a Magic Dash item in the connected Hudu instance.

## SYNTAX

```
New-HuduMagicDash [-Title] <String> [-Message] <String> [-CompanyName] <String> [[-Icon] <String>]
 [[-ImageUrl] <String>] [[-ContentLink] <String>] [[-Content] <String>] [[-Shade] <String>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sends a Magic Dash item to the connected HuduClient (see Connect-Hudu).
Hudu identifies an
item by its title and company name, so submitting an existing combination updates that item.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
New-HuduMagicDash -Title 'Backup Status' -Message 'Last backup OK' -CompanyName 'Acme'
```

Creates a Magic Dash item for Acme.

### EXAMPLE 2
```
New-HuduMagicDash -Title 'Backup Status' -Message 'Backup failed' -CompanyName 'Acme' -Shade 'danger' -ContentLink 'https://backup.example.com'
```

Creates a red Magic Dash item for Acme that links to the backup console.

## PARAMETERS

### -CompanyName
Name of the company the item belongs to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Content
HTML content displayed when the item is opened.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContentLink
URL the item links to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Icon
Icon displayed on the item, for example a Font Awesome icon name.

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

### -ImageUrl
URL of an image to display on the item.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Message
Short message displayed on the item.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Shade
Shade (color) of the item, for example 'success', 'warning' or 'danger'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
Title of the Magic Dash item.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

### Boyles.PowerShell.Hudu.Models.HuduMagicDash
## NOTES

## RELATED LINKS
