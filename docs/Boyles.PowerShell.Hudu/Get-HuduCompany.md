---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduCompany

## SYNOPSIS
Retrieves one or more companies from the connected Hudu instance.

## SYNTAX

### All (Default)
```
Get-HuduCompany [-Name <String>] [-IdNumber <Int32>] [-PhoneNumber <String>] [-Website <String>]
 [-City <String>] [-State <String>] [-Slug <String>] [-Search <String>] [-Page <Int32>] [-PageSize <Int32>]
 [<CommonParameters>]
```

### Single
```
Get-HuduCompany -Id <Int32> [<CommonParameters>]
```

## DESCRIPTION
With -Id, retrieves a single company by ID, returning $null instead of throwing if the ID
doesn't exist (Hudu responds with an HTTP 404 in that case).
Without -Id, retrieves every
company matching the supplied filters, optionally limited to a single page via
-Page/-PageSize.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduCompany -Id 5
```

Returns the company with ID 5, or $null if it doesn't exist.

### EXAMPLE 2
```
Get-HuduCompany -Name 'Acme Corp'
```

Returns the company named 'Acme Corp'.

### EXAMPLE 3
```
Get-HuduCompany -State 'TX' -Page 1 -PageSize 25
```

Returns the first 25 companies located in Texas.

## PARAMETERS

### -City
Filters results to companies matching the given city.

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
ID of a single company to retrieve.

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

### -IdNumber
Filters results to companies matching the given ID number (Hudu's custom company
identification number).

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

### -Name
Filters results to companies matching the given name.
Supports tab completion of existing
company names once Connect-Hudu has been run.

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

### -PhoneNumber
Filters results to companies matching the given phone number.

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

### -Search
Filters results to companies matching the given search text.

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
Filters results to companies matching the given URL slug.

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

### -State
Filters results to companies matching the given state.

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

### -Website
Filters results to companies matching the given website.

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

### Boyles.PowerShell.Hudu.Models.HuduCompany
### Boyles.PowerShell.Hudu.Models.HuduCompany[]
## NOTES

## RELATED LINKS
