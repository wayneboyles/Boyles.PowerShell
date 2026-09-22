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
    $script:PackagesRoot = Join-Path -Path $ArtifactsRoot -ChildPath 'Packages'
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

Task default -Depends Build

Task Build -Depends BuildPowerShell

Task Test -Depends TestPowerShell

Task Full -Depends Build, Test

Task Init -Depends Clean {

    Write-Host 'Creating directories...'

    Confirm-Directory $ArtifactsRoot

    $ModuleNames | ForEach-Object {

        Confirm-Directory (Join-Path -Path $ArtifactsRoot -ChildPath $_)
        Write-Host "Created $ArtifactsRoot\$_"

        Confirm-Directory (Join-Path -Path $ArtifactsRoot -ChildPath $_, 'bin')
        Write-Host "Created $ArtifactsRoot\$_\bin"

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

    # Remove packages from the out directory

    Get-ChildItem -Path "$PackagesRoot\*.nupkg" | Remove-Item -Force

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

    Write-Host ''
}

Task BuildPowerShell -Depends BuildCSharp -PreCondition { -not $SkipBuild } {

    Write-Host 'Building PowerShell Modules...'

    $ModuleNames | ForEach-Object {

        $modulePath = Join-Path -Path (Get-ModuleSourcePath -ModuleName $_) -ChildPath 'Module'
        $moduleOutPath = Join-Path -Path $ArtifactsRoot -ChildPath $_

        Copy-Item -Path "$modulePath\*.psd1" -Destination $moduleOutPath
        Copy-Item -Path "$modulePath\*.psm1" -Destination $moduleOutPath

        try {
            Copy-Item -Path "$modulePath\bin\*.dll" -Destination "$moduleOutPath\bin"
        } catch {
            # Boyles.PowerShell doesn't have a bin directory.  Just ignore.
        }

        Get-ChildItem -Path $modulePath -Filter *.ps1 -Exclude *.Tests.ps1 -File -Recurse | ForEach-Object {
            $relativePath = $_.FullName.Substring($modulePath.Length).TrimStart('\')
            $destFile = Join-Path $moduleOutPath $relativePath

            $destDir = Split-Path $destFile -Parent
            if (-not (Test-Path $destDir)) {
                New-Item -ItemType Directory -Path $destDir -Force | Out-Null
            }

            Copy-Item $_.FullName -Destination $destFile -Force
        }
    }

    Write-Host ''

}

Task TestPowerShell -PreCondition { $RunPesterTests } {

    Write-Host 'Running Pester tests...'

    if (-not (Get-Module -ListAvailable -Name Pester | Where-Object { $_.Version -ge [version] '5.0.0' })) {
        throw 'Pester 5.0+ is required to run TestPowerShell. Install it with: Install-Module Pester -MinimumVersion 5.0 -Scope CurrentUser -Force'
    }

    Import-Module -Name Pester -MinimumVersion 5.0 -ErrorAction Stop -WarningAction SilentlyContinue

    $testFiles = Get-ChildItem -Path $SrcRoot -Filter '*.Tests.ps1' -File -Recurse

    if (-not $testFiles) {
        Write-Host 'No *.Tests.ps1 files found under src. Skipping.'
        Write-Host ''
        return
    }

    $pesterConfig = New-PesterConfiguration
    $pesterConfig.Run.Path = $SrcRoot
    $pesterConfig.Run.PassThru = $true
    $pesterConfig.Output.Verbosity = 'Detailed'

    $result = Invoke-Pester -Configuration $pesterConfig

    if ($result.FailedCount -gt 0) {
        throw "$($result.FailedCount) of $($result.TotalCount) Pester test(s) failed."
    }

    Write-Host ''
}

Task Package -Depends BuildPowerShell {

    Write-Host 'Creating NuGet packages...'

    Confirm-Directory $PackagesRoot

    # Publish-Module needs the NuGet package provider; install it quietly rather than
    # letting it prompt interactively on a fresh machine/build agent.
    if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -Scope CurrentUser | Out-Null
    }

    # Each module's manifest declares its sibling modules via RequiredModules
    # (e.g. Boyles.PowerShell.Hudu requires Boyles.PowerShell.Core). Publish-Module
    # only resolves RequiredModules against modules it can find on PSModulePath - it
    # does not look inside the repository it's publishing to - so the staged ./out
    # folder (already laid out as one PSModulePath-shaped folder per module) is
    # temporarily added to PSModulePath for the duration of packaging.
    $repoName = "BoylesPowerShellPackageLocal-$([guid]::NewGuid().ToString('N').Substring(0, 8))"
    $originalPSModulePath = $env:PSModulePath

    Register-PSRepository -Name $repoName -SourceLocation $PackagesRoot -PublishLocation $PackagesRoot -InstallationPolicy Trusted

    try {
        $env:PSModulePath = "$ArtifactsRoot$([System.IO.Path]::PathSeparator)$originalPSModulePath"

        # Published in dependency order (Core, then Hudu, then the Boyles.PowerShell
        # umbrella) so each module's RequiredModules can already be resolved from ./out
        # by the time its dependents are packaged.
        $ModuleNames | ForEach-Object {

            $moduleOutPath = Join-Path -Path $ArtifactsRoot -ChildPath $_

            Write-Host "Packaging $_"

            Publish-Module -Path $moduleOutPath -Repository $repoName -NuGetApiKey 'local' -Force
        }
    } finally {
        $env:PSModulePath = $originalPSModulePath
        Unregister-PSRepository -Name $repoName -ErrorAction SilentlyContinue
    }

    Write-Host ''
    Write-Host "Packages written to $PackagesRoot"
    Write-Host ''

    Write-Host 'Creating zip file...'
}
