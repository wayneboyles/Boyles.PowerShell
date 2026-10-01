using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    /// <summary>
    /// Partial class containing the Hudu API Info operation.
    /// </summary>
    public partial class HuduClient
    {
        /// <summary>
        /// Retrieves the Hudu instance's API version information synchronously. Useful as a cheap
        /// connectivity and credential check.
        /// </summary>
        /// <returns>The <see cref="HuduApiInfo"/> for the connected instance.</returns>
        public HuduApiInfo GetApiInfo() => Sync(GetApiInfoAsync());

        /// <summary>
        /// Retrieves the Hudu instance's API version information asynchronously.
        /// </summary>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to the <see cref="HuduApiInfo"/> for the connected instance.</returns>
        public async Task<HuduApiInfo> GetApiInfoAsync(CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/api_info", ApiRoot);
            return await GetAsync<HuduApiInfo>(path, ct: cancellationToken);
        }
    }
}
