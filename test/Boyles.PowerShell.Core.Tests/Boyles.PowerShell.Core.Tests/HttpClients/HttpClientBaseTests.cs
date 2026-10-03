using System.Collections;
using System.Net;
using System.Net.Http.Headers;
using System.Net.Sockets;
using System.Text;

using Boyles.PowerShell.Authentication;
using Boyles.PowerShell.Diagnostics;
using Boyles.PowerShell.Exceptions;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Boyles.PowerShell.HttpClients
{
    // HttpClientBase always talks through the real, process-shared HttpTransport handler - there
    // is no seam to substitute a fake HttpMessageHandler. FakeHttpServer stands in a real
    // loopback-only HTTP endpoint instead, so these exercise the base client's actual
    // request/response/retry/pagination pipeline end to end, the same approach used by
    // OAuth2ClientCredentialsProviderTests.
    public class HttpClientBaseTests
    {
        [Theory]
        [InlineData(null)]
        [InlineData("")]
        [InlineData("   ")]
        public void Constructor_NullOrWhitespaceBaseUrl_ThrowsArgumentException(string? baseUrl)
        {
            Assert.Throws<ArgumentException>(() => new TestHttpClient(baseUrl!, new FakeAuthProvider()));
        }

        [Fact]
        public void Constructor_NullAuth_ThrowsArgumentNullException()
        {
            Assert.Throws<ArgumentNullException>(() => new TestHttpClient("https://example.test/", null!));
        }

        [Theory]
        [InlineData("https://example.test/api")]
        [InlineData("https://example.test/api/")]
        public void Constructor_AlwaysAppendsTrailingSlashToBaseAddress(string baseUrl)
        {
            using var client = new TestHttpClient(baseUrl, new FakeAuthProvider());

            Assert.Equal("https://example.test/api/", client.BaseAddress.ToString());
        }

        [Fact]
        public void Constructor_NoJsonOptionsSupplied_UsesDefaultJson()
        {
            using var client = new TestHttpClient("https://example.test/", new FakeAuthProvider());

            Assert.Same(HttpClientBase.DefaultJson, client.ExposedJsonOptions);
        }

        [Fact]
        public void Constructor_JsonOptionsSupplied_UsesSuppliedInstance()
        {
            var custom = new JsonSerializerSettings();
            using var client = new TestHttpClient("https://example.test/", new FakeAuthProvider(), custom);

            Assert.Same(custom, client.ExposedJsonOptions);
        }

        [Fact]
        public void Defaults_MaxRetriesIsFiveAndMaxPagesIsTenThousand()
        {
            using var client = new TestHttpClient("https://example.test/", new FakeAuthProvider());

            Assert.Equal(5, client.MaxRetries);
            Assert.Equal(10_000, client.MaxPages);
        }

        [Fact]
        public async Task GetAsync_ReturnsDeserializedBody()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, """{"widget_name":"gizmo","widget_count":3}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var result = await client.Get<Widget>("widgets/1", ct: CancellationToken.None);

            Assert.Equal("gizmo", result.WidgetName);
            Assert.Equal(3, result.WidgetCount);
            Assert.Equal("GET", server.Requests[0].Method);
        }

        [Fact]
        public async Task GetAsync_SendsSuppliedQueryParameters()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, """{"widget_name":"gizmo","widget_count":1}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            await client.Get<Widget>("widgets", new Dictionary<string, string> { ["active"] = "true" }, ct: CancellationToken.None);

            var query = ParseQuery(server.Requests[0].Path);
            Assert.Equal("true", query["active"]);
        }

        [Fact]
        public async Task GetAsync_UnwrapsNamedEnvelopeProperty()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, """{"widget":{"widget_name":"gizmo","widget_count":5}}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var result = await client.Get<Widget>("widgets/1", itemsProperty: "widget", ct: CancellationToken.None);

            Assert.Equal("gizmo", result.WidgetName);
            Assert.Equal(5, result.WidgetCount);
        }

        [Fact]
        public async Task GetAsync_EnvelopePropertyMissing_ReturnsDefault()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, """{"other":null}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var result = await client.Get<Widget>("widgets/1", itemsProperty: "widget", ct: CancellationToken.None);

            Assert.Null(result);
        }

        [Fact]
        public async Task RequestAsync_SetsUserAgentAcceptAndAuthorizationHeaders()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, """{"widget_name":"gizmo","widget_count":1}""");
            var auth = new FakeAuthProvider();
            using var client = new TestHttpClient(server.Url, auth);

            await client.Get<Widget>("widgets/1", ct: CancellationToken.None);

            var headers = server.Requests[0].Headers;
            Assert.StartsWith("Boyles.PowerShell/", headers["User-Agent"]);
            Assert.Contains("application/json", headers["Accept"]);
            Assert.Equal("Bearer token0", headers["Authorization"]);
        }

        [Fact]
        public async Task PostAsync_SerializesBodyAsSnakeCaseJson()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, """{"widget_name":"gizmo","widget_count":2}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var result = await client.Post<Widget>("widgets", new Widget { WidgetName = "gizmo", WidgetCount = 2 }, ct: CancellationToken.None);

            Assert.Contains("\"widget_name\":\"gizmo\"", server.Requests[0].Body);
            Assert.Contains("\"widget_count\":2", server.Requests[0].Body);
            Assert.Equal("gizmo", result.WidgetName);
        }

        [Fact]
        public async Task PostAsync_NullBody_SendsNoContentAndReturnsDefaultOnEmptyResponse()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, "");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var result = await client.Post<Widget>("widgets", null, ct: CancellationToken.None);

            Assert.Equal("", server.Requests[0].Body);
            Assert.Null(result);
        }

        [Fact]
        public async Task PutAsync_SendsBodyAndReturnsDeserializedResult()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, """{"widget_name":"renamed","widget_count":9}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var result = await client.Put<Widget>("widgets/1", new Widget { WidgetName = "renamed", WidgetCount = 9 }, ct: CancellationToken.None);

            Assert.Equal("PUT", server.Requests[0].Method);
            Assert.Equal("renamed", result.WidgetName);
        }

        [Fact]
        public async Task PatchAsync_UsesLiteralPatchHttpMethod()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, """{"widget_name":"patched","widget_count":1}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            await client.Patch<Widget>("widgets/1", new Widget { WidgetName = "patched", WidgetCount = 1 }, ct: CancellationToken.None);

            Assert.Equal("PATCH", server.Requests[0].Method);
        }

        [Fact]
        public async Task DeleteAsync_SendsNoBodyAndReturnsDeserializedResult()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, """{"deleted":true}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var result = await client.Delete<JObject>("widgets/1", ct: CancellationToken.None);

            Assert.Equal("DELETE", server.Requests[0].Method);
            Assert.Equal("", server.Requests[0].Body);
            Assert.True(result.Value<bool>("deleted"));
        }

        [Fact]
        public async Task RequestAsync_NonSuccessStatus_ThrowsApiExceptionWithStatusAndBody()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(404, """{"error":"not_found"}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var ex = await Assert.ThrowsAsync<ApiException>(() => client.Get<Widget>("widgets/999", ct: CancellationToken.None));

            Assert.Equal(HttpStatusCode.NotFound, ex.StatusCode);
            Assert.Contains("not_found", ex.ResponseBody);
            Assert.Equal(1, server.RequestCount);
        }

        [Fact]
        public async Task RequestAsync_RetriesOn500ThenSucceeds()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(500, """{"error":"boom"}""", new Dictionary<string, string> { ["Retry-After"] = "0" });
            server.Enqueue(200, """{"widget_name":"gizmo","widget_count":1}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var result = await client.Get<Widget>("widgets/1", ct: CancellationToken.None);

            Assert.Equal("gizmo", result.WidgetName);
            Assert.Equal(2, server.RequestCount);
        }

        [Fact]
        public async Task RequestAsync_RetriesOn429ThenSucceeds()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(429, """{"error":"slow_down"}""", new Dictionary<string, string> { ["Retry-After"] = "0" });
            server.Enqueue(200, """{"widget_name":"gizmo","widget_count":1}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var result = await client.Get<Widget>("widgets/1", ct: CancellationToken.None);

            Assert.Equal("gizmo", result.WidgetName);
            Assert.Equal(2, server.RequestCount);
        }

        [Fact]
        public async Task RequestAsync_ExhaustsMaxRetries_ThrowsApiException()
        {
            using var server = new FakeHttpServer();
            var retryHeaders = new Dictionary<string, string> { ["Retry-After"] = "0" };
            server.Enqueue(500, """{"error":"boom"}""", retryHeaders);
            server.Enqueue(500, """{"error":"boom"}""", retryHeaders);
            server.Enqueue(500, """{"error":"boom"}""", retryHeaders);
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider()) { MaxRetries = 2 };

            var ex = await Assert.ThrowsAsync<ApiException>(() => client.Get<Widget>("widgets/1", ct: CancellationToken.None));

            Assert.Equal(HttpStatusCode.InternalServerError, ex.StatusCode);
            Assert.Equal(3, server.RequestCount);
        }

        [Fact]
        public async Task RequestAsync_401_InvalidatesAuthAndRetriesOnceThenSucceeds()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(401, """{"error":"unauthorized"}""");
            server.Enqueue(200, """{"widget_name":"gizmo","widget_count":1}""");
            var auth = new FakeAuthProvider();
            using var client = new TestHttpClient(server.Url, auth);

            var result = await client.Get<Widget>("widgets/1", ct: CancellationToken.None);

            Assert.Equal("gizmo", result.WidgetName);
            Assert.Equal(2, server.RequestCount);
            Assert.Equal(1, auth.InvalidateCount);
            Assert.Equal("Bearer token0", server.Requests[0].Headers["Authorization"]);
            Assert.Equal("Bearer token1", server.Requests[1].Headers["Authorization"]);
        }

        [Fact]
        public async Task RequestAsync_Repeated401_ThrowsAfterSingleReauthAttempt()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(401, """{"error":"unauthorized"}""");
            server.Enqueue(401, """{"error":"unauthorized"}""");
            var auth = new FakeAuthProvider();
            using var client = new TestHttpClient(server.Url, auth);

            var ex = await Assert.ThrowsAsync<ApiException>(() => client.Get<Widget>("widgets/1", ct: CancellationToken.None));

            Assert.Equal(HttpStatusCode.Unauthorized, ex.StatusCode);
            Assert.Equal(2, server.RequestCount);
            Assert.Equal(1, auth.InvalidateCount);
        }

        [Fact]
        public async Task Diagnostics_RecordsOneEntryPerAttemptSharingCorrelationId()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(500, """{"error":"boom"}""", new Dictionary<string, string> { ["Retry-After"] = "0" });
            server.Enqueue(200, """{"widget_name":"gizmo","widget_count":1}""");
            var sink = new RecordingDiagnosticsSink();
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider(), diagnosticsSink: sink);

            await client.Get<Widget>("widgets/1", ct: CancellationToken.None);

            Assert.Equal(2, sink.Records.Count);
            Assert.Equal(sink.Records[0].CorrelationId, sink.Records[1].CorrelationId);
            Assert.False(sink.Records[0].IsRetry);
            Assert.True(sink.Records[1].IsRetry);
            Assert.Contains("backoff", sink.Records[1].RetryReason);
            Assert.Equal(500, sink.Records[0].ResponseStatusCode);
            Assert.Equal(200, sink.Records[1].ResponseStatusCode);
        }

        [Fact]
        public async Task GetAllPagesAsync_OffsetMode_CollectsItemsAcrossPagesAndStopsOnShortPage()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, """{"items":[{"id":1},{"id":2}]}""");
            server.Enqueue(200, """{"items":[{"id":3}]}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var items = await client.GetAllPages<Item>("items", pageSize: 2, ct: CancellationToken.None);

            Assert.Equal([1, 2, 3], items.Select(i => i.Id));
            Assert.Equal(2, server.RequestCount);

            var firstQuery = ParseQuery(server.Requests[0].Path);
            Assert.Equal("2", firstQuery["limit"]);
            Assert.Equal("0", firstQuery["offset"]);

            var secondQuery = ParseQuery(server.Requests[1].Path);
            Assert.Equal("2", secondQuery["offset"]);
        }

        [Fact]
        public async Task GetAllPagesAsync_PageNumberMode_IncrementsPageParameter()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, """{"items":[{"id":1},{"id":2}]}""");
            server.Enqueue(200, """{"items":[{"id":3}]}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var items = await client.GetAllPages<Item>(
                "items",
                pageSize: 2,
                limitParam: "page_size",
                offsetParam: "page",
                mode: PaginationMode.PageNumber,
                firstPage: 1,
                ct: CancellationToken.None);

            Assert.Equal([1, 2, 3], items.Select(i => i.Id));

            var firstQuery = ParseQuery(server.Requests[0].Path);
            Assert.Equal("1", firstQuery["page"]);

            var secondQuery = ParseQuery(server.Requests[1].Path);
            Assert.Equal("2", secondQuery["page"]);
        }

        [Fact]
        public async Task GetAllPagesAsync_BareArrayResponse_IsSupported()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, """[{"id":1},{"id":2}]""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var items = await client.GetAllPages<Item>("items", pageSize: 5, ct: CancellationToken.None);

            Assert.Equal([1, 2], items.Select(i => i.Id));
            Assert.Equal(1, server.RequestCount);
        }

        [Fact]
        public async Task GetAllPagesAsync_RepeatedIdenticalPage_EndsLoopWithoutDuplicatingItems()
        {
            using var server = new FakeHttpServer();
            const string page = """{"items":[{"id":1},{"id":2}]}""";
            server.Enqueue(200, page);
            server.Enqueue(200, page);
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var items = await client.GetAllPages<Item>("items", pageSize: 2, ct: CancellationToken.None);

            Assert.Equal([1, 2], items.Select(i => i.Id));
            Assert.Equal(2, server.RequestCount);
        }

        [Fact]
        public async Task GetAllPagesAsync_ExceedsMaxPages_ThrowsInvalidOperationException()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, """{"items":[{"id":1},{"id":2}]}""");
            server.Enqueue(200, """{"items":[{"id":3},{"id":4}]}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider()) { MaxPages = 2 };

            await Assert.ThrowsAsync<InvalidOperationException>(() => client.GetAllPages<Item>("items", pageSize: 2, ct: CancellationToken.None));

            Assert.Equal(2, server.RequestCount);
        }

        [Fact]
        public void BuildUri_StripsLeadingSlashFromPath()
        {
            using var client = new TestHttpClient("https://example.test/api/", new FakeAuthProvider());

            var uri = client.PublicBuildUri("/widgets", null);

            Assert.Equal("https://example.test/api/widgets", uri.ToString());
        }

        [Fact]
        public void BuildUri_AppendsQueryParametersPercentEncoded()
        {
            using var client = new TestHttpClient("https://example.test/api/", new FakeAuthProvider());

            var uri = client.PublicBuildUri("widgets", new Dictionary<string, string> { ["q"] = "a b" });

            Assert.Equal("?q=a%20b", uri.Query);
        }

        [Fact]
        public void BuildUri_PreservesExistingQueryStringOnPath()
        {
            using var client = new TestHttpClient("https://example.test/api/", new FakeAuthProvider());

            var uri = client.PublicBuildUri("widgets?existing=1", new Dictionary<string, string> { ["extra"] = "2" });

            Assert.Equal("?existing=1&extra=2", uri.Query);
        }

        [Fact]
        public void DeserializeToken_NullToken_ReturnsNull()
        {
            using var client = new TestHttpClient("https://example.test/", new FakeAuthProvider());

            var result = client.PublicDeserializeToken(null!, typeof(Widget));

            Assert.Null(result);
        }

        [Fact]
        public void DeserializeToken_UnwrapsDefaultDataProperty()
        {
            using var client = new TestHttpClient("https://example.test/", new FakeAuthProvider());
            var token = JObject.Parse("""{"data":{"widget_name":"foo","widget_count":3}}""");

            var result = (Widget)client.PublicDeserializeToken(token, typeof(Widget))!;

            Assert.Equal("foo", result.WidgetName);
            Assert.Equal(3, result.WidgetCount);
        }

        [Fact]
        public void DeserializeToken_CustomDataProperty()
        {
            using var client = new TestHttpClient("https://example.test/", new FakeAuthProvider());
            var token = JObject.Parse("""{"result":{"widget_name":"bar","widget_count":1}}""");

            var result = (Widget)client.PublicDeserializeToken(token, typeof(Widget), "result")!;

            Assert.Equal("bar", result.WidgetName);
        }

        [Fact]
        public void DeserializeToken_NoMatchingProperty_ConvertsRootToken()
        {
            using var client = new TestHttpClient("https://example.test/", new FakeAuthProvider());
            var token = JObject.Parse("""{"widget_name":"baz","widget_count":2}""");

            var result = (Widget)client.PublicDeserializeToken(token, typeof(Widget))!;

            Assert.Equal("baz", result.WidgetName);
        }

        [Fact]
        public async Task InvokeRawAsync_StringBody_SentVerbatim()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, "{}");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            await client.PublicInvokeRawAsync(HttpMethod.Post, "raw", body: "{\"raw\":true}", ct: CancellationToken.None);

            Assert.Equal("{\"raw\":true}", server.Requests[0].Body);
        }

        [Fact]
        public async Task InvokeRawAsync_ObjectBody_SerializedAsSnakeCaseJson()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, "{}");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            await client.PublicInvokeRawAsync(HttpMethod.Post, "raw", body: new { FooBar = "baz" }, ct: CancellationToken.None);

            Assert.Equal("""{"foo_bar":"baz"}""", server.Requests[0].Body);
        }

        [Fact]
        public async Task InvokeRawAsync_EmptyResponseBody_ReturnsNull()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(200, "");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            var result = await client.PublicInvokeRawAsync(HttpMethod.Get, "raw", ct: CancellationToken.None);

            Assert.Null(result);
        }

        [Fact]
        public async Task InvokeRawAsync_NonSuccessStatus_ThrowsApiException()
        {
            using var server = new FakeHttpServer();
            server.Enqueue(500, """{"error":"boom"}""");
            using var client = new TestHttpClient(server.Url, new FakeAuthProvider()) { MaxRetries = 0 };

            await Assert.ThrowsAsync<ApiException>(() => client.PublicInvokeRawAsync(HttpMethod.Get, "raw", ct: CancellationToken.None));
        }

        [Theory]
        [InlineData("get", "GET")]
        [InlineData("POST", "POST")]
        [InlineData("Put", "PUT")]
        [InlineData("patch", "PATCH")]
        [InlineData("DELETE", "DELETE")]
        [InlineData("head", "HEAD")]
        [InlineData("options", "OPTIONS")]
        public void ParseHttpMethod_RecognizedVerbs_AreCaseInsensitive(string input, string expected)
        {
            Assert.Equal(expected, HttpClientBase.ParseHttpMethod(input).Method);
        }

        [Theory]
        [InlineData(null)]
        [InlineData("")]
        [InlineData("   ")]
        public void ParseHttpMethod_NullOrWhitespace_ReturnsGet(string? input)
        {
            Assert.Equal(HttpMethod.Get, HttpClientBase.ParseHttpMethod(input));
        }

        [Fact]
        public void ParseHttpMethod_UnrecognizedVerb_PassesThroughUppercased()
        {
            Assert.Equal("TRACE", HttpClientBase.ParseHttpMethod(" trace ").Method);
        }

        [Fact]
        public void ToQueryDictionary_NullSource_ReturnsNull()
        {
            Assert.Null(HttpClientBase.ToQueryDictionary(null));
        }

        [Fact]
        public void ToQueryDictionary_EmptySource_ReturnsNull()
        {
            Assert.Null(HttpClientBase.ToQueryDictionary(new Hashtable()));
        }

        [Fact]
        public void ToQueryDictionary_DropsNullValuedEntries()
        {
            var source = new Hashtable
            {
                ["keep"] = "value",
                ["drop"] = null
            };

            var result = HttpClientBase.ToQueryDictionary(source);

            Assert.NotNull(result);
            Assert.Equal("value", result!["keep"]);
            Assert.False(result.ContainsKey("drop"));
        }

        [Fact]
        public void ToQueryDictionary_AllEntriesFilteredOut_ReturnsNull()
        {
            var source = new Hashtable { ["drop"] = null };

            Assert.Null(HttpClientBase.ToQueryDictionary(source));
        }

        [Fact]
        public void ToQueryDictionary_ConvertsNonStringValuesToStrings()
        {
            var source = new Hashtable
            {
                ["count"] = 42,
                ["flag"] = true
            };

            var result = HttpClientBase.ToQueryDictionary(source);

            Assert.NotNull(result);
            Assert.Equal("42", result!["count"]);
            Assert.Equal("True", result["flag"]);
        }

        [Theory]
        [InlineData(199, false)]
        [InlineData(200, true)]
        [InlineData(299, true)]
        [InlineData(300, false)]
        [InlineData(0, false)]
        public void HttpResult_IsSuccess_TrueOnlyForTwoHundredRange(int statusCode, bool expected)
        {
            var result = new HttpClientBase.HttpResult(statusCode, "body", null);

            Assert.Equal(expected, result.IsSuccess);
        }

        [Fact]
        public void HttpResult_NullBody_CoercedToEmptyString()
        {
            var result = new HttpClientBase.HttpResult(200, null!, null);

            Assert.Equal("", result.Body);
        }

        [Fact]
        public void Dispose_CanBeCalledMultipleTimesWithoutThrowing()
        {
            var client = new TestHttpClient("https://example.test/", new FakeAuthProvider());

            client.Dispose();
            client.Dispose();
        }

        [Fact]
        public async Task Dispose_DisposesUnderlyingHttpClient_SoSubsequentSendThrows()
        {
            using var server = new FakeHttpServer();
            var client = new TestHttpClient(server.Url, new FakeAuthProvider());

            client.Dispose();

            await Assert.ThrowsAsync<ObjectDisposedException>(() => client.Get<Widget>("widgets/1", ct: CancellationToken.None));
        }

        private static Dictionary<string, string> ParseQuery(string rawUrlWithQuery)
        {
            var result = new Dictionary<string, string>(StringComparer.Ordinal);

            var queryStart = rawUrlWithQuery.IndexOf('?');
            if (queryStart < 0)
            {
                return result;
            }

            var query = rawUrlWithQuery[(queryStart + 1)..];
            foreach (var pair in query.Split('&', StringSplitOptions.RemoveEmptyEntries))
            {
                var parts = pair.Split('=', 2);
                var key = Uri.UnescapeDataString(parts[0]);
                var value = parts.Length > 1 ? Uri.UnescapeDataString(parts[1]) : string.Empty;
                result[key] = value;
            }

            return result;
        }

        private sealed class Widget
        {
            public string? WidgetName { get; set; }

            public int WidgetCount { get; set; }
        }

        private sealed class Item
        {
            public int Id { get; set; }
        }

        /// <summary>
        /// Thin subclass exposing HttpClientBase's protected members so the pipeline can be
        /// exercised directly from test code without a real-world service client.
        /// </summary>
        private sealed class TestHttpClient : HttpClientBase
        {
            public TestHttpClient(string baseUrl, IAuthenticationProvider auth, JsonSerializerSettings? json = null, IHttpDiagnosticsSink? diagnosticsSink = null)
                : base(baseUrl, auth, json, diagnosticsSink)
            {
            }

            public JsonSerializerSettings ExposedJsonOptions => JsonOptions;

            public Task<T> Get<T>(string path, IReadOnlyDictionary<string, string>? query = null, string? itemsProperty = null, CancellationToken ct = default)
                => GetAsync<T>(path, query, itemsProperty, ct);

            public Task<T> Post<T>(string path, object? body, string? itemsProperty = null, CancellationToken ct = default)
                => PostAsync<T>(path, body, itemsProperty, ct);

            public Task<T> Put<T>(string path, object? body, string? itemsProperty = null, CancellationToken ct = default)
                => PutAsync<T>(path, body, itemsProperty, ct);

            public Task<T> Patch<T>(string path, object? body, string? itemsProperty = null, CancellationToken ct = default)
                => PatchAsync<T>(path, body, itemsProperty, ct);

            public Task<T> Delete<T>(string path, string? itemsProperty = null, CancellationToken ct = default)
                => DeleteAsync<T>(path, itemsProperty, ct);

            public Task<List<T>> GetAllPages<T>(
                string path,
                IReadOnlyDictionary<string, string>? baseQuery = null,
                int pageSize = 100,
                string itemsProperty = "items",
                string limitParam = "limit",
                string offsetParam = "offset",
                PaginationMode mode = PaginationMode.Offset,
                int firstPage = 1,
                CancellationToken ct = default)
                => GetAllPagesAsync<T>(path, baseQuery, pageSize, itemsProperty, limitParam, offsetParam, mode, firstPage, ct: ct);

            public Uri PublicBuildUri(string path, IReadOnlyDictionary<string, string>? query) => BuildUri(path, query);

            public object? PublicDeserializeToken(JToken token, Type targetType, string? dataProperty = "data")
                => DeserializeToken(token, targetType, dataProperty);

            public Task<JToken?> PublicInvokeRawAsync(HttpMethod method, string path, IReadOnlyDictionary<string, string>? query = null, object? body = null, CancellationToken ct = default)
                => InvokeRawAsync(method, path, query, body, ct);
        }

        private sealed class FakeAuthProvider : IAuthenticationProvider
        {
            private int _version;

            public int InvalidateCount { get; private set; }

            public Task ApplyAsync(HttpRequestMessage request, bool forceRefresh, CancellationToken ct)
            {
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", $"token{_version}");
                return Task.CompletedTask;
            }

            public Task InvalidateAsync(CancellationToken ct)
            {
                InvalidateCount++;
                _version++;
                return Task.CompletedTask;
            }
        }

        private sealed class RecordingDiagnosticsSink : IHttpDiagnosticsSink
        {
            public List<HttpCallRecord> Records { get; } = new();

            public Task RecordAsync(HttpCallRecord record)
            {
                lock (Records)
                {
                    Records.Add(record);
                }

                return Task.CompletedTask;
            }
        }

        private sealed class RecordedRequest
        {
            public string Method { get; init; } = "";

            public string Path { get; init; } = "";

            public string Body { get; init; } = "";

            public IReadOnlyDictionary<string, string> Headers { get; init; } = new Dictionary<string, string>();
        }

        /// <summary>
        /// A minimal loopback-only HTTP server for exercising HttpClientBase's real network
        /// pipeline. Records every received request's method, path, body and headers, and hands
        /// back queued (status, body, headers) responses in order; the server keeps returning an
        /// empty "{}" 200 once the queue runs dry.
        /// </summary>
        private sealed class FakeHttpServer : IDisposable
        {
            private readonly HttpListener _listener;
            private readonly Queue<(int Status, string Body, IReadOnlyDictionary<string, string>? Headers)> _responses = new();
            private readonly List<RecordedRequest> _requests = new();
            private readonly Task _acceptLoop;

            public FakeHttpServer()
            {
                var port = GetFreeLoopbackPort();
                Url = $"http://127.0.0.1:{port}/";

                _listener = new HttpListener();
                _listener.Prefixes.Add(Url);
                _listener.Start();

                _acceptLoop = Task.Run(AcceptLoopAsync);
            }

            public string Url { get; }

            public IReadOnlyList<RecordedRequest> Requests
            {
                get
                {
                    lock (_requests)
                    {
                        return _requests.ToArray();
                    }
                }
            }

            public int RequestCount
            {
                get
                {
                    lock (_requests)
                    {
                        return _requests.Count;
                    }
                }
            }

            public void Enqueue(int status, string body, IReadOnlyDictionary<string, string>? headers = null)
                => _responses.Enqueue((status, body, headers));

            private async Task AcceptLoopAsync()
            {
                while (_listener.IsListening)
                {
                    HttpListenerContext context;
                    try
                    {
                        context = await _listener.GetContextAsync().ConfigureAwait(false);
                    }
                    catch (Exception)
                    {
                        // Listener was stopped/disposed - exit quietly.
                        return;
                    }

                    string body;
                    using (var reader = new StreamReader(context.Request.InputStream))
                    {
                        body = await reader.ReadToEndAsync().ConfigureAwait(false);
                    }

                    var headers = context.Request.Headers.AllKeys
                        .Where(k => k != null)
                        .ToDictionary(k => k!, k => context.Request.Headers[k] ?? string.Empty, StringComparer.OrdinalIgnoreCase);

                    lock (_requests)
                    {
                        _requests.Add(new RecordedRequest
                        {
                            Method = context.Request.HttpMethod,
                            Path = context.Request.RawUrl ?? "",
                            Body = body,
                            Headers = headers
                        });
                    }

                    var (status, responseBody, responseHeaders) = _responses.Count > 0 ? _responses.Dequeue() : (200, "{}", null);

                    context.Response.StatusCode = status;
                    context.Response.ContentType = "application/json";

                    if (responseHeaders != null)
                    {
                        foreach (var kv in responseHeaders)
                        {
                            context.Response.Headers[kv.Key] = kv.Value;
                        }
                    }

                    var bytes = Encoding.UTF8.GetBytes(responseBody);
                    context.Response.ContentLength64 = bytes.Length;
                    await context.Response.OutputStream.WriteAsync(bytes).ConfigureAwait(false);
                    context.Response.OutputStream.Close();
                }
            }

            private static int GetFreeLoopbackPort()
            {
                var probe = new TcpListener(IPAddress.Loopback, 0);
                probe.Start();
                var port = ((IPEndPoint)probe.LocalEndpoint).Port;
                probe.Stop();
                return port;
            }

            public void Dispose()
            {
                _listener.Stop();
                _listener.Close();
            }
        }
    }
}
