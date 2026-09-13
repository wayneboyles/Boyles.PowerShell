@{
    # ============================================================
    #  PSScriptAnalyzer settings
    #
    #  These formatting rules are kept in lock-step with the VSCode
    #  settings.json so the editor's format-on-save and your CI lint
    #  step agree on every rule.
    #
    #  Editor use:  point "powershell.scriptAnalysis.settingsPath"
    #               at this file (relative to the workspace root).
    #  CI / local:  Invoke-ScriptAnalyzer -Path . -Recurse `
    #                   -Settings ./PSScriptAnalyzerSettings.psd1
    # ============================================================

    # Which severities surface as diagnostics.
    # Trim to @('Error','Warning') if 'Information' gets noisy.
    Severity            = @('Error', 'Warning', 'Information')

    # Run the full default rule set...
    IncludeDefaultRules = $true

    # ...minus anything you deliberately opt out of. Left empty by
    # default. Example candidates are shown commented below.
    ExcludeRules        = @(
        # 'PSUseShouldProcessForStateChangingFunctions'
        # 'PSReviewUnusedParameter'
    )

    Rules               = @{

        # -------- Brace placement: OTBS (brace on same line) --------
        # Matches "powershell.codeFormatting.preset": "OTBS".
        # For Allman style, set OnSameLine = $false here AND change
        # the editor preset to keep the two in sync.
        PSPlaceOpenBrace           = @{
            Enable             = $true
            OnSameLine         = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
        }

        PSPlaceCloseBrace          = @{
            Enable             = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
            NoEmptyLineBefore  = $false
        }

        # -------- Indentation: 4 spaces --------
        PSUseConsistentIndentation = @{
            Enable              = $true
            Kind                = 'space'
            IndentationSize     = 4
            PipelineIndentation = 'IncreaseIndentationForFirstPipeline'
        }

        # -------- Whitespace --------
        # One flag per "whitespace*" key in settings.json.
        PSUseConsistentWhitespace  = @{
            Enable                                  = $true
            CheckInnerBrace                         = $true   # whitespaceInsideBrace
            CheckOpenBrace                          = $true   # whitespaceBeforeOpenBrace
            CheckOpenParen                          = $true   # whitespaceBeforeOpenParen
            CheckOperator                           = $true   # whitespaceAroundOperator
            CheckSeparator                          = $true   # whitespaceAfterSeparator
            CheckPipe                               = $true   # addWhitespaceAroundPipe
            CheckPipeForRedundantWhitespace         = $true   # trimWhitespaceAroundPipe
            CheckParameter                          = $false  # whitespaceBetweenParameters
            IgnoreAssignmentOperatorInsideHashTable = $true
        }

        # -------- Align = in hashtables / DSC blocks --------
        # Matches "alignPropertyValuePairs".
        PSAlignAssignmentStatement = @{
            Enable         = $true
            CheckHashtable = $true
        }

        # -------- Casing: Get-childitem -> Get-ChildItem --------
        # Matches "useCorrectCasing".
        PSUseCorrectCasing         = @{
            Enable = $true
        }

        # -------- Line length (matches the editor ruler at 120) --------
        PSAvoidLongLines           = @{
            Enable            = $true
            MaximumLineLength = 120
        }

        # -------- No aliases in committed code --------
        # Matches "autoCorrectAliases" in the editor.
        PSAvoidUsingCmdletAliases  = @{
            Whitelist = @()
        }

        # -------- Cross-version compatibility (optional) --------
        # Flags syntax that won't parse on a target PowerShell version.
        # Set TargetVersions to the runtimes your module actually ships to.
        # Remove this block if you target a single version only.
        PSUseCompatibleSyntax      = @{
            Enable         = $true
            TargetVersions = @('5.1', '7.4')
        }
    }
}
