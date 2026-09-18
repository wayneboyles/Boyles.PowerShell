$script:ModuleRoot = $PSScriptRoot
$script:BinPath = Join-Path -Path $script:ModuleRoot -ChildPath 'bin'
$script:BPSCompletionCache = [System.Collections.Concurrent.ConcurrentDictionary[string, object]]::new()

# Resolve any dependency DLL (e.g. System.Text.Json.dll) that ships alongside
# the compiled module library, since the PowerShell host's own probing path
# won't include this module's bin folder.
if (Test-Path -Path $script:BinPath) {
    $resolveHandler = [System.ResolveEventHandler] {
        param($sender, $resolveEventArgs)

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
    }
    else {
        Write-Warning "Boyles.PowerShell.Core.dll was not found under '$script:BinPath'. Run build.ps1 from the repository root to compile the C# library before using this module."
    }
}

# Dot-source every function script and export only the Public ones. Co-located Pester tests
# (Function.Tests.ps1, living next to the function they test) are excluded - they aren't functions.
$publicFunctions  = @(Get-ChildItem -Path (Join-Path $script:ModuleRoot 'Public')  -Filter '*.ps1' -Exclude '*.Tests.ps1' -File -Recurse -ErrorAction SilentlyContinue)
$privateFunctions = @(Get-ChildItem -Path (Join-Path $script:ModuleRoot 'Private') -Filter '*.ps1' -Exclude '*.Tests.ps1' -File -Recurse -ErrorAction SilentlyContinue)

foreach ($functionFile in ($publicFunctions + $privateFunctions)) {
    try {
        . $functionFile.FullName
    }
    catch {
        throw "Failed to dot-source '$($functionFile.FullName)': $_"
    }
}

Export-ModuleMember -Function $publicFunctions.BaseName
