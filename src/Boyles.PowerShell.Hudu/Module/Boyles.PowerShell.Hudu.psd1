@{
    RootModule           = 'Boyles.PowerShell.Hudu.psm1'
    ModuleVersion        = '0.1.0'
    GUID                 = 'e79d0665-d4dd-47e6-85de-a12d0f3c028c'
    Author               = 'Wayne Boyles'
    CompanyName          = 'Wayne Boyles'
    Copyright            = '(c) Wayne Boyles. All rights reserved.'
    Description          = 'Cmdlets for interacting with Hudu, built on Boyles.PowerShell.Core for authentication and HTTP handling.'

    PowerShellVersion    = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')

    RequiredModules      = @(
        @{ ModuleName = 'Boyles.PowerShell.Core'; ModuleVersion = '0.1.0'; GUID = '5b06397d-8350-4a54-8751-b7e44f80adb2' }
    )

    FunctionsToExport    = @(
        'Connect-Hudu'
        'Disconnect-Hudu'

        'Disable-HuduCompany'
        'Enable-HuduCompany'
        'Get-HuduCompany'
        'New-HuduCompany'
        'Remove-HuduCompany'
        'Set-HuduCompany'
    )
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()

    FileList             = @(
        'Boyles.PowerShell.Hudu.psm1'
        'Boyles.PowerShell.Hudu.psd1'
    )

    PrivateData          = @{
        PSData = @{
            Tags         = @('Boyles', 'Hudu', 'Documentation', 'ITGlue')
            ProjectUri   = ''
            LicenseUri   = ''
            ReleaseNotes = 'Initial scaffold.'
        }
    }
}
