---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduAsset

## SYNOPSIS
Retrieves Hudu assets.

## SYNTAX

### ByLayoutName
```
Get-HuduAsset [-Id <Int32>] [-Name <String>] [-CompanyId <Int32>] [-PrimarySerial <String>]
 [-AssetLayout <String>] [-Archived] [-Slug <String>] [-Search <String>]
 [<CommonParameters>]
```

### ByLayoutId
```
Get-HuduAsset [-Id <Int32>] [-Name <String>] [-CompanyId <Int32>] [-PrimarySerial <String>]
 [-AssetLayoutId <Int32>] [-Archived] [-Slug <String>] [-Search <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Wraps the Hudu Assets API.
-CompanyId, -Id, and the filters (-Name, -PrimarySerial,
-AssetLayout/-AssetLayoutId, -Slug, -Search, -Archived) can be combined freely, so which
endpoint is called depends on which parameters were bound:

- -CompanyId and -Id together (regardless of any other filter) -\> a single, direct GET
  against /companies/{company_id}/assets/{id}.
Returns $null instead of throwing if the
  asset doesn't exist (Hudu responds with an HTTP 404 in that case).
- -CompanyId alone, with no -Id and no other filter (only -Archived is compatible with
  it) -\> the company-scoped list endpoint /companies/{company_id}/assets.
- Everything else (-Id alone, -CompanyId with another filter, or any of the other filters)
  -\> the global /assets endpoint, which supports every filter and accepts CompanyId and Id
  as ordinary filters rather than path segments.

-AssetLayout and -AssetLayoutId are in separate parameter sets, so only one of them can be
used per call.
List calls are paginated internally (Hudu's 'page' / 'page_size' parameters)
and this function always returns the full, materialized result set.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduAsset -CompanyId 12 -Id 345
```

Retrieves a single asset directly, via /companies/12/assets/345.

### EXAMPLE 2
```
Get-HuduAsset -CompanyId 12
```

Retrieves every non-archived asset for company 12, via the company-scoped endpoint.

### EXAMPLE 3
```
Get-HuduAsset -CompanyId 12 -Archived
```

Retrieves every archived asset for company 12, via the company-scoped endpoint.

### EXAMPLE 4
```
Get-HuduAsset -CompanyId 12 -Name 'DC01'
```

Searches company 12 for assets named 'DC01', via the global endpoint (company_id and name
are both sent as filters, since the company-scoped endpoint does not support -Name).

### EXAMPLE 5
```
Get-HuduAsset -AssetLayout 'Servers' -Search 'Dell'
```

Searches every company for assets on the 'Servers' asset layout matching 'Dell'.

### EXAMPLE 6
```
Get-HuduCompany -Name 'Acme' | ForEach-Object { Get-HuduAsset -CompanyId $_.Id }
```

Retrieves every asset belonging to the Acme company.
The company is passed explicitly
because a piped HuduCompany's Id property would otherwise bind to -Id, not -CompanyId.

## PARAMETERS

### -Archived
Returns only archived assets.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetLayout
Filters assets by the name of their asset layout.
The name is resolved to an ID with
Get-HuduAssetLayout before the query is sent.
Supports tab completion of existing asset
layout names once Connect-Hudu has been run.
Cannot be combined with -AssetLayoutId.

```yaml
Type: String
Parameter Sets: ByLayoutName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AssetLayoutId
Filters assets by the ID of their asset layout.
Cannot be combined with -AssetLayout.

```yaml
Type: Int32
Parameter Sets: ByLayoutId
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompanyId
Restricts results to a single company.
Combine with -Id for a direct single-asset lookup;
alone (or with -Archived) it uses the company-scoped list endpoint; combined with another
filter it is sent as a filter to the global endpoint.
Accepts pipeline input by property
name.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Id
The identifier of a specific asset.
Combine with -CompanyId for a direct single-asset
lookup; used without -CompanyId it is sent as a filter to the global assets endpoint.
Accepts pipeline input by property name.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Filters assets by name.

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

### -PrimarySerial
Filters assets by primary serial number.

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

### -Search
Free-text search filter.

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

### -Slug
Filters assets by their URL slug.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Boyles.PowerShell.Hudu.Models.HuduAsset
### Boyles.PowerShell.Hudu.Models.HuduAsset[]
## NOTES

## RELATED LINKS
