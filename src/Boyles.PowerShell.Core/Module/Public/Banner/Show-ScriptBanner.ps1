<#
.SYNOPSIS
    Writes a boxed banner to the console showing a script's name, version, and description.

.DESCRIPTION
    Draws a bordered box using the running script's own file name (via $PSCommandPath), the
    supplied version, and a word-wrapped description, framed with a fixed 58-character inner
    width. Intended to be called once near the top of a top-level script to give interactive runs
    a clear, consistent banner.

.PARAMETER ScriptVersion
    Version string to display under the script name, e.g. '1.2.0'.

.PARAMETER ScriptDescription
    Short description of what the script does. Word-wrapped to fit inside the banner.

.PARAMETER Color
    Console foreground color the banner is drawn in. Defaults to 'Yellow'.

.EXAMPLE
    Show-ScriptBanner -ScriptVersion '1.0.0' -ScriptDescription 'Syncs Hudu assets from source of truth.'

    Prints a bordered banner using the calling script's file name, the given version, and
    description in the default yellow color.

.EXAMPLE
    Show-ScriptBanner -ScriptVersion '2.3.1' -ScriptDescription 'Nightly cleanup job.' -Color Cyan

    Prints the same banner in cyan instead of the default yellow.
#>
function Show-ScriptBanner {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $ScriptVersion,

        [Parameter(Mandatory, Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $ScriptDescription,

        [Parameter()]
        [string] $Color = 'Yellow'
    )

    process {
        $scriptName = Split-Path -Leaf $PSCommandPath
        $innerWidth = 58
        $textWidth = $innerWidth - 2   # 1-space margin each side

        $center = {
            param($text)
            $pad = $innerWidth - $text.Length
            $left = [math]::Floor($pad / 2)
            $right = $pad - $left
            return (' ' * $left) + $text + (' ' * $right)
        }

        $wordWrap = {
            param($text, $width)
            $words = $text -split '\s+'
            $lines = @()
            $current = ''
            foreach ($word in $words) {
                if ($current.Length -eq 0) {
                    $current = $word
                } elseif (($current.Length + 1 + $word.Length) -le $width) {
                    $current += ' ' + $word
                } else {
                    $lines += $current
                    $current = $word
                }
            }
            if ($current.Length -gt 0) {
                $lines += $current
            }
            return $lines
        }

        $h = '═' * $innerWidth
        $s = '─' * $innerWidth
        $b = ' ' * $innerWidth

        Write-Host ''
        Write-Host "╔$h╗"                                    -ForegroundColor $Color
        Write-Host "║$(& $center $scriptName)║"              -ForegroundColor $Color
        Write-Host "║$(& $center "Version $ScriptVersion")║" -ForegroundColor $Color
        Write-Host "╟$s╢"                                    -ForegroundColor $Color
        Write-Host "║$b║"                                    -ForegroundColor $Color
        foreach ($line in (& $wordWrap $ScriptDescription $textWidth)) {
            Write-Host "║ $($line.PadRight($textWidth + 1))║" -ForegroundColor $Color
        }
        Write-Host "║$b║"                                    -ForegroundColor $Color
        Write-Host '║ Author: Wayne Boyles                                     ║' -ForegroundColor $Color
        Write-Host "║$b║"                                    -ForegroundColor $Color
        Write-Host "╚$h╝"                                    -ForegroundColor $Color
        Write-Host ''
    }
}
