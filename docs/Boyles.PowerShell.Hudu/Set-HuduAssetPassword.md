---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# Set-HuduAssetPassword

## SYNOPSIS
Updates an existing asset password in the connected Hudu instance.

## SYNTAX

```
Set-HuduAssetPassword [-Id] <Int32> [-Name <String>] [-Password <String>] [-CompanyId <Int32>]
 [-PasswordableType <String>] [-PasswordableId <Int32>] [-InPortal <Boolean>] [-OtpSecret <String>]
 [-Url <String>] [-Username <String>] [-Description <String>] [-PasswordType <String>]
 [-PasswordFolderId <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the asset password with the given ID via the connected HuduClient (see
Connect-Hudu).
Only the parameters actually supplied are sent in the request body, so
omitted properties are left unchanged.
Returns $null instead of throwing when the ID
doesn't exist, since Hudu responds with an HTTP 404 in that case.
Supports
-WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
Set-HuduAssetPassword -Id 123 -Username 'newadmin'
```

Updates the username on asset password 123, leaving its other properties unchanged.

### EXAMPLE 2
```
Get-HuduAssetPassword -CompanyId 5 -Search 'wifi' | Set-HuduAssetPassword -InPortal $true
```

Makes every matching Wi-Fi password for company 5 visible in the client portal.

## PARAMETERS

### -CompanyId
New company ID to associate the asset password with.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
New free-form description of the password.

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

### -Id
ID of the asset password to update.
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

### -InPortal
Whether the password should be visible in the client portal.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
New name for the asset password.

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

### -OtpSecret
New TOTP/OTP secret associated with the password.

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

### -Password
New password value, as plain text.

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

### -PasswordableId
New ID of the record this password is attached to.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PasswordableType
New type of the record this password is attached to, e.g.
'Asset' or 'Website'.

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

### -PasswordFolderId
New password folder ID to file the password under.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -PasswordType
New type/category of the password.

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

### -Url
New URL associated with the password.

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

### -Username
New username associated with the password.

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

### Boyles.PowerShell.Hudu.Models.HuduAssetPassword
## NOTES

## RELATED LINKS
