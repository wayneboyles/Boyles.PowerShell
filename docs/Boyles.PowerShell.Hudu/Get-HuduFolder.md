---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduFolder

## SYNOPSIS
Retrieves one or more folders from the connected Hudu instance.

## SYNTAX

### All (Default)
```
Get-HuduFolder [-Name <String>] [-CompanyId <Int32>] [-InCompany] [-FolderType <String>]
 [<CommonParameters>]
```

### Single
```
Get-HuduFolder -Id <Int32> [<CommonParameters>]
```

## DESCRIPTION
With -Id, retrieves a single folder by ID, returning $null instead of throwing if the ID
doesn't exist (Hudu responds with an HTTP 404 in that case).
Without -Id, retrieves every
folder matching the supplied filters, across all pages.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduFolder -Id 12
```

Returns the folder with ID 12, or $null if it doesn't exist.

### EXAMPLE 2
```
Get-HuduFolder -CompanyId 5 -FolderType 'article'
```

Returns every article folder belonging to company 5.

## PARAMETERS

### -CompanyId
Filters results to folders belonging to the given company ID.

```yaml
Type: Int32
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -FolderType
Filters results by folder type: 'article' or 'photo'.

```yaml
Type: String
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
ID of a single folder to retrieve.

```yaml
Type: Int32
Parameter Sets: Single
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -InCompany
Returns only company-specific folders, excluding global knowledge base folders.

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Filters results to folders matching the given name.

```yaml
Type: String
Parameter Sets: All
Aliases:

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
### Boyles.PowerShell.Hudu.Models.HuduFolder[]
## NOTES

## RELATED LINKS
