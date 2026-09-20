@{
    RootModule           = 'Boyles.PowerShell.Core.psm1'
    ModuleVersion        = '0.2.1'
    GUID                 = '5b06397d-8350-4a54-8751-b7e44f80adb2'
    Author               = 'Wayne Boyles'
    CompanyName          = 'Wayne Boyles'
    Copyright            = '(c) Wayne Boyles. All rights reserved.'
    Description          = 'Shared authentication, HTTP connection, and context primitives for the Boyles.PowerShell module family. Every Boyles.PowerShell.* service module depends on this module, the same way Az.* modules depend on Az.Accounts.'

    PowerShellVersion    = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')

    RequiredModules      = @()

    FunctionsToExport    = @(
        'Show-ScriptBanner'

        'Write-Done'
        'Write-Err'
        'Write-Header'
        'Write-Log'
        'Write-Skip'
        'Write-Step'

        'Add-BPSClient'
        'Get-BPSClient'
        'Get-BPSClientKey'
        'Remove-BPSClient'
        'Test-BPSClient'
        'Confirm-BPSClient'

        'Test-HasValue'
        'Test-RequiredValue'

        'ConvertFrom-JToken'
        'ConvertTo-StringDictionary'

        'Register-BPSArgumentCompleter'

        'Get-BPSSetting'
        'Get-BPSSettingPath'
        'Remove-BPSSetting'
        'Reset-BPSSetting'
        'Set-BPSSetting'

        'ConvertTo-RequestBody'
        'ConvertTo-RequestQuery'
    )

    CmdletsToExport      = @()
    VariablesToExport    = @()
    AliasesToExport      = @()

    FileList             = @(
        'Boyles.PowerShell.Core.psm1'
        'Boyles.PowerShell.Core.psd1'
    )

    PrivateData          = @{
        PSData = @{
            Tags         = @('Boyles', 'Http', 'Rest', 'Authentication')
            ProjectUri   = 'https://github.com/wayneboyles/Boyles.PowerShell'
            LicenseUri   = 'https://github.com/wayneboyles/Boyles.PowerShell/blob/main/LICENSE'
            ReleaseNotes = ''
        }
    }
}
