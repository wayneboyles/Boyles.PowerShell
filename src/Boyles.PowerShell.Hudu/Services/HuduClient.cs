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
        /// Retrieves the HuduClient registered under <paramref name="key"/> via BoylesContextCache.
        /// </summary>
        public static HuduClient FromContext(string key = "hudu")
            => ContextCache.Get<HuduClient>(key);

        // <summary>
        /// Invokes an HTTP request synchronously and returns the response as an untyped object.
        /// </summary>
        /// <param name="path">The relative path of the API endpoint to call.</param>
        /// <param name="method">The HTTP method to use. Defaults to <c>GET</c>.</param>
        /// <param name="query">Optional query string parameters to append to the request URL.</param>
        /// <param name="body">Optional request body, serialized for methods that support a payload.</param>
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
