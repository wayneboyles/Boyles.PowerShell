namespace Boyles.PowerShell.Authentication
{
    public interface IAuthenticationProvider
    {
        /// <summary>
        /// Apply auth to an outgoing request. forceRefresh is used after a 401.
        /// </summary>
        /// <param name="request"></param>
        /// <param name="forceRefresh"></param>
        /// <param name="ct"></param>
        /// <returns></returns>
        Task ApplyAsync(HttpRequestMessage request, bool forceRefresh, CancellationToken ct);

        /// <summary>
        /// Drop any cached credential so the next ApplyAsync re-acquires.
        /// </summary>
        /// <param name="ct"></param>
        /// <returns></returns>
        Task InvalidateAsync(CancellationToken ct);
    }
}
