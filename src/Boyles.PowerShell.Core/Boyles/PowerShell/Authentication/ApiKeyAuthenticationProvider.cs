namespace Boyles.PowerShell.Authentication
{
    /// <summary>
    /// Authenticates requests with a static credential sent as a single HTTP header — either a bearer
    /// token or a service-specific API key header (e.g. Hudu's <c>x-api-key</c>).
    /// </summary>
    /// <remarks>
    /// The credential never expires from this provider's point of view, so there is nothing to refresh:
    /// a 401 retry re-sends the same value. Create instances via <see cref="Bearer"/> or
    /// <see cref="Header"/>.
    /// </remarks>
    public sealed class ApiKeyAuthenticationProvider : IAuthenticationProvider
    {
        private readonly string _name;
        private readonly string _value;

        private ApiKeyAuthenticationProvider(string name, string value)
        {
            _name = name; _value = value;
        }

        /// <summary>
        /// Create a provider that sends <c>Authorization: Bearer {token}</c>.
        /// </summary>
        /// <param name="token">The bearer token, without the <c>Bearer </c> prefix.</param>
        /// <returns>A provider that applies the bearer token to every request.</returns>
        public static ApiKeyAuthenticationProvider Bearer(string token)
            => new("Authorization", "Bearer " + token);

        /// <summary>
        /// Create a provider that sends an arbitrary header, e.g. <c>x-api-key: {value}</c>.
        /// </summary>
        /// <param name="name">The header name.</param>
        /// <param name="value">The header value, sent verbatim.</param>
        /// <returns>A provider that applies the header to every request.</returns>
        public static ApiKeyAuthenticationProvider Header(string name, string value)
            => new(name, value);

        /// <summary>
        /// Add the configured header to the request. <paramref name="forceRefresh"/> is ignored because
        /// a static key has nothing to refresh.
        /// </summary>
        /// <param name="request">The outgoing request.</param>
        /// <param name="forceRefresh">Ignored.</param>
        /// <param name="ct">Unused; the operation completes synchronously.</param>
        /// <returns>A completed task.</returns>
        public Task ApplyAsync(HttpRequestMessage request, bool forceRefresh, CancellationToken ct)
        {
            // TryAddWithoutValidation so non-standard header names/values aren't rejected by
            // HttpHeaders' format checks.
            request.Headers.TryAddWithoutValidation(_name, _value);
            return Task.CompletedTask;
        }

        /// <summary>
        /// No-op: there is no cached credential to drop.
        /// </summary>
        /// <param name="ct">Unused.</param>
        /// <returns>A completed task.</returns>
        public Task InvalidateAsync(CancellationToken ct) => Task.CompletedTask; // nothing to renew
    }
}
