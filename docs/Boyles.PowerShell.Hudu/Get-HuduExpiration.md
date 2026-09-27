---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduExpiration

## SYNOPSIS
Retrieves expirations from the connected Hudu instance.

## SYNTAX

```
Get-HuduExpiration [[-CompanyId] <Int32>] [[-ExpirationType] <String>] [[-ResourceId] <Int32>]
 [[-ResourceType] <String>] [[-Archived] <Boolean>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves every expiration matching the supplied filters via the connected HuduClient (see
Connect-Hudu), across all pages.
Only filters that are supplied are sent to Hudu.
Unless
-Archived is specified, Hudu returns only active (non-archived) expirations.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduExpiration -CompanyId 5
```

Returns every active expiration belonging to company 5.

### EXAMPLE 2
```
Get-HuduExpiration -ExpirationType 'ssl_certificate' | Where-Object Date -lt (Get-Date).AddDays(30)
```

Returns every SSL certificate expiration due in the next 30 days.

### EXAMPLE 3
```
Get-HuduExpiration -ResourceType 'Asset' -ResourceId 345
```

Returns the expirations for asset 345.

## PARAMETERS

### -Archived
Filters results to archived ($true) or active ($false) expirations.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompanyId
Filters results to expirations belonging to the given company ID.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExpirationType
Filters results by expiration type: 'undeclared', 'domain', 'ssl_certificate', 'warranty',
'asset_field', or 'article_expiration'.

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

### -ResourceId
Filters results to expirations on the given resource ID.
Use together with -ResourceType.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceType
Filters results to expirations on the given resource type (e.g.
'Asset', 'Website').
Use together with -ResourceId.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Boyles.PowerShell.Hudu.Models.HuduExpiration[]
## NOTES

## RELATED LINKS
