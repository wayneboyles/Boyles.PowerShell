<#
.SYNOPSIS
    Scaffolds a new partial-class file for a C# HTTP client, wired into an
    existing Boyles.PowerShell service project (e.g. src\Boyles.PowerShell.Hudu).

.DESCRIPTION
    Mirrors the shape already used by every <Product>Client.<Area>.cs file
    under a service project's Services\ folder (see HuduClient.Companies.cs
    for the canonical example): a `public partial class <Product>Client`
    with sync/async Get (plural, paged), Get (singular, by id), New,
    Update, and Delete method pairs, built on the protected
    GetAllPagesAsync/GetAsync/PostAsync/PutAsync/DeleteAsync helpers
    exposed by HttpClientBase. Get<Name> (plural), New, Update, and Delete
    are named after the SINGULAR of -Name where singular (Companies.cs uses
    NewCompany/UpdateCompany/DeleteCompany, not NewCompanies) - Get<Name>
    (plural) itself keeps -Name as given, matching GetCompanies.

    The script locates the target project under src\ from -ProjectName,
    reads its <RootNamespace> out of the .csproj (falling back to the
    .csproj file name when the element is absent) to work out both the
    client's product prefix (e.g. "Hudu" -> HuduClient) and the namespace
    for -Model, then emits:

        src\<Project>\Services\<Product>Client.<Name>.cs

    The generated methods are boilerplate. The API path segment (-Route)
    and the id parameter's type (-IdType) are guessed from -Name but are
    frequently wrong for irregular plurals or non-integer ids - review the
    generated file and adjust ApiRoot-relative paths and the id
    parameter/type.

.PARAMETER ProjectName
    The service project to add the client to, e.g. 'Hudu' or
    'Boyles.PowerShell.Hudu'. Resolved against src\ - both forms work as
    long as exactly one matching project folder exists.

.PARAMETER Name
    The API area name, matching the existing files' convention of naming
    the area after its endpoint - usually plural, e.g. 'AssetLayouts' or
    'HuduPasswords'. Drives the output file name (<Product>Client.<Name>.cs)
    and - unless -Route is supplied - the guessed API path segment.

    Method names are generated from the SINGULAR of -Name instead (matching
    HuduClient.Companies.cs's NewCompany/UpdateCompany/DeleteCompany, not
    NewCompanies): -Name HuduPasswords produces NewHuduPassword,
    UpdateHuduPassword, and DeleteHuduPassword. A -Name that is already
    singular (e.g. 'MyArea') is left as-is.

.PARAMETER Model
    The unqualified model type name returned by these requests, e.g.
    'HuduCompany'. Must already exist in the project's Models namespace
    (<RootNamespace>.Models).

.PARAMETER Route
    The API path segment relative to ApiRoot, e.g. 'companies'. Defaults to
    the snake_case of -Name as given (-Name is expected to already be
    plural, matching the existing files' endpoints).

.PARAMETER IdParameterName
    Name of the id parameter used by Update<Name>/Delete<Name>, e.g.
    'companyId'. Defaults to the camelCase of the SINGULAR of -Name plus
    'Id' (HuduPasswords -> huduPasswordId).

.PARAMETER IdType
    C# type of the id parameter. Defaults to 'int'; pass 'string' for
    APIs that key on a slug or GUID instead.

.PARAMETER Force
    Overwrite the output file if it already exists.

.PARAMETER PassThru
    Return the FileInfo of the file that was created.

.PARAMETER SupportPaging
    Also generate a Get<Name>Page/Get<Name>PageAsync pair (<Name> kept
    plural, as given) that retrieves a single specific page - matching
    HuduClient.Articles.cs's GetArticlesPage/GetArticlesPageAsync - for
    APIs where the caller sometimes wants one page rather than the fully
    auto-paged result set from Get<Name>Async.

.EXAMPLE
    ./tools/New-HTTPClient.ps1 -ProjectName Hudu -Name HuduPasswords -Model HuduPassword

    Creates src\Boyles.PowerShell.Hudu\Services\HuduClient.HuduPasswords.cs
    with GetHuduPasswords/NewHuduPassword/UpdateHuduPassword/DeleteHuduPassword
    (sync + async), plus GetHuduPassword (singular, by id) - all returning
    HuduPassword or List<HuduPassword> - guessing the route as
    'hudu_passwords' and the id parameter as 'huduPasswordId'.

.EXAMPLE
    ./tools/New-HTTPClient.ps1 -ProjectName Boyles.PowerShell.Hudu -Name AssetPasswords -Model HuduAssetPassword -Route asset_passwords -IdType int -Force

    Same, but with an explicit route and overwriting an existing file.

.EXAMPLE
    ./tools/New-HTTPClient.ps1 -ProjectName Hudu -Name Articles -Model HuduArticle -SupportPaging

    Also adds GetArticlesPage/GetArticlesPageAsync for retrieving a single
    page instead of the fully auto-paged result set.
#>
[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
[OutputType([System.IO.FileInfo])]
param (
    [Parameter(Mandatory)]
    [ValidatePattern('^[A-Za-z][A-Za-z0-9.]*$')]
    [string]$ProjectName,

    [Parameter(Mandatory)]
    [ValidatePattern('^[A-Za-z][A-Za-z0-9]*$')]
    [string]$Name,

    [Parameter(Mandatory)]
    [ValidatePattern('^[A-Za-z][A-Za-z0-9]*$')]
    [string]$Model,

    [string]$Route,

    [string]$IdParameterName,

    [ValidateSet('int', 'long', 'string', 'Guid')]
    [string]$IdType = 'int',

    [switch]$Force,

    [switch]$PassThru,

    [switch]$SupportPaging
)

#===========================================================================
# FUNCTIONS
#===========================================================================

function ConvertTo-CamelCase {
    param ([Parameter(Mandatory)][string]$Text)

    if ($Text.Length -le 1) {
        return $Text.ToLowerInvariant()
    }

    return $Text.Substring(0, 1).ToLowerInvariant() + $Text.Substring(1)
}

function ConvertTo-SnakeCase {
    param ([Parameter(Mandatory)][string]$Text)

    # AssetLayouts -> asset_layouts, APIInfo -> api_info
    $withBoundaries = [regex]::Replace($Text, '(?<=[a-z0-9])(?=[A-Z])|(?<=[A-Z])(?=[A-Z][a-z])', '_')
    return $withBoundaries.ToLowerInvariant()
}

function ConvertTo-Singular {
    param ([Parameter(Mandatory)][string]$Text)

    # Naive English singularization - good enough for a first draft, review
    # the generated method names for anything irregular (e.g. words ending
    # in a non-plural 's', like 'Status').
    if ($Text -match '(?i)([^aeiou])ies$') {
        return $Text.Substring(0, $Text.Length - 3) + 'y'
    }

    if ($Text -match '(?i)(s|x|z|ch|sh)es$') {
        return $Text.Substring(0, $Text.Length - 2)
    }

    if ($Text -match '(?i)[^s]s$') {
        return $Text.Substring(0, $Text.Length - 1)
    }

    return $Text
}

#===========================================================================
# VARIABLES
#===========================================================================

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$srcRoot = Join-Path -Path $repoRoot -ChildPath 'src'

#===========================================================================
# EXECUTION
#===========================================================================

# Resolve the target project folder - accept either the bare service name
# ('Hudu') or the full folder name ('Boyles.PowerShell.Hudu').

$candidateNames = @($ProjectName)
if ($ProjectName -notlike 'Boyles.PowerShell.*') {
    $candidateNames += "Boyles.PowerShell.$ProjectName"
}

$projectDir = $null
foreach ($candidate in $candidateNames) {
    $candidatePath = Join-Path -Path $srcRoot -ChildPath $candidate
    if (Test-Path -Path $candidatePath -PathType Container) {
        $projectDir = Get-Item -Path $candidatePath
        break
    }
}

if (-not $projectDir) {
    throw "Could not find a project under '$srcRoot' matching '$ProjectName' (tried: $($candidateNames -join ', '))."
}

$csprojFile = Get-ChildItem -Path $projectDir.FullName -Filter '*.csproj' -File | Select-Object -First 1
if (-not $csprojFile) {
    throw "No .csproj file found under '$($projectDir.FullName)'."
}

# Pull RootNamespace out of the csproj; fall back to the csproj's own base
# name (which is what MSBuild itself falls back to) when it's not set.

[xml]$csprojXml = Get-Content -Path $csprojFile.FullName -Raw
$rootNamespace = $csprojXml.Project.PropertyGroup.RootNamespace | Where-Object { $_ } | Select-Object -First 1
if (-not $rootNamespace) {
    $rootNamespace = $csprojFile.BaseName
}

$product = ($rootNamespace -split '\.')[-1]
$clientName = "${product}Client"
$servicesNamespace = "$rootNamespace.Services"
$modelsNamespace = "$rootNamespace.Models"

$servicesDir = Join-Path -Path $projectDir.FullName -ChildPath 'Services'
if (-not (Test-Path -Path $servicesDir -PathType Container)) {
    New-Item -Path $servicesDir -ItemType Directory | Out-Null
}

$outputPath = Join-Path -Path $servicesDir -ChildPath "$clientName.$Name.cs"

if ((Test-Path -Path $outputPath) -and -not $Force) {
    throw "'$outputPath' already exists - pass -Force to overwrite it."
}

if (-not $Route) {
    $Route = ConvertTo-SnakeCase -Text $Name
}

$singularName = ConvertTo-Singular -Text $Name
$itemProperty = ConvertTo-SnakeCase -Text $singularName

if (-not $IdParameterName) {
    $IdParameterName = "$(ConvertTo-CamelCase -Text $singularName)Id"
}

$lines = @(
    'using System.Globalization;'
    ''
    "using $modelsNamespace;"
    ''
    "namespace $servicesNamespace"
    '{'
    '    /// <summary>'
    "    /// Partial class containing $product $(ConvertTo-CamelCase -Text $singularName)-related API operations."
    '    /// </summary>'
    "    public partial class $clientName"
    '    {'
    '        /// <summary>'
    "        /// Retrieves all $Name matching the given filters synchronously, automatically"
    '        /// paging through the full result set.'
    '        /// </summary>'
    '        /// <param name="query">Optional query parameters to filter or scope the request.</param>'
    "        /// <returns>A list of all <see cref=""$Model""/> records.</returns>"
    "        public List<$Model> Get$Name(Dictionary<string, string>? query = null) => Sync(Get${Name}Async(query));"
    ''
    '        /// <summary>'
    "        /// Retrieves all $Name matching the given filters asynchronously, automatically"
    '        /// paging through the full result set.'
    '        /// </summary>'
    '        /// <param name="query">Optional query parameters to filter or scope the request.</param>'
    '        /// <param name="cancellationToken">Token to cancel the request.</param>'
    "        /// <returns>A task resolving to a list of all <see cref=""$Model""/> records.</returns>"
    "        public async Task<List<$Model>> Get${Name}Async(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)"
    '        {'
    "            string path = string.Format(CultureInfo.InvariantCulture, ""{0}/$Route"", ApiRoot);"
    "            return await GetAllPagesAsync<$Model>(path, query, offsetParam: ""page"", limitParam: ""page_size"", itemsProperty: ""$Route"", ct: cancellationToken).ConfigureAwait(false);"
    '        }'
    ''
    '        /// <summary>'
    "        /// Retrieves a single $singularName by its ID synchronously."
    '        /// </summary>'
    "        /// <param name=""$IdParameterName"">The unique identifier of the $singularName to retrieve.</param>"
    "        /// <returns>The matching <see cref=""$Model""/>, or <c>null</c> if not found.</returns>"
    "        public $Model Get$singularName($IdType $IdParameterName) => Sync(Get${singularName}Async($IdParameterName));"
    ''
    '        /// <summary>'
    "        /// Retrieves a single $singularName by its ID asynchronously."
    '        /// </summary>'
    "        /// <param name=""$IdParameterName"">The unique identifier of the $singularName to retrieve.</param>"
    '        /// <param name="cancellationToken">Token to cancel the request.</param>'
    "        /// <returns>A task resolving to the matching <see cref=""$Model""/>, or <c>null</c> if not found.</returns>"
    "        public async Task<$Model> Get${singularName}Async($IdType $IdParameterName, CancellationToken cancellationToken = default)"
    '        {'
    "            string path = string.Format(CultureInfo.InvariantCulture, ""{0}/$Route/{1}"", ApiRoot, $IdParameterName);"
    "            return await GetAsync<$Model>(path, null, ""$itemProperty"", cancellationToken).ConfigureAwait(false);"
    '        }'
    ''
    '        /// <summary>'
    "        /// Creates a new $singularName record in $product synchronously."
    '        /// </summary>'
    '        /// <param name="body">'
    "        /// The request body representing the $singularName to create."
    '        /// </param>'
    '        /// <returns>The newly created <see cref="' + $Model + '"/>.</returns>'
    "        public $Model New$singularName(object body) => Sync(New${singularName}Async(body));"
    ''
    '        /// <summary>'
    "        /// Asynchronously creates a new $singularName record in $product."
    '        /// </summary>'
    '        /// <param name="body">'
    "        /// The request body representing the $singularName to create."
    '        /// </param>'
    '        /// <param name="cancellationToken">'
    '        /// A token to monitor for cancellation requests.'
    '        /// </param>'
    '        /// <returns>'
    "        /// A task that resolves to the newly created <see cref=""$Model""/>."
    '        /// </returns>'
    "        public async Task<$Model> New${singularName}Async(object body, CancellationToken cancellationToken = default)"
    '        {'
    "            string path = string.Format(CultureInfo.InvariantCulture, ""{0}/$Route"", ApiRoot);"
    "            return await PostAsync<$Model>(path, body, ""$Route"", cancellationToken).ConfigureAwait(false);"
    '        }'
    ''
    '        /// <summary>'
    "        /// Synchronously updates a $singularName."
    '        /// </summary>'
    "        /// <param name=""$IdParameterName"">The unique identifier of the $singularName to update.</param>"
    '        /// <param name="body">The request body containing the updated data.</param>'
    "        /// <returns>The updated <see cref=""$Model""/>.</returns>"
    "        public $Model Update$singularName($IdType $IdParameterName, object body) => Sync(Update${singularName}Async($IdParameterName, body));"
    ''
    '        /// <summary>'
    "        /// Asynchronously updates a $singularName."
    '        /// </summary>'
    "        /// <param name=""$IdParameterName"">The unique identifier of the $singularName to update.</param>"
    '        /// <param name="body">The request body containing the updated data.</param>'
    '        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>'
    '        /// <returns>'
    '        /// A task that represents the asynchronous operation.'
    "        /// The task result contains the updated <see cref=""$Model""/>."
    '        /// </returns>'
    "        public async Task<$Model> Update${singularName}Async($IdType $IdParameterName, object body, CancellationToken cancellationToken = default)"
    '        {'
    "            string path = string.Format(CultureInfo.InvariantCulture, ""{0}/$Route/{1}"", ApiRoot, $IdParameterName);"
    "            return await PutAsync<$Model>(path, body, ""$Route"", cancellationToken).ConfigureAwait(false);"
    '        }'
    ''
    '        /// <summary>'
    "        /// Synchronously deletes a $singularName."
    '        /// </summary>'
    "        /// <param name=""$IdParameterName"">The unique identifier of the $singularName to delete.</param>"
    "        public void Delete$singularName($IdType $IdParameterName) => Sync(Delete${singularName}Async($IdParameterName));"
    ''
    '        /// <summary>'
    "        /// Asynchronously deletes a $singularName."
    '        /// </summary>'
    "        /// <param name=""$IdParameterName"">The unique identifier of the $singularName to delete.</param>"
    '        /// <param name="cancellationToken">A token to monitor for cancellation requests.</param>'
    '        /// <returns>A task that represents the asynchronous delete operation.</returns>'
    "        public async Task Delete${singularName}Async($IdType $IdParameterName, CancellationToken cancellationToken = default)"
    '        {'
    "            string path = string.Format(CultureInfo.InvariantCulture, ""{0}/$Route/{1}"", ApiRoot, $IdParameterName);"
    "            await DeleteAsync<$Model>(path, null, cancellationToken).ConfigureAwait(false);"
    '        }'
)

if ($SupportPaging) {
    $lines += @(
        ''
        '        /// <summary>'
        "        /// Retrieves a single specific page of $Name synchronously, without paging further."
        '        /// </summary>'
        '        /// <param name="query">Optional filter parameters merged into the request alongside page and page_size.</param>'
        '        /// <param name="page">The 1-based page number to retrieve.</param>'
        '        /// <param name="pageSize">The number of items requested per page.</param>'
        "        /// <returns>The single page of matching <see cref=""$Model""/> records, as returned by the API.</returns>"
        "        public List<$Model> Get${Name}Page(Dictionary<string, string>? query, int page, int pageSize) => Sync(Get${Name}PageAsync(query, page, pageSize));"
        ''
        '        /// <summary>'
        "        /// Retrieves a single specific page of $Name asynchronously, without paging further."
        "        /// Use this instead of <see cref=""Get${Name}Async""/> when the caller has explicitly"
        '        /// requested a page and page size rather than the full result set.'
        '        /// </summary>'
        '        /// <param name="query">Optional filter parameters merged into the request alongside page and page_size.</param>'
        '        /// <param name="page">The 1-based page number to retrieve.</param>'
        '        /// <param name="pageSize">The number of items requested per page.</param>'
        '        /// <param name="cancellationToken">Token to cancel the request.</param>'
        "        /// <returns>A task resolving to the single page of matching <see cref=""$Model""/> records, as returned by the API.</returns>"
        "        public async Task<List<$Model>> Get${Name}PageAsync(Dictionary<string, string>? query, int page, int pageSize, CancellationToken cancellationToken = default)"
        '        {'
        '            var q = new Dictionary<string, string>(query ?? new Dictionary<string, string>(), StringComparer.Ordinal)'
        '            {'
        '                ["page"] = page.ToString(CultureInfo.InvariantCulture),'
        '                ["page_size"] = pageSize.ToString(CultureInfo.InvariantCulture)'
        '            };'
        ''
        "            string path = string.Format(CultureInfo.InvariantCulture, ""{0}/$Route"", ApiRoot);"
        "            return await GetAsync<List<$Model>>(path, q, itemsProperty: ""$Route"", ct: cancellationToken);"
        '        }'
    )
}

$lines += @(
    '    }'
    '}'
)

$content = ($lines -join "`r`n") + "`r`n"

if ($PSCmdlet.ShouldProcess($outputPath, 'Create HTTP client partial class file')) {
    Set-Content -Path $outputPath -Value $content -Encoding utf8 -NoNewline

    Write-Host "Created $outputPath" -ForegroundColor Green
    Write-Host "  Route guessed as '$Route', methods named after singular '$singularName', id parameter as '$IdType $IdParameterName', single-item envelope property as '$itemProperty' - adjust any of these if they're wrong for this API." -ForegroundColor Yellow

    if ($SupportPaging) {
        Write-Host "  Included Get${Name}Page/Get${Name}PageAsync." -ForegroundColor Yellow
    }

    if ($PassThru) {
        Get-Item -Path $outputPath
    }
}
