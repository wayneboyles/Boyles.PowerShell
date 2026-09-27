BeforeDiscovery {
    $modules = 'Boyles.PowerShell.Core', 'Boyles.PowerShell.Hudu'
    $commands = foreach ($m in $modules) {
        Import-Module (Join-Path $PSScriptRoot "../out/$m") -Force
        Get-Command -Module $m -CommandType Function | ForEach-Object { @{ Name = $_.Name; Module = $m } }
    }
}

Describe 'Comment-based help for <Name>' -ForEach $commands {
    BeforeAll {
        $help = Get-Help -Name $Name -Full
    }

    It 'has a synopsis' {
        $help.Synopsis | Should -Not -BeNullOrEmpty
        $help.Synopsis | Should -Not -BeLike "*$Name*[<CommonParameters>]*"   # auto-generated syntax = no CBH
    }

    It 'has a description' {
        $help.Description.Text | Should -Not -BeNullOrEmpty
    }

    It 'has at least one example' {
        @($help.Examples.Example).Count | Should -BeGreaterThan 0
    }

    It 'documents every parameter' {
        $common = [System.Management.Automation.PSCmdlet]::CommonParameters + [System.Management.Automation.PSCmdlet]::OptionalCommonParameters + 'ProgressAction'
        $params = (Get-Command $Name).Parameters.Keys | Where-Object { $_ -notin $common }
        foreach ($p in $params) {
            ($help.Parameters.Parameter | Where-Object Name -EQ $p).Description.Text | Should -Not -BeNullOrEmpty -Because "-$p on $Name needs a .PARAMETER entry"
        }
    }
}
