# Boyles.PowerShell.Core

Shared authentication, HTTP connection, and context primitives for the Boyles.PowerShell module family. Every Boyles.PowerShell.* service module depends on this module, the same way Az.* modules depend on Az.Accounts.

**Version:** 0.3.0

## Banner

| Command | Synopsis |
| ------- | -------- |
| [Show-ScriptBanner](Show-ScriptBanner.md) | Writes a boxed banner to the console showing a script's name, version, and description. |

## Collections

| Command | Synopsis |
| ------- | -------- |
| [ConvertFrom-JToken](ConvertFrom-JToken.md) | Recursively converts a Newtonsoft.Json.Linq token graph into native PowerShell objects. |
| [ConvertTo-RequestBody](ConvertTo-RequestBody.md) | Builds a request body hashtable from a function's bound parameters. |
| [ConvertTo-RequestQuery](ConvertTo-RequestQuery.md) | Builds a query-string hashtable from a function's bound parameters. |
| [ConvertTo-StringDictionary](ConvertTo-StringDictionary.md) | Converts a hashtable into a Dictionary[string, string] suitable for REST query parameters. |

## Completion

| Command | Synopsis |
| ------- | -------- |
| [Register-BPSArgumentCompleter](Register-BPSArgumentCompleter.md) | Registers a cached, generic tab-completer for one or more command parameters. |

## Context

| Command | Synopsis |
| ------- | -------- |
| [Add-BPSClient](Add-BPSClient.md) | Registers a connected service client in the process-wide Boyles client store. |
| [Confirm-BPSClient](Confirm-BPSClient.md) | Throws if a client is not currently registered under the given key. |
| [Get-BPSClient](Get-BPSClient.md) | Retrieves a previously registered client from the process-wide Boyles client store. |
| [Remove-BPSClient](Remove-BPSClient.md) | Removes a client from the process-wide Boyles client store. |
| [Test-BPSClient](Test-BPSClient.md) | Tests whether a client is currently registered under the given key. |
| [Get-BPSClientKey](Get-BPSClientKey.md) | Lists the keys of every client currently registered in the process-wide Boyles client store. |

## Logging

| Command | Synopsis |
| ------- | -------- |
| [Write-Done](Write-Done.md) | Writes a "done" status line to the console. |
| [Write-Err](Write-Err.md) | Writes an error status line to the console, optionally terminating the script. |
| [Write-Header](Write-Header.md) | Writes a message to the console underlined with a matching-length divider. |
| [Write-Log](Write-Log.md) | Writes a timestamped log entry to the console and an optional log file. |
| [Write-Skip](Write-Skip.md) | Writes a "skipped" status line to the console. |
| [Write-Step](Write-Step.md) | Writes a labeled progress line to the console. |

## Settings

| Command | Synopsis |
| ------- | -------- |
| [Get-BPSSetting](Get-BPSSetting.md) | Retrieves one or more Boyles.PowerShell settings. |
| [Remove-BPSSetting](Remove-BPSSetting.md) | Removes a single Boyles.PowerShell setting, reverting it to its built-in default. |
| [Reset-BPSSetting](Reset-BPSSetting.md) | Clears every Boyles.PowerShell setting, reverting the entire store to its built-in defaults. |
| [Set-BPSSetting](Set-BPSSetting.md) | Sets a Boyles.PowerShell setting. |
| [Get-BPSSettingPath](Get-BPSSettingPath.md) | Returns the path of the file the Boyles.PowerShell settings store persists to. |

## Validation

| Command | Synopsis |
| ------- | -------- |
| [Test-HasValue](Test-HasValue.md) | Tests whether a value is meaningfully populated. |
| [Test-RequiredValue](Test-RequiredValue.md) | Returns a required value, prompting for it interactively if it wasn't supplied. |
