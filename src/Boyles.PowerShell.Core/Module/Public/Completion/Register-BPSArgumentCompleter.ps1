<#
.SYNOPSIS
    Registers a cached, generic tab-completer for one or more command parameters.

.DESCRIPTION
    Wraps Register-ArgumentCompleter with the standard Boyles.PowerShell completion pipeline so every
    module implements tab-completion the same way. The caller supplies a ValueProvider scriptblock that
    knows how to fetch the full candidate set from its own C# client (e.g. HuduClient.GetCompanies()) -
    everything else (caching, filtering on what's typed so far, quoting values with spaces, building
    CompletionResult objects) is handled here.

    Results are cached per CacheKey so every keystroke doesn't re-hit the API. The cache expires after
    CacheSeconds and is transparently refreshed on the next completion request. If ValueProvider throws
    (most commonly because the service's Connect-* cmdlet, such as Connect-Hudu, hasn't been run yet)
    the exception is swallowed and whatever is already cached is used instead - a completer must never
    break Tab.

    Service modules normally call this from their .psm1 after dot-sourcing their functions, so the
    ValueProvider can use the module's private helpers (e.g. Get-HuduClientInternal).

.PARAMETER CommandName
    Name(s) of the command(s) to attach the completer to.

.PARAMETER ParameterName
    Name of the parameter being completed.

.PARAMETER ValueProvider
    Scriptblock that returns the full candidate set. Invoked with $fakeBoundParameters as its only
    argument on a cache miss, so a completer can filter on another already-bound parameter (e.g. only
    complete -AssetLayout for the -CompanyId the user already picked). Should return either plain
    strings or objects, in which case ValueProperty/DisplayProperty/TooltipProperty describe how to
    read them.

.PARAMETER ValueProperty
    Property on each candidate object to use as the completion value. Omit when ValueProvider already
    returns plain strings.

.PARAMETER DisplayProperty
    Property on each candidate object to show as the completion list-item text. Defaults to
    ValueProperty when omitted.

.PARAMETER TooltipProperty
    Property on each candidate object to show as the tooltip. Defaults to the display text when
    omitted.

.PARAMETER CacheSeconds
    How long fetched candidates are cached before ValueProvider is invoked again. Defaults to 300.

.PARAMETER CacheKey
    Cache partition key. Defaults to "<first CommandName>:<ParameterName>". Override this when two
    registrations should share one cache (e.g. two commands completing the same list of asset
    layouts), or when the same command/parameter pair needs to be cached separately per connected
    tenant.

.EXAMPLE
    Register-BPSArgumentCompleter -CommandName Get-HuduCompany -ParameterName Name -ValueProvider {
        (Get-HuduClientInternal).GetCompanies()
    } -ValueProperty Name -TooltipProperty Id

    Registers tab-completion for Get-HuduCompany -Name, pulling live company names from Hudu and
    caching them for five minutes. This is how Boyles.PowerShell.Hudu.psm1 registers it.

.EXAMPLE
    Register-BPSArgumentCompleter -CommandName Get-HuduAsset -ParameterName AssetLayout -ValueProvider {
        (Get-HuduClientInternal).GetAssetLayouts()
    } -ValueProperty Name -TooltipProperty Id -CacheSeconds 60 -CacheKey 'Hudu:AssetLayouts'

    Completes Get-HuduAsset -AssetLayout with live asset layout names, refreshing every 60
    seconds and storing the results under a named cache key that other registrations can share.

.OUTPUTS
    None
#>
function Register-BPSArgumentCompleter {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]] $CommandName,

        [Parameter(Mandatory)]
        [string] $ParameterName,

        [Parameter(Mandatory)]
        [scriptblock] $ValueProvider,

        [Parameter()]
        [string] $ValueProperty,

        [Parameter()]
        [string] $DisplayProperty,

        [Parameter()]
        [string] $TooltipProperty,

        [Parameter()]
        [int] $CacheSeconds = 300,

        [Parameter()]
        [string] $CacheKey = "$($CommandName[0]):$ParameterName"
    )

    # Captured as a plain local variable (not referenced as $script: inside the completer body) because
    # .GetNewClosure() below gives the completer its own, isolated session state with its own empty
    # script scope - a $script: reference inside the closure would silently resolve to $null there even
    # though it works fine everywhere else in this module. Since ConcurrentDictionary is a reference
    # type, capturing it this way still shares the exact same cache instance across every completer.
    $cache = $script:BPSCompletionCache

    $completer = {
        param($commandNameParam, $parameterNameParam, $wordToComplete, $commandAst, $fakeBoundParameters)

        try {
            $now = [DateTimeOffset]::UtcNow
            $entry = $null
            $cacheHit = $cache.TryGetValue($CacheKey, [ref] $entry)

            if (-not $cacheHit -or ($now - $entry.Timestamp).TotalSeconds -gt $CacheSeconds) {
                try {
                    $values = & $ValueProvider $fakeBoundParameters
                } catch {
                    # Most commonly: the relevant Connect-* cmdlet hasn't been run yet. Fall back to
                    # whatever is already cached (possibly nothing) rather than throwing out of Tab.
                    $values = if ($cacheHit) { $entry.Values } else { @() }
                }

                $entry = [pscustomobject]@{
                    Timestamp = $now
                    Values    = @($values)
                }

                $cache[$CacheKey] = $entry
            }

            $matchCount = 0

            foreach ($item in $entry.Values) {
                $value = if ($ValueProperty) { $item.$ValueProperty } else { $item }

                if ([string]::IsNullOrEmpty($value) -or $value -notlike "$wordToComplete*") {
                    continue
                }

                $display = if ($DisplayProperty) { $item.$DisplayProperty } elseif ($ValueProperty) { $item.$ValueProperty } else { $value }
                $tooltip = if ($TooltipProperty) { $item.$TooltipProperty } else { $display }
                $completionText = if ($value -match '\s') { "'$value'" } else { $value }
                $matchCount++

                [System.Management.Automation.CompletionResult]::new(
                    $completionText,
                    $display,
                    'ParameterValue',
                    [string] $tooltip
                )
            }

        } catch {

        }
    }.GetNewClosure()

    Register-ArgumentCompleter -CommandName $CommandName -ParameterName $ParameterName -ScriptBlock $completer
}
