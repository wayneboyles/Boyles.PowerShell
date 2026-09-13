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
