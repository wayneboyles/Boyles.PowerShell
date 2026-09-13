Properties {

    # Run configuration properties
    $script:Configuration = 'Debug'
    $script:SkipClean = $false
    $script:RunCSharpTests = $true
    $script:RunPesterTests = $true
    $script:SkipBuild = $false
    $script:SkipClean = $false

    # Path properties
    $script:RepoRoot = $PSScriptRoot
    $script:ArtifactsRoot = Join-Path -Path $RepoRoot -ChildPath 'out'
    $script:DocsRoot = Join-Path -Path $RepoRoot -ChildPath 'docs'
    $script:SrcRoot = Join-Path -Path $RepoRoot -ChildPath 'src'

    # Propreties
    $script:ModuleNames = @(
        'Boyles.PowerShell.Core'
        'Boyles.PowerShell.Hudu'
        'Boyles.PowerShell'
    )

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

#==============================================================================
# FUNCTIONS
#==============================================================================

function Confirm-Directory {
    param([string] $Path)
    process {
        if (-not (Test-Path $Path)) {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
        }
    }
}

function Get-ModuleSourcePath {
    param([string] $ModuleName)
    Join-Path $SrcRoot $ModuleName
}

function Get-CSharpProjectPath {
    param([string] $ModuleName)
    $moduleSrc = Get-ModuleSourcePath -ModuleName $ModuleName
    Join-Path -Path $moduleSrc -ChildPath "$ModuleName.csproj"
}

function Get-PowerShellModulePath {
    param([string] $ModuleName)
    $moduleSrc = Get-ModuleSourcePath -ModuleName $ModuleName
    Join-Path -Path $moduleSrc -ChildPath 'Module'
}

function Get-TestProjectPath {
    param([string] $ModuleName)
    Join-Path $RepoRoot -ChildPath 'Test', "$ModuleName", "$ModuleName.Tests.csproj"
}

function Test-HasCSharpProject {
    param([string] $ModuleName)
    Test-Path (Get-CSharpProjectPath -ModuleName $ModuleName)
}

function Test-HasTestProject {
    param([string] $ModuleName)
    Test-Path (Get-TestProjectPath -ModuleName $ModuleName)
}

function Test-HasPowerShellModule {
    param([string] $ModuleName)
    Test-Path (Get-PowerShellModulePath -ModuleName $ModuleName)
}

function Invoke-ExternalCommand {
    param(
        [string]   $Executable,
        [string[]] $Arguments
    )

    & $Executable @Arguments | Out-Null

    if ($LASTEXITCODE -ne 0) {
        throw "'$Executable $($Arguments -join ' ')' failed with exit code $LASTEXITCODE."
    }
}

#==============================================================================
# CONFIGURATION
#==============================================================================

FormatTaskName {
    param ($TaskName)
    Write-Host "[$($TaskName)]" -ForegroundColor Yellow
}

#==============================================================================
# TASKS
#==============================================================================

Task default -Depends Init

Task Init -Depends Clean {

    Write-Host 'Creating directories...'

    Confirm-Directory $ArtifactsRoot

    $ModuleNames | ForEach-Object {
        Confirm-Directory (Join-Path -Path $ArtifactsRoot -ChildPath $_)
        Write-Host "Created $ArtifactsRoot\$_"

        # Make sure the 'bin' folder exists in the module
        $BinDir = Join-Path (Get-PowerShellModulePath -ModuleName $_) -ChildPath 'bin'
        if (-not (Test-Path -Path $BinDir)) {
            if ($_ -ne 'Boyles.PowerShell') {
                Confirm-Directory $BinDir
            }
        }
    }

    Write-Host ''
}

Task Clean -PreCondition { -not $SkipClean } {

    Write-Host 'Cleaning output directories...'

    $ModuleNames | ForEach-Object {
        $ModulePath = Join-Path -Path $ArtifactsRoot -ChildPath $_

        # Delete the output dir folders with the module files
        # in it

        if (Test-Path -Path $ModulePath) {
            Remove-Item -Path $ModulePath -Recurse -Force
            Write-Host "Removed $ModulePath"
        }

        # Delete the C# project bin and obj folders

        if (Test-HasCSharpProject -ModuleName $_) {
            $BinDir = Join-Path -Path (Get-ModuleSourcePath -ModuleName $_) -ChildPath 'bin'
            $ObjDir = Join-Path -Path (Get-ModuleSourcePath -ModuleName $_) -ChildPath 'obj'

            foreach ($Dir in @($BinDir, $ObjDir)) {
                if (Test-Path $Dir) {
                    Remove-Item -Path $Dir -Recurse -Force
                    Write-Host "Removed $Dir"
                }
            }
        }

        # Remove the C# binaries from the module bin dir

        $BinDir = Join-Path -Path (Get-PowerShellModulePath -ModuleName $_) -ChildPath 'bin'
        if (Test-Path -Path $BinDir) {
            Get-ChildItem -Path $BinDir | Remove-Item -Force -Recurse
            Write-Host "Removed $BinDir"
        }
    }

    Write-Host ''
}

Task BuildCSharp -Depends Init -PreCondition { -not $SkipBuild } {

    Write-Host 'Building C# Projects...'

    $ModuleNames | ForEach-Object {

        if (-not (Test-HasCSharpProject -ModuleName $_)) {
            continue
        }

        $projPath = Get-CSharpProjectPath -ModuleName $_

        Write-Host "Building $_"

        Invoke-ExternalCommand -Executable 'dotnet' -Arguments @(
            'build'
            $projPath
            '--configuration', $Configuration
            '--no-self-contained'
            '/p:GeneratePackageOnBuild=false'
        )
    }
}
