---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Remove-HuduExpiration

## SYNOPSIS
Deletes an expiration from the connected Hudu instance.

## SYNTAX

```
Remove-HuduExpiration [-Id] <Int32> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Permanently deletes the expiration with the given ID via the connected HuduClient (see
Connect-Hudu).
Returns $null instead of throwing when the ID doesn't exist, since Hudu
responds with an HTTP 404 in that case.
Supports -WhatIf/-Confirm, with a 'High' confirm
impact since deletion is irreversible.
To hide an expiration without deleting it, use
Set-HuduExpiration -Archived $true instead.

## EXAMPLES

### EXAMPLE 1
```
Remove-HuduExpiration -Id 88
```

Deletes the expiration with ID 88, after confirmation.

### EXAMPLE 2
```
Get-HuduExpiration -CompanyId 5 -Archived $true | Remove-HuduExpiration -Confirm:$false
```

Deletes every archived expiration belonging to company 5 without prompting.

## PARAMETERS

### -Id
ID of the expiration to delete.
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

### None
## NOTES

## RELATED LINKS
