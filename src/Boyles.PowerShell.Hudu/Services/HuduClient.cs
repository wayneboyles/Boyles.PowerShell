using Boyles.PowerShell.Authentication;
using Boyles.PowerShell.Context;
using Boyles.PowerShell.HttpClients;

namespace Boyles.PowerShell.Hudu
{
    /// <summary>
    /// Hudu API client. Built and registered by Connect-Hudu.ps1; cmdlets look it back up via
    /// FromContext() (or Get-BoylesClient from PowerShell) rather than constructing it themselves.
    /// </summary>
    public sealed class HuduClient : HttpClientBase
    {
        /// <param name="baseUrl">Root URL of the Hudu instance, e.g. https://myinstance.huducloud.com.</param>
        /// <param name="apiKey">Hudu API key, sent as the x-api-key header on every request.</param>
        public HuduClient(string baseUrl, string apiKey)
            : base(baseUrl, ApiKeyAuthenticationProvider.Header("x-api-key", apiKey))
        {
        }

        /// <summary>
        /// Retrieves the HuduClient registered under <paramref name="key"/> via BoylesContextCache.
        /// </summary>
        public static HuduClient FromContext(string key = ContextCache.DefaultKey)
            => ContextCache.Get<HuduClient>(key);
    }
}
