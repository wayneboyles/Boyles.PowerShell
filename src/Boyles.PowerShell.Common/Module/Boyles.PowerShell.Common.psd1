@{
    RootModule        = 'Boyles.PowerShell.Common.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = 'abf206e2-75f9-47ad-a75e-000bfd571e62'
    Author            = 'Wayne Boyles'
    CompanyName       = 'Boyles'
    Copyright         = '(c) Wayne Boyles. All rights reserved.'
    Description       = 'Cmdlets for interacting with Common, built on Boyles.PowerShell.Core for authentication and HTTP handling.'

    PowerShellVersion = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')

    RequiredModules   = @(
        @{ ModuleName = 'Boyles.PowerShell.Core'; ModuleVersion = '0.1.0'; GUID = "5b06397d-8350-4a54-8751-b7e44f80adb2" }
    )

    FunctionsToExport = @()
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()

    FileList          = @(
        'Boyles.PowerShell.Common.psm1'
        'Boyles.PowerShell.Common.psd1'
    )

    PrivateData       = @{
        PSData = @{
            Tags         = @('Boyles', 'PowerShell', 'API', 'Common')
            ProjectUri   = ''
            LicenseUri   = ''
            ReleaseNotes = 'Initial scaffold.'
        }
    }
}
