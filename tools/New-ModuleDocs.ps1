<#
.SYNOPSIS
    Generates Markdown reference documentation for the Boyles.PowerShell modules from their
    comment-based help.

.DESCRIPTION
    Imports each built module from the artifacts folder and runs platyPS New-MarkdownHelp against
    it, writing one Markdown file per exported command plus a module landing page (README.md) to
    docs/<ModuleName>/. Comment-based help is the source of truth, so each module's docs folder is
    deleted and fully regenerated on every run.

    After generation the output is post-processed to:
      - Fill in the module page description from the module manifest.
      - Strip the -ProgressAction common parameter that PowerShell 7.4+ leaks into platyPS 0.14 output.
      - Report any remaining platyPS '{{ ... }}' placeholders, which indicate missing help.

    A docs/README.md index linking every module is also generated.

.PARAMETER ArtifactsRoot
    Path to the build output folder containing one folder per built module (e.g. ./out).

.PARAMETER DocsRoot
    Path to the root docs folder. Each module is written to a subfolder named after the module.

.PARAMETER ModuleName
    Names of the modules to document. Accepts an array or a single comma-separated string (the
    latter so it can be passed through pwsh -File). Modules that export no functions are skipped.

.PARAMETER FailOnMissingHelp
    Throws if any generated file still contains platyPS placeholders. Without this switch the
    placeholders are reported as warnings.

.EXAMPLE
    .\tools\New-ModuleDocs.ps1 -ArtifactsRoot .\out -DocsRoot .\docs -ModuleName Boyles.PowerShell.Core, Boyles.PowerShell.Hudu

    Generates docs for the Core and Hudu modules from the built output in .\out.

.EXAMPLE
    .\tools\New-ModuleDocs.ps1 -ArtifactsRoot .\out -DocsRoot .\docs -ModuleName Boyles.PowerShell.Hudu -FailOnMissingHelp

    Generates the Hudu docs and fails if any command or parameter is missing help text.
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
    [switch] $FailOnMissingHelp
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Import-Module -Name platyPS -ErrorAction Stop

# pwsh -File passes arrays as a single string, so accept 'A,B,C' as well.
$ModuleName = @($ModuleName -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ })

# Let RequiredModules (e.g. Hudu -> Core) resolve from the built output.
$env:PSModulePath = "$ArtifactsRoot$([System.IO.Path]::PathSeparator)$env:PSModulePath"

$utf8NoBom = [System.Text.UTF8Encoding]::new($false)
$missingHelp = [System.Collections.Generic.List[string]]::new()
$indexRows = [System.Collections.Generic.List[string]]::new()

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
        WithModulePage        = $true
        ModulePagePath        = Join-Path $outDir 'README.md'
        Locale                = 'en-US'
        HelpVersion           = $module.Version.ToString()
        FwLink                = 'N/A'
        AlphabeticParamsOrder = $true
        ExcludeDontShow       = $true
        Encoding              = $utf8NoBom
        Force                 = $true
    }

    New-MarkdownHelp @markdownParams | Out-Null

    # --- Post-process -------------------------------------------------------

    foreach ($file in Get-ChildItem -Path $outDir -Filter '*.md' -File) {

        $content = [System.IO.File]::ReadAllText($file.FullName)

        # PowerShell 7.4+ adds -ProgressAction as a common parameter; platyPS 0.14 documents it.
        $content = $content -replace ' \[-ProgressAction <ActionPreference>\]', ''
        $content = $content -replace '(?ms)^### -ProgressAction\r?\n.*?(?=^### |^## )', ''

        if ($file.Name -eq 'README.md' -and $module.Description) {
            $content = $content -replace '\{\{ ?Fill in the Description ?\}\}', $module.Description
        }

        [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)

        foreach ($match in [regex]::Matches($content, '\{\{[^}]+\}\}')) {
            $missingHelp.Add("$name/$($file.Name): $($match.Value)")
        }
    }

    $indexRows.Add("| [$name]($name/README.md) | $($module.Version) | $($module.ExportedFunctions.Count) | $($module.Description) |")
}

# --- Root index ---------------------------------------------------------------

$index = @(
    '# Boyles.PowerShell Command Reference'
    ''
    '> Generated from comment-based help by `build.ps1 -Task Docs`. Do not edit by hand.'
    ''
    '| Module | Version | Commands | Description |'
    '| ------ | ------- | -------- | ----------- |'
    $indexRows
    ''
) -join [Environment]::NewLine

[System.IO.File]::WriteAllText((Join-Path $DocsRoot 'README.md'), $index, $utf8NoBom)

# --- Report missing help -------------------------------------------------------

if ($missingHelp.Count -gt 0) {
    $message = "Found $($missingHelp.Count) placeholder(s) indicating missing help:`n  " + ($missingHelp -join "`n  ")
    if ($FailOnMissingHelp) {
        throw $message
    }
    Write-Warning $message
}

Write-Host "Docs written to $DocsRoot"
