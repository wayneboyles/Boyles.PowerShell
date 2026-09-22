#Requires -Version 5.1
<#
.SYNOPSIS
    Launches Test-Module.ps1 in a brand-new, detached PowerShell window.

.DESCRIPTION
    Used by the VS Code "Test-Module" build task (Ctrl+Shift+B). Running the
    test script in a separate process/window — rather than in VS Code's
    integrated terminal — means the module DLLs it loads aren't locked by a
    process tied to VS Code's lifetime. Close the spawned window when you're
    done to release the lock before your next build.
#>

$repoRoot = Split-Path -Path $PSScriptRoot -Parent
$scriptPath = Join-Path -Path $PSScriptRoot -ChildPath 'Test-Module.ps1'

$argumentList = @(
    '-NoExit'
    '-NoProfile'
    '-File'
    $scriptPath
)

Start-Process -FilePath 'pwsh' -ArgumentList $argumentList -WorkingDirectory $repoRoot
