<#
.SYNOPSIS
    Builds a request body hashtable from a function's bound parameters using each
    parameter's [BodyProperty()] attribute for the JSON key.

.DESCRIPTION
    Loops through the calling function's parameter metadata. For every parameter that
    carries a [BodyProperty('json_name')] attribute, is present in $PSBoundParameters,
    and passes Test-HasValue, its value is added to the returned hashtable under the
    attribute's JSON name. Parameters without the attribute are skipped, so path/route
    parameters (like -CompanyId) can sit alongside body parameters without special-casing.

.PARAMETER BoundParameters
    The $PSBoundParameters hashtable from the calling function.

.PARAMETER ParameterMetadata
    The calling function's parameter metadata, typically $MyInvocation.MyCommand.Parameters.

.EXAMPLE
    function Set-HuduAsset {
        [CmdletBinding(SupportsShouldProcess)]
        param(
            [Parameter(Mandatory)]
            [int] $AssetId,

            [BodyProperty('passwordable_type')]
            [string] $PasswordableType,

            [BodyProperty('name')]
            [string] $Name
        )

        $body = ConvertTo-RequestBody -BoundParameters $PSBoundParameters -ParameterMetadata $MyInvocation.MyCommand.Parameters

        if ($PSCmdlet.ShouldProcess("Asset $AssetId", 'Update')) {
            HuduClient::FromContext().UpdateAsset($AssetId, $body)
        }
    }

    # Binding -PasswordableType 'Asset' produces: @{ passwordable_type = 'Asset' }

.OUTPUTS
    System.Collections.Hashtable
#>
function ConvertTo-RequestBody {
    [OutputType([hashtable])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [System.Collections.IDictionary] $BoundParameters,

        [Parameter(Mandatory)]
        [System.Collections.Generic.Dictionary[string, System.Management.Automation.ParameterMetadata]] $ParameterMetadata
    )

    # PowerShell's built-in parameters (-Verbose, -WhatIf, -ErrorAction, etc.) show up in both
    # ParameterMetadata and PSBoundParameters just like the function's own parameters, so they
    # have to be excluded explicitly - there's no metadata flag that marks them as "common".
    $commonParams = [System.Management.Automation.Cmdlet]::CommonParameters + [System.Management.Automation.Cmdlet]::OptionalCommonParameters

    $body = @{}

    foreach ($paramName in $ParameterMetadata.Keys) {

        if ($commonParams -contains $paramName) {
            continue
        }

        if (-not $BoundParameters.ContainsKey($paramName)) {
            continue
        }

        $attributes = $ParameterMetadata[$paramName].Attributes

        if ($attributes | Where-Object { $_ -is [BodyIgnore] }) {
            continue
        }

        $value = $BoundParameters[$paramName]

        if (-not (Test-HasValue -Value $value)) {
            continue
        }

        $bodyAttr = $attributes | Where-Object { $_ -is [BodyProperty] } | Select-Object -First 1

        $key = if ($null -ne $bodyAttr) { $bodyAttr.Name } else { $paramName.ToLowerInvariant() }

        $body[$key] = $value
    }

    return $body
}
