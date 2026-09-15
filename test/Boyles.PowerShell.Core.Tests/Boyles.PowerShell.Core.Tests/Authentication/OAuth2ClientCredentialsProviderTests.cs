using System.Net;
using System.Net.Sockets;

using Boyles.PowerShell.Exceptions;

namespace Boyles.PowerShell.Authentication
{
    // OAuth2ClientCredentialsProvider always talks to its token URL through the real,
    // process-shared HttpTransport handler - there is no seam to substitute a fake
    // HttpMessageHandler. FakeTokenServer stands in a real loopback-only HTTP endpoint instead,
    // so these exercise the provider's actual request/response/caching behavior end to end.
    public class OAuth2ClientCredentialsProviderTests
    {
        [Fact]
        public async Task ApplyAsync_SetsBearerHeader_FromFetchedAccessToken()
        {
            using var server = new FakeTokenServer();
            server.Enqueue(200, """{"access_token":"abc123","expires_in":3600}""");

            var provider = new OAuth2ClientCredentialsProvider(server.Url, "client-id", "client-secret");
            using var request = new HttpRequestMessage(HttpMethod.Get, "https://example.test/");

            await provider.ApplyAsync(request, forceRefresh: false, CancellationToken.None);

            Assert.Equal("Bearer abc123", request.Headers.GetValues("Authorization").Single());
            Assert.Equal(1, server.RequestCount);

            var form = server.Requests[0];
            Assert.Equal("client_credentials", form["grant_type"]);
            Assert.Equal("client-id", form["client_id"]);
            Assert.Equal("client-secret", form["client_secret"]);
            Assert.False(form.ContainsKey("scope"));
        }

        [Fact]
        public async Task GetAccessTokenAsync_IncludesScope_WhenProvided()
        {
            using var server = new FakeTokenServer();
            server.Enqueue(200, """{"access_token":"abc123","expires_in":3600}""");

            var provider = new OAuth2ClientCredentialsProvider(server.Url, "client-id", "client-secret", scope: "read write");

            await provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None);

            Assert.Equal("read write", server.Requests[0]["scope"]);
        }

        [Fact]
        public async Task GetAccessTokenAsync_CachesToken_WithinExpiry()
        {
            using var server = new FakeTokenServer();
            server.Enqueue(200, """{"access_token":"first","expires_in":3600}""");

            var provider = new OAuth2ClientCredentialsProvider(server.Url, "client-id", "client-secret");

            var first = await provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None);
            var second = await provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None);

            Assert.Equal("first", first);
            Assert.Equal("first", second);
            Assert.Equal(1, server.RequestCount);
        }

        [Fact]
        public async Task GetAccessTokenAsync_ForceRefresh_BypassesCache()
        {
            using var server = new FakeTokenServer();
            server.Enqueue(200, """{"access_token":"first","expires_in":3600}""");
            server.Enqueue(200, """{"access_token":"second","expires_in":3600}""");

            var provider = new OAuth2ClientCredentialsProvider(server.Url, "client-id", "client-secret");

            var first = await provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None);
            var second = await provider.GetAccessTokenAsync(forceRefresh: true, CancellationToken.None);

            Assert.Equal("first", first);
            Assert.Equal("second", second);
            Assert.Equal(2, server.RequestCount);
        }

        [Fact]
        public async Task InvalidateAsync_ClearsCachedToken_SoNextCallRefetches()
        {
            using var server = new FakeTokenServer();
            server.Enqueue(200, """{"access_token":"first","expires_in":3600}""");
            server.Enqueue(200, """{"access_token":"second","expires_in":3600}""");

            var provider = new OAuth2ClientCredentialsProvider(server.Url, "client-id", "client-secret");

            var first = await provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None);
            await provider.InvalidateAsync(CancellationToken.None);
            var second = await provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None);

            Assert.Equal("first", first);
            Assert.Equal("second", second);
            Assert.Equal(2, server.RequestCount);
        }

        [Fact]
        public async Task GetAccessTokenAsync_ShortLivedToken_IsNotConsideredFresh_UnderDefaultSkew()
        {
            // expires_in (1s) is well under the default 60s skew, so IsFresh() should treat the
            // token as stale immediately - both calls should hit the server.
            using var server = new FakeTokenServer();
            server.Enqueue(200, """{"access_token":"first","expires_in":1}""");
            server.Enqueue(200, """{"access_token":"second","expires_in":1}""");

            var provider = new OAuth2ClientCredentialsProvider(server.Url, "client-id", "client-secret");

            var first = await provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None);
            var second = await provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None);

            Assert.Equal("first", first);
            Assert.Equal("second", second);
            Assert.Equal(2, server.RequestCount);
        }

        [Fact]
        public async Task GetAccessTokenAsync_ShortLivedToken_IsFresh_WhenSkewDisabled()
        {
            using var server = new FakeTokenServer();
            server.Enqueue(200, """{"access_token":"first","expires_in":30}""");

            var provider = new OAuth2ClientCredentialsProvider(server.Url, "client-id", "client-secret")
            {
                SkewSeconds = 0
            };

            var first = await provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None);
            var second = await provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None);

            Assert.Equal("first", first);
            Assert.Equal("first", second);
            Assert.Equal(1, server.RequestCount);
        }

        [Fact]
        public async Task GetAccessTokenAsync_ExpiresInZero_FallsBackToDefaultTtl()
        {
            // expires_in <= 0 falls back to a 3600s default, which is well outside the default
            // skew, so an immediate second call should still be served from cache.
            using var server = new FakeTokenServer();
            server.Enqueue(200, """{"access_token":"first","expires_in":0}""");

            var provider = new OAuth2ClientCredentialsProvider(server.Url, "client-id", "client-secret");

            var first = await provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None);
            var second = await provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None);

            Assert.Equal("first", first);
            Assert.Equal("first", second);
            Assert.Equal(1, server.RequestCount);
        }

        [Fact]
        public async Task GetAccessTokenAsync_NonSuccessStatus_ThrowsApiException()
        {
            using var server = new FakeTokenServer();
            server.Enqueue(401, """{"error":"invalid_client"}""");

            var provider = new OAuth2ClientCredentialsProvider(server.Url, "client-id", "client-secret");

            var ex = await Assert.ThrowsAsync<ApiException>(
                () => provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None));

            Assert.Equal(HttpStatusCode.Unauthorized, ex.StatusCode);
            Assert.Contains("invalid_client", ex.ResponseBody);
        }

        [Fact]
        public async Task GetAccessTokenAsync_ResponseMissingAccessToken_ThrowsApiException()
        {
            using var server = new FakeTokenServer();
            server.Enqueue(200, "{}");

            var provider = new OAuth2ClientCredentialsProvider(server.Url, "client-id", "client-secret");

            await Assert.ThrowsAsync<ApiException>(
                () => provider.GetAccessTokenAsync(forceRefresh: false, CancellationToken.None));
        }

        /// <summary>
        /// A minimal loopback-only HTTP server for exercising OAuth2ClientCredentialsProvider's
        /// real network calls without reaching an external endpoint. Records every request's
        /// posted form fields and hands back queued (status, body) responses in order; the
        /// server keeps returning an empty "{}" 200 once the queue runs dry.
        /// </summary>
        private sealed class FakeTokenServer : IDisposable
        {
            private readonly HttpListener _listener;
            private readonly Queue<(int Status, string Body)> _responses = new();
            private readonly List<Dictionary<string, string>> _requests = new();
            private readonly Task _acceptLoop;

            public FakeTokenServer()
            {
                var port = GetFreeLoopbackPort();
                Url = $"http://127.0.0.1:{port}/token";

                _listener = new HttpListener();
                _listener.Prefixes.Add($"http://127.0.0.1:{port}/");
                _listener.Start();

                _acceptLoop = Task.Run(AcceptLoopAsync);
            }

            public string Url { get; }

            public IReadOnlyList<Dictionary<string, string>> Requests
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

            public void Enqueue(int status, string body) => _responses.Enqueue((status, body));

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

                    lock (_requests)
                    {
                        _requests.Add(ParseForm(body));
                    }

                    var (status, responseBody) = _responses.Count > 0 ? _responses.Dequeue() : (200, "{}");

                    context.Response.StatusCode = status;
                    context.Response.ContentType = "application/json";
                    var bytes = System.Text.Encoding.UTF8.GetBytes(responseBody);
                    context.Response.ContentLength64 = bytes.Length;
                    await context.Response.OutputStream.WriteAsync(bytes).ConfigureAwait(false);
                    context.Response.OutputStream.Close();
                }
            }

            private static Dictionary<string, string> ParseForm(string body)
            {
                var result = new Dictionary<string, string>(StringComparer.Ordinal);

                foreach (var pair in body.Split('&', StringSplitOptions.RemoveEmptyEntries))
                {
                    var parts = pair.Split('=', 2);
                    var key = Uri.UnescapeDataString(parts[0].Replace('+', ' '));
                    var value = parts.Length > 1 ? Uri.UnescapeDataString(parts[1].Replace('+', ' ')) : string.Empty;
                    result[key] = value;
                }

                return result;
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
