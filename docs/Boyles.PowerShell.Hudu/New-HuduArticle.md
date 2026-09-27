---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# New-HuduArticle

## SYNOPSIS
Creates a new article in the connected Hudu instance.

## SYNTAX

```
New-HuduArticle [-Name] <String> [-Content <String>] [-EnableSharing <Boolean>] [-FolderId <Int32>]
 [-CompanyId <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates an article via the connected HuduClient (see Connect-Hudu).
Only the parameters
actually supplied are sent in the request body.
Omit -CompanyId to create a global
(non-company) knowledge base article.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
...</p>' -CompanyId 5
```

Creates a new article named 'Password Policy' under company 5.

### EXAMPLE 2
```
New-HuduArticle 'Onboarding Checklist' -Content $html -FolderId 12 -EnableSharing $true
```

Creates a global article in folder 12 with public sharing enabled.

## PARAMETERS

### -CompanyId
ID of the company to associate the article with.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Content
Body content of the article, as HTML.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableSharing
Whether to give the article a public URL that non-authenticated users can view.

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

### -FolderId
ID of the folder to create the article in.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name/title of the new article.

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

### Boyles.PowerShell.Hudu.Models.HuduArticle
## NOTES

## RELATED LINKS
