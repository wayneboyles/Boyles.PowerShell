using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    public partial class HuduClient
    {
        public List<HuduActivityLog> GetActivityLogs(Dictionary<string, string>? query = null)
            => Sync(GetActivityLogsAsync(query));

        public async Task<List<HuduActivityLog>> GetActivityLogsAsync(Dictionary<string, string>? query = null, CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/activity_logs", ApiRoot);
            return await GetAllPagesAsync<HuduActivityLog>(path, query, offsetParam: "page", limitParam: "page_size", ct: cancellationToken);
        }
    }
}
