using System.Net.Http.Headers;

using Boyles.PowerShell.Exceptions;
using Boyles.PowerShell.Http;

using Newtonsoft.Json;

namespace Boyles.PowerShell.Authentication
{
    /// <summary>
    /// Authenticates requests with a bearer token obtained via the OAuth 2.0 client credentials
    /// grant. The token is cached in memory and re-acquired shortly before it expires (see
    /// <see cref="SkewSeconds"/>), on a forced refresh after a 401, or after
    /// <see cref="InvalidateAsync"/>. Token acquisition is serialized so concurrent requests
    /// share a single token fetch rather than each hitting the token endpoint.
    /// </summary>
    public sealed class OAuth2ClientCredentialsProvider : IAuthenticationProvider
    {
        private readonly string _tokenUrl, _clientId, _clientSecret;
        private readonly string? _scope;
        private readonly HttpClient _http;

        /// <summary>
        /// Ensures only one caller fetches a new token at a time.
        /// </summary>
        private readonly SemaphoreSlim _gate = new SemaphoreSlim(1, 1);

        /// <summary>
        /// How many seconds before the token's actual expiry it is treated as stale, so a request
        /// never goes out with a token that expires in flight. Defaults to 60.
        /// </summary>
        public int SkewSeconds { get; set; } = 60;

        private string? _token;
        private DateTimeOffset _expiresAt = DateTimeOffset.MinValue;

        /// <summary>
        /// Initializes a new provider for the given token endpoint and client credentials. No
        /// token is requested until the first call to <see cref="ApplyAsync"/> or
        /// <see cref="GetAccessTokenAsync"/>.
        /// </summary>
        /// <param name="tokenUrl">The OAuth 2.0 token endpoint URL.</param>
        /// <param name="clientId">The client ID.</param>
        /// <param name="clientSecret">The client secret.</param>
        /// <param name="scope">Optional space-separated scope(s) to request; omitted from the request when null or empty.</param>
        public OAuth2ClientCredentialsProvider(string tokenUrl, string clientId, string clientSecret, string? scope = null)
        {
            _tokenUrl = tokenUrl;
            _clientId = clientId;
            _clientSecret = clientSecret;
            _scope = scope;
            _http = new HttpClient(HttpTransport.Shared, disposeHandler: false);
        }

        /// <summary>
        /// Sets <c>Authorization: Bearer {token}</c> on the request, acquiring a new token first
        /// if the cached one is missing, stale, or <paramref name="forceRefresh"/> is true.
        /// </summary>
        /// <param name="request">The outgoing request.</param>
        /// <param name="forceRefresh">True to bypass the cached token, e.g. after a 401.</param>
        /// <param name="ct">Cancels token acquisition.</param>
        /// <returns>A task that completes once the header has been set.</returns>
        /// <exception cref="ApiException">The token endpoint returned an error or no access token.</exception>
        public async Task ApplyAsync(HttpRequestMessage request, bool forceRefresh, CancellationToken ct)
        {
            var token = await GetAccessTokenAsync(forceRefresh, ct).ConfigureAwait(false);
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
        }

        /// <summary>
        /// Discards the cached token so the next request acquires a fresh one.
        /// </summary>
        /// <param name="ct">Unused.</param>
        /// <returns>A completed task.</returns>
        public Task InvalidateAsync(CancellationToken ct)
        {
            _token = null;
            _expiresAt = DateTimeOffset.MinValue;
            return Task.CompletedTask;
        }

        /// <summary>
        /// Returns the current access token, requesting a new one from the token endpoint when the
        /// cached token is missing, within <see cref="SkewSeconds"/> of expiry, or
        /// <paramref name="forceRefresh"/> is true. If the endpoint omits <c>expires_in</c>, the
        /// token is assumed to last one hour.
        /// </summary>
        /// <remarks>
        /// Exposed so an MSP client can use the live token as an exchange <c>subject_token</c>.
        /// </remarks>
        /// <param name="forceRefresh">True to always request a new token.</param>
        /// <param name="ct">Cancels the token request.</param>
        /// <returns>The access token.</returns>
        /// <exception cref="ApiException">The token endpoint returned an error or no access token.</exception>
        public async Task<string> GetAccessTokenAsync(bool forceRefresh, CancellationToken ct)
        {
            if (!forceRefresh && IsFresh())
            {
                return _token!;
            }

            await _gate.WaitAsync(ct).ConfigureAwait(false);
            try
            {
                if (!forceRefresh && IsFresh())
                {
                    return _token!;   // double-check under lock
                }

                var form = new Dictionary<string, string>
                {
                    ["grant_type"] = "client_credentials",
                    ["client_id"] = _clientId,
                    ["client_secret"] = _clientSecret
                };

                if (!string.IsNullOrEmpty(_scope))
                {
                    form["scope"] = _scope!;
                }

                using var req = new HttpRequestMessage(HttpMethod.Post, _tokenUrl)
                {
                    Content = new FormUrlEncodedContent(form)   // handles escaping for you
                };

                req.Headers.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

                using var resp = await _http.SendAsync(req, ct).ConfigureAwait(false);
                var body = await resp.Content.ReadAsStringAsync().ConfigureAwait(false);
                if (!resp.IsSuccessStatusCode)
                {
                    throw new ApiException(resp.StatusCode, body, $"Token request failed: HTTP {(int)resp.StatusCode}");
                }

                var tok = JsonConvert.DeserializeObject<OAuthTokenResponse>(body);
                if (tok is null || string.IsNullOrEmpty(tok.AccessToken))
                {
                    throw new ApiException(resp.StatusCode, body, "Token endpoint returned no access_token.");
                }

                _token = tok.AccessToken;
                _expiresAt = DateTimeOffset.UtcNow.AddSeconds(tok.ExpiresIn > 0 ? tok.ExpiresIn : 3600);
                return _token!;
            }
            finally { _gate.Release(); }
        }

        /// <summary>
        /// True when a token is cached and is not yet within <see cref="SkewSeconds"/> of expiry.
        /// </summary>
        /// <returns>Whether the cached token can be reused.</returns>
        private bool IsFresh() =>
            _token != null && DateTimeOffset.UtcNow < _expiresAt.AddSeconds(-SkewSeconds);
    }

    /// <summary>
    /// The JSON body returned by an OAuth 2.0 token endpoint.
    /// </summary>
    internal sealed class OAuthTokenResponse
    {
        /// <summary>
        /// The access token to send as a bearer token.
        /// </summary>
        [JsonProperty("access_token")]
        public string? AccessToken { get; set; }

        /// <summary>
        /// Token lifetime in seconds; 0 when the endpoint omits it.
        /// </summary>
        [JsonProperty("expires_in")]
        public int ExpiresIn { get; set; }

        /// <summary>
        /// The token type, typically "Bearer".
        /// </summary>
        [JsonProperty("token_type")]
        public string? TokenType { get; set; }
    }
}
