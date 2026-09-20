$script:ModuleRoot = $PSScriptRoot
$script:BinPath = Join-Path -Path $script:ModuleRoot -ChildPath 'bin'
$script:BPSCompletionCache = [System.Collections.Concurrent.ConcurrentDictionary[string, object]]::new()

# =============================================================
# Load assemblies
# =============================================================

if (Test-Path -Path $script:BinPath) {

    $resolveHandler = [System.ResolveEventHandler] {
        param($senderArgs, $resolveEventArgs)

        $requestedName = [System.Reflection.AssemblyName]::new($resolveEventArgs.Name).Name
        $candidatePath = Join-Path -Path $script:BinPath -ChildPath "$requestedName.dll"

        if (Test-Path -Path $candidatePath) {
            return [System.Reflection.Assembly]::LoadFrom($candidatePath)
        }

        return $null
    }

    [System.AppDomain]::CurrentDomain.add_AssemblyResolve($resolveHandler)

    $coreAssemblyPath = Join-Path -Path $script:BinPath -ChildPath 'Boyles.PowerShell.Core.dll'

    if (Test-Path -Path $coreAssemblyPath) {
        Add-Type -Path $coreAssemblyPath -ErrorAction Stop
    } else {
        Write-Warning "Boyles.PowerShell.Core.dll was not found under '$script:BinPath'. Run build.ps1 from the repository root to compile the C# library before using this module."
    }
}

# =============================================================
# Type accelerators
# =============================================================

$TypeAcceleratorsClass = [psobject].Assembly.GetType('System.Management.Automation.TypeAccelerators')

# -- Add the accelerators

if (-not $TypeAcceleratorsClass::Get.ContainsKey('BodyProperty')) { $TypeAcceleratorsClass::Add('BodyProperty', [Boyles.PowerShell.Attributes.BodyPropertyAttribute]) }
if (-not $TypeAcceleratorsClass::Get.ContainsKey('BodyIgnore')) { $TypeAcceleratorsClass::Add('BodyIgnore', [Boyles.PowerShell.Attributes.BodyIgnoreAttribute]) }

if (-not $TypeAcceleratorsClass::Get.ContainsKey('QueryProperty')) { $TypeAcceleratorsClass::Add('QueryProperty', [Boyles.PowerShell.Attributes.QueryPropertyAttribute]) }
if (-not $TypeAcceleratorsClass::Get.ContainsKey('QueryIgnore')) { $TypeAcceleratorsClass::Add('QueryIgnore', [Boyles.PowerShell.Attributes.QueryIgnoreAttribute]) }

# -- Remove when the module is removed

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    $TypeAcceleratorsClass::Remove('BodyProperty') | Out-Null
    $TypeAcceleratorsClass::Remove('BodyIgnore') | Out-Null

    $TypeAcceleratorsClass::Remove('QueryProperty') | Out-Null
    $TypeAcceleratorsClass::Remove('QueryIgnore') | Out-Null
}.GetNewClosure()

# =============================================================
# Export functions
# =============================================================

$publicFunctions = @(Get-ChildItem -Path (Join-Path $script:ModuleRoot 'Public')  -Filter '*.ps1' -Exclude '*.Tests.ps1' -File -Recurse -ErrorAction SilentlyContinue)
$privateFunctions = @(Get-ChildItem -Path (Join-Path $script:ModuleRoot 'Private') -Filter '*.ps1' -Exclude '*.Tests.ps1' -File -Recurse -ErrorAction SilentlyContinue)

foreach ($functionFile in ($publicFunctions + $privateFunctions)) {
    try {
        . $functionFile.FullName
    } catch {
        throw "Failed to dot-source '$($functionFile.FullName)': $_"
    }
}

Export-ModuleMember -Function $publicFunctions.BaseName
