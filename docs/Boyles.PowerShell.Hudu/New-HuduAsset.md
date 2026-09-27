---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# New-HuduAsset

## SYNOPSIS
Creates a new asset in the connected Hudu instance.

## SYNTAX

```
New-HuduAsset [-CompanyId] <Int32> [-Name] <String> [-AssetLayoutId] <Int32> [[-PrimarySerial] <String>]
 [[-PrimaryMail] <String>] [[-PrimaryModel] <String>] [[-PrimaryManufacturer] <String>]
 [[-Fields] <HuduAssetField[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates an asset under the given company via the connected HuduClient (see Connect-Hudu).
Only the parameters actually supplied are sent in the request body.
Custom field values are
supplied through -Fields and sent as the asset's custom_fields.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
New-HuduAsset -CompanyId 12 -Name 'DC01' -AssetLayoutId 7 -PrimarySerial 'ABC1234'
```

Creates an asset named 'DC01' on asset layout 7 for company 12.

### EXAMPLE 2
```
$fields = @(
    @{ Label = 'Hostname'; Value = 'dc01.acme.local' }
    @{ Label = 'Operating System'; Value = 'Windows Server 2022' }
)
```

New-HuduAsset -CompanyId 12 -Name 'DC01' -AssetLayoutId 7 -Fields $fields

Creates the asset and populates two of its custom fields.

## PARAMETERS

### -AssetLayoutId
ID of the asset layout the new asset uses.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompanyId
ID of the company to create the asset under.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Fields
Custom field values for the asset, as an array of HuduAssetField objects.
Each field's
Label must match a field on the asset layout; use Get-HuduAssetLayoutFields to list them.

```yaml
Type: HuduAssetField[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the new asset.

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

### -PrimaryMail
Primary email address associated with the asset.

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

### -PrimaryManufacturer
Primary manufacturer of the asset.

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

### -PrimaryModel
Primary model of the asset.

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

### -PrimarySerial
Primary serial number of the asset.

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

### Boyles.PowerShell.Hudu.Models.HuduAsset
## NOTES

## RELATED LINKS
