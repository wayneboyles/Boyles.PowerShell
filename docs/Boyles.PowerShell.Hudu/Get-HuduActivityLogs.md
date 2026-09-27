---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Get-HuduActivityLogs

## SYNOPSIS
Retrieves activity logs from the connected Hudu instance.

## SYNTAX

```
Get-HuduActivityLogs [[-Page] <Int32>] [[-PageNumber] <Int32>] [[-UserId] <Int32>] [[-UserEmail] <String>]
 [[-ResourceId] <Int32>] [[-ResourceType] <String>] [[-ActionMessage] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Queries the Hudu activity log endpoint via the connected HuduClient (see Connect-Hudu),
applying whichever filters were supplied as query parameters.
Every page of results is
retrieved automatically and returned as a single array.
ResourceId and ResourceType must be
specified together - supplying only one of the pair throws.

## EXAMPLES

### EXAMPLE 1
```
Get-HuduActivityLogs
```

Returns every activity log entry, with no filters applied.

### EXAMPLE 2
```
Get-HuduActivityLogs -ResourceId 123 -ResourceType 'Asset'
```

Returns activity log entries for the asset with ID 123.

### EXAMPLE 3
```
Get-HuduActivityLogs -UserEmail 'tech@example.com' -ActionMessage 'viewed'
```

Returns every 'viewed' entry recorded for the given user.

## PARAMETERS

### -ActionMessage
Filters results to log entries for the given action (e.g.
'viewed', 'updated').

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

### -Page
Sent to Hudu as the 'page' query parameter.
Currently has no effect: the client retrieves
every page automatically and overwrites 'page' while paging.

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

### -PageNumber
Sent to Hudu as a 'page_number' query parameter.
Currently has no effect: Hudu's activity
log endpoint does not recognize 'page_number'.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceId
Filters results to activity on the given resource ID.
Must be specified together with
ResourceType.

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

### -ResourceType
Filters results to activity on the given resource type (e.g.
'Asset', 'AssetPassword',
'Company', 'Article').
Must be specified together with ResourceId.

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

### -UserEmail
Filters results to activity performed by the user with the given email address.

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

### -UserId
Filters results to activity performed by the given user ID.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Boyles.PowerShell.Hudu.Models.HuduActivityLog[]
## NOTES

## RELATED LINKS
