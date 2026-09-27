---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduAssetPassword

## SYNOPSIS
Retrieves one or more asset passwords from the connected Hudu instance.

## SYNTAX

### All (Default)
```
Get-HuduAssetPassword [-Name <String>] [-CompanyId <Int32>] [-Archived <Boolean>] [-Slug <String>]
 [-Search <String>] [-InputObject <HuduCompany>] [-Page <Int32>] [-PageSize <Int32>]
 [<CommonParameters>]
```

### Single
```
Get-HuduAssetPassword -Id <Int32> [<CommonParameters>]
```

## DESCRIPTION
With -Id, retrieves a single asset password by ID, returning $null instead of throwing if
the ID doesn't exist (Hudu responds with an HTTP 404 in that case).
Without -Id, retrieves
every asset password matching the supplied filters, optionally scoped to a company via
-CompanyId or a piped HuduCompany object (not both), and optionally limited to a single page
via -Page/-PageSize.
The API key used by Connect-Hudu must have password access.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduAssetPassword -Id 123
```

Returns the asset password with ID 123, or $null if it doesn't exist.

### EXAMPLE 2
```
Get-HuduAssetPassword -CompanyId 5 -Archived $false
```

Returns every non-archived asset password belonging to company 5.

### EXAMPLE 3
```
Get-HuduCompany -Name 'Acme' | Get-HuduAssetPassword -Search 'admin'
```

Returns Acme's asset passwords matching the given search text.

## PARAMETERS

### -Archived
Filters results to archived ($true) or non-archived ($false) asset passwords.

```yaml
Type: Boolean
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompanyId
Filters results to asset passwords belonging to the given company ID.
Accepts pipeline
input by property name.
Mutually exclusive with a piped HuduCompany object.

```yaml
Type: Int32
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Id
ID of a single asset password to retrieve.

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

### -InputObject
A HuduCompany object to scope results to.
Accepts pipeline input.
Mutually exclusive with
-CompanyId.

```yaml
Type: HuduCompany
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Name
Filters results to asset passwords matching the given name.

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

### -Page
Page number to retrieve.
Supplying -Page and/or -PageSize returns just that one page, using
page 1 or a page size of 50 for whichever is omitted.
When neither is supplied, every page
is retrieved automatically.

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

### -PageSize
Number of results per page.
Supplying -Page and/or -PageSize returns just that one page,
using page 1 or a page size of 50 for whichever is omitted.
When neither is supplied, every
page is retrieved automatically.

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

### -Search
Filters results to asset passwords matching the given search text.

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

### -Slug
Filters results to asset passwords matching the given URL slug.

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

### Boyles.PowerShell.Hudu.Models.HuduAssetPassword
### Boyles.PowerShell.Hudu.Models.HuduAssetPassword[]
## NOTES

## RELATED LINKS
