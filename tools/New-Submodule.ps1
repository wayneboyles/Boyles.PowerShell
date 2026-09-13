<#
.SYNOPSIS
    Scaffolds a new Boyles.PowerShell.<ServiceName> service module: a C#
    class library plus its paired PowerShell module folder, wired into the
    solution and referencing Boyles.PowerShell.Core.

.DESCRIPTION
    Mirrors the layout already used by src\Hudu:
        src\<ServiceName>\Boyles.PowerShell.<ServiceName>.csproj
        src\<ServiceName>\Services\
        src\<ServiceName>\Models\
        src\<ServiceName>\Module\Boyles.PowerShell.<ServiceName>.psd1
        src\<ServiceName>\Module\Boyles.PowerShell.<ServiceName>.psm1
        src\<ServiceName>\Module\Public\
        src\<ServiceName>\Module\Private\
        src\<ServiceName>\Module\en-US\
        src\<ServiceName>\Module\bin\

    Adds the new .csproj to Boyles.PowerShell.sln and references
    Boyles.PowerShell.Core. Does NOT touch src\Boyles.PowerShell\Boyles.PowerShell.psd1

    Add the new module to its RequiredModules by hand once it's ready to
    ship, the same way each Az.* module is added to Az.psd1 deliberately.

.PARAMETER ServiceName
    The service's short name, e.g. 'ITGlue'. Produces Boyles.PowerShell.ITGlue.

.EXAMPLE
    ./tools/New-BoylesSubmodule.ps1 -ServiceName ITGlue
#>
[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [ValidatePattern('^[A-Za-z][A-Za-z0-9]*$')]
    [string]$ServiceName
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$testRoot = Join-Path -Path $repoRoot -ChildPath 'test'
$moduleFullName = "Boyles.PowerShell.$ServiceName"
$serviceRoot = Join-Path $repoRoot "src\Boyles.PowerShell.$ServiceName"

if (Test-Path $serviceRoot) {
    throw "'$serviceRoot' already exists - pick a different -ServiceName or remove it first."
}

Write-Host "Scaffolding $moduleFullName under src\Boyles.PowerShell.$ServiceName ..." -ForegroundColor Cyan

New-Item -Path $serviceRoot -ItemType Directory | Out-Null
foreach ($sub in 'Services', 'Models', 'Module\Public', 'Module\Private', 'Module\en-US', 'Module\bin') {
    New-Item -Path (Join-Path $serviceRoot $sub) -ItemType Directory | Out-Null
}

$csprojPath = Join-Path $serviceRoot "$moduleFullName.csproj"
@"
<Project Sdk="Microsoft.NET.Sdk">

    <PropertyGroup>
        <TargetFramework>netstandard2.0</TargetFramework>
        <AssemblyName>$moduleFullName</AssemblyName>
        <RootNamespace>$moduleFullName</RootNamespace>
        <Description>$ServiceName API client and models backing the $moduleFullName cmdlets.</Description>
    </PropertyGroup>

    <ItemGroup>
        <ProjectReference Include="..\Boyles.PowerShell.Core\Boyles.PowerShell.Core.csproj" />
    </ItemGroup>

    <Target Name="CopyToPowerShellModule" AfterTargets="Build">
        <ItemGroup>
            <ModuleBinOutput Include="`$(TargetDir)**\*.dll" />
            <!--<ModuleBinOutput Include="`$(TargetDir)**\*.pdb" />-->
        </ItemGroup>
        <Copy SourceFiles="@(ModuleBinOutput)" DestinationFolder="`$(MSBuildProjectDirectory)\Module\bin\%(RecursiveDir)" SkipUnchangedFiles="true" />
    </Target>

</Project>
"@ | Set-Content -Path $csprojPath -Encoding utf8

$testProjPath = Join-Path $testRoot "$moduleFullName"


$psm1Path = Join-Path $serviceRoot "Module\$moduleFullName.psm1"
@"
`$script:ModuleRoot = `$PSScriptRoot
`$script:BinPath = Join-Path -Path `$script:ModuleRoot -ChildPath 'bin'

# RequiredModules in the manifest guarantees Boyles.PowerShell.Core is already
# imported (and its types loaded) by the time this file runs.
if (Test-Path -Path `$script:BinPath) {
    `$resolveHandler = [System.ResolveEventHandler] {
        param(`$sender, `$resolveEventArgs)

        `$requestedName = [System.Reflection.AssemblyName]::new(`$resolveEventArgs.Name).Name
        `$candidatePath = Join-Path -Path `$script:BinPath -ChildPath "`$requestedName.dll"

        if (Test-Path -Path `$candidatePath) {
            return [System.Reflection.Assembly]::LoadFrom(`$candidatePath)
        }

        return `$null
    }
    [System.AppDomain]::CurrentDomain.add_AssemblyResolve(`$resolveHandler)

    `$assemblyPath = Join-Path -Path `$script:BinPath -ChildPath '$moduleFullName.dll'
    if (Test-Path -Path `$assemblyPath) {
        Add-Type -Path `$assemblyPath -ErrorAction Stop
    }
    else {
        Write-Warning "$moduleFullName.dll was not found under '`$script:BinPath'. Run build.ps1 from the repository root to compile the C# library before using this module."
    }
}

`$publicFunctions  = @(Get-ChildItem -Path (Join-Path `$script:ModuleRoot 'Public')  -Filter '*.ps1' -File -Recurse -ErrorAction SilentlyContinue)
`$privateFunctions = @(Get-ChildItem -Path (Join-Path `$script:ModuleRoot 'Private') -Filter '*.ps1' -File -Recurse -ErrorAction SilentlyContinue)

foreach (`$functionFile in (`$publicFunctions + `$privateFunctions)) {
    try {
        . `$functionFile.FullName
    }
    catch {
        throw "Failed to dot-source '`$(`$functionFile.FullName)': `$_"
    }
}

Export-ModuleMember -Function `$publicFunctions.BaseName
"@ | Set-Content -Path $psm1Path -Encoding utf8

$guid = [guid]::NewGuid().ToString()
$psd1Path = Join-Path $serviceRoot "Module\$moduleFullName.psd1"
@"
@{
    RootModule        = '$moduleFullName.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = '$guid'
    Author            = 'Wayne Boyles'
    CompanyName       = 'Boyles'
    Copyright         = '(c) Wayne Boyles. All rights reserved.'
    Description       = 'Cmdlets for interacting with $ServiceName, built on Boyles.PowerShell.Core for authentication and HTTP handling.'

    PowerShellVersion = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')

    RequiredModules   = @(
        @{ ModuleName = 'Boyles.PowerShell.Core'; ModuleVersion = '0.1.0'; GUID = "5b06397d-8350-4a54-8751-b7e44f80adb2" }
    )

    FunctionsToExport = @()
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    FileList          = @(
        '$moduleFullName.psm1'
        '$moduleFullName.psd1'
    )

    PrivateData       = @{
        PSData = @{
            Tags         = @('Boyles', 'PowerShell', 'API', '$ServiceName')
            ProjectUri   = ''
            LicenseUri   = ''
            ReleaseNotes = 'Initial scaffold.'
        }
    }
}
"@ | Set-Content -Path $psd1Path -Encoding utf8

$aboutPath = Join-Path $serviceRoot "Module\en-US\about_$moduleFullName.help.txt"
@"
TOPIC
    about_$moduleFullName

SHORT DESCRIPTION
    Cmdlets for interacting with $ServiceName.

LONG DESCRIPTION
    $moduleFullName is a service module in the Boyles.PowerShell family. It
    depends on Boyles.PowerShell.Core for connection management,
    authentication, and HTTP handling (see about_Boyles.PowerShell.Core).

SEE ALSO
    about_Boyles.PowerShell.Core
"@ | Set-Content -Path $aboutPath -Encoding utf8

New-Item -Path (Join-Path $serviceRoot 'Module\Private\.gitkeep') -ItemType File | Out-Null

Push-Location $repoRoot
try {
    dotnet sln 'Boyles.PowerShell.slnx' add $csprojPath | Out-Null
} finally {
    Pop-Location
}

Write-Host 'Done. Next steps:' -ForegroundColor Green
Write-Host "  1. Add cmdlets under src\$ServiceName\Module\Public\ and API/model code under src\$ServiceName\Services\ and \Models\."
Write-Host "  2. Add '$moduleFullName' to FunctionsToExport in Module\$moduleFullName.psd1 as cmdlets are added."
Write-Host '  3. Once ready to ship it as part of the umbrella, add it to RequiredModules in src\Boyles.PowerShell\Boyles.PowerShell.psd1.'
Write-Host '  4. Run ./build.ps1 -Import to build and smoke-test.'
