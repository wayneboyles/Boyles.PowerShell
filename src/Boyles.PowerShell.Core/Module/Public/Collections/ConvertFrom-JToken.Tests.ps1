#Requires -Modules Pester

<#
.SYNOPSIS
    Pester tests for ConvertFrom-JToken.

.DESCRIPTION
    Imports the module directly from this source tree (not from a staged ./out build), so it
    requires only that the C# library has already been compiled into Module\bin (via
    ./build.ps1 or `dotnet build`), not a full psake staging run.
#>

BeforeAll {
    $script:ModuleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
    $script:ManifestPath = Join-Path $script:ModuleRoot 'Boyles.PowerShell.Core.psd1'
    $script:BinPath = Join-Path $script:ModuleRoot 'bin\Boyles.PowerShell.Core.dll'

    if (-not (Test-Path $script:BinPath)) {
        throw "Compiled assembly not found at '$script:BinPath'. Run ./build.ps1 or 'dotnet build' first."
    }

    Import-Module -Name $script:ManifestPath -Force
}

AfterAll {
    Remove-Module -Name Boyles.PowerShell.Core -Force -ErrorAction SilentlyContinue
}

Describe 'ConvertFrom-JToken' {
    It 'returns $null when InputObject is $null' {
        ConvertFrom-JToken -InputObject $null | Should -BeNullOrEmpty
    }

    It 'returns a non-JToken value unchanged' {
        ConvertFrom-JToken -InputObject 'plain string' | Should -Be 'plain string'
    }

    It 'converts a JObject into a pscustomobject with matching properties' {
        $jObject = [Newtonsoft.Json.Linq.JObject]::Parse('{"name":"Acme","id":5}')

        $result = ConvertFrom-JToken -InputObject $jObject

        $result | Should -BeOfType [pscustomobject]
        $result.name | Should -Be 'Acme'
        $result.id | Should -Be 5
    }

    It 'recursively converts nested JObjects' {
        $jObject = [Newtonsoft.Json.Linq.JObject]::Parse('{"company":{"name":"Acme","address":{"city":"Austin"}}}')

        $result = ConvertFrom-JToken -InputObject $jObject

        $result.company | Should -BeOfType [pscustomobject]
        $result.company.name | Should -Be 'Acme'
        $result.company.address.city | Should -Be 'Austin'
    }

    It 'converts a JArray into an array' {
        $jArray = [Newtonsoft.Json.Linq.JArray]::Parse('[1,2,3]')

        $result = @(ConvertFrom-JToken -InputObject $jArray)

        $result | Should -HaveCount 3
        $result[0] | Should -Be 1
        $result[2] | Should -Be 3
    }

    It 'converts a JArray of JObjects into an array of pscustomobjects' {
        $jArray = [Newtonsoft.Json.Linq.JArray]::Parse('[{"id":1},{"id":2}]')

        $result = @(ConvertFrom-JToken -InputObject $jArray)

        $result | Should -HaveCount 2
        $result[0] | Should -BeOfType [pscustomobject]
        $result[0].id | Should -Be 1
        $result[1].id | Should -Be 2
    }

    It 'unwraps a JValue to its underlying value' {
        $jValue = [Newtonsoft.Json.Linq.JValue]::new(42)

        ConvertFrom-JToken -InputObject $jValue | Should -Be 42
    }

    It 'accepts a plain (non-JToken) value via the pipeline' {
        $result = 'plain string' | ConvertFrom-JToken

        $result | Should -Be 'plain string'
    }

    It 'requires -NoEnumerate to pipe a JObject without PowerShell unrolling it first' {
        # JObject/JArray/JValue all implement IEnumerable, so a direct pipe (`$jObject |
        # ConvertFrom-JToken`) would auto-unroll it into its child tokens before this function
        # ever sees the original object - see the DESCRIPTION caveat in ConvertFrom-JToken.ps1.
        $jObject = [Newtonsoft.Json.Linq.JObject]::Parse('{"active":true}')

        $result = Write-Output -NoEnumerate $jObject | ConvertFrom-JToken

        $result | Should -BeOfType [pscustomobject]
        $result.active | Should -Be $true
    }
}
