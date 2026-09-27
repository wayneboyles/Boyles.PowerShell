---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Set-HuduAssetLayout

## SYNOPSIS
Updates an existing asset layout in the connected Hudu instance.

## SYNTAX

```
Set-HuduAssetLayout [-Id] <Int32> [[-Name] <String>] [[-Fields] <HuduAssetLayoutField[]>] [[-Icon] <String>]
 [[-Active] <Boolean>] [[-Color] <String>] [[-IconColor] <String>] [-Inactive] [-IncludePasswords]
 [-IncludePhotos] [-IncludeComments] [-IncludeFiles] [-IncludeProcesses]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the asset layout with the given ID via the connected HuduClient (see Connect-Hudu).
Only the parameters actually supplied are sent in the request body, so omitted properties are
left unchanged.
Returns $null instead of throwing when the ID doesn't exist, since Hudu
responds with an HTTP 404 in that case.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
Set-HuduAssetLayout -Id 42 -Name 'Servers (Updated)'
```

Renames asset layout 42, leaving its other properties unchanged.

### EXAMPLE 2
```
$layout = Get-HuduAssetLayout -Name 'Servers'
$layout.Fields.Add([Boyles.PowerShell.Hudu.Models.HuduAssetLayoutField]@{
    Label = 'Warranty Expires'; FieldType = 'Date'; Expiration = $true; Position = 10
})
$layout | Set-HuduAssetLayout -Fields $layout.Fields
```

Adds a new date field to the 'Servers' asset layout, keeping its existing fields.

### EXAMPLE 3
```
Set-HuduAssetLayout -Id 42 -IncludeComments:$false
```

Turns off the comments section on asset layout 42.

## PARAMETERS

### -Active
Whether the asset layout should be active.
Enable-HuduAssetLayout and
Disable-HuduAssetLayout are shortcuts for this.

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

### -Color
New hex code for the icon's background color.

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

### -Fields
Field definitions for the asset layout, as an array of HuduAssetLayoutField objects.
To
update an existing field, include its Id; fields without an Id are added as new fields.
Changing the list of a ListSelect field clears that field's existing values on every asset.

```yaml
Type: HuduAssetLayoutField[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Icon
New Font Awesome icon class for the asset layout, e.g.
'fas fa-server'.

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

### -IconColor
New hex code for the icon glyph's color.

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

### -Id
ID of the asset layout to update.
Accepts pipeline input by property name.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Inactive
Marks the asset layout as inactive.
Prefer -Active $false (or Disable-HuduAssetLayout),
which sends Hudu's 'active' property directly.

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
Pass -IncludeComments:$false to
disable it.

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
Pass -IncludeFiles:$false to
disable it.

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
Pass -IncludePasswords:$false
to disable it.

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
Pass -IncludePhotos:$false to
disable it.

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
Pass -IncludeProcesses:$false
to disable it.

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
New name for the asset layout.

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
