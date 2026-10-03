# Boyles.PowerShell

Umbrella module for the `Boyles.PowerShell` family. Importing this module imports
`Boyles.PowerShell.Core` plus every installed `Boyles.PowerShell.<Service>` module (e.g.
`Boyles.PowerShell.Hudu`) - the same "meta-module" pattern used by `Az` and `Microsoft.Graph`.

This module has no cmdlets of its own; it exists purely to pull every service module into the
session via `RequiredModules`.

## Install

```powershell
Install-Module -Name Boyles.PowerShell
Import-Module -Name Boyles.PowerShell
```

## Links

- [Project repository](https://github.com/wayneboyles/Boyles.PowerShell)
- [Command reference](https://wayneboyles.github.io/Boyles.PowerShell/)
