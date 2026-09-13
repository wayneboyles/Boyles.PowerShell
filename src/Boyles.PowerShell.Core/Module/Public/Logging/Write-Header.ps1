function Write-Header {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [string] $Message,

        [Parameter()]
        [string] $Color = 'Yellow'
    )

    process {
        Write-Host $Message -ForegroundColor $Color
        Write-Host ('-' * $Message.Length) -ForegroundColor $Color
    }
}
