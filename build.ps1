<#
.SYNOPSIS
    Builds every C# library in this repo and stages the full Boyles.PowerShell
    module family into .\out so it can be imported for local testing.
.DESCRIPTION
    1. `dotnet build` the solution. Each module's .csproj has a post-build
       target that copies its compiled assembly (and dependencies) into its
       own src\<Module>\Module\bin folder.
    2. Stage every module's Module folder into .\out\<ModuleName>, producing a
       directory that behaves like a PSModulePath repository:
           out\Boyles.PowerShell\Boyles.PowerShell.psd1
           out\Boyles.PowerShell.Core\Boyles.PowerShell.Core.psd1
           out\Boyles.PowerShell.Hudu\Boyles.PowerShell.Hudu.psd1
    3. Optionally prepend .\out to $env:PSModulePath and Import-Module the
       umbrella module (-Import), for a quick smoke test.
.PARAMETER Configuration
    The dotnet build configuration. Defaults to Debug.
.PARAMETER Clean
    Remove .\out and every bin\obj folder before building.
.PARAMETER Import
    After staging, prepend .\out to PSModulePath and Import-Module -Force the
    umbrella Boyles.PowerShell module into the current session.
.EXAMPLE
    ./build.ps1 -Import
#>
[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('Debug', 'Release')]
    [string] $Configuration = 'Debug',

    [Parameter()]
    [switch] $Bootstrap,

    [Parameter()]
    [switch] $SetSecrets,

    [Parameter()]
    [string[]] $Task = 'Build',

    [Parameter()]
    [switch] $Clean
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($Bootstrap) {
    Write-Host 'Bootstrapping build dependencies...' -ForegroundColor Cyan

    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

    if (-not (Get-Module -Name PSDepend -ListAvailable)) {
        Install-Module -Name PSDepend -Scope CurrentUser -Force
    }

    Import-Module PSDepend
    Invoke-PSDepend -Path "$PSScriptRoot/requirements.psd1" -Install -Import -Force

    Write-Host 'Bootstrap complete.' -ForegroundColor Green
    Write-Host ''

    exit 0
}

if ($SetSecrets) {
    Write-Host 'Creating secrets vault for testing...' -ForegroundColor Cyan
    Write-Host ''

    if (-not (Get-Module -Name 'Microsoft.PowerShell.SecretManagement' -ListAvailable) -or -not (Get-Module -Name 'Microsoft.PowerShell.SecretStore' -ListAvailable)) {
        throw 'Run .\build.ps1 -Bootstrap to install the required dependencies.'
    }

    $VaultName = 'Boyles.PowerShell'

    $Vault = Get-SecretVault -Name $VaultName -ErrorAction SilentlyContinue
    if ($null -eq $Vault) {
        $Vault = Register-SecretVault -Name $VaultName -ModuleName Microsoft.PowerShell.SecretStore
    }

    $huduBaseUrl = Read-Host 'Enter the Hudu Base URL'
    $huduApiKey = Read-Host 'Enter the Hudu API Key'

    Set-Secret -Name 'Hudu.BaseUrl' -Vault $VaultName -Secret $huduBaseUrl
    Set-Secret -Name 'Hudu.ApiKey' -Vault $VaultName -Secret $huduApiKey

    Write-Host 'Secrets set.' -ForegroundColor Cyan
    Write-Host ''

    exit 0
}

$ModuleSourceDirs = @()
$ModuleSourceDirs += Get-ChildItem -Path (Join-Path $PSScriptRoot 'src') -Directory | Where-Object { Test-Path (Join-Path $_.FullName "$($_.Name).psd1") }
$ModuleSourceDirs += Get-ChildItem -Path (Join-Path $PSScriptRoot 'src') -Directory | ForEach-Object {
    $moduleDir = Join-Path $_.FullName 'Module'
    if (Test-Path $moduleDir) {
        Get-Item -Path $moduleDir
    }
} | Where-Object {
    $null -ne (Get-ChildItem -Path $_.FullName -Filter '*.psd1' -File | Select-Object -First 1)
}

Import-Module -Name psake -ErrorAction Stop

# Build the properties to pass to psake script
$Properties = @{
    Configuration = $Configuration
}

Invoke-Psake -BuildFile "$PSScriptRoot/psakefile.ps1" -TaskList $Task -Properties $Properties -NoLogo

exit ([int](-not $psake.build_success))
















exit 0
$repoRoot = $PSScriptRoot
$outRoot = Join-Path $repoRoot 'out'

if ($Clean) {
    Write-Host 'Cleaning previous build output...' -ForegroundColor Cyan
    if (Test-Path $outRoot) {
        Remove-Item -Path $outRoot -Recurse -Force
    }
    Get-ChildItem -Path $repoRoot -Include 'bin', 'obj' -Recurse -Directory |
        Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "Building solution ($Configuration)..." -ForegroundColor Cyan
#dotnet build (Join-Path $repoRoot 'Boyles.PowerShell.slnx') --configuration $Configuration
#if ($LASTEXITCODE -ne 0) {
#    throw "dotnet build failed with exit code $LASTEXITCODE."
#}

# Every "module" directory under src\ is either the umbrella module itself
# (src\Boyles.PowerShell) or a <Service>\Module folder (src\Core\Module,
# src\Hudu\Module, ...). Discover both shapes rather than hardcoding names,
# so a new module scaffolded by tools\New-BoylesSubmodule.ps1 is picked up
# automatically.
$moduleSourceDirs = @()
$moduleSourceDirs += Get-ChildItem -Path (Join-Path $repoRoot 'src') -Directory | Where-Object { Test-Path (Join-Path $_.FullName "$($_.Name).psd1") }
$moduleSourceDirs += Get-ChildItem -Path (Join-Path $repoRoot 'src') -Directory | ForEach-Object {
    $moduleDir = Join-Path $_.FullName 'Module'
    if (Test-Path $moduleDir) {
        Get-Item -Path $moduleDir
    }
} | Where-Object {
    (Get-ChildItem -Path $_.FullName -Filter '*.psd1' -File).Count -gt 0
}

Write-Host $moduleSourceDirs

exit 0

if (-not (Test-Path $outRoot)) {
    New-Item -Path $outRoot -ItemType Directory | Out-Null
}

foreach ($moduleDir in $moduleSourceDirs) {
    $manifest = Get-ChildItem -Path $moduleDir.FullName -Filter '*.psd1' -File | Select-Object -First 1
    $moduleName = $manifest.BaseName
    $destination = Join-Path $outRoot $moduleName

    Write-Host "Staging $moduleName -> out\$moduleName" -ForegroundColor DarkCyan
    if (Test-Path $destination) {
        Remove-Item -Path $destination -Recurse -Force
    }
    Copy-Item -Path $moduleDir.FullName -Destination $destination -Recurse -Force
}

Write-Host "Build complete. Staged modules are in '$outRoot'." -ForegroundColor Green

if ($Import) {
    if ($env:PSModulePath -notlike "*$outRoot*") {
        $env:PSModulePath = "$outRoot$([System.IO.Path]::PathSeparator)$env:PSModulePath"
    }

    Import-Module -Name (Join-Path $outRoot 'Boyles.PowerShell\Boyles.PowerShell.psd1') -Force -Verbose
}
