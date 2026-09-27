---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# New-HuduFolder

## SYNOPSIS
Creates a new folder in the connected Hudu instance.

## SYNTAX

```
New-HuduFolder [-Name] <String> [-Icon <String>] [-Description <String>] [-ParentFolderId <Int32>]
 -CompanyId <Int32> [-FolderType <String>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a folder under the given company via the connected HuduClient (see Connect-Hudu).
Only the parameters actually supplied are sent in the request body.
Supports
-WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
New-HuduFolder -Name 'Network' -CompanyId 5
```

Creates an article folder named 'Network' under company 5.

### EXAMPLE 2
```
New-HuduFolder 'Switches' -CompanyId 5 -ParentFolderId 12 -Icon 'fas fa-network-wired'
```

Creates a 'Switches' subfolder inside folder 12.

## PARAMETERS

### -CompanyId
ID of the company to create the folder under.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Description of the folder.

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

### -FolderType
Type of folder: 'article' or 'photo'.
Hudu defaults to 'article' when omitted.
Cannot be
changed after the folder is created.

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

### -Icon
Font Awesome icon class for the folder, e.g.
'fas fa-folder'.

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

### -Name
Name of the new folder.

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

### -ParentFolderId
ID of the parent folder, to create this folder as a subfolder.

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

### Boyles.PowerShell.Hudu.Models.HuduFolder
## NOTES

## RELATED LINKS
