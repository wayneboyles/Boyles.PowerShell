<#
.SYNOPSIS
    Scaffolds a new partial-class file for a C# HTTP client, wired into an
    existing Boyles.PowerShell service project (e.g. src\Boyles.PowerShell.Hudu).

.DESCRIPTION
    Mirrors the shape used by HuduClient.Labels.cs (see that file for the
    canonical example): a file-scoped `public partial class <Product>Client`
    with Get (singular, by id), Get (plural, auto-paged), New, Update, and
    Delete method pairs (sync + async), built on the protected
    GetAsync/PostAsync/PutAsync/DeleteAsync helpers exposed by
    HttpClientBase.

    Method names are derived from -SingularName (defaulting to a naive
    singularization of -Name) for Get/New/Update/Delete, and from -Name
    (kept as given, normally plural) for the paged Get<Name>/Get<Name>Async
    pair - matching HuduClient.Companies.cs's GetCompany/NewCompany/
    UpdateCompany/DeleteCompany alongside GetCompanies.

    New/Update request bodies are wrapped in a singular JSON envelope before
    being sent (`new { <itemsProperty> = body }`), and single-item responses
    (Get singular, New, Update, Delete) are unwrapped from that same
    envelope - matching HuduClient.Labels.cs. List responses are unwrapped
    from the plural envelope.

    List endpoints page through HuduClient's own private
    GetAllHuduPagesAsync(path, query, itemsProperty, ct) when the target
    project's client is HuduClient (Hudu pages by 1-based page/page_size,
    not record offset - see HuduClient.cs), or through the base
    HttpClientBase.GetAllPagesAsync directly for any other product. Override
    with -Pagination if the auto-detected choice is wrong.

    The script locates the target project under src\ from -ProjectName,
    reads its <RootNamespace> out of the .csproj (falling back to the
    .csproj file name when the element is absent) to work out both the
    client's product prefix (e.g. "Hudu" -> HuduClient) and the namespace
    for -Model, then emits:

        src\<Project>\Services\<Product>Client.<Name>.cs

    The generated methods are boilerplate. The API path segment (-Route),
    the envelope property names (-ItemsProperty/-PluralItemsProperty), and
    the id parameter's type (-IdType) are guessed from -Name but are
    frequently wrong for irregular plurals, non-integer ids, or envelopes
    that don't follow the snake_case-of-the-name convention - review the
    generated file and adjust before building.

.PARAMETER ProjectName
    The service project to add the client to, e.g. 'Hudu' or
    'Boyles.PowerShell.Hudu'. Resolved against src\ - both forms work as
    long as exactly one matching project folder exists.

.PARAMETER Name
    The API area name, matching the existing files' convention of naming
    the area after its endpoint - usually plural, e.g. 'AssetLayouts' or
    'HuduPasswords'. Drives the output file name (<Product>Client.<Name>.cs),
    the paged Get<Name>/Get<Name>Async method names (kept exactly as given),
    and - unless overridden - the guessed API path segment and plural
    envelope property.

.PARAMETER SingularName
    The singular form of the resource, used to name the by-id Get, New,
    Update, and Delete methods (e.g. 'Label' for -Name 'Labels', matching
    HuduClient.Labels.cs's GetLabel/NewLabel/UpdateLabel/DeleteLabel).
    Defaults to a naive singularization of -Name; pass this explicitly when
    that guess is wrong (e.g. -Name 'Statuses' singularizing incorrectly) or
    when -Name is already singular.

.PARAMETER Model
    The unqualified model type name returned by these requests, e.g.
    'HuduLabel'. Must already exist in the project's Models namespace
    (<RootNamespace>.Models).

.PARAMETER Route
    The API path segment relative to ApiRoot, e.g. 'labels'. Defaults to
    the snake_case of -Name as given (-Name is expected to already be
    plural, matching the existing files' endpoints).

.PARAMETER ItemsProperty
    The JSON envelope property used to wrap/unwrap a single item, e.g.
    'label' for HuduLabel. Defaults to the snake_case of -SingularName.
    Used for Get (singular), New, Update, and Delete.

.PARAMETER PluralItemsProperty
    The JSON envelope property used to unwrap the list response, e.g.
    'labels'. Defaults to the snake_case of -Name. Ignored by endpoints that
    return a bare array (pass an empty string and adjust the generated call
    by hand for those).

.PARAMETER IdParameterName
    Name of the id parameter used by Get/Update/Delete, e.g. 'labelId'.
    Defaults to the camelCase of -SingularName plus 'Id' (Labels -> labelId).

.PARAMETER IdType
    C# type of the id parameter. Defaults to 'int'; pass 'string' for
    APIs that key on a slug or GUID instead.

.PARAMETER Pagination
    How the paged Get<Name>Async method retrieves subsequent pages:
    - 'Hudu' calls the Hudu-only private GetAllHuduPagesAsync helper
      (page/page_size paging). Only valid when the target client is
      HuduClient.
    - 'PageNumber' calls the base GetAllPagesAsync with
      PaginationMode.PageNumber (page/page_size paging) for other clients.
    - 'Offset' calls the base GetAllPagesAsync with its offset/limit
      defaults.
    Defaults to 'Hudu' when the resolved product is Hudu, otherwise
    'PageNumber'.

.PARAMETER Force
    Overwrite the output file if it already exists.

.PARAMETER PassThru
    Return the FileInfo of the file that was created.

.PARAMETER SupportPaging
    Also generate a Get<Name>Page/Get<Name>PageAsync pair (<Name> kept
    plural, as given) that retrieves a single specific page - matching
    HuduClient.Companies.cs's GetCompaniesPage/GetCompaniesPageAsync - for
    APIs where the caller sometimes wants one page rather than the fully
    auto-paged result set from Get<Name>Async.

.EXAMPLE
    ./tools/New-HttpClient.ps1 -ProjectName Hudu -Name HuduPasswords -Model HuduPassword

    Creates src\Boyles.PowerShell.Hudu\Services\HuduClient.HuduPasswords.cs
    with GetHuduPassword (singular, by id) / GetHuduPasswords (plural,
    auto-paged) / NewHuduPassword / UpdateHuduPassword / DeleteHuduPassword
    (sync + async), guessing the route as 'hudu_passwords', the single-item
    envelope as 'hudu_password', the plural envelope as 'hudu_passwords',
    and the id parameter as 'huduPasswordId'.

.EXAMPLE
    ./tools/New-HttpClient.ps1 -ProjectName Boyles.PowerShell.Hudu -Name AssetPasswords -Model HuduAssetPassword -Route asset_passwords -IdType int -Force

    Same, but with an explicit route and overwriting an existing file.

.EXAMPLE
    ./tools/New-HttpClient.ps1 -ProjectName Hudu -Name Articles -Model HuduArticle -SupportPaging

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

    [ValidatePattern('^[A-Za-z][A-Za-z0-9]*$')]
    [string]$SingularName,

    [Parameter(Mandatory)]
    [ValidatePattern('^[A-Za-z][A-Za-z0-9]*$')]
    [string]$Model,

    [string]$Route,

    [string]$ItemsProperty,

    [string]$PluralItemsProperty,

    [string]$IdParameterName,

    [ValidateSet('int', 'long', 'string', 'Guid')]
    [string]$IdType = 'int',

    [ValidateSet('Hudu', 'PageNumber', 'Offset')]
    [string]$Pagination,

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
    # in a non-plural 's', like 'Status') and pass -SingularName instead.
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
$isHuduClient = $clientName -ieq 'HuduClient'

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

if (-not $SingularName) {
    $SingularName = ConvertTo-Singular -Text $Name
}

if (-not $ItemsProperty) {
    $ItemsProperty = ConvertTo-SnakeCase -Text $SingularName
}

if (-not $PluralItemsProperty) {
    $PluralItemsProperty = ConvertTo-SnakeCase -Text $Name
}

if (-not $IdParameterName) {
    $IdParameterName = "$(ConvertTo-CamelCase -Text $SingularName)Id"
}

if (-not $Pagination) {
    $Pagination = if ($isHuduClient) { 'Hudu' } else { 'PageNumber' }
}

if ($Pagination -eq 'Hudu' -and -not $isHuduClient) {
    throw "-Pagination 'Hudu' calls HuduClient's private GetAllHuduPagesAsync helper, but the resolved client is '$clientName', not 'HuduClient'. Pass -Pagination PageNumber or Offset instead."
}

switch ($Pagination) {
    'Hudu' {
        $pagedCallLine = "return await GetAllHuduPagesAsync<$Model>(path, query, ""$PluralItemsProperty"", cancellationToken);"
    }
    'PageNumber' {
        $pagedCallLine = "return await GetAllPagesAsync<$Model>(path, query, itemsProperty: ""$PluralItemsProperty"", limitParam: ""page_size"", offsetParam: ""page"", mode: PaginationMode.PageNumber, ct: cancellationToken);"
    }
    'Offset' {
        $pagedCallLine = "return await GetAllPagesAsync<$Model>(path, query, itemsProperty: ""$PluralItemsProperty"", ct: cancellationToken);"
    }
}

$usingLines = @(
    'using System.Globalization;'
    ''
)

if ($Pagination -ne 'Hudu') {
    $usingLines += @(
        'using Boyles.PowerShell.HttpClients;'
        ''
    )
}

$usingLines += @(
    "using $modelsNamespace;"
    ''
)

$lines = $usingLines + @(
    "namespace $servicesNamespace;"
    ''
    '/// <summary>'
    "/// Partial class containing $product $SingularName-related API operations."
    '/// </summary>'
    "public partial class $clientName"
    '{'
    '    /// <summary>'
    "    /// Retrieves a single $SingularName by its ID synchronously."
    '    /// </summary>'
    "    /// <param name=""$IdParameterName"">The unique identifier of the $SingularName to retrieve.</param>"
    "    /// <returns>The matching <see cref=""$Model""/>.</returns>"
    "    public $Model Get$SingularName($IdType $IdParameterName) => Sync(Get${SingularName}Async($IdParameterName));"
    ''
    '    /// <summary>'
    "    /// Retrieves a single $SingularName by its ID asynchronously."
    '    /// </summary>'
    "    /// <param name=""$IdParameterName"">The unique identifier of the $SingularName to retrieve.</param>"
    '    /// <param name="cancellationToken">Token to cancel the request.</param>'
    "    /// <returns>A task resolving to the matching <see cref=""$Model""/>.</returns>"
    "    public async Task<$Model> Get${SingularName}Async($IdType $IdParameterName, CancellationToken cancellationToken = default)"
    '    {'
    "        var path = string.Format(CultureInfo.InvariantCulture, ""{0}/$Route/{1}"", ApiRoot, $IdParameterName);"
    "        return await GetAsync<$Model>(path, itemsProperty: ""$ItemsProperty"", ct: cancellationToken);"
    '    }'
    ''
    '    /// <summary>'
    "    /// Retrieves all $Name from the $product API synchronously, following pagination."
    '    /// </summary>'
    "    /// <param name=""query"">Optional query-string filters (keyed by $product's JSON parameter names).</param>"
    "    /// <returns>A list of all matching <see cref=""$Model""/> records.</returns>"
    "    public List<$Model> Get$Name(Dictionary<string, string>? query = null) => Sync(Get${Name}Async(query));"
    ''
    '    /// <summary>'
    "    /// Retrieves all $Name from the $product API asynchronously, following pagination."
    '    /// </summary>'
    "    /// <param name=""query"">Optional query-string filters (keyed by $product's JSON parameter names).</param>"
    '    /// <param name="cancellationToken">Token to cancel the request.</param>'
    "    /// <returns>A task resolving to a list of all matching <see cref=""$Model""/> records.</returns>"
    "    public async Task<List<$Model>> Get${Name}Async(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)"
    '    {'
    "        var path = string.Format(CultureInfo.InvariantCulture, ""{0}/$Route"", ApiRoot);"
    "        $pagedCallLine"
    '    }'
)

if ($SupportPaging) {
    $lines += @(
        ''
        '    /// <summary>'
        "    /// Retrieves a single specific page of $Name synchronously, without paging further."
        '    /// </summary>'
        '    /// <param name="query">Optional filter parameters merged into the request alongside page and page_size.</param>'
        '    /// <param name="page">The 1-based page number to retrieve.</param>'
        '    /// <param name="pageSize">The number of items requested per page.</param>'
        "    /// <returns>The single page of matching <see cref=""$Model""/> records, as returned by the API.</returns>"
        "    public List<$Model> Get${Name}Page(Dictionary<string, string>? query, int page, int pageSize) => Sync(Get${Name}PageAsync(query, page, pageSize));"
        ''
        '    /// <summary>'
        "    /// Retrieves a single specific page of $Name asynchronously, without paging further."
        "    /// Use this instead of <see cref=""Get${Name}Async""/> when the caller has explicitly"
        '    /// requested a page and page size rather than the full result set.'
        '    /// </summary>'
        '    /// <param name="query">Optional filter parameters merged into the request alongside page and page_size.</param>'
        '    /// <param name="page">The 1-based page number to retrieve.</param>'
        '    /// <param name="pageSize">The number of items requested per page.</param>'
        '    /// <param name="cancellationToken">Token to cancel the request.</param>'
        "    /// <returns>A task resolving to the single page of matching <see cref=""$Model""/> records, as returned by the API.</returns>"
        "    public async Task<List<$Model>> Get${Name}PageAsync(Dictionary<string, string>? query, int page, int pageSize, CancellationToken cancellationToken = default)"
        '    {'
        '        var q = new Dictionary<string, string>(query ?? new Dictionary<string, string>(), StringComparer.Ordinal)'
        '        {'
        '            ["page"] = page.ToString(CultureInfo.InvariantCulture),'
        '            ["page_size"] = pageSize.ToString(CultureInfo.InvariantCulture)'
        '        };'
        ''
        "        var path = string.Format(CultureInfo.InvariantCulture, ""{0}/$Route"", ApiRoot);"
        "        return await GetAsync<List<$Model>>(path, q, itemsProperty: ""$PluralItemsProperty"", ct: cancellationToken);"
        '    }'
    )
}

$lines += @(
    ''
    '    /// <summary>'
    "    /// Creates a new $SingularName in $product synchronously."
    '    /// </summary>'
    '    /// <param name="body">'
    "    /// The request body representing the $SingularName to create. Wrapped in a <c>$ItemsProperty</c> envelope before sending."
    '    /// </param>'
    "    /// <returns>The newly created <see cref=""$Model""/>.</returns>"
    "    public $Model New$SingularName(object body) => Sync(New${SingularName}Async(body));"
    ''
    '    /// <summary>'
    "    /// Creates a new $SingularName in $product asynchronously."
    '    /// </summary>'
    '    /// <param name="body">'
    "    /// The request body representing the $SingularName to create. Wrapped in a <c>$ItemsProperty</c> envelope before sending."
    '    /// </param>'
    '    /// <param name="cancellationToken">Token to cancel the request.</param>'
    "    /// <returns>A task resolving to the newly created <see cref=""$Model""/>.</returns>"
    "    public async Task<$Model> New${SingularName}Async(object body, CancellationToken cancellationToken = default)"
    '    {'
    "        var path = string.Format(CultureInfo.InvariantCulture, ""{0}/$Route"", ApiRoot);"
    ''
    '        var wrapper = new'
    '        {'
    "            $ItemsProperty = body"
    '        };'
    ''
    "        return await PostAsync<$Model>(path, wrapper, itemsProperty: ""$ItemsProperty"", ct: cancellationToken);"
    '    }'
    ''
    '    /// <summary>'
    "    /// Updates an existing $SingularName in $product synchronously."
    '    /// </summary>'
    "    /// <param name=""$IdParameterName"">The unique identifier of the $SingularName to update.</param>"
    '    /// <param name="body">The request body containing the fields to update.</param>'
    "    /// <returns>The updated <see cref=""$Model""/>.</returns>"
    "    public $Model Update$SingularName($IdType $IdParameterName, object body) => Sync(Update${SingularName}Async($IdParameterName, body));"
    ''
    '    /// <summary>'
    "    /// Updates an existing $SingularName in $product asynchronously."
    '    /// </summary>'
    "    /// <param name=""$IdParameterName"">The unique identifier of the $SingularName to update.</param>"
    '    /// <param name="body">The request body containing the fields to update.</param>'
    '    /// <param name="cancellationToken">Token to cancel the request.</param>'
    "    /// <returns>A task resolving to the updated <see cref=""$Model""/>.</returns>"
    "    public async Task<$Model> Update${SingularName}Async($IdType $IdParameterName, object body, CancellationToken cancellationToken = default)"
    '    {'
    "        var path = string.Format(CultureInfo.InvariantCulture, ""{0}/$Route/{1}"", ApiRoot, $IdParameterName);"
    ''
    '        var wrapper = new'
    '        {'
    "            $ItemsProperty = body"
    '        };'
    ''
    "        return await PutAsync<$Model>(path, wrapper, itemsProperty: ""$ItemsProperty"", ct: cancellationToken);"
    '    }'
    ''
    '    /// <summary>'
    "    /// Deletes a $SingularName from $product synchronously."
    '    /// </summary>'
    "    /// <param name=""$IdParameterName"">The unique identifier of the $SingularName to delete.</param>"
    "    public void Delete$SingularName($IdType $IdParameterName) => Sync(Delete${SingularName}Async($IdParameterName));"
    ''
    '    /// <summary>'
    "    /// Deletes a $SingularName from $product asynchronously."
    '    /// </summary>'
    "    /// <param name=""$IdParameterName"">The unique identifier of the $SingularName to delete.</param>"
    '    /// <param name="cancellationToken">Token to cancel the request.</param>'
    "    /// <returns>A task that completes when the $SingularName has been deleted.</returns>"
    "    public async Task Delete${SingularName}Async($IdType $IdParameterName, CancellationToken cancellationToken = default)"
    '    {'
    "        var path = string.Format(CultureInfo.InvariantCulture, ""{0}/$Route/{1}"", ApiRoot, $IdParameterName);"
    "        _ = await DeleteAsync<$Model>(path, itemsProperty: ""$ItemsProperty"", ct: cancellationToken);"
    '    }'
    '}'
)

$content = ($lines -join "`r`n") + "`r`n"

if ($PSCmdlet.ShouldProcess($outputPath, 'Create HTTP client partial class file')) {
    Set-Content -Path $outputPath -Value $content -Encoding utf8 -NoNewline

    Write-Host "Created $outputPath" -ForegroundColor Green
    Write-Host "  Route guessed as '$Route', singular name as '$SingularName', id parameter as '$IdType $IdParameterName'." -ForegroundColor Yellow
    Write-Host "  Envelopes guessed as '$ItemsProperty' (single item) / '$PluralItemsProperty' (list) - adjust if the API doesn't follow that convention." -ForegroundColor Yellow
    Write-Host "  Pagination strategy: $Pagination." -ForegroundColor Yellow

    if ($SupportPaging) {
        Write-Host "  Included Get${Name}Page/Get${Name}PageAsync." -ForegroundColor Yellow
    }

    if ($PassThru) {
        Get-Item -Path $outputPath
    }
}
