using System.Collections;
using System.Globalization;
using System.Net;
using System.Net.Http.Headers;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Text;

using Boyles.PowerShell.Authentication;
using Boyles.PowerShell.Diagnostics;
using Boyles.PowerShell.Exceptions;
using Boyles.PowerShell.Http;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json.Serialization;

namespace Boyles.PowerShell.HttpClients
{
    /// <summary>
    /// Abstract base class for all Boyles.PowerShell service API HTTP clients. Provides a unified pipeline
    /// for authentication, JSON serialization, automatic retry with back-off, cursor-based pagination,
    /// and raw JToken access. Concrete clients inherit this class and call the protected verb helpers
    /// (GetAsync, PostAsync, etc.) rather than constructing HttpRequestMessage instances directly.
    /// </summary>
    public abstract class HttpClientBase : IDisposable
    {
        private bool _disposed;

        private static readonly string UserAgent = $"Boyles.PowerShell/{Assembly.GetExecutingAssembly().GetName().Version}";

        /// <summary>
        /// Underlying HttpClient instance that executes all outgoing HTTP requests.
        /// Constructed with the shared HttpTransport handler (disposeHandler: false) so that
        /// socket connections are pooled across client instances and not torn down on Dispose.
        /// </summary>
        private readonly HttpClient _http;

        /// <summary>
        /// Pluggable authentication provider applied to every outgoing request via ApplyAsync.
        /// Also called via InvalidateAsync when a 401 response is received, triggering a token
        /// refresh before a single automatic retry is attempted.
        /// </summary>
        private readonly IAuthenticationProvider _auth;

        /// <summary>
        /// Pre-built JsonSerializer derived from JsonOptions at construction time.
        /// Used for token-level deserialization (JToken.ToObject) inside GetAllPagesAsync
        /// and DeserializeToken, keeping settings consistent with the typed request helpers.
        /// </summary>
        private readonly JsonSerializer _serializer;

        /// <summary>
        /// Shared Random instance used to add jitter to exponential back-off delay calculations.
        /// Declared static so that rapid sequential retries across concurrent requests do not
        /// all land on the same delay value. All reads and writes are guarded by a lock statement.
        /// </summary>
        private static readonly Random _jitter = new Random();

        /// <summary>
        /// Diagnostics sink that every HTTP attempt made by this client is reported to.
        /// Defaults to NullHttpDiagnosticsSink so verbose call logging stays entirely opt-in;
        /// callers that want a live request/response trail supply a real sink at construction.
        /// </summary>
        private readonly IHttpDiagnosticsSink _diagnosticsSink;

        /// <summary>
        /// Builds redacted HttpCallRecord instances from request/response data before they are
        /// handed to _diagnosticsSink. Stateless aside from its static redaction rules, so a
        /// single instance is shared across every attempt made by this client.
        /// </summary>
        private static readonly HttpCallRecordBuilder _diagnosticsBuilder = new();

        /// <summary>
        /// Root URI for the target API. All relative paths supplied to the request helpers
        /// are resolved against this address using standard Uri combination rules.
        /// The constructor always appends a trailing slash to ensure correct segment resolution.
        /// </summary>
        public Uri BaseAddress { get; }

        /// <summary>
        /// JSON serializer settings used for both serializing request bodies and deserializing
        /// response bodies throughout this client. When not supplied by the caller the constructor
        /// falls back to DefaultJson, which applies snake_case naming and omits null values.
        /// </summary>
        protected JsonSerializerSettings JsonOptions { get; }

        /// <summary>
        /// Maximum number of times a failed request will be retried before the error is surfaced
        /// to the caller as an ApiException. Retry logic applies to HTTP 429 responses, any 5xx
        /// status code, and transport-level failures such as timeouts, DNS errors, and TLS resets.
        /// Defaults to 5.
        /// </summary>
        public int MaxRetries { get; set; } = 5;

        /// <summary>
        /// Default JSON serializer settings shared by all client instances that do not supply
        /// their own settings. PascalCase C# properties are mapped to snake_case JSON keys via
        /// SnakeCaseNamingStrategy; explicit [JsonProperty] names are honoured and not overridden;
        /// null-valued properties are omitted from serialized output entirely.
        /// </summary>
        public static readonly JsonSerializerSettings DefaultJson = new()
        {
            ContractResolver = new DefaultContractResolver
            {
                NamingStrategy = new SnakeCaseNamingStrategy(processDictionaryKeys: false, overrideSpecifiedNames: false)
            },
            NullValueHandling = NullValueHandling.Ignore
        };

        /// <summary>
        /// Initializes a new instance of HttpClientBase, wiring up the base address, authentication
        /// provider, JSON settings, and underlying HttpClient. The HttpClient is configured with a
        /// 100-second timeout and an Accept: application/json default header applied to all requests.
        /// </summary>
        /// <param name="baseUrl">
        /// Root URL of the target API (e.g. https://api.example.com/v2). A trailing slash is appended
        /// automatically so that relative paths passed to the request helpers resolve correctly against
        /// the base when using standard Uri combination semantics.
        /// </param>
        /// <param name="auth">
        /// Authentication provider responsible for attaching credentials to each outgoing request
        /// and for invalidating cached tokens when a 401 response is received so that a fresh token
        /// can be obtained before the single automatic re-authentication retry.
        /// </param>
        /// <param name="json">
        /// Optional custom JSON serializer settings to use in place of DefaultJson. When null, the
        /// static DefaultJson settings are used, providing snake_case mapping and null-value suppression.
        /// </param>
        /// <exception cref="ArgumentException">
        /// Thrown when baseUrl is null, empty, or consists entirely of whitespace characters.
        /// </exception>
        /// <exception cref="ArgumentNullException">
        /// Thrown when auth is null, as every request requires a valid authentication provider.
        /// </exception>
        protected HttpClientBase(string baseUrl, IAuthenticationProvider auth, JsonSerializerSettings? json = null, IHttpDiagnosticsSink? diagnosticsSink = null)
        {
            if (string.IsNullOrWhiteSpace(baseUrl))
            {
                throw new ArgumentException("baseUrl is required", nameof(baseUrl));
            }

            BaseAddress = new Uri(baseUrl.TrimEnd('/') + "/");

            _auth = auth ?? throw new ArgumentNullException(nameof(auth));

            JsonOptions = json ?? DefaultJson;
            _serializer = JsonSerializer.Create(JsonOptions);

            _diagnosticsSink = diagnosticsSink ?? NullHttpDiagnosticsSink.Instance;

            _http = new HttpClient(HttpTransport.Shared, disposeHandler: false)
            {
                Timeout = TimeSpan.FromSeconds(100)
            };

            _http.DefaultRequestHeaders.UserAgent.ParseAdd(UserAgent);

            _http.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        /// <summary>
        /// Issues an authenticated HTTP GET request to the specified path and deserializes the
        /// response body to TResult. Passes through the full retry and 401 re-authentication
        /// pipeline defined in SendWithRetryAsync before returning the deserialized value.
        /// </summary>
        /// <param name="path">API path relative to BaseAddress.</param>
        /// <param name="query">Optional key-value pairs appended to the URL as a query string.</param>
        /// <param name="itemsProperty">
        /// When non-null, the response JSON is treated as an envelope object and only the value
        /// of this named property is deserialized rather than the root document.
        /// </param>
        /// <param name="ct">Cancellation token forwarded to the underlying HTTP call.</param>
        protected async Task<T> GetAsync<T>(string path, IReadOnlyDictionary<string, string>? query = null, string? itemsProperty = null, CancellationToken ct = default, [CallerMemberName] string sourceMethod = "")
            => await RequestAsync<T>(HttpMethod.Get, path, query, null, itemsProperty, ct, sourceMethod);

        /// <summary>
        /// Issues an authenticated HTTP POST request with a JSON-serialized body and deserializes
        /// the response to TResult. The body object is serialized using JsonOptions; pass null to
        /// send a request with no body content.
        /// </summary>
        /// <param name="path">API path relative to BaseAddress.</param>
        /// <param name="body">Object serialized as the JSON request body, or null for an empty body.</param>
        /// <param name="itemsProperty">Optional envelope property name; see GetAsync for details.</param>
        /// <param name="ct">Cancellation token forwarded to the underlying HTTP call.</param>
        protected async Task<T> PostAsync<T>(string path, object? body, string? itemsProperty = null, CancellationToken ct = default, [CallerMemberName] string sourceMethod = "")
            => await RequestAsync<T>(HttpMethod.Post, path, null, body, itemsProperty, ct, sourceMethod);

        /// <summary>
        /// Issues an authenticated HTTP PUT request with a JSON-serialized body and deserializes
        /// the response to TResult. Intended for full-resource replacement operations where the
        /// entire resource representation is supplied in the request body.
        /// </summary>
        /// <param name="path">API path relative to BaseAddress.</param>
        /// <param name="body">Object serialized as the JSON request body.</param>
        /// <param name="itemsProperty">Optional envelope property name; see GetAsync for details.</param>
        /// <param name="ct">Cancellation token forwarded to the underlying HTTP call.</param>
        protected async Task<T> PutAsync<T>(string path, object? body, string? itemsProperty = null, CancellationToken ct = default, [CallerMemberName] string sourceMethod = "")
            => await RequestAsync<T>(HttpMethod.Put, path, null, body, itemsProperty, ct, sourceMethod);

        /// <summary>
        /// Issues an authenticated HTTP PATCH request with a JSON-serialized body and deserializes
        /// the response to TResult. HttpMethod.Patch is constructed manually because the static
        /// property is not available on all target framework versions.
        /// </summary>
        /// <param name="path">API path relative to BaseAddress.</param>
        /// <param name="body">Object serialized as the JSON request body.</param>
        /// <param name="itemsProperty">Optional envelope property name; see GetAsync for details.</param>
        /// <param name="ct">Cancellation token forwarded to the underlying HTTP call.</param>
        protected async Task<T> PatchAsync<T>(string path, object? body, string? itemsProperty = null, CancellationToken ct = default, [CallerMemberName] string sourceMethod = "")
            => await RequestAsync<T>(new HttpMethod("PATCH"), path, null, body, itemsProperty, ct, sourceMethod);

        /// <summary>
        /// Issues an authenticated HTTP DELETE request and deserializes the response to TResult.
        /// No request body is sent. Use the return type parameter to capture a confirmation payload
        /// from APIs that return a body on deletion, or discard it when none is expected.
        /// </summary>
        /// <param name="path">API path relative to BaseAddress.</param>
        /// <param name="itemsProperty">Optional envelope property name; see GetAsync for details.</param>
        /// <param name="ct">Cancellation token forwarded to the underlying HTTP call.</param>
        protected async Task<T> DeleteAsync<T>(string path, string? itemsProperty = null, CancellationToken ct = default, [CallerMemberName] string sourceMethod = "")
            => await RequestAsync<T>(HttpMethod.Delete, path, null, null, itemsProperty, ct, sourceMethod);

        /// <summary>
        /// Retrieves all pages of a paginated GET endpoint, accumulating the results into a single
        /// flat list. Pagination is driven by offset/limit query parameters; the loop exits when a
        /// page shorter than pageSize is returned, indicating no further records remain. Each page
        /// is parsed by extracting the array at itemsProperty from the response envelope.
        /// </summary>
        /// <param name="path">API path relative to BaseAddress (or baseOverride when supplied).</param>
        /// <param name="baseQuery">
        /// Fixed query parameters merged into every paged request before the limit and offset
        /// parameters are appended. Keys in this dictionary take lower precedence than the
        /// pagination parameters, which are always written last.
        /// </param>
        /// <param name="pageSize">Number of items requested per page; defaults to 100.</param>
        /// <param name="itemsProperty">Name of the JSON array property inside the response envelope; defaults to "items".</param>
        /// <param name="limitParam">Query parameter name used to specify the page size; defaults to "limit".</param>
        /// <param name="offsetParam">Query parameter name used to specify the page offset; defaults to "offset".</param>
        /// <param name="authOverride">
        /// When non-null, this Authorization header value is used in place of the configured
        /// authentication provider, bypassing automatic token refresh on 401 responses.
        /// </param>
        /// <param name="baseOverride">
        /// When non-null, URI resolution uses this base address instead of BaseAddress, allowing
        /// paged requests to be directed at a different host or path prefix.
        /// </param>
        /// <param name="ct">Cancellation token forwarded to each page request.</param>
        /// <exception cref="ApiException">
        /// Thrown when any individual page request returns a non-2xx HTTP status code after
        /// all retry attempts have been exhausted.
        /// </exception>
        protected async Task<List<T>> GetAllPagesAsync<T>(string path, IReadOnlyDictionary<string, string>? baseQuery = null, int pageSize = 100, string itemsProperty = "items", string limitParam = "limit", string offsetParam = "offset", AuthenticationHeaderValue? authOverride = null, Uri? baseOverride = null, CancellationToken ct = default, [CallerMemberName] string sourceMethod = "")
        {
            var all = new List<T>();
            int offset = 0;

            while (true)
            {
                var q = new Dictionary<string, string>(StringComparer.Ordinal);
                if (baseQuery != null)
                {
                    foreach (var kv in baseQuery)
                    {
                        q[kv.Key] = kv.Value;
                    }
                }

                q[limitParam] = pageSize.ToString();
                q[offsetParam] = offset.ToString();

                var uri = BuildUri(path, q, baseOverride);

                var result = await SendWithRetryAsync(HttpMethod.Get, uri, () => null, authOverride, allowReauth: authOverride == null, ct, sourceMethod).ConfigureAwait(false);

                if (!result.IsSuccess)
                {
                    throw new ApiException((HttpStatusCode)result.StatusCode, result.Body, $"Paged GET {uri} failed: HTTP {result.StatusCode}");
                }

                int pageCount = 0;
                var root = JsonConvert.DeserializeObject<JObject>(string.IsNullOrWhiteSpace(result.Body) ? "{}" : result.Body);

                if (root != null && root[itemsProperty] is JArray items)
                {
                    foreach (var el in items)
                    {
                        var item = el.ToObject<T>(_serializer);
                        if (item != null)
                        {
                            all.Add(item);
                        }

                        pageCount++;
                    }
                }

                offset += pageCount;

                if (pageCount < pageSize)
                {
                    break;
                }
            }

            return all;
        }

        /// <summary>
        /// Core request dispatcher used by all typed verb helpers. Builds the request URI,
        /// serializes the optional body to JSON via a content factory delegate, invokes the
        /// retry pipeline, and hands the response body to DeserializeBody for final conversion
        /// to the requested CLR type.
        /// </summary>
        /// <param name="method">HTTP method to use for the request.</param>
        /// <param name="path">API path relative to BaseAddress.</param>
        /// <param name="query">Optional query parameters appended to the URI.</param>
        /// <param name="body">Optional object serialized as the JSON request body.</param>
        /// <param name="itemsProperty">Optional envelope property name forwarded to DeserializeBody.</param>
        /// <param name="ct">Cancellation token forwarded to the retry loop.</param>
        /// <exception cref="ApiException">
        /// Thrown when the final response after all retries carries a non-2xx HTTP status code.
        /// </exception>
        private async Task<T> RequestAsync<T>(HttpMethod method, string path, IReadOnlyDictionary<string, string>? query, object? body, string? itemsProperty, CancellationToken ct, [CallerMemberName] string sourceMethod = "")
        {
            var uri = BuildUri(path, query);

            HttpContent? ContentFactory() => body is null
                ? null
                : new StringContent(JsonConvert.SerializeObject(body, JsonOptions), Encoding.UTF8, "application/json");

            var result = await SendWithRetryAsync(method, uri, ContentFactory, null, allowReauth: true, ct, sourceMethod).ConfigureAwait(false);
            if (!result.IsSuccess)
            {
                throw new ApiException((HttpStatusCode)result.StatusCode, result.Body, $"{method} {uri} failed: HTTP {result.StatusCode}");
            }

            return DeserializeBody<T>(result.Body, itemsProperty);
        }

        /// <summary>
        /// Executes an HTTP request with automatic retry, exponential back-off with jitter, and
        /// a single 401-triggered token refresh cycle. A new HttpRequestMessage is constructed on
        /// every attempt so that the content stream can be re-read and authorization headers
        /// reflect any token that was obtained during a mid-loop re-authentication step.
        /// </summary>
        /// <param name="method">HTTP method for the request.</param>
        /// <param name="uri">Fully-qualified URI including any query string.</param>
        /// <param name="contentFactory">
        /// Factory delegate invoked on each attempt to produce the request body content.
        /// A factory is used rather than a single HttpContent instance because HttpContent
        /// cannot be re-sent after it has been read by the previous attempt.
        /// </param>
        /// <param name="authOverride">
        /// When non-null, this value is written directly to the Authorization header and the
        /// authentication provider is bypassed entirely, including the 401 refresh logic.
        /// </param>
        /// <param name="allowReauth">
        /// When true, a single 401 response causes the auth provider to be invalidated and
        /// the request to be retried immediately without counting against MaxRetries.
        /// </param>
        /// <param name="ct">Cancellation token. TaskCanceledException due to timeout is treated as a retryable transport error.</param>
        private async Task<HttpResult> SendWithRetryAsync(HttpMethod method, Uri uri, Func<HttpContent?> contentFactory, AuthenticationHeaderValue? authOverride, bool allowReauth, CancellationToken ct, string sourceMethod = "")
        {
            // One correlation ID per logical call - shared by every attempt below, including
            // retries and the request that follows a 401 token refresh - so a diagnostics
            // consumer can group them together as a single operation.
            var correlationId = Guid.NewGuid();

            int attempt = 0;
            bool reauthed = false;

            // Set by the previous iteration when it decides the next attempt is a retry, so
            // that attempt's diagnostics record can explain why it happened. Null on the first attempt.
            string? pendingRetryReason = null;

            while (true)
            {
                attempt++;
                
                bool isRetry = attempt > 1;
                
                var retryReason = pendingRetryReason;

                pendingRetryReason = null;

                var attemptStartedAtUtc = DateTimeOffset.UtcNow;
                
                using var request = new HttpRequestMessage(method, uri);
                
                var content = contentFactory();
                if (content != null)
                {
                    request.Content = content;
                }

                if (authOverride != null)
                {
                    request.Headers.Authorization = authOverride;
                }
                else
                {
                    await _auth.ApplyAsync(request, forceRefresh: false, ct).ConfigureAwait(false);
                }

                // Read the outgoing body once up front, purely for diagnostics. StringContent
                // buffers in memory, so this does not disturb HttpClient's own read of the same
                // content when the request is actually sent below.
                var requestBodyText = request.Content is null
                    ? null
                    : await request.Content.ReadAsStringAsync().ConfigureAwait(false);

                HttpResult result;

                try
                {
                    using var resp = await _http.SendAsync(request, ct).ConfigureAwait(false);
                    var text = await resp.Content.ReadAsStringAsync().ConfigureAwait(false);
                    result = new HttpResult((int)resp.StatusCode, text, resp.Headers);

                    var record = _diagnosticsBuilder.BuildForResponse(
                        correlationId,
                        attempt,
                        sourceMethod,
                        attemptStartedAtUtc,
                        method.Method,
                        uri.ToString(),
                        CombineHeaders(request.Headers, request.Content?.Headers),
                        requestBodyText,
                        (int)resp.StatusCode,
                        resp.ReasonPhrase,
                        CombineHeaders(resp.Headers, resp.Content?.Headers),
                        text,
                        isRetry,
                        retryReason
                    );

                    await _diagnosticsSink.RecordAsync(record).ConfigureAwait(false);
                }
                catch (TaskCanceledException tcx) when (!ct.IsCancellationRequested)
                {
                    result = new HttpResult(0, "Request timed out", null);

                    var record = _diagnosticsBuilder.BuildForException(
                        correlationId, attempt, sourceMethod, attemptStartedAtUtc,
                        method.Method, uri.ToString(),
                        CombineHeaders(request.Headers, request.Content?.Headers),
                        requestBodyText, tcx, isRetry);

                    await _diagnosticsSink.RecordAsync(record).ConfigureAwait(false);
                }
                catch (HttpRequestException ex)
                {
                    result = new HttpResult(0, ex.Message, null);

                    var record = _diagnosticsBuilder.BuildForException(
                        correlationId, attempt, sourceMethod, attemptStartedAtUtc,
                        method.Method, uri.ToString(),
                        CombineHeaders(request.Headers, request.Content?.Headers),
                        requestBodyText, ex, isRetry);

                    await _diagnosticsSink.RecordAsync(record).ConfigureAwait(false);
                }

                if (result.StatusCode == 401 && allowReauth && authOverride == null && !reauthed)
                {
                    reauthed = true;
                    pendingRetryReason = "401 - token refreshed";
                    await _auth.InvalidateAsync(ct).ConfigureAwait(false);
                    continue;
                }

                bool retryable = result.StatusCode == 429 || (result.StatusCode >= 500 && result.StatusCode <= 599) || result.StatusCode == 0;

                if (!retryable || attempt > MaxRetries)
                {
                    return result;
                }

                var delay = ComputeDelay(result, attempt);
                pendingRetryReason = $"{(result.StatusCode == 0 ? "transport error" : result.StatusCode.ToString())} - backoff {delay.TotalMilliseconds:0}ms";

                await Task.Delay(delay, ct).ConfigureAwait(false);
            }
        }

        /// <summary>
        /// Deserializes a raw JSON response body string into the requested CLR type. When
        /// dataProperty is null or empty the entire body is deserialized as TResult. When a
        /// property name is provided the body is parsed as a JObject and only the value of
        /// that named property is extracted and converted, allowing envelope-wrapped responses
        /// to be unwrapped transparently without burdening callers with wrapper types.
        /// </summary>
        /// <param name="body">Raw JSON string from the HTTP response. Returns default when null or whitespace.</param>
        /// <param name="dataProperty">
        /// Name of the envelope property to unwrap, or null to deserialize the root document directly.
        /// Returns default when the property is absent from the response or its value is JSON null.
        /// </param>
        private T DeserializeBody<T>(string body, string? dataProperty)
        {
            if (string.IsNullOrWhiteSpace(body))
            {
                return default!;
            }

            if (string.IsNullOrEmpty(dataProperty))
            {
                return JsonConvert.DeserializeObject<T>(body, JsonOptions)!;
            }

            var root = JToken.Parse(body);
            var token = root is JObject obj ? obj[dataProperty!] : null;

            if (token == null || token.Type == JTokenType.Null)
            {
                return default!;
            }

            return token.ToObject<T>(_serializer)!;
        }

        /// <summary>
        /// Materializes a JToken into an arbitrary CLR type, optionally unwrapping a named envelope
        /// property before conversion. This mirrors the envelope-unwrapping behaviour of the typed
        /// DeserializeBody helper but accepts a pre-parsed JToken rather than a raw string, making
        /// it suitable for scenarios where the caller has already parsed the response document.
        /// </summary>
        /// <param name="token">The JToken to convert. Returns null when token itself is null.</param>
        /// <param name="targetType">The CLR type to convert the token or its unwrapped payload into.</param>
        /// <param name="dataProperty">
        /// Name of the child property to unwrap before conversion. When non-null and present on a
        /// JObject with a non-null value, that child token is converted rather than the root token.
        /// Defaults to "data" to match the most common API envelope convention.
        /// </param>
        protected object? DeserializeToken(JToken token, Type targetType, string? dataProperty = "data")
        {
            if (token == null)
            {
                return null;
            }

            var payload = token;
            if (!string.IsNullOrEmpty(dataProperty) && token is JObject obj && obj[dataProperty!] is JToken d && d.Type != JTokenType.Null)
            {
                payload = d;
            }

            return payload.ToObject(targetType, _serializer);
        }

        /// <summary>
        /// Calculates the delay to observe before the next retry attempt. When the response carries
        /// a Retry-After header (either as a delta-seconds value or an absolute date), that value
        /// is used directly. Otherwise an exponential back-off is computed (2^(attempt-1) seconds,
        /// capped at 60) and a sub-second jitter value is added to reduce thundering-herd effects
        /// when multiple concurrent requests are retrying simultaneously.
        /// </summary>
        /// <param name="r">The HttpResult whose response headers are inspected for Retry-After.</param>
        /// <param name="attempt">The current attempt number, used as the exponent for back-off calculation.</param>
        private TimeSpan ComputeDelay(HttpResult r, int attempt)
        {
            var ra = r.Headers?.RetryAfter;

            if (ra?.Delta is TimeSpan d)
            {
                return d;
            }

            if (ra?.Date is DateTimeOffset when)
            {
                var diff = when - DateTimeOffset.UtcNow;
                if (diff > TimeSpan.Zero)
                {
                    return diff;
                }
            }

            double secs = Math.Min(60, Math.Pow(2, attempt - 1));

            lock (_jitter)
            {
                secs += _jitter.NextDouble();
            }

            return TimeSpan.FromSeconds(secs);
        }

        /// <summary>
        /// Constructs a fully-qualified URI by combining a base address with a relative path and
        /// an optional set of query parameters. The path's leading slash is stripped before
        /// combination to ensure correct Uri resolution semantics. Query parameters are percent-encoded
        /// and appended, preserving any query string already present on the resolved URI.
        /// </summary>
        /// <param name="path">Relative API path. A leading slash is removed before resolution.</param>
        /// <param name="query">Optional query parameters; each key and value is percent-encoded individually.</param>
        /// <param name="baseOverride">
        /// When non-null, URI resolution uses this address instead of BaseAddress, allowing
        /// individual requests to target a different host or root path.
        /// </param>
        protected Uri BuildUri(string path, IReadOnlyDictionary<string, string>? query, Uri? baseOverride = null)
        {
            var uri = new Uri(baseOverride ?? BaseAddress, path.TrimStart('/'));
            if (query == null || query.Count == 0)
            {
                return uri;
            }

            var qs = string.Join("&", query.Select(kv => $"{Uri.EscapeDataString(kv.Key)}={Uri.EscapeDataString(kv.Value)}"));
            var b = new UriBuilder(uri)
            {
                Query = string.IsNullOrEmpty(uri.Query) ? qs : uri.Query.TrimStart('?') + "&" + qs
            };

            return b.Uri;
        }

        /// <summary>
        /// Issues a general-purpose HTTP request and returns the raw response as a JToken without
        /// performing any typed deserialization. Runs through the same retry and 401 re-authentication
        /// pipeline as the typed verb helpers, making it suitable for endpoints with dynamic or
        /// polymorphic response shapes where a fixed CLR type is not known at call time. A string
        /// body is treated as already-serialized JSON and forwarded verbatim; all other objects
        /// are serialized using JsonOptions.
        /// </summary>
        /// <param name="method">HTTP method to use for the request.</param>
        /// <param name="path">API path relative to BaseAddress.</param>
        /// <param name="query">Optional query parameters appended to the URI.</param>
        /// <param name="body">
        /// Optional request body. A string value is sent as-is; any other object is serialized
        /// to JSON using JsonOptions before being written to the request content.
        /// </param>
        /// <param name="ct">Cancellation token forwarded to the retry loop.</param>
        /// <exception cref="ApiException">
        /// Thrown when the final response after all retries carries a non-2xx HTTP status code.
        /// </exception>
        protected async Task<JToken?> InvokeRawAsync(HttpMethod method, string path, IReadOnlyDictionary<string, string>? query = null, object? body = null, CancellationToken ct = default)
        {
            var uri = BuildUri(path, query);

            HttpContent? ContentFactory() => body switch
            {
                null => null,
                string s => new StringContent(s, Encoding.UTF8, "application/json"),
                _ => new StringContent(JsonConvert.SerializeObject(body, JsonOptions), Encoding.UTF8, "application/json")
            };

            var result = await SendWithRetryAsync(method, uri, ContentFactory, null, allowReauth: true, ct).ConfigureAwait(false);
            if (!result.IsSuccess)
            {
                throw new ApiException((HttpStatusCode)result.StatusCode, result.Body, $"{method} {uri} failed: HTTP {result.StatusCode}");
            }

            return string.IsNullOrWhiteSpace(result.Body) ? null : JToken.Parse(result.Body);
        }

        /// <summary>
        /// Concatenates two HTTP header collections (typically a message's own headers and its
        /// content headers) into a single enumeration for diagnostics purposes. Either argument
        /// may be null, in which case it contributes no entries.
        /// </summary>
        /// <param name="primary">The primary header collection, e.g. request or response headers.</param>
        /// <param name="secondary">The secondary header collection, e.g. content headers.</param>
        private static IEnumerable<KeyValuePair<string, IEnumerable<string>>> CombineHeaders(HttpHeaders? primary, HttpHeaders? secondary)
        {
            if (primary != null)
            {
                foreach (var header in primary)
                {
                    yield return header;
                }
            }

            if (secondary != null)
            {
                foreach (var header in secondary)
                {
                    yield return header;
                }
            }
        }

        /// <summary>
        /// Maps a verb string to its corresponding HttpMethod instance in a case-insensitive manner.
        /// PATCH is constructed via the HttpMethod constructor rather than a static property because
        /// HttpMethod.Patch is not available on all targeted framework versions. Unrecognised verb
        /// strings are wrapped in a new HttpMethod instance and passed through without validation,
        /// allowing non-standard or extension methods to be used when required by a specific API.
        /// </summary>
        /// <param name="method">
        /// HTTP verb string to parse (e.g. "GET", "post", "Patch"). Returns HttpMethod.Get
        /// when null or whitespace.
        /// </param>
        public static HttpMethod ParseHttpMethod(string? method)
        {
            if (string.IsNullOrWhiteSpace(method))
            {
                return HttpMethod.Get;
            }

            return method!.Trim().ToUpperInvariant() switch
            {
                "GET" => HttpMethod.Get,
                "POST" => HttpMethod.Post,
                "PUT" => HttpMethod.Put,
                "PATCH" => new HttpMethod("PATCH"),
                "DELETE" => HttpMethod.Delete,
                "HEAD" => HttpMethod.Head,
                "OPTIONS" => HttpMethod.Options,
                var other => new HttpMethod(other)
            };
        }

        /// <summary>
        /// Flattens a non-generic IDictionary (such as a PowerShell hashtable) into a typed
        /// read-only dictionary suitable for use as a query-string parameter map. Null keys,
        /// null values, and empty key strings are silently dropped. All keys and values are
        /// converted to strings using InvariantCulture to ensure consistent encoding regardless
        /// of the caller's thread culture. Returns null when the source is null, empty, or
        /// produces no valid entries after filtering.
        /// </summary>
        /// <param name="source">
        /// The source IDictionary to flatten. Typically a PowerShell hashtable passed in from
        /// a script; the ordinal key comparer used in the result preserves API-significant casing
        /// because PowerShell hashtables are already case-insensitive at the source.
        /// </param>
        public static IReadOnlyDictionary<string, string>? ToQueryDictionary(IDictionary? source)
        {
            if (source == null || source.Count == 0)
            {
                return null;
            }

            var result = new Dictionary<string, string>(source.Count, StringComparer.Ordinal);
            foreach (DictionaryEntry entry in source)
            {
                if (entry.Key == null || entry.Value == null)
                {
                    continue;
                }

                var key = Convert.ToString(entry.Key, CultureInfo.InvariantCulture) ?? string.Empty;
                if (key.Length == 0)
                {
                    continue;
                }

                result[key] = Convert.ToString(entry.Value, CultureInfo.InvariantCulture) ?? string.Empty;
            }

            return result.Count == 0 ? null : result;
        }

        /// <summary>
        /// Synchronously blocks the calling thread until the supplied Task completes and returns
        /// its result. Intended for use in PowerShell-facing synchronous cmdlet entry points where
        /// async/await cannot be used. Should not be called from within an async context as it
        /// risks deadlocking on single-threaded synchronization contexts.
        /// </summary>
        /// <param name="task">The asynchronous task to block on.</param>
        protected static T Sync<T>(Task<T> task) => task.GetAwaiter().GetResult();

        /// <summary>
        /// Synchronously blocks the calling thread until the supplied non-generic Task completes.
        /// Intended for use in PowerShell-facing synchronous cmdlet entry points where async/await
        /// cannot be used. Should not be called from within an async context as it risks deadlocking
        /// on single-threaded synchronization contexts.
        /// </summary>
        /// <param name="task">The asynchronous task to block on.</param>
        protected static void Sync(Task task) => task.GetAwaiter().GetResult();

        /// <summary>
        /// Encapsulates the status code, raw body string, and response headers captured from a
        /// single HTTP attempt inside the retry loop. Used as the internal return type of
        /// SendWithRetryAsync to carry all relevant response data through the retry and
        /// deserialization pipeline without exposing the underlying HttpResponseMessage.
        /// </summary>
        public sealed class HttpResult
        {
            /// <summary>
            /// HTTP status code returned by the server, or 0 when the request failed at the
            /// transport layer (timeout, DNS failure, TLS reset) before a response was received.
            /// </summary>
            public int StatusCode { get; }

            /// <summary>
            /// Raw response body text as received from the server, or a descriptive error message
            /// when a transport-level exception was caught. Never null; defaults to an empty string
            /// when the response carried no body content.
            /// </summary>
            public string Body { get; }

            /// <summary>
            /// HTTP response headers from the server response, or null when the request failed at
            /// the transport layer before any response headers were received. Primarily inspected
            /// for the Retry-After header during back-off delay calculation.
            /// </summary>
            public HttpResponseHeaders? Headers { get; }

            /// <summary>
            /// Returns true when StatusCode falls in the 200–299 inclusive range, indicating a
            /// successful response that can be passed to the deserialization step. Returns false
            /// for all error status codes and for transport failures represented by status code 0.
            /// </summary>
            public bool IsSuccess => StatusCode >= 200 && StatusCode < 300;

            /// <summary>
            /// Initializes a new HttpResult with the given status code, body text, and response headers.
            /// The body parameter is coerced to an empty string when null to ensure Body is never null
            /// and downstream string checks do not require null guards in addition to empty checks.
            /// </summary>
            /// <param name="status">HTTP status code, or 0 for transport-level failures.</param>
            /// <param name="body">Raw response body string, or an error description for transport failures.</param>
            /// <param name="headers">Response headers, or null for transport-level failures.</param>
            public HttpResult(int status, string body, HttpResponseHeaders? headers)
            {
                StatusCode = status;
                Body = body ?? "";
                Headers = headers;
            }
        }

        /// <summary>
        /// Called by the Dispose pattern to release managed resources when disposing is true.
        /// Disposes the internal HttpClient instance; because the HttpClient was constructed with
        /// disposeHandler: false, the shared SocketsHttpHandler is left alive and continues to
        /// serve other client instances. The _disposed flag prevents double-disposal.
        /// </summary>
        /// <param name="disposing">
        /// True when called from the public Dispose() method; false when called from a finalizer,
        /// in which case managed resources must not be accessed as they may have already been collected.
        /// </param>
        protected virtual void Dispose(bool disposing)
        {
            if (_disposed)
            {
                return;
            }

            if (disposing)
            {
                _http.Dispose();
            }

            _disposed = true;
        }

        /// <summary>
        /// Releases all managed resources held by this HttpClientBase instance and suppresses
        /// finalization. Calls the virtual Dispose(bool) overload with disposing: true so that
        /// derived classes can participate in the disposal chain by overriding that method.
        /// Safe to call multiple times; subsequent calls after the first are no-ops.
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}