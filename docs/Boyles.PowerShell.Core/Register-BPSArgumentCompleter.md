---
external help file: Boyles.PowerShell.Core-help.xml
Module Name: Boyles.PowerShell.Core
online version:
schema: 2.0.0
---

# Register-BPSArgumentCompleter

## SYNOPSIS
Registers a cached, generic tab-completer for one or more command parameters.

## SYNTAX

```
Register-BPSArgumentCompleter [-CommandName] <String[]> [-ParameterName] <String>
 [-ValueProvider] <ScriptBlock> [[-ValueProperty] <String>] [[-DisplayProperty] <String>]
 [[-TooltipProperty] <String>] [[-CacheSeconds] <Int32>] [[-CacheKey] <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Wraps Register-ArgumentCompleter with the standard Boyles.PowerShell completion pipeline so every
module implements tab-completion the same way.
The caller supplies a ValueProvider scriptblock that
knows how to fetch the full candidate set from its own C# client (e.g.
HuduClient.GetCompanies()) -
everything else (caching, filtering on what's typed so far, quoting values with spaces, building
CompletionResult objects) is handled here.

Results are cached per CacheKey so every keystroke doesn't re-hit the API.
The cache expires after
CacheSeconds and is transparently refreshed on the next completion request.
If ValueProvider throws
(most commonly because the service's Connect-* cmdlet, such as Connect-Hudu, hasn't been run yet)
the exception is swallowed and whatever is already cached is used instead - a completer must never
break Tab.

Service modules normally call this from their .psm1 after dot-sourcing their functions, so the
ValueProvider can use the module's private helpers (e.g.
Get-HuduClientInternal).

## EXAMPLES

### EXAMPLE 1
```
Register-BPSArgumentCompleter -CommandName Get-HuduCompany -ParameterName Name -ValueProvider {
    (Get-HuduClientInternal).GetCompanies()
} -ValueProperty Name -TooltipProperty Id
```

Registers tab-completion for Get-HuduCompany -Name, pulling live company names from Hudu and
caching them for five minutes.
This is how Boyles.PowerShell.Hudu.psm1 registers it.

### EXAMPLE 2
```
Register-BPSArgumentCompleter -CommandName Get-HuduAsset -ParameterName AssetLayout -ValueProvider {
    (Get-HuduClientInternal).GetAssetLayouts()
} -ValueProperty Name -TooltipProperty Id -CacheSeconds 60 -CacheKey 'Hudu:AssetLayouts'
```

Completes Get-HuduAsset -AssetLayout with live asset layout names, refreshing every 60
seconds and storing the results under a named cache key that other registrations can share.

## PARAMETERS

### -CacheKey
Cache partition key.
Defaults to "\<first CommandName\>:\<ParameterName\>".
Override this when two
registrations should share one cache (e.g.
two commands completing the same list of asset
layouts), or when the same command/parameter pair needs to be cached separately per connected
tenant.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: "$($CommandName[0]):$ParameterName"
Accept pipeline input: False
Accept wildcard characters: False
```

### -CacheSeconds
How long fetched candidates are cached before ValueProvider is invoked again.
Defaults to 300.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 300
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommandName
Name(s) of the command(s) to attach the completer to.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisplayProperty
Property on each candidate object to show as the completion list-item text.
Defaults to
ValueProperty when omitted.

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

### -ParameterName
Name of the parameter being completed.

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

### -TooltipProperty
Property on each candidate object to show as the tooltip.
Defaults to the display text when
omitted.

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

### -ValueProperty
Property on each candidate object to use as the completion value.
Omit when ValueProvider already
returns plain strings.

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

### -ValueProvider
Scriptblock that returns the full candidate set.
Invoked with $fakeBoundParameters as its only
argument on a cache miss, so a completer can filter on another already-bound parameter (e.g.
only
complete -AssetLayout for the -CompanyId the user already picked).
Should return either plain
strings or objects, in which case ValueProperty/DisplayProperty/TooltipProperty describe how to
read them.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
