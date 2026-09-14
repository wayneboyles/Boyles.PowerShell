using Boyles.PowerShell.Authentication;
using Boyles.PowerShell.Hudu.Services;

namespace Boyles.PowerShell.TestClient.Services
{
    /// <summary>
    /// Holds the single <see cref="HuduClient"/> this browser tab is testing against. Mirrors
    /// what Connect-Hudu.ps1 does for a PowerShell session, but keeps the client in scoped DI
    /// state instead of BoylesContextCache since there is no PowerShell host here.
    /// </summary>
    public sealed class HuduConnectionService : IDisposable
    {
        private readonly DiagnosticsStore _diagnostics;

        public HuduConnectionService(DiagnosticsStore diagnostics)
        {
            _diagnostics = diagnostics;
        }

        public HuduClient? Client { get; private set; }

        public string? BaseUrl { get; private set; }

        public bool IsConnected => Client is not null;

        /// <summary>
        /// Raised after Connect/Disconnect, so the navbar badge and connect page can re-render.
        /// </summary>
        public event Action? Changed;

        public void Connect(string baseUrl, string apiKey)
        {
            Client?.Dispose();

            // Built directly (rather than via HuduClient.Create) so the DiagnosticsStore can be
            // supplied as the sink - Create() has no diagnosticsSink parameter.
            Client = new HuduClient(baseUrl, ApiKeyAuthenticationProvider.Header("x-api-key", apiKey), null, _diagnostics);
            BaseUrl = baseUrl;

            Changed?.Invoke();
        }

        public void Disconnect()
        {
            Client?.Dispose();
            Client = null;
            BaseUrl = null;

            Changed?.Invoke();
        }

        public void Dispose() => Client?.Dispose();
    }
}
