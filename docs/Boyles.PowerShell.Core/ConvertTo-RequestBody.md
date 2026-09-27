---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# ConvertTo-RequestBody

## SYNOPSIS
Builds a request body hashtable from a function's bound parameters.

## SYNTAX

```
ConvertTo-RequestBody [-BoundParameters] <IDictionary>
 [-ParameterMetadata] <System.Collections.Generic.Dictionary`2[System.String,System.Management.Automation.ParameterMetadata]>
 [<CommonParameters>]
```

## DESCRIPTION
Loops through the calling function's parameter metadata and adds every parameter that was
actually bound (present in $PSBoundParameters) to the returned hashtable, keyed by its JSON
name:

- A parameter decorated with \[BodyProperty('json_name')\] is keyed by that name.
- A parameter with no \[BodyProperty()\] attribute is keyed by its own name in lowercase
  (e.g.
-Name becomes 'name').
- A parameter decorated with \[BodyIgnore()\] is skipped entirely.
Use this for route/path
  parameters such as -Id or -CompanyId that belong in the URL rather than the body.
- PowerShell's common parameters (-Verbose, -WhatIf, -ErrorAction, etc.) are always skipped.

Value types (int, bool, switch, etc.) are always included when bound, even when they hold
their default value, so -Enabled:$false is sent as false.
Reference types (strings,
arrays, objects) are only included when Test-HasValue returns $true, so an empty string or
empty array is dropped.

## EXAMPLES

### EXAMPLE 1
```
function Set-HuduWidget {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [BodyIgnore()]
        [Parameter(Mandatory)]
        [int] $Id,
```

\[Parameter()\]
        \[string\] $Name,

        \[BodyProperty('company_id')\]
        \[Parameter()\]
        \[int\] $CompanyId
    )

    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters
}

Set-HuduWidget -Id 7 -Name 'Core Switch' -CompanyId 5

Inside the function, $body is @{ name = 'Core Switch'; company_id = 5 }.
-Id is excluded
by \[BodyIgnore()\], -Name falls back to its lowercase parameter name, and -CompanyId uses
the name from \[BodyProperty()\].

## PARAMETERS

### -BoundParameters
The $PSBoundParameters dictionary from the calling function.

```yaml
Type: IDictionary
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParameterMetadata
The calling function's parameter metadata, typically $MyInvocation.MyCommand.Parameters.

```yaml
Type: System.Collections.Generic.Dictionary`2[System.String,System.Management.Automation.ParameterMetadata]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Collections.Hashtable
## NOTES

## RELATED LINKS
