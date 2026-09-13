Properties {

    # Run configuration properties
    $script:Configuration = 'Debug'
    $script:SkipClean = $false

    # Path properties
    $script:RepoRoot = $PSScriptRoot
    $script:ArtifactsRoot = Join-Path -Path $RepoRoot -ChildPath 'out'

    # Propreties
    $script:ModuleSourceDirs = @()
    $script:ModuleSourceDirs += Get-ChildItem -Path (Join-Path $PSScriptRoot 'src') -Directory | Where-Object { Test-Path (Join-Path $_.FullName "$($_.Name).psd1") }
    $script:ModuleSourceDirs += Get-ChildItem -Path (Join-Path $PSScriptRoot 'src') -Directory | ForEach-Object {
        $moduleDir = Join-Path $_.FullName 'Module'
        if (Test-Path $moduleDir) {
            Get-Item -Path $moduleDir
        }
    } | Where-Object {
        $null -ne (Get-ChildItem -Path $_.FullName -Filter '*.psd1' -File | Select-Object -First 1)
    }

}

function Confirm-Directory {
    param(
        [string] $Path
    )
    process {
        if (-not (Test-Path $Path)) {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
        }
    }
}

FormatTaskName {
    param ($TaskName)
    Write-Host "===== [$($TaskName)] =====" -ForegroundColor Yellow
}

Task default -Depends Init

Task Init {

}

Task Clean {

}
