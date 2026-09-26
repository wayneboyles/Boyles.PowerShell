function Set-HuduFlag {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Boyles.PowerShell.Hudu.Models.HuduFlag])]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, [int]::MaxValue)]
        [QueryIgnore()]
        [int] $Id,

        [Parameter()]
        [BodyProperty('flag_type_id')]
        [int] $FlagTypeId,

        [Parameter()]
        [BodyProperty('description')]
        [string] $Description
    )
    process {

        $client = Get-HuduClientInternal

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        Write-Verbose "Body = $($body | ConvertTo-Json)"

        if ($PSCmdlet.ShouldProcess($Id, 'Update the Flag')) {

            try {
                [Boyles.PowerShell.Hudu.Models.HuduFlag] $result = $client.UpdateFlag($Id, $body)
                $result
            } catch {
                $message = $_.Exception.Message
                if ($message -like '*HTTP 404*') {
                    return $null # ID wasn't found.  Hudu returns a 404 error
                } else {
                    throw $_
                }
            }

        }

    }

}
