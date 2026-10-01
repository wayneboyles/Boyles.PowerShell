using System.Runtime.CompilerServices;

using Boyles.PowerShell.Authentication;
using Boyles.PowerShell.Context;
using Boyles.PowerShell.Diagnostics;
using Boyles.PowerShell.HttpClients;

using Newtonsoft.Json;

namespace Boyles.PowerShell.Hudu.Services
{
    /// <summary>
    /// Hudu API client. Built and registered by Connect-Hudu.ps1; cmdlets look it back up via
    /// FromContext() (or Get-BPSClient from PowerShell) rather than constructing it themselves.
    /// </summary>
    public partial class HuduClient : HttpClientBase
    {
        /// <summary>
        /// The API path prefix shared by every Hudu endpoint.
        /// </summary>
        private const string ApiRoot = "api/v1";

        /// <summary>
        /// Page size requested from Hudu list endpoints. Must not exceed the API's maximum, or every
        /// page comes back short and paging stops after the first one.
        /// </summary>
        private const int PageSize = 25;

        /// <summary>
        /// Initializes a new <see cref="HuduClient"/>. Most callers should use <see cref="Create"/>,
        /// which wires up the <c>x-api-key</c> header for them.
        /// </summary>
        /// <param name="baseUrl">The base URL of the Hudu instance, e.g. <c>https://your-instance.huducloud.com</c>.</param>
        /// <param name="auth">Provider that attaches the Hudu API key to each request.</param>
        /// <param name="json">Optional JSON serializer settings; defaults to snake_case with nulls omitted.</param>
        /// <param name="diagnosticsSink">Optional sink that receives a record of every HTTP attempt.</param>
        public HuduClient(string baseUrl, ApiKeyAuthenticationProvider auth, JsonSerializerSettings? json = null, IHttpDiagnosticsSink? diagnosticsSink = null)
            : base(baseUrl, auth, json, diagnosticsSink)
        {
        }

        /// <summary>
        /// Creates a new <see cref="HuduClient"/> instance authenticated with the provided API key.
        /// </summary>
        /// <param name="baseUrl">The base URL of the Hudu instance, e.g. <c>https://your-instance.huducloud.com</c>.</param>
        /// <param name="apiKey">The Hudu API key used to authenticate requests via the <c>x-api-key</c> header.</param>
        /// <returns>A configured <see cref="HuduClient"/> ready to make authenticated API requests.</returns>
        /// <exception cref="ArgumentNullException">Thrown if <paramref name="baseUrl"/> or <paramref name="apiKey"/> is null or whitespace.</exception>
        public static HuduClient Create(string baseUrl, string apiKey)
        {
            if (string.IsNullOrWhiteSpace(baseUrl))
            {
                throw new ArgumentNullException(nameof(baseUrl));
            }

            if (string.IsNullOrWhiteSpace(apiKey))
            {
                throw new ArgumentNullException(nameof(apiKey));
            }

            return new HuduClient(baseUrl, ApiKeyAuthenticationProvider.Header("x-api-key", apiKey));
        }

        /// <summary>
        /// Retrieves the HuduClient registered under <paramref name="key"/> via <see cref="ContextCache"/>.
        /// </summary>
        /// <param name="key">The key the client was registered under by Connect-Hudu; defaults to <c>hudu</c>.</param>
        /// <returns>The registered <see cref="HuduClient"/>.</returns>
        /// <exception cref="KeyNotFoundException">No client is registered under <paramref name="key"/>.</exception>
        /// <exception cref="InvalidOperationException">The client registered under <paramref name="key"/> is not a <see cref="HuduClient"/>.</exception>
        public static HuduClient FromContext(string key = "hudu")
            => ContextCache.Get<HuduClient>(key);

        /// <summary>
        /// Retrieves every page of a Hudu list endpoint. Hudu pages by 1-based <c>page</c> number
        /// and <c>page_size</c> rather than by record offset; every list method should page through
        /// here rather than calling GetAllPagesAsync directly.
        /// </summary>
        /// <typeparam name="T">The type of each item.</typeparam>
        /// <param name="path">API path, including <see cref="ApiRoot"/>.</param>
        /// <param name="query">Optional filters merged into every page request.</param>
        /// <param name="itemsProperty">
        /// The envelope property holding the array, e.g. <c>companies</c>. Ignored when the endpoint
        /// returns a bare array.
        /// </param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <param name="sourceMethod">Calling method name recorded in diagnostics; supplied automatically by the compiler.</param>
        /// <returns>Every item across all pages.</returns>
        private Task<List<T>> GetAllHuduPagesAsync<T>(string path, IReadOnlyDictionary<string, string>? query, string itemsProperty, CancellationToken cancellationToken, [CallerMemberName] string sourceMethod = "")
            => GetAllPagesAsync<T>(path, query, PageSize, itemsProperty, limitParam: "page_size", offsetParam: "page", mode: PaginationMode.PageNumber, ct: cancellationToken, sourceMethod: sourceMethod);

        /// <summary>
        /// Invokes an HTTP request synchronously and returns the response as an untyped object.
        /// </summary>
        /// <param name="path">The relative path of the API endpoint to call.</param>
        /// <param name="method">The HTTP method to use. Defaults to <c>GET</c>.</param>
        /// <param name="query">Optional query string parameters to append to the request URL.</param>
        /// <param name="body">Optional request body, serialized for methods that support a payload.</param>
        /// <param name="itemsProperty">Optional envelope property to unwrap from the response, e.g. <c>company</c>.</param>
        /// <returns>The response deserialized as an untyped object, or <c>null</c> if the response is empty.</returns>
        public object? Invoke(string path, string method = "GET", IReadOnlyDictionary<string, string>? query = null, object? body = null, string? itemsProperty = null) =>
            Sync(InvokeAsync(path, method, query, body, itemsProperty));

        /// <summary>
        /// Invokes an HTTP request asynchronously and returns the response as an untyped object.
        /// </summary>
        /// <param name="path">The relative path of the API endpoint to call.</param>
        /// <param name="method">The HTTP method to use. Defaults to <c>GET</c>.</param>
        /// <param name="query">Optional query string parameters to append to the request URL.</param>
        /// <param name="body">Optional request body, serialized for methods that support a payload.</param>
        /// <param name="itemsProperty">Optional envelope property to unwrap from the response, e.g. <c>company</c>.</param>
        /// <param name="cancellationToken">A token to cancel the asynchronous operation.</param>
        /// <returns>A task resolving to the response deserialized as an untyped object, or <c>null</c> if the response is empty.</returns>
        public async Task<object?> InvokeAsync(string path, string method = "GET", IReadOnlyDictionary<string, string>? query = null, object? body = null, string? itemsProperty = null, CancellationToken cancellationToken = default)
        {
            switch (method.ToUpper())
            {
                default:
                case "GET":
                    return await GetAsync<object?>($"{ApiRoot}/{path}", query, itemsProperty: itemsProperty, ct: cancellationToken);

                case "POST":
                    return await PostAsync<object?>($"{ApiRoot}/{path}", body, itemsProperty: itemsProperty, ct: cancellationToken);

                case "PUT":
                    return await PutAsync<object?>($"{ApiRoot}/{path}", body, itemsProperty: itemsProperty, ct: cancellationToken);

                case "DELETE":
                    return await DeleteAsync<object?>($"{ApiRoot}/{path}", itemsProperty: itemsProperty, ct: cancellationToken);

                case "PATCH":
                    return await PatchAsync<object?>($"{ApiRoot}/{path}", body, itemsProperty: itemsProperty, ct: cancellationToken);
            }
        }
    }
}
