namespace Boyles.PowerShell.Authentication
{
    /// <summary>
    /// Supplies credentials for outgoing requests made by <c>HttpClientBase</c>. Implementations
    /// range from a static header (<see cref="ApiKeyAuthenticationProvider"/>) to a cached,
    /// self-renewing token (<see cref="OAuth2ClientCredentialsProvider"/>).
    /// </summary>
    public interface IAuthenticationProvider
    {
        /// <summary>
        /// Apply auth to an outgoing request. forceRefresh is used after a 401.
        /// </summary>
        /// <param name="request">The outgoing request to add credentials to.</param>
        /// <param name="forceRefresh">True when retrying after a 401; re-acquire rather than reuse a cached credential.</param>
        /// <param name="ct">Cancels any credential acquisition.</param>
        /// <returns>A task that completes once the request has been authenticated.</returns>
        Task ApplyAsync(HttpRequestMessage request, bool forceRefresh, CancellationToken ct);

        /// <summary>
        /// Drop any cached credential so the next ApplyAsync re-acquires.
        /// </summary>
        /// <param name="ct">Cancels the operation.</param>
        /// <returns>A task that completes once any cached credential has been discarded.</returns>
        Task InvalidateAsync(CancellationToken ct);
    }
}
