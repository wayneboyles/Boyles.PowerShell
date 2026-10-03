function Remove-HuduMagicDash {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'ById')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'ById')]
        [ValidateRange(1, [int]::MaxValue)]
        [BodyIgnore()]
        [int] $Id,

        [Parameter(Mandatory, ParameterSetName = 'ByTitle')]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('title')]
        [string] $Title,

        [Parameter(Mandatory, ParameterSetName = 'ByTitle')]
        [ValidateNotNullOrEmpty()]
        [BodyProperty('company_name')]
        [string] $CompanyName
    )
    process {

        $client = Get-HuduClientInternal

        if ($PSCmdlet.ShouldProcess($Id, 'Delete the MagicDash')) {
            try {
                if ($PSCmdlet.ParameterSetName -eq 'ById') {

                    # Delete by the MagicDash ID

                    $client.DeleteMagicDash($Id, $null)

                } else {

                    # Build the body from the parameters and delete by title and
                    # company name

                    $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

                    Write-Verbose "Body = $($body | ConvertTo-Json)"

                    $client.DeleteMagicDash(0, $body)

                }
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
