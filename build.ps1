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
    [string[]] $Task = 'Build'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($Bootstrap) {
    Write-Host ''
    Write-Host 'Bootstrapping build dependencies...' -ForegroundColor Cyan

    Get-PackageProvider -Name NuGet -ForceBootstrap | Out-Null
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

    if (-not (Get-Module -Name PSDepend -ListAvailable)) {
        Install-Module -Name PSDepend -Scope CurrentUser -Force
    }

    Import-Module PSDepend
    Invoke-PSDepend -Path "$PSScriptRoot/requirements.psd1" -Install -Import -Force

    Write-Host 'Bootstrap complete.' -ForegroundColor Cyan
    Write-Host ''

    exit 0
}

if ($SetSecrets) {
    Write-Host ''
    Write-Host 'Creating secrets vault for testing...' -ForegroundColor Cyan

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
    Configuration  = $Configuration
    RunCSharpTests = $false
    RunPesterTests = $false
    SkipBuild      = $false
    SkipClean      = $false
}

Invoke-Psake -BuildFile "$PSScriptRoot/psakefile.ps1" -TaskList $Task -Properties $Properties -NoLogo

exit ([int](-not $psake.build_success))
