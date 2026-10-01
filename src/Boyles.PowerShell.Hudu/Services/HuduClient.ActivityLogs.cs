using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    /// <summary>
    /// Partial class containing Hudu Activity Log-related API operations. Activity logs are read-only.
    /// </summary>
    public partial class HuduClient
    {
        /// <summary>
        /// Retrieves all Activity Logs from the Hudu API synchronously, following pagination.
        /// </summary>
        /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
        /// <returns>A list of all matching <see cref="HuduActivityLog"/> records.</returns>
        public List<HuduActivityLog> GetActivityLogs(Dictionary<string, string>? query = null)
            => Sync(GetActivityLogsAsync(query));

        /// <summary>
        /// Retrieves all Activity Logs from the Hudu API asynchronously, following pagination.
        /// Unlike most Hudu endpoints, this one pages with <c>page</c>/<c>page_size</c> and returns
        /// a bare JSON array rather than an envelope object.
        /// </summary>
        /// <param name="query">Optional query-string filters (keyed by Hudu's JSON parameter names).</param>
        /// <param name="cancellationToken">Token to cancel the request.</param>
        /// <returns>A task resolving to a list of all matching <see cref="HuduActivityLog"/> records.</returns>
        public async Task<List<HuduActivityLog>> GetActivityLogsAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            var path = string.Format(CultureInfo.InvariantCulture, "{0}/activity_logs", ApiRoot);
            return await GetAllHuduPagesAsync<HuduActivityLog>(path, query, "activity_logs", cancellationToken);
        }
    }
}
