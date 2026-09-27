---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# ConvertTo-RequestQuery

## SYNOPSIS
Builds a query-string hashtable from a function's bound parameters.

## SYNTAX

```
ConvertTo-RequestQuery [-BoundParameters] <IDictionary>
 [-ParameterMetadata] <System.Collections.Generic.Dictionary`2[System.String,System.Management.Automation.ParameterMetadata]>
 [<CommonParameters>]
```

## DESCRIPTION
The query-string counterpart to ConvertTo-RequestBody.
Loops through the calling function's
parameter metadata and adds every parameter that was actually bound (present in
$PSBoundParameters) to the returned hashtable, keyed by its query-string name:

- A parameter decorated with \[QueryProperty('query_name')\] is keyed by that name.
- A parameter with no \[QueryProperty()\] attribute is keyed by its own name in lowercase.
- A parameter decorated with \[QueryIgnore()\] is skipped entirely.
Use this for route/path
  parameters such as -Id that belong in the URL rather than the query string.
- PowerShell's common parameters (-Verbose, -WhatIf, -ErrorAction, etc.) are always skipped.

Value types (int, bool, switch, etc.) are always included when bound, even when they hold
their default value.
Reference types (strings, arrays, objects) are only included when
Test-HasValue returns $true.

The result is a plain hashtable of typed values.
Pipe it to ConvertTo-StringDictionary to
get the Dictionary\[string, string\] that the C# client methods expect, with booleans
rendered as lowercase 'true'/'false'.

## EXAMPLES

### EXAMPLE 1
```
function Get-HuduWidget {
    [CmdletBinding()]
    param(
        [QueryProperty('company_id')]
        [Parameter()]
        [int] $CompanyId,
```

\[QueryProperty('archived')\]
        \[Parameter()\]
        \[bool\] $Archived
    )

    $query = ConvertTo-RequestQuery -BoundParameters $PSBoundParameters \`
        -ParameterMetadata $MyInvocation.MyCommand.Parameters | ConvertTo-StringDictionary
}

Get-HuduWidget -CompanyId 5 -Archived $false

Inside the function, $query is a Dictionary\[string, string\] containing
company_id = '5' and archived = 'false'.

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
