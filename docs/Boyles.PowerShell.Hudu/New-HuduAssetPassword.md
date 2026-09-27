---
external help file: Boyles.PowerShell.Hudu-help.xml
Module Name: Boyles.PowerShell.Hudu
online version:
schema: 2.0.0
---

# New-HuduAssetPassword

## SYNOPSIS
Creates a new asset password in the connected Hudu instance.

## SYNTAX

```
New-HuduAssetPassword [-Name] <String> -Password <String> -CompanyId <Int32> [-PasswordableType <String>]
 [-PasswordableId <Int32>] [-InPortal <Boolean>] [-OtpSecret <String>] [-Url <String>] [-Username <String>]
 [-Description <String>] [-PasswordType <String>] [-PasswordFolderId <Int32>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates an asset password via the connected HuduClient (see Connect-Hudu).
Only the
parameters actually supplied are sent in the request body.
Supports -WhatIf/-Confirm.

## EXAMPLES

### EXAMPLE 1
```
New-HuduAssetPassword -Name 'Admin Login' -Password 'S3cr3t!' -CompanyId 5
```

Creates a new asset password named 'Admin Login' under company 5.

### EXAMPLE 2
```
$params = @{
    Name             = 'iDRAC'
    Password         = $pw
    CompanyId        = 5
    Username         = 'root'
    PasswordableType = 'Asset'
    PasswordableId   = 345
}
New-HuduAssetPassword @params
```

Creates a password for the 'root' user and attaches it to asset 345.

## PARAMETERS

### -CompanyId
ID of the company to associate the asset password with.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Free-form description of the password.

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
Name of the new asset password.

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

### -OtpSecret
TOTP/OTP secret associated with the password.

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
The password value to store, as plain text (Hudu's API requires it unencrypted).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PasswordableId
ID of the record this password is attached to.
Use together with -PasswordableType.

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
Type of the record this password is attached to, e.g.
'Asset' or 'Website'.
Use together
with -PasswordableId.

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
ID of the password folder to file the password under.

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
Type/category of the password.

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
URL associated with the password.

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
Username associated with the password.

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
