@{
    RootModule           = 'Boyles.PowerShell.Hudu.psm1'
    ModuleVersion        = '0.3.0'
    GUID                 = 'e79d0665-d4dd-47e6-85de-a12d0f3c028c'
    Author               = 'Wayne Boyles'
    CompanyName          = 'Wayne Boyles'
    Copyright            = '(c) Wayne Boyles. All rights reserved.'
    Description          = 'Cmdlets for interacting with Hudu, built on Boyles.PowerShell.Core for authentication and HTTP handling.'

    PowerShellVersion    = '5.1'
    CompatiblePSEditions = @('Desktop', 'Core')

    RequiredModules      = @(
        @{ ModuleName = 'Boyles.PowerShell.Core'; ModuleVersion = '0.3.0'; GUID = '5b06397d-8350-4a54-8751-b7e44f80adb2' }
    )

    FunctionsToExport    = @(
        # Activity Logs
        'Get-HuduActivityLogs'

        # Api Info
        'Get-HuduApiInfo'

        # Articles
        'Disable-HuduArticle'
        'Enable-HuduArticle'
        'Get-HuduArticle'
        'New-HuduArticle'
        'Remove-HuduArticle'
        'Set-HuduArticle'

        # Asset Layouts
        'Disable-HuduAssetLayout'
        'Enable-HuduAssetLayout'
        'Get-HuduAssetLayout'
        'Get-HuduAssetLayoutFields'
        'New-HuduAssetLayout'
        'Set-HuduAssetLayout'

        # Asset Passwords
        'Disable-HuduAssetPassword'
        'Enable-HuduAssetPassword'
        'Get-HuduAssetPassword'
        'New-HuduAssetPassword'
        'Remove-HuduAssetPassword'
        'Set-HuduAssetPassword'

        # Assets
        'Disable-HuduAsset'
        'Enable-HuduAsset'
        'Get-HuduAsset'
        'New-HuduAsset'
        'Remove-HuduAsset'

        # Cards
        'Get-HuduCard'

        # Companies
        'Disable-HuduCompany'
        'Enable-HuduCompany'
        'Get-HuduCompany'
        'New-HuduCompany'
        'Remove-HuduCompany'
        'Set-HuduCompany'

        # Connectivity
        'Connect-Hudu'
        'Disconnect-Hudu'

        # Expirations
        'Get-HuduExpiration'
        'Set-HuduExpiration'
        'Remove-HuduExpiration'

        # Flags
        'Get-HuduFlag'
        'New-HuduFlag'
        'Remove-HuduFlag'
        'Set-HuduFlag'

        # Flag Types
        'Get-HuduFlagType'
        'New-HuduFlagType'
        'Remove-HuduFlagType'
        'Set-HuduFlagType'

        # Folders
        'Get-HuduFolder'
        'New-HuduFolder'
        'Remove-HuduFolder'
        'Set-HuduFolder'

        # Groups
        'Get-HuduGroup'
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
            Tags         = @('Boyles', 'Hudu', 'Documentation')
            ProjectUri   = 'https://github.com/wayneboyles/Boyles.PowerShell'
            LicenseUri   = 'https://github.com/wayneboyles/Boyles.PowerShell/blob/main/LICENSE'
            ReleaseNotes = ''
        }
    }
}
