using System.Net.Http.Headers;

using Boyles.PowerShell.Exceptions;
using Boyles.PowerShell.Http;

using Newtonsoft.Json;

namespace Boyles.PowerShell.Authentication
{
    public sealed class OAuth2ClientCredentialsProvider : IAuthenticationProvider
    {
        private readonly string _tokenUrl, _clientId, _clientSecret;
        private readonly string? _scope;
        private readonly HttpClient _http;
        private readonly SemaphoreSlim _gate = new SemaphoreSlim(1, 1);

        public int SkewSeconds { get; set; } = 60;

        private string? _token;
        private DateTimeOffset _expiresAt = DateTimeOffset.MinValue;

        public OAuth2ClientCredentialsProvider(string tokenUrl, string clientId, string clientSecret, string? scope = null)
        {
            _tokenUrl = tokenUrl;
            _clientId = clientId;
            _clientSecret = clientSecret;
            _scope = scope;
            _http = new HttpClient(HttpTransport.Shared, disposeHandler: false);
        }

        public async Task ApplyAsync(HttpRequestMessage request, bool forceRefresh, CancellationToken ct)
        {
            var token = await GetAccessTokenAsync(forceRefresh, ct).ConfigureAwait(false);
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", token);
        }

        public Task InvalidateAsync(CancellationToken ct)
        {
            _token = null;
            _expiresAt = DateTimeOffset.MinValue;
            return Task.CompletedTask;
        }

        // Exposed so an MSP client can use the live token as an exchange subject_token.
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

        private bool IsFresh() =>
            _token != null && DateTimeOffset.UtcNow < _expiresAt.AddSeconds(-SkewSeconds);
    }

    internal sealed class OAuthTokenResponse
    {
        [JsonProperty("access_token")]
        public string? AccessToken { get; set; }

        [JsonProperty("expires_in")]
        public int ExpiresIn { get; set; }

        [JsonProperty("token_type")]
        public string? TokenType { get; set; }
    }
}
