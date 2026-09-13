
Set-StrictMode -Version Latest

$ErrorActionPreference = 'Stop'

# Everything this module needs is pulled in via RequiredModules in the .psd1.
# This file just confirms what actually loaded, for -Verbose diagnostics.
$loadedServiceModules = Get-Module -Name 'Boyles.PowerShell.*' | Select-Object -ExpandProperty Name
Write-Verbose "Boyles.PowerShell umbrella module loaded. Active modules: $($loadedServiceModules -join ', ')"
