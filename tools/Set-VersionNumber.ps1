<#
.SYNOPSIS
    Sets the version number across every module manifest and the shared C# version property.

.DESCRIPTION
    Updates ModuleVersion in each service/umbrella module's .psd1 manifest under src/ (including the
    ModuleVersion pins inside RequiredModules dependency entries), and updates the <Version> property
    in src/common.props, which every module .csproj imports for AssemblyVersion/FileVersion.

.PARAMETER Version
    The new version number, in major.minor.patch (0.0.0) format.

.EXAMPLE
    ./tools/Set-VersionNumber.ps1 -Version 0.4.0

.EXAMPLE
    ./tools/Set-VersionNumber.ps1 -Version 1.0.0 -WhatIf
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory)]
    [ValidatePattern('^\d+\.\d+\.\d+$', ErrorMessage = "'{0}' is not a valid version. Expected format: 0.0.0")]
    [string]$Version
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
$versionPattern = '\d+\.\d+\.\d+'

function Update-FileVersion {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)] [string]$Path,
        [Parameter(Mandatory)] [string]$Pattern,
        [Parameter(Mandatory)] [string]$NewVersion
    )

    # Read/write via raw bytes so encoding (e.g. a UTF-8 BOM on common.props) round-trips untouched;
    # Get-Content/Set-Content would otherwise silently drop the BOM.
    $bytes = [System.IO.File]::ReadAllBytes($Path)
    $hasBom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
    $encoding = [System.Text.UTF8Encoding]::new($hasBom)
    $content = $encoding.GetString($bytes)
    if ($hasBom -and $content.Length -gt 0 -and $content[0] -eq [char]0xFEFF) {
        $content = $content.Substring(1)
    }

    $matchCount = ([regex]::Matches($content, $Pattern)).Count

    if ($matchCount -eq 0) {
        Write-Warning "No version references matched in $Path"
        return
    }

    $evaluator = {
        param($match)
        $match.Groups[1].Value + $NewVersion + $match.Groups[2].Value
    }

    $updated = [regex]::Replace($content, $Pattern, $evaluator)

    if ($PSCmdlet.ShouldProcess($Path, "Set version to $NewVersion ($matchCount reference(s))")) {
        [System.IO.File]::WriteAllText($Path, $updated, $encoding)
        Write-Host "Updated $matchCount reference(s) in $Path" -ForegroundColor Green
    }
}

# Every module manifest: top-level ModuleVersion plus ModuleVersion pins inside RequiredModules entries.
$psd1Files = Get-ChildItem -Path (Join-Path $repoRoot 'src') -Filter '*.psd1' -Recurse -File
$moduleVersionPattern = "(ModuleVersion\s*=\s*')$versionPattern(')"

foreach ($file in $psd1Files) {
    Update-FileVersion -Path $file.FullName -Pattern $moduleVersionPattern -NewVersion $Version
}

# common.props: the single <Version> property every module .csproj imports for the C# assemblies.
$propsPath = Join-Path $repoRoot 'src\common.props'
$propsPattern = "(<Version>)$versionPattern(</Version>)"

Update-FileVersion -Path $propsPath -Pattern $propsPattern -NewVersion $Version
