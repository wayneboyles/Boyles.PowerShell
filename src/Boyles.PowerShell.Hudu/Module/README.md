# Boyles.PowerShell.Hudu

Cmdlets for interacting with [Hudu](https://www.hudu.com/), built on `Boyles.PowerShell.Core` for
authentication, HTTP transport, and retry/pagination handling.

## What's in here

Get/New/Set/Remove (and, for some resources, Enable/Disable) cmdlets covering Hudu's companies,
assets, asset layouts, passwords, articles, folders, flags, labels, lists, Magic Dash entries, and
more. Each resource is backed by a matching partial `HuduClient` class in the underlying C# library.

## Install

```powershell
Install-Module -Name Boyles.PowerShell.Hudu
```

## Getting started

```powershell
Connect-Hudu -BaseUrl 'https://yourinstance.huducloud.com' -ApiKey $apiKey
Get-HuduCompany
```

## Links

- [Project repository](https://github.com/wayneboyles/Boyles.PowerShell)
- [Command reference](https://wayneboyles.github.io/Boyles.PowerShell/Boyles.PowerShell.Hudu/)
