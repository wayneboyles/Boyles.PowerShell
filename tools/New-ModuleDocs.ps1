<#
.SYNOPSIS
    Generates Markdown reference documentation for the Boyles.PowerShell modules from their
    comment-based help, grouped by functional area.

.DESCRIPTION
    Imports each built module from the artifacts folder and runs platyPS New-MarkdownHelp against
    it, writing one Markdown file per exported command to docs/<ModuleName>/. Comment-based help is
    the source of truth, so each module's docs folder is deleted and fully regenerated on every run.

    Commands are grouped by the folder their source file lives in under Public/ (for example
    Public/Assets/Get-HuduAsset.ps1 belongs to the 'Assets' area). Commands directly under Public/
    are grouped as 'General'. That grouping is used to:
      - Write a grouped module landing page (docs/<ModuleName>/README.md) with command synopses.
      - Write the site navigation into mkdocs.yml between the generated-nav marker comments.

    Output is also post-processed to strip the -ProgressAction common parameter that PowerShell
    7.4+ leaks into platyPS 0.14 output, and any remaining platyPS '{{ ... }}' placeholders are
    reported because they indicate missing help.

.PARAMETER ArtifactsRoot
    Path to the build output folder containing one folder per built module (e.g. ./out).

.PARAMETER DocsRoot
    Path to the root docs folder. Each module is written to a subfolder named after the module.

.PARAMETER ModuleName
    Names of the modules to document. Accepts an array or a single comma-separated string (the
    latter so it can be passed through pwsh -File). Modules that export no functions are skipped.

.PARAMETER MkDocsConfig
    Path to mkdocs.yml. When supplied, the generated navigation is written between the
    '# --- BEGIN GENERATED NAV' and '# --- END GENERATED NAV ---' markers, or appended if the
    markers don't exist yet.

.PARAMETER FailOnMissingHelp
    Throws if any generated file still contains platyPS placeholders. Without this switch the
    placeholders are reported as warnings.

.EXAMPLE
    .\tools\New-ModuleDocs.ps1 -ArtifactsRoot .\out -DocsRoot .\docs -ModuleName Boyles.PowerShell.Core, Boyles.PowerShell.Hudu -MkDocsConfig .\mkdocs.yml

    Generates grouped docs for the Core and Hudu modules and updates the site navigation.

.EXAMPLE
    .\tools\New-ModuleDocs.ps1 -ArtifactsRoot .\out -DocsRoot .\docs -ModuleName Boyles.PowerShell.Hudu -FailOnMissingHelp

    Generates the Hudu docs without touching mkdocs.yml and fails if any help is missing.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [string] $ArtifactsRoot,

    [Parameter(Mandatory)]
    [string] $DocsRoot,

    [Parameter(Mandatory)]
    [string[]] $ModuleName,

    [Parameter()]
    [string] $MkDocsConfig,

    [Parameter()]
    [switch] $FailOnMissingHelp
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Import-Module -Name platyPS -ErrorAction Stop

# Display names for area folders that don't split nicely from PascalCase.
$AreaTitleOverrides = @{
    'ApiInfo'     = 'API Info'
    'IpAddresses' = 'IP Addresses'
}

<#
.SYNOPSIS
    Converts an area folder name into a display title.

.EXAMPLE
    ConvertTo-AreaTitle -FolderName 'AssetLayouts'

    Returns 'Asset Layouts'.
#>
function ConvertTo-AreaTitle {
    param([string] $FolderName)

    if ($AreaTitleOverrides.ContainsKey($FolderName)) {
        return $AreaTitleOverrides[$FolderName]
    }

    $FolderName -creplace '(?<=[a-z0-9])(?=[A-Z])', ' '
}

<#
.SYNOPSIS
    Converts a full module name into the short title used for its site navigation tab.

.EXAMPLE
    ConvertTo-ModuleTitle -ModuleName 'Boyles.PowerShell.Hudu'

    Returns 'Hudu'.

.EXAMPLE
    ConvertTo-ModuleTitle -ModuleName 'Some.Other.Module'

    Returns 'Some.Other.Module' unchanged because it doesn't start with the Boyles.PowerShell. prefix.
#>
function ConvertTo-ModuleTitle {
    param([string] $ModuleName)

    $ModuleName -replace '^Boyles\.PowerShell\.', ''
}

<#
.SYNOPSIS
    Returns the area (source folder under Public/) that a function was loaded from.

.EXAMPLE
    Get-CommandArea -Command (Get-Command Get-HuduAsset)

    Returns 'Assets' for a function loaded from Public/Assets/Get-HuduAsset.ps1.
#>
function Get-CommandArea {
    param([System.Management.Automation.FunctionInfo] $Command)

    $file = $Command.ScriptBlock.File
    if (-not $file) {
        return 'General'
    }

    $parent = Split-Path -Path (Split-Path -Path $file -Parent) -Leaf
    if ($parent -eq 'Public') { 'General' } else { $parent }
}

# pwsh -File passes arrays as a single string, so accept 'A,B,C' as well.
$ModuleName = @($ModuleName -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })

# Let RequiredModules (e.g. Hudu -> Core) resolve from the built output.
$env:PSModulePath = "$ArtifactsRoot$([System.IO.Path]::PathSeparator)$env:PSModulePath"

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$missingHelp = [System.Collections.Generic.List[string]]::new()
$indexRows = [System.Collections.Generic.List[string]]::new()
$navModules = [System.Collections.Generic.List[object]]::new()

foreach ($name in $ModuleName) {

    $module = Import-Module -Name (Join-Path $ArtifactsRoot $name) -Force -PassThru -ErrorAction Stop |
        Where-Object Name -EQ $name |
        Select-Object -First 1

    if ($module.ExportedFunctions.Count -eq 0) {
        Write-Host "Skipping $name (no exported functions)"
        continue
    }

    $outDir = Join-Path $DocsRoot $name
    if (Test-Path $outDir) {
        Remove-Item -Path $outDir -Recurse -Force
    }

    Write-Host "Generating docs for $name ($($module.ExportedFunctions.Count) commands)"

    $markdownParams = @{
        Module                = $name
        OutputFolder          = $outDir
        AlphabeticParamsOrder = $true
        ExcludeDontShow       = $true
        Encoding              = $utf8NoBom
        Force                 = $true
    }

    New-MarkdownHelp @markdownParams | Out-Null

    # --- Post-process command pages ------------------------------------------

    foreach ($file in Get-ChildItem -Path $outDir -Filter '*.md' -File) {

        $content = [System.IO.File]::ReadAllText($file.FullName)

        # PowerShell 7.4+ adds -ProgressAction as a common parameter; platyPS 0.14 documents it.
        $content = $content -replace ' \[-ProgressAction <ActionPreference>\]', ''
        $content = $content -replace '(?ms)^### -ProgressAction\r?\n.*?(?=^### |^## )', ''

        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)

        foreach ($match in [regex]::Matches($content, '\{\{[^}]+\}\}')) {
            $missingHelp.Add("$name/$($file.Name): $($match.Value)")
        }
    }

    # --- Group commands by area ---------------------------------------------

    $commands = foreach ($function in $module.ExportedFunctions.Values) {
        [pscustomobject]@{
            Name     = $function.Name
            Verb     = $function.Verb
            Noun     = $function.Noun
            Area     = Get-CommandArea -Command $function
            Synopsis = "$((Get-Help -Name $function.Name).Synopsis)".Trim()
        }
    }

    $areas = $commands |
        Group-Object -Property Area |
        Sort-Object -Property @{ Expression = { $_.Name -eq 'General' } }, Name |
        ForEach-Object {
            [pscustomobject]@{
                Title    = ConvertTo-AreaTitle -FolderName $_.Name
                Commands = @($_.Group | Sort-Object -Property Noun, Verb)
            }
        }

    $navModules.Add([pscustomobject]@{ Name = $name; Areas = @($areas) })

    # --- Module landing page ------------------------------------------------

    $page = [System.Collections.Generic.List[string]]::new()
    $page.Add("# $name")
    $page.Add('')
    if ($module.Description) {
        $page.Add($module.Description)
        $page.Add('')
    }
    $page.Add("**Version:** $($module.Version)")
    $page.Add('')

    foreach ($area in $areas) {
        $page.Add("## $($area.Title)")
        $page.Add('')
        $page.Add('| Command | Synopsis |')
        $page.Add('| ------- | -------- |')
        foreach ($command in $area.Commands) {
            $synopsis = $command.Synopsis -replace '\|', '\|' -replace '\r?\n', ' '
            $page.Add("| [$($command.Name)]($($command.Name).md) | $synopsis |")
        }
        $page.Add('')
    }

    [System.IO.File]::WriteAllText((Join-Path $outDir 'README.md'), ($page -join "`n"), $utf8NoBom)

    $indexRows.Add("| [$(ConvertTo-ModuleTitle -ModuleName $name)]($name/README.md) | $($module.Version) | $($module.ExportedFunctions.Count) | $($module.Description) |")
}

# --- Root index -----------------------------------------------------------------

$index = @(
    '# Boyles.PowerShell Command Reference'
    ''
    '> Generated from comment-based help by `build.ps1 -Task Docs`. Do not edit by hand.'
    ''
    '| Module | Version | Commands | Description |'
    '| ------ | ------- | -------- | ----------- |'
    $indexRows
    ''
) -join "`n"

[System.IO.File]::WriteAllText((Join-Path $DocsRoot 'README.md'), $index, $utf8NoBom)

# --- Site navigation --------------------------------------------------------------

if ($MkDocsConfig) {

    $nav = [System.Collections.Generic.List[string]]::new()
    $nav.Add('# --- BEGIN GENERATED NAV (build.ps1 -Task Docs) ---')
    $nav.Add('nav:')
    $nav.Add('  - Home: README.md')

    foreach ($navModule in $navModules) {
        $nav.Add("  - '$(ConvertTo-ModuleTitle -ModuleName $navModule.Name)':")
        $nav.Add("      - '$($navModule.Name)/README.md'")

        foreach ($area in $navModule.Areas) {
            $nav.Add("      - '$($area.Title)':")
            foreach ($command in $area.Commands) {
                $nav.Add("          - '$($command.Name)': '$($navModule.Name)/$($command.Name).md'")
            }
        }
    }

    $nav.Add('# --- END GENERATED NAV ---')
    $navBlock = $nav -join "`n"

    $config = [System.IO.File]::ReadAllText($MkDocsConfig)
    $pattern = '(?ms)^# --- BEGIN GENERATED NAV.*?^# --- END GENERATED NAV ---'

    if ([regex]::IsMatch($config, $pattern)) {
        $config = [regex]::Replace($config, $pattern, [System.Text.RegularExpressions.MatchEvaluator] { $navBlock })
    } else {
        $config = $config.TrimEnd() + "`n`n" + $navBlock + "`n"
    }

    [System.IO.File]::WriteAllText($MkDocsConfig, $config, $utf8NoBom)
    Write-Host "Navigation written to $MkDocsConfig"
}

# --- Report missing help ------------------------------------------------------------

if ($missingHelp.Count -gt 0) {
    $message = "Found $($missingHelp.Count) placeholder(s) indicating missing help:`n  " + ($missingHelp -join "`n  ")
    if ($FailOnMissingHelp) {
        throw $message
    }
    Write-Warning $message
}

Write-Host "Docs written to $DocsRoot"
