---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Set-HuduArticle

## SYNOPSIS
Updates an existing article in the connected Hudu instance.

## SYNTAX

```
Set-HuduArticle [-Id] <Int32> [[-Name] <String>] [[-Content] <String>] [[-EnableSharing] <Boolean>]
 [[-FolderId] <Int32>] [[-CompanyId] <Int32>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates the article with the given ID via the connected HuduClient (see Connect-Hudu).
Only
the parameters actually supplied are sent in the request body, so omitted properties are left
unchanged.
Returns $null instead of throwing when the ID doesn't exist, since Hudu responds
with an HTTP 404 in that case.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
Set-HuduArticle -Id 123 -Name 'Updated Password Policy'
```

Renames the article with ID 123, leaving its other properties unchanged.

### EXAMPLE 2
```
Get-HuduArticle -CompanyId 5 | Set-HuduArticle -EnableSharing $false
```

Turns off public sharing on every article belonging to company 5.

## PARAMETERS

### -CompanyId
ID of the company to associate the article with.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Content
New body content for the article, as HTML.

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

### -EnableSharing
Whether the article should have a public URL that non-authenticated users can view.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -FolderId
ID of the folder to move the article into.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of the article to update.
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
New name/title for the article.

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

### Boyles.PowerShell.Hudu.Models.HuduArticle
## NOTES

## RELATED LINKS
