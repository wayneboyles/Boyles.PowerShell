[CmdletBinding()]
param (
    [Parameter()]
    [ValidateSet('Hudu')]
    [string] $Environment,

    [Parameter()]
    [ValidateSet('Debug', 'Release')]
    [string] $Configuration = 'Debug',

    [Parameter()]
    [switch] $Force
)

#===========================================================================
# VARIABLES
#===========================================================================

$ModuleNames = @(
    'Boyles.PowerShell.Core'
    'Boyles.PowerShell.Hudu'
    'Boyles.PowerShell'
)

$RepoRoot = Split-Path -Path $PSScriptRoot -Parent
$SrcRoot = Join-Path -Path $RepoRoot -ChildPath 'src'

#===========================================================================
# FUNCTIONS
#===========================================================================

function Import-DevModule {
    param (
        [Parameter(Mandatory)]
        [string] $ManifestPath,

        [Parameter(Mandatory)]
        [string] $ModuleName,

        [Parameter()]
        [switch] $Force
    )

    $importParams = @{
        Name                = $ManifestPath
        Global              = $true   # make exports available outside this script scope
        DisableNameChecking = $true
        ErrorAction         = 'Stop'
    }

    if ($Force) {
        $importParams['Force'] = $true
    }

    Write-Host "  Importing $ModuleName" -NoNewline
    Write-Host " ($ManifestPath)" -ForegroundColor DarkGray

    Import-Module @importParams

    Write-Host '  OK ' -ForegroundColor Green -NoNewline
    Write-Host $ModuleName
}

#===========================================================================
# EXECUTION
#===========================================================================

Set-StrictMode -Version Latest

# Header
Write-Host ''
Write-Host 'Boyles.PowerShell  —  development module loader' -ForegroundColor Cyan
Write-Host "Configuration : $Configuration"
Write-Host "Repo root     : $RepoRoot"
Write-Host ''

# Kick off a build so we have fresh modules to import
try {
    Push-Location $RepoRoot

    $Tasks = @('BuildCSharp')
    $Properties = @{
        Configuration = 'Debug'
    }

    Invoke-Psake -BuildFile .\psakefile.ps1 -Properties $Properties -TaskList $Tasks
} finally {
    Pop-Location
}

# Import the modules

#------------------------------------------------------------------------------
# 1. Boyles.PowerShell.Core  (must come first — Hudu depends on it)
#------------------------------------------------------------------------------

$coreManifest = Join-Path -Path $SrcRoot -ChildPath 'Boyles.PowerShell.Core', 'Module', 'Boyles.PowerShell.Core.psd1'

if (-not (Test-Path $coreManifest)) {
    throw (
        "Manifest not found for 'Boyles.PowerShell.Core'.`n" +
        "Expected : $coreManifest`n" +
        "Run      : Invoke-psake Build    (or: .\build.ps1 -Task Build)`n" +
        'Then re-run this script.'
    )
}

Import-DevModule -ManifestPath $coreManifest -ModuleName 'Boyles.PowerShell.Core' -Force:$Force

#------------------------------------------------------------------------------
# 2. Boyles.PowerShell.Hudu
#------------------------------------------------------------------------------

$huduManifest = Join-Path -Path $SrcRoot -ChildPath 'Boyles.PowerShell.Hudu', 'Module', 'Boyles.PowerShell.Hudu.psd1'

if (-not (Test-Path $huduManifest)) {
    throw (
        "Manifest not found for 'Boyles.PowerShell.Hudu'.`n" +
        "Expected : $huduManifest`n" +
        "Run      : Invoke-psake Build    (or: .\build.ps1 -Task Build)`n" +
        'Then re-run this script.'
    )
}

Import-DevModule -ManifestPath $huduManifest -ModuleName 'Boyles.PowerShell.Hudu' -Force:$Force

#------------------------------------------------------------------------------
# 3. Confirmation
#------------------------------------------------------------------------------

Write-Host ''
Write-Host 'Loaded commands:' -ForegroundColor Cyan

Get-Command -Module 'Boyles.PowerShell.Core', 'Boyles.PowerShell.Hudu' |
    Sort-Object -Property Noun, Verb |
    Format-Table -Property Verb, Noun, Module -AutoSize

Write-Host 'Module session ready.  Use Get-Help <CmdletName> to explore.' -ForegroundColor Cyan
Write-Host ''

#------------------------------------------------------------------------------
# 4. Connect
#------------------------------------------------------------------------------

Write-Host 'Connecting to Hudu' -ForegroundColor Cyan

$HuduBaseUrl = Get-Secret -Name 'Hudu.BaseUrl' -Vault 'Boyles.PowerShell' | ConvertFrom-SecureString -AsPlainText
$HuduApiKey = Get-Secret -Name 'Hudu.ApiKey' -Vault 'Boyles.PowerShell' | ConvertFrom-SecureString -AsPlainText

Connect-Hudu -BaseUrl $HuduBaseUrl -ApiKey $HuduApiKey

Write-Host 'Connected to Hudu!' -ForegroundColor Cyan

Write-Host ''
