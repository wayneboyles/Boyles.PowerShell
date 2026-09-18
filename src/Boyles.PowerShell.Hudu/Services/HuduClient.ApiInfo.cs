using System.Globalization;

using Boyles.PowerShell.Hudu.Models;

namespace Boyles.PowerShell.Hudu.Services
{
    public partial class HuduClient
    {
        public HuduApiInfo GetApiInfo() => Sync(GetApiInfoAsync());

        public async Task<HuduApiInfo> GetApiInfoAsync(CancellationToken cancellationToken = default)
        {
            string path = string.Format(CultureInfo.InvariantCulture, "{0}/api_info", ApiRoot);
            return await GetAsync<HuduApiInfo>(path, ct: cancellationToken);
        }
    }
}
