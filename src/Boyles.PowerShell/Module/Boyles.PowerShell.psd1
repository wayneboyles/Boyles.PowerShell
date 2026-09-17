@{
    RootModule           = 'Boyles.PowerShell.psm1'
    ModuleVersion        = '0.1.0'
    GUID                 = '8192f6c9-261d-44b4-960f-05d64086c8e1'
    Author               = 'Wayne Boyles'
    CompanyName          = 'Boyles'
    Copyright            = '(c) Wayne Boyles. All rights reserved.'
    Description          = 'Umbrella module for the Boyles.PowerShell family. Importing this module imports Boyles.PowerShell.Core plus every installed Boyles.PowerShell.<Service> module (e.g. Boyles.PowerShell.Hudu) - the same "meta-module" pattern used by Az and Microsoft.Graph.'

    PowerShellVersion    = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')

    # Add one entry per service module here as new ones are scaffolded
    # (see tools/New-BoylesSubmodule.ps1). This module has no cmdlets of its
    # own - it exists purely to pull every service module into the session.
    RequiredModules      = @(
        @{ ModuleName = 'Boyles.PowerShell.Core'; ModuleVersion = '0.1.0'; GUID = '5b06397d-8350-4a54-8751-b7e44f80adb2' }
        @{ ModuleName = 'Boyles.PowerShell.Hudu'; ModuleVersion = '0.1.0'; GUID = 'e79d0665-d4dd-47e6-85de-a12d0f3c028c' }
    )

    FunctionsToExport    = @()
    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()

    FileList             = @(
        'Boyles.PowerShell.psm1'
        'Boyles.PowerShell.psd1'
    )

    PrivateData          = @{
        PSData = @{
            Tags         = @('PowerShell', 'API', 'Hudu', 'Halo', 'HaloPSA', 'InControl2')
            ProjectUri   = ''
            LicenseUri   = ''
            ReleaseNotes = 'Initial scaffold.'
        }
    }
}
