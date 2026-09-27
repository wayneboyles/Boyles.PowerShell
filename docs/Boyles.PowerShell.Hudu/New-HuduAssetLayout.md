---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# New-HuduAssetLayout

## SYNOPSIS
Creates a new asset layout in the connected Hudu instance.

## SYNTAX

```
New-HuduAssetLayout [-Name] <String> -Fields <HuduAssetLayoutField[]> [-Icon <String>] [-Color <String>]
 [-IconColor <String>] [-Inactive] [-IncludePasswords] [-IncludePhotos] [-IncludeComments] [-IncludeFiles]
 [-IncludeProcesses] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates an asset layout via the connected HuduClient (see Connect-Hudu).
Only the parameters
actually supplied are sent in the request body; the field definitions in -Fields are sent
alongside them.
Hudu creates the layout as active unless -Inactive is specified.
Supports
-WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
$fields = @(
    @{ Label = 'Hostname'; FieldType = 'Text'; Required = $true; ShowInList = $true; Position = 1 }
    @{ Label = 'Notes'; FieldType = 'RichText'; Position = 2 }
)
```

New-HuduAssetLayout -Name 'Servers' -Fields $fields -Icon 'fas fa-server' -IncludePasswords -IncludeFiles

Creates an active 'Servers' asset layout with two fields and the passwords and files
sections enabled.

## PARAMETERS

### -Color
Hex code for the icon's background color, e.g.
'#1E88E5'.

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

### -Fields
Field definitions for the asset layout, as an array of HuduAssetLayoutField objects.
Each
field needs at least a Label and a FieldType (see \[Boyles.PowerShell.Hudu.Models.HuduFieldType\]
for the supported type names).

```yaml
Type: HuduAssetLayoutField[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Icon
Font Awesome icon class to display for the asset layout, e.g.
'fas fa-server'.

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

### -IconColor
Hex code for the icon glyph's color, e.g.
'#FFFFFF'.

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

### -Inactive
Creates the asset layout as inactive instead of active.

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

### -IncludeComments
Enables the comments section on assets using this layout.

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

### -IncludeFiles
Enables the files section on assets using this layout.

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

### -IncludePasswords
Enables the passwords section on assets using this layout.

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

### -IncludePhotos
Enables the photos section on assets using this layout.

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

### -IncludeProcesses
Enables the processes section on assets using this layout.

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

### -Name
Name of the new asset layout.

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

### Boyles.PowerShell.Hudu.Models.HuduAssetLayout
## NOTES

## RELATED LINKS
