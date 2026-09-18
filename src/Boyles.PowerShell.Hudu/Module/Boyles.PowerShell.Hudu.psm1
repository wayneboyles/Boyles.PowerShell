$script:ModuleRoot = $PSScriptRoot
$script:BinPath = Join-Path -Path $script:ModuleRoot -ChildPath 'bin'

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

    $assemblyPath = Join-Path -Path $script:BinPath -ChildPath 'Boyles.PowerShell.Hudu.dll'

    if (Test-Path -Path $assemblyPath) {
        Add-Type -Path $assemblyPath -ErrorAction Stop
    } else {
        Write-Warning "Boyles.PowerShell.Hudu.dll was not found under '$script:BinPath'. Run build.ps1 from the repository root to compile the C# library before using this module."
    }

}

# =============================================================
# Export functions
# =============================================================

# Co-located Pester tests (Function.Tests.ps1, living next to the function they test) are
# excluded - they aren't functions.
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

# =============================================================
# Argument completers
# =============================================================

Register-BPSArgumentCompleter -CommandName Get-HuduCompany -ParameterName Name -CacheSeconds 300 -ValueProperty Name -ToolTipProperty Id -ValueProvider {
    (Get-HuduClientInternal).GetCompanies()
}
