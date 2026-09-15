using Microsoft.Extensions.Options;

using Boyles.PowerShell.Authentication;
using Boyles.PowerShell.Hudu.Services;
using Boyles.PowerShell.TestClient.Configuration;

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
        private readonly HuduOptions _configured;

        public HuduConnectionService(DiagnosticsStore diagnostics, IOptions<HuduOptions> options)
        {
            _diagnostics = diagnostics;
            _configured = options.Value;
        }

        public HuduClient? Client { get; private set; }

        public string? BaseUrl { get; private set; }

        public bool IsConnected => Client is not null;

        /// <summary>
        /// True when a connection was made via <see cref="TryConnectFromConfiguration"/> rather
        /// than a manual <see cref="Connect"/> call - drives the "Connected via User Secrets"
        /// wording on the Connect page.
        /// </summary>
        public bool ConnectedFromConfiguration { get; private set; }

        /// <summary>
        /// True when both a base URL and API key are present in configuration (User Secrets in
        /// Development, or any other configured provider), so auto-connect / the "use saved
        /// credentials" button have something to work with.
        /// </summary>
        public bool HasConfiguredCredentials =>
            !string.IsNullOrWhiteSpace(_configured.BaseUrl) && !string.IsNullOrWhiteSpace(_configured.ApiKey);

        /// <summary>
        /// The configured base URL, safe to show/pre-fill in the UI. The API key is never
        /// exposed this way - it's only ever read directly from configuration when connecting.
        /// </summary>
        public string? ConfiguredBaseUrl => _configured.BaseUrl;

        /// <summary>
        /// Raised after Connect/Disconnect, so the navbar badge and connect page can re-render.
        /// </summary>
        public event Action? Changed;

        /// <summary>
        /// Connects using the base URL/API key found in configuration (User Secrets), if any.
        /// Does nothing and returns false when no credentials are configured. Intended to be
        /// called once per circuit (see MainLayout) so a test session opens already connected,
        /// while still leaving <see cref="Connect"/> available for a manual, one-off override.
        /// </summary>
        public bool TryConnectFromConfiguration()
        {
            if (!HasConfiguredCredentials)
            {
                return false;
            }

            Connect(_configured.BaseUrl!, _configured.ApiKey!, fromConfiguration: true);
            return true;
        }

        public void Connect(string baseUrl, string apiKey) => Connect(baseUrl, apiKey, fromConfiguration: false);

        private void Connect(string baseUrl, string apiKey, bool fromConfiguration)
        {
            Client?.Dispose();

            // Built directly (rather than via HuduClient.Create) so the DiagnosticsStore can be
            // supplied as the sink - Create() has no diagnosticsSink parameter.
            Client = new HuduClient(baseUrl, ApiKeyAuthenticationProvider.Header("x-api-key", apiKey), null, _diagnostics);
            BaseUrl = baseUrl;
            ConnectedFromConfiguration = fromConfiguration;

            Changed?.Invoke();
        }

        public void Disconnect()
        {
            Client?.Dispose();
            Client = null;
            BaseUrl = null;
            ConnectedFromConfiguration = false;

            Changed?.Invoke();
        }

        public void Dispose() => Client?.Dispose();
    }
}
